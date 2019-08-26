
#include "QGCApplication.h"
#include "SettingsManager.h"

#include "CustomLogManager.h"
#include "CustomPlugin.h"

#include <QJsonDocument>
#include <QJsonObject>
#include <QSettings>
#include <QCryptographicHash> 

#include <curl/curl.h>
#include <fcntl.h>
#include <iostream>
#include <stdio.h>
#include <string>
#include <sys/stat.h>

static const char* kCustomMAVLinkLogGroup = "CustomMAVLinkLogGroup";
static const char* kNetworkIdKey          = "NetworkId";
static const char* kSerialNumberKey       = "SerialNumber";
static const char* kEnableAutoUploadKey   = "EnableAutoUpload";

//-----------------------------------------------------------------------------
CustomLogManager::CustomLogManager(QObject* parent) : QObject(parent) {
    qCDebug(CustomLog) << "CustomLogManager Created";
}

//-----------------------------------------------------------------------------
CustomLogManager::~CustomLogManager() {
    qCDebug(CustomLog) << "CustomLogManager Destroyed";
}

//-----------------------------------------------------------------------------
void CustomLogManager::init(QGCApplication* app) {
    //-- Get saved settings
    QSettings settings;
    settings.beginGroup(kCustomMAVLinkLogGroup);
    _networkId =
        settings.value(kNetworkIdKey, QString("flight_uploader")).toString();
    _serialNumber =
        settings.value(kSerialNumberKey, QString("Unknown")).toString();
    _enableAutoUpload = settings.value(kEnableAutoUploadKey, true).toBool();

    _logPath =
        app->toolbox()->settingsManager()->appSettings()->telemetrySavePath();
    qCDebug(CustomLog) << "LOG PATH : " << _logPath;
    syncLog();
}

//
//-----------------------------------------------------------------------------
void CustomLogManager::syncLog() {

    QDir          directory = QDir(_logPath);
    QFileInfoList files     = directory.entryInfoList();


    qCDebug(CustomLog) << "################### SYNC LOG ###################";

    qCDebug(CustomLog) << "Will attempt to sync for network :" << _networkId;

    QList<QString> serverFiles = getServerList(_networkId);

    foreach (QFileInfo cur_file, files) {
        if (cur_file.isFile()) {
            // Process md5
            QFile cur_qfile(cur_file.absoluteFilePath());
            QString md5 = md5sum(cur_qfile);

            if (!serverFiles.contains(md5)) {
                qCDebug(CustomLog)
                    << "This file need to be sync : " << cur_file.fileName();

                std::string remote_url = _networkId.toStdString() + "/" +
                                         _serialNumber.toStdString() +
                                         cur_file.lastModified()
                                             .toString("_yyyy-MM-dd-HH-mm-ss")
                                             .toStdString() +
                                         ".tlog";
                qCDebug(CustomLog) << "Will upload to : " << remote_url.c_str();
                uploadLogServer(cur_file.filePath(),
                                QString(remote_url.c_str()), _networkId);
            }
        }
    }
    qCDebug(CustomLog) << "End of Sync process";
    qCDebug(CustomLog) << "################### END SYNC ###################";
}

static size_t WriteCallback(void* contents, size_t size, size_t nmemb,
                            void* userp) {
    ((std::string*)userp)->append((char*)contents, size * nmemb);
    return size * nmemb;
}

QList<QString> CustomLogManager::getServerList(QString network_id) {

    std::string readBuffer;

    QList<QString> result;

    QString continuationToken = "";

    do {
        readBuffer = queryLogServer(network_id.toStdString(),
                                    continuationToken.toStdString());

        if (readBuffer != "") {
            QJsonDocument d =
                QJsonDocument::fromJson(QByteArray(readBuffer.c_str()));
            QJsonObject sett2 = d.object();

            // Check if continuation token is empty
            continuationToken = sett2["continuationToken"].toString();

            if (sett2["items"].isArray()) {
                QJsonArray           arr = sett2["items"].toArray();
                QJsonArray::iterator i;
                for (i = arr.begin(); i != arr.end(); ++i) {
                    QJsonValue  val      = QJsonValue(*i);
                    QJsonObject artifact = val.toObject();

                    // Print all files + md5sum present on server
                    //qDebug() << artifact["name"].toString()
                    //         << artifact["assets"]
                    //                .toArray()
                    //                .first()["checksum"]
                    //                .toObject()["md5"]
                    //                .toString();

                    // Append the current file md5sum to our result list
                    result.append(artifact["assets"]
                                      .toArray()
                                      .first()["checksum"]
                                      .toObject()["md5"]
                                      .toString());
                }
            }
        }
    } while (continuationToken != "");
    return result;
}

std::string
CustomLogManager::queryLogServer(std::string network_id,
                                 std::string continuationToken = "") {

    CURL*       curl;
    CURLcode    res;
    std::string readBuffer;

    std::string URL = "https://services.aeronavics.com/nexus/service/rest/v1/";
    std::string QUERY = "components?repository=flight_logs_raw";

    std::string user = network_id + ":" + network_id;

    std::string request_url;

    if (continuationToken == "") {
        request_url = URL + QUERY;
    } else {
        request_url = URL + QUERY + "&continuationToken=" + continuationToken;
    }

    QList<QString> result;

    curl = curl_easy_init();
    if (curl) {
        curl_easy_setopt(curl, CURLOPT_URL, request_url.c_str());
        curl_easy_setopt(curl, CURLOPT_USERPWD, user.c_str());
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteCallback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &readBuffer);
        res = curl_easy_perform(curl);
        curl_easy_cleanup(curl);
    }
    if (res == CURLE_OK) {
        return readBuffer;
    } else {
        qCDebug(CustomLog) << "unable to request log server :" << res;
        return "";
    }
}

int CustomLogManager::uploadLogServer(QString filePath, QString remoteFilePath,
                                      QString network_id) {
    CURL*       curl;
    CURLcode    res;
    struct stat file_info;
    FILE*       fd;

    std::string user =
        network_id.toStdString() + ":" + network_id.toStdString();

    std::string repoUrl =
        "https://services.aeronavics.com/nexus/repository/flight_logs_raw/";

    std::string absoluteRemoteFilePath = repoUrl + remoteFilePath.toStdString();

    fd = fopen(filePath.toStdString().c_str(), "rb"); /* open file to upload */
    if (!fd) {
        qCDebug(CustomLog) << "unable to access log file for upload";
        return 1; /* can't continue */
    }

    /* to get the file size */
    if (fstat(fileno(fd), &file_info) != 0) {
        qCDebug(CustomLog) << "unable to access log file for upload (size)";
        return 1; /* can't continue */
    }

    curl = curl_easy_init();
    if (curl) {
        /* upload to this place */
        curl_easy_setopt(curl, CURLOPT_URL, absoluteRemoteFilePath.c_str());

        /* tell it to "upload" to the URL */
        curl_easy_setopt(curl, CURLOPT_UPLOAD, 1L);

        /* set credentials*/
        curl_easy_setopt(curl, CURLOPT_USERPWD, user.c_str());

        /* set where to read from (on Windows you need to use READFUNCTION
         * too) */
        curl_easy_setopt(curl, CURLOPT_READDATA, fd);

        /* and give the size of the upload (optional) */
        curl_easy_setopt(curl, CURLOPT_INFILESIZE_LARGE,
                         (curl_off_t)file_info.st_size);

        res = curl_easy_perform(curl);
        /* Check for errors */
        if (res != CURLE_OK) {
            qCDebug(CustomLog)
                << "uploadLogServer : curl_easy_perform() failed: " << curl_easy_strerror(res);
        } 
        /* always cleanup */
        curl_easy_cleanup(curl);
    }
    fclose(fd);
    return 0;
}

QString CustomLogManager::md5sum(QFile& file) {
    if (file.open(QIODevice::ReadOnly)) {
        return QString(
            QCryptographicHash::hash(file.readAll(), QCryptographicHash::Md5)
                .toHex());
    } else {
        qCDebug(CustomLog) << "md5sum Unable to open file";
    }
    return "";
}

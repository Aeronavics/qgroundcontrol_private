
#include "QGCApplication.h"
#include "SettingsManager.h"

#include "CustomLogManager.h"
#include "CustomPlugin.h"

#include <QSettings>
#include <QJsonObject> 
#include <QJsonDocument> 

#include <curl/curl.h>
#include <iostream>
#include <string>

static const char* kCustomMAVLinkLogGroup = "CustomMAVLinkLogGroup";
static const char* kCustomerIdKey         = "CustomerId";
static const char* kSerialNumberKey       = "SerialNumber";
static const char* kNexusKey              = "flight_uploader";
static const char* kNexusURL = "https://services.aeronavics.com/nexus/service/"
                               "rest/v1/components?repository=FlightLogs";
static const char* kEnableAutoUploadKey = "EnableAutoUpload";

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
    _customerId =
        settings.value(kCustomerIdKey, QString("flight_uploader")).toString();
    _serialNumber =
        settings.value(kSerialNumberKey, QString("Unknown")).toString();
    _enableAutoUpload = settings.value(kEnableAutoUploadKey, true).toBool();

    _logPath =
        app->toolbox()->settingsManager()->appSettings()->telemetrySavePath();
    qDebug() << "LOG PATH : " << _logPath;
    syncLog();
}

//
//-----------------------------------------------------------------------------
void CustomLogManager::syncLog() {

    QDir          directory = QDir(_logPath);
    QFileInfoList files     = directory.entryInfoList();

    directory.mkpath("aa");

    qDebug() << "################### SYNC LOG ###################";

    foreach (QFileInfo cur_file, files) {
        if (cur_file.isFile()) {
            qDebug() << cur_file.fileName()
                     << cur_file.lastModified().toString();
        }
    }
    getServerList("customer_id");
    qDebug() << "################### END SYNC ###################";
}

static size_t WriteCallback(void* contents, size_t size, size_t nmemb,
                            void* userp) {
    ((std::string*)userp)->append((char*)contents, size * nmemb);
    return size * nmemb;
}

void CustomLogManager::getServerList(QString customer_id) {

    CURL*       curl;
    CURLcode    res;
    std::string readBuffer;

    std::string  URL = "https://services.aeronavics.com/nexus/service/rest/v1/";
    std::string  QUERY = "components?repository=flight_logs_raw";

    std::string user = "flight_uploader:flight_uploader";

    std::string request_url = URL+QUERY;

    curl = curl_easy_init();
    if (curl) {
        std::cout << URL+QUERY<< std::endl;
        curl_easy_setopt(curl, CURLOPT_URL, request_url.c_str()); 
        curl_easy_setopt(curl, CURLOPT_USERPWD, user.c_str());
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteCallback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &readBuffer);
        res = curl_easy_perform(curl);
        curl_easy_cleanup(curl);

        std::cout << res << std::endl;
        std::cout << readBuffer << std::endl;
    }
    if(res == CURLE_OK){
        QJsonDocument d = QJsonDocument::fromJson(QByteArray(readBuffer.c_str()));    
        QJsonObject sett2 = d.object();
        QJsonValue value = sett2.value(QString("items"));
        qDebug()<< value;
    }

}


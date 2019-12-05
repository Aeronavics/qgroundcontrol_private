
#include "QGCApplication.h"
#include "SettingsManager.h"

#include "CustomWebODMManager.h"
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

using namespace std;


static const char* kCustomWebODMGroup     = "CustomWebODMGroup";
static const char* kEmailKey         = "Email";
static const char* kPassword            = "Password";

//-----------------------------------------------------------------------------
CustomWebODMManager::CustomWebODMManager(QObject* parent) : QObject(parent) {
    qCDebug(CustomLog) << "CustomWebODMManager Created";
}

//-----------------------------------------------------------------------------
CustomWebODMManager::~CustomWebODMManager() {
    qCDebug(CustomLog) << "CustomWebODMManager Destroyed";
}

//-----------------------------------------------------------------------------
void CustomWebODMManager::init() {
    //-- Get saved settings
    QSettings settings;
    settings.beginGroup(kCustomWebODMGroup);
    _email =
        settings.value(kEmailKey, QString("james")).toString();
    _password =
        settings.value(kPassword, QString("")).toString();
}

static size_t WriteCallback(void* contents, size_t size, size_t nmemb,
                            void* userp) {
    ((std::string*)userp)->append((char*)contents, size * nmemb);
    return size * nmemb;
}



//-----------------------------------------------------------------------------
long CustomWebODMManager::queryLoginCredientials(std::string email, std::string password) {

    std::string body = "email=" + email +"&password=" + password; 
    cout << body << " ";
    CURL *hnd;

    std::string readBuffer;

    hnd = curl_easy_init();
    curl_easy_setopt(hnd, CURLOPT_BUFFERSIZE, 102400L);
    curl_easy_setopt(hnd, CURLOPT_URL, "http://localhost:5000/");
    curl_easy_setopt(hnd, CURLOPT_NOPROGRESS, 1L);
    curl_easy_setopt(hnd, CURLOPT_POSTFIELDS, body.c_str());
    curl_easy_setopt(hnd, CURLOPT_USERAGENT, "curl/7.58.0");
    curl_easy_setopt(hnd, CURLOPT_MAXREDIRS, 50L);
    curl_easy_setopt(hnd, CURLOPT_HTTP_VERSION, (long)CURL_HTTP_VERSION_2TLS);
    curl_easy_setopt(hnd, CURLOPT_CUSTOMREQUEST, "POST");
    curl_easy_setopt(hnd, CURLOPT_TCP_KEEPALIVE, 1L);
    curl_easy_setopt(hnd, CURLOPT_WRITEFUNCTION, WriteCallback);
    curl_easy_setopt(hnd, CURLOPT_WRITEDATA, &readBuffer);

    curl_easy_perform(hnd);
    long http_code = 0;
    curl_easy_getinfo(hnd, CURLINFO_RESPONSE_CODE, &http_code);

    cout << http_code << " ";
    curl_easy_cleanup(hnd);
    hnd = NULL;

    return http_code;
} 

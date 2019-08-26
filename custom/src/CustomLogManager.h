#pragma once

#include "Vehicle.h"

#include <QNetworkAccessManager> 
#include <QFileInfo> 



//-----------------------------------------------------------------------------
// QtQuick Interface (UI)
class CustomLogManager : public QObject {
    Q_OBJECT
  public:
    CustomLogManager(QObject* parent = nullptr);
    ~CustomLogManager();

    void init(QGCApplication* app);
    void syncLog();

    // Getters

    QString networkId() { return _networkId; }
    QString serialNumber() { return _serialNumber; }
    bool    enableAutoUpload() { return _enableAutoUpload; }

    void replyFinished(QNetworkReply* reply);
    QList<QString> getServerList(QString network_id);

  private:
    std::string queryLogServer(std::string network_id, std::string continuationToken);
    int uploadLogServer(QString filePath, QString remoteFilePath, QString network_id);
    QString md5sum(QFile &file);

    QString _networkId;
    QString _serialNumber;
    QString _logPath;
    bool    _enableAutoUpload;
};

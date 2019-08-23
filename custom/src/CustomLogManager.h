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

    QString customerId() { return _customerId; }
    QString serialNumber() { return _serialNumber; }
    bool    enableAutoUpload() { return _enableAutoUpload; }

    void replyFinished(QNetworkReply* reply);
    void getServerList(QString customer_id);

  private:

    QString _customerId;
    QString _serialNumber;
    QString _logPath;
    bool    _enableAutoUpload;
};

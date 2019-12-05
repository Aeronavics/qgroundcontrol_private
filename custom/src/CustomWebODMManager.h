#pragma once

#include "Vehicle.h"

#include <QNetworkAccessManager> 
#include <QFileInfo>

//-----------------------------------------------------------------------------
// QtQuick Interface (UI)
class CustomWebODMManager : public QObject {
    Q_OBJECT
  public:
    CustomWebODMManager(QObject* parent = nullptr);
    ~CustomWebODMManager();

    void init();

    // Getters

    QString email() { return _email; }
    QString password() { return _password; }

    static long queryLoginCredientials(std::string email, std::string password);


  private:
    QString _email;
    QString _password;
};

#pragma once

#include "Vehicle.h"
#include "CustomMappingSettings.h"
#include <QNetworkAccessManager> 
#include <QFileInfo>

//-----------------------------------------------------------------------------
// QtQuick Interface (UI)
class CustomWebODMManager : public QObject {
    Q_OBJECT
  public:
    void init(CustomMappingSettings* mappingSettings);

    // Getters

    QString email() { return _email; }
    QString password() { return _password; }
    long taskId() { return _taskId; }
    long imagesUploaded() { return _imagesUploaded; }
    std::string webodmTaskId() { return _webodmTaskId; }

    long queryLoginCredientials(std::string email, std::string password);

    long createTask(std::string password);

    long postImages(long taskId, std::string image);
   
    std::string startTask(long taskId);


  private:
    QString _email;
    QString _password;
    long _taskId;
    long _imagesUploaded;
    std::string _webodmTaskId;
    CustomMappingSettings* _mappingSettings;

    std::string getOptions();
};

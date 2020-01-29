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

    QString username() { return _username; }
    std::string password() { return _password; }
    long taskId() { return _taskId; }
    long imagesUploaded() { return _imagesUploaded; }
    std::string webodmTaskId() { return _webodmTaskId; }

    long queryLoginCredientials(std::string username, std::string password);

    void createTask(std::string password);

    long postImages(std::string image);
   
    void startTask();

    void uploadImages();
    void webodm(std::string password);

  public slots:
    void _vehicleArmedChanged(bool armed);
    void _imageUploadComplete(QString uploadMsg);
    void _imageUploaded(QString message);

  signals:
    void uploadComplete(QString uploadMsg);
    void imageUploaded(QString message);

  private:
    QString _username;
    std::string _password;
    std::string _userPassword;
    qlonglong _taskId;
    long _imagesUploaded;
    std::string _webodmTaskId;
    CustomMappingSettings* _mappingSettings;
    QString _failedImageName;
    int _numImagesUploaded;
    int _totalImages;
    int _numImagesFailed;
    bool _uploadFailed;
    bool _connectionLost;
    bool _cameraLost;
    QString _mountpath;


    void _unmount();
    void _deleteImages();
    void _uploadImage(QString filepath, QString filename);
    std::string getOptions();
};

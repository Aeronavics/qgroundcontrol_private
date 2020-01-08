/****************************************************************************
 *
 * (c) 2009-2019 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 * @file
 *   @brief Custom QtQuick Interface
 *   @author Gus Grubba <gus@auterion.com>
 */

#pragma once

#include "Vehicle.h"
#include "CustomMappingSettings.h"
#include "CustomWebODMManager.h"

#include <QColor>
#include <QGeoPositionInfo>
#include <QGeoPositionInfoSource>
#include <QObject>
#include <QTimer>

//-----------------------------------------------------------------------------
// QtQuick Interface (UI)
class CustomQuickInterface : public QObject {
    Q_OBJECT
  public:
    CustomQuickInterface(QObject* parent = nullptr);
    ~CustomQuickInterface();
     //Q_PROPERTY(bool showGimbalControl READ showGimbalControl WRITE
     //              setShowGimbalControl NOTIFY showGimbalControlChanged)

    Q_PROPERTY(QString networkId READ networkId WRITE setNetworkId NOTIFY
                                                                      networkIdChanged)
    Q_PROPERTY(QString serialNumber READ serialNumber WRITE setSerialNumber
                   NOTIFY serialNumberChanged)
    Q_PROPERTY(bool enableAutoUpload READ enableAutoUpload WRITE
                   setEnableAutoUpload NOTIFY enableAutoUploadChanged)
    Q_PROPERTY(QString password READ password WRITE setPassword NOTIFY passwordChanged)
    Q_PROPERTY(bool correctCredentials READ correctCredentials WRITE setCorrectCredentials NOTIFY correctCredentialsChanged)
    Q_PROPERTY(bool advancedSettings READ advancedSettings WRITE setAdvancedSettings NOTIFY advancedSettingsChanged)
    Q_PROPERTY(QObject* customMappingSettings         READ customMappingSettings        CONSTANT)

    // bool showGimbalControl() { return _showGimbalControl; }
    // void setShowGimbalControl(bool set);
    void init(QGCApplication* app);

    // Getters

    QString          networkId() { return _networkId; }
    QString          serialNumber() { return _serialNumber; }
    QString          password() { return _password; }
    bool             enableAutoUpload() { return _enableAutoUpload; }
    Q_INVOKABLE bool test_connection(QString networkId);
    Q_INVOKABLE void login(QString password);
    bool             correctCredentials() { return _correctCredentials; }
    bool             advancedSettings()   { return _advancedSettings; }
    CustomMappingSettings* customMappingSettings(void) { return _mapping; }


    // Setters

    void setNetworkId(QString networkId);
    void setSerialNumber(QString serialNumber);
    void setPassword(QString password);
    void setEnableAutoUpload(bool enable);
    void setCorrectCredentials(bool correctCredentials);
    Q_INVOKABLE void setAdvancedSettings(bool advancedSettings);
    Q_INVOKABLE void upload(QString password);
    Q_INVOKABLE void setCustom();
    Q_INVOKABLE void presetChanged();
    
  signals:
    // void showGimbalControlChanged();

    void networkIdChanged();
    void serialNumberChanged();
    void enableAutoUploadChanged();
    void passwordChanged();
    void correctCredentialsChanged();
    void advancedSettingsChanged();

  private:
    // bool _showGimbalControl = true;
    QString _networkId;
    QString _serialNumber;
    QString _logPath;
    bool    _enableAutoUpload;
    QString _password;
    bool    _correctCredentials;
    bool    _advancedSettings;
    CustomMappingSettings* _mapping;
    CustomWebODMManager* _webodmManager;

    void dsmdtm();
    void returnToDefault();
    void forest();
    void fastOrtho();
    void model();
    void highRes();
    void buildings();
    void pointOfInterest();
    void volumeAnalysis();

};

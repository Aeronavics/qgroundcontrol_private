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

#include "AppSettings.h"
#include "MAVLinkLogManager.h"
#include "PositionManager.h"
#include "QGCApplication.h"
#include "QGCMapEngine.h"
#include "SettingsManager.h"

#include "CustomPlugin.h"
#include "CustomQuickInterface.h"

#include <QSettings>

// static const char* kGroupName       = "CustomSettings";
// static const char* kShowGimbalCtl   = "ShowGimbalCtl";
static const char* kCustomMAVLinkLogGroup = "CustomMAVLinkLogGroup";
static const char* kCustomerIdKey         = "CustomerId";
static const char* kSerialNumberKey       = "SerialNumber";
static const char* kNexusKey              = "flight_uploader";
static const char* kNexusURL = "https://services.aeronavics.com/nexus/service/"
                               "rest/v1/components?repository=FlightLogs";
static const char* kEnableAutoUploadKey = "EnableAutoUpload";

//-----------------------------------------------------------------------------
CustomQuickInterface::CustomQuickInterface(QObject* parent) : QObject(parent) {
    qCDebug(CustomLog) << "CustomQuickInterface Created";
}

//-----------------------------------------------------------------------------
CustomQuickInterface::~CustomQuickInterface() {
    qCDebug(CustomLog) << "CustomQuickInterface Destroyed";
}

//-----------------------------------------------------------------------------
void CustomQuickInterface::init() {
    // QSettings settings;
    // settings.beginGroup(kGroupName);
    //_showGimbalControl = settings.value(kShowGimbalCtl, true).toBool();
    //-- Get saved settings
    QSettings settings;
    settings.beginGroup(kCustomMAVLinkLogGroup);
    setCustomerId(
        settings.value(kCustomerIdKey, QString("flight_uploader")).toString());
    setSerialNumber(
        settings.value(kSerialNumberKey, QString("Unknown")).toString());
    setEnableAutoUpload(settings.value(kEnableAutoUploadKey, true).toBool());

    // QString logExtension +=
    // qgcApp()->toolbox()->settingsManager()->appSettings()->logFileExtension;
    // QString logPath =
    // qgcApp()->toolbox()->settingsManager()->appSettings()->logSavePath();
}

//-----------------------------------------------------------------------------
// void
// CustomQuickInterface::setShowGimbalControl(bool set)
//{
//    if(_showGimbalControl != set) {
//        _showGimbalControl = set;
//        QSettings settings;
//        settings.beginGroup(kGroupName);
//        settings.setValue(kShowGimbalCtl,set);
//        emit showGimbalControlChanged();
//    }
//}

void CustomQuickInterface::setCustomerId(QString customerId) {
    qDebug() << "setCustomerId" << customerId;
    _customerId = customerId;
    QSettings settings;
    settings.beginGroup(kCustomMAVLinkLogGroup);
    settings.setValue(kCustomerIdKey, customerId);
    emit customerIdChanged();
}

//-----------------------------------------------------------------------------
void CustomQuickInterface::setSerialNumber(QString serialNumber) {
    qDebug() << "setSerialNumber" << serialNumber;
    _serialNumber = serialNumber;
    QSettings settings;
    settings.beginGroup(kCustomMAVLinkLogGroup);
    settings.setValue(kSerialNumberKey, serialNumber);
    emit serialNumberChanged();
}

//-----------------------------------------------------------------------------
void CustomQuickInterface::setEnableAutoUpload(bool enable) {
    _enableAutoUpload = enable;
    QSettings settings;
    settings.beginGroup(kCustomMAVLinkLogGroup);
    settings.setValue(kEnableAutoUploadKey, enable);
    emit enableAutoUploadChanged();
}

//-----------------------------------------------------------------------------
void CustomQuickInterface::uploadLog() {}

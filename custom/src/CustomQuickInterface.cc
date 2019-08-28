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

static const char* kCustomMAVLinkLogGroup = "CustomMAVLinkLogGroup";
static const char* kNetworkIdKey         = "NetworkId";
static const char* kSerialNumberKey       = "SerialNumber";
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
void CustomQuickInterface::init(QGCApplication* app) {
    (void) app;
    //-- Get saved settings
    QSettings settings;
    settings.beginGroup(kCustomMAVLinkLogGroup);
    setNetworkId(
        settings.value(kNetworkIdKey, QString("flight_uploader")).toString());
    setSerialNumber(
        settings.value(kSerialNumberKey, QString("Unknown")).toString());
    setEnableAutoUpload(settings.value(kEnableAutoUploadKey, true).toBool());

    //_logPath =
    //    app->toolbox()->settingsManager()->appSettings()->telemetrySavePath();
    //qDebug()<< "LOG PATH : "<<_logPath ;
    //syncLog();
}

void CustomQuickInterface::setNetworkId(QString networkId) {
    qDebug() << "setNetworkId" << networkId;
    _networkId = networkId;
    QSettings settings;
    settings.beginGroup(kCustomMAVLinkLogGroup);
    settings.setValue(kNetworkIdKey, networkId);
    emit networkIdChanged();
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


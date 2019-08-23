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

    Q_PROPERTY(QString customerId READ customerId WRITE setCustomerId NOTIFY
                                                                      customerIdChanged)
    Q_PROPERTY(QString serialNumber READ serialNumber WRITE setSerialNumber
                   NOTIFY serialNumberChanged)
    Q_PROPERTY(bool enableAutoUpload READ enableAutoUpload WRITE
                   setEnableAutoUpload NOTIFY enableAutoUploadChanged)

    // bool showGimbalControl() { return _showGimbalControl; }
    // void setShowGimbalControl(bool set);
    void init(QGCApplication* app);

    // Getters

    QString customerId() { return _customerId; }
    QString serialNumber() { return _serialNumber; }
    bool    enableAutoUpload() { return _enableAutoUpload; }

    // Setters

    void setCustomerId(QString customerId);
    void setSerialNumber(QString serialNumber);
    void setEnableAutoUpload(bool enable);
  signals:
    // void showGimbalControlChanged();

    void customerIdChanged();
    void serialNumberChanged();
    void enableAutoUploadChanged();

  private:
    // bool _showGimbalControl = true;
    QString _customerId;
    QString _serialNumber;
    QString _logPath;
    bool    _enableAutoUpload;
};

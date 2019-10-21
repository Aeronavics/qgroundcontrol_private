/****************************************************************************
 *
 * (c) 2009-2019 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 */

#include "CustomFirmwarePlugin.h"
#include "CustomAutoPilotPlugin.h"
#include "CustomCameraManager.h"
#include "CustomCameraControl.h"

//-----------------------------------------------------------------------------
CustomFirmwarePlugin::CustomFirmwarePlugin(): ArduCopterFirmwarePlugin()
{
}

//-----------------------------------------------------------------------------
AutoPilotPlugin* CustomFirmwarePlugin::autopilotPlugin(Vehicle* vehicle)
{
    return new CustomAutoPilotPlugin(vehicle, vehicle);
}

void CustomFirmwarePlugin::checkIfIsLatestStable(Vehicle* vehicle)
{
    // HardCoded Aeronavics Release
    QString aeronavic_version = QString("3.6.6");
    QString& version = aeronavic_version;
    //qCDebug(FirmwarePluginLog) << "Latest stable version = "  << version;

    int currType = vehicle->firmwareVersionType();

    // Check if lower version than stable or same version but different type
    if (currType == FIRMWARE_VERSION_TYPE_OFFICIAL && vehicle->versionCompare(version) < 0) {
        QString currentVersionNumber = QString("%1.%2.%3").arg(vehicle->firmwareMajorVersion())
                .arg(vehicle->firmwareMinorVersion())
                .arg(vehicle->firmwarePatchVersion());
        qgcApp()->showMessage(tr("Vehicle is not running latest stable firmware! Running %1, latest stable is %2.").arg(currentVersionNumber, version));
    }
}

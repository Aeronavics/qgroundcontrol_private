/****************************************************************************
 *
 * (c) 2009-2019 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 */

#pragma once

#include "FirmwarePlugin.h"

class CustomFirmwarePlugin;

class CustomFirmwarePluginFactory : public FirmwarePluginFactory
{
    Q_OBJECT
public:
    CustomFirmwarePluginFactory();
    QList<MAV_AUTOPILOT>    supportedFirmwareTypes      () const override;
    FirmwarePlugin*         firmwarePluginForAutopilot  (MAV_AUTOPILOT autopilotType, MAV_TYPE vehicleType) override;
private:
    CustomFirmwarePlugin*   _pluginInstance;
};

extern CustomFirmwarePluginFactory CustomFirmwarePluginFactoryImp;

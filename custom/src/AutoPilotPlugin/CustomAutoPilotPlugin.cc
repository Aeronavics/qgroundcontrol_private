/****************************************************************************
 *
 * (c) 2009-2019 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 * @file
 *   @brief Custom Autopilot Plugin
 *   @author Gus Grubba <gus@auterion.com>
 */

#include "CustomAutoPilotPlugin.h"

#include "UAS.h"
#include "FirmwarePlugin/APM/APMParameterMetaData.h"  // FIXME: Hack
#include "FirmwarePlugin/APM/APMFirmwarePlugin.h"  // FIXME: Hack
#include "FirmwarePlugin/APM/ArduCopterFirmwarePlugin.h"
#include "VehicleComponent.h"
#include "APMAirframeComponent.h"
#include "APMFlightModesComponent.h"
#include "APMRadioComponent.h"
#include "APMSafetyComponent.h"
#include "APMTuningComponent.h"
#include "APMSensorsComponent.h"
#include "APMPowerComponent.h"
#include "APMMotorComponent.h"
#include "APMCameraComponent.h"
#include "APMLightsComponent.h"
#include "APMSubFrameComponent.h"
#include "ESP8266Component.h"
#include "APMHeliComponent.h"
#include "QGCApplication.h"
#include "ParameterManager.h"
#include "QGCApplication.h"
#include "QGCCorePlugin.h"

//-----------------------------------------------------------------------------
CustomAutoPilotPlugin::CustomAutoPilotPlugin(Vehicle* vehicle, QObject* parent)
    : APMAutoPilotPlugin(vehicle, parent)
{
    connect(qgcApp()->toolbox()->corePlugin(), &QGCCorePlugin::showAdvancedUIChanged, this, &CustomAutoPilotPlugin::_advancedChanged);
}

//-----------------------------------------------------------------------------
void
CustomAutoPilotPlugin::_advancedChanged(bool)
{
    _components.clear();
    emit vehicleComponentsChanged();
}

const QVariantList& CustomAutoPilotPlugin::vehicleComponents(void)
{
    if (_components.count() == 0 && !_incorrectParameterVersion) {
        if (_vehicle->parameterManager()->parametersReady()) {
            if(qgcApp()->toolbox()->corePlugin()->showAdvancedUI()){
                _airframeComponent = new APMAirframeComponent(_vehicle, this);
                _airframeComponent->setupTriggerSignals();
                _components.append(QVariant::fromValue((VehicleComponent*)_airframeComponent));
            }

            if ( _vehicle->supportsRadio() ) {
                _radioComponent = new APMRadioComponent(_vehicle, this);
                _radioComponent->setupTriggerSignals();
                _components.append(QVariant::fromValue((VehicleComponent*)_radioComponent));
            }
            
            // No flight modes component for Sub versions 3.5 and up
            if (!_vehicle->sub() || (_vehicle->versionCompare(3, 5, 0) < 0)) {
                _flightModesComponent = new APMFlightModesComponent(_vehicle, this);
                _flightModesComponent->setupTriggerSignals();
                _components.append(QVariant::fromValue((VehicleComponent*)_flightModesComponent));
            }

            _sensorsComponent = new APMSensorsComponent(_vehicle, this);
            _sensorsComponent->setupTriggerSignals();
            _components.append(QVariant::fromValue((VehicleComponent*)_sensorsComponent));

            if(qgcApp()->toolbox()->corePlugin()->showAdvancedUI()){
                _powerComponent = new APMPowerComponent(_vehicle, this);
                _powerComponent->setupTriggerSignals();
                _components.append(QVariant::fromValue((VehicleComponent*)_powerComponent));
            }

            _safetyComponent = new APMSafetyComponent(_vehicle, this);
            _safetyComponent->setupTriggerSignals();
            _components.append(QVariant::fromValue((VehicleComponent*)_safetyComponent));


            if(qgcApp()->toolbox()->corePlugin()->showAdvancedUI()){
                _tuningComponent = new APMTuningComponent(_vehicle, this);
                _tuningComponent->setupTriggerSignals();
                _components.append(QVariant::fromValue((VehicleComponent*)_tuningComponent));
            }

            _cameraComponent = new APMCameraComponent(_vehicle, this);
            _cameraComponent->setupTriggerSignals();
            _components.append(QVariant::fromValue((VehicleComponent*)_cameraComponent));


        } else {
            qWarning() << "Call to vehicleCompenents prior to parametersReady";
        }
    }

    return _components;
}

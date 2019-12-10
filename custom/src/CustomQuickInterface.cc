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

#include "CustomMappingSettings.h"
#include "CustomPlugin.h"
#include "CustomQuickInterface.h"
#include "CustomLogManager.h"
#include "CustomWebODMManager.h"

#include <iostream>
using namespace std;

#include <QSettings>

static const char* kCustomMAVLinkLogGroup = "CustomMAVLinkLogGroup";
static const char* kCustomWebODMGroup     = "CustomWebODMGroup";
static const char* kNetworkIdKey          = "NetworkId";
static const char* kSerialNumberKey       = "SerialNumber";
static const char* kEnableAutoUploadKey   = "EnableAutoUpload";
static const char* kPasswordKey           = "Password";
static const char* kCorrectCredentialsKey = "CorrectCredentials";
static const char* kAdvancedSettingsKey   = "AdvancedSettings";


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
    settings.beginGroup(kCustomWebODMGroup);
    setPassword(
        settings.value(kPasswordKey, QString("")).toString());
    setCorrectCredentials(
        settings.value(kCorrectCredentialsKey, false).toBool());
    setAdvancedSettings(
        settings.value(kAdvancedSettingsKey, false).toBool());
    _mapping = new CustomMappingSettings();
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

//-----------------------------------------------------------------------------
bool CustomQuickInterface::test_connection(QString networkId) {
    return (CustomLogManager::queryLogServer(networkId.toStdString(), "") !=
            "");
}

//-----------------------------------------------------------------------------
void CustomQuickInterface::setPassword(QString password) {
    
    _password = password;
    QSettings settings;
    settings.beginGroup(kCustomWebODMGroup);
    settings.setValue(kPasswordKey, password);
    emit passwordChanged();
}

//-----------------------------------------------------------------------------
void CustomQuickInterface::setCorrectCredentials(bool correctCredentials) {
    _correctCredentials = correctCredentials;
    QSettings settings;
    settings.beginGroup(kCustomWebODMGroup);
    settings.setValue(kCorrectCredentialsKey, correctCredentials);
    emit correctCredentialsChanged();
}



void CustomQuickInterface::login(QString password) {
    CustomWebODMManager* webodm = new CustomWebODMManager();
    QGCToolbox* toolbox = qgcApp()->toolbox();
    // Be careful of toolbox not being open yet
    if (toolbox) {
        QString email = _mapping->email()->rawValue().toString();
        long res = webodm->queryLoginCredientials(email.toStdString(), password.toStdString());
        if (res == (long)200){
            setCorrectCredentials(true);
        } else {
            setCorrectCredentials(false);
        }
    } else {
        setCorrectCredentials(false);
    }
}


void CustomQuickInterface::setAdvancedSettings(bool advancedSettings) {
    _advancedSettings = advancedSettings;
    QSettings settings;
    settings.beginGroup(kCustomWebODMGroup);
    settings.setValue(kAdvancedSettingsKey, advancedSettings);
    emit advancedSettingsChanged();
}


void CustomQuickInterface::returnToDefault() {
        _mapping->pcClassify()->rawValue() = _mapping->pcClassify()->rawDefaultValue();
        _mapping->smrfScalar()->rawValue() = _mapping->smrfScalar()->rawDefaultValue();
        _mapping->opensfmDepthmapMinPatchSd()->rawValue() = _mapping->opensfmDepthmapMinPatchSd()->rawDefaultValue();
        _mapping->smrfWindow()->rawValue() = _mapping->smrfWindow()->rawDefaultValue();
        _mapping->meshOctreeDepth()->rawValue() =_mapping->meshOctreeDepth()->rawDefaultValue();
        _mapping->minNumFeatures()->rawValue() =_mapping->minNumFeatures()->rawDefaultValue();
        _mapping->resizeTo()->rawValue() =_mapping->resizeTo()->rawDefaultValue();
        _mapping->smrfSlope()->rawValue() =_mapping->smrfSlope()->rawDefaultValue();
        _mapping->rerunFrom()->rawValue() =_mapping->rerunFrom()->rawDefaultValue();
        _mapping->use3dmesh()->rawValue() =_mapping->use3dmesh()->rawDefaultValue();
        _mapping->orthophotoCompression()->rawValue() =_mapping->orthophotoCompression()->rawDefaultValue();
        _mapping->mveConfidence()->rawValue() = _mapping->mveConfidence()->rawDefaultValue();
        _mapping->texturingSkipHoleFilling()->rawValue() = _mapping->texturingSkipHoleFilling()->rawDefaultValue();
        _mapping->texturingSkipGlobalSeamLeveling()->rawValue() = _mapping->texturingSkipGlobalSeamLeveling()->rawDefaultValue();
        _mapping->texturingNadirWeight()->rawValue() = _mapping->texturingNadirWeight()->rawDefaultValue();
        _mapping->texturingOutlierRemovalType()->rawValue() = _mapping->texturingOutlierRemovalType()->rawDefaultValue();
        _mapping->othrophotoResolution()->rawValue() = _mapping->othrophotoResolution()->rawDefaultValue();
        _mapping->dtm()->rawValue() = _mapping->dtm()->rawDefaultValue();
        _mapping->orthophotoNoTiled()->rawValue() = _mapping->orthophotoNoTiled()->rawDefaultValue();
        _mapping->demResolution()->rawValue() = _mapping->demResolution()->rawDefaultValue();
        _mapping->meshSize()->rawValue() = _mapping->meshSize()->rawDefaultValue();
        _mapping->forceGPS()->rawValue() = _mapping->forceGPS()->rawDefaultValue();
        _mapping->ignoreGsd()->rawValue() = _mapping->ignoreGsd()->rawDefaultValue();
        _mapping->buildOverviews()->rawValue() = _mapping->buildOverviews()->rawDefaultValue();
        _mapping->opensfmDense()->rawValue() = _mapping->opensfmDense()->rawDefaultValue();
        _mapping->opensfmDepthmapMinConsistentViews()->rawValue() = _mapping->opensfmDepthmapMinConsistentViews()->rawDefaultValue();
        _mapping->texturingSkipLocalSeamLeveling()->rawValue() = _mapping->texturingSkipLocalSeamLeveling()->rawDefaultValue();
        _mapping->texturingKeepUnseenFaces()->rawValue() = _mapping->texturingKeepUnseenFaces()->rawDefaultValue();
        _mapping->debug()->rawValue() = _mapping->debug()->rawDefaultValue();
        _mapping->useExif()->rawValue() = _mapping->useExif()->rawDefaultValue();
        _mapping->meshSamples()->rawValue() = _mapping->meshSamples()->rawDefaultValue();
        _mapping->pcSample()->rawValue() = _mapping->pcSample()->rawDefaultValue();
        _mapping->matcherDistance()->rawValue() = _mapping->matcherDistance()->rawDefaultValue();
        _mapping->splitOverlap()->rawValue() = _mapping->splitOverlap()->rawDefaultValue();
        _mapping->demDecimation()->rawValue() = _mapping->demDecimation()->rawDefaultValue();
        _mapping->orthophotoCutline()->rawValue() = _mapping->orthophotoCutline()->rawDefaultValue();
        _mapping->pcFilter()->rawValue() = _mapping->pcFilter()->rawDefaultValue();
        _mapping->split()->rawValue() = _mapping->split()->rawDefaultValue();
        _mapping->fastOrthophoto()->rawValue() = _mapping->fastOrthophoto()->rawDefaultValue();
        _mapping->pcEpt()->rawValue() = _mapping->pcEpt()->rawDefaultValue();
        _mapping->crop()->rawValue() = _mapping->crop()->rawDefaultValue();
        _mapping->pcLas()->rawValue() = _mapping->pcLas()->rawDefaultValue();
        _mapping->merge()->rawValue() = _mapping->merge()->rawDefaultValue();
        _mapping->dsm()->rawValue() = _mapping->dsm()->rawDefaultValue();
        _mapping->demGapfillSteps()->rawValue() = _mapping->demGapfillSteps()->rawDefaultValue();
        _mapping->meshPointWeight()->rawValue() = _mapping->meshPointWeight()->rawDefaultValue();
        _mapping->maxConcurrency()->rawValue() = _mapping->maxConcurrency()->rawDefaultValue();
        _mapping->texturingToneMapping()->rawValue() = _mapping->texturingToneMapping()->rawDefaultValue();
        _mapping->demEuclidianMap()->rawValue() = _mapping->demEuclidianMap()->rawDefaultValue();
        _mapping->cameraLens()->rawValue() = _mapping->cameraLens()->rawDefaultValue();
        _mapping->skip3dmodel()->rawValue() = _mapping->skip3dmodel()->rawDefaultValue();
        _mapping->matchNeighbours()->rawValue() = _mapping->matchNeighbours()->rawDefaultValue();
        _mapping->pcCsv()->rawValue() = _mapping->pcCsv()->rawDefaultValue();
        _mapping->endWith()->rawValue() = _mapping->endWith()->rawDefaultValue();
        _mapping->depthmapResolution()->rawValue() = _mapping->depthmapResolution()->rawDefaultValue();
        _mapping->texturingDataTerm()->rawValue() = _mapping->texturingDataTerm()->rawDefaultValue();
        _mapping->texturingSkipVisibilityTest()->rawValue() = _mapping->texturingSkipVisibilityTest()->rawDefaultValue();
        _mapping->opensfmDepthmapMethod()->rawValue() = _mapping->opensfmDepthmapMethod()->rawDefaultValue();
        _mapping->useFixedCameraParams()->rawValue() = _mapping->useFixedCameraParams()->rawDefaultValue();
        _mapping->smrfThreshold()->rawValue() = _mapping->smrfThreshold()->rawDefaultValue();
        _mapping->verbose()->rawValue() = _mapping->verbose()->rawDefaultValue();
        _mapping->useHybridBundleAdjustment()->rawValue() = _mapping->useHybridBundleAdjustment()->rawDefaultValue();
}

void CustomQuickInterface::dsmdtm() {
    _mapping->dsm()->setRawValue(true);
    _mapping->dtm()->setRawValue(true);
}

void CustomQuickInterface::highRes() {
    _mapping->dsm()->setRawValue(true);
    _mapping->ignoreGsd()->setRawValue(true);
    _mapping->depthmapResolution()->setRawValue(1000);
    _mapping->demResolution()->setRawValue(2.0);
    _mapping->othrophotoResolution()->setRawValue(2.0);
}

void CustomQuickInterface::fastOrtho() {
    _mapping->fastOrthophoto()->setRawValue(true);
}

void CustomQuickInterface::volumeAnalysis() {
    _mapping->dsm()->setRawValue(true);
    _mapping->demResolution()->setRawValue(2.0);
    _mapping->depthmapResolution()->setRawValue(1000);
}

void CustomQuickInterface::model() {
    _mapping->depthmapResolution()->setRawValue(1000);
    _mapping->meshSize()->setRawValue(600000);
    _mapping->use3dmesh()->setRawValue(true);
    _mapping->meshOctreeDepth()->setRawValue(11);
}

void CustomQuickInterface::buildings() {
    _mapping->meshOctreeDepth()->setRawValue(10);
    _mapping->meshSize()->setRawValue(300000);
    _mapping->depthmapResolution()->setRawValue(1000);
    _mapping->texturingNadirWeight()->setRawValue(28);
}


void CustomQuickInterface::pointOfInterest() {
    _mapping->meshSize()->setRawValue(600000);
    _mapping->use3dmesh()->setRawValue(true);
}

void CustomQuickInterface::forest() {
    _mapping->minNumFeatures()->setRawValue(18000);
    _mapping->texturingDataTerm()->setEnumIndex(0);
}

void CustomQuickInterface::presetChanged() {
    QGCToolbox* toolbox = qgcApp()->toolbox();
    // Be careful of toolbox not being open yet
    if (toolbox) {
        returnToDefault();

        std::string value = _mapping->processingPresets()->enumStringValue().toStdString();
        if (value == "DSM + DTM") {
                dsmdtm();
        } else if (value == "High Resolution") {
                highRes();
        } else if (value == "Fast Orthophoto") {
                fastOrtho();
        } else if (value == "Forest") {
                forest();
        } else if (value == "Point of Interest") {
                pointOfInterest();
        } else if (value == "Buildings") {
                buildings();
        } else if (value == "3D Model") {
                model();
        } else if (value == "Volume Analysis") {
                volumeAnalysis();
        }
    }
}

void CustomQuickInterface::setCustom() {
    _mapping->processingPresets()->setEnumIndex(9);
}

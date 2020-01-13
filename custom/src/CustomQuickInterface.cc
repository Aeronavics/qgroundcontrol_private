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
static const char* kMapSurveyKey   = "MapSurvey";

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
    _webodmManager = new CustomWebODMManager();
    _webodmManager->init(_mapping);
    setMapSurvey(
        settings.value(kMapSurveyKey, false).toBool());
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



void CustomQuickInterface::login(QString password, QString compPassword) {
    QString email = _mapping->email()->rawValue().toString();
    long res = _webodmManager->queryLoginCredientials(email.toStdString(), password.toStdString());
    if (res == (long)200){
        setCorrectCredentials(true);
        _webodmManager->webodm(compPassword.toStdString());
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


void CustomQuickInterface::setMapSurvey(bool mapSurvey) {
    if (!mapSurvey) {
        QObject::disconnect(qgcApp()->toolbox()->multiVehicleManager()->activeVehicle(),0,_webodmManager, 0);
        setCorrectCredentials(false);
    }
    _mapSurvey = mapSurvey;
    QSettings settings;
    settings.beginGroup(kCustomWebODMGroup);
    settings.setValue(kMapSurveyKey, mapSurvey);
    emit mapSurveyChanged();
}


void CustomQuickInterface::returnToDefault() {
        _mapping->pcClassify()->setRawValue( _mapping->pcClassify()->rawDefaultValue());
        _mapping->smrfScalar()->setRawValue( _mapping->smrfScalar()->rawDefaultValue());
        _mapping->opensfmDepthmapMinPatchSd()->setRawValue( _mapping->opensfmDepthmapMinPatchSd()->rawDefaultValue());
        _mapping->smrfWindow()->setRawValue( _mapping->smrfWindow()->rawDefaultValue());
        _mapping->meshOctreeDepth()->setRawValue( _mapping->meshOctreeDepth()->rawDefaultValue());
        _mapping->minNumFeatures()->setRawValue( _mapping->minNumFeatures()->rawDefaultValue());
        _mapping->resizeTo()->setRawValue( _mapping->resizeTo()->rawDefaultValue());
        _mapping->smrfSlope()->setRawValue( _mapping->smrfSlope()->rawDefaultValue());
        _mapping->rerunFrom()->setRawValue( _mapping->rerunFrom()->rawDefaultValue());
        _mapping->use3dmesh()->setRawValue( _mapping->use3dmesh()->rawDefaultValue());
        _mapping->orthophotoCompression()->setRawValue( _mapping->orthophotoCompression()->rawDefaultValue());
        _mapping->mveConfidence()->setRawValue( _mapping->mveConfidence()->rawDefaultValue());
        _mapping->texturingSkipHoleFilling()->setRawValue( _mapping->texturingSkipHoleFilling()->rawDefaultValue());
        _mapping->texturingSkipGlobalSeamLeveling()->setRawValue( _mapping->texturingSkipGlobalSeamLeveling()->rawDefaultValue());
        _mapping->texturingNadirWeight()->setRawValue( _mapping->texturingNadirWeight()->rawDefaultValue());
        _mapping->texturingOutlierRemovalType()->setRawValue( _mapping->texturingOutlierRemovalType()->rawDefaultValue());
        _mapping->othrophotoResolution()->setRawValue( _mapping->othrophotoResolution()->rawDefaultValue());
        _mapping->dtm()->setRawValue( _mapping->dtm()->rawDefaultValue());
        _mapping->orthophotoNoTiled()->setRawValue( _mapping->orthophotoNoTiled()->rawDefaultValue());
        _mapping->demResolution()->setRawValue( _mapping->demResolution()->rawDefaultValue());
        _mapping->meshSize()->setRawValue( _mapping->meshSize()->rawDefaultValue());
        _mapping->forceGPS()->setRawValue( _mapping->forceGPS()->rawDefaultValue());
        _mapping->ignoreGsd()->setRawValue( _mapping->ignoreGsd()->rawDefaultValue());
        _mapping->buildOverviews()->setRawValue( _mapping->buildOverviews()->rawDefaultValue());
        _mapping->opensfmDense()->setRawValue( _mapping->opensfmDense()->rawDefaultValue());
        _mapping->opensfmDepthmapMinConsistentViews()->setRawValue( _mapping->opensfmDepthmapMinConsistentViews()->rawDefaultValue());
        _mapping->texturingSkipLocalSeamLeveling()->setRawValue( _mapping->texturingSkipLocalSeamLeveling()->rawDefaultValue());
        _mapping->texturingKeepUnseenFaces()->setRawValue( _mapping->texturingKeepUnseenFaces()->rawDefaultValue());
        _mapping->debug()->setRawValue( _mapping->debug()->rawDefaultValue());
        _mapping->useExif()->setRawValue( _mapping->useExif()->rawDefaultValue());
        _mapping->meshSamples()->setRawValue( _mapping->meshSamples()->rawDefaultValue());
        _mapping->pcSample()->setRawValue( _mapping->pcSample()->rawDefaultValue());
        _mapping->matcherDistance()->setRawValue( _mapping->matcherDistance()->rawDefaultValue());
        _mapping->splitOverlap()->setRawValue( _mapping->splitOverlap()->rawDefaultValue());
        _mapping->demDecimation()->setRawValue( _mapping->demDecimation()->rawDefaultValue());
        _mapping->orthophotoCutline()->setRawValue( _mapping->orthophotoCutline()->rawDefaultValue());
        _mapping->pcFilter()->setRawValue( _mapping->pcFilter()->rawDefaultValue());
        _mapping->split()->setRawValue( _mapping->split()->rawDefaultValue());
        _mapping->fastOrthophoto()->setRawValue( _mapping->fastOrthophoto()->rawDefaultValue());
        _mapping->pcEpt()->setRawValue( _mapping->pcEpt()->rawDefaultValue());
        _mapping->crop()->setRawValue( _mapping->crop()->rawDefaultValue());
        _mapping->pcLas()->setRawValue( _mapping->pcLas()->rawDefaultValue());
        _mapping->merge()->setRawValue( _mapping->merge()->rawDefaultValue());
        _mapping->dsm()->setRawValue( _mapping->dsm()->rawDefaultValue());
        _mapping->demGapfillSteps()->setRawValue( _mapping->demGapfillSteps()->rawDefaultValue());
        _mapping->meshPointWeight()->setRawValue( _mapping->meshPointWeight()->rawDefaultValue());
        _mapping->maxConcurrency()->setRawValue( _mapping->maxConcurrency()->rawDefaultValue());
        _mapping->texturingToneMapping()->setRawValue( _mapping->texturingToneMapping()->rawDefaultValue());
        _mapping->demEuclidianMap()->setRawValue( _mapping->demEuclidianMap()->rawDefaultValue());
        _mapping->cameraLens()->setRawValue( _mapping->cameraLens()->rawDefaultValue());
        _mapping->skip3dmodel()->setRawValue( _mapping->skip3dmodel()->rawDefaultValue());
        _mapping->matchNeighbours()->setRawValue( _mapping->matchNeighbours()->rawDefaultValue());
        _mapping->pcCsv()->setRawValue( _mapping->pcCsv()->rawDefaultValue());
        _mapping->endWith()->setRawValue( _mapping->endWith()->rawDefaultValue());
        _mapping->depthmapResolution()->setRawValue( _mapping->depthmapResolution()->rawDefaultValue());
        _mapping->texturingDataTerm()->setRawValue( _mapping->texturingDataTerm()->rawDefaultValue());
        _mapping->texturingSkipVisibilityTest()->setRawValue( _mapping->texturingSkipVisibilityTest()->rawDefaultValue());
        _mapping->opensfmDepthmapMethod()->setRawValue( _mapping->opensfmDepthmapMethod()->rawDefaultValue());
        _mapping->useFixedCameraParams()->setRawValue( _mapping->useFixedCameraParams()->rawDefaultValue());
        _mapping->smrfThreshold()->setRawValue( _mapping->smrfThreshold()->rawDefaultValue());
        _mapping->verbose()->setRawValue( _mapping->verbose()->rawDefaultValue());
        _mapping->useHybridBundleAdjustment()->setRawValue( _mapping->useHybridBundleAdjustment()->rawDefaultValue());
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

void CustomQuickInterface::setCustom() {
    _mapping->processingPresets()->setEnumIndex(9);
}

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
#include "MappingSettings.h"
#include "MAVLinkLogManager.h"
#include "PositionManager.h"
#include "QGCApplication.h"
#include "QGCMapEngine.h"
#include "SettingsManager.h"

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
        QString email = qgcApp()->toolbox()->settingsManager()->mappingSettings()->email()->rawValue().toString();
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
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->pcClassify()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->smrfScalar()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->opensfmDepthmapMinPatchSd()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->smrfWindow()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->meshOctreeDepth()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->minNumFeatures()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->resizeTo()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->smrfSlope()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->rerunFrom()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->use3dmesh()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->orthophotoCompression()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->mveConfidence()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->texturingSkipHoleFilling()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->texturingSkipGlobalSeamLeveling()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->texturingNadirWeight()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->texturingOutlierRemovalType()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->othrophotoResolution()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->dtm()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->orthophotoNoTiled()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->demResolution()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->meshSize()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->forceGPS()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->ignoreGsd()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->buildOverviews()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->opensfmDense()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->opensfmDepthmapMinConsistentViews()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->texturingSkipLocalSeamLeveling()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->texturingKeepUnseenFaces()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->debug()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->useExif()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->meshSamples()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->pcSample()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->matcherDistance()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->splitOverlap()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->demDecimation()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->orthophotoCutline()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->pcFilter()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->split()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->fastOrthophoto()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->pcEpt()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->crop()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->pcLas()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->merge()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->dsm()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->demGapfillSteps()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->meshPointWeight()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->maxConcurrency()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->texturingToneMapping()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->demEuclidianMap()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->cameraLens()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->skip3dmodel()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->matchNeighbours()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->pcCsv()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->endWith()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->depthmapResolution()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->texturingDataTerm()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->texturingSkipVisibilityTest()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->opensfmDepthmapMethod()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->useFixedCameraParams()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->smrfThreshold()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->verbose()->setToDefault();
        qgcApp()->toolbox()->settingsManager()->mappingSettings()->useHybridBundleAdjustment()->setToDefault();
}

void CustomQuickInterface::dsmdtm() {
    qgcApp()->toolbox()->settingsManager()->mappingSettings()->dsm()->setRawValue(true);
    qgcApp()->toolbox()->settingsManager()->mappingSettings()->dtm()->setRawValue(true);
}

void CustomQuickInterface::highRes() {
    qgcApp()->toolbox()->settingsManager()->mappingSettings()->dsm()->setRawValue(true);
    qgcApp()->toolbox()->settingsManager()->mappingSettings()->ignoreGsd()->setRawValue(true);
    qgcApp()->toolbox()->settingsManager()->mappingSettings()->depthmapResolution()->setRawValue(1000);
    qgcApp()->toolbox()->settingsManager()->mappingSettings()->demResolution()->setRawValue(2.0);
    qgcApp()->toolbox()->settingsManager()->mappingSettings()->othrophotoResolution()->setRawValue(2.0);
}

void CustomQuickInterface::fastOrtho() {
    qgcApp()->toolbox()->settingsManager()->mappingSettings()->fastOrthophoto()->setRawValue(true);
}

void CustomQuickInterface::volumeAnalysis() {
    qgcApp()->toolbox()->settingsManager()->mappingSettings()->dsm()->setRawValue(true);
    qgcApp()->toolbox()->settingsManager()->mappingSettings()->demResolution()->setRawValue(2.0);
    qgcApp()->toolbox()->settingsManager()->mappingSettings()->depthmapResolution()->setRawValue(1000);
}

void CustomQuickInterface::model() {
    qgcApp()->toolbox()->settingsManager()->mappingSettings()->depthmapResolution()->setRawValue(1000);
    qgcApp()->toolbox()->settingsManager()->mappingSettings()->meshSize()->setRawValue(600000);
    qgcApp()->toolbox()->settingsManager()->mappingSettings()->use3dmesh()->setRawValue(true);
    qgcApp()->toolbox()->settingsManager()->mappingSettings()->meshOctreeDepth()->setRawValue(11);
}

void CustomQuickInterface::buildings() {
    qgcApp()->toolbox()->settingsManager()->mappingSettings()->meshOctreeDepth()->setRawValue(10);
    qgcApp()->toolbox()->settingsManager()->mappingSettings()->meshSize()->setRawValue(300000);
    qgcApp()->toolbox()->settingsManager()->mappingSettings()->depthmapResolution()->setRawValue(1000);
    qgcApp()->toolbox()->settingsManager()->mappingSettings()->texturingNadirWeight()->setRawValue(28);
}


void CustomQuickInterface::pointOfInterest() {
    qgcApp()->toolbox()->settingsManager()->mappingSettings()->meshSize()->setRawValue(600000);
    qgcApp()->toolbox()->settingsManager()->mappingSettings()->use3dmesh()->setRawValue(true);
}

void CustomQuickInterface::forest() {
    qgcApp()->toolbox()->settingsManager()->mappingSettings()->minNumFeatures()->setRawValue(18000);
    qgcApp()->toolbox()->settingsManager()->mappingSettings()->texturingDataTerm()->setEnumIndex(0);
}

void CustomQuickInterface::presetChanged() {
    QGCToolbox* toolbox = qgcApp()->toolbox();
    // Be careful of toolbox not being open yet
    if (toolbox) {
        returnToDefault();

        std::string value = qgcApp()->toolbox()->settingsManager()->mappingSettings()->processingPresets()->enumStringValue().toStdString();
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
    qgcApp()->toolbox()->settingsManager()->mappingSettings()->processingPresets()->setEnumIndex(9);
}

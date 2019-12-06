/****************************************************************************
 *
 *   (c) 2009-2016 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "AppSettings.h"
#include "QGCPalette.h"
#include "QGCApplication.h"
#include "ParameterManager.h"

#include <QQmlEngine>
#include <QtQml>
#include <QStandardPaths>

const char* AppSettings::parameterFileExtension =   "params";
const char* AppSettings::planFileExtension =        "plan";
const char* AppSettings::missionFileExtension =     "mission";
const char* AppSettings::waypointsFileExtension =   "waypoints";
const char* AppSettings::fenceFileExtension =       "fence";
const char* AppSettings::rallyPointFileExtension =  "rally";
const char* AppSettings::telemetryFileExtension =   "tlog";
const char* AppSettings::kmlFileExtension =         "kml";
const char* AppSettings::shpFileExtension =         "shp";
const char* AppSettings::logFileExtension =         "ulg";

const char* AppSettings::parameterDirectory =       "Parameters";
const char* AppSettings::telemetryDirectory =       "Telemetry";
const char* AppSettings::missionDirectory =         "Missions";
const char* AppSettings::logDirectory =             "Logs";
const char* AppSettings::videoDirectory =           "Video";
const char* AppSettings::crashDirectory =           "CrashLogs";

DECLARE_SETTINGGROUP(App, "")
{
    qmlRegisterUncreatableType<AppSettings>("QGroundControl.SettingsManager", 1, 0, "AppSettings", "Reference only");
    QGCPalette::setGlobalTheme(indoorPalette()->rawValue().toBool() ? QGCPalette::Dark : QGCPalette::Light);

    // Instantiate savePath so we can check for override and setup default path if needed

    SettingsFact* savePathFact = qobject_cast<SettingsFact*>(savePath());
    QString appName = qgcApp()->applicationName();
    if (savePathFact->rawValue().toString().isEmpty() && _nameToMetaDataMap[savePathName]->rawDefaultValue().toString().isEmpty()) {
#ifdef __mobile__
#ifdef __ios__
        QDir rootDir = QDir(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation));
#else
        QDir rootDir = QDir(QStandardPaths::writableLocation(QStandardPaths::GenericDataLocation));
#endif
        savePathFact->setVisible(false);
#else
        QDir rootDir = QDir(QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation));
#endif
        savePathFact->setRawValue(rootDir.filePath(appName));
    }

    connect(savePathFact, &Fact::rawValueChanged, this, &AppSettings::savePathsChanged);
    connect(savePathFact, &Fact::rawValueChanged, this, &AppSettings::_checkSavePathDirectories);

    _checkSavePathDirectories();
    //-- Keep track of language changes
    SettingsFact* languageFact = qobject_cast<SettingsFact*>(language());
    connect(languageFact, &Fact::rawValueChanged, this, &AppSettings::_languageChanged);
}

DECLARE_SETTINGSFACT(AppSettings, offlineEditingFirmwareType)
DECLARE_SETTINGSFACT(AppSettings, offlineEditingVehicleType)
DECLARE_SETTINGSFACT(AppSettings, offlineEditingCruiseSpeed)
DECLARE_SETTINGSFACT(AppSettings, offlineEditingHoverSpeed)
DECLARE_SETTINGSFACT(AppSettings, offlineEditingAscentSpeed)
DECLARE_SETTINGSFACT(AppSettings, offlineEditingDescentSpeed)
DECLARE_SETTINGSFACT(AppSettings, batteryPercentRemainingAnnounce)
DECLARE_SETTINGSFACT(AppSettings, defaultMissionItemAltitude)
DECLARE_SETTINGSFACT(AppSettings, telemetrySave)
DECLARE_SETTINGSFACT(AppSettings, telemetrySaveNotArmed)
DECLARE_SETTINGSFACT(AppSettings, audioMuted)
DECLARE_SETTINGSFACT(AppSettings, checkInternet)
DECLARE_SETTINGSFACT(AppSettings, virtualJoystick)
DECLARE_SETTINGSFACT(AppSettings, virtualJoystickCentralized)
DECLARE_SETTINGSFACT(AppSettings, appFontPointSize)
DECLARE_SETTINGSFACT(AppSettings, showLargeCompass)
DECLARE_SETTINGSFACT(AppSettings, savePath)
DECLARE_SETTINGSFACT(AppSettings, autoLoadMissions)
DECLARE_SETTINGSFACT(AppSettings, useChecklist)
DECLARE_SETTINGSFACT(AppSettings, mapboxToken)
DECLARE_SETTINGSFACT(AppSettings, esriToken)
DECLARE_SETTINGSFACT(AppSettings, defaultFirmwareType)
DECLARE_SETTINGSFACT(AppSettings, gstDebugLevel)
DECLARE_SETTINGSFACT(AppSettings, followTarget)
DECLARE_SETTINGSFACT(AppSettings, rerun)
DECLARE_SETTINGSFACT(AppSettings, apmStartMavlinkStreams)
DECLARE_SETTINGSFACT(AppSettings, enableTaisync)
DECLARE_SETTINGSFACT(AppSettings, enableTaisyncVideo)
DECLARE_SETTINGSFACT(AppSettings, enableMicrohard)
DECLARE_SETTINGSFACT(AppSettings, language)
DECLARE_SETTINGSFACT(AppSettings, disableAllPersistence)
DECLARE_SETTINGSFACT(AppSettings, usePairing)
DECLARE_SETTINGSFACT(AppSettings, saveCsvTelemetry)
DECLARE_SETTINGSFACT(AppSettings, smrfScalar)
DECLARE_SETTINGSFACT(AppSettings, pcClassify)
DECLARE_SETTINGSFACT(AppSettings, opensfmDepthmapMinPatchSd)
DECLARE_SETTINGSFACT(AppSettings, email)
DECLARE_SETTINGSFACT(AppSettings, projectName)
DECLARE_SETTINGSFACT(AppSettings, taskName)
DECLARE_SETTINGSFACT(AppSettings, smrfWindow)
DECLARE_SETTINGSFACT(AppSettings, meshOctreeDepth)
DECLARE_SETTINGSFACT(AppSettings, minNumFeatures)
DECLARE_SETTINGSFACT(AppSettings, resizeTo)
DECLARE_SETTINGSFACT(AppSettings, smrfSlope)
DECLARE_SETTINGSFACT(AppSettings, rerunFrom)
DECLARE_SETTINGSFACT(AppSettings, use3dmesh)
DECLARE_SETTINGSFACT(AppSettings, orthophotoCompression)
DECLARE_SETTINGSFACT(AppSettings, mveConfidence)
DECLARE_SETTINGSFACT(AppSettings, texturingSkipHoleFilling)
DECLARE_SETTINGSFACT(AppSettings, texturingSkipGlobalSeamLeveling)
DECLARE_SETTINGSFACT(AppSettings, texturingNadirWeight)
DECLARE_SETTINGSFACT(AppSettings, texturingOutlierRemovalType)
DECLARE_SETTINGSFACT(AppSettings, othrophotoResolution)
DECLARE_SETTINGSFACT(AppSettings, dtm)
DECLARE_SETTINGSFACT(AppSettings, orthophotoNoTiled)
DECLARE_SETTINGSFACT(AppSettings, demResolution)
DECLARE_SETTINGSFACT(AppSettings, meshSize)
DECLARE_SETTINGSFACT(AppSettings, forceGPS)
DECLARE_SETTINGSFACT(AppSettings, ignoreGsd)
DECLARE_SETTINGSFACT(AppSettings, buildOverviews)
DECLARE_SETTINGSFACT(AppSettings, opensfmDense)
DECLARE_SETTINGSFACT(AppSettings, opensfmDepthmapMinConsistentViews)
DECLARE_SETTINGSFACT(AppSettings, texturingSkipLocalSeamLeveling)
DECLARE_SETTINGSFACT(AppSettings, texturingKeepUnseenFaces)
DECLARE_SETTINGSFACT(AppSettings, debug)
DECLARE_SETTINGSFACT(AppSettings, useExif)
DECLARE_SETTINGSFACT(AppSettings, meshSamples)
DECLARE_SETTINGSFACT(AppSettings, pcSample)
DECLARE_SETTINGSFACT(AppSettings, matcherDistance)
DECLARE_SETTINGSFACT(AppSettings, splitOverlap)
DECLARE_SETTINGSFACT(AppSettings, demDecimation)
DECLARE_SETTINGSFACT(AppSettings, orthophotoCutline)
DECLARE_SETTINGSFACT(AppSettings, pcFilter)
DECLARE_SETTINGSFACT(AppSettings, split)
DECLARE_SETTINGSFACT(AppSettings, fastOrthophoto)
DECLARE_SETTINGSFACT(AppSettings, pcEpt)
DECLARE_SETTINGSFACT(AppSettings, crop)
DECLARE_SETTINGSFACT(AppSettings, pcLas)
DECLARE_SETTINGSFACT(AppSettings, merge)
DECLARE_SETTINGSFACT(AppSettings, dsm)
DECLARE_SETTINGSFACT(AppSettings, demGapfillSteps)
DECLARE_SETTINGSFACT(AppSettings, meshPointWeight)
DECLARE_SETTINGSFACT(AppSettings, maxConcurrency)
DECLARE_SETTINGSFACT(AppSettings, texturingToneMapping)
DECLARE_SETTINGSFACT(AppSettings, demEuclidianMap)
DECLARE_SETTINGSFACT(AppSettings, cameraLens)
DECLARE_SETTINGSFACT(AppSettings, skip3dmodel)
DECLARE_SETTINGSFACT(AppSettings, matchNeighbours)
DECLARE_SETTINGSFACT(AppSettings, pcCsv)
DECLARE_SETTINGSFACT(AppSettings, endWith)
DECLARE_SETTINGSFACT(AppSettings, depthmapResolution)
DECLARE_SETTINGSFACT(AppSettings, texturingDataTerm)
DECLARE_SETTINGSFACT(AppSettings, texturingSkipVisibilityTest)
DECLARE_SETTINGSFACT(AppSettings, opensfmDepthmapMethod)
DECLARE_SETTINGSFACT(AppSettings, useFixedCameraParams)
DECLARE_SETTINGSFACT(AppSettings, smrfThreshold)
DECLARE_SETTINGSFACT(AppSettings, verbose)
DECLARE_SETTINGSFACT(AppSettings, useHybridBundleAdjustment)


DECLARE_SETTINGSFACT_NO_FUNC(AppSettings, indoorPalette)
{
    if (!_indoorPaletteFact) {
        _indoorPaletteFact = _createSettingsFact(indoorPaletteName);
        connect(_indoorPaletteFact, &Fact::rawValueChanged, this, &AppSettings::_indoorPaletteChanged);
    }
    return _indoorPaletteFact;
}

void AppSettings::_languageChanged()
{
    qgcApp()->setLanguage();
}

void AppSettings::_checkSavePathDirectories(void)
{
    QDir savePathDir(savePath()->rawValue().toString());
    if (!savePathDir.exists()) {
        QDir().mkpath(savePathDir.absolutePath());
    }
    if (savePathDir.exists()) {
        savePathDir.mkdir(parameterDirectory);
        savePathDir.mkdir(telemetryDirectory);
        savePathDir.mkdir(missionDirectory);
        savePathDir.mkdir(logDirectory);
        savePathDir.mkdir(videoDirectory);
        savePathDir.mkdir(crashDirectory);
    }
}

void AppSettings::_indoorPaletteChanged(void)
{
    QGCPalette::setGlobalTheme(indoorPalette()->rawValue().toBool() ? QGCPalette::Dark : QGCPalette::Light);
}

QString AppSettings::missionSavePath(void)
{
    QString path = savePath()->rawValue().toString();
    if (!path.isEmpty() && QDir(path).exists()) {
        QDir dir(path);
        return dir.filePath(missionDirectory);
    }
    return QString();
}

QString AppSettings::parameterSavePath(void)
{
    QString path = savePath()->rawValue().toString();
    if (!path.isEmpty() && QDir(path).exists()) {
        QDir dir(path);
        return dir.filePath(parameterDirectory);
    }
    return QString();
}

QString AppSettings::telemetrySavePath(void)
{
    QString path = savePath()->rawValue().toString();
    if (!path.isEmpty() && QDir(path).exists()) {
        QDir dir(path);
        return dir.filePath(telemetryDirectory);
    }
    return QString();
}

QString AppSettings::logSavePath(void)
{
    QString path = savePath()->rawValue().toString();
    if (!path.isEmpty() && QDir(path).exists()) {
        QDir dir(path);
        return dir.filePath(logDirectory);
    }
    return QString();
}

QString AppSettings::videoSavePath(void)
{
    QString path = savePath()->rawValue().toString();
    if (!path.isEmpty() && QDir(path).exists()) {
        QDir dir(path);
        return dir.filePath(videoDirectory);
    }
    return QString();
}

QString AppSettings::crashSavePath(void)
{
    QString path = savePath()->rawValue().toString();
    if (!path.isEmpty() && QDir(path).exists()) {
        QDir dir(path);
        return dir.filePath(crashDirectory);
    }
    return QString();
}

MAV_AUTOPILOT AppSettings::offlineEditingFirmwareTypeFromFirmwareType(MAV_AUTOPILOT firmwareType)
{
    if (firmwareType != MAV_AUTOPILOT_PX4 && firmwareType != MAV_AUTOPILOT_ARDUPILOTMEGA) {
        firmwareType = MAV_AUTOPILOT_GENERIC;
    }
    return firmwareType;
}

MAV_TYPE AppSettings::offlineEditingVehicleTypeFromVehicleType(MAV_TYPE vehicleType)
{
    if (QGCMAVLink::isRover(vehicleType)) {
        return MAV_TYPE_GROUND_ROVER;
    } else if (QGCMAVLink::isSub(vehicleType)) {
        return MAV_TYPE_SUBMARINE;
    } else if (QGCMAVLink::isVTOL(vehicleType)) {
        return MAV_TYPE_VTOL_QUADROTOR;
    } else if (QGCMAVLink::isFixedWing(vehicleType)) {
        return MAV_TYPE_FIXED_WING;
    } else {
        return MAV_TYPE_QUADROTOR;
    }
}

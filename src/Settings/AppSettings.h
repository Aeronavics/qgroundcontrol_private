/****************************************************************************
 *
 *   (c) 2009-2016 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/
#pragma once
#include <QTranslator>

#include "SettingsGroup.h"
#include "QGCMAVLink.h"

class AppSettings : public SettingsGroup
{
    Q_OBJECT

public:
    AppSettings(QObject* parent = nullptr);

    DEFINE_SETTING_NAME_GROUP()

    DEFINE_SETTINGFACT(offlineEditingFirmwareType)
    DEFINE_SETTINGFACT(offlineEditingVehicleType)
    DEFINE_SETTINGFACT(offlineEditingCruiseSpeed)
    DEFINE_SETTINGFACT(offlineEditingHoverSpeed)
    DEFINE_SETTINGFACT(offlineEditingAscentSpeed)
    DEFINE_SETTINGFACT(offlineEditingDescentSpeed)
    DEFINE_SETTINGFACT(batteryPercentRemainingAnnounce)
    DEFINE_SETTINGFACT(defaultMissionItemAltitude)
    DEFINE_SETTINGFACT(telemetrySave)
    DEFINE_SETTINGFACT(telemetrySaveNotArmed)
    DEFINE_SETTINGFACT(audioMuted)
    DEFINE_SETTINGFACT(checkInternet)
    DEFINE_SETTINGFACT(virtualJoystick)
    DEFINE_SETTINGFACT(virtualJoystickCentralized)
    DEFINE_SETTINGFACT(appFontPointSize)
    DEFINE_SETTINGFACT(indoorPalette)
    DEFINE_SETTINGFACT(showLargeCompass)
    DEFINE_SETTINGFACT(savePath)
    DEFINE_SETTINGFACT(autoLoadMissions)
    DEFINE_SETTINGFACT(useChecklist)
    DEFINE_SETTINGFACT(mapboxToken)
    DEFINE_SETTINGFACT(esriToken)
    DEFINE_SETTINGFACT(defaultFirmwareType)
    DEFINE_SETTINGFACT(gstDebugLevel)
    DEFINE_SETTINGFACT(followTarget)
    DEFINE_SETTINGFACT(rerun)
    DEFINE_SETTINGFACT(enableTaisync)
    DEFINE_SETTINGFACT(enableTaisyncVideo)
    DEFINE_SETTINGFACT(enableMicrohard)
    DEFINE_SETTINGFACT(language)
    DEFINE_SETTINGFACT(disableAllPersistence)
    DEFINE_SETTINGFACT(usePairing)
    DEFINE_SETTINGFACT(saveCsvTelemetry)
    DEFINE_SETTINGFACT(email)
    DEFINE_SETTINGFACT(projectName)
    DEFINE_SETTINGFACT(taskName)
    DEFINE_SETTINGFACT(smrfScalar)
    DEFINE_SETTINGFACT(pcClassify)
    DEFINE_SETTINGFACT(opensfmDepthmapMinPatchSd)
    DEFINE_SETTINGFACT(smrfWindow)
    DEFINE_SETTINGFACT(meshOctreeDepth)
    DEFINE_SETTINGFACT(minNumFeatures)
    DEFINE_SETTINGFACT(resizeTo)
    DEFINE_SETTINGFACT(smrfSlope)
    DEFINE_SETTINGFACT(rerunFrom)
    DEFINE_SETTINGFACT(use3dmesh)
    DEFINE_SETTINGFACT(orthophotoCompression)
    DEFINE_SETTINGFACT(mveConfidence)
    DEFINE_SETTINGFACT(texturingSkipHoleFilling)
    DEFINE_SETTINGFACT(texturingSkipGlobalSeamLeveling)
    DEFINE_SETTINGFACT(texturingNadirWeight)
    DEFINE_SETTINGFACT(texturingOutlierRemovalType)
    DEFINE_SETTINGFACT(othrophotoResolution)
    DEFINE_SETTINGFACT(dtm)
    DEFINE_SETTINGFACT(orthophotoNoTiled)
    DEFINE_SETTINGFACT(demResolution)
    DEFINE_SETTINGFACT(meshSize)
    DEFINE_SETTINGFACT(forceGPS)
    DEFINE_SETTINGFACT(ignoreGsd)
    DEFINE_SETTINGFACT(buildOverviews)
    DEFINE_SETTINGFACT(opensfmDense)
    DEFINE_SETTINGFACT(opensfmDepthmapMinConsistentViews)
    DEFINE_SETTINGFACT(texturingSkipLocalSeamLeveling)
    DEFINE_SETTINGFACT(texturingKeepUnseenFaces)
    DEFINE_SETTINGFACT(debug)
    DEFINE_SETTINGFACT(useExif)
    DEFINE_SETTINGFACT(meshSamples)
    DEFINE_SETTINGFACT(pcSample)
    DEFINE_SETTINGFACT(matcherDistance)
    DEFINE_SETTINGFACT(splitOverlap)
    DEFINE_SETTINGFACT(demDecimation)
    DEFINE_SETTINGFACT(orthophotoCutline)
    DEFINE_SETTINGFACT(pcFilter)
    DEFINE_SETTINGFACT(split)
    DEFINE_SETTINGFACT(fastOrthophoto)
    DEFINE_SETTINGFACT(pcEpt)
    DEFINE_SETTINGFACT(crop)
    DEFINE_SETTINGFACT(pcLas)
    DEFINE_SETTINGFACT(merge)
    DEFINE_SETTINGFACT(dsm)
    DEFINE_SETTINGFACT(demGapfillSteps)
    DEFINE_SETTINGFACT(meshPointWeight)
    DEFINE_SETTINGFACT(maxConcurrency)
    DEFINE_SETTINGFACT(texturingToneMapping)
    DEFINE_SETTINGFACT(demEuclidianMap)
    DEFINE_SETTINGFACT(cameraLens)
    DEFINE_SETTINGFACT(skip3dmodel)
    DEFINE_SETTINGFACT(matchNeighbours)
    DEFINE_SETTINGFACT(pcCsv)
    DEFINE_SETTINGFACT(endWith)
    DEFINE_SETTINGFACT(depthmapResolution)
    DEFINE_SETTINGFACT(texturingDataTerm)
    DEFINE_SETTINGFACT(texturingSkipVisibilityTest)
    DEFINE_SETTINGFACT(opensfmDepthmapMethod)
    DEFINE_SETTINGFACT(useFixedCameraParams)
    DEFINE_SETTINGFACT(smrfThreshold)
    DEFINE_SETTINGFACT(verbose)
    DEFINE_SETTINGFACT(useHybridBundleAdjustment)
    
   
    // Although this is a global setting it only affects ArduPilot vehicle since PX4 automatically starts the stream from the vehicle side
    DEFINE_SETTINGFACT(apmStartMavlinkStreams)

    Q_PROPERTY(QString missionSavePath      READ missionSavePath    NOTIFY savePathsChanged)
    Q_PROPERTY(QString parameterSavePath    READ parameterSavePath  NOTIFY savePathsChanged)
    Q_PROPERTY(QString telemetrySavePath    READ telemetrySavePath  NOTIFY savePathsChanged)
    Q_PROPERTY(QString logSavePath          READ logSavePath        NOTIFY savePathsChanged)
    Q_PROPERTY(QString videoSavePath        READ videoSavePath      NOTIFY savePathsChanged)
    Q_PROPERTY(QString crashSavePath        READ crashSavePath      NOTIFY savePathsChanged)

    Q_PROPERTY(QString planFileExtension        MEMBER planFileExtension        CONSTANT)
    Q_PROPERTY(QString missionFileExtension     MEMBER missionFileExtension     CONSTANT)
    Q_PROPERTY(QString waypointsFileExtension   MEMBER waypointsFileExtension   CONSTANT)
    Q_PROPERTY(QString parameterFileExtension   MEMBER parameterFileExtension   CONSTANT)
    Q_PROPERTY(QString telemetryFileExtension   MEMBER telemetryFileExtension   CONSTANT)
    Q_PROPERTY(QString kmlFileExtension         MEMBER kmlFileExtension         CONSTANT)
    Q_PROPERTY(QString shpFileExtension         MEMBER shpFileExtension         CONSTANT)
    Q_PROPERTY(QString logFileExtension         MEMBER logFileExtension         CONSTANT)

    QString missionSavePath     ();
    QString parameterSavePath   ();
    QString telemetrySavePath   ();
    QString logSavePath         ();
    QString videoSavePath       ();
    QString crashSavePath       ();

    static MAV_AUTOPILOT    offlineEditingFirmwareTypeFromFirmwareType  (MAV_AUTOPILOT firmwareType);
    static MAV_TYPE         offlineEditingVehicleTypeFromVehicleType    (MAV_TYPE vehicleType);

    // Application wide file extensions
    static const char* parameterFileExtension;
    static const char* planFileExtension;
    static const char* missionFileExtension;
    static const char* waypointsFileExtension;
    static const char* fenceFileExtension;
    static const char* rallyPointFileExtension;
    static const char* telemetryFileExtension;
    static const char* kmlFileExtension;
    static const char* shpFileExtension;
    static const char* logFileExtension;

    // Child directories of savePath for specific file types
    static const char* parameterDirectory;
    static const char* telemetryDirectory;
    static const char* missionDirectory;
    static const char* logDirectory;
    static const char* videoDirectory;
    static const char* crashDirectory;

signals:
    void savePathsChanged();

private slots:
    void _indoorPaletteChanged();
    void _checkSavePathDirectories();
    void _languageChanged();

private:
    QTranslator _QGCTranslator;

};

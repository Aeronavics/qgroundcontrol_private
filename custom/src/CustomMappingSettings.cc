/****************************************************************************
 *
 *   (c) 2009-2016 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "CustomMappingSettings.h"
#include "QGCPalette.h"
#include "QGCApplication.h"
#include "ParameterManager.h"

#include <QQmlEngine>
#include <QtQml>
#include <QStandardPaths>

DECLARE_SETTINGGROUP(CustomMapping, "Mapping")
{
    qmlRegisterUncreatableType<CustomMappingSettings>("CustomQuickInterface", 1, 0, "CustomMappingSettings", "Reference only");
}

DECLARE_SETTINGSFACT(CustomMappingSettings, server)
DECLARE_SETTINGSFACT(CustomMappingSettings, smrfScalar)
DECLARE_SETTINGSFACT(CustomMappingSettings, pcClassify)
DECLARE_SETTINGSFACT(CustomMappingSettings, opensfmDepthmapMinPatchSd)
DECLARE_SETTINGSFACT(CustomMappingSettings, username)
DECLARE_SETTINGSFACT(CustomMappingSettings, projectName)
DECLARE_SETTINGSFACT(CustomMappingSettings, taskName)
DECLARE_SETTINGSFACT(CustomMappingSettings, smrfWindow)
DECLARE_SETTINGSFACT(CustomMappingSettings, meshOctreeDepth)
DECLARE_SETTINGSFACT(CustomMappingSettings, minNumFeatures)
DECLARE_SETTINGSFACT(CustomMappingSettings, resizeTo)
DECLARE_SETTINGSFACT(CustomMappingSettings, smrfSlope)
DECLARE_SETTINGSFACT(CustomMappingSettings, rerunFrom)
DECLARE_SETTINGSFACT(CustomMappingSettings, use3dmesh)
DECLARE_SETTINGSFACT(CustomMappingSettings, orthophotoCompression)
DECLARE_SETTINGSFACT(CustomMappingSettings, mveConfidence)
DECLARE_SETTINGSFACT(CustomMappingSettings, texturingSkipHoleFilling)
DECLARE_SETTINGSFACT(CustomMappingSettings, texturingSkipGlobalSeamLeveling)
DECLARE_SETTINGSFACT(CustomMappingSettings, texturingNadirWeight)
DECLARE_SETTINGSFACT(CustomMappingSettings, texturingOutlierRemovalType)
DECLARE_SETTINGSFACT(CustomMappingSettings, othrophotoResolution)
DECLARE_SETTINGSFACT(CustomMappingSettings, dtm)
DECLARE_SETTINGSFACT(CustomMappingSettings, orthophotoNoTiled)
DECLARE_SETTINGSFACT(CustomMappingSettings, demResolution)
DECLARE_SETTINGSFACT(CustomMappingSettings, meshSize)
DECLARE_SETTINGSFACT(CustomMappingSettings, forceGPS)
DECLARE_SETTINGSFACT(CustomMappingSettings, ignoreGsd)
DECLARE_SETTINGSFACT(CustomMappingSettings, buildOverviews)
DECLARE_SETTINGSFACT(CustomMappingSettings, opensfmDense)
DECLARE_SETTINGSFACT(CustomMappingSettings, opensfmDepthmapMinConsistentViews)
DECLARE_SETTINGSFACT(CustomMappingSettings, texturingSkipLocalSeamLeveling)
DECLARE_SETTINGSFACT(CustomMappingSettings, texturingKeepUnseenFaces)
DECLARE_SETTINGSFACT(CustomMappingSettings, debug)
DECLARE_SETTINGSFACT(CustomMappingSettings, useExif)
DECLARE_SETTINGSFACT(CustomMappingSettings, meshSamples)
DECLARE_SETTINGSFACT(CustomMappingSettings, pcSample)
DECLARE_SETTINGSFACT(CustomMappingSettings, matcherDistance)
DECLARE_SETTINGSFACT(CustomMappingSettings, splitOverlap)
DECLARE_SETTINGSFACT(CustomMappingSettings, demDecimation)
DECLARE_SETTINGSFACT(CustomMappingSettings, orthophotoCutline)
DECLARE_SETTINGSFACT(CustomMappingSettings, pcFilter)
DECLARE_SETTINGSFACT(CustomMappingSettings, split)
DECLARE_SETTINGSFACT(CustomMappingSettings, fastOrthophoto)
DECLARE_SETTINGSFACT(CustomMappingSettings, pcEpt)
DECLARE_SETTINGSFACT(CustomMappingSettings, crop)
DECLARE_SETTINGSFACT(CustomMappingSettings, pcLas)
DECLARE_SETTINGSFACT(CustomMappingSettings, merge)
DECLARE_SETTINGSFACT(CustomMappingSettings, dsm)
DECLARE_SETTINGSFACT(CustomMappingSettings, demGapfillSteps)
DECLARE_SETTINGSFACT(CustomMappingSettings, meshPointWeight)
DECLARE_SETTINGSFACT(CustomMappingSettings, maxConcurrency)
DECLARE_SETTINGSFACT(CustomMappingSettings, texturingToneMapping)
DECLARE_SETTINGSFACT(CustomMappingSettings, demEuclidianMap)
DECLARE_SETTINGSFACT(CustomMappingSettings, cameraLens)
DECLARE_SETTINGSFACT(CustomMappingSettings, skip3dmodel)
DECLARE_SETTINGSFACT(CustomMappingSettings, matchNeighbours)
DECLARE_SETTINGSFACT(CustomMappingSettings, pcCsv)
DECLARE_SETTINGSFACT(CustomMappingSettings, endWith)
DECLARE_SETTINGSFACT(CustomMappingSettings, depthmapResolution)
DECLARE_SETTINGSFACT(CustomMappingSettings, texturingDataTerm)
DECLARE_SETTINGSFACT(CustomMappingSettings, texturingSkipVisibilityTest)
DECLARE_SETTINGSFACT(CustomMappingSettings, opensfmDepthmapMethod)
DECLARE_SETTINGSFACT(CustomMappingSettings, useFixedCameraParams)
DECLARE_SETTINGSFACT(CustomMappingSettings, smrfThreshold)
DECLARE_SETTINGSFACT(CustomMappingSettings, verbose)
DECLARE_SETTINGSFACT(CustomMappingSettings, useHybridBundleAdjustment)
DECLARE_SETTINGSFACT(CustomMappingSettings, processingPresets)

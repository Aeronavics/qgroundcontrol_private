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

DECLARE_SETTINGGROUP(Mapping, "Mapping")
{
    qmlRegisterUncreatableType<MappingSettings>("CustomMappingSettings", 1, 0, "MappingSettings", "Reference only");
}

DECLARE_SETTINGSFACT(MappingSettings, smrfScalar)
DECLARE_SETTINGSFACT(MappingSettings, pcClassify)
DECLARE_SETTINGSFACT(MappingSettings, opensfmDepthmapMinPatchSd)
DECLARE_SETTINGSFACT(MappingSettings, email)
DECLARE_SETTINGSFACT(MappingSettings, projectName)
DECLARE_SETTINGSFACT(MappingSettings, taskName)
DECLARE_SETTINGSFACT(MappingSettings, smrfWindow)
DECLARE_SETTINGSFACT(MappingSettings, meshOctreeDepth)
DECLARE_SETTINGSFACT(MappingSettings, minNumFeatures)
DECLARE_SETTINGSFACT(MappingSettings, resizeTo)
DECLARE_SETTINGSFACT(MappingSettings, smrfSlope)
DECLARE_SETTINGSFACT(MappingSettings, rerunFrom)
DECLARE_SETTINGSFACT(MappingSettings, use3dmesh)
DECLARE_SETTINGSFACT(MappingSettings, orthophotoCompression)
DECLARE_SETTINGSFACT(MappingSettings, mveConfidence)
DECLARE_SETTINGSFACT(MappingSettings, texturingSkipHoleFilling)
DECLARE_SETTINGSFACT(MappingSettings, texturingSkipGlobalSeamLeveling)
DECLARE_SETTINGSFACT(MappingSettings, texturingNadirWeight)
DECLARE_SETTINGSFACT(MappingSettings, texturingOutlierRemovalType)
DECLARE_SETTINGSFACT(MappingSettings, othrophotoResolution)
DECLARE_SETTINGSFACT(MappingSettings, dtm)
DECLARE_SETTINGSFACT(MappingSettings, orthophotoNoTiled)
DECLARE_SETTINGSFACT(MappingSettings, demResolution)
DECLARE_SETTINGSFACT(MappingSettings, meshSize)
DECLARE_SETTINGSFACT(MappingSettings, forceGPS)
DECLARE_SETTINGSFACT(MappingSettings, ignoreGsd)
DECLARE_SETTINGSFACT(MappingSettings, buildOverviews)
DECLARE_SETTINGSFACT(MappingSettings, opensfmDense)
DECLARE_SETTINGSFACT(MappingSettings, opensfmDepthmapMinConsistentViews)
DECLARE_SETTINGSFACT(MappingSettings, texturingSkipLocalSeamLeveling)
DECLARE_SETTINGSFACT(MappingSettings, texturingKeepUnseenFaces)
DECLARE_SETTINGSFACT(MappingSettings, debug)
DECLARE_SETTINGSFACT(MappingSettings, useExif)
DECLARE_SETTINGSFACT(MappingSettings, meshSamples)
DECLARE_SETTINGSFACT(MappingSettings, pcSample)
DECLARE_SETTINGSFACT(MappingSettings, matcherDistance)
DECLARE_SETTINGSFACT(MappingSettings, splitOverlap)
DECLARE_SETTINGSFACT(MappingSettings, demDecimation)
DECLARE_SETTINGSFACT(MappingSettings, orthophotoCutline)
DECLARE_SETTINGSFACT(MappingSettings, pcFilter)
DECLARE_SETTINGSFACT(MappingSettings, split)
DECLARE_SETTINGSFACT(MappingSettings, fastOrthophoto)
DECLARE_SETTINGSFACT(MappingSettings, pcEpt)
DECLARE_SETTINGSFACT(MappingSettings, crop)
DECLARE_SETTINGSFACT(MappingSettings, pcLas)
DECLARE_SETTINGSFACT(MappingSettings, merge)
DECLARE_SETTINGSFACT(MappingSettings, dsm)
DECLARE_SETTINGSFACT(MappingSettings, demGapfillSteps)
DECLARE_SETTINGSFACT(MappingSettings, meshPointWeight)
DECLARE_SETTINGSFACT(MappingSettings, maxConcurrency)
DECLARE_SETTINGSFACT(MappingSettings, texturingToneMapping)
DECLARE_SETTINGSFACT(MappingSettings, demEuclidianMap)
DECLARE_SETTINGSFACT(MappingSettings, cameraLens)
DECLARE_SETTINGSFACT(MappingSettings, skip3dmodel)
DECLARE_SETTINGSFACT(MappingSettings, matchNeighbours)
DECLARE_SETTINGSFACT(MappingSettings, pcCsv)
DECLARE_SETTINGSFACT(MappingSettings, endWith)
DECLARE_SETTINGSFACT(MappingSettings, depthmapResolution)
DECLARE_SETTINGSFACT(MappingSettings, texturingDataTerm)
DECLARE_SETTINGSFACT(MappingSettings, texturingSkipVisibilityTest)
DECLARE_SETTINGSFACT(MappingSettings, opensfmDepthmapMethod)
DECLARE_SETTINGSFACT(MappingSettings, useFixedCameraParams)
DECLARE_SETTINGSFACT(MappingSettings, smrfThreshold)
DECLARE_SETTINGSFACT(MappingSettings, verbose)
DECLARE_SETTINGSFACT(MappingSettings, useHybridBundleAdjustment)
DECLARE_SETTINGSFACT(MappingSettings, processingPresets)

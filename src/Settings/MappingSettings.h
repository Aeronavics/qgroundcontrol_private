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

class MappingSettings : public SettingsGroup
{
    Q_OBJECT

public:
    MappingSettings(QObject* parent = nullptr);

    DEFINE_SETTING_NAME_GROUP()

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
};

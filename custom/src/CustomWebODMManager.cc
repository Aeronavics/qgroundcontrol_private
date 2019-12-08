
#include "QGCApplication.h"
#include "SettingsManager.h"

#include "CustomWebODMManager.h"
#include "CustomPlugin.h"


#include <QJsonDocument>
#include <QJsonObject>
#include <QSettings>
#include <QCryptographicHash> 

#include <curl/curl.h>
#include <fcntl.h>
#include <iostream>
#include <iomanip>
#include <sstream>
#include <stdio.h>
#include <string>
#include <sys/stat.h>

using namespace std;

static const char* kCustomWebODMGroup     = "CustomWebODMGroup";
static const char* kPassword            = "Password";

//-----------------------------------------------------------------------------
void CustomWebODMManager::init() {
    //-- Get saved settings
    QSettings settings;
    settings.beginGroup(kCustomWebODMGroup);
    _password =
        settings.value(kPassword, QString("")).toString();
}

static size_t WriteCallback(void* contents, size_t size, size_t nmemb,
                            void* userp) {
    ((std::string*)userp)->append((char*)contents, size * nmemb);
    return size * nmemb;
}



//-----------------------------------------------------------------------------
long CustomWebODMManager::queryLoginCredientials(std::string email, std::string password) {

    std::string body = "email=" + email +"&password=" + password; 
    CURL *hnd;

    std::string readBuffer;

    hnd = curl_easy_init();
    curl_easy_setopt(hnd, CURLOPT_BUFFERSIZE, 102400L);
    curl_easy_setopt(hnd, CURLOPT_URL, "http://localhost:5000/");
    curl_easy_setopt(hnd, CURLOPT_NOPROGRESS, 1L);
    curl_easy_setopt(hnd, CURLOPT_POSTFIELDS, body.c_str());
    curl_easy_setopt(hnd, CURLOPT_USERAGENT, "curl/7.58.0");
    curl_easy_setopt(hnd, CURLOPT_MAXREDIRS, 50L);
    curl_easy_setopt(hnd, CURLOPT_HTTP_VERSION, (long)CURL_HTTP_VERSION_2TLS);
    curl_easy_setopt(hnd, CURLOPT_CUSTOMREQUEST, "POST");
    curl_easy_setopt(hnd, CURLOPT_TCP_KEEPALIVE, 1L);
    curl_easy_setopt(hnd, CURLOPT_WRITEFUNCTION, WriteCallback);
    curl_easy_setopt(hnd, CURLOPT_WRITEDATA, &readBuffer);

    curl_easy_perform(hnd);
    long http_code = 0;
    curl_easy_getinfo(hnd, CURLINFO_RESPONSE_CODE, &http_code);

    curl_easy_cleanup(hnd);
    hnd = NULL;
    
    return http_code;
}

std::string CustomWebODMManager::getOptions(){
    std::string options = "[";
    if (qgcApp()) {
        QGCToolbox* toolbox = qgcApp()->toolbox();
        // Be careful of toolbox not being open yet
        if (toolbox) {
            bool pcClassify = qgcApp()->toolbox()->settingsManager()->mappingSettings()->pcClassify()->rawValue().toBool();
            double smrfScalar = qgcApp()->toolbox()->settingsManager()->mappingSettings()->smrfScalar()->rawValue().toDouble();
            double opensfmDepthmapMinPatchSd = qgcApp()->toolbox()->settingsManager()->mappingSettings()->opensfmDepthmapMinPatchSd()->rawValue().toDouble();
            double smrfWindow = qgcApp()->toolbox()->settingsManager()->mappingSettings()->smrfWindow()->rawValue().toDouble();
            int meshOctreeDepth = qgcApp()->toolbox()->settingsManager()->mappingSettings()->meshOctreeDepth()->rawValue().toInt();
            int minNumFeatures = qgcApp()->toolbox()->settingsManager()->mappingSettings()->minNumFeatures()->rawValue().toInt();
            int resizeTo = qgcApp()->toolbox()->settingsManager()->mappingSettings()->resizeTo()->rawValue().toInt();
            double smrfSlope = qgcApp()->toolbox()->settingsManager()->mappingSettings()->smrfSlope()->rawValue().toDouble();
            int rerunFrom = qgcApp()->toolbox()->settingsManager()->mappingSettings()->rerunFrom()->enumIndex();
            bool use3dmesh = qgcApp()->toolbox()->settingsManager()->mappingSettings()->use3dmesh()->rawValue().toBool();
            int orthophotoCompression = qgcApp()->toolbox()->settingsManager()->mappingSettings()->orthophotoCompression()->enumIndex();
            double mveConfidence = qgcApp()->toolbox()->settingsManager()->mappingSettings()->mveConfidence()->rawValue().toDouble();
            bool texturingSkipHoleFilling = qgcApp()->toolbox()->settingsManager()->mappingSettings()->texturingSkipHoleFilling()->rawValue().toBool();
            bool texturingSkipGlobalSeamLeveling = qgcApp()->toolbox()->settingsManager()->mappingSettings()->texturingSkipGlobalSeamLeveling()->rawValue().toBool();
            int texturingNadirWeight = qgcApp()->toolbox()->settingsManager()->mappingSettings()->texturingNadirWeight()->rawValue().toInt();
            int texturingOutlierRemovalType = qgcApp()->toolbox()->settingsManager()->mappingSettings()->texturingOutlierRemovalType()->enumIndex();
            double othrophotoResolution = qgcApp()->toolbox()->settingsManager()->mappingSettings()->othrophotoResolution()->rawValue().toDouble();
            bool dtm = qgcApp()->toolbox()->settingsManager()->mappingSettings()->dtm()->rawValue().toBool();
            bool orthophotoNoTiled = qgcApp()->toolbox()->settingsManager()->mappingSettings()->orthophotoNoTiled()->rawValue().toBool();
            double demResolution = qgcApp()->toolbox()->settingsManager()->mappingSettings()->demResolution()->rawValue().toDouble();
            int meshSize = qgcApp()->toolbox()->settingsManager()->mappingSettings()->meshSize()->rawValue().toInt();
            bool forceGPS = qgcApp()->toolbox()->settingsManager()->mappingSettings()->forceGPS()->rawValue().toBool();
            bool ignoreGsd = qgcApp()->toolbox()->settingsManager()->mappingSettings()->ignoreGsd()->rawValue().toBool();
            bool buildOverviews = qgcApp()->toolbox()->settingsManager()->mappingSettings()->buildOverviews()->rawValue().toBool();
            bool opensfmDense = qgcApp()->toolbox()->settingsManager()->mappingSettings()->opensfmDense()->rawValue().toBool();
            int opensfmDepthmapMinConsistentViews = qgcApp()->toolbox()->settingsManager()->mappingSettings()->opensfmDepthmapMinConsistentViews()->rawValue().toInt();
            bool texturingSkipLocalSeamLeveling = qgcApp()->toolbox()->settingsManager()->mappingSettings()->texturingSkipLocalSeamLeveling()->rawValue().toBool();
            bool texturingKeepUnseenFaces = qgcApp()->toolbox()->settingsManager()->mappingSettings()->texturingKeepUnseenFaces()->rawValue().toBool();
            bool debug = qgcApp()->toolbox()->settingsManager()->mappingSettings()->debug()->rawValue().toBool();
            bool useExif = qgcApp()->toolbox()->settingsManager()->mappingSettings()->useExif()->rawValue().toBool();
            double meshSamples = qgcApp()->toolbox()->settingsManager()->mappingSettings()->meshSamples()->rawValue().toDouble();
            int pcSample = qgcApp()->toolbox()->settingsManager()->mappingSettings()->pcSample()->rawValue().toInt();
            int matcherDistance = qgcApp()->toolbox()->settingsManager()->mappingSettings()->matcherDistance()->rawValue().toInt();
            int splitOverlap = qgcApp()->toolbox()->settingsManager()->mappingSettings()->splitOverlap()->rawValue().toInt();
            int demDecimation = qgcApp()->toolbox()->settingsManager()->mappingSettings()->demDecimation()->rawValue().toInt();
            bool orthophotoCutline = qgcApp()->toolbox()->settingsManager()->mappingSettings()->orthophotoCutline()->rawValue().toBool();
            double pcFilter = qgcApp()->toolbox()->settingsManager()->mappingSettings()->pcFilter()->rawValue().toDouble();
            int split = qgcApp()->toolbox()->settingsManager()->mappingSettings()->split()->rawValue().toInt();
            bool fastOrthophoto = qgcApp()->toolbox()->settingsManager()->mappingSettings()->fastOrthophoto()->rawValue().toBool();
            bool pcEpt = qgcApp()->toolbox()->settingsManager()->mappingSettings()->pcEpt()->rawValue().toBool();
            double crop = qgcApp()->toolbox()->settingsManager()->mappingSettings()->crop()->rawValue().toDouble();
            bool pcLas = qgcApp()->toolbox()->settingsManager()->mappingSettings()->pcLas()->rawValue().toBool();
            int merge = qgcApp()->toolbox()->settingsManager()->mappingSettings()->merge()->enumIndex();
            bool dsm = qgcApp()->toolbox()->settingsManager()->mappingSettings()->dsm()->rawValue().toBool();
            int demGapfillSteps = qgcApp()->toolbox()->settingsManager()->mappingSettings()->demGapfillSteps()->rawValue().toInt();
            double meshPointWeight = qgcApp()->toolbox()->settingsManager()->mappingSettings()->meshPointWeight()->rawValue().toDouble();
            int maxConcurrency = qgcApp()->toolbox()->settingsManager()->mappingSettings()->maxConcurrency()->rawValue().toInt();
            int texturingToneMapping = qgcApp()->toolbox()->settingsManager()->mappingSettings()->texturingToneMapping()->enumIndex();
            bool demEuclidianMap = qgcApp()->toolbox()->settingsManager()->mappingSettings()->demEuclidianMap()->rawValue().toBool();
            int cameraLens = qgcApp()->toolbox()->settingsManager()->mappingSettings()->cameraLens()->enumIndex();
            bool skip3dmodel = qgcApp()->toolbox()->settingsManager()->mappingSettings()->skip3dmodel()->rawValue().toBool();
            int matchNeighbours = qgcApp()->toolbox()->settingsManager()->mappingSettings()->matchNeighbours()->rawValue().toInt();
            bool pcCsv = qgcApp()->toolbox()->settingsManager()->mappingSettings()->pcCsv()->rawValue().toBool();
            int endWith = qgcApp()->toolbox()->settingsManager()->mappingSettings()->endWith()->enumIndex();
            double depthmapResolution = qgcApp()->toolbox()->settingsManager()->mappingSettings()->depthmapResolution()->rawValue().toDouble();
            int texturingDataTerm = qgcApp()->toolbox()->settingsManager()->mappingSettings()->texturingDataTerm()->enumIndex();
            bool texturingSkipVisibilityTest = qgcApp()->toolbox()->settingsManager()->mappingSettings()->texturingSkipVisibilityTest()->rawValue().toBool();
            int opensfmDepthmapMethod = qgcApp()->toolbox()->settingsManager()->mappingSettings()->opensfmDepthmapMethod()->enumIndex();
            bool useFixedCameraParams = qgcApp()->toolbox()->settingsManager()->mappingSettings()->useFixedCameraParams()->rawValue().toBool();
            double smrfThreshold = qgcApp()->toolbox()->settingsManager()->mappingSettings()->smrfThreshold()->rawValue().toDouble();
            bool verbose = qgcApp()->toolbox()->settingsManager()->mappingSettings()->verbose()->rawValue().toBool();
            bool useHybridBundleAdjustment = qgcApp()->toolbox()->settingsManager()->mappingSettings()->useHybridBundleAdjustment()->rawValue().toBool();




            if (pcClassify != qgcApp()->toolbox()->settingsManager()->mappingSettings()->pcClassify()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'pc-classify', 'value':'true'}";
            }
            if (smrfScalar != qgcApp()->toolbox()->settingsManager()->mappingSettings()->smrfScalar()->rawDefaultValue().toDouble()) {
                if (options != "[") { options += ","; }
                std::stringstream stream;
                stream << std::fixed << std::setprecision(2) << smrfScalar;
                options += "{'name':'smrf-scalar', 'value':" + stream.str() + "}";
            }
            if (opensfmDepthmapMinPatchSd != qgcApp()->toolbox()->settingsManager()->mappingSettings()->opensfmDepthmapMinPatchSd()->rawDefaultValue().toDouble()) {
                if (options != "[") { options += ","; }
                options += "{'name':'opensfm-depthmap-min-patch-sd', 'value':" + std::to_string(opensfmDepthmapMinPatchSd) + "}";
            }
            if (smrfWindow != qgcApp()->toolbox()->settingsManager()->mappingSettings()->smrfWindow()->rawDefaultValue().toDouble()) {
                if (options != "[") { options += ","; }
                options += "{'name':'smrf-window', 'value':" + std::to_string(smrfWindow) + "}";
            }
            if (meshOctreeDepth != qgcApp()->toolbox()->settingsManager()->mappingSettings()->meshOctreeDepth()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'mesh-octree-depth', 'value':" + std::to_string(meshOctreeDepth) + "}";
            }
            if (minNumFeatures != qgcApp()->toolbox()->settingsManager()->mappingSettings()->minNumFeatures()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'min-num-features', 'value':" + std::to_string(minNumFeatures) + "}";
            }
            if (resizeTo != qgcApp()->toolbox()->settingsManager()->mappingSettings()->resizeTo()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'resize-to', 'value':" + std::to_string(resizeTo) + "}";
            }
            if (smrfSlope != qgcApp()->toolbox()->settingsManager()->mappingSettings()->smrfSlope()->rawDefaultValue().toDouble()) {
                if (options != "[") { options += ","; }
                options += "{'name':'smrf-slope', 'value':" + std::to_string(smrfSlope) + "}";
            }
            if (rerunFrom != qgcApp()->toolbox()->settingsManager()->mappingSettings()->rerunFrom()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'rerun-from', 'value':'" + qgcApp()->toolbox()->settingsManager()->mappingSettings()->rerunFrom()->enumStringValue().toStdString() + "'}";
            }
            if (use3dmesh != qgcApp()->toolbox()->settingsManager()->mappingSettings()->use3dmesh()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'use-3dmesh', 'value':'true'}";
            }
            if (orthophotoCompression != qgcApp()->toolbox()->settingsManager()->mappingSettings()->orthophotoCompression()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'orthophoto-compression', 'value':'" + qgcApp()->toolbox()->settingsManager()->mappingSettings()->orthophotoCompression()->enumStringValue().toStdString() + "'}";
            }
            if (mveConfidence != qgcApp()->toolbox()->settingsManager()->mappingSettings()->mveConfidence()->rawDefaultValue().toDouble()) {
                if (options != "[") { options += ","; }
                options += "{'name':'mve-confidence', 'value':" + std::to_string(mveConfidence) + "}";
            }
            if (texturingSkipHoleFilling != qgcApp()->toolbox()->settingsManager()->mappingSettings()->texturingSkipHoleFilling()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'texturing-skip-hole-filling', 'value':'true'}";
            }
            if (texturingSkipGlobalSeamLeveling != qgcApp()->toolbox()->settingsManager()->mappingSettings()->texturingSkipGlobalSeamLeveling()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'texturing-skip-global-seam-leveling', 'value':'true'}";
            }
            if (texturingNadirWeight != qgcApp()->toolbox()->settingsManager()->mappingSettings()->texturingNadirWeight()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'texturing-nadir-weight', 'value':" + std::to_string(texturingNadirWeight) + "}";
            }
            if (texturingOutlierRemovalType != qgcApp()->toolbox()->settingsManager()->mappingSettings()->texturingOutlierRemovalType()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'texturing-outlier-removal-type', 'value':'" + qgcApp()->toolbox()->settingsManager()->mappingSettings()->texturingOutlierRemovalType()->enumStringValue().toStdString() + "'}";
            }
            if (othrophotoResolution != qgcApp()->toolbox()->settingsManager()->mappingSettings()->othrophotoResolution()->rawDefaultValue().toDouble()) {
                if (options != "[") { options += ","; }
                options += "{'name':'orthophoto-resolution', 'value':" + std::to_string(othrophotoResolution) + "}";
            }
            if (dtm != qgcApp()->toolbox()->settingsManager()->mappingSettings()->dtm()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'dtm', 'value':'true'}";
            }
            if (orthophotoNoTiled != qgcApp()->toolbox()->settingsManager()->mappingSettings()->orthophotoNoTiled()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'orthophoto-no-tiled', 'value':'true'}";
            }
            if (demResolution != qgcApp()->toolbox()->settingsManager()->mappingSettings()->demResolution()->rawDefaultValue().toDouble()) {
                if (options != "[") { options += ","; }
                options += "{'name':'dem-resolution ', 'value':" + std::to_string(demResolution) + "}";
            }
            if (meshSize != qgcApp()->toolbox()->settingsManager()->mappingSettings()->meshSize()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'mesh-size', 'value':" + std::to_string(meshSize) + "}";
            }
            if (forceGPS != qgcApp()->toolbox()->settingsManager()->mappingSettings()->forceGPS()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'force-gps', 'value':'true'}";
            }
            if (ignoreGsd != qgcApp()->toolbox()->settingsManager()->mappingSettings()->ignoreGsd()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'ignore-gsd', 'value':'true'}";
            }
            if (buildOverviews != qgcApp()->toolbox()->settingsManager()->mappingSettings()->buildOverviews()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'build-overviews', 'value':'true'}";
            }
            if (opensfmDense != qgcApp()->toolbox()->settingsManager()->mappingSettings()->opensfmDense()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'use-opensfm-dense', 'value':'true'}";
            }
            if (opensfmDepthmapMinConsistentViews != qgcApp()->toolbox()->settingsManager()->mappingSettings()->opensfmDepthmapMinConsistentViews()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'opensfm-depthmap-min-consistent-views', 'value':" + std::to_string(opensfmDepthmapMinConsistentViews) + "}";
            }
            if (texturingSkipLocalSeamLeveling != qgcApp()->toolbox()->settingsManager()->mappingSettings()->texturingSkipLocalSeamLeveling()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'texturing-skip-local-seam-leveling', 'value':'true'}";
            }
            if (texturingKeepUnseenFaces != qgcApp()->toolbox()->settingsManager()->mappingSettings()->texturingKeepUnseenFaces()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'texturing-keep-unseen-faces', 'value':'true'}";
            }
            if (debug != qgcApp()->toolbox()->settingsManager()->mappingSettings()->debug()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'debug', 'value':'true'}";
            }
            if (useExif != qgcApp()->toolbox()->settingsManager()->mappingSettings()->useExif()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'use-exif', 'value':'true'}";
            }
            if (meshSamples != qgcApp()->toolbox()->settingsManager()->mappingSettings()->meshSamples()->rawDefaultValue().toDouble()) {
                if (options != "[") { options += ","; }
                options += "{'name':'mesh-samples', 'value':" + std::to_string(meshSamples) + "}";
            }
            if (pcSample != qgcApp()->toolbox()->settingsManager()->mappingSettings()->pcSample()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'pc-sample', 'value':" + std::to_string(pcSample) + "}";
            }
            if (matcherDistance != qgcApp()->toolbox()->settingsManager()->mappingSettings()->matcherDistance()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'matcher-distance', 'value':" + std::to_string(matcherDistance) + "}";
            }
            if (splitOverlap != qgcApp()->toolbox()->settingsManager()->mappingSettings()->splitOverlap()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'split-overlap', 'value':" + std::to_string(splitOverlap) + "}";
            }
            if (demDecimation != qgcApp()->toolbox()->settingsManager()->mappingSettings()->demDecimation()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'dem-decimation', 'value':" + std::to_string(demDecimation) + "}";
            }
            if (orthophotoCutline != qgcApp()->toolbox()->settingsManager()->mappingSettings()->orthophotoCutline()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'orthophoto-cutline', 'value':'true'}";
            }
            if (pcFilter != qgcApp()->toolbox()->settingsManager()->mappingSettings()->pcFilter()->rawDefaultValue().toDouble()) {
                if (options != "[") { options += ","; }
                options += "{'name':'pc-filter', 'value':" + std::to_string(pcFilter) + "}";
            }
            if (split != qgcApp()->toolbox()->settingsManager()->mappingSettings()->split()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'split', 'value':" + std::to_string(split) + "}";
            }
            if (fastOrthophoto != qgcApp()->toolbox()->settingsManager()->mappingSettings()->fastOrthophoto()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'fast-orthophoto', 'value':'true'}";
            }
            if (pcEpt != qgcApp()->toolbox()->settingsManager()->mappingSettings()->pcEpt()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'pc-ept', 'value':'true'}";
            }
            if (crop != qgcApp()->toolbox()->settingsManager()->mappingSettings()->crop()->rawDefaultValue().toDouble()) {
                if (options != "[") { options += ","; }
                options += "{'name':'crop', 'value':" + std::to_string(crop) + "}";
            }
            if (pcLas != qgcApp()->toolbox()->settingsManager()->mappingSettings()->pcLas()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'pc-las', 'value':'true'}";
            }
            if (merge != qgcApp()->toolbox()->settingsManager()->mappingSettings()->merge()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'merge', 'value':'" + qgcApp()->toolbox()->settingsManager()->mappingSettings()->merge()->enumStringValue().toStdString() + "'}";
            }
            if (dsm != qgcApp()->toolbox()->settingsManager()->mappingSettings()->dsm()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'dsm', 'value':'true'}";
            }
            if (demGapfillSteps != qgcApp()->toolbox()->settingsManager()->mappingSettings()->demGapfillSteps()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'dem-gapfill-steps', 'value':" + std::to_string(demGapfillSteps) + "}";
            }
            if (meshPointWeight != qgcApp()->toolbox()->settingsManager()->mappingSettings()->meshPointWeight()->rawDefaultValue().toDouble()) {
                if (options != "[") { options += ","; }
                options += "{'name':'mesh-point-weight', 'value':" + std::to_string(meshPointWeight) + "}";
            }
            if (maxConcurrency != qgcApp()->toolbox()->settingsManager()->mappingSettings()->maxConcurrency()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'max-concurrency', 'value':" + std::to_string(maxConcurrency) + "}";
            }
            if (texturingToneMapping != qgcApp()->toolbox()->settingsManager()->mappingSettings()->texturingToneMapping()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'texturing-tone-mapping', 'value':'" + qgcApp()->toolbox()->settingsManager()->mappingSettings()->texturingToneMapping()->enumStringValue().toStdString() + "'}";
            }
            if (demEuclidianMap != qgcApp()->toolbox()->settingsManager()->mappingSettings()->demEuclidianMap()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'dem-euclidean-map', 'value':'true'}";
            }
            if (cameraLens != qgcApp()->toolbox()->settingsManager()->mappingSettings()->cameraLens()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'camera-lens', 'value':'" + qgcApp()->toolbox()->settingsManager()->mappingSettings()->cameraLens()->enumStringValue().toStdString() + "'}";
            }
            if (skip3dmodel != qgcApp()->toolbox()->settingsManager()->mappingSettings()->skip3dmodel()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'skip-3dmodel', 'value':'true'}";
            }
            if (matchNeighbours != qgcApp()->toolbox()->settingsManager()->mappingSettings()->matchNeighbours()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'matcher-neighbors', 'value':" + std::to_string(matchNeighbours) + "}";
            }
            if (pcCsv != qgcApp()->toolbox()->settingsManager()->mappingSettings()->pcCsv()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'pc-csv', 'value':'true'}";
            }
            if (endWith != qgcApp()->toolbox()->settingsManager()->mappingSettings()->endWith()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'end-with', 'value':'" + qgcApp()->toolbox()->settingsManager()->mappingSettings()->endWith()->enumStringValue().toStdString() + "'}";
            }
            if (depthmapResolution != qgcApp()->toolbox()->settingsManager()->mappingSettings()->depthmapResolution()->rawDefaultValue().toDouble()) {
                if (options != "[") { options += ","; }
                options += "{'name':'depthmap-resolution', 'value':" + std::to_string(depthmapResolution) + "}";
            }
            if (texturingDataTerm != qgcApp()->toolbox()->settingsManager()->mappingSettings()->texturingDataTerm()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'texturing-data-term', 'value':'" + qgcApp()->toolbox()->settingsManager()->mappingSettings()->texturingDataTerm()->enumStringValue().toStdString() + "'}";
            }
            if (texturingSkipVisibilityTest != qgcApp()->toolbox()->settingsManager()->mappingSettings()->texturingSkipVisibilityTest()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'texturing-skip-visibility-test', 'value':'true'}";
            }
            if (opensfmDepthmapMethod != qgcApp()->toolbox()->settingsManager()->mappingSettings()->opensfmDepthmapMethod()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'opensfm-depthmap-method', 'value':'" + qgcApp()->toolbox()->settingsManager()->mappingSettings()->opensfmDepthmapMethod()->enumStringValue().toStdString() + "'}";
            }
            if (useFixedCameraParams != qgcApp()->toolbox()->settingsManager()->mappingSettings()->useFixedCameraParams()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'use-fixed-camera-params', 'value':'true'}";
            }
            if (smrfThreshold != qgcApp()->toolbox()->settingsManager()->mappingSettings()->smrfThreshold()->rawDefaultValue().toDouble()) {
                if (options != "[") { options += ","; }
                options += "{'name':'smrf-threshold', 'value':" + std::to_string(smrfThreshold) + "}";
            }
            if (verbose != qgcApp()->toolbox()->settingsManager()->mappingSettings()->verbose()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'verbose', 'value':'true'}";
            }
            if (useHybridBundleAdjustment != qgcApp()->toolbox()->settingsManager()->mappingSettings()->useHybridBundleAdjustment()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'use-hybrid-bundle-adjustment', 'value':'true'}";
            }
        }
    }
    options += "]";
    return options;
} 

long CustomWebODMManager::createTask(std::string password){
    std::string options = getOptions();
    std::string email = "";
    std::string projectName = "";
    std::string taskName = "";
    if (qgcApp()) {
        QGCToolbox* toolbox = qgcApp()->toolbox();
        // Be careful of toolbox not being open yet
        if (toolbox) {
            email = qgcApp()->toolbox()->settingsManager()->mappingSettings()->email()->rawValueString().toStdString();
            projectName = qgcApp()->toolbox()->settingsManager()->mappingSettings()->projectName()->rawValueString().toStdString();
            taskName = qgcApp()->toolbox()->settingsManager()->mappingSettings()->taskName()->rawValueString().toStdString();
        }
    }
    std::string body = "email=" + email +"&password=" + password + "&options=" + options;
    if (projectName != "") { body += "&projectName=" + projectName; }
    if (taskName != "") { body += "&taskName=" + taskName; }
    
    CURL *hnd;

    std::string readBuffer;

    hnd = curl_easy_init();
    curl_easy_setopt(hnd, CURLOPT_BUFFERSIZE, 102400L);
    curl_easy_setopt(hnd, CURLOPT_URL, "http://localhost:5000/task");
    curl_easy_setopt(hnd, CURLOPT_NOPROGRESS, 1L);
    curl_easy_setopt(hnd, CURLOPT_POSTFIELDS, body.c_str());
    curl_easy_setopt(hnd, CURLOPT_USERAGENT, "curl/7.58.0");
    curl_easy_setopt(hnd, CURLOPT_MAXREDIRS, 50L);
    curl_easy_setopt(hnd, CURLOPT_HTTP_VERSION, (long)CURL_HTTP_VERSION_2TLS);
    curl_easy_setopt(hnd, CURLOPT_CUSTOMREQUEST, "POST");
    curl_easy_setopt(hnd, CURLOPT_TCP_KEEPALIVE, 1L);
    curl_easy_setopt(hnd, CURLOPT_WRITEFUNCTION, WriteCallback);
    curl_easy_setopt(hnd, CURLOPT_WRITEDATA, &readBuffer);

    curl_easy_perform(hnd);
    long http_code = 0;
    curl_easy_getinfo(hnd, CURLINFO_RESPONSE_CODE, &http_code);

    curl_easy_cleanup(hnd);
    hnd = NULL;

    long taskId = 0;
    
    taskId = atol(readBuffer.substr(6,15).c_str());
    return taskId;
}


long CustomWebODMManager::postImages(long taskId, std::string image){

    CURL *hnd;
    struct curl_httppost *post1;
    struct curl_httppost *postend;

    std::string readBuffer;
    std::string url = std::string("http://localhost:5000/task/") + std::to_string(taskId);
    post1 = NULL;
    postend = NULL;
    curl_formadd(&post1, &postend,
               CURLFORM_COPYNAME, "images",
               CURLFORM_FILE, image.c_str(),
               CURLFORM_CONTENTTYPE, "image/jpeg",
               CURLFORM_END);

    hnd = curl_easy_init();
    curl_easy_setopt(hnd, CURLOPT_URL, url.c_str());
    curl_easy_setopt(hnd, CURLOPT_NOPROGRESS, 1L);
    curl_easy_setopt(hnd, CURLOPT_HTTPPOST, post1);
    curl_easy_setopt(hnd, CURLOPT_USERAGENT, "curl/7.47.0");
    curl_easy_setopt(hnd, CURLOPT_MAXREDIRS, 50L);
    curl_easy_setopt(hnd, CURLOPT_CUSTOMREQUEST, "POST");
    curl_easy_setopt(hnd, CURLOPT_TCP_KEEPALIVE, 1L);
    curl_easy_setopt(hnd, CURLOPT_WRITEFUNCTION, WriteCallback);
    curl_easy_setopt(hnd, CURLOPT_WRITEDATA, &readBuffer);

    curl_easy_perform(hnd);
    curl_easy_cleanup(hnd);
    long http_code = 0;
    curl_easy_getinfo(hnd, CURLINFO_RESPONSE_CODE, &http_code);
    curl_formfree(post1);
    hnd = NULL;
    post1 = NULL;
        
    return http_code;
}

std::string CustomWebODMManager::startTask(long taskId){
    CURL *hnd;

    std::string readBuffer;

    std::string url = "http://localhost:5000/task/";
    url += std::to_string(taskId);
    url += "/start";
    
    hnd = curl_easy_init();
    curl_easy_setopt(hnd, CURLOPT_BUFFERSIZE, 102400L);
    curl_easy_setopt(hnd, CURLOPT_URL, url.c_str());
    curl_easy_setopt(hnd, CURLOPT_NOPROGRESS, 1L);
    curl_easy_setopt(hnd, CURLOPT_USERAGENT, "curl/7.58.0");
    curl_easy_setopt(hnd, CURLOPT_MAXREDIRS, 50L);
    curl_easy_setopt(hnd, CURLOPT_HTTP_VERSION, (long)CURL_HTTP_VERSION_2TLS);
    curl_easy_setopt(hnd, CURLOPT_CUSTOMREQUEST, "POST");
    curl_easy_setopt(hnd, CURLOPT_TCP_KEEPALIVE, 1L);
    curl_easy_setopt(hnd, CURLOPT_WRITEFUNCTION, WriteCallback);
    curl_easy_setopt(hnd, CURLOPT_WRITEDATA, &readBuffer);

    curl_easy_perform(hnd);
    long http_code = 0;
    curl_easy_getinfo(hnd, CURLINFO_RESPONSE_CODE, &http_code);
    curl_easy_cleanup(hnd);
    hnd = NULL;

    return readBuffer;
}

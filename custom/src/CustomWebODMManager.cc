
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
            bool pcClassify = qgcApp()->toolbox()->settingsManager()->appSettings()->pcClassify()->rawValue().toBool();
            double smrfScalar = qgcApp()->toolbox()->settingsManager()->appSettings()->smrfScalar()->rawValue().toDouble();
            double opensfmDepthmapMinPatchSd = qgcApp()->toolbox()->settingsManager()->appSettings()->opensfmDepthmapMinPatchSd()->rawValue().toDouble();
            double smrfWindow = qgcApp()->toolbox()->settingsManager()->appSettings()->smrfWindow()->rawValue().toDouble();
            int meshOctreeDepth = qgcApp()->toolbox()->settingsManager()->appSettings()->meshOctreeDepth()->rawValue().toInt();
            int minNumFeatures = qgcApp()->toolbox()->settingsManager()->appSettings()->minNumFeatures()->rawValue().toInt();
            int resizeTo = qgcApp()->toolbox()->settingsManager()->appSettings()->resizeTo()->rawValue().toInt();
            double smrfSlope = qgcApp()->toolbox()->settingsManager()->appSettings()->smrfSlope()->rawValue().toDouble();
            int rerunFrom = qgcApp()->toolbox()->settingsManager()->appSettings()->rerunFrom()->enumIndex();
            bool use3dmesh = qgcApp()->toolbox()->settingsManager()->appSettings()->use3dmesh()->rawValue().toBool();
            int orthophotoCompression = qgcApp()->toolbox()->settingsManager()->appSettings()->orthophotoCompression()->enumIndex();
            double mveConfidence = qgcApp()->toolbox()->settingsManager()->appSettings()->mveConfidence()->rawValue().toDouble();
            bool texturingSkipHoleFilling = qgcApp()->toolbox()->settingsManager()->appSettings()->texturingSkipHoleFilling()->rawValue().toBool();
            bool texturingSkipGlobalSeamLeveling = qgcApp()->toolbox()->settingsManager()->appSettings()->texturingSkipGlobalSeamLeveling()->rawValue().toBool();
            int texturingNadirWeight = qgcApp()->toolbox()->settingsManager()->appSettings()->texturingNadirWeight()->rawValue().toInt();
            int texturingOutlierRemovalType = qgcApp()->toolbox()->settingsManager()->appSettings()->texturingOutlierRemovalType()->enumIndex();
            double othrophotoResolution = qgcApp()->toolbox()->settingsManager()->appSettings()->othrophotoResolution()->rawValue().toDouble();
            bool dtm = qgcApp()->toolbox()->settingsManager()->appSettings()->dtm()->rawValue().toBool();
            bool orthophotoNoTiled = qgcApp()->toolbox()->settingsManager()->appSettings()->orthophotoNoTiled()->rawValue().toBool();
            double demResolution = qgcApp()->toolbox()->settingsManager()->appSettings()->demResolution()->rawValue().toDouble();
            int meshSize = qgcApp()->toolbox()->settingsManager()->appSettings()->meshSize()->rawValue().toInt();
            bool forceGPS = qgcApp()->toolbox()->settingsManager()->appSettings()->forceGPS()->rawValue().toBool();
            bool ignoreGsd = qgcApp()->toolbox()->settingsManager()->appSettings()->ignoreGsd()->rawValue().toBool();
            bool buildOverviews = qgcApp()->toolbox()->settingsManager()->appSettings()->buildOverviews()->rawValue().toBool();
            bool opensfmDense = qgcApp()->toolbox()->settingsManager()->appSettings()->opensfmDense()->rawValue().toBool();
            int opensfmDepthmapMinConsistentViews = qgcApp()->toolbox()->settingsManager()->appSettings()->opensfmDepthmapMinConsistentViews()->rawValue().toInt();
            bool texturingSkipLocalSeamLeveling = qgcApp()->toolbox()->settingsManager()->appSettings()->texturingSkipLocalSeamLeveling()->rawValue().toBool();
            bool texturingKeepUnseenFaces = qgcApp()->toolbox()->settingsManager()->appSettings()->texturingKeepUnseenFaces()->rawValue().toBool();
            bool debug = qgcApp()->toolbox()->settingsManager()->appSettings()->debug()->rawValue().toBool();
            bool useExif = qgcApp()->toolbox()->settingsManager()->appSettings()->useExif()->rawValue().toBool();
            double meshSamples = qgcApp()->toolbox()->settingsManager()->appSettings()->meshSamples()->rawValue().toDouble();
            int pcSample = qgcApp()->toolbox()->settingsManager()->appSettings()->pcSample()->rawValue().toInt();
            int matcherDistance = qgcApp()->toolbox()->settingsManager()->appSettings()->matcherDistance()->rawValue().toInt();
            int splitOverlap = qgcApp()->toolbox()->settingsManager()->appSettings()->splitOverlap()->rawValue().toInt();
            int demDecimation = qgcApp()->toolbox()->settingsManager()->appSettings()->demDecimation()->rawValue().toInt();
            bool orthophotoCutline = qgcApp()->toolbox()->settingsManager()->appSettings()->orthophotoCutline()->rawValue().toBool();
            double pcFilter = qgcApp()->toolbox()->settingsManager()->appSettings()->pcFilter()->rawValue().toDouble();
            int split = qgcApp()->toolbox()->settingsManager()->appSettings()->split()->rawValue().toInt();
            bool fastOrthophoto = qgcApp()->toolbox()->settingsManager()->appSettings()->fastOrthophoto()->rawValue().toBool();
            bool pcEpt = qgcApp()->toolbox()->settingsManager()->appSettings()->pcEpt()->rawValue().toBool();
            double crop = qgcApp()->toolbox()->settingsManager()->appSettings()->crop()->rawValue().toDouble();
            bool pcLas = qgcApp()->toolbox()->settingsManager()->appSettings()->pcLas()->rawValue().toBool();
            int merge = qgcApp()->toolbox()->settingsManager()->appSettings()->merge()->enumIndex();
            bool dsm = qgcApp()->toolbox()->settingsManager()->appSettings()->dsm()->rawValue().toBool();
            int demGapfillSteps = qgcApp()->toolbox()->settingsManager()->appSettings()->demGapfillSteps()->rawValue().toInt();
            double meshPointWeight = qgcApp()->toolbox()->settingsManager()->appSettings()->meshPointWeight()->rawValue().toDouble();
            int maxConcurrency = qgcApp()->toolbox()->settingsManager()->appSettings()->maxConcurrency()->rawValue().toInt();
            int texturingToneMapping = qgcApp()->toolbox()->settingsManager()->appSettings()->texturingToneMapping()->enumIndex();
            bool demEuclidianMap = qgcApp()->toolbox()->settingsManager()->appSettings()->demEuclidianMap()->rawValue().toBool();
            int cameraLens = qgcApp()->toolbox()->settingsManager()->appSettings()->cameraLens()->enumIndex();
            bool skip3dmodel = qgcApp()->toolbox()->settingsManager()->appSettings()->skip3dmodel()->rawValue().toBool();
            int matchNeighbours = qgcApp()->toolbox()->settingsManager()->appSettings()->matchNeighbours()->rawValue().toInt();
            bool pcCsv = qgcApp()->toolbox()->settingsManager()->appSettings()->pcCsv()->rawValue().toBool();
            int endWith = qgcApp()->toolbox()->settingsManager()->appSettings()->endWith()->enumIndex();
            double depthmapResolution = qgcApp()->toolbox()->settingsManager()->appSettings()->depthmapResolution()->rawValue().toDouble();
            int texturingDataTerm = qgcApp()->toolbox()->settingsManager()->appSettings()->texturingDataTerm()->enumIndex();
            bool texturingSkipVisibilityTest = qgcApp()->toolbox()->settingsManager()->appSettings()->texturingSkipVisibilityTest()->rawValue().toBool();
            int opensfmDepthmapMethod = qgcApp()->toolbox()->settingsManager()->appSettings()->opensfmDepthmapMethod()->enumIndex();
            bool useFixedCameraParams = qgcApp()->toolbox()->settingsManager()->appSettings()->useFixedCameraParams()->rawValue().toBool();
            double smrfThreshold = qgcApp()->toolbox()->settingsManager()->appSettings()->smrfThreshold()->rawValue().toDouble();
            bool verbose = qgcApp()->toolbox()->settingsManager()->appSettings()->verbose()->rawValue().toBool();
            bool useHybridBundleAdjustment = qgcApp()->toolbox()->settingsManager()->appSettings()->useHybridBundleAdjustment()->rawValue().toBool();




            if (pcClassify != qgcApp()->toolbox()->settingsManager()->appSettings()->pcClassify()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'pc-classify', 'value':'true'}";
            }
            if (smrfScalar != qgcApp()->toolbox()->settingsManager()->appSettings()->smrfScalar()->rawDefaultValue().toDouble()) {
                if (options != "[") { options += ","; }
                std::stringstream stream;
                stream << std::fixed << std::setprecision(2) << smrfScalar;
                options += "{'name':'smrf-scalar', 'value':" + stream.str() + "}";
            }
            if (opensfmDepthmapMinPatchSd != qgcApp()->toolbox()->settingsManager()->appSettings()->opensfmDepthmapMinPatchSd()->rawDefaultValue().toDouble()) {
                if (options != "[") { options += ","; }
                options += "{'name':'opensfm-depthmap-min-patch-sd', 'value':" + std::to_string(opensfmDepthmapMinPatchSd) + "}";
            }
            if (smrfWindow != qgcApp()->toolbox()->settingsManager()->appSettings()->smrfWindow()->rawDefaultValue().toDouble()) {
                if (options != "[") { options += ","; }
                options += "{'name':'smrf-window', 'value':" + std::to_string(smrfWindow) + "}";
            }
            if (meshOctreeDepth != qgcApp()->toolbox()->settingsManager()->appSettings()->meshOctreeDepth()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'mesh-octree-depth', 'value':" + std::to_string(meshOctreeDepth) + "}";
            }
            if (minNumFeatures != qgcApp()->toolbox()->settingsManager()->appSettings()->minNumFeatures()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'min-num-features', 'value':" + std::to_string(minNumFeatures) + "}";
            }
            if (resizeTo != qgcApp()->toolbox()->settingsManager()->appSettings()->resizeTo()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'resize-to', 'value':" + std::to_string(resizeTo) + "}";
            }
            if (smrfSlope != qgcApp()->toolbox()->settingsManager()->appSettings()->smrfSlope()->rawDefaultValue().toDouble()) {
                if (options != "[") { options += ","; }
                options += "{'name':'smrf-slope', 'value':" + std::to_string(smrfSlope) + "}";
            }
            if (rerunFrom != qgcApp()->toolbox()->settingsManager()->appSettings()->rerunFrom()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'rerun-from', 'value':'" + qgcApp()->toolbox()->settingsManager()->appSettings()->rerunFrom()->enumStringValue().toStdString() + "'}";
            }
            if (use3dmesh != qgcApp()->toolbox()->settingsManager()->appSettings()->use3dmesh()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'use-3dmesh', 'value':'true'}";
            }
            if (orthophotoCompression != qgcApp()->toolbox()->settingsManager()->appSettings()->orthophotoCompression()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'orthophoto-compression', 'value':'" + qgcApp()->toolbox()->settingsManager()->appSettings()->orthophotoCompression()->enumStringValue().toStdString() + "'}";
            }
            if (mveConfidence != qgcApp()->toolbox()->settingsManager()->appSettings()->mveConfidence()->rawDefaultValue().toDouble()) {
                if (options != "[") { options += ","; }
                options += "{'name':'mve-confidence', 'value':" + std::to_string(mveConfidence) + "}";
            }
            if (texturingSkipHoleFilling != qgcApp()->toolbox()->settingsManager()->appSettings()->texturingSkipHoleFilling()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'texturing-skip-hole-filling', 'value':'true'}";
            }
            if (texturingSkipGlobalSeamLeveling != qgcApp()->toolbox()->settingsManager()->appSettings()->texturingSkipGlobalSeamLeveling()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'texturing-skip-global-seam-leveling', 'value':'true'}";
            }
            if (texturingNadirWeight != qgcApp()->toolbox()->settingsManager()->appSettings()->texturingNadirWeight()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'texturing-nadir-weight', 'value':" + std::to_string(texturingNadirWeight) + "}";
            }
            if (texturingOutlierRemovalType != qgcApp()->toolbox()->settingsManager()->appSettings()->texturingOutlierRemovalType()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'texturing-outlier-removal-type', 'value':'" + qgcApp()->toolbox()->settingsManager()->appSettings()->texturingOutlierRemovalType()->enumStringValue().toStdString() + "'}";
            }
            if (othrophotoResolution != qgcApp()->toolbox()->settingsManager()->appSettings()->othrophotoResolution()->rawDefaultValue().toDouble()) {
                if (options != "[") { options += ","; }
                options += "{'name':'orthophoto-resolution', 'value':" + std::to_string(othrophotoResolution) + "}";
            }
            if (dtm != qgcApp()->toolbox()->settingsManager()->appSettings()->dtm()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'dtm', 'value':'true'}";
            }
            if (orthophotoNoTiled != qgcApp()->toolbox()->settingsManager()->appSettings()->orthophotoNoTiled()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'orthophoto-no-tiled', 'value':'true'}";
            }
            if (demResolution != qgcApp()->toolbox()->settingsManager()->appSettings()->demResolution()->rawDefaultValue().toDouble()) {
                if (options != "[") { options += ","; }
                options += "{'name':'dem-resolution ', 'value':" + std::to_string(demResolution) + "}";
            }
            if (meshSize != qgcApp()->toolbox()->settingsManager()->appSettings()->meshSize()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'mesh-size', 'value':" + std::to_string(meshSize) + "}";
            }
            if (forceGPS != qgcApp()->toolbox()->settingsManager()->appSettings()->forceGPS()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'force-gps', 'value':'true'}";
            }
            if (ignoreGsd != qgcApp()->toolbox()->settingsManager()->appSettings()->ignoreGsd()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'ignore-gsd', 'value':'true'}";
            }
            if (buildOverviews != qgcApp()->toolbox()->settingsManager()->appSettings()->buildOverviews()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'build-overviews', 'value':'true'}";
            }
            if (opensfmDense != qgcApp()->toolbox()->settingsManager()->appSettings()->opensfmDense()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'use-opensfm-dense', 'value':'true'}";
            }
            if (opensfmDepthmapMinConsistentViews != qgcApp()->toolbox()->settingsManager()->appSettings()->opensfmDepthmapMinConsistentViews()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'opensfm-depthmap-min-consistent-views', 'value':" + std::to_string(opensfmDepthmapMinConsistentViews) + "}";
            }
            if (texturingSkipLocalSeamLeveling != qgcApp()->toolbox()->settingsManager()->appSettings()->texturingSkipLocalSeamLeveling()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'texturing-skip-local-seam-leveling', 'value':'true'}";
            }
            if (texturingKeepUnseenFaces != qgcApp()->toolbox()->settingsManager()->appSettings()->texturingKeepUnseenFaces()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'texturing-keep-unseen-faces', 'value':'true'}";
            }
            if (debug != qgcApp()->toolbox()->settingsManager()->appSettings()->debug()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'debug', 'value':'true'}";
            }
            if (useExif != qgcApp()->toolbox()->settingsManager()->appSettings()->useExif()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'use-exif', 'value':'true'}";
            }
            if (meshSamples != qgcApp()->toolbox()->settingsManager()->appSettings()->meshSamples()->rawDefaultValue().toDouble()) {
                if (options != "[") { options += ","; }
                options += "{'name':'mesh-samples', 'value':" + std::to_string(meshSamples) + "}";
            }
            if (pcSample != qgcApp()->toolbox()->settingsManager()->appSettings()->pcSample()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'pc-sample', 'value':" + std::to_string(pcSample) + "}";
            }
            if (matcherDistance != qgcApp()->toolbox()->settingsManager()->appSettings()->matcherDistance()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'matcher-distance', 'value':" + std::to_string(matcherDistance) + "}";
            }
            if (splitOverlap != qgcApp()->toolbox()->settingsManager()->appSettings()->splitOverlap()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'split-overlap', 'value':" + std::to_string(splitOverlap) + "}";
            }
            if (demDecimation != qgcApp()->toolbox()->settingsManager()->appSettings()->demDecimation()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'dem-decimation', 'value':" + std::to_string(demDecimation) + "}";
            }
            if (orthophotoCutline != qgcApp()->toolbox()->settingsManager()->appSettings()->orthophotoCutline()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'orthophoto-cutline', 'value':'true'}";
            }
            if (pcFilter != qgcApp()->toolbox()->settingsManager()->appSettings()->pcFilter()->rawDefaultValue().toDouble()) {
                if (options != "[") { options += ","; }
                options += "{'name':'pc-filter', 'value':" + std::to_string(pcFilter) + "}";
            }
            if (split != qgcApp()->toolbox()->settingsManager()->appSettings()->split()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'split', 'value':" + std::to_string(split) + "}";
            }
            if (fastOrthophoto != qgcApp()->toolbox()->settingsManager()->appSettings()->fastOrthophoto()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'fast-orthophoto', 'value':'true'}";
            }
            if (pcEpt != qgcApp()->toolbox()->settingsManager()->appSettings()->pcEpt()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'pc-ept', 'value':'true'}";
            }
            if (crop != qgcApp()->toolbox()->settingsManager()->appSettings()->crop()->rawDefaultValue().toDouble()) {
                if (options != "[") { options += ","; }
                options += "{'name':'crop', 'value':" + std::to_string(crop) + "}";
            }
            if (pcLas != qgcApp()->toolbox()->settingsManager()->appSettings()->pcLas()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'pc-las', 'value':'true'}";
            }
            if (merge != qgcApp()->toolbox()->settingsManager()->appSettings()->merge()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'merge', 'value':'" + qgcApp()->toolbox()->settingsManager()->appSettings()->merge()->enumStringValue().toStdString() + "'}";
            }
            if (dsm != qgcApp()->toolbox()->settingsManager()->appSettings()->dsm()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'dsm', 'value':'true'}";
            }
            if (demGapfillSteps != qgcApp()->toolbox()->settingsManager()->appSettings()->demGapfillSteps()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'dem-gapfill-steps', 'value':" + std::to_string(demGapfillSteps) + "}";
            }
            if (meshPointWeight != qgcApp()->toolbox()->settingsManager()->appSettings()->meshPointWeight()->rawDefaultValue().toDouble()) {
                if (options != "[") { options += ","; }
                options += "{'name':'mesh-point-weight', 'value':" + std::to_string(meshPointWeight) + "}";
            }
            if (maxConcurrency != qgcApp()->toolbox()->settingsManager()->appSettings()->maxConcurrency()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'max-concurrency', 'value':" + std::to_string(maxConcurrency) + "}";
            }
            if (texturingToneMapping != qgcApp()->toolbox()->settingsManager()->appSettings()->texturingToneMapping()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'texturing-tone-mapping', 'value':'" + qgcApp()->toolbox()->settingsManager()->appSettings()->texturingToneMapping()->enumStringValue().toStdString() + "'}";
            }
            if (demEuclidianMap != qgcApp()->toolbox()->settingsManager()->appSettings()->demEuclidianMap()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'dem-euclidean-map', 'value':'true'}";
            }
            if (cameraLens != qgcApp()->toolbox()->settingsManager()->appSettings()->cameraLens()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'camera-lens', 'value':'" + qgcApp()->toolbox()->settingsManager()->appSettings()->cameraLens()->enumStringValue().toStdString() + "'}";
            }
            if (skip3dmodel != qgcApp()->toolbox()->settingsManager()->appSettings()->skip3dmodel()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'skip-3dmodel', 'value':'true'}";
            }
            if (matchNeighbours != qgcApp()->toolbox()->settingsManager()->appSettings()->matchNeighbours()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'matcher-neighbors', 'value':" + std::to_string(matchNeighbours) + "}";
            }
            if (pcCsv != qgcApp()->toolbox()->settingsManager()->appSettings()->pcCsv()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'pc-csv', 'value':'true'}";
            }
            if (endWith != qgcApp()->toolbox()->settingsManager()->appSettings()->endWith()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'end-with', 'value':'" + qgcApp()->toolbox()->settingsManager()->appSettings()->endWith()->enumStringValue().toStdString() + "'}";
            }
            if (depthmapResolution != qgcApp()->toolbox()->settingsManager()->appSettings()->depthmapResolution()->rawDefaultValue().toDouble()) {
                if (options != "[") { options += ","; }
                options += "{'name':'depthmap-resolution', 'value':" + std::to_string(depthmapResolution) + "}";
            }
            if (texturingDataTerm != qgcApp()->toolbox()->settingsManager()->appSettings()->texturingDataTerm()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'texturing-data-term', 'value':'" + qgcApp()->toolbox()->settingsManager()->appSettings()->texturingDataTerm()->enumStringValue().toStdString() + "'}";
            }
            if (texturingSkipVisibilityTest != qgcApp()->toolbox()->settingsManager()->appSettings()->texturingSkipVisibilityTest()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'texturing-skip-visibility-test', 'value':'true'}";
            }
            if (opensfmDepthmapMethod != qgcApp()->toolbox()->settingsManager()->appSettings()->opensfmDepthmapMethod()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'opensfm-depthmap-method', 'value':'" + qgcApp()->toolbox()->settingsManager()->appSettings()->opensfmDepthmapMethod()->enumStringValue().toStdString() + "'}";
            }
            if (useFixedCameraParams != qgcApp()->toolbox()->settingsManager()->appSettings()->useFixedCameraParams()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'use-fixed-camera-params', 'value':'true'}";
            }
            if (smrfThreshold != qgcApp()->toolbox()->settingsManager()->appSettings()->smrfThreshold()->rawDefaultValue().toDouble()) {
                if (options != "[") { options += ","; }
                options += "{'name':'smrf-threshold', 'value':" + std::to_string(smrfThreshold) + "}";
            }
            if (verbose != qgcApp()->toolbox()->settingsManager()->appSettings()->verbose()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'verbose', 'value':'true'}";
            }
            if (useHybridBundleAdjustment != qgcApp()->toolbox()->settingsManager()->appSettings()->useHybridBundleAdjustment()->rawDefaultValue().toBool()) {
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
            email = qgcApp()->toolbox()->settingsManager()->appSettings()->email()->rawValueString().toStdString();
            projectName = qgcApp()->toolbox()->settingsManager()->appSettings()->projectName()->rawValueString().toStdString();
            taskName = qgcApp()->toolbox()->settingsManager()->appSettings()->taskName()->rawValueString().toStdString();
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
               CURLFORM_FILE, image,
               CURLFORM_CONTENTTYPE, "image/jpeg",
               CURLFORM_END);

    hnd = curl_easy_init();
    curl_easy_setopt(hnd, CURLOPT_URL, url);
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

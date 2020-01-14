
#include "QGCApplication.h"
#include "SettingsManager.h"

#include "CustomWebODMManager.h"
#include "CustomPlugin.h"
#include "CustomMappingSettings.h"
#include "Vehicle.h"
#include "ParameterManager.h"
#include "Fact.h"

#include <QDir>
#include <QJsonDocument>
#include <QJsonObject>
#include <QSettings>
#include <QCryptographicHash> 
#include <QSysInfo>
#include <QInputDialog>
#include <QApplication>
#include <QtConcurrent>

#include <curl/curl.h>
#include <fcntl.h>
#include <iostream>
#include <iomanip>
#include <sstream>
#include <stdio.h>
#include <string>
#include <sys/stat.h>
#include <errno.h>

using namespace std;

//-----------------------------------------------------------------------------
void CustomWebODMManager::init(CustomMappingSettings* mappingSettings) {
    _mappingSettings = mappingSettings;
}

static size_t WriteCallback(void* contents, size_t size, size_t nmemb,
                            void* userp) {
    ((std::string*)userp)->append((char*)contents, size * nmemb);
    return size * nmemb;
}



//-----------------------------------------------------------------------------
long CustomWebODMManager::queryLoginCredientials(std::string email, std::string password) {

    _password = password;

    std::string body = "email=" + email +"&password=" + password; 
    CURL *hnd;
    
    std::string url = _mappingSettings->server()->rawValue().toString().toStdString();
    url += "/";
    std::string readBuffer;

    hnd = curl_easy_init();
    curl_easy_setopt(hnd, CURLOPT_BUFFERSIZE, 102400L);
    curl_easy_setopt(hnd, CURLOPT_URL, url.c_str());
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
    if (_mappingSettings) {
            bool pcClassify = _mappingSettings->pcClassify()->rawValue().toBool();
            double smrfScalar = _mappingSettings->smrfScalar()->rawValue().toDouble();
            double opensfmDepthmapMinPatchSd = _mappingSettings->opensfmDepthmapMinPatchSd()->rawValue().toDouble();
            double smrfWindow = _mappingSettings->smrfWindow()->rawValue().toDouble();
            int meshOctreeDepth = _mappingSettings->meshOctreeDepth()->rawValue().toInt();
            int minNumFeatures = _mappingSettings->minNumFeatures()->rawValue().toInt();
            int resizeTo = _mappingSettings->resizeTo()->rawValue().toInt();
            double smrfSlope = _mappingSettings->smrfSlope()->rawValue().toDouble();
            int rerunFrom = _mappingSettings->rerunFrom()->enumIndex();
            bool use3dmesh = _mappingSettings->use3dmesh()->rawValue().toBool();
            int orthophotoCompression = _mappingSettings->orthophotoCompression()->enumIndex();
            double mveConfidence = _mappingSettings->mveConfidence()->rawValue().toDouble();
            bool texturingSkipHoleFilling = _mappingSettings->texturingSkipHoleFilling()->rawValue().toBool();
            bool texturingSkipGlobalSeamLeveling = _mappingSettings->texturingSkipGlobalSeamLeveling()->rawValue().toBool();
            int texturingNadirWeight = _mappingSettings->texturingNadirWeight()->rawValue().toInt();
            int texturingOutlierRemovalType = _mappingSettings->texturingOutlierRemovalType()->enumIndex();
            double othrophotoResolution = _mappingSettings->othrophotoResolution()->rawValue().toDouble();
            bool dtm = _mappingSettings->dtm()->rawValue().toBool();
            bool orthophotoNoTiled = _mappingSettings->orthophotoNoTiled()->rawValue().toBool();
            double demResolution = _mappingSettings->demResolution()->rawValue().toDouble();
            int meshSize = _mappingSettings->meshSize()->rawValue().toInt();
            bool forceGPS = _mappingSettings->forceGPS()->rawValue().toBool();
            bool ignoreGsd = _mappingSettings->ignoreGsd()->rawValue().toBool();
            bool buildOverviews = _mappingSettings->buildOverviews()->rawValue().toBool();
            bool opensfmDense = _mappingSettings->opensfmDense()->rawValue().toBool();
            int opensfmDepthmapMinConsistentViews = _mappingSettings->opensfmDepthmapMinConsistentViews()->rawValue().toInt();
            bool texturingSkipLocalSeamLeveling = _mappingSettings->texturingSkipLocalSeamLeveling()->rawValue().toBool();
            bool texturingKeepUnseenFaces = _mappingSettings->texturingKeepUnseenFaces()->rawValue().toBool();
            bool debug = _mappingSettings->debug()->rawValue().toBool();
            bool useExif = _mappingSettings->useExif()->rawValue().toBool();
            double meshSamples = _mappingSettings->meshSamples()->rawValue().toDouble();
            int pcSample = _mappingSettings->pcSample()->rawValue().toInt();
            int matcherDistance = _mappingSettings->matcherDistance()->rawValue().toInt();
            int splitOverlap = _mappingSettings->splitOverlap()->rawValue().toInt();
            int demDecimation = _mappingSettings->demDecimation()->rawValue().toInt();
            bool orthophotoCutline = _mappingSettings->orthophotoCutline()->rawValue().toBool();
            double pcFilter = _mappingSettings->pcFilter()->rawValue().toDouble();
            int split = _mappingSettings->split()->rawValue().toInt();
            bool fastOrthophoto = _mappingSettings->fastOrthophoto()->rawValue().toBool();
            bool pcEpt = _mappingSettings->pcEpt()->rawValue().toBool();
            double crop = _mappingSettings->crop()->rawValue().toDouble();
            bool pcLas = _mappingSettings->pcLas()->rawValue().toBool();
            int merge = _mappingSettings->merge()->enumIndex();
            bool dsm = _mappingSettings->dsm()->rawValue().toBool();
            int demGapfillSteps = _mappingSettings->demGapfillSteps()->rawValue().toInt();
            double meshPointWeight = _mappingSettings->meshPointWeight()->rawValue().toDouble();
            int maxConcurrency = _mappingSettings->maxConcurrency()->rawValue().toInt();
            int texturingToneMapping = _mappingSettings->texturingToneMapping()->enumIndex();
            bool demEuclidianMap = _mappingSettings->demEuclidianMap()->rawValue().toBool();
            int cameraLens = _mappingSettings->cameraLens()->enumIndex();
            bool skip3dmodel = _mappingSettings->skip3dmodel()->rawValue().toBool();
            int matchNeighbours = _mappingSettings->matchNeighbours()->rawValue().toInt();
            bool pcCsv = _mappingSettings->pcCsv()->rawValue().toBool();
            int endWith = _mappingSettings->endWith()->enumIndex();
            double depthmapResolution = _mappingSettings->depthmapResolution()->rawValue().toDouble();
            int texturingDataTerm = _mappingSettings->texturingDataTerm()->enumIndex();
            bool texturingSkipVisibilityTest = _mappingSettings->texturingSkipVisibilityTest()->rawValue().toBool();
            int opensfmDepthmapMethod = _mappingSettings->opensfmDepthmapMethod()->enumIndex();
            bool useFixedCameraParams = _mappingSettings->useFixedCameraParams()->rawValue().toBool();
            double smrfThreshold = _mappingSettings->smrfThreshold()->rawValue().toDouble();
            bool verbose = _mappingSettings->verbose()->rawValue().toBool();
            bool useHybridBundleAdjustment = _mappingSettings->useHybridBundleAdjustment()->rawValue().toBool();




            if (pcClassify != _mappingSettings->pcClassify()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'pc-classify', 'value':'true'}";
            }
            if (smrfScalar != _mappingSettings->smrfScalar()->rawDefaultValue().toDouble()) {
                if (options != "[") { options += ","; }
                std::stringstream stream;
                stream << std::fixed << std::setprecision(2) << smrfScalar;
                options += "{'name':'smrf-scalar', 'value':" + stream.str() + "}";
            }
            if (opensfmDepthmapMinPatchSd != _mappingSettings->opensfmDepthmapMinPatchSd()->rawDefaultValue().toDouble()) {
                if (options != "[") { options += ","; }
                options += "{'name':'opensfm-depthmap-min-patch-sd', 'value':" + std::to_string(opensfmDepthmapMinPatchSd) + "}";
            }
            if (smrfWindow != _mappingSettings->smrfWindow()->rawDefaultValue().toDouble()) {
                if (options != "[") { options += ","; }
                options += "{'name':'smrf-window', 'value':" + std::to_string(smrfWindow) + "}";
            }
            if (meshOctreeDepth != _mappingSettings->meshOctreeDepth()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'mesh-octree-depth', 'value':" + std::to_string(meshOctreeDepth) + "}";
            }
            if (minNumFeatures != _mappingSettings->minNumFeatures()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'min-num-features', 'value':" + std::to_string(minNumFeatures) + "}";
            }
            if (resizeTo != _mappingSettings->resizeTo()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'resize-to', 'value':" + std::to_string(resizeTo) + "}";
            }
            if (smrfSlope != _mappingSettings->smrfSlope()->rawDefaultValue().toDouble()) {
                if (options != "[") { options += ","; }
                options += "{'name':'smrf-slope', 'value':" + std::to_string(smrfSlope) + "}";
            }
            if (rerunFrom != _mappingSettings->rerunFrom()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'rerun-from', 'value':'" + _mappingSettings->rerunFrom()->enumStringValue().toStdString() + "'}";
            }
            if (use3dmesh != _mappingSettings->use3dmesh()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'use-3dmesh', 'value':'true'}";
            }
            if (orthophotoCompression != _mappingSettings->orthophotoCompression()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'orthophoto-compression', 'value':'" + _mappingSettings->orthophotoCompression()->enumStringValue().toStdString() + "'}";
            }
            if (mveConfidence != _mappingSettings->mveConfidence()->rawDefaultValue().toDouble()) {
                if (options != "[") { options += ","; }
                options += "{'name':'mve-confidence', 'value':" + std::to_string(mveConfidence) + "}";
            }
            if (texturingSkipHoleFilling != _mappingSettings->texturingSkipHoleFilling()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'texturing-skip-hole-filling', 'value':'true'}";
            }
            if (texturingSkipGlobalSeamLeveling != _mappingSettings->texturingSkipGlobalSeamLeveling()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'texturing-skip-global-seam-leveling', 'value':'true'}";
            }
            if (texturingNadirWeight != _mappingSettings->texturingNadirWeight()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'texturing-nadir-weight', 'value':" + std::to_string(texturingNadirWeight) + "}";
            }
            if (texturingOutlierRemovalType != _mappingSettings->texturingOutlierRemovalType()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'texturing-outlier-removal-type', 'value':'" + _mappingSettings->texturingOutlierRemovalType()->enumStringValue().toStdString() + "'}";
            }
            if (othrophotoResolution != _mappingSettings->othrophotoResolution()->rawDefaultValue().toDouble()) {
                if (options != "[") { options += ","; }
                options += "{'name':'orthophoto-resolution', 'value':" + std::to_string(othrophotoResolution) + "}";
            }
            if (dtm != _mappingSettings->dtm()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'dtm', 'value':'true'}";
            }
            if (orthophotoNoTiled != _mappingSettings->orthophotoNoTiled()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'orthophoto-no-tiled', 'value':'true'}";
            }
            if (demResolution != _mappingSettings->demResolution()->rawDefaultValue().toDouble()) {
                if (options != "[") { options += ","; }
                options += "{'name':'dem-resolution ', 'value':" + std::to_string(demResolution) + "}";
            }
            if (meshSize != _mappingSettings->meshSize()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'mesh-size', 'value':" + std::to_string(meshSize) + "}";
            }
            if (forceGPS != _mappingSettings->forceGPS()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'force-gps', 'value':'true'}";
            }
            if (ignoreGsd != _mappingSettings->ignoreGsd()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'ignore-gsd', 'value':'true'}";
            }
            if (buildOverviews != _mappingSettings->buildOverviews()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'build-overviews', 'value':'true'}";
            }
            if (opensfmDense != _mappingSettings->opensfmDense()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'use-opensfm-dense', 'value':'true'}";
            }
            if (opensfmDepthmapMinConsistentViews != _mappingSettings->opensfmDepthmapMinConsistentViews()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'opensfm-depthmap-min-consistent-views', 'value':" + std::to_string(opensfmDepthmapMinConsistentViews) + "}";
            }
            if (texturingSkipLocalSeamLeveling != _mappingSettings->texturingSkipLocalSeamLeveling()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'texturing-skip-local-seam-leveling', 'value':'true'}";
            }
            if (texturingKeepUnseenFaces != _mappingSettings->texturingKeepUnseenFaces()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'texturing-keep-unseen-faces', 'value':'true'}";
            }
            if (debug != _mappingSettings->debug()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'debug', 'value':'true'}";
            }
            if (useExif != _mappingSettings->useExif()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'use-exif', 'value':'true'}";
            }
            if (meshSamples != _mappingSettings->meshSamples()->rawDefaultValue().toDouble()) {
                if (options != "[") { options += ","; }
                options += "{'name':'mesh-samples', 'value':" + std::to_string(meshSamples) + "}";
            }
            if (pcSample != _mappingSettings->pcSample()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'pc-sample', 'value':" + std::to_string(pcSample) + "}";
            }
            if (matcherDistance != _mappingSettings->matcherDistance()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'matcher-distance', 'value':" + std::to_string(matcherDistance) + "}";
            }
            if (splitOverlap != _mappingSettings->splitOverlap()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'split-overlap', 'value':" + std::to_string(splitOverlap) + "}";
            }
            if (demDecimation != _mappingSettings->demDecimation()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'dem-decimation', 'value':" + std::to_string(demDecimation) + "}";
            }
            if (orthophotoCutline != _mappingSettings->orthophotoCutline()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'orthophoto-cutline', 'value':'true'}";
            }
            if (pcFilter != _mappingSettings->pcFilter()->rawDefaultValue().toDouble()) {
                if (options != "[") { options += ","; }
                options += "{'name':'pc-filter', 'value':" + std::to_string(pcFilter) + "}";
            }
            if (split != _mappingSettings->split()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'split', 'value':" + std::to_string(split) + "}";
            }
            if (fastOrthophoto != _mappingSettings->fastOrthophoto()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'fast-orthophoto', 'value':'true'}";
            }
            if (pcEpt != _mappingSettings->pcEpt()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'pc-ept', 'value':'true'}";
            }
            if (crop != _mappingSettings->crop()->rawDefaultValue().toDouble()) {
                if (options != "[") { options += ","; }
                options += "{'name':'crop', 'value':" + std::to_string(crop) + "}";
            }
            if (pcLas != _mappingSettings->pcLas()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'pc-las', 'value':'true'}";
            }
            if (merge != _mappingSettings->merge()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'merge', 'value':'" + _mappingSettings->merge()->enumStringValue().toStdString() + "'}";
            }
            if (dsm != _mappingSettings->dsm()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'dsm', 'value':'true'}";
            }
            if (demGapfillSteps != _mappingSettings->demGapfillSteps()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'dem-gapfill-steps', 'value':" + std::to_string(demGapfillSteps) + "}";
            }
            if (meshPointWeight != _mappingSettings->meshPointWeight()->rawDefaultValue().toDouble()) {
                if (options != "[") { options += ","; }
                options += "{'name':'mesh-point-weight', 'value':" + std::to_string(meshPointWeight) + "}";
            }
            if (maxConcurrency != _mappingSettings->maxConcurrency()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'max-concurrency', 'value':" + std::to_string(maxConcurrency) + "}";
            }
            if (texturingToneMapping != _mappingSettings->texturingToneMapping()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'texturing-tone-mapping', 'value':'" + _mappingSettings->texturingToneMapping()->enumStringValue().toStdString() + "'}";
            }
            if (demEuclidianMap != _mappingSettings->demEuclidianMap()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'dem-euclidean-map', 'value':'true'}";
            }
            if (cameraLens != _mappingSettings->cameraLens()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'camera-lens', 'value':'" + _mappingSettings->cameraLens()->enumStringValue().toStdString() + "'}";
            }
            if (skip3dmodel != _mappingSettings->skip3dmodel()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'skip-3dmodel', 'value':'true'}";
            }
            if (matchNeighbours != _mappingSettings->matchNeighbours()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'matcher-neighbors', 'value':" + std::to_string(matchNeighbours) + "}";
            }
            if (pcCsv != _mappingSettings->pcCsv()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'pc-csv', 'value':'true'}";
            }
            if (endWith != _mappingSettings->endWith()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'end-with', 'value':'" + _mappingSettings->endWith()->enumStringValue().toStdString() + "'}";
            }
            if (depthmapResolution != _mappingSettings->depthmapResolution()->rawDefaultValue().toDouble()) {
                if (options != "[") { options += ","; }
                options += "{'name':'depthmap-resolution', 'value':" + std::to_string(depthmapResolution) + "}";
            }
            if (texturingDataTerm != _mappingSettings->texturingDataTerm()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'texturing-data-term', 'value':'" + _mappingSettings->texturingDataTerm()->enumStringValue().toStdString() + "'}";
            }
            if (texturingSkipVisibilityTest != _mappingSettings->texturingSkipVisibilityTest()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'texturing-skip-visibility-test', 'value':'true'}";
            }
            if (opensfmDepthmapMethod != _mappingSettings->opensfmDepthmapMethod()->rawDefaultValue().toInt()) {
                if (options != "[") { options += ","; }
                options += "{'name':'opensfm-depthmap-method', 'value':'" + _mappingSettings->opensfmDepthmapMethod()->enumStringValue().toStdString() + "'}";
            }
            if (useFixedCameraParams != _mappingSettings->useFixedCameraParams()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'use-fixed-camera-params', 'value':'true'}";
            }
            if (smrfThreshold != _mappingSettings->smrfThreshold()->rawDefaultValue().toDouble()) {
                if (options != "[") { options += ","; }
                options += "{'name':'smrf-threshold', 'value':" + std::to_string(smrfThreshold) + "}";
            }
            if (verbose != _mappingSettings->verbose()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'verbose', 'value':'true'}";
            }
            if (useHybridBundleAdjustment != _mappingSettings->useHybridBundleAdjustment()->rawDefaultValue().toBool()) {
                if (options != "[") { options += ","; }
                options += "{'name':'use-hybrid-bundle-adjustment', 'value':'true'}";
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
    if (_mappingSettings){
        email = _mappingSettings->email()->rawValueString().toStdString();
        projectName = _mappingSettings->projectName()->rawValueString().toStdString();
        taskName = _mappingSettings->taskName()->rawValueString().toStdString();
    }
    std::string body = "email=" + email +"&password=" + password + "&options=" + options;
    if (projectName != "") { body += "&projectName=" + projectName; }
    if (taskName != "") { body += "&taskName=" + taskName; }

    std::string url = _mappingSettings->server()->rawValue().toString().toStdString();
    url += "/task";

    CURL *hnd;

    std::string readBuffer;

    hnd = curl_easy_init();
    curl_easy_setopt(hnd, CURLOPT_BUFFERSIZE, 102400L);
    curl_easy_setopt(hnd, CURLOPT_URL, url.c_str());
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
    std::string url = _mappingSettings->server()->rawValue().toString().toStdString();
    url += std::string("/task/") + std::to_string(taskId);
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
    curl_easy_setopt(hnd, CURLOPT_TIMEOUT, 10L);
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

void CustomWebODMManager::startTask(long taskId){
    CURL *hnd;

    std::string readBuffer;
    std::string url = _mappingSettings->server()->rawValue().toString().toStdString();
    url += std::string("/task/");
    url += std::to_string(taskId);
    url += "/start";
    
    hnd = curl_easy_init();

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
}

void CustomWebODMManager::uploadImages(){
 
    ParameterManager* parameterManager = qgcApp()->toolbox()->multiVehicleManager()->activeVehicle()->parameterManager();
    if (parameterManager->parametersReady()){
        qgcApp()->showMessage(tr("Starting image upload"));
        connect(this, &CustomWebODMManager::uploadComplete, this, &CustomWebODMManager::_imageUploadComplete);
        connect(this, &CustomWebODMManager::imageUploaded, this, &CustomWebODMManager::_imageUploaded);
        parameterManager->getParameter(51, "USB_EN")->setRawValue(0);
        QFuture<void> future = QtConcurrent::run([=]() {
            QTime dieTime= QTime::currentTime().addSecs(10);
            while (QTime::currentTime() < dieTime)
                QCoreApplication::processEvents(QEventLoop::AllEvents, 100);
            std::string mount;
            std::string type = QSysInfo::productType().toStdString();
            if (type == "winrt" || type == "windows"){
                mount = "net use q: \\\\10.10.1.2\\airside_shared";
            } else {
                mount = "echo " + _userPassword + " | sudo -S mkdir -p -m777 /tmp/images; echo " + _userPassword + " | sudo -S mount -v -t cifs -o user=guest,password=,uid=1000,gid=1000 //10.10.1.2/airside_shared /tmp/images";
            }
            qDebug() << system(mount.c_str());

            dieTime= QTime::currentTime().addSecs(10);
            while (QTime::currentTime() < dieTime)
                QCoreApplication::processEvents(QEventLoop::AllEvents, 100);

            long taskId = CustomWebODMManager::createTask(_password);
            int totalImages = 0;
            int sentImages = 0;
            QDirIterator dir("/tmp/images/payload/SonyCamera/DCIM",QDir::AllEntries |QDir::NoDotAndDotDot, QDirIterator::Subdirectories);
            while (dir.hasNext()){
                dir.next();
                if (dir.fileInfo().isFile()){
                    totalImages++;
                }
            }
            QDirIterator it("/tmp/images/payload/SonyCamera/DCIM",QDir::AllEntries |QDir::NoDotAndDotDot, QDirIterator::Subdirectories);
            while (it.hasNext()){
                it.next();
                if (it.fileInfo().isFile()){
                    it.filePath();
                    CustomWebODMManager::postImages(taskId, it.filePath().toStdString());
                    QFile::remove(it.filePath());
                    sentImages++;
                    QString str = "Uploaded image "+ QString::number(sentImages) +" of " + QString::number(totalImages);
                    emit imageUploaded(str);
                }
            }
            dieTime= QTime::currentTime().addSecs(15);
            while (QTime::currentTime() < dieTime)
                QCoreApplication::processEvents(QEventLoop::AllEvents, 100); 
            

            
            CustomWebODMManager::startTask(taskId);

            parameterManager->getParameter(51, "USB_EN")->setRawValue(1);
            std::string umount;
            if (type == "winrt" || type == "windows"){
                umount = "net use q: /delete";
            } else {
                umount = "echo " + _userPassword + " | sudo -S umount /tmp/images";
            }

            qDebug() << system(umount.c_str());
            emit uploadComplete();
        });
    }
}

void CustomWebODMManager::webodm(std::string password){
    _userPassword = password;
    Vehicle* activeVehicle = qgcApp()->toolbox()->multiVehicleManager()->activeVehicle();
    connect(activeVehicle, &Vehicle::armedChanged,this, &CustomWebODMManager::_vehicleArmedChanged);
}

void CustomWebODMManager::_vehicleArmedChanged(bool armed){
    if (!armed){
        uploadImages();
    }
}

void CustomWebODMManager::_imageUploadComplete() {
    qgcApp()->showMessage(tr("Image upload complete"));
    disconnect(this, 0, this, 0);
}

void CustomWebODMManager::_imageUploaded(QString message) {
    qgcApp()->toolbox()->uasMessageHandler()->handleTextMessage(0,51,6, message);
}

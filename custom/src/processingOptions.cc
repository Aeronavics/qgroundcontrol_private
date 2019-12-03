#include "processingOptions.h"
#include "JsonHelper.h"

#include <QQmlEngine>

const char* CameraSpec::_smrfScalarName =          "smrfScalar";


ProcessingOptions::ProcessingOptions(const QString& settingsGroup, QObject* parent)
    : QObject                   (parent)
    , _metaDataMap              (FactMetaData::createMapFromJsonFile(QStringLiteral(":/json/processingOptions.FactMetaData.json"), this))
    , _smrfScalarFact          (settingsGroup, _metaDataMap[_smrfScalarName])
{
    QQmlEngine::setObjectOwnership(this, QQmlEngine::CppOwnership);
}

const ProcessingOptions& ProcessingOptions::operator=(const CameraSpec& other)
{
    _smrfScalarFact.setRawValue        (other._smrfScalarFact.rawValue());

    return *this;
}

void ProcessingOptions::save(QJsonObject& json) const
{

    json[_smrfScalarName] =        _smrfScalarFact.rawValue().toDouble();

}

bool ProcessingOptions::load(const QJsonObject& json, QString& errorString)
{
    QList<JsonHelper::KeyValidateInfo> keyInfoList = {
        { _smrfScalarName,         QJsonValue::Double, true },
    };
    if (!JsonHelper::validateKeys(json, keyInfoList, errorString)) {
        return false;
    }

    _smrfScalarFact.setRawValue        (json[_smrfScalarName].toDouble());

    return true;
}

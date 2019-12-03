#pragma once

#include "SettingsFact.h"

class ProcessingOptions : public QObject
{
    Q_OBJECT

public:
    ProcessingOptions(const QString& settingsGroup, QObject* parent = nullptr);

    const ProcessingOptions& operator=(const ProcessingOptions& other);

    Q_PROPERTY(Fact* smrfScalar        READ smrfScalar        CONSTANT)



    SettingsFact* smrfScalar       (void) { return &_smrfScalarFact; }


    void save(QJsonObject& json) const;
    bool load(const QJsonObject& json, QString& errorString);


private:


    QMap<QString, FactMetaData*> _metaDataMap;

    SettingsFact _smrfScalarFact;

    static const char* _smrfScalarName;

};

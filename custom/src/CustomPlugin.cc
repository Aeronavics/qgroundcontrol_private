/****************************************************************************
 *
 * (c) 2009-2019 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 *   @brief Custom QGCCorePlugin Implementation
 *   @author Gus Grubba <gus@auterion.com>
 */

#include <QtQml>
#include <QQmlEngine>
#include <QDateTime>
#include "QGCSettings.h"
#include "MAVLinkLogManager.h"

#include "CustomPlugin.h"
#include "CustomQuickInterface.h"
#include "CustomVideoManager.h"

#include "MultiVehicleManager.h"
#include "QGCApplication.h"
#include "SettingsManager.h"
#include "AppMessages.h"
#include "QmlComponentInfo.h"
#include "QGCPalette.h"

QGC_LOGGING_CATEGORY(CustomLog, "CustomLog")

//CustomVideoReceiver::CustomVideoReceiver(QObject* parent)
//    : VideoReceiver(parent)
//{
//#if defined(QGC_GST_STREAMING)
//    //-- Shorter RTSP test interval
//    _restart_time_ms = 1000;
//#endif
//}
//
//CustomVideoReceiver::~CustomVideoReceiver()
//{
//}

//-----------------------------------------------------------------------------
//static QObject*
//customQuickInterfaceSingletonFactory(QQmlEngine*, QJSEngine*)
//{
//    qCDebug(CustomLog) << "Creating CustomQuickInterface instance";
//    CustomQuickInterface* pIFace = new CustomQuickInterface();
//    CustomPlugin* pPlug = dynamic_cast<CustomPlugin*>(qgcApp()->toolbox()->corePlugin());
//    if(pPlug) {
//        pIFace->init();
//    } else {
//        qCritical() << "Error obtaining instance of CustomPlugin";
//    }
//    return pIFace;
//}

//-----------------------------------------------------------------------------
CustomOptions::CustomOptions(CustomPlugin*, QObject* parent)
    : QGCOptions(parent)
{
}

//-----------------------------------------------------------------------------
//bool
//CustomOptions::showFirmwareUpgrade() const
//{
//    return qgcApp()->toolbox()->corePlugin()->showAdvancedUI();
//}

//QColor
//CustomOptions::toolbarBackgroundLight() const
//{
//    return CustomPlugin::_windowShadeEnabledLightColor;
//}
//
//QColor
//CustomOptions::toolbarBackgroundDark() const
//{
//    return CustomPlugin::_windowShadeEnabledDarkColor;
//}

//-----------------------------------------------------------------------------
CustomPlugin::CustomPlugin(QGCApplication *app, QGCToolbox* toolbox)
    : QGCCorePlugin(app, toolbox)
{
    _pOptions = new CustomOptions(this, this);
    _showAdvancedUI = false;
}

//-----------------------------------------------------------------------------
CustomPlugin::~CustomPlugin()
{
}

//-----------------------------------------------------------------------------
//void
//CustomPlugin::setToolbox(QGCToolbox* toolbox)
//{
//    QGCCorePlugin::setToolbox(toolbox);
//    qmlRegisterSingletonType<CustomQuickInterface>("CustomQuickInterface", 1, 0, "CustomQuickInterface", customQuickInterfaceSingletonFactory);
//    //-- Disable automatic logging
//    toolbox->mavlinkLogManager()->setEnableAutoStart(false);
//    toolbox->mavlinkLogManager()->setEnableAutoUpload(false);
//    connect(qgcApp()->toolbox()->corePlugin(), &QGCCorePlugin::showAdvancedUIChanged, this, &CustomPlugin::_advancedChanged);
//}

//-----------------------------------------------------------------------------
//void
//CustomPlugin::_advancedChanged(bool changed)
//{
//    //-- We are now in "Advanced Mode" (or not)
//    emit _pOptions->showFirmwareUpgradeChanged(changed);
//}

//-----------------------------------------------------------------------------
void
CustomPlugin::addSettingsEntry(const QString& title,
                               const char* qmlFile,
                               const char* iconFile/*= nullptr*/)
{
    Q_CHECK_PTR(qmlFile);
    // 'this' instance will take ownership on the QmlComponentInfo instance
    _customSettingsList.append(QVariant::fromValue(
        new QmlComponentInfo(title,
                QUrl::fromUserInput(qmlFile),
                iconFile == nullptr ? QUrl() : QUrl::fromUserInput(iconFile),
                this)));
}

//-----------------------------------------------------------------------------
QVariantList&
CustomPlugin::settingsPages()
{
    if(_customSettingsList.isEmpty()) {
        addSettingsEntry(tr("General"),     "qrc:/qml/GeneralSettings.qml", "qrc:/res/gear-white.svg");
        addSettingsEntry(tr("Comm Links"),  "qrc:/qml/LinkSettings.qml",    "qrc:/res/waves.svg");
        addSettingsEntry(tr("Offline Maps"),"qrc:/qml/OfflineMap.qml",      "qrc:/res/waves.svg");
//#if defined(QGC_GST_MICROHARD_ENABLED)
//        addSettingsEntry(tr("Microhard"),   "qrc:/qml/MicrohardSettings.qml");
//#endif
//#if defined(QGC_GST_TAISYNC_ENABLED)
//        addSettingsEntry(tr("Taisync"),     "qrc:/qml/TaisyncSettings.qml");
//#endif
#if defined(QGC_AIRMAP_ENABLED)
        addSettingsEntry(tr("AirMap"),      "qrc:/qml/AirmapSettings.qml");
#endif
//        addSettingsEntry(tr("MAVLink"),     "qrc:/qml/MavlinkSettings.qml", "    qrc:/res/waves.svg");
//        addSettingsEntry(tr("Console"),     "qrc:/qml/QGroundControl/Controls/AppMessages.qml");
//#if defined(QGC_ENABLE_QZXING)
//        addSettingsEntry(tr("Barcode Test"),"qrc:/custom/BarcodeReader.qml");
//#endif
#if defined(QT_DEBUG)
        //-- These are always present on Debug builds
        addSettingsEntry(tr("Mock Link"),   "qrc:/qml/MockLink.qml");
        addSettingsEntry(tr("Debug"),       "qrc:/qml/DebugWindow.qml");
        addSettingsEntry(tr("Palette Test"),"qrc:/qml/QmlTest.qml");
#endif
    }
    return _customSettingsList;
}

//-----------------------------------------------------------------------------
QGCOptions*
CustomPlugin::options()
{
    return _pOptions;
}

//-----------------------------------------------------------------------------
QString
CustomPlugin::brandImageIndoor(void) const
{
    return QStringLiteral("/custom/img/void.png");
}

//-----------------------------------------------------------------------------
QString
CustomPlugin::brandImageOutdoor(void) const
{
    return QStringLiteral("/custom/img/void.png");
}

//-----------------------------------------------------------------------------
//bool
//CustomPlugin::overrideSettingsGroupVisibility(QString name)
//{
//    if (name == BrandImageSettings::name) {
//        return false;
//    }
//    return true;
//}

//-----------------------------------------------------------------------------
//VideoManager*
//CustomPlugin::createVideoManager(QGCApplication *app, QGCToolbox *toolbox)
//{
//    return new CustomVideoManager(app, toolbox);
//}
//
////-----------------------------------------------------------------------------
//VideoReceiver*
//CustomPlugin::createVideoReceiver(QObject* parent)
//{
//    return new CustomVideoReceiver(parent);
//}
//
////-----------------------------------------------------------------------------
//QQmlApplicationEngine*
//CustomPlugin::createRootWindow(QObject *parent)
//{
//    QQmlApplicationEngine* pEngine = new QQmlApplicationEngine(parent);
//    pEngine->addImportPath("qrc:/qml");
//    pEngine->addImportPath("qrc:/Custom/Widgets");
//    pEngine->addImportPath("qrc:/Custom/Camera");
//    pEngine->rootContext()->setContextProperty("joystickManager",   qgcApp()->toolbox()->joystickManager());
//    pEngine->rootContext()->setContextProperty("debugMessageModel", AppMessages::getModel());
//    pEngine->load(QUrl(QStringLiteral("qrc:/qml/MainRootWindow.qml")));
//    return pEngine;
//}

//-----------------------------------------------------------------------------
//bool
//CustomPlugin::adjustSettingMetaData(const QString& settingsGroup, FactMetaData& metaData)
//{
//    if (settingsGroup == AppSettings::settingsGroup) {
//        if (metaData.name() == AppSettings::appFontPointSizeName) {
//        #if defined(Q_OS_LINUX)
//            int defaultFontPointSize = 11;
//            metaData.setRawDefaultValue(defaultFontPointSize);
//        #endif
//        } else if (metaData.name() == AppSettings::indoorPaletteName) {
//            QVariant indoorPalette = 1;
//            metaData.setRawDefaultValue(indoorPalette);
//            return true;
//        }
//    }
//    return true;
//}

//const QColor     CustomPlugin::_windowShadeEnabledLightColor("#FFFFFF");
//const QColor     CustomPlugin::_windowShadeEnabledDarkColor("#212529");

//-----------------------------------------------------------------------------
void
CustomPlugin::paletteOverride(QString colorName, QGCPalette::PaletteColorInfo_t& colorInfo)
{
    if (colorName == QStringLiteral("brandingPurple")) {
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#222222");
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#222222");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#000000");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#000000");
    }
}

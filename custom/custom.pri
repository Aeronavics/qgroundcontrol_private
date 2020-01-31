message("Adding Aeronavics Plugin")

#-- Version control
#   Major and minor versions are defined here (manually)

CUSTOM_QGC_VER_MAJOR = 0
CUSTOM_QGC_VER_MINOR = 0
CUSTOM_QGC_VER_FIRST_BUILD = 0

# Build number is automatic
# Uses the current branch. This way it works on any branch including build-server's PR branches
CUSTOM_QGC_VER_BUILD = $$system(git --git-dir ../.git rev-list $$GIT_BRANCH --first-parent --count)
win32 {
    CUSTOM_QGC_VER_BUILD = $$system("set /a $$CUSTOM_QGC_VER_BUILD - $$CUSTOM_QGC_VER_FIRST_BUILD")
} else {
    CUSTOM_QGC_VER_BUILD = $$system("echo $(($$CUSTOM_QGC_VER_BUILD - $$CUSTOM_QGC_VER_FIRST_BUILD))")
}
CUSTOM_QGC_VERSION = $${CUSTOM_QGC_VER_MAJOR}.$${CUSTOM_QGC_VER_MINOR}.$${CUSTOM_QGC_VER_BUILD}

DEFINES -= GIT_VERSION=\"\\\"$$GIT_VERSION\\\"\"
DEFINES += GIT_VERSION=\"\\\"$$CUSTOM_QGC_VERSION\\\"\"

message(Aeronavics QGC Version: $${CUSTOM_QGC_VERSION})

# Branding

DEFINES += CUSTOMHEADER=\"\\\"CustomPlugin.h\\\"\"
DEFINES += CUSTOMCLASS=CustomPlugin

TARGET   = QGroundControl
DEFINES += QGC_APPLICATION_NAME=\"\\\"AeronavicsQGC\\\"\"

DEFINES += QGC_ORG_NAME=\"\\\"qgroundcontrol.org\\\"\"
DEFINES += QGC_ORG_DOMAIN=\"\\\"org.qgroundcontrol\\\"\"

QGC_APP_NAME        = "Aeronavics GS"
QGC_BINARY_NAME     = "AeronavicsQGC"
QGC_ORG_NAME        = "Aeronavics"
QGC_ORG_DOMAIN      = "aeronavics.com"
QGC_APP_DESCRIPTION = "Aeronavics QGC Ground Station"
QGC_APP_COPYRIGHT   = "Copyright (C) 2019 QGroundControl Development Team. All rights reserved."

# Our own, custom resources
RESOURCES += \
    $$QGCROOT/custom/custom.qrc

QML_IMPORT_PATH += \
    $$QGCROOT/custom/res

# Our own, custom sources
SOURCES += \
    $$PWD/src/CustomMappingSettings.cc \
    $$PWD/src/CustomPlugin.cc \
    $$PWD/src/CustomLogManager.cc \
    $$PWD/src/CustomQuickInterface.cc \
    $$PWD/src/CustomWebODMManager.cc \


HEADERS += \
    $$PWD/src/CustomMappingSettings.h \
    $$PWD/src/CustomPlugin.h \
    $$PWD/src/CustomQuickInterface.h \
    $$PWD/src/CustomLogManager.h \
    $$PWD/src/CustomWebODMManager.h \

INCLUDEPATH += \
    $$PWD/src \


#-------------------------------------------------------------------------------------
# Custom Firmware/AutoPilot Plugin

INCLUDEPATH += \
    $$QGCROOT/custom/src/FirmwarePlugin \
    $$QGCROOT/custom/src/AutoPilotPlugin

HEADERS+= \
    $$QGCROOT/custom/src/AutoPilotPlugin/CustomAutoPilotPlugin.h \
    $$QGCROOT/custom/src/FirmwarePlugin/CustomCameraControl.h \
    $$QGCROOT/custom/src/FirmwarePlugin/CustomCameraManager.h \
    $$QGCROOT/custom/src/FirmwarePlugin/CustomFirmwarePlugin.h \
    $$QGCROOT/custom/src/FirmwarePlugin/CustomFirmwarePluginFactory.h \

SOURCES += \
    $$QGCROOT/custom/src/AutoPilotPlugin/CustomAutoPilotPlugin.cc \
    $$QGCROOT/custom/src/FirmwarePlugin/CustomCameraControl.cc \
    $$QGCROOT/custom/src/FirmwarePlugin/CustomCameraManager.cc \
    $$QGCROOT/custom/src/FirmwarePlugin/CustomFirmwarePlugin.cc \
    $$QGCROOT/custom/src/FirmwarePlugin/CustomFirmwarePluginFactory.cc \


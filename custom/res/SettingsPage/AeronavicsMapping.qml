 /****************************************************************************
 *
 *   (c) 2009-2016 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 *COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/


import QtQuick                  2.11
import QtQuick.Controls.Styles  1.4
import QtQuick.Dialogs          1.2
import QtQuick.Layouts          1.2
import QtQuick.Controls         2.4

import QGroundControl                       1.0
import QGroundControl.FactSystem            1.0
import QGroundControl.FactControls          1.0
import QGroundControl.Controls              1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.Palette               1.0
import QGroundControl.Controllers           1.0
import QGroundControl.SettingsManager       1.0

import CustomQuickInterface                 1.0

Rectangle {
    id:                 _root
    color:              qgcPal.window
    anchors.fill:       parent
    anchors.margins:    ScreenTools.defaultFontPixelWidth
    property real _labelWidth:                  ScreenTools.defaultFontPixelWidth * 20
    property real _comboFieldWidth:             ScreenTools.defaultFontPixelWidth * 28
    property real _valueFieldWidth:             ScreenTools.defaultFontPixelWidth * 10
    property real _baseFontEdit:                ScreenTools.defaultFontPixelHeight
    property string _mapProvider:               QGroundControl.settingsManager.flightMapSettings.mapProvider.value
    property string _mapType:                   QGroundControl.settingsManager.flightMapSettings.mapType.value
    property real _panelWidth:                  _root.width * _internalWidthRatio
    property real _margins:                     ScreenTools.defaultFontPixelWidth
    property real _columnSpacing:               ScreenTools.defaultFontPixelHeight * 0.25

    property string _videoSource:               QGroundControl.settingsManager.videoSettings.videoSource.value
    property bool   _isGst:                     QGroundControl.videoManager.isGStreamer
    property bool   _isUDP264:                  _isGst && _videoSource === QGroundControl.settingsManager.videoSettings.udp264VideoSource
    property bool   _isUDP265:                  _isGst && _videoSource === QGroundControl.settingsManager.videoSettings.udp265VideoSource
    property bool   _isRTSP:                    _isGst && _videoSource === QGroundControl.settingsManager.videoSettings.rtspVideoSource
    property bool   _isTCP:                     _isGst && _videoSource === QGroundControl.settingsManager.videoSettings.tcpVideoSource
    property bool   _isMPEGTS:                  _isGst && _videoSource === QGroundControl.settingsManager.videoSettings.mpegtsVideoSource 

    property string gpsDisabled: "Disabled"
    property string gpsUdpPort:  "UDP Port"

    readonly property real _internalWidthRatio: 0.8

    QGCPalette { id: qgcPal }

        QGCFlickable {
            clip:               true
            anchors.fill:       parent
            contentHeight:      outerItem.height
            contentWidth:       outerItem.width

            Item {
                id:     outerItem
                width:  Math.max(_root.width, settingsColumn.width)
                height: settingsColumn.height

                ColumnLayout {
                    id:                         settingsColumn
                    anchors.horizontalCenter:   parent.horizontalCenter

                    QGCLabel {
                        id: mappingMainLabel
                        text: qsTr("Aeronavics Mapping")
                    }
                    Rectangle {
                        Layout.preferredHeight: mappingMainGrid.height + (_margins * 2)
                        Layout.preferredWidth:  mappingMainGrid.width + (_margins * 2)
                        color:                  qgcPal.windowShade
                        Layout.fillWidth:       true

                        Column {
                            id:                mappingMainGrid
                            spacing:           _columnSpacing
                            anchors.centerIn:  parent

                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                QGCLabel {
                                    width:             _labelWidth
                                    anchors.bottom:  mappingSwitch.bottom
                                    text:              qsTr("Aeronavics Mapping: ")
                                }
                                QGCSwitch {
                                    id: mappingSwitch
                                    checked: CustomQuickInterface.mapSurvey
                                    anchors.verticalCenter: parent.verticalCenter
                                    onClicked: CustomQuickInterface.setMapSurvey(!CustomQuickInterface.mapSurvey)
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                QGCLabel{
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: CustomQuickInterface.correctCredentials?qsTr("Data from this flight will be uploaded for processing"):qsTr("Data will not be uploaded")
                                }
                            }
                        }
                    }
                    QGCLabel {
                        id:         unitsSectionLabel
                        text:       qsTr("Login Details")
                        visible: CustomQuickInterface.mapSurvey && !CustomQuickInterface.correctCredentials
                    }
                    Rectangle {
                        Layout.preferredHeight: unitsGrid.height + (_margins * 2)
                        Layout.preferredWidth:  unitsGrid.width + (_margins * 2)
                        color:                  qgcPal.windowShade
                        Layout.fillWidth:       true
                        visible: CustomQuickInterface.mapSurvey && !CustomQuickInterface.correctCredentials

                        Column {
                            id:                unitsGrid
                            spacing:           _columnSpacing
                            anchors.centerIn:  parent
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    width:             _labelWidth
                                    anchors.baseline:  serverField.baseline
                                    text:              qsTr("Server Address: ")
                                }
                                FactTextField {
                                    id: serverField
                                    width: _comboFieldWidth
                                    anchors.verticalCenter: parent.verticalCenter
                                    fact: CustomQuickInterface.customMappingSettings.server
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                
                                QGCLabel {
                                    width:             _labelWidth
                                    anchors.baseline:  usernameField.baseline
                                    text:              qsTr("WebODM Email: ")
                                }
                                FactTextField {
                                    id: usernameField
                                    width: _comboFieldWidth
                                    anchors.verticalCenter: parent.verticalCenter
                                    fact: CustomQuickInterface.customMappingSettings.email
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    width:             _labelWidth
                                    anchors.baseline:  passwordField.baseline
                                    text:              qsTr("WebODM Password: ")
                                }
                                QGCTextField {
                                    id: passwordField
                                    objectName: "test"
                                    width: _comboFieldWidth
                                    anchors.verticalCenter: parent.verticalCenter
                                    echoMode: TextInput.Password
                                    text: CustomQuickInterface.password
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                visible: Qt.platform.os !== "windows" && Qt.platform.os !== "winrt" && Qt.platform.os !== "android"

                                QGCLabel {
                                    width:             _labelWidth
                                    anchors.baseline:  userPasswordField.baseline
                                    text:              qsTr("Computer Password: ")
                                }
                                QGCTextField {
                                    id: userPasswordField
                                    width: _comboFieldWidth
                                    anchors.verticalCenter: parent.verticalCenter
                                    echoMode: TextInput.Password
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                QGCLabel{
                                    id: correctCredentials
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: CustomQuickInterface.correctCredentials?"Correct email and password":"Incorrect email or password"
                                    color: CustomQuickInterface.correctCredentials?qgcPal.text:qgcPal.warningText
                                }
                                QGCButton {
                                    id: checkButton
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: qsTr("Log in")
                                    onClicked: {
                                        CustomQuickInterface.login(passwordField.text, userPasswordField.text)
                                        passwordField.text = ""
                                        userPasswordField.text = ""
                                    }
                                }
                            }
                        }
                    }

                    Item { width: 1; height: _margins }

                    QGCLabel {
                        id:         taskNameLabel
                        text:       qsTr("Task Name")
                        visible: CustomQuickInterface.correctCredentials
                    }
                    Rectangle {
                        Layout.preferredWidth:  nameGrid.width + (_margins * 2)
                        Layout.preferredHeight: nameGrid.height + (_margins * 2)
                        Layout.fillWidth:       true
                        color:                  qgcPal.windowShade
                        visible: CustomQuickInterface.correctCredentials

                        Column {
                            id:                nameGrid
                            spacing:           _columnSpacing
                            anchors.centerIn:  parent

                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:           qsTr("Project Name: ")
                                    width:          _labelWidth
                                    anchors.baseline: projectNameField.baseline
                                }
                                FactTextField {
                                    id:                     projectNameField
                                    anchors.verticalCenter: parent.verticalCenter
                                    width:                  _comboFieldWidth
                                    fact: CustomQuickInterface.customMappingSettings.projectName
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:           qsTr("Task Name: ")
                                    width:          _labelWidth
                                    anchors.baseline: taskNameField.baseline
                                }
                                FactTextField {
                                    id:     taskNameField
                                    anchors.verticalCenter: parent.verticalCenter
                                    width:  _comboFieldWidth
                                    fact: CustomQuickInterface.customMappingSettings.taskName
                                }
                            }
                        }
                    }
                    Item { width: 1; height: _margins }
                    QGCLabel {
                        id:         processingOptionsLabel
                        text:       qsTr("Processing Options")
                        visible: CustomQuickInterface.correctCredentials
                    }
                    Rectangle {
                        Layout.preferredHeight: processingOptionsCol.height + (_margins * 2)
                        Layout.preferredWidth:  processingOptionsCol.width + (_margins * 2)
                        color:                  qgcPal.windowShade
                        Layout.fillWidth:       true
                        visible: CustomQuickInterface.correctCredentials

                        Column {
                            id:                         processingOptionsCol
                            spacing:                    _columnSpacing
                            anchors.centerIn:           parent
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactComboBox {
                                    id:      processingPresets
                                    anchors.baseline: parent.verticleCenter
                                    width:  _comboFieldWidth
                                    fact: CustomQuickInterface.customMappingSettings.processingPresets
                                    onActivated: CustomQuickInterface.presetChanged()
                                }
                                QGCButton {
                                    id: advancedSettingsButton
                                    width: _comboFieldWidth
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: qsTr("Advanced Settings")
                                    onClicked: CustomQuickInterface.setAdvancedSettings(!CustomQuickInterface.advancedSettings)
                                }                                
                            }
                        }
                    }
                    Item { width: 1; height: _margins }
                    QGCLabel {
                        id:         testLabel
                        text:       qsTr("Advanced Processing Options")
                        visible:    CustomQuickInterface.advancedSettings
                    }
                    Repeater {
                        model: [CustomQuickInterface.customMappingSettings.pcClassify,CustomQuickInterface.customMappingSettings.smrfScalar,CustomQuickInterface.customMappingSettings.opensfmDepthmapMinPatchSd,CustomQuickInterface.customMappingSettings.smrfWindow,CustomQuickInterface.customMappingSettings.meshOctreeDepth,CustomQuickInterface.customMappingSettings.minNumFeatures,CustomQuickInterface.customMappingSettings.resizeTo,CustomQuickInterface.customMappingSettings.smrfSlope,CustomQuickInterface.customMappingSettings.rerunFrom,CustomQuickInterface.customMappingSettings.use3dmesh,CustomQuickInterface.customMappingSettings.orthophotoCompression,CustomQuickInterface.customMappingSettings.mveConfidence,CustomQuickInterface.customMappingSettings.texturingSkipHoleFilling,CustomQuickInterface.customMappingSettings.texturingSkipGlobalSeamLeveling,CustomQuickInterface.customMappingSettings.texturingNadirWeight,CustomQuickInterface.customMappingSettings.texturingOutlierRemovalType,CustomQuickInterface.customMappingSettings.othrophotoResolution,CustomQuickInterface.customMappingSettings.dtm,CustomQuickInterface.customMappingSettings.orthophotoNoTiled,CustomQuickInterface.customMappingSettings.demResolution,CustomQuickInterface.customMappingSettings.meshSize,CustomQuickInterface.customMappingSettings.forceGPS,CustomQuickInterface.customMappingSettings.ignoreGsd,CustomQuickInterface.customMappingSettings.buildOverviews,CustomQuickInterface.customMappingSettings.opensfmDense,CustomQuickInterface.customMappingSettings.opensfmDepthmapMinConsistentViews,CustomQuickInterface.customMappingSettings.texturingSkipLocalSeamLeveling,CustomQuickInterface.customMappingSettings.debug,CustomQuickInterface.customMappingSettings.useExif,CustomQuickInterface.customMappingSettings.meshSamples,CustomQuickInterface.customMappingSettings.pcSample,CustomQuickInterface.customMappingSettings.matcherDistance,CustomQuickInterface.customMappingSettings.splitOverlap,CustomQuickInterface.customMappingSettings.demDecimation,CustomQuickInterface.customMappingSettings.orthophotoCutline,CustomQuickInterface.customMappingSettings.pcFilter,CustomQuickInterface.customMappingSettings.split,CustomQuickInterface.customMappingSettings.fastOrthophoto,CustomQuickInterface.customMappingSettings.pcEpt,CustomQuickInterface.customMappingSettings.crop,CustomQuickInterface.customMappingSettings.pcLas,CustomQuickInterface.customMappingSettings.merge,CustomQuickInterface.customMappingSettings.dsm,CustomQuickInterface.customMappingSettings.demGapfillSteps,CustomQuickInterface.customMappingSettings.meshPointWeight,CustomQuickInterface.customMappingSettings.maxConcurrency,CustomQuickInterface.customMappingSettings.texturingToneMapping,CustomQuickInterface.customMappingSettings.demEuclidianMap,CustomQuickInterface.customMappingSettings.cameraLens,CustomQuickInterface.customMappingSettings.skip3dmodel,CustomQuickInterface.customMappingSettings.matchNeighbours,CustomQuickInterface.customMappingSettings.pcCsv,CustomQuickInterface.customMappingSettings.endWith,CustomQuickInterface.customMappingSettings.depthmapResolution,CustomQuickInterface.customMappingSettings.texturingDataTerm,CustomQuickInterface.customMappingSettings.texturingSkipVisibilityTest,CustomQuickInterface.customMappingSettings.opensfmDepthmapMethod,CustomQuickInterface.customMappingSettings.useFixedCameraParams,CustomQuickInterface.customMappingSettings.smrfThreshold,CustomQuickInterface.customMappingSettings.verbose,CustomQuickInterface.customMappingSettings.useHybridBundleAdjustment]
                        MyCustom {
                            visible:    CustomQuickInterface.advancedSettings
                            fact: modelData
                        }
                    }
                }
            }
    }
}

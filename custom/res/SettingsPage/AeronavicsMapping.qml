 /****************************************************************************
 *
 *   (c) 2009-2016 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
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

    property Fact _percentRemainingAnnounce:    QGroundControl.settingsManager.appSettings.batteryPercentRemainingAnnounce
    property Fact _savePath:                    QGroundControl.settingsManager.appSettings.savePath
    property Fact _appFontPointSize:            QGroundControl.settingsManager.appSettings.appFontPointSize
    property Fact _userBrandImageIndoor:        QGroundControl.settingsManager.brandImageSettings.userBrandImageIndoor
    property Fact _userBrandImageOutdoor:       QGroundControl.settingsManager.brandImageSettings.userBrandImageOutdoor
    property real _labelWidth:                  ScreenTools.defaultFontPixelWidth * 20
    property real _comboFieldWidth:             ScreenTools.defaultFontPixelWidth * 28
    property real _valueFieldWidth:             ScreenTools.defaultFontPixelWidth * 10
    property real _baseFontEdit:                ScreenTools.defaultFontPixelHeight
    property string _mapProvider:               QGroundControl.settingsManager.flightMapSettings.mapProvider.value
    property string _mapType:                   QGroundControl.settingsManager.flightMapSettings.mapType.value
    property Fact _followTarget:                QGroundControl.settingsManager.appSettings.followTarget
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
                        id:         unitsSectionLabel
                        text:       qsTr("Login Details")
                        visible:    QGroundControl.settingsManager.unitsSettings.visible
                    }
                    Rectangle {
                        Layout.preferredHeight: unitsGrid.height + (_margins * 2)
                        Layout.preferredWidth:  unitsGrid.width + (_margins * 2)
                        color:                  qgcPal.windowShade
                        Layout.fillWidth:       true

                        Column {
                            id:                unitsGrid
                            spacing:           _columnSpacing
                            anchors.centerIn:  parent

                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                
                                QGCLabel {
                                    width:             _labelWidth
                                    anchors.baseline:  usernameField.baseline
                                    text:              qsTr("Email: ")
                                }
                                FactTextField {
                                    id: usernameField
                                    width: _comboFieldWidth
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: CustomQuickInterface.username
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    width:             _labelWidth
                                    anchors.baseline:  passwordField.baseline
                                    text:              qsTr("Password: ")
                                }
                                FactTextField {
                                    id: passwordField
                                    width: _comboFieldWidth
                                    anchors.verticalCenter: parent.verticalCenter
                                    echoMode: TextInput.Password
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCButton {
                                    id: checkButton
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("Check Credentials")
                                    property string toolTipText: passwordField.text
                                    ToolTip.visible: toolTipText ? checkma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: checkma
                                        anchors.fill: parent
                                        hoverEnabled: true
                                    }
                                }
                            }
                        }
                    }

                    Item { width: 1; height: _margins }

                    QGCLabel {
                        id:         taskNameLabel
                        text:       qsTr("Task Name")
                        visible:    QGroundControl.settingsManager.appSettings.visible
                    }
                    Rectangle {
                        Layout.preferredWidth:  nameGrid.width + (_margins * 2)
                        Layout.preferredHeight: nameGrid.height + (_margins * 2)
                        Layout.fillWidth:       true
                        color:                  qgcPal.windowShade

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
                                    visible: QGroundControl.settingsManager.appSettings.language.visible
                                }
                                FactTextField {
                                    id:                     projectNameField
                                    anchors.verticalCenter: parent.verticalCenter
                                    width:                  _comboFieldWidth
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:           qsTr("Task Name: ")
                                    width:          _labelWidth
                                    anchors.baseline: taskNameField.baseline
                                    visible: QGroundControl.settingsManager.appSettings.indoorPalette.visible
                                }
                                FactTextField {
                                    id:     taskNameField
                                    anchors.verticalCenter: parent.verticalCenter
                                    width:  _comboFieldWidth
                                }
                            }
                        }
                    }

                    Item { width: 1; height: _margins }
                    QGCLabel {
                        id:         processingOptionsLabel
                        text:       qsTr("Processing Options")
                    }
                    Rectangle {
                        Layout.preferredHeight: processingOptionsCol.height + (_margins * 2)
                        Layout.preferredWidth:  processingOptionsCol.width + (_margins * 2)
                        color:                  qgcPal.windowShade
                        Layout.fillWidth:       true

                        Column {
                            id:                         processingOptionsCol
                            spacing:                    _columnSpacing
                            anchors.centerIn:           parent
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                
                                QGCLabel {
                                    text:  qsTr("<b>pc-classify</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactCheckBox {
                                    id: pcclassify
                                    text: qsTr("Enable")
                                    width: _labelWidth
                                    anchors.baseline: pcclassifyInfo.baseline
                                    fact: QGroundControl.settingsManager.appSettings.pcClassify
                                }
                                QGCButton {
                                    id: pcclassifyInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    onClicked: mainWindow.showComponentDialog(helppcclassifyDialogComponent, qsTr("Value Details"), mainWindow.showDialogDefaultWidth, StandardButton.Save | StandardButton.Cancel)
                                    Component {
                                        id: helppcclassifyDialogComponent
                                        ParameterEditorDialog {
                                            fact: pcclassify.fact
                                        }
                                    }
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel { 
                                    text:  qsTr("<b>smrf-scalar (postitive float)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:     smrfScalar
                                    width:  _comboFieldWidth 
                                    fact: QGroundControl.settingsManager.appSettings.smrfScalar
                                }
                                
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                
                                QGCLabel {
                                    text:  qsTr("<b>opensfm-depthmap-min-patch-sd (postitive float)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:     opensfmDepthmapMinPatch
                                    width:  _comboFieldWidth
                                    fact: QGroundControl.settingsManager.appSettings.opensfmDepthmapMinPatchSd
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>smrf-window (postitive float)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      smrfWindow
                                    width:  _comboFieldWidth
                                    fact: QGroundControl.settingsManager.appSettings.smrfWindow
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel { 
                                    text:  qsTr("<b>mesh-octree-depth (postitive Integer)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      meshOctreeDepth
                                    width:  _comboFieldWidth
                                    fact: QGroundControl.settingsManager.appSettings.meshOctreeDepth
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>min-num-features (Integer)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth 
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      minNumFeatures
                                    width:  _comboFieldWidth
                                    fact: QGroundControl.settingsManager.appSettings.minNumFeatures
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>resize-to (Integer)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      resizeTo
                                    width:  _comboFieldWidth
                                    fact: QGroundControl.settingsManager.appSettings.resizeTo
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>smrf-slope (Positve Float)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      smrfSlope
                                    width:  _comboFieldWidth
                                    fact: QGroundControl.settingsManager.appSettings.smrfSlope
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>rerun-from</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactComboBox {
                                    id:      rerunFrom
                                    anchors.baseline: parent.verticleCenter
                                    width:  _comboFieldWidth
                                    fact: QGroundControl.settingsManager.appSettings.rerunFrom
                                }
                                QGCButton {
                                    id: rerunFromInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    onClicked: mainWindow.showComponentDialog(helprerunFromDialogComponent, qsTr("Value Details"), mainWindow.showDialogDefaultWidth, StandardButton.Save | StandardButton.Cancel)
                                    Component {
                                        id: helprerunFromDialogComponent
                                        ParameterEditorDialog {
                                            fact: rerunFrom.fact
                                        }
                                    }

                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                
                                QGCLabel {
                                    text:  qsTr("<b>use-3dmesh</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactCheckBox {
                                    id: use3Dmesh
                                    text: qsTr("Enable")
                                    width: _labelWidth
                                    anchors.baseline: use3DmeshInfo.baseline
                                    fact: QGroundControl.settingsManager.appSettings.use3dmesh
                                }
                                QGCButton {
                                    id: use3DmeshInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    onClicked: mainWindow.showComponentDialog(helpuse3dDialogComponent, qsTr("Value Details"), mainWindow.showDialogDefaultWidth, StandardButton.Save | StandardButton.Cancel)
                                    Component {
                                        id: helpuse3dDialogComponent
                                        ParameterEditorDialog {
                                            fact: use3Dmesh.fact
                                        }
                                    }
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>orthophoto-compression</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactComboBox { 
                                    id:      orthophotoCompression
                                    anchors.baseline: parent.verticleCenter
                                    width:  _comboFieldWidth
                                    fact: QGroundControl.settingsManager.appSettings.orthophotoCompression
                                }
                                QGCButton {
                                    id: orthophotoCompressionInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    onClicked: mainWindow.showComponentDialog(helporthophotoCompressionDialogComponent, qsTr("Value Details"), mainWindow.showDialogDefaultWidth, StandardButton.Save | StandardButton.Cancel)
                                    Component {
                                        id: helporthophotoCompressionDialogComponent
                                        ParameterEditorDialog {
                                            fact: orthophotoCompression.fact
                                        }
                                    }
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>mve-confidence (Float: 0 <= x <= 1)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      mveConfidence
                                    width:  _comboFieldWidth
                                    fact: QGroundControl.settingsManager.appSettings.mveConfidence
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>texturing-skip-hole-filling</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactCheckBox {
                                    id: texturingSkipHoleFilling
                                    text: qsTr("Enable")
                                    width: _labelWidth
                                    anchors.baseline: texturingSkipHoleFillingInfo.baseline
                                    fact: QGroundControl.settingsManager.appSettings.texturingSkipHoleFilling
                                }
                                QGCButton {
                                    id: texturingSkipHoleFillingInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    onClicked: mainWindow.showComponentDialog(helptexturingSkipHoleFillingDialogComponent, qsTr("Value Details"), mainWindow.showDialogDefaultWidth, StandardButton.Save | StandardButton.Cancel)
                                    Component {
                                        id: helptexturingSkipHoleFillingDialogComponent
                                        ParameterEditorDialog {
                                            fact: texturingSkipHoleFilling.fact
                                        }
                                    }
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>texturing-skip-global-seam-leveling</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactCheckBox {
                                    id: texturingSkipSeamFilling
                                    text: qsTr("Enable")
                                    width: _labelWidth
                                    anchors.baseline: texturingSkipSeamFillingInfo.baseline
                                    fact: QGroundControl.settingsManager.appSettings.texturingSkipGlobalSeamLeveling
                                }
                                QGCButton {
                                    id: texturingSkipSeamFillingInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    onClicked: mainWindow.showComponentDialog(helptexturingSkipSeamFillingDialogComponent, qsTr("Value Details"), mainWindow.showDialogDefaultWidth, StandardButton.Save | StandardButton.Cancel)
                                    Component {
                                        id: helptexturingSkipSeamFillingDialogComponent
                                        ParameterEditorDialog {
                                            fact: texturingSkipSeamFilling.fact
                                        }
                                    }
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {   
                                    text:  qsTr("<b>Texturing-nadir-weight (Integer: 0 <= x <= 32)<b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      testuringNadirweight
                                    fact: QGroundControl.settingsManager.appSettings.TexturingNadirWeight
                                    width:  _comboFieldWidth
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {   
                                    text:  qsTr("<b>Texturing-outlier-removal-type</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactComboBox { 
                                    id:      texturingOutlierRemoveType
                                    anchors.baseline: parent.verticleCenter
                                    fact: QGroundControl.settingsManager.appSettings.TexturingOutlierRemovalType
                                    width:  _comboFieldWidth
                                }
                                QGCButton {
                                    id: texturingOutlierRemoveTypeInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    onClicked: mainWindow.showComponentDialog(helptexturingOutlierRemoveTypeDialogComponent, qsTr("Value Details"), mainWindow.showDialogDefaultWidth, StandardButton.Save | StandardButton.Cancel)
                                    Component {
                                        id: helptexturingOutlierRemoveTypeDialogComponent
                                        ParameterEditorDialog {
                                            fact: texturingOutlierRemoveType.fact
                                        } 
                                    }
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {   
                                    text:  qsTr("<b>Othrophoto-resolution (Float > 0.0)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      othroRes
                                    width:  _comboFieldWidth
                                    fact: QGroundControl.settingsManager.appSettings.OthrophotoResolution
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>dtm</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactCheckBox {
                                    id: dtm
                                    text: qsTr("Enable")
                                    width: _labelWidth
                                    anchors.baseline: dtmInfo.baseline
                                    fact: QGroundControl.settingsManager.appSettings.dtm
                                }
                                QGCButton {
                                    id: dtmInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    onClicked: mainWindow.showComponentDialog(helpdtmDialogComponent, qsTr("Value Details"), mainWindow.showDialogDefaultWidth, StandardButton.Save | StandardButton.Cancel)
                                    Component {
                                        id: helpdtmDialogComponent
                                        ParameterEditorDialog {
                                            fact: dtm.fact
                                        }
                                    }
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>orthophoto-no-tiled</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactCheckBox {
                                    id: orthoNoTiled
                                    text: qsTr("Enable")
                                    width: _labelWidth
                                    fact: QGroundControl.settingsManager.appSettings.orthophotoNoTiled
                                    anchors.baseline: orthoNoTiledInfo.baseline
                                }
                                QGCButton {
                                    id: orthoNoTiledInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    onClicked: mainWindow.showComponentDialog(helporthoNoTiledDialogComponent, qsTr("Value Details"), mainWindow.showDialogDefaultWidth, StandardButton.Save | StandardButton.Cancel)
                                    Component {
                                        id: helporthoNoTiledDialogComponent
                                        ParameterEditorDialog {
                                            fact: orthoNoTiled.fact
                                        }
                                    }
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {   
                                    text:  qsTr("<b>dem-resolution (Float > 0.0)</b>")
                                }   
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      demRes
                                    width:  _comboFieldWidth
                                    fact: QGroundControl.settingsManager.appSettings.demResolution
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>mesh-size (Positive Integer)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      meshSize
                                    width:  _comboFieldWidth
                                    fact: QGroundControl.settingsManager.appSettings.meshSize
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>force-GPS</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter

                                FactCheckBox {
                                    id: forceGPS
                                    text: qsTr("Enable")
                                    width: _labelWidth
                                    fact: QGroundControl.settingsManager.appSettings.forceGPS
                                    anchors.baseline: forceGPSInfo.baseline
                                }
                                QGCButton {
                                    id: forceGPSInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    onClicked: mainWindow.showComponentDialog(helpforceGPSDialogComponent, qsTr("Value Details"), mainWindow.showDialogDefaultWidth, StandardButton.Save | StandardButton.Cancel)
                                    Component {
                                        id: helpforceGPSDialogComponent
                                        ParameterEditorDialog {
                                            fact: forceGPS.fact
                                        }
                                    }
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>ignore-gsd</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactCheckBox {
                                    id: ignoregsd
                                    text: qsTr("Enable")
                                    width: _labelWidth
                                    anchors.baseline: ignoregsdInfo.baseline
                                    fact: QGroundControl.settingsManager.appSettings.ignoreGsd
                                }
                                QGCButton {
                                    id: ignoregsdInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    onClicked: mainWindow.showComponentDialog(helpignoregsdDialogComponent, qsTr("Value Details"), mainWindow.showDialogDefaultWidth, StandardButton.Save | StandardButton.Cancel)
                                    Component {
                                        id: helpignoregsdDialogComponent
                                        ParameterEditorDialog {
                                            fact: ignoregsd.fact
                                        }
                                    }
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>build-overviews</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter

                                FactCheckBox {
                                    id: buildOverviews
                                    text: qsTr("Enable")
                                    width: _labelWidth
                                    anchors.baseline: buildOverviewsInfo.baseline
                                    fact: QGroundControl.settingsManager.appSettings.buildOverviews
                                }
                                QGCButton {
                                    id: buildOverviewsInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    onClicked: mainWindow.showComponentDialog(helpbuildOverviewsDialogComponent, qsTr("Value Details"), mainWindow.showDialogDefaultWidth, StandardButton.Save | StandardButton.Cancel)
                                    Component {
                                        id: helpbuildOverviewsDialogComponent
                                        ParameterEditorDialog {
                                            fact: buildOverviews.fact
                                        }
                                    }
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>opensfm-dense</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter

                                FactCheckBox {
                                    id: opensfmDense
                                    text: qsTr("Enable")
                                    width: _labelWidth
                                    anchors.baseline: opensfmDenseInfo.baseline
                                    fact: QGroundControl.settingsManager.appSettings.opensfmDense
                                }
                                QGCButton {
                                    id: opensfmDenseInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    onClicked: mainWindow.showComponentDialog(helpopensfmDenseDialogComponent, qsTr("Value Details"), mainWindow.showDialogDefaultWidth, StandardButton.Save | StandardButton.Cancel)
                                    Component {
                                        id: helpopensfmDenseDialogComponent
                                        ParameterEditorDialog {
                                            fact: opensfmDense.fact
                                        }
                                    }
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>opensfm-depthmap-min-consistent-views (Integer: 2<=x<=9)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      opensfmDepthmapMinConsistentViews
                                    width:  _comboFieldWidth
                                    fact: QGroundControl.settingsManager.appSettings.opensfmDepthmapMinConsistentViews
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>textureing-skip-local-seam-leveling</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter

                                FactCheckBox {
                                    id: texturingSkipLocalSeamLeveling
                                    text: qsTr("Enable")
                                    width: _labelWidth
                                    anchors.baseline: texturingSkipLocalSeamLevelingInfo.baseline
                                    fact: QGroundControl.settingsManager.appSettings.textureingSkipLocalSeamLeveling
                                }
                                QGCButton {
                                    id: texturingSkipLocalSeamLevelingInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    onClicked: mainWindow.showComponentDialog(helptexturingSkipLocalSeamLevelingDialogComponent, qsTr("Value Details"), mainWindow.showDialogDefaultWidth, StandardButton.Save | StandardButton.Cancel)
                                    Component {
                                        id: helptexturingSkipLocalSeamLevelingDialogComponent
                                        ParameterEditorDialog {
                                            fact: texturingSkipLocalSeamLeveling.fact
                                        }
                                    }
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>textureing-keep-unseen-faces</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter

                                FactCheckBox {
                                    id: texturingKeepUnseenFaces
                                    text: qsTr("Enable")
                                    width: _labelWidth
                                    anchors.baseline: texturingKeepUnseenFacesInfo.baseline
                                    fact: QGroundControl.settingsManager.appSettings.textureingKeepUnseenFaces
                                }
                                QGCButton {
                                    id: texturingKeepUnseenFacesInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    onClicked: mainWindow.showComponentDialog(helptexturingKeepUnseenFacesDialogComponent, qsTr("Value Details"), mainWindow.showDialogDefaultWidth, StandardButton.Save | StandardButton.Cancel)
                                    Component {
                                        id: helptexturingKeepUnseenFacesDialogComponent
                                        ParameterEditorDialog {
                                            fact: texturingKeepUnseenFaces.fact
                                        }
                                    }
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>debug</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter

                                FactCheckBox {
                                    id: debug
                                    text: qsTr("Enable")
                                    width: _labelWidth
                                    anchors.baseline: debugInfo.baseline
                                    fact: QGroundControl.settingsManager.appSettings.debug
                                }
                                QGCButton {
                                    id: debugInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    onClicked: mainWindow.showComponentDialog(helpdebugDialogComponent, qsTr("Value Details"), mainWindow.showDialogDefaultWidth, StandardButton.Save | StandardButton.Cancel)
                                    Component {
                                        id: helpdebugDialogComponent
                                        ParameterEditorDialog {
                                            fact: debug.fact
                                        }
                                    }
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>use-exif</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter

                                FactCheckBox {
                                    id: useExif
                                    text: qsTr("Enable")
                                    width: _labelWidth
                                    anchors.baseline: useExifInfo.baseline
                                    fact: QGroundControl.settingsManager.appSettings.useExif
                                }
                                QGCButton {
                                    id: useExifInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    onClicked: mainWindow.showComponentDialog(helpuseExifDialogComponent, qsTr("Value Details"), mainWindow.showDialogDefaultWidth, StandardButton.Save | StandardButton.Cancel)
                                    Component {
                                        id: helpuseExifDialogComponent
                                        ParameterEditorDialog {
                                            fact: useExif.fact
                                        }
                                    }
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>mesh-samples (Float >= 1.0)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      meshSamples
                                    width:  _comboFieldWidth
                                    fact: QGroundControl.settingsManager.appSettings.meshSamples
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>pc-sample (Positive Integer)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      pcSample
                                    width:  _comboFieldWidth
                                    fact: QGroundControl.settingsManager.appSettings.pcSample
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>matcher-distance (Integer)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      matcherDistance
                                    width:  _comboFieldWidth
                                    fact: QGroundControl.settingsManager.appSettings.matcherDistance
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>split-overlap (Positive Integer)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      splitOverlap
                                    width:  _comboFieldWidth
                                    fact: QGroundControl.settingsManager.appSettings.splitOverlap
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>dem-decimation (Positive Integer)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      demDecimation
                                    width:  _comboFieldWidth
                                    fact: QGroundControl.settingsManager.appSettings.demDecimation
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>orthophoto-cutline</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter

                                FactCheckBox {
                                    id: orthoCutline
                                    text: qsTr("Enable")
                                    width: _labelWidth
                                    anchors.baseline: orthoCutlineInfo.baseline
                                    fact: QGroundControl.settingsManager.appSettings.orthophotoCutline
                                }
                                QGCButton {
                                    id: orthoCutlineInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    onClicked: mainWindow.showComponentDialog(helporthoCutlineDialogComponent, qsTr("Value Details"), mainWindow.showDialogDefaultWidth, StandardButton.Save | StandardButton.Cancel)
                                    Component {
                                        id: helporthoCutlineDialogComponent
                                        ParameterEditorDialog {
                                            fact: orthoCutline.fact
                                        }
                                    }
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>pc-filter (Positive Float)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      pcFilter
                                    width:  _comboFieldWidth
                                    fact: QGroundControl.settingsManager.appSettings.pcFilter
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>split (Positive Integer)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      split
                                    width:  _comboFieldWidth
                                    fact: QGroundControl.settingsManager.appSettings.split
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>fast-orthophoto</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter

                                FactCheckBox {
                                    id: fastOrtho
                                    text: qsTr("Enable")
                                    width: _labelWidth
                                    anchors.baseline: fastOrthoInfo.baseline
                                    fact: QGroundControl.settingsManager.appSettings.fastOrthophoto
                                }
                                QGCButton {
                                    id: fastOrthoInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    onClicked: mainWindow.showComponentDialog(helpfastOrthoDialogComponent, qsTr("Value Details"), mainWindow.showDialogDefaultWidth, StandardButton.Save | StandardButton.Cancel)
                                    Component {
                                        id: helpfastOrthoDialogComponent
                                        ParameterEditorDialog {
                                            fact: fastOrtho.fact
                                        }
                                    }
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>pc-ept</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter

                                FactCheckBox {
                                    id: pcEpt
                                    text: qsTr("Enable")
                                    width: _labelWidth
                                    anchors.baseline: pcEptInfo.baseline
                                    fact: QGroundControl.settingsManager.appSettings.pcEpt
                                }
                                QGCButton {
                                    id: pcEptInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    onClicked: mainWindow.showComponentDialog(helppcEptDialogComponent, qsTr("Value Details"), mainWindow.showDialogDefaultWidth, StandardButton.Save | StandardButton.Cancel)
                                    Component {
                                        id: helppcEptDialogComponent
                                        ParameterEditorDialog {
                                            fact: pcEpt.fact
                                        }
                                    }
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>crop (Positive Float)</b>")
                                }
                            }   
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      crop
                                    width:  _comboFieldWidth
                                    fact: QGroundControl.settingsManager.appSettings.crop
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>pc-las</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter

                                FactCheckBox {
                                    id: pcLas
                                    text: qsTr("Enable")
                                    width: _labelWidth
                                    anchors.baseline: pcLasInfo.baseline
                                    fact: QGroundControl.settingsManager.appSettings.pcLas
                                }
                                QGCButton {
                                    id: pcLasInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    onClicked: mainWindow.showComponentDialog(helppcLasDialogComponent, qsTr("Value Details"), mainWindow.showDialogDefaultWidth, StandardButton.Save | StandardButton.Cancel)
                                    Component {
                                        id: helppcLasDialogComponent
                                        ParameterEditorDialog {
                                            fact: pcLas.fact
                                        }
                                    }
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>merge</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactComboBox {
                                    id:      merge
                                    anchors.baseline: parent.verticleCenter
                                    width:  _comboFieldWidth
                                    fact: QGroundControl.settingsManager.appSettings.merge
                                }
                                QGCButton {
                                    id: mergeInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    onClicked: mainWindow.showComponentDialog(helpmergeDialogComponent, qsTr("Value Details"), mainWindow.showDialogDefaultWidth, StandardButton.Save | StandardButton.Cancel)
                                    Component {
                                        id: helpmergeDialogComponent
                                        ParameterEditorDialog {
                                            fact: merge.fact
                                        }
                                    }
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel { 
                                    text:  qsTr("<b>dsm</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter

                                FactCheckBox {
                                    id: dsm
                                    text: qsTr("Enable")
                                    width: _labelWidth
                                    anchors.baseline: dsmInfo.baseline
                                    fact: QGroundControl.settingsManager.appSettings.dsm
                                }
                                QGCButton {
                                    id: dsmInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    onClicked: mainWindow.showComponentDialog(helpdsmDialogComponent, qsTr("Value Details"), mainWindow.showDialogDefaultWidth, StandardButton.Save | StandardButton.Cancel)
                                    Component {
                                        id: helpdsmDialogComponent
                                        ParameterEditorDialog {
                                            fact: dsm.fact
                                        }
                                    }
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>dem-gapfill-steps (Positive Integer)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      demGapfillSteps
                                    width:  _comboFieldWidth
                                    fact: QGroundControl.settingsManager.appSettings.demGapfillSteps
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>mesh-point-weight (Positive Float)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      meshPointWeight
                                    width:  _comboFieldWidth
                                    fact: QGroundControl.settingsManager.appSettings.meshPointWeight
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>max-concurrency (Positive Integer)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      maxConcurrency
                                    width:  _comboFieldWidth
                                    fact: QGroundControl.settingsManager.appSettings.maxConcurrency
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {   
                                    text:  qsTr("<b>texturing-tone-mapping</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactComboBox {
                                    id:     textureToneMapping
                                    anchors.baseline: parent.verticleCenter
                                    width:  _comboFieldWidth
                                    fact: QGroundControl.settingsManager.appSettings.texturingToneMapping
                                }
                                QGCButton {
                                    id: textureToneMappingInfo 
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    onClicked: mainWindow.showComponentDialog(helptextureToneMappingDialogComponent, qsTr("Value Details"), mainWindow.showDialogDefaultWidth, StandardButton.Save | StandardButton.Cancel)
                                    Component {
                                        id: helptextureToneMappingDialogComponent
                                        ParameterEditorDialog {
                                            fact: textureToneMapping.fact
                                        }
                                    }
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>dem-euclidian-map</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter

                                FactCheckBox {
                                    id: demEuclidianMap
                                    text: qsTr("Enable")
                                    width: _labelWidth
                                    anchors.baseline: demEuclidianMapInfo.baseline
                                    fact: QGroundControl.settingsManager.appSettings.demEuclidianMap
                                }
                                QGCButton {
                                    id: demEuclidianMapInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    onClicked: mainWindow.showComponentDialog(helpdemEuclidianMapDialogComponent, qsTr("Value Details"), mainWindow.showDialogDefaultWidth, StandardButton.Save | StandardButton.Cancel)
                                    Component {
                                        id: helpdemEuclidianMapDialogComponent
                                        ParameterEditorDialog {
                                            fact: demEuclidianMap.fact
                                        }
                                    }
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>camera-lens</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactComboBox {
                                    id:     cameraLens
                                    anchors.baseline: parent.verticleCenter
                                    width:  _comboFieldWidth
                                    fact: QGroundControl.settingsManager.appSettings.cameraLens
                                }
                                QGCButton {
                                    id: cameraLensInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    onClicked: mainWindow.showComponentDialog(helpcameraLensDialogComponent, qsTr("Value Details"), mainWindow.showDialogDefaultWidth, StandardButton.Save | StandardButton.Cancel)
                                    Component {
                                        id: helpcameraLensDialogComponent
                                        ParameterEditorDialog {
                                            fact: cameraLens.fact
                                        }
                                    }
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>skip-3dmodel</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter

                                FactCheckBox {
                                    id: skip3dmodel
                                    text: qsTr("Enable")
                                    width: _labelWidth
                                    anchors.baseline: skip3dmodelInfo.baseline
                                    fact: QGroundControl.settingsManager.appSettings.skip3dmodel
                                }
                                QGCButton {
                                    id: skip3dmodelInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    onClicked: mainWindow.showComponentDialog(helpskip3dmodelDialogComponent, qsTr("Value Details"), mainWindow.showDialogDefaultWidth, StandardButton.Save | StandardButton.Cancel)
                                    Component {
                                        id: helpskip3dmodelDialogComponent
                                        ParameterEditorDialog {
                                            fact: skip3dmodel.fact
                                        }
                                    }
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>match-neighbours (Positive Integer)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      matchNeighbours
                                    width:  _comboFieldWidth
                                    fact: QGroundControl.settingsManager.appSettings.matchNeighbours
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>pc-csv</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter

                                FactCheckBox {
                                    id: pcCsv
                                    text: qsTr("Enable")
                                    width: _labelWidth
                                    fact: QGroundControl.settingsManager.appSettings.pcCsv
                                    anchors.baseline: pcCsvInfo.baseline
                                }
                                QGCButton {
                                    id: pcCsvInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    onClicked: mainWindow.showComponentDialog(helppcCsvDialogComponent, qsTr("Value Details"), mainWindow.showDialogDefaultWidth, StandardButton.Save | StandardButton.Cancel)
                                    Component {
                                        id: helppcCsvDialogComponent
                                        ParameterEditorDialog {
                                            fact: pcCsv.fact
                                        }
                                    }
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>end-with</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactComboBox {
                                    id:     endWith
                                    anchors.baseline: parent.verticleCenter
                                    width:  _comboFieldWidth
                                    fact: QGroundControl.settingsManager.appSettings.endWith
                                }
                                QGCButton {
                                    id: endWithInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    onClicked: mainWindow.showComponentDialog(helpendWithDialogComponent, qsTr("Value Details"), mainWindow.showDialogDefaultWidth, StandardButton.Save | StandardButton.Cancel)
                                    Component {
                                        id: helpendWithDialogComponent
                                        ParameterEditorDialog {
                                            fact: endWith.fact
                                        }
                                    }
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>depthmap-resolution (Positive Float)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      depthmapRes
                                    width:  _comboFieldWidth
                                    fact: QGroundControl.settingsManager.appSettings.depthmapResolution
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>texturing-data-term</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactComboBox {
                                    id:     texturingDataTerm
                                    anchors.baseline: parent.verticleCenter
                                    width:  _comboFieldWidth
                                    fact: QGroundControl.settingsManager.appSettings.texturingDataTerm
                                }
                                QGCButton {
                                    id: texturingDataTermInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    onClicked: mainWindow.showComponentDialog(helptexturingDataTermDialogComponent, qsTr("Value Details"), mainWindow.showDialogDefaultWidth, StandardButton.Save | StandardButton.Cancel)
                                    Component {
                                        id: helptexturingDataTermDialogComponent
                                        ParameterEditorDialog {
                                            fact: texturingDataTerm.fact
                                        }
                                    }
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>texturing-skip-visibility-test</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter

                                FactCheckBox {
                                    id: texturingSkipVisibilityTest
                                    text: qsTr("Enable")
                                    width: _labelWidth
                                    anchors.baseline: texturingSkipVisibilityTestInfo.baseline
                                    fact: QGroundControl.settingsManager.appSettings.texturingSkipVisibilityTest
                                }
                                QGCButton {
                                    id: texturingSkipVisibilityTestInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    onClicked: mainWindow.showComponentDialog(helptexturingSkipVisibilityTestTermDialogComponent, qsTr("Value Details"), mainWindow.showDialogDefaultWidth, StandardButton.Save | StandardButton.Cancel)
                                    Component {
                                        id: helptexturingSkipVisibilityTestTermDialogComponent
                                        ParameterEditorDialog {
                                            fact: texturingSkipVisibilityTest.fact
                                        }
                                    }
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>opensfm-depthmap-method</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactComboBox {
                                    id:     opensfmDepthmapMethod
                                    anchors.baseline: parent.verticleCenter
                                    width:  _comboFieldWidth
                                    fact: QGroundControl.settingsManager.appSettings.opensfmDepthmapMethod
                                }
                                QGCButton {
                                    id: opensfmDepthmapMethodInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    onClicked: mainWindow.showComponentDialog(helpopensfmDepthmapMethodDialogComponent, qsTr("Value Details"), mainWindow.showDialogDefaultWidth, StandardButton.Save | StandardButton.Cancel)
                                    Component {
                                        id: helpopensfmDepthmapMethodDialogComponent
                                        ParameterEditorDialog {
                                            fact: opensfmDepthmapMethod.fact
                                        }
                                    }
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>use-fixed-camera-params</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter

                                FactCheckBox {
                                    id: fixedCameraParams
                                    text: qsTr("Enable")
                                    width: _labelWidth
                                    anchors.baseline: fixedCameraParamsInfo.baseline
                                    fact: QGroundControl.settingsManager.appSettings.useFixedCameraParams
                                }
                                QGCButton {
                                    id: fixedCameraParamsInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    onClicked: mainWindow.showComponentDialog(helpfixedCameraParamsDialogComponent, qsTr("Value Details"), mainWindow.showDialogDefaultWidth, StandardButton.Save | StandardButton.Cancel)
                                    Component {
                                        id: helpfixedCameraParamsDialogComponent
                                        ParameterEditorDialog {
                                            fact: fixedCameraParams.fact
                                        }
                                    }
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>smrf-threshold (Positive Float)<b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      smrfThreshold
                                    width:  _comboFieldWidth
                                    fact: QGroundControl.settingsManager.appSettings.smrfThreshold
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>verbose</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter

                                FactCheckBox {
                                    id: verbose
                                    text: qsTr("Enable")
                                    width: _labelWidth
                                    anchors.baseline: verboseInfo.baseline
                                    fact: QGroundControl.settingsManager.appSettings.verbose
                                }
                                QGCButton {
                                    id: verboseInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    onClicked: mainWindow.showComponentDialog(helpverboseDialogComponent, qsTr("Value Details"), mainWindow.showDialogDefaultWidth, StandardButton.Save | StandardButton.Cancel)
                                    Component {
                                        id: helpverboseDialogComponent
                                        ParameterEditorDialog {
                                            fact: verbose.fact
                                        }
                                    }
                                }
                            }
                            MenuSeparator {
                                padding: 0
                                topPadding: 5
                                bottomPadding: 5
                                contentItem: Rectangle {
                                    implicitWidth: 400
                                    implicitHeight: 2
                                    color: qgcPal.window
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("<b>use-hybrid-bundle-adjustment</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter

                                FactCheckBox {
                                    id: hybridBundleAdjustment
                                    text: qsTr("Enable")
                                    width: _labelWidth
                                    anchors.baseline: hybridBundleAdjustmentInfo.baseline
                                    fact: QGroundControl.settingsManager.appSettings.useHybridBundleAdjustment
                                }
                                QGCButton {
                                    id: hybridBundleAdjustmentInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    onClicked: mainWindow.showComponentDialog(helphybridBundleAdjustmentDialogComponent, qsTr("Value Details"), mainWindow.showDialogDefaultWidth, StandardButton.Save | StandardButton.Cancel)
                                    Component {
                                        id: helphybridBundleAdjustmentDialogComponent
                                        ParameterEditorDialog {
                                            fact: hybridBundleAdjustment.fact
                                        }
                                    }
                                }
                            }
                        }
                    }
                } // settingsColumn
            }
        
    }
}

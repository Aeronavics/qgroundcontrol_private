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
                                    anchors.baseline: rerunFromInfo.baseline
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
                                    property string toolTipText: "Use a fill 3D mesh to compute the orthophoto instead of a 2.5D mesh. This option is a bit faster and provides similar results in planar areas. Default: false"
                                    ToolTip.visible: toolTipText ? use3Dmeshma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: use3Dmeshma
                                        anchors.fill: parent
                                        hoverEnabled: true
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
                                    anchors.baseline: orthophotoCompressionInfo.baseline
                                    width:  _comboFieldWidth
                                    fact: QGroundControl.settingsManager.appSettings.orthophotoCompression
                                }
                                QGCButton {
                                    id: orthophotoCompressionInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    property string toolTipText: "Set the compression to use. Note that this could break gdal_translate if you don't know what you are doing. Default deflate"
                                    ToolTip.visible: toolTipText ? orthophotoCompressionma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: orthophotoCompressionma
                                        anchors.fill: parent
                                        hoverEnabled: true
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
                                    property string toolTipText: "Skip filling hole in the mesh. Default: false"
                                    ToolTip.visible: toolTipText ? texturingSkipHoleFillingma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: texturingSkipHoleFillingma
                                        anchors.fill: parent
                                        hoverEnabled: true
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
                                    property string toolTipText: "Skip global seam leveling. Useful for IR data. Default: false"
                                    ToolTip.visible: toolTipText ? texturingSkipSeamFillingma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: texturingSkipSeamFillingma
                                        anchors.fill: parent
                                        hoverEnabled: true
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
                                    anchors.baseline: texturingOutlierRemoveTypeInfo.baseline
                                    fact: QGroundControl.settingsManager.appSettings.TexturingOutlierRemovalType
                                    width:  _comboFieldWidth
                                }
                                QGCButton {
                                    id: texturingOutlierRemoveTypeInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    property string toolTipText: "Type of photometric outlier removal method. Default gauss clamping"
                                    ToolTip.visible: toolTipText ? texturingOutlierRemoveTypema.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: texturingOutlierRemoveTypema
                                        anchors.fill: parent
                                        hoverEnabled: true
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
                                    property string toolTipText: "Use this tag to build a DTM (Digital Terrain Model, ground only) using a simple morphological filter. Check the --dem* and --smrf* parameters for finer tuning. Default: false"
                                    ToolTip.visible: toolTipText ? dtmma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: dtmma
                                        anchors.fill: parent
                                        hoverEnabled: true
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
                                    property string toolTipText: "Set this parameter if you want a stripped geoTIFF. Default: false"
                                    ToolTip.visible: toolTipText ? orthoNoTiledma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: orthoNoTiledma
                                        anchors.fill: parent
                                        hoverEnabled: true
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
                                    property string toolTipText: "Uses images' GPS exif data for reconstruction, even if there are GCPs present. This flag is useful if you have high precision GPS measurements. If there are no GCPs, this flag does nothing. Default: false"
                                    ToolTip.visible: toolTipText ? forceGPSma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: forceGPSma
                                        anchors.fill: parent
                                        hoverEnabled: true
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
                                    property string toolTipText: "Ignore ground sampling distance (GSD). GSD caps the maximum resolution of image outputs and resizes images when necessary, resulting in faster processing and lower memory usage. Since GSD is an estimate, sometimes ignoring it can result in slightly better image output quality. Default: false"
                                    ToolTip.visible: toolTipText ? ignoregsdma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: ignoregsdma
                                        anchors.fill: parent
                                        hoverEnabled: true
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
                                    property string toolTipText: "Build orthophoto overviews using gdaladdo. Default: false"
                                    ToolTip.visible: toolTipText ? buildOverviewsma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: buildOverviewsma
                                        anchors.fill: parent
                                        hoverEnabled: true
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
                                    property string toolTipText: "Use opensfm to compute dense point cloud alternatively. Default: false"
                                    ToolTip.visible: toolTipText ? opensfmDensema.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: opensfmDensema
                                        anchors.fill: parent
                                        hoverEnabled: true
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
                                    property string toolTipText: "Skip local seam blending. Default: false"
                                    ToolTip.visible: toolTipText ? texturingSkipLocalSeamLevelingma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: texturingSkipLocalSeamLevelingma
                                        anchors.fill: parent
                                        hoverEnabled: true
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
                                    property string toolTipText: "Keep faces in the mesh that are not seen in any camera. Default: false"
                                    ToolTip.visible: toolTipText ? texturingKeepUnseenFacesma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: texturingKeepUnseenFacesma
                                        anchors.fill: parent
                                        hoverEnabled: true
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
                                    property string toolTipText: "Print debug messages. Default: false"
                                    ToolTip.visible: toolTipText ? debugma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: debugma
                                        anchors.fill: parent
                                        hoverEnabled: true
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
                                    property string toolTipText: "Use this tag when you have a gcp_list.txt but want to use exif geotags instead. Default: false"
                                    ToolTip.visible: toolTipText ? useExifma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: useExifma
                                        anchors.fill: parent
                                        hoverEnabled: true
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
                                    property string toolTipText: "Generates a polygon around the cropping area that cuts the orthophoto around the edges of the feature. This polygome can be useful for stitching seamless mosaics with multiple overlapping orthophotos. Default: false"
                                    ToolTip.visible: toolTipText ? orthoCutlinema.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: orthoCutlinema
                                        anchors.fill: parent
                                        hoverEnabled: true
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
                                    property string toolTipText: "Skips dense reconsturction and 3D model generation. It generates an orthophoto directly from the sparse reconstruction. If you just need an orthophoto and do nopt need a full 3D model, turn on this option. Experimental. Default: false"
                                    ToolTip.visible: toolTipText ? fastOrthoma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: fastOrthoma
                                        anchors.fill: parent
                                        hoverEnabled: true
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
                                    property string toolTipText: "Export the georeferenced point cloud in the Entwine Point Tile (EPT) format. Default: false"
                                    ToolTip.visible: toolTipText ? pcEptma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: pcEptma
                                        anchors.fill: parent
                                        hoverEnabled: true
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
                                    property string toolTipText: "Export the georeferenced point cloud in LAS format. Default: false"
                                    ToolTip.visible: toolTipText ? pcLasma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: pcLasma
                                        anchors.fill: parent
                                        hoverEnabled: true
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
                                    anchors.baseline: mergeInfo.baseline
                                    width:  _comboFieldWidth
                                    fact: QGroundControl.settingsManager.appSettings.merge
                                }
                                QGCButton {
                                    id: mergeInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    property string toolTipText: "Choose what to merge in the merge step in a split dataset. By default all avaiable outputs are merged. Default: all"
                                    ToolTip.visible: toolTipText ? mergema.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: mergema
                                        anchors.fill: parent
                                        hoverEnabled: true
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
                                    property string toolTipText: "Use this tag to build a DSM (Digital Surface Model, ground + objects) using a progressive morphological filter. Check the --dem* parameters for finer tuning. Default: false"
                                    ToolTip.visible: toolTipText ? dsmma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: dsmma
                                        anchors.fill: parent
                                        hoverEnabled: true
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
                                    anchors.baseline: textureToneMappingInfo.baseline
                                    width:  _comboFieldWidth
                                    fact: QGroundControl.settingsManager.appSettings.texturingToneMapping
                                }
                                QGCButton {
                                    id: textureToneMappingInfo 
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    property string toolTipText: "Turn on gamma tone mapping or none for no tone mapping. Default: none"
                                    ToolTip.visible: toolTipText ? textureToneMappingma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: textureToneMappingma
                                        anchors.fill: parent
                                        hoverEnabled: true
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
                                    property string toolTipText: "Computes an euclidean raste map for each DEM. The map reports the distance from each cell to to the nearest NODATA value (before any hole filling takes place). This can be useful to isolate the areas that have been filled. Default: false"
                                    ToolTip.visible: toolTipText ? demEuclidianMapma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: demEuclidianMapma
                                        anchors.fill: parent
                                        hoverEnabled: true
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
                                    anchors.baseline: cameraLensInfo.baseline
                                    width:  _comboFieldWidth
                                    fact: QGroundControl.settingsManager.appSettings.cameraLens
                                }
                                QGCButton {
                                    id: cameraLensInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    property string toolTipText: "Set a camera projection type. Manually set a value can help improve geometric undistortion. By default the application tries to determine a lens type from the images metedata. Default: auto"
                                    ToolTip.visible: toolTipText ? cameraLensma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: cameraLensma
                                        anchors.fill: parent
                                        hoverEnabled: true
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
                                    property string toolTipText: "Skips generation of the full 3D model. This can save time if you only need 2D results such as orthophotos and DEMs. Default: false"
                                    ToolTip.visible: toolTipText ? skip3dmodelma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: skip3dmodelma
                                        anchors.fill: parent
                                        hoverEnabled: true
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
                                    property string toolTipText: "Exports the georeferenced point cloud in CSV format. Default: false"
                                    ToolTip.visible: toolTipText ? pcCsvma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: pcCsvma
                                        anchors.fill: parent
                                        hoverEnabled: true
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
                                    anchors.baseline: endWithInfo.baseline
                                    width:  _comboFieldWidth
                                    fact: QGroundControl.settingsManager.appSettings.endWith
                                }
                                QGCButton {
                                    id: endWithInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    property string toolTipText: "Can be one of: dataset, split, merge, opensfm, mve, odm_filterpoints, odm_meshing, mvs_texturing, odm_georeferencing, odm_dem, odm_orthophoto. Default: odm_orthophoto"
                                    ToolTip.visible: toolTipText ? endWithma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: endWithma
                                        anchors.fill: parent
                                        hoverEnabled: true
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
                                    anchors.baseline: texturingDataTermInfo.baseline
                                    width:  _comboFieldWidth
                                    fact: QGroundControl.settingsManager.appSettings.texturingDataTerm
                                }
                                QGCButton {
                                    id: texturingDataTermInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    property string toolTipText: "Data term:[area, gmi]. Default: gmi"
                                    ToolTip.visible: toolTipText ? texturingDataTermma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: texturingDataTermma
                                        anchors.fill: parent
                                        hoverEnabled: true
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
                                    property string toolTipText: "Skip geometric visibility test. Default: false"
                                    ToolTip.visible: toolTipText ? texturingSkipVisibilityTestma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: texturingSkipVisibilityTestma
                                        anchors.fill: parent
                                        hoverEnabled: true
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
                                    anchors.baseline: opensfmDepthmapMethodInfo.baseline
                                    width:  _comboFieldWidth
                                    fact: QGroundControl.settingsManager.appSettings.opensfmDepthmapMethod
                                }
                                QGCButton {
                                    id: opensfmDepthmapMethodInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    property string toolTipText: "Raw depthmap computation algorithm. PATCH_MATCH and PATCH_MATCH_SAMPLE are faster, but might miss some valid points. BRUTE_FORCE takes longer but produces denser reconstuctions. Default: PATCH_MATCH"
                                    ToolTip.visible: toolTipText ? opensfmDepthmapMethodma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: opensfmDepthmapMethodma
                                        anchors.fill: parent
                                        hoverEnabled: true
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
                                    property string toolTipText: "Turn off camera parameter optimization during bundler. Default: false"
                                    ToolTip.visible: toolTipText ? fixedCameraParamsma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: fixedCameraParamsma
                                        anchors.fill: parent
                                        hoverEnabled: true
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
                                    property string toolTipText: "Print additional messages to the console. Default: false"
                                    ToolTip.visible: toolTipText ? verbosema.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: verbosema
                                        anchors.fill: parent
                                        hoverEnabled: true
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
                                    property string toolTipText: "Run local bundle adjustment for every image added to the reconstruction and a global adjustment every 100 images. Speeds up reconstruction for very large datasets. Default: false"
                                    ToolTip.visible: toolTipText ? hybridBundleAdjustmentma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: hybridBundleAdjustmentma
                                        anchors.fill: parent
                                        hoverEnabled: true
                                    }
                                }
                            }
                        }
                    }
                } // settingsColumn
            }
        
    }
}

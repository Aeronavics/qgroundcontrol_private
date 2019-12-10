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

    function saveItems()
    {
        CustomQuickInterface.password = passwordField.text
    }

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
                                    fact: CustomQuickInterface.customMappingSettings.email
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    width:             _labelWidth
                                    anchors.baseline:  passwordField.baseline
                                    text:              qsTr("Password: ")
                                }
                                QGCTextField {
                                    id: passwordField
                                    width: _comboFieldWidth
                                    anchors.verticalCenter: parent.verticalCenter
                                    echoMode: TextInput.Password
                                    text: CustomQuickInterface.password
                                    onEditingFinished: {
                                        saveItems();
                                    }
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
                                    text: qsTr("Check Credentials")
                                    onClicked: CustomQuickInterface.login(CustomQuickInterface.password)
                                }
                            }
                        }
                    }

                    Item { width: 1; height: _margins }

                    QGCLabel {
                        id:         taskNameLabel
                        text:       qsTr("Task Name")
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
                        id:         advancedProcessingOptionsLabel
                        text:       qsTr("Advanced Processing Options")
                        visible:    CustomQuickInterface.advancedSettings
                    }
                    Rectangle {
                        Layout.preferredHeight: advancedProcessingOptionsCol.height + (_margins * 2)
                        Layout.preferredWidth:  advancedProcessingOptionsCol.width + (_margins * 2)
                        color:                  qgcPal.windowShade
                        Layout.fillWidth:       true
                        visible:                CustomQuickInterface.advancedSettings

                        Column {
                            id:                         advancedProcessingOptionsCol
                            spacing:                    _columnSpacing
                            anchors.centerIn:           parent
                            
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                
                                QGCLabel {
                                    text:  qsTr("<b>Point Cloud Classify</b>")
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
                                    fact: CustomQuickInterface.customMappingSettings.pcClassify
                                    onClicked: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>smrf scalar (postitive float)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:     smrfScalar
                                    width:  _comboFieldWidth 
                                    fact: CustomQuickInterface.customMappingSettings.smrfScalar
                                    onEditingFinished: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>opensfm depthmap min patch sd (postitive float)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:     opensfmDepthmapMinPatch
                                    width:  _comboFieldWidth
                                    fact: CustomQuickInterface.customMappingSettings.opensfmDepthmapMinPatchSd
                                    onEditingFinished: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>smrf window (postitive float)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      smrfWindow
                                    width:  _comboFieldWidth
                                    fact: CustomQuickInterface.customMappingSettings.smrfWindow
                                    onEditingFinished: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Mesh octree depth (postitive Integer)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      meshOctreeDepth
                                    width:  _comboFieldWidth
                                    fact: CustomQuickInterface.customMappingSettings.meshOctreeDepth
                                    onEditingFinished: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>min num features (Integer)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth 
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      minNumFeatures
                                    width:  _comboFieldWidth
                                    fact: CustomQuickInterface.customMappingSettings.minNumFeatures
                                    onEditingFinished: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Resize to (Integer)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      resizeTo
                                    width:  _comboFieldWidth
                                    fact: CustomQuickInterface.customMappingSettings.resizeTo
                                    onEditingFinished: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>smrf slope (Positve Float)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      smrfSlope
                                    width:  _comboFieldWidth
                                    fact: CustomQuickInterface.customMappingSettings.smrfSlope
                                    onEditingFinished: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Rerun from</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactComboBox {
                                    id:      rerunFrom
                                    anchors.baseline: parent.verticleCenter
                                    width:  _comboFieldWidth
                                    fact: CustomQuickInterface.customMappingSettings.rerunFrom
                                    onActivated: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Use 3D mesh</b>")
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
                                    fact: CustomQuickInterface.customMappingSettings.use3dmesh
                                    onClicked: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Orthophoto compression</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactComboBox { 
                                    id:      orthophotoCompression
                                    anchors.baseline: parent.verticleCenter
                                    width:  _comboFieldWidth
                                    fact: CustomQuickInterface.customMappingSettings.orthophotoCompression
                                    onActivated: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>MVE confidence (Float: 0 <= x <= 1)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      mveConfidence
                                    width:  _comboFieldWidth
                                    fact: CustomQuickInterface.customMappingSettings.mveConfidence
                                    onEditingFinished: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Texturing skip hole filling</b>")
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
                                    fact: CustomQuickInterface.customMappingSettings.texturingSkipHoleFilling
                                    onClicked: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Texturing skip global seam leveling</b>")
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
                                    fact: CustomQuickInterface.customMappingSettings.texturingSkipGlobalSeamLeveling
                                    onClicked: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Texturing nadir weight (Integer: 0 <= x <= 32)<b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      testuringNadirweight
                                    fact: CustomQuickInterface.customMappingSettings.texturingNadirWeight
                                    width:  _comboFieldWidth
                                    onEditingFinished: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Texturing outlier removal type</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactComboBox { 
                                    id:      texturingOutlierRemoveType
                                    anchors.baseline: parent.verticleCenter
                                    fact: CustomQuickInterface.customMappingSettings.texturingOutlierRemovalType
                                    width:  _comboFieldWidth
                                    onActivated: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Othrophoto resolution (Float > 0.0)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      othroRes
                                    width:  _comboFieldWidth
                                    fact: CustomQuickInterface.customMappingSettings.othrophotoResolution
                                    onEditingFinished: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>DTM</b>")
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
                                    fact: CustomQuickInterface.customMappingSettings.dtm
                                    onClicked: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Orthophoto no tiled</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactCheckBox {
                                    id: orthoNoTiled
                                    text: qsTr("Enable")
                                    width: _labelWidth
                                    fact: CustomQuickInterface.customMappingSettings.orthophotoNoTiled
                                    anchors.baseline: orthoNoTiledInfo.baseline
                                    onClicked: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>DEM resolution (Float > 0.0)</b>")
                                }   
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      demRes
                                    width:  _comboFieldWidth
                                    fact: CustomQuickInterface.customMappingSettings.demResolution
                                    onEditingFinished: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Mesh size (Positive Integer)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      meshSize
                                    width:  _comboFieldWidth
                                    fact: CustomQuickInterface.customMappingSettings.meshSize
                                    onEditingFinished: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Force GPS</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter

                                FactCheckBox {
                                    id: forceGPS
                                    text: qsTr("Enable")
                                    width: _labelWidth
                                    fact: CustomQuickInterface.customMappingSettings.forceGPS
                                    anchors.baseline: forceGPSInfo.baseline
                                    onClicked: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Ignore GSD</b>")
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
                                    fact: CustomQuickInterface.customMappingSettings.ignoreGsd
                                    onClicked: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Build overviews</b>")
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
                                    fact: CustomQuickInterface.customMappingSettings.buildOverviews
                                    onClicked: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Opensfm dense</b>")
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
                                    fact: CustomQuickInterface.customMappingSettings.opensfmDense
                                    onClicked: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Opensfm depthmap min consistent views (Integer: 2<=x<=9)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      opensfmDepthmapMinConsistentViews
                                    width:  _comboFieldWidth
                                    fact: CustomQuickInterface.customMappingSettings.opensfmDepthmapMinConsistentViews
                                    onEditingFinished: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Texturing skip local seam leveling</b>")
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
                                    fact: CustomQuickInterface.customMappingSettings.texturingSkipLocalSeamLeveling
                                    onClicked: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Texturing keep unseen faces</b>")
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
                                    fact: CustomQuickInterface.customMappingSettings.texturingKeepUnseenFaces
                                    onClicked: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Debug</b>")
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
                                    fact: CustomQuickInterface.customMappingSettings.debug
                                    onClicked: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Use exif</b>")
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
                                    fact: CustomQuickInterface.customMappingSettings.useExif
                                    onClicked: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Mesh samples (Float >= 1.0)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      meshSamples
                                    width:  _comboFieldWidth
                                    fact: CustomQuickInterface.customMappingSettings.meshSamples
                                    onEditingFinished: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b> Point cloud sample (Positive Integer)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      pcSample
                                    width:  _comboFieldWidth
                                    fact: CustomQuickInterface.customMappingSettings.pcSample
                                    onEditingFinished: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Matcher distance (Integer)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      matcherDistance
                                    width:  _comboFieldWidth
                                    fact: CustomQuickInterface.customMappingSettings.matcherDistance
                                    onEditingFinished: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Split overlap (Positive Integer)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      splitOverlap
                                    width:  _comboFieldWidth
                                    fact: CustomQuickInterface.customMappingSettings.splitOverlap
                                    onEditingFinished: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>DEM decimation (Positive Integer)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      demDecimation
                                    width:  _comboFieldWidth
                                    fact: CustomQuickInterface.customMappingSettings.demDecimation
                                    onEditingFinished: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Orthophoto cutline</b>")
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
                                    fact: CustomQuickInterface.customMappingSettings.orthophotoCutline
                                    onClicked: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Point cloud filter (Positive Float)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      pcFilter
                                    width:  _comboFieldWidth
                                    fact: CustomQuickInterface.customMappingSettings.pcFilter
                                    onEditingFinished: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Split (Positive Integer)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      split
                                    width:  _comboFieldWidth
                                    fact: CustomQuickInterface.customMappingSettings.split
                                    onEditingFinished: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Fast orthophoto</b>")
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
                                    fact: CustomQuickInterface.customMappingSettings.fastOrthophoto
                                    onClicked: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Point Cloud EPT</b>")
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
                                    fact: CustomQuickInterface.customMappingSettings.pcEpt
                                    onClicked: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Crop (Positive Float)</b>")
                                }
                            }   
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      crop
                                    width:  _comboFieldWidth
                                    fact: CustomQuickInterface.customMappingSettings.crop
                                    onEditingFinished: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Point cloud LAS</b>")
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
                                    fact: CustomQuickInterface.customMappingSettings.pcLas
                                    onClicked: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Merge</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactComboBox {
                                    id:      merge
                                    anchors.baseline: parent.verticleCenter
                                    width:  _comboFieldWidth
                                    fact: CustomQuickInterface.customMappingSettings.merge
                                    onActivated: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>DSM</b>")
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
                                    fact: CustomQuickInterface.customMappingSettings.dsm
                                    onClicked: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>DEM gapfill steps (Positive Integer)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      demGapfillSteps
                                    width:  _comboFieldWidth
                                    fact: CustomQuickInterface.customMappingSettings.demGapfillSteps
                                    onEditingFinished: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Mesh point weight (Positive Float)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      meshPointWeight
                                    width:  _comboFieldWidth
                                    fact: CustomQuickInterface.customMappingSettings.meshPointWeight
                                    onEditingFinished: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Max concurrency (Positive Integer)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      maxConcurrency
                                    width:  _comboFieldWidth
                                    fact: CustomQuickInterface.customMappingSettings.maxConcurrency
                                    onEditingFinished: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Texturing tone mapping</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactComboBox {
                                    id:     textureToneMapping
                                    anchors.baseline: parent.verticleCenter
                                    width:  _comboFieldWidth
                                    fact: CustomQuickInterface.customMappingSettings.texturingToneMapping
                                    onActivated: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>DEM euclidian map</b>")
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
                                    fact: CustomQuickInterface.customMappingSettings.demEuclidianMap
                                    onClicked: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Camera lens</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactComboBox {
                                    id:     cameraLens
                                    anchors.baseline: parent.verticleCenter
                                    width:  _comboFieldWidth
                                    fact: CustomQuickInterface.customMappingSettings.cameraLens
                                    onActivated: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Skip 3D model</b>")
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
                                    fact: CustomQuickInterface.customMappingSettings.skip3dmodel
                                    onClicked: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Match neighbours (Positive Integer)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      matchNeighbours
                                    width:  _comboFieldWidth
                                    fact: CustomQuickInterface.customMappingSettings.matchNeighbours
                                    onEditingFinished: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Point cloud CSV</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter

                                FactCheckBox {
                                    id: pcCsv
                                    text: qsTr("Enable")
                                    width: _labelWidth
                                    fact: CustomQuickInterface.customMappingSettings.pcCsv
                                    anchors.baseline: pcCsvInfo.baseline
                                    onClicked: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>End with</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactComboBox {
                                    id:     endWith
                                    anchors.baseline: parent.verticleCenter
                                    width:  _comboFieldWidth
                                    fact: CustomQuickInterface.customMappingSettings.endWith
                                    onActivated: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Depthmap resolution (Positive Float)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      depthmapRes
                                    width:  _comboFieldWidth
                                    fact: CustomQuickInterface.customMappingSettings.depthmapResolution
                                    onEditingFinished: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Texturing data term</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactComboBox {
                                    id:     texturingDataTerm
                                    anchors.baseline: parent.verticleCenter
                                    width:  _comboFieldWidth
                                    fact: CustomQuickInterface.customMappingSettings.texturingDataTerm
                                    onActivated: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Texturing skip visibility test</b>")
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
                                    fact: CustomQuickInterface.customMappingSettings.texturingSkipVisibilityTest
                                    onClicked: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Opensfm depthmap method</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactComboBox {
                                    id:     opensfmDepthmapMethod
                                    anchors.baseline: parent.verticleCenter
                                    width:  _comboFieldWidth
                                    fact: CustomQuickInterface.customMappingSettings.opensfmDepthmapMethod
                                    onActivated: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Use fixed camera parameters</b>")
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
                                    fact: CustomQuickInterface.customMappingSettings.useFixedCameraParams
                                    onClicked: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>smrf threshold (Positive Float)<b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                FactTextField {
                                    id:      smrfThreshold
                                    width:  _comboFieldWidth
                                    fact: CustomQuickInterface.customMappingSettings.smrfThreshold
                                    onEditingFinished: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Verbose</b>")
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
                                    fact: CustomQuickInterface.customMappingSettings.verbose
                                    onClicked: CustomQuickInterface.setCustom()
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
                                    text:  qsTr("<b>Use hybrid bundle adjustment</b>")
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
                                    fact: CustomQuickInterface.customMappingSettings.useHybridBundleAdjustment
                                    onClicked: CustomQuickInterface.setCustom()
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

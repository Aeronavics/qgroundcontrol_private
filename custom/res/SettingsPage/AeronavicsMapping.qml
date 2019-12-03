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
                                QGCTextField {
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
                                QGCTextField {
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
                                    ToolTip.visible: toolTipText ? ckeckma.containsMouse : false
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
                                QGCTextField {
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
                                QGCTextField {
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
                                QGCCheckBox {
                                    id: pcclassify
                                    text: qsTr("Enable")
                                    width: _labelWidth
                                    anchors.baseline: pcclassifyInfo.baseline
                                }
                                QGCButton {
                                    id: pcclassifyInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    property string toolTipText: "Classify the point cloud outputs using a Simple Morphological Filter. You can control the behaviour of this option by tweaking the --dem-* parameters. Default: false"
                                    ToolTip.visible: toolTipText ? ma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: ma
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
                                    text:  qsTr("<b>smrf-scalar (postitive float)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                QGCTextField {
                                    id:     smrfScalar
                                    anchors.baseline: smrfScalarInfo.baseline
                                    width:  _comboFieldWidth 
                                }
                                QGCButton {
                                    id: smrfScalarInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    property string toolTipText: "Simple Morphological Filter elevation scalar parameter. Default: 1.25"
                                    ToolTip.visible: toolTipText ? smfrScalarma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: smfrScalarma
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
                                    text:  qsTr("<b>opensfm-depthmap-min-patch-sd (postitive float)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                QGCTextField {
                                    id:     opensfmDepthmapMinPatch
                                    anchors.baseline: opensfmDepthmapMinPatchInfo.baseline
                                    width:  _comboFieldWidth
                                }
                                QGCButton {
                                    id: opensfmDepthmapMinPatchInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    property string toolTipText: "When using PATCH_MATCH or PATCH_MATCH_SAMPLE, controls the standard deviation threshold to include patched. Patches with lower standard deviation are ignored. Default: 1"
                                    ToolTip.visible: toolTipText ? opensfmDepthmapMinPatchma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: opensfmDepthmapMinPatchma
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
                                    text:  qsTr("<b>smrf-window (postitive float)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                QGCTextField {
                                    id:      smrfWindow
                                    anchors.baseline: smrfWindowInfo.baseline
                                    width:  _comboFieldWidth
                                }
                                QGCButton {
                                    id: smrfWindowInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    property string toolTipText: "Simple Morphological Filter window raduis parameter (meters). Default: 18"
                                    ToolTip.visible: toolTipText ? smrfWindowma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: smrfWindowma
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
                                    text:  qsTr("<b>mesh-octree-depth (postitive Integer)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                QGCTextField {
                                    id:      meshOctreeDepth
                                    anchors.baseline: meshOctreeDepthInfo.baseline
                                    width:  _comboFieldWidth
                                }
                                QGCButton {
                                    id: meshOctreeDepthInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    property string toolTipText: "Oct-tree depth used in the mesh reconstruction, increase to get more vertices recommended values are 8-12. Default: 9"
                                    ToolTip.visible: toolTipText ? meshOctreeDepthma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: meshOctreeDepthma
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
                                    text:  qsTr("<b>min-num-features (Integer)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                QGCTextField {
                                    id:      minNumFeatures
                                    anchors.baseline: minNumFeaturesInfo.baseline
                                    width:  _comboFieldWidth
                                }
                                QGCButton {
                                    id: minNumFeaturesInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    property string toolTipText: "Minimum number of features to extract per image. More features leads to better results but slower execution. Default: 8000"
                                    ToolTip.visible: toolTipText ? minNumFeaturesma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: minNumFeaturesma
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
                                    text:  qsTr("<b>resize-to (Integer)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                QGCTextField {
                                    id:      resizeTo
                                    anchors.baseline: resizeToInfo.baseline
                                    width:  _comboFieldWidth
                                }
                                QGCButton {
                                    id: resizeToInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    property string toolTipText: "Resizes images by the largest side for feature extraction purposes only. Set to -1 to disable. this does not affest the final orthophoto resolution quality and will not resize the original images. Default: 2048"
                                    ToolTip.visible: toolTipText ? resizeToma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: resizeToma
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
                                    text:  qsTr("<b>smrf-slope (Positve Float)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                QGCTextField {
                                    id:      smrfSlope
                                    anchors.baseline: smrfSlopeInfo.baseline
                                    width:  _comboFieldWidth
                                }
                                QGCButton {
                                    id: smrfSlopeInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    property string toolTipText: "Simple Morphological Filter slope parameter (rise over run). Default: 0.15"
                                    ToolTip.visible: toolTipText ? smrfSlopema.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: smrfSlopema
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
                                    text:  qsTr("<b>rerun-from</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                ComboBox {
                                    id:      rerunFrom
                                    anchors.baseline: rerunFromInfo.baseline
                                    width:  _comboFieldWidth
                                    model: ["dataset", "split","merge","opensfm","mve","odm_filterpoints","odm_meshing","mvs_texturing","odm_georeferencing","odm_dem","odm_orthophoto"]
                                }
                                QGCButton {
                                    id: rerunFromInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    property string toolTipText: "Can be one of: dataset | split | merge | opensfm | mve | odm_filterpoints | odm_meshing | mvs_texturing | odm_georeferencing | odm_dem | odm_orthophoto"
                                    ToolTip.visible: toolTipText ? rerunFromma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: rerunFromma
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
                                ComboBox { 
                                    id:      orthophotoCompression
                                    anchors.baseline: orthophotoCompressionInfo.baseline
                                    width:  _comboFieldWidth
                                    model: ["deflate", "JPEG","LZW","Packbits","LZMA","none"]
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
                                QGCTextField {
                                    id:      mveConfidence
                                    anchors.baseline: mveConfidenceInfo.baseline
                                    width:  _comboFieldWidth
                                }
                                QGCButton {
                                    id: mveConfidenceInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    property string toolTipText: "Dicard points that have les than a certain confidence threshold. This only affects dense reconstructions performed with MVE. Higher values discard more points. Default: 0.6"
                                    ToolTip.visible: toolTipText ? mveConfidencema.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: mveConfidencema
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
                                anchors.horizontalCenter: parent.horizontalCenter
                                QGCTextField {
                                    id:      testuringNadirweight
                                    anchors.baseline: testuringNadirweightInfo.baseline
                                    width:  _comboFieldWidth
                                }
                                QGCButton {
                                    id: testuringNadirweightInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    property string toolTipText: "Affects orthophotos only. Higher values result in sharper corners, but it can affect colour distribution and blurriness. Use lower values for planar areas and higher values for urban areas. The default value works well for most scenarios. Default: 16"
                                    ToolTip.visible: toolTipText ? testuringNadirweightma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: testuringNadirweightma
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
                                    text:  qsTr("<b>Texturing-outlier-removal-type</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                ComboBox { 
                                    id:      texturingOutlierRemoveType
                                    anchors.baseline: texturingOutlierRemoveTypeInfo.baseline
                                    width:  _comboFieldWidth
                                    model: ["gauss_clamping", "gauss_damping","none"]
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
                                anchors.horizontalCenter: parent.horizontalCenter
                                QGCTextField {
                                    id:      othroRes
                                    anchors.baseline: othroResInfo.baseline
                                    width:  _comboFieldWidth
                                }
                                QGCButton {
                                    id: othroResInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    property string toolTipText: "Orthophoto resoultion in cm/pixel. Default: 5"
                                    ToolTip.visible: toolTipText ? othroResma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: othroResma
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
                                anchors.horizontalCenter: parent.horizontalCenter
                                QGCTextField {
                                    id:      demRes
                                    anchors.baseline: demResInfo.baseline
                                    width:  _comboFieldWidth
                                }
                                QGCButton {
                                    id: demResInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    property string toolTipText: "DSM/DTM resoultion in cm/pixel. Default: 5"
                                    ToolTip.visible: toolTipText ? demResma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: demResma
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
                                    text:  qsTr("<b>mesh-size (Positive Integer)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                QGCTextField {
                                    id:      meshSize
                                    anchors.baseline: meshSizeInfo.baseline
                                    width:  _comboFieldWidth
                                }
                                QGCButton {
                                    id: meshSizeInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    property string toolTipText: "The maximum vertex count of the output mesh. Default: 100000"
                                    ToolTip.visible: toolTipText ? meshSizema.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: meshSizema
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
                                anchors.horizontalCenter: parent.horizontalCenter
                                QGCTextField {
                                    id:      opensfmDepthmapMinConsistentViews
                                    anchors.baseline: opensfmDepthmapMinConsistentViewsInfo.baseline
                                    width:  _comboFieldWidth
                                }
                                QGCButton {
                                    id: opensfmDepthmapMinConsistentViewsInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    property string toolTipText: "Minimum number of views that should reconstruct a point for it to be valid. Use lower values if your images have less overlap. Lower values result in denser point clouds but with more noise. Default: 3"
                                    ToolTip.visible: toolTipText ? opensfmDepthmapMinConsistentViewsma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: opensfmDepthmapMinConsistentViewsma
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
                                anchors.horizontalCenter: parent.horizontalCenter
                                QGCTextField {
                                    id:      meshSamples
                                    anchors.baseline: meshSamplesInfo.baseline
                                    width:  _comboFieldWidth
                                }
                                QGCButton {
                                    id: meshSamplesInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    property string toolTipText: "Number of points per octree node. Recommended and Default: 1"
                                    ToolTip.visible: toolTipText ? meshSamplesma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: meshSamplesma
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
                                    text:  qsTr("<b>pc-sample (Positive Integer)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                QGCTextField {
                                    id:      pcSample
                                    anchors.baseline: pcSampleInfo.baseline
                                    width:  _comboFieldWidth
                                }
                                QGCButton {
                                    id: pcSampleInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    property string toolTipText: "Filters the point cloud by keeping only a single point around a radius N (in meters). This can be useful to limit the output resolution of the point cloud set to 0 to diable sampling. Default: 0"
                                    ToolTip.visible: toolTipText ? pcSamplema.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: pcSamplema
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
                                    text:  qsTr("<b>matcher-distance (Integer)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                QGCTextField {
                                    id:      matcherDistance
                                    anchors.baseline: matcherDistanceInfo.baseline
                                    width:  _comboFieldWidth
                                }
                                QGCButton {
                                    id: matcherDistanceInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    property string toolTipText: "Distance threshold in meters to find pre-matching images based on exif data. Set matcher-neighbors and this to 0 to skip pre-matching. Default: 0"
                                    ToolTip.visible: toolTipText ? matcherDistancema.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: matcherDistancema
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
                                    text:  qsTr("<b>split-overlap (Positive Integer)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                QGCTextField {
                                    id:      splitOverlap
                                    anchors.baseline: splitOverlapInfo.baseline
                                    width:  _comboFieldWidth
                                }
                                QGCButton {
                                    id: splitOverlapInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    property string toolTipText: "Radius of the overlap between submodels. After grouping images into clusters, images that are closer that this radius to a cluster are added to the cluster. This is done to ensure that the neighboring submodels overlap. Default: 150"
                                    ToolTip.visible: toolTipText ? splitOverlapma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: splitOverlapma
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
                                    text:  qsTr("<b>dem-decimation (Positive Integer)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                QGCTextField {
                                    id:      demDecimation
                                    anchors.baseline: demDecimationInfo.baseline
                                    width:  _comboFieldWidth
                                }
                                QGCButton {
                                    id: demDecimationInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    property string toolTipText: "Decimate the points before generatiing the DEM. 1 is no decimation (full quality). 100 decimates ~99% of the points. Useful for speeding up the generation. Default: 1"
                                    ToolTip.visible: toolTipText ? demDecimationma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: demDecimationma
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
                                anchors.horizontalCenter: parent.horizontalCenter
                                QGCTextField {
                                    id:      pcFilter
                                    anchors.baseline: pcFilterInfo.baseline
                                    width:  _comboFieldWidth
                                }
                                QGCButton {
                                    id:  pcFilterInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    property string toolTipText: "Filters the point cloud by removing the points that deviate more that N standard deviations from the local mean. Set to 0 to disable filtering. Default: 2.5"
                                    ToolTip.visible: toolTipText ? pcFilterma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: pcFilterma
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
                                    text:  qsTr("<b>split (Positive Integer)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                QGCTextField {
                                    id:      split
                                    anchors.baseline: splitInfo.baseline
                                    width:  _comboFieldWidth
                                }
                                QGCButton {
                                    id:  splitInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    property string toolTipText: "Average number of images per submodel. When splitting a large dataset into smaller submodels, images are grouped into clusters. This value regulates the number of images that each cluster should have on average. Default: 999999"
                                    ToolTip.visible: toolTipText ? splitma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: splitma
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
                                anchors.horizontalCenter: parent.horizontalCenter
                                QGCTextField {
                                    id:      crop
                                    anchors.baseline: cropInfo.baseline
                                    width:  _comboFieldWidth
                                }
                                QGCButton {
                                    id:  cropInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    property string toolTipText: "Automatically crop image outputs by creating a smooth buffer around the dataset boundaries, shrunk by N meters. Use 0 to disable cropping. Default: 3"
                                    ToolTip.visible: toolTipText ? cropma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: cropma
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
                                ComboBox {
                                    id:      merge
                                    anchors.baseline: mergeInfo.baseline
                                    width:  _comboFieldWidth
                                    model: ["all", "orthophoto","pointcloud","dem"]
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
                                anchors.horizontalCenter: parent.horizontalCenter
                                QGCTextField {
                                    id:      demGapfillSteps
                                    anchors.baseline: demGapfillStepsInfo.baseline
                                    width:  _comboFieldWidth
                                }
                                QGCButton {
                                    id:  demGapfillStepsInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    property string toolTipText: "Number of steps used to fill areas with gaps. Set to 0 to disable gap filling. Starting witha radius equal to the output resulotion, N different DEMs are generated with progressively bigger radius using the inverse distance weighted (IDW) algorthim and merged together. Remaining gaps are then merged using nearest neighbour interpolation. Default: 3"
                                    ToolTip.visible: toolTipText ? demGapfillStepsma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: demGapfillStepsma
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
                                    text:  qsTr("<b>mesh-point-weight (Positive Float)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                QGCTextField {
                                    id:      meshPointWeight
                                    anchors.baseline: meshPointWeightInfo.baseline
                                    width:  _comboFieldWidth
                                }
                                QGCButton {
                                    id:  meshPointWeightInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    property string toolTipText: "This floating point number specifies the importance that interpolation of the point samples is given in the formulation of the screen Poisson equation. The results of the original (unscreened) Poisson Reconstruction can be obtained by setting this value to 0. Default: 4"
                                    ToolTip.visible: toolTipText ? meshPointWeightma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: meshPointWeightma
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
                                    text:  qsTr("<b>max-concurrency (Positive Integer)</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                QGCTextField {
                                    id:      maxConcurrency
                                    anchors.baseline: maxConcurrencyInfo.baseline
                                    width:  _comboFieldWidth
                                }
                                QGCButton {
                                    id:  maxConcurrencyInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    property string toolTipText: "The maximum number of processes to use in the various processes. Peak memory requirement is ~1GB per thread and 2 megapixel image resolution. Default: 16"
                                    ToolTip.visible: toolTipText ? maxConcurrencyma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: maxConcurrencyma
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
                                    text:  qsTr("<b>texturing-tone-mapping</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                ComboBox {
                                    id:     textureToneMapping
                                    anchors.baseline: textureToneMappingInfo.baseline
                                    width:  _comboFieldWidth
                                    model: ["none", "gamma","pointcloud","dem"]
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
                                ComboBox {
                                    id:     cameraLens
                                    anchors.baseline: cameraLensInfo.baseline
                                    width:  _comboFieldWidth
                                    model: ["auto", "perspective","brown","fisheye","spherical"]
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
                                anchors.horizontalCenter: parent.horizontalCenter
                                QGCTextField {
                                    id:      matchNeighbours
                                    anchors.baseline: matchNeighboursInfo.baseline
                                    width:  _comboFieldWidth
                                }
                                QGCButton {
                                    id:  matchNeighboursInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    property string toolTipText: "Number of nearest images to pre-match based on GPS exif data. set to 0 to skip pre-matching. Neighbours works together with Distance parameter, set both to 0 to not user pre-matching. OpenSFM uses both parameters at the same time, bundler uses only one which has value, prefering Neighbours parameter. Default: 8"
                                    ToolTip.visible: toolTipText ? matchNeighboursma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: matchNeighboursma
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
                                ComboBox {
                                    id:     endWith
                                    anchors.baseline: endWithInfo.baseline
                                    width:  _comboFieldWidth
                                    model: ["odm_orthophoto","dataset","split", "merge", "opensfm", "mve", "odm_filterpoints", "odm_meshing", "mvs_texturing", "odm_georeferencing", "odm_dem"]
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
                                anchors.horizontalCenter: parent.horizontalCenter
                                QGCTextField {
                                    id:      depthmapRes
                                    anchors.baseline: depthmapResInfo.baseline
                                    width:  _comboFieldWidth
                                }
                                QGCButton {
                                    id:  depthmapResInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    property string toolTipText: "Controls the density of the point cloud by setting the resolution of the depthmap images. Higher values take longer to compute but produce denser point clouds. Default: 640"
                                    ToolTip.visible: toolTipText ? depthmapResma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: depthmapResma
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
                                    text:  qsTr("<b>texturing-data-term</b>")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                ComboBox {
                                    id:     texturingDataTerm
                                    anchors.baseline: texturingDataTermInfo.baseline
                                    width:  _comboFieldWidth
                                    model: ["gmi","area"]
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
                                ComboBox {
                                    id:     opensfmDepthmapMethod
                                    anchors.baseline: opensfmDepthmapMethodInfo.baseline
                                    width:  _comboFieldWidth
                                    model: ["PATCH_MATCH","PATCH_MATCH_SAMPLE","BRUTE_FORCE"]
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
                                anchors.horizontalCenter: parent.horizontalCenter
                                QGCTextField {
                                    id:      smrfThreshold
                                    anchors.baseline: smrfThresholdInfo.baseline
                                    width:  _comboFieldWidth
                                }
                                QGCButton {
                                    id:  smrfThresholdInfo
                                    Layout.preferredWidth: height
                                    Layout.preferredHeight: _baseFontEdit
                                    anchors.verticalCenter: parent.verticleCenter
                                    text: qsTr("\uD83D")
                                    property string toolTipText: "Simple Morphological Filter elevation threshold parameter (meters). Default: 0.5"
                                    ToolTip.visible: toolTipText ? smrfThresholdma.containsMouse : false
                                    ToolTip.text: toolTipText
                                    MouseArea {
                                        id: smrfThresholdma
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

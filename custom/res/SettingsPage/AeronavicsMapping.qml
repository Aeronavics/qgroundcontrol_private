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
                                    text:  qsTr("pc-classify")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                FactCheckBox {
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
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel { 
                                    text:  qsTr("smrf-scalar (postitive float)")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
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
                            RowLayout {
                                spacing: ScreenTools.defaultFontPixelWidth
                                
                                QGCLabel {
                                    text:  qsTr("opensfm-depthmap-min-patch-sd (postitive float)")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
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
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("smrf-window (postitive float)")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
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
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel { 
                                    text:  qsTr("mesh-octree-depth (postitive Integer)")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
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
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("min-num-features (Integer)")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
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
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("resize-to (Integer)")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
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
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("smrf-slope (Positve Float)")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
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
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("rerun-from")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
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
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
                                
                                QGCLabel {
                                    text:  qsTr("use-3dmesh")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

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
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("orthophoto-compression")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
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
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("mve-confidence (Float: 0 <= x <= 1)")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
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
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("texturing-skip-hole-filling")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

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
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("texturing-skip-global-seam-leveling")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

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
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {   
                                    text:  qsTr("Texturing-nadir-weight (Integer: 0 <= x <= 32)")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
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
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {   
                                    text:  qsTr("Texturing-outlier-removal-type")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
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
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {   
                                    text:  qsTr("Othrophoto-resolution (Float > 0.0)")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
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
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("dtm")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

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
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    text:  qsTr("orthophoto-no-tiled")
                                }
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

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
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth

                                QGCLabel {   
                                    text:  qsTr("dem-resolution (Float > 0.0)")
                                }   
                            }
                            Row {
                                spacing: ScreenTools.defaultFontPixelWidth
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

                        }
                    }
                    Item { width: 1; height: _margins }
                    QGCLabel {
                        text:       qsTr("Telemetry Logs from Vehicle")
                    }
                    Rectangle {
                        Layout.preferredHeight: loggingCol.height + (_margins * 2)
                        Layout.preferredWidth:  loggingCol.width + (_margins * 2)
                        color:                  qgcPal.windowShade
                        Layout.fillWidth:       true
                        ColumnLayout {
                            id:                         loggingCol
                            anchors.margins:            _margins
                            anchors.top:                parent.top
                            anchors.horizontalCenter:   parent.horizontalCenter
                            spacing:                    _margins
                            FactCheckBox {
                                id:         promptSaveLog
                                text:       qsTr("Save log after each flight")
                                fact:       _telemetrySave
                                visible:    _telemetrySave.visible
                                property Fact _telemetrySave: QGroundControl.settingsManager.appSettings.telemetrySave
                            }
                            FactCheckBox {
                                id:         logIfNotArmed
                                text:       qsTr("Save logs even if vehicle was not armed")
                                fact:       _telemetrySaveNotArmed
                                visible:    _telemetrySaveNotArmed.visible
                                property Fact _telemetrySaveNotArmed: QGroundControl.settingsManager.appSettings.telemetrySaveNotArmed
                            }
                            FactCheckBox {
                                id:         promptSaveCsv
                                text:       qsTr("Save CSV log of telemetry data")
                                fact:       _saveCsvTelemetry
                                visible:    _saveCsvTelemetry.visible
                                property Fact _saveCsvTelemetry: QGroundControl.settingsManager.appSettings.saveCsvTelemetry
                            }
                        }
                    }

                    Item { width: 1; height: _margins }
                    QGCLabel {
                        id:         flyViewSectionLabel
                        text:       qsTr("Fly View")
                        visible:    QGroundControl.settingsManager.flyViewSettings.visible
                    }
                    Rectangle {
                        Layout.preferredHeight: flyViewCol.height + (_margins * 2)
                        Layout.preferredWidth:  flyViewCol.width + (_margins * 2)
                        color:                  qgcPal.windowShade
                        visible:                flyViewSectionLabel.visible
                        Layout.fillWidth:       true

                        ColumnLayout {
                            id:                         flyViewCol
                            anchors.margins:            _margins
                            anchors.top:                parent.top
                            anchors.horizontalCenter:   parent.horizontalCenter
                            spacing:                    _margins

                            FactCheckBox {
                                text:       qsTr("Use Preflight Checklist")
                                fact:       _useChecklist
                                visible:    _useChecklist.visible && QGroundControl.corePlugin.options.preFlightChecklistUrl.toString().length

                                property Fact _useChecklist: QGroundControl.settingsManager.appSettings.useChecklist
                            }

                            FactCheckBox {
                                text:       qsTr("Show Telemetry Log Replay Status Bar")
                                fact:       _showLogReplayStatusBar
                                visible:    _showLogReplayStatusBar.visible

                                property Fact _showLogReplayStatusBar: QGroundControl.settingsManager.flyViewSettings.showLogReplayStatusBar
                            }

                            FactCheckBox {
                                text:       qsTr("Virtual Joystick")
                                visible:    _virtualJoystick.visible
                                fact:       _virtualJoystick

                                property Fact _virtualJoystick: QGroundControl.settingsManager.appSettings.virtualJoystick
                            }

                            FactCheckBox {
                                text:       qsTr("Auto-Center throttle")
                                visible:    _virtualJoystickCentralized.visible && activeVehicle && (activeVehicle.sub || activeVehicle.rover)
                                fact:       _virtualJoystickCentralized
                                Layout.leftMargin: _margins

                                property Fact _virtualJoystickCentralized: QGroundControl.settingsManager.appSettings.virtualJoystickCentralized
                            }
                            FactCheckBox {
                                text:       qsTr("Use Vertical Instrument Panel")
                                visible:    _alternateInstrumentPanel.visible
                                fact:       _alternateInstrumentPanel

                                property Fact _alternateInstrumentPanel: QGroundControl.settingsManager.flyViewSettings.alternateInstrumentPanel
                            }
                            FactCheckBox {
                                text:       qsTr("Show additional heading indicators on Compass")
                                visible:    _showAdditionalIndicatorsCompass.visible
                                fact:       _showAdditionalIndicatorsCompass

                                property Fact _showAdditionalIndicatorsCompass: QGroundControl.settingsManager.flyViewSettings.showAdditionalIndicatorsCompass
                            }
                            FactCheckBox {
                                text:       qsTr("Lock Compass Nose-Up")
                                visible:    _lockNoseUpCompass.visible
                                fact:       _lockNoseUpCompass

                                property Fact _lockNoseUpCompass: QGroundControl.settingsManager.flyViewSettings.lockNoseUpCompass
                            }


                            GridLayout {
                                columns: 2

                                property Fact _guidedMinimumAltitude:   QGroundControl.settingsManager.flyViewSettings.guidedMinimumAltitude
                                property Fact _guidedMaximumAltitude:   QGroundControl.settingsManager.flyViewSettings.guidedMaximumAltitude
                                property Fact _maxGoToLocationDistance: QGroundControl.settingsManager.flyViewSettings.maxGoToLocationDistance

                                QGCLabel {
                                    text:                   qsTr("Guided Minimum Altitude")
                                    visible:                parent._guidedMinimumAltitude.visible
                                }
                                FactTextField {
                                    Layout.preferredWidth:  _valueFieldWidth
                                    visible:                parent._guidedMinimumAltitude.visible
                                    fact:                   parent._guidedMinimumAltitude
                                }

                                QGCLabel {
                                    text:                   qsTr("Guided Maximum Altitude")
                                    visible:                parent._guidedMaximumAltitude.visible
                                }
                                FactTextField {
                                    Layout.preferredWidth:  _valueFieldWidth
                                    visible:                parent._guidedMaximumAltitude.visible
                                    fact:                   parent._guidedMaximumAltitude
                                }

                                QGCLabel {
                                    text:                   qsTr("Go To Location Max Distance")
                                    visible:                parent._maxGoToLocationDistance.visible
                                }
                                FactTextField {
                                    Layout.preferredWidth:  _valueFieldWidth
                                    visible:                parent._maxGoToLocationDistance.visible
                                    fact:                   parent._maxGoToLocationDistance
                                }
                            }
                        }
                    }

                    Item { width: 1; height: _margins }

                    QGCLabel {
                        id:         planViewSectionLabel
                        text:       qsTr("Plan View")
                        visible:    QGroundControl.settingsManager.planViewSettings.visible
                    }
                    Rectangle {
                        Layout.preferredHeight: planViewCol.height + (_margins * 2)
                        Layout.preferredWidth:  planViewCol.width + (_margins * 2)
                        color:                  qgcPal.windowShade
                        visible:                planViewSectionLabel.visible
                        Layout.fillWidth:       true

                        ColumnLayout {
                            id:                         planViewCol
                            anchors.margins:            _margins
                            anchors.top:                parent.top
                            anchors.horizontalCenter:   parent.horizontalCenter
                            spacing:                    _margins

                            RowLayout {
                                spacing:    ScreenTools.defaultFontPixelWidth
                                visible:    QGroundControl.settingsManager.appSettings.defaultMissionItemAltitude.visible

                                QGCLabel { text: qsTr("Default Mission Altitude") }
                                FactTextField {
                                    Layout.preferredWidth:  _valueFieldWidth
                                    fact:                   QGroundControl.settingsManager.appSettings.defaultMissionItemAltitude
                                }
                            }
                        }
                    }

                    Item { width: 1; height: _margins }

                    QGCLabel {
                        id:         autoConnectSectionLabel
                        text:       qsTr("AutoConnect to the following devices")
                        visible:    QGroundControl.settingsManager.autoConnectSettings.visible
                    }
                    Rectangle {
                        Layout.preferredWidth:  autoConnectCol.width + (_margins * 2)
                        Layout.preferredHeight: autoConnectCol.height + (_margins * 2)
                        color:                  qgcPal.windowShade
                        visible:                autoConnectSectionLabel.visible
                        Layout.fillWidth:       true

                        ColumnLayout {
                            id:                 autoConnectCol
                            anchors.margins:    _margins
                            anchors.left:       parent.left
                            anchors.top:        parent.top
                            spacing:            _margins

                            RowLayout {
                                spacing: _margins

                                Repeater {
                                    id:     autoConnectRepeater
                                    model:  [ QGroundControl.settingsManager.autoConnectSettings.autoConnectPixhawk,
                                        QGroundControl.settingsManager.autoConnectSettings.autoConnectSiKRadio,
                                        QGroundControl.settingsManager.autoConnectSettings.autoConnectPX4Flow,
                                        QGroundControl.settingsManager.autoConnectSettings.autoConnectLibrePilot,
                                        QGroundControl.settingsManager.autoConnectSettings.autoConnectUDP,
                                        QGroundControl.settingsManager.autoConnectSettings.autoConnectRTKGPS
                                    ]

                                    property var names: [ qsTr("Pixhawk"), qsTr("SiK Radio"), qsTr("PX4 Flow"), qsTr("LibrePilot"), qsTr("UDP"), qsTr("RTK GPS") ]

                                    FactCheckBox {
                                        text:       autoConnectRepeater.names[index]
                                        fact:       modelData
                                        visible:    modelData.visible
                                    }
                                }
                            }

                            GridLayout {
                                Layout.fillWidth:   false
                                Layout.alignment:   Qt.AlignHCenter
                                columns:            2
                                visible:            !ScreenTools.isMobile
                                                    && QGroundControl.settingsManager.autoConnectSettings.autoConnectNmeaPort.visible
                                                    && QGroundControl.settingsManager.autoConnectSettings.autoConnectNmeaBaud.visible

                                QGCLabel {
                                    text: qsTr("NMEA GPS Device")
                                }
                                QGCComboBox {
                                    id:                     nmeaPortCombo
                                    Layout.preferredWidth:  _comboFieldWidth

                                    model:  ListModel {
                                    }

                                    onActivated: {
                                        if (index != -1) {
                                            QGroundControl.settingsManager.autoConnectSettings.autoConnectNmeaPort.value = textAt(index);
                                        }
                                    }
                                    Component.onCompleted: {
                                        model.append({text: gpsDisabled})
                                        model.append({text: gpsUdpPort})

                                        for (var i in QGroundControl.linkManager.serialPorts) {
                                            nmeaPortCombo.model.append({text:QGroundControl.linkManager.serialPorts[i]})
                                        }
                                        var index = nmeaPortCombo.find(QGroundControl.settingsManager.autoConnectSettings.autoConnectNmeaPort.valueString);
                                        nmeaPortCombo.currentIndex = index;
                                        if (QGroundControl.linkManager.serialPorts.length === 0) {
                                            nmeaPortCombo.model.append({text: "Serial <none available>"})
                                        }
                                    }
                                }

                                QGCLabel {
                                    visible:          nmeaPortCombo.currentText !== gpsUdpPort && nmeaPortCombo.currentText !== gpsDisabled
                                    text:             qsTr("NMEA GPS Baudrate")
                                }
                                QGCComboBox {
                                    visible:                nmeaPortCombo.currentText !== gpsUdpPort && nmeaPortCombo.currentText !== gpsDisabled
                                    id:                     nmeaBaudCombo
                                    Layout.preferredWidth:  _comboFieldWidth
                                    model:                  [4800, 9600, 19200, 38400, 57600, 115200]

                                    onActivated: {
                                        if (index != -1) {
                                            QGroundControl.settingsManager.autoConnectSettings.autoConnectNmeaBaud.value = textAt(index);
                                        }
                                    }
                                    Component.onCompleted: {
                                        var index = nmeaBaudCombo.find(QGroundControl.settingsManager.autoConnectSettings.autoConnectNmeaBaud.valueString);
                                        nmeaBaudCombo.currentIndex = index;
                                    }
                                }

                                QGCLabel {
                                    text:       qsTr("NMEA stream UDP port")
                                    visible:    nmeaPortCombo.currentText === gpsUdpPort
                                }
                                FactTextField {
                                    visible:                nmeaPortCombo.currentText === gpsUdpPort
                                    Layout.preferredWidth:  _valueFieldWidth
                                    fact:                   QGroundControl.settingsManager.autoConnectSettings.nmeaUdpPort
                                }
                            }
                        }
                    }

                    Item { width: 1; height: _margins }

                    QGCLabel {
                        id:         rtkSectionLabel
                        text:       qsTr("RTK GPS")
                        visible:    QGroundControl.settingsManager.rtkSettings.visible
                    }
                    Rectangle {
                        Layout.preferredHeight: rtkGrid.height + (_margins * 2)
                        Layout.preferredWidth:  rtkGrid.width + (_margins * 2)
                        color:                  qgcPal.windowShade
                        visible:                rtkSectionLabel.visible
                        Layout.fillWidth:       true

                        GridLayout {
                            id:                         rtkGrid
                            anchors.topMargin:          _margins
                            anchors.top:                parent.top
                            Layout.fillWidth:           true
                            anchors.horizontalCenter:   parent.horizontalCenter
                            columns:                    3

                            property var  rtkSettings:      QGroundControl.settingsManager.rtkSettings
                            property bool useFixedPosition: rtkSettings.useFixedBasePosition.rawValue
                            property real firstColWidth:    ScreenTools.defaultFontPixelWidth * 3

                            QGCRadioButton {
                                text:               qsTr("Perform Survey-In")
                                visible:            rtkGrid.rtkSettings.useFixedBasePosition.visible
                                checked:            rtkGrid.rtkSettings.useFixedBasePosition.value === false
                                Layout.columnSpan:  3
                                onClicked:          rtkGrid.rtkSettings.useFixedBasePosition.value = false
                            }

                            Item { width: rtkGrid.firstColWidth; height: 1 }
                            QGCLabel {
                                text:               rtkGrid.rtkSettings.surveyInAccuracyLimit.shortDescription
                                visible:            rtkGrid.rtkSettings.surveyInAccuracyLimit.visible
                                enabled:            !rtkGrid.useFixedPosition
                            }
                            FactTextField {
                                fact:               rtkGrid.rtkSettings.surveyInAccuracyLimit
                                visible:            rtkGrid.rtkSettings.surveyInAccuracyLimit.visible
                                enabled:            !rtkGrid.useFixedPosition
                                Layout.preferredWidth:  _valueFieldWidth
                            }

                            Item { width: rtkGrid.firstColWidth; height: 1 }
                            QGCLabel {
                                text:               rtkGrid.rtkSettings.surveyInMinObservationDuration.shortDescription
                                visible:            rtkGrid.rtkSettings.surveyInMinObservationDuration.visible
                                enabled:            !rtkGrid.useFixedPosition
                            }
                            FactTextField {
                                fact:               rtkGrid.rtkSettings.surveyInMinObservationDuration
                                visible:            rtkGrid.rtkSettings.surveyInMinObservationDuration.visible
                                enabled:            !rtkGrid.useFixedPosition
                                Layout.preferredWidth:  _valueFieldWidth
                            }

                            QGCRadioButton {
                                text:               qsTr("Use Specified Base Position")
                                visible:            rtkGrid.rtkSettings.useFixedBasePosition.visible
                                checked:            rtkGrid.rtkSettings.useFixedBasePosition.value === true
                                onClicked:          rtkGrid.rtkSettings.useFixedBasePosition.value = true
                                Layout.columnSpan:  3
                            }

                            Item { width: rtkGrid.firstColWidth; height: 1 }
                            QGCLabel {
                                text:               rtkGrid.rtkSettings.fixedBasePositionLatitude.shortDescription
                                visible:            rtkGrid.rtkSettings.fixedBasePositionLatitude.visible
                                enabled:            rtkGrid.useFixedPosition
                            }
                            FactTextField {
                                fact:               rtkGrid.rtkSettings.fixedBasePositionLatitude
                                visible:            rtkGrid.rtkSettings.fixedBasePositionLatitude.visible
                                enabled:            rtkGrid.useFixedPosition
                                Layout.fillWidth:   true
                            }

                            Item { width: rtkGrid.firstColWidth; height: 1 }
                            QGCLabel {
                                text:               rtkGrid.rtkSettings.fixedBasePositionLongitude.shortDescription
                                visible:            rtkGrid.rtkSettings.fixedBasePositionLongitude.visible
                                enabled:            rtkGrid.useFixedPosition
                            }
                            FactTextField {
                                fact:               rtkGrid.rtkSettings.fixedBasePositionLongitude
                                visible:            rtkGrid.rtkSettings.fixedBasePositionLongitude.visible
                                enabled:            rtkGrid.useFixedPosition
                                Layout.fillWidth:   true
                            }

                            Item { width: rtkGrid.firstColWidth; height: 1 }
                            QGCLabel {
                                text:           rtkGrid.rtkSettings.fixedBasePositionAltitude.shortDescription
                                visible:        rtkGrid.rtkSettings.fixedBasePositionAltitude.visible
                                enabled:        rtkGrid.useFixedPosition
                            }
                            FactTextField {
                                fact:               rtkGrid.rtkSettings.fixedBasePositionAltitude
                                visible:            rtkGrid.rtkSettings.fixedBasePositionAltitude.visible
                                enabled:            rtkGrid.useFixedPosition
                                Layout.fillWidth:   true
                            }

                            Item { width: rtkGrid.firstColWidth; height: 1 }
                            QGCLabel {
                                text:           rtkGrid.rtkSettings.fixedBasePositionAccuracy.shortDescription
                                visible:        rtkGrid.rtkSettings.fixedBasePositionAccuracy.visible
                                enabled:        rtkGrid.useFixedPosition
                            }
                            FactTextField {
                                fact:               rtkGrid.rtkSettings.fixedBasePositionAccuracy
                                visible:            rtkGrid.rtkSettings.fixedBasePositionAccuracy.visible
                                enabled:            rtkGrid.useFixedPosition
                                Layout.fillWidth:   true
                            }

                            Item { width: rtkGrid.firstColWidth; height: 1 }
                            QGCButton {
                                text:               qsTr("Save Current Base Position")
                                enabled:            QGroundControl.gpsRtk && QGroundControl.gpsRtk.valid.value
                                Layout.columnSpan:  2
                                onClicked: {
                                    rtkGrid.rtkSettings.fixedBasePositionLatitude.rawValue =    QGroundControl.gpsRtk.currentLatitude.rawValue
                                    rtkGrid.rtkSettings.fixedBasePositionLongitude.rawValue =   QGroundControl.gpsRtk.currentLongitude.rawValue
                                    rtkGrid.rtkSettings.fixedBasePositionAltitude.rawValue =    QGroundControl.gpsRtk.currentAltitude.rawValue
                                    rtkGrid.rtkSettings.fixedBasePositionAccuracy.rawValue =    QGroundControl.gpsRtk.currentAccuracy.rawValue
                                }
                            }
                        }
                    }

                    Item { width: 1; height: _margins }

                    QGCLabel {
                        id:         videoSectionLabel
                        text:       qsTr("Video")
                        visible:    QGroundControl.settingsManager.videoSettings.visible && !QGroundControl.videoManager.autoStreamConfigured
                    }
                    Rectangle {
                        Layout.preferredWidth:  videoGrid.width + (_margins * 2)
                        Layout.preferredHeight: videoGrid.height + (_margins * 2)
                        Layout.fillWidth:       true
                        color:                  qgcPal.windowShade
                        visible:                videoSectionLabel.visible

                        GridLayout {
                            id:                         videoGrid
                            anchors.margins:            _margins
                            anchors.top:                parent.top
                            anchors.horizontalCenter:   parent.horizontalCenter
                            Layout.fillWidth:           false
                            Layout.fillHeight:          false
                            columns:                    2
                            QGCLabel {
                                text:                   qsTr("Video Source")
                                visible:                QGroundControl.settingsManager.videoSettings.videoSource.visible
                            }
                            FactComboBox {
                                id:                     videoSource
                                Layout.preferredWidth:  _comboFieldWidth
                                indexModel:             false
                                fact:                   QGroundControl.settingsManager.videoSettings.videoSource
                                visible:                QGroundControl.settingsManager.videoSettings.videoSource.visible
                            }

                            QGCLabel {
                                text:                   qsTr("UDP Port")
                                visible:                (_isUDP264 || _isUDP265 || _isMPEGTS)  && QGroundControl.settingsManager.videoSettings.udpPort.visible
                            }
                            FactTextField {
                                Layout.preferredWidth:  _comboFieldWidth
                                fact:                   QGroundControl.settingsManager.videoSettings.udpPort
                                visible:                (_isUDP264 || _isUDP265 || _isMPEGTS) && QGroundControl.settingsManager.videoSettings.udpPort.visible
                            }

                            QGCLabel {
                                text:                   qsTr("RTSP URL")
                                visible:                _isRTSP && QGroundControl.settingsManager.videoSettings.rtspUrl.visible
                            }
                            FactTextField {
                                Layout.preferredWidth:  _comboFieldWidth
                                fact:                   QGroundControl.settingsManager.videoSettings.rtspUrl
                                visible:                _isRTSP && QGroundControl.settingsManager.videoSettings.rtspUrl.visible
                            }

                            QGCLabel {
                                text:                   qsTr("TCP URL")
                                visible:                _isTCP && QGroundControl.settingsManager.videoSettings.tcpUrl.visible
                            }
                            FactTextField {
                                Layout.preferredWidth:  _comboFieldWidth
                                fact:                   QGroundControl.settingsManager.videoSettings.tcpUrl
                                visible:                _isTCP && QGroundControl.settingsManager.videoSettings.tcpUrl.visible
                            }
                            QGCLabel {
                                text:                   qsTr("Aspect Ratio")
                                visible:                _isGst && QGroundControl.settingsManager.videoSettings.aspectRatio.visible
                            }
                            FactTextField {
                                Layout.preferredWidth:  _comboFieldWidth
                                fact:                   QGroundControl.settingsManager.videoSettings.aspectRatio
                                visible:                _isGst && QGroundControl.settingsManager.videoSettings.aspectRatio.visible
                            }

                            QGCLabel {
                                text:                   qsTr("Disable When Disarmed")
                                visible:                _isGst && QGroundControl.settingsManager.videoSettings.disableWhenDisarmed.visible
                            }
                            FactCheckBox {
                                text:                   ""
                                fact:                   QGroundControl.settingsManager.videoSettings.disableWhenDisarmed
                                visible:                _isGst && QGroundControl.settingsManager.videoSettings.disableWhenDisarmed.visible
                            }
                        }
                    }

                    Item { width: 1; height: _margins }

                    QGCLabel {
                        id:                             videoRecSectionLabel
                        text:                           qsTr("Video Recording")
                        visible:                        (QGroundControl.settingsManager.videoSettings.visible && _isGst) || QGroundControl.videoManager.autoStreamConfigured
                    }
                    Rectangle {
                        Layout.preferredWidth:          videoRecCol.width  + (_margins * 2)
                        Layout.preferredHeight:         videoRecCol.height + (_margins * 2)
                        Layout.fillWidth:               true
                        color:                          qgcPal.windowShade
                        visible:                        videoRecSectionLabel.visible

                        GridLayout {
                            id:                         videoRecCol
                            anchors.margins:            _margins
                            anchors.top:                parent.top
                            anchors.horizontalCenter:   parent.horizontalCenter
                            Layout.fillWidth:           false
                            columns:                    2

                            QGCLabel {
                                text:                   qsTr("Auto-Delete Files")
                                visible:                QGroundControl.settingsManager.videoSettings.enableStorageLimit.visible
                            }
                            FactCheckBox {
                                text:                   ""
                                fact:                   QGroundControl.settingsManager.videoSettings.enableStorageLimit
                                visible:                QGroundControl.settingsManager.videoSettings.enableStorageLimit.visible
                            }

                            QGCLabel {
                                text:                   qsTr("Max Storage Usage")
                                visible:                QGroundControl.settingsManager.videoSettings.maxVideoSize.visible && QGroundControl.settingsManager.videoSettings.enableStorageLimit.value
                            }
                            FactTextField {
                                Layout.preferredWidth:  _comboFieldWidth
                                fact:                   QGroundControl.settingsManager.videoSettings.maxVideoSize
                                visible:                QGroundControl.settingsManager.videoSettings.maxVideoSize.visible && QGroundControl.settingsManager.videoSettings.enableStorageLimit.value
                            }

                            QGCLabel {
                                text:                   qsTr("Video File Format")
                                visible:                QGroundControl.settingsManager.videoSettings.recordingFormat.visible
                            }
                            FactComboBox {
                                Layout.preferredWidth:  _comboFieldWidth
                                fact:                   QGroundControl.settingsManager.videoSettings.recordingFormat
                                visible:                QGroundControl.settingsManager.videoSettings.recordingFormat.visible
                            }
                        }
                    }

                    Item { width: 1; height: _margins; visible: videoRecSectionLabel.visible }

                    QGCLabel {
                        id:         brandImageSectionLabel
                        text:       qsTr("Brand Image")
                        visible:    QGroundControl.settingsManager.brandImageSettings.visible && !ScreenTools.isMobile
                    }
                    Rectangle {
                        Layout.preferredWidth:  brandImageGrid.width + (_margins * 2)
                        Layout.preferredHeight: brandImageGrid.height + (_margins * 2)
                        Layout.fillWidth:       true
                        color:                  qgcPal.windowShade
                        visible:                brandImageSectionLabel.visible

                        GridLayout {
                            id:                 brandImageGrid
                            anchors.margins:    _margins
                            anchors.top:        parent.top
                            anchors.left:       parent.left
                            anchors.right:      parent.right
                            columns:            3

                            QGCLabel {
                                text:           qsTr("Indoor Image")
                                visible:        _userBrandImageIndoor.visible
                            }
                            QGCTextField {
                                readOnly:           true
                                Layout.fillWidth:   true
                                text:               _userBrandImageIndoor.valueString.replace("file:///","")
                            }
                            QGCButton {
                                text:       qsTr("Browse")
                                onClicked:  userBrandImageIndoorBrowseDialog.openForLoad()
                                QGCFileDialog {
                                    id:                 userBrandImageIndoorBrowseDialog
                                    title:              qsTr("Choose custom brand image file")
                                    folder:             _userBrandImageIndoor.rawValue.replace("file:///","")
                                    selectExisting:     true
                                    selectFolder:       false
                                    onAcceptedForLoad:  _userBrandImageIndoor.rawValue = "file:///" + file
                                }
                            }

                            QGCLabel {
                                text:       qsTr("Outdoor Image")
                                visible:    _userBrandImageOutdoor.visible
                            }
                            QGCTextField {
                                readOnly:           true
                                Layout.fillWidth:   true
                                text:                _userBrandImageOutdoor.valueString.replace("file:///","")
                            }
                            QGCButton {
                                text:       qsTr("Browse")
                                onClicked:  userBrandImageOutdoorBrowseDialog.openForLoad()
                                QGCFileDialog {
                                    id:                 userBrandImageOutdoorBrowseDialog
                                    title:              qsTr("Choose custom brand image file")
                                    folder:             _userBrandImageOutdoor.rawValue.replace("file:///","")
                                    selectExisting:     true
                                    selectFolder:       false
                                    onAcceptedForLoad:  _userBrandImageOutdoor.rawValue = "file:///" + file
                                }
                            }
                            QGCButton {
                                text:               qsTr("Reset Default Brand Image")
                                Layout.columnSpan:  3
                                Layout.alignment:   Qt.AlignHCenter
                                onClicked:  {
                                    _userBrandImageIndoor.rawValue = ""
                                    _userBrandImageOutdoor.rawValue = ""
                                }
                            }
                        }
                    }

                    Item { width: 1; height: _margins }

                    QGCLabel {
                        text:               qsTr("%1 Version").arg(QGroundControl.appName)
                        Layout.alignment:   Qt.AlignHCenter
                    }
                    QGCLabel {
                        text:               QGroundControl.qgcVersion
                        Layout.alignment:   Qt.AlignHCenter
                    }
                } // settingsColumn
            }
    }
}

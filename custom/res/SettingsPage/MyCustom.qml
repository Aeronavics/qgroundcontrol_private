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
    id: _root
    property Fact fact: Fact { }
    property real _margins: ScreenTools.defaultFontPixelWidth
    property real _comboFieldWidth: ScreenTools.defaultFontPixelWidth * 28
 
    Layout.preferredHeight: col.height + (_margins * 2)
    Layout.preferredWidth:  col.width + (_margins * 2)
    color:                  qgcPal.windowShade
    Layout.fillWidth:       true
    border.width: 0

    Column {
        id: col
        spacing: ScreenTools.defaultFontPixelHeight * 0.25
        anchors.centerIn:  parent
        property bool _showCombo: fact.enumStrings.length !== 0 && fact.bitmaskStrings.length === 0
        property bool _showField: !_showCombo && !_root.fact.typeIsBool
        Row {
            spacing: ScreenTools.defaultFontPixelWidth
            QGCLabel {
                text: _root.fact.shortDescription
            }
        }
        Row {
            spacing: ScreenTools.defaultFontPixelWidth
            anchors.horizontalCenter: parent.horizontalCenter
            visible: !col._showField
            FactCheckBox {
                id: checkBox
                text: qsTr("Enable")
                width: ScreenTools.defaultFontPixelWidth * 20
                anchors.baseline: info.baseline
                visible: _root.fact.typeIsBool
                fact: _root.fact
                onClicked: CustomQuickInterface.setCustom()
            }
            FactComboBox {
                id: comboBox
                anchors.baseline: parent.verticleCenter
                width: _comboFieldWidth 
                fact: _root.fact
                visible: col._showCombo
                onActivated: CustomQuickInterface.setCustom()
            }
            QGCButton {
                id: info
                Layout.preferredWidth: height
                Layout.preferredHeight: ScreenTools.defaultFontPixelHeight
                anchors.verticalCenter: parent.verticleCenter
                text: qsTr("\uD83D")
                onClicked: mainWindow.showComponentDialog(helpDialogComponent, qsTr("Value Details"), mainWindow.showDialogDefaultWidth, StandardButton.Save | StandardButton.Cancel)
                Component {
                    id: helpDialogComponent
                    ParameterEditorDialog {
                        fact: _root.fact
                    }
                }
            }
        }
        Row {
            spacing: ScreenTools.defaultFontPixelWidth
            anchors.horizontalCenter: parent.horizontalCenter
            visible: col._showField
            FactTextField {
                id:      textField
                width:  _comboFieldWidth
                fact: _root.fact
                onEditingFinished: CustomQuickInterface.setCustom()
            }
        }
    }
}

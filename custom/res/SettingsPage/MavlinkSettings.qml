import QtQuick                  2.3
import QtQuick.Controls         1.2
import QtQuick.Controls.Styles  1.4
import QtQuick.Dialogs          1.2
import QtQuick.Layouts          1.2

import QGroundControl                       1.0
import QGroundControl.FactSystem            1.0
import QGroundControl.FactControls          1.0
import QGroundControl.Controls              1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.Palette               1.0


Rectangle {
    id:             __customeMavlinkRoot
    color:          qgcPal.window
    anchors.fill:   parent

    QGCLabel {
        id:             customLabel
        text:           qsTr("This is a custom setting !")
        font.family:    ScreenTools.demiboldFontFamily
    }
    Loader {
        id:             customLogSettings
        anchors.top:    customLabel.bottom
        anchors.bottom: parent.bottom
        anchors.right:  parent.right
        anchors.left:   parent.left
        source : "qrc:/custom/CustomLogSettings.qml"
        visible: true
    }


}

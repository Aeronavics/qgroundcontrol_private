/****************************************************************************
 *
 *   (c) 2009-2016 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/


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

 import CustomQuickInterface             1.0

 Rectangle {
     id:             __UploadImageRoot
     color:          qgcPal.window
     anchors.fill:   parent

     property real _labelWidth:          ScreenTools.defaultFontPixelWidth * 28
     property real _valueWidth:          ScreenTools.defaultFontPixelWidth * 24
     property int  _selectedCount:       0
     property real _columnSpacing:       ScreenTools.defaultFontPixelHeight * 0.25
     property bool _uploadedSelected:    false
     property Fact _disableDataPersistenceFact: QGroundControl.settingsManager.appSettings.disableAllPersistence
     property bool _disableDataPersistence:     _disableDataPersistenceFact ? _disableDataPersistenceFact.rawValue : false

     QGCPalette { id: qgcPal }


     QGCFlickable {
         clip:               true
         anchors.fill:       parent
         anchors.margins:    ScreenTools.defaultFontPixelWidth
         contentHeight:      settingsColumn.height
         contentWidth:       settingsColumn.width
         flickableDirection: Flickable.VerticalFlick

         Column {
             id:                 settingsColumn
             width:              __UploadImageRoot.width
             spacing:            ScreenTools.defaultFontPixelHeight * 0.5
             anchors.margins:    ScreenTools.defaultFontPixelWidth

             Item {
                 width:              __UploadImageRoot.width * 0.8
                 height:             logLabel.height
                 anchors.margins:    ScreenTools.defaultFontPixelWidth
                 anchors.horizontalCenter: parent.horizontalCenter
                 visible:            true
                 QGCLabel {
                     id:             logLabel
                     text:           qsTr("Aeronavics Image Uploads")
                     font.family:    ScreenTools.demiboldFontFamily
                 }
             }
             Rectangle {
                 height:         loginColumn.height + (ScreenTools.defaultFontPixelHeight * 2)
                 width:          __mavlinkRoot.width * 0.8
                 color:          qgcPal.windowShade
                 anchors.margins: ScreenTools.defaultFontPixelWidth
                 anchors.horizontalCenter: parent.horizontalCenter
                 visible:        true
                 Column {
                     id:         loginColumn
                     spacing:    _columnSpacing
                     anchors.centerIn: parent
                     //-----------------------------------------------------------------
                     //-- NetworkId Field
                     Row {
                         spacing:    ScreenTools.defaultFontPixelWidth
                         QGCLabel {
                             width:              _labelWidth
                             anchors.baseline:   usernameField.baseline
                             text:               qsTr("Username :")
                         }
                         QGCTextField {
                             id:         usernameField
                             text:       CustomQuickInterface.username
                             width:      _valueWidth
                             enabled:    !_disableDataPersistence
                             inputMethodHints:       Qt.ImhNoAutoUppercase 
                             anchors.verticalCenter: parent.verticalCenter
                             onEditingFinished: {
                                 saveItems();
                             }
                         }
                     }
                 }
             }
         }
     }
 }

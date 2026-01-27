/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick
import QtQuick.Layouts

import QGroundControl
import QGroundControl.Controls
import QGroundControl.MultiVehicleManager
import QGroundControl.ScreenTools
import QGroundControl.Palette

//-------------------------------------------------------------------------
//-- Vessel attitude indicator

Item {
    anchors.verticalCenter: parent.verticalCenter
    implicitWidth: column.implicitWidth
    implicitHeight: column.implicitHeight
    property var    _activeVehicle:     QGroundControl.multiVehicleManager.activeVehicle
    property real   _heel:              _activeVehicle ? _activeVehicle.roll.rawValue : 0
    property real   _trim:             _activeVehicle ? _activeVehicle.pitch.rawValue : 0

    Column {
        id: column
        spacing: 4

        Text {
            text: qsTr("heel %1 °").arg(_heel.toFixed(1))
            color: "#ffffff"
            font.pointSize: 12
        }

        Text {
            text: qsTr("trim %1 °").arg(_trim.toFixed(1))
            color: "#ffffff"
            font.pointSize: 12
        }
    }
}

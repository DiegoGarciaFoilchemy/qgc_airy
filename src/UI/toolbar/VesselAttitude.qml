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
    anchors.top: parent.top
    anchors.topMargin: 0
    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight
    property var    _activeVehicle:     QGroundControl.multiVehicleManager.activeVehicle
    property real   _heel:              _activeVehicle ? _activeVehicle.roll.rawValue : 0
    property real   _trim:             _activeVehicle ? _activeVehicle.pitch.rawValue : 0

    Row {
        id: row
        spacing: 10

        Column {
            id: column1
            spacing: 0

            Text {
                text: qsTr("heel %1°").arg(_heel.toFixed(1).padStart(5))
                color: "#ffffff"
                font.pointSize: 14
                font.family: "DejaVu Sans Mono"
            }

            Text {
                text: qsTr("trim %1°").arg(_trim.toFixed(1).padStart(5))
                color: "#ffffff"
                font.pointSize: 14
                font.family: "DejaVu Sans Mono"
            }
        }
        Column {
            id: column2
            spacing: 0

            Text {
                text: qsTr("Speed %1kn").arg(_heel.toFixed(1).padStart(5))
                color: "#ffffff"
                font.pointSize: 14
                font.family: "DejaVu Sans Mono"
            }

            Text {
                text: qsTr("Heave %1m").arg(_trim.toFixed(1).padStart(5))
                color: "#ffffff"
                font.pointSize: 14
                font.family: "DejaVu Sans Mono"
            }
        }
    }
}

/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick

import QGroundControl
import QGroundControl.Controls
import QGroundControl.ScreenTools
import QGroundControl.Palette


Item {
    id:     root
    width:  200
    height: width
    // color:  "transparent"

    property real extraInset:           0

    property real   _spacing:           ScreenTools.defaultFontPixelHeight * 0.33
    property real _max_pitch: 5.0
    property real _roll_scale: 3
    property real _max_roll: 10.0
    property real _rollDisplay: Math.max(-_max_roll, Math.min(_max_roll, _rollAngle))

    property var  vehicle:      globals.activeVehicle
    property real _rollAngle:   vehicle ? vehicle.roll.rawValue  : 0
    property real _rollAngleDisplay: _rollAngle
    property real _rollSetpoint: vehicle ? vehicle.rollSp.rawValue : 0
    property real _rollSetpointDisplay: Math.max(-_max_roll, Math.min(_max_roll, _rollSetpoint))

    QGCPalette { id: qgcPal; colorGroupEnabled: true }

    Timer {
        interval: 300
        running: true
        repeat: true
        onTriggered: {
            _rollAngleDisplay = _rollAngle
        }
    }

    DeadMouseArea { anchors.fill: parent }

    Rectangle {
        id:                 rollScale
        width:              parent.width - (_spacing * 2) 
        height:             ScreenTools.defaultFontPixelHeight * 3
        color:              "transparent"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: _maxRoll.height + ScreenTools.defaultFontPixelHeight * 0.5

        readonly property real trackWidth: width - ScreenTools.defaultFontPixelHeight * 0.6
        readonly property real trackLeft:    (width - trackWidth) / 2

        Rectangle {
            id:             rollTrack
            height:          ScreenTools.defaultFontPixelHeight * 0.6
            width:          rollScale.trackWidth
            radius:         height / 2
            color:          qgcPal.windowShade
            border.color:   "#000000"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom:    parent.bottom
            anchors.bottomMargin: ScreenTools.defaultFontPixelHeight * 1.5
        }

        Rectangle {
            id:  _minRoll
            height:          ScreenTools.defaultFontPixelHeight * 0.4
            width:         1
            color:          qgcPal.text
            y:              rollTrack.y + height
            x:              rollTrack.x 

            Text {
                anchors.top: parent.bottom
                anchors.topMargin: ScreenTools.defaultFontPixelHeight * 0.2
                anchors.left: parent.left
                // anchors.leftMargin: ScreenTools.defaultFontPixelHeight * 0.1
                text:          (-_max_roll).toFixed(0) + "°"
                color:         qgcPal.text
                font.pixelSize:ScreenTools.defaultFontPixelHeight * 1.2
            }
        }

        Rectangle {
            id:  _maxRoll
            height:          ScreenTools.defaultFontPixelHeight * 0.4
            width:         1
            color:          qgcPal.text
            y:              rollTrack.y + height
            x:              rollTrack.x + rollTrack.width

            Text {
                anchors.top: parent.bottom
                anchors.topMargin: ScreenTools.defaultFontPixelHeight * 0.2
                anchors.right: parent.right
                // anchors.rightMargin: ScreenTools.defaultFontPixelHeight * 0.1
                text:          (_max_roll).toFixed(0) + "°"
                color:         qgcPal.text
                font.pixelSize:ScreenTools.defaultFontPixelHeight * 1.2
            }
        }

        Rectangle {
            id:  _zeroRoll
            height:          ScreenTools.defaultFontPixelHeight * 1.
            width:         1
            color:          qgcPal.text
            y:              rollTrack.y - height/2 + rollTrack.height / 2
            x:              rollTrack.x + rollTrack.width / 2

            Text {
                anchors.top: parent.bottom
                anchors.topMargin: ScreenTools.defaultFontPixelHeight * 0.2
                anchors.horizontalCenter: parent.horizontalCenter
                text:          (0).toFixed(0) + "°"
                color:         qgcPal.text
                font.pixelSize:ScreenTools.defaultFontPixelHeight * 1.2
            }
        }

        Rectangle {
            id:                     rollPointer
            height:                  rollTrack.height + ScreenTools.defaultFontPixelHeight * 0.8
            width:                 2
            radius:                 1
            color:                  qgcPal.text
            anchors.horizontalCenter: rollTrack.horizontalCenter
            anchors.verticalCenter:   rollTrack.verticalCenter
            anchors.horizontalCenterOffset: (_rollDisplay / _max_roll) * (rollScale.trackWidth / 2)
        }

        Rectangle {
            id:                     rollSetpointPointer
            height:                  rollTrack.height + ScreenTools.defaultFontPixelHeight * 0.8
            width:                 2
            radius:                 1
            color:                  "green"
            anchors.horizontalCenter: rollTrack.horizontalCenter
            anchors.verticalCenter:   rollTrack.verticalCenter
            anchors.horizontalCenterOffset: (_rollSetpointDisplay / _max_roll) * (rollScale.trackWidth / 2)
        }
    }

    Image {
        id:                 boat_roll
        source:             "/qmlimages/boat_rear.svg"
        mipmap:             true
        fillMode:           Image.PreserveAspectFit
        anchors.bottom: rollScale.top
        anchors.bottomMargin: _spacing * 0.
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: _spacing * 7
        rotation:           _rollDisplay * _roll_scale
    }

    Text {
        anchors.bottom: boat_roll.top
        anchors.bottomMargin: _spacing * 0.2
        anchors.horizontalCenter: boat_roll.horizontalCenter
        text:            qsTr("%1 °").arg(_rollAngleDisplay.toFixed(1))
        color:           qgcPal.text
        font.pixelSize:  ScreenTools.defaultFontPixelHeight * 1.3
    }
    Text {
        anchors.bottom: boat_roll.top
        anchors.bottomMargin: _spacing * 0.2
        anchors.left: boat_roll.left
        anchors.leftMargin: _spacing * 0.5
        text:            qsTr("Heel")
        color:           qgcPal.text
        font.pixelSize:  ScreenTools.defaultFontPixelHeight * 1.
    }
}

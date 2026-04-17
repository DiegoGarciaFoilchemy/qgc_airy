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
import QGroundControl.Palette


Item {
    id:     root
    width:  300
    height: 200
    // color:  "transparent"

    property real extraInset:           0
    property bool useFixedPixels:       false
    property real fixedUnitPx:          12
    readonly property real _unitPx:     useFixedPixels ? fixedUnitPx : ScreenTools.defaultFontPixelHeight

    property real   _spacing:           _unitPx * 0.33
    property real _max_pitch: 5.0
    property real _roll_scale: 6.0
    property real _max_roll: 6.0
    property real _rollDisplay: Math.max(-_max_roll, Math.min(_max_roll, _rollAngle))

    property var  vehicle:      globals.activeVehicle
    property real _rollAngle:   vehicle ? vehicle.roll.rawValue  : 0
    property real _rollAngleDisplay: _rollAngle * 1.4
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
        width:              parent.width - (_spacing * 12.) 
        height:             _unitPx * 3
        color:              "transparent"
        anchors.right: parent.right
        anchors.rightMargin: _unitPx * 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: _maxRoll.height + _unitPx * 0.5

        readonly property real trackWidth: width - _unitPx * 0.6
        readonly property real trackLeft:    (width - trackWidth) / 2
        readonly property int _tickStart:    -Math.floor(root._max_roll)
        readonly property int _tickEnd:      Math.floor(root._max_roll)
        readonly property int _tickCount:    Math.max(0, (_tickEnd - _tickStart + 1))

        Rectangle {
            id:             rollTrack
            height:          _unitPx * 0.9
            width:          rollScale.trackWidth
            radius:         height / 2
            color:          qgcPal.windowShade
            border.color:   "#000000"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom:    parent.bottom
            anchors.bottomMargin: _unitPx * 1.5
        }

        Rectangle {
            id:  _minRoll
            height:          _unitPx * 1.5
            width:         2
            color:          qgcPal.text
            y:              rollTrack.y + height/2 - rollTrack.height / 2
            x:              rollTrack.x 

            Text {
                anchors.top: parent.bottom
                anchors.topMargin: _unitPx * 0.4
                anchors.left: parent.left
                // anchors.leftMargin: ScreenTools.defaultFontPixelHeight * 0.1
                text:          (-_max_roll).toFixed(0) + "°"
                color:         qgcPal.text
                font.pixelSize: _unitPx * 2.4
            }
        }

        Rectangle {
            id:  _maxRoll
            height:          _unitPx * 1.5
            width:         2
            color:          qgcPal.text
            y:              rollTrack.y + height/2 - rollTrack.height / 2
            x:              rollTrack.x + rollTrack.width

            Text {
                anchors.top: parent.bottom
                anchors.topMargin: _unitPx * 0.4
                anchors.right: parent.right
                // anchors.rightMargin: ScreenTools.defaultFontPixelHeight * 0.1
                text:          (_max_roll).toFixed(0) + "°"
                color:         qgcPal.text
                font.pixelSize: _unitPx * 2.4
            }
        }

        Rectangle {
            id:  _zeroRoll
            height:          _unitPx * 1.5
            width:         2
            color:          qgcPal.text
            y:              rollTrack.y - height/2 + rollTrack.height / 2
            x:              rollTrack.x + rollTrack.width / 2

            Text {
                anchors.top: parent.bottom
                anchors.topMargin: _unitPx * 0.4
                anchors.horizontalCenter: parent.horizontalCenter
                text:          (0).toFixed(0) + "°"
                color:         qgcPal.text
                font.pixelSize: _unitPx * 2.4
            }
        }

        Rectangle {
            id:                     rollPointer
            height:                  rollTrack.height + _unitPx * 0.8
            width:                 2
            radius:                 1
            color:                  qgcPal.text
            anchors.horizontalCenter: rollTrack.horizontalCenter
            anchors.verticalCenter:   rollTrack.verticalCenter
            anchors.horizontalCenterOffset: (_rollDisplay / _max_roll) * (rollScale.trackWidth / 2)
        }

        Rectangle {
            id:                     rollSetpointPointer
            height:                  rollTrack.height + _unitPx * 0.8
            width:                 4
            radius:                 2
            color:                  "green"
            opacity:                1.0
            anchors.horizontalCenter: rollTrack.horizontalCenter
            anchors.verticalCenter:   rollTrack.verticalCenter
            anchors.horizontalCenterOffset: (_rollSetpointDisplay / _max_roll) * (rollScale.trackWidth / 2)
        }

        Repeater {
            model: rollScale._tickCount

            Rectangle {
                property int tickValue: rollScale._tickStart + index
                visible: tickValue !== 0 && tickValue !== rollScale._tickStart && tickValue !== rollScale._tickEnd
                width: 1
                height: _unitPx * 1.2
                color: qgcPal.text
                opacity: 0.35
                y: rollTrack.y + (rollTrack.height - height) / 2
                x: rollTrack.x + ((tickValue + root._max_roll) / (2 * root._max_roll)) * rollTrack.width - (width / 2)
            }
        }
    }

    Image {
        id:                 boat_roll
        source:             "/qmlimages/boat_rear.svg"
        mipmap:             true
        fillMode:           Image.PreserveAspectFit
        anchors.bottom: rollScale.top
        anchors.bottomMargin: _spacing * 5.
        anchors.horizontalCenter: rollScale.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: _spacing * 4
        rotation:           _rollDisplay * _roll_scale
    }

    Text {
        anchors.bottom: boat_roll.top
        anchors.bottomMargin: _spacing * 0.5
        anchors.horizontalCenter: boat_roll.horizontalCenter
        text:            qsTr("Heel")
        color:           qgcPal.text
        font.pixelSize:  _unitPx * 2.3
    }
    Text {
        anchors.left: parent.left
        anchors.leftMargin: _spacing * 0
        anchors.verticalCenter: parent.verticalCenter
        // Reserve a sign column so positive/negative values render at a stable x-position.
        text: qsTr("%1 °").arg((_rollAngleDisplay < 0 ? "-" : " ") + Math.abs(_rollAngleDisplay).toFixed(1))
        color: qgcPal.text
        font.pixelSize: _unitPx * 3.
    }
}

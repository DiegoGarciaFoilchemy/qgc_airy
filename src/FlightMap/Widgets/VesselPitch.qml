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
    clip:   true
    // color:  "transparent"

    property real extraInset:           0

    property real   _spacing:           ScreenTools.defaultFontPixelHeight * 0.33
    property real _pitch_scale: 4.0
    property real _max_pitch: 5.0
    property real _pitchDisplay: Math.max(-_max_pitch, Math.min(_max_pitch, _pitchAngle))
    property real _pitchSetpointDisplay: Math.max(-_max_pitch, Math.min(_max_pitch, _pitchSetpoint))

    property var  vehicle:      globals.activeVehicle
    property real _pitchAngle:  vehicle ? vehicle.pitch.rawValue : 0
    property real _pitchAngleDisplay: _pitchAngle
    property real _pitchSetpoint: 2// vehicle ? vehicle.pitch.setpointRawValue : 0
    QGCPalette { id: qgcPal; colorGroupEnabled: true }

    Timer {
        interval: 300
        running: true
        repeat: true
        onTriggered: {
            _pitchAngleDisplay = _pitchAngle
        }
    }

    DeadMouseArea { anchors.fill: parent }


    // Pitch scale on the left, showing unclamped pitch range
    Rectangle {
        id:                 pitchScale
        width:              ScreenTools.defaultFontPixelHeight * 3
        height:             parent.height - (_spacing * 4)
        color:              "transparent"
        anchors.verticalCenter: parent.verticalCenter
        anchors.right:      parent.right
        anchors.rightMargin: _maxPitch.width + ScreenTools.defaultFontPixelHeight * 0.5

        readonly property real trackHeight: height - ScreenTools.defaultFontPixelHeight * 0.6
        readonly property real trackTop:    (height - trackHeight) / 2

        Rectangle {
            id:             track
            width:          ScreenTools.defaultFontPixelHeight * 0.6
            height:         pitchScale.trackHeight
            radius:         width / 2
            color:          qgcPal.windowShade
            border.color:   "#000000"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top:    parent.top
            anchors.topMargin: pitchScale.trackTop
        }

        Rectangle {
            id:  _maxPitch
            width:          ScreenTools.defaultFontPixelHeight * 0.4
            height:         1
            color:          qgcPal.text
            x:              track.x + width
            y:              track.y 

            Text {
                anchors.left: parent.right
                anchors.leftMargin: ScreenTools.defaultFontPixelHeight * 0.2
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: ScreenTools.defaultFontPixelHeight  / 2
                text:          _max_pitch.toFixed(0) + "°"
                color:         qgcPal.text
                font.pixelSize:ScreenTools.defaultFontPixelHeight * 1.2
            }
        }

        Rectangle {
            id:  _minPitch
            width:          ScreenTools.defaultFontPixelHeight * 0.4
            height:         1
            color:          qgcPal.text
            x:              track.x + width
            y:              track.y + pitchScale.trackHeight

            Text {
                anchors.left: parent.right
                anchors.leftMargin: ScreenTools.defaultFontPixelHeight * 0.2
                anchors.bottom: parent.bottom
                text:          (-_max_pitch).toFixed(0) + "°"
                color:         qgcPal.text
                font.pixelSize:ScreenTools.defaultFontPixelHeight * 1.2
            }
        }

        Rectangle {
            id:  _zeroPitch
            width:          ScreenTools.defaultFontPixelHeight * 1.
            height:         1
            color:          qgcPal.text
            x:              track.x - width/2 + track.width / 2
            y:              track.y + pitchScale.trackHeight / 2

            Text {
                anchors.left: parent.right
                anchors.leftMargin: ScreenTools.defaultFontPixelHeight * 0.2
                anchors.verticalCenter: parent.verticalCenter
                text:          (0).toFixed(0) + "°"
                color:         qgcPal.text
                font.pixelSize:ScreenTools.defaultFontPixelHeight * 1.2
            }
        }

        Rectangle {
            id:                     pitchSetpoint
            width:                  track.width + ScreenTools.defaultFontPixelHeight * 0.8
            height:                 3
            radius:                 1
            color:                  "green"
            anchors.horizontalCenter: track.horizontalCenter
            anchors.verticalCenter:   track.verticalCenter
            anchors.verticalCenterOffset: -(_pitchSetpoint / _max_pitch) * (pitchScale.trackHeight / 2)
            opacity:               0.7
        }

        Rectangle {
            id:                     pitchPointer
            width:                  track.width + ScreenTools.defaultFontPixelHeight * 0.8
            height:                 2
            radius:                 1
            color:                  qgcPal.text
            anchors.horizontalCenter: track.horizontalCenter
            anchors.verticalCenter:   track.verticalCenter
            anchors.verticalCenterOffset: -(_pitchDisplay / _max_pitch) * (pitchScale.trackHeight / 2)
        }
    }

    Image {
        id:                 boat_pitch
        source:             "/qmlimages/boat_side.svg"
        mipmap:             true
        fillMode:           Image.PreserveAspectFit
        mirror:             true
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: pitchScale.left
        anchors.rightMargin: ScreenTools.defaultFontPixelHeight * 0.4
        // sourceSize.height:  parent.height * 0.35
        rotation:           -_pitchDisplay * _pitch_scale
    }
    Text {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: _spacing * 4
        anchors.horizontalCenter: boat_pitch.horizontalCenter
        anchors.horizontalCenterOffset: -0.6 *_spacing
        text:            qsTr("%1 °").arg(_pitchAngleDisplay.toFixed(1))
        color:           qgcPal.text
        font.pixelSize:  ScreenTools.defaultFontPixelHeight * 1.3
    }

    Text {
        anchors.top: parent.top
        anchors.topMargin: _spacing * 4
        anchors.horizontalCenter: boat_pitch.horizontalCenter
        anchors.horizontalCenterOffset: -0.6 *_spacing
        text:            qsTr("Trim")
        color:           qgcPal.text
        font.pixelSize:  ScreenTools.defaultFontPixelHeight * 1.
    }
}

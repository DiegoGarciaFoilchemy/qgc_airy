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
    width:  350
    height: 200
    clip:   true
    // color:  "transparent"

    property real extraInset:           0
    property bool useFixedPixels:       false
    property real fixedUnitPx:          12
    readonly property real _unitPx:     useFixedPixels ? fixedUnitPx : ScreenTools.defaultFontPixelHeight

    property real   _spacing:           _unitPx * 0.33
    property real _pitch_scale: 4.0
    property real _max_pitch: 5.0
    property real _min_pitch: -2.0
    property real _pitchRange: _max_pitch - _min_pitch
    property real _pitchDisplay: Math.max(_min_pitch, Math.min(_max_pitch, _pitchAngle))
    property real _pitchSetpointDisplay: Math.max(_min_pitch, Math.min(_max_pitch, _pitchSetpoint))

    property var  vehicle:      globals.activeVehicle
    property real _pitchAngle:  vehicle ? vehicle.pitch.rawValue : 0
    property real _pitchAngleDisplay: _pitchAngle
    property real _pitchSetpoint: vehicle ? vehicle.pitchSp.rawValue : -5

    function pitchToTrackOffset(pitchValue, trackHeight) {
        const clampedPitch = Math.max(_min_pitch, Math.min(_max_pitch, pitchValue))
        const ratio = (clampedPitch - _min_pitch) / _pitchRange
        return (0.5 - ratio) * trackHeight
    }

    function pitchToTrackY(pitchValue, trackTop, trackHeight) {
        const clampedPitch = Math.max(_min_pitch, Math.min(_max_pitch, pitchValue))
        return trackTop + ((_max_pitch - clampedPitch) / _pitchRange) * trackHeight
    }

    QGCPalette { id: qgcPal; colorGroupEnabled: true }

    Timer {
        interval: 350
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
        width:              _unitPx * 3
        height:             parent.height - (_spacing * 4)
        color:              "transparent"
        anchors.verticalCenter: parent.verticalCenter
        anchors.right:      parent.right
        anchors.rightMargin: _unitPx * 10

        readonly property real trackHeight: height - _unitPx * 0.6
        readonly property real trackTop:    (height - trackHeight) / 2
        readonly property int _tickStart:   Math.ceil(root._min_pitch)
        readonly property int _tickEnd:     Math.floor(root._max_pitch)
        readonly property int _tickCount:   Math.max(0, (_tickEnd - _tickStart + 1))

        Rectangle {
            id:             track
            width:          _unitPx * 0.9
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
            width:          _unitPx * 1.5
            height:         2
            color:          qgcPal.text
            x:              track.x  - width/2 + track.width / 2
            y:              track.y 

            Text {
                anchors.left: parent.right
                anchors.leftMargin: _unitPx * 0.4
                anchors.verticalCenter: parent.verticalCenter
                text:          _max_pitch.toFixed(0) + "°"
                color:         qgcPal.text
                font.pixelSize: _unitPx * 2.4
            }
        }

        Rectangle {
            id:  _minPitch
            width:          _unitPx * 1.5
            height:         2
            color:          qgcPal.text
            x:              track.x  - width/2 + track.width / 2
            y:              track.y + pitchScale.trackHeight

            Text {
                anchors.left: parent.right
                anchors.leftMargin: _unitPx * 0.4
                anchors.verticalCenter: parent.verticalCenter
                text:          _min_pitch.toFixed(0) + "°"
                color:         qgcPal.text
                font.pixelSize: _unitPx * 2.4
            }
        }

        Rectangle {
            id:  _zeroPitch
            width:          _unitPx * 1.5
            height:         2
            color:          qgcPal.text
            x:              track.x - width/2 + track.width / 2
            y:              root.pitchToTrackY(0, track.y, pitchScale.trackHeight)

            Text {
                anchors.left: parent.right
                anchors.leftMargin: _unitPx * 0.4
                anchors.verticalCenter: parent.verticalCenter
                text:          (0).toFixed(0) + "°"
                color:         qgcPal.text
                font.pixelSize: _unitPx * 2.4
            }
        }

        Repeater {
            model: pitchScale._tickCount

            Rectangle {
                property int tickValue: pitchScale._tickStart + index
                visible: tickValue !== 0 && tickValue !== pitchScale._tickStart && tickValue !== pitchScale._tickEnd
                width: _unitPx * 1.2
                height: 1
                color: qgcPal.text
                opacity: 0.35
                x: track.x - width / 2 + track.width / 2
                y: root.pitchToTrackY(tickValue, track.y, pitchScale.trackHeight)
            }
        }

        Rectangle {
            id:                     pitchSetpoint
            width:                  track.width + _unitPx * 1.2
            height:                 4
            radius:                 2
            color:                  "green"
            anchors.horizontalCenter: track.horizontalCenter
            anchors.verticalCenter:   track.verticalCenter
            anchors.verticalCenterOffset: root.pitchToTrackOffset(_pitchSetpointDisplay, pitchScale.trackHeight)
            opacity:               1.0
        }

        Rectangle {
            id:                     pitchPointer
            width:                  track.width + _unitPx * 1.2
            height:                 2
            radius:                 1
            color:                  qgcPal.text
            anchors.horizontalCenter: track.horizontalCenter
            anchors.verticalCenter:   track.verticalCenter
            anchors.verticalCenterOffset: root.pitchToTrackOffset(_pitchDisplay, pitchScale.trackHeight)
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
        anchors.rightMargin: _unitPx * 1.
        // sourceSize.height:  parent.height * 0.35
        rotation:           -_pitchDisplay * _pitch_scale
    }
    Text {
        anchors.left: pitchScale.right
        anchors.leftMargin: _unitPx * 2
        anchors.verticalCenter: pitchScale.verticalCenter
        // Reserve a sign column so positive/negative values render at a stable x-position.
        text:            qsTr("%1 °").arg((_pitchAngleDisplay < 0 ? "-" : " ") + Math.abs(_pitchAngleDisplay).toFixed(1))
        color:           qgcPal.text
        font.pixelSize:  _unitPx * 3.
    }

    Text {
        anchors.top: parent.top
        anchors.topMargin: _spacing * 2
        anchors.horizontalCenter: boat_pitch.horizontalCenter
        anchors.horizontalCenterOffset: -0.6 *_spacing
        text:            qsTr("Trim")
        color:           qgcPal.text
        font.pixelSize:  _unitPx * 2.3
    }
}

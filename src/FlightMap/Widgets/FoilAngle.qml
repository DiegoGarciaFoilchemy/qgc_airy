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


Rectangle {
    id:     root
    width:  190
    height: 200
    color:  "transparent"

    property real extraInset:           0

    property real   _spacing:           ScreenTools.defaultFontPixelHeight * 0.33
    property real _pitch_scale: 4.0
    property real _max_pitch: 5.0
    property real _pitchDisplay: Math.max(-_max_pitch, Math.min(_max_pitch, _pitchAngle))
    property real _pitchSetpointDisplay: Math.max(-_max_pitch, Math.min(_max_pitch, _pitchSetpoint))
    property real _roll_scale: 1.2
    property real _max_roll: 10.0
    property real _rollDisplay: Math.max(-_max_roll, Math.min(_max_roll, _rollAngle))

    property var  vehicle:      globals.activeVehicle
    property real _rollAngle:   vehicle ? vehicle.acu1Angle.rawValue  : 0
    property real _pitchAngle:  vehicle ? vehicle.pitch.rawValue : 0
    property real _rollAngleDisplay: _rollAngle
    property real _pitchAngleDisplay: _pitchAngle
    property real _pitchSetpoint: 2// vehicle ? vehicle.pitch.setpointRawValue : 0
    QGCPalette { id: qgcPal; colorGroupEnabled: true }

    Timer {
        interval: 500
        running: true
        repeat: true
        onTriggered: {
            _rollAngleDisplay = _rollAngle
            _pitchAngleDisplay = _pitchAngle
        }
    }

    DeadMouseArea { anchors.fill: parent }

    // Top section - roll display
    Rectangle {
        id:             topSection
        width:          parent.width
        height:         parent.height / 2
        anchors.top:    parent.top
        // radius:         _outerRadius / 5
        color:          qgcPal.windowShadeLight

        // Roll scale on the left
        Rectangle {
            id:                 rollScale
            width:              ScreenTools.defaultFontPixelHeight * 3
            height:             topSection.height - (_spacing * 2)
            color:              "transparent"
            anchors.verticalCenter: topSection.verticalCenter
            anchors.left:      topSection.left
            anchors.leftMargin: 4*_spacing

            readonly property real trackHeight: height - ScreenTools.defaultFontPixelHeight * 0.6
            readonly property real trackTop:    (height - trackHeight) / 2
            readonly property int  tickCount:   3
            readonly property real tickStep:    (2 * _max_roll) / (tickCount - 1)

            Rectangle {
                id:             rollTrack
                width:          ScreenTools.defaultFontPixelHeight * 0.6
                height:         rollScale.trackHeight
                radius:         width / 2
                color:          qgcPal.windowShade
                border.color:   qgcPal.windowShadeDark
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top:    parent.top
                anchors.topMargin: rollScale.trackTop
            }

            Repeater {
                model: rollScale.tickCount
                delegate: Rectangle {
                    readonly property real value: _max_roll - (index * rollScale.tickStep)
                    width:          ScreenTools.defaultFontPixelHeight * 0.4
                    height:         1
                    color:          qgcPal.text
                    x:              rollTrack.x - width
                    y:              rollTrack.y + ((index / (rollScale.tickCount - 1)) * rollScale.trackHeight)

                    Text {
                        readonly property int midIndex: Math.floor((rollScale.tickCount - 1) / 2)
                        visible:       (index === 0 || index === rollScale.tickCount - 1 || index === midIndex)
                        anchors.right: parent.left
                        anchors.rightMargin: ScreenTools.defaultFontPixelHeight * 0.2
                        anchors.verticalCenter: parent.verticalCenter
                        text:          value.toFixed(0) + "°"
                        color:         qgcPal.text
                        font.pixelSize:ScreenTools.defaultFontPixelHeight * 0.9
                    }
                }
            }

            Rectangle {
                id:                     rollPointer
                width:                  rollTrack.width + ScreenTools.defaultFontPixelHeight * 0.8
                height:                 2
                radius:                 1
                color:                  qgcPal.text
                anchors.horizontalCenter: rollTrack.horizontalCenter
                anchors.verticalCenter:   rollTrack.verticalCenter
                anchors.verticalCenterOffset: -(_rollDisplay / _max_roll) * (rollScale.trackHeight / 2)
            }
        }

        Image {
            id:                 boat_roll
            source:             "/qmlimages/boat_rear.svg"
            mipmap:             true
            fillMode:           Image.PreserveAspectFit
            anchors.verticalCenter: topSection.verticalCenter
            anchors.verticalCenterOffset: -2.2 * _spacing;
            anchors.right: topSection.right
            anchors.rightMargin: 2.8 *_spacing
            sourceSize.height:  topSection.height * 0.5
            rotation:           _rollDisplay * _roll_scale
        }

        Text {
            anchors.bottom: topSection.bottom
            anchors.bottomMargin: _spacing * 1
            anchors.horizontalCenter: boat_roll.horizontalCenter
            anchors.horizontalCenterOffset: -0.6 *_spacing
            text:            qsTr("%1 °").arg(_rollAngleDisplay.toFixed(1))
            color:           qgcPal.text
            font.pixelSize:  ScreenTools.defaultFontPixelHeight * 1.3
        }
    }

    // Bottom section - pitch display
    Rectangle {
        id:             bottomSection
        width:          parent.width
        height:         parent.height / 2
        anchors.bottom: parent.bottom
        // radius:         _outerRadius / 5
        color:          qgcPal.windowShadeLight

    // Pitch scale on the left, showing unclamped pitch range
        Rectangle {
            id:                 pitchScale
            width:              ScreenTools.defaultFontPixelHeight * 3
            height:             bottomSection.height - (_spacing * 2)
            color:              "transparent"
            anchors.verticalCenter: bottomSection.verticalCenter
            anchors.left:      bottomSection.left
            anchors.leftMargin: 4*_spacing

            readonly property real trackHeight: height - ScreenTools.defaultFontPixelHeight * 0.6
            readonly property real trackTop:    (height - trackHeight) / 2
            readonly property int  tickCount:   3
            readonly property real tickStep:    (2 * _max_pitch) / (tickCount - 1)

            Rectangle {
                id:             track
                width:          ScreenTools.defaultFontPixelHeight * 0.6
                height:         pitchScale.trackHeight
                radius:         width / 2
                color:          qgcPal.windowShade
                border.color:   qgcPal.windowShadeDark
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top:    parent.top
                anchors.topMargin: pitchScale.trackTop
            }

            Repeater {
                model: pitchScale.tickCount
                delegate: Rectangle {
                    readonly property real value: _max_pitch - (index * pitchScale.tickStep)
                    width:          ScreenTools.defaultFontPixelHeight * 0.4
                    height:         1
                    color:          qgcPal.text
                    x:              track.x - width
                    y:              track.y + ((index / (pitchScale.tickCount - 1)) * pitchScale.trackHeight)

                    Text {
                        readonly property int midIndex: Math.floor((pitchScale.tickCount - 1) / 2)
                        visible:       (index === 0 || index === pitchScale.tickCount - 1 || index === midIndex)
                        anchors.right: parent.left
                        anchors.rightMargin: ScreenTools.defaultFontPixelHeight * 0.2
                        anchors.verticalCenter: parent.verticalCenter
                        text:          value.toFixed(0) + "°"
                        color:         qgcPal.text
                        font.pixelSize:ScreenTools.defaultFontPixelHeight * 0.9
                    }
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
                anchors.verticalCenter: bottomSection.verticalCenter
                anchors.verticalCenterOffset: -2.2 * _spacing; // positive means image down
                anchors.right: bottomSection.right
                anchors.rightMargin: 1.5 *_spacing // positives image to the left
                sourceSize.height:  bottomSection.height * 0.35
                rotation:           -_pitchDisplay * _pitch_scale
            }
        Text {
            anchors.bottom: bottomSection.bottom
            anchors.bottomMargin: _spacing * 1
            anchors.horizontalCenter: boat_pitch.horizontalCenter
            anchors.horizontalCenterOffset: -0.6 *_spacing
            text:            qsTr("%1 °").arg(_pitchAngleDisplay.toFixed(1))
            color:           qgcPal.text
            font.pixelSize:  ScreenTools.defaultFontPixelHeight * 1.3
        }
    }
}

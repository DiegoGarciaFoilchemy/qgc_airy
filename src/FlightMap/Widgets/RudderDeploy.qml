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
    id: root
    width: 200
    height: width * 0.001
    visible: true

    property real labelPointSize: 20
    property real rudderDeployment: 0

    // Rudder deflection range (symmetric around zero).
    readonly property real _maxDeflection: 25
    readonly property real _barHeight: 24
    readonly property real _halfWidth: width / 2

    // Fraction of the half-width that should be filled, clamped to [0, 1].
    readonly property real _positiveFill: Math.max(0, Math.min(rudderDeployment, _maxDeflection)) / _maxDeflection
    readonly property real _negativeFill: Math.max(0, Math.min(-rudderDeployment, _maxDeflection)) / _maxDeflection

    QGCPalette { id: qgcPal }

    // Horizontal indicator track. Left half is red (negative), right half is green (positive).
    Rectangle {
        id: bar
        width: parent.width
        height: _barHeight
        anchors.top: parent.top
        color: "transparent"
        border.color: qgcPal.text
        border.width: 1
    }

    // Center reference tick.
    Rectangle {
        x: bar.x + _halfWidth - 1
        y: bar.y
        width: 2
        height: _barHeight
        color: qgcPal.text
    }

    // Positive deflection: green fills from the middle toward the right side.
    Rectangle {
        id: greenFill
        x: bar.x + _halfWidth
        y: bar.y
        width: _positiveFill * _halfWidth
        height: _barHeight
        color: qgcPal.colorGreen
    }

    // Negative deflection: red fills from the middle toward the left side.
    Rectangle {
        id: redFill
        x: bar.x + _halfWidth - _negativeFill * _halfWidth
        y: bar.y
        width: _negativeFill * _halfWidth
        height: _barHeight
        color: qgcPal.colorRed
    }

    // Angle readout below the rectangle.
    QGCLabel {
        anchors.top: bar.bottom
        anchors.topMargin: 4
        anchors.horizontalCenter: parent.horizontalCenter
        text: rudderDeployment.toFixed(1) + "\u00B0"
        font: Qt.font({ pixelSize: labelPointSize * 1.7 })
    }
}

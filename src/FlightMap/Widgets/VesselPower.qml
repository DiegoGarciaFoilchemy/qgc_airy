/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick
import QtQuick.Controls

import QGroundControl
import QGroundControl.Controls
import QGroundControl.Palette


Item {
    id: root

    property real power: 0
    property real maxPower: 80
    property real minPower: 0

    implicitWidth: 220
    implicitHeight: 220

    readonly property real _center: Math.min(width, height) * 0.5
    readonly property real _radius: _center * 0.88
    readonly property real _startDeg: -200
    readonly property real _sweepDeg: 210

    function _clampPower(value) {
        return Math.max(minPower, Math.min(maxPower, value))
    }

    Canvas {
        id: dial
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()

            var w = width
            var h = height
            var cx = w * 0.5
            var cy = h * 0.5
            var r = root._radius

            // Base ring
            ctx.beginPath()
            ctx.arc(cx, cy, r, 0, Math.PI * 2)
            ctx.fillStyle = "#800e0f12"
            ctx.fill()

            // Outer bezel
            ctx.beginPath()
            ctx.arc(cx, cy, r, 0, Math.PI * 2)
            ctx.strokeStyle = "#b320242b"
            ctx.lineWidth = r * 0.07
            ctx.stroke()

            // Tick marks
            var tickCount = 8
            var inner = r * 0.75
            var outer = r * 0.9
            ctx.strokeStyle = "#d9dde3"
            ctx.lineWidth = r * 0.03
            for (var i = 0; i < tickCount; i++) {
                var t = i / (tickCount - 1)
                var deg = root._startDeg + root._sweepDeg * t
                var rad = (deg * Math.PI) / 180
                var x1 = cx + Math.cos(rad) * inner
                var y1 = cy + Math.sin(rad) * inner
                var x2 = cx + Math.cos(rad) * outer
                var y2 = cy + Math.sin(rad) * outer
                ctx.beginPath()
                ctx.moveTo(x1, y1)
                ctx.lineTo(x2, y2)
                ctx.stroke()
            }

            // Progress arc
            var clamped = root._clampPower(root.power)
            var ratio = (clamped - root.minPower) / (root.maxPower - root.minPower)
            var endDeg = root._startDeg + root._sweepDeg * ratio
            ctx.beginPath()
            ctx.arc(cx, cy, r * 0.79, (root._startDeg * Math.PI) / 180, (endDeg * Math.PI) / 180)
            ctx.strokeStyle = "#ffffff"
            ctx.lineWidth = r * 0.2
            ctx.lineCap = "round"
            ctx.stroke()
        }
    }

    Column {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 16
        spacing: 2

        Label {
            id: powerLabel
            anchors.horizontalCenter: parent.horizontalCenter
            text: Math.round(root._clampPower(root.power))
            font.pixelSize: 54
            font.bold: true
            color: "#ffffff"
            horizontalAlignment: Text.AlignHCenter
        }

        Label {
            id: unitsLabel
            anchors.horizontalCenter: parent.horizontalCenter
            text: "kW"
            font.pixelSize: 25
            color: "#ffffff"
            horizontalAlignment: Text.AlignHCenter
        }
    }

    onPowerChanged: {
        dial.requestPaint()
    }
    onWidthChanged: dial.requestPaint()
    onHeightChanged: dial.requestPaint()
    onMaxPowerChanged: dial.requestPaint()
    onMinPowerChanged: dial.requestPaint()
}

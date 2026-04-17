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
    width: 260
    height: width
    
    property real value: 0 // Current speedometer value (-40 to 40)
    property bool highSpeed: false
    readonly property real displayLimit: highSpeed ? 13 : 40
    readonly property real minValue: -displayLimit
    readonly property real maxValue: displayLimit
    property real needleWidth: 4
    property real foilAngle: 0
    property bool showFoil: true
    property int labelFontSize: 20
    property real gaugeCenterX: width / 2
    property real gaugeCenterY: height / 2
    property real gaugeRadius: Math.min(width, height) / 2 - 10
    property real spanRadians: 80 * Math.PI / 180
    property real startAngle: Math.PI - spanRadians / 2
    property real endAngle: Math.PI + spanRadians / 2
    property real labelRadius: gaugeRadius + 16
    property var foilName: "Generic Foil"
    property var foilStatus: "RUNNING"
    property bool inverted: false
    
    // Computed angles for current orientation
    readonly property real arcStart: inverted ? -spanRadians/2 : startAngle
    readonly property real arcEnd: inverted ? spanRadians/2 : endAngle

    function valueToAngle(inputValue) {
        const normalized = (inputValue - minValue) / (maxValue - minValue)
        const mapped = inverted ? normalized : (1 - normalized)
        return arcStart + mapped * Math.abs(arcEnd - arcStart)
    }

    function foilToNeedleAngle(inputValue) {
        const clampedValue = Math.max(minValue, Math.min(maxValue, inputValue))
        const normalized = (clampedValue - minValue) / (maxValue - minValue)
        return -spanRadians * 0.5 * 180 / Math.PI + normalized * spanRadians * 180 / Math.PI
    }
    
    // Redraw canvas when inverted changes
    onInvertedChanged: canvas.requestPaint()
    
    // Canvas for drawing the speedometer
    Canvas {
        id: canvas
        anchors.fill: parent
        
        onPaint: {
            var ctx = getContext("2d")
            var centerX = gaugeCenterX
            var centerY = gaugeCenterY
            var radius = gaugeRadius
            
            // Clear canvas
            ctx.clearRect(0, 0, width, height)
            
            // Draw inner arc (80°)
            ctx.strokeStyle = "#cccccc"
            ctx.lineWidth = 2
            ctx.beginPath()
            ctx.arc(centerX, centerY, radius - 5, arcStart, arcEnd)
            ctx.stroke()
            
            // Draw scale markings
            ctx.strokeStyle = "#ffffff"
            
            var majorValues = [minValue, 0, maxValue]
            for (let i = 0; i < majorValues.length; i++) {
                var value = majorValues[i]
                var angle = valueToAngle(value)
                
                // Draw tick marks
                var x1 = centerX + (radius - 15) * Math.cos(angle)
                var y1 = centerY + (radius - 15) * Math.sin(angle)
                var x2 = centerX + (radius - 5) * Math.cos(angle)
                var y2 = centerY + (radius - 5) * Math.sin(angle)
                
                ctx.lineWidth = 2
                ctx.beginPath()
                ctx.moveTo(x1, y1)
                ctx.lineTo(x2, y2)
                ctx.stroke()
            }
            
            // Draw minor tick marks at -20 and 20 (no labels)
            var minorValues = [minValue / 2, maxValue / 2]
            ctx.lineWidth = 1.5
            for (let i = 0; i < minorValues.length; i++) {
                var value = minorValues[i]
                var angle = valueToAngle(value)
                
                var x1 = centerX + (radius - 12) * Math.cos(angle)
                var y1 = centerY + (radius - 12) * Math.sin(angle)
                var x2 = centerX + (radius - 5) * Math.cos(angle)
                var y2 = centerY + (radius - 5) * Math.sin(angle)
                
                ctx.beginPath()
                ctx.moveTo(x1, y1)
                ctx.lineTo(x2, y2)
                ctx.stroke()
            }
        }
    }
    
    // Labels outside the arc
    Repeater {
        model: [minValue, 0, maxValue]
        delegate: Text {
            text: modelData.toString() + "º"
            color: "#ffffff"
            font.pixelSize: labelFontSize
            property real angle: valueToAngle(modelData)
            x: (gaugeCenterX + labelRadius * Math.cos(angle)) - width / 2
            y: (gaugeCenterY + labelRadius * Math.sin(angle)) - height / 2
        }
    }
    
    // Needle
    Image {
        id: foil
        visible: showFoil
        source:             "/qmlimages/foil.svg"
        mipmap:             true
        fillMode:           Image.PreserveAspectFit
        width: 110

        // Align rotation point with speedometer center
        x: inverted ? gaugeCenterX + width : gaugeCenterX - width
        y: gaugeCenterY - height / 2 - 5
        transform:[
            Rotation {
                origin.x: width / 2.35
                origin.y: 13
                angle: foilToNeedleAngle(foilAngle)
            },
            Scale { xScale: inverted ? -1 : 1; yScale: 1 }
        ]
    }
    
    // Redraw canvas when needed
    Label {
        y: foilAngleValue.y - labelFontSize * 0.6
        property real statusCenterX: inverted ? gaugeCenterX + gaugeRadius * 1.7 : gaugeCenterX - gaugeRadius * 1.7
        x: statusCenterX - width / 2
        text: foilName
        color: "#ffffff"
        font: Qt.font({ pixelSize: labelFontSize * 1.2 })
    }

    Label {
        y: foilAngleValue.y + labelFontSize * 2.5
        width: gaugeRadius * 2.2
        property real statusCenterX: inverted ? gaugeCenterX + gaugeRadius * 1.7 : gaugeCenterX - gaugeRadius * 1.7
        x: statusCenterX - width / 2
        text: foilStatus
        color: "#ffffff"
        font: Qt.font({ pixelSize: labelFontSize * 1.2 })
        horizontalAlignment: Text.AlignHCenter
    }
    Item {
        id: foilAngleValue
        visible: showFoil
        y: gaugeCenterY - labelFontSize * 1.3
        width: gaugeRadius * 1.3
        height: labelFontSize * 1.8
        property real valueCenterX: inverted ? gaugeCenterX - gaugeRadius * 0.55 : gaugeCenterX + gaugeRadius * 0.55
        x: valueCenterX - width / 1.8

        readonly property string absFormatted: Math.abs(foilAngle).toFixed(1)
        readonly property string integerPart: {
            const parts = absFormatted.split(".")
            return parts[0].length < 2 ? (" " + parts[0]) : parts[0]
        }
        readonly property string decimalPart: absFormatted.split(".")[1]
        readonly property bool twoDigitAbs: Math.abs(foilAngle) >= 10

        Row {
            anchors.centerIn: parent
            spacing: foilAngle < 0 ? (foilAngleValue.twoDigitAbs ? labelFontSize * 0.18 : labelFontSize * 0.12) : labelFontSize * 0.06

            Text {
                width: foilAngle < 0 ? (foilAngleValue.twoDigitAbs ? labelFontSize * 1.25 : labelFontSize * 1.05) : labelFontSize * 0.95
                horizontalAlignment: Text.AlignRight
                text: foilAngle < 0 ? "-" : " "
                color: "#ffffff"
                font.pixelSize: labelFontSize * 1.6
            }

            Text {
                width: labelFontSize * 1.55
                horizontalAlignment: Text.AlignRight
                text: foilAngleValue.integerPart
                color: "#ffffff"
                font.pixelSize: labelFontSize * 1.6
            }

            Text {
                text: "." + foilAngleValue.decimalPart
                color: "#ffffff"
                font.pixelSize: labelFontSize * 1.6
            }

            Text {
                text: "º"
                color: "#ffffff"
                font.pixelSize: labelFontSize * 1.6
            }
        }
    }
}

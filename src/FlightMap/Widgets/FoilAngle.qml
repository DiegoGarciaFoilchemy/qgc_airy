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
    width: 260
    height: width
    
    property real value: 0 // Current speedometer value (-40 to 40)
    property real minValue: -40
    property real maxValue: 40
    property real needleWidth: 4
    property real foilAngle: 0
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
                var angle = arcStart + ((value - minValue) / (maxValue - minValue)) * Math.abs(arcEnd - arcStart)
                
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
            var minorValues = [-20, 20]
            ctx.lineWidth = 1.5
            for (let i = 0; i < minorValues.length; i++) {
                var value = minorValues[i]
                var angle = arcStart + ((value - minValue) / (maxValue - minValue)) * Math.abs(arcEnd - arcStart)
                
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
            property real angle: arcStart + ((modelData - minValue) / (maxValue - minValue)) * Math.abs(arcEnd - arcStart)
            x: (gaugeCenterX + labelRadius * Math.cos(angle)) - width / 2
            y: (gaugeCenterY + labelRadius * Math.sin(angle)) - height / 2
        }
    }
    
    // Needle
    Image {
        id: foil
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
                angle: inverted ? foilAngle : -foilAngle
            },
            Scale { xScale: inverted ? -1 : 1; yScale: 1 }
        ]
    }
    
    // Redraw canvas when needed
    QGCLabel {
        y: gaugeCenterY - labelFontSize * 3.
        x: inverted ? 2.5 * gaugeRadius : - 1. * gaugeRadius
        text: foilName
        color: "#ffffff"
        font.pointSize: labelFontSize * 0.7
    }

    QGCLabel {
        y: gaugeCenterY - labelFontSize * 0.8
        width: gaugeRadius * 2.2
        property real statusCenterX: inverted ? gaugeCenterX + gaugeRadius * 1.7 : gaugeCenterX - gaugeRadius * 1.7
        x: statusCenterX - width / 2
        text: foilStatus
        color: "#ffffff"
        font.pointSize: labelFontSize * 0.7
        horizontalAlignment: Text.AlignHCenter
    }
    QGCLabel {
        y: gaugeCenterY + labelFontSize * 1.2
        x: inverted ? 2.6 * gaugeRadius : -1. * gaugeRadius
        text: -foilAngle.toFixed(1) + "º"
        color: "#ffffff"
        font.pointSize: labelFontSize * 1.
    }
}

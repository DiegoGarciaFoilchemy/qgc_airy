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
    width: 300
    height: width
    
    property real value: 0 // Current speedometer value (-40 to 40)
    property real minValue: -40
    property real maxValue: 40
    property real needleWidth: 4
    property real needleLength: 80
    property real foilAngle: 0
    property int labelFontSize: 20
    property real gaugeCenterX: width / 2 + 40
    property real gaugeCenterY: height / 2
    property real gaugeCenterYOffset: 4
    property real gaugeRadius: Math.min(width, height) / 2 - 10
    property real spanRadians: 80 * Math.PI / 180
    property real startAngle: Math.PI - spanRadians / 2
    property real endAngle: Math.PI + spanRadians / 2
    property real labelRadius: gaugeRadius + 12
    
    // Canvas for drawing the speedometer
    Canvas {
        id: canvas
        anchors.fill: parent
        
        onPaint: {
            var ctx = getContext("2d")
            var centerX = gaugeCenterX
            var centerY = gaugeCenterY + gaugeCenterYOffset
            var radius = gaugeRadius
            
            // Clear canvas
            ctx.clearRect(0, 0, width, height)
            
            // Draw inner arc (80°)
            ctx.strokeStyle = "#cccccc"
            ctx.lineWidth = 2
            ctx.beginPath()
            ctx.arc(centerX, centerY, radius - 5, startAngle, endAngle)
            ctx.stroke()
            
            // Draw scale markings
            ctx.strokeStyle = "#ffffff"
            
            var majorValues = [minValue, 0, maxValue]
            for (let i = 0; i < majorValues.length; i++) {
                var value = majorValues[i]
                var angle = startAngle + ((value - minValue) / (maxValue - minValue)) * spanRadians
                
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
                var angle = startAngle + ((value - minValue) / (maxValue - minValue)) * spanRadians
                
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
            property real angle: startAngle + ((modelData - minValue) / (maxValue - minValue)) * spanRadians
            x: (gaugeCenterX + labelRadius * Math.cos(angle)) - width / 2
            y: (gaugeCenterY + gaugeCenterYOffset + labelRadius * Math.sin(angle)) - height / 2
        }
    }
    
    // Needle
    Image {
        id: foil
        source:             "/qmlimages/foil.svg"
        mipmap:             true
        fillMode:           Image.PreserveAspectFit
        width: 120
        // Align rotation point with speedometer center
        x: gaugeCenterX - width
        y: gaugeCenterY - height / 2
        rotation: foilAngle
        transformOrigin: Item.Right
        
        // Behavior on rotation {
        //     SmoothedAnimation {
        //         duration: 300
        //         velocity: 360
        //     }
        // }
    }
    
    // Center circle
    // Circle {
    //     anchors.centerIn: parent
    //     width: 12
    //     height: width
    //     color: "#333333"
    // }
    
    // Redraw canvas when needed
    onWidthChanged: canvas.requestPaint()
    onHeightChanged: canvas.requestPaint()
}

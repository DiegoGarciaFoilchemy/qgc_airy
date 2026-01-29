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
    width: 250
    height: width
    
    property real value: 0 // Current speedometer value (-40 to 40)
    property real minValue: -40
    property real maxValue: 40
    property real needleWidth: 4
    property real needleLength: 80
    property real foilAngle: 0
    
    // Canvas for drawing the speedometer
    Canvas {
        id: canvas
        anchors.fill: parent
        
        onPaint: {
            var ctx = getContext("2d")
            var centerX = width / 2 + 40
            var centerY = height / 2
            var radius = Math.min(width, height) / 2 - 10
            var spanRadians = 80 * Math.PI / 180
            var startAngle = Math.PI - spanRadians / 2
            var endAngle = Math.PI + spanRadians / 2
            
            // Clear canvas
            ctx.clearRect(0, 0, width, height)
            
            // Draw outer arc (80°)
            ctx.strokeStyle = "#ffffff"
            ctx.lineWidth = 2
            ctx.beginPath()
            ctx.arc(centerX, centerY, radius, startAngle, endAngle)
            ctx.stroke()
            
            // Draw inner arc (80°)
            ctx.strokeStyle = "#cccccc"
            ctx.lineWidth = 1
            ctx.beginPath()
            ctx.arc(centerX, centerY, radius - 5, startAngle, endAngle)
            ctx.stroke()
            
            // Draw scale markings and numbers
            ctx.fillStyle = "#ffffff"
            ctx.strokeStyle = "#ffffff"
            ctx.font = "12px Arial"
            ctx.textAlign = "center"
            ctx.textBaseline = "middle"
            
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
                
                // Draw numbers (outside the arc)
                var numX = centerX + (radius + 12) * Math.cos(angle)
                var numY = centerY + (radius + 12) * Math.sin(angle)
                ctx.fillText(value.toString(), numX, numY)
            }
        }
    }
    
    // Needle
    Image {
        id: foil
        source:             "/qmlimages/foil.svg"
        mipmap:             true
        fillMode:           Image.PreserveAspectFit
        width:120
        x: parent.width / 2 - width / 2
        y: parent.height / 2 - height
        rotation: foilAngle
        // width: needleWidth
        // height: needleLength
        // radius: needleWidth / 2
        
        // transformOrigin: Item.Bottom
        // rotation: {
        //     // Convert value to angle: -40 = 0°, 0 = 90°, 40 = 180°
        //     var normalized = (value - minValue) / (maxValue - minValue)
        //     return normalized * 180
        // }
        
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

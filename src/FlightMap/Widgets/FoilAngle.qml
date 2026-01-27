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
    width: 200
    height: width
    
    property real value: 0 // Current speedometer value (-40 to 40)
    property real minValue: -40
    property real maxValue: 40
    property real needleWidth: 4
    property real needleLength: 80
    
    // Canvas for drawing the speedometer
    Canvas {
        id: canvas
        anchors.fill: parent
        
        onPaint: {
            var ctx = getContext("2d")
            var centerX = width / 2
            var centerY = height / 2
            var radius = Math.min(width, height) / 2 - 10
            
            // Clear canvas
            ctx.clearRect(0, 0, width, height)
            
            // Draw outer circle
            ctx.strokeStyle = "#333333"
            ctx.lineWidth = 2
            ctx.beginPath()
            ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI)
            ctx.stroke()
            
            // Draw inner circle
            ctx.strokeStyle = "#cccccc"
            ctx.lineWidth = 1
            ctx.beginPath()
            ctx.arc(centerX, centerY, radius - 5, 0, 2 * Math.PI)
            ctx.stroke()
            
            // Draw scale markings and numbers
            ctx.fillStyle = "#000000"
            ctx.strokeStyle = "#000000"
            ctx.font = "12px Arial"
            ctx.textAlign = "center"
            ctx.textBaseline = "middle"
            
            for (let i = minValue; i <= maxValue; i += 20) {
                var angle = ((i - minValue) / (maxValue - minValue)) * Math.PI - Math.PI / 2
                
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
                
                // Draw numbers
                var numX = centerX + (radius - 30) * Math.cos(angle)
                var numY = centerY + (radius - 30) * Math.sin(angle)
                ctx.fillText(i.toString(), numX, numY)
            }
            
            // Draw smaller tick marks between numbers
            ctx.lineWidth = 1
            for (let i = minValue + 10; i < maxValue; i += 20) {
                var angle = ((i - minValue) / (maxValue - minValue)) * Math.PI - Math.PI / 2
                var x1 = centerX + (radius - 10) * Math.cos(angle)
                var y1 = centerY + (radius - 10) * Math.sin(angle)
                var x2 = centerX + (radius - 5) * Math.cos(angle)
                var y2 = centerY + (radius - 5) * Math.sin(angle)
                
                ctx.beginPath()
                ctx.moveTo(x1, y1)
                ctx.lineTo(x2, y2)
                ctx.stroke()
            }
        }
    }
    
    // Needle
    Rectangle {
        id: needle
        x: parent.width / 2 - needleWidth / 2
        y: parent.height / 2 - needleLength
        width: needleWidth
        height: needleLength
        color: "#ff0000"
        radius: needleWidth / 2
        
        transformOrigin: Item.Bottom
        rotation: {
            // Convert value to angle: -40 = 0°, 0 = 90°, 40 = 180°
            var normalized = (value - minValue) / (maxValue - minValue)
            return normalized * 180
        }
        
        Behavior on rotation {
            SmoothedAnimation {
                duration: 300
                velocity: 360
            }
        }
    }
    
    // Center circle
    Circle {
        anchors.centerIn: parent
        width: 12
        height: width
        color: "#333333"
    }
    
    // Redraw canvas when needed
    onWidthChanged: canvas.requestPaint()
    onHeightChanged: canvas.requestPaint()
}

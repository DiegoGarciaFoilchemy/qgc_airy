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
    width: 110
    height: width * 0.6

    property real portDeployment: 0
    property real starboardDeployment: 0
    property real labelPointSize: 10

    readonly property real _lineThickness: 4
    readonly property real _sideMargin: 16
    readonly property real _topMargin: 6
    readonly property real _gap: 16
    readonly property real _maxDeploymentHeight: height - _lineThickness - _topMargin
    readonly property real _rectWidth: Math.max(0, (width - (_sideMargin * 2) - _gap) * 0.5)
    readonly property real _portHeight: Math.min(1, Math.abs(portDeployment) / 100) * _maxDeploymentHeight
    readonly property real _starboardHeight: Math.min(1, Math.abs(starboardDeployment) / 100) * _maxDeploymentHeight

    Rectangle {
        id: centerLine
        color: "white"
        height: _lineThickness
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
    }

    Rectangle {
        width: _rectWidth
        height: _maxDeploymentHeight
        x: _sideMargin
        y: centerLine.y + _lineThickness + _topMargin
        color: "transparent"
        border.color: "white"
        border.width: 1
        opacity: 0.25
    }

    Rectangle {
        width: _rectWidth
        height: _maxDeploymentHeight
        x: _sideMargin + _rectWidth + _gap
        y: centerLine.y + _lineThickness + _topMargin
        color: "transparent"
        border.color: "white"
        border.width: 1
        opacity: 0.25
    }

    Text {
        text: Math.round(portDeployment) + "%"
        color: "white"
        font.pointSize: labelPointSize * 1.7
        anchors.right: centerLine.left
        anchors.rightMargin: _sideMargin
        anchors.verticalCenter: centerLine.verticalCenter
        visible: portDeployment !== 0
    }

    Text {
        text: Math.round(starboardDeployment) + "%"
        color: "white"
        font.pointSize: labelPointSize * 1.7
        anchors.left: centerLine.right
        anchors.leftMargin: _sideMargin
        anchors.verticalCenter: centerLine.verticalCenter
        visible: starboardDeployment !== 0
    }

    Rectangle {
        width: _rectWidth
        height: _portHeight
        x: _sideMargin
        y: portDeployment >= 0
            ? centerLine.y + _lineThickness + _topMargin
            : centerLine.y - _topMargin - height
        color: "white"
        visible: portDeployment !== 0
    }

    Rectangle {
        width: _rectWidth
        height: _starboardHeight
        x: _sideMargin + _rectWidth + _gap
        y: starboardDeployment >= 0
            ? centerLine.y + _lineThickness + _topMargin
            : centerLine.y - _topMargin - height
        color: "white"
        visible: starboardDeployment !== 0
    }
    
    
}

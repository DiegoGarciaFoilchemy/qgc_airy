import QtQuick
import QtQuick.Layouts

import QGroundControl
import QGroundControl.Controls
import QGroundControl.Palette
import QGroundControl.ScreenTools

Item {
    id: root
    width: parent ? parent.width : 1280
    height: parent ? parent.height : 760
    property var  vehicle:      globals.activeVehicle


    QGCPalette { id: qgcPal; colorGroupEnabled: true }

    

    Rectangle {
        anchors.fill: parent
        color: "black"
    }

    Rectangle {
        id: topLeftButton
        width: 140
        height: 60
        opacity: vehicle ? 1.0 : 0.45
        radius: 4
        color: "#2f2f2f"
        border.color: "#ffffff"
        border.width: 1
        anchors {
            left: parent.left
            top: parent.top
            leftMargin: 16
            topMargin: 20
        }

        Text {
            anchors.centerIn: parent
            text: "Reboot FCU"
            color: "white"
            font.pixelSize: 16
        }

        MouseArea {
            anchors.fill: parent
            enabled: !!vehicle
            onClicked: vehicle.rebootVehicle()
        }
    }

    Rectangle {
        id: rebootHmiButton
        width: 140
        height: 60
        radius: 4
        color: "#2f2f2f"
        border.color: "#ffffff"
        border.width: 1
        anchors {
            left: parent.left
            top: topLeftButton.bottom
            leftMargin: 16
            topMargin: 30
        }

        Text {
            anchors.centerIn: parent
            text: "Reboot HMI"
            color: "white"
            font.pixelSize: 16
        }

        MouseArea {
            anchors.fill: parent
            onClicked: Qt.quit()
        }
    }

}

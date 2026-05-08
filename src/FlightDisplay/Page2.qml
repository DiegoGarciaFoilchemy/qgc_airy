import QtQuick
import QtQuick.Controls
import QGroundControl.Palette

Item {
    id: root
    width: parent ? parent.width : 1280
    height: parent ? parent.height : 760
    QGCPalette { id: qgcPal; colorGroupEnabled: true }
    property var  vehicle:      globals.activeVehicle
    property var bowHeight: vehicle ? vehicle.bowHeight.rawValue : 0.0
    property int overlayHeight: 165
    property int _labelPixelSize: 16
    property real _heaveSp: vehicle ? vehicle.heaveSp.rawValue : 4.0
    property real _pitchAngle:  vehicle ? vehicle.pitch.rawValue : 0
    property real _rollAngle:   vehicle ? vehicle.roll.rawValue : 0
    property real _speedOverGround: vehicle ? vehicle.groundSpeed.rawValue : 0.0
    // overlay height of 0 means main deck 6 meters above water line
    // overlay height of 435 means main deck at water line
    Rectangle {
        anchors.fill: parent
        color: "black"

        
        Image {
            id: bowImage
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 80
            anchors.leftMargin: 30
            anchors.rightMargin: 50
            anchors.right: parent.right
            source: "/qmlimages/VesselBow.svg"
            fillMode: Image.PreserveAspectFit
            transform: Rotation {
                origin.x: bowImage.width
                origin.y: 0
                angle: -_pitchAngle
            }
        }

        Rectangle {
            id: waterRect
            anchors.left: parent.left
            anchors.right: bowImage.right
            anchors.bottom: bowImage.bottom
            anchors.rightMargin: -30
            anchors.bottomMargin: -50
            height: overlayHeight - bowHeight / 6. * overlayHeight + 70
            color: "#0f5e9c"
            opacity: 0.4
        }

        Rectangle {
            id: waterTopLine
            anchors.left: waterRect.left
            anchors.right: waterRect.right
            anchors.top: waterRect.top
            height: 3
            color: "#3d93c8"
            opacity: 0.9
        }

        Rectangle {
            id: heaveSpLine
            anchors.left: parent.left
            anchors.right: bowImage.right
            anchors.rightMargin: -30
            y: bowImage.y + bowImage.height - overlayHeight + _heaveSp / 6 * overlayHeight - 20
            height: 3
            color: "#00cc44"
            opacity: 0.85
            visible: _speedOverGround > 15
        }

        Column {
            id: vesselAttitude
            anchors.bottom: bowImage.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 12
            spacing: 4
            z: 20

            Label {
                color: qgcPal.text
                font.pixelSize: _labelPixelSize + 8
                font.bold: true
                text: "TRIM: " + _pitchAngle.toFixed(2) + "°"
            }

            Label {
                color: qgcPal.text
                font.pixelSize: _labelPixelSize + 8
                font.bold: true
                text: "HEEL: " + _rollAngle.toFixed(2) + "°"
            }

            Label {
                color: qgcPal.text
                font.pixelSize: _labelPixelSize + 8
                font.bold: true
                text: "SOG: " + _speedOverGround.toFixed(1) + " kn"
            }
        }

        Column {
            id: freeboardInfo
            anchors.bottom: bowImage.top
            anchors.right: bowImage.right
            anchors.bottomMargin: 12
            anchors.rightMargin: 24
            spacing: 4
            z: 20

            Label {
                color: qgcPal.text
                font.pixelSize: _labelPixelSize + 8
                font.bold: true
                text: "BOW FREEBOARD: " + bowHeight.toFixed(1)
            }

            Label {
                id: bowDraughtText
                color: qgcPal.text
                font.pixelSize: _labelPixelSize + 8
                font.bold: true
                text: "BOW DRAUGHT: " + ((6 - bowHeight) + Math.sin(_pitchAngle * Math.PI / 180.0) * 3).toFixed(2)
            }
        }

        Label {
            id: aftDraughtText
            anchors.left: parent.left
            anchors.leftMargin: 24
            y: freeboardInfo.y + bowDraughtText.y + (bowDraughtText.height - height) / 2
            color: qgcPal.text
            font.pixelSize: _labelPixelSize + 8
            font.bold: true
            text: "ESTIMATED AFT DRAUGHT: " + ((6 - bowHeight) + Math.sin(_pitchAngle * Math.PI / 180.0) * 33).toFixed(2)
            z: 20
        }
        
    }
}

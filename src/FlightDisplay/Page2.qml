import QtQuick
import QtQuick.Controls
import QGroundControl.Palette

Item {
    id: root
    width: parent ? parent.width : 1280
    height: parent ? parent.height : 760
    QGCPalette { id: qgcPal; colorGroupEnabled: true }
    property var  vehicle:      globals.activeVehicle
    property var bowHeight: vehicle ? vehicle.bowHeight.rawValue : 3000
    property int overlayHeight: 435 - 50
    property int _labelPixelSize: 16

    // overlay height of 0 means main deck 6 meters above water line
    // overlay height of 435 means main deck at water line
    Rectangle {
        anchors.fill: parent
        color: qgcPal.windowShade

        
        Image {
            id: bowImage
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            source: "/qmlimages/VesselBow.svg"
            fillMode: Image.PreserveAspectFit
        }

        Rectangle {
            id: waterRect
            anchors.left: bowImage.left
            anchors.right: bowImage.right
            anchors.bottom: bowImage.bottom
            anchors.rightMargin: -30
            anchors.bottomMargin: -50
            height: overlayHeight - bowHeight / 6. * overlayHeight + 50
            color: "#0f5e9c"
            opacity: 0.4
        }

        Item {
            id: heightArrow
            anchors.horizontalCenter: waterRect.right
            anchors.top: bowImage.top
            anchors.bottom: waterRect.top
            width: 60

            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 2
                color: qgcPal.text
            }

            Rectangle {
                anchors.right: parent.horizontalCenter
                anchors.rightMargin: -9
                anchors.top: parent.top
                anchors.topMargin: 0
                width: 40
                height: 4
                color: qgcPal.text
            }

            Rectangle {
                anchors.right: parent.horizontalCenter
                anchors.rightMargin: -9
                anchors.bottom: parent.bottom
                anchors.bottomMargin: -height / 2
                width: 40
                height: 4
                color: qgcPal.text
            }

            Canvas {
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                width: 12
                height: 12
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0, 0, width, height)
                    ctx.fillStyle = qgcPal.text
                    ctx.beginPath()
                    ctx.moveTo(width / 2, 0)
                    ctx.lineTo(0, height)
                    ctx.lineTo(width, height)
                    ctx.closePath()
                    ctx.fill()
                }
            }

            Canvas {
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                width: 12
                height: 12
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0, 0, width, height)
                    ctx.fillStyle = qgcPal.text
                    ctx.beginPath()
                    ctx.moveTo(0, 0)
                    ctx.lineTo(width, 0)
                    ctx.lineTo(width / 2, height)
                    ctx.closePath()
                    ctx.fill()
                }
            }

            Column {
                anchors.left: parent.horizontalCenter
                anchors.leftMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                spacing: 2
                width: Math.max(freeboardText.implicitWidth, bowHeightText.implicitWidth)

                Label {
                    id: freeboardText
                    color: qgcPal.text
                    font.pixelSize: _labelPixelSize
                    text: "Freeboard"
                }

                Label {
                    id: bowHeightText
                    color: qgcPal.text
                    font.pixelSize: _labelPixelSize
                    text: bowHeight.toFixed(1) + " m"
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
        
    }
}

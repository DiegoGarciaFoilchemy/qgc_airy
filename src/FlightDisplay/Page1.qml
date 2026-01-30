import QtQuick
import QGroundControl.Palette
Item {
    id: root
    width: parent ? parent.width : 1280
    height: parent ? parent.height : 760
    QGCPalette { id: qgcPal; colorGroupEnabled: true }
    property var  vehicle:      globals.activeVehicle
    
    Rectangle {
        anchors.fill: parent
        color: qgcPal.windowShade

        Image {
            anchors.centerIn: parent
            source: "/qmlimages/vesselOutline.svg"
            fillMode: Image.PreserveAspectFit
        }

        Column {
            anchors.centerIn: parent
            spacing: 20

            Loader {
                id: instrumentLoader
                source: "qrc:/qml/QGroundControl/FlightMap/Widgets/VesselAttitude.qml"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 10
            }
        }
        Column {
            anchors.right: parent.right
            spacing: 10
            Loader {
                id: foil1
                source: "qrc:/qml/QGroundControl/FlightMap/Widgets/FoilAngle.qml"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 10
                onLoaded: {
                    item.foilAngle = Qt.binding(function() { return vehicle ? vehicle.pitch.rawValue : 0 })
                }
            }
        }
    }
}

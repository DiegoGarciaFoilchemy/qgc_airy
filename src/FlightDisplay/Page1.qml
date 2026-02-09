import QtQuick
import QGroundControl.Palette
Item {
    id: root
    width: parent ? parent.width : 1280
    height: parent ? parent.height : 760
    QGCPalette { id: qgcPal; colorGroupEnabled: true }
    property var  vehicle:      globals.activeVehicle
    property var acuModeLabels: ["RUNNING", "RUNNING", "CALIBRATING", "IDLE", "IDLE", "OFF", "ERROR"]

    function updateFoilStatus(loader, modeValue) {
        if (!loader.item) {
            return
        }
        if (modeValue >= 0 && modeValue < acuModeLabels.length) {
            loader.item.foilStatus = acuModeLabels[modeValue]
        } else {
            loader.item.foilStatus = "--"
        }
    }

    Timer {
        id: acu1ModeTimer
        interval: 300
        repeat: true
        running: true
        onTriggered: {
            var acu1ModeValue = vehicle ? vehicle.acu1Mode.rawValue : 0
            var acu2ModeValue = vehicle ? vehicle.acu2Mode.rawValue : 0
            var acu3ModeValue = vehicle ? vehicle.acu3Mode.rawValue : 0
            var acu4ModeValue = vehicle ? vehicle.acu4Mode.rawValue : 0

            updateFoilStatus(foil1, acu2ModeValue)
            updateFoilStatus(foil2, acu1ModeValue)
            updateFoilStatus(foil3, acu4ModeValue)
            updateFoilStatus(foil4, acu3ModeValue)
        }
    }
    
    Rectangle {
        anchors.fill: parent
        color: qgcPal.windowShade

        Image {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -60
            source: "/qmlimages/vesselOutline.svg"
            fillMode: Image.PreserveAspectFit
            rotation: -90
            scale: 0.6
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

            Loader {
                id: speedLoader
                source: "qrc:/qml/QGroundControl/FlightMap/Widgets/VesselSpeed.qml"
                anchors.horizontalCenter: parent.horizontalCenter
                onLoaded: {
                    item.speed = Qt.binding(function() { return vehicle ? vehicle.pitch.rawValue : 0 })
                }
            }
        }
        Column {
            anchors.left: parent.left
            anchors.leftMargin: 200
            anchors.top: parent.top
            spacing: 130
            Loader {
                id: foil1
                source: "qrc:/qml/QGroundControl/FlightMap/Widgets/FoilAngle.qml"
                anchors.horizontalCenter: parent.horizontalCenter
                onLoaded: {
                    item.foilAngle = Qt.binding(function() { return vehicle ? vehicle.acu2Angle.rawValue : 0 })
                    item.foilName = "BOW PS"
                }
            }

             Loader {
                id: foil2
                source: "qrc:/qml/QGroundControl/FlightMap/Widgets/FoilAngle.qml"
                anchors.horizontalCenter: parent.horizontalCenter
                onLoaded: {
                    item.foilAngle = Qt.binding(function() { return vehicle ? vehicle.acu1Angle.rawValue : 0 })
                    item.foilName = "MAIN PS"
                }
            }
        }
        Column {
            anchors.right: parent.right
            anchors.rightMargin: 200
            anchors.top: parent.top
            spacing: 130
            Loader {
                id: foil3
                source: "qrc:/qml/QGroundControl/FlightMap/Widgets/FoilAngle.qml"
                anchors.horizontalCenter: parent.horizontalCenter
                onLoaded: {
                    item.foilAngle = Qt.binding(function() { return vehicle ? vehicle.acu4Angle.rawValue : 0 })
                    item.foilName = "BOW SB"
                    item.inverted = true
                }
            }
             Loader {
                id: foil4
                source: "qrc:/qml/QGroundControl/FlightMap/Widgets/FoilAngle.qml"
                anchors.horizontalCenter: parent.horizontalCenter
                onLoaded: {
                    item.foilAngle = Qt.binding(function() { return vehicle ? vehicle.acu3Angle.rawValue : 0 })
                    item.foilName = "MAIN SB"
                    item.inverted = true
                }
            }
        }
        Loader {
            id: interceptorDeploy
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 70
            source: "qrc:/qml/QGroundControl/FlightMap/Widgets/InterceptorDeploy.qml"
            onLoaded: {
                item.starboardDeployment = Qt.binding(function() { return vehicle ? -vehicle.acu5Angle.rawValue : 0 })
                item.portDeployment = Qt.binding(function() { return vehicle ? vehicle.acu6Angle.rawValue : 0 })
            }
        }
    }
}

import QtQuick
import QtQuick.Layouts
import QGroundControl.Palette
Item {
    id: root
    width: parent ? parent.width : 1280
    height: parent ? parent.height : 760
    QGCPalette { id: qgcPal; colorGroupEnabled: true }
    property var  vehicle:      globals.activeVehicle
    property var acuModeLabels: ["RUNNING", "RUNNING", "CALIBRATING", "IDLE", "ZERO", "OFF", "ERROR"]

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
        color: "black"

        Image {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -60
            source: "/qmlimages/vesselOutline.svg"
            fillMode: Image.PreserveAspectFit
            rotation: -90
            scale: 0.6
        }

        // ColumnLayout {
        //     anchors.top: parent.top
        //     anchors.horizontalCenter: parent.horizontalCenter
        //     anchors.topMargin: 150
        //     spacing: 20

            RowLayout {
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 270
                spacing: 150
                Layout.alignment: Qt.AlignHCenter
                Loader {
                    id: pitchLoader
                    source: "qrc:/qml/QGroundControl/FlightMap/Widgets/VesselPitch.qml"
                }
                 Loader {
                    id: speedLoader
                    source: "qrc:/qml/QGroundControl/FlightMap/Widgets/VesselSpeed.qml"
                    Layout.alignment: Qt.AlignHCenter
                    onLoaded: {
                        item.speed = Qt.binding(function() { return vehicle ? vehicle.groundSpeed.rawValue : 0 })
                    }
                }
                Loader {
                    id: rollLoader
                    source: "qrc:/qml/QGroundControl/FlightMap/Widgets/VesselRoll.qml"
                }
            }
            

        //    
        // }
        Column {
            anchors.left: parent.left
            anchors.leftMargin: 150
            anchors.top: parent.top
            spacing: 230
            Loader {
                id: foil1
                source: "qrc:/qml/QGroundControl/FlightMap/Widgets/FoilAngle.qml"
                anchors.horizontalCenter: parent.horizontalCenter
                onLoaded: {
                    item.foilAngle = Qt.binding(function() { return vehicle ? vehicle.commandBowPs.rawValue : 0 })
                    item.highSpeed = Qt.binding(function() { return vehicle ? vehicle.groundSpeed.rawValue > 20 : false })
                    item.showFoil = Qt.binding(function() { return vehicle ? vehicle.armed : false })
                    item.foilName = "BOW PS"
                }
            }

             Loader {
                id: foil2
                source: "qrc:/qml/QGroundControl/FlightMap/Widgets/FoilAngle.qml"
                anchors.horizontalCenter: parent.horizontalCenter
                onLoaded: {
                    item.foilAngle = Qt.binding(function() { return vehicle ? vehicle.commandMainPs.rawValue : 0 })
                    item.highSpeed = Qt.binding(function() { return vehicle ? vehicle.groundSpeed.rawValue > 20 : false })
                    item.showFoil = Qt.binding(function() { return vehicle ? vehicle.armed : false })
                    item.foilName = "AFT PS"
                }
            }
        }
        Column {
            anchors.right: parent.right
            anchors.rightMargin: 150
            anchors.top: parent.top
            spacing: 230
            Loader {
                id: foil3
                source: "qrc:/qml/QGroundControl/FlightMap/Widgets/FoilAngle.qml"
                anchors.horizontalCenter: parent.horizontalCenter
                onLoaded: {
                    item.foilAngle = Qt.binding(function() { return vehicle ? vehicle.commandBowSb.rawValue : 0 })
                    item.highSpeed = Qt.binding(function() { return vehicle ? vehicle.groundSpeed.rawValue > 20 : false })
                    item.showFoil = Qt.binding(function() { return vehicle ? vehicle.armed : false })
                    item.foilName = "BOW SB"
                    item.inverted = true
                }
            }
             Loader {
                id: foil4
                source: "qrc:/qml/QGroundControl/FlightMap/Widgets/FoilAngle.qml"
                anchors.horizontalCenter: parent.horizontalCenter
                onLoaded: {
                    item.foilAngle = Qt.binding(function() { return vehicle ? vehicle.commandMainSb.rawValue : 0 })
                    item.highSpeed = Qt.binding(function() { return vehicle ? vehicle.groundSpeed.rawValue > 20 : false })
                    item.showFoil = Qt.binding(function() { return vehicle ? vehicle.armed : false })
                    item.foilName = "AFT SB"
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
                item.starboardDeployment = Qt.binding(function() { return vehicle ? vehicle.commandInterSb.rawValue * 2 : 0 })
                item.portDeployment = Qt.binding(function() { return vehicle ? vehicle.commandInterPs.rawValue * 2 : 0 })
                item.showInterceptor = Qt.binding(function() { return vehicle ? vehicle.armed : false })
            }
        }
    }
}

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
    property var acu1Mode: vehicle ? vehicle.acu1Mode.rawValue : 0
    property var acu2Mode: vehicle ? vehicle.acu2Mode.rawValue : 0
    // Fixed-pixel layout tokens for this page.
    property real _vesselImageCenterOffsetYPx:   -60
    property real _topRowTopMarginPx:            270
    property real _topRowSpacingPx:              120
    property real _foilColumnSideMarginPx:       150
    property real _foilColumnSpacingPx:          230
    property real _interceptorBottomMarginPx:    70

    property real _pitchWidthPx:                 300
    property real _pitchHeightPx:                200
    property real _speedSizePx:                  220
    property real _rollWidthPx:                  300
    property real _rollHeightPx:                 200
    property real _foilSizePx:                   260
    property real _interceptorWidthPx:           110

    function updateFoilStatus(loader, modeValue) {
        if (!loader.item) {
            return
        }
        if (modeValue >= 0 && modeValue < acuModeLabels.length) {
            loader.item.foilStatus = acuModeLabels[modeValue]
            if (modeValue === 5) {
                loader.item.isVisible = false
            } else {
                loader.item.isVisible = true
            }
        } else {
            loader.item.foilStatus = "--"
            loader.item.isVisible = false
        }
    }

    Timer {
        id: acu1ModeTimer
        interval: 300
        repeat: true
        running: true
        onTriggered: {
            var acu3ModeValue = vehicle ? vehicle.acu3Mode.rawValue : 0
            var acu4ModeValue = vehicle ? vehicle.acu4Mode.rawValue : 0
            var acu5ModeValue = vehicle ? vehicle.acu5Mode.rawValue : 0
            var acu6ModeValue = vehicle ? vehicle.acu6Mode.rawValue : 0

            updateFoilStatus(foil1, acu6ModeValue)
            updateFoilStatus(foil2, acu4ModeValue)
            updateFoilStatus(foil3, acu5ModeValue)
            updateFoilStatus(foil4, acu3ModeValue)
        }
    }
    
    Rectangle {
        anchors.fill: parent
        color: "black"

        Image {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: _vesselImageCenterOffsetYPx
            source: "/qmlimages/vesselOutline.svg"
            fillMode: Image.PreserveAspectFit
            rotation: -90
            scale: 0.6
        }

        Image {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 146
            anchors.horizontalCenterOffset: 10
            source: "/res/WindLogoDark.svg"
            fillMode: Image.PreserveAspectFit
            rotation: -90
            scale: 0.57
            opacity: 0.6
        }

        // ColumnLayout {
        //     anchors.top: parent.top
        //     anchors.horizontalCenter: parent.horizontalCenter
        //     anchors.topMargin: 150
        //     spacing: 20

            RowLayout {
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: _topRowTopMarginPx
                spacing: _topRowSpacingPx
                Layout.alignment: Qt.AlignHCenter
                Loader {
                    id: pitchLoader
                    source: "qrc:/qml/QGroundControl/FlightMap/Widgets/VesselPitch.qml"
                    width: _pitchWidthPx
                    height: _pitchHeightPx
                    onLoaded: {
                        item.useFixedPixels = true
                    }
                }
                 Loader {
                    id: speedLoader
                    source: "qrc:/qml/QGroundControl/FlightMap/Widgets/VesselSpeed.qml"
                    width: _speedSizePx
                    height: _speedSizePx
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: -80
                    onLoaded: {
                        item.speed = Qt.binding(function() { return vehicle ? vehicle.groundSpeed.rawValue : 0 })
                    }
                }
                Loader {
                    id: rollLoader
                    source: "qrc:/qml/QGroundControl/FlightMap/Widgets/VesselRoll.qml"
                    width: _rollWidthPx
                    height: _rollHeightPx
                    onLoaded: {
                        item.useFixedPixels = true
                    }
                }
            }
            

        //    
        // }
        Column {
            anchors.left: parent.left
            anchors.leftMargin: _foilColumnSideMarginPx
            anchors.top: parent.top
            spacing: _foilColumnSpacingPx
            Loader {
                id: foil1
                source: "qrc:/qml/QGroundControl/FlightMap/Widgets/FoilAngle.qml"
                width: _foilSizePx
                height: _foilSizePx
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
                     width: _foilSizePx
                     height: _foilSizePx
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
            anchors.rightMargin: _foilColumnSideMarginPx
            anchors.top: parent.top
            spacing: _foilColumnSpacingPx
            Loader {
                id: foil3
                source: "qrc:/qml/QGroundControl/FlightMap/Widgets/FoilAngle.qml"
                width: _foilSizePx
                height: _foilSizePx
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
                     width: _foilSizePx
                     height: _foilSizePx
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
            anchors.bottomMargin: _interceptorBottomMarginPx
            source: "qrc:/qml/QGroundControl/FlightMap/Widgets/InterceptorDeploy.qml"
            width: _interceptorWidthPx
            height: _interceptorWidthPx * 0.6
            onLoaded: {
                item.starboardDeployment = Qt.binding(function() { return vehicle ? vehicle.commandInterSb.rawValue * 2 : 0 })
                item.portDeployment = Qt.binding(function() { return vehicle ? vehicle.commandInterPs.rawValue * 2 : 0 })
                item.showInterceptor = Qt.binding(function() { return vehicle ? vehicle.armed : false })
                item.stbdVisible = Qt.binding(function() { return acu1Mode !== 5 })
                item.portVisible = Qt.binding(function() { return acu2Mode !== 5 })
            }
        }
    }
}

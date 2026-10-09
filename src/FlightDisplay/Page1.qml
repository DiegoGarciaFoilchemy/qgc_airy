import QtQuick
import QtQuick.Layouts
import QGroundControl.Palette
Item {
    id: root
    width: parent ? parent.width : 1280
    height: parent ? parent.height : 760
    QGCPalette { id: qgcPal; colorGroupEnabled: true }
    property var  vehicle:      globals.activeVehicle
    // Sparse map of ServoState values to display labels. Values 1 and
    // 15..255 (including OFFLINE = 255) are intentionally omitted and
    // fall back to "OFFLINE" in updateFoilStatus().
    property var acuModeLabels: ({
        "0": "UNKNOWN",
        "2": "SWITCHED ON",
        "3": "OPERATION ENABLED",
        "4": "READY",
        "5": "ENABLED PPM",
        "6": "HOMING",
        "7": "SET HOMING",
        "8": "SET PPM",
        "9": "NO VOLTAGE",
        "10": "FAULT",
        "11": "NOT READY",
        "12": "SET IPM",
        "13": "WORKING",
        "14": "SET VELOCITY"
    })
    property var acu1Mode: vehicle ? vehicle.acu1Mode.rawValue : 0
    property var acu2Mode: vehicle ? vehicle.acu2Mode.rawValue : 0
    // Fixed-pixel layout tokens for this page.
    property real _vesselImageCenterOffsetYPx:   -60
    property real _topRowTopMarginPx:            270
    property real _topRowSpacingPx:              120
    property real _foilColumnSideMarginPx:       150
    property real _foilColumnSpacingPx:          230
    property real _rudderBottomMarginPx:    70

    property real _pitchWidthPx:                 300
    property real _pitchHeightPx:                200
    property real _speedSizePx:                  220
    property real _rollWidthPx:                  300
    property real _rollHeightPx:                 200
    property real _foilSizePx:                   260
    property real _rudderWidthPx:                260

    function updateFoilStatus(loader, modeValue) {
        if (!loader.item) {
            return
        }
        var status = acuModeLabels[modeValue]
        if (status === undefined) {
            status = "OFFLINE"
        }
        loader.item.foilStatus = status
        loader.item.isVisible = status !== "OFFLINE" && status !== "UNKNOWN"
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
            var acu5ModeValue = vehicle ? vehicle.acu5Mode.rawValue : 0
            var acu6ModeValue = vehicle ? vehicle.acu6Mode.rawValue : 0

            updateFoilStatus(foil1, acu2ModeValue)
            updateFoilStatus(foil2, acu4ModeValue)
            updateFoilStatus(foil3, acu1ModeValue)
            updateFoilStatus(foil4, acu3ModeValue)
            updateFoilStatus(interceptorDeploy, acu5ModeValue)
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
                    item.foilAngle = Qt.binding(function() { return vehicle ? vehicle.acu2Angle.rawValue : 0 })
                    item.highSpeed = true
                    item.showFoil = true 
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
                    item.foilAngle = Qt.binding(function() { return vehicle ? vehicle.acu4Angle.rawValue : 0 })
                    item.highSpeed = true
                    item.showFoil = true
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
                    item.foilAngle = Qt.binding(function() { return vehicle ? vehicle.acu1Angle.rawValue : 0 })
                    item.highSpeed = true
                    item.showFoil = true
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
                    item.foilAngle = Qt.binding(function() { return vehicle ? vehicle.acu3Angle.rawValue : 0 })
                    item.highSpeed = true
                    item.showFoil = true
                    item.foilName = "AFT SB"
                    item.inverted = true
                }
            }
        }
        Loader {
            id: interceptorDeploy
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: _rudderBottomMarginPx
            source: "qrc:/qml/QGroundControl/FlightMap/Widgets/RudderDeploy.qml"
            width: _rudderWidthPx
            height: _rudderWidthPx * 0.3
            onLoaded: {
                item.rudderDeployment = Qt.binding(function() { return vehicle ? vehicle.acu5Angle.rawValue : 0 })
            }
        }
    }
}

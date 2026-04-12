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

    property real _outerMargin: ScreenTools.defaultFontPixelWidth * 4.
    property real _cardWidth: ScreenTools.defaultFontPixelWidth * 21
    property real _cardMinHeight: ScreenTools.defaultFontPixelWidth * 10
    property real _rowSpacing: ScreenTools.defaultFontPixelHeight * 0.5

    property real boatPitch: vehicle ? vehicle.pitch.rawValue : 0
    property real boatRoll: vehicle ? vehicle.roll.rawValue : 0
    property real boatBowHeight: vehicle ? vehicle.bowHeight.rawValue : 0

    property var categories: []

    function _buildCategories() {
                return [
                        { title: "BOW SB FOIL",
                            entries: [
                                {label: "Position", value: vehicle ? vehicle.acu1Angle.rawValue.toFixed(1) : "-" + " deg"},
                                {label: "Speed", value: vehicle ? vehicle.acu1Speed.rawValue.toFixed(1) : "-" + " deg/sec"},
                                {label: "Target", value: vehicle ? vehicle.acu1Target.rawValue.toFixed(1) : "-" + " deg"},
                                {label: "Valve cmd", value: vehicle ? vehicle.acu1ValveCmd.rawValue.toFixed(0) : "-" + "%"},
                                {label: "Valve feedback", value: vehicle ? vehicle.acu1ValveFeedback.rawValue: "-" + "%"},
                                {label: "Status", value: vehicle ? vehicle.acu1Status.rawValue : ""},
                                {label: "Mode", value: vehicle ? vehicle.acu1Mode.rawValue : ""}
                            ] },
                        { title: "BOW PS FOIL",
                            entries: [
                                {label: "Position", value: vehicle ? vehicle.acu2Angle.rawValue.toFixed(1) : "-" + " deg"},
                                {label: "Speed", value: vehicle ? vehicle.acu2Speed.rawValue.toFixed(1) : "-" + " deg/sec"},
                                {label: "Target", value: vehicle ? vehicle.acu2Target.rawValue.toFixed(1) : "-" + " deg"},
                                {label: "Valve cmd", value: vehicle ? vehicle.acu2ValveCmd.rawValue.toFixed(0) : "-" + "%"},
                                {label: "Valve feedback", value: vehicle ? vehicle.acu2ValveFeedback.rawValue.toFixed(0) : "-" + "%"},
                                {label: "Status", value: vehicle ? vehicle.acu2Status.rawValue : ""},
                                {label: "Mode", value: vehicle ? vehicle.acu2Mode.rawValue : ""}
                            ] },
                        { title: "MAIN SB FOIL",
                            entries: [
                                {label: "Position", value: vehicle ? vehicle.acu3Angle.rawValue.toFixed(1) : "-" + " deg"},
                                {label: "Speed", value: vehicle ? vehicle.acu3Speed.rawValue.toFixed(1) : "-" + " deg/sec"},
                                {label: "Target", value: vehicle ? vehicle.acu3Target.rawValue.toFixed(1) : "-" + " deg"},
                                {label: "Valve cmd", value: vehicle ? vehicle.acu3ValveCmd.rawValue.toFixed(0) : "-" + "%"},
                                {label: "Valve feedback", value: vehicle ? vehicle.acu3ValveFeedback.rawValue.toFixed(0) : "-" + "%"},
                                {label: "Status", value: vehicle ? vehicle.acu3Status.rawValue : ""},
                                {label: "Mode", value: vehicle ? vehicle.acu3Mode.rawValue : ""}
                            ] },
                        { title: "MAIN PS FOIL",
                            entries: [
                                {label: "Position", value: vehicle ? vehicle.acu4Angle.rawValue.toFixed(1) : "-" + " deg"},
                                {label: "Speed", value: vehicle ? vehicle.acu4Speed.rawValue.toFixed(1) : "-" + " deg/sec"},
                                {label: "Target", value: vehicle ? vehicle.acu4Target.rawValue.toFixed(1) : "-" + " deg"},
                                {label: "Valve cmd", value: vehicle ? vehicle.acu4ValveCmd.rawValue.toFixed(0) : "-" + "%"},
                                {label: "Valve feedback", value: vehicle ? vehicle.acu4ValveFeedback.rawValue.toFixed(0) : "-" + "%"},
                                {label: "Status", value: vehicle ? vehicle.acu4Status.rawValue : ""},
                                {label: "Mode", value: vehicle ? vehicle.acu4Mode.rawValue: ""}
                            ] },
                        { title: "INTERCEPTOR SB",
                            entries: [
                                {label: "Position", value: vehicle ? vehicle.acu5Angle.rawValue.toFixed(1) : "-" + " deg"},
                                {label: "Speed", value: vehicle ? vehicle.acu5Speed.rawValue.toFixed(1) : "-" + " deg/sec"},
                                {label: "Target", value: vehicle ? vehicle.acu5Target.rawValue.toFixed(1) : "-" + " deg"},
                                {label: "Valve cmd", value: vehicle ? vehicle.acu5ValveCmd.rawValue.toFixed(0) : "-" + "%"},
                                {label: "Valve feedback", value: vehicle ? vehicle.acu5ValveFeedback.rawValue.toFixed(0) : "-" + "%"},
                                {label: "Status", value: vehicle ? vehicle.acu5Status.rawValue : ""},
                                {label: "Mode", value: vehicle ? vehicle.acu5Mode.rawValue : ""}
                            ] },
                        { title: "INTERCEPTOR PS",
                            entries: [
                                {label: "Position", value: vehicle ? vehicle.acu6Angle.rawValue.toFixed(1) : "-" + " deg"},
                                {label: "Speed", value: vehicle ? vehicle.acu6Speed.rawValue.toFixed(1) : "-" + " deg/sec"},
                                {label: "Target", value: vehicle ? vehicle.acu6Target.rawValue.toFixed(1) : "-" + " deg"},
                                {label: "Valve cmd", value: vehicle ? vehicle.acu6ValveCmd.rawValue.toFixed(0) : "-" + "%"},
                                {label: "Valve feedback", value: vehicle ? vehicle.acu6ValveFeedback.rawValue.toFixed(0) : "-" + "%"},
                                {label: "Status", value: vehicle ? vehicle.acu6Status.rawValue : ""},
                                {label: "Mode", value: vehicle ? vehicle.acu6Mode.rawValue : ""}
                            ] },
                        { title: "refill system", entries: [
                                {label: "Bow PS pressure", value: vehicle ? vehicle.bowPsPressure.rawValue.toFixed(0) : "-" + " bar"},
                                {label: "Bow SB pressure", value: vehicle ? vehicle.bowSbPressure.rawValue.toFixed(0) : "-" + " bar"},
                                {label: "Main PS pressure", value: vehicle ? vehicle.mainPsPressure.rawValue.toFixed(0) : "-" + " bar"},
                                {label: "Main SB pressure", value: vehicle ? vehicle.mainSbPressure.rawValue.toFixed(0) : "-" + " bar"},
                                {label: "Int PS pressure", value: vehicle ? vehicle.intPsPressure.rawValue.toFixed(0) : "-" + " bar"},
                                {label: "Int SB pressure", value: vehicle ? vehicle.intSbPressure.rawValue.toFixed(0) : "-" + " bar"},
                                {label: "Refill cmd", value: vehicle ? vehicle.refillCmd.rawValue.toFixed(0) : "-" + " %"}
                            ] },
            {
                title: "boat",
                entries: [
                    { label: "Pitch", value: boatPitch.toFixed(1) + " deg" },
                    { label: "Roll", value: boatRoll.toFixed(1) + " deg" },
                    { label: "Pitch speed", value: boatPitch.toFixed(1) + " deg" },
                    { label: "Roll speed", value: boatRoll.toFixed(1) + " deg" },
                    { label: "Bow Height", value: boatBowHeight.toFixed(1) + " m" }
                ]
            },
            { title: "sensors", entries: [] }
        ]
    }

    Component.onCompleted: {
        categories = _buildCategories()
    }

    onBoatPitchChanged: categories = _buildCategories()

    Rectangle {
        anchors.fill: parent
        color: qgcPal.windowShade
    }

    Flickable {
        id: flickable
        anchors.fill: parent
        contentWidth: width
        contentHeight: gridLayout.implicitHeight + (_outerMargin * 2)
        clip: true

        GridLayout {
            id: gridLayout
            x: _outerMargin
            y: _outerMargin
            width: flickable.width - (_outerMargin * 2)
            columns: Math.max(1, Math.floor((width + columnSpacing) / (_cardWidth + columnSpacing)))
            columnSpacing: _outerMargin
            rowSpacing: _outerMargin

            Repeater {
                model: categories

                Rectangle {
                    color: qgcPal.window
                    border.color: qgcPal.text
                    border.width: 1
                    radius: ScreenTools.defaultFontPixelWidth / 2
                    Layout.preferredWidth: _cardWidth
                    Layout.preferredHeight: contentLayout.implicitHeight + (ScreenTools.defaultFontPixelWidth * 2)
                    Layout.minimumHeight: _cardMinHeight

                    ColumnLayout {
                        id: contentLayout
                        anchors.fill: parent
                        anchors.margins: ScreenTools.defaultFontPixelWidth
                        spacing: _rowSpacing

                        QGCLabel {
                            text: modelData.title
                            font.bold: true
                            color: qgcPal.text
                            Layout.fillWidth: true
                        }

                        Item {
                            Layout.preferredHeight: 1
                            Layout.fillWidth: true

                            Rectangle {
                                anchors.fill: parent
                                color: qgcPal.text
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: _rowSpacing

                            Repeater {
                                model: modelData.entries

                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: ScreenTools.defaultFontPixelWidth

                                    QGCLabel {
                                        text: modelData.label
                                        color: qgcPal.text
                                        Layout.fillWidth: true
                                    }

                                    QGCLabel {
                                        text: modelData.value
                                        color: qgcPal.text
                                        horizontalAlignment: Text.AlignRight
                                        Layout.alignment: Qt.AlignRight
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

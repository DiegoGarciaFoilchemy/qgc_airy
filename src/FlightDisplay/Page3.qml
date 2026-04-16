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

    property var vehicle: globals.activeVehicle

    QGCPalette { id: qgcPal; colorGroupEnabled: true }

    property real _outerMargin: ScreenTools.defaultFontPixelWidth * 2.5
    property real _cardWidth: ScreenTools.defaultFontPixelWidth * 30
    property real _cardMinHeight: ScreenTools.defaultFontPixelWidth * 11
    property real _rowSpacing: ScreenTools.defaultFontPixelHeight * 0.2
    property real _titlePointSize: ScreenTools.defaultFontPointSize * 0.95
    property real _rowPointSize: ScreenTools.defaultFontPointSize * 0.9

    property var foilCards: _buildFoilCards()

    function _factValue(fact, decimals, unit) {
        if (!fact || fact.rawValue === undefined || fact.rawValue === null) {
            return "-"
        }

        var value = fact.rawValue
        if (typeof value === "number" && decimals >= 0) {
            value = value.toFixed(decimals)
        }

        return unit ? value + " " + unit : value
    }

    function _modeText(modeValue) {
        switch (modeValue) {
        case 0:
            return "POSITION MODE"
        case 1:
            return "MANUAL SPEED"
        case 2:
            return "CALIBRATION"
        case 3:
            return "IDLE"
        case 4:
            return "ZERO MODE"
        case 5:
            return "OFF"
        case 6:
            return "ERROR"
        case 7:
            return "SPEED MODE"
        default:
            return "Mode " + modeValue
        }
    }

    function _refillValveStateText(value) {
        return value >= 1 ? "Open" : "Closed"
    }

    function _buildCard(title, row, column, angleFact, speedFact, targetFact, valveCmdFact, valveFeedbackFact, statusFact, modeFact, pressureFact) {
        var modeValue = modeFact && modeFact.rawValue !== undefined && modeFact.rawValue !== null ? modeFact.rawValue : null
        var refillValue = vehicle && vehicle.refillCmd ? vehicle.refillCmd.rawValue : 0

        return {
            title: title,
            row: row,
            column: column,
            refillValue: refillValue,
            refillActive: refillValue >= 1,
            entries: [
                { label: "Position", value: _factValue(angleFact, 1, "deg") },
                { label: "Speed", value: _factValue(speedFact, 1, "deg/sec") },
                { label: "Target", value: _factValue(targetFact, 1, "deg") },
                { label: "Valve cmd", value: _factValue(valveCmdFact, 0, "%") },
                { label: "Valve feedback", value: _factValue(valveFeedbackFact, 0, "%") },
                { label: "Accumulator pressure", value: _factValue(pressureFact, 0, "bar") },
                { label: "Status", value: statusFact ? statusFact.rawValue : "-" },
                { label: "Mode", value: modeValue === null ? "-" : _modeText(modeValue) }
            ]
        }
    }

    function _buildFoilCards() {
        return [
            _buildCard(
                "INTERCEPTOR SB",
                0,
                0,
                vehicle ? vehicle.acu5Angle : null,
                vehicle ? vehicle.acu5Speed : null,
                vehicle ? vehicle.acu5Target : null,
                vehicle ? vehicle.acu5ValveCmd : null,
                vehicle ? vehicle.acu5ValveFeedback : null,
                vehicle ? vehicle.acu5Status : null,
                vehicle ? vehicle.acu5Mode : null,
                vehicle ? vehicle.intSbPressure : null
            ),
            _buildCard(
                "INTERCEPTOR PS",
                1,
                0,
                vehicle ? vehicle.acu6Angle : null,
                vehicle ? vehicle.acu6Speed : null,
                vehicle ? vehicle.acu6Target : null,
                vehicle ? vehicle.acu6ValveCmd : null,
                vehicle ? vehicle.acu6ValveFeedback : null,
                vehicle ? vehicle.acu6Status : null,
                vehicle ? vehicle.acu6Mode : null,
                vehicle ? vehicle.intPsPressure : null
            ),
            _buildCard(
                "MAIN SB FOIL",
                0,
                1,
                vehicle ? vehicle.acu3Angle : null,
                vehicle ? vehicle.acu3Speed : null,
                vehicle ? vehicle.acu3Target : null,
                vehicle ? vehicle.acu3ValveCmd : null,
                vehicle ? vehicle.acu3ValveFeedback : null,
                vehicle ? vehicle.acu3Status : null,
                vehicle ? vehicle.acu3Mode : null,
                vehicle ? vehicle.mainSbPressure : null
            ),
            _buildCard(
                "MAIN PS FOIL",
                1,
                1,
                vehicle ? vehicle.acu4Angle : null,
                vehicle ? vehicle.acu4Speed : null,
                vehicle ? vehicle.acu4Target : null,
                vehicle ? vehicle.acu4ValveCmd : null,
                vehicle ? vehicle.acu4ValveFeedback : null,
                vehicle ? vehicle.acu4Status : null,
                vehicle ? vehicle.acu4Mode : null,
                vehicle ? vehicle.mainPsPressure : null
            ),
            _buildCard(
                "BOW SB FOIL",
                0,
                2,
                vehicle ? vehicle.acu1Angle : null,
                vehicle ? vehicle.acu1Speed : null,
                vehicle ? vehicle.acu1Target : null,
                vehicle ? vehicle.acu1ValveCmd : null,
                vehicle ? vehicle.acu1ValveFeedback : null,
                vehicle ? vehicle.acu1Status : null,
                vehicle ? vehicle.acu1Mode : null,
                vehicle ? vehicle.bowSbPressure : null
            ),
            _buildCard(
                "BOW PS FOIL",
                1,
                2,
                vehicle ? vehicle.acu2Angle : null,
                vehicle ? vehicle.acu2Speed : null,
                vehicle ? vehicle.acu2Target : null,
                vehicle ? vehicle.acu2ValveCmd : null,
                vehicle ? vehicle.acu2ValveFeedback : null,
                vehicle ? vehicle.acu2Status : null,
                vehicle ? vehicle.acu2Mode : null,
                vehicle ? vehicle.bowPsPressure : null
            )
        ]
    }

    Rectangle {
        anchors.fill: parent
        color: qgcPal.windowShade
    }

    Flickable {
        id: flickable
        anchors.fill: parent
        contentWidth: width
        contentHeight: gridLayout.implicitHeight + manualFoilPanel.height + (_outerMargin * 3)
        clip: true

        GridLayout {
            id: gridLayout
            x: _outerMargin
            y: _outerMargin
            width: flickable.width - (_outerMargin * 2)
            columns: 3
            columnSpacing: _outerMargin
            rowSpacing: _outerMargin

            Repeater {
                model: foilCards

                Rectangle {
                    Layout.row: modelData.row
                    Layout.column: modelData.column
                    color: qgcPal.window
                    border.color: qgcPal.text
                    border.width: 1
                    radius: ScreenTools.defaultFontPixelWidth / 2
                    Layout.preferredWidth: _cardWidth
                    Layout.preferredHeight: contentLayout.implicitHeight + ScreenTools.defaultFontPixelWidth
                    Layout.minimumHeight: _cardMinHeight

                    ColumnLayout {
                        id: contentLayout
                        anchors.fill: parent
                        anchors.margins: ScreenTools.defaultFontPixelWidth * 0.7
                        spacing: _rowSpacing

                        QGCLabel {
                            text: modelData.title
                            font.bold: true
                            font.pointSize: _titlePointSize
                            color: qgcPal.text
                            Layout.fillWidth: true
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: _rowSpacing

                            Repeater {
                                model: modelData.entries

                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: ScreenTools.defaultFontPixelWidth * 0.6

                                    QGCLabel {
                                        text: modelData.label
                                        font.pointSize: _rowPointSize
                                        color: qgcPal.text
                                        Layout.fillWidth: true
                                    }

                                    QGCLabel {
                                        text: modelData.value
                                        font.pointSize: _rowPointSize
                                        color: qgcPal.text
                                        horizontalAlignment: Text.AlignRight
                                        Layout.alignment: Qt.AlignRight
                                    }
                                }
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: ScreenTools.defaultFontPixelWidth * 0.6

                            QGCLabel {
                                text: "Refill valve"
                                font.pointSize: _rowPointSize
                                color: qgcPal.text
                                Layout.fillWidth: true
                            }

                            Rectangle {
                                Layout.preferredWidth: ScreenTools.defaultFontPixelWidth * 1.4
                                Layout.preferredHeight: ScreenTools.defaultFontPixelWidth * 1.4
                                radius: width / 2
                                color: modelData.refillActive ? "#2fb34a" : qgcPal.windowShadeDark
                                border.color: qgcPal.text
                                border.width: 1
                            }

                            QGCLabel {
                                text: _refillValveStateText(vehicle && vehicle.refillCmd ? vehicle.refillCmd.rawValue : 0)
                                font.pointSize: _rowPointSize
                                color: qgcPal.text
                                horizontalAlignment: Text.AlignRight
                                Layout.alignment: Qt.AlignRight
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            id:           manualFoilPanel
            x:            0
            y:            gridLayout.y + gridLayout.implicitHeight + _outerMargin
            width:        flickable.width
            height:       panelContent.implicitHeight + ScreenTools.defaultFontPixelWidth
        color:        qgcPal.window
        border.color: qgcPal.text
        border.width: 1

        property var _foilAngles: [0, 0, 0, 0, 0, 0]

        Timer {
            interval: 300
            running:  manualFoilToggle.checked && vehicle
            repeat:   true
            onTriggered: vehicle.sendManualFoils(manualFoilPanel._foilAngles)
        }

        ColumnLayout {
            id: panelContent
            anchors {
                top:     parent.top
                left:    parent.left
                right:   parent.right
                margins: ScreenTools.defaultFontPixelWidth * 0.5
            }
            spacing: ScreenTools.defaultFontPixelHeight * 0.3

            QGCButton {
                id:               manualFoilToggle
                Layout.fillWidth: true
                text:             "MANUAL FOIL CONTROL"
                checkable:        true
                checked:          false
                highlighted:      checked
            }

            GridLayout {
                visible:          manualFoilToggle.checked
                Layout.fillWidth: true
                columns:          3
                columnSpacing:    ScreenTools.defaultFontPixelWidth
                rowSpacing:       ScreenTools.defaultFontPixelHeight * 0.8

                Repeater {
                    model: [
                        { label: "INT SB",  from: -10, to: 50, unit: "mm",     foilIndex: 0 },
                        { label: "AFT SB",  from: -35, to: 35, unit: "\u00b0", foilIndex: 2 },
                        { label: "BOW SB",  from: -35, to: 35, unit: "\u00b0", foilIndex: 4 },
                        { label: "INT PS",  from: -10, to: 50, unit: "mm",     foilIndex: 1 },
                        { label: "AFT PS",  from: -35, to: 35, unit: "\u00b0", foilIndex: 3 },
                        { label: "BOW PS",  from: -35, to: 35, unit: "\u00b0", foilIndex: 5 }
                    ]

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing:          0

                        RowLayout {
                            Layout.fillWidth: true
                            spacing:          ScreenTools.defaultFontPixelWidth * 0.4

                            QGCLabel {
                                text:             modelData.label
                                font.pointSize:   _titlePointSize
                                font.bold:        true
                                color:            qgcPal.text
                            }

                            Item { Layout.fillWidth: true }

                            QGCLabel {
                                id:               _valueLabel
                                text:             "0" + modelData.unit
                                font.pointSize:   _titlePointSize
                                font.bold:        true
                                color:            qgcPal.text
                            }
                        }

                        QGCSlider {
                            id:               _slider
                            Layout.fillWidth: true
                            from:             modelData.from
                            to:               modelData.to
                            value:            0
                            stepSize:         1
                            orientation:      Qt.Horizontal
                            onValueChanged: {
                                _valueLabel.text = value.toFixed(0) + modelData.unit
                                var arr = manualFoilPanel._foilAngles.slice()
                                arr[modelData.foilIndex] = value
                                manualFoilPanel._foilAngles = arr
                            }
                        }
                    }
                }
            }
        }
        }
    }
}

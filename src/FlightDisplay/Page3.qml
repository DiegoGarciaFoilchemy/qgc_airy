import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import QGroundControl
import QGroundControl.Controls
import QGroundControl.Palette
import QGroundControl.ScreenTools
import Qt5Compat.GraphicalEffects

Item {
    id: root
    width: parent ? parent.width : 1280
    height: parent ? parent.height : 760

    property var vehicle: globals.activeVehicle

    QGCPalette { id: qgcPal; colorGroupEnabled: true }

    property int _outerMarginX: 4
    property int _outerMarginY: 14
    property int _columnGap: 8
    property int _cardWidth: 290
    property int _cardMinHeight: 170
    property int _rowSpacing: 4
    property int _titlePixelSize: 18
    property int _rowPixelSize: 16
    property int _rowInlineSpacing: 8
    property int _contentMarginX: 2
    property int _contentMarginY: 6
    property int _cardCornerRadius: 6
    property int _cardBottomPadding: 8
    property int _refillIndicatorSize: 14
    property int _refillPanelHeight: 46
    property int _manualSliderWidth: 44
    property int _foilIndicatorWidth: 72
    property int _manualSliderGap: 8
    property bool _manualControlExpanded: false
    property var _manualFoilAngles: [0, 0, 0, 0, 0, 0]

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
            return "POSITION"
        case 1:
            return "SPEED"
        case 2:
            return "CALIBRATION"
        case 3:
            return "IDLE"
        case 4:
            return "ZERO"
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

    function _refillValveActive(value) {
        return value >= 1
    }

    function _manualControlActive() {
        if (!vehicle) {
            return false
        }

        var modeFacts = [
            vehicle.acu1Mode,
            vehicle.acu2Mode,
            vehicle.acu3Mode,
            vehicle.acu4Mode,
            vehicle.acu5Mode,
            vehicle.acu6Mode,
        ]

        for (var index = 0; index < modeFacts.length; index++) {
            var fact = modeFacts[index]
            if (fact && fact.rawValue === 1) {
                return true
            }
        }

        return false
    }

    function _factNumberValue(fact, fallbackValue) {
        if (!fact || fact.rawValue === undefined || fact.rawValue === null || isNaN(fact.rawValue)) {
            return fallbackValue
        }

        return Number(fact.rawValue)
    }

    function _syncManualFoilAngles() {
        _manualFoilAngles = [
            _factNumberValue(vehicle ? vehicle.acu5Angle : null, 0),
            _factNumberValue(vehicle ? vehicle.acu6Angle : null, 0),
            _factNumberValue(vehicle ? vehicle.acu3Angle : null, 0),
            _factNumberValue(vehicle ? vehicle.acu4Angle : null, 0),
            _factNumberValue(vehicle ? vehicle.acu1Angle : null, 0),
            _factNumberValue(vehicle ? vehicle.acu2Angle : null, 0)
        ]
    }

    function _toggleManualControlExpanded() {
        _manualControlExpanded = !_manualControlExpanded
        if (_manualControlExpanded) {
            _syncManualFoilAngles()
        } else {
            _manualFoilAngles = [0, 0, 0, 0, 0, 0]
        }
    }

    function _buildCard(title, row, column, angleFact, speedFact, targetFact, valveCmdFact, valveFeedbackFact, statusFact, modeFact, pressureFact, manualFrom, manualTo, manualUnit, manualIndex) {
        var modeValue = modeFact && modeFact.rawValue !== undefined && modeFact.rawValue !== null ? modeFact.rawValue : null
        var modeText = modeValue === null ? "OFF" : _modeText(modeValue)
        var refillValue = vehicle && vehicle.refillCmd ? vehicle.refillCmd.rawValue : 0

        return {
            title: title,
            modeText: modeText,
            modeOff: modeText === "OFF",
            row: row,
            column: column,
            refillValue: refillValue,
            refillActive: refillValue >= 1,
            angleFact: angleFact,
            manualFrom: manualFrom,
            manualTo: manualTo,
            manualUnit: manualUnit,
            manualIndex: manualIndex,
            entries: [
                { label: "Position", value: _factValue(angleFact, 1, "deg") },
                { label: "Speed", value: _factValue(speedFact, 1, "deg/sec") },
                { label: "Target", value: _factValue(targetFact, 1, "deg") },
                { label: "Valve cmd", value: _factValue(valveCmdFact, 0, "%") },
                { label: "Valve feedback", value: _factValue(valveFeedbackFact, 0, "%") },
                { label: "Accumulator pressure", value: _factValue(pressureFact, 0, "bar") },
                { label: "Status", value: statusFact ? statusFact.rawValue : "-" }
            ]
        }
    }

    function _buildFoilCards() {
        return [
            _buildCard(
                "BOW FLAP SB",
                0,
                1,
                vehicle ? vehicle.acu1Angle : null,
                vehicle ? vehicle.acu1Speed : null,
                vehicle ? vehicle.acu1Target : null,
                vehicle ? vehicle.acu1ValveCmd : null,
                vehicle ? vehicle.acu1ValveFeedback : null,
                vehicle ? vehicle.acu1Status : null,
                vehicle ? vehicle.acu1Mode : null,
                vehicle ? vehicle.bowSbPressure : null,
                -35,
                35,
                "\u00b0",
                4
            ),
            _buildCard(
                "BOW FLAP PS",
                0,
                0,
                vehicle ? vehicle.acu2Angle : null,
                vehicle ? vehicle.acu2Speed : null,
                vehicle ? vehicle.acu2Target : null,
                vehicle ? vehicle.acu2ValveCmd : null,
                vehicle ? vehicle.acu2ValveFeedback : null,
                vehicle ? vehicle.acu2Status : null,
                vehicle ? vehicle.acu2Mode : null,
                vehicle ? vehicle.bowPsPressure : null,
                -35,
                35,
                "\u00b0",
                5
            ),
            _buildCard(
                "AFT FLAP SB",
                1,
                1,
                vehicle ? vehicle.acu3Angle : null,
                vehicle ? vehicle.acu3Speed : null,
                vehicle ? vehicle.acu3Target : null,
                vehicle ? vehicle.acu3ValveCmd : null,
                vehicle ? vehicle.acu3ValveFeedback : null,
                vehicle ? vehicle.acu3Status : null,
                vehicle ? vehicle.acu3Mode : null,
                vehicle ? vehicle.mainSbPressure : null,
                -35,
                35,
                "\u00b0",
                2
            ),
            _buildCard(
                "AFT FLAP PS",
                1,
                0,
                vehicle ? vehicle.acu4Angle : null,
                vehicle ? vehicle.acu4Speed : null,
                vehicle ? vehicle.acu4Target : null,
                vehicle ? vehicle.acu4ValveCmd : null,
                vehicle ? vehicle.acu4ValveFeedback : null,
                vehicle ? vehicle.acu4Status : null,
                vehicle ? vehicle.acu4Mode : null,
                vehicle ? vehicle.mainPsPressure : null,
                -35,
                35,
                "\u00b0",
                3
            ),
            _buildCard(
                "INTERCEPTOR SB",
                2,
                1,
                vehicle ? vehicle.acu5Angle : null,
                vehicle ? vehicle.acu5Speed : null,
                vehicle ? vehicle.acu5Target : null,
                vehicle ? vehicle.acu5ValveCmd : null,
                vehicle ? vehicle.acu5ValveFeedback : null,
                vehicle ? vehicle.acu5Status : null,
                vehicle ? vehicle.acu5Mode : null,
                vehicle ? vehicle.intSbPressure : null,
                -10,
                50,
                "mm",
                0
            ),
            _buildCard(
                "INTERCEPTOR PS",
                2,
                0,
                vehicle ? vehicle.acu6Angle : null,
                vehicle ? vehicle.acu6Speed : null,
                vehicle ? vehicle.acu6Target : null,
                vehicle ? vehicle.acu6ValveCmd : null,
                vehicle ? vehicle.acu6ValveFeedback : null,
                vehicle ? vehicle.acu6Status : null,
                vehicle ? vehicle.acu6Mode : null,
                vehicle ? vehicle.intPsPressure : null,
                -10,
                50,
                "mm",
                1
            )
        ]
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
    }

    Timer {
        interval: 300
        running: root._manualControlExpanded && vehicle
        repeat: true
        onTriggered: vehicle.sendManualFoils(root._manualFoilAngles)
    }

    Flickable {
        id: flickable
        anchors.fill: parent
        contentWidth: width
        contentHeight: Math.max(refillValvePanel.y + refillValvePanel.height, manualControlPanel.y + manualControlPanel.height) + _outerMarginY
        clip: true

        GridLayout {
            id: gridLayout
            x: Math.max(_outerMarginX, (flickable.width - implicitWidth) / 2)
            y: _outerMarginY
            columns: 2
            columnSpacing: _columnGap
            rowSpacing: _outerMarginY

            Repeater {
                model: foilCards

                Item {
                    Layout.row: modelData.row
                    Layout.column: modelData.column
                    Layout.preferredWidth: _cardWidth
                    Layout.preferredHeight: cardContentLayout.implicitHeight + _cardBottomPadding
                    Layout.minimumHeight: _cardMinHeight
                    z: 1

                    Rectangle {
                        id: infoCard
                        anchors.fill: parent
                        color: qgcPal.window
                        border.color: modelData.modeOff ? "#ff4d4d" : qgcPal.text
                        border.width: modelData.modeOff ? 2 : 1
                        radius: _cardCornerRadius

                        ColumnLayout {
                            id: cardContentLayout
                            anchors.fill: parent
                            anchors.leftMargin: _contentMarginX
                            anchors.rightMargin: _contentMarginX
                            anchors.topMargin: _contentMarginY
                            anchors.bottomMargin: _contentMarginY
                            spacing: _rowSpacing

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: _rowInlineSpacing * 2

                                Label {
                                    text: modelData.title + ":"
                                    font.bold: true
                                    font.pixelSize: _titlePixelSize
                                    color: qgcPal.text
                                }

                                Item {
                                    Layout.fillWidth: true
                                }

                                Label {
                                    text: modelData.modeText
                                    font.bold: true
                                    font.pixelSize: _titlePixelSize
                                    color: qgcPal.text
                                    horizontalAlignment: Text.AlignRight
                                    Layout.alignment: Qt.AlignRight
                                }
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: _rowSpacing

                                Repeater {
                                    model: modelData.entries

                                    RowLayout {
                                        Layout.fillWidth: true
                                        spacing: _rowInlineSpacing

                                        Label {
                                            text: modelData.label
                                            font.pixelSize: _rowPixelSize
                                            color: qgcPal.text
                                            Layout.fillWidth: true
                                        }

                                        Label {
                                            text: modelData.value
                                            font.pixelSize: _rowPixelSize
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
                        id: sliderPanel
                        visible: true
                        property bool isFlapCard: modelData.manualUnit === "\u00b0"
                        width: root._manualControlExpanded ? _manualSliderWidth + _foilIndicatorWidth : _foilIndicatorWidth
                        height: parent.height
                        x: modelData.column === 0 ? -width - _manualSliderGap : parent.width + _manualSliderGap
                        y: 0
                        color: root._manualControlExpanded ? qgcPal.window : "transparent"
                        border.color: "#4aa3ff"
                        border.width: root._manualControlExpanded ? 1 : 0
                        radius: _cardCornerRadius
                        z: 2

                        RowLayout {
                            anchors.fill: parent
                            spacing: 0

                            // Left indicator — PS cards (column 0)
                            Item {
                                Layout.preferredWidth: modelData.column === 0 ? _foilIndicatorWidth : 0
                                Layout.fillHeight: true
                                visible: modelData.column === 0

                                // Foil image — flap cards only
                                Image {
                                    id: foilImgLeft
                                    visible: sliderPanel.isFlapCard
                                    source: "/qmlimages/foil.svg"
                                    width: parent.width - 6
                                    height: width / 6.3
                                    anchors.centerIn: parent
                                    smooth: true
                                    mipmap: true
                                    mirror: true
                                    layer.enabled: root._manualControlExpanded
                                    layer.effect: Glow {
                                        color: "#4aa3ff"
                                        radius: 8
                                        samples: 9
                                        spread: 0.4
                                        transparentBorder: true
                                    }
                                    transform: Rotation {
                                        origin.x: foilImgLeft.width * 0.18
                                        origin.y: foilImgLeft.height / 2
                                        angle: root._manualControlExpanded ? sliderControl.value : (modelData.angleFact ? modelData.angleFact.rawValue : 0)
                                    }
                                }

                                // Bar indicator — interceptor cards only
                                Item {
                                    visible: !sliderPanel.isFlapCard
                                    anchors.fill: parent

                                    property real currentValue: root._manualControlExpanded ? sliderControl.value : (modelData.angleFact ? Number(modelData.angleFact.rawValue) : 0)
                                    property real totalRange: modelData.manualTo - modelData.manualFrom
                                    property real trackPad: 18
                                    property real trackH: height - 2 * trackPad
                                    property real zeroY: trackPad + (Math.abs(modelData.manualFrom) / totalRange) * trackH
                                    property real fillH: (Math.abs(currentValue) / totalRange) * trackH

                                    Rectangle {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        y: parent.trackPad
                                        width: 16
                                        height: parent.trackH
                                        radius: 8
                                        color: "#111111"
                                        border.color: "#aaaaaa"
                                        border.width: 2
                                    }

                                    Rectangle {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        width: 16
                                        radius: 8
                                        y: parent.currentValue >= 0 ? parent.zeroY : parent.zeroY - parent.fillH
                                        height: Math.max(parent.fillH, 1)
                                        color: root._manualControlExpanded ? "#4aa3ff" : "#888888"
                                        layer.enabled: root._manualControlExpanded
                                        layer.effect: Glow {
                                            color: "#4aa3ff"
                                            radius: 4
                                            samples: 9
                                            spread: 0.5
                                            transparentBorder: true
                                        }
                                    }

                                    Rectangle {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        y: parent.zeroY - 1
                                        width: 24
                                        height: 2
                                        color: "#aaaaaa"
                                    }
                                }
                            }

                            // Slider column
                            ColumnLayout {
                                visible: root._manualControlExpanded
                                Layout.preferredWidth: _manualSliderWidth
                                Layout.fillHeight: true
                                Layout.topMargin: 8
                                Layout.bottomMargin: 8
                                spacing: 2

                                Label {
                                    Layout.alignment: Qt.AlignHCenter
                                    text: Number(sliderControl.value).toFixed(0) + modelData.manualUnit
                                    color: "#4aa3ff"
                                    font.bold: true
                                    font.pixelSize: _rowPixelSize - 1
                                }

                                Label {
                                    Layout.alignment: Qt.AlignHCenter
                                    text: modelData.manualFrom + modelData.manualUnit
                                    color: qgcPal.text
                                    font.pixelSize: _rowPixelSize - 4
                                }

                                QGCSlider {
                                    id: sliderControl
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.fillHeight: true
                                    orientation: Qt.Vertical
                                    from: modelData.manualTo
                                    to: modelData.manualFrom
                                    stepSize: 1

                                    Component.onCompleted: value = root._manualFoilAngles[modelData.manualIndex]
                                    onVisibleChanged: {
                                        if (visible) {
                                            value = root._manualFoilAngles[modelData.manualIndex]
                                        }
                                    }

                                    onValueChanged: {
                                        var values = root._manualFoilAngles.slice()
                                        values[modelData.manualIndex] = value
                                        root._manualFoilAngles = values
                                    }
                                }

                                Label {
                                    Layout.alignment: Qt.AlignHCenter
                                    text: modelData.manualTo + modelData.manualUnit
                                    color: qgcPal.text
                                    font.pixelSize: _rowPixelSize - 4
                                }
                            }

                            // Right indicator — SB cards (column 1)
                            Item {
                                Layout.preferredWidth: modelData.column === 1 ? _foilIndicatorWidth : 0
                                Layout.fillHeight: true
                                visible: modelData.column === 1

                                // Foil image — flap cards only
                                Image {
                                    id: foilImgRight
                                    visible: sliderPanel.isFlapCard
                                    source: "/qmlimages/foil.svg"
                                    width: parent.width - 6
                                    height: width / 6.3
                                    anchors.centerIn: parent
                                    smooth: true
                                    mipmap: true
                                    layer.enabled: root._manualControlExpanded
                                    layer.effect: Glow {
                                        color: "#4aa3ff"
                                        radius: 8
                                        samples: 9
                                        spread: 0.4
                                        transparentBorder: true
                                    }
                                    transform: Rotation {
                                        origin.x: foilImgRight.width * 0.82
                                        origin.y: foilImgRight.height / 2
                                        angle: root._manualControlExpanded ? -sliderControl.value : -(modelData.angleFact ? modelData.angleFact.rawValue : 0)
                                    }
                                }

                                // Bar indicator — interceptor cards only
                                Item {
                                    visible: !sliderPanel.isFlapCard
                                    anchors.fill: parent

                                    property real currentValue: root._manualControlExpanded ? sliderControl.value : (modelData.angleFact ? Number(modelData.angleFact.rawValue) : 0)
                                    property real totalRange: modelData.manualTo - modelData.manualFrom
                                    property real trackPad: 18
                                    property real trackH: height - 2 * trackPad
                                    property real zeroY: trackPad + (Math.abs(modelData.manualFrom) / totalRange) * trackH
                                    property real fillH: (Math.abs(currentValue) / totalRange) * trackH

                                    Rectangle {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        y: parent.trackPad
                                        width: 16
                                        height: parent.trackH
                                        radius: 8
                                        color: "#111111"
                                        border.color: "#aaaaaa"
                                        border.width: 2
                                    }

                                    Rectangle {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        width: 16
                                        radius: 8
                                        y: parent.currentValue >= 0 ? parent.zeroY : parent.zeroY - parent.fillH
                                        height: Math.max(parent.fillH, 1)
                                        color: root._manualControlExpanded ? "#4aa3ff" : "#888888"
                                        layer.enabled: root._manualControlExpanded
                                        layer.effect: Glow {
                                            color: "#4aa3ff"
                                            radius: 4
                                            samples: 9
                                            spread: 0.5
                                            transparentBorder: true
                                        }
                                    }

                                    Rectangle {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        y: parent.zeroY - 1
                                        width: 24
                                        height: 2
                                        color: "#aaaaaa"
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            id: refillValvePanel
            x: gridLayout.x
            y: gridLayout.y + gridLayout.implicitHeight + _outerMarginY
            width: _cardWidth
            height: _refillPanelHeight
            color: qgcPal.window
            border.color: _refillValveActive(vehicle && vehicle.refillCmd ? vehicle.refillCmd.rawValue : 0) ? "#4fe06b" : "#7a7a7a"
            border.width: 2
            radius: _cardCornerRadius

            property bool refillOpen: _refillValveActive(vehicle && vehicle.refillCmd ? vehicle.refillCmd.rawValue : 0)

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                anchors.topMargin: 6
                anchors.bottomMargin: 6
                spacing: 10

                Rectangle {
                    Layout.preferredWidth: 18
                    Layout.preferredHeight: 18
                    radius: 9
                    color: refillValvePanel.refillOpen ? "#4fe06b" : "#5a5a5a"
                    border.color: refillValvePanel.refillOpen ? "#a8ffb8" : "#9a9a9a"
                    border.width: 2
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2

                    Label {
                        text: "REFILL VALVE"
                        color: qgcPal.text
                        font.bold: true
                        font.pixelSize: _rowPixelSize - 1
                    }

                    Label {
                        text: refillValvePanel.refillOpen ? "OPEN" : "CLOSED"
                        color: refillValvePanel.refillOpen ? "#4fe06b" : "#c8c8c8"
                        font.bold: true
                        font.pixelSize: _titlePixelSize + 1
                    }
                }
            }
        }

        Rectangle {
            id: manualControlPanel
            x: gridLayout.x + _cardWidth + _columnGap
            y: gridLayout.y + gridLayout.implicitHeight + _outerMarginY
            width: _cardWidth
            height: _refillPanelHeight
            color: qgcPal.window
            border.color: root._manualControlExpanded ? "#4aa3ff" : "#7a7a7a"
            border.width: 2
            radius: _cardCornerRadius

            property bool manualControlOn: root._manualControlExpanded

            MouseArea {
                anchors.fill: parent
                onClicked: root._toggleManualControlExpanded()
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                anchors.topMargin: 6
                anchors.bottomMargin: 6
                spacing: 10

                Rectangle {
                    Layout.preferredWidth: 18
                    Layout.preferredHeight: 18
                    radius: 9
                    color: manualControlPanel.manualControlOn ? "#4aa3ff" : "#5a5a5a"
                    border.color: manualControlPanel.manualControlOn ? "#a9d1ff" : "#9a9a9a"
                    border.width: 2
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2

                    Label {
                        text: "MANUAL CONTROL"
                        color: qgcPal.text
                        font.bold: true
                        font.pixelSize: _rowPixelSize - 1
                    }

                    Label {
                        text: manualControlPanel.manualControlOn ? "ON" : "OFF"
                        color: manualControlPanel.manualControlOn ? "#4aa3ff" : "#c8c8c8"
                        font.bold: true
                        font.pixelSize: _titlePixelSize + 1
                    }
                }
            }
        }

        /*
        Rectangle {
            id:           manualFoilPanel
            x:            0
            y:            gridLayout.y + gridLayout.implicitHeight + _outerMarginY
            width:        flickable.width
            height:       panelContent.implicitHeight + _cardBottomPadding
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
                leftMargin: _contentMarginX
                rightMargin: _contentMarginX
                topMargin: _contentMarginY
                bottomMargin: _contentMarginY
            }
            spacing: _rowSpacing

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
                columnSpacing:    _outerMarginX
                rowSpacing:       _rowInlineSpacing

                Repeater {
                    model: [
                        { label: "INTERCEPTOR SB",  from: -10, to: 50, unit: "mm",     foilIndex: 0 },
                        { label: "AFT FLAP SB",  from: -35, to: 35, unit: "\u00b0", foilIndex: 2 },
                        { label: "BOW FLAP SB",  from: -35, to: 35, unit: "\u00b0", foilIndex: 4 },
                        { label: "INTERCEPTOR PS",  from: -10, to: 50, unit: "mm",     foilIndex: 1 },
                        { label: "AFT FLAP PS",  from: -35, to: 35, unit: "\u00b0", foilIndex: 3 },
                        { label: "BOW FLAP PS",  from: -35, to: 35, unit: "\u00b0", foilIndex: 5 }
                    ]

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing:          0

                        RowLayout {
                            Layout.fillWidth: true
                            spacing:          _rowInlineSpacing

                            Label {
                                text:             modelData.label
                                font.pixelSize:   _titlePixelSize
                                font.bold:        true
                                color:            qgcPal.text
                            }

                            Item { Layout.fillWidth: true }

                            Label {
                                id:               _valueLabel
                                text:             "0" + modelData.unit
                                font.pixelSize:   _titlePixelSize
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
        */
    }
}

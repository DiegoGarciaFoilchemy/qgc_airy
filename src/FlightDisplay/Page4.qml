import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import QGroundControl
import QGroundControl.Controls
import QGroundControl.Palette
import QGroundControl.ScreenTools
import QGroundControl.FactSystem


Item {
    id: root
    width: parent ? parent.width : 1280
    height: parent ? parent.height : 760
    property var  vehicle:      globals.activeVehicle


    QGCPalette { id: qgcPal; colorGroupEnabled: true }

    /// HEAVE_SP_2 parameter fact. Fetched lazily because no vehicle (and hence
    /// no parameter list) is available yet when this page is created at startup.
    property Fact _heaveSp2Fact: null
    property Fact _simAngleFact: null
    property Fact _bowPsFact:    null   // SIM_BOW_PS
    property Fact _bowSbFact:    null   // SIM_BOW_SB
    property Fact _aftPsFact:    null   // SIM_AFT_PS
    property Fact _aftSbFact:    null   // SIM_AFT_SB
    property Fact _rudderFact:   null   // SIM_RUDDER

    /// Foil angle limits (degrees)
    property real _foilMin:      -18
    property real _foilMax:      22
    property real _rudderMin:    -21.5
    property real _rudderMax:    23.5

    /// Manual foil control is only active while SIM_ANGLE == 1
    readonly property bool _foilControlEnabled: !!_simAngleFact && Number(_simAngleFact.rawValue) === 1

    /// Heave setpoint limits/step (in the parameter's raw units, i.e. meters)
    property real _heaveStepMeters: 0.05
    property real _heaveMinMeters:  0.0
    property real _heaveMaxMeters:  0.5

    Component {
        id: factControllerComponent
        FactPanelController { }
    }

    // FactPanelController captures the active vehicle in its constructor, so it
    // must only be created once a vehicle is actually connected. The returned
    // Fact is owned by the vehicle's ParameterManager (CppOwnership), so it
    // survives destroying the temporary controller below.
    function _fetchParameterFact(name) {
        if (!vehicle) {
            return null
        }
        var controller = factControllerComponent.createObject(root)
        // reportMissing = false: the parameter may simply not be loaded yet
        var fact = controller.getParameterFact(-1, name, false)
        controller.destroy()
        return fact
    }

    function _fetchFacts() {
        _heaveSp2Fact = _fetchParameterFact("HEAVE_SP_2")
        _simAngleFact = _fetchParameterFact("SIM_ANGLE")
        _bowPsFact    = _fetchParameterFact("SIM_BOW_PS")
        _bowSbFact    = _fetchParameterFact("SIM_BOW_SB")
        _aftPsFact    = _fetchParameterFact("SIM_AFT_PS")
        _aftSbFact    = _fetchParameterFact("SIM_AFT_SB")
        _rudderFact   = _fetchParameterFact("SIM_RUDDER")
    }

    Component.onCompleted: _fetchFacts()

    onVehicleChanged: _fetchFacts()

    // Re-fetch once the vehicle finishes downloading its parameters
    Connections {
        target: vehicle ? vehicle.parameterManager : null
        function onParametersReadyChanged() {
            root._fetchFacts()
        }
    }

    // Adjust the heave setpoint by delta (meters), clamped to [_heaveMinMeters, _heaveMaxMeters].
    function _adjustHeave(deltaMeters) {
        if (!_heaveSp2Fact) {
            return
        }
        var newValue = Number(_heaveSp2Fact.rawValue) + deltaMeters
        // Round to 2 decimals to avoid floating point accumulation errors
        newValue = Math.round(newValue * 100) / 100
        if (newValue > _heaveMaxMeters) {
            newValue = _heaveMaxMeters
        } else if (newValue < _heaveMinMeters) {
            newValue = _heaveMinMeters
        }
        _heaveSp2Fact.value = newValue   // triggers PARAM_SET to vehicle
    }

    // Toggle SIM_ANGLE between 0 and 1
    function _toggleSimAngle() {
        if (!_simAngleFact) {
            return
        }
        var newValue = Number(_simAngleFact.rawValue) === 1 ? 0 : 1
        _simAngleFact.value = newValue   // triggers PARAM_SET to vehicle
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
    }

    // Styling properties
    readonly property real _unitPx:     14
    property real _outerMarginX:        _unitPx * 0.3
    property real _outerMarginY:        _unitPx * 0.2
    property real _columnGap:           _unitPx * 0.6
    property real _cardWidth:           _unitPx * 23
    property real _cardMinHeight:       _unitPx * 1
    property real _rowSpacing:          _unitPx * 0.3
    property real _titlePixelSize:      _unitPx * 1.3
    property real _rowPixelSize:        _unitPx * 1.1
    property real _rowInlineSpacing:    _unitPx * 0.6
    property real _contentMarginX:      _unitPx * 0.95
    property real _contentMarginY:      _unitPx * 0.4
    property real _cardCornerRadius:    _unitPx * 0.45
    property real _cardBottomPadding:   _unitPx * 2.

    // Format fact values for display
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

    // State values: 255 means OFF, otherwise OK
    function _isOff(fact) {
        return !!fact && fact.rawValue === 255
    }

    function _stateText(fact) {
        if (!fact || fact.rawValue === undefined || fact.rawValue === null) {
            return "-"
        }
        return _isOff(fact) ? "OFF" : "OK"
    }

    function _cardHasOff(card) {
        if (!card || !card.entries) {
            return false
        }
        for (var i = 0; i < card.entries.length; i++) {
            var entry = card.entries[i]
            if (entry.isState && _isOff(entry.fact)) {
                return true
            }
        }
        return false
    }

    // Create subsystem card definitions
    function _buildSubsystemCards() {
        return [
            {
                title: "Boat Attitude",
                row: 0,
                column: 0,
                entries: [
                    { label: "Pitch", fact: vehicle ? vehicle.pitch : null, decimals: 1, unit: "deg" },
                    { label: "Roll", fact: vehicle ? vehicle.roll : null, decimals: 1, unit: "deg" },
                    { label: "Pitch Rate", fact: vehicle ? vehicle.pitchRate : null, decimals: 1, unit: "deg/s" },
                    { label: "Roll Rate", fact: vehicle ? vehicle.rollRate : null, decimals: 1, unit: "deg/s" },
                    { label: "IMU state", fact: vehicle ? vehicle.attitudeState : null, decimals: 0, unit: "", isState: true }
                ]
            },
            {
                title: "Boat Speed",
                row: 0,
                column: 2,
                entries: [
                    { label: "Ground Speed", fact: vehicle ? vehicle.groundSpeed : null, decimals: 1, unit: "knots" },
                    { label: "GPS state", fact: vehicle ? vehicle.speedState : null, decimals: 0, unit: "", isState: true }
                ]
            },
            {
                title: "Boat Heave",
                row: 1,
                column: 0,
                entries: [
                    { label: "Heave", fact: vehicle ? vehicle.bowHeight : null, decimals: 1, unit: "m" },
                    { label: "Estimation state", fact: vehicle ? vehicle.heaveState : null, decimals: 0, unit: "", isState: true }
                ]
            },
            {
                title: "Steering Wheel",
                row: 1,
                column: 2,
                entries: [
                    { label: "Steering position", fact: vehicle ? vehicle.joystickY : null, decimals: 1, unit: "" },
                    { label: "Encoder sate", fact: vehicle ? vehicle.joystickState : null, decimals: 0, unit: "", isState: true }
                ]
            },
            {
                title: "Ultrasonic Sensors",
                row: 0,
                column: 1,
                rowSpan: 2,
                entries: [
                    { label: "Ultrasonic bow stbd Distance", fact: vehicle ? vehicle.uss1Distance : null, decimals: 2, unit: "m" },
                    { label: "Ultrasonic bow stbd State", fact: vehicle ? vehicle.uss1State : null, decimals: 0, unit: "", isState: true },
                    { label: "Ultrasonic bow port Distance", fact: vehicle ? vehicle.uss2Distance : null, decimals: 2, unit: "m" },
                    { label: "Ultrasonic bow port State", fact: vehicle ? vehicle.uss2State : null, decimals: 0, unit: "", isState: true },
                    { label: "Ultrasonic aft Distance", fact: vehicle ? vehicle.uss3Distance : null, decimals: 2, unit: "m" },
                    { label: "Ultrasonic aft State", fact: vehicle ? vehicle.uss3State : null, decimals: 0, unit: "", isState: true }
                ]
            }
        ]
    }

    property var subsystemCards: _buildSubsystemCards()

    // Card layout UI
    Flickable {
        id: flickable
        anchors {
            top: foilSlidersColumn.bottom
            topMargin: 20
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        contentWidth: width
        contentHeight: gridLayout.implicitHeight
        clip: true

        GridLayout {
            id: gridLayout
            x: Math.max(_outerMarginX, (flickable.width - implicitWidth) / 2)
            columns: 3
            columnSpacing: _columnGap
            rowSpacing: _outerMarginY

            Repeater {
                model: subsystemCards

                Item {
                    Layout.row: modelData.row
                    Layout.column: modelData.column
                    Layout.columnSpan: modelData.columnSpan || 1
                    Layout.preferredWidth: modelData.columnSpan === 2 ? 
                        (_cardWidth * 2 + _columnGap) : _cardWidth
                    Layout.preferredHeight: cardContentLayout.implicitHeight + _cardBottomPadding
                    Layout.minimumHeight: _cardMinHeight

                    Rectangle {
                        id: infoCard
                        anchors.fill: parent
                        color: qgcPal.window
                        border.color: _cardHasOff(modelData) ? "#ff4d4d" : qgcPal.text
                        border.width: _cardHasOff(modelData) ? 2 : 1
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
                                            text: modelData.isState ? _stateText(modelData.fact) : _factValue(modelData.fact, modelData.decimals, modelData.unit)
                                            font.pixelSize: _rowPixelSize
                                            color: (modelData.isState && _isOff(modelData.fact)) ? "#ff4d4d" : qgcPal.text
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

    Rectangle {
        id: topLeftButton
        width: 140
        height: 60
        opacity: vehicle ? 1.0 : 0.45
        radius: 4
        color: "#2f2f2f"
        border.color: "#ffffff"
        border.width: 1
        anchors {
            left: parent.left
            top: parent.top
            leftMargin: 16
            topMargin: 20
        }

        Text {
            anchors.centerIn: parent
            text: "Reboot FCU"
            color: "white"
            font.pixelSize: 16
        }

        MouseArea {
            anchors.fill: parent
            enabled: !!vehicle
            onClicked: vehicle.rebootVehicle()
        }
    }

    // Heave setpoint controls, placed right of the Manual foil control button
    Rectangle {
        id: heaveDownButton
        width: 140
        height: 60
        opacity: (vehicle && _heaveSp2Fact) ? 1.0 : 0.45
        radius: 4
        color: "#2f2f2f"
        border.color: "#ffffff"
        border.width: 1
        anchors {
            left: manualFoilButton.right
            top: topLeftButton.top
            leftMargin: 12
        }

        Text {
            anchors.centerIn: parent
            text: "Heave -0.05"
            color: "white"
            font.pixelSize: 16
        }

        MouseArea {
            anchors.fill: parent
            enabled: !!vehicle && !!_heaveSp2Fact
            onClicked: _adjustHeave(-_heaveStepMeters)
        }
    }

    Rectangle {
        id: heaveUpButton
        width: 140
        height: 60
        opacity: (vehicle && _heaveSp2Fact) ? 1.0 : 0.45
        radius: 4
        color: "#2f2f2f"
        border.color: "#ffffff"
        border.width: 1
        anchors {
            left: heaveDownButton.right
            top: topLeftButton.top
            leftMargin: 12
        }

        Text {
            anchors.centerIn: parent
            text: "Heave +0.05"
            color: "white"
            font.pixelSize: 16
        }

        MouseArea {
            anchors.fill: parent
            enabled: !!vehicle && !!_heaveSp2Fact
            onClicked: _adjustHeave(_heaveStepMeters)
        }
    }

    // Current HEAVE_SP_2 value, right of both buttons
    Text {
        id: heaveValueLabel
        anchors {
            left: heaveUpButton.right
            verticalCenter: topLeftButton.verticalCenter
            leftMargin: 16
        }
        text: _heaveSp2Fact ? ("Heave Target: " + Number(_heaveSp2Fact.rawValue).toFixed(2) + " m")
                            : "Heave Target: N/A"
        color: "white"
        font.pixelSize: 16
    }

    // Manual foil control toggle, right of the Reboot FCU button
    Rectangle {
        id: manualFoilButton
        width: 200
        height: 60
        opacity: (vehicle && _simAngleFact) ? 1.0 : 0.45
        radius: 4
        color: "#2f2f2f"
        border.color: "#ffffff"
        border.width: 1
        anchors {
            left: topLeftButton.right
            top: topLeftButton.top
            leftMargin: 12
        }

        Text {
            anchors.centerIn: parent
            text: "Manual foil control"
            color: "white"
            font.pixelSize: 16
        }

        MouseArea {
            anchors.fill: parent
            enabled: !!vehicle && !!_simAngleFact
            onClicked: _toggleSimAngle()
        }
    }

    // Foil angle slider: single labeled horizontal slider with min/0/max scale
    component FoilSlider: Column {
        property Fact   fact: null
        property string title: ""
        property real   minValue: -10
        property real   maxValue: 10
        property bool   featureEnabled: true

        width: 320
        spacing: 2

        // Semi-transparent when the manual foil feature is off (SIM_ANGLE == 0)
        opacity: featureEnabled ? 1.0 : 0.35

        Row {
            spacing: 8
            Label {
                text: title
                color: "white"
                font.pixelSize: 14
            }
            Label {
                text: Number(slider.value).toFixed(1)
                color: "#cccccc"
                font.pixelSize: 14
            }
        }

        Slider {
            id: slider
            width: parent.width
            from: minValue
            to: maxValue
            value: 0
            enabled: featureEnabled && !!fact
            onMoved: {
                if (featureEnabled && fact) {
                    fact.value = value
                }
            }
        }

        Row {
            width: parent.width
            Label { text: minValue.toFixed(1).replace(/\.0$/, ""); color: "#888888"; width: parent.width / 3; font.pixelSize: 12; horizontalAlignment: Text.AlignLeft }
            Label { text: "0"; color: "#888888"; width: parent.width / 3; font.pixelSize: 12; horizontalAlignment: Text.AlignHCenter }
            Label { text: maxValue.toFixed(1).replace(/\.0$/, ""); color: "#888888"; width: parent.width / 3; font.pixelSize: 12; horizontalAlignment: Text.AlignRight }
        }
    }

    // Foil angle controls, below the top button row
    Column {
        id: foilSlidersColumn
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: topLeftButton.bottom
            topMargin: 20
        }
        spacing: 16

        Row {
            spacing: 40
            FoilSlider { title: "Bow PS"; fact: _bowPsFact; minValue: _foilMin; maxValue: _foilMax; featureEnabled: _foilControlEnabled }
            FoilSlider { title: "Bow SB"; fact: _bowSbFact; minValue: _foilMin; maxValue: _foilMax; featureEnabled: _foilControlEnabled }
        }

        Row {
            spacing: 40
            FoilSlider { title: "Aft PS"; fact: _aftPsFact; minValue: _foilMin; maxValue: _foilMax; featureEnabled: _foilControlEnabled }
            FoilSlider { title: "Aft SB"; fact: _aftSbFact; minValue: _foilMin; maxValue: _foilMax; featureEnabled: _foilControlEnabled }
        }

        Item {
            width: 680
            height: rudderSlider.height

            FoilSlider {
                id: rudderSlider
                anchors.horizontalCenter: parent.horizontalCenter
                title: "Rudder"
                fact: _rudderFact
                minValue: _rudderMin
                maxValue: _rudderMax
                featureEnabled: _foilControlEnabled
            }
        }
    }

}

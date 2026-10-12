import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import QGroundControl
import QGroundControl.Palette

Item {
    id: root
    width: parent ? parent.width : 1280
    height: parent ? parent.height : 760

    property var vehicle: globals.activeVehicle

    QGCPalette { id: qgcPal; colorGroupEnabled: true }

    readonly property real _unitPx: 14

    property real _outerMarginX:   _unitPx * 0.8
    property real _outerMarginY:   _unitPx * 0.6
    property real _columnGap:      _unitPx * 0.8
    property real _rowSpacing:     _unitPx * 0.35
    property real _cardWidth:      _unitPx * 24
    property real _titlePixelSize: _unitPx * 1.3
    property real _rowPixelSize:   _unitPx * 1.1
    property real _rowInlineSpacing: _unitPx * 0.6
    property real _contentMarginX: _unitPx * 0.95
    property real _contentMarginY: _unitPx * 0.4
    property real _cardCornerRadius: _unitPx * 0.45
    property real _bottomMargin:   _unitPx * 3

    // One card per VehicleGerris* fact group.
    property var factGroups: [
        {
            title: "BCM",
            group: "gerrisBcm",
            facts: [
                "timestamp", "status_word_1", "status_word_2", "temp_x10",
                "throttle", "services_battery_voltage_x10", "roll_x10", "pitch_x10",
                "isolation_voltage_1", "isolation_voltage_2", "isolation_resistance",
                "isolation_alarm_threshold", "isolation_warning_threshold", "io_mask"
            ]
        },
        {
            title: "INVERTER",
            group: "gerrisInverter",
            facts: [
                "timestamp", "on_request", "on_state", "aux_voltage_x10",
                "battery_voltage_x10", "throttle", "battery_current_x10", "output_power_x100",
                "board_temp_x10", "motor_temp_x10", "motor_rpm", "io_mask"
            ]
        },
        {
            title: "DC-DC",
            group: "gerrisDcdc",
            facts: [
                "timestamp", "on_request", "on_state", "hv_voltage_x10",
                "hv_current_x10", "lv_voltage_x10", "lv_current_x10", "coolant_temp_x10",
                "radiator_temp_x10", "io_mask"
            ]
        },
        {
            title: "BMS",
            group: "gerrisBms",
            facts: [
                "timestamp", "on_request", "on_state", "battery_voltage_x10",
                "battery_current_x10", "max_discharge_current_x10", "max_charge_current_x10",
                "soc_x10", "soh_x10", "io_mask"
            ]
        },
        {
            title: "CHARGER",
            group: "gerrisCharger",
            facts: [
                "timestamp", "on_request", "on_state", "actual_voltage_x10",
                "set_voltage_x10", "actual_current_x10", "set_current_x10"
            ]
        },
        {
            title: "ALARMS",
            group: "gerrisAlarms",
            facts: [
                "timestamp", "bcm_active", "bcm_stored", "bms_active", "bms_stored",
                "inverter_active", "inverter_stored", "dcdc_active", "dcdc_stored",
                "isolator_active", "isolator_stored"
            ]
        },
        {
            title: "WARNINGS",
            group: "gerrisWarnings",
            facts: [
                "timestamp", "bcm_active", "bcm_stored", "bms_active", "bms_stored",
                "inverter_active", "inverter_stored", "dcdc_active", "dcdc_stored",
                "isolator_active", "isolator_stored"
            ]
        }
    ]

    function _divisor(name) {
        if (name.endsWith("_x100")) {
            return 100
        }
        if (name.endsWith("_x10")) {
            return 10
        }
        return 1
    }

    function _decimals(name) {
        if (name.endsWith("_x100")) {
            return 2
        }
        if (name.endsWith("_x10")) {
            return 1
        }
        return 0
    }

    function _displayName(name) {
        if (name.endsWith("_x100")) {
            return name.slice(0, -5)
        }
        if (name.endsWith("_x10")) {
            return name.slice(0, -4)
        }
        return name
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
    }

    Flickable {
        id: flickable
        anchors.fill: parent
        contentWidth: width
        contentHeight: contentColumn.height
        clip: true

        ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

        Item {
            id: contentColumn
            width: parent.width
            height: gridLayout.implicitHeight + _outerMarginY + _bottomMargin

            GridLayout {
                id: gridLayout
                anchors.top: parent.top
                anchors.topMargin: _outerMarginY
                anchors.horizontalCenter: parent.horizontalCenter
                columns: 3
                columnSpacing: _columnGap
                rowSpacing: _outerMarginY

                Repeater {
                    model: factGroups

                    Rectangle {
                        property string groupName: modelData.group

                        Layout.preferredWidth: _cardWidth
                        Layout.preferredHeight: cardContent.implicitHeight + 2 * _contentMarginY
                        color: qgcPal.window
                        border.color: qgcPal.text
                        border.width: 1
                        radius: _cardCornerRadius

                        ColumnLayout {
                            id: cardContent
                            anchors.fill: parent
                            anchors.leftMargin: _contentMarginX
                            anchors.rightMargin: _contentMarginX
                            anchors.topMargin: _contentMarginY
                            anchors.bottomMargin: _contentMarginY
                            spacing: _rowSpacing

                            Label {
                                Layout.fillWidth: true
                                text: modelData.title
                                font.bold: true
                                font.pixelSize: _titlePixelSize
                                color: qgcPal.text
                            }

                            Repeater {
                                model: modelData.facts

                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: _rowInlineSpacing

                                    property string factName: root._displayName(modelData)
                                    property var fact: root.vehicle ? root.vehicle.getFactGroup(groupName).getFact(modelData) : null
                                    property int divisor: root._divisor(modelData)
                                    property int decimals: root._decimals(modelData)

                                    Label {
                                        text: factName
                                        font.pixelSize: _rowPixelSize
                                        color: qgcPal.text
                                        Layout.fillWidth: true
                                    }

                                    Label {
                                        text: fact && fact.rawValue !== undefined && fact.rawValue !== null
                                                ? (Number(fact.rawValue) / divisor).toFixed(decimals)
                                                : "-"
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
            }
        }
    }
}

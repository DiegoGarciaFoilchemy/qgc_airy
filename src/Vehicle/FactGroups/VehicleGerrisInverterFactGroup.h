/****************************************************************************
 *
 * (c) 2009-2024 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#pragma once

#include "FactGroup.h"

class VehicleGerrisInverterFactGroup : public FactGroup
{
    Q_OBJECT
    Q_PROPERTY(Fact *timestamp           READ timestamp           CONSTANT)
    Q_PROPERTY(Fact *on_request          READ on_request          CONSTANT)
    Q_PROPERTY(Fact *on_state            READ on_state            CONSTANT)
    Q_PROPERTY(Fact *aux_voltage_x10     READ aux_voltage_x10     CONSTANT)
    Q_PROPERTY(Fact *battery_voltage_x10 READ battery_voltage_x10 CONSTANT)
    Q_PROPERTY(Fact *throttle            READ throttle            CONSTANT)
    Q_PROPERTY(Fact *battery_current_x10 READ battery_current_x10 CONSTANT)
    Q_PROPERTY(Fact *output_power_x100   READ output_power_x100   CONSTANT)
    Q_PROPERTY(Fact *board_temp_x10      READ board_temp_x10      CONSTANT)
    Q_PROPERTY(Fact *motor_temp_x10      READ motor_temp_x10      CONSTANT)
    Q_PROPERTY(Fact *motor_rpm           READ motor_rpm           CONSTANT)
    Q_PROPERTY(Fact *io_mask             READ io_mask             CONSTANT)

public:
    explicit VehicleGerrisInverterFactGroup(QObject *parent = nullptr);

    Fact *timestamp() { return &_timestampFact; }
    Fact *on_request() { return &_on_requestFact; }
    Fact *on_state() { return &_on_stateFact; }
    Fact *aux_voltage_x10() { return &_aux_voltage_x10Fact; }
    Fact *battery_voltage_x10() { return &_battery_voltage_x10Fact; }
    Fact *throttle() { return &_throttleFact; }
    Fact *battery_current_x10() { return &_battery_current_x10Fact; }
    Fact *output_power_x100() { return &_output_power_x100Fact; }
    Fact *board_temp_x10() { return &_board_temp_x10Fact; }
    Fact *motor_temp_x10() { return &_motor_temp_x10Fact; }
    Fact *motor_rpm() { return &_motor_rpmFact; }
    Fact *io_mask() { return &_io_maskFact; }

    // Overrides from FactGroup
    void handleMessage(Vehicle *vehicle, const mavlink_message_t &message) final;

private:
    void _handleGerrisInverter(const mavlink_message_t &message);

    Fact _timestampFact = Fact(0, QStringLiteral("timestamp"), FactMetaData::valueTypeUint64);
    Fact _on_requestFact = Fact(0, QStringLiteral("on_request"), FactMetaData::valueTypeUint8);
    Fact _on_stateFact = Fact(0, QStringLiteral("on_state"), FactMetaData::valueTypeUint8);
    Fact _aux_voltage_x10Fact = Fact(0, QStringLiteral("aux_voltage_x10"), FactMetaData::valueTypeInt16);
    Fact _battery_voltage_x10Fact = Fact(0, QStringLiteral("battery_voltage_x10"), FactMetaData::valueTypeInt16);
    Fact _throttleFact = Fact(0, QStringLiteral("throttle"), FactMetaData::valueTypeUint8);
    Fact _battery_current_x10Fact = Fact(0, QStringLiteral("battery_current_x10"), FactMetaData::valueTypeInt16);
    Fact _output_power_x100Fact = Fact(0, QStringLiteral("output_power_x100"), FactMetaData::valueTypeInt16);
    Fact _board_temp_x10Fact = Fact(0, QStringLiteral("board_temp_x10"), FactMetaData::valueTypeInt16);
    Fact _motor_temp_x10Fact = Fact(0, QStringLiteral("motor_temp_x10"), FactMetaData::valueTypeInt16);
    Fact _motor_rpmFact = Fact(0, QStringLiteral("motor_rpm"), FactMetaData::valueTypeInt16);
    Fact _io_maskFact = Fact(0, QStringLiteral("io_mask"), FactMetaData::valueTypeUint16);
};

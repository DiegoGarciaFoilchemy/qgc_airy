/****************************************************************************
 *
 * (c) 2009-2024 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "VehicleGerrisInverterFactGroup.h"
#include "Vehicle.h"

VehicleGerrisInverterFactGroup::VehicleGerrisInverterFactGroup(QObject *parent)
    : FactGroup(1000, QStringLiteral(":/json/Vehicle/GerrisInverterFact.json"), parent)
{
    _addFact(&_timestampFact);
    _addFact(&_on_requestFact);
    _addFact(&_on_stateFact);
    _addFact(&_aux_voltage_x10Fact);
    _addFact(&_battery_voltage_x10Fact);
    _addFact(&_throttleFact);
    _addFact(&_battery_current_x10Fact);
    _addFact(&_output_power_x100Fact);
    _addFact(&_board_temp_x10Fact);
    _addFact(&_motor_temp_x10Fact);
    _addFact(&_motor_rpmFact);
    _addFact(&_io_maskFact);
}

void VehicleGerrisInverterFactGroup::handleMessage(Vehicle *vehicle, const mavlink_message_t &message)
{
    Q_UNUSED(vehicle);

    switch (message.msgid) {
    case MAVLINK_MSG_ID_GERRIS_INVERTER:
        _handleGerrisInverter(message);
        break;
    default:
        break;
    }
}

void VehicleGerrisInverterFactGroup::_handleGerrisInverter(const mavlink_message_t &message)
{
    mavlink_gerris_inverter_t gerrisInverter{};
    mavlink_msg_gerris_inverter_decode(&message, &gerrisInverter);

    timestamp()->setRawValue(static_cast<quint64>(gerrisInverter.timestamp));
    on_request()->setRawValue(gerrisInverter.on_request);
    on_state()->setRawValue(gerrisInverter.on_state);
    aux_voltage_x10()->setRawValue(gerrisInverter.aux_voltage_x10);
    battery_voltage_x10()->setRawValue(gerrisInverter.battery_voltage_x10);
    throttle()->setRawValue(gerrisInverter.throttle);
    battery_current_x10()->setRawValue(gerrisInverter.battery_current_x10);
    output_power_x100()->setRawValue(gerrisInverter.output_power_x100);
    board_temp_x10()->setRawValue(gerrisInverter.board_temp_x10);
    motor_temp_x10()->setRawValue(gerrisInverter.motor_temp_x10);
    motor_rpm()->setRawValue(gerrisInverter.motor_rpm);
    io_mask()->setRawValue(gerrisInverter.io_mask);

    _setTelemetryAvailable(true);
}

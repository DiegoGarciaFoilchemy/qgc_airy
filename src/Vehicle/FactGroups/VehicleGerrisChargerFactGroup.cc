/****************************************************************************
 *
 * (c) 2009-2024 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "VehicleGerrisChargerFactGroup.h"
#include "Vehicle.h"

VehicleGerrisChargerFactGroup::VehicleGerrisChargerFactGroup(QObject *parent)
    : FactGroup(1000, QStringLiteral(":/json/Vehicle/GerrisChargerFact.json"), parent)
{
    _addFact(&_timestampFact);
    _addFact(&_on_requestFact);
    _addFact(&_on_stateFact);
    _addFact(&_actual_voltage_x10Fact);
    _addFact(&_set_voltage_x10Fact);
    _addFact(&_actual_current_x10Fact);
    _addFact(&_set_current_x10Fact);
}

void VehicleGerrisChargerFactGroup::handleMessage(Vehicle *vehicle, const mavlink_message_t &message)
{
    Q_UNUSED(vehicle);

    switch (message.msgid) {
    case MAVLINK_MSG_ID_GERRIS_CHARGER:
        _handleGerrisCharger(message);
        break;
    default:
        break;
    }
}

void VehicleGerrisChargerFactGroup::_handleGerrisCharger(const mavlink_message_t &message)
{
    mavlink_gerris_charger_t gerrisCharger{};
    mavlink_msg_gerris_charger_decode(&message, &gerrisCharger);

    timestamp()->setRawValue(static_cast<quint64>(gerrisCharger.timestamp));
    on_request()->setRawValue(gerrisCharger.on_request);
    on_state()->setRawValue(gerrisCharger.on_state);
    actual_voltage_x10()->setRawValue(gerrisCharger.actual_voltage_x10);
    set_voltage_x10()->setRawValue(gerrisCharger.set_voltage_x10);
    actual_current_x10()->setRawValue(gerrisCharger.actual_current_x10);
    set_current_x10()->setRawValue(gerrisCharger.set_current_x10);

    _setTelemetryAvailable(true);
}

/****************************************************************************
 *
 * (c) 2009-2024 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "VehicleGerrisBmsFactGroup.h"
#include "Vehicle.h"

VehicleGerrisBmsFactGroup::VehicleGerrisBmsFactGroup(QObject *parent)
    : FactGroup(1000, QStringLiteral(":/json/Vehicle/GerrisBmsFact.json"), parent)
{
    _addFact(&_timestampFact);
    _addFact(&_on_requestFact);
    _addFact(&_on_stateFact);
    _addFact(&_battery_voltage_x10Fact);
    _addFact(&_battery_current_x10Fact);
    _addFact(&_max_discharge_current_x10Fact);
    _addFact(&_max_charge_current_x10Fact);
    _addFact(&_soc_x10Fact);
    _addFact(&_soh_x10Fact);
    _addFact(&_io_maskFact);
}

void VehicleGerrisBmsFactGroup::handleMessage(Vehicle *vehicle, const mavlink_message_t &message)
{
    Q_UNUSED(vehicle);

    switch (message.msgid) {
    case MAVLINK_MSG_ID_GERRIS_BMS:
        _handleGerrisBms(message);
        break;
    default:
        break;
    }
}

void VehicleGerrisBmsFactGroup::_handleGerrisBms(const mavlink_message_t &message)
{
    mavlink_gerris_bms_t gerrisBms{};
    mavlink_msg_gerris_bms_decode(&message, &gerrisBms);

    timestamp()->setRawValue(static_cast<quint64>(gerrisBms.timestamp));
    on_request()->setRawValue(gerrisBms.on_request);
    on_state()->setRawValue(gerrisBms.on_state);
    battery_voltage_x10()->setRawValue(gerrisBms.battery_voltage_x10);
    battery_current_x10()->setRawValue(gerrisBms.battery_current_x10);
    max_discharge_current_x10()->setRawValue(gerrisBms.max_discharge_current_x10);
    max_charge_current_x10()->setRawValue(gerrisBms.max_charge_current_x10);
    soc_x10()->setRawValue(gerrisBms.soc_x10);
    soh_x10()->setRawValue(gerrisBms.soh_x10);
    io_mask()->setRawValue(gerrisBms.io_mask);

    _setTelemetryAvailable(true);
}

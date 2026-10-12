/****************************************************************************
 *
 * (c) 2009-2024 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "VehicleGerrisDcdcFactGroup.h"
#include "Vehicle.h"

VehicleGerrisDcdcFactGroup::VehicleGerrisDcdcFactGroup(QObject *parent)
    : FactGroup(1000, QStringLiteral(":/json/Vehicle/GerrisDcdcFact.json"), parent)
{
    _addFact(&_timestampFact);
    _addFact(&_on_requestFact);
    _addFact(&_on_stateFact);
    _addFact(&_hv_voltage_x10Fact);
    _addFact(&_hv_current_x10Fact);
    _addFact(&_lv_voltage_x10Fact);
    _addFact(&_lv_current_x10Fact);
    _addFact(&_coolant_temp_x10Fact);
    _addFact(&_radiator_temp_x10Fact);
    _addFact(&_io_maskFact);
}

void VehicleGerrisDcdcFactGroup::handleMessage(Vehicle *vehicle, const mavlink_message_t &message)
{
    Q_UNUSED(vehicle);

    switch (message.msgid) {
    case MAVLINK_MSG_ID_GERRIS_DCDC:
        _handleGerrisDcdc(message);
        break;
    default:
        break;
    }
}

void VehicleGerrisDcdcFactGroup::_handleGerrisDcdc(const mavlink_message_t &message)
{
    mavlink_gerris_dcdc_t gerrisDcdc{};
    mavlink_msg_gerris_dcdc_decode(&message, &gerrisDcdc);

    timestamp()->setRawValue(static_cast<quint64>(gerrisDcdc.timestamp));
    on_request()->setRawValue(gerrisDcdc.on_request);
    on_state()->setRawValue(gerrisDcdc.on_state);
    hv_voltage_x10()->setRawValue(gerrisDcdc.hv_voltage_x10);
    hv_current_x10()->setRawValue(gerrisDcdc.hv_current_x10);
    lv_voltage_x10()->setRawValue(gerrisDcdc.lv_voltage_x10);
    lv_current_x10()->setRawValue(gerrisDcdc.lv_current_x10);
    coolant_temp_x10()->setRawValue(gerrisDcdc.coolant_temp_x10);
    radiator_temp_x10()->setRawValue(gerrisDcdc.radiator_temp_x10);
    io_mask()->setRawValue(gerrisDcdc.io_mask);

    _setTelemetryAvailable(true);
}

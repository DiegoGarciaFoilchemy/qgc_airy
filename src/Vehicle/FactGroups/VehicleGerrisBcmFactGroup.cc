/****************************************************************************
 *
 * (c) 2009-2024 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "VehicleGerrisBcmFactGroup.h"
#include "Vehicle.h"

VehicleGerrisBcmFactGroup::VehicleGerrisBcmFactGroup(QObject *parent)
    : FactGroup(1000, QStringLiteral(":/json/Vehicle/GerrisBcmFact.json"), parent)
{
    _addFact(&_timestampFact);
    _addFact(&_status_word_1Fact);
    _addFact(&_status_word_2Fact);
    _addFact(&_temp_x10Fact);
    _addFact(&_throttleFact);
    _addFact(&_services_battery_voltage_x10Fact);
    _addFact(&_roll_x10Fact);
    _addFact(&_pitch_x10Fact);
    _addFact(&_isolation_voltage_1Fact);
    _addFact(&_isolation_voltage_2Fact);
    _addFact(&_isolation_resistanceFact);
    _addFact(&_isolation_alarm_thresholdFact);
    _addFact(&_isolation_warning_thresholdFact);
    _addFact(&_io_maskFact);
}

void VehicleGerrisBcmFactGroup::handleMessage(Vehicle *vehicle, const mavlink_message_t &message)
{
    Q_UNUSED(vehicle);

    switch (message.msgid) {
    case MAVLINK_MSG_ID_GERRIS_BCM:
        _handleGerrisBcm(message);
        break;
    default:
        break;
    }
}

void VehicleGerrisBcmFactGroup::_handleGerrisBcm(const mavlink_message_t &message)
{
    mavlink_gerris_bcm_t gerrisBcm{};
    mavlink_msg_gerris_bcm_decode(&message, &gerrisBcm);

    timestamp()->setRawValue(static_cast<quint64>(gerrisBcm.timestamp));
    status_word_1()->setRawValue(gerrisBcm.status_word_1);
    status_word_2()->setRawValue(gerrisBcm.status_word_2);
    temp_x10()->setRawValue(gerrisBcm.temp_x10);
    throttle()->setRawValue(gerrisBcm.throttle);
    services_battery_voltage_x10()->setRawValue(gerrisBcm.services_battery_voltage_x10);
    roll_x10()->setRawValue(gerrisBcm.roll_x10);
    pitch_x10()->setRawValue(gerrisBcm.pitch_x10);
    isolation_voltage_1()->setRawValue(gerrisBcm.isolation_voltage_1);
    isolation_voltage_2()->setRawValue(gerrisBcm.isolation_voltage_2);
    isolation_resistance()->setRawValue(gerrisBcm.isolation_resistance);
    isolation_alarm_threshold()->setRawValue(gerrisBcm.isolation_alarm_threshold);
    isolation_warning_threshold()->setRawValue(gerrisBcm.isolation_warning_threshold);
    io_mask()->setRawValue(gerrisBcm.io_mask);

    _setTelemetryAvailable(true);
}

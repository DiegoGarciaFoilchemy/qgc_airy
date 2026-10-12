/****************************************************************************
 *
 * (c) 2009-2024 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "VehicleGerrisAlarmsFactGroup.h"
#include "Vehicle.h"

VehicleGerrisAlarmsFactGroup::VehicleGerrisAlarmsFactGroup(QObject *parent)
    : FactGroup(1000, QStringLiteral(":/json/Vehicle/GerrisAlarmsFact.json"), parent)
{
    _addFact(&_timestampFact);
    _addFact(&_bcm_activeFact);
    _addFact(&_bcm_storedFact);
    _addFact(&_bms_activeFact);
    _addFact(&_bms_storedFact);
    _addFact(&_inverter_activeFact);
    _addFact(&_inverter_storedFact);
    _addFact(&_dcdc_activeFact);
    _addFact(&_dcdc_storedFact);
    _addFact(&_isolator_activeFact);
    _addFact(&_isolator_storedFact);
}

void VehicleGerrisAlarmsFactGroup::handleMessage(Vehicle *vehicle, const mavlink_message_t &message)
{
    Q_UNUSED(vehicle);

    switch (message.msgid) {
    case MAVLINK_MSG_ID_GERRIS_ALARMS:
        _handleGerrisAlarms(message);
        break;
    default:
        break;
    }
}

void VehicleGerrisAlarmsFactGroup::_handleGerrisAlarms(const mavlink_message_t &message)
{
    mavlink_gerris_alarms_t gerrisAlarms{};
    mavlink_msg_gerris_alarms_decode(&message, &gerrisAlarms);

    timestamp()->setRawValue(static_cast<quint64>(gerrisAlarms.timestamp));
    bcm_active()->setRawValue(gerrisAlarms.bcm_active);
    bcm_stored()->setRawValue(gerrisAlarms.bcm_stored);
    bms_active()->setRawValue(gerrisAlarms.bms_active);
    bms_stored()->setRawValue(gerrisAlarms.bms_stored);
    inverter_active()->setRawValue(gerrisAlarms.inverter_active);
    inverter_stored()->setRawValue(gerrisAlarms.inverter_stored);
    dcdc_active()->setRawValue(gerrisAlarms.dcdc_active);
    dcdc_stored()->setRawValue(gerrisAlarms.dcdc_stored);
    isolator_active()->setRawValue(gerrisAlarms.isolator_active);
    isolator_stored()->setRawValue(gerrisAlarms.isolator_stored);

    _setTelemetryAvailable(true);
}

/****************************************************************************
 *
 * (c) 2009-2024 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "VehicleGerrisWarningsFactGroup.h"
#include "Vehicle.h"

VehicleGerrisWarningsFactGroup::VehicleGerrisWarningsFactGroup(QObject *parent)
    : FactGroup(1000, QStringLiteral(":/json/Vehicle/GerrisWarningsFact.json"), parent)
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

void VehicleGerrisWarningsFactGroup::handleMessage(Vehicle *vehicle, const mavlink_message_t &message)
{
    Q_UNUSED(vehicle);

    switch (message.msgid) {
    case MAVLINK_MSG_ID_GERRIS_WARNINGS:
        _handleGerrisWarnings(message);
        break;
    default:
        break;
    }
}

void VehicleGerrisWarningsFactGroup::_handleGerrisWarnings(const mavlink_message_t &message)
{
    mavlink_gerris_warnings_t gerrisWarnings{};
    mavlink_msg_gerris_warnings_decode(&message, &gerrisWarnings);

    timestamp()->setRawValue(static_cast<quint64>(gerrisWarnings.timestamp));
    bcm_active()->setRawValue(gerrisWarnings.bcm_active);
    bcm_stored()->setRawValue(gerrisWarnings.bcm_stored);
    bms_active()->setRawValue(gerrisWarnings.bms_active);
    bms_stored()->setRawValue(gerrisWarnings.bms_stored);
    inverter_active()->setRawValue(gerrisWarnings.inverter_active);
    inverter_stored()->setRawValue(gerrisWarnings.inverter_stored);
    dcdc_active()->setRawValue(gerrisWarnings.dcdc_active);
    dcdc_stored()->setRawValue(gerrisWarnings.dcdc_stored);
    isolator_active()->setRawValue(gerrisWarnings.isolator_active);
    isolator_stored()->setRawValue(gerrisWarnings.isolator_stored);

    _setTelemetryAvailable(true);
}

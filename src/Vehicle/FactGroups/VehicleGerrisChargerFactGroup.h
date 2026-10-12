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

class VehicleGerrisChargerFactGroup : public FactGroup
{
    Q_OBJECT
    Q_PROPERTY(Fact *timestamp          READ timestamp          CONSTANT)
    Q_PROPERTY(Fact *on_request         READ on_request         CONSTANT)
    Q_PROPERTY(Fact *on_state           READ on_state           CONSTANT)
    Q_PROPERTY(Fact *actual_voltage_x10 READ actual_voltage_x10 CONSTANT)
    Q_PROPERTY(Fact *set_voltage_x10    READ set_voltage_x10    CONSTANT)
    Q_PROPERTY(Fact *actual_current_x10 READ actual_current_x10 CONSTANT)
    Q_PROPERTY(Fact *set_current_x10    READ set_current_x10    CONSTANT)

public:
    explicit VehicleGerrisChargerFactGroup(QObject *parent = nullptr);

    Fact *timestamp() { return &_timestampFact; }
    Fact *on_request() { return &_on_requestFact; }
    Fact *on_state() { return &_on_stateFact; }
    Fact *actual_voltage_x10() { return &_actual_voltage_x10Fact; }
    Fact *set_voltage_x10() { return &_set_voltage_x10Fact; }
    Fact *actual_current_x10() { return &_actual_current_x10Fact; }
    Fact *set_current_x10() { return &_set_current_x10Fact; }

    // Overrides from FactGroup
    void handleMessage(Vehicle *vehicle, const mavlink_message_t &message) final;

private:
    void _handleGerrisCharger(const mavlink_message_t &message);

    Fact _timestampFact = Fact(0, QStringLiteral("timestamp"), FactMetaData::valueTypeUint64);
    Fact _on_requestFact = Fact(0, QStringLiteral("on_request"), FactMetaData::valueTypeUint8);
    Fact _on_stateFact = Fact(0, QStringLiteral("on_state"), FactMetaData::valueTypeUint8);
    Fact _actual_voltage_x10Fact = Fact(0, QStringLiteral("actual_voltage_x10"), FactMetaData::valueTypeInt16);
    Fact _set_voltage_x10Fact = Fact(0, QStringLiteral("set_voltage_x10"), FactMetaData::valueTypeInt16);
    Fact _actual_current_x10Fact = Fact(0, QStringLiteral("actual_current_x10"), FactMetaData::valueTypeInt16);
    Fact _set_current_x10Fact = Fact(0, QStringLiteral("set_current_x10"), FactMetaData::valueTypeInt16);
};

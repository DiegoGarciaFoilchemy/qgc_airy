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

class VehicleGerrisBmsFactGroup : public FactGroup
{
    Q_OBJECT
    Q_PROPERTY(Fact *timestamp                 READ timestamp                 CONSTANT)
    Q_PROPERTY(Fact *on_request                READ on_request                CONSTANT)
    Q_PROPERTY(Fact *on_state                  READ on_state                  CONSTANT)
    Q_PROPERTY(Fact *battery_voltage_x10       READ battery_voltage_x10       CONSTANT)
    Q_PROPERTY(Fact *battery_current_x10       READ battery_current_x10       CONSTANT)
    Q_PROPERTY(Fact *max_discharge_current_x10 READ max_discharge_current_x10 CONSTANT)
    Q_PROPERTY(Fact *max_charge_current_x10    READ max_charge_current_x10    CONSTANT)
    Q_PROPERTY(Fact *soc_x10                   READ soc_x10                   CONSTANT)
    Q_PROPERTY(Fact *soh_x10                   READ soh_x10                   CONSTANT)
    Q_PROPERTY(Fact *io_mask                   READ io_mask                   CONSTANT)

public:
    explicit VehicleGerrisBmsFactGroup(QObject *parent = nullptr);

    Fact *timestamp() { return &_timestampFact; }
    Fact *on_request() { return &_on_requestFact; }
    Fact *on_state() { return &_on_stateFact; }
    Fact *battery_voltage_x10() { return &_battery_voltage_x10Fact; }
    Fact *battery_current_x10() { return &_battery_current_x10Fact; }
    Fact *max_discharge_current_x10() { return &_max_discharge_current_x10Fact; }
    Fact *max_charge_current_x10() { return &_max_charge_current_x10Fact; }
    Fact *soc_x10() { return &_soc_x10Fact; }
    Fact *soh_x10() { return &_soh_x10Fact; }
    Fact *io_mask() { return &_io_maskFact; }

    // Overrides from FactGroup
    void handleMessage(Vehicle *vehicle, const mavlink_message_t &message) final;

private:
    void _handleGerrisBms(const mavlink_message_t &message);

    Fact _timestampFact = Fact(0, QStringLiteral("timestamp"), FactMetaData::valueTypeUint64);
    Fact _on_requestFact = Fact(0, QStringLiteral("on_request"), FactMetaData::valueTypeUint8);
    Fact _on_stateFact = Fact(0, QStringLiteral("on_state"), FactMetaData::valueTypeUint8);
    Fact _battery_voltage_x10Fact = Fact(0, QStringLiteral("battery_voltage_x10"), FactMetaData::valueTypeInt16);
    Fact _battery_current_x10Fact = Fact(0, QStringLiteral("battery_current_x10"), FactMetaData::valueTypeInt16);
    Fact _max_discharge_current_x10Fact = Fact(0, QStringLiteral("max_discharge_current_x10"), FactMetaData::valueTypeInt16);
    Fact _max_charge_current_x10Fact = Fact(0, QStringLiteral("max_charge_current_x10"), FactMetaData::valueTypeInt16);
    Fact _soc_x10Fact = Fact(0, QStringLiteral("soc_x10"), FactMetaData::valueTypeInt16);
    Fact _soh_x10Fact = Fact(0, QStringLiteral("soh_x10"), FactMetaData::valueTypeInt16);
    Fact _io_maskFact = Fact(0, QStringLiteral("io_mask"), FactMetaData::valueTypeUint16);
};

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

class VehicleGerrisDcdcFactGroup : public FactGroup
{
    Q_OBJECT
    Q_PROPERTY(Fact *timestamp         READ timestamp         CONSTANT)
    Q_PROPERTY(Fact *on_request        READ on_request        CONSTANT)
    Q_PROPERTY(Fact *on_state          READ on_state          CONSTANT)
    Q_PROPERTY(Fact *hv_voltage_x10    READ hv_voltage_x10    CONSTANT)
    Q_PROPERTY(Fact *hv_current_x10    READ hv_current_x10    CONSTANT)
    Q_PROPERTY(Fact *lv_voltage_x10    READ lv_voltage_x10    CONSTANT)
    Q_PROPERTY(Fact *lv_current_x10    READ lv_current_x10    CONSTANT)
    Q_PROPERTY(Fact *coolant_temp_x10  READ coolant_temp_x10  CONSTANT)
    Q_PROPERTY(Fact *radiator_temp_x10 READ radiator_temp_x10 CONSTANT)
    Q_PROPERTY(Fact *io_mask           READ io_mask           CONSTANT)

public:
    explicit VehicleGerrisDcdcFactGroup(QObject *parent = nullptr);

    Fact *timestamp() { return &_timestampFact; }
    Fact *on_request() { return &_on_requestFact; }
    Fact *on_state() { return &_on_stateFact; }
    Fact *hv_voltage_x10() { return &_hv_voltage_x10Fact; }
    Fact *hv_current_x10() { return &_hv_current_x10Fact; }
    Fact *lv_voltage_x10() { return &_lv_voltage_x10Fact; }
    Fact *lv_current_x10() { return &_lv_current_x10Fact; }
    Fact *coolant_temp_x10() { return &_coolant_temp_x10Fact; }
    Fact *radiator_temp_x10() { return &_radiator_temp_x10Fact; }
    Fact *io_mask() { return &_io_maskFact; }

    // Overrides from FactGroup
    void handleMessage(Vehicle *vehicle, const mavlink_message_t &message) final;

private:
    void _handleGerrisDcdc(const mavlink_message_t &message);

    Fact _timestampFact = Fact(0, QStringLiteral("timestamp"), FactMetaData::valueTypeUint64);
    Fact _on_requestFact = Fact(0, QStringLiteral("on_request"), FactMetaData::valueTypeUint8);
    Fact _on_stateFact = Fact(0, QStringLiteral("on_state"), FactMetaData::valueTypeUint8);
    Fact _hv_voltage_x10Fact = Fact(0, QStringLiteral("hv_voltage_x10"), FactMetaData::valueTypeInt16);
    Fact _hv_current_x10Fact = Fact(0, QStringLiteral("hv_current_x10"), FactMetaData::valueTypeInt16);
    Fact _lv_voltage_x10Fact = Fact(0, QStringLiteral("lv_voltage_x10"), FactMetaData::valueTypeInt16);
    Fact _lv_current_x10Fact = Fact(0, QStringLiteral("lv_current_x10"), FactMetaData::valueTypeInt16);
    Fact _coolant_temp_x10Fact = Fact(0, QStringLiteral("coolant_temp_x10"), FactMetaData::valueTypeInt16);
    Fact _radiator_temp_x10Fact = Fact(0, QStringLiteral("radiator_temp_x10"), FactMetaData::valueTypeInt16);
    Fact _io_maskFact = Fact(0, QStringLiteral("io_mask"), FactMetaData::valueTypeUint16);
};

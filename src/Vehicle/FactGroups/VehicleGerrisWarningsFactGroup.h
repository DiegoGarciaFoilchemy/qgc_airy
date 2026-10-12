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

class VehicleGerrisWarningsFactGroup : public FactGroup
{
    Q_OBJECT
    Q_PROPERTY(Fact *timestamp       READ timestamp       CONSTANT)
    Q_PROPERTY(Fact *bcm_active      READ bcm_active      CONSTANT)
    Q_PROPERTY(Fact *bcm_stored      READ bcm_stored      CONSTANT)
    Q_PROPERTY(Fact *bms_active      READ bms_active      CONSTANT)
    Q_PROPERTY(Fact *bms_stored      READ bms_stored      CONSTANT)
    Q_PROPERTY(Fact *inverter_active READ inverter_active CONSTANT)
    Q_PROPERTY(Fact *inverter_stored READ inverter_stored CONSTANT)
    Q_PROPERTY(Fact *dcdc_active     READ dcdc_active     CONSTANT)
    Q_PROPERTY(Fact *dcdc_stored     READ dcdc_stored     CONSTANT)
    Q_PROPERTY(Fact *isolator_active READ isolator_active CONSTANT)
    Q_PROPERTY(Fact *isolator_stored READ isolator_stored CONSTANT)

public:
    explicit VehicleGerrisWarningsFactGroup(QObject *parent = nullptr);

    Fact *timestamp() { return &_timestampFact; }
    Fact *bcm_active() { return &_bcm_activeFact; }
    Fact *bcm_stored() { return &_bcm_storedFact; }
    Fact *bms_active() { return &_bms_activeFact; }
    Fact *bms_stored() { return &_bms_storedFact; }
    Fact *inverter_active() { return &_inverter_activeFact; }
    Fact *inverter_stored() { return &_inverter_storedFact; }
    Fact *dcdc_active() { return &_dcdc_activeFact; }
    Fact *dcdc_stored() { return &_dcdc_storedFact; }
    Fact *isolator_active() { return &_isolator_activeFact; }
    Fact *isolator_stored() { return &_isolator_storedFact; }

    // Overrides from FactGroup
    void handleMessage(Vehicle *vehicle, const mavlink_message_t &message) final;

private:
    void _handleGerrisWarnings(const mavlink_message_t &message);

    Fact _timestampFact = Fact(0, QStringLiteral("timestamp"), FactMetaData::valueTypeUint64);
    Fact _bcm_activeFact = Fact(0, QStringLiteral("bcm_active"), FactMetaData::valueTypeUint32);
    Fact _bcm_storedFact = Fact(0, QStringLiteral("bcm_stored"), FactMetaData::valueTypeUint32);
    Fact _bms_activeFact = Fact(0, QStringLiteral("bms_active"), FactMetaData::valueTypeUint32);
    Fact _bms_storedFact = Fact(0, QStringLiteral("bms_stored"), FactMetaData::valueTypeUint32);
    Fact _inverter_activeFact = Fact(0, QStringLiteral("inverter_active"), FactMetaData::valueTypeUint32);
    Fact _inverter_storedFact = Fact(0, QStringLiteral("inverter_stored"), FactMetaData::valueTypeUint32);
    Fact _dcdc_activeFact = Fact(0, QStringLiteral("dcdc_active"), FactMetaData::valueTypeUint32);
    Fact _dcdc_storedFact = Fact(0, QStringLiteral("dcdc_stored"), FactMetaData::valueTypeUint32);
    Fact _isolator_activeFact = Fact(0, QStringLiteral("isolator_active"), FactMetaData::valueTypeUint32);
    Fact _isolator_storedFact = Fact(0, QStringLiteral("isolator_stored"), FactMetaData::valueTypeUint32);
};

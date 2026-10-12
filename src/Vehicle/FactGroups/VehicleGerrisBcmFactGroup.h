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

class VehicleGerrisBcmFactGroup : public FactGroup
{
    Q_OBJECT
    Q_PROPERTY(Fact *timestamp                     READ timestamp                     CONSTANT)
    Q_PROPERTY(Fact *status_word_1                 READ status_word_1                 CONSTANT)
    Q_PROPERTY(Fact *status_word_2                 READ status_word_2                 CONSTANT)
    Q_PROPERTY(Fact *temp_x10                      READ temp_x10                      CONSTANT)
    Q_PROPERTY(Fact *throttle                      READ throttle                      CONSTANT)
    Q_PROPERTY(Fact *services_battery_voltage_x10  READ services_battery_voltage_x10  CONSTANT)
    Q_PROPERTY(Fact *roll_x10                      READ roll_x10                      CONSTANT)
    Q_PROPERTY(Fact *pitch_x10                     READ pitch_x10                     CONSTANT)
    Q_PROPERTY(Fact *isolation_voltage_1           READ isolation_voltage_1           CONSTANT)
    Q_PROPERTY(Fact *isolation_voltage_2           READ isolation_voltage_2           CONSTANT)
    Q_PROPERTY(Fact *isolation_resistance          READ isolation_resistance          CONSTANT)
    Q_PROPERTY(Fact *isolation_alarm_threshold     READ isolation_alarm_threshold     CONSTANT)
    Q_PROPERTY(Fact *isolation_warning_threshold   READ isolation_warning_threshold   CONSTANT)
    Q_PROPERTY(Fact *io_mask                       READ io_mask                       CONSTANT)

public:
    explicit VehicleGerrisBcmFactGroup(QObject *parent = nullptr);

    Fact *timestamp() { return &_timestampFact; }
    Fact *status_word_1() { return &_status_word_1Fact; }
    Fact *status_word_2() { return &_status_word_2Fact; }
    Fact *temp_x10() { return &_temp_x10Fact; }
    Fact *throttle() { return &_throttleFact; }
    Fact *services_battery_voltage_x10() { return &_services_battery_voltage_x10Fact; }
    Fact *roll_x10() { return &_roll_x10Fact; }
    Fact *pitch_x10() { return &_pitch_x10Fact; }
    Fact *isolation_voltage_1() { return &_isolation_voltage_1Fact; }
    Fact *isolation_voltage_2() { return &_isolation_voltage_2Fact; }
    Fact *isolation_resistance() { return &_isolation_resistanceFact; }
    Fact *isolation_alarm_threshold() { return &_isolation_alarm_thresholdFact; }
    Fact *isolation_warning_threshold() { return &_isolation_warning_thresholdFact; }
    Fact *io_mask() { return &_io_maskFact; }

    // Overrides from FactGroup
    void handleMessage(Vehicle *vehicle, const mavlink_message_t &message) final;

private:
    void _handleGerrisBcm(const mavlink_message_t &message);

    Fact _timestampFact = Fact(0, QStringLiteral("timestamp"), FactMetaData::valueTypeUint64);
    Fact _status_word_1Fact = Fact(0, QStringLiteral("status_word_1"), FactMetaData::valueTypeUint16);
    Fact _status_word_2Fact = Fact(0, QStringLiteral("status_word_2"), FactMetaData::valueTypeUint16);
    Fact _temp_x10Fact = Fact(0, QStringLiteral("temp_x10"), FactMetaData::valueTypeInt16);
    Fact _throttleFact = Fact(0, QStringLiteral("throttle"), FactMetaData::valueTypeUint8);
    Fact _services_battery_voltage_x10Fact = Fact(0, QStringLiteral("services_battery_voltage_x10"), FactMetaData::valueTypeInt16);
    Fact _roll_x10Fact = Fact(0, QStringLiteral("roll_x10"), FactMetaData::valueTypeInt16);
    Fact _pitch_x10Fact = Fact(0, QStringLiteral("pitch_x10"), FactMetaData::valueTypeInt16);
    Fact _isolation_voltage_1Fact = Fact(0, QStringLiteral("isolation_voltage_1"), FactMetaData::valueTypeUint16);
    Fact _isolation_voltage_2Fact = Fact(0, QStringLiteral("isolation_voltage_2"), FactMetaData::valueTypeUint16);
    Fact _isolation_resistanceFact = Fact(0, QStringLiteral("isolation_resistance"), FactMetaData::valueTypeUint16);
    Fact _isolation_alarm_thresholdFact = Fact(0, QStringLiteral("isolation_alarm_threshold"), FactMetaData::valueTypeUint16);
    Fact _isolation_warning_thresholdFact = Fact(0, QStringLiteral("isolation_warning_threshold"), FactMetaData::valueTypeUint16);
    Fact _io_maskFact = Fact(0, QStringLiteral("io_mask"), FactMetaData::valueTypeUint16);
};

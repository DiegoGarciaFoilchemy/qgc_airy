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

class VehicleFactGroup : public FactGroup
{
    Q_OBJECT
    Q_PROPERTY(Fact *roll                   READ roll                   CONSTANT)
    Q_PROPERTY(Fact *pitch                  READ pitch                  CONSTANT)
    Q_PROPERTY(Fact *heading                READ heading                CONSTANT)
    Q_PROPERTY(Fact *rollRate               READ rollRate               CONSTANT)
    Q_PROPERTY(Fact *pitchRate              READ pitchRate              CONSTANT)
    Q_PROPERTY(Fact *yawRate                READ yawRate                CONSTANT)
    Q_PROPERTY(Fact *groundSpeed            READ groundSpeed            CONSTANT)
    Q_PROPERTY(Fact *airSpeed               READ airSpeed               CONSTANT)
    Q_PROPERTY(Fact *airSpeedSetpoint       READ airSpeedSetpoint       CONSTANT)
    Q_PROPERTY(Fact *climbRate              READ climbRate              CONSTANT)
    Q_PROPERTY(Fact *altitudeRelative       READ altitudeRelative       CONSTANT)
    Q_PROPERTY(Fact *altitudeAMSL           READ altitudeAMSL           CONSTANT)
    Q_PROPERTY(Fact *altitudeAboveTerr      READ altitudeAboveTerr      CONSTANT)
    Q_PROPERTY(Fact *altitudeTuning         READ altitudeTuning         CONSTANT)
    Q_PROPERTY(Fact *altitudeTuningSetpoint READ altitudeTuningSetpoint CONSTANT)
    Q_PROPERTY(Fact *xTrackError            READ xTrackError            CONSTANT)
    Q_PROPERTY(Fact *rangeFinderDist        READ rangeFinderDist        CONSTANT)
    Q_PROPERTY(Fact *flightDistance         READ flightDistance         CONSTANT)
    Q_PROPERTY(Fact *distanceToHome         READ distanceToHome         CONSTANT)
    Q_PROPERTY(Fact *timeToHome             READ timeToHome             CONSTANT)
    Q_PROPERTY(Fact *missionItemIndex       READ missionItemIndex       CONSTANT)
    Q_PROPERTY(Fact *headingToNextWP        READ headingToNextWP        CONSTANT)
    Q_PROPERTY(Fact *distanceToNextWP       READ distanceToNextWP       CONSTANT)
    Q_PROPERTY(Fact *headingToHome          READ headingToHome          CONSTANT)
    Q_PROPERTY(Fact *distanceToGCS          READ distanceToGCS          CONSTANT)
    Q_PROPERTY(Fact *hobbs                  READ hobbs                  CONSTANT)
    Q_PROPERTY(Fact *throttlePct            READ throttlePct            CONSTANT)
    Q_PROPERTY(Fact *imuTemp                READ imuTemp                CONSTANT)

    Q_PROPERTY(Fact *acu1Angle              READ acu1Angle              CONSTANT)
    Q_PROPERTY(Fact *acu1Speed              READ acu1Speed              CONSTANT)
    Q_PROPERTY(Fact *acu1Target             READ acu1Target             CONSTANT)
    Q_PROPERTY(Fact *acu1Status             READ acu1Status             CONSTANT)
    Q_PROPERTY(Fact *acu1Mode               READ acu1Mode               CONSTANT)
    Q_PROPERTY(Fact *acu1ValveCmd           READ acu1ValveCmd           CONSTANT)
    Q_PROPERTY(Fact *acu1ValveFeedback      READ acu1ValveFeedback      CONSTANT)

    Q_PROPERTY(Fact *acu2Angle              READ acu2Angle              CONSTANT)
    Q_PROPERTY(Fact *acu2Speed              READ acu2Speed              CONSTANT)
    Q_PROPERTY(Fact *acu2Target             READ acu2Target             CONSTANT)
    Q_PROPERTY(Fact *acu2Status             READ acu2Status             CONSTANT)
    Q_PROPERTY(Fact *acu2Mode               READ acu2Mode               CONSTANT)
    Q_PROPERTY(Fact *acu2ValveCmd           READ acu2ValveCmd           CONSTANT)
    Q_PROPERTY(Fact *acu2ValveFeedback      READ acu2ValveFeedback      CONSTANT)

    Q_PROPERTY(Fact *acu3Angle              READ acu3Angle              CONSTANT)
    Q_PROPERTY(Fact *acu3Speed              READ acu3Speed              CONSTANT)
    Q_PROPERTY(Fact *acu3Target             READ acu3Target             CONSTANT)
    Q_PROPERTY(Fact *acu3Status             READ acu3Status             CONSTANT)
    Q_PROPERTY(Fact *acu3Mode               READ acu3Mode               CONSTANT)
    Q_PROPERTY(Fact *acu3ValveCmd           READ acu3ValveCmd           CONSTANT)
    Q_PROPERTY(Fact *acu3ValveFeedback      READ acu3ValveFeedback      CONSTANT)

    Q_PROPERTY(Fact *acu4Angle              READ acu4Angle              CONSTANT)
    Q_PROPERTY(Fact *acu4Speed              READ acu4Speed              CONSTANT)
    Q_PROPERTY(Fact *acu4Target             READ acu4Target             CONSTANT)
    Q_PROPERTY(Fact *acu4Status             READ acu4Status             CONSTANT)
    Q_PROPERTY(Fact *acu4Mode               READ acu4Mode               CONSTANT)
    Q_PROPERTY(Fact *acu4ValveCmd           READ acu4ValveCmd           CONSTANT)
    Q_PROPERTY(Fact *acu4ValveFeedback      READ acu4ValveFeedback      CONSTANT)

    Q_PROPERTY(Fact *acu5Angle              READ acu5Angle              CONSTANT)
    Q_PROPERTY(Fact *acu5Speed              READ acu5Speed              CONSTANT)
    Q_PROPERTY(Fact *acu5Target             READ acu5Target             CONSTANT)
    Q_PROPERTY(Fact *acu5Status             READ acu5Status             CONSTANT)
    Q_PROPERTY(Fact *acu5Mode               READ acu5Mode               CONSTANT)
    Q_PROPERTY(Fact *acu5ValveCmd           READ acu5ValveCmd           CONSTANT)
    Q_PROPERTY(Fact *acu5ValveFeedback      READ acu5ValveFeedback      CONSTANT)

    Q_PROPERTY(Fact *acu6Angle              READ acu6Angle              CONSTANT)
    Q_PROPERTY(Fact *acu6Speed              READ acu6Speed              CONSTANT)
    Q_PROPERTY(Fact *acu6Target             READ acu6Target             CONSTANT)
    Q_PROPERTY(Fact *acu6Status             READ acu6Status             CONSTANT)
    Q_PROPERTY(Fact *acu6Mode               READ acu6Mode               CONSTANT)
    Q_PROPERTY(Fact *acu6ValveCmd           READ acu6ValveCmd           CONSTANT)
    Q_PROPERTY(Fact *acu6ValveFeedback      READ acu6ValveFeedback      CONSTANT)

    Q_PROPERTY(Fact *followingSeas          READ followingSeas          CONSTANT)
    Q_PROPERTY(Fact *bowHeight              READ bowHeight              CONSTANT)
    Q_PROPERTY(Fact *estimatedDisplacement  READ estimatedDisplacement  CONSTANT)
    Q_PROPERTY(Fact *controlState           READ controlState           CONSTANT)
    Q_PROPERTY(Fact *controlHealth          READ controlHealth          CONSTANT)
    
    

public:
    explicit VehicleFactGroup(QObject *parent = nullptr);

    Fact *roll() { return &_rollFact; }
    Fact *pitch() { return &_pitchFact; }
    Fact *heading() { return &_headingFact; }
    Fact *rollRate() { return &_rollRateFact; }
    Fact *pitchRate() { return &_pitchRateFact; }
    Fact *yawRate() { return &_yawRateFact; }
    Fact *airSpeed() { return &_airSpeedFact; }
    Fact *airSpeedSetpoint() { return &_airSpeedSetpointFact; }
    Fact *groundSpeed() { return &_groundSpeedFact; }
    Fact *climbRate() { return &_climbRateFact; }
    Fact *altitudeRelative() { return &_altitudeRelativeFact; }
    Fact *altitudeAMSL() { return &_altitudeAMSLFact; }
    Fact *altitudeAboveTerr() { return &_altitudeAboveTerrFact; }
    Fact *altitudeTuning() { return &_altitudeTuningFact; }
    Fact *altitudeTuningSetpoint() { return &_altitudeTuningSetpointFact; }
    Fact *xTrackError() { return &_xTrackErrorFact; }
    Fact *rangeFinderDist() { return &_rangeFinderDistFact; }
    Fact *flightDistance() { return &_flightDistanceFact; }
    Fact *distanceToHome() { return &_distanceToHomeFact; }
    Fact *timeToHome() { return &_timeToHomeFact; }
    Fact *missionItemIndex() { return &_missionItemIndexFact; }
    Fact *headingToNextWP() { return &_headingToNextWPFact; }
    Fact *distanceToNextWP() { return &_distanceToNextWPFact; }
    Fact *headingToHome() { return &_headingToHomeFact; }
    Fact *distanceToGCS() { return &_distanceToGCSFact; }
    Fact *hobbs() { return &_hobbsFact; }
    Fact *throttlePct() { return &_throttlePctFact; }
    Fact *imuTemp() { return &_imuTempFact; }

    Fact *acu1Angle() { return &_acu1AngleFact; }
    Fact *acu1Speed() { return &_acu1SpeedFact; }
    Fact *acu1Target() { return &_acu1TargetFact; }
    Fact *acu1Status() { return &_acu1StatusFact; }
    Fact *acu1Mode() { return &_acu1ModeFact; }
    Fact *acu1ValveCmd() { return &_acu1ValveCmdFact; }
    Fact *acu1ValveFeedback() { return &_acu1ValveFeedbackFact; }

    Fact *acu2Angle() { return &_acu2AngleFact; }
    Fact *acu2Speed() { return &_acu2SpeedFact; }
    Fact *acu2Target() { return &_acu2TargetFact; }
    Fact *acu2Status() { return &_acu2StatusFact; }
    Fact *acu2Mode() { return &_acu2ModeFact; }
    Fact *acu2ValveCmd() { return &_acu2ValveCmdFact; }
    Fact *acu2ValveFeedback() { return &_acu2ValveFeedbackFact; }

    Fact *acu3Angle() { return &_acu3AngleFact; }
    Fact *acu3Speed() { return &_acu3SpeedFact; }
    Fact *acu3Target() { return &_acu3TargetFact; }
    Fact *acu3Status() { return &_acu3StatusFact; }
    Fact *acu3Mode() { return &_acu3ModeFact; }
    Fact *acu3ValveCmd() { return &_acu3ValveCmdFact; }
    Fact *acu3ValveFeedback() { return &_acu3ValveFeedbackFact; }

    Fact *acu4Angle() { return &_acu4AngleFact; }
    Fact *acu4Speed() { return &_acu4SpeedFact; }
    Fact *acu4Target() { return &_acu4TargetFact; }
    Fact *acu4Status() { return &_acu4StatusFact; }
    Fact *acu4Mode() { return &_acu4ModeFact; }
    Fact *acu4ValveCmd() { return &_acu4ValveCmdFact; }
    Fact *acu4ValveFeedback() { return &_acu4ValveFeedbackFact; }

    Fact *acu5Angle() { return &_acu5AngleFact; }
    Fact *acu5Speed() { return &_acu5SpeedFact; }
    Fact *acu5Target() { return &_acu5TargetFact; }
    Fact *acu5Status() { return &_acu5StatusFact; }
    Fact *acu5Mode() { return &_acu5ModeFact; }
    Fact *acu5ValveCmd() { return &_acu5ValveCmdFact; }
    Fact *acu5ValveFeedback() { return &_acu5ValveFeedbackFact; }

    Fact *acu6Angle() { return &_acu6AngleFact; }
    Fact *acu6Speed() { return &_acu6SpeedFact; }
    Fact *acu6Target() { return &_acu6TargetFact; }
    Fact *acu6Status() { return &_acu6StatusFact; }
    Fact *acu6Mode() { return &_acu6ModeFact; }
    Fact *acu6ValveCmd() { return &_acu6ValveCmdFact; }
    Fact *acu6ValveFeedback() { return &_acu6ValveFeedbackFact; }

    Fact *followingSeas() { return &_followingSeasFact; }
    Fact *bowHeight() { return &_bowHeightFact; }
    Fact *estimatedDisplacement() { return &_estimatedDisplacementFact; }
    Fact *controlState() { return &_controlStateFact; }
    Fact *controlHealth() { return &_controlHealthFact; }

    void handleMessage(Vehicle *vehicle, const mavlink_message_t &message) override;

protected:
    void _handleAttitude(Vehicle *vehicle, const mavlink_message_t &message);
    void _handleAttitudeQuaternion(Vehicle *vehicle, const mavlink_message_t &message);
    void _handleAltitude(const mavlink_message_t &message);
    void _handleVfrHud(const mavlink_message_t &message);
    void _handleRawImuTemp(const mavlink_message_t &message);
    void _handleNavControllerOutput(const mavlink_message_t &message);
    void _handleMarsunActuator(const mavlink_message_t &message);
    void _handleMarsunControlState(const mavlink_message_t &message);
    void _handleAccumulator(const mavlink_message_t &message);
#ifndef QGC_NO_ARDUPILOT_DIALECT
    void _handleRangefinder(const mavlink_message_t &message);
#endif

    Fact _rollFact = Fact(0, QStringLiteral("roll"), FactMetaData::valueTypeDouble);
    Fact _pitchFact = Fact(0, QStringLiteral("pitch"), FactMetaData::valueTypeDouble);
    Fact _headingFact = Fact(0, QStringLiteral("heading"), FactMetaData::valueTypeDouble);
    Fact _rollRateFact = Fact(0, QStringLiteral("rollRate"), FactMetaData::valueTypeDouble);
    Fact _pitchRateFact = Fact(0, QStringLiteral("pitchRate"), FactMetaData::valueTypeDouble);
    Fact _yawRateFact = Fact(0, QStringLiteral("yawRate"), FactMetaData::valueTypeDouble);
    Fact _groundSpeedFact = Fact(0, QStringLiteral("groundSpeed"), FactMetaData::valueTypeDouble);
    Fact _airSpeedFact = Fact(0, QStringLiteral("airSpeed"), FactMetaData::valueTypeDouble);
    Fact _airSpeedSetpointFact = Fact(0, QStringLiteral("airSpeedSetpoint"), FactMetaData::valueTypeDouble);
    Fact _climbRateFact = Fact(0, QStringLiteral("climbRate"), FactMetaData::valueTypeDouble);
    Fact _altitudeRelativeFact = Fact(0, QStringLiteral("altitudeRelative"), FactMetaData::valueTypeDouble);
    Fact _altitudeAMSLFact = Fact(0, QStringLiteral("altitudeAMSL"), FactMetaData::valueTypeDouble);
    Fact _altitudeAboveTerrFact = Fact(0, QStringLiteral("altitudeAboveTerr"), FactMetaData::valueTypeDouble);
    Fact _altitudeTuningFact = Fact(0, QStringLiteral("altitudeTuning"), FactMetaData::valueTypeDouble);
    Fact _altitudeTuningSetpointFact = Fact(0, QStringLiteral("altitudeTuningSetpoint"), FactMetaData::valueTypeDouble);
    Fact _xTrackErrorFact = Fact(0, QStringLiteral("xTrackError"), FactMetaData::valueTypeDouble);
    Fact _rangeFinderDistFact = Fact(0, QStringLiteral("rangeFinderDist"), FactMetaData::valueTypeFloat);
    Fact _flightDistanceFact = Fact(0, QStringLiteral("flightDistance"), FactMetaData::valueTypeDouble);
    Fact _flightTimeFact = Fact(0, QStringLiteral("flightTime"), FactMetaData::valueTypeElapsedTimeInSeconds);
    Fact _distanceToHomeFact = Fact(0, QStringLiteral("distanceToHome"), FactMetaData::valueTypeDouble);
    Fact _timeToHomeFact = Fact(0, QStringLiteral("timeToHome"), FactMetaData::valueTypeDouble);
    Fact _missionItemIndexFact = Fact(0, QStringLiteral("missionItemIndex"), FactMetaData::valueTypeUint16);
    Fact _headingToNextWPFact = Fact(0, QStringLiteral("headingToNextWP"), FactMetaData::valueTypeDouble);
    Fact _distanceToNextWPFact = Fact(0, QStringLiteral("distanceToNextWP"), FactMetaData::valueTypeDouble);
    Fact _headingToHomeFact = Fact(0, QStringLiteral("headingToHome"), FactMetaData::valueTypeDouble);
    Fact _distanceToGCSFact = Fact(0, QStringLiteral("distanceToGCS"), FactMetaData::valueTypeDouble);
    Fact _hobbsFact = Fact(0, QStringLiteral("hobbs"), FactMetaData::valueTypeString);
    Fact _throttlePctFact = Fact(0, QStringLiteral("throttlePct"), FactMetaData::valueTypeUint16);
    Fact _imuTempFact = Fact(0, QStringLiteral("imuTemp"), FactMetaData::valueTypeInt16);

    Fact _acu1AngleFact = Fact(0, QStringLiteral("acu1Angle"), FactMetaData::valueTypeDouble);
    Fact _acu1SpeedFact = Fact(0, QStringLiteral("acu1Speed"), FactMetaData::valueTypeDouble);
    Fact _acu1TargetFact = Fact(0, QStringLiteral("acu1Target"), FactMetaData::valueTypeDouble);
    Fact _acu1StatusFact = Fact(0, QStringLiteral("acu1Status"), FactMetaData::valueTypeUint8);
    Fact _acu1ModeFact = Fact(0, QStringLiteral("acu1Mode"), FactMetaData::valueTypeUint8);
    Fact _acu1ValveCmdFact = Fact(0, QStringLiteral("acu1ValveCmd"), FactMetaData::valueTypeDouble);
    Fact _acu1ValveFeedbackFact = Fact(0, QStringLiteral("acu1ValveFeedback"), FactMetaData::valueTypeDouble);

    Fact _acu2AngleFact = Fact(0, QStringLiteral("acu2Angle"), FactMetaData::valueTypeDouble);
    Fact _acu2SpeedFact = Fact(0, QStringLiteral("acu2Speed"), FactMetaData::valueTypeDouble);
    Fact _acu2TargetFact = Fact(0, QStringLiteral("acu2Target"), FactMetaData::valueTypeDouble);
    Fact _acu2StatusFact = Fact(0, QStringLiteral("acu2Status"), FactMetaData::valueTypeUint8);
    Fact _acu2ModeFact = Fact(0, QStringLiteral("acu2Mode"), FactMetaData::valueTypeUint8);
    Fact _acu2ValveCmdFact = Fact(0, QStringLiteral("acu2ValveCmd"), FactMetaData::valueTypeDouble);
    Fact _acu2ValveFeedbackFact = Fact(0, QStringLiteral("acu2ValveFeedback"), FactMetaData::valueTypeDouble);

    Fact _acu3AngleFact = Fact(0, QStringLiteral("acu3Angle"), FactMetaData::valueTypeDouble);
    Fact _acu3SpeedFact = Fact(0, QStringLiteral("acu3Speed"), FactMetaData::valueTypeDouble);
    Fact _acu3TargetFact = Fact(0, QStringLiteral("acu3Target"), FactMetaData::valueTypeDouble);
    Fact _acu3StatusFact = Fact(0, QStringLiteral("acu3Status"), FactMetaData::valueTypeUint8);
    Fact _acu3ModeFact = Fact(0, QStringLiteral("acu3Mode"), FactMetaData::valueTypeUint8);
    Fact _acu3ValveCmdFact = Fact(0, QStringLiteral("acu3ValveCmd"), FactMetaData::valueTypeDouble);
    Fact _acu3ValveFeedbackFact = Fact(0, QStringLiteral("acu3ValveFeedback"), FactMetaData::valueTypeDouble);

    Fact _acu4AngleFact = Fact(0, QStringLiteral("acu4Angle"), FactMetaData::valueTypeDouble);
    Fact _acu4SpeedFact = Fact(0, QStringLiteral("acu4Speed"), FactMetaData::valueTypeDouble);
    Fact _acu4TargetFact = Fact(0, QStringLiteral("acu4Target"), FactMetaData::valueTypeDouble);
    Fact _acu4StatusFact = Fact(0, QStringLiteral("acu4Status"), FactMetaData::valueTypeUint8);
    Fact _acu4ModeFact = Fact(0, QStringLiteral("acu4Mode"), FactMetaData::valueTypeUint8);
    Fact _acu4ValveCmdFact = Fact(0, QStringLiteral("acu4ValveCmd"), FactMetaData::valueTypeDouble);
    Fact _acu4ValveFeedbackFact = Fact(0, QStringLiteral("acu4ValveFeedback"), FactMetaData::valueTypeDouble);

    Fact _acu5AngleFact = Fact(0, QStringLiteral("acu5Angle"), FactMetaData::valueTypeDouble);
    Fact _acu5SpeedFact = Fact(0, QStringLiteral("acu5Speed"), FactMetaData::valueTypeDouble);
    Fact _acu5TargetFact = Fact(0, QStringLiteral("acu5Target"), FactMetaData::valueTypeDouble);
    Fact _acu5StatusFact = Fact(0, QStringLiteral("acu5Status"), FactMetaData::valueTypeUint8);
    Fact _acu5ModeFact = Fact(0, QStringLiteral("acu5Mode"), FactMetaData::valueTypeUint8);
    Fact _acu5ValveCmdFact = Fact(0, QStringLiteral("acu5ValveCmd"), FactMetaData::valueTypeDouble);
    Fact _acu5ValveFeedbackFact = Fact(0, QStringLiteral("acu5ValveFeedback"), FactMetaData::valueTypeDouble);

    Fact _acu6AngleFact = Fact(0, QStringLiteral("acu6Angle"), FactMetaData::valueTypeDouble);
    Fact _acu6SpeedFact = Fact(0, QStringLiteral("acu6Speed"), FactMetaData::valueTypeDouble);
    Fact _acu6TargetFact = Fact(0, QStringLiteral("acu6Target"), FactMetaData::valueTypeDouble);
    Fact _acu6StatusFact = Fact(0, QStringLiteral("acu6Status"), FactMetaData::valueTypeUint8);
    Fact _acu6ModeFact = Fact(0, QStringLiteral("acu6Mode"), FactMetaData::valueTypeUint8);
    Fact _acu6ValveCmdFact = Fact(0, QStringLiteral("acu6ValveCmd"), FactMetaData::valueTypeDouble);
    Fact _acu6ValveFeedbackFact = Fact(0, QStringLiteral("acu6ValveFeedback"), FactMetaData::valueTypeDouble);

    Fact _followingSeasFact = Fact(0, QStringLiteral("followingSeas"), FactMetaData::valueTypeBool);
    Fact _bowHeightFact = Fact(0, QStringLiteral("bowHeight"), FactMetaData::valueTypeDouble);
    Fact _estimatedDisplacementFact = Fact(0, QStringLiteral("estimatedDisplacement"), FactMetaData::valueTypeDouble);
    Fact _controlStateFact = Fact(0, QStringLiteral("controlState"), FactMetaData::valueTypeUint8);
    Fact _controlHealthFact = Fact(0, QStringLiteral("controlHealth"), FactMetaData::valueTypeUint16);
    float _altitudeTuningOffset = qQNaN();

protected:
    bool _altitudeMessageAvailable = false;

private:
    void _handleAttitudeWorker(double rollRadians, double pitchRadians, double yawRadians);

    bool _receivingAttitudeQuaternion = false;
};

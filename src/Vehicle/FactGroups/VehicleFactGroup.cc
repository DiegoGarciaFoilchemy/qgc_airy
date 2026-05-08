/****************************************************************************
 *
 * (c) 2009-2024 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "VehicleFactGroup.h"
#include "Vehicle.h"
#include "QGC.h"

#include <QtGui/QQuaternion>
#include <QtGui/QVector3D>

VehicleFactGroup::VehicleFactGroup(QObject *parent)
    : FactGroup(100, QStringLiteral(":/json/Vehicle/VehicleFact.json"), parent)
{
    _addFact(&_rollFact);
    _addFact(&_pitchFact);
    _addFact(&_headingFact);
    _addFact(&_rollRateFact);
    _addFact(&_pitchRateFact);
    _addFact(&_yawRateFact);
    _addFact(&_groundSpeedFact);
    _addFact(&_airSpeedFact);
    _addFact(&_airSpeedSetpointFact);
    _addFact(&_climbRateFact);
    _addFact(&_altitudeRelativeFact);
    _addFact(&_altitudeAMSLFact);
    _addFact(&_altitudeAboveTerrFact);
    _addFact(&_altitudeTuningFact);
    _addFact(&_altitudeTuningSetpointFact);
    _addFact(&_xTrackErrorFact);
    _addFact(&_rangeFinderDistFact);
    _addFact(&_flightDistanceFact);
    _addFact(&_flightTimeFact);
    _addFact(&_distanceToHomeFact);
    _addFact(&_timeToHomeFact);
    _addFact(&_missionItemIndexFact);
    _addFact(&_headingToNextWPFact);
    _addFact(&_distanceToNextWPFact);
    _addFact(&_headingToHomeFact);
    _addFact(&_distanceToGCSFact);
    _addFact(&_hobbsFact);
    _addFact(&_throttlePctFact);
    _addFact(&_imuTempFact);

    _addFact(&_acu1AngleFact);
    _addFact(&_acu1SpeedFact);
    _addFact(&_acu1TargetFact);
    _addFact(&_acu1StatusFact);
    _addFact(&_acu1ModeFact);
    _addFact(&_acu1ValveCmdFact);
    _addFact(&_acu1ValveFeedbackFact);

    _addFact(&_acu2AngleFact);
    _addFact(&_acu2SpeedFact);
    _addFact(&_acu2TargetFact);
    _addFact(&_acu2StatusFact);
    _addFact(&_acu2ModeFact);
    _addFact(&_acu2ValveCmdFact);
    _addFact(&_acu2ValveFeedbackFact);

    _addFact(&_acu3AngleFact);
    _addFact(&_acu3SpeedFact);
    _addFact(&_acu3TargetFact);
    _addFact(&_acu3StatusFact);
    _addFact(&_acu3ModeFact);
    _addFact(&_acu3ValveCmdFact);
    _addFact(&_acu3ValveFeedbackFact);

    _addFact(&_acu4AngleFact);
    _addFact(&_acu3SpeedFact);
    _addFact(&_acu4TargetFact);
    _addFact(&_acu4StatusFact);
    _addFact(&_acu4ModeFact);
    _addFact(&_acu4ValveCmdFact);
    _addFact(&_acu4ValveFeedbackFact);

    _addFact(&_acu5AngleFact);
    _addFact(&_acu5SpeedFact);
    _addFact(&_acu5TargetFact);
    _addFact(&_acu5StatusFact);
    _addFact(&_acu5ModeFact);
    _addFact(&_acu5ValveCmdFact);
    _addFact(&_acu5ValveFeedbackFact);

    _addFact(&_acu6AngleFact);
    _addFact(&_acu6SpeedFact);
    _addFact(&_acu6TargetFact);
    _addFact(&_acu6StatusFact);
    _addFact(&_acu6ModeFact);
    _addFact(&_acu6ValveCmdFact);
    _addFact(&_acu6ValveFeedbackFact);

    _addFact(&_followingSeasFact);
    _addFact(&_waveStateFact);
    _addFact(&_bowHeightFact);
    _addFact(&_estimatedDisplacementFact);
    _addFact(&_controlModeFact);
    _addFact(&_attitudeStateFact);
    _addFact(&_heaveStateFact);
    _addFact(&_speedStateFact);
    _addFact(&_commStateFact);
    _addFact(&_ballastCommandFact);
    _addFact(&_commandBowSbFact);
    _addFact(&_commandBowPsFact);
    _addFact(&_commandMainSbFact);
    _addFact(&_commandMainPsFact);
    _addFact(&_commandInterSbFact);
    _addFact(&_commandInterPsFact);

    _addFact(&_refillCmdFact);
    _addFact(&_intSbPressureFact);
    _addFact(&_intPsPressureFact);
    _addFact(&_mainSbPressureFact);
    _addFact(&_mainPsPressureFact);
    _addFact(&_bowSbPressureFact);
    _addFact(&_bowPsPressureFact);

    _addFact(&_pitchSpFact);
    _addFact(&_rollSpFact);
    _addFact(&_heaveSpFact);

    _hobbsFact.setRawValue(QStringLiteral("0000:00:00"));
    _followingSeasFact.setRawValue(0);
    _waveStateFact.setRawValue(0);

}

void VehicleFactGroup::handleMessage(Vehicle *vehicle, const mavlink_message_t &message)
{
    switch (message.msgid) {
    case MAVLINK_MSG_ID_BOAT_ATTITUDE:
        _handleAttitude(vehicle, message);
        break;
    // case MAVLINK_MSG_ID_ATTITUDE_QUATERNION:
    //     _handleAttitudeQuaternion(vehicle, message);
    //     break;
    case MAVLINK_MSG_ID_ALTITUDE:
        _handleAltitude(message);
        break;
    case MAVLINK_MSG_ID_VFR_HUD:
        _handleVfrHud(message);
        break;
    case MAVLINK_MSG_ID_NAV_CONTROLLER_OUTPUT:
        _handleNavControllerOutput(message);
        break;
    case MAVLINK_MSG_ID_RAW_IMU:
        _handleRawImuTemp(message);
        break;
    case MAVLINK_MSG_ID_FCB35_ACTUATOR:
        _handleMarsunActuator(message);
        break;
    case MAVLINK_MSG_ID_FCB35_CONTROL_STATE:
        _handleMarsunControlState(message);
        break;
    case MAVLINK_MSG_ID_FCB35_ACCUMULATOR:
        _handleAccumulator(message);
        break;
    case MAVLINK_MSG_ID_BOAT_SPEED:
        _handleBoatSpeed(message);
        break;
    case MAVLINK_MSG_ID_BOAT_SETPOINT:
        _handleBoatSetpoint(message);
        break;
    case MAVLINK_MSG_ID_JOYSTICK:
        _handleJoystick(message);
        break;
#ifndef QGC_NO_ARDUPILOT_DIALECT
    case MAVLINK_MSG_ID_RANGEFINDER:
        _handleRangefinder(message);
        break;
#endif
    default:
        break;
    }
}

void VehicleFactGroup::_handleAttitudeWorker(double rollRadians, double pitchRadians, double yawRadians)
{
    double rollDegrees = QGC::limitAngleToPMPIf(rollRadians);
    double pitchDegrees = QGC::limitAngleToPMPIf(pitchRadians);
    double yawDegrees = QGC::limitAngleToPMPIf(yawRadians);

    rollDegrees = qRadiansToDegrees(rollDegrees);
    pitchDegrees = qRadiansToDegrees(pitchDegrees);
    yawDegrees = qRadiansToDegrees(yawDegrees);

    if (yawDegrees < 0.0) {
        yawDegrees += 360.0;
    }
    // truncate to integer so widget never displays 360
    yawDegrees = trunc(yawDegrees);

    roll()->setRawValue(rollDegrees);
    pitch()->setRawValue(pitchDegrees);
    heading()->setRawValue(yawDegrees);
    // acu1Angle()->setRawValue(rollDegrees);
    // acu2Angle()->setRawValue(pitchDegrees);
    // acu3Angle()->setRawValue(yawDegrees);
    // acu4Angle()->setRawValue(rollDegrees);
    // acu5Angle()->setRawValue(pitchDegrees);
    // acu6Angle()->setRawValue(yawDegrees);
}

void VehicleFactGroup::_handleAttitude(Vehicle *vehicle, const mavlink_message_t &message)
{
    if ((message.sysid != vehicle->id()) || (message.compid != vehicle->compId())) {
        return;
    }


    mavlink_boat_attitude_t attitude{};
    mavlink_msg_boat_attitude_decode(&message, &attitude);

    // _handleAttitudeWorker(attitude.roll, attitude.pitch, attitude.yaw);
    roll()->setRawValue(attitude.roll);
    pitch()->setRawValue(attitude.pitch);
    heading()->setRawValue(attitude.yaw);
    rollRate()->setRawValue(attitude.roll_rate);
    pitchRate()->setRawValue(attitude.pitch_rate);
    yawRate()->setRawValue(attitude.yaw_rate);
    _setTelemetryAvailable(true);
}

void VehicleFactGroup::_handleAltitude(const mavlink_message_t &message)
{
    mavlink_altitude_t altitude{};
    mavlink_msg_altitude_decode(&message, &altitude);

    // Data from ALTITUDE message takes precedence over gps messages
    _altitudeMessageAvailable = true;
    altitudeRelative()->setRawValue(altitude.altitude_relative);
    altitudeAMSL()->setRawValue(altitude.altitude_amsl);

    _setTelemetryAvailable(true);
}

void VehicleFactGroup::_handleAttitudeQuaternion(Vehicle *vehicle, const mavlink_message_t &message)
{
    // only accept the attitude message from the vehicle's flight controller
    if ((message.sysid != vehicle->id()) || (message.compid != vehicle->compId())) {
        return;
    }

    _receivingAttitudeQuaternion = true;

    mavlink_attitude_quaternion_t attitudeQuaternion{};
    mavlink_msg_attitude_quaternion_decode(&message, &attitudeQuaternion);

    QQuaternion quat(attitudeQuaternion.q1, attitudeQuaternion.q2, attitudeQuaternion.q3, attitudeQuaternion.q4);
    QVector3D rates(attitudeQuaternion.rollspeed, attitudeQuaternion.pitchspeed, attitudeQuaternion.yawspeed);
    QQuaternion repr_offset(attitudeQuaternion.repr_offset_q[0], attitudeQuaternion.repr_offset_q[1], attitudeQuaternion.repr_offset_q[2], attitudeQuaternion.repr_offset_q[3]);

    // if repr_offset is valid, rotate attitude and rates
    if (repr_offset.length() >= 0.5f) {
        quat *= repr_offset;
        rates = repr_offset * rates;
    }

    float attRoll, attPitch, attYaw;
    float q[] = { quat.scalar(), quat.x(), quat.y(), quat.z() };
    mavlink_quaternion_to_euler(q, &attRoll, &attPitch, &attYaw);

    _handleAttitudeWorker(attRoll, attPitch, attYaw);

    rollRate()->setRawValue(qRadiansToDegrees(rates[0]));
    pitchRate()->setRawValue(qRadiansToDegrees(rates[1]));
    yawRate()->setRawValue(qRadiansToDegrees(rates[2]));

    _setTelemetryAvailable(true);
}

void VehicleFactGroup::_handleNavControllerOutput(const mavlink_message_t &message)
{
    mavlink_nav_controller_output_t navControllerOutput{};
    mavlink_msg_nav_controller_output_decode(&message, &navControllerOutput);

    altitudeTuningSetpoint()->setRawValue(_altitudeTuningFact.rawValue().toDouble() - navControllerOutput.alt_error);
    xTrackError()->setRawValue(navControllerOutput.xtrack_error);
    airSpeedSetpoint()->setRawValue(_airSpeedFact.rawValue().toDouble() - navControllerOutput.aspd_error);
    distanceToNextWP()->setRawValue(navControllerOutput.wp_dist);

    _setTelemetryAvailable(true);
}

void VehicleFactGroup::_handleVfrHud(const mavlink_message_t &message)
{
    mavlink_vfr_hud_t vfrHud{};
    mavlink_msg_vfr_hud_decode(&message, &vfrHud);

    airSpeed()->setRawValue(qIsNaN(vfrHud.airspeed) ? 0 : vfrHud.airspeed);
    // groundSpeed()->setRawValue(qIsNaN(vfrHud.groundspeed) ? 0 : vfrHud.groundspeed);
    climbRate()->setRawValue(qIsNaN(vfrHud.climb) ? 0 : vfrHud.climb);
    throttlePct()->setRawValue(static_cast<int16_t>(vfrHud.throttle));
    if (qIsNaN(_altitudeTuningOffset)) {
        _altitudeTuningOffset = vfrHud.alt;
    }
    altitudeTuning()->setRawValue(vfrHud.alt - _altitudeTuningOffset);
    if (!qIsNaN(vfrHud.groundspeed) && !qIsNaN(_distanceToHomeFact.cookedValue().toDouble())) {
      timeToHome()->setRawValue(_distanceToHomeFact.cookedValue().toDouble() / vfrHud.groundspeed);
    }

    _setTelemetryAvailable(true);
}

void VehicleFactGroup::_handleRawImuTemp(const mavlink_message_t &message)
{
    mavlink_raw_imu_t imuRaw{};
    mavlink_msg_raw_imu_decode(&message, &imuRaw);

    imuTemp()->setRawValue((imuRaw.temperature == 0) ? 0 : (imuRaw.temperature * 0.01));

    _setTelemetryAvailable(true);
}

void VehicleFactGroup::_handleMarsunActuator(const mavlink_message_t &message)
{
    mavlink_fcb35_actuator_t msg{};
    mavlink_msg_fcb35_actuator_decode(&message, &msg);

    switch(msg.actuator_id) {
        case 0:
            acu1Angle()->setRawValue(msg.position);
            acu1Speed()->setRawValue(msg.speed);
            acu1Target()->setRawValue(msg.target);
            acu1Status()->setRawValue(msg.status);
            acu1Mode()->setRawValue(msg.mode);
            acu1ValveCmd()->setRawValue(msg.valve_cmd * 10);
            acu1ValveFeedback()->setRawValue(msg.valve_feedback);
            break;
        case 1:
            acu2Angle()->setRawValue(msg.position);
            acu2Speed()->setRawValue(msg.speed);
            acu2Target()->setRawValue(msg.target);
            acu2Status()->setRawValue(msg.status);
            acu2Mode()->setRawValue(msg.mode);
            acu2ValveCmd()->setRawValue(msg.valve_cmd * 10);
            acu2ValveFeedback()->setRawValue(msg.valve_feedback);
            break;
        case 2:
            acu3Angle()->setRawValue(msg.position);
            acu3Speed()->setRawValue(msg.speed);
            acu3Target()->setRawValue(msg.target);
            acu3Status()->setRawValue(msg.status);
            acu3Mode()->setRawValue(msg.mode);
            acu3ValveCmd()->setRawValue(msg.valve_cmd * 10);
            acu3ValveFeedback()->setRawValue(msg.valve_feedback);
            break;
        case 3:
            acu4Angle()->setRawValue(msg.position);
            acu4Speed()->setRawValue(msg.speed);
            acu4Target()->setRawValue(msg.target);
            acu4Status()->setRawValue(msg.status);
            acu4Mode()->setRawValue(msg.mode);
            acu4ValveCmd()->setRawValue(msg.valve_cmd * 10);
            acu4ValveFeedback()->setRawValue(msg.valve_feedback);
            break;
        case 4:
            acu5Angle()->setRawValue(msg.position);
            acu5Speed()->setRawValue(msg.speed);
            acu5Target()->setRawValue(msg.target);
            acu5Status()->setRawValue(msg.status);
            acu5Mode()->setRawValue(msg.mode);
            acu5ValveCmd()->setRawValue(msg.valve_cmd * 10);
            acu5ValveFeedback()->setRawValue(msg.valve_feedback);
            break;
        case 5:
            acu6Angle()->setRawValue(msg.position);
            acu6Speed()->setRawValue(msg.speed);
            acu6Target()->setRawValue(msg.target);
            acu6Status()->setRawValue(msg.status);
            acu6Mode()->setRawValue(msg.mode);
            acu6ValveCmd()->setRawValue(msg.valve_cmd * 10);
            acu6ValveFeedback()->setRawValue(msg.valve_feedback);
            break;
        default:
            break;
    }
    _setTelemetryAvailable(true);
}

void VehicleFactGroup::_handleBoatSetpoint(const mavlink_message_t &message)
{
    mavlink_boat_setpoint_t msg{};
    mavlink_msg_boat_setpoint_decode(&message, &msg);

    // TODO: add pitch and roll setpoings
    pitchSp()->setRawValue(msg.pitch_sp);
    rollSp()->setRawValue(msg.roll_sp);
    heaveSp()->setRawValue(msg.heave_sp);
    _setTelemetryAvailable(true);
}

void VehicleFactGroup::_handleJoystick(const mavlink_message_t &message)
{
    mavlink_joystick_t msg{};
    mavlink_msg_joystick_decode(&message, &msg);
    if(msg.z == 0) {
        ballastCommand()->setRawValue(0);
    } else {
        ballastCommand()->setRawValue(1);
    }
    

    _setTelemetryAvailable(true);
}
void VehicleFactGroup::_handleMarsunControlState(const mavlink_message_t &message)
{
    mavlink_fcb35_control_state_t msg{};
    mavlink_msg_fcb35_control_state_decode(&message, &msg);

    bowHeight()->setRawValue(msg.bow_freeboard);
    estimatedDisplacement()->setRawValue(msg.average_freeboard);
    controlMode()->setRawValue(msg.control_mode);
    attitudeState()->setRawValue(msg.attitude_state);
    heaveState()->setRawValue(msg.heave_state);
    speedState()->setRawValue(msg.speed_state);
    // commState()->setRawValue(msg.comm_state);
    // ballastCommand()->setRawValue(msg.ballast_command);
    commandBowSb()->setRawValue(msg.aoa_bow_sb);
    commandBowPs()->setRawValue(msg.aoa_bow_ps);
    commandMainSb()->setRawValue(msg.aoa_main_sb);
    commandMainPs()->setRawValue(msg.aoa_main_ps);
    commandInterSb()->setRawValue(msg.interceptor_sb);
    commandInterPs()->setRawValue(msg.interceptor_ps);
    followingSeas()->setRawValue(msg.following_seas);
    waveState()->setRawValue(msg.wave_state);
    _setTelemetryAvailable(true);
}

void VehicleFactGroup::_handleAccumulator(const mavlink_message_t &message)
{
    mavlink_fcb35_accumulator_t msg{};
    mavlink_msg_fcb35_accumulator_decode(&message, &msg);
    intSbPressure()->setRawValue(msg.pressure[0]);
    intPsPressure()->setRawValue(msg.pressure[1]);
    mainSbPressure()->setRawValue(msg.pressure[2]);
    mainPsPressure()->setRawValue(msg.pressure[3]);
    bowSbPressure()->setRawValue(msg.pressure[4]);
    bowPsPressure()->setRawValue(msg.pressure[5]);
    refillCmd()->setRawValue(msg.filling_command);
    _setTelemetryAvailable(true);
}

void VehicleFactGroup::_handleBoatSpeed(const mavlink_message_t &message)
{
    mavlink_boat_speed_t msg{};
    mavlink_msg_boat_speed_decode(&message, &msg);

    groundSpeed()->setRawValue(msg.control_speed);

    _setTelemetryAvailable(true);
}

#ifndef QGC_NO_ARDUPILOT_DIALECT
void VehicleFactGroup::_handleRangefinder(const mavlink_message_t &message)
{
    mavlink_rangefinder_t rangefinder{};
    mavlink_msg_rangefinder_decode(&message, &rangefinder);

    rangeFinderDist()->setRawValue(qIsNaN(rangefinder.distance) ? 0 : rangefinder.distance);

    _setTelemetryAvailable(true);
}
#endif

# Mission Planning Removal Plan

Status: not started. Mission planning C++ still compiles and is inert.

## Why it is a separate pass

`MockLink` implements the vehicle side of the mission protocol, and `InitialConnectStateMachine` downloads the mission when a vehicle connects. Both use `MissionItem` and `MissionManager` types. Vehicle also keeps mission status facts and the current mission item index.

## Steps

1. Delete `src/MissionManager` and remove `add_subdirectory(MissionManager)` from `src/CMakeLists.txt`.
2. Vehicle:
   - Remove the `MissionManager` include, creation, connections, destructor delete, getter and member.
   - Remove `_missionManagerError`, `_firstMissionLoadComplete`, `_updateHeadingToNextWP`, `_updateMissionItemIndex`.
   - Remove the `MAVLINK_MSG_ID_MISSION_*` routes and the mission facts.
3. `InitialConnectStateMachine`: remove `_stateRequestMission`, its state table entry and `gotProgressUpdate`.
4. `QGCApplication`: remove the include and `MissionManager::registerQmlTypes()`.
5. `QGroundControlQmlGlobal`: remove the `missionCommandTree` property, include, member and initializer.
6. `QGCCorePlugin.h`: forward declare `PlanMasterController` instead of including it.
7. Settings: delete `PlanViewSettings` (files, `SettingsManager` entries, `Settings/CMakeLists.txt`, JSON, qrc).
8. `MockLink`: delete `MockLinkMissionItemHandler`, its member, its constructor call and the public wrappers in `MockLink.h`.
9. `QmlControls`: remove `FlightPathSegment.h` and `FlightPathSegment.cc` from the target. MissionController was the only user.
10. qrc: remove the mission JSON entries from `qgroundcontrol.qrc`.
11. Build, then fix the remaining compile errors one by one.

## Expected result

About 2 MB less binary text and 20,000 fewer lines to maintain.

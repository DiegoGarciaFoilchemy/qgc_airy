# Progress

## What works

- Gerris telemetry pages: `Page1`, `Page3`, `Page4` in `src/FlightDisplay`.
- Gerris fact groups for ACU, BCM, BMS, charger, DCDC, inverter, alarms and warnings.
- Setup pages, parameter editor, link manager, settings.
- MAVLink dialect from the Airy fork.
- Day and night mode buttons.
- English and Spanish.

## Done in the first removal pass

- 3D viewer off: `QGC_VIEWER3D=OFF`, `import Viewer3D` dropped from `FlyView.qml`, 39 3D entries dropped from `qgroundcontrol.qrc`, the 3D icon dropped from `qgcimages.qrc`.
- Korean font dropped: two `NanumGothic` entries removed from `qgcresources.qrc`, the font loading block removed from `QGCApplication.cc`, the Korean branch removed from `ScreenToolsController.cc`.
- Translations limited to Spanish: `QGC_LANGUAGES=es_ES`, the glob replaced in `CMakeLists.txt`, language list trimmed in `AppSettings.cc`, the test-only language block gated behind `QGC_TEST_LANGUAGES`.
- ArduPilot images dropped: ten entries removed from `qgcimages.qrc`.

## Done in the second pass

Follow Me removed:
- `src/FollowMe` deleted.
- `FollowMe::instance()->init()` and the include removed from `QGCApplication.cc`.
- The `sendGCSMotionReport` virtual and its default body removed from `FirmwarePlugin`.
- The ArduPilot override removed from `APMFirmwarePlugin`.

ADSB removed:
- `src/ADSB` deleted.
- The `MAVLINK_MSG_ID_ADSB_VEHICLE` case removed from `Vehicle.cc`.
- The `adsbVehicleManager` property removed from `QGroundControlQmlGlobal`.
- `ADSBVehicleManagerSettings` and its settings group deleted.
- The ADSB Server settings page removed.
- The `ADSB` pronunciation entry removed from `AudioOutput`.

Analyze tools stay. They were removed by mistake and restored from git. The `AnalyzeView` module, the `Charts` Qt module, the MAVLink console, the log download page and the inspector are back in the build.

## Maps were still running at startup

Discovery on 2026-11-13:

- `MainWindow.qml` created `PlanView` with `visible: false`.
- `PlanView.qml` created a real `FlightMap`, which is a Qt Location `Map` with the QGroundControl plugin.
- The hidden map opened the tile cache at `~/.cache/QGCMapCache300/qgcMapCache.db` and requested 16 tiles.
- The default provider is Bing, map type Hybrid.
- An 18 second offscreen run wrote 1.7 MB into the cache directory.

Fix:

- Removed the `PlanView` element from `MainWindow.qml`.
- Removed `showPlanView()`, the `planView` lines in `showFlyView()`, and the unsaved-mission close check.
- Removed `PlanView.qml` from the `QmlControls` module and deleted the file.

Test after the fix, same 18 second offscreen run with a fresh home directory:

- No `QGeoServiceProviderFactoryQGC` line.
- No `QGCMapCache300` directory.
- Zero tile requests.

The `QGCCacheWorker` thread starts only when a map uses it, so it stays idle now.

Still present: the `FlightMap` QML module, the `QGCLocation` Qt plugin, the Qt Location and Qt Positioning libraries, and the Maps settings page. They are linked but idle.


- Binary file: 196.0 MB to 193.6 MB.
- Binary text: 25.09 MB to 24.97 MB.
- `ADSBVehicleManager` and `FollowMe` symbols: zero in the binary.
- Build: 644 tasks, exit code 0, zero errors.
- Smoke test: 20 seconds offscreen, no QML errors.


- Binary file: 221.8 MB to 196.0 MB. Saving 25.8 MB.
- Binary text: 45.9 MB to 25.1 MB. Saving 20.8 MB, about 45 percent.
- Linked Qt libraries: 103 MB to 92 MB.
- Packed resources: 27.6 MB to 6.8 MB.
- `qrc_qgcresources` blob: 10.0 MB to 1.81 MB.
- `qrc_qgroundcontrol` blob: 9.06 MB to 0.17 MB.
- `qrc_qgcimages` blob: 5.36 MB to 4.71 MB.
- Translations blob: 3.19 MB to 0.12 MB. Two Spanish files remain.
- Qt Quick3D and Qt ShaderTools are no longer linked.
- Build: zero errors, zero warnings.
- Smoke test: the application ran 20 seconds with `QT_QPA_PLATFORM=offscreen` and reported no QML errors. The only message was the pre-existing `Could not attach Keys property` warning.

## Vehicle clock from a unit without internet access

Report: the unit has no internet access, so the system clock is wrong, and the vehicle receives a wrong timestamp. The autopilot takes correct time from GPS.

Finding: QGC has no TIMESYNC handling in this tree. The only time it sends is `SYSTEM_TIME` (id 2) from `Vehicle::_sendQGCTimeToVehicle()`. `_parametersReady` calls it twice, with `QDateTime::currentMSecsSinceEpoch()` from the personal computer clock.

Fix:

- New `MavlinkSettings` fact `sendSystemTimeToVehicle`, default false. It appears in Application Settings, Telemetry page, group "Time".
- `_sendQGCTimeToVehicle` returns early when the fact is off.
- When the fact is on, a clock before 2022-01-01 is refused with a warning, because such a date is certainly wrong.

ArduPilot accepts a ground station time only when `RTC_TYPES` allows the MAVLink source (default allows GPS only), the vehicle is disarmed, and the new time is later than the current time. The default parameter set already ignores the message, but a changed parameter makes the vehicle follow the ground station clock.

Side effect to know: telemetry log names and the clock display still use the personal computer clock. Correct the clock at boot (fake-hwclock or the GPS feed) to fix the names.

Test: build exit code 0, offscreen run clean.


## Application clock from vehicle GPS

Goal: on units without internet access, QGC uses the GPS time from the vehicle for its own clock, log names and log timestamps. Opt in, because most units have a correct clock.

Implementation: new `QGCClock` in `src/Utilities`. One clock for the whole application.

- `QGCClock::currentMSecsSinceEpoch()` returns the personal computer time plus an offset learned from the vehicle.
- `Vehicle::_handleGpsRawInt` feeds the clock when `fix_type >= GPS_FIX_TYPE_3D_FIX` and `time_usec != 0`. This is the preferred source.
- `Vehicle::_handleSystemTime` feeds the clock from the vehicle `SYSTEM_TIME` message, but only until a GPS time arrives. The vehicle clock can be wrong.
- `QGCApplication::init` calls `QGCClock::instance()->init()` after `SettingsManager::instance()->init()`.
- Setting `useVehicleTimeForClock` in `MavlinkSettings`, default false, shown in Application Settings, Telemetry page, group Time.

Uses of the clock: `VehicleClockFactGroup` (local, UTC and date), temporary telemetry log timestamps, saved telemetry log names, CSV log names and rows, downloaded vehicle log names.

Not changed: console log lines use process time. Flight Data replay compares log time against its own start time, so replay pacing is unaffected.

Behavior: the computer clock is used until a GPS fix arrives. With the setting off, every path behaves as before. Times before 2022-01-01 are rejected.

Test: build exit code 0. Offscreen runs with a profile that sets the fact print "Use vehicle time true", a fresh profile prints "Use vehicle time false".



## RAM disk fill on the write protected unit

Report: after a few hours the application slows and blocks. The machine is write protected, so every file lands on a RAM disk.

Cause found: the temporary MAVLink telemetry log had no size cap. `MAVLinkProtocol::_startLogging()` opens `FlightDataXXXXXX.mavlink` in `QStandardPaths::TempLocation` on the first heartbeat and writes every received and sent message. Nothing closed or trimmed it while a link stayed open, so a session wrote tens of megabytes per hour until the RAM disk was full. A full disk makes the write fail, which shows a modal message and suspends logging. It also breaks settings and parameter writes.

Second cause: at disconnect the temp file moved into the telemetry folder with the default `telemetrySave = true`, and nothing pruned the folder. Each flight added a full log.

Fixes:

- `MAVLinkProtocol` rotates the temp log at 16 MB, saves or deletes it per the settings and opens a new one. Constants: `kMaxTempLogSize`, `kMaxSavedTelemetryLogsSize`.
- Saved telemetry logs are pruned to 64 MB total, newest first, in `_pruneTelemetryLogs`.
- `telemetrySave = false` now prevents the temp log on every platform. The check was mobile only, so the desktop always wrote a temp log.
- `QGCLogging` caps: 2 MB per file, 2 backups, 5000 rows in memory, 5000 pending lines. Before: 10 MB, 5 backups and 104857 rows.

Diagnostic script: `tools/diag_ramdisk.sh`. It prints tmpfs usage, resident memory, folder sizes, temp and saved logs, and files changed in the last five minutes.

Not found: no other writer grows without a bound during normal operation. Log download, firmware flash, geotag, parameter export and file download run on user action. Component info and parameter caches are bounded.

Test: build exit code 0, offscreen run with no error.


## Remote ID and system position source

Done on 2026-11-13:

- Remote ID removed: `RemoteIDManager`, `RemoteIDSettings` and its group, the settings page, the indicator page, the QML registration and the `Vehicle` member and message route.
- The system position source is disabled. `QGCPositionManager::_setupPositionSources()` no longer calls `QGeoPositionInfoSource::createDefaultSource`, so no geoclue or D-Bus position backend opens at launch. The plugin source hook and the NMEA input remain.
- Effect to know: the automatic home point from ground station position now only runs when an NMEA source provides a position. Otherwise it does nothing.

Test: build 439 tasks, exit code 0. No `RemoteIDManager` or `RemoteIDSettings` symbol in the binary. Offscreen run reports no error.

Binary: 157.89 MB to 156.90 MB. Text: 20.35 MB to 20.28 MB.

Kept because the crew uses them: Mock Link and PX4 log transfer.


## Quick wins

Done on 2026-11-13:

- Version check disabled. `QGCCorePlugin::stableVersionCheckFileUrl()` returns an empty string, so no HTTPS request runs at launch. The `QGC.version.txt` string is gone from the binary.
- Plan View settings page removed from the settings model, from the `AppSettings` module and from the tree. `PlanViewSettings` C++ still exists for now.
- First run prompts return an empty list, so no prompt dialog opens on a new profile.
- The toolbar was left untouched. The live bar uses `FlightModeIndicator` and `MainStatusIndicator` from `QmlControls`, and only `FlyViewToolBarIndicators` imports `QGroundControl.Toolbar`, with that import commented out.

Test: build 64 tasks, exit code 0. Offscreen run reports no error. Binary 157.92 MB to 157.89 MB, so the gain is behavioral, not size.

Still running in the background: component information download on connect, ground station position source, Remote ID, PX4 log transfer, Mock Link.


## Audio alerts removal

Removed on 2026-11-13:

- `src/Utilities/Audio` (`AudioOutput`).
- Every `_say` call in `Vehicle` and `VehicleLinkManager`.
- The `audioMuted` application setting and its checkbox.
- The `/res/audio` resource and `resources/audio`.
- Qt TextToSpeech from the build. Qt Multimedia went with it, because TextToSpeech was its only consumer.

Test: build 282 tasks, exit code 0. `ldd` shows no TextToSpeech and no Multimedia. Normal offscreen run reports no error.

Binary after this step: 158.7 MB to 157.9 MB. Text: 20.45 MB to 20.36 MB.

Mission planning is not removed. See `mission-removal-plan.md`.


## Video, joystick, camera and gimbal removal

Removed on 2026-11-13:

- Video: `src/VideoManager`, `VideoSettings`, the Video settings page, `videoManager` from the QML global, the video API hooks in `QGCCorePlugin`, Qt Multimedia from the build, and the UVC and streaming options.
- Joystick: `src/Joystick`, SDL2 and the gamecontrollerdb resource, `JoystickManager`, `JoystickConfigController` and its five QML pages.
- Camera: `src/Camera`, `CameraMetaData`, the camera manager in `Vehicle`, the camera message handlers, `triggerSimpleCamera`, and the camera list.
- Gimbal: `src/Gimbal`, `GimbalController` in `Vehicle`, `GimbalControllerSettings`, and the gimbal registration.
- The camera calculator in mission planning falls back to the custom camera.

Kept: Qt TextToSpeech for audio alerts. Qt Multimedia stays linked only because TextToSpeech depends on it.

Test after the removal: build 5 tasks, exit code 0. The binary holds no `QGCCameraManager`, `GimbalController`, `JoystickManager` or `VideoManager` symbol. The MAVLink inspector is still present. The 15 second offscreen run reported no error and created no map cache.


## Full map stack removal

Removed on 2026-11-13:

- `src/Terrain` and `src/QtLocationPlugin`.
- Qt Location from `find_package`, from the link list, and the geoservices plugin import.
- Terrain queries in `VisualMissionItem`, `FlightPathSegment`, `Vehicle` and `TransectStyleComplexItem`.
- Terrain values stay neutral: mission item terrain altitude is NaN, altitude above terrain is NaN, and home is set with altitude 0.

`TransectStyleComplexItem` now uses a local `TransectPathHeightInfo` struct in place of the terrain query type, so the survey math compiles with empty height lists.

Kept on purpose: Qt Positioning. `QGeoCoordinate` carries every vehicle position and appears in 129 files.

Test after the removal, 18 seconds offscreen with a fresh home directory and location logging on:

- No `QGCMapCache300` directory.
- Zero tile requests.
- No geoservices provider.
- The `.cache` directory holds only QML bytecode.

Binary: 190.6 MB to 175.8 MB. Text: 24.57 MB to 23.56 MB. Qt Location and Qt PositioningQuick are no longer linked.

Mission planning C++ (`src/MissionManager`) still compiles. Its map and terrain inputs are gone, and its editor QML is deleted. It is inert and can be removed in a later pass.


Removed on 2026-11-13:

- `PlanView`, its sixteen map and mission editor QML files, and the map edits in `MainWindow.qml`.
- Map settings classes and groups: `FlightMapSettings`, `MapsSettings`, `OfflineMapsSettings`, and the Maps settings page.
- The `mapEngineManager` property from the `QGroundControl` singleton, so the tile engine object is never built.
- The `FlightMap` module now holds only the six Gerris widgets: `FoilAngle`, `RudderDeploy`, `VesselPitch`, `VesselPower`, `VesselRoll`, `VesselSpeed`.
- 41 map images. Four stay because the Gerris pages use them: `boat_rear.svg`, `boat_side.svg`, `foil.svg`, `vesselOutline.svg`.

Kept on purpose: `src/QtLocationPlugin` and Qt Location. `src/Terrain` uses the plugin map reply class and Qt Location private headers. Terrain drives mission altitude and vehicle home altitude. The plugin stays inert because no `Map` item exists.

Terrain setting reads are replaced with constants: provider `Copernicus`, disk cache 1024 MB, memory cache 128 MB.

Test, 18 seconds offscreen with a fresh home directory and location logging on: no geoservices provider, no `QGCMapCache300` directory, zero tile requests. The `.cache` directory holds only QML bytecode.

Binary: 193.6 MB to 190.6 MB. Text: 24.97 MB to 24.57 MB.


## Next steps

- Rebuild and confirm the application starts.
- Remove video: `QGC_ENABLE_UVC=OFF`, drop `VideoManager` sources and the video settings page.
- Remove the analyze tools: `QGC_DISABLE_MAVLINK_INSPECTOR=ON`, then the pages and the advanced tool entry.
- Remove ADSB, Follow Me, joystick, camera and gimbal.
- Plan the map removal, then the mission planning removal. Both are large.

## Known issues

- Maps and mission planning still build and still ship. `PlanView.qml` (1,180 lines) is still in the `QmlControls` module.
- The `Maps`, `Plan View` and `ADSB Server` settings pages still show.
- The `test` directory (26 MB) and the `docs` directory (24 MB) stay in the repository, but they do not build.
- Translations other than Spanish stay in `translations/` (29 MB) but do not build.

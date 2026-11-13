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

## Measured result of the first pass

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

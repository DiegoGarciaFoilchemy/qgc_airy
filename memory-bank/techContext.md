# Tech Context

## Toolchain

- C++20, Qt 6.8.3, CMake 4.3.1, Ninja.
- Compiler flags: `CMAKE_CXX_STANDARD 20`, `CMAKE_AUTOMOC ON`.
- Precompiled headers: `QtCore/QLoggingCategory`, `QObject`, `QString`, `QTimer`.
- QML modules are static. They need `NO_PLUGIN` on Qt 6.6.3.

## Build commands

Configure and build:

    cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Debug
    cmake --build build -j8

Run:

    ./build/Debug/QGroundControl

## Dependencies

CPM downloads the dependencies into `build/cpm_modules`: mavlink, libevents, px4-gpsdrivers, sdl2, sdl_gamecontrollerdb, shapelib, ulog_cpp, xz-embedded, zlib, geographiclib.

The MAVLink dialect comes from `git@github.com:DiegoGarciaFoilchemy/mavlinkAiry_C.git`, tag `dde34031be8c6af3f73df545d495c74c56242e43`.

## Current build options

- `QGC_DISABLE_APM_PLUGIN=ON`, `QGC_DISABLE_APM_PLUGIN_FACTORY=ON`, `QGC_DISABLE_APM_MAVLINK=ON`.
- `QGC_DISABLE_PX4_PLUGIN=OFF`. The PX4 plugin is the only firmware plugin.
- `QGC_VIEWER3D=OFF` since this change.
- `QGC_UTM_ADAPTER=OFF`, `QGC_ENABLE_BLUETOOTH=OFF`, `QGC_ENABLE_GST_VIDEOSTREAMING=OFF`, `QGC_ENABLE_QT_VIDEOSTREAMING=OFF`.
- `QGC_ENABLE_UVC=ON`, `QGC_NO_SERIAL_LINK=OFF`.
- `QGC_LANGUAGES=es_ES`. Only Spanish is compiled. English is built in.
- Testing is forced off: `BUILD_TESTING OFF` and the test directory is not added.

## Measured footprint

Debug build on 2026-11-13, before the first removal pass: binary 221.8 MB, binary text 45.9 MB, linked Qt libraries 103 MB. Packed resources were 27.6 MB of the text.

## Constraints

- No Wayland. Run with `QT_QPA_PLATFORM=xcb` if the session defaults to Wayland.
- The PX4 plugin must stay while the ArduPilot plugin is disabled.

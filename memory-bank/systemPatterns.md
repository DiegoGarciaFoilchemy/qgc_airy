# System Patterns

## Build system

- CMake with Ninja. Qt 6.8.3 at `/home/diego/Qt/6.8.3/gcc_64`.
- Options live in `cmake/CustomOptions.cmake`.
- Each source directory adds files to one target, `${CMAKE_PROJECT_NAME}`.
- QML lives in static QML modules that `qt_add_qml_module` creates.
- The main window is `src/UI/MainWindow.qml`. It loads `FlyView` and a `PlanView` stub.

## Removal pattern

QGroundControl already shows the pattern for disabled features. A CMake option returns early from the module `CMakeLists.txt`. The rest of the code uses `#ifdef` guards. The ArduPilot plugin uses this pattern.

Full removal needs three edits:
1. Turn the option off or drop the sources from `CMakeLists.txt`.
2. Remove the QML and the resource entries.
3. Remove the call sites in `QGCApplication.cc` and `SettingsManager.cc`.

## Resource packing

Three qrc files ship inside the binary: `qgcresources.qrc` (fonts, audio, calibration), `qgcimages.qrc` (icons) and `qgroundcontrol.qrc` (JSON metadata, QML, 3D meshes).

Resources are most of the binary. The packed blobs are about 27.6 MB of 45.9 MB of binary text.

## Vehicle coupling

`Vehicle` owns `MissionManager`, `CameraManager`, `GimbalController`, `TrajectoryPoints` and the parameter manager. Removing mission planning touches `Vehicle.cc` in 13 places.

## Fact groups

Gerris data arrives as custom fact groups under `src/Vehicle/FactGroups`, for example `VehicleGerrisBcmFactGroup` and `VehicleGerrisBmsFactGroup`. The pages bind to them through `vehicle.<group>.<fact>`.

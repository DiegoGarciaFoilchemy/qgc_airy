qt_add_library(FlightMapModule STATIC)

qt_add_qml_module(FlightMapModule
    URI QGroundControl.FlightMap
    VERSION 1.0
    RESOURCE_PREFIX /qml
    QML_FILES
        Widgets/FoilAngle.qml
        Widgets/RudderDeploy.qml
        Widgets/VesselPitch.qml
        Widgets/VesselPower.qml
        Widgets/VesselRoll.qml
        Widgets/VesselSpeed.qml

    NO_PLUGIN # Required by Qt 6.6.3. TODO: Remove when no longer supported.
)

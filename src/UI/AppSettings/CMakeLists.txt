qt_add_library(AppSettingsModule STATIC)

qt_add_qml_module(AppSettingsModule
    URI QGroundControl.AppSettings
    VERSION 1.0
    RESOURCE_PREFIX /qml
    QML_FILES
        BluetoothSettings.qml
        DebugWindow.qml
        FlyViewSettings.qml
        GeneralSettings.qml
        HelpSettings.qml
        LinkSettings.qml
        LogReplaySettings.qml
        MockLink.qml
        MockLinkSettings.qml
        PX4LogTransferSettings.qml
        SerialSettings.qml
        SettingsPage.qml
        SettingsPagesModel.qml
        TcpSettings.qml
        TelemetrySettings.qml
        UdpSettings.qml
    NO_PLUGIN # Required by Qt 6.6.3. TODO: Remove when no longer supported.
)

target_sources(${CMAKE_PROJECT_NAME}
    PRIVATE
        AppSettings.cc
        AppSettings.h
        AutoConnectSettings.cc
        AutoConnectSettings.h
        BatteryIndicatorSettings.cc
        BatteryIndicatorSettings.h
        BrandImageSettings.cc
        BrandImageSettings.h
        MavlinkActionsSettings.cc
        MavlinkActionsSettings.h
        FirmwareUpgradeSettings.cc
        FirmwareUpgradeSettings.h
        FlightModeSettings.cc
        FlightModeSettings.h
        FlyViewSettings.cc
        FlyViewSettings.h
        MavlinkSettings.cc
        MavlinkSettings.h
        PlanViewSettings.cc
        PlanViewSettings.h
        RTKSettings.cc
        RTKSettings.h
        SettingsGroup.cc
        SettingsGroup.h
        SettingsManager.cc
        SettingsManager.h
        UnitsSettings.cc
        UnitsSettings.h
        Viewer3DSettings.cc
        Viewer3DSettings.h
)

if(NOT QGC_DISABLE_APM_MAVLINK)
    target_sources(${CMAKE_PROJECT_NAME}
        PRIVATE
            APMMavlinkStreamRateSettings.cc
            APMMavlinkStreamRateSettings.h
    )
endif()

target_include_directories(${CMAKE_PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})

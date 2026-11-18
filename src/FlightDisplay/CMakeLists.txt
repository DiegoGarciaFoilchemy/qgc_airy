qt_add_library(FlightDisplayModule STATIC)

# Boat selection. Each boat has its own FlyView.qml and page set in a
# subdirectory. Switch with: cmake -DQGC_BOAT=AIRY and recompile.
set(QGC_BOAT "GERRIS" CACHE STRING "Boat display set to build: GERRIS or AIRY")
set_property(CACHE QGC_BOAT PROPERTY STRINGS GERRIS AIRY)

if(QGC_BOAT STREQUAL "AIRY")
    set(_qgc_boat_dir "Airy")
else()
    set(_qgc_boat_dir "Gerris")
endif()
message(STATUS "FlightDisplay boat pages: ${_qgc_boat_dir} (QGC_BOAT=${QGC_BOAT})")

set(_qgc_boat_qml_files
    ${_qgc_boat_dir}/FlyView.qml
    ${_qgc_boat_dir}/Page1.qml
    ${_qgc_boat_dir}/Page3.qml
    ${_qgc_boat_dir}/Page4.qml
)

# Flatten the boat files to the module root so the QML types keep their
# original names (FlyView, Page1, Page3, Page4) regardless of boat.
foreach(_qml_file IN LISTS _qgc_boat_qml_files)
    get_filename_component(_qml_name "${_qml_file}" NAME)
    set_source_files_properties(${_qml_file} PROPERTIES QT_RESOURCE_ALIAS "${_qml_name}")
endforeach()

qt_add_qml_module(FlightDisplayModule
    URI QGroundControl.FlightDisplay
    VERSION 1.0
    RESOURCE_PREFIX /qml
    QML_FILES
        ${_qgc_boat_qml_files}
        Page2.qml
        Page5.qml
        # FlyViewAdditionalActionsButton.qml
        # FlyViewAdditionalActionsList.qml
        # FlyViewAdditionalActionsPanel.qml
        # FlyViewAdditionalCustomActionsList.qml
        # FlyViewBottomRightRowLayout.qml
        # FlyViewCustomLayer.qml
        # FlyViewInsetViewer.qml
        # FlyViewInstrumentPanel.qml
        # FlyViewMap.qml
        # FlyViewMissionCompleteDialog.qml
        # FlyViewPreFlightChecklistPopup.qml
        # FlyViewToolStrip.qml
        # FlyViewToolStripActionList.qml
        # FlyViewTopRightColumnLayout.qml
        # FlyViewTopRightPanel.qml
        # FlyViewVideo.qml
        # FlyViewWidgetLayer.qml
        # GripperMenu.qml
        # GuidedActionConfirm.qml
        # GuidedActionGripper.qml
        # GuidedActionLand.qml
        # GuidedActionPause.qml
        # GuidedActionRTL.qml
        # GuidedActionsController.qml
        # GuidedActionTakeoff.qml
        # GuidedToolStripAction.qml
        # GuidedValueSlider.qml
        # MultiRotorChecklist.qml
        # MultiVehicleList.qml
        # ObstacleDistanceOverlay.qml
        # ObstacleDistanceOverlayMap.qml
        # ObstacleDistanceOverlayVideo.qml
        # OnScreenGimbalController.qml
        # PreFlightBatteryCheck.qml
        # PreFlightCheckList.qml
        # PreFlightCheckListShowAction.qml
        # PreFlightGPSCheck.qml
        # PreFlightRCCheck.qml
        # PreFlightSensorsHealthCheck.qml
        # PreFlightSoundCheck.qml
        # ProximityRadarValues.qml
        # ProximityRadarVideoView.qml
        # QGCVideoBackground.qml
        # RoverChecklist.qml
        # SubChecklist.qml
        # TelemetryValuesBar.qml
        # TerrainProgress.qml
        # VehicleWarnings.qml
        # VirtualJoystick.qml
    NO_PLUGIN # Required by Qt 6.6.3. TODO: Remove when no longer supported.
)

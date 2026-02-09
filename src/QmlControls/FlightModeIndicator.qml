/****************************************************************************
 *
 * (c) 2009-2022 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import QGroundControl
import QGroundControl.Controls
import QGroundControl.MultiVehicleManager
import QGroundControl.ScreenTools
import QGroundControl.Palette
import QGroundControl.FactSystem
import QGroundControl.FactControls
import QGroundControl.AutoPilotPlugin

Item {
    id:         control
    // spacing:    0
    property bool   showIndicator:          true
    property var    expandedPageComponent
    property bool   waitForParameters:      false

    property real fontPointSize:    ScreenTools.largeFontPointSize
    property var  activeVehicle:    QGroundControl.multiVehicleManager.activeVehicle
    property bool allowEditMode:    true
    property bool editMode:         false

    // Flight mode colors
    property color colorHighSpeed:  Qt.rgba(1.0, 0.42, 0.0, 0.3)      // orange-red
    property color colorLowSpeed:   Qt.rgba(0.204, 0.596, 0.859, 0.3)  // blue
    property color colorTesting:    Qt.rgba(0.953, 0.612, 0.071, 0.3)  // amber
    property color colorApproach:   Qt.rgba(0.153, 0.682, 0.376, 0.3)  // green

    function getModeColor(modeName) {
        if (modeName.toLowerCase().includes("high speed")) {
            return colorHighSpeed
        } else if (modeName.toLowerCase().includes("low speed")) {
            return colorLowSpeed
        } else if (modeName.toLowerCase().includes("debug")) {
            return colorTesting
        } else if (modeName.toLowerCase().includes("approach")) {
            return colorApproach
        }
        return '#ffffff' // default gray
    }

    property color displayColor: activeVehicle ? getModeColor(activeVehicle.flightMode) : "#ffffff"
    
    function showFlightModeDrawer() {
        mainWindow.showIndicatorDrawer(drawerComponent, control)
    }
    
    Item {
        Layout.fillWidth: true
        Layout.preferredHeight: ScreenTools.defaultFontPixelHeight * 8

        QGCLabel {
            text:                   qsTr("Mode")
            font.pointSize:         fontPointSize
            // anchors.centerIn:       parent
            anchors.horizontalCenterOffset: -90
            // anchors.horizontalCenterOffset: -ScreenTools.defaultFontPixelWidth * 1.5
            // horizontalAlignment:    Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -25
            // rotation:               -90
            // MouseArea {
            //     anchors.fill:   parent
            //     onClicked:      mainWindow.showIndicatorDrawer(drawerComponent, control)
            // }
        }

        QGCLabel {
            text:                   activeVehicle ? activeVehicle.flightMode : qsTr("N/A", "No data to display")
            font.pointSize:         fontPointSize
            // anchors.centerIn:       parent
            anchors.horizontalCenterOffset: -90
            // anchors.horizontalCenterOffset: ScreenTools.defaultFontPixelWidth * 1.5
            // horizontalAlignment:    Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 25
            visible:                activeVehicle
            // rotation:               -90
            // MouseArea {
            //     anchors.fill:   parent
            //     onClicked:      mainWindow.showIndicatorDrawer(drawerComponent, control)
            // }
        }
        
    }

    Component {
        id: drawerComponent

        ToolIndicatorPage {
            showExpand:         false
            waitForParameters:  control.waitForParameters

            contentComponent:    flightModeContentComponent
            expandedComponent:   flightModeExpandedComponent

            onExpandedChanged: {
                if (!expanded) {
                    editMode = false
                }
            }
        }
    }

    Component {
        id: flightModeContentComponent

        ColumnLayout {
            id:         modeColumn
            spacing:    ScreenTools.defaultFontPixelWidth / 2

            property var    activeVehicle:            QGroundControl.multiVehicleManager.activeVehicle
            property var    flightModeSettings:       QGroundControl.settingsManager.flightModeSettings
            property var    hiddenFlightModesFact:    null
            property var    hiddenFlightModesList:    [] 

            Component.onCompleted: {
                // Hidden flight modes are classified by firmware and vehicle class
                var hiddenFlightModesPropPrefix
                if (activeVehicle.px4Firmware) {
                    hiddenFlightModesPropPrefix = "px4HiddenFlightModes"
                } else if (activeVehicle.apmFirmware) {
                    hiddenFlightModesPropPrefix = "apmHiddenFlightModes"
                } else {
                    control.allowEditMode = false
                }
                if (control.allowEditMode) {
                    var hiddenFlightModesProp = hiddenFlightModesPropPrefix + activeVehicle.vehicleClassInternalName()
                    if (flightModeSettings.hasOwnProperty(hiddenFlightModesProp)) {
                        hiddenFlightModesFact = flightModeSettings[hiddenFlightModesProp]
                        // Split string into list of flight modes
                        if (hiddenFlightModesFact && hiddenFlightModesFact.value !== "") {
                            hiddenFlightModesList = hiddenFlightModesFact.value.split(",")
                        }
                    } else {
                        control.allowEditMode = false
                    }
                }
                hiddenModesLabel.calcVisible()
            }

            Connections {
                target: control
                onEditModeChanged: {
                    if (editMode) {
                        for (var i=0; i<modeRepeater.count; i++) {
                            var button      = modeRepeater.itemAt(i).children[0]
                            var checkBox    = modeRepeater.itemAt(i).children[1]

                            checkBox.checked = !hiddenFlightModesList.find(item => { return item === button.text } )
                        }
                    }
                }
            }

            Repeater {
                id:     modeRepeater
                model:  activeVehicle ? activeVehicle.flightModes : []

                RowLayout {
                    spacing: ScreenTools.defaultFontPixelWidth
                    visible: editMode || !hiddenFlightModesList.find(item => { return item === modelData } )

                    QGCButton {
                        id:                 modeButton
                        text:               modelData
                        Layout.fillWidth:   true

                        onClicked: {
                                console.log("Flight Mode:", modelData);
                                _activeVehicle.setFlightMode(modelData);
                                mainWindow.closeIndicatorDrawer()
                        }
                    }

                    QGCCheckBoxSlider {
                        visible: editMode

                        onClicked: {
                            hiddenFlightModesList = []
                            for (var i=0; i<modeRepeater.count; i++) {
                                var checkBox = modeRepeater.itemAt(i).children[1]
                                if (!checkBox.checked) {
                                    hiddenFlightModesList.push(modeRepeater.model[i])
                                }
                            }
                            hiddenFlightModesFact.value = hiddenFlightModesList.join(",")
                            hiddenModesLabel.calcVisible()
                        }
                    }
                }
            }

            QGCLabel {
                id:                     hiddenModesLabel
                text:                   qsTr("Some Modes Hidden")
                Layout.fillWidth:       true
                font.pointSize:         ScreenTools.smallFontPointSize
                horizontalAlignment:    Text.AlignHCenter
                visible:                false

                function calcVisible() {
                    hiddenModesLabel.visible = hiddenFlightModesList.length > 0
                }
            }
        }
    }

    Component {
        id: flightModeExpandedComponent

        ColumnLayout {
            Layout.preferredWidth:  ScreenTools.defaultFontPixelWidth * 60
            spacing:                margins / 2

            property var  qgcPal:   QGroundControl.globalPalette
            property real margins:  ScreenTools.defaultFontPixelHeight

            Loader {
                sourceComponent: expandedPageComponent
            }

            SettingsGroupLayout {
                Layout.fillWidth:  true

                RowLayout {
                    Layout.fillWidth:   true
                    enabled:            control.allowEditMode

                    QGCLabel {
                        Layout.fillWidth:   true
                        text:               qsTr("Edit Displayed Flight Modes")
                    }

                    QGCCheckBoxSlider {
                        onClicked: control.editMode = checked
                    }
                }

                LabelledButton {
                    Layout.fillWidth:   true
                    label:              qsTr("Flight Modes")
                    buttonText:         qsTr("Configure")
                    visible:            _activeVehicle.autopilotPlugin.knownVehicleComponentAvailable(AutoPilotPlugin.KnownFlightModesVehicleComponent) &&
                                            QGroundControl.corePlugin.showAdvancedUI

                    onClicked: {
                        mainWindow.showKnownVehicleComponentConfigPage(AutoPilotPlugin.KnownFlightModesVehicleComponent)
                        mainWindow.closeIndicatorDrawer()
                    }
                }
            }
        }
    }
}

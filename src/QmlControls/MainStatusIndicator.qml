/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
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

RowLayout {
    id:         control
    spacing:    useFixedPixels ? fixedSpacingPx : ScreenTools.defaultFontPixelWidth

    property var    _activeVehicle:     QGroundControl.multiVehicleManager.activeVehicle
    property var    _vehicleInAir:      _activeVehicle ? _activeVehicle.flying || _activeVehicle.landing : false
    property bool   _vtolInFWDFlight:   _activeVehicle ? _activeVehicle.vtolInFwdFlight : false
    property bool   _armed:             _activeVehicle ? _activeVehicle.armed : false
    property bool   useFixedPixels:     false
    property real   fixedSpacingPx:     6
    property real   fixedMainLabelPixelSize: 26
    property real   _margins:           useFixedPixels ? fixedSpacingPx : ScreenTools.defaultFontPixelWidth
    property real   _spacing:           useFixedPixels ? (fixedSpacingPx / 2) : (ScreenTools.defaultFontPixelWidth / 2)
    property bool   _healthAndArmingChecksSupported: _activeVehicle ? _activeVehicle.healthAndArmingCheckReport.supported : false
    property var  vehicle:      globals.activeVehicle
    function dropMainStatusIndicator() {
        let overallStatusComponent = _activeVehicle ? overallStatusIndicatorPage : overallStatusOfflineIndicatorPage
        mainWindow.showIndicatorDrawer(overallStatusComponent, control)
    }

    Label {
        id:                 mainStatusLabel
        Layout.fillWidth:  true
        Layout.preferredHeight: 150//contentWidth + vehicleMessagesIcon.width + control.spacing
        verticalAlignment:  Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        text:               mainStatusText()
        color:              "white"
        font.pixelSize:     mainStatusLabel.statusPixelSize()
        font.bold:          true

        property int    _statusPixelSize:   48
        property int    _readyPixelSize:    41
        property int    _notReadyPixelSize: 30

        // The ready state uses its own background color so that it differs
        // from the armed state, which uses green.
        property color  _readyBackgroundColor: "#0080ff"

        property string _commLostText:      qsTr("Comms Lost")
        property string _readyToFlyText:    qsTr(" READY")
        property string _notReadyText:      qsTr("NOT\nREADY")
        property string _disconnectedText:  qsTr("Disconnected")
        property string _armedText:         qsTr(" FOIL")
        property string _flyingText:        qsTr("Flying")
        property string _landingText:       qsTr("Landing")

        // The ready text is one long word, so it uses a slightly smaller size.
        // The not ready text is shorter and uses two lines.
        function statusPixelSize() {
            if (mainStatusLabel.text === mainStatusLabel._notReadyText) {
                return mainStatusLabel._notReadyPixelSize
            }
            if (mainStatusLabel.text === mainStatusLabel._readyToFlyText) {
                return mainStatusLabel._readyPixelSize
            }
            return mainStatusLabel._statusPixelSize
        }

        // State value 255 means that the subsystem is off. A missing state
        // also means that the subsystem is not available.
        function _stateIsOk(stateFact) {
            if (!stateFact) {
                return false
            }
            var stateValue = stateFact.rawValue
            if (stateValue === undefined || stateValue === null) {
                return false
            }
            return stateValue !== 255
        }

        // The boat is ready when the attitude, heave, speed and joystick
        // states all report a value other than 255.
        function _boatReady() {
            if (!_activeVehicle) {
                return false
            }
            return _stateIsOk(_activeVehicle.attitudeState)
                && _stateIsOk(_activeVehicle.heaveState)
                && _stateIsOk(_activeVehicle.speedState)
                && _stateIsOk(_activeVehicle.joystickState)
        }

        function mainStatusText() {
            if (_activeVehicle) {
                if (_communicationLost) {
                    _mainStatusBGColor = "red"
                    return mainStatusLabel._commLostText
                }
                if (_activeVehicle.armed) {
                    _mainStatusBGColor = "green"
                    return mainStatusLabel._armedText
                }
                if (_boatReady()) {
                    _mainStatusBGColor = mainStatusLabel._readyBackgroundColor
                    return mainStatusLabel._readyToFlyText
                }
                _mainStatusBGColor = "red"
                return mainStatusLabel._notReadyText
            } else {
                _mainStatusBGColor = qgcPal.brandingPurple
                return mainStatusLabel._disconnectedText
            }
        }

        function textPointSize() {
            if (mainStatusLabel.text.length > 4) {
                return ScreenTools.largeFontPointSize * 1.2
            } else {
                return ScreenTools.largeFontPointSize * 1.5
            }
        }

        function textPixelSize() {
            return mainStatusLabel.text.length > 4 ? fixedMainLabelPixelSize * 0.85 : fixedMainLabelPixelSize
        }

        // QGCColoredImage {
        //     id:                     vehicleMessagesIcon
        //     anchors.verticalCenter: parent.verticalCenter
        //     anchors.right:          parent.right
        //     width:                  ScreenTools.defaultFontPixelWidth * 2
        //     height:                 width
        //     source:                 "/res/VehicleMessages.png"
        //     color:                  getIconColor()
        //     sourceSize.width:       width
        //     fillMode:               Image.PreserveAspectFit
        //     //visible:                _activeVehicle && _activeVehicle.messageCount > 0// FIXME: Is messageCount check needed?

        //     function getIconColor() {
        //         let iconColor = qgcPal.text
        //         if (_activeVehicle) {
        //             if (_activeVehicle.messageTypeWarning) {
        //                 iconColor = qgcPal.colorOrange
        //             } else if (_activeVehicle.messageTypeError) {
        //                 iconColor = qgcPal.colorRed
        //             }
        //         }
        //         return iconColor
        //     }
        // }

        QGCMouseArea {
            anchors.fill:   parent
            onClicked:      dropMainStatusIndicator()
        }
    }

    // QGCLabel {
    //     id:                 vtolModeLabel
    //     Layout.fillHeight:  true
    //     verticalAlignment:  Text.AlignVCenter
    //     text:               _vtolInFWDFlight ? qsTr("FW(vtol)") : qsTr("MR(vtol)")
    //     font.pointSize:     _vehicleInAir ? ScreenTools.largeFontPointSize : ScreenTools.defaultFontPointSize
    //     visible:            _activeVehicle && _activeVehicle.vtol

    //     QGCMouseArea {
    //         anchors.fill: parent
    //         onClicked: {
    //             if (_vehicleInAir) {
    //                 mainWindow.showIndicatorDrawer(vtolTransitionIndicatorPage)
    //             }
    //         }
    //     }
    // }

    Component {
        id: overallStatusOfflineIndicatorPage

        MainStatusIndicatorOfflinePage { }
    }

    Component {
        id: overallStatusIndicatorPage

        ToolIndicatorPage {
            showExpand:         _activeVehicle.mainStatusIndicatorContentItem ? true : false
            waitForParameters:  _activeVehicle.mainStatusIndicatorContentItem ? true : false
            contentComponent:   mainStatusContentComponent
            expandedComponent:  mainStatusExpandedComponent
        }
    }

    Component {
        id: mainStatusContentComponent

        ColumnLayout {
            id:         mainLayout
            spacing:    _spacing

            Label {
                text:               _armed ? qsTr("⚠ Actuators may still move and will go back to zero") : qsTr("⚠ Hydraulics will move. Make sure engine is running")
                color:              qgcPal.colorOrange
                font.pointSize:     ScreenTools.mediumFontPointSize
                font.bold:          true
                Layout.alignment:   Qt.AlignHCenter
                wrapMode:           Text.WordWrap
                Layout.maximumWidth: ScreenTools.defaultFontPixelWidth * 40
            }

            QGCButton {
                // FIXME: forceArm is not possible anymore if _healthAndArmingChecksSupported == true
                enabled:            _armed || !_healthAndArmingChecksSupported || _activeVehicle.healthAndArmingCheckReport.canArm
                text:               _armed ?  qsTr("STOP") : qsTr("START")
                Layout.alignment:   Qt.AlignHCenter
                Layout.preferredWidth:  ScreenTools.defaultFontPixelWidth * 20
                Layout.preferredHeight: ScreenTools.defaultFontPixelHeight * 4
                font.pointSize:     ScreenTools.largeFontPointSize

                property bool forceArm: false

                // onPressAndHold: forceArm = true

                onClicked: {
                    if (_armed) {
                        vehicle.forceDisarm()
                    } else {
                        vehicle.forceArm()
                    }
                    forceArm = false
                    mainWindow.closeIndicatorDrawer()
                }
            }

            // SettingsGroupLayout {
            //     //Layout.fillWidth:   true
            //     heading:            qsTr("Vehicle Messages")
            //     visible:            !vehicleMessageList.noMessages

            //     VehicleMessageList { 
            //         id: vehicleMessageList
            //     }
            // }

            // SettingsGroupLayout {
            //     //Layout.fillWidth:   true
            //     heading:            qsTr("Sensor Status")
            //     visible:            !_healthAndArmingChecksSupported

            //     GridLayout {
            //         rowSpacing:     _spacing
            //         columnSpacing:  _spacing
            //         rows:           _activeVehicle.sysStatusSensorInfo.sensorNames.length
            //         flow:           GridLayout.TopToBottom

            //         Repeater {
            //             model: _activeVehicle.sysStatusSensorInfo.sensorNames
            //             QGCLabel { text: modelData }
            //         }

            //         Repeater {
            //             model: _activeVehicle.sysStatusSensorInfo.sensorStatus
            //             QGCLabel { text: modelData }
            //         }
            //     }
            // }

            // SettingsGroupLayout {
            //     //Layout.fillWidth:   true
            //     heading:            qsTr("Overall Status")
            //     visible:            _healthAndArmingChecksSupported && _activeVehicle.healthAndArmingCheckReport.problemsForCurrentMode.count > 0

            //     // List health and arming checks
            //     Repeater {
            //         model:      _activeVehicle ? _activeVehicle.healthAndArmingCheckReport.problemsForCurrentMode : null
            //         delegate:   listdelegate
            //     }
            // }

            FactPanelController {
                id: controller
            }

            Component {
                id: listdelegate

                Column {
                    Row {
                        spacing: ScreenTools.defaultFontPixelHeight

                        Label {
                            id:           message
                            text:         object.message
                            textFormat:   TextEdit.RichText
                            color:        object.severity == 'error' ? qgcPal.colorRed : object.severity == 'warning' ? qgcPal.colorOrange : qgcPal.text
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    if (object.description != "")
                                        object.expanded = !object.expanded
                                }
                            }
                        }

                        QGCColoredImage {
                            id:                     arrowDownIndicator
                            anchors.verticalCenter: parent.verticalCenter
                            height:                 1.5 * ScreenTools.defaultFontPixelWidth
                            width:                  height
                            source:                 "/qmlimages/arrow-down.png"
                            color:                  qgcPal.text
                            visible:                object.description != ""
                            MouseArea {
                                anchors.fill:       parent
                                onClicked:          object.expanded = !object.expanded
                            }
                        }
                    }

                    Label {
                        id:                 description
                        text:               object.description
                        textFormat:         TextEdit.RichText
                        clip:               true
                        visible:            object.expanded
                        
                        property var fact:  null

                        onLinkActivated: (link) => {
                            if (link.startsWith('param://')) {
                                var paramName = link.substr(8);
                                fact = controller.getParameterFact(-1, paramName, true)
                                if (fact != null) {
                                    paramEditorDialogComponent.createObject(mainWindow).open()
                                }
                            } else {
                                Qt.openUrlExternally(link);
                            }
                        }

                        Component {
                            id: paramEditorDialogComponent

                            ParameterEditorDialog {
                                title:          qsTr("Edit Parameter")
                                fact:           description.fact
                                destroyOnClose: true
                            }
                        }
                    }
                }
            }
        }
    }

    Component {
        id: mainStatusExpandedComponent

        ColumnLayout {
            Layout.preferredWidth:  ScreenTools.defaultFontPixelWidth * 60
            spacing:                margins / 2

            property real margins: ScreenTools.defaultFontPixelHeight

            Loader {
                source: _activeVehicle.mainStatusIndicatorContentItem
            }

            SettingsGroupLayout {
                Layout.fillWidth:   true
                visible:            QGroundControl.corePlugin.showAdvancedUI

                GridLayout {
                    columns:            2
                    rowSpacing:         ScreenTools.defaultFontPixelHeight / 2
                    columnSpacing:      ScreenTools.defaultFontPixelWidth *2
                    Layout.fillWidth:   true

                    Label { Layout.fillWidth: true; text: qsTr("Vehicle Parameters") }
                    QGCButton {
                        text: qsTr("Configure")
                        onClicked: {                            
                            mainWindow.showVehicleConfigParametersPage()
                            mainWindow.closeIndicatorDrawer()
                        }
                    }

                    Label { Layout.fillWidth: true; text: qsTr("Vehicle Configuration") }
                    QGCButton {
                        text: qsTr("Configure")
                        onClicked: {                            
                            mainWindow.showVehicleConfig()
                            mainWindow.closeIndicatorDrawer()
                        }
                    }
                }
            }
        }
    }

    Component {
        id: vtolTransitionIndicatorPage

        ToolIndicatorPage {
            contentComponent: Component {
                QGCButton {
                    text: _vtolInFWDFlight ? qsTr("Transition to Multi-Rotor") : qsTr("Transition to Fixed Wing")

                    onClicked: {
                        if (_vtolInFWDFlight) {
                            mainWindow.vtolTransitionToMRFlightRequest()
                        } else {
                            mainWindow.vtolTransitionToFwdFlightRequest()
                        }
                        mainWindow.closeIndicatorDrawer()
                    }
                }
            }
        }
    }
}


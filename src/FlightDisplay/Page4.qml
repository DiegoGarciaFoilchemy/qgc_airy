import QtQuick
import QtQuick.Layouts

import QGroundControl
import QGroundControl.Controls
import QGroundControl.Palette
import QGroundControl.ScreenTools
import QGroundControl.FactSystem


Item {
    id: root
    width: parent ? parent.width : 1280
    height: parent ? parent.height : 760
    property var  vehicle:      globals.activeVehicle


    QGCPalette { id: qgcPal; colorGroupEnabled: true }

    /// HEAVE_SP_2 parameter fact. Fetched lazily because no vehicle (and hence
    /// no parameter list) is available yet when this page is created at startup.
    property Fact _heaveSp2Fact: null

    // Component {
    //     id: factControllerComponent
    //     FactPanelController { }
    // }

    // FactPanelController captures the active vehicle in its constructor, so it
    // must only be created once a vehicle is actually connected. The returned
    // Fact is owned by the vehicle's ParameterManager (CppOwnership), so it
    // survives destroying the temporary controller below.
    function _fetchHeaveSp2Fact() {
        _heaveSp2Fact = null
        if (!vehicle) {
            return
        }
        var controller = factControllerComponent.createObject(root)
        // reportMissing = false: the parameter may simply not be loaded yet
        _heaveSp2Fact = controller.getParameterFact(-1, "HEAVE_SP_2", false)
        controller.destroy()
    }

    Component.onCompleted: _fetchHeaveSp2Fact()

    onVehicleChanged: _fetchHeaveSp2Fact()

    // Re-fetch once the vehicle finishes downloading its parameters
    Connections {
        target: vehicle ? vehicle.parameterManager : null
        function onParametersReadyChanged() {
            root._fetchHeaveSp2Fact()
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
    }

    Rectangle {
        id: topLeftButton
        width: 140
        height: 60
        opacity: vehicle ? 1.0 : 0.45
        radius: 4
        color: "#2f2f2f"
        border.color: "#ffffff"
        border.width: 1
        anchors {
            left: parent.left
            top: parent.top
            leftMargin: 16
            topMargin: 20
        }

        Text {
            anchors.centerIn: parent
            text: "Reboot FCU"
            color: "white"
            font.pixelSize: 16
        }

        MouseArea {
            anchors.fill: parent
            enabled: !!vehicle
            onClicked: vehicle.rebootVehicle()
        }
    }

    

    /// Button that increments HEAVE_SP_2 by 0.2 on each click.
    /// Wraps back to 0 when the value would exceed 2.0.
    Rectangle {
        id: heaveSp2Button
        width: 140
        height: 60
        opacity: (vehicle && _heaveSp2Fact) ? 1.0 : 0.45
        radius: 4
        color: "#2f2f2f"
        border.color: "#ffffff"
        border.width: 1
        anchors {
            left: parent.left
            top: rebootHmiButton.bottom
            leftMargin: 16
            topMargin: 30
        }

        Text {
            anchors.centerIn: parent
            text: _heaveSp2Fact ? ("HEAVE_SP_2: " + Number(_heaveSp2Fact.rawValue).toFixed(1) + " m  (+0.2)")
                                : "HEAVE_SP_2: N/A"
            color: "white"
            font.pixelSize: 14
        }

        MouseArea {
            anchors.fill: parent
            enabled: !!vehicle && !!_heaveSp2Fact
            onClicked: {
                var currentValue = _heaveSp2Fact.rawValue
                var newValue = currentValue + 0.2
                if (newValue > 2.0) {
                    newValue = 0.0
                }
                _heaveSp2Fact.value = newValue   // triggers PARAM_SET to vehicle
            }
        }
    }


}

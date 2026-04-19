import QtQuick
import QtQuick.Layouts

import QGroundControl
import QGroundControl.Controls
import QGroundControl.Palette
import QGroundControl.ScreenTools

Item {
    id: root
    width: parent ? parent.width : 1280
    height: parent ? parent.height : 760
    property var  vehicle:      globals.activeVehicle


    QGCPalette { id: qgcPal; colorGroupEnabled: true }

    

    Rectangle {
        anchors.fill: parent
        color: "black"
    }

}

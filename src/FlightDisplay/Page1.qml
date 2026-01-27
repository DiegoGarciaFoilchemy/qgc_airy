import QtQuick

Item {
    id: root
    width: parent ? parent.width : 1280
    height: parent ? parent.height : 760

    Rectangle {
        anchors.fill: parent
        color: "#f0f0f0"

        Column {
            anchors.centerIn: parent
            spacing: 20

            // Text {
            //     text: "Vessel"
            //     font.pixelSize: 24
            //     anchors.horizontalCenter: parent.horizontalCenter
            // }
            // Text {
            //     text: "Content for page 1"
            //     font.pixelSize: 16
            //     anchors.horizontalCenter: parent.horizontalCenter
            // }
            Loader {
                id: instrumentLoader
                source: "qrc:/qml/QGroundControl/FlightMap/Widgets/VesselAttitude.qml"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 10
            }
        }
    }
}

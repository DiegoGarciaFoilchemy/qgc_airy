import QtQuick

Item {
    id: root
    width: parent ? parent.width : 1280
    height: parent ? parent.height : 760

    Rectangle {
        anchors.fill: parent
        color: "#e0ffe0"

        Column {
            anchors.centerIn: parent
            spacing: 20

            Text {
                text: "Page 3"
                font.pixelSize: 24
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text {
                text: "Content for page 3"
                font.pixelSize: 16
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}

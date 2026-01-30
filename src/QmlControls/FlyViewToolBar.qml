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
import QtQuick.Dialogs

import QGroundControl
import QGroundControl.Controls
import QGroundControl.Palette
import QGroundControl.MultiVehicleManager
import QGroundControl.ScreenTools
import QGroundControl.Controllers

Rectangle {
    id:     _root
    // width:  parent.width
    // height: ScreenTools.toolbarHeight
    width: 100
    height: parent.height
    color:  qgcPal.toolbarBackground
    // anchors.topMargin:    10
    anchors.top:    parent.top
    anchors.right:  parent.right

    property var    _activeVehicle:     QGroundControl.multiVehicleManager.activeVehicle
    property bool   _communicationLost: _activeVehicle ? _activeVehicle.vehicleLinkManager.communicationLost : false
    property color  _mainStatusBGColor: qgcPal.brandingPurple
    property color _followingSeasColor: _activeVehicle && _activeVehicle.followingSeas.rawValue ? Qt.rgba(0, 1, 0, 0.2) : Qt.rgba(1, 0, 0, 0.2)

    function dropMainStatusIndicatorTool() {
        mainStatusIndicator.dropMainStatusIndicator();
    }

    QGCPalette { id: qgcPal }

    /// Left single pixel divider
    Rectangle {
        anchors.left:   parent.left
        anchors.top:  parent.top
        anchors.bottom: parent.bottom
        width:         1
        color:          "black"
        visible:        qgcPal.globalTheme === QGCPalette.Light
    }

    Rectangle {
        id: backgroundGradient
        anchors.fill: viewButtonRow
        anchors.top : parent.top
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop { position: 0.0; color: _root.color }
            GradientStop { position: 0.2; color: Qt.rgba(_mainStatusBGColor.r, _mainStatusBGColor.g, _mainStatusBGColor.b, 0.6) }
            GradientStop { position: 0.8; color: Qt.rgba(_mainStatusBGColor.r, _mainStatusBGColor.g, _mainStatusBGColor.b, 0.6) }
            GradientStop { position: 1.0; color: _root.color }
        }
    }

    ColumnLayout {
        id:                     viewButtonRow
        anchors.rightMargin:   1
        anchors.topMargin:     10
        anchors.left:            parent.left
        anchors.right:         parent.right
        anchors.top:           parent.top
        // anchors.bottom:        parent.bottom
        spacing:                ScreenTools.defaultFontPixelWidth / 2

        // QGCToolBarButton {
        //     id:                     currentButton
        //     // Layout.preferredHeight: viewButtonRow.height
        //     Layout.preferredWidth:  viewButtonRow.width
        //     icon.source:            "/res/QGCLogoFull.svg"
        //     logo:                   true 
        //     onClicked:              mainWindow.showToolSelectDialog()
        // }

        MainStatusIndicator {
            id: mainStatusIndicator
            // Layout.preferredHeight: viewButtonRow.height
            Layout.preferredWidth:  viewButtonRow.width
        }

        QGCButton {
            id:                 disconnectButton
            text:               qsTr("Disconnect")
            onClicked:          _activeVehicle.closeVehicle()
            visible:            _activeVehicle && _communicationLost
        }
    }

    Rectangle {
        id: flighModeColor
        anchors.right: parent.right
        anchors.left: parent.left
        height: 200
        anchors.verticalCenter: mainFlightModeIndicator.verticalCenter
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop { position: 0.0; color: _root.color }
            GradientStop { position: 0.2; color: mainFlightModeIndicator.displayColor }
            GradientStop { position: 0.8; color: mainFlightModeIndicator.displayColor }
            GradientStop { position: 1.0; color: _root.color }
        }
        MouseArea {
                anchors.fill:   parent
                onClicked:      mainFlightModeIndicator.showFlightModeDrawer()
            }
    }

    FlightModeIndicator {
        id: mainFlightModeIndicator
        anchors.right:      parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -25
        // anchors.left:     parent.left
    }

    Rectangle {
        anchors.left:   parent.left
        anchors.right:  parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 65
        height:         200
        
        
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop { position: 0.0; color: _root.color }
            GradientStop { position: 0.2; color: _followingSeasColor }
            GradientStop { position: 0.8; color: _followingSeasColor }
            GradientStop { position: 1.0; color: _root.color }
        }
        
        QGCLabel {
            text: qsTr("Head Seas")
            color: "white"
            font.pointSize: ScreenTools.largeFontPointSize
            rotation: -90
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: -20
        }
        
        QGCLabel {
            text: _activeVehicle ? (_activeVehicle.followingSeas.rawValue ? qsTr("ON") : qsTr("OFF")) : "-"
            color: "white"
            font.pointSize: ScreenTools.largeFontPointSize
            rotation: -90
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 12
        }
        
        MouseArea {
            anchors.fill:   parent
            onClicked: _activeVehicle.followingSeas.rawValue ? _activeVehicle.followingSeasOff() : _activeVehicle.followingSeasOn()
        }
        visible: _activeVehicle
        
    }
    // QGCFlickable {
    //     id:                     toolsFlickable
    //     // anchors.leftMargin:     ScreenTools.defaultFontPixelWidth * ScreenTools.largeFontPointRatio * 1.5
    //     // anchors.rightMargin:    ScreenTools.defaultFontPixelWidth / 2
    //     anchors.left:           parent.left
    //     anchors.topMargin:        40
    //     anchors.bottomMargin:   1
    //     anchors.top:            viewButtonRow.bottom
    //     anchors.bottom:         parent.bottom
    //     anchors.right:          parent.right
    //     contentWidth:           toolIndicators.width
    //     flickableDirection:     Flickable.HorizontalFlick

    //     FlyViewToolBarIndicators { id: toolIndicators }
    // }

    //-------------------------------------------------------------------------
    //-- Branding Logo
    // Image {
    //     anchors.right:          parent.right
    //     anchors.top:            parent.top
    //     anchors.bottom:         parent.bottom
    //     anchors.margins:        ScreenTools.defaultFontPixelHeight * 0.5
    //     visible:                _activeVehicle && !_communicationLost && x > (toolsFlickable.x + toolsFlickable.contentWidth + ScreenTools.defaultFontPixelWidth)
    //     fillMode:               Image.PreserveAspectFit
    //     source:                 "/res/FoilchemyLogo"
    //     mipmap:                 true

    //     property bool   _outdoorPalette:        qgcPal.globalTheme === QGCPalette.Light
    // }
    // Small parameter download progress bar
    // Rectangle {
    //     anchors.bottom: parent.bottom
    //     height:         _root.height * 0.05
    //     width:          _activeVehicle ? _activeVehicle.loadProgress * parent.width : 0
    //     color:          qgcPal.colorGreen
    //     visible:        !largeProgressBar.visible
    // }

    // Large parameter download progress bar
    // Rectangle {
    //     id:             largeProgressBar
    //     anchors.bottom: parent.bottom
    //     anchors.left:   parent.left
    //     anchors.right:  parent.right
    //     height:         parent.height
    //     color:          qgcPal.window
    //     visible:        _showLargeProgress

    //     property bool _initialDownloadComplete: _activeVehicle ? _activeVehicle.initialConnectComplete : true
    //     property bool _userHide:                false
    //     property bool _showLargeProgress:       !_initialDownloadComplete && !_userHide && qgcPal.globalTheme === QGCPalette.Light

    //     Connections {
    //         target:                 QGroundControl.multiVehicleManager
    //         function onActiveVehicleChanged(activeVehicle) { largeProgressBar._userHide = false }
    //     }

    //     Rectangle {
    //         anchors.top:    parent.top
    //         anchors.bottom: parent.bottom
    //         width:          _activeVehicle ? _activeVehicle.loadProgress * parent.width : 0
    //         color:          qgcPal.colorGreen
    //     }

    //     QGCLabel {
    //         anchors.centerIn:   parent
    //         text:               qsTr("Downloading")
    //         font.pointSize:     ScreenTools.largeFontPointSize
    //     }

    //     QGCLabel {
    //         anchors.margins:    _margin
    //         anchors.right:      parent.right
    //         anchors.bottom:     parent.bottom
    //         text:               qsTr("Click anywhere to hide")

    //         property real _margin: ScreenTools.defaultFontPixelWidth / 2
    //     }

    //     MouseArea {
    //         anchors.fill:   parent
    //         onClicked:      largeProgressBar._userHide = true
    //     }
    // }
}

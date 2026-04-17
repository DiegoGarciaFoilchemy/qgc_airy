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
import QGroundControl.Controllers

Rectangle {
    id:     _root
    // width:  parent.width
    // height: ScreenTools.toolbarHeight
    width: _toolbarWidthPx
    height: _toolbarHeightPx
    color:  qgcPal.toolbarBackground
    // anchors.topMargin:    10
    anchors.top:    parent.top
    anchors.right:  parent.right

    property var    _activeVehicle:     QGroundControl.multiVehicleManager.activeVehicle
    property bool   _communicationLost: _activeVehicle ? _activeVehicle.vehicleLinkManager.communicationLost : false
    property color  _mainStatusBGColor: qgcPal.brandingPurple
    property color _followingSeasColor: !_activeVehicle ? Qt.rgba(1, 0, 0, 0.14) : (_activeVehicle.followingSeas.rawValue === 2 ? Qt.rgba(0, 1, 0, 0.14) : (_activeVehicle.followingSeas.rawValue === 1 ? Qt.rgba(1, 0.85, 0, 0.14) : Qt.rgba(1, 0, 0, 0.14)))
    property color _waveStateColor: !_activeVehicle ? Qt.rgba(0, 0, 1, 0.14) : (_activeVehicle.waveState.rawValue === 2 ? Qt.rgba(0, 0, 1, 0.14) : (_activeVehicle.waveState.rawValue === 1 ? Qt.rgba(0, 0, 1, 0.07) : Qt.rgba(0, 0, 1, 0.03)))
    property real   _toolbarHeightPx:               800
    property real   _toolbarWidthPx:                170
    property real   _panelHeightPx:                 150
    property real   _flightModeTopMarginPx:         230
    property real   _followingSeasTopMarginPx:      310
    property real   _waveStateTopMarginPx:          460
    property real   _logoBottomMarginPx:            20
    property real   _logoInsetPx:                   10
    property real   _borderWidthPx:                 2
    property real   _dividerWidthPx:                1
    property real   _followingSeasOffsetPx:         20
    property real   _viewButtonSpacingPx:           6
    property real   _labelPixelSize:                22
    property real   _disconnectButtonHeightPx:      36
    property real   _mainStatusLabelPixelSize:      26
    property real   _flightModePanelHeightPx:       80

    function dropMainStatusIndicatorTool() {
        mainStatusIndicator.dropMainStatusIndicator();
    }

    QGCPalette { id: qgcPal }

    /// Left single pixel divider
    Rectangle {
        anchors.left:   parent.left
        anchors.top:  parent.top
        anchors.bottom: parent.bottom
        width:         _dividerWidthPx
        color:          "black"
        visible:        qgcPal.globalTheme === QGCPalette.Light
    }

    Rectangle {
        id: backgroundGradient
        anchors.fill: viewButtonRow
        anchors.top : parent.top
        color: _mainStatusBGColor
        opacity: 0.5
        border.color: "white"
        border.width: _borderWidthPx
    }

    ColumnLayout {
        id:                     viewButtonRow
        // anchors.rightMargin:   1
        anchors.left:            parent.left
        anchors.right:         parent.right
        anchors.top:           parent.top
        // anchors.bottom:        parent.bottom
        spacing:                _viewButtonSpacingPx

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
            useFixedPixels:         true
            fixedSpacingPx:         _viewButtonSpacingPx
            fixedMainLabelPixelSize:_mainStatusLabelPixelSize
        }

        QGCButton {
            id:                 disconnectButton
            Layout.preferredWidth:  viewButtonRow.width
            Layout.preferredHeight: _disconnectButtonHeightPx
            text:               qsTr("Disconnect")
            textColor:          "white"
            onClicked:          _activeVehicle.closeVehicle()
            visible:            _activeVehicle && _communicationLost
        }
    }

    Rectangle {
        id: flighModeColor
        visible: _activeVehicle
        anchors.right: parent.right
        anchors.left: parent.left
        height: _panelHeightPx
        anchors.verticalCenter: mainFlightModeIndicator.verticalCenter
        color: mainFlightModeIndicator.displayColor
        opacity: 0.5
        border.color: "white"
        border.width: _borderWidthPx
        MouseArea {
                anchors.fill:   parent
                onClicked:      mainFlightModeIndicator.showFlightModeDrawer()
            }
    }

    FlightModeIndicator {
        id: mainFlightModeIndicator
        useFixedPixels:         true
        fixedPanelHeightPx:     _flightModePanelHeightPx
        fixedLabelPixelSize:    _labelPixelSize
        anchors.right:      parent.right
        anchors.top: parent.top
        anchors.topMargin: _flightModeTopMarginPx
        // anchors.left:     parent.left
    }

    Rectangle {
        id: followingSeasIndicator
        anchors.left:   parent.left
        anchors.right:  parent.right
        anchors.top: parent.top
        anchors.topMargin: _followingSeasTopMarginPx
        height:         _panelHeightPx
        color: _followingSeasColor
        border.color: Qt.rgba(1, 1, 1, 0.5)
        border.width: _borderWidthPx
        
        Label {
            text: qsTr("Following Seas")
            color: "white"
            font: Qt.font({ pixelSize: _labelPixelSize })
            // rotation: -90
            // anchors.top: parent.top
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenterOffset: -_followingSeasOffsetPx
        }
        
        Label {
            text: !_activeVehicle ? "-" : (_activeVehicle.followingSeas.rawValue === 2 ? qsTr("HIGH") : (_activeVehicle.followingSeas.rawValue === 1 ? qsTr("NORMAL") : qsTr("OFF")))
            color: "white"
            font: Qt.font({ pixelSize: _labelPixelSize })
            // rotation: -90
            // anchors.bottom: parent.bottom
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenterOffset: _followingSeasOffsetPx
        }
        
        MouseArea {
            anchors.fill:   parent
            enabled: _activeVehicle
            onClicked: _activeVehicle.followingSeasOn()
        }
        visible: _activeVehicle
        
    }

    Rectangle {
        id: waveStateIndicator
        anchors.left:   parent.left
        anchors.right:  parent.right
        anchors.top: parent.top
        anchors.topMargin: _waveStateTopMarginPx
        height:         _panelHeightPx
        color: _waveStateColor
        border.color: Qt.rgba(1, 1, 1, 0.5)
        border.width: _borderWidthPx
        
        Label {
            text: qsTr("WAVES")
            color: "white"
            font: Qt.font({ pixelSize: _labelPixelSize })
            // rotation: -90
            // anchors.top: parent.top
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenterOffset: -_followingSeasOffsetPx
        }
        
        Label {
            text: !_activeVehicle ? "-" : (_activeVehicle.waveState.rawValue === 2 ? qsTr("HIGH") : (_activeVehicle.waveState.rawValue === 1 ? qsTr("MID") : qsTr("LOW")))
            color: "white"
            font: Qt.font({ pixelSize: _labelPixelSize })
            // rotation: -90
            // anchors.bottom: parent.bottom
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenterOffset: _followingSeasOffsetPx
        }
        
        MouseArea {
            anchors.fill:   parent
            enabled: _activeVehicle
            onClicked: _activeVehicle.waveStateOn()
        }
        visible: _activeVehicle
        
    }

    QGCToolBarButton {
            id:                     currentButton
            useFixedPixels:         true
            fixedHeightPx:          parent.width - _logoInsetPx
            fixedHorizontalMarginPx: 4
            fixedContentSpacingPx:  4
            Layout.preferredWidth:  parent.width
            Layout.preferredHeight: parent.width - _logoInsetPx
            icon.source:            "/res/LogoFoilchemy.svg"
            logo:                   true 
            onClicked:              mainWindow.showToolSelectDialog()
            anchors.bottom:           parent.bottom
            anchors.bottomMargin: _logoBottomMarginPx
            anchors.horizontalCenter: parent.horizontalCenter
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

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
import QtQuick.Dialogs
import QtQuick.Layouts

import QtLocation
import QtPositioning
import QtQuick.Window
import QtQml.Models

import QGroundControl
import QGroundControl.Controllers
import QGroundControl.Controls
import QGroundControl.FactSystem
// import QGroundControl.FlightDisplay
// import QGroundControl.FlightMap
import QGroundControl.Palette
import QGroundControl.ScreenTools
import QGroundControl.Vehicle

// 3D Viewer modules
import Viewer3D

Item {
    id: _root

    // These should only be used by MainRootWindow
    // property var planController:    _planController
    // property var guidedController:  _guidedController

    // Properties of UTM adapter
    property bool utmspSendActTrigger: false
    // Page names for navigation
    property var pageNames: ["overview", "actuators", "alarms", "debug", "test"]
    // PlanMasterController {
    //     id:                     _planController
    //     flyView:                true
    //     Component.onCompleted:  start()
    // }

    property bool   _mainWindowIsMap:       mapControl.pipState.state === mapControl.pipState.fullState
    property bool   _isFullWindowItemDark:  _mainWindowIsMap ? mapControl.isSatelliteMap : true
    property var    _activeVehicle:         QGroundControl.multiVehicleManager.activeVehicle
    // property var    _missionController:     _planController.missionController
    // property var    _geoFenceController:    _planController.geoFenceController
    // property var    _rallyPointController:  _planController.rallyPointController
    property real   _margins:               ScreenTools.defaultFontPixelWidth / 2
    // property var    _guidedController:      guidedActionsController
    // property var    _guidedValueSlider:     guidedValueSlider
    // property var    _widgetLayer:           widgetLayer
    property real   _toolsMargin:           ScreenTools.defaultFontPixelWidth * 0.75
    property rect   _centerViewport:        Qt.rect(0, 0, width, height)
    property real   _rightPanelWidth:       ScreenTools.defaultFontPixelWidth * 30
    property var    _mapControl:            mapControl

    property real   _fullItemZorder:    0
    property real   _pipItemZorder:     QGroundControl.zOrderWidgets

    function _calcCenterViewPort() {
        var newToolInset = Qt.rect(0, 0, width, height)
        toolstrip.adjustToolInset(newToolInset)
    }

    function dropMainStatusIndicatorTool() {
        toolbar.dropMainStatusIndicatorTool();
    }

    // QGCToolInsets {
    //     id:                     _toolInsets
    //     leftEdgeBottomInset:    _pipView.leftEdgeBottomInset
    //     bottomEdgeLeftInset:    _pipView.bottomEdgeLeftInset
    // }

    FlyViewToolBar {
        id:         toolbar
        visible:    !QGroundControl.videoManager.fullScreen
    }

    Item {
        id:                 mapHolder
        anchors.top:        toolbar.bottom
        anchors.bottom:     parent.bottom
        anchors.left:       parent.left
        anchors.right:      parent.right

        Item {
            id:                     mapControl
            anchors.fill:           parent

            // Keep these properties so other QML which references `mapControl` still works
            property var    planMasterController
            property var    rightPanelWidth
            property Item   pipView
            property bool   pipMode:                !_mainWindowIsMap
            property var    toolInsets
            property string mapName:                "FlightDisplayView"
            property bool   enabled:                true

            // Minimal pipState emulation used by surrounding UI
            QtObject {
                id: _pip_state_stub
                property int pipState: 0
                property int fullState: 1
                property int state: pipState
            }
            property alias pipState: _pip_state_stub

            // Minimal properties expected by code elsewhere
            property bool isSatelliteMap: false

            // SwipeView for multiple screens
            SwipeView {
                id: screenSwipeView
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: navBar.top
                anchors.bottomMargin: 12
                clip: true

                Page1 { width: screenSwipeView.width; height: screenSwipeView.height }
                Page2 { width: screenSwipeView.width; height: screenSwipeView.height }
                Page3 { width: screenSwipeView.width; height: screenSwipeView.height }
                Page4 { width: screenSwipeView.width; height: screenSwipeView.height }
                Page5 { width: screenSwipeView.width; height: screenSwipeView.height }
            }

            // Bottom navigation buttons
            Row {
                id: navBar
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottomMargin: 12
                spacing: 12

                Repeater {
                    model: pageNames
                    delegate: Button {
                        text: modelData
                        checkable: true
                        checked: screenSwipeView.currentIndex === index
                        onClicked: screenSwipeView.currentIndex = index
                    }
                }
            }
        }

        // FlyViewVideo {
        //     id:         videoControl
        //     pipView:    _pipView
        // }

        // PipView {
        //     id:                     _pipView
        //     anchors.left:           parent.left
        //     anchors.bottom:         parent.bottom
        //     anchors.margins:        _toolsMargin
        //     item1IsFullSettingsKey: "MainFlyWindowIsMap"
        //     item1:                  mapControl
        //     item2:                  QGroundControl.videoManager.hasVideo ? videoControl : null
        //     show:                   QGroundControl.videoManager.hasVideo && !QGroundControl.videoManager.fullScreen &&
        //                                 (videoControl.pipState.state === videoControl.pipState.pipState || mapControl.pipState.state === mapControl.pipState.pipState)
        //     z:                      QGroundControl.zOrderWidgets

        //     property real leftEdgeBottomInset: visible ? width + anchors.margins : 0
        //     property real bottomEdgeLeftInset: visible ? height + anchors.margins : 0
        // }

        // FlyViewWidgetLayer {
        //     id:                     widgetLayer
        //     anchors.top:            parent.top
        //     anchors.bottom:         parent.bottom
        //     anchors.left:           parent.left
        //     anchors.right:          guidedValueSlider.visible ? guidedValueSlider.left : parent.right
        //     z:                      _fullItemZorder + 2 // we need to add one extra layer for map 3d viewer (normally was 1)
        //     parentToolInsets:       _toolInsets
        //     mapControl:             _mapControl
        //     visible:                !QGroundControl.videoManager.fullScreen
        //     utmspActTrigger:        utmspSendActTrigger
        //     isViewer3DOpen:         viewer3DWindow.isOpen
        // }

        // FlyViewCustomLayer {
        //     id:                 customOverlay
        //     anchors.fill:       widgetLayer
        //     z:                  _fullItemZorder + 2
        //     parentToolInsets:   widgetLayer.totalToolInsets
        //     mapControl:         _mapControl
        //     visible:            !QGroundControl.videoManager.fullScreen
        // }

        // Development tool for visualizing the insets for a paticular layer, show if needed
        // FlyViewInsetViewer {
        //     id:                     widgetLayerInsetViewer
        //     anchors.top:            parent.top
        //     anchors.bottom:         parent.bottom
        //     anchors.left:           parent.left
        //     anchors.right:          guidedValueSlider.visible ? guidedValueSlider.left : parent.right
        //     z:                      widgetLayer.z + 1
        //     insetsToView:           widgetLayer.totalToolInsets
        //     visible:                false
        // }

        // GuidedActionsController {
        //     id:                 guidedActionsController
        //     missionController:  _missionController
        //     guidedValueSlider:     _guidedValueSlider
        // }

        //-- Guided value slider (e.g. altitude)
        // GuidedValueSlider {
        //     id:                 guidedValueSlider
        //     anchors.right:      parent.right
        //     anchors.top:        parent.top
        //     anchors.bottom:     parent.bottom
        //     z:                  QGroundControl.zOrderTopMost
        //     visible:            false
        // }

        // Viewer3D{
        //     id:                     viewer3DWindow
        //     anchors.fill:           parent
        // }
    }
}

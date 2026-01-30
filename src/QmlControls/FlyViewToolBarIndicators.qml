/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick

import QGroundControl
import QGroundControl.ScreenTools
import QGroundControl.Toolbar

//-------------------------------------------------------------------------
//-- Toolbar Indicators
Column {
    id:                 indicatorRow
    anchors.left:       parent.left
    anchors.right:      parent.right
    anchors.margins:    _toolIndicatorMargins
    spacing:            ScreenTools.defaultFontPixelHeight * 1.75

    property var  _activeVehicle:           QGroundControl.multiVehicleManager.activeVehicle
    property real _toolIndicatorMargins:    ScreenTools.defaultFontPixelWidth * 0.66

    Repeater {
        id:     appRepeater
        model:  QGroundControl.corePlugin.toolBarIndicators
        Loader {
            anchors.left:       parent.left
            anchors.right:      parent.right
            source:             modelData
            visible:            item.showIndicator
        }
    }

    Repeater {
        id:     toolIndicatorsRepeater
        model:  _activeVehicle ? _activeVehicle.toolIndicators : []

        Loader {
            anchors.left:       parent.left
            anchors.right:      parent.right
            source:             modelData
            visible:            item.showIndicator
        }
    }

    Repeater {
        model: _activeVehicle ? _activeVehicle.modeIndicators : []
        Loader {
            anchors.left:       parent.left
            anchors.right:      parent.right
            source:             modelData
            visible:            item.showIndicator
        }
    }

    
}

/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

import QGroundControl.Controls
import QGroundControl.ScreenTools

/// On-screen numeric keypad used to enter values into a text field.
/// Keys: 0-9, decimal point, minus sign and backspace.
GridLayout {
    id: root

    /// The TextField/TextInput which receives the key presses.
    property var textField: null

    /// Height of a single key.
    property real keyHeight: ScreenTools.minTouchPixels * 1.5

    columns: 4
    rowSpacing: ScreenTools.defaultFontPixelWidth / 4
    columnSpacing: ScreenTools.defaultFontPixelWidth / 4

    function insertKey(key) {
        if (textField === null || textField === undefined) {
            return
        }
        var tf = textField
        // Force focus first: QGCTextField selects all text when it gains focus,
        // so the selection below reflects the expected state before we edit it.
        tf.forceActiveFocus()
        var start = Math.min(tf.selectionStart, tf.selectionEnd)
        var end = Math.max(tf.selectionStart, tf.selectionEnd)
        if (end > start) {
            tf.remove(start, end)
        }
        tf.insert(start, key)
        tf.cursorPosition = start + key.length
    }

    function backspace() {
        if (textField === null || textField === undefined) {
            return
        }
        var tf = textField
        tf.forceActiveFocus()
        var start = Math.min(tf.selectionStart, tf.selectionEnd)
        var end = Math.max(tf.selectionStart, tf.selectionEnd)
        if (end > start) {
            tf.remove(start, end)
            tf.cursorPosition = start
        } else if (start > 0) {
            tf.remove(start - 1, start)
            tf.cursorPosition = start - 1
        }
    }

    component Key: QGCButton {
        focusPolicy:                Qt.NoFocus
        Layout.fillWidth:           true
        Layout.preferredHeight:     root.keyHeight
        topPadding:                 0
        bottomPadding:              0
        leftPadding:                0
        rightPadding:               0
        pointSize:                  ScreenTools.largeFontPointSize
    }

    Key { text: "7"; onClicked: root.insertKey("7") }
    Key { text: "8"; onClicked: root.insertKey("8") }
    Key { text: "9"; onClicked: root.insertKey("9") }
    Key { text: "⌫"; onClicked: root.backspace() }

    Key { text: "4"; onClicked: root.insertKey("4") }
    Key { text: "5"; onClicked: root.insertKey("5") }
    Key { text: "6"; onClicked: root.insertKey("6") }
    Key { text: "."; onClicked: root.insertKey(".") }

    Key { text: "1"; onClicked: root.insertKey("1") }
    Key { text: "2"; onClicked: root.insertKey("2") }
    Key { text: "3"; onClicked: root.insertKey("3") }
    Key { text: "-"; onClicked: root.insertKey("-") }

    Key {
        text:               "0"
        Layout.columnSpan:  4
        onClicked:          root.insertKey("0")
    }
}

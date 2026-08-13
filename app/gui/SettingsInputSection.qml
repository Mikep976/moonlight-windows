import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import StreamingPreferences 1.0
import SystemProperties 1.0

SettingsSection {
    id: root

    title: qsTr("Input")
    description: qsTr("Configure mouse, keyboard, and touchscreen behavior while streaming.")

    CheckBox {
        Layout.fillWidth: true
        hoverEnabled: true
        text: qsTr("Optimize mouse for remote desktop instead of games")
        font.pixelSize: 14
        checked: StreamingPreferences.absoluteMouseMode

        onCheckedChanged: {
            StreamingPreferences.absoluteMouseMode = checked
        }

        ToolTip.delay: 700
        ToolTip.timeout: 10000
        ToolTip.visible: hovered
        ToolTip.text: qsTr("This enables seamless mouse control without capturing the client's mouse cursor. It is ideal for remote desktop usage but will not work in most games.") + " " +
                      qsTr("You can toggle this while streaming using Ctrl+Alt+Shift+M.") + "\n\n" +
                      qsTr("NOTE: Due to a bug in GeForce Experience, this option may not work properly if your host PC has multiple monitors.")
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: root.windowsStyle.space8

        CheckBox {
            id: captureSysKeysCheck
            Layout.fillWidth: true
            hoverEnabled: true
            text: qsTr("Capture system keyboard shortcuts")
            font.pixelSize: 14
            enabled: SystemProperties.hasDesktopEnvironment
            checked: StreamingPreferences.captureSysKeysMode !== StreamingPreferences.CSK_OFF || !SystemProperties.hasDesktopEnvironment

            ToolTip.delay: 700
            ToolTip.timeout: 10000
            ToolTip.visible: hovered
            ToolTip.text: qsTr("This enables the capture of system-wide keyboard shortcuts like Alt+Tab that would normally be handled by the client OS while streaming.") + "\n\n" +
                          qsTr("NOTE: Certain keyboard shortcuts like Ctrl+Alt+Del on Windows cannot be intercepted by any application, including Moonlight.")
        }

        AutoResizingComboBox {
            id: captureSysKeysModeComboBox
            enabled: captureSysKeysCheck.checked && captureSysKeysCheck.enabled
            textRole: "text"

            model: ListModel {
                id: captureSysKeysModeListModel

                ListElement {
                    text: qsTr("in fullscreen")
                    val: StreamingPreferences.CSK_FULLSCREEN
                }
                ListElement {
                    text: qsTr("always")
                    val: StreamingPreferences.CSK_ALWAYS
                }
            }

            Component.onCompleted: {
                if (!visible) {
                    return
                }

                var savedMode = StreamingPreferences.captureSysKeysMode
                currentIndex = 0
                for (var i = 0; i < captureSysKeysModeListModel.count; i++) {
                    if (savedMode === captureSysKeysModeListModel.get(i).val) {
                        currentIndex = i
                        break
                    }
                }

                // Preserve the legacy behavior that normalizes stale/invalid values.
                activated(currentIndex)
            }

            function updatePref() {
                if (!enabled) {
                    StreamingPreferences.captureSysKeysMode = StreamingPreferences.CSK_OFF
                }
                else {
                    StreamingPreferences.captureSysKeysMode = captureSysKeysModeListModel.get(currentIndex).val
                }
            }

            onActivated: updatePref()
            onEnabledChanged: updatePref()
        }
    }

    CheckBox {
        Layout.fillWidth: true
        hoverEnabled: true
        text: qsTr("Use touchscreen as a virtual trackpad")
        font.pixelSize: 14
        checked: !StreamingPreferences.absoluteTouchMode

        onCheckedChanged: {
            StreamingPreferences.absoluteTouchMode = !checked
        }

        ToolTip.delay: 700
        ToolTip.timeout: 5000
        ToolTip.visible: hovered
        ToolTip.text: qsTr("When checked, the touchscreen acts like a trackpad. When unchecked, the touchscreen will directly control the mouse pointer.")
    }

    CheckBox {
        Layout.fillWidth: true
        hoverEnabled: true
        text: qsTr("Swap left and right mouse buttons")
        font.pixelSize: 14
        checked: StreamingPreferences.swapMouseButtons

        onCheckedChanged: {
            StreamingPreferences.swapMouseButtons = checked
        }
    }

    CheckBox {
        Layout.fillWidth: true
        hoverEnabled: true
        text: qsTr("Reverse mouse scrolling direction")
        font.pixelSize: 14
        checked: StreamingPreferences.reverseScrollDirection

        onCheckedChanged: {
            StreamingPreferences.reverseScrollDirection = checked
        }
    }
}

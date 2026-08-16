import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import StreamingPreferences 1.0
import SystemProperties 1.0

SettingsSection {
    id: root

    title: qsTr("Gamepad")
    description: qsTr("Configure controller layout, connection behavior, and background input.")

    CheckBox {
        Layout.fillWidth: true
        text: qsTr("Swap A/B and X/Y gamepad buttons")
        font.pixelSize: 14
        checked: StreamingPreferences.swapFaceButtons

        onCheckedChanged: {
            StreamingPreferences.swapFaceButtons = checked
        }

        ToolTip.delay: 700
        ToolTip.timeout: 5000
        ToolTip.visible: hovered
        ToolTip.text: qsTr("This switches gamepads into a Nintendo-style button layout")
    }

    CheckBox {
        Layout.fillWidth: true
        text: qsTr("Force gamepad #1 always connected")
        font.pixelSize: 14
        checked: !StreamingPreferences.multiController

        onCheckedChanged: {
            StreamingPreferences.multiController = !checked
        }

        ToolTip.delay: 700
        ToolTip.timeout: 5000
        ToolTip.visible: hovered
        ToolTip.text: qsTr("Forces a single gamepad to always stay connected to the host, even if no gamepads are actually connected to this PC.") + " " +
                      qsTr("Only enable this option when streaming a game that doesn't support gamepads being connected after startup.")
    }

    CheckBox {
        Layout.fillWidth: true
        hoverEnabled: true
        text: qsTr("Enable mouse control with gamepads by holding the 'Start' button")
        font.pixelSize: 14
        checked: StreamingPreferences.gamepadMouse

        onCheckedChanged: {
            StreamingPreferences.gamepadMouse = checked
        }
    }

    CheckBox {
        Layout.fillWidth: true
        visible: SystemProperties.hasDesktopEnvironment
        text: qsTr("Process gamepad input when Moonlight is in the background")
        font.pixelSize: 14
        checked: StreamingPreferences.backgroundGamepad

        onCheckedChanged: {
            StreamingPreferences.backgroundGamepad = checked
        }

        ToolTip.delay: 700
        ToolTip.timeout: 5000
        ToolTip.visible: hovered
        ToolTip.text: qsTr("Allows Moonlight to capture gamepad inputs even if it's not the current window in focus")
    }
}

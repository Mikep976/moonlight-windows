import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import StreamingPreferences 1.0

SettingsSection {
    id: root

    title: qsTr("Host")
    description: qsTr("Choose how Moonlight manages game settings and running apps on the host PC.")

    CheckBox {
        Layout.fillWidth: true
        text: qsTr("Optimize game settings for streaming")
        font.pixelSize: 14
        checked: StreamingPreferences.gameOptimizations

        onCheckedChanged: {
            StreamingPreferences.gameOptimizations = checked
        }
    }

    CheckBox {
        Layout.fillWidth: true
        text: qsTr("Quit app on host PC after ending stream")
        font.pixelSize: 14
        checked: StreamingPreferences.quitAppAfter

        onCheckedChanged: {
            StreamingPreferences.quitAppAfter = checked
        }

        ToolTip.delay: 700
        ToolTip.timeout: 5000
        ToolTip.visible: hovered
        ToolTip.text: qsTr("This will close the app or game you are streaming when you end your stream. You will lose any unsaved progress!")
    }
}

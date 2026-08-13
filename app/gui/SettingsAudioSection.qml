import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import StreamingPreferences 1.0
import SystemProperties 1.0

SettingsSection {
    id: root

    title: qsTr("Audio")
    description: qsTr("Choose the stream audio layout and how Moonlight handles host and background audio.")

    Label {
        Layout.fillWidth: true
        text: qsTr("Audio configuration")
        color: root.windowsStyle.textPrimary
        font.pixelSize: 14
        wrapMode: Text.Wrap
    }

    AutoResizingComboBox {
        id: audioComboBox
        Layout.alignment: Qt.AlignLeft
        textRole: "text"

        model: ListModel {
            id: audioListModel

            ListElement {
                text: qsTr("Stereo")
                val: StreamingPreferences.AC_STEREO
            }
            ListElement {
                text: qsTr("5.1 surround sound")
                val: StreamingPreferences.AC_51_SURROUND
            }
            ListElement {
                text: qsTr("7.1 surround sound")
                val: StreamingPreferences.AC_71_SURROUND
            }
        }

        Component.onCompleted: {
            var savedAudio = StreamingPreferences.audioConfig
            currentIndex = 0

            for (var i = 0; i < audioListModel.count; i++) {
                if (savedAudio === audioListModel.get(i).val) {
                    currentIndex = i
                    break
                }
            }

            // Preserve the legacy behavior that normalizes stale/invalid values.
            activated(currentIndex)
        }

        onActivated: {
            StreamingPreferences.audioConfig = audioListModel.get(currentIndex).val
        }
    }

    CheckBox {
        Layout.fillWidth: true
        hoverEnabled: true
        text: qsTr("Mute host PC speakers while streaming")
        font.pixelSize: 14
        checked: !StreamingPreferences.playAudioOnHost

        onCheckedChanged: {
            StreamingPreferences.playAudioOnHost = !checked
        }

        ToolTip.delay: 700
        ToolTip.timeout: 5000
        ToolTip.visible: hovered
        ToolTip.text: qsTr("You must restart any game currently in progress for this setting to take effect")
    }

    CheckBox {
        Layout.fillWidth: true
        visible: SystemProperties.hasDesktopEnvironment
        hoverEnabled: true
        text: qsTr("Mute audio stream when Moonlight is not the active window")
        font.pixelSize: 14
        checked: StreamingPreferences.muteOnFocusLoss

        onCheckedChanged: {
            StreamingPreferences.muteOnFocusLoss = checked
        }

        ToolTip.delay: 700
        ToolTip.timeout: 5000
        ToolTip.visible: hovered
        ToolTip.text: qsTr("Mutes Moonlight's audio when you Alt+Tab out of the stream or click on a different window.")
    }
}

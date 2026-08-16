import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import StreamingPreferences 1.0
import SystemProperties 1.0

SettingsSection {
    id: root

    signal languageChanged()

    title: qsTr("App")
    description: qsTr("Configure Moonlight's language, window behavior, warnings, and desktop integrations.")

    Label {
        Layout.fillWidth: true
        text: qsTr("Language")
        color: root.windowsStyle.textPrimary
        font.pixelSize: 14
        wrapMode: Text.Wrap
    }

    AutoResizingComboBox {
        id: languageComboBox
        Layout.alignment: Qt.AlignLeft
        textRole: "text"

        model: ListModel {
            id: languageListModel

            ListElement { text: qsTr("Automatic"); val: StreamingPreferences.LANG_AUTO }
            ListElement { text: "Deutsch"; val: StreamingPreferences.LANG_DE }
            ListElement { text: "English"; val: StreamingPreferences.LANG_EN }
            ListElement { text: "Français"; val: StreamingPreferences.LANG_FR }
            ListElement { text: "简体中文"; val: StreamingPreferences.LANG_ZH_CN }
            ListElement { text: "Norwegian Bokmål"; val: StreamingPreferences.LANG_NB_NO }
            ListElement { text: "русский"; val: StreamingPreferences.LANG_RU }
            ListElement { text: "Español"; val: StreamingPreferences.LANG_ES }
            ListElement { text: "日本語"; val: StreamingPreferences.LANG_JA }
            ListElement { text: "Tiếng Việt"; val: StreamingPreferences.LANG_VI }
            ListElement { text: "ภาษาไทย"; val: StreamingPreferences.LANG_TH }
            ListElement { text: "한국어"; val: StreamingPreferences.LANG_KO }
            ListElement { text: "Magyar"; val: StreamingPreferences.LANG_HU }
            ListElement { text: "Nederlands"; val: StreamingPreferences.LANG_NL }
            ListElement { text: "Svenska"; val: StreamingPreferences.LANG_SV }
            ListElement { text: "Türkçe"; val: StreamingPreferences.LANG_TR }
            ListElement { text: "繁體中文"; val: StreamingPreferences.LANG_ZH_TW }
            ListElement { text: "Português"; val: StreamingPreferences.LANG_PT }
            ListElement { text: "Português do Brasil"; val: StreamingPreferences.LANG_PT_BR }
            ListElement { text: "Ελληνικά"; val: StreamingPreferences.LANG_EL }
            ListElement { text: "Italiano"; val: StreamingPreferences.LANG_IT }
            ListElement { text: "Język polski"; val: StreamingPreferences.LANG_PL }
            ListElement { text: "Čeština"; val: StreamingPreferences.LANG_CS }
            ListElement { text: "Български"; val: StreamingPreferences.LANG_BG }
            ListElement { text: "தமிழ்"; val: StreamingPreferences.LANG_TA }
        }

        Component.onCompleted: {
            var savedLanguage = StreamingPreferences.language
            currentIndex = 0
            for (var i = 0; i < languageListModel.count; i++) {
                if (savedLanguage === languageListModel.get(i).val) {
                    currentIndex = i
                    break
                }
            }

            // Preserve the legacy behavior that normalizes stale/invalid values.
            activated(currentIndex)
        }

        onActivated: {
            var newLanguage = languageListModel.get(currentIndex).val
            if (StreamingPreferences.language === newLanguage) {
                return
            }

            StreamingPreferences.language = newLanguage
            if (!StreamingPreferences.retranslate()) {
                ToolTip.show(qsTr("You must restart Moonlight for this change to take effect"), 5000)
            }
            else {
                root.languageChanged()
            }
        }
    }

    Label {
        Layout.fillWidth: true
        visible: SystemProperties.hasDesktopEnvironment
        text: qsTr("GUI display mode")
        color: root.windowsStyle.textPrimary
        font.pixelSize: 14
        wrapMode: Text.Wrap
    }

    AutoResizingComboBox {
        id: uiDisplayModeComboBox
        Layout.alignment: Qt.AlignLeft
        visible: SystemProperties.hasDesktopEnvironment
        textRole: "text"

        model: ListModel {
            id: uiDisplayModeListModel

            ListElement { text: qsTr("Windowed"); val: StreamingPreferences.UI_WINDOWED }
            ListElement { text: qsTr("Maximized"); val: StreamingPreferences.UI_MAXIMIZED }
            ListElement { text: qsTr("Fullscreen"); val: StreamingPreferences.UI_FULLSCREEN }
        }

        function reinitialize() {
            if (!visible) {
                return
            }

            var savedMode = StreamingPreferences.uiDisplayMode
            currentIndex = 0
            for (var i = 0; i < uiDisplayModeListModel.count; i++) {
                if (savedMode === uiDisplayModeListModel.get(i).val) {
                    currentIndex = i
                    break
                }
            }

            // Preserve the legacy behavior that normalizes stale/invalid values.
            activated(currentIndex)
        }

        Component.onCompleted: {
            reinitialize()
            root.languageChanged.connect(reinitialize)
        }

        onActivated: {
            StreamingPreferences.uiDisplayMode = uiDisplayModeListModel.get(currentIndex).val
        }
    }

    CheckBox {
        Layout.fillWidth: true
        text: qsTr("Show connection quality warnings")
        font.pixelSize: 14
        checked: StreamingPreferences.connectionWarnings

        onCheckedChanged: {
            StreamingPreferences.connectionWarnings = checked
        }
    }

    CheckBox {
        Layout.fillWidth: true
        text: qsTr("Show configuration warnings")
        font.pixelSize: 14
        checked: StreamingPreferences.configurationWarnings

        onCheckedChanged: {
            StreamingPreferences.configurationWarnings = checked
        }
    }

    CheckBox {
        Layout.fillWidth: true
        visible: SystemProperties.hasDiscordIntegration
        hoverEnabled: true
        text: qsTr("Discord Rich Presence integration")
        font.pixelSize: 14
        checked: StreamingPreferences.richPresence

        onCheckedChanged: {
            StreamingPreferences.richPresence = checked
        }

        ToolTip.delay: 700
        ToolTip.timeout: 5000
        ToolTip.visible: hovered
        ToolTip.text: qsTr("Updates your Discord status to display the name of the game you're streaming.")
    }

    CheckBox {
        Layout.fillWidth: true
        hoverEnabled: true
        text: qsTr("Keep the display awake while streaming")
        font.pixelSize: 14
        checked: StreamingPreferences.keepAwake

        onCheckedChanged: {
            StreamingPreferences.keepAwake = checked
        }

        ToolTip.delay: 700
        ToolTip.timeout: 5000
        ToolTip.visible: hovered
        ToolTip.text: qsTr("Prevents the screensaver from starting or the display from going to sleep while streaming.")
    }
}

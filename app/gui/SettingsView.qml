import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import QtQuick.Window 2.2

import StreamingPreferences 1.0
import ComputerManager 1.0
import SdlGamepadKeyNavigation 1.0
import SystemProperties 1.0

Flickable {
    id: settingsPage
    objectName: qsTr("Settings")

    signal languageChanged()

    SettingsBitrateController {
        id: bitrateController
    }

    boundsBehavior: Flickable.OvershootBounds

    contentWidth: settingsColumn1.width > settingsColumn2.width ? settingsColumn1.width : settingsColumn2.width
    contentHeight: settingsColumn1.height > settingsColumn2.height ? settingsColumn1.height : settingsColumn2.height

    ScrollBar.vertical: ScrollBar {
        anchors {
            left: parent.right
            leftMargin: -10
        }
    }

    function isChildOfFlickable(item) {
        while (item) {
            if (item.parent === contentItem) {
                return true
            }

            item = item.parent
        }
        return false
    }

    NumberAnimation on contentY {
        id: autoScrollAnimation
        duration: 100
    }

    Window.onActiveFocusItemChanged: {
        var item = Window.activeFocusItem
        if (item) {
            // Ignore non-child elements like the toolbar buttons
            if (!isChildOfFlickable(item)) {
                return
            }

            // Map the focus item's position into our content item's coordinate space
            var pos = item.mapToItem(contentItem, 0, 0)

            // Ensure some extra space is visible around the element we're scrolling to
            var scrollMargin = height > 100 ? 50 : 0

            if (pos.y - scrollMargin < contentY) {
                autoScrollAnimation.from = contentY
                autoScrollAnimation.to = Math.max(pos.y - scrollMargin, 0)
                autoScrollAnimation.start()
            }
            else if (pos.y + item.height + scrollMargin > contentY + height) {
                autoScrollAnimation.from = contentY
                autoScrollAnimation.to = Math.min(pos.y + item.height + scrollMargin - height, contentHeight - height)
                autoScrollAnimation.start()
            }
        }
    }

    StackView.onActivated: {
        // This enables Tab and BackTab based navigation rather than arrow keys.
        // It is required to shift focus between controls on the settings page.
        SdlGamepadKeyNavigation.setUiNavMode(true)

        // Highlight the first item if a gamepad is connected
        if (SdlGamepadKeyNavigation.getConnectedGamepads() > 0) {
            streamingSettingsSection.forceInitialFocus()
        }
    }

    StackView.onDeactivating: {
        SdlGamepadKeyNavigation.setUiNavMode(false)

        // Save the prefs so the Session can observe the changes
        StreamingPreferences.save()
    }

    Component.onDestruction: {
        // Also save preferences on destruction, since we won't get a
        // deactivating callback if the user just closes Moonlight
        StreamingPreferences.save()
    }

    Column {
        padding: 10
        id: settingsColumn1
        width: settingsPage.width / 2
        spacing: 15

        SettingsStreamingSection {
            id: streamingSettingsSection
            width: parent.width - (parent.leftPadding + parent.rightPadding)
            bitrateState: bitrateController
        }

        SettingsAudioSection {
            width: parent.width - (parent.leftPadding + parent.rightPadding)
        }

        SettingsHostSection {
            width: parent.width - (parent.leftPadding + parent.rightPadding)
        }

        SettingsUiSection {
            width: parent.width - (parent.leftPadding + parent.rightPadding)

            onLanguageChanged: {
                // Preserve the legacy retranslation workaround until AppView no longer needs it.
                window.clearOnBack = true
                streamingSettingsSection.languageChanged()
                settingsPage.languageChanged()
            }
        }
    }

    Column {
        padding: 10
        rightPadding: 20
        anchors.left: settingsColumn1.right
        id: settingsColumn2
        width: settingsPage.width / 2
        spacing: 15

        SettingsInputSection {
            width: parent.width - (parent.leftPadding + parent.rightPadding)
        }

        SettingsGamepadSection {
            width: parent.width - (parent.leftPadding + parent.rightPadding)
        }

        SettingsAdvancedSection {
            id: advancedSettingsSection
            width: parent.width - (parent.leftPadding + parent.rightPadding)
            bitrateState: bitrateController

            onDiscoverySettingsChanged: {
                if (window.pollingActive) {
                    ComputerManager.stopPollingAsync()
                    ComputerManager.startPolling()
                }
            }
        }
    }
}

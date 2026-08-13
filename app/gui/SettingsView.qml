import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2

import StreamingPreferences 1.0
import ComputerManager 1.0
import SdlGamepadKeyNavigation 1.0

Item {
    id: settingsPage
    objectName: qsTr("Settings")
    focus: true

    signal languageChanged()

    property int selectedSection: 0
    readonly property bool compactNavigation: width < 840

    WindowsStyle {
        id: windowsStyle
    }

    SettingsBitrateController {
        id: bitrateController
    }

    function selectSection(index) {
        if (index < 0 || index > 6) {
            return
        }

        selectedSection = index
        contentFlick.contentY = 0
    }

    function focusSelectedNavigation() {
        if (compactNavigation) {
            compactSectionSelector.forceActiveFocus(Qt.TabFocus)
            return
        }

        switch (selectedSection) {
        case 0: streamingNav.forceActiveFocus(Qt.TabFocus); break
        case 1: audioNav.forceActiveFocus(Qt.TabFocus); break
        case 2: hostNav.forceActiveFocus(Qt.TabFocus); break
        case 3: appNav.forceActiveFocus(Qt.TabFocus); break
        case 4: inputNav.forceActiveFocus(Qt.TabFocus); break
        case 5: gamepadNav.forceActiveFocus(Qt.TabFocus); break
        case 6: advancedNav.forceActiveFocus(Qt.TabFocus); break
        }
    }

    function isChildOfContent(item) {
        while (item) {
            if (item === contentFlick.contentItem) {
                return true
            }

            item = item.parent
        }

        return false
    }

    NumberAnimation {
        id: autoScrollAnimation
        target: contentFlick
        property: "contentY"
        duration: 100
    }

    Window.onActiveFocusItemChanged: {
        var item = Window.activeFocusItem
        if (!item || !isChildOfContent(item)) {
            return
        }

        var pos = item.mapToItem(contentFlick.contentItem, 0, 0)
        var scrollMargin = contentFlick.height > 100 ? windowsStyle.space24 : 0
        var nextY = contentFlick.contentY

        if (pos.y - scrollMargin < contentFlick.contentY) {
            nextY = Math.max(pos.y - scrollMargin, 0)
        }
        else if (pos.y + item.height + scrollMargin > contentFlick.contentY + contentFlick.height) {
            nextY = Math.min(pos.y + item.height + scrollMargin - contentFlick.height,
                             Math.max(contentFlick.contentHeight - contentFlick.height, 0))
        }

        if (nextY !== contentFlick.contentY) {
            autoScrollAnimation.stop()
            autoScrollAnimation.from = contentFlick.contentY
            autoScrollAnimation.to = nextY
            autoScrollAnimation.start()
        }
    }

    StackView.onActivated: {
        SdlGamepadKeyNavigation.setUiNavMode(true)

        if (SdlGamepadKeyNavigation.getConnectedGamepads() > 0) {
            focusSelectedNavigation()
        }
    }

    StackView.onDeactivating: {
        SdlGamepadKeyNavigation.setUiNavMode(false)
        StreamingPreferences.save()
    }

    Component.onDestruction: {
        StreamingPreferences.save()
    }

    Rectangle {
        anchors.fill: parent
        color: windowsStyle.background
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            id: compactNavigationBar
            visible: settingsPage.compactNavigation
            Layout.fillWidth: true
            Layout.preferredHeight: 68
            color: windowsStyle.surface

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 1
                color: windowsStyle.border
            }

            ComboBox {
                id: compactSectionSelector
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: windowsStyle.space16
                anchors.rightMargin: windowsStyle.space16
                implicitHeight: windowsStyle.touchTarget
                activeFocusOnTab: true

                model: [
                    qsTr("Streaming"),
                    qsTr("Audio"),
                    qsTr("Host"),
                    qsTr("App"),
                    qsTr("Input"),
                    qsTr("Gamepad"),
                    qsTr("Advanced")
                ]

                currentIndex: settingsPage.selectedSection
                onActivated: settingsPage.selectSection(currentIndex)
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            Rectangle {
                id: navigationRail
                visible: !settingsPage.compactNavigation
                Layout.preferredWidth: 232
                Layout.fillHeight: true
                color: windowsStyle.surface

                Rectangle {
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    width: 1
                    color: windowsStyle.border
                }

                Column {
                    anchors.fill: parent
                    anchors.margins: windowsStyle.space12
                    spacing: windowsStyle.space4

                    Label {
                        width: parent.width
                        height: 32
                        leftPadding: windowsStyle.space12
                        text: qsTr("Categories")
                        color: windowsStyle.textSecondary
                        font.pixelSize: 12
                        font.weight: Font.DemiBold
                        verticalAlignment: Text.AlignVCenter
                    }

                    SettingsNavButton {
                        id: streamingNav
                        width: parent.width
                        text: qsTr("Streaming")
                        selected: settingsPage.selectedSection === 0
                        onClicked: settingsPage.selectSection(0)
                    }

                    SettingsNavButton {
                        id: audioNav
                        width: parent.width
                        text: qsTr("Audio")
                        selected: settingsPage.selectedSection === 1
                        onClicked: settingsPage.selectSection(1)
                    }

                    SettingsNavButton {
                        id: hostNav
                        width: parent.width
                        text: qsTr("Host")
                        selected: settingsPage.selectedSection === 2
                        onClicked: settingsPage.selectSection(2)
                    }

                    SettingsNavButton {
                        id: appNav
                        width: parent.width
                        text: qsTr("App")
                        selected: settingsPage.selectedSection === 3
                        onClicked: settingsPage.selectSection(3)
                    }

                    SettingsNavButton {
                        id: inputNav
                        width: parent.width
                        text: qsTr("Input")
                        selected: settingsPage.selectedSection === 4
                        onClicked: settingsPage.selectSection(4)
                    }

                    SettingsNavButton {
                        id: gamepadNav
                        width: parent.width
                        text: qsTr("Gamepad")
                        selected: settingsPage.selectedSection === 5
                        onClicked: settingsPage.selectSection(5)
                    }

                    SettingsNavButton {
                        id: advancedNav
                        width: parent.width
                        text: qsTr("Advanced")
                        selected: settingsPage.selectedSection === 6
                        onClicked: settingsPage.selectSection(6)
                    }
                }
            }

            Flickable {
                id: contentFlick
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                focus: true
                boundsBehavior: Flickable.StopAtBounds
                contentWidth: width
                contentHeight: contentColumn.height + (windowsStyle.space24 * 2)

                ScrollBar.vertical: ScrollBar {}

                Column {
                    id: contentColumn
                    x: (contentFlick.width - width) / 2
                    y: windowsStyle.space24
                    width: Math.max(0,
                                    Math.min(contentFlick.width -
                                             (settingsPage.compactNavigation ? windowsStyle.space32 : windowsStyle.space24 * 2),
                                             960))
                    height: childrenRect.height
                    spacing: windowsStyle.space16

                    SettingsStreamingSection {
                        id: streamingSettingsSection
                        width: parent.width
                        visible: settingsPage.selectedSection === 0
                        bitrateState: bitrateController
                    }

                    SettingsAudioSection {
                        width: parent.width
                        visible: settingsPage.selectedSection === 1
                    }

                    SettingsHostSection {
                        width: parent.width
                        visible: settingsPage.selectedSection === 2
                    }

                    SettingsUiSection {
                        width: parent.width
                        visible: settingsPage.selectedSection === 3

                        onLanguageChanged: {
                            // Preserve the legacy retranslation workaround until AppView no longer needs it.
                            window.clearOnBack = true
                            streamingSettingsSection.languageChanged()
                            settingsPage.languageChanged()
                        }
                    }

                    SettingsInputSection {
                        width: parent.width
                        visible: settingsPage.selectedSection === 4
                    }

                    SettingsGamepadSection {
                        width: parent.width
                        visible: settingsPage.selectedSection === 5
                    }

                    SettingsAdvancedSection {
                        id: advancedSettingsSection
                        width: parent.width
                        visible: settingsPage.selectedSection === 6
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
        }
    }
}

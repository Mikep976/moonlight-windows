import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2

import StreamingPreferences 1.0
import SystemProperties 1.0

GroupBox {
    id: root

    property var bitrateState
    signal discoverySettingsChanged()
    width: (parent.width - (parent.leftPadding + parent.rightPadding))
    padding: 12
    title: qsTr("Advanced")
    font.pointSize: 12

    Column {
        anchors.fill: parent
        spacing: 5

        Label {
            width: parent.width
            id: resVDSTitle
            text: qsTr("Video decoder")
            font.pointSize: 12
            wrapMode: Text.Wrap
        }

        AutoResizingComboBox {
            // ignore setting the index at first, and actually set it when the component is loaded
            Component.onCompleted: {
                var saved_vds = StreamingPreferences.videoDecoderSelection
                currentIndex = 0
                for (var i = 0; i < decoderListModel.count; i++) {
                    var el_vds = decoderListModel.get(i).val;
                    if (saved_vds === el_vds) {
                        currentIndex = i
                        break
                    }
                }
                activated(currentIndex)
            }

            id: decoderComboBox
            textRole: "text"
            model: ListModel {
                id: decoderListModel
                ListElement {
                    text: qsTr("Automatic (Recommended)")
                    val: StreamingPreferences.VDS_AUTO
                }
                ListElement {
                    text: qsTr("Force software decoding")
                    val: StreamingPreferences.VDS_FORCE_SOFTWARE
                }
                ListElement {
                    text: qsTr("Force hardware decoding")
                    val: StreamingPreferences.VDS_FORCE_HARDWARE
                }
            }
            // ::onActivated must be used, as it only listens for when the index is changed by a human
            onActivated: {
                if (enabled) {
                    StreamingPreferences.videoDecoderSelection = decoderListModel.get(currentIndex).val
                }
            }
        }

        Label {
            width: parent.width
            id: resVCCTitle
            text: qsTr("Video codec")
            font.pointSize: 12
            wrapMode: Text.Wrap
        }

        AutoResizingComboBox {
            // ignore setting the index at first, and actually set it when the component is loaded
            Component.onCompleted: {
                var saved_vcc = StreamingPreferences.videoCodecConfig

                // Default to Automatic (relevant if HDR is enabled,
                // where we will match none of the codecs in the list)
                currentIndex = 0

                for(var i = 0; i < codecListModel.count; i++) {
                    var el_vcc = codecListModel.get(i).val;
                    if (saved_vcc === el_vcc) {
                        currentIndex = i
                        break
                    }
                }

                activated(currentIndex)
            }

            id: codecComboBox
            textRole: "text"
            model: ListModel {
                id: codecListModel
                ListElement {
                    text: qsTr("Automatic (Recommended)")
                    val: StreamingPreferences.VCC_AUTO
                }
                ListElement {
                    text: qsTr("H.264")
                    val: StreamingPreferences.VCC_FORCE_H264
                }
                ListElement {
                    text: qsTr("HEVC (H.265)")
                    val: StreamingPreferences.VCC_FORCE_HEVC
                }
                ListElement {
                    text: qsTr("AV1")
                    val: StreamingPreferences.VCC_FORCE_AV1
                }
            }
            // ::onActivated must be used, as it only listens for when the index is changed by a human
            onActivated : {
                if (enabled) {
                    StreamingPreferences.videoCodecConfig = codecListModel.get(currentIndex).val
                }
            }
        }

        CheckBox {
            id: enableHdr
            width: parent.width
            text: qsTr("Enable HDR")
            font.pointSize: 12

            enabled: SystemProperties.supportsHdr
            checked: enabled && StreamingPreferences.enableHdr
            onCheckedChanged: {
                StreamingPreferences.enableHdr = checked
            }

            // Updating StreamingPreferences.videoCodecConfig is handled above

            ToolTip.delay: 1000
            ToolTip.timeout: 5000
            ToolTip.visible: hovered
            ToolTip.text: enabled ?
                              qsTr("The stream will be HDR-capable, but some games may require an HDR monitor on your host PC to enable HDR mode.")
                            :
                              qsTr("HDR streaming is not supported on this PC.")
        }

        CheckBox {
            id: enableYUV444
            width: parent.width
            text: qsTr("Enable YUV 4:4:4")
            font.pointSize: 12

            checked: StreamingPreferences.enableYUV444
            onCheckedChanged: {
                bitrateState.setYuv444Enabled(checked)
            }

            ToolTip.delay: 1000
            ToolTip.timeout: 5000
            ToolTip.visible: hovered
            ToolTip.text: enabled ?
                              qsTr("Good for streaming desktop and text-heavy games, but not recommended for fast-paced games.")
                            :
                              qsTr("YUV 4:4:4 is not supported on this PC.")
        }

        CheckBox {
            id: unlockBitrate
            width: parent.width
            text: qsTr("Unlock bitrate limit (Experimental)")
            font.pointSize: 12

            checked: StreamingPreferences.unlockBitrate
            onCheckedChanged: {
                bitrateState.setUnlockBitrateEnabled(checked)
            }

            ToolTip.delay: 1000
            ToolTip.timeout: 5000
            ToolTip.visible: hovered
            ToolTip.text: qsTr("This unlocks extremely high video bitrates for use with Sunshine hosts. It should only be used when streaming over an Ethernet LAN connection.")
        }

        CheckBox {
            id: enableMdns
            width: parent.width
            text: qsTr("Automatically find PCs on the local network (Recommended)")
            font.pointSize: 12
            checked: StreamingPreferences.enableMdns
            onCheckedChanged: {
                // This is called on init, so only do the work if we've
                // actually changed the value.
                if (StreamingPreferences.enableMdns != checked) {
                    StreamingPreferences.enableMdns = checked

                    // The parent owns polling lifecycle; request a restart.
                    root.discoverySettingsChanged()
                }
            }
        }

        CheckBox {
            id: detectNetworkBlocking
            width: parent.width
            text: qsTr("Automatically detect blocked connections (Recommended)")
            font.pointSize: 12
            checked: StreamingPreferences.detectNetworkBlocking
            onCheckedChanged: {
                StreamingPreferences.detectNetworkBlocking = checked
            }
        }

        CheckBox {
            id: showPerformanceOverlay
            width: parent.width
            text: qsTr("Show performance stats while streaming")
            font.pointSize: 12
            checked: StreamingPreferences.showPerformanceOverlay
            onCheckedChanged: {
                StreamingPreferences.showPerformanceOverlay = checked
            }

            ToolTip.delay: 1000
            ToolTip.timeout: 5000
            ToolTip.visible: hovered
            ToolTip.text: qsTr("Display real-time stream performance information while streaming.") + "\n\n" +
                          qsTr("You can toggle it at any time while streaming using Ctrl+Alt+Shift+S or Select+L1+R1+X.") + "\n\n" +
                          qsTr("The performance overlay is not supported on Steam Link or Raspberry Pi.")
        }
    }
}

import QtQuick 2.9

import StreamingPreferences 1.0

QtObject {
    id: root

    signal bitrateChanged(int bitrateKbps)

    readonly property int minimumKbps: 500
    readonly property int maximumKbps: StreamingPreferences.unlockBitrate ? 500000 : 150000
    readonly property int stepKbps: 500

    function defaultBitrateKbps() {
        return StreamingPreferences.getDefaultBitrate(StreamingPreferences.width,
                                                      StreamingPreferences.height,
                                                      StreamingPreferences.fps,
                                                      StreamingPreferences.enableYUV444)
    }

    function clampBitrate(bitrateKbps, maximumOverride) {
        var maximum = maximumOverride !== undefined ? maximumOverride : maximumKbps
        return Math.max(minimumKbps, Math.min(bitrateKbps, maximum))
    }

    function setBitrate(bitrateKbps) {
        var clampedBitrate = clampBitrate(bitrateKbps)
        StreamingPreferences.bitrateKbps = clampedBitrate
        bitrateChanged(clampedBitrate)
    }

    function setUserBitrate(bitrateKbps) {
        StreamingPreferences.autoAdjustBitrate = false
        setBitrate(bitrateKbps)
    }

    function recalculateDefaultIfAutomatic() {
        if (!StreamingPreferences.autoAdjustBitrate) {
            return
        }

        setBitrate(defaultBitrateKbps())
    }

    function resetToDefault() {
        StreamingPreferences.autoAdjustBitrate = true
        setBitrate(defaultBitrateKbps())
    }

    function setYuv444Enabled(enabled) {
        // This handler is also called during QML initialization. Only recalculate
        // when the user-visible state actually differs from the stored preference.
        if (StreamingPreferences.enableYUV444 === enabled) {
            return
        }

        StreamingPreferences.enableYUV444 = enabled
        recalculateDefaultIfAutomatic()
    }

    function setUnlockBitrateEnabled(enabled) {
        StreamingPreferences.unlockBitrate = enabled

        // Binding updates may not be processed before this function returns, so use
        // the new limit explicitly when clamping instead of reading maximumKbps here.
        var newMaximum = enabled ? 500000 : 150000
        var clampedBitrate = clampBitrate(StreamingPreferences.bitrateKbps, newMaximum)
        StreamingPreferences.bitrateKbps = clampedBitrate
        bitrateChanged(clampedBitrate)
    }
}

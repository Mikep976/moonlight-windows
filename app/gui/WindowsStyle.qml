import QtQuick 2.9

QtObject {
    // Windows 11-inspired design tokens for the product layer.
    // Keep this dependency-free so it can be instantiated from any QML view.

    readonly property color background: "#202020"
    readonly property color surface: "#2B2B2B"
    readonly property color surfaceHover: "#343434"
    readonly property color surfacePressed: "#3D3D3D"
    readonly property color surfaceElevated: "#323232"
    readonly property color border: "#454545"
    readonly property color textPrimary: "#F5F5F5"
    readonly property color textSecondary: "#B8B8B8"
    readonly property color accent: "#60CDFF"
    readonly property color accentPressed: "#4CC2FF"

    readonly property int radiusSmall: 6
    readonly property int radiusMedium: 8
    readonly property int radiusLarge: 12

    readonly property int space4: 4
    readonly property int space8: 8
    readonly property int space12: 12
    readonly property int space16: 16
    readonly property int space20: 20
    readonly property int space24: 24
    readonly property int space32: 32

    // 44 px is the minimum target we want for touch-first controls.
    readonly property int touchTarget: 44
    readonly property int toolbarHeight: 64
    readonly property int iconSmall: 18
    readonly property int iconMedium: 22
    readonly property int iconLarge: 28
}

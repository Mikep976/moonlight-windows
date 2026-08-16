import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

ToolButton {
    id: control

    property string iconSource
    property WindowsStyle windowsStyle: WindowsStyle {}

    activeFocusOnTab: true
    hoverEnabled: true

    implicitWidth: Math.max(windowsStyle.touchTarget, implicitContentWidth + windowsStyle.space16)
    implicitHeight: windowsStyle.touchTarget

    icon.source: iconSource
    icon.width: windowsStyle.iconMedium
    icon.height: windowsStyle.iconMedium
    icon.color: windowsStyle.textPrimary

    padding: windowsStyle.space8
    Layout.preferredHeight: Math.max(windowsStyle.touchTarget, parent ? parent.height : windowsStyle.touchTarget)

    background: Rectangle {
        radius: windowsStyle.radiusMedium
        color: control.down ? windowsStyle.surfacePressed :
               control.hovered ? windowsStyle.surfaceHover :
               control.activeFocus ? windowsStyle.surfaceElevated : "transparent"
        border.width: control.activeFocus ? 2 : 0
        border.color: windowsStyle.accent

        Behavior on color {
            ColorAnimation { duration: 90 }
        }
    }

    Keys.onReturnPressed: {
        clicked()
    }

    Keys.onEnterPressed: {
        clicked()
    }

    Keys.onRightPressed: {
        nextItemInFocusChain(true).forceActiveFocus(Qt.TabFocus)
    }

    Keys.onLeftPressed: {
        nextItemInFocusChain(false).forceActiveFocus(Qt.TabFocus)
    }
}

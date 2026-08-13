import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Button {
    id: control

    property bool selected: false
    property WindowsStyle windowsStyle: WindowsStyle {}

    activeFocusOnTab: true
    hoverEnabled: true

    implicitHeight: windowsStyle.touchTarget
    implicitWidth: 200
    leftPadding: windowsStyle.space16
    rightPadding: windowsStyle.space12

    contentItem: Label {
        text: control.text
        color: windowsStyle.textPrimary
        font.pixelSize: 14
        font.weight: control.selected ? Font.DemiBold : Font.Normal
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        elide: Text.ElideRight
    }

    background: Rectangle {
        radius: windowsStyle.radiusMedium
        color: control.down ? windowsStyle.surfacePressed :
               control.hovered ? windowsStyle.surfaceHover :
               control.selected ? windowsStyle.surfaceElevated : "transparent"
        border.width: control.activeFocus ? 2 : 0
        border.color: windowsStyle.accent

        Rectangle {
            visible: control.selected
            width: 3
            height: Math.min(parent.height - windowsStyle.space16, 20)
            radius: 2
            anchors.left: parent.left
            anchors.leftMargin: windowsStyle.space4
            anchors.verticalCenter: parent.verticalCenter
            color: windowsStyle.accent
        }

        Behavior on color {
            ColorAnimation { duration: 90 }
        }
    }

    Keys.onDownPressed: {
        nextItemInFocusChain(true).forceActiveFocus(Qt.TabFocus)
    }

    Keys.onUpPressed: {
        nextItemInFocusChain(false).forceActiveFocus(Qt.TabFocus)
    }
}

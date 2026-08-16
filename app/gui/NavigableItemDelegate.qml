import QtQuick 2.9
import QtQuick.Controls 2.2

ItemDelegate {
    id: control

    property GridView grid
    property WindowsStyle windowsStyle: WindowsStyle {}

    hoverEnabled: true
    highlighted: grid.activeFocus && grid.currentItem === this

    background: Rectangle {
        radius: windowsStyle.radiusLarge
        color: control.down ? windowsStyle.surfacePressed :
               control.highlighted ? windowsStyle.surfaceElevated :
               control.hovered ? windowsStyle.surfaceHover : windowsStyle.surface
        border.width: control.highlighted ? 2 : 1
        border.color: control.highlighted ? windowsStyle.accent : windowsStyle.border

        Behavior on color {
            ColorAnimation { duration: 100 }
        }
    }

    Keys.onLeftPressed: {
        grid.moveCurrentIndexLeft()
    }
    Keys.onRightPressed: {
        grid.moveCurrentIndexRight()
    }
    Keys.onDownPressed: {
        grid.moveCurrentIndexDown()
    }
    Keys.onUpPressed: {
        grid.moveCurrentIndexUp()

        // If we've reached the top of the grid, move focus to the toolbar
        if (grid.currentItem === this) {
            nextItemInFocusChain(false).forceActiveFocus(Qt.TabFocus)
        }
    }
    Keys.onReturnPressed: {
        clicked()
    }
    Keys.onEnterPressed: {
        clicked()
    }
}

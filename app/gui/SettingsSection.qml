import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Item {
    id: root

    property string title
    property string description
    property WindowsStyle windowsStyle: WindowsStyle {}
    default property alias contentData: contentColumn.data

    implicitWidth: 480
    implicitHeight: contentColumn.implicitHeight + (windowsStyle.space16 * 2)
    height: implicitHeight

    Rectangle {
        id: card
        anchors.fill: parent
        radius: root.windowsStyle.radiusLarge
        color: root.windowsStyle.surface
        border.width: 1
        border.color: root.windowsStyle.border

        ColumnLayout {
            id: contentColumn
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: root.windowsStyle.space16
            spacing: root.windowsStyle.space12

            Label {
                Layout.fillWidth: true
                text: root.title
                color: root.windowsStyle.textPrimary
                font.pixelSize: 17
                font.weight: Font.DemiBold
                wrapMode: Text.Wrap
            }

            Label {
                Layout.fillWidth: true
                visible: root.description.length > 0
                text: root.description
                color: root.windowsStyle.textSecondary
                font.pixelSize: 13
                wrapMode: Text.Wrap
            }
        }
    }
}

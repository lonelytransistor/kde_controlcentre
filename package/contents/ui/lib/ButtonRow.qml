import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import org.kde.plasma.core 2.0 as PlasmaCore

GridView {
    id: root
    property var buttons: []
    property int spacing: global.smallSpacing

    readonly property var pButtons: buttons.translated !== undefined ? buttons.translated : buttons
    height: parent.height
    width: parent.width
    cellWidth: height + spacing
    cellHeight: height

    highlight: Item{}
    model: pButtons.length
    snapMode: GridView.SnapToRow
    boundsBehavior: width > cellWidth*pButtons.length ? Flickable.StopAtBounds : Flickable.DragAndOvershootBounds
    flow: GridView.FlowTopToBottom
    delegate: Item {
        width: root.cellWidth - root.spacing
        height: root.cellHeight
        TouchButton {
            anchors.centerIn: parent
            property var btn: root.pButtons[model.index]

            size: parent.height
            icon: btn.icon
            overlayLocation: btn.overlay && btn.overlay.location ? btn.overlay.location : 0
            overlayIcon: btn.overlay && btn.overlay.icon ? btn.overlay.icon : 0
            onClicked: btn.onClicked()
            onRightClicked: btn.onRightClicked()
        }
    }
}

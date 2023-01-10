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
    boundsBehavior: Flickable.StopAtBounds
    flow: GridView.FlowTopToBottom
    delegate: Button {
        id: btnRoot

        property var btn: root.pButtons[index]
        width: root.cellWidth - root.spacing
        height: root.cellHeight
        icon {
            width: btnRoot.width
            height: btnRoot.height
        }
        flat: true
        text: !!btn.text ? btn.text : ""
        ToolTip.delay: 500
        ToolTip.text: !!btn.tooltip ? btn.tooltip : ""
        ToolTip.visible: hovered && ToolTip.text != ""
        onClicked: btn.onClicked()
        Image {
            source: !!btnRoot.btn.icon ? btnRoot.btn.icon : ""
            anchors.fill: parent
            anchors.margins: 4
            onStatusChanged: if (status==Image.Error && source) { source = ""; btnRoot.icon.name = btnRoot.btn.icon }
        }
    }
}


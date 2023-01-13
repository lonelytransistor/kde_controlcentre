import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

Item {
    id: root

    signal closed
    signal opened

    signal open
    signal close

    property string title: ""
    property var title: []
    default property alias content: innerContent.children

    function updateOffset() {
        rootOffset.x = mapToItem(fullRep, 0, 0).x - global.mediumSpacing;
        rootOffset.y = mapToItem(fullRep, 0, 0).y - global.mediumSpacing;
    }
    onOpen: {
        updateOffset();
        opacity = 1;
        opened();
    }
    onClose: {
        opacity = 0;
        closed();
    }

    Item {
        id: rootOffset

        width: fullRep.width - 2*global.mediumSpacing
        height: fullRep.height - 2*global.mediumSpacing
        x: 0
        y: 0

        z: root.visible ? 3 : 0

        Label {
            id: title
            anchors {
                top: parent.top
                right: parent.right
                margins: global.smallSpacing
            }
            text: root.title
            pixelSize: global.largeFontSize
            weight: Font.Bold
        }
        RowLayout {
            id: buttons
            anchors {
                top: parent.top
                left: parent.left
                right: title.left
                margins: global.smallSpacing
            }
            spacing: global.smallSpacing
            height: 40

            ToolButton {
                id: backBtn
                anchors.fill: parent
                Icon {
                    anchors.centerIn: parent
                    size: parent.height-8
                    source: "arrow-left"
                    onPressed: parent.clicked()
                }
                ToolTip.delay: 500
                ToolTip.text: "Back"
                ToolTip.visible: hovered
                onClicked: root.hide()
            }
            Repeater {
                model: root.buttons.length
                ToolButton {
                    id: button

                    property string buttonIcon: root.buttons[index].icon
                    property string buttonTooltip: root.buttons[index].tooltip

                    visible: buttonIcon != ""
                    Icon {
                        anchors.centerIn: parent
                        size: parent.height-8
                        source: parent.buttonIcon
                        onPressed: parent.clicked()
                    }
                    ToolTip.delay: 500
                    ToolTip.text: buttonTooltip
                    ToolTip.visible: hovered
                    onClicked: root.buttons[index].onClicked()
                }
            }
        }
        Item {
            id: innerContent
            anchors {
                top: buttons.button
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                margins: global.smallSpacing
            }
            clip: true
            TouchArea {
                anchors.fill: parent
                enabled: root.visible
                z: 3
                onTouchPress: ev.accepted = false;
                onMousePress: ev.accepted = false;
            }
        }
    }
}

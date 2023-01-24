import QtQuick 2.15

ListView {
    id: listView
    property int defaultHeight: 50
    property string config: ""

    property int splitterPos: 0
    readonly property string splitterMagic: "_splitter_"

    signal moveItem(src: var, dst: var)
    signal load
    signal save
    onMoveItem: {
        if (dst) {
            if (src > dst.index) {
                model.move(src, dst.index, 1);
            } else if (src < dst.index) {
                model.move(src, dst.index-1, 1);
            }
        } else {
            model.move(src, model.count-1, 1);
        }
        updateSplitterPos();
        save();
    }
    onModelChanged: load()
    function updateSplitterPos() {
        for (let ix = 0; ix < model.count; ix++) {
            if (model.get(ix).uuid == listView.splitterMagic) {
                splitterPos = ix;
                break;
            }
        }
    }
    onLoad: {
        let order = config.split(",").filter(n => n);
        for (let ix_o = 0; ix_o < order.length; ix_o++) {
            for (let ix_m = ix_o; ix_m < model.count; ix_m++) {
                if (model.get(ix_m).uuid == order[ix_o]) {
                    model.move(ix_m, ix_o, 1);
                    break;
                }
            }
        }
        for (let ix_m = order.length; ix_m < model.count; ix_m++) {
            if (model.get(ix_m).uuid == listView.splitterMagic) {
                model.move(ix_m, order.length, 1);
                break;
            }
        }
        updateSplitterPos();
    }
    onSave: {
        let data = [];
        for (let ix_m = 0; ix_m < model.count; ix_m++) {
            if (model.get(ix_m).uuid != listView.splitterMagic) {
                data.push(model.get(ix_m).uuid);
            } else {
                break;
            }
        }
        config = data.join();
    }

    delegate: Item {
        id: listItem

        Rectangle {
            id: listItemContent
            anchors.bottom: parent.bottom
            width: parent.width
            height: listView.defaultHeight
            property var modelData: model
            Drag.dragType: Drag.Automatic
            Drag.hotSpot.x: width/2
            Drag.hotSpot.y: height
            color: {
                if (dragArea.drag.active) {
                    if ((Drag.target && Drag.target.index > listView.splitterPos) || !Drag.target) {
                        return "#f08080"
                    } else {
                        return "#a0f0a0"
                    }
                } else if (item.isSplitter) {
                    return "#202010"
                } else if (model.index > listView.splitterPos) {
                    return "#b0b0a0"
                } else {
                    return "#f0f0e0"
                }
            }
            radius: 5
            border {
                width: 1
                color: item.isSplitter ? Qt.lighter(color, 1.2) : Qt.darker(color, 1.2)
            }
            WidgetItem {
                id: item
                anchors.fill: parent
                modelData: model
                isSplitter: model.uuid == listView.splitterMagic
            }

            MouseArea {
                id: dragArea
                anchors {
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                }
                Image {
                    anchors.centerIn: parent
                    source: "../../../assets/drag.svg"
                    height: parent.height/2
                    width: parent.width
                }
                width: parent.height/2
                cursorShape: containsPress ? Qt.ClosedHandCursor : Qt.OpenHandCursor
                visible: !item.isSplitter
                drag.target: parent
                drag.axis: Drag.YAxis
                drag.smoothed: false
                drag.onActiveChanged: {
                    if (drag.active) {
                        parent.Drag.start();
                    } else {
                        listView.moveItem(model.index, parent.Drag.target);
                        parent.Drag.drop();
                    }
                }
            }
        }
        Rectangle {
            id: listItemGhost
            anchors.top: parent.top
            width: parent.width
            height: listView.defaultHeight
            opacity: 0.5
            color: {
                if (model.index > listView.splitterPos) {
                    return "#a06060"
                } else {
                    return "#60a060"
                }
            }
            property var source: dropArea.drag.source
            visible: !!source
            radius: 5
            border {
                width: 1
                color: Qt.darker(color, 1.2)
            }
            WidgetItem {
                anchors.fill: parent
                modelData: parent.source ? parent.source.modelData : undefined
            }
        }
        DropArea {
            id: dropArea
            anchors.fill: parent
            property int index: model.index
        }
        states: [
            State {
                when: dragArea.drag.active
                ParentChange {
                    target: listItemContent
                    parent: listView
                }
                PropertyChanges {
                    target: listItemContent
                    opacity: 0.8
                    anchors.bottom: undefined
                }
                PropertyChanges {
                    target: listItem
                    height: 0
                }
            }
        ]
        width: listView.width
        height: dropArea.drag.source ? listView.defaultHeight*2 : listView.defaultHeight
    }
}

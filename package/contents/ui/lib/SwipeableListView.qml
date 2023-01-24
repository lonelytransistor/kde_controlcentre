import QtQuick 2.15
import QtQuick.Layouts 1.15

ListView {
    id: root
    Layout.fillHeight: true
    Layout.fillWidth: true
    Layout.preferredWidth: width
    Layout.preferredHeight: height
    height: (children[0].children.length ? Math.min(model.count ? model.count : jsonModel.length, maxVisible)*(itemHeight + spacing) : 0) - spacing
    width: parent.width
    spacing: Global.smallSpacing

    property bool canRefresh: false
    property bool refreshPossible: false
    property double refreshHeight: 0
    property double refreshing: 0.0
    property double minYPosition: 0.0
    property double yPosition: visibleArea.yPosition
    onMovementStarted: {
        minYPosition = 0.0;
        refreshPossible = visibleArea.yPosition<=0 && canRefresh;
        refreshHeight = visibleArea.heightRatio;
    }
    onYPositionChanged: {
        minYPosition = Math.min(visibleArea.yPosition, minYPosition)
        if (refreshPossible && -minYPosition>refreshHeight) {
            interactive = false;
            minYPosition = 0.0;
            refreshPossible = false;
            refreshing = 0.025;
            refresh();
        }
    }
    Timer {
        id: refreshingTimer
        running: root.refreshing > 0.0
        interval: 10
        onTriggered: root.refreshing += 0.025
    }
    onRefreshed: {
        refreshing = 0.0;
        interactive = true;
    }

    property var jsonModel: []
    model: jsonModel.length

    property int itemHeight: 0.7*Global.sectionHeight/3 - spacing
    property int maxVisible: 3

    property var colorLeft: n => "#30f030"
    property var textLeftColor: n => "black"
    property var textLeft: n => "left"
    property var iconLeft: n => "emblem-checked"

    property var colorRight: n => "tomato"
    property var textRightColor: n => "white"
    property var textRight: n => "right"
    property var iconRight: n => "emblem-error"

    property var colorCentre: n => "transparent"
    property var textCentreColor: n => "white"
    property var textCentre: n => "centre"
    property var iconCentre: n => "battery"

    signal refresh
    signal refreshed
    signal openLeft(m: var)
    signal openRight(m: var)

    clip: true
    Item {
        id: refreshIndicator
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
        Item {
            anchors.centerIn: parent
            height: parent.height
            width: height
            RefreshIndicator {
                borderColor: "#377292"
                position: refreshIndicator.position
            }
        }
        height: 30
        property double positionMove: -Math.min((root.visibleArea.yPosition + (refreshIndicator.height/root.height)*root.refreshHeight)*6, 0)
        property double positionTimer: 1.0 + root.refreshing
        property double position: (root.refreshing > 0) ? positionTimer : positionMove
        opacity: Math.min(1.0, position*3)
        visible: root.refreshPossible || root.refreshing > 0
    }
    Rectangle {
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
        height: 2
        color: "#FFFFFF"
        opacity: 0.2
        visible: parent.visibleArea.yPosition > 0
    }
    Rectangle {
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        height: 2
        color: "#FFFFFF"
        opacity: 0.2
        visible: parent.visibleArea.yPosition < 1-parent.visibleArea.heightRatio
    }
    headerPositioning: ListView.OverlayHeader
    delegate: Swipeable {
        id: notificationItem
        width: root.width
        height: root.itemHeight

        property var pModel: root.jsonModel.length>0 ? root.jsonModel[model.index] : model

        border.color: "#FFFFFF"
        border.width: 1
        borderOpacity: 0.1

        textCentre: root.textCentre(pModel)
        textCentreColor: root.textCentreColor(pModel)
        colorCentre: root.colorCentre(pModel)
        iconCentre: root.iconCentre(pModel)

        textRight: root.textRight(pModel)
        textRightColor: root.textRightColor(pModel)
        colorRight: root.colorRight(pModel)
        iconRight: root.iconRight(pModel)

        textLeft: root.textLeft(pModel)
        textLeftColor: root.textLeftColor(pModel)
        colorLeft: root.colorLeft(pModel)
        iconLeft: root.iconLeft(pModel)

        onOpenLeft: root.openLeft(pModel)
        onOpenRight: root.openRight(pModel)

        ListView.onRemove: SequentialAnimation {
            PropertyAction {
                target: notificationItem
                property: "ListView.delayRemove"
                value: true
            }
            NumberAnimation {
                target: notificationItem
                property: "height"
                to: 0
                easing.type: Easing.InOutQuad
            }
            PropertyAction {
                target: notificationItem
                property: "ListView.delayRemove"
                value: false
            }
        }
    }
}

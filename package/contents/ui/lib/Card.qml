import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15
import QtQuick.Controls 2.15

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    id: cardRoot
    property alias small: smallRepresentation.data
    property alias big: bigRepresentation.data
    property var buttons: []
    property string leftTitle: ""
    property string leftSubtitle: ""
    property string rightTitle: ""
    property string rightSubtitle: ""

    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.margins: root.smallSpacing
    Layout.minimumHeight: height
    height: cardRootOffset.smallHeight
    width: parent.width

    z: cardRootOffset.fraction>0.0 ? 2 : 0

    property bool isExpanded: cardRootOffset.state == "expanded";
    readonly property var expand: function() {root.cards.expand(cardRoot, cardRootOffset)}
    readonly property var collapse: function() {root.cards.collapse(cardRoot, cardRootOffset)}

    signal expanded
    signal collapsed

    Item {
        id: normalView
        anchors.fill: parent

        Glow {
            id: shadow
            anchors.fill: cardRootOffset
            radius: root.mediumSpacing
            samples: 17
            color: "black"
            source: cardRootOffset
            opacity: cardRootOffset.fraction
        }
        Item {
            id: cardRootOffset
            x: 0
            y: fraction*bigOffset
            width: parent.width
            height: pHeight + smallRepresentation.height + (bigRepresentation.height - smallRepresentation.height)*fraction
            clip: true

            property double fraction: 0.0
            onFractionChanged: root.cards.update(fraction)
            property int duration: 200

            property int pHeight: Math.max(Math.max(leftTitle!=""?leftTitleO.height:0, rightTitle!=""?rightTitleO.height:0) +
                                        Math.max(leftSubtitle!=""?leftSubtitleO.height:0, rightSubtitle!=""?rightSubtitleO.height:0),
                                        buttonsO.height) + root.mediumSpacing
            property int smallHeight: pHeight + smallRepresentation.height
            property int bigHeight: pHeight + bigRepresentation.height
            property int bigOffset: 0

            TouchArea {
                id: touchArea
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    bottom: smallRepresentation.top
                }
                property int bigOffset: -cardRootOffset.bigOffset
                property bool expanded: plasmoid.expanded;
                enabled: bigRepresentation.height > smallRepresentation.height

                function updateOffset() {
                    if (cardRootOffset.state == "collapsed") {
                        let possibleOffsetTop = mapToItem(fullRep, 0, 0).y - shadow.radius;
                        let possibleOffsetBot = -fullRep.mapToItem(touchArea, 0, fullRep.height - shadow.radius - cardRootOffset.height - bigRepresentation.height + smallRepresentation.height).y;

                        let neededOffset = (bigRepresentation.height - smallRepresentation.height)/2;
                        let realOffset;
                        if (neededOffset > possibleOffsetTop) {
                            realOffset = possibleOffsetTop;
                        } else if (neededOffset < possibleOffsetBot) {
                            realOffset = possibleOffsetBot;
                        } else {
                            realOffset = neededOffset;
                        }
                        cardRootOffset.bigOffset = -realOffset;
                    }
                }
                function clamp(k, l, m) {
                    return l>m ? m : l<k ? k : l
                }
                onExpandedChanged: {
                    if (expanded) {
                        updateOffset();
                    }
                }
                onTouchMove: {
                    let delta = ev.startY - ev.y;
                    delta = cardRootOffset.state=="collapsed" ? delta : delta+bigOffset;
                    let fraction = clamp(0.0, delta/bigOffset, 1.0);
                    cardRootOffset.fraction = fraction;
                }
                onTouchPress: {
                    updateOffset();
                    ev.accepted = true;
                }
                onTouchRelease: {
                    let delta = ev.startY - ev.y;
                    if (delta > 50 && cardRootOffset.state == "collapsed") {
                        cardRoot.expand();
                    } else if (delta < -50 && cardRootOffset.state == "expanded") {
                        cardRoot.collapse();
                    } else {
                        cardRootOffset.fraction = cardRootOffset.state=="expanded" ? 1.0 : 0.0
                    }
                }
                onMousePress: {
                    ev.accepted = true;
                }
                onMouseRelease: {
                    updateOffset();
                    if (cardRootOffset.state == "expanded") {
                        cardRoot.collapse();
                    } else {
                        cardRoot.expand();
                    }
                }
            }
            states: [
                State {
                    name: "expanded"
                    PropertyChanges {
                        target: cardRootOffset
                        fraction: 1.0
                    }
                },
                State {
                    name: "collapsed"
                    PropertyChanges {
                        target: cardRootOffset
                        fraction: 0.0
                    }
                }
            ]
            transitions: [
                Transition {
                    property int duration: cardRootOffset.duration
                    NumberAnimation {
                        property: "fraction"
                        target: cardRootOffset
                        duration: cardRootOffset.duration
                        easing.type: Easing.Linear
                    }
                    onRunningChanged: {
                        if (running) {
                            if (cardRootOffset.state == "collapsed") {
                                duration = cardRootOffset.fraction*cardRootOffset.duration;
                            } else {
                                duration = (1.0 - cardRootOffset.fraction)*cardRootOffset.duration;
                            }
                        }
                    }
                }
            ]
            state: "collapsed"
            PlasmaCore.FrameSvgItem {
                anchors.fill: parent
                imagePath: "opaque/dialogs/background"
            }
            PlasmaComponents.Label {
                id: leftTitleO
                anchors {
                    top: parent.top
                    left: parent.left
                    right: rightTitleO.text ? parent.horizontalCenter : parent.right
                    leftMargin: root.mediumSpacing
                    rightMargin: root.mediumSpacing
                }
                text: cardRoot.leftTitle
                font.pixelSize: root.largeFontSize
                font.weight: Font.Bold
                font.capitalization: Font.Capitalize
                elide: Text.ElideRight
            }
            PlasmaComponents.Label {
                id: leftSubtitleO
                anchors {
                    top: leftTitleO.bottom
                    left: parent.left
                    right: rightSubtitleO.text ? parent.horizontalCenter : parent.right
                    leftMargin: root.mediumSpacing
                    rightMargin: root.mediumSpacing
                }
                text: cardRoot.leftSubtitle
                font.pixelSize: root.mediumFontSize
                font.capitalization: Font.Capitalize
                elide: Text.ElideRight
            }
            PlasmaComponents.Label {
                id: rightTitleO
                anchors {
                    top: parent.top
                    left: leftTitleO.text ? parent.horizontalCenter : parent.left
                    right: parent.right
                    leftMargin: root.mediumSpacing
                    rightMargin: root.mediumSpacing
                }
                text: cardRoot.rightTitle
                font.pixelSize: root.largeFontSize
                font.weight: Font.Bold
                font.capitalization: Font.Capitalize
                horizontalAlignment: Text.AlignRight
                elide: Text.ElideMiddle
            }
            PlasmaComponents.Label {
                id: rightSubtitleO
                anchors {
                    top: rightTitleO.bottom
                    left: leftSubtitleO.text ? parent.horizontalCenter : parent.left
                    right: parent.right
                    leftMargin: root.mediumSpacing
                    rightMargin: root.mediumSpacing
                }
                text: cardRoot.rightSubtitle
                font.pixelSize: root.mediumFontSize
                font.capitalization: Font.Capitalize
                horizontalAlignment: Text.AlignRight
                elide: Text.ElideMiddle
            }
            RowLayout {
                id: buttonsO
                anchors {
                    top: parent.top
                    horizontalCenter: parent.horizontalCenter
                    topMargin: root.smallSpacing
                }
                spacing: root.smallSpacing
                Repeater {
                    model: cardRoot.buttons.length
                    ToolButton {
                        id: button

                        property string buttonIcon: cardRoot.buttons[index].icon
                        property string buttonTooltip: cardRoot.buttons[index].tooltip

                        visible: buttonIcon != ""
                        Image {
                            source: buttonIcon
                            anchors.fill: parent
                            anchors.margins: 4
                            onStatusChanged: if (status==Image.Error && source) { source = ""; parent.icon.name = parent.buttonIcon }
                        }
                        ToolTip.delay: 500
                        ToolTip.text: buttonTooltip
                        ToolTip.visible: hovered
                        onClicked: cardRoot.buttons[index].onClicked()
                    }
                }
            }
            TouchArea {
                anchors.fill: buttonsO
            }
            ColumnLayout {
                id: smallRepresentation
                spacing: root.smallSpacing
                anchors {
                    top: leftSubtitle!=""||rightSubtitle!="" ? leftSubtitleO.bottom : leftTitleO.bottom
                    left: cardRootOffset.fraction==1 ? parent.right : parent.left
                    leftMargin: root.smallSpacing
                }
                width: parent.width - root.smallSpacing*2
                opacity: 1.0 - cardRootOffset.fraction
            }
            ColumnLayout {
                id: bigRepresentation
                spacing: root.smallSpacing
                anchors {
                    top: leftSubtitle!=""||rightSubtitle!="" ? leftSubtitleO.bottom : leftTitleO.bottom
                    left: cardRootOffset.fraction==0 ? parent.right : parent.left
                    leftMargin: root.smallSpacing
                }
                width: parent.width - root.smallSpacing*2
                opacity: cardRootOffset.fraction
            }
        }
    }
}

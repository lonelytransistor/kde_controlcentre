import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import org.kde.plasma.core 2.1 as PlasmaCore

import "." as Lib

Item {
    id: root

    property string title: ""
    property var buttons: []
    default property alias content: innerContent.children

    property bool isExpanded: rootOffset.state == "expanded";
    readonly property var expand: function(caller) {
        if (caller) {
            lampEffect.offset = (caller.mapToItem(rootOffset, 0, 0).x + caller.width/2)/rootOffset.width;
        } else {
            lampEffect.offset = 0;
        }
        Global.cards.expand(root, rootOffset);
    }
    readonly property var collapse: function(caller) {Global.cards.collapse(root, rootOffset)}
    readonly property int pHeight: visible ? height : 0
    readonly property int pWidth: visible ? width : 0

    visible: lampEffect.progress < 1.0

    signal expanded
    signal collapsed

    objectName: "FullPopup"
    parent: fullRep //FIXME

    Item {
        id: rootOffset

        width: fullRep.width
        height: fullRep.height
        x: 0
        y: 0

        z: root.visible ? 3 : 0

        function updateOffset() {
            //x = -mapToItem(fullRep, 0, 0).x + Global.mediumSpacing;
            //y = -mapToItem(fullRep, 0, 0).y + Global.mediumSpacing;
        }
        state: "collapsed"
        onStateChanged: if (state == "collapsed") updateOffset();
        states: [
            State {
                name: "expanded"
                PropertyChanges {
                    target: lampEffect
                    progress: 0.0
                }
            },
            State {
                name: "collapsed"
                PropertyChanges {
                    target: lampEffect
                    progress: 1.0
                }
            }
        ]
        transitions: [
            Transition {
                NumberAnimation {
                    target: lampEffect
                    property: "progress"
                    duration: 300
                    easing.type: Easing.Linear
                }
                onRunningChanged: {
                    if (!running) {
                        if (rootOffset.state == "expanded") {
                            root.expanded()
                        } else {
                            root.collapsed()
                        }
                    }
                }
            }
        ]

        ShaderEffect {
            id: lampEffect
            anchors.fill: parent

            property variant srcImg: lampEffectSource
            property real offset: 0.0
            property real progress: 0.0
            opacity: (1 - progress)*2
            onProgressChanged: Global.cards.update(1 - progress);
            vertexShader: "
                uniform highp mat4 qt_Matrix;
                attribute highp vec4 qt_Vertex;
                attribute highp vec2 qt_MultiTexCoord0;
                varying highp vec2 dstPos;
                void main() {
                    dstPos = qt_MultiTexCoord0;
                    gl_Position = qt_Matrix * qt_Vertex;
                }"
            fragmentShader: "
                varying highp vec2 dstPos;
                uniform sampler2D srcImg;
                uniform lowp float offset;
                uniform lowp float progress;
                uniform lowp float opacity;
                uniform lowp float qt_Opacity;
                void main() {
                    highp vec2 srcPos = dstPos;

                    lowp float a = 1.0/(0.01 + dstPos.y * dstPos.y * dstPos.y); //Multiplier
                    srcPos.x  = dstPos.x*a + (1.0-a)*offset;
                    srcPos.y += progress;

                    lowp float remainder = (dstPos.x - srcPos.x) * 1.25*max(0.8-progress, 0.0);
                    srcPos.x += remainder;

                    lowp vec2 edge0 = min(ceil(srcPos - 0.01), 1.0-floor(srcPos + 0.01));
                    lowp float edge = min(edge0.x, edge0.y);

                    gl_FragColor = edge * texture2D(srcImg, srcPos).rgba;
                    gl_FragColor *= opacity;
                }"
        }
        Item {
            id: innerContainer
            anchors.fill: parent
            Item {
                anchors {
                    fill: parent
                    topMargin: Global.mediumSpacing
                    bottomMargin: Global.mediumSpacing
                    leftMargin: Global.smallSpacing
                    rightMargin: Global.smallSpacing
                }

                PlasmaCore.FrameSvgItem {
                    anchors.fill: parent
                    imagePath: "opaque/dialogs/background"
                }
                Lib.Label {
                    id: title
                    anchors {
                        top: parent.top
                        right: parent.right
                        topMargin: Global.mediumSpacing
                        rightMargin: 2*Global.mediumSpacing
                    }
                    text: root.title
                    pixelSize: Global.largeFontSize
                    weight: Font.Bold
                }
                RowLayout {
                    id: buttonsRow
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: title.left
                        margins: Global.smallSpacing
                    }
                    spacing: Global.smallSpacing
                    height: 40

                    ToolButton {
                        id: backBtn
                        Icon {
                            anchors.centerIn: parent
                            size: parent.height-8
                            source: "arrow-left"
                            onPressed: parent.clicked()
                        }
                        ToolTip.delay: 500
                        ToolTip.text: "Back"
                        ToolTip.visible: hovered
                        onClicked: root.collapse()
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
                        top: buttonsRow.button
                        left: parent.left
                        right: parent.right
                        bottom: parent.bottom
                        margins: Global.smallSpacing
                    }
                    clip: true
                }
                TouchArea {
                    anchors.fill: parent
                    enabled: root.visible
                    z: 2
                }
            }
        }
        ShaderEffectSource {
            id: lampEffectSource
            anchors.fill: parent

            sourceItem: innerContainer
            hideSource: true
            visible: false
        }
    }
}

import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root
    anchors {
        left: parent.left
        right: parent.right
    }
    height: 50

    property color colorLeft: "transparent"
    property color textLeftColor: "black"
    property string textLeft: "left"
    property string iconLeft: "battery"

    property color colorRight: "transparent"
    property color textRightColor: "white"
    property string textRight: "right"
    property string iconRight: "battery"

    property color colorCentre: "transparent"
    property color textCentreColor: "white"
    property string textCentre: "centre"
    property string iconCentre: "battery"

    property int spacing: 10
    property int threshold: width*0.25
    property int duration: 400

    property alias border: border.border
    property double borderOpacity: 1.0

    signal openLeft
    signal openRight

    Rectangle {
        id: bgLeft
        width: parent.width
        anchors {
            top: parent.top
            bottom: parent.bottom
            right: bgCentre.left
        }
        color: root.colorLeft
        Text {
            id: textLeft
            text: root.textLeft
            color: root.textLeftColor
            anchors {
                right: iconLeft.left
                verticalCenter: parent.verticalCenter
                rightMargin: root.spacing
            }
            font.bold: true
            elide: Text.ElideRight
            maximumLineCount: 1
            wrapMode: Text.WordWrap
        }
        Button {
            id: iconLeft
            icon.name: root.iconLeft
            icon.source: root.iconLeft
            icon.height: height
            icon.width: width
            icon.color: "transparent"
            display: Button.IconOnly
            flat: true
            hoverEnabled: false
            height: parent.height*0.8
            width: height
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
                rightMargin: root.spacing
            }
        }
    }
    Rectangle {
        id: bgRight
        width: parent.width
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: bgCentre.right
        }
        color: root.colorRight
        Button {
            id: iconRight
            icon.name: root.iconRight
            icon.source: root.iconRight
            icon.height: height
            icon.width: width
            icon.color: "transparent"
            display: Button.IconOnly
            flat: true
            hoverEnabled: false
            height: parent.height*0.8
            width: height
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: root.spacing
            }
        }
        Text {
            id: textRight
            text: root.textRight
            color: root.textRightColor
            anchors {
                right: parent.right
                left: iconRight.right
                verticalCenter: parent.verticalCenter
                leftMargin: root.spacing
            }
            font.bold: true
            elide: Text.ElideRight
            maximumLineCount: 1
            wrapMode: Text.WordWrap
        }
    }
    Rectangle {
        id: bgCentre
        width: parent.width
        anchors {
            top: parent.top
            bottom: parent.bottom
        }
        states: [
            State {
                name: "leftOpened"
                PropertyChanges {
                    target: bgCentre
                    x: root.width
                }
            },
            State {
                name: "closed"
                PropertyChanges {
                    target: bgCentre
                    x: 0
                }
            },
            State {
                name: "rightOpened"
                PropertyChanges {
                    target: bgCentre
                    x: -root.width
                }
            }
        ]
        state: "closed"
        transitions: [
            Transition {
                NumberAnimation {
                    id: transitionAnimation
                    property: "x"
                    target: bgCentre
                    duration: root.duration
                    easing.type: Easing.InOutQuad
                }
                onRunningChanged: {
                    transitionAnimation.duration = root.duration

                    if (bgCentre.state != "closed" && !running) {
                        if (bgCentre.state == "leftOpened") {
                            root.openLeft()
                        } else if (bgCentre.state == "rightOpened") {
                            root.openRight()
                        }
                        bgCentre.state = "closed"
                    }
                }
            }
        ]
        x: 0
        color: root.colorCentre
        Button {
            id: icon
            icon.height: height
            icon.width: width
            display: Button.IconOnly
            flat: true
            hoverEnabled: false
            height: parent.height*0.8
            width: height
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: root.spacing
            }
            Image {
                source: !!root.iconCentre ? root.iconCentre : ""
                anchors.fill: parent
                onStatusChanged: if (status==Image.Error && source) { source = ""; icon.icon.name = root.iconCentre }
            }
        }
        Text {
            id: text
            text: root.textCentre
            color: root.textCentreColor
            anchors {
                right: parent.right
                left: icon.right
                verticalCenter: parent.verticalCenter
                leftMargin: root.spacing
            }
            elide: Text.ElideRight
            maximumLineCount: 1
            wrapMode: Text.WordWrap
        }
    }
    Rectangle {
        id: border
        anchors.fill: parent
        color: "transparent"
        opacity: root.borderOpacity
    }
    TouchArea {
        anchors.fill: parent
        property bool accept: false
        onTouchPress: {
            if (accept) {
                accept = false;
                ev.accepted = false;
                console.log("rejected swipeable")
            } else {
                ev.accepted = true;
            }
        }
        onTouchMove: {
            let deltaX = ev.x - ev.startX;
            let deltaY = ev.y - ev.startY;
            if (deltaX > root.width) {
                bgCentre.x = root.width;
            } else if (deltaX < -root.width) {
                bgCentre.x = -root.width;
            } else {
                bgCentre.x = deltaX;
            }
            if (!accept) {
                if (Math.abs(deltaX) > root.threshold) {
                    accept = true;
                } else if (Math.abs(deltaY)>30 && Math.abs(deltaY)>Math.abs(deltaX)) {
                    touchRelease(ev);
                    ev.accepted = false;
                }
            }
        }
        onTouchRelease: {
            let delta = ev.x - ev.startX;
            let duration = root.duration - root.duration*Math.abs(delta)/root.width
            transitionAnimation.duration = duration>0 ? duration : 0

            if (delta > root.threshold && delta > 0) {
                bgCentre.state = "leftOpened"
            } else if (-delta > root.threshold && delta < 0) {
                bgCentre.state = "rightOpened"
            } else if (bgCentre.state == "closed") {
                bgCentre.x = 0
            } else {
                bgCentre.state = "closed"
            }
            accept = false;
        }
        onMousePress: {
            ev.accepted = true;
        }
        onMouseRelease: {
            bgCentre.state = (ev.button == Qt.RightButton) ? "rightOpened" : "leftOpened"
        }
    }
}

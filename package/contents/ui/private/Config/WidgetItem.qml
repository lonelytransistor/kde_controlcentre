import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root
    property bool isSplitter: false
    property var modelData
    readonly property var info: modelData ? modelData : {"icon": "", "title": "", "description": "", "splitter": false}

    WidgetIcon {
        id: icon
        anchors {
            top: parent.top
            left: parent.left
        }
        size: parent.height
        source: info.icon
        glow: true
    }
    Text {
        id: title
        anchors {
            right: parent.right
            left: parent.left
            top: parent.top
        }
        height: parent.height*0.2
        color: root.isSplitter ? "#ffffff" : "#000000"
        font.bold: true
        font.pointSize: height ? height : 1
        text: info.title
        horizontalAlignment: Text.AlignHCenter
    }
    Text {
        id: description
        anchors {
            right: parent.right
            left: title.left
            top: title.bottom
            bottom: parent.bottom
            topMargin: title.height
        }
        color: root.isSplitter ? "#ffffff" : "#000000"
        font.pointSize: height ? height/4 : 1
        text: info.description
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
    }
}

import QtQuick 2.7
import QtQuick.Controls 2.0

TextField {
    id: root

    property string icon: ""

    placeholderText: qsTr("User name")
    color: mainTextColor
    font.pointSize: 14
    font.family: "fontawesome"
    leftPadding: 30
    width: parent.width*0.7
    height: 50
    background: Rectangle {
        anchors.fill: parent
        color: "transparent"
        Text {
            text: root.icon
            font.pointSize: 14
            font.family: "fontawesome"
            color: mainAppColor
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            leftPadding: 10
        }

        Rectangle {
            width: parent.width - 10
            height: 1
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            color: mainAppColor
        }
    }
}

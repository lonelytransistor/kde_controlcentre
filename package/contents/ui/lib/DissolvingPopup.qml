import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Item {
    id: root
    width: 64
    height: 64
    property string image: ""
    default property var content

    signal finished

    readonly property var show: function(_x, _y) {
        popupLoader.xp = _x - width*2;
        popupLoader.yp = _y - 5*height/2;
        popupLoader.active = true;
    }
    Loader {
        id: popupLoader
        sourceComponent: popupComponent
        active: false

        signal unload
        property int xp: 0
        property int yp: 0
        onUnload: {
            active = false;
            root.finished();
        }
    }
    Component {
        id: popupComponent
        Window {
            id: popupWindow

            x: popupLoader.xp
            y: popupLoader.yp
            width: root.width*4
            height: root.height*4
            flags: Qt.ToolTip
            color: "transparent"
            visible: true

            Image {
                id: heartImg
                x: 3*root.width/2 + xOffset
                y: 3*root.height/2 + yOffset
                width: root.width
                height: root.height
                property int xOffset: 0
                property int yOffset: 0

                mipmap: true
                sourceSize.width: width
                sourceSize.height: height
                source: root.image ? root.image : ""
                fillMode: Image.PreserveAspectFit
                children: root.content ? root.content : []

                ParallelAnimation {
                    running: true
                    NumberAnimation {
                        properties: "yOffset"
                        target: heartImg
                        duration: 1000
                        to: -100
                        easing.type: Easing.InSine
                    }
                    SequentialAnimation {
                        NumberAnimation {
                            properties: "xOffset"
                            target: heartImg
                            duration: 250
                            to: 5
                            easing.type: Easing.OutSine
                        }
                        NumberAnimation {
                            properties: "xOffset"
                            target: heartImg
                            duration: 500
                            to: -5
                            easing.type: Easing.InSine
                        }
                        NumberAnimation {
                            properties: "xOffset"
                            target: heartImg
                            duration: 250
                            to: 0
                            easing.type: Easing.InSine
                        }
                    }
                    NumberAnimation {
                        properties: "opacity"
                        target: heartImg
                        duration: 1000
                        from: 1.0
                        to: 0.0
                    }
                    onFinished: popupLoader.unload();
                }
            }
        }
    }
}

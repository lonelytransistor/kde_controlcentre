import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: root

    width: size
    height: size
    property int size: Global.largeFontSize*2
    property alias icon: btnIcon.source
    property alias overlayIcon: btnIcon.overlayIcon
    property alias overlayLocation: btnIcon.overlayLocation

    signal clicked
    signal rightClicked

    property int longTouchDuration: 500

    Rectangle {
        anchors.centerIn: parent
        property int size: root.size
        width: size
        height: size
        radius: size/2
        color: "#fff"
        opacity: 0.1
    }
    Rectangle {
        id: touchCircle
        anchors.centerIn: parent

        property int size: 0
        property bool touched: false
        property bool animating: false
        property bool longTouched: false
        property int shortAnimation: 125
        property int longAnimation: root.longTouchDuration*3
        onTouchedChanged: {
            animating = true;

            if (touched) {
                circleAnimation.duration = longAnimation;
                circleAnimation.from = 0;
                circleAnimation.start();
                visible = true;
            } else {
                circleAnimation.stop();
                circleAnimation.from = size;
                circleAnimation.duration = shortAnimation;
                circleAnimation.start();
                opacityAnimation.start();
            }
        }
        signal pressedL
        signal pressedR
        onPressedL: {
            circleAnimation.duration = shortAnimation;
            circleAnimation.start();
            opacityAnimation.start();
            visible = true;
        }
        onPressedR: {
            circleAnimation.duration = shortAnimation;
            circleAnimation.start();
            opacityAnimation.start();
            colorAnimation.start();
            visible = true;
        }
        onSizeChanged: {
            if (touched && size > root.size/3) {
                longTouched = true;
                colorAnimation.start();
            }
        }
        onOpacityChanged: {
            if (opacity == 0) {
                circleAnimation.stop();
                colorAnimation.stop();
                color = "#fff";
                size = 0;
                visible = false;
                animating = false;
                opacity = 0.3;
            }
        }

        width: size
        height: size
        radius: size/2
        color: "#fff"
        opacity: 0.3
        visible: false

        NumberAnimation {
            id: circleAnimation
            target: touchCircle
            from: 0
            to: root.size
            property: "size"
        }
        NumberAnimation {
            id: opacityAnimation
            target: touchCircle
            to: 0
            property: "opacity"
            duration: touchCircle.shortAnimation*4
        }
        PropertyAnimation {
            id: colorAnimation
            target: touchCircle
            property: "color"
            to: "#aaf"
            duration: touchCircle.shortAnimation
        }
    }
    Icon {
        id: btnIcon
        size: parent.size
        source: root.icon
    }
    TouchArea {
        anchors.fill: parent
        onTouchPress: {
            if (touchCircle.animating) {
                ev.accepted = false;
            } else {
                touchCircle.touched = true;
                ev.accepted = true;
            }
        }
        onTouchMove: {
            var deltaX = Math.abs(ev.startX - ev.x);
            var deltaY = Math.abs(ev.startY - ev.y);
            if (deltaX > width/2 || deltaY > height/2) {
                touchCircle.touched = false;
                ev.accepted = false;
            }
        }
        onTouchRelease: {
            if (touchCircle.longTouched) {
                root.rightClicked();
            } else {
                root.clicked();
            }
            touchCircle.touched = false;
            touchCircle.longTouched = false;
        }
        onMousePress: ev.accepted = true;
        onMouseRelease: {
            if (ev.button == Qt.RightButton) {
                touchCircle.pressedR();
                root.rightClicked();
            } else {
                touchCircle.pressedL();
                root.clicked();
            }
            ev.accepted = true;
        }
    }
}

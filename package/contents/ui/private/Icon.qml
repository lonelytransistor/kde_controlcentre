import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.2
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import QtGraphicalEffects 1.15
import Utilities 1.0

Item {
    id: root
    height: size
    width: size
    property int size: plasmoid.rootItem.largeFontSize*2
    property bool glow: false
    property color glowColor: rootIcon.invertedColor
    property string source: root.source
    readonly property color averageColor: root.averageColor

    signal pressed

    function getImageAverageColor(item, cb) {
        if (item.width > 0 && item.height > 0 && item.parent) {
            item.grabToImage(result => cb(utilsInternal.getAverageColor(result)));
        }
    }
    function getInvertedColor(color) {
        if (color) {
            return Qt.rgba(1-color.r, 1-color.g, 1-color.b, color.a);
        } else {
            return Qt.rgba(0,0,0,0);
        }
    }
    function getAverageColor() {
        if ((rootIcon.windowObj && rootIcon.windowObjVisible) && ((icon.source && icon.valid) || (image.source && image.status == Image.Ready))) {
            getImageAverageColor(rootIcon, c => rootIcon.averageColor = c);
        }
    }
    Glow {
        id: shadow
        anchors.fill: rootIcon
        radius: 5
        samples: 10
        color: root.glowColor
        source: rootIcon
        visible: root.glow
    }
    Item {
        id: rootIcon
        anchors.fill: parent

        property bool glow: false
        property color glowColor: invertedColor

        property color averageColor
        property color invertedColor: getInvertedColor(averageColor);
        property var windowObj: undefined
        property bool windowObjVisible: windowObj ? windowObj.visible : false

        Utilities{id: utilsInternal}

        onWindowObjVisibleChanged: getAverageColor();
        onWindowChanged: rootIcon.windowObj = window;

        PlasmaCore.IconItem {
            id: icon
            anchors.fill: parent
            onSourceChanged: getAverageColor();
            onValidChanged: getAverageColor();
            onWidthChanged: getAverageColor();
            onHeightChanged: getAverageColor();
        }
        Image {
            id: image
            anchors.fill: parent

            source: {
                if (plasmoid.rootItem.misc.getImageType(root.source) == "") {
                    icon.source = root.source
                    return ""
                } else {
                    return root.source
                }
            }
            onSourceChanged: getAverageColor();
            onWidthChanged: getAverageColor();
            onHeightChanged: getAverageColor();
            onStatusChanged: {
                getAverageColor();
                if (status == Image.Error && source) {
                    icon.source = source
                    source = ""
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            onPressed: root.pressed();
        }
    }
}

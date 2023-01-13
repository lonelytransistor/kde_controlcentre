import QtQuick 2.15
import "../private" as Private

Private.LibIcon {
    id: root

    property string overlayIcon: ""
    property string overlayLocation: ""
    Private.LibIcon {
        id: overlayIcon

        visible: root.overlayLocation && root.overlayIcon
        property string place: visible ? root.overlayLocation : ""
        source: visible ? root.overlayIcon : ""
        size: {
            if (place == "fill") {
                return parent.size;
            } else if (!visible) {
                return 0;
            }
            return parent.size/3;
        }
        x: {
            if (place == "fill") {
                return 0;
            }
            if (place.split("-")[1] == "right") {
                return 2*parent.size/3;
            }
            return 0;
        }
        y: {
            if (place == "fill") {
                return 0;
            }
            if (place.split("-")[0] == "bottom") {
                return 2*parent.size/3;
            }
            return 0;
        }
    }
}

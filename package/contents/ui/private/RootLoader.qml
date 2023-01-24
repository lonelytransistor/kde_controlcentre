import QtQuick 2.15
import org.kde.plasma.plasmoid 2.0

Loader {
    id: root

    readonly property var fn: Global.misc.object
    readonly property var pChildren: fn.findChild(root, n => n.objectName==="Card")
    readonly property bool expanded: plasmoid.expanded

    z: fn.max(pChildren, "z");

    function updateParams() {
        width = fn.max(pChildren, "pWidth");
        height = fn.sum(pChildren, "pHeight");
    }
    onStatusChanged: {
        if (status === Loader.Ready) {
            for (var child of pChildren) {
                child.pWidthChanged.connect(updateParams);
                child.pHeightChanged.connect(updateParams);
            }
            updateParams();
        }
    }
    onExpandedChanged: {
        if (expanded) {
            updateParams();
        }
    }
}

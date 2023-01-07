import QtQuick 2.15
import org.kde.plasma.plasmoid 2.0
import "../lib"

Rectangle {
    objectName: "dismiss"
    anchors.fill: parent
    anchors.margins: -50
    color: "black"
    opacity: 0.3 * global.cards.fraction
    z: 1

    readonly property bool expanded: plasmoid.expanded
    onExpandedChanged: if (!expanded) global.cards.collapseAll()

    TouchArea {
        anchors.fill: parent
        enabled: global.cards.fraction == 1.0
        z: 1
        onTouchPress: {
            ev.accepted = true;
        }
        onTouchRelease: {
            global.cards.collapseAll();
            ev.accepted = true;
        }
        onMousePress: {
            global.cards.collapseAll();
            ev.accepted = true;
        }
        onMouseRelease: {
            ev.accepted = true;
        }
    }
}

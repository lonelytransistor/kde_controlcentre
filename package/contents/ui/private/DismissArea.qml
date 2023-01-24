import QtQuick 2.15
import org.kde.plasma.plasmoid 2.0
import "../lib"

Rectangle {
    objectName: "dismiss"
    anchors.fill: parent
    anchors.margins: -50
    color: "black"
    opacity: 0.3 * Global.cards.fraction
    z: 1

    readonly property bool expanded: plasmoid.expanded
    onExpandedChanged: if (!expanded) Global.cards.collapseAll()

    TouchArea {
        anchors.fill: parent
        enabled: Global.cards.fraction == 1.0
        z: 1
        onTouchPress: {
            ev.accepted = true;
        }
        onTouchRelease: {
            Global.cards.collapseAll();
            ev.accepted = true;
        }
        onMousePress: {
            Global.cards.collapseAll();
            ev.accepted = true;
        }
        onMouseRelease: {
            ev.accepted = true;
        }
    }
}

import QtQml 2.0
import QtQuick 2.0
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.0

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

DropArea {
    id: compactRep
    
    onEntered: {
        if (drag.hasUrls) {
            plasmoid.expanded = true
        }
    }

    PlasmaCore.IconItem {
        anchors.fill: parent
        source: root.mainIconName
        smooth: true

        MouseArea {
            anchors.fill: parent
            onClicked: {
                plasmoid.expanded = !plasmoid.expanded
            }
        }
    }
}

import QtQuick 2.0
import QtQuick.Controls 2.15

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.1 as PlasmaCore
import org.kde.plasma.private.volume 0.1 as Vol

import "private" as Private
import "private/Globals" as PrivateGlobals

Rectangle {
    id: ini
    
    //clip: true
    property bool t: false

    Component{ id: dummy; Item{} }
    Component{ id: globalComponent; PrivateGlobals.Globals{} }
    Component{ id: fullRepComponent; FullRepresentation{} }
    Component{ id: compRepComponent; CompactRepresentation{} }
    readonly property bool inPanel: (
           Plasmoid.location === PlasmaCore.Types.TopEdge
        || Plasmoid.location === PlasmaCore.Types.RightEdge
        || Plasmoid.location === PlasmaCore.Types.BottomEdge
        || Plasmoid.location === PlasmaCore.Types.LeftEdge)
    Plasmoid.preferredRepresentation: inPanel ? plasmoid.compactRepresentation : plasmoid.fullRepresentation
    Plasmoid.fullRepresentation: t ? fullRepComponent : dummy
    Plasmoid.compactRepresentation: t ? compRepComponent : dummy
    property var globalObject

    Component.onCompleted: {
        Math.clamp = (num, min, max) => Math.min(Math.max(num, min), max);
        Math.bigger = (num, ...args) => {
            var ret = -Infinity;
            for (const arg of args) {
                if (arg <= num) {
                    ret = Math.max(ret, arg);
                }
            }
            return ret==-Infinity ? num : ret;
        }
        Math.smaller = (num, ...args) => {
            var ret = Infinity;
            for (const arg of args) {
                if (arg >= num) {
                    ret = Math.min(ret, arg);
                }
            }
            return ret==Infinity ? num : ret;
        }

        globalObject = globalComponent.createObject();
        InitMainQml(Qt.resolvedUrl("."), globalObject);
        t = true;
    }
}

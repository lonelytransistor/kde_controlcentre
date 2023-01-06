import QtQuick 2.15
import QtQuick.Layouts 1.15

import org.kde.plasma.plasmoid 2.0

import "private" as Private
import "Components" as Components

// Despite all of this being an ugly hack, this works waaaay better in terms of dynamically adjusted plasmoid size.
// It's a code only a mother could love. So I guess I like it.
Item {
    width: fullRep.width
    height: fullRep.height
    onWidthChanged: if (parent) parent.width = fullRep.width
    onHeightChanged: if (parent) parent.height = fullRep.height

    ListView {
        id: fullRep
        readonly property var config: plasmoid.configuration.widgetOrder.split(",").filter(n => n)
        interactive: false
        model: config
        width: global.fullRepWidth
        height: global.misc.object.sum(children && children.length ? children[0].children : null, "height", n => n.objectName && n.objectName!=="dismiss");
        anchors.left: parent.left
        anchors.bottom: parent.bottom

        property var battery: Component{Components.Battery{}}
        property var volume: Component{Components.Volume{}}
        property var mpris: Component{Components.MPRIS2{}}
        property var brightness: Component{Components.Brightness{}}
        property var kdeconnect: Component{Components.KDEConnect{}}

        delegate: Private.RootLoader {
            objectName: fullRep.config[model.index]
            sourceComponent: objectName == "battery"    ? fullRep.battery :
                             objectName == "volume"     ? fullRep.volume :
                             objectName == "mpris"      ? fullRep.mpris :
                             objectName == "brightness" ? fullRep.brightness :
                             objectName == "kdeconnect" ? fullRep.kdeconnect : null
        }
        Private.DismissArea{}
        Private.GlobalTouchArea{id:touchRoot}
    }
}

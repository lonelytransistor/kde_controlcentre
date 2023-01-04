import QtQuick 2.15
import QtQuick.Layouts 1.15

import org.kde.plasma.plasmoid 2.0

import "lib"
import "Components" as Components

Item {
    id: fullRep

    // PROPERTIES
    Layout.preferredWidth: root.fullRepWidth
    Layout.preferredHeight: componentContainer.implicitHeight
    Layout.minimumWidth: Layout.preferredWidth
    Layout.maximumWidth: Layout.preferredWidth
    Layout.minimumHeight: Layout.preferredHeight
    Layout.maximumHeight: Layout.preferredHeight
    clip: true
    
    // Lists all available network connections
    //Components.SectionNetworks{
    //    id: sectionNetworks
    //}

    ColumnLayout {
        id: componentContainer
        anchors.fill: parent
        spacing: 0
        Rectangle {
            anchors.fill: parent
            color: "black"
            opacity: 0.3 * root.cards.fraction
            z: 1
            TouchArea {
                anchors.fill: parent
                enabled: root.cards.fraction == 1.0
                z: 1
                onTouchPress: {
                    ev.accepted = true;
                }
                onTouchRelease: {
                    root.cards.collapseAll();
                    ev.accepted = true;
                }
                onMousePress: {
                    root.cards.collapseAll();
                    ev.accepted = true;
                }
                onMouseRelease: {
                    ev.accepted = true;
                }
            }
        }
    }

    property var objects: []
    readonly property var components: Item {
        property var battery: Component{Components.Battery{}}
        property var volume: Component{Components.Volume{}}
        property var mpris: Component{Components.MPRIS2{}}
        property var brightness: Component{Components.Brightness{}}
        property var kdeconnect: Component{Components.KDEConnect{}}
    }
    readonly property var config: plasmoid.configuration.widgetOrder
    onConfigChanged: instantiateComponents()
    function instantiateComponents() {
        let order = config.split(",").filter(n => n);

        while (objects.length > 0) {
            objects.pop().destroy();
        }

        for (var ix = 0; ix < order.length; ix++) {
            var component = components[order[ix]];
            if (component) {
                objects.push(component.createObject(componentContainer, {}));
            } else {
                console.log("Unknown component uuid:", order[ix]);
            }
        }
    }
    GlobalTouchArea {
        id: touchRoot
        anchors.fill: parent
    }
}

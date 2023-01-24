import QtQuick 2.15
import QtQuick.Layouts 1.15

import org.kde.plasma.plasmoid 2.0

import "private" as Private
import "Components" as Components
import "lib" as Lib

// Despite all of this being an ugly hack, this works waaaay better in terms of dynamically adjusted plasmoid size.
// It's a code only a mother could love. So I guess I like it.
Item {
    width: fullRep.width
    height: fullRep.height
    onWidthChanged: if (parent) parent.width = fullRep.width
    onHeightChanged: if (parent) parent.height = fullRep.height

    Private.WidgetIterator {
        id: allWidgets
    }
    ListView {
        id: fullRep
        interactive: false
        model: allWidgets.status ? allWidgets.config.length : 0
        width: Global.fullRepWidth
        height: Global.misc.object.sum(children && children.length ? children[0].children : null, "height", n => n.objectName && n.objectName!=="dismiss");
        anchors.left: parent.left
        anchors.bottom: parent.bottom

        property int childrenCount: 0
        property bool finishedLoading: model>0 ? childrenCount==model : false
        onFinishedLoadingChanged: {
            Global.finishedLoading = finishedLoading
            if (finishedLoading) {
                allWidgets.clear();
            }
        }

        delegate: Private.RootLoader {
            objectName: allWidgets.config[model.index]
            Component.onCompleted: fullRep.childrenCount++
            Component.onDestruction: fullRep.childrenCount--
            sourceComponent: {
                if (allWidgets.widgets && allWidgets.widgets[objectName] && allWidgets.widgets[objectName].component) {
                    return allWidgets.widgets[objectName].component;
                } else {
                    return null;
                }
            }
        }
        Component.onCompleted: dismissRoot.parent = (fullRep.children[0].objectName != "dismiss" ? fullRep.children[0] : fullRep)
        Private.DismissArea{id:dismissRoot}
        Private.GlobalTouchArea{id:touchRoot}
    }
}

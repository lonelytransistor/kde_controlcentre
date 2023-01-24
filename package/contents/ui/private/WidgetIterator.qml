import QtQuick 2.15
import Qt.labs.folderlistmodel 2.15
import org.kde.plasma.plasmoid 2.0

Item {
    id: root

    readonly property bool status: folderModel.ready
    readonly property alias widgets: folderModel.widgets
    readonly property alias widgetNames: folderModel.widgetNames
    readonly property var config: plasmoid.configuration.widgetOrder.split(",").filter(n => n)
    signal clear
    onClear: {
        console.log("Clearing cached widgets");
        var obj = folderModel.objectsToDestroy.pop();
        while (obj) {
            obj.destroy();
            obj = folderModel.objectsToDestroy.pop();
        }
    }

    FolderListModel {
        id: folderModel
        folder: "../Components"
        nameFilters: ["*.qml"]
        showDirs: false
        showOnlyReadable: true
        readonly property var suppress: Global.misc.std.suppress
        readonly property var compress: Global.compression.lz.compressToBase64
        readonly property var decompress: Global.compression.lz.decompressFromBase64
        property var objectsToDestroy: []
        property var widgets: {}
        property bool ready: false
        property var widgetNames: []
        onStatusChanged: {
            if (status == FolderListModel.Ready) {
                var widgetCache = JSON.parse(plasmoid.configuration.widgetCache ? decompress(plasmoid.configuration.widgetCache) : "{}");
                if (!widgetCache)
                    widgetCache = {};

                var widgetList = [];
                var widgetDict = {};
                var widgetUUID = {};
                for (var ix=0; ix<count; ix++) {
                    var path = get(ix, "fileName");
                    var name = get(ix, "fileBaseName");
                    var component = Qt.createComponent(folder + "/" + path);

                    if (widgetCache && widgetCache[name]) {
                        widgetDict[name] = widgetCache[name];
                    } else {
                        var obj = component.createObject();
                        if (!obj) {
                            console.warn("Object creation failed!", path, name);
                            continue;
                        }
                        var info = obj.widgetInfo;
                        var objDict = {
                            "title": info.title,
                            "description": info.description,
                            "icon": info.icon,
                            "uuid": info.uuid,
                            "path": path
                        };
                        objectsToDestroy.push(obj);
                        widgetDict[name] = objDict;
                    }

                    if (widgetDict[name]) {
                        var info = widgetDict[name];

                        widgetList.push(info.uuid);
                        widgetUUID[info.uuid] = {
                            "title": info.title,
                            "description": info.description,
                            "icon": info.icon,
                            "path": info.path,
                            "component": component
                        }
                    }
                }
                widgetDict = compress(JSON.stringify(widgetDict));
                if (widgetDict != widgetCache) {
                    plasmoid.configuration.widgetCache = widgetDict;
                }
                if (widgetUUID && widgetList && widgetList.length>0) {
                    widgets = widgetUUID;
                    widgetNames = widgetList;
                    ready = true;
                }
            }
        }
    }
}

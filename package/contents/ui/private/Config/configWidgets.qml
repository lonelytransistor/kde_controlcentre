import QtQuick 2.0
import QtQuick.Controls 2.0
import "../Globals" as PrivateGlobals

WidgetList {
    id: widgetList
    property alias cfg_widgetOrder: widgetList.config

    PrivateGlobals.Compression { id: compression }
    ListModel { id: widgetModel }
    Component.onCompleted: {
        widgetModel.clear();
        var cacheStr = compression.lz.decompressFromBase64(plasmoid.configuration.widgetCache);
        var cache = JSON.parse(cacheStr ? cacheStr : "{}");
        for (var path of Object.getOwnPropertyNames(cache)) {
            widgetModel.append(cache[path]);
        }
        widgetModel.append({
            "title": "Hidden widgets",
            "description": "Drag widgets you don't want to see below this point.",
            "icon": "",
            "uuid": splitterMagic
        });
        model = widgetModel;
    }
    model: ListModel {}
}

import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root

    property var dict: {}
    property var model
    property var filter: n=>n

    property var translated: []
    property var pTranslated: []
    property var instances: Item {
        Repeater {
            model: root.model
            Item {
                Component.onCompleted: {
                    if (model.index == 0) {
                        root.pTranslated = [];
                    }
                    var dict = {};
                    for (var outVar of Object.keys(root.dict)) {
                        var type = typeof root.dict[outVar];
                        if (type === "string") {
                            dict[outVar] = model[root.dict[outVar]];
                        } else if (type === "function") {
                            dict[outVar] = root.dict[outVar](model);
                        }
                    }
                    if (root.filter(model)) {
                        root.pTranslated.push(dict);
                    }
                    if (model.index === root.model.count-1 || model.index === root.model.length-1 || model.index === root.model.size-1) {
                        root.translated = root.pTranslated.concat([]);
                    }
                }
            }
        }
    }
}

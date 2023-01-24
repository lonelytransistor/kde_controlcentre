import QtQuick 2.15
import QtQuick.Layouts 1.15

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

Row {
    id: labelRoot
    spacing: 0

    property string text: ""
    property int pixelSize: Global.mediumFontSize
    property var weight: Font.Bold

    function split(str) {
        var list = str.split(/\|(icon:.*?:.*?)\|/gm).filter(n => n);
        var model = [];
        for (var ix = 0; ix < list.length; ix++) {
            var _text = ""; var _icon = ""; var _alttext = "";

            if (list[ix].substring(0, 5) == "icon:") {
                var _tmp = list[ix].split(":");
                _icon = _tmp[1];
                _alttext = _tmp[2];
            } else {
                _text = list[ix];
            }
            if (!_icon && _text && list[ix+1] && list[ix+1].substring(0, 5) == "icon:") {
                ix++;
                var _tmp = list[ix].split(":");
                _icon = _tmp[1];
                _alttext = _tmp[2];
            }
            model.push({
                "text": _text,
                "icon": _icon,
                "alttext": _alttext
            })
        }
        return model;
    }

    Repeater {
        id: repeater
        model: split(labelRoot.text)
        delegate: Item {
            Layout.preferredWidth: width
            Layout.preferredHeight: height
            Layout.fillHeight: true
            Layout.fillWidth: true
            height: text||icon||alttext ? label.height : 0
            width: text||icon||alttext ? label.width + icon.width : 0
            objectName: "LabelPart"

            property string text: repeater.model[model.index].text
            property string icon: repeater.model[model.index].icon
            property string alttext: repeater.model[model.index].alttext

            PlasmaComponents.Label {
                id: label
                anchors.left: parent.left

                font.pixelSize: labelRoot.pixelSize
                font.weight: labelRoot.weight

                text: parent.text
                visible: text!=""
            }
            PlasmaCore.IconItem {
                id: icon
                anchors {
                    left: text.visible ? text.right : parent.left
                    verticalCenter: text.visible ? text.verticalCenter : parent.verticalCenter
                }
                width: valid ? height : 0
                height: valid ? text.height : 0
                onSourceChanged: {
                    if (!valid && source && source.substring(source.length-8, source.length) != "-desktop") {
                        source += "-desktop"
                    } else if (!valid && source) {
                        text.text += " " + alttext;
                    }
                }
                source: parent.icon
            }
        }
    }
}

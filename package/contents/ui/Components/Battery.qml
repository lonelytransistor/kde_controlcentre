import QtQuick 2.15
import QtQuick.Layouts 1.15

import "../lib" as Lib
import ".."

Lib.Card {
    widgetInfo: WidgetInfo {
        title: "Battery info"
        description: "A small battery widget with a battery charge/rate graph."
        icon: "battery-good"
        uuid: "battery"
    }

    readonly property var battery: Global.sources.powerManagement.battery
    readonly property var inhibitions: Global.sources.powerManagement.inhibitions
    readonly property var lid: Global.sources.powerManagement.lid
    readonly property var history: battery.history.charge

    leftTitle: "Battery"
    leftSubtitle: battery.status
    rightTitle: (battery.charging ? "🗲 " : "") + battery.percent + "%"
    rightSubtitle: battery.timeStatus

    buttons: [{
        "icon": inhibitions.present ? "../../assets/coffee_on.svg" : "../../assets/coffee_off.svg",
        "tooltip": inhibitions.present ? "Release sleep inhibition" : "Inhibit sleep",
        "onClicked": function() {
            if (inhibitions.present) {
                inhibitions.uninhibit()
            } else {
                inhibitions.inhibit()
            }
        }}, {
        "icon": lid.inhibited ? "../../assets/laptop_on.svg" : "../../assets/laptop_off.svg",
        "tooltip": lid.inhibited ? "Release lid closure inhibition" : "Inhibit lid closure",
        "onClicked": function() {
            if (lid.inhibited) {
                lid.uninhibit()
            } else {
                lid.inhibit()
            }
        }}
    ]
    small: [
        Lib.ProgressBar {
            icon: battery.icon
            value: battery.percent
            highlight: Math.max(0, Math.min(battery.rate, 100))
        },
        Lib.Label {
            text: {
                if (inhibitions.list.length == 0) {
                    return "";
                } else if (inhibitions.list.length == 1) {
                    var name = inhibitions.list[0]["Name"];
                    var icon = inhibitions.list[0]["Icon"];
                    return "|icon:" + icon + ":" + name + "| blocks sleep."
                } else {
                    let text = "";
                    let icons = 0;
                    for (let ix in inhibitions.list) {
                        var icon = inhibitions.list[ix]["Icon"];
                        if (icon) {
                            text += "|icon:" + icon + ":, " + icon + "|";
                            icons++;
                        }
                    }
                    for (let ix in inhibitions.list) {
                        var name = inhibitions.list[ix]["Name"];
                        var icon = inhibitions.list[ix]["Icon"];
                        if (icons && !icon && name) {
                            text += ", ";
                            text += name;
                        }
                    }
                    text += " block sleep.";
                    return text;
                }
            }
        }
    ]
    big: [
        Lib.ProgressBar {
            icon: battery.icon
            value: battery.percent
            highlight: Math.max(0, Math.min(battery.rate, 100))
        },
        Lib.Graph {
            id: graph
            width: parent.width
            height: width/2
            Layout.preferredWidth: width
            Layout.preferredHeight: width/2

            data: history.points

            xTicksDivision: xDuration/3600/6
            yUnits: i18nc("literal percent sign","%")
            yMax: 99
            yStep: 20
        }
    ]
    onExpanded: history.refresh();
}

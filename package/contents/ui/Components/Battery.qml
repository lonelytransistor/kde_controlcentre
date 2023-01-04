import QtQuick 2.15
import QtQuick.Layouts 1.15

import "../lib" as Lib

Lib.Card {
    readonly property var battery: root.sources.powerManagement.battery
    readonly property var inhibitions: sources.powerManagement.inhibitions
    readonly property var lid: sources.powerManagement.lid
    readonly property var history: battery.history.charge

    leftTitle: "Battery"
    leftSubtitle: battery.status
    rightTitle: battery.percent + "%"
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
                    return ""
                } else if (inhibitions.list.length == 1) {
                    return inhibitions.list[0]["Name"] + " blocks sleep."
                } else {
                    let text = ""
                    for (let ix in inhibitions.list) {
                        if (ix != 0)
                            text += ", "
                        text += inhibitions.list[ix]["Name"]
                    }
                    text += " block sleep."
                    return text
                }
            }
        }
    ]
    big: [
        Lib.ProgressBar {
            icon: battery.icon
            value: battery.percent
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

import QtQuick 2.15

import "../lib" as Lib

Item {
    id: root

    property var dndTimes: [0, 1, 3, 8, 12]
    property double dndTime: global.sources.notifications.inhibitedUntil/3600
    property double dndTimeNormalized: Math.bigger(dndTime, ...dndTimes)
    property int dndIndex: dndTimes.indexOf(dndTimeNormalized)
    property var nightMode: global.sources.powerManagement.nightMode

    property int dnd: dndTime==0 ? 0 : dndIndex+1
    property int powerMode: 0
    property bool redshift: nightMode.enabled

    Lib.ButtonRow {
        id: row
        anchors.fill: parent
        anchors.margins: global.smallSpacing
        spacing: global.smallSpacing
        buttons: [{
            "tooltip": "WiFi",
            "icon": "network-wireless",
            "onClicked": ()=>console.log("wifi"),
            "onRightClicked": ()=>console.log("wifi long")
        },{
            "tooltip": "Bluetooth",
            "icon": "network-bluetooth",
            "onClicked": ()=>0,
            "onRightClicked": ()=>console.log("bt long")
        },{
            "tooltip": "Do not disturb",
            "icon": root.dnd>0 ? "notifications-disabled" : "notifications",
            "overlay": {
                "location": "bottom-right",
                "icon": "../../assets/" + ["empty.svg", "time_1h.svg", "time_3h.svg", "time_8h.svg", "infinity.svg"][Math.clamp(root.dnd, 0, 4)]
            },
            "onClicked": () => {
                var _dnd = root.dnd;
                _dnd++;
                while (_dnd > 4)
                    _dnd = 0;
                while (_dnd < 0)
                    _dnd = 4;
                global.sources.notifications.inhibit(3600*root.dndTimes[_dnd]);
            },
            "onRightClicked": ()=>0
        },{
            "tooltip": "Power mode",
            "icon": root.powerMode==0 ? "speedometer" : powerMode==1 ? "quickopen" : "plugins",
            "onClicked": ()=>0,
            "onRightClicked": ()=>console.log("wifi long")
        },{
            "tooltip": "Night mode",
            "icon": root.nightMode.active ? "redshift-status-on" : "redshift-status-off",
            "onClicked": () => root.nightMode.active ? root.nightMode.disable() : root.nightMode.enable(),
            "onRightClicked": ()=>console.log("wifi long")
        },{
            "tooltip": "Airplane mode",
            "icon": "network-wireless",
            "onClicked": ()=>0,
            "onRightClicked": ()=>console.log("wifi long")
        },{
            "tooltip": "Airplane mode",
            "icon": "network-wireless",
            "onClicked": ()=>0,
            "onRightClicked": ()=>console.log("wifi long")
        }]
    }
    objectName: "Card"
    height: pHeight
    width: pWidth
    readonly property int pHeight: pWidth/5
    readonly property int pWidth: global.fullRepWidth
}

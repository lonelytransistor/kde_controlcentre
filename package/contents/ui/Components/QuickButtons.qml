import QtQuick 2.15

import "../lib" as Lib

Item {
    id: root

    property bool redshift: false
    property bool dnd: false
    property int powerMode: 0

    Lib.ButtonRow {
        anchors.fill: parent
        anchors.margins: global.smallSpacing
        spacing: global.smallSpacing
        buttons: [{
            "tooltip": "WiFi",
            "icon": "network-wireless",
            "onClicked": ()=>0
        },{
            "tooltip": "Bluetooth",
            "icon": "network-bluetooth",
            "onClicked": ()=>0
        },{
            "tooltip": "Do not disturb",
            "icon": root.dnd ? "notifications" : "dialog-cancel",
            "onClicked": ()=>0
        },{
            "tooltip": "Power mode",
            "icon": root.powerMode==0 ? "speedometer" : powerMode==1 ? "quickopen" : "plugins",
            "onClicked": ()=>0
        },{
            "tooltip": "Night mode",
            "icon": root.redshift ? "redshift-status-on" : "redshift-status-off",
            "onClicked": ()=>0
        },{
            "tooltip": "Airplane mode",
            "icon": "network-wireless",
            "onClicked": ()=>0
        },{
            "tooltip": "Airplane mode",
            "icon": "network-wireless",
            "onClicked": ()=>0
        }]
    }
    objectName: "Card"
    height: pHeight
    width: pWidth
    readonly property int pHeight: 60
    readonly property int pWidth: global.fullRepWidth
}

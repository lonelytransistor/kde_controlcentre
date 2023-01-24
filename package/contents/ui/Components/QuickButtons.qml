import QtQuick 2.15

import "../lib" as Lib
import ".."

Item {
    property var widgetInfo: WidgetInfo {
        title: "Quick buttons"
        description: "A widget containing buttons like on Android."
        icon: "quickopen"
        uuid: "quickbuttons"
    }

    id: root

    property var dndTimes: [0, 1, 3, 8, 12]
    property double dndTime: Global.sources.notifications.inhibitedUntil/3600
    property double dndTimeNormalized: Math.bigger(dndTime, ...dndTimes)
    property int dndIndex: dndTimes.indexOf(dndTimeNormalized)

    property var nightMode: Global.sources.powerManagement.nightMode
    property var powerProfile: Global.sources.powerManagement.powerProfile

    property int dnd: dndTime==0 ? 0 : dndIndex+1
    property string powerMode: powerProfile.active
    property int powerModeIndex: powerProfile.activeIndex
    property bool redshift: nightMode.enabled
    property bool airplaneMode: false

    Lib.FullPopup {
        id: wifiPopup
        title: "|icon:network-wired:| Network Connections"
    }
    Lib.FullPopup {
        id: btPopup
        title: "|icon:network-bluetooth:| Bluetooth"
    }
    Lib.ButtonRow {
        id: row
        anchors.fill: parent
        anchors.margins: Global.smallSpacing
        spacing: Global.smallSpacing
        buttons: [{
            "tooltip": "WiFi",
            "icon": "network-wireless",
            "onClicked": (it)=>wifiPopup.expand(it),
            "onRightClicked": ()=>console.log("wifi long")
        },{
            "tooltip": "Bluetooth",
            "icon": "network-bluetooth",
            "onClicked": (it)=>btPopup.expand(it),
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
                Global.sources.notifications.inhibit(3600*root.dndTimes[_dnd]);
            }
        },{
            "tooltip": "Power mode",
            "icon": "../../assets/" + root.powerMode + ".svg",
            "onClicked": () => {
                var newPM = root.powerModeIndex + 1;
                if (newPM > root.powerProfile.profiles.length-1) {
                    newPM = 0;
                }
                root.powerProfile.set(newPM);
            },
            "onRightClicked": ()=>console.log("wifi long")
        },{
            "tooltip": "Night mode",
            "icon": root.nightMode.active ? "redshift-status-on" : "redshift-status-off",
            "onClicked": () => root.nightMode.active ? root.nightMode.disable() : root.nightMode.enable()
        },{
            "tooltip": "Airplane mode",
            "icon": "../../assets/airplane_" + (root.airplaneMode ? "on" : "off") + ".svg",
            "onClicked": ()=>root.airplaneMode = !root.airplaneMode
        }]
    }
    objectName: "Card"
    height: pHeight
    width: pWidth
    readonly property int pHeight: pWidth/5
    readonly property int pWidth: Global.fullRepWidth
}

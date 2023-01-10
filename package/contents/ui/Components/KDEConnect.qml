import QtQuick 2.15
import QtQuick.Layouts 1.15

import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kdeconnect 1.0

import "../lib" as Lib

Repeater {
    model: DevicesModel {
        displayFilter: DevicesModel.Paired | DevicesModel.Reachable
    }

    DropArea {
        id: fileDropArea
        height: kdeRoot.height
        width: global.fullRepWidth
        onHeightChanged: if (parent) parent.height = kdeRoot.height
        onWidthChanged: if (parent) parent.width = global.fullRepWidth

        readonly property variant share: ShareDbusInterfaceFactory.create(model.deviceId)
        property bool dropping: false

        onEntered: if (drag.hasUrls) dropping = true
        onExited: dropping = false
        onDropped: {
            dropping = false
            if (drop.hasUrls) {
                var urls = [];
                for (var v in drop.urls) {
                    if (drop.urls[v] != null) {
                        if (urls.indexOf(drop.urls[v].toString()) == -1) {
                            urls.push(drop.urls[v].toString())
                        }
                    }
                }
                for (var i = 0; i < urls.length; i++) {
                    share.shareUrl(urls[i])
                }
            }
            drop.accepted = true
        }

        PlasmaComponents.Label {
            id: fileDropLabel
            anchors.fill: parent
            font.pixelSize: global.largeFontSize
            font.weight: Font.Bold
            font.capitalization: Font.Capitalize
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: "Drop your file here to share it to " + model.name
            visible: fileDropArea.dropping
        }
        Lib.Card {
            id: kdeRoot

            visible: !fileDropArea.dropping

            readonly property QtObject device:       DeviceDbusInterfaceFactory.create(model.deviceId)
            readonly property variant battery:       DeviceBatteryDbusInterfaceFactory.create(model.deviceId)
            readonly property variant network:       DeviceConnectivityReportDbusInterfaceFactory.create(model.deviceId)
            readonly property variant findMyPhone:   FindMyPhoneDbusInterfaceFactory.create(model.deviceId)
            readonly property variant sftp:          SftpDbusInterfaceFactory.create(model.deviceId)
            readonly property variant notifications: NotificationsModel{deviceId: model.deviceId}
            readonly property var icon:              global.misc.getIcon

            leftTitle: model.name
            rightTitle: (battery.isCharging ? "🗲 " : "") + battery.charge + "%"

            buttons: [{
                "icon": "document-open-folder",
                "tooltip": "Browse this device",
                "onClicked": sftp.startBrowsing
            }, {
                "icon": "irc-voice",
                "tooltip": "Ring this device",
                "onClicked": findMyPhone.ring
            }, {
                "icon": "edit-clear-history",
                "tooltip": "Clear all notifications",
                "onClicked": notifications.dismissAll
            }]

            small: [
                Row {
                    Layout.alignment: Qt.AlignRight
                    PlasmaCore.IconItem {
                        id: batteryIcon
                        height: width
                        width: 22
                        source: kdeRoot.icon.battery(kdeRoot.battery ? kdeRoot.battery.charge : -1)
                    }
                    PlasmaCore.IconItem {
                        id: networkIcon
                        height: width
                        width: 22
                        source: kdeRoot.network ? kdeRoot.icon.network(kdeRoot.network.cellularNetworkStrength, kdeRoot.network.cellularNetworkType) : kdeRoot.icon.network(-1, "");
                    }
                },
                Lib.SwipeableListView {
                    model: kdeRoot.notifications

                    textCentre: m => m.appName + ": " + (m.title.length>0 ? (m.appName==m.title ? m.notitext : m.title+": "+m.notitext) : m.name)
                    iconCentre: m => m.appIcon
                    textRight: m => "Delete"
                    textLeft: m => "Reply"
                    onOpenLeft: m.dbusInterface.reply()
                    onOpenRight: m.dbusInterface.dismiss()
                }
            ]
            big: []
        }
    }
}

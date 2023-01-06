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

        onEntered: {
            if (drag.hasUrls) {
                dropping = true
            }
        }
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

            readonly property QtObject device:     DeviceDbusInterfaceFactory.create(model.deviceId)
            readonly property variant battery:     DeviceBatteryDbusInterfaceFactory.create(model.deviceId)
            readonly property variant network:     DeviceConnectivityReportDbusInterfaceFactory.create(model.deviceId)
            readonly property variant findMyPhone: FindMyPhoneDbusInterfaceFactory.create(model.deviceId)
            readonly property variant sftp:        SftpDbusInterfaceFactory.create(model.deviceId)
            readonly property var icon:            global.misc.getIcon

            leftTitle: model.name
            rightTitle: (battery.isCharging ? "🗲 " : "") + battery.charge + "%"

            buttons: [{
                "icon": "document-open-folder",
                "tooltip": "Browse this device",
                "onClicked": function() {
                    sftp.startBrowsing();
                }}, {
                "icon": "irc-voice",
                "tooltip": "Ring this device",
                "onClicked": function() {
                    findMyPhone.ring();
                }}, {
                "icon": "edit-clear-history",
                "tooltip": "Clear all notifications",
                "onClicked": function() {
                    notificationsView.model.dismissAll();
                }}
            ]

            NotificationsModel {
                id: notificationsModel
                deviceId: model.deviceId
            }
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
                ListView {
                    id: notificationsView
                    model: notificationsModel
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.preferredWidth: width
                    Layout.preferredHeight: height
                    height: (children[0].children.length ? Math.min(model.count, 3)*(children[0].children[0].height + spacing) : 0) - spacing
                    width: parent.width
                    spacing: global.smallSpacing
                    interactive: false
                    clip: true
                    delegate: Lib.Swipeable {
                        id: notificationItem
                        width: notificationsView.width
                        height: 0.7*global.sectionHeight/3 - notificationsView.spacing

                        border.color: "#FFFFFF"
                        border.width: 1
                        borderOpacity: 0.1

                        textCentre: appName + ": " + (title.length>0 ? (appName==title?notitext:title+": "+notitext) : name)
                        iconCentre: appIcon
                        textCentreColor: textCentreColor

                        textRight: "Delete"
                        textRightColor: "white"
                        colorRight: "tomato"
                        iconRight: "emblem-error"

                        textLeft: "Reply"
                        textLeftColor: "black"
                        colorLeft: "#30f030"
                        iconLeft: "emblem-checked"

                        onOpenLeft: dbusInterface.reply()
                        onOpenRight: dbusInterface.dismiss()

                        ListView.onRemove: SequentialAnimation {
                            PropertyAction {
                                target: notificationItem
                                property: "ListView.delayRemove"
                                value: true
                            }
                            NumberAnimation {
                                target: notificationItem
                                property: "height"
                                to: 0
                                easing.type: Easing.InOutQuad
                            }
                            PropertyAction {
                                target: notificationItem
                                property: "ListView.delayRemove"
                                value: false
                            }
                        }
                    }
                }
            ]
            big: []
        }
    }
}

import QtQml 2.0
import QtQuick 2.0
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.kdeconnect 1.0

import "../lib" as Lib
import "../js/funcs.js" as Funcs

Lib.Card {
    id: kdeConnectDevice
    Layout.fillWidth: true
    Layout.preferredHeight: 0.3*root.sectionHeight + 0.7*root.sectionHeight*notificationsModel.count/3 + root.largeSpacing

    readonly property QtObject device: DeviceDbusInterfaceFactory.create(model.deviceId)

    // Notifications
    NotificationsModel {
        id: notificationsModel
        deviceId: model.deviceId
    }

    // Battery
    property variant battery: DeviceBatteryDbusInterfaceFactory.create(model.deviceId)
    property int batteryCharge: battery ? battery.charge : -1
    property bool batteryCharging: battery ? battery.isCharging : false
    property string batteryStatus: (batteryCharge > -1) ? ((batteryCharging) ? (i18n("%1% charging", batteryCharge)) : (i18n("%1%", batteryCharge))) : i18n("No info")
    readonly property string batteryIcon: {
        batteryCharge < 0 ?
        "battery-missing-symbolic" :
        batteryCharge < 10 ?
        batteryCharging ?
            "battery-empty-batteryCharging-symbolic" :
            "battery-empty-symbolic" :
        batteryCharge < 25 ?
        batteryCharging ?
            "battery-caution-batteryCharging-symbolic" :
            "battery-caution-symbolic" :
        batteryCharge < 50 ?
            batteryCharging ?
            "battery-low-batteryCharging-symbolic" :
            "battery-low-symbolic" :
        batteryCharge < 75 ?
        batteryCharging ?
            "battery-good-batteryCharging-symbolic" :
            "battery-good-symbolic" :
        batteryCharging ?
        "battery-full-batteryCharging-symbolic":
        "battery-full-symbolic"
    }

    // Network
    readonly property string networkType: network ? network.cellularNetworkType : i18n("Unknown")
    readonly property int networkStrength: network ? network.cellularNetworkStrength : -1
    property variant network: DeviceConnectivityReportDbusInterfaceFactory.create(model.deviceId)
    readonly property string networkIcon: {
        ((networkStrength < 0) ?
            "network-mobile-off" :
        (networkStrength == 0) ?
            "network-mobile-0" :
        (networkStrength == 1) ?
            "network-mobile-20" :
        (networkStrength == 2) ?
            "network-mobile-60" :
        (networkStrength == 3) ?
            "network-mobile-80" :
        (networkStrength == 4) ?
            "network-mobile-100" :
        "network-mobile-available")
        +
        ((networkType === "5G") ?
            "" :
        (networkType === "LTE") ?
            "-lte" :
        (networkType === "HSPA") ?
            "-hspa" :
        (networkType === "UMTS") ?
            "-umts" :
        (networkType === "CDMA2000") ?
            "" :
        (networkType === "EDGE") ?
            "-edge" :
        (networkType === "GPRS") ?
            "-gprs" :
        (networkType === "GSM") ?
            "" :
        (networkType === "CDMA") ?
            "" :
        (networkType === "iDEN") ?
            "" :
            "")
    }

    // Find my phone
    property variant findMyPhone: FindMyPhoneDbusInterfaceFactory.create(model.deviceId)

    // Sftp
    property variant sftp: SftpDbusInterfaceFactory.create(model.deviceId)

    // Share
    property variant share: ShareDbusInterfaceFactory.create(model.deviceId)
    DropArea {
        id: fileDropArea
        anchors.fill: parent
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
    }
    PlasmaComponents.Label {
        id: fileDropLabel
        anchors.fill: parent
        font.pixelSize: root.largeFontSize
        font.weight: Font.Bold
        font.capitalization: Font.Capitalize
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: "Drop your file here to share it to " + model.name
        visible: fileDropArea.dropping
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: root.largeSpacing
        Layout.fillWidth: true
        visible: !fileDropArea.dropping
        clip: true

        RowLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing: 0

            PlasmaComponents.Label {
                id: deviceName
                text: model.name
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignLeft
                font.pixelSize: root.largeFontSize
                font.weight: Font.Bold
                font.capitalization: Font.Capitalize
            }

            PlasmaComponents.ToolButton {
                id: sftpButton
                Layout.alignment: Qt.AlignHCenter
                iconSource: "document-open-folder"
                tooltip: i18n("Browse this device")
                onClicked: sftp.startBrowsing()
            }
            PlasmaComponents.ToolButton {
                id: findButton
                Layout.alignment: Qt.AlignHCenter
                iconSource: "irc-voice"
                tooltip: i18n("Ring the phone")
                onClicked: findMyPhone.ring()
            }
            PlasmaComponents.ToolButton {
                id: dismissButton
                visible: (notificationsModel.count > 0 && notificationsModel.isAnyDimissable)
                Layout.alignment: Qt.AlignHCenter
                iconSource: "edit-clear-history"
                tooltip: i18n("Dismiss all notifications")
                onClicked: notificationsModel.dismissAll()
            }

            PlasmaComponents.Label {
                id: batteryStatus
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignRight
                font.pixelSize: root.mediumFontSize
                font.weight: Font.Bold
                font.capitalization: Font.Capitalize
                horizontalAlignment: Text.AlignRight
                text: kdeConnectDevice.batteryStatus
            }
            PlasmaCore.IconItem {
                id: batteryIcon
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignRight
                source: kdeConnectDevice.batteryIcon
            }
            PlasmaCore.IconItem {
                id: networkIcon
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignRight
                source: kdeConnectDevice.networkIcon
            }
        }
        // Notifications
        ListView {
            id: notificationsView
            model: notificationsModel
            Layout.fillHeight: true
            Layout.fillWidth: true
            height: 0.7*root.sectionHeight
            spacing: root.smallSpacing
            clip: true
            delegate: SwipeDelegate {
                id: notificationItem
                width: notificationsView.width
                height: 0.7*root.sectionHeight/3 - notificationsView.spacing
                background: Rectangle {
                    border.color: "#FFFFFF"
                    border.width: 1
                    color: "transparent"
                    opacity: 0.1
                }
                PlasmaCore.IconItem {
                    id: notificationIcon
                    source: appIcon
                    height: notificationItem.height*0.8
                    width: height
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.margins: notificationItem.height*0.1
                }
                PlasmaComponents.Label {
                    text: appName + ": " + (title.length>0 ? (appName==title?notitext:title+": "+notitext) : model.name)
                    anchors {
                        right: parent.right
                        left: notificationIcon.right
                        top: parent.top
                        bottom: parent.bottom
                        leftMargin: root.smallSpacing
                    }
                    elide: Text.ElideRight
                    maximumLineCount: 1
                    wrapMode: Text.WordWrap
                }


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
                onClicked: swipe.close()
                swipe.right: Label {
                    id: deleteLabel
                    text: qsTr("Delete")
                    color: "white"
                    verticalAlignment: Label.AlignVCenter
                    padding: 12
                    height: parent.height
                    anchors.right: parent.right

                    SwipeDelegate.onClicked: dbusInterface.dismiss()

                    background: Rectangle {
                        color: deleteLabel.SwipeDelegate.pressed ? Qt.darker("tomato", 1.1) : "tomato"
                    }
                }
                swipe.left: Label {
                    id: replyLabel
                    visible: repliable
                    enabled: repliable
                    text: i18n("Reply")
                    color: "white"
                    verticalAlignment: Label.AlignVCenter
                    padding: 12
                    height: parent.height
                    anchors.left: parent.left

                    SwipeDelegate.onClicked: dbusInterface.reply()

                    background: Rectangle {
                        color: replyLabel.SwipeDelegate.pressed ? Qt.darker("#30f030", 1.1) : "#30f030"
                    }
                }
            }
        }
    }
}

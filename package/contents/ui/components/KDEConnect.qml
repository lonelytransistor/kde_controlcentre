import QtQml 2.15
import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.kdeconnect 1.0

import "../lib" as Lib
import "../js/funcs.js" as Funcs

Lib.Card {
    id: kdeConnectDevice
    Layout.fillWidth: true
    Layout.preferredHeight: 0.3*root.sectionHeight + 0.7*root.sectionHeight*notificationsView.model.count/3 + (notificationsView.model.count ? root.mediumSpacing : root.smallSpacing/2)

    readonly property QtObject device: DeviceDbusInterfaceFactory.create(model.deviceId)

    // Notifications
    NotificationsModel {
        id: notificationsModel
        deviceId: model.deviceId
    }

    property var buttonIcon: ["document-open-folder", "irc-voice", "edit-clear-history"]
    property var buttonTooltip: [i18n("Browse this device"), i18n("Ring the phone"), i18n("Dismiss all notifications")]
    signal buttonPress(index: int)
    onButtonPress: {
        if (index == 0) {
            sftp.startBrowsing()
        } else if (index == 1) {
            findMyPhone.ring()
        } else if (index == 2) {
            //visible: (notificationsView.model.count > 0 && notificationsView.model.isAnyDimissable)
            notificationsView.model.dismissAll()
        }
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
        id: kdeConnectDeviceColumn
        anchors.fill: parent
        anchors.margins: root.largeSpacing
        anchors.topMargin: root.largeSpacing*2.75
        Layout.fillWidth: true
        visible: !fileDropArea.dropping
        //clip: true
        // Notifications
        ListView {
            id: notificationsView
            property var debugModel: ListModel {
                ListElement {
                    appName: "appName1"
                    title: "title1"
                    notitext: "notitext1"
                    name: "name1"
                    appIcon: "battery"
                }
                ListElement {
                    appName: "appName2"
                    title: "title2"
                    notitext: "notitext2"
                    name: "name2"
                    appIcon: "battery"
                }
            }
            //model: debugModel
            model: notificationsModel
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.topMargin: root.largeSpacing
            height: 0.7*root.sectionHeight
            spacing: root.smallSpacing
            interactive: false
            clip: true
            delegate: Lib.Swipeable {
                id: notificationItem
                width: notificationsView.width
                height: 0.7*root.sectionHeight/3 - notificationsView.spacing

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
    }
    Item {
        id: header
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: root.smallSpacing
        }
        height: buttonRow.height

        RowLayout {
            anchors.fill: parent
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
            Item {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignRight

                PlasmaComponents.Label {
                    id: batteryStatus
                    anchors {
                        right: batteryIcon.left
                        verticalCenter: parent.verticalCenter
                        rightMargin: root.smallSpacing
                    }
                    font.pixelSize: root.mediumFontSize
                    font.weight: Font.Bold
                    font.capitalization: Font.Capitalize
                    horizontalAlignment: Text.AlignRight
                    text: kdeConnectDevice.batteryStatus
                }
                PlasmaCore.IconItem {
                    id: batteryIcon
                    anchors {
                        right: networkIcon.left
                        verticalCenter: parent.verticalCenter
                        rightMargin: root.smallSpacing
                    }
                    source: kdeConnectDevice.batteryIcon
                }
                PlasmaCore.IconItem {
                    id: networkIcon
                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }
                    source: kdeConnectDevice.networkIcon
                }
            }
        }
        Item {
            id: buttons
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            RowLayout {
                id: buttonRow
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                Layout.fillHeight: true
                Layout.fillWidth: true
                spacing: 0
                Repeater {
                    model: kdeConnectDevice.buttonIcon.length
                    ToolButton {
                        id: button

                        property string buttonIcon: kdeConnectDevice.buttonIcon[index]
                        property string buttonTooltip: kdeConnectDevice.buttonTooltip[index]

                        visible: buttonIcon != ""
                        icon.name: buttonIcon
                        icon.source: buttonIcon
                        height: 24//icon.height
                        width: 24//icon.width
                        ToolTip.delay: 500
                        ToolTip.text: buttonTooltip
                        ToolTip.visible: hovered
                        onClicked: kdeConnectDevice.buttonPress(index)
                    }
                }
            }
        }
    }
}

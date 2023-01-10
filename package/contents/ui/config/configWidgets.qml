import QtQuick 2.0
import QtQuick.Controls 2.0

import "../private" as Private

Private.ComponentList {
    id: widgetList
    property alias cfg_widgetOrder: widgetList.config

    model: ListModel {
        ListElement {
            title: "Battery info"
            description: "A small battery widget with a battery charge/rate graph."
            icon: "battery-good"
            uuid: "battery"
        }
        ListElement {
            title: "Volume"
            description: "A widget for volume control and a detailed per-application and per-device volume manager."
            icon: "audio-volume-medium"
            uuid: "volume"
        }
        ListElement {
            title: "MPRIS control"
            description: "A widget for music playback control with detailed per-app control and pulseeffects support."
            icon: "media-playback-start"
            uuid: "mpris"
        }
        ListElement {
            title: "Brightness"
            description: "A widget for brightness control of your laptop's screen or its keyboard."
            icon: "brightness-high"
            uuid: "brightness"
        }
        ListElement {
            title: "Hidden widgets"
            description: "Drag widgets you don't want to see below this point."
            icon: ""
            uuid: "_splitter_"
        }
        ListElement {
            title: "KDE Connect"
            description: "A widget used to control KDE Connect compatible devices."
            icon: "kdeconnect"
            uuid: "kdeconnect"
        }
        ListElement {
            title: "Session buttons"
            description: "A widget containing basic session buttons."
            icon: "system-shutdown"
            uuid: "sessionbuttons"
        }
        ListElement {
            title: "Quick buttons"
            description: "A widget containing buttons like on Android."
            icon: "quickopen"
            uuid: "quickbuttons"
        }
        ListElement {
            title: "ProtonMail client"
            description: "A widget checking for e-mails on your ProtonMail account every 30 minutes."
            icon: "mail-read"
            uuid: "protonmail"
        }
    }
}

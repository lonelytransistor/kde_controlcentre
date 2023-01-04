import QtQuick 2.15

ListModel {
    ListElement {
        title: "Battery info"
        description: "A small battery widget with a battery charge/rate graph."
        icon: "battery-good"
    }
    ListElement {
        title: "Volume"
        description: "A widget for volume control and a detailed per-application and per-device volume manager."
        icon: "audio-volume-medium"
    }
    ListElement {
        title: "MPRIS control"
        description: "A widget for music playback control with detailed per-app control and pulseeffects support."
        icon: "media-playback-start"
    }
}

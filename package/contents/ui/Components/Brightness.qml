import QtQuick 2.15
import QtQuick.Layouts 1.15

import "../lib" as Lib
import ".."

Lib.Card {
    widgetInfo: WidgetInfo {
        title: "Brightness"
        description: "A widget for brightness control of your laptop's screen or its keyboard."
        icon: "brightness-high"
        uuid: "brightness"
    }

    id: bRoot

    readonly property var brightness: Global.sources.powerManagement.brightness
    readonly property var screen: brightness.screen
    readonly property var keyboard: brightness.keyboard

    leftTitle: "Brightness"
    rightTitle: Math.round(100*screen.value/screen.max) + "%"

    small: [
        Lib.Slider {
            readonly property int normalized: Math.round(100*value/bRoot.screen.max)

            icon: Global.misc.getIcon.brightness(normalized)
            value: bRoot.screen.value
            tooltipValue: normalized + "%"
            from: bRoot.screen.min
            to: bRoot.screen.max
            step: 1
            onMoved: bRoot.screen.value = value;
        }
    ]
    big: [
        Lib.Slider {
            readonly property int normalized: Math.round(100*value/bRoot.screen.max)

            icon: Global.misc.getIcon.brightness(normalized)
            value: bRoot.screen.value
            tooltipValue: normalized + "%"
            from: bRoot.screen.min
            to: bRoot.screen.max
            step: 1
            info: normalized + "%"
            title: "Screen brightness"
            onMoved: bRoot.screen.value = value;
        },
        Lib.Slider {
            readonly property int normalized: Math.round(100*value/bRoot.keyboard.max)

            icon: Global.misc.getIcon.brightness(normalized)
            value: bRoot.keyboard.value
            tooltipValue: normalized + "%"
            from: bRoot.keyboard.min
            to: bRoot.keyboard.max
            step: 1
            info: normalized + "%"
            title: "Keyboard brightness"
            onMoved: bRoot.keyboard.value = value;
        }
    ]
}

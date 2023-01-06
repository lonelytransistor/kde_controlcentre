import QtQuick 2.15
import QtQuick.Layouts 1.15

import "../lib" as Lib

Lib.Card {
    id: bRoot

    readonly property var brightness: global.sources.powerManagement.brightness
    readonly property var screen: brightness.screen
    readonly property var keyboard: brightness.keyboard

    leftTitle: "Brightness"
    rightTitle: Math.round(100*screen.value/screen.max) + "%"

    small: [
        Lib.Slider {
            readonly property int normalized: Math.round(100*value/bRoot.screen.max)

            icon: global.misc.getIcon.brightness(normalized)
            value: bRoot.screen.value
            from: bRoot.screen.min
            to: bRoot.screen.max
            step: 1
            onMoved: bRoot.screen.value = value;
        }
    ]
    big: [
        Lib.Slider {
            readonly property int normalized: Math.round(100*value/bRoot.screen.max)

            icon: global.misc.getIcon.brightness(normalized)
            value: bRoot.screen.value
            from: bRoot.screen.min
            to: bRoot.screen.max
            step: 1
            info: normalized + "%"
            title: "Screen brightness"
            onMoved: bRoot.screen.value = value;
        },
        Lib.Slider {
            readonly property int normalized: Math.round(100*value/bRoot.keyboard.max)

            icon: global.misc.getIcon.brightness(normalized)
            value: bRoot.keyboard.value
            from: bRoot.keyboard.min
            to: bRoot.keyboard.max
            step: 1
            info: normalized + "%"
            title: "Keyboard brightness"
            onMoved: bRoot.keyboard.value = value;
        }
    ]
}

import QtQuick 2.15
import QtQuick.Layouts 1.15

import "../lib" as Lib

Lib.Card {
    id: brightnessRoot

    readonly property var brightness: root.sources.powerManagement.brightness
    readonly property int brightnessScreen: Math.round(100*brightness.screen/255)
    readonly property int brightnessKeyboard: Math.round(100*brightness.keyboard/255)

    leftTitle: "Brightness"
    rightTitle: brightnessScreen + "%"

    small: [
        Lib.Slider {
            icon: root.misc.getIcon.brightness(brightnessRoot.brightnessScreen)
            value: brightnessRoot.brightnessScreen
            onMoved: {
                brightnessRoot.brightness.screen = Math.round(255*value/100);
            }
        }
    ]
    big: [
        Lib.Label {
            text: "Screen brightness"
        },
        Lib.Slider {
            icon: root.misc.getIcon.brightness(brightnessRoot.brightnessScreen)
            value: brightnessRoot.brightnessScreen
            onMoved: {
                brightnessRoot.brightness.screen = Math.round(255*value/100);
            }
        },
        Lib.Label {
            text: "Keyboard brightness"
        },
        Lib.Slider {
            icon: root.misc.getIcon.brightness(brightnessRoot.brightnessKeyboard)
            value: brightnessRoot.brightnessKeyboard
            onMoved: {
                brightnessRoot.brightness.keyboard = Math.round(255*value/100);
            }
        }
    ]
}

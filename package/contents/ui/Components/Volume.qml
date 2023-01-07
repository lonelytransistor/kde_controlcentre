import QtQuick 2.15
import QtQuick.Layouts 1.15

import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.private.volume 0.1 as Vol

import "../lib" as Lib

Lib.Card {
    id: volumeRoot

    readonly property var audio: global.sources.audio
    readonly property var sinkModel: audio.activeSinks
    readonly property var streamModel: audio.outputStreams
    readonly property var defaultSink: audio.defaultSink
    readonly property int defaultSinkVolume: defaultSink.volume
    onDefaultSinkVolumeChanged: volumeSlider.value = defaultSinkVolume;

    leftTitle: "Volume"
    leftSubtitle: defaultSink.simpleName
    rightTitle: Math.round(volumeSlider.value) + "%"
    rightSubtitle: {
        if (streamModel.count == 0) {
            return "No apps are playing audio.";
        } else if (streamModel.count == 1) {
            return "1 app is playing audio.";
        } else {
            return streamModel.count + " apps are playing audio.";
        }
    }

    small: [
        Lib.Slider {
            id: volumeSlider
            icon: defaultSink.icon
            value: defaultSink.volume
            tooltipValue: Math.round(value) + "%"
            onReleased: antiSpamTimer.running = true;
            onMoved: antiSpamTimer.running = true;
            onIconPressed: defaultSink.muted = !defaultSink.muted;
            Timer {
                id: antiSpamTimer
                interval: 250
                running: false
                onTriggered: defaultSink.volume = Math.round(parent.value);
            }
        }
    ]
    big: [
        ListView {
            id: sinkList
            model: sinkModel
            Layout.preferredWidth: width
            Layout.preferredHeight: height
            height: children[0].children.length ? Math.min(model.count, 4)*children[0].children[0].height : 0
            width: parent.width
            Layout.fillWidth: true
            Layout.fillHeight: true
            delegate: Lib.Slider {
                id: sinkSlider
                value: Math.round(100*model.Volume/audio.normalVolume)
                tooltipValue: info
                info: Math.round(value) + "%"
                highlight: Math.round(meter.volume*100)
                onReleased: antiSpamTimer.running = true;
                onMoved: antiSpamTimer.running = true;
                icon: model.Muted ? "audio-volume-muted" : model.IconName.length !== 0 ? model.IconName : "audio-volume-high"
                onIconPressed: model.Muted = !model.Muted
                title: {
                    if (activePort && activePort.description) {
                        return activePort.description;
                    }
                    if (model.Name) {
                        return model.Name;
                    }
                    if (model.Description) {
                        return model.Description;
                    }
                    return i18n("Device name not found");
                }

                readonly property var activePort: model.Ports[model.ActivePortIndex]
                Timer {
                    id: antiSpamTimer
                    interval: 250
                    running: false
                    onTriggered: model.Volume = Math.round(audio.normalVolume*parent.value/100);
                }
                Vol.VolumeMonitor {
                    id: meter
                    target: volumeRoot.isExpanded && streamModel.count!=0 ? model.PulseObject : null
                }
            }
        },
        Lib.Splitter {},
        Lib.Label {
            width: parent.width
            text: streamModel.count==0 ? "No application is playing audio at this moment." : ""
            Layout.alignment: Qt.AlignHCenter
        },
        ListView {
            id: streamList
            model: streamModel
            Layout.preferredWidth: width
            Layout.preferredHeight: height
            height: children[0].children.length ? Math.min(model.count, 4)*children[0].children[0].height : 0
            width: parent.width
            Layout.fillWidth: true
            Layout.fillHeight: true
            delegate: Lib.Slider {
                id: appSlider
                tooltipValue: info
                value: Math.round(100*model.Volume/audio.normalVolume)
                highlight: Math.round(meter.volume*100)
                onReleased: antiSpamTimer.running = true;
                onMoved: antiSpamTimer.running = true;
                icon: model.Muted ? "audio-volume-muted" : model.IconName.length !== 0 ? model.IconName : "audio-volume-high"
                onIconPressed: model.Muted = !model.Muted
                info: Math.round(value) + "%"
                title: {
                    if (Client) {
                        if (Client.name === "pipewire-media-session")
                            return Name;
                        return i18ndc("kcm_pulseaudio", "label of stream items", "%1: %2", Client.name, Name);
                    } else {
                        return Name;
                    }
                }
                Timer {
                    id: antiSpamTimer
                    interval: 250
                    running: false
                    onTriggered: model.Volume = Math.round(audio.normalVolume*parent.value/100);
                }
                Vol.VolumeMonitor {
                    id: meter
                    target: volumeRoot.isExpanded ? model.PulseObject : null
                }
            }
        }
    ]
}

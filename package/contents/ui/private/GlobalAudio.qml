import QtQuick 2.0
import org.kde.plasma.private.volume 0.1 as Vol

Item {
    readonly property real normalVolume: Vol.PulseAudio.NormalVolume
    readonly property var allSinks: Vol.SinkModel {}
    readonly property var activeSinks: Vol.PulseObjectFilterModel {
        sortRole: "SortByDefault"
        sortOrder: Qt.DescendingOrder
        filterOutInactiveDevices: true
        filterVirtualDevices: false
        sourceModel: global.sources.audio.allSinks
    }
    readonly property var outputStreams: Vol.PulseObjectFilterModel {
        filters: [ { role: "VirtualStream", value: false } ]
        sourceModel: Vol.SinkInputModel {}
    }
    readonly property var defaultSink: Item {
        property int volume: volumeRawPercent
        property bool muted: global.sources.audio.allSinks.preferredSink ? global.sources.audio.allSinks.preferredSink.muted : false
        property string name: global.sources.audio.allSinks.preferredSink ? global.sources.audio.allSinks.preferredSink.name : ""
        property string portName: global.sources.audio.allSinks.preferredSink ? global.sources.audio.allSinks.preferredSink.ports[global.sources.audio.allSinks.preferredSink.activePortIndex].description : ""
        property string description: global.sources.audio.allSinks.preferredSink ? global.sources.audio.allSinks.preferredSink.description : ""
        property string simpleName: {
            if (portName) {
                return portName;
            } else if (description) {
                return description;
            } else {
                return name;
            }
        }

        readonly property int volumeRawPercent: global.sources.audio.allSinks.preferredSink ? Math.round(100*global.sources.audio.allSinks.preferredSink.volume/Vol.PulseAudio.NormalVolume) : 0
        readonly property string icon: global.misc.getIcon.volume(muted ? 0 : volume)
        onMutedChanged: {
            if (global.sources.audio.allSinks.preferredSink.muted != muted)
                global.sources.audio.allSinks.preferredSink.muted = muted;
        }
        onVolumeRawPercentChanged: {
            if (volume != volumeRawPercent)
                volume = volumeRawPercent;
        }
        onVolumeChanged: {
            let tmpval = Math.max(Vol.PulseAudio.MinimalVolume, Math.round(Vol.PulseAudio.NormalVolume*volume/100));
            if (volume != tmpval)
                global.sources.audio.allSinks.preferredSink.volume = tmpval;
        }
    }
}

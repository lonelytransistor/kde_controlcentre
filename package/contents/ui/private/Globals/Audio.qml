import QtQuick 2.0
import org.kde.plasma.private.volume 0.1 as Vol

Item {
    id: root

    readonly property real normalVolume: Vol.PulseAudio.NormalVolume
    readonly property var allSinks: Vol.SinkModel {}
    readonly property var activeSinks: Vol.PulseObjectFilterModel {
        sortRole: "SortByDefault"
        sortOrder: Qt.DescendingOrder
        filterOutInactiveDevices: true
        filterVirtualDevices: false
        sourceModel: allSinks
    }
    readonly property var outputStreams: Vol.PulseObjectFilterModel {
        filters: [ { role: "VirtualStream", value: false } ]
        sourceModel: Vol.SinkInputModel {}
    }
    readonly property var defaultSink: Item {
        property int volume: volumeRawPercent
        property bool muted: root.allSinks.preferredSink ? root.allSinks.preferredSink.muted : false
        property string name: root.allSinks.preferredSink ? root.allSinks.preferredSink.name : ""
        property string portName: root.allSinks.preferredSink ? root.allSinks.preferredSink.ports[root.allSinks.preferredSink.activePortIndex].description : ""
        property string description: root.allSinks.preferredSink ? root.allSinks.preferredSink.description : ""
        property string simpleName: {
            if (portName) {
                return portName;
            } else if (description) {
                return description;
            } else {
                return name;
            }
        }

        readonly property int volumeRawPercent: root.allSinks.preferredSink ? Math.round(100*root.allSinks.preferredSink.volume/Vol.PulseAudio.NormalVolume) : 0
        readonly property string icon: ini.t ? Global.misc.getIcon.volume(muted ? 0 : volume) : ""
        onMutedChanged: {
            if (root.allSinks.preferredSink.muted != muted)
                root.allSinks.preferredSink.muted = muted;
        }
        onVolumeRawPercentChanged: {
            if (volume != volumeRawPercent)
                volume = volumeRawPercent;
        }
        onVolumeChanged: {
            let tmpval = Math.max(Vol.PulseAudio.MinimalVolume, Math.round(Vol.PulseAudio.NormalVolume*volume/100));
            if (volume != tmpval)
                root.allSinks.preferredSink.volume = tmpval;
        }
    }
}

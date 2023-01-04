import QtQuick 2.0
import QtQuick.Controls 2.15

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.1 as PlasmaCore
import org.kde.plasma.private.volume 0.1 as Vol

import "lib" as Lib

Rectangle {
    id: root
    
    clip: true

    readonly property var cards: Item {
        Item {
            id: cardsStore
            property var expandedCards: []
            property double fraction: 0.0
        }
        readonly property double fraction: cardsStore.fraction
        readonly property var update: function(fraction) {
            cardsStore.fraction = fraction;
        }
        readonly property var expand: function(card, subcard) {
            collapseAll();
            cardsStore.expandedCards.push({"card": card, "subcard": subcard});

            subcard.state = "expanded";
            card.expanded();
        }
        readonly property var collapse: function(card, subcard) {
            subcard.state = "collapsed";
            card.collapsed();

            for (var ix = 0; ix < cardsStore.expandedCards.length; ix++) {
                var _card = cardsStore.expandedCards;
                if (_card.card == card) {
                    cardsStore.expandedCards.splice(ix, 1);
                }
            }
        }
        readonly property var collapseAll: function() {
            while (cardsStore.expandedCards.length) {
                var _card = cardsStore.expandedCards.pop();
                collapse(_card.card, _card.subcard);
            }
        }
    }
    readonly property var misc: Item {
        readonly property var getIcon: Item {
            readonly property var network: function(networkStrength, networkType) {
                var prefixes = ["network-mobile-0", "network-mobile-20", "network-mobile-60", "network-mobile-80", "network-mobile-100"];
                var suffixes = {"LTE": "-lte", "HSPA": "-hspa", "UMTS": "-umts", "EDGE": "-edge", "GPRS": "-gprs"};
                return (networkStrength<0 ? "network-mobile-off" : (prefixes[networkStrength] ? prefixes[networkStrength] : "network-mobile-available")) +
                       (suffixes[networkType] ? suffixes[networkType] : "");
            }
            readonly property var volume: function(volume) {
                let name = "audio-volume";
                if (volume <= 0) {
                    name += "-muted";
                } else if (volume <= 25) {
                    name += "-low";
                } else if (volume <= 75) {
                    name += "-medium";
                } else {
                    name += "-high";
                }
                return name;
            }
            readonly property var battery: function(now, isCharging) {
                return (now <  0 ? "battery-missing" :
                        now < 10 ? isCharging ? "battery-empty-batteryCharging": "battery-empty":
                        now < 25 ? isCharging ? "battery-caution-batteryCharging": "battery-caution":
                        now < 50 ? isCharging ? "battery-low-batteryCharging": "battery-low":
                        now < 75 ? isCharging ? "battery-good-batteryCharging": "battery-good":
                                   isCharging ? "battery-full-batteryCharging": "battery-full")
            }
            readonly property var brightness: function(value) {
                return (value < 33 ? "brightness-low" :
                                     "brightness-high")
            }
        }
    }
    readonly property var sources: Item {
        readonly property var powerManagement: PowerManagement {}
        readonly property var audio: Item {
            readonly property real normalVolume: Vol.PulseAudio.NormalVolume
            readonly property var allSinks: Vol.SinkModel {}
            readonly property var activeSinks: Vol.PulseObjectFilterModel {
                sortRole: "SortByDefault"
                sortOrder: Qt.DescendingOrder
                filterOutInactiveDevices: true
                filterVirtualDevices: false
                sourceModel: root.sources.audio.allSinks
            }
            readonly property var outputStreams: Vol.PulseObjectFilterModel {
                filters: [ { role: "VirtualStream", value: false } ]
                sourceModel: Vol.SinkInputModel {}
            }
            readonly property var defaultSink: Item {
                property int volume: volumeRawPercent
                property bool muted: root.sources.audio.allSinks.preferredSink ? root.sources.audio.allSinks.preferredSink.muted : false
                property string name: root.sources.audio.allSinks.preferredSink ? root.sources.audio.allSinks.preferredSink.name : ""
                property string portName: root.sources.audio.allSinks.preferredSink ? root.sources.audio.allSinks.preferredSink.ports[root.sources.audio.allSinks.preferredSink.activePortIndex].description : ""
                property string description: root.sources.audio.allSinks.preferredSink ? root.sources.audio.allSinks.preferredSink.description : ""
                property string simpleName: {
                    if (portName) {
                        return portName;
                    } else if (description) {
                        return description;
                    } else {
                        return name;
                    }
                }

                readonly property int volumeRawPercent: root.sources.audio.allSinks.preferredSink ? Math.round(100*root.sources.audio.allSinks.preferredSink.volume/Vol.PulseAudio.NormalVolume) : 0
                readonly property string icon: root.misc.getIcon.volume(muted ? 0 : volume)
                onMutedChanged: {
                    if (root.sources.audio.allSinks.preferredSink.muted != muted)
                        root.sources.audio.allSinks.preferredSink.muted = muted;
                }
                onVolumeRawPercentChanged: {
                    if (volume != volumeRawPercent)
                        volume = volumeRawPercent;
                }
                onVolumeChanged: {
                    let tmpval = Math.max(Vol.PulseAudio.MinimalVolume, Math.round(Vol.PulseAudio.NormalVolume*volume/100));
                    if (volume != tmpval)
                        root.sources.audio.allSinks.preferredSink.volume = tmpval;
                }
            }
        }
        readonly property var mpris2: Item {
            readonly property var players: mpris2Source.players
            readonly property var multiplex: mpris2Source.multiplex
            readonly property var flags: Item {
                readonly property int control: 0b00000001
                readonly property int next:    0b00000010
                readonly property int prev:    0b00000100
                readonly property int pause:   0b00001000
                readonly property int play:    0b00010000
                readonly property int quit:    0b00100000
                readonly property int raise:   0b01000000
                readonly property int seek:    0b10000000
            }
            PlasmaCore.DataSource {
                id: mpris2Source
                engine: "mpris2"
                connectedSources: sources
                property var multiplex: {}
                property var players: []
                property string multiplexSource: "@multiplex"
                onDataChanged: {
                    var playerList = [];
                    var sources = mpris2Source.sources;
                    for (let ix = 0; ix < sources.length; ix++) {
                        var source = sources[ix];
                        var audioData = data[source];
                        if (!audioData)
                            continue;
                        var audioMetadata = audioData["Metadata"];
                        var audioData2 = {
                            "app": audioData["Identity"] || "Unknown app",
                            "icon": audioData["Desktop Icon Name"] || audioData["DesktopEntry"] || "emblem-music-symbolic",
                            "source": source,
                            "url": audioMetadata["xesam:url"],
                            "art": audioMetadata["mpris:artUrl"],
                            "title": audioMetadata["xesam:title"] || "Unknown title",
                            "artist": audioMetadata["xesam:artist"] || "Unknown artist",
                            "thumb": audioMetadata["mpris:artUrl"],
                            "position": audioData["Position"],
                            "length": audioMetadata["mpris:length"],
                            "volume": Math.round(audioData["Volume"]*100),
                            "isPlaying": audioData["PlaybackStatus"]=="Playing",
                            "capabilities": (audioData["CanControl"]?0b00000001:0 | audioData["CanGoNext"]?0b00000010:0 | audioData["CanGoPrevious"]?0b00000100:0 | audioData["CanPause"]?0b00001000:0 | audioData["CanPlay"]?0b00010000:0 | audioData["CanQuit"]?0b00100000:0 | audioData["CanRaise"]?0b01000000:0 | audioData["CanSeek"]?0b10000000:0),
                            "_audioData": audioData,
                            "setVolume": function(v) {this._audioData["Volume"]=v*0.01;},
                            "raise": function()      {var s=serviceForSource(this.source);var o=s.operationDescription("Raise");                       s.startOperationCall(o);},
                            "play": function()       {var s=serviceForSource(this.source);var o=s.operationDescription("Play");                        s.startOperationCall(o);},
                            "playPause": function()  {var s=serviceForSource(this.source);var o=s.operationDescription("Pause");                       s.startOperationCall(o);},
                            "pause": function()      {var s=serviceForSource(this.source);var o=s.operationDescription("Pause");                       s.startOperationCall(o);},
                            "stop": function()       {var s=serviceForSource(this.source);var o=s.operationDescription("Stop");                        s.startOperationCall(o);},
                            "next": function()       {var s=serviceForSource(this.source);var o=s.operationDescription("Next");                        s.startOperationCall(o);},
                            "prev": function()       {var s=serviceForSource(this.source);var o=s.operationDescription("Previous");                    s.startOperationCall(o);},
                            "seekTo": function(v)    {var s=serviceForSource(this.source);var o=s.operationDescription("SetPosition");o.microseconds=v;s.startOperationCall(o);}
                        }
                        if (source === multiplexSource) {
                            multiplex = audioData2;
                        } else {
                            playerList.push(audioData2);
                        }
                    }
                    players = playerList;
                }
                onSourcesChanged: {
                    dataChanged()
                }
                onSourceRemoved: {
                    dataChanged()
                }
                Component.onCompleted: {
                    dataChanged()
                }
            }
        }
    }

    SystemPalette {
        id: activePalette
        colorGroup: SystemPalette.Active
    }
    property color background: activePalette.window

    // PROPERTIES
    property bool enableTransparency: plasmoid.configuration.transparency
    property var animationDuration: PlasmaCore.Units.veryShortDuration

    property var scale: plasmoid.configuration.scale * PlasmaCore.Units.devicePixelRatio / 100
    property int fullRepWidth: 360 * scale
    property int fullRepHeight: 360 * scale
    property int sectionHeight: 180 * scale

    property int largeSpacing: 12 * scale
    property int mediumSpacing: 8 * scale
    property int smallSpacing: 6 * scale

    property int buttonMargin: 4 * scale
    property int buttonHeight: 48 * scale

    property int largeFontSize: 15 * scale
    property int mediumFontSize: 12 * scale
    property int smallFontSize: 7 * scale
    
    // Main Icon
    property string mainIconName: plasmoid.configuration.mainIconName
    property string mainIconHeight: plasmoid.configuration.mainIconHeight
    
    // Components
    property bool showKDEConnect: plasmoid.configuration.showKDEConnect
    property bool showNightColor: plasmoid.configuration.showNightColor
    property bool showColorSwitcher: plasmoid.configuration.showColorSwitcher
    property bool showDnd: plasmoid.configuration.showDnd
    property bool showVolume: plasmoid.configuration.showVolume
    property bool showBrightness: plasmoid.configuration.showBrightness
    property bool showMediaPlayer: plasmoid.configuration.showMediaPlayer
    property bool showCmd1: plasmoid.configuration.showCmd1
    property bool showCmd2: plasmoid.configuration.showCmd2
    property bool showPercentage: plasmoid.configuration.showPercentage
    
    property string cmdRun1: plasmoid.configuration.cmdRun1
    property string cmdTitle1: plasmoid.configuration.cmdTitle1
    property string cmdIcon1: plasmoid.configuration.cmdIcon1
    property string cmdRun2: plasmoid.configuration.cmdRun2
    property string cmdTitle2: plasmoid.configuration.cmdTitle2
    property string cmdIcon2: plasmoid.configuration.cmdIcon2

    readonly property bool inPanel: (Plasmoid.location === PlasmaCore.Types.TopEdge
        || Plasmoid.location === PlasmaCore.Types.RightEdge
        || Plasmoid.location === PlasmaCore.Types.BottomEdge
        || Plasmoid.location === PlasmaCore.Types.LeftEdge)
    
    Plasmoid.switchHeight: fullRepWidth
    Plasmoid.switchWidth: fullRepWidth
    Plasmoid.preferredRepresentation: inPanel ? plasmoid.compactRepresentation : plasmoid.fullRepresentation
    Plasmoid.fullRepresentation: FullRepresentation {}
    Plasmoid.compactRepresentation: CompactRepresentation {}
}

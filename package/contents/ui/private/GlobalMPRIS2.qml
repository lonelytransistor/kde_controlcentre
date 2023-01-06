import QtQuick 2.0
import org.kde.plasma.core 2.1 as PlasmaCore

Item {
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
                    "seekTo": function(v)    {var s=serviceForSource(this.source);var o=s.operationDescription("SetPosition");o.microseconds=v;s.startOperationCall(o);},
                    "update": function()     {var s=serviceForSource(this.source);var o=s.operationDescription("GetPosition");                 s.startOperationCall(o);}
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

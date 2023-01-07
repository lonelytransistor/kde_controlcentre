import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.components 3.0 as PlasmaComponents

import "../lib" as Lib

Lib.Card {
    id: volumeRoot

    readonly property var mpris2: global.sources.mpris2
    readonly property var multiplex: mpris2.multiplex ? mpris2.multiplex : {}
    readonly property var players: mpris2.players ? mpris2.players : {}
    readonly property var printf: global.misc.time.printf

    visible: players.length!=0

    leftTitle: {
        if (multiplex.title) {
            return multiplex.title
        } else if (multiplex.url) {
            return multiplex.url
        } else {
            return "Unknown track"
        }
    }
    rightSubtitle: {
        if (multiplex.artist) {
            return multiplex.artist
        } else {
            return "Unknown artist"
        }
    }
    Timer {
        running: plasmoid.expanded
        repeat: true
        interval: 1000
        triggeredOnStart: true
        onTriggered: {
            if (volumeRoot.isExpanded) {
                for (var player of volumeRoot.players) {
                    if (player.isPlaying) {
                        player.update();
                    }
                }
            }
            if (volumeRoot.multiplex.isPlaying) {
                volumeRoot.multiplex.update();
            }
        }
    }

    small: [
        Item {
            Layout.fillWidth: true
            height: 32
            Image {
                id: thumbnail
                anchors {
                    left: parent.left
                    bottom: parent.bottom
                    leftMargin: global.smallSpacing
                }
                width: 60
                height: 60
                source: multiplex.art ? multiplex.art : "../../assets/music.png"
                fillMode: Image.PreserveAspectFit
                onStatusChanged: if (status == Image.Error) { source = "../../assets/music.png" }
            }
            ToolButton {
                id: prevBTN
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    right: playBTN.left
                    rightMargin: global.smallSpacing
                }
                icon.name: "media-skip-backward"
                onClicked: multiplex.prev()
            }
            ToolButton {
                id: playBTN
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    right: nextBTN.left
                    rightMargin: global.smallSpacing
                }
                icon.name: multiplex.isPlaying ? "media-playback-pause" : "media-playback-start"
                onClicked: multiplex.isPlaying ? multiplex.pause() : multiplex.play()
            }
            ToolButton {
                id: nextBTN
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    right: parent.right
                    rightMargin: global.smallSpacing
                }
                icon.name: "media-skip-forward"
                onClicked: multiplex.next()
            }
        },
        Lib.Slider {
            id: playbackSlider
            value: position
            Layout.topMargin: -global.mediumFontSize*2
            title: printf(multiplex.position/1000, "%N:%S/") + printf(multiplex.length/1000, "%N:%S")
            tooltipValue: printf((isPressed ? value*multiplex.length/100 : multiplex.position)/1000, "%N:%S/") + printf(multiplex.length/1000, "%N:%S")
            onReleased: multiplex.seekTo(Math.round(value*multiplex.length/100));
            onIconPressed: multiplex.raise();

            property int position: Math.round(100*multiplex.position/multiplex.length);
            onPositionChanged: if (value != position && !isPressed) value = position;
        }
    ]
    big: [
        Lib.Splitter {},
        Lib.Label {
            text: volumeRoot.players.length==0 ? "No application is playing audio at this moment." : ""
            Layout.alignment: Qt.AlignHCenter
        },
        ListView {
            id: playerList
            property var modelDummy: []
            readonly property int modelCount: volumeRoot.players.length
            onModelCountChanged: {
                var _modelDummy = []
                for (var ix = 0; ix < modelCount; ix++) {
                    _modelDummy.push(0);
                }
                modelDummy = _modelDummy;
            }
            model: modelDummy
            Layout.preferredWidth: width
            width: parent.width
            height: Math.min(model.length, 4)*(spacing + sHeight) - spacing
            readonly property int sHeight: 50
            spacing: 20
            delegate: Item {
                id: playerItem
                width: playerList.width
                height: playerList.sHeight
                property var pmodel: volumeRoot.players[model.index]
                property var printf: volumeRoot.printf
                PlasmaComponents.Label {
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                    }
                    elide: Text.ElideRight
                    text: pmodel.app + ": " + pmodel.artist + " - " + pmodel.title
                    font.pixelSize: global.mediumFontSize
                    font.weight: Font.Bold
                    font.capitalization: Font.Capitalize
                }
                Lib.Slider {
                    anchors {
                        bottom: parent.bottom
                        left: parent.left
                        right: prevBTN.left
                        rightMargin: global.smallSpacing
                    }
                    value: position
                    tooltipValue: printf((isPressed ? value*pmodel.length/100 : pmodel.position)/1000, "%N:%S/") + printf(pmodel.length/1000, "%N:%S")
                    onReleased: pmodel.seekTo(Math.round(value*pmodel.length/100));
                    onIconPressed: pmodel.raise();
                    icon: pmodel.icon

                    property int position: Math.round(100*pmodel.position/pmodel.length);
                    onPositionChanged: if (value != position && !isPressed) value = position;
                }
                ToolButton {
                    id: prevBTN
                    anchors {
                        bottom: parent.bottom
                        right: playBTN.left
                        rightMargin: global.smallSpacing
                    }
                    icon.name: "media-skip-backward"
                    onClicked: pmodel.prev()
                }
                ToolButton {
                    id: playBTN
                    anchors {
                        bottom: parent.bottom
                        right: nextBTN.left
                        rightMargin: global.smallSpacing
                    }
                    icon.name: pmodel.isPlaying ? "media-playback-pause" : "media-playback-start"
                    onClicked: pmodel.isPlaying ? pmodel.pause() : pmodel.play()
                }
                ToolButton {
                    id: nextBTN
                    anchors {
                        bottom: parent.bottom
                        right: parent.right
                        rightMargin: global.smallSpacing
                    }
                    icon.name: "media-skip-forward"
                    onClicked: pmodel.next()
                }
            }
        }
    ]
}

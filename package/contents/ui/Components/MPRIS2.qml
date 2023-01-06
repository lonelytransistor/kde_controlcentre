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
                    player.update();
                }
            }
            volumeRoot.multiplex.update();
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
                source: multiplex.art ? multiplex.art : ""
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
            Layout.topMargin: -global.mediumFontSize*2.5
            title: printf(multiplex.position/1000, "%M:%S/") + printf(multiplex.length/1000, "%M:%S")
            onReleased: multiplex.seekTo(Math.round(value*multiplex.length/100));
            onIconPressed: multiplex.raise();

            property int position: Math.round(100*multiplex.position/multiplex.length);
            onPositionChanged: {
                if (value != position) {
                    value = position;
                }
            }
        }
    ]
    big: [
        Lib.Splitter {},
        PlasmaComponents.Label {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: width
            Layout.preferredHeight: height
            width: parent.width
            height: players.length==0 ? global.mediumFontSize*2 : 0
            visible: players.length==0
            text: "No application is playing audio at this moment."
            font.pixelSize: global.mediumFontSize
            font.weight: Font.Bold
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        },
        ListView {
            id: playerList
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: width
            Layout.preferredHeight: height
            model: players
            height: children[0].children.length ? Math.min(model.length, 4)*(spacing + children[0].children[0].height)-spacing : 0
            spacing: 20
            delegate: Item {
                id: playerItem
                width: playerList.width
                height: 50
                property var pmodel: volumeRoot.players[model.index]
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
                    onReleased: pmodel.seekTo(Math.round(value*pmodel.length/100));
                    onIconPressed: pmodel.raise();
                    icon: pmodel.icon

                    property int position: Math.round(100*pmodel.position/pmodel.length);
                    onPositionChanged: {
                        if (value != position) {
                            value = position;
                        }
                    }
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
                Lib.Splitter {}
            }
        }
    ]
}

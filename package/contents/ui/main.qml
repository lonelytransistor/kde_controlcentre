import QtQuick 2.0
import QtQuick.Controls 2.15

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.1 as PlasmaCore
import org.kde.plasma.private.volume 0.1 as Vol

import "private" as Private

Rectangle {
    id: global
    
    //clip: true

    readonly property var cards: Private.GlobalCards{}
    readonly property var misc: Private.GlobalMisc{}
    readonly property var sources: Item {
        readonly property var powerManagement: Private.GlobalPowerManagement{}
        readonly property var audio: Private.GlobalAudio{}
        readonly property var mpris2: Private.GlobalMPRIS2{}
        readonly property var palette: SystemPalette{colorGroup: SystemPalette.Active}
        readonly property var mail: Private.GlobalMailProvider{}
    }
    readonly property var prompt: Private.GlobalWindows{}

    // PROPERTIES
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

    readonly property bool inPanel: (
           Plasmoid.location === PlasmaCore.Types.TopEdge
        || Plasmoid.location === PlasmaCore.Types.RightEdge
        || Plasmoid.location === PlasmaCore.Types.BottomEdge
        || Plasmoid.location === PlasmaCore.Types.LeftEdge)
    Plasmoid.fullRepresentation: FullRepresentation {}
    Plasmoid.compactRepresentation: CompactRepresentation {}
    Plasmoid.preferredRepresentation: inPanel ? plasmoid.compactRepresentation : plasmoid.fullRepresentation
}

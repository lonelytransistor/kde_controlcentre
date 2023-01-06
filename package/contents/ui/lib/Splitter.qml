import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.margins: global.smallSpacing
    Layout.preferredHeight: height
    height: 1
    clip: true
    PlasmaCore.FrameSvgItem {
        anchors {
            fill: parent
            leftMargin: -global.smallSpacing
            rightMargin: -global.smallSpacing
        }
        imagePath: "opaque/dialogs/background"
    }
}

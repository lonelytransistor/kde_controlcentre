import QtQuick 2.15
import QtQuick.Layouts 1.15

import org.kde.kirigami 2.13 as Kirigami
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kcoreaddons 1.0 as KCoreAddons
import org.kde.plasma.private.kicker 0.1 as Kicker
import org.kde.kquickcontrolsaddons 2.0 as KQuickAddons

import "../lib" as Lib

Item {
    Rectangle {
        id: userImage
        KCoreAddons.KUser {
            id: kuser
        }
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            leftMargin: global.smallSpacing
        }
        width: height
        radius: width/2
        color: "transparent"
        border.width: PlasmaCore.Units.devicePixelRatio * 2
        border.color: PlasmaCore.Theme.buttonFocusColor
        clip: true

        Kirigami.Avatar {
            anchors.fill: parent
            source: kuser.faceIconUrl
            name: kuser.fullName
        }
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: KQuickAddons.KCMShell.openSystemSettings("kcm_users")
        }
    }
    Lib.ButtonRow {
        anchors {
            left: userImage.right
            top: parent.top
            bottom: parent.bottom
            right: parent.right
        }
        spacing: 0
        layoutDirection: Qt.RightToLeft
        buttons: Lib.ModelTranslator {
            dict: {"tooltip":"display", "icon":"decoration", "onClicked": n=>function(){model.trigger(n.index, "", null)}}
            model: Kicker.SystemModel{}
        }
    }
    objectName: "Card"
    height: pHeight
    width: pWidth
    readonly property int pHeight: 40
    readonly property int pWidth: global.fullRepWidth
}

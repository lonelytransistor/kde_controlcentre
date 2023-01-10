import QtQuick 2.15
import QtQuick.Layouts 1.15

import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore

import "../lib" as Lib

Lib.Card {
    id: protonRoot

    readonly property var mail: global.sources.mail.protonMail

    leftTitle: "ProtonMail"
    rightTitle: mail.unread.length>1 ? (mail.unread.length + " unread e-mails.") : (mail.unread.length==1 ? "1 unread e-mail." : "No unread e-mails.")
    visible: mail.unread.length>0

    buttons: [{
        "icon": "view-refresh",
        "tooltip": "Update",
        "onClicked": mail.update
    }]

    Timer {
        id: updateTimer
        interval: 30*60*1000
        onTriggered: mail.update()
        triggeredOnStart: true
        running: true
    }
    small: [
        Lib.SwipeableListView {
            jsonModel: protonRoot.mail.unread

            textCentre: m => m.senders[0] + ": " + m.subject
            iconCentre: m => m.icon
            textRight: m => "Archive"
            textLeft: m => "Read"
            onOpenLeft: m.read()
            onOpenRight: m.archive()
        }
    ]
    big: []
}

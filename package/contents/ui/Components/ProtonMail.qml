import QtQuick 2.15
import QtQuick.Layouts 1.15

import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore

import "../lib" as Lib
import ".."

Lib.Card {
    widgetInfo: WidgetInfo {
        title: "ProtonMail client"
        description: "A widget checking for e-mails on your ProtonMail account every 30 minutes."
        icon: "mail-read"
        uuid: "protonmail"
    }

    id: protonRoot

    readonly property var mail: Global.sources.mail.protonMail

    leftTitle: "ProtonMail"
    rightTitle: mail.unread.length>1 ? (mail.unread.length + " new e-mails.") : (mail.unread.length==1 ? "1 new e-mail." : "No new e-mails.")

    Timer {
        id: updateTimer
        interval: 30*60*1000
        onTriggered: mail.update();
        triggeredOnStart: true
        running: true
    }
    small: [
        Lib.SwipeableListView {
            jsonModel: protonRoot.mail.unread

            canRefresh: true
            onRefresh: protonRoot.mail.update()
            onJsonModelChanged: refreshed()

            textCentre: m => m.senders[0] + ": " + m.subject
            iconCentre: m => m.icon
            textRight: m => "Archive"
            textLeft: m => "Read"
            onOpenLeft: m.cmds.read()
            onOpenRight: m.cmds.archive()
        }
    ]
    big: []
}

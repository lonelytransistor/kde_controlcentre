import QtQuick 2.0
import org.kde.notificationmanager 1.0 as NotificationManager

Item {
    Timer {
        running: notificationSettings.isInhibited
        interval: 10*60*1000
        repeat: true
        onTriggered: notificationSettings.settingsChanged()
    }
    NotificationManager.Settings {
        id: notificationSettings
        Component.onCompleted: settingsChanged();
        onSettingsChanged: {
            if (!serverRunning) {
                return;
            }
            var _inhibitedUntil = notificationSettings.notificationsInhibitedUntil.getTime();

            var _inhibited = Date.now() < _inhibitedUntil;
            _inhibited |= notificationSettings.notificationsInhibitedByApplication;
            _inhibited |= notificationSettings.screensMirrored && notificationSettings.inhibitNotificationsWhenScreensMirrored;
            isInhibited1 = _inhibited;

            inhibitedUntil = Math.max(0, (_inhibitedUntil - Date.now())/1000);
        }

        property bool serverRunning: NotificationManager.Server.valid
        property bool isInhibited1: false
        property bool isInhibited2: false
        property bool isInhibited: isInhibited1 || isInhibited2
        property int inhibitedUntil: 0
    }

    readonly property var uninhibit: function() {
        notificationSettings.screensMirrored = false;
        notificationSettings.notificationsInhibitedUntil = undefined;
        notificationSettings.revokeApplicationInhibitions();
        notificationSettings.save();
    }
    readonly property bool serverRunning: notificationSettings.serverRunning
    readonly property bool isInhibited: notificationSettings.isInhibited
    readonly property int inhibitedUntil: notificationSettings.inhibitedUntil
    readonly property var inhibit: function(time){notificationSettings
        if (isInhibited) {
            uninhibit();
        }
        if (time == 0) {
            return;
        }
        notificationSettings.notificationsInhibitedUntil = new Date(Date.now() + time*1000);
        notificationSettings.save();
    }
}

import QtQml 2.0
import QtQuick 2.0
import QtQuick.Layouts 1.15

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.private.volume 0.1 as Vol

import "../lib" as Lib
import "../js/funcs.js" as Funcs

Lib.ProgressBar {
    Layout.fillWidth: true
    Layout.preferredHeight: root.sectionHeight*0.6
    title: i18n("Battery")
    
    PlasmaCore.DataSource {
        id: battery

        engine: "powermanagement"
        connectedSources: ["Battery"]

        property int now
        property bool isCharging
        property string status
        property string status2
        onDataChanged: {
            let remainingHoursFrac = data["Battery"]["Remaining msec"]/(3600*1000)
            isCharging = data["Battery"]["State"] != "Discharging"

            let remainingHours = Math.floor(remainingHoursFrac)
            let remainingMinutes = Math.round(60 * (remainingHoursFrac - remainingHours))
            remainingMinutes = remainingMinutes < 10 ? "0"+remainingMinutes : remainingMinutes

            if (remainingHours > 24 || (remainingHours == 0 && remainingMinutes == 0)) {
                status2 = ""
            } else {
                status2 = (isCharging ? "Time to full charge: " : "Time left: ") + remainingHours + ":" + remainingMinutes
            }
            status  =  isCharging ? "Charging." : "Discharging"
            now = data["Battery"]["Percent"]
        }
    }
    
    value: battery.now
    secondaryTitle: battery.now + "%"
    subTitle: battery.status
    subSecondaryTitle: battery.status2
    
    source: {
        battery.now < 0 ?
        "battery-missing" :
        battery.now < 10 ?
        battery.isCharging ?
            "battery-empty-batteryCharging" :
            "battery-empty" :
        battery.now < 25 ?
        battery.isCharging ?
            "battery-caution-batteryCharging" :
            "battery-caution" :
        battery.now < 50 ?
        battery.isCharging ?
            "battery-low-batteryCharging" :
            "battery-low" :
        battery.now < 75 ?
        battery.isCharging ?
            "battery-good-batteryCharging" :
            "battery-good" :
        battery.isCharging ?
        "battery-full-batteryCharging":
        "battery-full"
    }
}

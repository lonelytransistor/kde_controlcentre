import QtQml 2.0
import QtQuick 2.0
import QtQuick.Layouts 1.15

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.private.volume 0.1 as Vol

import "../lib" as Lib
import "../js/funcs.js" as Funcs

import TouchArea 1.0
import StatisticsProvider 1.0

Lib.ProgressBar {
    title: i18n("Battery")


    StatisticsProvider {
        id: history
        duration: 86400
        device: getUdi()[0]
        type: StatisticsProvider.ChargeType
    }

    Lib.BatteryGraph {
        id: graph

        data: history.points

        // Set grid lines distances which directly correspondent to the xTicksAt variables
        readonly property var xDivisionWidths: [1000 * 60 * 10, 1000 * 60 * 60 * 12, 1000 * 60 * 60, 1000 * 60 * 30, 1000 * 60 * 60 * 2, 1000 * 60 * 10]
        xTicksAt: xTicksAtFullSecondHour
        xDivisionWidth: xDivisionWidths[xTicksAt]

        xMin: history.firstDataPointTime
        xMax: history.lastDataPointTime
        xDuration: history.duration

        yUnits: i18nc("literal percent sign","%")
        yMax: 100
        yStep: 20
        visible: history.count > 1
    }

    PlasmaCore.DataSource {
        id: pmSource

        engine: "powermanagement"
        connectedSources: ["Battery", "Inhibitions"]

        property int now
        property bool isCharging
        property string status
        property string status2
        property var inhibitions: []
        onSourceAdded: {
            disconnectSource(source);
            connectSource(source);
        }
        onSourceRemoved: {
            disconnectSource(source);
        }
        onDataChanged: {
            if (data) {
                if (data["Inhibitions"]) {
                    let inhibitions_p = []
                    for (let key in data["Inhibitions"]) {
                        //if (key === "plasmashell" || key === "plasmoidviewer") {
                        //    continue
                        //}
                        inhibitions_p.push(data["Inhibitions"][key])
                    }
                    inhibitions = inhibitions_p
                }
                if (data["Battery"]) {
                    let remainingHoursFrac = data["Battery"]["Remaining msec"]/(3600*1000)
                    isCharging = data["Battery"]["State"] != "Discharging"

                    let remainingHours = Math.floor(remainingHoursFrac)
                    let remainingMinutes = Math.round(60 * (remainingHoursFrac - remainingHours))
                    remainingMinutes = remainingMinutes < 10 ? "0"+remainingMinutes : remainingMinutes

                    if (remainingHours > 24 || (remainingHours == 0 && remainingMinutes == 0)) {
                        status2 = ""
                    } else {
                        status2 = (isCharging ? "Time to full: " : "Time left: ") + remainingHours + ":" + remainingMinutes
                    }
                    status  =  isCharging ? "Charging." : "Discharging"
                    now = data["Battery"]["Percent"]
                }
            }
        }
    }
    
    value: pmSource.now
    secondaryTitle: pmSource.now + "%"
    subTitle: pmSource.status
    subSecondaryTitle: pmSource.status2
    body: {
        if (pmSource.inhibitions.length > 0) {
            let text = ""
            for (let ix in pmSource.inhibitions) {
                if (ix != 0)
                    text += ", "
                text += pmSource.inhibitions[ix]["Name"]
            }
            if (pmSource.inhibitions.length == 1) {
                text += " blocks sleep."
            } else {
                text += " block sleep."
            }
            return text
        } else {
            return ""
        }
    }
    property bool sleepInhibited: false
    property int cookie1: -1
    property int cookie2: -1
    buttonIcon: [sleepInhibited ? "../assets/coffee_on.svg" : "../assets/coffee_off.svg"]
    buttonTooltip: [sleepInhibited ? "Release sleep inhibition" : "Inhibit sleep"]
    onButtonPress: {
        if (index == 0) {
            const service = pmSource.serviceForSource("PowerDevil");
            if (sleepInhibited) {
                const op1 = service.operationDescription("stopSuppressingSleep");
                op1.cookie = cookie1;
                const op2 = service.operationDescription("stopSuppressingScreenPowerManagement");
                op2.cookie = cookie2;
                const job1 = service.startOperationCall(op1);
                job1.finished.connect(job => {
                    cookie1 = -1;
                });
                const job2 = service.startOperationCall(op2);
                job2.finished.connect(job => {
                    cookie2 = -1;
                });

                sleepInhibited = false;
            } else {
                const reason = i18n("The control centre applet has enabled system-wide inhibition");
                const op1 = service.operationDescription("beginSuppressingSleep");
                op1.reason = reason;
                const op2 = service.operationDescription("beginSuppressingScreenPowerManagement");
                op2.reason = reason;
                const job1 = service.startOperationCall(op1);
                job1.finished.connect(job => {
                    cookie1 = job.result;
                });
                const job2 = service.startOperationCall(op2);
                job2.finished.connect(job => {
                    cookie2 = job.result;
                });

                sleepInhibited = true;
            }
        }
    }

    source: {
        pmSource.now < 0 ?
        "battery-missing" :
        pmSource.now < 10 ?
        pmSource.isCharging ?
            "battery-empty-batteryCharging" :
            "battery-empty" :
        pmSource.now < 25 ?
        pmSource.isCharging ?
            "battery-caution-batteryCharging" :
            "battery-caution" :
        pmSource.now < 50 ?
        pmSource.isCharging ?
            "battery-low-batteryCharging" :
            "battery-low" :
        pmSource.now < 75 ?
        pmSource.isCharging ?
            "battery-good-batteryCharging" :
            "battery-good" :
        pmSource.isCharging ?
        "battery-full-batteryCharging":
        "battery-full"
    }
}

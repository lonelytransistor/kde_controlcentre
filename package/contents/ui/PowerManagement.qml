import QtQuick 2.15
import org.kde.plasma.core 2.0 as PlasmaCore

import StatisticsProvider 1.0
import SystemConfig 1.0

Item {
    id: pmRoot
    SystemConfig { id: sysConf }
    readonly property var lid: Item {
        function backupEntry(newValue) {
            var old = sysConf.readEntry("powermanagementprofilesrc", [type, "HandleButtonEvents"], "lidAction");
            sysConf.writeEntry("powermanagementprofilesrc", [type, "HandleButtonEvents"], "lidActionOld", old);
            sysConf.writeEntry("powermanagementprofilesrc", [type, "HandleButtonEvents"], "lidAction", newValue);
            sysConf.refreshPM();
        }
        function unbackupEntry() {
            var old = sysConf.readEntry("powermanagementprofilesrc", [type, "HandleButtonEvents"], "lidActionOld");
            if (old != "") {
                sysConf.deleteEntry("powermanagementprofilesrc", [type, "HandleButtonEvents"], "lidActionOld");
                sysConf.writeEntry("powermanagementprofilesrc", [type, "HandleButtonEvents"], "lidAction", old);
                sysConf.refreshPM();
            }
        }
        function getInhibited() {
            return sysConf.readEntry("powermanagementprofilesrc", [type, "HandleButtonEvents"], "lidAction") == 0 &&
                   sysConf.readEntry("powermanagementprofilesrc", [type, "HandleButtonEvents"], "lidActionOld") != "";
        }
        readonly property string pType: pmRoot.battery.charging ? "AC" : "Battery";
        property string type: "";
        onPTypeChanged: {
            unbackupEntry();
            inhibited = getInhibited();
            type = pType;
        }

        property bool inhibited: getInhibited(pmRoot.battery.charging ? "AC" : 'Battery') != "0"
        readonly property var inhibit: function() {
            var isInhibited = getInhibited();
            if (!isInhibited) {
                backupEntry(0);
            }
            inhibited = getInhibited();
        }
        readonly property var uninhibit: function() {
            var isInhibited = getInhibited();
            if (isInhibited) {
                unbackupEntry();
            }
            inhibited = getInhibited();
        }
    }
    readonly property var battery: Item {
        readonly property int percent: pmSource.now
        readonly property int rate: pmSource.rate
        readonly property bool charging: pmSource.isCharging
        readonly property var remaining: Item {
            readonly property double hours: Math.floor(pmSource.remaining/3600)
            readonly property double minutes: Math.floor(pmSource.remaining/60)
            readonly property double seconds: Math.floor(pmSource.remaining)
        }
        readonly property string icon: root.misc.getIcon.volume(pmSource.now, pmSource.isCharging)
        readonly property string status: pmSource.status
        readonly property string timeStatus: pmSource.status2
        readonly property var history: Item {
            readonly property var charge: StatisticsProvider {
                                            duration: 86400
                                            device: getUdi()[0]
                                            type: StatisticsProvider.ChargeType
                                        }
            readonly property var rate: StatisticsProvider {
                                            duration: 86400
                                            device: getUdi()[0]
                                            type: StatisticsProvider.RateType
                                        }
        }
    }
    readonly property var inhibitions: Item {
        readonly property bool present: cookies.sleepInhibited
        readonly property var list: pmSource.inhibitions
        readonly property int count: list.length

        signal inhibit
        signal uninhibit

        Item {
            id: cookies
            property int cookie1
            property int cookie2
            property bool sleepInhibited: false
            property var service: null
        }
        onUninhibit: {
            if (!cookies.service) {
                cookies.service = pmSource.serviceForSource("PowerDevil")
            }
            if (cookies.sleepInhibited) {
                const op1 = cookies.service.operationDescription("stopSuppressingSleep");
                op1.cookie = cookies.cookie1;
                const op2 = cookies.service.operationDescription("stopSuppressingScreenPowerManagement");
                op2.cookie = cookies.cookie2;
                const job1 = cookies.service.startOperationCall(op1);
                job1.finished.connect(job => {
                    cookies.cookie1 = -1;
                });
                const job2 = cookies.service.startOperationCall(op2);
                job2.finished.connect(job => {
                    cookies.cookie2 = -1;
                });

                cookies.sleepInhibited = false;
            }
        }
        onInhibit: {
            if (!cookies.service) {
                cookies.service = pmSource.serviceForSource("PowerDevil")
            }
            if (!cookies.sleepInhibited) {
                const reason = i18n("The control centre applet has enabled system-wide inhibition");
                const op1 = cookies.service.operationDescription("beginSuppressingSleep");
                op1.reason = reason;
                const op2 = cookies.service.operationDescription("beginSuppressingScreenPowerManagement");
                op2.reason = reason;
                const job1 = cookies.service.startOperationCall(op1);
                job1.finished.connect(job => {
                    cookies.cookie1 = job.result;
                });
                const job2 = cookies.service.startOperationCall(op2);
                job2.finished.connect(job => {
                    cookies.cookie2 = job.result;
                });

                cookies.sleepInhibited = true;
            }
        }
    }
    readonly property var brightness: Item {
        property int screen: pmSource.brightnessScreen
        property int keyboard: pmSource.brightnessKbd
        onScreenChanged: {
            if (screen != pmSource.brightnessScreen) {
                const service = pmSource.serviceForSource("PowerDevil");
                const operation = service.operationDescription("setBrightness");
                operation.brightness = screen;

                const job1 = service.startOperationCall(operation);
                job1.finished.connect(job => {
                    screen = pmSource.brightnessScreen;
                });
            }
        }
        onKeyboardChanged: {
            if (keyboard != pmSource.brightnessKbd) {
                const service = pmSource.serviceForSource("PowerDevil");
                const operation = service.operationDescription("setKeyboardBrightness");
                operation.brightness = keyboard;

                const job1 = service.startOperationCall(operation);
                job1.finished.connect(job => {
                    keyboard = pmSource.brightnessKbd;
                });
            }
        }
    }

    PlasmaCore.DataSource {
        id: pmSource

        engine: "powermanagement"
        connectedSources: ["Battery", "Inhibitions", "PowerDevil"]

        property int rate
        property int now
        property int remaining
        property bool isCharging
        property string status
        property string status2
        property var inhibitions: []
        property var brightnessKbd: 0
        property var brightnessScreen: 0
        onSourceAdded: {
            disconnectSource(source);
            connectSource(source);
        }
        onSourceRemoved: {
            disconnectSource(source);
        }
        onDataChanged: {
            if (data) {
                if (data["PowerDevil"]) {
                    brightnessScreen = data["PowerDevil"]["Screen Brightness"]
                    brightnessKbd = data["PowerDevil"]["Keyboard Brightness"]
                }
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
                    remaining = Math.abs(data["Battery"]["Remaining msec"]<<0>>0)/1000
                    isCharging = data["Battery"]["State"] != "Discharging"

                    let remainingHours = Math.floor(remaining/3600)
                    let remainingMinutes = Math.round(remaining/60 - remainingHours*60)
                    remainingMinutes = (remainingMinutes < 10 ? "0" : "") + remainingMinutes

                    if (remainingHours > 24 || (remainingHours == 0 && remainingMinutes == 0)) {
                        status2 = ""
                    } else {
                        status2 = (isCharging ? "Time to full: " : "Time left: ") + remainingHours + ":" + remainingMinutes
                    }
                    status  =  isCharging ? "Charging" : "Discharging"
                    now = data["Battery"]["Percent"]
                    rate = Math.round(3600.0*now/remaining);
                }
            }
        }
    }
}

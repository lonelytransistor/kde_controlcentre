import QtQuick 2.0
import PythonLoader 1.0
import Utilities 1.0

Item {
    Utilities{id: utilsInternal}

    readonly property var python: Item {
        PythonLoader {
            id: pyInternal
            property bool initialized: false
        }

        function initPython() {
            if (!pyInternal.initialized) {
                var newCwd = Qt.resolvedUrl(".").substring(7);
                pyInternal.initialized = pyInternal.switchCwd(newCwd);

                if (pyInternal.initialized) {
                    console.log("Python initialization succeeded!", newCwd);
                } else {
                    console.log("Python initialization failed! CWD =", newCwd);
                }
            }
        }
        readonly property var call: function(mod, func, args=[]) {
            initPython();
            return pyInternal.call(mod, func, args);
        }
        readonly property var get: function(mod, name) {
            initPython();
            if (arguments.length == 1) {
                return pyInternal.get("__main__", mod);
            } else {
                return pyInternal.get(mod, name);
            }
        }
        readonly property var set: function(mod, name, val) {
            initPython();
            if (arguments.length == 1) {
                return pyInternal.set("__main__", mod, val);
            } else {
                return pyInternal.set(mod, name, val);
            }
        }
        readonly property var importModule: function(mod) {
            initPython();
            return pyInternal.importModule(mod);
        }
    }
    readonly property var getImageType: utilsInternal.getImageType;
    readonly property var getImageAverageColor: function(item, cb) {
        if (item.width > 0 && item.height > 0 && item.parent) {
            item.grabToImage(result => cb(utilsInternal.getAverageColor(result)));
        }
    }
    readonly property var dBus: Item {
        readonly property var call: function(service, path, iface, method, args, convert="") {
            return utilsInternal.dbusCall(service, path, iface, method, args, convert);
        }
        readonly property var get: function(service, path, iface, name) {
            return utilsInternal.dbusGet(service, path, iface, name);
        }
    }
    readonly property var getInvertedColor: function(color) {
        if (color) {
            return Qt.rgba(255-color.r, 255-color.g, 255-color.b, color.a);
        } else {
            return Qt.rgba(0,0,0,0);
        }
    }
    readonly property var getIcon: Item {
        readonly property var network: function(networkStrength, networkType) {
            var prefixes = ["network-mobile-0", "network-mobile-20", "network-mobile-60", "network-mobile-80", "network-mobile-100"];
            var suffixes = {"LTE": "-lte", "HSPA": "-hspa", "UMTS": "-umts", "EDGE": "-edge", "GPRS": "-gprs"};
            return (networkStrength<0 ? "network-mobile-off" : (prefixes[networkStrength] ? prefixes[networkStrength] : "network-mobile-available")) +
                    (suffixes[networkType] ? suffixes[networkType] : "");
        }
        readonly property var volume: function(volume) {
            let name = "audio-volume";
            if (volume <= 0) {
                name += "-muted";
            } else if (volume <= 25) {
                name += "-low";
            } else if (volume <= 75) {
                name += "-medium";
            } else {
                name += "-high";
            }
            return name;
        }
        readonly property var battery: function(now, isCharging) {
            return (now <  0 ? "battery-missing" :
                    now < 10 ? isCharging ? "battery-empty-batteryCharging": "battery-empty":
                    now < 25 ? isCharging ? "battery-caution-batteryCharging": "battery-caution":
                    now < 50 ? isCharging ? "battery-low-batteryCharging": "battery-low":
                    now < 75 ? isCharging ? "battery-good-batteryCharging": "battery-good":
                                isCharging ? "battery-full-batteryCharging": "battery-full")
        }
        readonly property var brightness: function(value) {
            return (value < 33 ? "brightness-low" :
                                    "brightness-high")
        }
    }
    readonly property var object: Item {
        readonly property var max: function(arr, v, cb = (n => n)) {
            if (!arr || !v || !cb)
                return null;

            var ret = -Infinity;
            for (var ix = 0; ix < (arr.count ? arr.count : arr.length ? arr.length : arr.size); ix++) {
                if (cb(arr[ix])) {
                    ret = Math.max(ret, arr[ix][v]);
                }
            }
            return ret;
        }
        readonly property var min: function(arr, v, cb = (n => n)) {
            if (!arr || !v || !cb)
                return null;

            var ret = Infinity;
            for (var ix = 0; ix < (arr.count ? arr.count : arr.length ? arr.length : arr.size); ix++) {
                if (cb(arr[ix])) {
                    ret = Math.min(ret, arr[ix][v]);
                }
            }
            return ret;
        }
        readonly property var sum: function(arr, v, cb = (n => n)) {
            if (!arr || !v || !cb)
                return null;

            var ret = 0;
            for (var ix = 0; ix < (arr.count ? arr.count : arr.length ? arr.length : arr.size); ix++) {
                if (cb(arr[ix])) {
                    ret += arr[ix][v];
                }
            }
            return ret;
        }
        readonly property var findChild: function(obj, cb) {
            function _find(child) {
                var ret = [];
                var _max = (child&&child.children) ? child.children.length : 0;

                for (var ix = 0; ix < _max; ix++) {
                    var _child = child.children[ix];
                    if (cb(_child)) {
                        ret = ret.concat(_child);
                    } else {
                        ret = ret.concat(_find(_child));
                    }
                }
                return ret;
            }

            if (!obj || !cb) {
                return null;
            } else {
                return _find(obj);
            }
        }
    }
    readonly property var time: Item {
        readonly property var printf: function(ms, format) {
            var hoursF = Math.floor(ms/3600000);
            var minutesF = Math.floor(ms/60000);
            var secondsF = Math.floor(ms/1000);
            var msecondsF = Math.floor(ms);
            var hours = hoursF;
            var minutes = minutesF - hours*60;
            var seconds = secondsF - hours*3600 - minutes*60;
            var mseconds = msecondsF - hours*3600000 - minutes*60000;

            var ret = ""
            for (var fmt of format.split(/(%?.)/g)) {
                if (fmt == "%H") {
                    ret += (hours < 10 ? "0" : "") + hours
                } else if (fmt == "%h") {
                    ret += hours
                } else if (fmt == "%N") {
                    ret += (minutesF < 10 ? "0" : "") + minutesF
                } else if (fmt == "%M") {
                    ret += (minutes < 10 ? "0" : "") + minutes
                } else if (fmt == "%m") {
                    ret += minutes
                } else if (fmt == "%A") {
                    ret += (secondsF < 10 ? "0" : "") + secondsF
                } else if (fmt == "%S") {
                    ret += (seconds < 10 ? "0" : "") + seconds
                } else if (fmt == "%s") {
                    ret += seconds
                } else if (fmt == "%S") {
                    ret += (seconds < 10 ? "0" : "") + seconds
                } else if (fmt == "%s") {
                    ret += seconds
                } else {
                    ret += fmt
                }
            }
            return ret
        }
    }
}

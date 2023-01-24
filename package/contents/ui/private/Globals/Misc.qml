import QtQuick 2.0
import org.kde.plasma.plasmoid 2.0

import "../"
import PythonLoader 1.0
import Utilities 1.0

Item {
    id: root
    Utilities{id: utilsInternal}

    readonly property var convert: Item {
        readonly property var bytesToUnicode: function(data) {
            var strs = [];
            var str = "";

            for (var ix=0; ix<data.length; ix+=2) {
                var chr = data[ix]*0x100 + data[ix+1];
                if (chr != 0) {
                    str += String.fromCharCode(chr);
                } else {
                    strs.push(str);
                    str = "";
                }
            }
            if (str != "") {
                strs.push(str);
            }
            return strs;
        }
        readonly property var unicodeToBytes: function(data) {
            var ret = [];
            for (var ix=0; ix<data.length; ix++) {
                var code = data.charCodeAt(ix);
                ret.push(code >> 8);
                ret.push(code & 0xFF);
            }
            return ret;
        }
        readonly property var bytesToInt: function(data) {
            var ret = 0;
            for (var ix=0; ix<data.length; ix++) {
                ret = (ret<<8) + data[ix];
            }
            return ret;
        }
        readonly property var intToBytes: function(data, size) {
            var ret = [];
            var num = data;
            for (var ix=0; ix<size; ix++) {
                ret.push(num & 0xFF);
                num = num>>8;
            }
            return ret.reverse();
        }
    }
    readonly property var store: Item {
        readonly property var wallet: Item {
            Item {
                id: walletInternal
                property string appName: "LonelyTransistor.ControlCentre2"
                property int handle: 0
            }
            function bytesToUnicode(data) {return root.convert.bytesToUnicode(data)}
            function unicodeToBytes(data) {return root.convert.unicodeToBytes(data)}
            function bytesToInt(data) {return root.convert.bytesToInt(data)}
            function intToBytes(data,size) {return root.convert.intToBytes(data,size)}

            Component.onDestruction: close()

            readonly property var open: function() {
                if (walletInternal.handle <= 0)
                    walletInternal.handle = root.dBus.call("org.kde.kwalletd5", "/modules/kwalletd5", "org.kde.KWallet", "open", ["kdewallet", 0, walletInternal.appName], [0,4,0])[0];
                if (walletInternal.handle <= 0)
                    console.warn("KWallet refused to open for us.");
                return walletInternal.handle > 0;
            }
            readonly property var close: function() {
                if (walletInternal.handle != -1) {
                    var ret = root.dBus.call("org.kde.kwalletd5", "/modules/kwalletd5", "org.kde.KWallet", "close", [walletInternal.handle, false, walletInternal.appName])[0];
                    walletInternal.handle = -1;
                    return ret;
                }
                return true;
            }
            readonly property var hasFolder: function(folder = walletInternal.appName) {
                if (!open())
                    return false;
                return root.dBus.call("org.kde.kwalletd5", "/modules/kwalletd5", "org.kde.KWallet", "hasFolder", [walletInternal.handle, folder, walletInternal.appName])[0];
            }
            readonly property var createFolder: function(folder = walletInternal.appName) {
                if (!open())
                    return false;
                var exists = hasFolder(folder);
                if (!exists) {
                    return root.dBus.call("org.kde.kwalletd5", "/modules/kwalletd5", "org.kde.KWallet", "createFolder", [walletInternal.handle, folder, walletInternal.appName])[0];
                } else {
                    return true;
                }
            }
            readonly property var readMap: function(key, folder = walletInternal.appName) {
                if (!open())
                    return false;
                var ret = {};
                var map = root.dBus.call("org.kde.kwalletd5", "/modules/kwalletd5", "org.kde.KWallet", "readMap", [walletInternal.handle, folder, key, walletInternal.appName], [], [9])[0];

                var mapSize = bytesToInt(map.slice(0, 4));
                map = map.slice(4);

                for (var ix=0; ix<mapSize; ix++) {
                    var size = bytesToInt(map.slice(0, 4));
                    var mKey = bytesToUnicode(map.slice(4, size+4))[0];
                    map = map.slice(size+4);

                    var size = bytesToInt(map.slice(0, 4));
                    var mVal = bytesToUnicode(map.slice(4, size+4))[0];
                    map = map.slice(size+4);

                    ret[mKey] = mVal;
                }
                return ret;
            }
            readonly property var writeMap: function(key, map, folder = walletInternal.appName) {
                if (!open())
                    return false;
                var value = [];
                createFolder(folder);

                var keys = Object.keys(map);
                value = value.concat(intToBytes(keys.length, 4));
                for (var mKey of keys) {
                    var mVal = unicodeToBytes(map[mKey]);
                    mKey = unicodeToBytes(mKey);

                    value = value.concat(intToBytes(mKey.length, 4));
                    value = value.concat(mKey);
                    value = value.concat(intToBytes(mVal.length, 4));
                    value = value.concat(mVal);
                }
                return root.dBus.call("org.kde.kwalletd5", "/modules/kwalletd5", "org.kde.KWallet", "writeMap", [walletInternal.handle, folder, key, value, walletInternal.appName], [0,0,0,12,0], [])[0];
            }
        }
    }
    readonly property var std: Item {
        readonly property var suppress: n => utilsInternal.swallowErrors(n);
    }
    readonly property var python: Item {
        PythonLoader {
            id: pyInternal
            property bool initialized: false
        }

        readonly property var call: function(mod, func, args=[]) {
            return pyInternal.call(mod, func, args);
        }
        readonly property var get: function(mod, name) {
            if (arguments.length == 1) {
                return pyInternal.get("__main__", mod);
            } else {
                return pyInternal.get(mod, name);
            }
        }
        readonly property var set: function(mod, name, val) {
            if (arguments.length == 1) {
                return pyInternal.set("__main__", mod, val);
            } else {
                return pyInternal.set(mod, name, val);
            }
        }
        readonly property var importModule: function(mod) {
            return pyInternal.importModule(mod);
        }
    }
    readonly property var getB64ImageType: function(data) {
        if (data.substring(0,5) == "data:") {
            return data.substring(5,data.search(";"));
        } else {
            return "";
        }
    }
    readonly property var getImageType: utilsInternal.getImageType;
    readonly property var getImageAverageColor: function(item, cb) {
        if (item.width > 0 && item.height > 0 && item.parent) {
            item.grabToImage(result => cb(utilsInternal.getAverageColor(result)));
        }
    }
    readonly property var dBus: Item {
        readonly property var call: function(service, path, iface, method, args=[], convertInput=[], convertOutput=[], isSystem=false) {
            var cI = convertInput.concat([]);
            var cO = convertOutput.concat([]);
            while (cI.length < args.length) cI.push(0);
            while (cO.length < args.length) cO.push(0);
            return utilsInternal.dbusCall(service, path, iface, method, args, cI, cO, isSystem);
        }
        readonly property var get: function(service, path, iface, name, isSystem=false) {
            return utilsInternal.dbusGet(service, path, iface, name, isSystem);
        }
        readonly property var set: function(service, path, iface, name, value, convert=0, isSystem=false) {
            return utilsInternal.dbusSet(service, path, iface, name, value, convert, isSystem);
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

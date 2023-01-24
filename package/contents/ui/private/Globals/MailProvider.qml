import QtQuick 2.0

Item {
    Item {
        id: pythonInternal
        property var python: ini.t ? Global.misc.python : null
    }
    readonly property var gMail: Item {
        readonly property var python: pythonInternal.python

        property var unread: []
        readonly property string walletFolder: "gmaillogins"
        readonly property var _module: python ? python.importModule(Script("Gmail")) : null
        readonly property var _mainClass: python ? python.get(_module, "main") : null
        readonly property int _DUMMY: python ? python.get(_mainClass, "DUMMY") : 0
        readonly property int _NEEDS_REAUTH: python ? python.get(_mainClass, "NEEDS_REAUTH") : 0
        readonly property var reauthenticate: function() {
            Global.prompt.login(Asset("gmail.svg"), "Type in your gmail e-mail and your app password.", function(finish, errors, login, password, save) {
                var ret = python.call("Gmail", "setCredentials", [login, password]);
                if (ret == 0) {
                    if (save) {
                        var map = Global.misc.store.wallet.readMap(walletFolder);
                        map["default"] = login;
                        map[login] = password;
                        Global.misc.store.wallet.writeMap(walletFolder, map);
                    }
                    update();
                    finish("Logged in successfully.");
                } else {
                    errors("Failed to log in.");
                }
            }, function(){unread=[]}, true);
        }
        readonly property var update: function() {
            if (!Global.finishedLoading) {
                console.warn("Top level reports non-initialized popup.");
                return;
            }
            var map = Global.misc.store.wallet.readMap(walletFolder);
            var login = map["default"];
            if (login && map[login]) {
                python.call("Gmail", "setCredentials", [login, map[login]])
            }
            var _mails = python.call("Gmail", "newMails");
            var status = python.call("Gmail", "status");
            if (status & _NEEDS_REAUTH) {
                reauthenticate();
            } else if (status == 0) {
                var ret = [];
                for (var x of _mails) {
                    var it = x;
                    var uid = it["ID"];
                    it["cmds"] = {
                       "uid": uid,
                       "read": function() {python.call("Gmail","read",[this.uid, true]); this.update();},
                       "archive": function() {python.call("Gmail","archive",[this.uid, true]); this.update();},
                       "update": update
                    }
                    ret.push(it);
                }
                unread = ret;
            }
        }
    }
    readonly property var protonMail: Item {
        readonly property var python: pythonInternal.python

        property var unread: []
        readonly property string walletFolder: "protonmaillogins"
        readonly property var _module: python ? python.importModule(Script("ProtonMail")) : null
        readonly property var _mainClass: python ? python.get(_module, "main") : null
        readonly property int _DUMMY: python ? python.get(_mainClass, "DUMMY") : 0
        readonly property int _NEEDS_REAUTH: python ? python.get(_mainClass, "NEEDS_REAUTH") : 0
        readonly property var reauthenticate: function() {
            Global.prompt.login(Asset("protonmail.svg"), "Type in your ProtonMail credentials.", function(finish, errors, login, password, save) {
                var ret = python.call("ProtonMail", "setCredentials", [login, password]);
                if (ret == 0) {
                    if (save) {
                        var map = Global.misc.store.wallet.readMap(walletFolder);
                        map["default"] = login;
                        map[login] = password;
                        Global.misc.store.wallet.writeMap(walletFolder, map);
                    }
                    update();
                    finish("Logged in successfully.");
                } else {
                    errors("Failed to log in.");
                }
            }, function(){unread=[]}, true);
        }
        readonly property var update: function() {
            if (!Global.finishedLoading) {
                console.warn("Top level reports non-initialized popup.");
                return;
            }
            var map = Global.misc.store.wallet.readMap(walletFolder);
            var login = map["default"];
            if (login && map[login]) {
                python.call("ProtonMail", "setCredentials", [login, map[login]])
            }
            var _mails = python.call("ProtonMail", "newMails");
            var status = python.call("ProtonMail", "status");
            if (status & _NEEDS_REAUTH) {
                reauthenticate();
            } else if (status == 0) {
                var ret = [];
                for (var x of _mails) {
                    var it = x;
                    var uid = it["ID"];
                    it["cmds"] = {
                       "uid": uid,
                       "read": function() {python.call("ProtonMail","read",[this.uid, true]); this.update();},
                       "archive": function() {python.call("ProtonMail","archive",[this.uid, true]); this.update();},
                       "update": update
                    }
                    ret.push(it);
                }
                unread = ret;
            }
        }
    }
}

import QtQuick 2.0

Item {
    readonly property var protonMail: Item {
        readonly property var python: global.misc.python

        property var unread: []
        readonly property var _module: python.importModule("./protonmail")
        readonly property var _mainClass: python.get(_module, "main")
        readonly property int _DUMMY: python.get(_mainClass, "DUMMY")
        readonly property int _NEEDS_REAUTH: python.get(_mainClass, "NEEDS_REAUTH")
        readonly property var reauthenticate: function() {
            global.prompt.login("protonmail.svg", "Type in your ProtonMail credentials.", function(finish, errors, login, password) {
                var ret = python.call("protonmail", "setCredentials", [login, password]);
                if (ret == 0) {
                    finish("Logged in successfully.");
                } else {
                    errors("Failed to log in.");
                }
            }, function(){unread=[]});
        }
        readonly property var update: function() {
            var _mails = python.call("protonmail", "newMails");
            var status = python.call("protonmail", "status");
            if (status & _NEEDS_REAUTH) {
                reauthenticate();
            } else if (status == 0) {
                var ret = [];
                for (var x of _mails) {
                    var it = x;
                    var uid = it["ID"];
                    it["cmds"] = {
                       "uid": uid,
                       "read": function() {python.call("protonmail","read",[this.uid, true]); this.update();},
                       "archive": function() {python.call("protonmail","archive",[this.uid, true]); this.update();},
                       "update": global.sources.mail.protonMail.update
                    }
                    ret.push(it);
                }
                unread = ret;
            }
        }
    }
}

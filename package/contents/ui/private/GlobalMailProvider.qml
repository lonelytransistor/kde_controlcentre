import QtQuick 2.0

Item {
    readonly property var protonMail: Item {
        Component.onCompleted: global.misc.python.importModule("./protonmail")

        property var unread: []
        readonly property int _DUMMY: 0b1000
        readonly property int _NEEDS_REAUTH: 0b0010
        readonly property var reauthenticate: function() {
            global.prompt.login("protonmail.svg", "Type in your ProtonMail credentials.", function(finish, errors, login, password) {
                var ret = global.misc.python.call("protonmail", "setCredentials", [login, password]);
                if (ret == 0) {
                    finish("Logged in successfully.");
                } else {
                    errors("Failed to log in.");
                }
            }, function(){unread=[]});
        }
        readonly property var update: function() {
            var _mails = global.misc.python.call("protonmail", "newMails", []);
            global.misc.python.printError();
            var status = global.misc.python.call("protonmail", "status", []);
            global.misc.python.printError();
            if (status & _NEEDS_REAUTH) {
                reauthenticate();
            } else if (status == 0) {
                var ret = [];
                for (var x of _mails) {
                    var it = x;
                    it["read"] = () => global.misc.python.call("protonmail", "read", [this.ID, true]);
                    it["archive"] = () => global.misc.python.call("protonmail", "archive", [this.ID, true]);
                    ret.push(it);
                }
                unread = ret;
            }
        }
    }
}

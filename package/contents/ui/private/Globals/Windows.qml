import QtQuick 2.0
import "windows" as W

Item {
    Item {
        id: cache
        property var activeWindow: null
        property var login: Component{W.Login{}}
    }
    Timer {
        id: destroy
        interval: 1
        onTriggered: {
            if (cache.activeWindow) {
                cache.activeWindow.destroy();
                console.log("Destroyed window");
                cache.activeWindow = null;
            }
        }
    }
    readonly property var login: function(logo, prompt, cbAccept, cbReject, showSave=false) {
        var window = cache.login.createObject(Global, {logo: logo, prompt: prompt, showSave: showSave});
        window.accepted.connect(cbAccept);
        window.rejected.connect(cbReject);
        window.closed.connect(destroy.start);
        cache.activeWindow = window;
        window.show();
    }
}

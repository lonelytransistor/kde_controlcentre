import QtQuick 2.0

Item {
    Item {
        id: cache
        property var activeWindow: null
        property var login: Component{WindowLogin{}}
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
    readonly property var login: function(logo, prompt, cbAccept, cbReject) {
        var window = cache.login.createObject(global, {logo: logo, prompt: prompt});
        window.accepted.connect(cbAccept);
        window.rejected.connect(cbReject);
        window.closed.connect(destroy.start);
        cache.activeWindow = window;
        window.show();
    }
}

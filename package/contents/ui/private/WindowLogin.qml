import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Window 2.15

Window {
    id: root

    property color backGroundColor : "#394454"
    property color mainAppColor: "#6fda9c"
    property color mainTextColor: "#f0f0f0"
    property color popupErrorBackgroundColor: "#b44"
    property color popupFinishBackgroundColor: "#4b4"
    property color popupTextColor: "#ffffff"

    property string logo: "protonmail.svg"
    property string prompt: "Type in your ProtonMail credentials."
    property string finishMessage: ""
    property string errorMessage: ""

    property int logoSpacing: 70
    property int itemSpacing: 30

    FontLoader {
        id: fontAwesome
        name: "fontawesome"
        source: "fontawesome-webfont.ttf"
    }
    color: backGroundColor

    signal accepted(finish: var, error: var, login: string, password: string)
    signal rejected
    signal closed
    signal finish(err: string)
    signal errors(err: string)

    onClosing: {
        if (finishMessage == "") {
            rejected();
        }
        closed();
    }
    onFinish: {
        finishMessage = err;
        spinner.visible = true;
        errorPopup.open();
    }
    onErrors: {
        errorMessage = err;
        spinner.visible = false;
        errorPopup.open();
    }

    Image {
        id: logo
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            topMargin: root.logoSpacing
        }
        height: width*0.15
        fillMode: Image.PreserveAspectFit
        horizontalAlignment: Image.AlignHCenter
        source: !!root.logo ? root.logo : ""
        onStatusChanged: if (status==Image.Error && source) { source = ""; icon.name = root.logo }
    }
    Text {
        id: prompt
        anchors {
            top: logo.bottom
            topMargin: root.itemSpacing
            horizontalCenter: parent.horizontalCenter
        }
        text: root.prompt
        color: mainTextColor
        font.pixelSize: 14
        font.weight: Font.Bold
    }
    WindowLoginTextField {
        id: login
        anchors {
            top: prompt.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: root.itemSpacing
        }
        icon: "\uf007"
        placeholderText: qsTr("User name")
        onAccepted: loginBtn.clicked()
    }
    WindowLoginTextField {
        id: password
        anchors {
            top: login.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: root.itemSpacing
        }
        icon: "\uf023"
        echoMode: TextInput.Password
        placeholderText: qsTr("Password")
        onAccepted: loginBtn.clicked()
    }
    Item {
        anchors {
            top: password.bottom
            left: password.left
            right: password.right
            topMargin: root.itemSpacing
        }
        WindowLoginButton {
            id: loginBtn
            anchors {
                top: parent.top
                left: parent.left
            }
            name: "Log In"
            baseColor: mainAppColor
            onClicked: {
                if (password.text.length && login.text.length) {
                    spinner.visible = true;
                    root.accepted(root.finish, root.errors, login.text, password.text);
                } else if (!password.text.length && !login.text.length) {
                    root.errors("Please enter your credentials.");
                } else if (!password.text.length) {
                    root.errors("Please enter your password.");
                } else if (!login.text.length) {
                    root.errors("Please enter your user name.");
                }
            }
        }
        WindowLoginButton {
            id: cancelBtn
            anchors {
                top: parent.top
                right: parent.right
            }
            name: "Cancel"
            baseColor: "transparent"
            onClicked: {
                root.rejected();
            }
        }
    }
    Popup {
        id: errorPopup
        y: parent.height - height
        width: parent.width
        height: 60

        background: Rectangle { color: root.errorMessage ? popupErrorBackgroundColor : popupFinishBackgroundColor }
        modal: true
        focus: true
        closePolicy: Popup.CloseOnPressOutside
        Text {
            id: message
            anchors.centerIn: parent
            font.pointSize: 12
            text: root.errorMessage ? root.errorMessage : root.finishMessage
            color: popupTextColor
        }
        Timer {
            id: popupClose
            interval: 2000
            onTriggered: {
                if (root.errorMessage) {
                    errorPopup.close();
                    root.errorMessage = "";
                } else {
                    root.close();
                }
            }
        }
        onOpened: popupClose.start()
    }
    MouseArea {
        id: spinner
        anchors.fill: parent
        enabled: visible
        visible: false
        Rectangle {
            anchors.fill: parent
            color: "#000000"
            opacity: 0.4
        }
        BusyIndicator {
            anchors.centerIn: parent
            running: parent.visible && parent.enabled
        }
    }
}

import QtQuick 2.0

Item {
    readonly property bool isValid: title!="" && description!="" && icon!="" && uuid!=""

    property string title: ""
    property string description: ""
    property string icon: ""
    property string uuid: ""
}

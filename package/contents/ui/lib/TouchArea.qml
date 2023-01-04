import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: touchAreaItem
    property bool enabled: true

    signal touchPress(ev: var)
    signal touchRelease(ev: var)
    signal touchMove(ev: var)
    signal mousePress(ev: var)
    signal mouseRelease(ev: var)
    signal mouseMove(ev: var)

    Component.onCompleted: touchRoot.append(touchAreaItem)
    Component.onDestruction: touchRoot.remove(touchAreaItem)
}

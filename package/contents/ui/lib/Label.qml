import QtQuick 2.15
import QtQuick.Layouts 1.15

import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore

PlasmaComponents.Label {
    Layout.fillWidth: true
    font.pixelSize: root.mediumFontSize
    wrapMode: Text.WordWrap
    elide: Text.ElideRight
    maximumLineCount: 3

    height: text!="" ? Math.round(Math.max(paintedHeight, PlasmaCore.Theme.mSize(PlasmaCore.Theme.defaultFont).height*1.6)) : 0
    visible: text!=""
}

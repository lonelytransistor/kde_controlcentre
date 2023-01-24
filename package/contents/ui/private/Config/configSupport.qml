import QtQuick 2.10
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.10
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras
import "../../lib" as Lib

Row {
    spacing: 10
    PlasmaExtras.Heading {
        anchors.verticalCenter: kofi.verticalCenter
        text: i18n("You can support my work here:")
    }
    Image {
        id: kofi
        height: PlasmaCore.Units.gridUnit * 2.5
        source: "../../../assets/Ko-Fi.png"
        fillMode: Image.PreserveAspectFit
        MouseArea {
            anchors.fill: parent
            onClicked: {
                var point = mapToGlobal(mouse.x, mouse.y);
                heart.show(point.x, point.y);
            }
        }
        Lib.DissolvingPopup {
            id: heart
            width: 64
            height: 64
            image: "../../assets/heart.svg"
            onFinished: Qt.openUrlExternally("https://ko-fi.com/lonelytransistor")
        }
    }
}

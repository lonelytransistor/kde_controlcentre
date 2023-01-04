import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents

Item {
    id: sliderRoot

    property alias icon: icon.source
    property alias value: control.value
    property alias from: control.from
    property alias to: control.to
    property int highlight: 0

    signal moved
    signal released
    signal iconPressed

    height: icon.height
    width: parent.width
    Layout.fillHeight: true
    Layout.fillWidth: true

    PlasmaCore.IconItem {
        id: icon
        height: root.largeFontSize*2
        width: height
        MouseArea {
            anchors.fill: parent
            onPressed: sliderRoot.iconPressed();
        }
    }
    PlasmaComponents.Slider {
        id: control
        anchors {
            left: icon.source ? icon.right : parent.left
            leftMargin: root.smallSpacing
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
        from: 0
        to: 100
        property double highlight: (sliderRoot.highlight - from)/(to - from)
        Behavior on highlight {
            NumberAnimation  {
                duration: PlasmaCore.Units.shortDuration
                easing.type: Easing.OutQuad
            }
        }
        onMoved: parent.moved();
        onPressedChanged: {
            if (!pressed)
                parent.released();
        }
        background: PlasmaCore.FrameSvgItem {
            imagePath: "widgets/slider"
            prefix: "groove"
            colorGroup: PlasmaCore.ColorScope.colorGroup

            implicitWidth: control.horizontal ? PlasmaCore.Units.gridUnit * 12 : fixedMargins.left + fixedMargins.right
            implicitHeight: control.vertical ? PlasmaCore.Units.gridUnit * 12 : fixedMargins.top + fixedMargins.bottom

            width: control.horizontal ? Math.max(fixedMargins.left + fixedMargins.right, control.availableWidth) : implicitWidth
            height: control.vertical ? Math.max(fixedMargins.top + fixedMargins.bottom, control.availableHeight) : implicitHeight

            x: control.leftPadding + (control.horizontal ? 0 : Math.round((control.availableWidth - width) / 2))
            y: control.topPadding + (control.vertical ? 0 : Math.round((control.availableHeight - height) / 2))

            PlasmaCore.FrameSvgItem {
                imagePath: "widgets/slider"
                prefix: "groove-highlight"
                colorGroup: PlasmaCore.ColorScope.colorGroup

                anchors.left: parent.left
                anchors.bottom: parent.bottom
                LayoutMirroring.enabled: control.mirrored

                width: control.horizontal ? Math.max(fixedMargins.left + fixedMargins.right, Math.round(control.position * (control.availableWidth - control.handle.width / 2) + (control.handle.width / 2))) : parent.width
                height: control.vertical ? Math.max(fixedMargins.top + fixedMargins.bottom, Math.round(control.position * (control.availableHeight - control.handle.height / 2) + (control.handle.height / 2))) : parent.height
            }

            PlasmaCore.FrameSvgItem {
                imagePath: "widgets/slider"
                prefix: "groove-highlight"
                status: PlasmaCore.FrameSvgItem.Selected
                visible: control.highlight > 0

                anchors.left: parent.left
                anchors.bottom: parent.bottom
                LayoutMirroring.enabled: control.mirrored

                width: control.horizontal ? Math.max(fixedMargins.left + fixedMargins.right, Math.round(control.highlight * control.position * control.availableWidth)) : parent.width
                height: control.vertical ? Math.max(fixedMargins.top + fixedMargins.bottom, Math.round(control.highlight * control.position * control.availableHeight)) : parent.height
            }
        }
    }
}

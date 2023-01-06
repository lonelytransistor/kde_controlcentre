import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents

Item {
    id: sliderRoot

    property alias icon: icon.source
    property alias value: control.value
    property alias from: control.from
    property alias step: control.stepSize
    property alias to: control.to
    property alias info: info.text
    property alias title: title.text
    property int highlight: 0

    signal moved
    signal pressed
    signal released
    signal iconPressed

    height: title.visible ? icon.height + title.height : icon.height
    width: parent.width
    Layout.fillHeight: true
    Layout.fillWidth: true

    PlasmaComponents.Label {
        id: title
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }
        font.pixelSize: global.mediumFontSize
        font.weight: Font.Bold
        font.capitalization: Font.Capitalize
        visible: text!=""
    }
    PlasmaCore.IconItem {
        id: icon
        anchors {
            left: parent.left
            verticalCenter: control.verticalCenter
        }
        height: global.largeFontSize*2
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
            leftMargin: global.smallSpacing
            right: info.text ? info.left : parent.right
            rightMargin: global.smallSpacing
            top: title.visible ? title.bottom : parent.top
            topMargin: title.visible ? -title.height*0.25 : 0
            bottom: parent.bottom
        }
        from: 0
        to: 100
        snapMode: stepSize ? PlasmaComponents.Slider.SnapAlways : PlasmaComponents.Slider.NoSnap
        property double highlight: (sliderRoot.highlight - from)/(to - from)
        Behavior on highlight {
            NumberAnimation  {
                duration: PlasmaCore.Units.shortDuration
                easing.type: Easing.OutQuad
            }
        }
        onMoved: parent.moved();
        onPressedChanged: {
            if (pressed) {
                parent.pressed();
            } else {
                parent.released();
            }
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
    PlasmaComponents.Label {
        id: info
        anchors {
            right: parent.right
            rightMargin: global.smallSpacing
            verticalCenter: control.verticalCenter
        }
        elide: Text.ElideRight
        font.weight: Font.Bold
        font.pixelSize: global.largeFontSize
        visible: text!=""
    }
}

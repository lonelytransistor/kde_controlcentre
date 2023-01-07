import QtQuick 2.15
import QtQuick.Shapes 1.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

ToolTip {
    id: root

    property int handleHeight: 10
    property int radius: Math.min(width, height) * 0.1
    property int borderWidth: 1
    property color borderColor: "black"
    property color backgroundColor: "white"
    text: ""
    visible: !!text
    topPadding: 20

    delay: -1
    contentItem: Text {
        id: textIt
        anchors.top: parent.top
        text: root.text
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: global.largeFontSize
        font.weight: Font.Bold
    }
    background: Shape {
        id: shape
        layer.enabled: true
        layer.samples: 16

        ShapePath {
            id: path
            strokeWidth: root.borderWidth
            strokeColor: root.borderColor
            fillColor: root.backgroundColor
            startX: shape.width/2
            startY: shape.height
            property int r: root.radius
            property int d: root.handleHeight
            PathLine {x: 0;                    y: path.startY - path.d}
            PathLine {x: 0;                    y: path.r}
            PathArc  {x: path.r;               y: 0;                   radiusX: path.d; radiusY: path.d}
            PathLine {x: shape.width - path.r; y: 0}
            PathArc  {x: shape.width;          y: path.r;              radiusX: path.d; radiusY: path.d}
            PathLine {x: shape.width;          y: path.startY-path.d}
            PathLine {x: path.startX;          y: path.startY}
        }
    }
}

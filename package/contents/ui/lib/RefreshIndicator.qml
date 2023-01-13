import QtQuick 2.15
import QtQuick.Shapes 1.15

Shape {
    id: root
    layer.enabled: true
    layer.samples: 16

    width: Math.min(parent.width, parent.height)
    height: width

    property double position: 0
    property int arrowAngle: 50
    property double arrowFraction: 0.3
    property int radius: width/2
    property int borderWidth: radius*0.2
    property color borderColor: "black"
    property color backgroundColor: "transparent"

    ShapePath {
        id: path

        strokeWidth: root.borderWidth
        strokeColor: root.borderColor
        fillColor: root.backgroundColor
        capStyle: ShapePath.RoundCap

        PathAngleArc {
            id: arc

            centerX: root.radius
            centerY: root.radius
            radiusX: root.radius*0.8
            radiusY: root.radius*0.8

            startAngle: 90 + Math.min(root.position*90, 90) + 3*Math.max(root.position*90, 90)
            sweepAngle: 50 + 3*Math.min(root.position*90, 90)
            property double angleRp: Math.PI*(90 - (90 + sweepAngle + startAngle) + root.arrowAngle*1.4)/180
            property double angleRn: Math.PI*(90 - (90 + sweepAngle + startAngle) - root.arrowAngle)/180
        }
        PathLine {
            relativeX: -Math.cos(arc.angleRn)*root.radius*root.arrowFraction
            relativeY:  Math.sin(arc.angleRn)*root.radius*root.arrowFraction
        }
        PathMove {
            relativeX:  Math.cos(arc.angleRn)*root.radius*root.arrowFraction
            relativeY: -Math.sin(arc.angleRn)*root.radius*root.arrowFraction
        }
        PathLine {
            relativeX:  Math.cos(arc.angleRp)*root.radius*root.arrowFraction
            relativeY: -Math.sin(arc.angleRp)*root.radius*root.arrowFraction
        }
    }
}

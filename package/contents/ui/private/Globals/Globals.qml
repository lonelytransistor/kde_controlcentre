import QtQuick 2.0
import org.kde.plasma.core 2.1 as PlasmaCore
import "." as PrivateGlobals

Item {
    readonly property var qMetaType: {"Void": 43, "Bool": 1, "Int": 2, "UInt": 3, "Double": 6, "QChar": 7, "QString": 10, "QByteArray": 12, "Nullptr": 51, "VoidStar": 31, "Long": 32, "LongLong": 4, "Short": 33, "Char": 34, "Char16": 56, "Char32": 57, "ULong": 35, "ULongLong": 5, "UShort": 36, "SChar": 40, "UChar": 37, "Float": 38, "QObjectStar": 39, "QVariant": 41, "QCursor": 0, "QDate": 14, "QSize": 21, "QTime": 15, "QVariantList": 9, "QPolygon": 0, "QPolygonF": 0, "QColor": 0, "QColorSpace": 0, "QSizeF": 22, "QRectF": 20, "QLine": 23, "QTextLength": 0, "QStringList": 11, "QVariantMap": 8, "QVariantHash": 28, "QIcon": 0, "QPen": 0, "QLineF": 24, "QTextFormat": 0, "QRect": 19, "QPoint": 25, "QUrl": 17, "QRegularExpression": 44, "QDateTime": 16, "QPointF": 26, "QPalette": 0, "QFont": 0, "QBrush": 0, "QRegion": 0, "QBitArray": 13, "QImage": 0, "QKeySequence": 0, "QSizePolicy": 0, "QPixmap": 0, "QLocale": 18, "QBitmap": 0, "QTransform": 0, "QMatrix4x4": 0, "QVector2D": 0, "QVector3D": 0, "QVector4D": 0, "QQuaternion": 0, "QEasingCurve": 29, "QJsonValue": 45, "QJsonObject": 46, "QJsonArray": 47, "QJsonDocument": 48, "QCborValue": 53, "QCborArray": 54, "QCborMap": 55, "QCborSimpleType": 52, "QModelIndex": 42, "QPersistentModelIndex": 50, "QUuid": 30, "QByteArrayList": 49, "User": 65536};
    readonly property var compression: PrivateGlobals.Compression{}
    readonly property var cards: PrivateGlobals.Cards{}
    readonly property var misc: PrivateGlobals.Misc{}
    readonly property var fonts: PrivateGlobals.Fonts{}
    readonly property var sources: Item {
        readonly property var powerManagement: PrivateGlobals.PowerManagement{}
        readonly property var audio: PrivateGlobals.Audio{}
        readonly property var mpris2: PrivateGlobals.MPRIS2{}
        readonly property var palette: SystemPalette{colorGroup: SystemPalette.Active}
        readonly property var mail: PrivateGlobals.MailProvider{}
        readonly property var notifications: PrivateGlobals.Notifications{}
    }
    readonly property var prompt: PrivateGlobals.Windows{}

    property bool finishedLoading: false

    // PROPERTIES
    property var scale: plasmoid.configuration.scale * PlasmaCore.Units.devicePixelRatio / 100
    property int fullRepWidth: 360 * scale
    property int fullRepHeight: 360 * scale
    property int sectionHeight: 180 * scale

    property int largeSpacing: 12 * scale
    property int mediumSpacing: 8 * scale
    property int smallSpacing: 6 * scale

    property int buttonMargin: 4 * scale
    property int buttonHeight: 48 * scale

    property int largeFontSize: 15 * scale
    property int mediumFontSize: 12 * scale
    property int smallFontSize: 7 * scale

    // Main Icon
    property string mainIconName: plasmoid.configuration.mainIconName
    property string mainIconHeight: plasmoid.configuration.mainIconHeight
}

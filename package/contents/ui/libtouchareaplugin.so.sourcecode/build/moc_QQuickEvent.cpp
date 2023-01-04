/****************************************************************************
** Meta object code from reading C++ file 'QQuickEvent.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.15.7)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <memory>
#include "../QQuickEvent.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'QQuickEvent.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.15.7. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_QQuickEvent_t {
    QByteArrayData data[11];
    char stringdata0[65];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_QQuickEvent_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_QQuickEvent_t qt_meta_stringdata_QQuickEvent = {
    {
QT_MOC_LITERAL(0, 0, 11), // "QQuickEvent"
QT_MOC_LITERAL(1, 12, 1), // "x"
QT_MOC_LITERAL(2, 14, 1), // "y"
QT_MOC_LITERAL(3, 16, 6), // "startX"
QT_MOC_LITERAL(4, 23, 6), // "startY"
QT_MOC_LITERAL(5, 30, 4), // "endX"
QT_MOC_LITERAL(6, 35, 4), // "endY"
QT_MOC_LITERAL(7, 40, 6), // "button"
QT_MOC_LITERAL(8, 47, 2), // "id"
QT_MOC_LITERAL(9, 50, 5), // "state"
QT_MOC_LITERAL(10, 56, 8) // "accepted"

    },
    "QQuickEvent\0x\0y\0startX\0startY\0endX\0"
    "endY\0button\0id\0state\0accepted"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_QQuickEvent[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
       0,    0, // methods
      10,   14, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // properties: name, type, flags
       1, QMetaType::QReal, 0x00095401,
       2, QMetaType::QReal, 0x00095401,
       3, QMetaType::QReal, 0x00095401,
       4, QMetaType::QReal, 0x00095401,
       5, QMetaType::QReal, 0x00095401,
       6, QMetaType::QReal, 0x00095401,
       7, QMetaType::Int, 0x00095401,
       8, QMetaType::Int, 0x00095401,
       9, QMetaType::Int, 0x00095401,
      10, QMetaType::Bool, 0x00095103,

       0        // eod
};

void QQuickEvent::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{

#ifndef QT_NO_PROPERTIES
    if (_c == QMetaObject::ReadProperty) {
        auto *_t = static_cast<QQuickEvent *>(_o);
        (void)_t;
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< qreal*>(_v) = _t->x(); break;
        case 1: *reinterpret_cast< qreal*>(_v) = _t->y(); break;
        case 2: *reinterpret_cast< qreal*>(_v) = _t->startX(); break;
        case 3: *reinterpret_cast< qreal*>(_v) = _t->startY(); break;
        case 4: *reinterpret_cast< qreal*>(_v) = _t->endX(); break;
        case 5: *reinterpret_cast< qreal*>(_v) = _t->endY(); break;
        case 6: *reinterpret_cast< int*>(_v) = _t->button(); break;
        case 7: *reinterpret_cast< int*>(_v) = _t->id(); break;
        case 8: *reinterpret_cast< int*>(_v) = _t->state(); break;
        case 9: *reinterpret_cast< bool*>(_v) = _t->getAccepted(); break;
        default: break;
        }
    } else if (_c == QMetaObject::WriteProperty) {
        auto *_t = static_cast<QQuickEvent *>(_o);
        (void)_t;
        void *_v = _a[0];
        switch (_id) {
        case 9: _t->setAccepted(*reinterpret_cast< bool*>(_v)); break;
        default: break;
        }
    } else if (_c == QMetaObject::ResetProperty) {
    }
#endif // QT_NO_PROPERTIES
    (void)_o;
    (void)_id;
    (void)_c;
    (void)_a;
}

QT_INIT_METAOBJECT const QMetaObject QQuickEvent::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_meta_stringdata_QQuickEvent.data,
    qt_meta_data_QQuickEvent,
    qt_static_metacall,
    nullptr,
    nullptr
} };


const QMetaObject *QQuickEvent::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *QQuickEvent::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_QQuickEvent.stringdata0))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int QQuickEvent::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    
#ifndef QT_NO_PROPERTIES
    if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 10;
    } else if (_c == QMetaObject::QueryPropertyDesignable) {
        _id -= 10;
    } else if (_c == QMetaObject::QueryPropertyScriptable) {
        _id -= 10;
    } else if (_c == QMetaObject::QueryPropertyStored) {
        _id -= 10;
    } else if (_c == QMetaObject::QueryPropertyEditable) {
        _id -= 10;
    } else if (_c == QMetaObject::QueryPropertyUser) {
        _id -= 10;
    }
#endif // QT_NO_PROPERTIES
    return _id;
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE

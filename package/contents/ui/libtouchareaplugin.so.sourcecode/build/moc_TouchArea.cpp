/****************************************************************************
** Meta object code from reading C++ file 'TouchArea.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.15.7)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <memory>
#include "../TouchArea.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'TouchArea.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.15.7. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_TouchArea_t {
    QByteArrayData data[12];
    char stringdata0[112];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_TouchArea_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_TouchArea_t qt_meta_stringdata_TouchArea = {
    {
QT_MOC_LITERAL(0, 0, 9), // "TouchArea"
QT_MOC_LITERAL(1, 10, 11), // "QML.Element"
QT_MOC_LITERAL(2, 22, 4), // "auto"
QT_MOC_LITERAL(3, 27, 10), // "mousePress"
QT_MOC_LITERAL(4, 38, 0), // ""
QT_MOC_LITERAL(5, 39, 12), // "QQuickEvent*"
QT_MOC_LITERAL(6, 52, 2), // "ev"
QT_MOC_LITERAL(7, 55, 9), // "mouseMove"
QT_MOC_LITERAL(8, 65, 12), // "mouseRelease"
QT_MOC_LITERAL(9, 78, 10), // "touchPress"
QT_MOC_LITERAL(10, 89, 9), // "touchMove"
QT_MOC_LITERAL(11, 99, 12) // "touchRelease"

    },
    "TouchArea\0QML.Element\0auto\0mousePress\0"
    "\0QQuickEvent*\0ev\0mouseMove\0mouseRelease\0"
    "touchPress\0touchMove\0touchRelease"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_TouchArea[] = {

 // content:
       8,       // revision
       0,       // classname
       1,   14, // classinfo
       6,   16, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       6,       // signalCount

 // classinfo: key, value
       1,    2,

 // signals: name, argc, parameters, tag, flags
       3,    1,   46,    4, 0x06 /* Public */,
       7,    1,   49,    4, 0x06 /* Public */,
       8,    1,   52,    4, 0x06 /* Public */,
       9,    1,   55,    4, 0x06 /* Public */,
      10,    1,   58,    4, 0x06 /* Public */,
      11,    1,   61,    4, 0x06 /* Public */,

 // signals: parameters
    QMetaType::Void, 0x80000000 | 5,    6,
    QMetaType::Void, 0x80000000 | 5,    6,
    QMetaType::Void, 0x80000000 | 5,    6,
    QMetaType::Void, 0x80000000 | 5,    6,
    QMetaType::Void, 0x80000000 | 5,    6,
    QMetaType::Void, 0x80000000 | 5,    6,

       0        // eod
};

void TouchArea::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        auto *_t = static_cast<TouchArea *>(_o);
        (void)_t;
        switch (_id) {
        case 0: _t->mousePress((*reinterpret_cast< QQuickEvent*(*)>(_a[1]))); break;
        case 1: _t->mouseMove((*reinterpret_cast< QQuickEvent*(*)>(_a[1]))); break;
        case 2: _t->mouseRelease((*reinterpret_cast< QQuickEvent*(*)>(_a[1]))); break;
        case 3: _t->touchPress((*reinterpret_cast< QQuickEvent*(*)>(_a[1]))); break;
        case 4: _t->touchMove((*reinterpret_cast< QQuickEvent*(*)>(_a[1]))); break;
        case 5: _t->touchRelease((*reinterpret_cast< QQuickEvent*(*)>(_a[1]))); break;
        default: ;
        }
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        switch (_id) {
        default: *reinterpret_cast<int*>(_a[0]) = -1; break;
        case 0:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<int*>(_a[0]) = -1; break;
            case 0:
                *reinterpret_cast<int*>(_a[0]) = qRegisterMetaType< QQuickEvent* >(); break;
            }
            break;
        case 1:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<int*>(_a[0]) = -1; break;
            case 0:
                *reinterpret_cast<int*>(_a[0]) = qRegisterMetaType< QQuickEvent* >(); break;
            }
            break;
        case 2:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<int*>(_a[0]) = -1; break;
            case 0:
                *reinterpret_cast<int*>(_a[0]) = qRegisterMetaType< QQuickEvent* >(); break;
            }
            break;
        case 3:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<int*>(_a[0]) = -1; break;
            case 0:
                *reinterpret_cast<int*>(_a[0]) = qRegisterMetaType< QQuickEvent* >(); break;
            }
            break;
        case 4:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<int*>(_a[0]) = -1; break;
            case 0:
                *reinterpret_cast<int*>(_a[0]) = qRegisterMetaType< QQuickEvent* >(); break;
            }
            break;
        case 5:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<int*>(_a[0]) = -1; break;
            case 0:
                *reinterpret_cast<int*>(_a[0]) = qRegisterMetaType< QQuickEvent* >(); break;
            }
            break;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _t = void (TouchArea::*)(QQuickEvent * );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&TouchArea::mousePress)) {
                *result = 0;
                return;
            }
        }
        {
            using _t = void (TouchArea::*)(QQuickEvent * );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&TouchArea::mouseMove)) {
                *result = 1;
                return;
            }
        }
        {
            using _t = void (TouchArea::*)(QQuickEvent * );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&TouchArea::mouseRelease)) {
                *result = 2;
                return;
            }
        }
        {
            using _t = void (TouchArea::*)(QQuickEvent * );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&TouchArea::touchPress)) {
                *result = 3;
                return;
            }
        }
        {
            using _t = void (TouchArea::*)(QQuickEvent * );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&TouchArea::touchMove)) {
                *result = 4;
                return;
            }
        }
        {
            using _t = void (TouchArea::*)(QQuickEvent * );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&TouchArea::touchRelease)) {
                *result = 5;
                return;
            }
        }
    }
}

QT_INIT_METAOBJECT const QMetaObject TouchArea::staticMetaObject = { {
    QMetaObject::SuperData::link<QQuickItem::staticMetaObject>(),
    qt_meta_stringdata_TouchArea.data,
    qt_meta_data_TouchArea,
    qt_static_metacall,
    nullptr,
    nullptr
} };


const QMetaObject *TouchArea::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *TouchArea::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_TouchArea.stringdata0))
        return static_cast<void*>(this);
    return QQuickItem::qt_metacast(_clname);
}

int TouchArea::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QQuickItem::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 6)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 6;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 6)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 6;
    }
    return _id;
}

// SIGNAL 0
void TouchArea::mousePress(QQuickEvent * _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}

// SIGNAL 1
void TouchArea::mouseMove(QQuickEvent * _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 1, _a);
}

// SIGNAL 2
void TouchArea::mouseRelease(QQuickEvent * _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 2, _a);
}

// SIGNAL 3
void TouchArea::touchPress(QQuickEvent * _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 3, _a);
}

// SIGNAL 4
void TouchArea::touchMove(QQuickEvent * _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 4, _a);
}

// SIGNAL 5
void TouchArea::touchRelease(QQuickEvent * _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 5, _a);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE

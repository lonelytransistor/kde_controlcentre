/****************************************************************************
** Meta object code from reading C++ file 'StatisticsProvider.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.15.7)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <memory>
#include "../StatisticsProvider.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'StatisticsProvider.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.15.7. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_StatisticsProvider_t {
    QByteArrayData data[19];
    char stringdata0[205];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_StatisticsProvider_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_StatisticsProvider_t qt_meta_stringdata_StatisticsProvider = {
    {
QT_MOC_LITERAL(0, 0, 18), // "StatisticsProvider"
QT_MOC_LITERAL(1, 19, 13), // "deviceChanged"
QT_MOC_LITERAL(2, 33, 0), // ""
QT_MOC_LITERAL(3, 34, 11), // "typeChanged"
QT_MOC_LITERAL(4, 46, 15), // "durationChanged"
QT_MOC_LITERAL(5, 62, 11), // "dataChanged"
QT_MOC_LITERAL(6, 74, 7), // "refresh"
QT_MOC_LITERAL(7, 82, 6), // "getUdi"
QT_MOC_LITERAL(8, 89, 6), // "device"
QT_MOC_LITERAL(9, 96, 8), // "duration"
QT_MOC_LITERAL(10, 105, 4), // "type"
QT_MOC_LITERAL(11, 110, 11), // "HistoryType"
QT_MOC_LITERAL(12, 122, 6), // "points"
QT_MOC_LITERAL(13, 129, 5), // "count"
QT_MOC_LITERAL(14, 135, 18), // "firstDataPointTime"
QT_MOC_LITERAL(15, 154, 17), // "lastDataPointTime"
QT_MOC_LITERAL(16, 172, 12), // "largestValue"
QT_MOC_LITERAL(17, 185, 8), // "RateType"
QT_MOC_LITERAL(18, 194, 10) // "ChargeType"

    },
    "StatisticsProvider\0deviceChanged\0\0"
    "typeChanged\0durationChanged\0dataChanged\0"
    "refresh\0getUdi\0device\0duration\0type\0"
    "HistoryType\0points\0count\0firstDataPointTime\0"
    "lastDataPointTime\0largestValue\0RateType\0"
    "ChargeType"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_StatisticsProvider[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
       6,   14, // methods
       8,   50, // properties
       1,   82, // enums/sets
       0,    0, // constructors
       0,       // flags
       4,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    0,   44,    2, 0x06 /* Public */,
       3,    0,   45,    2, 0x06 /* Public */,
       4,    0,   46,    2, 0x06 /* Public */,
       5,    0,   47,    2, 0x06 /* Public */,

 // slots: name, argc, parameters, tag, flags
       6,    0,   48,    2, 0x0a /* Public */,
       7,    0,   49,    2, 0x0a /* Public */,

 // signals: parameters
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,

 // slots: parameters
    QMetaType::Void,
    QMetaType::QStringList,

 // properties: name, type, flags
       8, QMetaType::QString, 0x00495103,
       9, QMetaType::UInt, 0x00495103,
      10, 0x80000000 | 11, 0x0049510b,
      12, QMetaType::QVariantList, 0x00495001,
      13, QMetaType::Int, 0x00495001,
      14, QMetaType::Int, 0x00495001,
      15, QMetaType::Int, 0x00495001,
      16, QMetaType::Int, 0x00495001,

 // properties: notify_signal_id
       0,
       2,
       1,
       3,
       3,
       3,
       3,
       3,

 // enums: name, alias, flags, count, data
      11,   11, 0x0,    2,   87,

 // enum data: key, value
      17, uint(StatisticsProvider::RateType),
      18, uint(StatisticsProvider::ChargeType),

       0        // eod
};

void StatisticsProvider::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        auto *_t = static_cast<StatisticsProvider *>(_o);
        (void)_t;
        switch (_id) {
        case 0: _t->deviceChanged(); break;
        case 1: _t->typeChanged(); break;
        case 2: _t->durationChanged(); break;
        case 3: _t->dataChanged(); break;
        case 4: _t->refresh(); break;
        case 5: { QStringList _r = _t->getUdi();
            if (_a[0]) *reinterpret_cast< QStringList*>(_a[0]) = std::move(_r); }  break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _t = void (StatisticsProvider::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&StatisticsProvider::deviceChanged)) {
                *result = 0;
                return;
            }
        }
        {
            using _t = void (StatisticsProvider::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&StatisticsProvider::typeChanged)) {
                *result = 1;
                return;
            }
        }
        {
            using _t = void (StatisticsProvider::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&StatisticsProvider::durationChanged)) {
                *result = 2;
                return;
            }
        }
        {
            using _t = void (StatisticsProvider::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&StatisticsProvider::dataChanged)) {
                *result = 3;
                return;
            }
        }
    }
#ifndef QT_NO_PROPERTIES
    else if (_c == QMetaObject::ReadProperty) {
        auto *_t = static_cast<StatisticsProvider *>(_o);
        (void)_t;
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< QString*>(_v) = _t->m_device; break;
        case 1: *reinterpret_cast< uint*>(_v) = _t->m_duration; break;
        case 2: *reinterpret_cast< HistoryType*>(_v) = _t->m_type; break;
        case 3: *reinterpret_cast< QVariantList*>(_v) = _t->asPoints(); break;
        case 4: *reinterpret_cast< int*>(_v) = _t->count(); break;
        case 5: *reinterpret_cast< int*>(_v) = _t->firstDataPointTime(); break;
        case 6: *reinterpret_cast< int*>(_v) = _t->lastDataPointTime(); break;
        case 7: *reinterpret_cast< int*>(_v) = _t->largestValue(); break;
        default: break;
        }
    } else if (_c == QMetaObject::WriteProperty) {
        auto *_t = static_cast<StatisticsProvider *>(_o);
        (void)_t;
        void *_v = _a[0];
        switch (_id) {
        case 0: _t->setDevice(*reinterpret_cast< QString*>(_v)); break;
        case 1: _t->setDuration(*reinterpret_cast< uint*>(_v)); break;
        case 2: _t->setType(*reinterpret_cast< HistoryType*>(_v)); break;
        default: break;
        }
    } else if (_c == QMetaObject::ResetProperty) {
    }
#endif // QT_NO_PROPERTIES
}

QT_INIT_METAOBJECT const QMetaObject StatisticsProvider::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_meta_stringdata_StatisticsProvider.data,
    qt_meta_data_StatisticsProvider,
    qt_static_metacall,
    nullptr,
    nullptr
} };


const QMetaObject *StatisticsProvider::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *StatisticsProvider::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_StatisticsProvider.stringdata0))
        return static_cast<void*>(this);
    if (!strcmp(_clname, "QQmlParserStatus"))
        return static_cast< QQmlParserStatus*>(this);
    if (!strcmp(_clname, "org.qt-project.Qt.QQmlParserStatus"))
        return static_cast< QQmlParserStatus*>(this);
    return QObject::qt_metacast(_clname);
}

int StatisticsProvider::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 6)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 6;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 6)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 6;
    }
#ifndef QT_NO_PROPERTIES
    else if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 8;
    } else if (_c == QMetaObject::QueryPropertyDesignable) {
        _id -= 8;
    } else if (_c == QMetaObject::QueryPropertyScriptable) {
        _id -= 8;
    } else if (_c == QMetaObject::QueryPropertyStored) {
        _id -= 8;
    } else if (_c == QMetaObject::QueryPropertyEditable) {
        _id -= 8;
    } else if (_c == QMetaObject::QueryPropertyUser) {
        _id -= 8;
    }
#endif // QT_NO_PROPERTIES
    return _id;
}

// SIGNAL 0
void StatisticsProvider::deviceChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void StatisticsProvider::typeChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}

// SIGNAL 2
void StatisticsProvider::durationChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 2, nullptr);
}

// SIGNAL 3
void StatisticsProvider::dataChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 3, nullptr);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE

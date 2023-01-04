/****************************************************************************
** Meta object code from reading C++ file 'SystemConfig.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.15.7)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <memory>
#include "../SystemConfig.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'SystemConfig.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.15.7. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_SystemConfig_t {
    QByteArrayData data[11];
    char stringdata0[103];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_SystemConfig_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_SystemConfig_t qt_meta_stringdata_SystemConfig = {
    {
QT_MOC_LITERAL(0, 0, 12), // "SystemConfig"
QT_MOC_LITERAL(1, 13, 10), // "readConfig"
QT_MOC_LITERAL(2, 24, 0), // ""
QT_MOC_LITERAL(3, 25, 10), // "configName"
QT_MOC_LITERAL(4, 36, 10), // "writeEntry"
QT_MOC_LITERAL(5, 47, 9), // "groupName"
QT_MOC_LITERAL(6, 57, 7), // "varName"
QT_MOC_LITERAL(7, 65, 5), // "value"
QT_MOC_LITERAL(8, 71, 11), // "deleteEntry"
QT_MOC_LITERAL(9, 83, 9), // "readEntry"
QT_MOC_LITERAL(10, 93, 9) // "refreshPM"

    },
    "SystemConfig\0readConfig\0\0configName\0"
    "writeEntry\0groupName\0varName\0value\0"
    "deleteEntry\0readEntry\0refreshPM"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_SystemConfig[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
       8,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // slots: name, argc, parameters, tag, flags
       1,    1,   54,    2, 0x0a /* Public */,
       4,    4,   57,    2, 0x0a /* Public */,
       4,    4,   66,    2, 0x0a /* Public */,
       8,    3,   75,    2, 0x0a /* Public */,
       8,    3,   82,    2, 0x0a /* Public */,
       9,    3,   89,    2, 0x0a /* Public */,
       9,    3,   96,    2, 0x0a /* Public */,
      10,    0,  103,    2, 0x0a /* Public */,

 // slots: parameters
    QMetaType::QVariantMap, QMetaType::QString,    3,
    QMetaType::QVariant, QMetaType::QString, QMetaType::QStringList, QMetaType::QString, QMetaType::QVariant,    3,    5,    6,    7,
    QMetaType::QVariant, QMetaType::QString, QMetaType::QString, QMetaType::QString, QMetaType::QVariant,    3,    5,    6,    7,
    QMetaType::QVariant, QMetaType::QString, QMetaType::QStringList, QMetaType::QString,    3,    5,    6,
    QMetaType::QVariant, QMetaType::QString, QMetaType::QString, QMetaType::QString,    3,    5,    6,
    QMetaType::QVariant, QMetaType::QString, QMetaType::QStringList, QMetaType::QString,    3,    5,    6,
    QMetaType::QVariant, QMetaType::QString, QMetaType::QString, QMetaType::QString,    3,    5,    6,
    QMetaType::Void,

       0        // eod
};

void SystemConfig::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        auto *_t = static_cast<SystemConfig *>(_o);
        (void)_t;
        switch (_id) {
        case 0: { QVariantMap _r = _t->readConfig((*reinterpret_cast< QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QVariantMap*>(_a[0]) = std::move(_r); }  break;
        case 1: { QVariant _r = _t->writeEntry((*reinterpret_cast< QString(*)>(_a[1])),(*reinterpret_cast< QStringList(*)>(_a[2])),(*reinterpret_cast< QString(*)>(_a[3])),(*reinterpret_cast< QVariant(*)>(_a[4])));
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = std::move(_r); }  break;
        case 2: { QVariant _r = _t->writeEntry((*reinterpret_cast< QString(*)>(_a[1])),(*reinterpret_cast< QString(*)>(_a[2])),(*reinterpret_cast< QString(*)>(_a[3])),(*reinterpret_cast< QVariant(*)>(_a[4])));
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = std::move(_r); }  break;
        case 3: { QVariant _r = _t->deleteEntry((*reinterpret_cast< QString(*)>(_a[1])),(*reinterpret_cast< QStringList(*)>(_a[2])),(*reinterpret_cast< QString(*)>(_a[3])));
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = std::move(_r); }  break;
        case 4: { QVariant _r = _t->deleteEntry((*reinterpret_cast< QString(*)>(_a[1])),(*reinterpret_cast< QString(*)>(_a[2])),(*reinterpret_cast< QString(*)>(_a[3])));
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = std::move(_r); }  break;
        case 5: { QVariant _r = _t->readEntry((*reinterpret_cast< QString(*)>(_a[1])),(*reinterpret_cast< QStringList(*)>(_a[2])),(*reinterpret_cast< QString(*)>(_a[3])));
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = std::move(_r); }  break;
        case 6: { QVariant _r = _t->readEntry((*reinterpret_cast< QString(*)>(_a[1])),(*reinterpret_cast< QString(*)>(_a[2])),(*reinterpret_cast< QString(*)>(_a[3])));
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = std::move(_r); }  break;
        case 7: _t->refreshPM(); break;
        default: ;
        }
    }
}

QT_INIT_METAOBJECT const QMetaObject SystemConfig::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_meta_stringdata_SystemConfig.data,
    qt_meta_data_SystemConfig,
    qt_static_metacall,
    nullptr,
    nullptr
} };


const QMetaObject *SystemConfig::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *SystemConfig::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_SystemConfig.stringdata0))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int SystemConfig::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 8)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 8;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 8)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 8;
    }
    return _id;
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE

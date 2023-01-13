#pragma once

#include <QUrl>
#include <QString>
#include <QVariant>
#include <QByteArray>
#include <QStringList>
#include <QQmlContext>
#include <QQmlEngine>
#include <QMap>
#include <string>
#include <QDebug>
#include <dlfcn.h>
#include "LonelyTransistorBase.h"

#pragma push_macro("slots")
#undef slots
#include <Python.h>
#pragma pop_macro("slots")

#define toPyObjectFUNC(type, value) \
toPyObject(type v) {\
  PyObject* ret=value;\
  stackPush(ret);\
  return ret;\
}
#define py_newobj(name, value) \
  PyObject* name = value; \
  if (name == NULL) {\
    if (PyErr_Occurred()) {\
      PyErr_PrintEx(0);\
      PyErr_Clear();\
    }\
    stackFree();\
    return QVariant();\
  } else {\
    stackPush(name);\
  }

class PythonLoaderPyObject : public QObject
{
  Q_OBJECT

public:
  PythonLoaderPyObject() {
  }
  PythonLoaderPyObject(PyObject* obj) : QObject(nullptr) {
    m_obj = obj;
  }
  PythonLoaderPyObject(const PythonLoaderPyObject& obj) : QObject(nullptr) {
    m_obj = obj.m_obj;
  }
  PythonLoaderPyObject &operator=(const PythonLoaderPyObject& obj) {
    m_obj = obj.m_obj;
    return *this;
  }

  PyObject* getPyObject() {
    return m_obj;
  }
private:
  PyObject* m_obj = NULL;
};
Q_DECLARE_METATYPE(PythonLoaderPyObject);

class PythonLoader : public QObject, public LonelyTransistorBase
{
  Q_OBJECT

public:
  PythonLoader();
  ~PythonLoader();

public Q_SLOTS:
  bool switchCwd(QUrl cwd);

  void rawCall(QString script);
  QVariant importModule(QString url);
  QVariant importModule(QUrl url);
  QVariant getModule(QString mod);

  QVariant call(QString mod, QString fn, QVariantList params);
  QVariant get(QVariant obj, QString var);
  bool set(QVariant obj, QString var, QVariant val);

private:
  QStringList m_importPaths;
  QMap<QString, PyObject*> m_modules;
  QMap<QString, PyObject*> m_moduleDicts;

  int m_allocatedObjectsPointer = 0;
  QList<PyObject*> m_allocatedObjects;
  void stackSet();
  void stackPush(PyObject* v);
  void stackFree();

  PyObject* toPyObjectFUNC(QByteArray,         PyBytes_FromStringAndSize(v.data(), v.count()));
  PyObject* toPyObjectFUNC(const char*,        PyUnicode_FromString(v));
  PyObject* toPyObjectFUNC(char*,              PyUnicode_FromString(v));
  PyObject* toPyObjectFUNC(QString,            PyUnicode_FromString(v.toStdString().c_str()));
  PyObject* toPyObjectFUNC(int,                PyLong_FromLong(v));
  PyObject* toPyObjectFUNC(unsigned int,       PyLong_FromUnsignedLong(v));
  PyObject* toPyObjectFUNC(long,               PyLong_FromLong(v));
  PyObject* toPyObjectFUNC(unsigned long,      PyLong_FromUnsignedLong(v));
  PyObject* toPyObjectFUNC(long long,          PyLong_FromLongLong(v));
  PyObject* toPyObjectFUNC(unsigned long long, PyLong_FromLongLong(v));
  PyObject* toPyObjectFUNC(double,             PyFloat_FromDouble(v));
  PyObject* toPyObjectFUNC(bool,               v?Py_True:Py_False);
  PyObject* toPyObject(QVariantList v);
  PyObject* toPyObject(QVariantMap v);
  PyObject* toPyObject(QVariant v) {
    switch (v.type()) {
      case QVariant::Bool:
        return toPyObject(v.value<bool>());
      case QVariant::Double:
        return toPyObject(v.value<double>());
      case QVariant::Int:
        return toPyObject(v.value<int>());
      case QVariant::LongLong:
        return toPyObject(v.value<long long>());
      case QVariant::UInt:
        return toPyObject(v.value<unsigned int>());
      case QVariant::ULongLong:
        return toPyObject(v.value<unsigned long long>());
      case QVariant::String:
        return toPyObject(v.value<QString>());
      case QVariant::List:
        return toPyObject(v.value<QVariantList>());
      case QVariant::Map:
        return toPyObject(v.value<QVariantMap>());
      case QVariant::UserType:
        return qvariant_cast<PythonLoaderPyObject>(v).getPyObject();
      default:
        return Py_None;
    }
  }

  QVariant fromPyObject(PyObject* v) {
    if (PyTuple_Check(v)) {
      QVariantList list;
      for (int ix = 0; ix < PyTuple_Size(v); ix++) {
        list.push_back(fromPyObject(PyTuple_GetItem(v, ix)));
      }
      return QVariant(list);
    } else if (PyList_Check(v)) {
      QVariantList list;
      for (int ix = 0; ix < PyList_Size(v); ix++) {
        list.push_back(fromPyObject(PyList_GetItem(v, ix)));
      }
      return QVariant(list);
    } else if (PyDict_Check(v)) {
      QVariantMap map; PyObject* key; PyObject* value; Py_ssize_t pos=0;
      while (PyDict_Next(v, &pos, &key, &value)) {
        map[PyUnicode_AsUTF8(key)] = fromPyObject(value);
      }
      return QVariant(map);
    } else if (PyBytes_Check(v)) {
      return QVariant(QByteArray(PyBytes_AsString(v), PyBytes_Size(v)));
    } else if (PyUnicode_Check(v)) {
      return QVariant(QString(PyUnicode_AsUTF8(v)));
    } else if (PyFloat_Check(v)) {
      return QVariant(PyFloat_AsDouble(v));
    } else if (PyLong_Check(v)) {
      return QVariant(PyLong_AsUnsignedLongLong(v));
    } else if (PyBool_Check(v)) {
      return QVariant(v == Py_True);
    } else if (v == Py_None) {
      return QVariant();
    } else {
      QVariant ret;
      ret.setValue(PythonLoaderPyObject(v));
      return ret;
    }
  }
};

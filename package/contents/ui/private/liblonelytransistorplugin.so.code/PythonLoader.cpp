#include "PythonLoader.h"

PythonLoader::PythonLoader() {
  m_libPython = dlopen("libpython3.10.so", RTLD_NOW | RTLD_GLOBAL);
  Py_Initialize();
  PyRun_SimpleString("import sys");
}
PythonLoader::~PythonLoader() {
  Py_Finalize();
  dlclose(m_libPython);
}

PyObject* PythonLoader::toPyObject(QVariantList v) {
  PyObject* ret = PyList_New(0);
  for (QVariant i : v) {
    PyList_Append(ret, toPyObject(i));
  }

  stackPush(ret);
  return ret;
}
PyObject* PythonLoader::toPyObject(QVariantMap v) {
  PyObject* ret = PyDict_New();
  QVariantMap::const_iterator i = v.constBegin();
  while (i != v.constEnd()) {
    PyDict_SetItem(ret, toPyObject(i.key()), toPyObject(i.value()));
    ++i;
  }

  stackPush(ret);
  return ret;
}

void PythonLoader::stackSet() {
  if (m_allocatedObjects.size() > 0) {
    m_allocatedObjectsPointer = m_allocatedObjects.size();
  } else {
    m_allocatedObjectsPointer = 0;
  }
}
void PythonLoader::stackPush(PyObject* v) {
  m_allocatedObjects.push_back(v);
}
void PythonLoader::stackFree() {
  int left = m_allocatedObjects.size() - m_allocatedObjectsPointer;
  while (left-- > 0) {
    PyObject* it = m_allocatedObjects.last();
    Py_DECREF(it);
    m_allocatedObjects.removeLast();
  }
}

#define py_newobj(name, value) \
  PyObject* name = value; \
  if (name == NULL) {\
    if (PyErr_Occurred()) {\
      PyErr_PrintEx(0);\
      PyErr_Clear();\
    }\
    stackFree();\
    return false;\
  } else {\
    stackPush(name);\
  }
bool PythonLoader::importModule(QUrl url) {
  stackSet();

  QString path = url.adjusted(QUrl::RemoveFilename).path();
  QString mod = url.fileName();
  if (m_modules.keys().contains(mod)) {
    return true;
  }
  if (path.size() && !m_importPaths.contains(path)) {
    PyRun_SimpleString(("sys.path.append('"+path+"')").toStdString().c_str());
  }

  py_newobj(pModule, PyImport_ImportModule(mod.toStdString().c_str()));
  py_newobj(pDict, PyModule_GetDict(pModule));

  m_modules[mod] = pModule;
  m_moduleDicts[mod] = pDict;
  return true;
}

#undef py_newobj
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
QVariant PythonLoader::call(QString mod, QString fn, QVariantList params) {
  stackSet();

  py_newobj(pArgs, PyList_AsTuple(toPyObject(params)));
  PyObject* pFunc = PyDict_GetItemString(m_moduleDicts[mod], fn.toStdString().c_str()); // This function only borrows an object!
  if (PyCallable_Check(pFunc)) {
    py_newobj(pRet, PyObject_CallObject(pFunc, pArgs));
    QVariant ret = fromPyObject(pRet);

    stackFree();
    return ret;
  }

  stackFree();
  return QVariant();
}

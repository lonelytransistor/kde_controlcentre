#include "PythonLoader.h"

const void* m_libPython = dlopen("libpython3.so", RTLD_NOW | RTLD_GLOBAL);

PythonLoader::PythonLoader() {
  Py_Initialize();
  PyRun_SimpleString("import os, sys, __main__");
}
PythonLoader::~PythonLoader() {
  Py_Finalize();
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

QVariant PythonLoader::importModule(QString url) {
  return importModule(QUrl(url));
}
QVariant PythonLoader::importModule(QUrl url) {
  stackSet();

  QString path = url.adjusted(QUrl::RemoveFilename).path();
  QString mod = url.fileName();
  if (m_modules.keys().contains(mod)) {
    return true;
  }
  if (path.size() && !m_importPaths.contains(path)) {
    PyRun_SimpleString(("sys.path.append('"+path+"')").toStdString().c_str());
  }

  py_newobj(pyMod, PyImport_ImportModule(mod.toStdString().c_str()));
  py_newobj(pyDict, PyModule_GetDict(pyMod));

  m_modules[mod] = pyMod;
  m_moduleDicts[mod] = pyDict;
  return QVariant(fromPyObject(m_modules[mod]));
}

QVariant PythonLoader::call(QString mod, QString fn, QVariantList params) {
  QVariant ret;
  PyObject* pyDict = m_moduleDicts[mod];
  if (pyDict == NULL) {
    stackSet();
    PyObject* pyMod = PyImport_GetModule(toPyObject(mod.toStdString().c_str()));
    stackFree();

    py_newobj(pyDict2, PyModule_GetDict(pyMod));
    pyDict = pyDict2;
    m_modules[mod] = pyMod;
    m_moduleDicts[mod] = pyDict;
  }
  stackSet();

  const char* pyVar = fn.toStdString().c_str();
  if (pyDict == NULL) {
    return ret;
  }
  PyObject* pyFunc = PyDict_GetItemString(pyDict, pyVar); // This function only borrows an object!

  py_newobj(pyArgs, PyList_AsTuple(toPyObject(params)));
  if (PyCallable_Check(pyFunc)) {
    py_newobj(pyRet, PyObject_CallObject(pyFunc, pyArgs));
    ret = fromPyObject(pyRet);
  }

  stackFree();
  return ret;
}
bool PythonLoader::switchCwd(QUrl cwd) {
  QVariantList params;
  params.push_back(QVariant(cwd.path()));

  call("os", "chdir", params);
  params.clear();

  QString newCwd = QUrl(call("os", "getcwd", params).toString()).path(QUrl::FullyEncoded | QUrl::StripTrailingSlash | QUrl::PreferLocalFile | QUrl::NormalizePathSegments);
  QString reqCwd = QUrl(cwd.toString()).path(QUrl::FullyEncoded | QUrl::StripTrailingSlash | QUrl::PreferLocalFile | QUrl::NormalizePathSegments);
  return newCwd == reqCwd;
}

void PythonLoader::rawCall(QString script) {
  PyRun_SimpleString(script.toStdString().c_str());

  if (PyErr_Occurred()) {
    PyErr_PrintEx(0);
    PyErr_Clear();
  }
}
QVariant PythonLoader::get(QVariant obj, QString var) {
  stackSet();

  PyObject* pyObj = toPyObject(obj);
  const char* pyVar = var.toStdString().c_str();
  QVariant ret;
  if (pyObj != NULL) {
    ret = fromPyObject(PyObject_GetAttrString(pyObj, pyVar));

    if (PyErr_Occurred()) {
      PyErr_PrintEx(0);
      PyErr_Clear();
    }
  }

  stackFree();
  return ret;
}
QVariant PythonLoader::getModule(QString mod) {
  stackSet();

  QVariant ret = fromPyObject(m_modules[mod]);

  stackFree();
  return ret;
}
bool PythonLoader::set(QVariant obj, QString var, QVariant val) {
  stackSet();
  bool ret = false;

  PyObject* pyObj = toPyObject(obj);
  PyObject* pyVal = toPyObject(val);
  const char* pyVar = var.toStdString().c_str();
  if (pyObj != NULL && pyVal != NULL && PyObject_HasAttrString(pyObj, pyVar)) {
    ret = PyObject_SetAttrString(pyObj, pyVar, pyVal)==0;

    if (PyErr_Occurred()) {
      PyErr_PrintEx(0);
      PyErr_Clear();
    }
  }

  stackFree();
  return ret;
}

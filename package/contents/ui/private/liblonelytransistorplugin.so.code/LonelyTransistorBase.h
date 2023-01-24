#pragma once
#include <QUrl>
#include <QString>
#include <QQmlEngine>

class GlobalProperties;
class LonelyTransistorBase
{
public:
  LonelyTransistorBase();
  ~LonelyTransistorBase();

  static void init(QQmlEngine* engine, GlobalProperties* cppGlobal, QJSValue* jsGlobal) {
    m_engine = engine;
    m_cppGlobal = cppGlobal;
    m_jsGlobal = jsGlobal;
  }
  static void JSRegisterGlobalProperty(QString dst, QString src) {
    m_engine->globalObject().setProperty(dst, m_jsGlobal->property(src));
  }

  static void setCWD(QUrl path) {
    m_cwd = path;
    QString pathString = path.path(QUrl::RemoveFilename | QUrl::PreferLocalFile | QUrl::StripTrailingSlash | QUrl::NormalizePathSegments);
    if (!m_engine->importPathList().contains(pathString)) {
      m_engine->addImportPath(pathString);
    }
  }
  static void setCWD(QString path) {
    setCWD(QUrl(path));
  }
  static QQmlEngine* getQmlEngine() {
    return m_engine;
  }
  static QUrl getCWD() {
    return m_cwd;
  }
  static QString getCWDString() {
    return m_cwd.path(QUrl::PreferLocalFile | QUrl::StripTrailingSlash | QUrl::NormalizePathSegments);
  }
private:
  static QQmlEngine* m_engine;
  static GlobalProperties* m_cppGlobal;
  static QJSValue* m_jsGlobal;
  static QUrl m_cwd;
};

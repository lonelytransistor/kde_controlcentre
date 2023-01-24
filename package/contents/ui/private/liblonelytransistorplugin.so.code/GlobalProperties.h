#pragma once

#include <QString>
#include <QObject>
#include <QUrl>
#include <QQmlContext>

#include "LonelyTransistorBase.h"

class GlobalProperties : public QObject, public LonelyTransistorBase
{
    Q_OBJECT

    Q_PROPERTY(QObject* globalObject READ getGlobalObject NOTIFY globalObjectChanged)
    Q_PROPERTY(bool initialized READ getInitialized NOTIFY initializedChanged)

private:
    QString sanitizeUrl(const char* base, QString url) {
        QUrl uUrl = QUrl(LonelyTransistorBase::getCWD());
        uUrl = uUrl.resolved(QUrl(base));
        uUrl = uUrl.resolved(url);
        return uUrl.path(QUrl::PreferLocalFile | QUrl::StripTrailingSlash | QUrl::NormalizePathSegments);
    }
    QObject* getGlobalObject() {
        return m_globalObject;
    }
    bool getInitialized() {
        return m_initialized;
    }

public:
    GlobalProperties();
    ~GlobalProperties();

    Q_INVOKABLE void initMainQml(QString cwd, QObject* obj) {
        LonelyTransistorBase::setCWD(QUrl(cwd));
        m_globalObject = obj;
        m_initialized = true;
        JSRegisterGlobalProperty("Global", "globalObject");
        JSRegisterGlobalProperty("Initialized", "initialized");

        globalObjectChanged();
        initializedChanged();
    }
    Q_INVOKABLE QString mainPath() {
        return LonelyTransistorBase::getCWD().path(QUrl::PreferLocalFile | QUrl::StripTrailingSlash | QUrl::NormalizePathSegments);
    }
    Q_INVOKABLE QString assetPath(QString asset) {
        return sanitizeUrl("../assets/", asset);
    }
    Q_INVOKABLE QString pythonPath(QString name) {
        return sanitizeUrl("private/python/", name);
    }
    Q_INVOKABLE QString fontPath(QString name) {
        return sanitizeUrl("private/Fonts/", name);
    }
Q_SIGNALS:
    void globalObjectChanged();
    void initializedChanged();

private:
    QObject* m_globalObject = nullptr;
    bool m_initialized = false;
};

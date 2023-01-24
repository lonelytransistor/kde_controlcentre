#pragma once
#include <QJSValue>
#include <QQmlEngine>
#include <QQmlEngineExtensionPlugin>

#include "StatisticsProvider.h"
#include "SystemConfig.h"
#include "TouchArea.h"
#include "PythonLoader.h"
#include "Utilities.h"
#include "GlobalProperties.h"

#include "LonelyTransistorBase.h"

class QLonelyTransistorPlugin : public QQmlEngineExtensionPlugin {
  Q_OBJECT
  Q_PLUGIN_METADATA(IID QQmlEngineExtensionInterface_iid)

  QJSValue jsGlobalProperties;
  GlobalProperties cppGlobalProperties;
public:
  QLonelyTransistorPlugin() {
  }
  void initializeEngine(QQmlEngine *engine, const char *uri) {
    LonelyTransistorBase::init(engine, &cppGlobalProperties, &jsGlobalProperties);
    jsGlobalProperties = engine->newQObject(&cppGlobalProperties);

    engine->globalObject().setProperty("Font", jsGlobalProperties.property("fontsPath"));
    engine->globalObject().setProperty("Asset", jsGlobalProperties.property("assetPath"));
    engine->globalObject().setProperty("Script", jsGlobalProperties.property("pythonPath"));
    engine->globalObject().setProperty("CWD", jsGlobalProperties.property("mainPath"));
    engine->globalObject().setProperty("InitMainQml", jsGlobalProperties.property("initMainQml"));
    engine->globalObject().setProperty("Initialized", jsGlobalProperties.property("initialized"));

    qmlRegisterType<TouchArea>("TouchArea", 1, 0, "TouchArea");
    qmlRegisterType<SystemConfig>("SystemConfig", 1, 0, "SystemConfig");
    qmlRegisterType<StatisticsProvider>("StatisticsProvider", 1, 0, "StatisticsProvider");
    qmlRegisterType<PythonLoader>("PythonLoader", 1, 0, "PythonLoader");
    qmlRegisterType<Utilities>("Utilities", 1, 0, "Utilities");
  }
};

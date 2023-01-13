#pragma once
#include <QObject>
#include <QQmlEngine>
#include <QQmlEngineExtensionPlugin>
#include "StatisticsProvider.h"
#include "SystemConfig.h"
#include "TouchArea.h"
#include "PythonLoader.h"
#include "Utilities.h"

#include "LonelyTransistorBase.h"

class QLonelyTransistorPlugin : public QQmlEngineExtensionPlugin {
  Q_OBJECT
  Q_PLUGIN_METADATA(IID QQmlEngineExtensionInterface_iid)
public:
  QLonelyTransistorPlugin() {
  }
  void initializeEngine(QQmlEngine *engine, const char *uri) {
    LonelyTransistorBase::setCWD(engine->baseUrl());

    qmlRegisterType<TouchArea>("TouchArea", 1, 0, "TouchArea");
    qmlRegisterType<SystemConfig>("SystemConfig", 1, 0, "SystemConfig");
    qmlRegisterType<StatisticsProvider>("StatisticsProvider", 1, 0, "StatisticsProvider");
    qmlRegisterType<PythonLoader>("PythonLoader", 1, 0, "PythonLoader");
    qmlRegisterType<Utilities>("Utilities", 1, 0, "Utilities");
  }
};

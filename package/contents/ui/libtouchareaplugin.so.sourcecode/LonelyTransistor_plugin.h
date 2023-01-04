#pragma once
#include <QObject>
#include <QQmlEngineExtensionPlugin>
#include "StatisticsProvider.h"
#include "SystemConfig.h"
#include "TouchArea.h"

class QLonelyTransistorPlugin : public QQmlEngineExtensionPlugin {
  Q_OBJECT
  Q_PLUGIN_METADATA(IID QQmlEngineExtensionInterface_iid)
public:
  QLonelyTransistorPlugin() {
  }
  void initializeEngine(QQmlEngine *engine, const char *uri) {
    qmlRegisterType<TouchArea>("TouchArea", 1, 0, "TouchArea");
    qmlRegisterType<SystemConfig>("SystemConfig", 1, 0, "SystemConfig");
    qmlRegisterType<StatisticsProvider>("StatisticsProvider", 1, 0, "StatisticsProvider");
  }
};

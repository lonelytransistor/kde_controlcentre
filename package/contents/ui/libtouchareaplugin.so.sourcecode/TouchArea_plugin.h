#pragma once
#include <QObject>
#include <QQmlEngineExtensionPlugin>
#include "StatisticsProvider.h"
#include "SystemConfig.h"
#include "TouchArea.h"

class QTouchAreaPlugin : public QQmlEngineExtensionPlugin {
  Q_OBJECT
  Q_PLUGIN_METADATA(IID QQmlEngineExtensionInterface_iid)
public:
  QTouchAreaPlugin() {
  }
  void initializeEngine(QQmlEngine *engine, const char *uri) {
    qmlRegisterType<TouchArea>("TouchArea", 1, 0, "TouchArea");
    qmlRegisterType<SystemConfig>("SystemConfig", 1, 0, "SystemConfig");
    qmlRegisterType<StatisticsProvider>("StatisticsProvider", 1, 0, "StatisticsProvider");
  }
};

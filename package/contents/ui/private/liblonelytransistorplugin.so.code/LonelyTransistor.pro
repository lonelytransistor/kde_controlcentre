QT      += qml quick dbus Solid KConfigCore KConfigGui
CONFIG  += c++11 plugin
TARGET   = $$qtLibraryTarget(lonelytransistorplugin)
TEMPLATE = lib

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += TouchArea.cpp StatisticsProvider.cpp SystemConfig.cpp
HEADERS += TouchArea.h StatisticsProvider.h SystemConfig.h
HEADERS += QQuickEvent.h LonelyTransistor_plugin.h

#RESOURCES += qml.qrc

QT      += qml quick dbus Solid KConfigCore KConfigGui widgets
CONFIG  += c++11 plugin
TARGET   = $$qtLibraryTarget(lonelytransistorplugin)
TEMPLATE = lib

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += LonelyTransistorBase.cpp TouchArea.cpp StatisticsProvider.cpp SystemConfig.cpp PythonLoader.cpp Utilities.cpp
HEADERS += LonelyTransistorBase.h TouchArea.h StatisticsProvider.h SystemConfig.h PythonLoader.h Utilities.h
HEADERS += QQuickEvent.h LonelyTransistor_plugin.h

LIBS += -lpython3 -lcrypt -ldl -lm
INCLUDEPATH += /usr/include/python3.10/
DEPENDPATH += /usr/include/python3.10/

#RESOURCES += qml.qrc

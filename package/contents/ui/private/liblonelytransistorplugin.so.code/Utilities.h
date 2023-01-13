#pragma once

#include <QString>
#include <QFileInfo>
#include <QImageReader>
#include <QImage>
#include <QQuickWindow>
#include <QQuickItem>
#include <QQuickItemGrabResult>
#include <QColor>
#include <QByteArray>
#include <QDBusInterface>
#include <QDBusPendingCall>
#include <QDebug>
#include "LonelyTransistorBase.h"

class Utilities : public QObject, public LonelyTransistorBase
{
    Q_OBJECT

public:
    Utilities();
    ~Utilities();

public Q_SLOTS:
    QString getImageType(QString path) {
        if (QFileInfo::exists(path)) {
            return QImageReader::imageFormat(path);
        } else {
            return "";
        }
    }
    QColor getAverageColor(QObject* grabObj) {
        QQuickItemGrabResult* grab = static_cast<QQuickItemGrabResult*>(grabObj);
        QImage img = grab->image();
        if (!img.isNull()) {
            img = img.scaled(1, 1, Qt::IgnoreAspectRatio, Qt::SmoothTransformation);
            QColor color = img.pixelColor(0, 0);
            color.setAlpha(255);
            return color;
        } else {
            return QColor();
        }
    }
    QVariantList dbusCall(QString service, QString path, QString interface, QString method, QVariantList args, QString convert) {
        QDBusInterface dbusIface(service, path, interface);
        QVariantList arguments;
        for (int ix=0; ix<args.size(); ix++) {
            QVariant arg = args[ix];
            if (ix < convert.size()) {
                switch (convert.toStdString().c_str()[ix]) {
                    case 'u':
                        arg.convert(QMetaType::UInt);
                    break;
                    default:
                    break;
                }
            }
            arguments.push_back(arg);
        }
        QDBusMessage msg = dbusIface.callWithArgumentList(QDBus::BlockWithGui, method, arguments);
        return msg.arguments();
        //QDBusPendingCall call = dbusIface.asyncCallWithArgumentList(method, args);
    }
    QVariant dbusGet(QString service, QString path, QString interface, QString name) {
        QDBusInterface dbusIface(service, path, interface);
        return dbusIface.property(name.toStdString().c_str());
    }
};

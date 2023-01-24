#pragma once

#include <QString>
#include <QByteArray>
#include <QFileInfo>
#include <QImageReader>
#include <QImage>
#include <QQuickWindow>
#include <QQuickItem>
#include <QQuickItemGrabResult>
#include <QColor>
#include <QByteArray>
#include <QBitArray>
#include <QDBusArgument>
#include <QDBusInterface>
#include <QDBusPendingCall>
#include <QDir>
#include <QDebug>
#include "LonelyTransistorBase.h"

#define QT_NO_CAST_FROM_BYTEARRAY 1
void errorSwallower(QtMsgType type, const QMessageLogContext &context, const QString &msg);

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
    QVariantList dbusCall(QString service, QString path, QString interface, QString method, QVariantList args, QList<int> convertInput, QList<int> convertOutput, bool isSystemBus) {
        QVariantList arguments;
        QDBusInterface dbusIface(service, path, interface, isSystemBus ? QDBusConnection::systemBus() : QDBusConnection::sessionBus());

        for (int ix=0; ix<args.size(); ix++) {
            QVariant arg = args[ix];
            if (convertInput[ix] != 0) {
                if (convertInput[ix] == QVariant::ByteArray && arg.type() == QVariant::List) {
                    QByteArray array;
                    for (QVariant c : arg.toList()) {
                        array.append(c.value<char>());
                    }
                    arg = QVariant(array);
                } else if (convertInput[ix] == QVariant::BitArray && arg.type() == QVariant::List) {
                    QVariantList input = arg.toList();
                    QBitArray array(input.size(), false);
                    for (int ix=0; ix<input.size(); ix++) {
                        if (input.at(ix).toBool()) {
                            array.setBit(ix);
                        }
                    }
                    arg = QVariant(array);
                } else {
                    arg.convert(convertInput[ix]);
                }
            }
            arguments.push_back(arg);
        }

        QDBusMessage msg = dbusIface.callWithArgumentList(QDBus::BlockWithGui, method, arguments);

        arguments.clear();
        QVariantList argsOut = msg.arguments();
        for (int ix=0; ix<argsOut.size(); ix++) {
            QVariant arg = argsOut[ix];
            if (convertOutput[ix] != 0) {
                if (convertOutput[ix] == QVariant::List && arg.type() == QVariant::ByteArray) {
                    QVariantList array;
                    QByteArray input = arg.toByteArray();
                    for (char c : input) {
                        array.push_back(c);
                    }
                    arg = QVariant(array);
                } else if (convertOutput[ix] == QVariant::List && arg.type() == QVariant::BitArray) {
                    QVariantList array;
                    QBitArray input = arg.toBitArray();
                    for (int ix=0; ix<input.size(); ix++) {
                        array.push_back(input.at(ix));
                    }
                    arg = QVariant(array);
                } else {
                    arg.convert(convertOutput[ix]);
                }
            }
            arguments.push_back(arg);
        }
        return arguments;
    }
    QVariant dbusGet(QString service, QString path, QString interface, QString name, bool isSystemBus) {
        QDBusInterface dbusIface(service, path, interface, isSystemBus ? QDBusConnection::systemBus() : QDBusConnection::sessionBus());
        return dbusIface.property(name.toStdString().c_str());
    }
    bool dbusSet(QString service, QString path, QString interface, QString name, QVariant val, int convert, bool isSystemBus) {
        QVariant value = val;
        if (convert) {
            value.convert(convert);
        }
        QDBusInterface dbusIface(service, path, interface, isSystemBus ? QDBusConnection::systemBus() : QDBusConnection::sessionBus());
        return dbusIface.setProperty(name.toStdString().c_str(), value);
    }
    bool swallowErrors(bool state) {
        QtMessageHandler handler = qInstallMessageHandler(state ? errorSwallower : 0);
        return handler == errorSwallower;
    }
    QString sanitizeUrl(QString url) {
        QUrl uUrl = QDir(".").absolutePath();
        return uUrl.resolved(url).path(QUrl::PreferLocalFile | QUrl::StripTrailingSlash | QUrl::NormalizePathSegments);
    }
};

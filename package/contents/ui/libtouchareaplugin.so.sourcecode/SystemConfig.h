#pragma once

#include <QMap>
#include <QVariantMap>
#include <QString>
#include <QObject>
#include <KConfigGroup>
#include <KSharedConfig>
#include <QStringList>
#include <QDBusMessage>
#include <QDBusReply>
#include <QDBusConnection>
#include <QDBusConnectionInterface>

// powermanagementprofilesrc

class SystemConfig : public QObject
{
    Q_OBJECT

private:
    QVariantMap readConfigGroup(KConfigGroup group);
    QVariantMap readConfigGroup(KSharedConfig::Ptr config);
    enum EntryAction: int {
        EntryRead = 0,
        EntryWrite,
        EntryDelete
    };
    QVariant modifyEntry(QString configName, QStringList groupName, QString varName, QVariant value, EntryAction action);

public Q_SLOTS:
    QVariantMap readConfig(QString configName);
    QVariant writeEntry(QString configName, QStringList groupName, QString varName, QVariant value);
    QVariant writeEntry(QString configName, QString groupName, QString varName, QVariant value);
    QVariant deleteEntry(QString configName, QStringList groupName, QString varName);
    QVariant deleteEntry(QString configName, QString groupName, QString varName);
    QVariant readEntry(QString configName, QStringList groupName, QString varName);
    QVariant readEntry(QString configName, QString groupName, QString varName);

    void refreshPM();
};

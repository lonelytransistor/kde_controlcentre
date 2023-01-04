#include "SystemConfig.h"

// powermanagementprofilesrc
QVariantMap SystemConfig::readConfigGroup(KConfigGroup group) {
    auto groups = group.groupList();
    auto keys = group.keyList();
    QVariantMap varMap;

    for (int ix = 0; ix < keys.size(); ix++) {
        auto key = keys.at(ix);
        varMap.insert(key, group.readEntry(key, ""));
    }
    for (int ix = 0; ix < groups.size(); ix++) {
        auto key = groups.at(ix);
        varMap.insert(key, readConfigGroup(group.group(key)));
    }

    return varMap;
}
QVariantMap SystemConfig::readConfigGroup(KSharedConfig::Ptr config) {
    auto data = config.data();
    auto groups = data->groupList();
    QVariantMap groupMap;

    for (int ix = 0; ix < groups.size(); ix++) {
        auto key = groups.at(ix);
        groupMap.insert(key, readConfigGroup(data->group(key)));
    }

    return groupMap;
}
QVariant SystemConfig::modifyEntry(QString configName, QStringList groupName, QString varName, QVariant value, SystemConfig::EntryAction action) {
    KSharedConfig::Ptr sharedConfig;
    sharedConfig = KSharedConfig::openConfig(
        configName,
        KConfig::SimpleConfig | KConfig::CascadeConfig
    );
    KConfigGroup group = sharedConfig.data()->group(groupName.at(0));
    for (int ix = 1; ix < groupName.size(); ix++) {
        auto key = groupName.at(ix);
        group = group.group(key);
    }

    switch (action) {
        case EntryRead:
        break;
        case EntryWrite:
            group.writeEntry(varName, value);
        break;
        case EntryDelete:
            group.deleteEntry(varName);
        break;
        default:
        break;
    }
    group.sync();

    return group.readEntry(varName, "");
}

QVariantMap SystemConfig::readConfig(QString configName) {
    KSharedConfig::Ptr sharedConfig;
    sharedConfig = KSharedConfig::openConfig(
        configName,
        KConfig::SimpleConfig | KConfig::CascadeConfig
    );
    return readConfigGroup(sharedConfig);
}
QVariant SystemConfig::writeEntry(QString configName, QStringList groupName, QString varName, QVariant value) {
    return modifyEntry(configName, groupName, varName, value, EntryWrite);
}
QVariant SystemConfig::writeEntry(QString configName, QString groupName, QString varName, QVariant value) {
    return modifyEntry(configName, QStringList(groupName), varName, value, EntryWrite);
}
QVariant SystemConfig::readEntry(QString configName, QStringList groupName, QString varName) {
    return modifyEntry(configName, groupName, varName, "", EntryRead);
}
QVariant SystemConfig::readEntry(QString configName, QString groupName, QString varName) {
    return modifyEntry(configName, QStringList(groupName), varName, "", EntryRead);
}
QVariant SystemConfig::deleteEntry(QString configName, QStringList groupName, QString varName) {
    return modifyEntry(configName, groupName, varName, "", EntryDelete);
}
QVariant SystemConfig::deleteEntry(QString configName, QString groupName, QString varName) {
    return modifyEntry(configName, QStringList(groupName), varName, "", EntryDelete);
}

void SystemConfig::refreshPM() {
    QDBusMessage call = QDBusMessage::createMethodCall("org.kde.Solid.PowerManagement", "/org/kde/Solid/PowerManagement",
                                                       "org.kde.Solid.PowerManagement", "refreshStatus");
    QDBusConnection::sessionBus().asyncCall(call);
}

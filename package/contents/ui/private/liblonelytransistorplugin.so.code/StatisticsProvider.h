#pragma once

#include <QObject>
#include <QVariant>
#include <QVariantList>
#include <QPointF>
#include <QQmlParserStatus>
#include "LonelyTransistorBase.h"

struct HistoryReply {
public:
    uint time = 0;
    double value = 0.0;
    uint charging = 0;
};

Q_DECLARE_METATYPE(HistoryReply)

class StatisticsProvider : public QObject, public QQmlParserStatus, public LonelyTransistorBase
{
    Q_OBJECT
    Q_INTERFACES(QQmlParserStatus)

    Q_PROPERTY(QString device MEMBER m_device WRITE setDevice NOTIFY deviceChanged)
    Q_PROPERTY(uint duration MEMBER m_duration WRITE setDuration NOTIFY durationChanged)
    Q_PROPERTY(HistoryType type MEMBER m_type WRITE setType NOTIFY typeChanged)

    Q_PROPERTY(QVariantList points READ asPoints NOTIFY dataChanged)
    Q_PROPERTY(int count READ count NOTIFY dataChanged)
    Q_PROPERTY(int firstDataPointTime READ firstDataPointTime NOTIFY dataChanged)
    Q_PROPERTY(int lastDataPointTime READ lastDataPointTime NOTIFY dataChanged)
    Q_PROPERTY(int largestValue READ largestValue NOTIFY dataChanged)

public:
    enum HistoryType {
        RateType,
        ChargeType,
    };
    Q_ENUM(HistoryType)

    enum HistoryRoles {
        TimeRole = Qt::UserRole + 1,
        ValueRole,
        ChargingRole,
    };

    explicit StatisticsProvider(QObject *parent = nullptr);

    void setDevice(const QString &device);
    void setDuration(uint duration);
    void setType(HistoryType type);

    void load();

    void classBegin() override;
    void componentComplete() override;

    QVariantList asPoints() const;
    int count() const;

    int firstDataPointTime() const;
    int lastDataPointTime() const;
    int largestValue() const;

Q_SIGNALS:
    void deviceChanged();
    void typeChanged();
    void durationChanged();

    void dataChanged();

public Q_SLOTS:
    void refresh();
    QStringList getUdi();

private:
    QString m_device;
    HistoryType m_type;
    uint m_duration; // in seconds

    QList<HistoryReply> m_values;
    bool m_isComplete = false;
};

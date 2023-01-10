#pragma once
#include <QObject>
#include <QQuickItem>
#include <QMouseEvent>
#include <QTouchEvent>

class QQuickEvent: public QObject {
    Q_OBJECT

    Q_PROPERTY(qreal x READ x CONSTANT)
    Q_PROPERTY(qreal y READ y CONSTANT)
    Q_PROPERTY(qreal startX READ startX CONSTANT)
    Q_PROPERTY(qreal startY READ startY CONSTANT)
    Q_PROPERTY(qreal endX READ endX CONSTANT)
    Q_PROPERTY(qreal endY READ endY CONSTANT)
    Q_PROPERTY(int button READ button CONSTANT)
    Q_PROPERTY(int id READ id CONSTANT)
    Q_PROPERTY(int state READ state CONSTANT)

    Q_PROPERTY(bool accepted READ getAccepted WRITE setAccepted)
    Q_PROPERTY(bool reemulate READ getReemulation WRITE setReemulation)
    Q_PROPERTY(QQuickItem* reemulateObj READ getReemulationObj WRITE setReemulationObj)

public:
    QQuickEvent(QMouseEvent* event) {
        auto point = event->pos();
        _id = event->source();
        _x = point.x();
        _y = point.y();
        _button = event->button();
    }
    QQuickEvent(QTouchEvent::TouchPoint* touch) {
        _id = touch->id();
        auto point = touch->pos();
        _x = point.x();
        _y = point.y();
        point = touch->startPos();
        _startX = point.x();
        _startY = point.y();
        point = touch->lastPos();
        _endX = point.x();
        _endY = point.y();
        _state = (int)touch->state();
    }
    qreal x() const { return _x; }
    qreal y() const { return _y; }
    qreal startX() const { return _startX; }
    qreal startY() const { return _startY; }
    qreal endX() const { return _endX; }
    qreal endY() const { return _endY; }
    int button() const { return _button; }
    int id() const { return _id; }
    int state() const { return _state; }

    bool getAccepted() { return _accepted; }
    bool getReemulation() { return _reemulate; }
    QQuickItem* getReemulationObj() { return _reemulateObj; }
    void setAccepted(bool accepted) { _accepted = accepted; }
    void setReemulation(bool reemulate) { _reemulate = reemulate; }
    void setReemulationObj(QQuickItem* reemulateObj) { _reemulateObj = reemulateObj; }
private:
    qreal _x = 0;
    qreal _y = 0;
    qreal _startX = 0;
    qreal _startY = 0;
    qreal _endX = 0;
    qreal _endY = 0;
    int _button = 0;
    int _id = 0;
    int _state = 0;

    bool _accepted = false;
    bool _reemulate = false;
    QQuickItem* _reemulateObj;
};

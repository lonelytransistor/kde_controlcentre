#pragma once
#include <QtQuick>
#include <QMouseEvent>
#include <QTouchEvent>
#include <algorithm>
#include <list>
#include "QQuickEvent.h"

class TouchArea : public QQuickItem
{
  Q_OBJECT
  QML_ELEMENT

public:
  TouchArea();

signals:
  void mousePress(QQuickEvent* ev);
  void mouseMove(QQuickEvent* ev);
  void mouseRelease(QQuickEvent* ev);

  void touchPress(QQuickEvent* ev);
  void touchMove(QQuickEvent* ev);
  void touchRelease(QQuickEvent* ev);

protected:
  void mousePressEvent(QMouseEvent* event) final override;
  void mouseMoveEvent(QMouseEvent* event) final override;
  void mouseReleaseEvent(QMouseEvent* event) final override;
  void touchEvent(QTouchEvent* event) final override;

private:
  bool registerTouch(QTouchEvent::TouchPoint* event);
  bool deregisterTouch(QTouchEvent::TouchPoint* event);
  bool isAcceptedTouch(ulong timestamp);
  std::list<int> touchPoints = {};
  std::list<ulong> touchAccepted = {};
};

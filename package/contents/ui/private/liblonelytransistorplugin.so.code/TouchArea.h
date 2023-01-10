#pragma once

#include <QEvent>
#include <QMouseEvent>
#include <QTouchEvent>
#include <QTouchDevice>
#include <QQuickItem>
#include <QQuickWindow>
#include <QApplication>
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
  bool event(QEvent* event) final override;

private:
  bool m_inhibit = false;
};

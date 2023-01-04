#include "TouchArea_plugin.h"
#include "TouchArea.h"
#include "QQuickEvent.h"

TouchArea::TouchArea() {
  setAcceptedMouseButtons(Qt::LeftButton | Qt::MiddleButton | Qt::RightButton);
  setAcceptTouchEvents(true);
}

bool TouchArea::isAcceptedTouch(ulong timestamp) {
  bool ret = false;

  touchAccepted.sort();
  while (!touchAccepted.empty()) {
    auto t = touchAccepted.front();
    if (t == timestamp)
      ret = true;
    if (t <= timestamp)
      touchAccepted.pop_front();
  }
  return ret;
}
void TouchArea::mousePressEvent(QMouseEvent* event) {
  if (isAcceptedTouch(event->timestamp())){
    event->accept();
  } else {
    QQuickEvent ev(event);

    emit mousePress(&ev);

    if (ev.getAccepted()) {
      event->accept();
    } else {
      event->ignore();
    }
  }
}
void TouchArea::mouseMoveEvent(QMouseEvent* event) {
  if (isAcceptedTouch(event->timestamp())){
    event->accept();
  } else {
    QQuickEvent ev(event);

    emit mouseMove(&ev);

    if (ev.getAccepted()) {
      event->accept();
    } else {
      event->ignore();
    }
  }
}
void TouchArea::mouseReleaseEvent(QMouseEvent* event) {
  if (isAcceptedTouch(event->timestamp())){
    event->accept();
  } else {
    QQuickEvent ev(event);

    emit mouseRelease(&ev);

    if (ev.getAccepted()) {
      event->accept();
    } else {
      event->ignore();
    }
  }
}

bool TouchArea::registerTouch(QTouchEvent::TouchPoint* event) {
  auto id = event->id();
  if (std::find(touchPoints.begin(), touchPoints.end(), id) != touchPoints.end()) {
    return false;
  } else {
    touchPoints.push_back(id);
    return true;
  }
}
bool TouchArea::deregisterTouch(QTouchEvent::TouchPoint* event) {
  auto id = event->id();
  if (std::find(touchPoints.begin(), touchPoints.end(), id) != touchPoints.end()) {
    touchPoints.remove(id);
    return true;
  } else {
    return false;
  }
}
void TouchArea::touchEvent(QTouchEvent* event) {
  QList<QTouchEvent::TouchPoint> touchPoints;
  bool accept = true;

  for (QTouchEvent::TouchPoint p : event->touchPoints()) {
    QQuickEvent ev(&p);

    switch (event->type()) {
      case QEvent::TouchBegin:
      case QEvent::TouchUpdate:
      case QEvent::TouchEnd:
        switch (ev.state()) {
          case Qt::TouchPointPressed:
            if (registerTouch(&p)) {
              emit touchPress(&ev);
            } else {
              emit touchMove(&ev);
            }
            break;
          case Qt::TouchPointMoved:
            if (registerTouch(&p)) {
              emit touchPress(&ev);
            }
            emit touchMove(&ev);
            break;
          case Qt::TouchPointReleased:
            if (deregisterTouch(&p)) {
              emit touchRelease(&ev);
            }
            break;
          default:
            //emit touchStationary(&ev);
            break;
        }
        break;
      default:
        qWarning("touchEvent: unhandled event type %d", event->type());
        break;
    }
    if (!ev.getAccepted()) {
      accept = false;
    }
  }
  if (accept) {
    touchAccepted.push_back(event->timestamp());
    event->accept();
  } else {
    event->ignore();
  }
}

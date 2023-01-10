#include "TouchArea.h"
#include "QQuickEvent.h"

TouchArea::TouchArea() {
  setAcceptedMouseButtons(Qt::LeftButton | Qt::MiddleButton | Qt::RightButton);
  setAcceptTouchEvents(true);
}

bool TouchArea::event(QEvent* event) {
  bool reemulateTouch = false;
  bool accept = true;
  if (m_inhibit) {
    event->ignore();
    return false;
  }

  switch (event->type()) {
    case QEvent::TouchBegin:
    case QEvent::TouchUpdate:
    case QEvent::TouchEnd:
      for (QTouchEvent::TouchPoint p : static_cast<QTouchEvent*>(event)->touchPoints()) {
        QQuickEvent ev(&p);
        switch (ev.state()) {
          case Qt::TouchPointPressed:
            emit touchPress(&ev);
          break;
          case Qt::TouchPointMoved:
            emit touchMove(&ev);
            reemulateTouch = ev.getReemulation();
          break;
          case Qt::TouchPointReleased:
            emit touchRelease(&ev);
          break;
          default:
            //emit touchStationary(&ev);
          break;
        }
        accept = (ev.getAccepted() && accept);
      }
    break;
    case QEvent::MouseButtonPress: {
      QQuickEvent ev(static_cast<QMouseEvent*>(event));
      emit mousePress(&ev);
      accept = ev.getAccepted();}
    break;
    case QEvent::MouseMove: {
      QQuickEvent ev(static_cast<QMouseEvent*>(event));
      emit mouseMove(&ev);
      accept = ev.getAccepted();}
    break;
    case QEvent::MouseButtonRelease: {
      QQuickEvent ev(static_cast<QMouseEvent*>(event));
      emit mouseRelease(&ev);
      accept = ev.getAccepted();}
    break;
    default:
      return QObject::event(event);
    break;
  }

  if (reemulateTouch) {
    m_inhibit = true;
    auto ev = static_cast<QTouchEvent*>(event);
    auto p = ev->touchPoints();

    for (int ix=0; ix<p.size(); ix++) {
      (&p[ix])->setPos(QPoint(p[ix].scenePos().x(), p[ix].scenePos().y()));
      (&p[ix])->setState(Qt::TouchPointReleased);
    }
    QTouchEvent touchEvent(QEvent::TouchEnd, ev->device(), Qt::NoModifier, Qt::TouchPointReleased, p);
    QApplication::sendEvent(window(), &touchEvent);

    for (int ix=0; ix<p.size(); ix++) {
      (&p[ix])->setPos(QPoint(p[ix].startScenePos().x(), p[ix].startScenePos().y()));
      (&p[ix])->setState(Qt::TouchPointPressed);
    }
    touchEvent = QTouchEvent(QEvent::TouchBegin, ev->device(), Qt::NoModifier, Qt::TouchPointPressed, p);
    QApplication::sendEvent(window(), &touchEvent);
    ev->accept();

    m_inhibit = false;
  } else if (accept) {
    event->accept();
  } else {
    event->ignore();
  }
  return true;
}

#pragma once
#include <QUrl>

class LonelyTransistorBase
{
public:
  LonelyTransistorBase();
  ~LonelyTransistorBase();
  static void setCWD(QUrl path) {
    m_cwd = path;
  }
protected:
  static QUrl m_cwd;
};

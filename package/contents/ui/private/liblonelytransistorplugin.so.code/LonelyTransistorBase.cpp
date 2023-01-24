#include "LonelyTransistorBase.h"

LonelyTransistorBase::LonelyTransistorBase() {
}
LonelyTransistorBase::~LonelyTransistorBase() {
}
QQmlEngine* LonelyTransistorBase::m_engine = nullptr;
GlobalProperties* LonelyTransistorBase::m_cppGlobal = nullptr;
QJSValue* LonelyTransistorBase::m_jsGlobal = nullptr;
QUrl LonelyTransistorBase::m_cwd(".");

#include "Utilities.h"

Utilities::Utilities() {
}
Utilities::~Utilities() {
}

void errorSwallower(QtMsgType type, const QMessageLogContext &context, const QString &msg) {
    QByteArray localMsg = msg.toLocal8Bit();
    const char* file = context.file ? context.file : "";
    const char* function = context.function ? context.function : "";
    const char* body = localMsg.constData();
    int line = context.line;
    switch (type) {
        case QtDebugMsg:
        break;
        case QtInfoMsg:
        break;
        case QtWarningMsg:
        break;
        case QtCriticalMsg:
        break;
        case QtFatalMsg:
        break;
    }
}

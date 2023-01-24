import os
from .gmailAPI import Main

main = Main(os.path.join(__path__[0], "gmail.cache"))
def ping():
    main.getEMails()
    return main.getStatus()
def status():
    return main.getStatus()
def newMails():
    return main.getEMails()
def setCredentials(login, password):
    main.setCredentials(login, password)
    return ping()
def read(uid, t):
    if (t):
        return main.markRead(uid)
    else:
        return main.markUnread(uid)
def archive(uid, t):
    if (t):
        return main.moveFolder(uid, main.LABEL_ARCHIVE)
    else:
        return main.moveFolder(uid, main.LABEL_INBOX)

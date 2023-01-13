from proton.api import Session
from proton.exceptions import ProtonError
from PIL import Image, ImageDraw, ImageFont
from io import BytesIO
import base64, pickle, os

class Main:
    DUMMY = 0b1000
    NEEDS_REAUTH = 0b0010

    LABEL_SPAM = "4"
    LABEL_INBOX = "0"
    LABEL_TRASH = "3"
    LABEL_ARCHIVE = "6"
    LABEL_STARRED = "10"

    def __init__(self):
        self.cacheFile = "./protonmail.cache"
        self.cachePath = "/tmp/cache"
        self.logPath = "/tmp/log"
        self.cache = {}
        self.status = 0
        self.session = None
        self.cPassword = ""
        self.cLogin = ""
        self._readCache()
        self._reconnect()

    def _readCache(self):
        self.cache = {"icons": {}}
        if (os.path.exists(self.cacheFile)):
            with open(self.cacheFile, "rb") as f:
                self.cache = pickle.load(f)
    def _saveCache(self):
        with open(self.cacheFile, "wb") as f:
            pickle.dump(self.cache, f, protocol=pickle.HIGHEST_PROTOCOL)

    def _generateUserImage(self, addr):
        letter = addr[0].upper()
        image = Image.new('RGBA', (32, 32))
        draw = ImageDraw.Draw(image)
        font = ImageFont.truetype("Arial", size=24)
        bb = font.getbbox(letter)
        x = (31 - bb[2] + bb[0])/2 - bb[0]
        y = (31 - bb[3] + bb[1])/2 - bb[1]
        draw.ellipse((0,0,31,31), fill="#303030FF", outline="#505050FF")
        draw.text((int(x), int(y)), letter, font=font)
        buffered = BytesIO()
        image.save(buffered, format="PNG")
        return "data:image/png;base64," + base64.b64encode(buffered.getvalue()).decode("utf-8")

    def _reconnect(self):
        if "session" in self.cache.keys():
            try:
                self.session = Session.load(self.cache["session"], log_dir_path=self.logPath, cache_dir_path=self.cachePath, tls_pinning=False)
                self.session.enable_alternative_routing = False
                self.status &= ~self.NEEDS_REAUTH
                return True
            except ProtonError as e:
                print("Reconnect failed:", e.code)
        self.status |= self.NEEDS_REAUTH
        return False

    def _handleError(self, e):
        if (e.code == 401):
            return self.login()
        elif (e.code == 403):
            return self.login()
        elif (e.code == 429):
            return False
        elif (e.code == 503):
            print("Server unreachable")
            return False
        elif (e.code == 10013):
            self.logout()
            return self.login()
        return False

    def api_request(self, endpoint, method=None, jsondata=None, **params):
        if self.session == None:
            if self.login():
                return True
            else:
                return False
        while True:
            try:
                if (params == {}):
                    params = None
                print(endpoint, params, jsondata)
                return self.session.api_request(endpoint, method=method, jsondata=jsondata, params=params)
            except ProtonError as e:
                print("EX!", e)
                if not self._handleError(e):
                    return None

    def login(self):
        try:
            self.session = Session(api_url="https://api.protonmail.ch", log_dir_path=self.logPath, cache_dir_path=self.cachePath, tls_pinning=False)
            self.session.enable_alternative_routing = False
            self.session.authenticate(username=self.cLogin, password=self.cPassword)
            self.cache.update({"session": self.session.dump()})
            self.status &= ~self.NEEDS_REAUTH
            return True
        except ProtonError as e:
            print("Login failed:", e.code)
        except Exception as e:
            print("Unknown error during logon:", e)
        self.status |= self.NEEDS_REAUTH
        return False
    def logout(self):
        self.session.logout()
    def setCredentials(self, _cLogin, _cPassword):
        self.cLogin = _cLogin
        self.cPassword = _cPassword

    def getStatus(self):
        return self.status

    def getEMails(self):
        ret = []
        req = self.api_request("/mail/v4/conversations")
        if (req and "Conversations" in req.keys()):
            req = req["Conversations"]
        else:
            return
        for conv in req:
            info = {}
            if (conv["NumUnread"] > 0):
                info["ID"] = conv["ID"]
                info["subject"] = conv["Subject"]
                info["isSpam"] = self.LABEL_SPAM in conv["LabelIDs"]
                info["isInbox"] = self.LABEL_INBOX in conv["LabelIDs"]
                info["isTrashed"] = self.LABEL_TRASH in conv["LabelIDs"]
                info["isStarred"] = self.LABEL_STARRED in conv["LabelIDs"]
                info["isArchived"] = self.LABEL_ARCHIVE in conv["LabelIDs"]
                info["senders"] = [x["Name"] if len(x["Name"]) else x["Address"] for x in conv["Senders"]]
                info["sendersStr"] = ', '.join(info["senders"])
                addr = conv["Senders"][0]["Address"]

                if not info["isSpam"]:
                    if addr in self.cache["icons"].keys():
                        info["icon"] = self.cache["icons"][addr]
                    else:
                        icon = self.api_request("/core/v4/images/logo", Address=addr, Size=32, Mode="dark")
                        if icon:
                            info["icon"] = "data:" + icon.headers["content-type"] + ";base64," + base64.b64encode(icon.content).decode("utf-8")
                        else:
                            info["icon"] = self._generateUserImage(addr)
                        self.cache["icons"].update({addr: info["icon"]})
                    ret.append(info)
        self._saveCache()
        return ret
    def moveFolder(self, uid, folder):
        return self.api_request("/mail/v4/conversations/label", LabelID=folder, IDs=[uid])
    def setStarred(self, conv):
        return self.api_request("/mail/v4/conversations/label", LabelID=LABEL_STARRED, IDs=[uid])
    def unsetStarred(self, conv):
        return self.api_request("/mail/v4/conversations/unlabel", LabelID=LABEL_STARRED, IDs=[uid])
    def unsetLabel(self, uid, label):
        return self.api_request("/mail/v4/conversations/unlabel", LabelID=label, IDs=[uid])
    def markRead(self, uid):
        print("Marking as read", uid)
        return self.api_request("/mail/v4/conversations/read", "put", IDs=[uid])
    def markUnread(self, uid):
        return self.api_request("/mail/v4/conversations/unread", IDs=[uid], LabelID="0")

main = Main()
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

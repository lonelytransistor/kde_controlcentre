from PIL import Image, ImageDraw, ImageFont
from io import BytesIO
from http.client import HTTPSConnection
import xml.etree.ElementTree as ET
import base64, pickle, os, re, tld

class Main:
    DUMMY = 0b1000
    NEEDS_REAUTH = 0b0010

    LABEL_SPAM = "4"
    LABEL_INBOX = "0"
    LABEL_TRASH = "3"
    LABEL_ARCHIVE = "6"
    LABEL_STARRED = "10"
    FOLDER_SPAM = LABEL_SPAM
    FOLDER_INBOX = LABEL_INBOX
    FOLDER_TRASH = LABEL_TRASH
    FOLDER_ARCHIVE = LABEL_ARCHIVE

    def __init__(self, cFile = "gmail.cache"):
        self.cacheFile = cFile
        self.cache = {}
        self.status = 0
        self.cPassword = ""
        self.cLogin = ""
        self.cToken = ""
        self._readCache()
        iconSize = (32, 32)

        img = Image.new('RGBA', (iconSize[0]*4, iconSize[1]*4))
        draw = ImageDraw.Draw(img)
        draw.ellipse((0, 0, img.size[0]-1, img.size[1]-1), fill="#FFFFFFFF")
        self.iconMask = img.resize(iconSize)

        img = Image.new('RGBA', (iconSize[0]*4, iconSize[1]*4))
        draw = ImageDraw.Draw(img)
        draw.ellipse((0, 0, img.size[0]-1, img.size[1]-1), fill="#303030FF")
        draw.ellipse((4, 4, img.size[0]-5, img.size[1]-5), fill="#505050FF")
        self.iconCircle = img.resize(iconSize)

    def _readCache(self):
        self.cache = {"icons": {}}
        if (os.path.exists(self.cacheFile)):
            with open(self.cacheFile, "rb") as f:
                self.cache = pickle.load(f)
    def _saveCache(self):
        with open(self.cacheFile, "wb") as f:
            pickle.dump(self.cache, f, protocol=pickle.HIGHEST_PROTOCOL)
    def _getIcon(self, addr, letter="0"):
        if addr in self.cache["icons"].keys():
            return self.cache["icons"][addr]
        _, domain = addr.split("@")
        icon = Image.new('RGBA', (32, 32))
        draw = ImageDraw.Draw(icon)

        domains = list(filter(None, tld.parse_tld("https://" + domain)))
        domains.reverse()
        resp = None
        for ix in range(-len(domains), -1):
            dom = ".".join(domains[ix:])
            try:
                c = HTTPSConnection(dom, timeout=10)
                c.request('GET', '/favicon.ico')
                resp = c.getresponse()
                break
            except Exception as e:
                print("GeneralException:", e, "(" + str(dom) + ")")
                resp = None

        if (resp and (resp.status==200) and ("image/" in [x for x in resp.getheaders() if x[0].lower()=="content-type"][0][1].lower())):
            src = Image.open(BytesIO(resp.read())).convert("RGB")
            src = src.resize((32,32), Image.LANCZOS)
            icon.paste(src, (0, 0), self.iconMask)
        else:
            letter = letter[0].upper()
            font = ImageFont.truetype("Arial", size=24)
            bb = font.getbbox(letter)
            x = (31 - bb[2] + bb[0])/2 - bb[0]
            y = (31 - bb[3] + bb[1])/2 - bb[1]
            icon.paste(self.iconCircle)
            draw.text((int(x), int(y)), letter, font=font)

        iconData = BytesIO()
        icon.save(iconData, format="PNG")
        iconData = "data:image/png;base64," + base64.b64encode(iconData.getvalue()).decode("utf-8")
        self.cache["icons"].update({addr: iconData})
        return iconData

    def _handleError(self, e):
        if (e == 401):
            self.status |= self.NEEDS_REAUTH
            return True
        return False

    def api_request(self, request):
        try:
            c = HTTPSConnection("mail.google.com", timeout=10)
            if (request == "getEMails"):
                c.request('GET', '/mail/feed/atom', headers={'Authorization': self.cToken})
                res = c.getresponse()
                if (res.status == 200):
                    xml = ET.ElementTree(ET.fromstring(res.read()))
                    for el in xml.iter():
                        el.tag = re.sub(r'^{.*?}', "", el.tag)
                    self.status = 0
                    return xml.getroot()
                else:
                    self._handleError(res.status)
            else:
                print("Unknown request", request)
        except ET.ParseError as e:
            print("XMLError:", e)
        except Exception as e:
            print("GenericException:", e)
        return None

    def setCredentials(self, _cLogin, _cPassword):
        self.cLogin = _cLogin
        self.cPassword = _cPassword
        self.cToken = "Basic " + base64.b64encode(f"{_cLogin}:{_cPassword}".encode('utf-8')).decode("ascii")

    def getStatus(self):
        return self.status

    def getEMails(self):
        ret = []
        resp = self.api_request("getEMails")
        if not resp:
            return ret

        numUnread = resp.find("fullcount").text
        for conv in resp.findall("entry"):
            info = {}
            authorNames = [x.text if x.text else "unknown" for x in conv.findall("author/name")]
            authorEmails = [x.text if x.text else "unknown" for x in conv.findall("author/email")]

            info["ID"] = conv.find("id").text
            info["subject"] = conv.find("title").text
            info["summary"] = conv.find("summary").text
            info["isSpam"] = False
            info["isInbox"] = True
            info["isTrashed"] = False
            info["isStarred"] = False
            info["isArchived"] = False
            info["senders"] = [x[0] if x[0] else x[1] for x in zip(authorNames, authorEmails)]
            info["sendersStr"] = ', '.join(info["senders"])
            info["icon"] = self._getIcon(authorEmails[0], info["sendersStr"][0])

            ret.append(info)
        self._saveCache()
        return ret
    def moveFolder(self, uid, folder):
        print("NOT IMPLEMENTED")
        return False
    def setStarred(self, conv):
        print("NOT IMPLEMENTED")
        return False
    def unsetStarred(self, conv):
        print("NOT IMPLEMENTED")
        return False
    def unsetLabel(self, uid, label):
        print("NOT IMPLEMENTED")
        return False
    def markRead(self, uid):
        print("NOT IMPLEMENTED")
        return False
    def markUnread(self, uid):
        print("NOT IMPLEMENTED")
        return False

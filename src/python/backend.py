from PySide6.QtCore import QObject, Slot
import subprocess

class ShamanBackend(QObject):
    def __init__(self):
        super().__init__()

    @Slot(str)
    def runShell(self, command):
        try:
            subprocess.Popen(command.split(), stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        except Exception as e:
            print(f"Error executing shell command: {e}")

    @Slot(str)
    def openUrl(self, url):
        from PySide6.QtGui import QDesktopServices
        from PySide6.QtCore import QUrl
        QDesktopServices.openUrl(QUrl(url))

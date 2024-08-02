import sys
import os
import subprocess
import winreg
import requests
from PyQt5.QtWidgets import QApplication, QWidget, QPushButton, QVBoxLayout, QProgressBar, QLabel, QMessageBox
from PyQt5.QtGui import QIcon, QPixmap
from PyQt5.QtCore import Qt, QThread, pyqtSignal

class FixerThread(QThread):
    progress = pyqtSignal(int)
    finished = pyqtSignal()

    def run(self):
        try:
            key = winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, r"SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", 0, winreg.KEY_ALL_ACCESS)
            current_value, _ = winreg.QueryValueEx(key, "EnableLUA")
            
            if current_value == 1:
                for i in range(101):
                    self.progress.emit(i)
                    if i == 50:
                        winreg.SetValueEx(key, "EnableLUA", 0, winreg.REG_DWORD, 0)
                    self.msleep(20)
            else:
                for i in range(101):
                    self.progress.emit(i)
                    self.msleep(10)
            
            winreg.CloseKey(key)
        except Exception as e:
            print(f"Error: {e}")
        
        self.finished.emit()

class OAMPPApp(QWidget):
    def __init__(self):
        super().__init__()
        self.initUI()

    def initUI(self):
        self.setWindowTitle('oAMPP - XAMPP UAC Fixer')
        self.setGeometry(300, 300, 400, 300)
        self.setWindowIcon(QIcon('oAMPP_logo.png'))

        layout = QVBoxLayout()

        # Logo
        logo_label = QLabel()
        pixmap = QPixmap('oAMPP_logo.png')
        logo_label.setPixmap(pixmap.scaled(100, 100, Qt.KeepAspectRatio, Qt.SmoothTransformation))
        logo_label.setAlignment(Qt.AlignCenter)
        layout.addWidget(logo_label)

        # Fix button
        self.fix_button = QPushButton('Fix UAC Issue')
        self.fix_button.clicked.connect(self.start_fix)
        layout.addWidget(self.fix_button)

        # Progress bar
        self.progress_bar = QProgressBar()
        layout.addWidget(self.progress_bar)

        # Social links
        tg_button = QPushButton('Telegram Channel')
        tg_button.clicked.connect(lambda: self.open_url('https://t.me/VorTexCyberBD'))
        layout.addWidget(tg_button)

        git_button = QPushButton('GitHub Repository')
        git_button.clicked.connect(lambda: self.open_url('https://github.com/nectariferous/oAMPP'))
        layout.addWidget(git_button)

        self.setLayout(layout)

    def start_fix(self):
        self.fix_button.setEnabled(False)
        self.fixer_thread = FixerThread()
        self.fixer_thread.progress.connect(self.update_progress)
        self.fixer_thread.finished.connect(self.fix_finished)
        self.fixer_thread.start()

    def update_progress(self, value):
        self.progress_bar.setValue(value)

    def fix_finished(self):
        self.fix_button.setEnabled(True)
        QMessageBox.information(self, 'Fix Complete', 'UAC issue has been fixed. Please restart your computer for changes to take effect.')

    def open_url(self, url):
        subprocess.run(['start', url], shell=True)

if __name__ == '__main__':
    app = QApplication(sys.argv)
    ex = OAMPPApp()
    ex.show()
    sys.exit(app.exec_())

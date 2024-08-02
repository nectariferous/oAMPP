import sys
import os
import subprocess
import winreg
import requests
from PyQt5.QtWidgets import (QApplication, QMainWindow, QPushButton, QVBoxLayout, QProgressBar, 
                             QLabel, QMessageBox, QWidget, QHBoxLayout, QSystemTrayIcon, QMenu)
from PyQt5.QtGui import QIcon, QPixmap, QFont
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

class OAMPPApp(QMainWindow):
    def __init__(self):
        super().__init__()
        self.initUI()

    def initUI(self):
        self.setWindowTitle('oAMPP - XAMPP UAC Fixer')
        self.setGeometry(300, 300, 500, 400)
        self.setWindowIcon(QIcon('icons/favicon-32x32.png'))

        central_widget = QWidget()
        self.setCentralWidget(central_widget)
        layout = QVBoxLayout(central_widget)

        # Logo
        logo_label = QLabel()
        pixmap = QPixmap('oAMPP_logo.png')
        logo_label.setPixmap(pixmap.scaled(150, 150, Qt.KeepAspectRatio, Qt.SmoothTransformation))
        logo_label.setAlignment(Qt.AlignCenter)
        layout.addWidget(logo_label)

        # Title
        title_label = QLabel('oAMPP - XAMPP UAC Fixer')
        title_label.setAlignment(Qt.AlignCenter)
        title_label.setFont(QFont('Arial', 16, QFont.Bold))
        layout.addWidget(title_label)

        # Fix button
        self.fix_button = QPushButton('Fix UAC Issue')
        self.fix_button.setStyleSheet("background-color: #4CAF50; color: white; font-size: 14px; padding: 10px;")
        self.fix_button.clicked.connect(self.start_fix)
        layout.addWidget(self.fix_button)

        # Progress bar
        self.progress_bar = QProgressBar()
        self.progress_bar.setStyleSheet("QProgressBar {border: 2px solid grey; border-radius: 5px; text-align: center;}"
                                        "QProgressBar::chunk {background-color: #4CAF50;}")
        layout.addWidget(self.progress_bar)

        # Social links
        social_layout = QHBoxLayout()
        
        tg_button = QPushButton('Telegram')
        tg_button.setIcon(QIcon('icons/telegram_icon.png'))
        tg_button.clicked.connect(lambda: self.open_url('https://t.me/VorTexCyberBD'))
        social_layout.addWidget(tg_button)

        git_button = QPushButton('GitHub')
        git_button.setIcon(QIcon('icons/github_icon.png'))
        git_button.clicked.connect(lambda: self.open_url('https://github.com/nectariferous/oAMPP'))
        social_layout.addWidget(git_button)

        layout.addLayout(social_layout)

        # System tray
        self.tray_icon = QSystemTrayIcon(self)
        self.tray_icon.setIcon(QIcon('icons/favicon-32x32.png'))
        
        tray_menu = QMenu()
        show_action = tray_menu.addAction("Show")
        quit_action = tray_menu.addAction("Exit")
        show_action.triggered.connect(self.show)
        quit_action.triggered.connect(qApp.quit)
        self.tray_icon.setContextMenu(tray_menu)
        self.tray_icon.show()

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

    def closeEvent(self, event):
        event.ignore()
        self.hide()
        self.tray_icon.showMessage(
            "oAMPP",
            "Application was minimized to tray",
            QSystemTrayIcon.Information,
            2000
        )

if __name__ == '__main__':
    app = QApplication(sys.argv)
    ex = OAMPPApp()
    ex.show()
    sys.exit(app.exec_())

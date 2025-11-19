# SPDX-FileCopyrightText: 2025 Christian Tosta
# SPDX-License-Identifier: GPL-2.0-or-later
# Vim modeline: :set ts=4:sw=4:sts=4:et

import os
import sys
import signal

# PySide6 components
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QUrl, QCoreApplication

# Versioning
from .metadata import APPLICATION_NAME, ORGANIZATION_NAME, APPLICATION_VERSION

def run():

    # 1. Application Metadata
    QCoreApplication.setApplicationName(APPLICATION_NAME)
    QCoreApplication.setOrganizationName(ORGANIZATION_NAME)
    QCoreApplication.setApplicationVersion(APPLICATION_VERSION)

    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    # 2. Enable closing the app with Ctrl+C (SIGINT)
    signal.signal(signal.SIGINT, signal.SIG_DFL)

    # 3. Determine QML source path
    project_name = APPLICATION_NAME
    current_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.dirname(os.path.dirname(current_dir))

    # Load the QML file
    url = QUrl(f"file://{project_root}/{project_name}/qml/ui/Main.qml")

    engine.load(url)

    # 4. Error Checking
    if not engine.rootObjects():
        print(f"Error: cannot load QML application from {project_root}/{project_name}/qml/ui/Main.qml")
        sys.exit(-1)

    # 5. Start Event Loop
    sys.exit(app.exec())


if __name__ == "__main__":
    run()

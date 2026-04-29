## @file qml.py
#  @brief GUI management and QML engine initialization for Shaman.
#
#  SPDX-FileCopyrightText: 2026 Christian Tosta
#  SPDX-License-Identifier: LGPL-3.0-only

import sys
import signal
import os
from pathlib import Path

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QUrl, QCoreApplication

from shaman import __metadata__ as metadata
from .bridge import ShamanBridge

## @class GUI
#  @brief Handles the lifecycle of the graphical user interface.
class GUI:
    ## @brief Initializes the GUI with the engine reference.
    def __init__(self, engine):
        # Bridge Integration
        self.bridge = ShamanBridge(engine)

    ## @brief Configures and starts the QML application.
    def run(self):
        # Let user close application pressing CTRL+C
        signal.signal(signal.SIGINT, signal.SIG_DFL)

        # Path Resolution for Main.qml
        #project_root = Path(__file__).resolve().parents[2]
        #qml_path = project_root / "ui" / "gui" / "qml" / "Main.qml"
        qml_path = Path(__file__).parent / "qml" / "Main.qml"
        url = QUrl.fromLocalFile(str(qml_path))

        # Create the application
        app = QGuiApplication(sys.argv)
        app.processEvents()
        app.setOrganizationName(metadata.ORGANIZATION_NAME)
        app.setOrganizationDomain(metadata.ORGANIZATION_DOMAIN)
        app.setApplicationName(metadata.APPLICATION_NAME)
        app.setDesktopFileName(metadata.APPLICATION_ID)
        app.setApplicationVersion(metadata.APPLICATION_VERSION)

        # Set the QML Engine
        qml_engine = QQmlApplicationEngine()
        qml_engine.rootContext().setContextProperty("shaman", self.bridge)
        qml_engine.load(url)
        if not qml_engine.rootObjects():
            print(f"Error: Could not load QML from {qml_path}")
            sys.exit(-1)

        # Exits gracefully
        sys.exit(app.exec())

# vim: set ts=4:sw=4:sts=4:et:

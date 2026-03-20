// SPDX-FileCopyrightText: 2025 Christian Tosta <https://ur.link/tosta/>
// SPDX-License-Identifier: GPL-2.0-or-later

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import org.kde.kirigami as Kirigami

import "../pages"

Kirigami.ApplicationWindow {
    id: appWindow

    readonly property real aspectRatio: Screen.width / Screen.height
    readonly property int hintHeight: Kirigami.Units.gridUnit * 36
    readonly property int hintWidth: Math.max(Kirigami.Units.gridUnit * 48, aspectRatio * hintHeight)

    minimumHeight: hintHeight
    minimumWidth: hintWidth
    height: minimumHeight
    width: minimumWidth

    title: i18nc("@title:window", "Shaman – Assistente Ekaaty")

    pageStack.globalToolBar.style: Kirigami.ApplicationHeaderStyle.None

    pageStack.initialPage: Kirigami.Page {
        padding: 0
        titleVisible: false

        header: Controls.TabBar {
            id: tabBar

            Controls.TabButton {
                icon.name: "system-run-symbolic"
                text: i18n("Configurações de Sistema")
            }
            Controls.TabButton {
                icon.name: "drive-harddisk-symbolic"
                text: i18n("Configurações de Boot")
            }
            Controls.TabButton {
                icon.name: "package-symbolic"
                text: i18n("Configurações de Pacotes")
            }
            Controls.TabButton {
                icon.name: "preferences-desktop-theme-global-symbolic"
                text: i18n("Personalização Visual")
            }
            Controls.TabButton {
                icon.name: "preferences-desktop-accessibility-symbolic"
                text: i18n("Acessibilidade")
            }
        }

        StackLayout {
            anchors.fill: parent
            currentIndex: tabBar.currentIndex

            SystemSettingsPage {}
            BootSettingsPage {}
            PackageSettingsPage {}
            VisualPersonalizationPage {}
            AccessibilityPage {}
        }
    }

    footer: Controls.ToolBar {
        contentItem: RowLayout {
            Item {
                Layout.fillWidth: true
            }
            Controls.Button {
                text: i18n("Fechar")
                icon.name: "window-close-symbolic"
                onClicked: Qt.quit()
            }
        }
    }
}

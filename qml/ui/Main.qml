/*
 * SPDX-FileCopyrightText: 2025 Christian Tosta [Github](https://ur.link/tosta/)
 *
 * SPDX-License-Identifier: GPLv2 or later
 */

import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls as Controls
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.formcard as FormCard
import org.kde.plasma.core as PlasmaCore // for KI18n

import "../components"

Kirigami.ApplicationWindow {
    id: appWindow

    readonly property real aspectRatio: Screen.width/Screen.height
    readonly property int hintHeight: Kirigami.Units.gridUnit * 36
    readonly property int hintWidth: aspectRatio * hintHeight

    minimumHeight: hintHeight
    minimumWidth: hintWidth
    height: minimumHeight
    width: minimumWidth

    title: i18nc("@title:window", "Welcome - Shaman")

    Component { id: themePage; ThemePage {} }
    //Component { id: settings; Settings {} }

    pageStack.initialPage: Kirigami.Page {
        padding: Kirigami.Units.largeSpacing
        title: i18nc("@title:page", "Welcome")

        GridLayout {
            id: initialPageGrid
            anchors.centerIn: parent.centerIn
            anchors.fill: parent

            width: parent.width - (3 * Kirigami.Units.gridUnit)
            height: parent.height - (2 * Kirigami.Units.gridUnit)

            columnSpacing: Kirigami.Units.gridUnit / 2
            uniformCellWidths: true
            columns: 2

            Column {
                Rectangle {
                    width: (initialPageGrid.width - initialPageGrid.columnSpacing) / 2
                    height: initialPageGrid.height
                    color: "transparent"

                    Kirigami.Card {
                        anchors.margins: Kirigami.Units.gridUnit
                        anchors.fill: parent
                        background: Rectangle {
                            color: "transparent"
                            border.width: 0
                            radius: 0
                        }
                        header: Kirigami.Heading {
                            text: i18n("Welcome to Ekaaty Linux")
                            level: 1
                        }
                        contentItem: Controls.Label {
                            color: Kirigami.Theme.textColor
                            wrapMode: Text.WordWrap
                            text: i18n("Shaman, the Ekaaty OS assistant, will guide you throught the setup of your operating system...")
                        }
                    }

                    Image {
                        width: parent.width * 5/6
                        height: width
                        source: "../img/bottom-left-corner.png"
                        x: - Kirigami.Units.gridUnit * 2
                        y: appWindow.height - height
                    }
                }
            }

            Column {
                Rectangle {
                    width: (initialPageGrid.width - initialPageGrid.columnSpacing) / 2
                    height: initialPageGrid.height
                    color: "transparent"
                    border.width: 0
                    radius: 0

                    Kirigami.CardsLayout {
                        anchors.margins: Kirigami.Units.gridUnit
                        anchors.centerIn: parent

                        maximumColumns: 1
                        width: parent.width * 3/4

                        FormCard.FormButtonDelegate {
                            id: appearanceButton
                            icon.name: "preferences-desktop-theme-global-symbolic"
                            text: i18n("Configure Appearance")
                            onClicked: appWindow.pageStack.layers.push(themePage)
                        }
                        FormCard.FormButtonDelegate {
                            id: officeButton
                            icon.name: "applications-office-symbolic"
                            text: i18n("Install Office Suite")
                            onClicked: appWindow.pageStack.layers.push(themePage)
                        }
                        FormCard.FormButtonDelegate {
                            id: driversButton
                            icon.name: "package-symbolic"
                            text: i18n("Install/Update Extra Drivers")
                            onClicked: appWindow.pageStack.layers.push(themePage)
                        }
                        FormCard.FormButtonDelegate {
                            id: repositoriesButton
                            icon.name: "repository-symbolic"
                            text: i18n("Manage Software Repositories")
                            onClicked: appWindow.pageStack.layers.push(themePage)
                        }
                        FormCard.FormButtonDelegate {
                            id: securityButton
                            icon.name: "security-high-symbolic"
                            text: i18n("System Security Check-Up")
                            onClicked: appWindow.pageStack.layers.push(themePage)
                        }
                        FormCard.FormButtonDelegate {
                            id: performanceButton
                            icon.name: "battery-profile-performance"
                            text: i18n("Adjust the System Performance")
                            onClicked: appWindow.pageStack.layers.push(themePage)
                        }
                        /*FormCard.FormButtonDelegate {
                            id: settingsButton
                            icon.name: "settings-configure"
                            text: i18n("Application Settings")
                            onClicked: appWindow.pageStack.layers.push(settings)
                        }*/
                    }
                }
            }

        }
    }
}

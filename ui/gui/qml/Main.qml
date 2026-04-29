/*
 * SPDX-FileCopyrightText: 2025 Christian Tosta
 * SPDX-License-Identifier: GPLv2 or later
 */

import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls as Controls
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.formcard as FormCard
import org.kde.plasma.core as PlasmaCore // for KI18n

import "components"

Kirigami.ApplicationWindow {
    id: appWindow

    readonly property real aspectRatio: 3/2
    readonly property int hintHeight: Kirigami.Units.gridUnit * 32
    readonly property int hintWidth: aspectRatio * hintHeight
    property string pageTitle: "System Administration Assistant"

    minimumHeight: hintHeight
    minimumWidth: hintWidth
    maximumHeight: hintHeight
    maximumWidth: hintWidth
    height: minimumHeight
    width: minimumWidth

    title: i18nc("@title:window", pageTitle + " ─ Shaman")

    Component { id: channelsPage; ChannelsPage {} }
    Component { id: hardwarePage; HardwarePage {} }
    Component { id: softwarePage; SoftwarePage {} }
    Component { id: securityPage; SecurityPage {} }
    Component { id: performancePage; PerformancePage {} }

    pageStack.initialPage: Kirigami.Page {
        id: initialPage
        padding: Kirigami.Units.largeSpacing * 2
        title: i18nc("@title:page", "System Administration Assistant")

        onVisibleChanged: {
            if (visible) {
                appWindow.pageTitle = title;
            }
        }

        GridLayout {
            id: initialPageGrid
            anchors.centerIn: parent.centerIn
            anchors.fill: parent

            width:  parent.width  - (3 * Kirigami.Units.gridUnit)
            height: parent.height - (2 * Kirigami.Units.gridUnit)

            columnSpacing: Kirigami.Units.gridUnit // 2
            uniformCellWidths: true
            columns: 2

            Column {
                Rectangle {
                    width: (initialPageGrid.width - initialPageGrid.columnSpacing) / 2
                    height: initialPageGrid.height
                    color: "transparent"

                    Kirigami.Card {
                        anchors.topMargin: Kirigami.Units.gridUnit / 2
                        anchors.fill: parent

                        background: Rectangle {
                            color: "transparent"
                            border.width: 0
                            radius: 0
                        }

                        contentItem: Controls.Label {
                            color: Kirigami.Theme.textColor
                            wrapMode: Text.WordWrap
                            lineHeight: 1.3
                            text: i18n("A centralized facilitator for managing advanced parameters and security policies. Shaman simplifies the orchestration of critical components, allowing the administrator to tune infrastructure, hardware, and performance to specific requirements.")
                            opacity: 0.85
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
                        width: parent.width - Kirigami.Units.gridUnit

                        FormCard.FormButtonDelegate {
                            id: repositoriesButton
                            property string pageTitle: i18nc("@title:page", "Package Manager & Sources")
                            icon.name: "repository-symbolic"
                            text: i18n("Package Manager & Sources")
                            onClicked: {
                                appWindow.pageStack.layers.push(channelsPage)
                                appWindow.pageTitle = pageTitle;
                            }
                        }
                        FormCard.FormButtonDelegate {
                            id: hardwareButton
                            property string pageTitle: i18nc("@title:page", "Hardware Support & Firmwares")
                            icon.name: "package-symbolic"
                            text: i18n("Hardware Support & Firmwares")
                            onClicked: {
                                appWindow.pageStack.layers.push(hardwarePage)
                                appWindow.pageTitle = pageTitle;
                            }
                        }
                        FormCard.FormButtonDelegate {
                            id: softwareButton
                            property string pageTitle: i18nc("@title:page", "Extra Software & Altenatives")
                            icon.name: "kpackagekit-inactive"
                            text: i18n("Extra Software & Alternatives")
                            onClicked: {
                                appWindow.pageStack.layers.push(softwarePage)
                                appWindow.pageTitle = pageTitle;
                            }
                        }
                        FormCard.FormButtonDelegate {
                            id: securityButton
                            property string pageTitle: i18nc("@title:page", "Security & Hardening Shield")
                            icon.name: "preferences-security-symbolic"
                            text: i18n("Security & Hardening Shield")
                            onClicked: {
                                appWindow.pageStack.layers.push(securityPage)
                                appWindow.pageTitle = pageTitle;
                            }
                        }
                        FormCard.FormButtonDelegate {
                            id: performanceButton
                            property string pageTitle: i18nc("@title:page", "Kernel & Performance")
                            icon.name: "battery-profile-performance"
                            text: i18n("Kernel & Performance")
                            onClicked: {
                                appWindow.pageStack.layers.push(performancePage);
                                appWindow.pageTitle = pageTitle;
                            }
                        }
                    }
                }
            }
        }
    }
}

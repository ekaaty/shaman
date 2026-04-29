/**
 * @file InstallButton.qml
 * @brief Widget for software selection
 *
 * SPDX-FileCopyrightText: 2026 Christian Tosta
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import org.kde.kirigami as Kirigami

Kirigami.AbstractCard {
    id: installButtonRoot

    property var model: null
    readonly property string icondir: "../../img/icons"

    Layout.margins: Kirigami.Units.largeSpacing
    padding: Kirigami.Units.largeSpacing

    showClickFeedback: true
    hoverEnabled: true

    contentItem: RowLayout {
        spacing: Kirigami.Units.largeSpacing
        anchors.margins: Kirigami.Units.smallSpacing

        Image {
            source: icondir + "/" + model.icon || model.icon || ""
            Layout.preferredWidth: Kirigami.Units.gridUnit * 2
            Layout.preferredHeight: Kirigami.Units.gridUnit * 2
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            spacing: 0

            Kirigami.Heading {
                text: model.text
                color: Kirigami.Theme.textColor
                level: 4
                elide: Text.ElideRight
                font.weight: 500
                Layout.fillWidth: true
            }

            // Tags
            RowLayout {
                Layout.fillWidth: true
                spacing: 4
                visible: !!(model.tags || model.installed !== "null" && model)

                Controls.Label {
                    text: i18n(model.installed ? "installed" : "uninstalled") || ""
                    color: Kirigami.Theme.textColor
                    font.pointSize: Kirigami.Theme.smallFont.pointSize - 2
                    opacity: model.installed ? 0.85 : 0.5
                    padding: 1
                    leftPadding: 4
                    rightPadding: 4
                    background: Rectangle {
                        color: model.installed
                            ? Kirigami.Theme.highlightColor
                            : Kirigami.Theme.negativeColor
                            opacity: model.installed ? 1.0 : 0.25
                            radius: 2
                    }
                }

                Repeater {
                    model: { return installButtonRoot.model.tags; }
                    delegate: Controls.Label {
                        property color gold:     "#C5A059" // Premium
                        property color silver:   "#A8A9AD" // Pro
                        property color bronze:   "#965A38" // Standard
                        property color amethyst: "#55007f" // Other

                        text: modelData
                        color: Kirigami.Theme.textColor
                        font.pointSize: Kirigami.Theme.smallFont.pointSize - 2
                        opacity: 0.85
                        padding: 1
                        leftPadding: 4
                        rightPadding: 4
                        background: Rectangle {
                            color: {
                                if (modelData === "premium")  return gold;
                                if (modelData === "pro")      return silver;
                                if (modelData === "standard") return bronze;
                                return amethyst;
                            }
                            opacity: 1.0
                            radius: 2
                        }
                    }
                }
            }
        }

        Item { Layout.fillWidth: true }
    }
}

// :set ts=4:sw=4:sts=4:et:

/**
 * @file ChannelBox.qml
 * @brief Delegate for repository channels using a dual-line layout.
 * SPDX-FileCopyrightText: 2026 Christian Tosta
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import org.kde.kirigami as Kirigami

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: 0

    // Property injected by FormFactory
    property var model: null

    // Helper aliases/properties for backend mapping
    readonly property string displayName: model ? (model.text || "") : ""
    readonly property string iconSource: model ? (model.icon || "") : ""
    readonly property string categoryText: model ? (model.category || "") : ""
    readonly property string originText: model ? (model.origin || "") : ""
    readonly property bool isChecked: model ? (model.checked || false) : false

    signal toggled(bool isChecked)

    // Line 1: Identification
    RowLayout {
        Layout.fillWidth: true
        spacing: Kirigami.Units.smallSpacing

        Controls.CheckBox {
            id: channelCheck
            checked: root.isChecked
            onToggled: {
                if (root.model && root.model.hasOwnProperty("checked")) {
                    root.model.checked = checked;
                }
                root.toggled(checked);
            }
        }

        Kirigami.Icon {
            source: root.iconSource || "package-x-generic"
            Layout.preferredWidth: Kirigami.Units.iconSizes.small
            Layout.preferredHeight: Kirigami.Units.iconSizes.small
        }

        Controls.Label {
            text: root.displayName
            Layout.fillWidth: true
            font.bold: true
            elide: Text.ElideRight
        }
    }

    // Line 2: Metadata
    RowLayout {
        Layout.fillWidth: true
        Layout.leftMargin: channelCheck.width + Kirigami.Units.smallSpacing
        spacing: Kirigami.Units.smallSpacing

        // Badge for Origin
        Rectangle {
            color: Kirigami.Theme.highlightColor
            opacity: 0.2
            radius: 2
            visible: root.originText !== ""
            Layout.preferredHeight: originLabel.implicitHeight + 2
            Layout.preferredWidth: originLabel.implicitWidth + 8

            Controls.Label {
                id: originLabel
                text: root.originText.toUpperCase()
                anchors.centerIn: parent
                font.pointSize: Kirigami.Theme.smallFont.pointSize - 1
                font.weight: Font.Black
            }
        }

        Controls.Label {
            text: (root.originText !== "" ? "• " : "") + root.categoryText
            font.pointSize: Kirigami.Theme.smallFont.pointSize
            color: Kirigami.Theme.disabledTextColor
            opacity: 0.7
            elide: Text.ElideRight
            Layout.fillWidth: true
            visible: root.categoryText !== ""
        }
    }

    Item { Layout.preferredHeight: Kirigami.Units.smallSpacing }
}

// :set ts=4:sw=4:sts=4:et

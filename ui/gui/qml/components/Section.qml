/**
 * @file Section.qml
 * @brief Container component that proxies layout properties.
 *
 * SPDX-FileCopyrightText: 2026 Christian Tosta
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import org.kde.kirigami as Kirigami

Item {
    id: sectionRoot

    property bool scrollable: false
    property alias spacing: sectionContent.spacing
    default property alias content: sectionContent.data

    Layout.fillWidth: true
    Layout.fillHeight: scrollable

    implicitHeight: !scrollable ? sectionContent.implicitHeight : 0

    Controls.ScrollView {
        id: sectionScrollView
        anchors.fill: parent
        visible: sectionRoot.scrollable
        clip: true

        contentWidth: availableWidth
        contentHeight: sectionContent.implicitHeight
        rightPadding: scrollable ? 16 : 0

        Controls.ScrollBar.vertical: Controls.ScrollBar {
            parent: sectionScrollView
            //policy: Controls.ScrollBar.AlwaysOn
            policy: Controls.ScrollBar.AsNeeded
            orientation: Qt.Vertical
            interactive: true

            height: sectionScrollView.height
            x: sectionScrollView.width - width
            z: 10

            onActiveChanged: if (active) {
                height = sectionScrollView.height
                x = sectionScrollView.width - width
            }
        }

        Controls.ScrollBar.horizontal: Controls.ScrollBar {
            policy: Controls.ScrollBar.AlwaysOff
        }

        ColumnLayout {
            id: scrollContentSlot
            width: sectionScrollView.availableWidth
            spacing: sectionRoot.spacing
        }
    }

    ColumnLayout {
        id: sectionContent
        width: parent.width
        spacing: Kirigami.Units.largeSpacing

        anchors.top: !sectionRoot.scrollable ? parent.top : undefined
    }

    Component.onCompleted: {
        if (sectionRoot.scrollable) {
            sectionContent.parent = scrollContentSlot
        }
    }

    onVisibleChanged: {
        if (sectionRoot.scrollable && visible) {
            sectionContent.parent = scrollContentSlot
        } else if (!visible) {
            sectionContent.parent = sectionRoot
        }
    }
}

// :set ts=4:sw=4:sts=4:et:

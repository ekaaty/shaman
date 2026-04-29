/**
 * @file Accordion.qml
 * @brief Universal Accordion component supporting ListModel or JavaScript Arrays
 * SPDX-FileCopyrightText: 2026 Infra7 Serviços em TI
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.formcard as FormCard

Kirigami.CardsLayout {
    id: accordionRoot

    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.preferredWidth: expandable ? -1 : Kirigami.Units.gridUnit * 20
    maximumColumns: 1

    property var model: null
    property Component delegate: null
    property bool expandable: false
    property real fontPointSize: 10.0

    Repeater {
        model: accordionRoot.model
        delegate: FormCard.FormCard {
            id: card

            /** * @brief Universal data detection: checks for modelData (Arrays) or model (ListModel)
             */
            readonly property var itemModel: (typeof modelData !== "undefined") ? modelData : model
            readonly property bool isExpanded: itemModel.isExpanded || false

            Layout.fillWidth: true
            Layout.bottomMargin: isExpanded ? Kirigami.Units.largeSpacing : 0

            ColumnLayout {
                Layout.alignment: Qt.AlignLeft
                Layout.preferredWidth: parent.width
                spacing: 0

                FormCard.FormButtonDelegate {
                    id: delegateItem
                    Layout.fillWidth: true
                    Kirigami.Theme.colorSet: Kirigami.Theme.Button

                    background: Rectangle {
                        color: (delegateItem.hovered || isExpanded)
                            ? Kirigami.Theme.highlightColor
                            : Kirigami.Theme.backgroundColor
                    }

                    indicator: Item {
                        width: 24
                        height: 24
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter

                        Rectangle {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            width: 16
                            height: 16
                            color: (delegateItem.hovered || isExpanded)
                                ? Kirigami.Theme.highlightColor
                                : Kirigami.Theme.backgroundColor
                        }
                    }

                    icon.name: isExpanded ? "list-remove" : "list-add"
                    icon.color: Kirigami.Theme.linkColor

                    text: itemModel.title
                    description: itemModel.subtitle
                        ? "<i>" + itemModel.subtitle + "</i>"
                        : ""
                    font.pointSize: accordionRoot.fontPointSize
                    font.weight: 500

                    HoverHandler {
                        cursorShape: Qt.PointingHandCursor
                    }

                    onClicked: {
                        if (!accordionRoot.expandable) return;
                        let root = accordionRoot;
                        let m = root.model;
                        let currentIndex = index;
                        let targetState = !isExpanded;
                        let count = (m.count !== undefined) ? m.count : m.length;

                        if (targetState) {
                            for (let i = 0; i < count; ++i) {
                                root.updateProperty(m, i, "isExpanded", false);
                            }
                        }
                        root.updateProperty(m, currentIndex, "isExpanded", targetState);

                        if (m.length !== undefined) {
                            root.modelChanged();
                        }
                    }
                }

                Item {
                    id: collapsibleContent
                    Layout.fillWidth: true
                    clip: true

                    implicitHeight: isExpanded
                        ? (contentLoader.implicitHeight + Kirigami.Units.gridUnit * 2)
                        : 0
                    visible: implicitHeight > 0

                    Behavior on implicitHeight {
                        NumberAnimation {
                            duration: Kirigami.Units.shortDuration
                            easing.type: Easing.InOutQuad
                        }
                    }

                    Rectangle {
                        anchors.fill: parent
                        Kirigami.Theme.colorSet: Kirigami.Theme.Button
                        color: (delegateItem.hovered || isExpanded)
                            ? Kirigami.Theme.highlightColor
                            : Kirigami.Theme.backgroundColor
                        opacity: 0.05
                    }

                    Loader {
                        id: contentLoader
                        anchors {
                            top: parent.top
                            left: parent.left
                            right: parent.right
                            margins: Kirigami.Units.gridUnit
                        }

                        sourceComponent: accordionRoot.delegate

                        onLoaded: {
                            if (item) {
                                // Inject data into the delegate's properties
                                if (item.hasOwnProperty("model")) {
                                    item.model = itemModel;
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    /**
     * @brief Helper to handle property updates for both ListModel and JS Arrays
     */
    function updateProperty(m, idx, prop, val) {
        if (!m || idx === undefined || idx < 0) return;
        if (typeof m.setProperty === "function") {
            m.setProperty(idx, prop, val);
        } else {
            m[idx][prop] = val;
            // Notify view for JS objects since they aren't automatically observable
            accordionRoot.modelChanged();
        }
    }
}

// :set ts=4:sw=4:sts=4:et:

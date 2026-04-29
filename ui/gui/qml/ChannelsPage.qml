/*
 * @file ChannelsPage.qml
 * @brief Software repository channel management page.
 *
 * SPDX-FileCopyrightText: 2026 Christian Tosta
 * SPDX-License-Identifier: GPL-2.0-or-later
 *
 * :set ts=4:sw=4:sts=4:et
 */

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.formcard as FormCard

import "components" as ShamanComponents

Kirigami.Page {
    id: channelsPage
    title: i18nc("@title:page", "Software Channels")

    // Update page and window titles
    onVisibleChanged: { if (visible) { appWindow.pageTitle = title }}

    // Layout metrics
    padding: Kirigami.Units.largeSpacing * 2

    property bool showTesting: false
    property bool showTechnical: false
    property bool isEkaatyPlus: false //TODO: shaman.is_license_valid()

    property var pendingDeltas: ({})
    property var originalModel: []
    property int modelVersion: 0

    // Shaman Bridge Connection
    Connections {
        target: shaman
        onChannelsChanged: resetModels()
    }

    function resetModels() {
        let rawData = shaman.channelsModel;
        if (!rawData) return;
        // Deep copy to isolate memory referencies
        originalModel = JSON.parse(JSON.stringify(rawData));
        // Clean pending changes and notify the bridge
        pendingDeltas = {};
        shaman.hasPendingChanges = false;
        modelVersion++;
    }

    function loadChannelsData() {
        shaman.loadChannels("catalog", "origin");
        resetModels();
    }

    function discardLocalChanges() {
        loadChannelsData();
    }

    function getFilteredChannels(rawModel, showTech, showTest) {
        if (!rawModel || rawModel.length === 0) return [];

        return rawModel.filter(section => {
            const title = (section.title || "").toLowerCase();
            let isTechnical = title.includes("source") || title.includes("debug")
            let isTesting = title.includes("testing")
            if (!showTech && isTechnical) return false;
            if (!showTest && isTesting) return false;
            return true;
        });
    }

    function handleComponentCreation(object, loader) {
        if (!loader || !loader.itemData) return;

        let itemId = loader.itemData.id;
        let sectionId = loader.itemData.sectionId;

        if (object.hasOwnProperty("checked")) {
            let section = originalModel.find(s => s.id === sectionId);
            let item = section ? section.items.find(i => i.id === itemId) : null;

            let isInitializing = true;
            if (pendingDeltas.hasOwnProperty(itemId)) {
                object.checked = pendingDeltas[itemId];
            } else if (item) {
                object.checked = item.checked;
            } else {
                object.checked = loader.itemData.checked;
            }
            isInitializing = false;

            object.checkedChanged.connect(() => {
                if (isInitializing || !object) return;
                let newState = object.checked;

                if (item && newState === item.checked) {
                    delete pendingDeltas[itemId];
                } else {
                    pendingDeltas[itemId] = newState;
                }

                let hasPendingChanges = Object.keys(pendingDeltas).length > 0;
                shaman.setHasPendingChanges(hasPendingChanges);
            });
        }
    }

    // Startup action when the page is completed
    Component.onCompleted: {
        loadChannelsData();
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Page Grid based on TemplatePage structure
        GridLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.bottomMargin: Kirigami.Units.largeSpacing * 1.5
            columnSpacing: Kirigami.Units.gridUnit
            columns: 2

            // Left Section: Options
            ShamanComponents.Section {
                Layout.preferredWidth: parent.width * 1/2
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignTop
                spacing: Kirigami.Units.smallSpacing

                Kirigami.Heading {
                    Layout.fillWidth: true
                    text: i18n("Options")
                    font.weight: 500
                    level: 3
                }

                Kirigami.Separator {
                    Layout.fillWidth: true
                    Layout.bottomMargin: Kirigami.Units.smallSpacing
                    opacity: 0.5
                }

                FormCard.FormCheckDelegate {
                    Layout.fillWidth: true
                    text: i18n("Show Updates Testing channels")
                    description: "<i>" + i18n(
                        "Enable this to see channels with testing packages."
                    ) + "</i>"
                    checked: channelsPage.showTesting
                    onToggled: channelsPage.showTesting = checked
                }

                FormCard.FormCheckDelegate {
                    Layout.fillWidth: true
                    text: i18n("Show Debug/Source channels")
                    description: "<i>" + i18n(
                        "Enable this to see channels containing techinical data
                        and source code."
                    ) + "</i>"
                    checked: channelsPage.showTechnical
                    onToggled: channelsPage.showTechnical = checked
                }

                FormCard.FormCheckDelegate {
                    id: enableEkaatyPlus
                    Layout.fillWidth: true
                    text: i18n("Enable Ekaaty Plus")
                    description: "<i>" + i18n(
                        "Enable this to use Ekaaty Plus repositories."
                    ) + "</i>"
                    visible: false // TODO: Not implemented yet
                }

                FormCard.FormCard {
                    Layout.fillWidth: true
                    visible: enableEkaatyPlus.checked

                    //FormCard.FormHeader { title: i18n("Ekaaty Plus") }
                    FormCard.FormTextFieldDelegate {
                        id: licenseField
                        label: i18n("Ekaaty Plus Unique ID:")
                        placeholderText: "XXXX-XXXX-XXXX-XXXX"
                        //onLoad: shaman.read_license()
                        //onAccepted: shaman.save_license(text)
                    }

                    ShamanComponents.StatusNote {
                        type: "info"
                        text: i18n("Status: Active")
                        //visible: isEkaatyPlus
                    }
                }

                Item { Layout.fillHeight: true }
            }

            // Right Section: Channels List
            ShamanComponents.Section {
                scrollable: true
                Layout.preferredWidth: parent.width * 1/2
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: Kirigami.Units.smallSpacing

                Kirigami.Heading {
                    Layout.fillWidth: true
                    text: i18n("Available Channels")
                    font.weight: 500
                    level: 3
                }

                Kirigami.Separator {
                    Layout.fillWidth: true
                    Layout.bottomMargin: Kirigami.Units.smallSpacing
                    opacity: 0.5
                }

                ShamanComponents.Accordion {
                    id: channelsAccordion
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignRight | Qt.AlignTop
                    Layout.margins: Kirigami.Units.smallSpacing
                    expandable: true
                    model: getFilteredChannels(
                        shaman.channelsModel,
                        showTechnical,
                        showTesting
                    )
                    delegate: ShamanComponents.FormFactory {
                        typeMap: {
                            "channelbox": ShamanComponents.ChannelBox
                        }
                        onComponentCreated: (object) => {
                            handleComponentCreation(object, object.parent);
                        }
                    }
                }

                Item { Layout.fillHeight: true }
            }
        }

        Kirigami.Separator {
            Layout.fillWidth: true
            Layout.leftMargin: 0
            Layout.bottomMargin: Kirigami.Units.largeSpacing
            opacity: 0.5
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.margins: 0
            Layout.topMargin: Kirigami.Units.smallSpacing
            spacing: Kirigami.Units.mediumSpacing

            Item { Layout.fillWidth: true }

            Kirigami.Action {
                id: applyAction
                text: shaman.isLoading ? i18n("Processing...") : i18n("Apply")
                icon.name: "dialog-ok-apply"
                enabled: shaman.hasPendingChanges
                onTriggered: {
                    shaman.applyChannelChanges(channelsPage.pendingDeltas);
                }
            }

            Controls.Button {
                text: i18n("Restore")
                icon.name: "edit-undo"
                visible: applyAction.enabled
                onClicked: discardLocalChanges()
            }

            Controls.Button {
                action: applyAction
                highlighted: true
            }
        }


        Rectangle {
            id: loadingOverlay
            anchors.fill: parent
            color: Kirigami.Theme.backgroundColor
            z: 999
            visible: shaman.isLoading

            Behavior on opacity { NumberAnimation { duration: Kirigami.Units.shortDuration } }
            opacity: visible ? 1.0 : 0.0

            // Blocks clicks on background items when loading
            MouseArea {
                anchors.fill: parent
                preventStealing: true
                onClicked: (mouse) => mouse.accepted = true
            }

            ColumnLayout {
                anchors.centerIn: parent
                spacing: Kirigami.Units.gridUnit
                width: parent.width * 0.8

                Kirigami.Icon {
                    id: loadingIcon
                    source: "reload"
                    implicitWidth: Kirigami.Units.gridUnit * 3
                    implicitHeight: Kirigami.Units.gridUnit * 3
                    Layout.alignment: Qt.AlignHCenter
                    color: Kirigami.Theme.textColor

                    RotationAnimator on rotation {
                        from: 360
                        to: 0
                        duration: 1000
                        loops: Animation.Infinite
                        running: shaman.isLoading
                    }
                }

                Kirigami.Heading {
                    text: i18n("Executing System Changes")
                    type: Kirigami.Heading.Type.Primary
                    Layout.alignment: Qt.AlignHCenter
                    color: Kirigami.Theme.textColor
                }

                Controls.Label {
                    text: i18n("Please wait while updating your software channels...")
                    Layout.alignment: Qt.AlignHCenter
                    color: Kirigami.Theme.textColor
                    opacity: 0.8
                }
            }
        }
    }
}

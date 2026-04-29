import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.formcard as FormCard

import "components" as ShamanComponents
import "models" as ShamanModels

Kirigami.Page {
    id: hardwarePage
    title: i18nc("@title:page", "Hardware Support & Firmware")

    // Update page and window titles
    onVisibleChanged: { if (visible) { appWindow.pageTitle = title }}

    // Metrics
    padding: Kirigami.Units.largeSpacing * 2

    ListModel {
        id: deviceListModel
    }

    ListModel {
        id: packageSelectionModel

        ListElement {
            title: QT_TR_NOOP("Device Drivers")
            description: "Kernel modules and related tools for hardware devices."
            isExpanded: false
            type: "driver"
        }

        ListElement {
            title: QT_TR_NOOP("Device Firmwares")
            description: "Firmware data used by drivers and others."
            isExpanded: false
            type: "firmware"
        }
    }

    // Bridge Connection
    Connections {
        target: shaman
        function onInventoryChanged() {
            deviceListModel.clear();
            if (shaman.inventory) {
                deviceListModel.append({
                    "title": i18n("Detected Devices"),
                    "isExpanded": true,
                    "deviceListData": shaman.inventory
                });
            }
        }
    }

    // Start search when page is completed
    Component.onCompleted: {
        shaman.refresh_hardware();
    }

    // Components: Layout and Delegates
    Component {
        id: deviceListDelegate
        ShamanComponents.DeviceList {
            Layout.fillWidth: true
            model: ({ "deviceListData": shaman.inventory })
        }
    }

    Component {
        id: packageSelectionDelegate
        ShamanComponents.FormFactory {
            Layout.fillWidth: true
            //description: modelData ? modelData.description : "";
            //sectionModel: modelData ? modelData.items : [];
        }
    }

    // Page Grid
    GridLayout {
        anchors.fill: parent
        anchors.margins: Kirigami.Units.largeSpacing
        columnSpacing: Kirigami.Units.gridUnit
        columns: 2

        ShamanComponents.Section {
            scrollable: true
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width * 1/2

            Kirigami.Heading {
                Layout.fillWidth: true
                text: i18n("Hardware Overview")
                font.weight: 500
                level: 3
            }

            Kirigami.Separator {
                Layout.fillWidth: true
                Layout.bottomMargin: Kirigami.Units.smallSpacing
                opacity: 0.5
            }

            ShamanComponents.Accordion {
                id: deviceListAccordion
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignRight | Qt.AlignTop
                Layout.margins: Kirigami.Units.smallSpacing
                model: deviceListModel
                delegate: deviceListDelegate
                expandable: true
            }

            Item { Layout.fillHeight: true }
        }


        ShamanComponents.Section {
            scrollable: true
            Layout.preferredWidth: parent.width * 1/2


            Kirigami.Heading {
                Layout.fillWidth: true
                text: i18n("Install Drivers & Firmwares")
                font.weight: 500
                level: 3
            }

            Kirigami.Separator {
                Layout.fillWidth: true
                Layout.bottomMargin: Kirigami.Units.smallSpacing
                opacity: 0.5
            }

            ShamanComponents.Accordion {
                id: packageSelectionAccordion
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignRight | Qt.AlignTop
                Layout.margins: Kirigami.Units.smallSpacing
                model: packageSelectionModel
                delegate: packageSelectionDelegate
                expandable: true
            }

            Item { Layout.fillHeight: true }
        }

    }
}

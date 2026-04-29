import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import org.kde.kirigami as Kirigami
import org.kde.kirigami.delegates as Delegates
import org.kde.kirigamiaddons.formcard as FormCard

import "components" as ShamanComponents
//import "models" as ShamanModels

Kirigami.Page {
    id: softwarePage
    title: i18nc("@title:page", "Extra Software & Alternatives")

    // Update page and window titles
    onVisibleChanged: { if (visible) { appWindow.pageTitle = title }}

    // Metrics
    padding: Kirigami.Units.largeSpacing * 2

    // Models used in this page

    // Shaman Bridge Connection
    Connections {
        target: shaman
    }

    // Startup action when the page is completed
    Component.onCompleted: {
        //shaman.%%ShamanAction%%();
    }

    // Components: Layout and Delegates
    property var essentialSoftwareModel: [
        {
            title: "Multimedia Support",
            isExpanded: false,
            items: [
                {
                    title: "Audio Codecs",
                    type: "multiselect",
                    items: [
                        {
                            id: "h264_avc",
                            text: "H.264 / AVC",
                            checked: true
                        },
                        {
                            id: "hevc_h265",
                            text: "HEVC / H.265",
                            checked: false
                        },
                        {
                            id: "aac_mp4",
                            text: "AAC / MP4 Audio",
                            checked: true
                        },
                        {
                            id: "dvd_playback",
                            text: "DVD Playback",
                            checked: false
                        }
                    ]
                }
            ]
        },
        {
            title: "Web Browsers",
            isExpanded: true,
            items: [
                {
                    title: "",
                    description: "This will install the web browser and it common extensions",
                    type: "InstallButton",
                    items: [
                        {
                            id: "firefox",
                            text: "Mozilla Firefox",
                            icon: "firefox",
                            installed: true,
                            checked: true
                        },
                        {
                            id: "brave",
                            text: "Brave Browser",
                            icon: "brave-browser",
                            checked: false
                        },
                        {
                            id: "edge",
                            text: "Microsoft Edge",
                            icon: "microsoft-edge",
                            checked: false
                        },
                        {
                            id: "chrome",
                            text: "Google Chrome",
                            icon: "google-chrome",
                            checked: false
                        }
                    ]
                }
            ]
        }
    ]

    property var productivityModel: [
        {
            title: "Communication Hub",
            isExpanded: false,
            items: [
                {
                    title: "Team Workplaces",
                    type: "multiselect",
                    items: [
                        {
                            id: "neochat",
                            text: "Neochat",
                            checked: true
                        },
                        {
                            id: "elementor",
                            text: "Elementor (Coming Soon)",
                            checked: false,
                            enabled: false
                        },
                        {
                            id: "slack",
                            text: "Slack",
                            tags: "pro",
                            checked: false,
                            enabled: false
                        },
                        {
                            id: "teams",
                            text: "Microsoft Teams",
                            tags: ["pro"],
                            checked: false,
                            enabled: false
                        }
                    ]
                }
            ]
        },
        {
            title: "Productivity",
            isExpanded: true,
            items: [
                {
                    title: "Office Suites",
                    description: "Select one or more suites",
                    type: "InstallButton",
                    items: [
                        {
                            id: "libreoffice",
                            text: "LibreOffice",
                            icon: "libreoffice",
                            installed: true,
                            enabled: true
                        },
                        {
                            id: "eurooffice",
                            text: "Euro Office",
                            icon: "office-eu",
                            tags: ["coming-soon"],
                            installed: false,
                            enabled: false
                        },
                        {
                            id: "msoffice",
                            text: "Microsoft Office 365",
                            icon: "microsoft-365",
                            tags: ["premium"],
                            installed: false,
                            enabled: false
                        }
                    ]
                }
            ]
        }
    ]


    ColumnLayout {
        anchors.fill: parent
        spacing: 0

    // Page Grid
        GridLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.bottomMargin: Kirigami.Units.largeSpacing * 1.5
            columnSpacing: Kirigami.Units.gridUnit
            columns: 2

            ShamanComponents.Section {
                scrollable: true
                Layout.preferredWidth: parent.width * 1/2
                Layout.fillWidth: true
                Layout.fillHeight: true

                Kirigami.Heading {
                    Layout.fillWidth: true
                    text: i18n("System Essentials")
                    font.weight: 500
                    level: 3
                }

                Kirigami.Separator {
                    Layout.fillWidth: true
                    Layout.bottomMargin: Kirigami.Units.smallSpacing
                    opacity: 0.5
                }

                ShamanComponents.Accordion {
                    id: essentialSoftwareAccordion
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignRight | Qt.AlignTop
                    Layout.margins: Kirigami.Units.smallSpacing
                    expandable: true
                    model: essentialSoftwareModel //shaman.essentialSoftwareModel
                    delegate: ShamanComponents.FormFactory {
                        //typeMap: { "installbutton": ShamanComponents.InstallButton }
                    }
                }

                /*
                3. Bank Access & Security

                Esta seção funciona bem como uma lista de "Toggles" (Switches).

                * PJe: Software para escritórios de advocacia
                * Web PKI / Token Support: Instalação de drivers pcsc-lite e suporte a tokens criptográficos.
                * Sac-core: Suporte para eToken
                * Browser Extensions: Incluir com pacotes dos navegadores
                * Warsaw

                */

                Item { Layout.fillHeight: true }
            }


            ShamanComponents.Section {
                scrollable: true
                Layout.preferredWidth: parent.width * 1/2


                Kirigami.Heading {
                    Layout.fillWidth: true
                    text: i18n("Productivity & Sovereignty")
                    font.weight: 500
                    level: 3
                }

                Kirigami.Separator {
                    Layout.fillWidth: true
                    Layout.bottomMargin: Kirigami.Units.smallSpacing
                    opacity: 0.5
                }

                ShamanComponents.Accordion {
                    id: productivityAccordion
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignRight | Qt.AlignTop
                    Layout.margins: Kirigami.Units.smallSpacing
                    expandable: true
                    model: productivityModel //shaman.productivityModel
                    delegate: ShamanComponents.FormFactory { }
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
                    text: i18n("Please wait while installing/updating your software...")
                    Layout.alignment: Qt.AlignHCenter
                    color: Kirigami.Theme.textColor
                    opacity: 0.8
                }
            }
        }
    }
}

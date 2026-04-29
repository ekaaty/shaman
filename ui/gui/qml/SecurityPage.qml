import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore // for KI18n
import org.kde.kirigamiaddons.formcard as FormCard

import "components" as ShamanComponents
//import "forms" as ShamanForms

Kirigami.Page {
    id: securityPage
    title: i18nc("@title:page", "Security Center")
    padding: Kirigami.Units.largeSpacing * 3

    onVisibleChanged: {
        if (visible) {
            appWindow.pageTitle = title;
        }
    }

    QtObject {
        id: security
        property int status: 1

        property string statusText: {
            switch (status) {
                case 0: return i18n("Inactive");
                case 1: return i18n("Attention");
                case 2: return i18n("Active");
                default: return i18n("Inactive");
            }
        }
        property string statusColor: {
            switch (status) {
                case 0: return "#e74c3c"; // Red
                case 1: return "#e67e22"; // Orange
                case 2: return "#27ae60"; // Green
                default: return "#e74c3c";
            }
        }
        property string statusIcon: {
            switch (status) {
                case 0: return "security-low";
                case 1: return "security-medium";
                case 2: return "security-high";
                default: return "security-low";
            }
        }
    }

    GridLayout {
        anchors.fill: parent
        anchors.margins: Kirigami.Units.largeSpacing
        columnSpacing: Kirigami.Units.gridUnit / 2
        columns: 1

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width * 1/2
            spacing: Kirigami.Units.largeSpacing

            Rectangle {
                Layout.fillWidth: true
                Layout.margins: Kirigami.Units.largeSpacing
                Layout.preferredHeight: Kirigami.Units.gridUnit * 8
                Kirigami.Theme.colorSet: Kirigami.Theme.View
                color: Kirigami.Theme.activeBackgroundColor

                Kirigami.Icon {
                    source: security.statusIcon
                    x: 16
                    y: 16
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    width: 96
                    height: 96
                }

                Kirigami.Heading {
                    Layout.margins: Kirigami.Units.largeSpacing * 3
                    x: 96
                    padding: Kirigami.Units.largeSpacing * 3
                    text: i18n("Protection Status: ") + security.statusText
                    color: security.statusColor
                    font.pointSize: 24
                    level: 2
                }
            }

            Kirigami.CardsLayout {
                width: securityScroll.availableWidth
                maximumColumns: 3

                Repeater {
                    model: securityModel
                    delegate: Kirigami.AbstractCard {
                        Layout.margins: Kirigami.Units.largeSpacing
                        Layout.maximumHeight: Kirigami.Units.gridUnit * 6
                        Layout.preferredWidth: Kirigami.Units.gridUnit * 20
                        padding: Kirigami.Units.largeSpacing * 3

                        showClickFeedback: true
                        onClicked: {
                            switch(model.actionType) {
                                case "shell": backend.runShell(model.actionValue);
                                case "dbus": backend.openUrl(model.actionValue);
                                default: return false;
                            }
                        }

                        contentItem: RowLayout {
                            spacing: Kirigami.Units.largeSpacing
                            anchors.margins: Kirigami.Units.smallSpacing

                            Image {
                                source: "../img/" + model.icon + ".svg"
                                Layout.preferredWidth: Kirigami.Units.gridUnit * 3
                                Layout.preferredHeight: Kirigami.Units.gridUnit * 3
                                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                            }

                            ColumnLayout {
                                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                                spacing: 0

                                Kirigami.Heading {
                                    text: model.label
                                    level: 4
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }
                                Controls.Label {
                                    text: model.provider
                                    color: Kirigami.Theme.textColor
                                    font.pointSize: Kirigami.Theme.smallFont.pointSize
                                }
                                Controls.Label {
                                    text: model.statusText
                                    color: model.statusColor
                                    font.pointSize: Kirigami.Theme.smallFont.pointSize
                                    font.italic: true
                                }
                            }

                            Item { Layout.fillWidth: true }
                        }
                    }
                }
            }

            ListModel {
                id: securityModel

                ListElement {
                    label: "Firewall & Network"
                    icon: "firewall"
                    provider: "firewalld"
                    statusText: "Active & Protecting"
                    statusColor: "#27ae60"
                    actionType: "shell"
                    actionValue: "kcmshell6 kcm_firewall"
                }
                ListElement {
                    label: "Enhanced Security"
                    icon: "policy"
                    provider: "SELinux"
                    statusText: "Active & Enforced"
                    statusColor: "#27ae60"
                    actionType: "none"
                    actionValue: "none"
                }
                ListElement {
                    label: "Virus & Malware Protection"
                    icon: "treat-actor"
                    provider: "Clamav / Lynis"
                    statusText: "Active & Protecting"
                    statusColor: "#27ae60"
                    actionType: "none"
                    actionValue: "none"
                }
                ListElement {
                    label: "Host Security Level: HSI-1"
                    icon: "hsm"
                    provider: "fwupdmgr"
                    statusText: "Some settings are Disabled/Unsupported"
                    statusColor: "#e67e22"
                    actionType: "none"
                    actionValue: "none"
                }
                ListElement {
                    label: "Parental Control"
                    icon: "team-security"
                    provider: "None"
                    statusText: "Service not Installed"
                    statusColor: "#ff0000"
                    actionType: "none"
                    actionValue: "none"
                }
                ListElement {
                    label: "System Updates"
                    icon: "network"
                    provider: "Discover"
                    statusText: "3 Pending Updates"
                    statusColor: "#e67e22"
                    actionType: "shell"
                    actionValue: "plasma-discover --mode update"
                }
            }

            Item { Layout.fillHeight: true }
        }
    }
}

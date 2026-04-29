import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigamiaddons.formcard as FormCard

import "components" as ShamanComponents
import "models" as ShamanModels

Kirigami.Page {
    id: performancePage
    title: i18nc("@title:page", "Kernel & Performance")
    onVisibleChanged: {
        if (visible) {
            appWindow.pageTitle = title;
        }
    }

    padding: Kirigami.Units.largeSpacing * 2

    ShamanModels.PerformanceModel {
        id: performanceData
    }

    Component {
        id: accordionDelegate

        ShamanComponents.FormFactory {
            Layout.fillWidth: true

            property var model: null
            description: model.description

            // Map the type to the specific property in PerformanceModel
            sectionModel: {
                switch(model.type) {
                    case "kernel": return performanceData.kernelModel;
                    case "tuned":  return performanceData.tunedModel;
                    case "sysctl": return performanceData.sysctlModel;
                    default: return [];
                }
            }
        }
    }

    GridLayout {
        anchors.fill: parent
        anchors.margins: Kirigami.Units.largeSpacing
        columnSpacing: Kirigami.Units.gridUnit
        columns: 2

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width * 1/2
            spacing: Kirigami.Units.largeSpacing

            Controls.Label {
                Layout.fillWidth: true
                text: i18n("Fine-tune the operational core to optimize system responsiveness and resource allocation. This section facilitates the orchestration of kernel-level parameters, allowing for precise balancing between power efficiency, low-latency execution, and high-throughput performance according to deployment requirements.")
                wrapMode: Text.WordWrap
                opacity: 0.85
            }

            ShamanComponents.StatusNote {
                Layout.fillWidth: true
                type: "important"
                text: i18n("Changes to Kernel Boot Parameters require a system restart to take effect.")
            }

            // Documentação Técnica Local
            RowLayout {
                spacing: Kirigami.Units.smallSpacing
                Layout.fillWidth: true
                Layout.topMargin: Kirigami.Units.largeSpacing * 1.5

                Kirigami.Icon {
                    source: "document-share"
                    implicitWidth: Kirigami.Units.iconSizes.small
                    implicitHeight: Kirigami.Units.iconSizes.small
                }

                Controls.Label {
                    text: i18n("Read full documentation")
                    color: Kirigami.Theme.linkColor
                    font.underline: true

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            ShamanBackend.open_documentation(
                                "/usr/share/doc/shaman/kernel_performance.md",
                                "okular"
                            )
                        }
                    }
                }
            }

            Item { Layout.fillHeight: true }
        }

        Controls.ScrollView {
            id: performanceScroll
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width * 1/2
            spacing: Kirigami.Units.largeSpacing
            clip: true

            contentWidth: availableWidth

            Controls.ScrollBar.vertical: Controls.ScrollBar {
                parent: performanceScroll
                x: performanceScroll.width - width
                height: performanceScroll.height
                policy: Controls.ScrollBar.AsNeeded
            }

            Controls.ScrollBar.horizontal: Controls.ScrollBar {
                policy: Controls.ScrollBar.AlwaysOff
            }

            ColumnLayout {
                width: performanceScroll.availableWidth
                spacing: 0

                ShamanComponents.Accordion {
                    id: performanceAccordion
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignRight | Qt.AlignTop
                    Layout.margins: Kirigami.Units.smallSpacing
                    model: performanceModel
                    delegate: accordionDelegate
                    expandable: true
                }

                Item { Layout.fillHeight: true }
            }
        }
    }

    ListModel {
        id: performanceModel

        ListElement {
            title: QT_TR_NOOP("Kernel Boot Parameters")
            description: QT_TR_NOOP("This configures the kernel boot options.")
            isExpanded: false
            type: "kernel"
        }

        ListElement {
            title: QT_TR_NOOP("Tuned Optimization Profiles")
            description: QT_TR_NOOP("This enables dynamic tuning according to the computer use.")
            isExpanded: false
            type: "tuned"
        }

        ListElement {
            title: QT_TR_NOOP("Advanced System Controls")
            description: QT_TR_NOOP("This settings adjusts kernel runtime parameters.")
            isExpanded: false
            type: "sysctl"
        }
    }

}

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore // for KI18n
import org.kde.kirigamiaddons.formcard as FormCard

import "components" as ShamanComponents
import "forms" as ShamanForms


Kirigami.Page {
    id: performancePage
    title: i18nc("@title:page", "Kernel & Performance")

    padding: Kirigami.Units.largeSpacing * 2

    onVisibleChanged: {
        if (visible) {
            appWindow.pageTitle = title;
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

            Item { Layout.fillHeight: true }
        }

        Controls.ScrollView {
            id: performanceScroll
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width * 1/2
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
            subtitle: QT_TR_NOOP("Configure the kernel boot options.")
            isExpanded: false
            type: "kernel"
        }

        ListElement {
            title: QT_TR_NOOP("Tuned Optimization Profiles")
            subtitle: QT_TR_NOOP("Select and manage profiles for dynamic tuning.")
            isExpanded: false
            type: "tuned"
        }

        ListElement {
            title: QT_TR_NOOP("Advanced System Controls")
            subtitle: QT_TR_NOOP("Adjust kernel runtime parameters.")
            isExpanded: false
            type: "sysctl"
        }
    }

    Component { id: kernelComponent; ShamanForms.KernelSettings {} }
    Component { id: tunedComponent;  ShamanForms.TunedSettings {} }
    Component { id: sysctlComponent; ShamanForms.SysctlSettings {} }
    Component {
        id: accordionDelegate

        Loader {
            Layout.fillWidth: true
            property var model: null

            sourceComponent: {
                switch(model.type) {
                    case "kernel": return kernelComponent;
                    case "tuned":  return tunedComponent;
                    case "sysctl": return sysctlComponent;
                    default: return null;
                }
            }
        }
    }

}

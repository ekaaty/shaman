import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.formcard as FormCard

ColumnLayout {
    id: kernelSettings
    implicitHeight: childrenRect.height
    spacing: Kirigami.Units.smallSpacing

    FormCard.FormHeader {
        title: i18n("Latency & Performance")
    }

    Kirigami.Separator {
        Layout.fillWidth: true
        Layout.leftMargin: Kirigami.Units.gridUnit
        Layout.rightMargin: Kirigami.Units.gridUnit
    }

    FormCard.FormCheckDelegate {
        id: preemptToggle
        text: i18n("Enable kernel full preemptive mode")
        description: i18n("Prioritizes system interactivity and reduces delays for critical tasks.")
    }

    FormCard.FormCheckDelegate {
        id: thpToggle
        text: i18n("Disable Transparent Hugepages (THP)")
        description: i18n("Reduces latency spikes and micro-stuttering in memory-intensive applications.")
    }

    FormCard.FormHeader {
        title: i18n("Hardware Virtualization")
    }

    Kirigami.Separator {
        Layout.fillWidth: true
        Layout.leftMargin: Kirigami.Units.gridUnit
        Layout.rightMargin: Kirigami.Units.gridUnit
    }

    FormCard.FormCheckDelegate {
        id: iommuToggle
        text: i18n("Enable Input-Output Memory Management Unit (IOMMU)")
        description: i18n("Required for hardware passthrough and isolation in virtual machines.")
    }
}

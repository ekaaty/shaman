import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.formcard as FormCard

ColumnLayout {
    id: tunedSettings
    implicitHeight: childrenRect.height
    spacing: Kirigami.Units.smallSpacing

    FormCard.FormHeader {
        title: i18n("System Optimization Profiles")
    }

    Kirigami.Separator {
        Layout.fillWidth: true
        Layout.leftMargin: Kirigami.Units.gridUnit
        Layout.rightMargin: Kirigami.Units.gridUnit
    }

    FormCard.FormRadioDelegate {
        text: i18n("Optimize for Battery Life")
        description: i18n("Aggressive power saving for mobile devices.")
        checked: model.activeProfile === "battery"
        onClicked: model.activeProfile = "battery"
    }

    FormCard.FormRadioDelegate {
        text: i18n("Optimize for Business Workstation")
        description: i18n("Balanced profile for office tasks and daily usage.")
        checked: model.activeProfile === "workstation"
        onClicked: model.activeProfile = "workstation"
    }

    FormCard.FormRadioDelegate {
        text: i18n("Optimize for Software Development")
        description: i18n("Improved file system throughput and build performance.")
        checked: model.activeProfile === "development"
        onClicked: model.activeProfile = "development"
    }

    FormCard.FormRadioDelegate {
        text: i18n("Optimize for Virtualization")
        description: i18n("Tuned for hosting Virtual Machines and Containers.")
        checked: model.activeProfile === "virtualization"
        onClicked: model.activeProfile = "virtualization"
    }

    FormCard.FormRadioDelegate {
        text: i18n("Optimize for Gaming / Low Latency")
        description: i18n("Maximum performance and reduced input lag.")
        checked: model.activeProfile === "gaming"
        onClicked: model.activeProfile = "gaming"
    }
}

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.formcard as FormCard

import "components" as ShamanComponents
//import "models" as ShamanModels

Kirigami.Page {
    id: %%PageName%%Page
    title: i18nc("@title:page", "%%PageTitle%%")

    // Update page and window titles
    onVisibleChanged: { if (visible) { appWindow.pageTitle = title }}

    // Metrics
    padding: Kirigami.Units.largeSpacing * 2

    // Models used in this page
    %%PageModels%%


    // Shaman Bridge Connection
    Connections {
        target: shaman
        %%ConnectionJSMethods%%
    }

    // Startup action when the page is completed
    Component.onCompleted: {
        shaman.%%ShamanAction%%();
    }

    // Components: Layout and Delegates
    %%PageComponents%%


    // Page Grid
    GridLayout {
        anchors.fill: parent
        anchors.margins: Kirigami.Units.largeSpacing
        columnSpacing: Kirigami.Units.gridUnit
        columns: 2

        ShamanComponents.Section {
            scrollable: false
            Layout.preferredWidth: parent.width * 1/2
            Layout.fillWidth: true
            Layout.fillHeight: true

            Kirigami.Heading {
                Layout.fillWidth: true
                text: i18n("%%LeftSectionTitle%%")
                font.weight: 500
                level: 3
            }

            Kirigami.Separator {
                Layout.fillWidth: true
                Layout.bottomMargin: Kirigami.Units.smallSpacing
                opacity: 0.5
            }

            Item { Layout.fillHeight: true }
        }


        ShamanComponents.Section {
            scrollable: true
            Layout.preferredWidth: parent.width * 1/2


            Kirigami.Heading {
                Layout.fillWidth: true
                text: i18n("%%RightSectionTitle%%")
                font.weight: 500
                level: 3
            }

            Kirigami.Separator {
                Layout.fillWidth: true
                Layout.bottomMargin: Kirigami.Units.smallSpacing
                opacity: 0.5
            }

            Item { Layout.fillHeight: true }
        }

    }
}

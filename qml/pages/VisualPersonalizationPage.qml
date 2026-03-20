// SPDX-FileCopyrightText: 2025 Christian Tosta <https://ur.link/tosta/>
// SPDX-License-Identifier: GPL-2.0-or-later

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.formcard as FormCard

Controls.ScrollView {
    id: root

    contentWidth: availableWidth

    ColumnLayout {
        width: root.availableWidth
        spacing: 0

        FormCard.FormCard {
            Layout.fillWidth: true
            Layout.topMargin: Kirigami.Units.gridUnit

            FormCard.FormSectionText {
                text: i18n("Tema")
            }

            FormCard.FormComboBoxDelegate {
                id: themeCombo
                text: i18n("Esquema de aparência")
                description: i18n("Selecione entre tema claro ou escuro")
                model: [i18n("Claro"), i18n("Escuro"), i18n("Seguir sistema")]
                currentIndex: 2
            }

            FormCard.FormDelegateSeparator { above: themeCombo; below: colorSchemeCombo }

            FormCard.FormComboBoxDelegate {
                id: colorSchemeCombo
                text: i18n("Esquema de cores")
                description: i18n("Defina as cores de destaque da interface")
                model: [i18n("Breeze"), i18n("BreezeLight"), i18n("BreezeDark"), i18n("BreezeTwilight")]
                currentIndex: 0
            }
        }

        FormCard.FormCard {
            Layout.fillWidth: true
            Layout.topMargin: Kirigami.Units.largeSpacing

            FormCard.FormSectionText {
                text: i18n("Tipografia")
            }

            FormCard.FormSliderDelegate {
                id: fontSizeSlider
                label: i18n("Tamanho de fonte")
                value: 10
                from: 8
                to: 20
                stepSize: 1
            }
        }

        FormCard.FormCard {
            Layout.fillWidth: true
            Layout.topMargin: Kirigami.Units.largeSpacing
            Layout.bottomMargin: Kirigami.Units.gridUnit

            FormCard.FormButtonDelegate {
                icon.name: "preferences-desktop-theme-global-symbolic"
                text: i18n("Abrir Configurações de Aparência do Sistema")
                onClicked: {} // TODO: open system appearance settings via KCModule
            }
        }
    }
}

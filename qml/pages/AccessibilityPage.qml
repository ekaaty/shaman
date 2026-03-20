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
                text: i18n("Visibilidade")
            }

            FormCard.FormSwitchDelegate {
                id: highContrastSwitch
                text: i18n("Habilitar alto contraste")
                description: i18n("Aumenta o contraste da interface para melhor legibilidade")
            }

            FormCard.FormDelegateSeparator { above: highContrastSwitch; below: screenReaderSwitch }

            FormCard.FormSwitchDelegate {
                id: screenReaderSwitch
                text: i18n("Habilitar leitor de tela")
                description: i18n("Ativa o Orca para leitura em voz alta do conteúdo da tela")
            }

            FormCard.FormDelegateSeparator { above: screenReaderSwitch; below: magnificationSwitch }

            FormCard.FormSwitchDelegate {
                id: magnificationSwitch
                text: i18n("Habilitar ampliação de tela")
                description: i18n("Permite ampliar partes da tela para facilitar a leitura")
            }
        }

        FormCard.FormCard {
            Layout.fillWidth: true
            Layout.topMargin: Kirigami.Units.largeSpacing
            Layout.bottomMargin: Kirigami.Units.gridUnit

            FormCard.FormSectionText {
                text: i18n("Entrada")
            }

            FormCard.FormSliderDelegate {
                id: cursorSpeedSlider
                label: i18n("Velocidade do cursor")
                value: 5
                from: 1
                to: 10
                stepSize: 1
            }
        }
    }
}

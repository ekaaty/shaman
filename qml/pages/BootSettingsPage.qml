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
                text: i18n("Bootloader")
            }

            FormCard.FormSpinBoxDelegate {
                id: timeoutSpinBox
                label: i18n("Tempo de espera (segundos)")
                value: 5
                from: 0
                to: 60
            }

            FormCard.FormDelegateSeparator { above: timeoutSpinBox; below: defaultEntryCombo }

            FormCard.FormComboBoxDelegate {
                id: defaultEntryCombo
                text: i18n("Entrada de boot padrão")
                description: i18n("Selecione o sistema operacional padrão para inicialização")
                model: [i18n("Ekaaty Linux"), i18n("Ekaaty Linux (recuperação)"), i18n("UEFI Firmware Settings")]
                currentIndex: 0
            }
        }

        FormCard.FormCard {
            Layout.fillWidth: true
            Layout.topMargin: Kirigami.Units.largeSpacing
            Layout.bottomMargin: Kirigami.Units.gridUnit

            FormCard.FormSectionText {
                text: i18n("Opções de inicialização")
            }

            FormCard.FormSwitchDelegate {
                id: quietBootSwitch
                text: i18n("Modo silencioso (quiet boot)")
                description: i18n("Suprime mensagens do kernel durante a inicialização")
            }

            FormCard.FormDelegateSeparator { above: quietBootSwitch; below: splashSwitch }

            FormCard.FormSwitchDelegate {
                id: splashSwitch
                checked: true
                text: i18n("Splash screen habilitado")
                description: i18n("Exibe animação gráfica durante a inicialização")
            }
        }
    }
}

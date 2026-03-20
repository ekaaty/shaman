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
                text: i18n("Sistema")
            }

            FormCard.FormSwitchDelegate {
                id: autoUpdateSwitch
                text: i18n("Habilitar atualizações automáticas")
                description: i18n("Verifica e instala atualizações do sistema automaticamente")
            }

            FormCard.FormDelegateSeparator { above: autoUpdateSwitch; below: usageReportSwitch }

            FormCard.FormSwitchDelegate {
                id: usageReportSwitch
                text: i18n("Enviar relatórios de uso anônimos")
                description: i18n("Ajuda a melhorar o Ekaaty enviando dados anônimos de uso")
            }
        }

        FormCard.FormCard {
            Layout.fillWidth: true
            Layout.topMargin: Kirigami.Units.largeSpacing

            FormCard.FormSectionText {
                text: i18n("Rede")
            }

            FormCard.FormTextFieldDelegate {
                id: hostnameField
                label: i18n("Hostname")
                text: "ekaaty-desktop"
            }
        }

        FormCard.FormCard {
            Layout.fillWidth: true
            Layout.topMargin: Kirigami.Units.largeSpacing
            Layout.bottomMargin: Kirigami.Units.gridUnit

            FormCard.FormButtonDelegate {
                icon.name: "view-refresh-symbolic"
                text: i18n("Verificar atualizações agora")
                onClicked: {} // TODO: trigger update check
            }
        }
    }
}

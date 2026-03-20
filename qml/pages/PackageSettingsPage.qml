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
                text: i18n("Repositórios")
            }

            FormCard.FormSwitchDelegate {
                id: thirdPartySwitch
                text: i18n("Habilitar repositório de terceiros")
                description: i18n("Permite instalar pacotes de fontes não-oficiais")
            }

            FormCard.FormDelegateSeparator { above: thirdPartySwitch; below: flatpakSwitch }

            FormCard.FormSwitchDelegate {
                id: flatpakSwitch
                checked: true
                text: i18n("Habilitar pacotes Flatpak")
                description: i18n("Suporte a aplicativos empacotados no formato Flatpak")
            }

            FormCard.FormDelegateSeparator { above: flatpakSwitch; below: snapSwitch }

            FormCard.FormSwitchDelegate {
                id: snapSwitch
                text: i18n("Habilitar pacotes Snap")
                description: i18n("Suporte a aplicativos empacotados no formato Snap")
            }
        }

        FormCard.FormCard {
            Layout.fillWidth: true
            Layout.topMargin: Kirigami.Units.largeSpacing
            Layout.bottomMargin: Kirigami.Units.gridUnit

            FormCard.FormSectionText {
                text: i18n("Ações")
            }

            FormCard.FormButtonDelegate {
                id: manageReposButton
                icon.name: "repository-symbolic"
                text: i18n("Gerenciar repositórios")
                onClicked: {} // TODO: open repository manager
            }

            FormCard.FormDelegateSeparator { above: manageReposButton; below: installCodecsButton }

            FormCard.FormButtonDelegate {
                id: installCodecsButton
                icon.name: "applications-multimedia-symbolic"
                text: i18n("Instalar codecs multimídia")
                onClicked: {} // TODO: trigger codec installation
            }
        }
    }
}

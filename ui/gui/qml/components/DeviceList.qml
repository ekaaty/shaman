/**
 * @file DeviceList.qml
 * @brief Component linked directly to the Shaman bridge inventory.
 *
 * SPDX-FileCopyrightText: 2026 Christian Tosta
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import org.kde.kirigami as Kirigami

Item {
    id: deviceListRoot

    // Mantemos a propriedade para evitar erros de referência,
    // mas o Repeater agora bebe direto da fonte.
    property var model: null

    implicitHeight: deviceListLayout.implicitHeight
    Layout.fillWidth: true

    ColumnLayout {
        id: deviceListLayout
        anchors.fill: parent
        spacing: Kirigami.Units.mediumSpacing

        Repeater {
            // Conexão direta com a Bridge estabilizada por Array.from
            model: shaman.inventory ? Array.from(shaman.inventory) : []

            delegate: ColumnLayout {
                id: deviceItemDelegate
                Layout.fillWidth: true
                spacing: Kirigami.Units.smallSpacing

                Kirigami.Heading {
                    Layout.fillWidth: true
                    text: modelData.name || i18n("Unknown Device")
                    font.pointSize: Kirigami.Theme.smallFont.pointSize
                    font.weight: 500
                    elide: Text.ElideRight
                    level: 4
                }

                Controls.Label {
                    Layout.fillWidth: true
                    text: "<b>" + i18n("Address:") + "</b> " + (modelData.address || "N/A")
                    textFormat: Text.StyledText
                    font.pointSize: Kirigami.Theme.smallFont.pointSize
                    opacity: 0.8
                }

                Controls.Label {
                    Layout.fillWidth: true
                    text: "<b>" + i18n("Module:") + "</b> " + (modelData.module || "N/A")
                    textFormat: Text.StyledText
                    font.pointSize: Kirigami.Theme.smallFont.pointSize
                    opacity: 0.8
                }

                Kirigami.Separator {
                    Layout.fillWidth: true
                    Layout.topMargin: Kirigami.Units.smallSpacing
                    Layout.bottomMargin: Kirigami.Units.smallSpacing
                    visible: index < (parent.count - 1)
                    opacity: 0.2
                }
            }
        }
    }
}

/*
 1 . Delegate dinâmico (Otimização)                                                                                                                                                                    *

 Para evitar que a interface trave se o usuário tiver muitos dispositivos PCI, use um ListView ou Repeater com delegados enxutos dentro do seu novo Widget.

 Em vez de carregar todas as propriedades de uma vez, carregue apenas o nome.

 Use um Loader para carregar os botões de "Instalar" e "Propriedades" apenas quando o usuário clicar ou passar o mouse, economizando memória.

 2. Ações Contextuais (UX)

 No novo Widget, em vez de botões genéricos, você pode usar cores semânticas para as ações:

 Botão "Instalar": Apenas se o módulo estiver como None.

 Botão "Propriedades": Sempre visível, mas talvez como um ícone de "engrenagem" ou "info" para não poluir visualmente a lista.

 3. Alinhamento com o lado direito

 Já que o lado direito terá botões para "Device Drivers" e "Device Firmwares" (provavelmente para instalações em lote ou busca global), o seu Widget especializado no lado esquerdo pode servir como o ajuste fino.

 Lado Esquerdo: O "micro" (dispositivo por dispositivo).

 Lado Direito: O "macro" (ações globais do sistema).

 Essa separação é excelente porque atende tanto o usuário que quer apenas "instalar tudo o que falta" quanto o técnico que precisa resolver um conflito específico em um controlador de áudio ou rede.

*/

// :set ts=4:sw=4:sts=4:et:

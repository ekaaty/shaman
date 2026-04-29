import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.formcard as FormCard

import "." as ShamanComponents

ColumnLayout {
    id: factoryRoot

    property var typeMap: ({})
    property var model: null
    property var sectionModel: []
    property string description: ""
    spacing: 0

    signal componentCreated(var object)

    // Section Description
    ShamanComponents.StatusNote {
        Layout.fillWidth: true
        Layout.topMargin: 0
        text: i18n(description)
        visible: description !== ""
        opacity: 0.85
    }

    Repeater {
        id: itemRepeater
        model: factoryRoot.model ? factoryRoot.model.items : []
        delegate: ColumnLayout {
            id: itemLayout
            Layout.fillWidth: true
            visible: modelData.visible ?? true
            height: visible ? implicitHeight : 0
            clip: !visible
            spacing: 0

            readonly property var itemType: {
                let t = modelData.type || "multiselect";
                return factoryRoot.typeMap[t] || t;
            }

            FormCard.FormHeader {
                title: i18n(modelData.description
                    ? "<i>" + modelData.description + "</i>"
                    : modelData.title
                )
                opacity: modelData.description ? 0.35 : 1.0
                Layout.leftMargin: Kirigami.Units.gridUnit
                Layout.bottomMargin: Kirigami.Units.smallSpacing
            }

            Kirigami.Separator {
                Layout.fillWidth: true
                Layout.leftMargin: Kirigami.Units.gridUnit * 1.5
                Layout.bottomMargin: Kirigami.Units.smallSpacing
                opacity: 0.5
            }

            ColumnLayout {
                id: itemsLayout
                Layout.fillWidth: true
                Layout.leftMargin: Kirigami.Units.gridUnit
                spacing: Kirigami.Units.smallSpacing

                Controls.ButtonGroup {
                    id: radioGroup
                    property string currentActiveId: ""
                }

                Repeater {
                    id: itemRepeater
                    model: modelData.items
                    delegate: Loader {
                        id: itemLoader
                        Layout.fillWidth: true

                        property var itemData: modelData

                        sourceComponent: {
                            let type = itemLayout.itemType;

                            // If a component reference, use it directly
                            if (typeof type === "object") return type;

                            switch(type) {
                                case "multiselect": return checkDelegate;
                                case "oneselect":   return radioDelegate;
                                case "title"  :     return titleDelegate;
                                case "label":       return labelDelegate;
                                default:            return null;
                            }
                        }

                        // Fallback for External Component
                        source: {
                            let t = itemLayout.itemType;
                            let i = ["multiselect", "oneselect", "title", "label"];
                            if (t && typeof t === "string") {
                                // If not internal OR starts with uppercase, treat as external
                                if (!i.includes(t) || t[0] === t[0].toUpperCase()) {
                                    return t.endsWith(".qml") ? t : t + ".qml";
                                }
                            }
                            return ""; // Otherwise use internal component
                        }

                        onStatusChanged: {
                            if (status === Loader.Ready) {
                                factoryRoot.componentCreated(itemLoader.item);
                            }
                        }

                        onLoaded: {
                            if (itemLayout.itemType === "oneselect") {
                                var radioItem = itemLoader.item;
                                radioGroup.addButton(radioItem);
                                radioItem.toggled.connect(function() {
                                    if (radioItem.checked) {
                                        radioGroup.currentActiveId = itemData.id;
                                    }
                                });
                            }

                            // Universal data injection for external components
                            if (item && item.hasOwnProperty("model")) {
                                item.model = itemData;
                            }
                        }
                    }
                }
            }

            Item { Layout.preferredHeight: Kirigami.Units.largeSpacing }
        }
    }

    Component {
        id: titleDelegate
        Kirigami.Heading {
            Layout.alignment: itemData.align || Qt.AlignLeft
            elide: itemData.elide ? itemData.elide : Text.ElideNone
            level: itemData.level || 3
            text: i18n(itemData.text)
            font.pointSize: itemData.fontsize ? itemData.fontsize: 10.0
            font.weight: itemData.fontweight ? itemData.fontweight: 500
            enabled: itemData.enabled || true
        }
    }

    Component {
        id: labelDelegate
        Kirigami.Heading {
            Layout.alignment: itemData.align || Qt.AlignLeft
            text: i18n(itemData.text)
            font.pointSize: itemData.fontsize ? itemData.fontsize: 9.0
            elide: itemData.elide ? itemData.elide : Text.ElideNone
            level: itemData.level || 4
            enabled: itemData.enabled || true
        }
    }

    Component {
        id: checkDelegate
        FormCard.FormCheckDelegate {
            text: i18n(itemData.text)
            font.pointSize: itemData.fontsize ? itemData.fontsize: 9.0
            description: itemData.description
                ? "<i>" + i18n(itemData.description) + "</i>"
                : ""
            checked: itemData.checked
            enabled: itemData.enabled || true
        }
    }

    Component {
        id: radioDelegate
        FormCard.FormRadioDelegate {
            text: i18n(itemData.text)
            font.pointSize: itemData.fontsize ? itemData.fontsize: 9.0
            description: itemData.description
                ? "<i>" + i18n(itemData.description) + "</i>"
                : ""
            checked: itemData.checked || itemData.id === radioGroup.currentActiveId
            enabled: itemData.enabled || true
        }
    }

}

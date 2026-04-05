import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.formcard as FormCard

Kirigami.CardsLayout {
    id: accordionRoot

    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.preferredWidth: expandable ? -1 : Kirigami.Units.gridUnit * 20
    maximumColumns: 1

    property var model: null
    property Component delegate: null
    property bool expandable: false

    Repeater {
        model: accordionRoot.model
        delegate: FormCard.FormCard {
            id: card
            Layout.fillWidth: true
            Layout.bottomMargin: itemModel.isExpanded ? Kirigami.Units.largeSpacing : 0

            readonly property var itemModel: model

            ColumnLayout {
                Layout.alignment: Qt.AlignLeft
                Layout.preferredWidth: parent.width
                spacing: 0

                FormCard.FormButtonDelegate {
                    Layout.fillWidth: true

                    icon.name: itemModel.isExpanded ? "list-remove" : "list-add"
                    icon.color: Kirigami.Theme.linkColor

                    text: i18n(itemModel.title)
                    description: i18n(itemModel.subtitle)

                    onClicked: {
                        let targetState = !itemModel.isExpanded;

                        if (targetState === true) {
                            for (let i = 0; i < accordionRoot.model.count; ++i) {
                                accordionRoot.model.setProperty(i, "isExpanded", false);
                            }
                        }

                        itemModel.isExpanded = targetState;
                    }
                }

                Item {
                    id: collapsibleContent
                    Layout.fillWidth: true
                    clip: true

                    implicitHeight: itemModel.isExpanded
                        ? (contentLoader.implicitHeight + Kirigami.Units.gridUnit * 2)
                        : 0
                    visible: implicitHeight > 0

                    Behavior on implicitHeight {
                        NumberAnimation {
                            duration: Kirigami.Units.shortDuration
                            easing.type: Easing.InOutQuad
                        }
                    }

                    Loader {
                        id: contentLoader
                        anchors {
                            top: parent.top
                            left: parent.left
                            right: parent.right
                            margins: Kirigami.Units.gridUnit
                        }

                        sourceComponent: accordionRoot.delegate

                        onLoaded: {
                            if (item.hasOwnProperty("model")) {
                                item.model = itemModel
                            }
                        }
                    }
                }
            }
        }
    }
}

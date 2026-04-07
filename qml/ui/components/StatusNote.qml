import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import org.kde.kirigami as Kirigami

Item {
    id: root
    Layout.fillWidth: true
    Layout.topMargin: Kirigami.Units.smallSpacing * 2
    implicitHeight: mainLayout.implicitHeight + (Kirigami.Units.gridUnit * 2)

    property alias text: bodyLabel.text
    property string type: "note" // note, info, important, caution, danger

    readonly property color accentColor: {
        switch (type) {
            case "important": return Kirigami.Theme.highlightColor;
            case "caution":   return Kirigami.Theme.neutralTextColor;
            case "danger":    return Kirigami.Theme.negativeTextColor;
            case "info":      return Kirigami.Theme.highlightColor;
            default:          return Kirigami.Theme.disabledTextColor;
        }
    }

    readonly property string iconSource: {
        switch (type) {
            case "important": return "dialog-information";
            case "caution":   return "dialog-warning";
            case "danger":    return "dialog-error";
            case "info":      return "help-about";
            default:          return "document-edit";
        }
    }

    readonly property string headerTitle: {
        switch (type) {
            case "important": return i18nc("@title", "Important");
            case "caution":   return i18nc("@title", "Caution");
            case "danger":    return i18nc("@title", "Critical");
            case "info":      return i18nc("@title", "Info");
            default:          return i18nc("@title", "Note");
        }
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: Qt.alpha(accentColor, 0.05)
        radius: Kirigami.Units.smallSpacing

        Rectangle {
            id: sideBar
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 4
            color: accentColor
            topLeftRadius: background.radius
            bottomLeftRadius: background.radius
        }
    }

    ColumnLayout {
        id: mainLayout
        anchors.fill: parent
        anchors.margins: Kirigami.Units.gridUnit
        spacing: Kirigami.Units.smallSpacing / 2

        RowLayout {
            spacing: Kirigami.Units.smallSpacing
            Layout.fillWidth: true

            Kirigami.Icon {
                source: root.iconSource
                Layout.preferredWidth: Kirigami.Units.iconSizes.small
                Layout.preferredHeight: Kirigami.Units.iconSizes.small
                color: root.accentColor
            }

            Controls.Label {
                text: root.headerTitle
                font.weight: Font.Bold
                font.pointSize: Kirigami.Theme.defaultFont.pointSize
                color: root.accentColor
            }
        }

        Controls.Label {
            id: bodyLabel
            Layout.fillWidth: true
            Layout.topMargin: Kirigami.Units.smallSpacing * 2
            wrapMode: Text.WordWrap
            font.pointSize: Kirigami.Theme.defaultFont.pointSize
            color: Kirigami.Theme.textColor
            lineHeight: 1.2
        }
    }
}

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import org.kde.kirigami as Kirigami

Item {
    id: root
    Layout.fillWidth: true
    Layout.topMargin: Kirigami.Units.smallSpacing * 2
    implicitHeight: (type === "caption")
        ? mainLayout.implicitHeight + (Kirigami.Units.gridUnit)
        : mainLayout.implicitHeight + (Kirigami.Units.gridUnit * 2)

    property alias text: bodyCaption.text
    property string type: "caption" // caption, note, info, important, caution, danger

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
            case "note":      return "document-edit";
            default:          return "";
        }
    }

    readonly property string headerTitle: {
        switch (type) {
            case "important": return i18nc("@title", "Important");
            case "caution":   return i18nc("@title", "Caution");
            case "danger":    return i18nc("@title", "Critical");
            case "info":      return i18nc("@title", "Info");
            case "note":      return i18nc("@title", "Note");
            default:          return "";
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
            visible: bodyIcon.visible
        }
    }

    ColumnLayout {
        id: mainLayout
        anchors.fill: parent
        anchors.margins: Kirigami.Units.gridUnit
        spacing: Kirigami.Units.smallSpacing / 2

        RowLayout {
            id: bodyIcon
            spacing: Kirigami.Units.smallSpacing
            Layout.fillWidth: true
            visible: (root.iconSource && root.headerTitle) ? true : false

            Kirigami.Icon {
                source: root.iconSource ? root.iconSource : null
                Layout.preferredWidth: Kirigami.Units.iconSizes.small
                Layout.preferredHeight: Kirigami.Units.iconSizes.small
                color: root.accentColor
            }

            Controls.Label {
                text: root.headerTitle ? root.headerTitle : ""
                font.weight: Font.Bold
                font.pointSize: Kirigami.Theme.defaultFont.pointSize
                color: root.accentColor
            }
        }

        Controls.Label {
            id: bodyCaption
            Layout.fillWidth: true
            Layout.topMargin: bodyIcon.visible ? Kirigami.Units.smallSpacing * 2 : 0
            Layout.bottomMargin: bodyIcon.visible ? 0 : Kirigami.Units.smallSpacing * 3
            wrapMode: Text.WordWrap
            font.pointSize: Kirigami.Theme.defaultFont.pointSize
            font.italic: true
            color: Kirigami.Theme.textColor
            lineHeight: 1.2
        }
    }
}

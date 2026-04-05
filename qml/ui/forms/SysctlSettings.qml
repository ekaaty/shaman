import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.formcard as FormCard

ColumnLayout {
    id: sysctlSettings
    implicitHeight: childrenRect.height
    spacing: Kirigami.Units.smallSpacing

    // --- SECTION 1: System Responsiveness ---
    FormCard.FormHeader {
        title: i18n("System Responsiveness")
    }

    Kirigami.Separator {
        Layout.fillWidth: true
        Layout.leftMargin: Kirigami.Units.gridUnit
        Layout.rightMargin: Kirigami.Units.gridUnit
    }

    FormCard.FormCheckDelegate {
        id: swapOptimization
        text: i18n("Prefer RAM over disk")
        description: i18n("Increases RAM use over disk, significantly reducing system stutter (swappiness).")
        checked: false
    }

    FormCard.FormCheckDelegate {
        id: cacheOptimization
        text: i18n("Optimize File Browsing Speed")
        description: i18n("Increases directory caching for faster file manager response (vfs_cache_pressure).")
        checked: false
    }

    FormCard.FormCheckDelegate {
        id: backgroundWriteback
        text: i18n("Early Background Writeback")
        description: i18n("Starts flushing data to disk sooner to prevent UI freezes during heavy writes (dirty_background_ratio).")
        checked: false
    }

    // --- SECTION 2: Gaming & High-Load ---
    FormCard.FormHeader {
        title: i18n("Gaming & Large Scale Apps")
    }

    Kirigami.Separator {
        Layout.fillWidth: true
        Layout.leftMargin: Kirigami.Units.gridUnit
        Layout.rightMargin: Kirigami.Units.gridUnit
    }

    FormCard.FormCheckDelegate {
        id: gamingMemory
        text: i18n("Enhance Gaming Memory Limits")
        description: i18n("Increases memory map counts for modern games and Wine/Proton compatibility (max_map_count).")
        checked: false
    }

    FormCard.FormCheckDelegate {
        id: fileHandles
        text: i18n("Increase Global File Handles")
        description: i18n("Allows the system to handle more simultaneous open files and containers (somaxconn).")
        checked: false
    }

    // --- SECTION 3: Network Performance ---
    FormCard.FormHeader {
        title: i18n("Network & Internet Speed")
    }

    Kirigami.Separator {
        Layout.fillWidth: true
        Layout.leftMargin: Kirigami.Units.gridUnit
        Layout.rightMargin: Kirigami.Units.gridUnit
    }

    FormCard.FormCheckDelegate {
        id: tcpFastOpen
        text: i18n("Enable TCP Fast Open")
        description: i18n("Reduces latency when re-establishing connections to websites (tcp_max_syn_backlog).")
        checked: false
    }

    FormCard.FormCheckDelegate {
        id: gigabitOptimization
        text: i18n("Optimize for Gigabit Internet")
        description: i18n("Increases buffer sizes and window scaling for high-speed connections (rmem_max/wmem_max).")
        checked: false
    }
}

## @file bridge.py
#  @brief Bridge between Shaman Engine and QML Interface.
#
#  SPDX-FileCopyrightText: 2026 Christian Tosta
#  SPDX-License-Identifier: LGPL-3.0-only

from PySide6.QtCore import QObject, Slot, Property, Signal
from ...models import InventoryReport, ChannelsReport

## @class ShamanBridge
#  @brief Exposes engine data to the QML frontend.
class ShamanBridge(QObject):
    isLoadingChanged = Signal()
    hasPendingChangesChanged = Signal()
    channelsChanged = Signal()
    inventoryChanged = Signal()

    def __init__(self, engine):
        super().__init__()
        self._engine = engine
        self._is_loading = False

        self._channels_data = []
        self._channels_report = ChannelsReport()
        self._has_pending_changes = False

        self._inventory_data = []
        self._inventory_report = InventoryReport()

    @Property(bool, notify=isLoadingChanged)
    def isLoading(self):
        return self._is_loading

    def setLoading(self, value=False):
        if self._is_loading != value:
            self._is_loading = value
            self.isLoadingChanged.emit()

    def getHasPendingChanges(self):
        return self._has_pending_changes

    @Slot(bool)
    def setHasPendingChanges(self, value):
        if self._has_pending_changes != value:
            self._has_pending_changes = value
            self.hasPendingChangesChanged.emit()

    hasPendingChanges = Property(
        bool,
        fget=getHasPendingChanges,
        fset=setHasPendingChanges,
        notify=hasPendingChangesChanged
    )


    @Property(list, notify=channelsChanged)
    def channelsModel(self):
        return self._channels_data

    @Slot(str, str)
    def loadChannels(self, output="catalog", sort_by="origin"):
        """
        Fetches raw channel data from the engine and renders it
        using the ChannelsReport for QML compatibility.
        """
        manager = self._engine.PackageManager
        result = manager.list_channels()

        self._channels_data = self._channels_report.compose(result, output, sort_by)
        self.channelsChanged.emit()

    @Slot(dict)
    def applyChannelChanges(self, deltas):
        """
        Receives the updated changes from QML and persists changes to the system.
        """
        if not deltas:
            return

        self.setLoading(True)
        def worker():
            try:
                success = self._engine.PackageManager.update_channels_from_delta(deltas)
                if (success):
                    self.setHasPendingChanges(False)
                    self.loadChannels()
            except Exception as e:
                print(f"Error: {e}")
            finally:
                self.setLoading(False)

        import threading
        thread = threading.Thread(target=worker)
        thread.start()
        return True


    @Property(list, notify=inventoryChanged)
    def inventory(self):
        return self._inventory_data

    @Slot()
    def refresh_hardware(self):
        raw_data = self._engine.HardwareCollector.scan()
        self._inventory_data = self._inventory_report.render(
            raw_data,
            format="qml",
            truncate_length=60
        )
        self.inventoryChanged.emit()


# vim: set ts=4:sw=4:sts=4:et:

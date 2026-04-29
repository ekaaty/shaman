## @file __init__.py
#  @brief Unified Hardware Collector for Shaman.
#
#  SPDX-FileCopyrightText: 2026 Christian Tosta
#  SPDX-License-Identifier: LGPL-3.0-only

from .scanner import PciScanner
from .database import Database
from .modalias import Modalias
from .logs import LogCollector

## @class Hardware
#  @brief Main collector for hardware inventory and diagnostics.
class Hardware:
    def __init__(self):
        self.scanner = PciScanner() # Scans for PCI devices in sysfs
        self.db = Database()        # Reads pci.ids file for device Identification
        self.modalias = Modalias()  # Get device kernel modalias
        self.logs = LogCollector()  # Searches logs for device errors

        self.db.load()

    ## @brief Scans system and returns a list of identified hardware.
    #  @return list Objects containing address, name, module and status.
    def scan(self) -> list:
        raw_devices = self.scanner.get_raw_devices()
        inventory = []

        for dev in raw_devices:
            module = self.modalias.resolve(dev["modalias"])

            # Collects kernel errors specifically to device
            errors = self.logs.get_device_errors(dev["address"], module)

            inventory.append({
                "address": dev["address"],
                "name": self.db.get_name(dev["vendor"], dev["device"]),
                "module": module,
                "active": dev["has_driver"],
                "errors": errors
            })

        return inventory

# vim: set ts=4:sw=4:sts=4:et:

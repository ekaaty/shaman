## @file scanner.py
#  @brief Scans the PCI bus for connected devices.
#
#  SPDX-FileCopyrightText: 2026 Christian Tosta
#  SPDX-License-Identifier: LGPL-3.0-only

import os

## @class PciScanner
#  @brief Scans /sys/bus/pci/devices to retrieve raw hardware IDs.
class PciScanner:
    def __init__(self, sys_path="/sys/bus/pci/devices/"):
        self.sys_path = sys_path

    def get_raw_devices(self) -> list:
        if not os.path.exists(self.sys_path):
            return []

        devices = []
        for addr in os.listdir(self.sys_path):
            path = os.path.join(self.sys_path, addr)
            devices.append({
                "address": addr,
                "vendor": self._read_sys(path, "vendor"),
                "device": self._read_sys(path, "device"),
                "modalias": self._read_sys(path, "modalias"),
                "has_driver": os.path.exists(os.path.join(path, "driver"))
            })
        return devices

    def _read_sys(self, path, filename) -> str:
        try:
            with open(os.path.join(path, filename), "r") as f:
                content = f.read().strip()
                return content[2:] if content.startswith("0x") else content
        except OSError:
            return ""

# vim: set ts=4:sw=4:sts=4:et:

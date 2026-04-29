## @file database.py
#  @brief Parser for the PCI ID database.
#
#  SPDX-FileCopyrightText: 2026 Christian Tosta
#  SPDX-License-Identifier: LGPL-3.0-only

import os

## @class Database
#  @brief Handles pci.ids file parsing and device naming.
class Database:
    def __init__(self, path="/usr/share/hwdata/pci.ids"):
        self.path = path
        self._vendors = {}

    ## @brief Loads and parses the PCI database using match/case.
    def load(self):
        if self._vendors or not os.path.exists(self.path):
            return

        current_v = None
        try:
            with open(self.path, 'r', encoding='latin-1') as f:
                for line in f:
                    if not line.strip() or line.startswith('#'):
                        continue

                    # Determine nesting level by tab indentation
                    match line.count('\t'):
                        case 0: # Vendor
                            parts = line.split(maxsplit=1)
                            if len(parts) == 2:
                                current_v = parts[0].lower()
                                self._vendors[current_v] = {"n": parts[1].strip(), "d": {}}
                        case 1: # Device
                            if current_v:
                                parts = line.strip().split(maxsplit=1)
                                if len(parts) == 2:
                                    self._vendors[current_v]["d"][parts[0].lower()] = parts[1].strip()
                        case _:
                            continue
        except Exception:
            pass

    def get_name(self, vendor_id: str, device_id: str) -> str:
        v_info = self._vendors.get(vendor_id.lower(), {})
        v_name = v_info.get("n", f"Unknown ({vendor_id})")
        d_name = v_info.get("d", {}).get(device_id.lower(), f"Unknown ({device_id})")
        return f"{v_name} {d_name}"

# vim: set ts=4:sw=4:sts=4:et:

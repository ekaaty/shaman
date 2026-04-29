## @file resolver.py
#  @brief Domain provider for hardware-specific actions and driver resolution.
#
#  SPDX-FileCopyrightText: 2026 Christian Tosta
#  SPDX-License-Identifier: LGPL-3.0-only

import re

## @class HardwareResolver
#  @brief Analyzes hardware inventory and log errors to suggest packages.
class HardwareResolver:
    ## @brief Initializes the resolver with a package manager instance.
    #  @param package_manager The DnfManager instance for queries.
    def __init__(self, package_manager):
        self.pkg = package_manager

    ## @brief Resolves driver and firmware needs for a list of devices.
    #  @param inventory List of dictionaries from the Hardware collector.
    def resolve(self, inventory: list):
        for dev in inventory:
            suggestions = []

            # 1. Search based on journal log errors (Firmware focus)
            if dev.get('errors'):
                suggestions = self._find_by_log_evidence(dev['errors'])

            # 2. Fallback: Search by kernel module name (kmod/akmod)
            if not suggestions and dev.get('module'):
                suggestions = self.pkg.query(dev['module'], qtype="module")

            dev['suggestions'] = suggestions

    ## @brief Parses log lines to extract firmware filenames and search via radical.
    #  @param errors List of log strings.
    #  @return List of package suggestions.
    def _find_by_log_evidence(self, errors: list) -> list:
        for line in errors:
            # Regex to find firmware files: .bin, .ucode, .sfi
            match = re.search(r'([a-zA-Z0-9\-_]+\.(?:bin|ucode|sfi))', line)
            if match:
                filename = match.group(1)
                # Extract radical (e.g., 'iwlwifi-9000-pu-...' -> 'iwlwifi-9000')
                radical = filename.split('.')[0].rsplit('-', 1)[0]

                res = self.pkg.query(radical, qtype="firmware")
                if res:
                    return res
        return []

# :set ts=4:sw=4:sts=4:et:

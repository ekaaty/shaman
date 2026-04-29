## @file modalias.py
#  @brief Resolves hardware modaliases to kernel modules.
#
#  SPDX-FileCopyrightText: 2026 Christian Tosta
#  SPDX-License-Identifier: LGPL-3.0-only

import os
import re

## @class Modalias
#  @brief Handler for kernel modalias resolution.
class Modalias:
    ## @brief Resolves a PCI modalias to a kernel module name.
    #  @param alias The raw modalias string from sysfs.
    #  @return str Module name or None if not found.
    def resolve(self, alias: str) -> str | None:
        try:
            version = os.uname().release
            path = f"/lib/modules/{version}/modules.alias"

            # Extract vendor and device IDs
            match = re.search(r'pci:v0000([0-9A-Fa-f]+)d0000([0-9A-Fa-f]+)', alias)
            if not match:
                return None

            target = f"v0000{match.group(1)}d0000{match.group(2)}".upper()

            if os.path.exists(path):
                with open(path, 'r') as f:
                    for line in f:
                        if target in line.upper():
                            return line.split()[-1]
        except Exception:
            pass
        return None

# vim: set ts=4:sw=4:sts=4:et:

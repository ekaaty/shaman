## @file distro.py
#  @brief System distribution identification collector.
#
#  SPDX-FileCopyrightText: 2026 Christian Tosta
#  SPDX-License-Identifier: LGPL-3.0-only

import os

## @class Distro
#  @brief Singleton class for system distribution identification.
#  @details Parses os-release files to provide unified metadata across the framework.
class Distro:
    _instance = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(Distro, cls).__new__(cls)
            cls._instance._initialized = False
        return cls._instance

    def __init__(self):
        if self._initialized:
            return

        self.id = "generic"
        self.id_like = []
        self.name = "Unknown OS"
        self.cpe_name = ""
        self.version_id = ""
        self.pretty_name = ""

        self._detect_distro()
        self._initialized = True

    ## @brief Detects distribution details using structural pattern matching.
    #  @details Reads standard os-release paths and maps keys to class attributes.
    def _detect_distro(self):
        release_paths = ["/etc/os-release", "/usr/lib/os-release"]
        path = next((p for p in release_paths if os.path.exists(p)), None)

        if not path:
            return

        try:
            with open(path, "r") as f:
                for line in f:
                    if "=" not in line:
                        continue

                    key, value = line.strip().split("=", 1)
                    value = value.strip('"').strip("'")

                    match key:
                        case "ID":
                            self.id = value
                        case "ID_LIKE":
                            self.id_like = value.split()
                        case "NAME":
                            self.name = value
                        case "CPE_NAME":
                            self.cpe_name = value
                        case "VERSION_ID":
                            self.version_id = value
                        case "PRETTY_NAME":
                            self.pretty_name = value
                        case _:
                            continue
        except Exception:
            pass

    ## @brief Checks if the current OS is a variant of a given distro.
    #  @param name String to match against ID or ID_LIKE.
    #  @return bool True if match is found.
    def is_variant(self, name):
        return name == self.id or name in self.id_like

    ## @brief Normalizes CPE string to 2.3 format.
    #  @return str Valid CPE 2.3 string.
    def get_cpe(self):
        if not self.cpe_name:
            return "cpe:2.3:o:generic:generic:*:*:*:*:*:*:*:*"

        # Cleanup and split legacy URI
        parts = self.cpe_name.replace("cpe:/", "").replace("cpe://", "").split(":")

        # Ensure 10 components for 2.3 specification compliance
        res = (parts + ["*"] * 10)[:10]
        return f"cpe:2.3:o:{':'.join(res)}"

# vim: set ts=4:sw=4:sts=4:et:

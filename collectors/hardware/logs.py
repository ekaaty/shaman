## @file logs.py
#  @brief Journalctl log collector for hardware errors.
#
#  SPDX-FileCopyrightText: 2026 Christian Tosta
#  SPDX-License-Identifier: LGPL-3.0-only

import subprocess

class LogCollector:
    ## @brief Patterns that indicate hardware-related failures.
    FAILURE_KEYWORDS = [
        "failed", "error", "timeout", "firmware: failed",
        "exception", "refused", "not responding"
    ]

    ## @brief Searches logs for errors related to a specific device.
    #  @param address The PCI address (e.g., 0000:00:14.3).
    #  @param module The kernel module name (e.g., iwlwifi).
    #  @return list of error strings.
    def get_device_errors(self, address, module):
        unique_errors = set()

        # Build query for address or module
        query = f"{address}"
        if module:
            query += f"|{module}"

        try:
            # Query priority 3 (errors) for the current boot
            cmd = ["journalctl", "-b", "--priority=3..4", "--no-pager"]
            output = subprocess.check_output(cmd, text=True, stderr=subprocess.DEVNULL)

            for line in output.splitlines():
                if (address in line or (module and module in line)) and \
                   any(kw in line.lower() for kw in self.FAILURE_KEYWORDS):

                    # Clean the line: remove timestamp, hostname, and process info
                    # Standard systemd format: "Date Time Host Process[PID]: Message"
                    if "]: " in line:
                        msg = line.split("]: ", 1)[1].strip()
                    elif ": " in line:
                        msg = line.split(": ", 1)[-1].strip()
                    else:
                        msg = line.strip()

                    unique_errors.add(msg)

        except Exception:
            return ["Unable to access journalctl logs"]

        return sorted(list(unique_errors))

# vim: set ts=4:sw=4:sts=4:et:

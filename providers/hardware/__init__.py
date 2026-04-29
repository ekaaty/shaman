## @file providers/hardware/__init__.py
#  @brief Package initialization for hardware resolution services.
#
#  SPDX-FileCopyrightText: 2026 Christian Tosta
#  SPDX-License-Identifier: LGPL-3.0-only

from .resolver import HardwareResolver

## @class HardwareProvider
#  @brief Domain-specific provider for hardware diagnostic and resolution.
class HardwareProvider:
    def __init__(self, dnf_manager):
        self.resolver = HardwareResolver(dnf_manager)

    def resolve(self, inventory: list):
        return self.resolver.resolve(inventory)

# vim: set ts=4:sw=4:sts=4:et:

## @file providers/__init__.py
#  @brief Entry point for the Shaman providers hierarchy.
#
#  SPDX-FileCopyrightText: 2026 Christian Tosta
#  SPDX-License-Identifier: LGPL-3.0-only

from .hardware import HardwareProvider
from .package import PackageProvider
from .performance import PerformanceProvider
from .security import SecurityProvider

## @class Providers
#  @brief Container class to provide structured access to system managers.
class Providers:
    ## @brief Initializes all domain providers.
    #  Note: PackageProvider self-configures its manager via factory.
    def __init__(self):
        self.package = PackageProvider()
        # Hardware needs the package manager to query for drivers/firmware
        self.hardware = HardwareProvider(self.package.manager)
        self.performance = PerformanceProvider()
        self.security = SecurityProvider()

# vim: set ts=4:sw=4:sts=4:et:

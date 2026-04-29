## @file base.py
#  @brief Abstract base class for package managers.
#
#  SPDX-FileCopyrightText: 2026 Christian Tosta
#  SPDX-License-Identifier: LGPL-3.0-only

from abc import ABC, abstractmethod

## @class BaseManager
#  @brief Interface for distribution-specific package managers.
class BaseManager(ABC):
    def __init__(self, distro_config):
        self.config = distro_config

    @abstractmethod
    def install(self, packages: list) -> bool:
        """Execute installation of a package list."""
        pass

    @abstractmethod
    def remove(self, packages: list) -> bool:
        """Execute removal of a package list."""
        pass

    @abstractmethod
    def query(self, term: str, strategy: str = "repoquery",
              namespace: str = None, qtype: str = None) -> list:
        """Search for packages matching the query."""
        pass

    @abstractmethod
    def list(self, package: str) -> bool:
        """Lists a specific package with its status."""
        pass

# vim: set ts=4:sw=4:sts=4:et:

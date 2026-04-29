## @file __init__.py
#  @brief Clean factory for package providers.
#
#  SPDX-FileCopyrightText: 2026 Christian Tosta
#  SPDX-License-Identifier: LGPL-3.0-only

from ...collectors import Distro
from .managers.dnf import DnfManager
from .policies.ekaaty import EkaatyPolicy
from .policies.fedora import FedoraPolicy

## @class PackageProvider
#  @brief Domain provider for the Package Manager.
class PackageProvider:
    ## @brief Initializes the provider and auto-configures the manager.
    def __init__(self):
        self.manager = self.get_manager()

    ## @brief Factory method to retrieve the correct manager based on distro.
    #  @return DnfManager instance with appropriate policy.
    def get_manager(self):
        dist = Distro()

        match dist.id:
            case "ekaaty": return DnfManager(EkaatyPolicy())
            case "fedora": return DnfManager(FedoraPolicy())
            case _:
                raise NotImplementedError(f"System {dist.id} not supported.")

    ## @brief Forward the channel listing to the internal manager.
    def list_channels(self, channels=None, state="all"):
        return self.manager.list_channels(channels, state)

    ## @brief Forward the channel update to the internal manager.
    #  @return tuple (bool, error_message)
    def set_channels(self, channels, state="enable"):
        return self.manager.set_channels(channels, state)

    ## @brief Forwards the channels delta dictionary to the internal manager.
    def update_channels_from_delta(self, deltas):
        return self.manager.update_channels_from_delta(deltas)

    ## @brief Handles installation of software packages.
    def manage_software(self):
        # self.manager.mark_install()
        # self.manager.mark_remove()
        # self.manager.commit()
        pass

# vim: set ts=4:sw=4:sts=4:et:

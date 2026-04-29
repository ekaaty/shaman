## @file ekaaty.py
#  @brief Ekaaty Linux distribution policy.
#
#  SPDX-FileCopyrightText: 2026 Christian Tosta
#  SPDX-License-Identifier: LGPL-3.0-only

from .fedora import FedoraPolicy

## @class EkaatyPolicy
#  @brief Policy configurations for the Ekaaty Linux ecosystem.
class EkaatyPolicy(FedoraPolicy):
    def __init__(self):
        super().__init__()
        self.name = "Ekaaty Linux"
        self.config['enabled_channels'] = [
            "fedora", "updates",
            "copr:copr.fedorainfracloud.org:ekaaty:core",
            "copr:copr.fedorainfracloud.org:ekaaty:kde-extras"
        ]

    ## @brief Returns specific flags for Ekaaty.
    def get_flags(self) -> list:
        # For now inherits the flags from Fedora
        return super().get_flags()

# vim: set ts=4:sw=4:sts=4:et:

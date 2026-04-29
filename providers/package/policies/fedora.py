## @file fedora.py
#  @brief Fedora Linux distribution policy.
#
#  SPDX-FileCopyrightText: 2026 Christian Tosta
#  SPDX-License-Identifier: LGPL-3.0-only

from .base import DistroPolicy

class FedoraPolicy(DistroPolicy):
    def __init__(self):
        super().__init__()
        self.name = "Fedora Linux"

        self.config['query_scopes'] = {
            "hardware": ["kernel-modules*", "*firmware*", "kmod-*", "akmod-*"],
            "software": ["*"]
        }

        self.config['query_strategies'] = {
            "search"    : ["search"],
            "repoquery" : ["repoquery"]
        }

        self.config['query_types'] = {
            "firmware"  : ["*%s*firmware*", "*firmware*%s*"],
            "module"    : ["kmod-%s*", "akmod-%s*"],
            "term"      : ["*%s*"]
        }

        self.config['query_filters'] = {
            "firmware"  : [r".*firmware.*"],
            "module"    : [r".*"],
            "pcidevice" : [r".*"]
        }

    def get_flags(self) -> list:
        return ["--setopt=install_weak_deps=False"]

# vim: set ts=4:sw=4:sts=4:et:

## @file base.py
#  @brief Base class for distribution policies.
#
#  SPDX-FileCopyrightText: 2026 Christian Tosta
#  SPDX-License-Identifier: LGPL-3.0-only

class DistroPolicy:
    def __init__(self):
        self.name = "Generic"
        self.config = {}

    def get_flags(self) -> list:
        return []

# vim: set ts=4:sw=4:sts=4:et:

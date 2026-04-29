## @file __init__.py
#  @brief Package initializer for system collectors.
#
#  SPDX-FileCopyrightText: 2026 Christian Tosta
#  SPDX-License-Identifier: LGPL-3.0-only

from .distro import Distro
from .hardware import Hardware

__all__ = ["Distro", "Hardware"]

# vim: set ts=4:sw=4:sts=4:et:

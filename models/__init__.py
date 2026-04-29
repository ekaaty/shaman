## @file __init__.py
#  @brief CLI Report generators exporter.
#
#  SPDX-FileCopyrightText: 2026 Christian Tosta
#  SPDX-License-Identifier: LGPL-3.0-only

from .inventory import InventoryReport
from .channels import ChannelsReport
# from .software import SoftwareReport

REPORTS = {
    "inventory" : InventoryReport,
    "channels" : ChannelsReport,
    #"software"  : SoftwareReport,
}

__all__ = [
    "InventoryReport",
    "ChannelsReport",
    #"SoftwareReport",
]

# vim: set ts=4:sw=4:sts=4:et:

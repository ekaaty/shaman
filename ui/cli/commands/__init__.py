## @file ui/cli/commands/__init__.py
#  @brief Commands exporter for the Command Line Interface.
#
#  SPDX-FileCopyrightText: 2026 Christian Tosta
#  SPDX-License-Identifier: LGPL-3.0-only

from .channel import register_parser as reg_channel, handle_channel
from .hardware import register_parser as reg_hw, handle_hardware
from .software import register_parser as reg_sw, handle_software
from .security import register_parser as reg_sec, handle_security
from .perf import register_parser as reg_perf, handle_perf
from .version import register_parser as reg_ver, handle_version

## @brief Dictionary for automation into CLI.
#  Maps the command name to its registration and execution functions.
COMMANDS = {
    "channel": {"reg": reg_channel, "handle": handle_channel},
    "hardware": {"reg": reg_hw, "handle": handle_hardware},
    "software": {"reg": reg_sw, "handle": handle_software},
    "security": {"reg": reg_sec, "handle": handle_security},
    "perf": {"reg": reg_perf, "handle": handle_perf},
    "version": {"reg": reg_ver, "handle": handle_version},
}

# vim: set ts=4:sw=4:sts=4:et:

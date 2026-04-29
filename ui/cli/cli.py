## @file ui/cli/cli.py
#  @brief Orchestrator for the Command Line Interface.
#
#  SPDX-FileCopyrightText: 2026 Christian Tosta
#  SPDX-License-Identifier: LGPL-3.0-only

import argparse
#from ...engine import Engine
from .commands import COMMANDS

class CLI:
    def __init__(self, engine):
        self.engine = engine
        self.parser = argparse.ArgumentParser(prog="shaman", description="System orchestrator")
        self._build_parsers()

    def _build_parsers(self):
        subparsers = self.parser.add_subparsers(dest="command")
        # Register each command dynamically
        for cmd_info in COMMANDS.values():
            cmd_info["reg"](subparsers)

    def run(self):
        args = self.parser.parse_args()
        if not args.command:
            self.parser.print_help()
            return

        # Calls correspondent handler
        if args.command in COMMANDS:
            COMMANDS[args.command]["handle"](self.engine, args, self.parser)

# vim: set ts=4:sw=4:sts=4:et:

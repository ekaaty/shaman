## @file version.py
#  @brief Version command handler for Shaman CLI.
#
#  SPDX-FileCopyrightText: 2026 Christian Tosta
#  SPDX-License-Identifier: LGPL-3.0-only

# Import directly from metadata to avoid circular dependency with root __init__.py
from ....__metadata__ import APPLICATION_NAME, APPLICATION_VERSION

## @brief Registers the arguments for the 'version' command.
#  @param subparsers The subparsers object from ArgumentParser.
def register_parser(subparsers):
    subparsers.add_parser("version", help="Show application version")

## @brief Handles the execution of the version command.
#  @param engine The core Engine instance.
#  @param args The parsed arguments from CLI.
#  @param parser The main ArgumentParser for help fallback.
def handle_version(engine, args, parser):
    print(f"{APPLICATION_NAME} version {APPLICATION_VERSION}")

# vim: set ts=4:sw=4:sts=4:et:

## @file software.py
#  @brief Extra software command handler for Shaman CLI.
#
#  SPDX-FileCopyrightText: 2026 Christian Tosta
#  SPDX-License-Identifier: LGPL-3.0-only

## @brief Registers the arguments for the 'software' command.
#  @param subparsers The subparsers object from ArgumentParser.
def register_parser(subparsers):
    sw_p = subparsers.add_parser("software", help="Extra software management")
    sw_p.add_argument("action", choices=["list", "install", "remove"], nargs="?")
    sw_p.add_argument("software_list", nargs="*", help="List of software to manage")

## @brief Handles the execution of software commands.
#  @param engine The core Engine instance.
#  @param args The parsed arguments from CLI.
#  @param parser The main ArgumentParser for help fallback.
def handle_software(engine, args, parser):
    if not args.action:
        parser.parse_args(['software', '--help'])
        return

    # engine.PackageManager.manage_software(args.action, args.software_list)
    pass

# vim: set ts=4:sw=4:sts=4:et:

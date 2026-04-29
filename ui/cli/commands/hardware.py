## @file hardware.py
#  @brief Hardware diagnostic and driver command handler for Shaman CLI.
#
#  SPDX-FileCopyrightText: 2026 Christian Tosta
#  SPDX-License-Identifier: LGPL-3.0-only

from ....models import InventoryReport

## @brief Registers the arguments for the 'hardware' command and its subcommands.
#  @param subparsers The subparsers object from ArgumentParser.
def register_parser(subparsers):
    hw_p = subparsers.add_parser("hardware", help="Hardware diagnostics and drivers")
    hw_sub = hw_p.add_subparsers(dest="subcommand")

    # inventory {show} [--json] [--yaml]
    inv_p = hw_sub.add_parser("inventory", help="Hardware inventory tools")
    inv_p.add_argument("action", choices=["show"], nargs="?")

    # Group for mutual exclusivity (can't be text, json and yaml at the same time)
    fmt_group = inv_p.add_mutually_exclusive_group()
    fmt_group.add_argument("--json", action="store_const", const="json", dest="format",
                           help="Output in JSON format")
    fmt_group.add_argument("--yaml", action="store_const", const="yaml", dest="format",
                           help="Output in YAML format")
    fmt_group.add_argument("--text", action="store_const", const="text", dest="format",
                           help="Output in pure text format")
    inv_p.set_defaults(format="text")

    # driver/firmware {list, install, remove, upgrade}
    for hw_type in ["driver", "firmware"]:
        item_p = hw_sub.add_parser(hw_type, help=f"Manage system {hw_type}s")
        item_p.add_argument("action", choices=["list", "install", "remove", "upgrade"], nargs="?")
        item_p.add_argument("target", nargs="?", help=f"Specific {hw_type} name")

## @brief Handles the execution of hardware commands.
#  @param engine The core Engine instance.
#  @param args The parsed arguments from CLI.
#  @param parser The main ArgumentParser for help fallback.
def handle_hardware(engine, args, parser):
    if not args.subcommand:
        parser.parse_args(['hardware', '--help'])
        return

    match args.subcommand:
        case "inventory":
            if not args.action:
                parser.parse_args(['hardware', 'inventory', '--help'])
                return

            # Logic: Collect
            inventory = engine.HardwareCollector.scan()

            # UI: Render with selected format (text, json or yaml)
            InventoryReport().render(inventory, format=args.format)

        case "driver" | "firmware":
            if not args.action:
                parser.parse_args(['hardware', args.subcommand, '--help'])
                return
            # engine.HardwareManager.handle_action(args.subcommand, args.action, args.target)
            pass

# vim: set ts=4:sw=4:sts=4:et:

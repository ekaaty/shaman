## @file channel.py
#  @brief Software channel command handler for Shaman CLI.
#
#  SPDX-FileCopyrightText: 2026 Christian Tosta
#  SPDX-License-Identifier: LGPL-3.0-only

from ....models import ChannelsReport

## @brief Registers the arguments for the 'channel' command.
#  @param subparsers The subparsers object from ArgumentParser.
def register_parser(subparsers):
    channel_p = subparsers.add_parser("channel", help="Software channel management")
    channel_p.add_argument("action", choices=["list", "enable", "disable"], nargs="?")
    channel_p.add_argument("channels", nargs="*", help="Channel IDs")
    channel_p.add_argument("--json", action="store_const", const="json", dest="format")

    group = channel_p.add_mutually_exclusive_group()
    group.add_argument("--all", action="store_const", const="all", dest="state", default="all")
    group.add_argument("--enabled", action="store_const", const="enabled", dest="state")
    group.add_argument("--disabled", action="store_const", const="disabled", dest="state")

## @brief Handles the execution of software channel commands.
#  @param engine The core Engine instance.
#  @param args The parsed arguments from CLI.
#  @param parser The main ArgumentParser for help fallback.
def handle_channel(engine, args, parser):
    if not args.action:
        parser.parse_args(['channel', '--help'])
        return

    report = ChannelsReport()
    manager = engine.PackageManager

    match args.action:
        case "list":
            output_format = args.format if args.format else "terminal"
            result = manager.list_channels(channels=args.channels, state=args.state)
            output = report.compose(result, output=output_format)

        case "enable" | "disable":
            if not args.channels:
                print("Error: Must provide at least one channel ID.")
                return
            manager.set_channels(args.channels, state=args.action)

# vim: set ts=4:sw=4:sts=4:et:

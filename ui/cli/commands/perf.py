## @file perf.py
#  @brief Performance tuning command handler for Shaman CLI.
#
#  SPDX-FileCopyrightText: 2026 Christian Tosta
#  SPDX-License-Identifier: LGPL-3.0-only

## @brief Registers the arguments for the 'perf' command.
#  @param subparsers The subparsers object from ArgumentParser.
def register_parser(subparsers):
    perf_p = subparsers.add_parser("perf", help="Performance tuning")
    perf_p.add_argument("action", choices=["show", "edit", "apply"], nargs="?")
    perf_p.add_argument("target", choices=["bootparam", "profile", "sysctl"], nargs="?")

## @brief Handles the execution of performance commands.
#  @param engine The core Engine instance.
#  @param args The parsed arguments from CLI.
#  @param parser The main ArgumentParser for help fallback.
def handle_perf(engine, args, parser):
    if not args.action or not args.target:
        parser.parse_args(['perf', '--help'])
        return

    # engine.PerformanceManager.handle(args.action, args.target)
    pass

# vim: set ts=4:sw=4:sts=4:et:

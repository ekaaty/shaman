## @file security.py
#  @brief Security hardening command handler for Shaman CLI.
#
#  SPDX-FileCopyrightText: 2026 Christian Tosta
#  SPDX-License-Identifier: LGPL-3.0-only

## @brief Registers the arguments for the 'security' command.
#  @param subparsers The subparsers object from ArgumentParser.
def register_parser(subparsers):
    sec_p = subparsers.add_parser("security", help="System hardening")
    sec_p.add_argument("action", choices=["show", "edit", "apply"], nargs="?")
    sec_p.add_argument("policy_list", nargs="*", help="Security policies to manage")

## @brief Handles the execution of security commands.
#  @param engine The core Engine instance.
#  @param args The parsed arguments from CLI.
#  @param parser The main ArgumentParser for help fallback.
def handle_security(engine, args, parser):
    if not args.action:
        parser.parse_args(['security', '--help'])
        return

    # engine.SecurityManager.handle(args.action, args.policy_list)
    pass

# vim: set ts=4:sw=4:sts=4:et:

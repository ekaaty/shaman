## @file __main__.py
#  @brief Entry point for Shaman.
#
#  SPDX-FileCopyrightText: 2026 Christian Tosta
#  SPDX-License-Identifier: LGPL-3.0-only

import sys

from .engine import Engine
from . import CLI
from . import GUI

## @brief Executable run function.
def run():
    engine = Engine()

    try:
        app = CLI(engine) if len(sys.argv) > 1 else GUI(engine)
        app.run()
    except KeyboardInterrupt:
        print("\nOperation cancelled by user.")
        sys.exit(0)
    except Exception as e:
        print(f"Critical error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    run()

# vim: set ts=4:sw=4:sts=4:et:

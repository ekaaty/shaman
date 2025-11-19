# SPDX-FileCopyrightText: 2025 Christian Tosta
# SPDX-License-Identifier: GPL-2.0-or-later
# Vim modeline: :set ts=4:sw=4:sts=4:et

# Metadata (Injected via CMake in metadata.py)
from .metadata import APPLICATION_NAME, ORGANIZATION_NAME, APPLICATION_VERSION
__version__ = APPLICATION_VERSION
__appname__ = APPLICATION_NAME

# Entry Point
from .__main__ import run


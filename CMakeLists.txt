# SPDX-FileCopyrightText: 2025 Christian Tosta
# SPDX-License-Identifier: GPL-2.0-or-later

cmake_minimum_required(VERSION 3.21)

# --- Versioning and Metadata ---
file(READ "${CMAKE_CURRENT_SOURCE_DIR}/VERSION" SHAMAN_VERSION TRIM)
string(REPLACE "\n" "" SHAMAN_VERSION "${SHAMAN_VERSION}")
string(REPLACE "\r" "" SHAMAN_VERSION "${SHAMAN_VERSION}")

set(VERSION_REGEX "^(\\d+)\\.(\\d+)\\.(\\d+)")
string(REGEX REPLACE ${VERSION_REGEX} "\\1" SHAMAN_VERSION_MAJOR "${SHAMAN_VERSION}")
string(REGEX REPLACE ${VERSION_REGEX} "\\2" SHAMAN_VERSION_MINOR "${SHAMAN_VERSION}")
string(REGEX REPLACE ${VERSION_REGEX} "\\3" SHAMAN_VERSION_PATCH "${SHAMAN_VERSION}")

project(shaman VERSION ${SHAMAN_VERSION})
set(APPLICATION_ID "com.ekaaty.shaman")
set(ORGANIZATION_NAME "Ekaaty")
set(ORGANIZATION_DOMAIN "ekaaty.com")

include(GNUInstallDirs)

# Generate src/python/metadata.py from the template
configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/__metadata__.py.in"
    "${CMAKE_CURRENT_BINARY_DIR}/__metadata__.py"
    @ONLY
)

# --- Build Configuration ---
if(NOT CMAKE_GENERATOR)
    set(CMAKE_GENERATOR "Ninja" CACHE STRING "Set build generator" FORCE)
endif()

# --- Dependencies Discovery ---
find_package(Python3 REQUIRED COMPONENTS Interpreter)
find_package(Qt6 REQUIRED COMPONENTS Core Qml Quick)
find_package(PySide6 6.5 REQUIRED COMPONENTS Core Qml)
find_package(KF6KirigamiPlatform REQUIRED)
find_package(KF6Config REQUIRED)


# =========================================================================
# --- Installation Rules ---
# =========================================================================

install(DIRECTORY collectors models providers ui
    DESTINATION ${KDE_INSTALL_DATADIR}/${PROJECT_NAME}
    PATTERN "__pycache__" EXCLUDE
)

install(FILES
    "__init__.py"
    "__main__.py"
    "engine.py"
    "${CMAKE_CURRENT_BINARY_DIR}/__metadata__.py"
    DESTINATION ${KDE_INSTALL_DATADIR}/${PROJECT_NAME}
)

install(DIRECTORY data
    DESTINATION ${KDE_INSTALL_DATADIR}/${PROJECT_NAME}
    PATTERN "*.todo" EXCLUDE
)

# Create and install the executable PYTHON wrapper
set(SHAMAN_WRAPPER_CONTENT
"#!/usr/bin/env python3
import sys
import os

current_dir = os.path.dirname(os.path.abspath(__file__))
project_dir = os.path.join(os.path.dirname(current_dir), r'${KDE_INSTALL_DATADIR}')

sys.path.insert(0, project_dir)
from ${PROJECT_NAME}.__main__ import run

if __name__ == '__main__':
    run()
"
)

set(SHAMAN_WRAPPER_FILE "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}")
file(WRITE ${SHAMAN_WRAPPER_FILE} ${SHAMAN_WRAPPER_CONTENT})

install(PROGRAMS ${SHAMAN_WRAPPER_FILE}
    DESTINATION bin
)

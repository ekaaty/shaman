## @file utils.py
#  @brief System utilities and command runners for DNF manager.
#
#  SPDX-FileCopyrightText: 2026 Christian Tosta
#  SPDX-License-Identifier: LGPL-3.0-only

import os
import subprocess

def _run_dnf_cmd(args: list, privileged: bool = False) -> tuple:
    """!
    @brief Executes a DNF command with the --assumeyes flag.
    @param args List of arguments to append to the base DNF command.
    @return Tuple containing (success: bool, output: str).
    """
    base_cmd = ["dnf", "--assumeyes"]
    cmd = (["pkexec"] + base_cmd) if privileged else base_cmd
    try:
        cmd.extend(args)
        result = subprocess.run(cmd, capture_output=True, text=True)
        return (result.returncode == 0, result.stdout
                if result.returncode == 0 else result.stderr.strip())
    except Exception as e:
        return (False, str(e))

def _run_bootstrap_cmd(command: str) -> bool:
    """!
    @brief Executes a bootstrap shell command to install or configure a repository.
    @param command The shell command string to be executed.
    @return True if the command exited with 0, False otherwise.
    """
    try:
        # shell=True is used because bootstrap commands often contain pipes or redirects
        # for shell commands, pkexec must envolve the interpreter or the full command:
        privileged_command = f"pkexec sh -c '{command}'"
        subprocess.run(privileged_command, shell=True, check=True, capture_output=True)
        return True
    except (subprocess.CalledProcessError, OSError):
        return False

def _get_catalog_path() -> str:
    """!
    @brief Recursively searches for the Shaman catalog data directory.
    @details Traverses parent directories to locate 'shaman/data/channels'.
    @return Absolute path to the catalog directory or default system path.
    """
    current_dir = os.path.dirname(os.path.abspath(__file__))
    while current_dir != os.path.dirname(current_dir):
        for path in [os.path.join(current_dir, "shaman", "data", "channels"),
                     os.path.join(current_dir, "data", "channels")]:
            if os.path.isdir(path): return path
        current_dir = os.path.dirname(current_dir)
    return "/usr/share/shaman/data/channels"

# vim :set ts=4:sw=4:sts=4:et:

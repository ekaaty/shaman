## @file manager.py
#  @brief Main DnfManager implementation for package operations.
#
#  SPDX-FileCopyrightText: 2026 Christian Tosta
#  SPDX-License-Identifier: LGPL-3.0-only

import re
import subprocess
from ..base import BaseManager
from .channels import ChannelMixin
from .utils import _run_dnf_cmd

class DnfManager(BaseManager, ChannelMixin):
    def __init__(self, policy):
        super().__init__(policy)
        self.policy = policy
        self._init_distro()

    def _init_distro(self):
        conf = self.policy.config

    def query(self, term: str, strategy: str = "repoquery", namespace: str = None, qtype: str = None) -> list:
        pass

    """!
        conf = self.policy.config
        target = conf['query_namespaces'][namespace][0] % term if namespace else term

        cmd = ["dnf", "-qC"] + conf['query_strategies'].get(strategy, ["search"]) + [target]
        if namespace:
            cmd.extend(conf.get('query_scopes', {}).get('hardware', []))

        success, stdout = self._run_command(cmd)
        if not success or not stdout:
            return []

        output = stdout.splitlines()
        filter_key = namespace if namespace in conf['query_filters'] else qtype

        if filter_key in conf['query_filters']:
            pattern = conf['query_filters'][filter_key][0]
            output = [line for line in output if re.search(pattern, line)]

        return sorted(list(set(output)))
    """

    def list(self, pkgs: list, criteria: str = "installed") -> list:
        results = []
        for pkg in pkgs:
            success, _ = self._run_dnf_cmd(["list"] + ["f--{criteria}", pkg])
            status = "found" if success else "not_found"
            results.append(f"{pkg}:{status}")
        return results

    def install(self, packages: list) -> bool:
        if not packages: return True
        return _run_dnf_cmd(["install"] + self.policy.get_flags() + packages)[0]

    def remove(self, packages: list) -> bool:
        if not packages: return True
        return _run_dnf_cmd(["remove"] + self.policy.get_flags() + packages)[0]

# vim: set ts=4:sw=4:sts=4:et:

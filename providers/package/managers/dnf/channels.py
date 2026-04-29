## @file channels.py
#  @brief Repository and channel management logic for DNF.
#
#  SPDX-FileCopyrightText: 2026 Christian Tosta
#  SPDX-License-Identifier: LGPL-3.0-only

import json
import os
from .utils import _get_catalog_path, _run_dnf_cmd, _run_bootstrap_cmd

class ChannelMixin:
    """!
    @brief Mixin class for DNF channel and repository management.
    @details Provides methods to list, filter, and synchronize system repositories with a local catalog.
    """

    def list_channels(self, channels: list = None, state: str = "all") -> list:
        """!
        @brief Lists and synchronizes channels between DNF and the local catalog.
        @param channels Optional list of channel IDs to filter the search.
        @param state Filter state: "all", "enabled", or "disabled".
        @return A list of dictionaries containing unified channel data.
        """
        dnf_channels = {ch['id']: ch for ch in self._dnf_repolist(state="all", args=channels)}
        catalog = self._load_catalog()

        # Define catalog keys to process (filter or total)
        catalog_set = set(channels).intersection(catalog.keys()) if channels else catalog.keys()

        channels_list = []
        processed_ids = set()

        # Unify catalog with real system data
        for cid in catalog_set:
            dnf_ch = dnf_channels.get(cid, {})
            channels_list.append({**catalog[cid], **dnf_ch, 'installed': cid in dnf_channels})
            processed_ids.add(cid)

        # Add system repositories missing from catalog (manual/external)
        for cid, dnf_ch in dnf_channels.items():
            if cid not in processed_ids:
                channels_list.append({**dnf_ch, 'installed': True})

        return self._filter_channels(channels_list, state)

    def update_channels_from_delta(self, deltas: dict) -> bool:
        """!
        @brief Parses the delta dictionary and applies changes via set_channels.
        @param deltas Dictionary in the format { "channel_id": bool_state }.
        @return True if all operations succeeded, False otherwise.
        """
        if not deltas:
            return True

        to_enable = [cid for cid, state in deltas.items() if state is True]
        to_disable = [cid for cid, state in deltas.items() if state is False]

        success = True

        if to_enable:
            if not self.set_channels(to_enable, state="enable"):
                success = False

        if to_disable:
            if not self.set_channels(to_disable, state="disable"):
                success = False

        return success

    def set_channels(self, channels: list, state: str = "enable") -> bool:
        """!
        @brief Configures channels and handles all success/error output.
        @param channels List of strings (IDs or wildcards).
        @param state "enable" or "disable".
        @return True if successful, False otherwise.
        """
        dnf_channels = {ch['id']: ch for ch in self._dnf_repolist(state="all", args=channels)}
        catalog = self._load_catalog()

        to_configure = []
        for cid in channels:
            if "*" in cid: # If wildcard, ignores bootstrap and pass to DNF
                to_configure.append(cid)
                continue

            # If channel exists on catalog but inexists in the system, try to bootstrap it
            if cid not in dnf_channels and cid in catalog:
                bootstrap_cmd = catalog[cid].get("bootstrap")
                if bootstrap_cmd:
                    if not _run_bootstrap_cmd(bootstrap_cmd):
                        print(f"Failed to bootstrap channel: {cid}")
                        return False
            to_configure.append(cid)

        if to_configure:
            val = "1" if state == "enable" else "0"

            dnf_cmd = ["config-manager", "setopt"]
            dnf_args = dnf_cmd + [f"{cid}.enabled={val}" for cid in to_configure]

            success, output = _run_dnf_cmd(dnf_args, privileged=True)
            if success:
                status_verb = "enabled" if state == "enable" else "disabled"
                print(f" Successfully {status_verb}: {', '.join(to_configure)}")
            else:
                print(f"Critical error from DNF: {output}")
            return success

        return True

    def _dnf_repolist(self, state: str = "all", args: list = None) -> list:
        """!
        @brief Internal executor for the DNF repolist command.
        @param state DNF state filter ("all", "enabled", etc).
        @param args Additional command line arguments.
        @return DNF JSON output converted to a list.
        """
        dnf_cmd = "repolist"
        dnf_opt = [f"--{state}", "--json"]
        dnf_args = [dnf_cmd] + dnf_opt + (args if args else [])

        success, stdout = _run_dnf_cmd(dnf_args)

        if success and stdout:
            try:
                data = json.loads(stdout)
                return data if isinstance(data, list) else [data]
            except:
                return []
            return []

    def _load_catalog(self) -> dict:
        """!
        @brief Loads repository metadata from local JSON files.
        @return Dictionary where keys are channel IDs and values are metadata.
        """
        catalog = {}
        path = _get_catalog_path()
        if os.path.exists(path):
            for f in [f for f in os.listdir(path) if f.endswith(".json")]:
                try:
                    with open(os.path.join(path, f), 'r') as s:
                        data = json.load(s)
                        for item in (data if isinstance(data, list) else [data]):
                            if 'id' in item: catalog[item['id']] = item
                except: pass
        return catalog

    def _filter_channels(self, channels: list, state: str) -> list:
        """!
        @brief Filters the unified channel list by activation status.
        @param channels List of unified channel dictionaries.
        @param state Desired state ("enabled", "disabled", or "all").
        @return Filtered list of channels.
        """
        if state == "enabled": return [ch for ch in channels if ch.get('is_enabled')]
        if state == "disabled": return [ch for ch in channels if not ch.get('is_enabled')]
        return channels

# vim :set ts=4:sw=4:sts=4:et:

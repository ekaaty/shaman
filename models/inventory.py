## @file inventory.py
#  @brief Unified hardware inventory report for Shaman CLI.
#
#  SPDX-FileCopyrightText: 2026 Christian Tosta
#  SPDX-License-Identifier: LGPL-3.0-only

import json

## @class InventoryReport
#  @brief Handles the visual representation of the hardware inventory.
class InventoryReport:
    ## @brief Renders the hardware list in the specified format.
    #  @param inventory List of device dictionaries.
    #  @param format Output format (text, json, yaml).
    def render(self, inventory, format="text", truncate_length=45):
        if not inventory:
            return None

        match format:
            case "json": return self._render_json(inventory)
            case "yaml": return self._render_yaml(inventory)
            case "text": return self._render_text(inventory)
            case "qml":  return self._render_qml(inventory, truncate_length)
            case _:      return inventory

    ## @brief Standard text terminal output.
    def _render_text(self, inventory):
        print(f"\n{'ADDRESS':<12} {'STATUS':<8} {'DEVICE NAME'}")
        print("-" * 60)
        for dev in inventory:
            status = "OK" if dev["active"] and not dev["errors"] else "ERR"
            if not dev["active"]: status = "OFF"

            print(f"{dev['address']:<12} [{status:<4}] {dev['name']}")

            if dev["errors"]:
                for err in dev["errors"]:
                    print(f"    ! Log: {err}")
        print(f"\nTotal devices found: {len(inventory)}\n")

    ## @brief Structured output optimized for QML ListModels.
    def _render_qml(self, inventory, truncate_length):
        def smart_truncate(text, length):
            return (text[:length] + " ...") if len(text) > length else text

        devices_list = []

        for dev in inventory:
            raw_errors = str(dev.get("errors", []))
            has_errors = bool(raw_errors) if isinstance(raw_errors, list) else False

            devices_list.append({
                "name": smart_truncate(str(dev.get("name", "")), truncate_length),
                "address": str(dev.get("address", "0000:00:00.0")),
                "module": str(dev.get("module", "None")),
                "active": bool(dev.get("active", False)),
                "has_errors": has_errors
            })

        return devices_list

    ## @brief Structured JSON output for GUI or automation.
    def _render_json(self, inventory):
        print(json.dumps(inventory, indent=4, ensure_ascii=False))

    ## @brief YAML output (requires PyYAML, but can be simulated with print).
    def _render_yaml(self, inventory):
        # Simple manual YAML-like output if no library is available
        print("---")
        print("inventory:")
        for dev in inventory:
            print(f"  - address: {dev['address']}")
            print(f"    name: \"{dev['name']}\"")
            print(f"    module: {dev['module']}")
            print(f"    active: {str(dev['active']).lower()}")

            if dev["errors"]:
                print("    errors:")
                for err in dev["errors"]:
                    safe_err = err.replace('"', '\\"')
                    print(f"      - \"{safe_err}\"")
            else:
                print("    errors: []")
        print("...")

# vim: set ts=4:sw=4:sts=4:et:

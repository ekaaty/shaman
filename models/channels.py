## @file channels.py
#  @brief Software channels reporting for Shaman.
#
#  SPDX-FileCopyrightText: 2026 Christian Tosta
#  SPDX-License-Identifier: LGPL-3.0-only

import json
import shutil

from pygments import highlight, lexers, formatters
from pygments.token import Token

## @class ChannelsReport
#  @brief Handles the visual representation of software channels.
class ChannelsReport:
    ## @brief Composes the channel data into the specified format.
    #  @param data List of channel dictionaries.
    #  @param output Output format (json, terminal, catalog, ...).
    def compose(self, data, output="terminal", sort_by="origin"):
        if not data:
            return None

        match output:
            case "json":     return self._to_json(data)
            case "terminal": return self._to_stdout(data)
            case "catalog":  return self._to_catalog(data, sort_by)
            case _:          return data

    ## @brief Structured JSON output for external tools.
    #  @param data Raw list of channel dictionaries from the collector.
    #  @returns Returns json data or error message.
    def _to_json(self, data) -> str:
        try:
            dumped_json = json.dumps(data, indent=2, ensure_ascii=False)
            colorful_json = highlight(
                dumped_json,
                lexers.JsonLexer(),
                formatters.TerminalFormatter()
            )
            print(colorful_json)
            return dumped_json
        except (TypeError, ValueError) as e:
            error_msg = json.dumps({"error": f"Failed to serialize: {str(e)}"})
            print(error_msg)
            return error_msg

    ## @brief Standard CLI terminal output with status icons.
    #  @param data Raw list of channel dictionaries from the collector.
    def _to_stdout(self, data):
        import io
        cols, _ = shutil.get_terminal_size()
        lex, fmt = lexers.BashLexer(), formatters.TerminalFormatter()

        def colorize(char, success=True):
            out = io.StringIO()
            tok = Token.Generic.Inserted if success else Token.Generic.Deleted
            fmt.format([(tok, char)], out)
            return out.getvalue().strip()

        print(f"\n{highlight(f'{"S":<3} {"CHANNEL ID":<50} {"NAME"}', lex, fmt).strip()}")
        print("─" * cols)

        on, off = colorize("✔", True), colorize("✘", False)

        for c in data:
            status = on if bool(c.get("enabled") or c.get("is_enabled")) else off
            cid = str(c.get("id", "unknown"))
            name = str(c.get("display_name") or c.get("name") or "Unknown")
            print(f"{status:<12} {cid:<50} {name}")

        print("─" * cols)
        footer = f"Total channels listed: {len(data)}"
        print(f"\n{highlight(footer, lex, fmt).strip()}\n")

    ## @brief Groups channels into a categorized structure (sections).
    #  @param data Raw list of channel dictionaries from the collector.
    #  @param sort_by The field to group by (e.g., 'category').
    #  @return List of group dictionaries according to the requested JSON spec.
    def _to_catalog(self, data, sort_by):
        if not data:
            return []

        # Dictionary to store the sections: { "ORIGIN_NAME": { "CATEGORY_NAME": [items] } }
        sections = {}

        for c in data:
            # 1. Primary key (Accordion Section)
            primary_key = str(c.get(sort_by, "")).upper()
            if not primary_key:
                continue

            # 2. Secondary key (Internal Sub-group)
            # If we sort by origin, we want to see category names inside.
            # If we sort by category, we want a flat list (empty secondary key).
            secondary_key = str(c.get("category", "")).capitalize() if sort_by == "origin" else ""

            if primary_key not in sections:
                sections[primary_key] = {}

            if secondary_key not in sections[primary_key]:
                sections[primary_key][secondary_key] = []

            # 3. Item data
            if bool(c.get("readonly", False)): continue
            item_data = {
                "id":       str(c.get("id", "")),
                "text":     str(c.get("display_name", c.get("name"))),
                "icon":     str(c.get("icon", "package-x-generic")),
                "origin":   str(c.get("origin", "third-party")),
                "category": str(c.get("category", "general")),
                "checked":  bool(c.get("is_enabled", c.get("enabled", False))),
                "enabled":  not bool(c.get("readonly", False)),
                "fontsize": 8.0
            }

            sections[primary_key][secondary_key].append(item_data)

        # 4. Format for Universal Accordion
        final_model = []
        for section_title in sorted(sections.keys()):
            internal_groups = []

            # Sort sub-groups (categories) alphabetically
            for sub_title in sorted(sections[section_title].keys()):
                internal_groups.append({
                    "title": sub_title,
                    "type": "multiselect",
                    "items": sections[section_title][sub_title]
                })

            final_model.append({
                "title": section_title,
                "isExpanded": False,
                "items": internal_groups # Now contains ALL categories for this origin
            })

        return final_model



    ## @brief Structured output optimized for QML ListModels (Flat format).
    #  @param data Raw list of channel dictionaries from the collector.
    def _to_plain(self, data):
        return [{
            "id": str(c.get("id", "")),
            "display_name": str(c.get("display_name", c.get("name", ""))),
            "icon": str(c.get("icon", "package-x-generic")),
            "category": str(c.get("category", "General")),
            "enabled": bool(c.get("enabled", c.get("is_enabled", False))),
            "origin": str(c.get("origin", "system"))
        } for c in data]



# :set ts=4:sw=4:sts=4:et:

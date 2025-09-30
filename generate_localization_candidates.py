#!/usr/bin/env python3
"""Generate a focused list of unlocalized candidate strings.

This script reads ``unlocalized_detailed.json`` (produced by
``check_remaining_localizations.py``) and filters the results down to
strings that look like user-facing English messages. The filtered
results are written to ``localization_candidates.json`` for easier
manual localization work.
"""

from __future__ import annotations

import json
from pathlib import Path
from typing import Iterable


ROOT = Path(__file__).parent
REPORT_PATH = ROOT / "unlocalized_detailed.json"
OUTPUT_PATH = ROOT / "localization_candidates.json"


def load_report() -> dict:
    if not REPORT_PATH.exists():
        raise SystemExit(
            "unlocalized_detailed.json not found. Run"
            " check_remaining_localizations.py first."
        )

    with REPORT_PATH.open(encoding="utf-8") as fp:
        return json.load(fp)


def is_ascii(text: str) -> bool:
    try:
        text.encode("ascii")
    except UnicodeEncodeError:
        return False
    return True


def contains_alpha(text: str) -> bool:
    return any(ch.isalpha() for ch in text)


EXCLUDED_SUBSTRINGS: tuple[str, ...] = (
    # SQL fragments / schema related
    "SELECT ",
    "INSERT ",
    "UPDATE ",
    "DELETE ",
    "DROP ",
    "ALTER ",
    "CREATE ",
    "VALUES ",
    " WHERE ",
    " FROM ",
    " INTO ",
    " TABLE",
    "JOIN ",
    " ORDER BY ",
    " GROUP BY ",
    " SET ",
    " == ",
    " ~= ",
    " ->",
    ":Open()",
    # Paths and file references
    "icon16/",
    "materials/",
    "models/",
    "sound/",
    "data/",
    "resource/",
    "vgui/",
    "models\\",
    "materials\\",
    "sound\\",
    "/lua/",
    "\\lua\\",
    "http://",
    "https://",
    # Console / command placeholders
    "say /",
    "concommand",
    "lia.",
    "lia_",
    "lia/",
    " net.",
    # Formatting and placeholders
    "%s",
    "%d",
    "%f",
    "..",
    "\\n",
    "\\t",
    "\n",
    "\t",
    "[%s]",
    # Plain punctuation blocks
    "[[",
    "]]",
)


def is_candidate(text: str) -> bool:
    stripped = text.strip()

    if not stripped:
        return False

    if not is_ascii(stripped):
        return False

    if len(stripped) < 6:
        return False

    if len(stripped) > 140:
        return False

    if "\n" in stripped or "\r" in stripped:
        return False

    if stripped.isupper():
        return False

    if not contains_alpha(stripped):
        return False

    if stripped.replace(" ", "").isdigit():
        return False

    lowered = stripped.lower()
    if lowered.startswith("lia ") or lowered.startswith("lia_"):
        return False

    if any(substring in stripped for substring in EXCLUDED_SUBSTRINGS):
        return False

    # Require at least one lowercase word of length >= 3 to avoid code fragments
    words = [word for word in stripped.split() if word.isalpha()]
    if not any(len(word) >= 3 and word.islower() for word in words):
        return False

    # Encourage full sentences by preferring strings with spaces
    if " " not in stripped and len(stripped) < 20:
        return False

    return True


def filter_candidates(strings: Iterable[dict]) -> list[dict]:
    candidates: list[dict] = []
    for entry in strings:
        text = entry.get("text", "")
        if not isinstance(text, str):
            continue

        if is_candidate(text):
            candidates.append(entry)

    return candidates


def main() -> None:
    report = load_report()
    raw_strings = report.get("strings", [])
    candidates = filter_candidates(raw_strings)

    output = {
        "total_candidates": len(candidates),
        "strings": candidates,
    }

    with OUTPUT_PATH.open("w", encoding="utf-8") as fp:
        json.dump(output, fp, indent=2, ensure_ascii=False)

    print("Total strings in report:", len(raw_strings))
    print("Candidate user-facing strings:", len(candidates))
    print(f"Results written to {OUTPUT_PATH}")


if __name__ == "__main__":
    main()



"""Run the Lilia-framework-only auditor."""

from __future__ import annotations

import argparse
from pathlib import Path

from audit_shared import ensure_directory, resolve_lilia_paths, run_lilia_audit, watch_audit


SCRIPT_DIR = Path(__file__).resolve().parent
DEFAULT_BASE = SCRIPT_DIR.parent


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Audit only the Lilia gamemode framework.")
    parser.add_argument("--base-path", type=Path, default=DEFAULT_BASE, help="Lilia root or its gamemode directory.")
    parser.add_argument("--documentation-path", "--docs-path", type=Path, default=None, help="Documentation root used as a read-only reference.")
    parser.add_argument("--output-path", type=Path, default=None, help="Aggregate Markdown output (default: <Lilia>/comparison_report.md).")
    parser.add_argument("--quiet", "-q", action="store_true", help="Suppress progress output.")
    parser.add_argument("--watch", action="store_true", help="Rerun when Lua or documentation inputs change.")
    parser.add_argument("--watch-interval", type=float, default=1.5, help="Watch polling interval in seconds.")
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    paths = resolve_lilia_paths(args.base_path, args.documentation_path)
    ensure_directory(paths.gamemode_root, "Lilia gamemode path")
    output = (args.output_path or (paths.lilia_root / "comparison_report.md")).resolve()

    def audit():
        if not args.quiet:
            print(f"[lilia-audit] scanning: {paths.gamemode_root}")
            print("[lilia-audit] external modules: disabled")
            print(f"[lilia-audit] report: {output}")
        written = run_lilia_audit(paths, output, args.quiet)
        if not args.quiet:
            print(f"[lilia-audit] wrote {len(written)} report")

    audit()
    if args.watch:
        watch_audit(audit, [paths.gamemode_root, paths.docs_root], args.watch_interval, args.quiet)


if __name__ == "__main__":
    main()


"""Run glualint and write warnings/errors to a Markdown report."""

from __future__ import annotations

import argparse
import re
import shutil
import subprocess
import sys
from datetime import datetime
from pathlib import Path


ANSI_ESCAPE = re.compile(r"\x1b\[[0-?]*[ -/]*[@-~]")
WARNING = re.compile(r"\bwarning\b|\bwarn\b", re.IGNORECASE)
ERROR = re.compile(r"\berror\b|\bfatal\b", re.IGNORECASE)


def repository_root() -> Path:
    return Path(__file__).resolve().parent.parent


def resolve_path(path: str, root: Path) -> Path:
    candidate = Path(path)
    if not candidate.is_absolute():
        candidate = root / candidate
    return candidate.resolve()


def section(title: str, lines: list[str], empty_message: str) -> list[str]:
    result = [f"## {title}", ""]
    if lines:
        result.extend(["```text", *lines, "```"])
    else:
        result.append(empty_message)
    result.append("")
    return result


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "target",
        nargs="?",
        default=None,
        help="Optional path to lint; defaults to the Lilia repository root",
    )
    parser.add_argument(
        "-o",
        "--output",
        default="glualint-report.md",
        help="Markdown report path, relative to the repository root",
    )
    args = parser.parse_args()

    root = repository_root()
    target = root if args.target is None else resolve_path(args.target, root)
    report = resolve_path(args.output, root)

    if not target.exists():
        print(f"Lint target does not exist: {target}", file=sys.stderr)
        return 1

    glualint = shutil.which("glualint")
    if glualint is None:
        lines = [
            "Error: glualint was not found on PATH. "
            "Install it or make it available before running this script."
        ]
        exit_code = 1
    else:
        completed = subprocess.run(
            [glualint, str(target)],
            cwd=root,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
            errors="replace",
            check=False,
        )
        lines = [ANSI_ESCAPE.sub("", line) for line in completed.stdout.splitlines()]
        exit_code = completed.returncode

    error_lines = [line for line in lines if ERROR.search(line)]
    warning_lines = [line for line in lines if WARNING.search(line) and not ERROR.search(line)]
    other_lines = [
        line for line in lines if not ERROR.search(line) and not WARNING.search(line)
    ]

    document = [
        "# glualint report",
        "",
        f"- Status: **{'passed' if exit_code == 0 else 'failed'}**",
        f"- Exit code: `{exit_code}`",
        f"- Target: `{target}`",
        f"- Generated: {datetime.now().astimezone().isoformat(timespec='seconds')}",
        "",
    ]
    document.extend(section("Errors", error_lines, "No errors found."))
    document.extend(section("Warnings", warning_lines, "No warnings found."))
    document.extend(section("Other output", other_lines, "No other output."))

    report.parent.mkdir(parents=True, exist_ok=True)
    report.write_text("\n".join(document), encoding="utf-8")
    print(f"glualint {'passed' if exit_code == 0 else 'failed'}. Report written to {report}")
    return exit_code


if __name__ == "__main__":
    raise SystemExit(main())

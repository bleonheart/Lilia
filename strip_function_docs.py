import argparse
import os
import re
from pathlib import Path


LONG_COMMENT_START_RE = re.compile(r"--\[(=*)\[")
DOC_MARKERS = (
    "Folder:",
    "File:",
    "Overview:",
    "Purpose:",
    "When Called:",
    "Parameters:",
    "Returns:",
    "Realm:",
    "Example Usage:",
)


def detect_newline(raw: bytes) -> str:
    return "\r\n" if b"\r\n" in raw else "\n"


def decode_lua(raw: bytes) -> str:
    return raw.decode("utf-8", errors="replace")


def normalize_newlines(text: str) -> str:
    return text.replace("\r\n", "\n").replace("\r", "\n")


def strip_long_comment_blocks(text: str, remove_all_long: bool) -> tuple[str, int]:
    out = []
    removed = 0
    i = 0
    n = len(text)
    while i < n:
        m = LONG_COMMENT_START_RE.search(text, i)
        if not m:
            out.append(text[i:])
            break

        start = m.start()
        line_start = text.rfind("\n", 0, start) + 1
        if text[line_start:start].strip() == "":
            start = line_start

        out.append(text[i:start])

        eq = m.group(1)
        end_token = "]" + eq + "]"
        end_pos = text.find(end_token, m.end())
        if end_pos == -1:
            out.append(text[start:])
            break

        end_after = end_pos + len(end_token)
        if text.startswith("\r\n", end_after):
            end_after += 2
        elif end_after < len(text) and text[end_after] == "\n":
            end_after += 1

        block = text[start:end_after]
        should_remove = remove_all_long or any(marker in block for marker in DOC_MARKERS)
        if should_remove:
            removed += 1
            i = end_after
            continue

        out.append(block)
        i = end_after

    return "".join(out), removed


def repair_indent_artifacts(text: str) -> tuple[str, int]:
    lines = text.splitlines(keepends=True)
    changed = 0
    prev_sig = ""
    prev_indent = 0
    for idx, line in enumerate(lines):
        s = line.rstrip("\r\n")
        if s.strip() == "":
            continue

        cur_indent = len(s) - len(s.lstrip(" "))
        cur_stripped = s.lstrip(" ")

        is_function_decl = cur_stripped.startswith("function ") or cur_stripped.startswith("local function ")
        if is_function_decl:
            prev_sig_stripped = prev_sig.strip()
            if prev_sig_stripped in ("then", "else", "do") or prev_sig_stripped.endswith((" then", " else", " do")):
                if cur_indent >= prev_indent + 8:
                    new_indent = prev_indent + 4
                    lines[idx] = (" " * new_indent) + cur_stripped + (line[len(s) :])
                    changed += 1
            elif prev_sig_stripped == "end":
                if cur_indent >= prev_indent + 4:
                    new_indent = prev_indent
                    lines[idx] = (" " * new_indent) + cur_stripped + (line[len(s) :])
                    changed += 1

        prev_sig = s
        prev_indent = cur_indent

    return "".join(lines), changed


def should_skip_dir(dirpath: str, skip_names: set[str]) -> bool:
    parts = {p.lower() for p in Path(dirpath).parts}
    return any(name in parts for name in skip_names)


def iter_lua_files(roots: list[Path], skip_names: set[str]) -> list[Path]:
    files = []
    for root in roots:
        root = root.resolve()
        for dirpath, dirnames, filenames in os.walk(root):
            if should_skip_dir(dirpath, skip_names):
                dirnames[:] = []
                continue

            dirnames[:] = [d for d in dirnames if d.lower() not in skip_names]
            for fn in filenames:
                if fn.lower().endswith(".lua"):
                    files.append(Path(dirpath) / fn)
    return files


def process_file(path: Path, write: bool, remove_all_long: bool, repair_indent: bool) -> tuple[bool, int, int]:
    raw = path.read_bytes()
    newline = detect_newline(raw)
    text = normalize_newlines(decode_lua(raw))

    new_text, removed = strip_long_comment_blocks(text, remove_all_long=remove_all_long)
    repaired = 0
    if repair_indent:
        new_text, repaired = repair_indent_artifacts(new_text)

    if removed == 0 and repaired == 0:
        return False, 0, 0

    out_text = new_text.replace("\n", newline)
    if write:
        path.write_bytes(out_text.encode("utf-8"))
    return True, removed, repaired


def main() -> int:
    p = argparse.ArgumentParser()
    p.add_argument("roots", nargs="*", help="Directories to scan. Defaults to current directory.")
    p.add_argument("--write", action="store_true")
    p.add_argument("--remove-all", action="store_true", help="Remove all Lua long comment blocks.")
    p.add_argument("--repair-indent", action="store_true")
    p.add_argument("--skip", nargs="*", default=["docs", "documentation", "site", ".git"])
    args = p.parse_args()

    roots = [Path(r) for r in args.roots] if args.roots else [Path.cwd()]
    skip_names = {s.lower() for s in args.skip}

    files = iter_lua_files(roots, skip_names)
    files_scanned = 0
    files_changed = 0
    blocks_removed = 0
    indent_fixed = 0

    for f in files:
        files_scanned += 1
        changed, removed, repaired = process_file(
            f,
            write=args.write,
            remove_all_long=args.remove_all,
            repair_indent=args.repair_indent,
        )
        if changed:
            files_changed += 1
            blocks_removed += removed
            indent_fixed += repaired

    mode = "WROTE" if args.write else "DRY-RUN"
    print(
        f"{mode}: scanned={files_scanned} changed={files_changed} blocks_removed={blocks_removed} indent_fixed={indent_fixed}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

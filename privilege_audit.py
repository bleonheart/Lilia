import json
import os
import re
from datetime import datetime

REPO_ROOT = os.path.dirname(os.path.abspath(__file__))
GAMEMODE_DIR = os.path.join(REPO_ROOT, "gamemode")
LANG_FILE = os.path.join(GAMEMODE_DIR, "languages", "english.lua")
REGISTERED_JSON_PATH = os.path.join(REPO_ROOT, "lilia_registered_privileges.json")
REPORT_MD_PATH = os.path.join(REPO_ROOT, "lilia_privilege_report.md")


def extract_used_privileges() -> list[str]:
    # Pattern matches calls to hasPrivilege/hasPrivileges with a string first argument
    # Examples:
    #   ply:hasPrivilege("foo")
    #   LocalPlayer():hasPrivileges("foo", true)
    pattern = re.compile(r'hasPrivileges?\s*\(\s*(["\'])(.*?)\1', re.IGNORECASE | re.DOTALL)
    
    privileges: set[str] = set()
    for root, _, files in os.walk(GAMEMODE_DIR):
        for fname in files:
            if not fname.lower().endswith(".lua"):
                continue
            path = os.path.join(root, fname)
            try:
                with open(path, encoding="utf-8", errors="ignore") as fh:
                    content = fh.read()
                for match in pattern.finditer(content):
                    pid = match.group(2).strip()
                    if pid:
                        privileges.add(pid)
            except OSError:
                continue
    return sorted(privileges)


def load_localizations() -> dict[str, str]:
    localizations: dict[str, str] = {}
    try:
        with open(LANG_FILE, encoding="utf-8", errors="ignore") as fh:
            content = fh.read()
        for k, v in re.findall(r'^\s*(\w+)\s*=\s*"(.*?)"\s*$', content, re.MULTILINE):
            localizations[k] = v
        for k, v in re.findall(r'^\s*L\.\s*(\w+)\s*=\s*"(.*?)"\s*$', content, re.MULTILINE):
            localizations[k] = v
        for k, v in re.findall(r'L\[\s*["\']([^"\']+)["\']\s*\]\s*=\s*["\']([^"\']*)["\']', content, re.MULTILINE):
            localizations[k] = v
        for k, v in re.findall(r'lia\.(?:lang|language)\.Add\(\s*["\']([^"\']+)["\']\s*,\s*["\']([^"\']*)["\']\s*\)', content, re.IGNORECASE):
            localizations[k] = v
    except OSError:
        pass
    return localizations


def load_registered_raw():
    try:
        with open(REGISTERED_JSON_PATH, encoding="utf-8") as fh:
            return json.load(fh)
    except (OSError, json.JSONDecodeError):
        return None


def extract_registered_ids(x) -> list[str]:
    if x is None:
        return []
    ids: list[str] = []
    seen: set[str] = set()

    def add(v):
        s = str(v)
        if s and s != "None" and s not in seen:
            seen.add(s)
            ids.append(s)

    def walk(v):
        if isinstance(v, list):
            for i in v:
                walk(i)
        elif isinstance(v, dict):
            if "id" in v and isinstance(v["id"], (str, int)):
                add(v["id"])
            if "privileges" in v:
                walk(v["privileges"])
            else:
                for val in v.values():
                    if isinstance(val, (list, dict)):
                        walk(val)
        elif isinstance(v, (str, int)):
            add(v)

    walk(x)
    return sorted(ids)


def build_report(used: list[str], registered: list[str], localizations: dict[str, str]) -> dict:
    used_set = set(used)
    registered_set = set(registered)
    missing = sorted(used_set - registered_set)
    unused = sorted(registered_set - used_set)
    return {
        "generated_at": datetime.utcnow().isoformat() + "Z",
        "repo_root": REPO_ROOT,
        "counts": {
            "used_in_code": len(used),
            "registered": len(registered),
            "used_but_not_registered": len(missing),
            "registered_but_not_used": len(unused)
        },
        "used_but_not_registered": [{"id": p, "name": localizations.get(p, "")} for p in missing],
        "registered_but_not_used": [{"id": p, "name": localizations.get(p, "")} for p in unused]
    }


def escape_md(s: str) -> str:
    return s.replace("|", r"\|").replace("<", r"\<").replace(">", r"\>")


def write_markdown_report(report: dict, path: str) -> None:
    lines: list[str] = []
    lines.append("# Lilia Privilege Report")
    lines.append("")
    lines.append(f"- Generated at: `{report['generated_at']}`")
    lines.append(f"- Repo root: `{report['repo_root']}`")
    lines.append("")
    c = report["counts"]
    lines.append("## Summary")
    lines.append(f"- Used in code: **{c['used_in_code']}**")
    lines.append(f"- Registered: **{c['registered']}**")
    lines.append(f"- Used but not registered: **{c['used_but_not_registered']}**")
    lines.append(f"- Registered but not used: **{c['registered_but_not_used']}**")
    lines.append("")
    lines.append("## Used but not registered")
    if c["used_but_not_registered"] == 0:
        lines.append("_None_")
    else:
        lines.append("| ID | Name |")
        lines.append("|---|---|")
        for item in report["used_but_not_registered"]:
            pid = escape_md(item["id"])
            name = escape_md(item["name"] or "")
            lines.append(f"| `{pid}` | {name} |")
    lines.append("")
    lines.append("## Registered but not used")
    if c["registered_but_not_used"] == 0:
        lines.append("_None_")
    else:
        lines.append("| ID | Name |")
        lines.append("|---|---|")
        for item in report["registered_but_not_used"]:
            pid = escape_md(item["id"])
            name = escape_md(item["name"] or "")
            lines.append(f"| `{pid}` | {name} |")
    os.makedirs(os.path.dirname(path), exist_ok=True)
    tmp_path = f"{path}.tmp"
    with open(tmp_path, "w", encoding="utf-8") as fh:
        fh.write("\n".join(lines))
    os.replace(tmp_path, path)


def main() -> None:
    used = extract_used_privileges()
    loc = load_localizations()
    reg_raw = load_registered_raw()
    reg_ids = extract_registered_ids(reg_raw)
    report = build_report(used, reg_ids, loc)
    write_markdown_report(report, REPORT_MD_PATH)
    print(f"Markdown: {REPORT_MD_PATH}")


if __name__ == "__main__":
    main()

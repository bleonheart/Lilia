import argparse
import json
import re
from pathlib import Path

# Root directory of repository (script located in scripts/)
REPO_ROOT = Path(__file__).resolve().parent.parent

HAS_PRIV_REGEX = re.compile(r'hasPrivilege\(\s*"([^"]+)"\s*\)')
REGISTER_PRIV_REGEX = re.compile(
    r'registerPrivilege\(\s*\{[^}]*?ID\s*=\s*"([^"]+)"',
    re.DOTALL,
)


def scan_has_privileges(root: Path):
    privileges = set()
    for path in root.rglob('*.lua'):
        try:
            text = path.read_text(encoding='utf-8', errors='ignore')
        except Exception:
            continue
        privileges.update(HAS_PRIV_REGEX.findall(text))
    return sorted(privileges)


def scan_registered_privileges(root: Path):
    privileges = set()
    for path in root.rglob('*.lua'):
        try:
            text = path.read_text(encoding='utf-8', errors='ignore')
        except Exception:
            continue
        privileges.update(REGISTER_PRIV_REGEX.findall(text))
    return sorted(privileges)


def save_json(data, path: Path):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, indent=2, sort_keys=True))


def cmd_find_has(args):
    root = Path(args.path).resolve()
    privs = scan_has_privileges(root)
    if args.output:
        save_json(privs, Path(args.output))
    else:
        print(json.dumps(privs, indent=2))


def cmd_export_registered(args):
    root = Path(args.path).resolve()
    privs = scan_registered_privileges(root)
    save_json(privs, Path(args.output))


def cmd_compare(args):
    has_privs = json.loads(Path(args.has_file).read_text())
    reg_privs = json.loads(Path(args.registered_file).read_text())
    has_set, reg_set = set(has_privs), set(reg_privs)
    missing = sorted(has_set - reg_set)
    unused = sorted(reg_set - has_set)
    result = {"missing": missing, "unused": unused}
    if args.output:
        save_json(result, Path(args.output))
    else:
        print(json.dumps(result, indent=2))


def main():
    parser = argparse.ArgumentParser(description='Privilege auditing tools')
    sub = parser.add_subparsers(dest='cmd', required=True)

    p_find = sub.add_parser('find-has', help='Scan for privileges used with hasPrivilege')
    p_find.add_argument('--path', default=REPO_ROOT, help='Path to scan (default repo root)')
    p_find.add_argument('--output', help='File to write JSON list to')
    p_find.set_defaults(func=cmd_find_has)

    p_reg = sub.add_parser('export-registered', help='Export registered privileges')
    p_reg.add_argument('--path', default=REPO_ROOT, help='Path to scan (default repo root)')
    p_reg.add_argument('--output', default=str(REPO_ROOT / 'player_data' / 'registered_privileges.json'),
                      help='File to save registered privileges JSON')
    p_reg.set_defaults(func=cmd_export_registered)

    p_cmp = sub.add_parser('compare', help='Compare hasPrivilege and registered privileges JSON files')
    p_cmp.add_argument('has_file', help='JSON file from find-has')
    p_cmp.add_argument('registered_file', help='JSON file from export-registered')
    p_cmp.add_argument('--output', help='File to save comparison result')
    p_cmp.set_defaults(func=cmd_compare)

    args = parser.parse_args()
    args.func(args)


if __name__ == '__main__':
    main()

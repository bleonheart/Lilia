#!/usr/bin/env python3
import re

def remove_defaults_from_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    # Pattern to match **Default:** section with its content
    pattern = r'\*\*Default:\*\*\n\n`[^`]+`\n\n'

    # Remove all default sections
    content = re.sub(pattern, '', content)

    with open(filepath, 'w') as f:
        f.write(content)

    print(f"Removed default sections from {filepath}")

# Remove defaults from all three files
remove_defaults_from_file('documentation/docs/definitions/class.md')
remove_defaults_from_file('documentation/docs/definitions/faction.md')
remove_defaults_from_file('documentation/docs/definitions/attribute.md')

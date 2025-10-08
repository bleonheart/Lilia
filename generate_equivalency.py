#!/usr/bin/env python3
import re
from collections import defaultdict

def parse_panel_methods(file_path):
    """Parse panel_methods.md to extract panels and their methods"""
    panels = defaultdict(list)

    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Split by panel headers
    sections = re.split(r'\n(?=# )', content)

    for section in sections:
        if not section.strip():
            continue

        lines = section.strip().split('\n')
        panel_name = lines[0].replace('# ', '').strip()

        if not panel_name:
            continue

        methods = []
        for line in lines[1:]:
            line = line.strip()
            if not line or line.startswith('#') or line.startswith('Deprecated:') or line.startswith('Internal:'):
                continue

            # Extract method signature
            if ':' in line and '(' in line:
                method_match = re.match(r'(\w+:\w+\([^)]*\))', line)
                if method_match:
                    methods.append(method_match.group(1))

        if methods:
            panels[panel_name] = methods

    return panels

def identify_lia_panels():
    """Identify Lia panels and their available methods from the codebase"""
    lia_panels = {}

    # From the grep results, we can identify Lia panels
    # This would need to be more comprehensive by parsing actual Lua files
    # For now, we'll use the registrations we found
    lia_panels = {
        'liaButton': ['SetHover', 'SetFont', 'SetRadius', 'SetIcon', 'SetTxt', 'SetText', 'GetText', 'SetColor', 'SetColorHover', 'SetGradient', 'SetRipple', 'OnMousePressed'],
        'liaComboBox': ['AddChoice', 'SetValue', 'ChooseOption', 'ChooseOptionID', 'ChooseOptionData', 'GetValue', 'SetPlaceholder', 'Clear', 'OpenMenu', 'CloseMenu', 'OnRemove', 'GetOptionData', 'SetConVar', 'GetSelectedID', 'GetSelectedData', 'GetSelectedText', 'IsMenuOpen', 'SetFont', 'RefreshDropdown', 'AutoSize', 'FinishAddingOptions', 'SetTall', 'RecalculateSize', 'PostInit', 'SetTextColor', 'GetTextColor'],
        'liaScrollPanel': ['Base methods inherited from DScrollPanel'],
        'liaNumSlider': ['Base methods inherited from Panel'],
        'liaDListView': ['Base methods inherited from DFrame'],
        'liaChatBox': ['Base methods inherited from DPanel'],
        'liaCategory': ['Base methods inherited from Panel'],
        'liaModelPanel': ['Base methods inherited from DModelPanel'],
        'liaItemIcon': ['Base methods inherited from SpawnIcon'],
        'liaSpawnIcon': ['Base methods inherited from DModelPanel'],
        'liaSheet': ['Base methods inherited from DPanel'],
        'liaScoreboard': ['Base methods inherited from EditablePanel'],
        'liaRoster': ['Base methods inherited from EditablePanel'],
        'liaPrivilegeRow': ['Base methods inherited from DPanel'],
        'liaTabButton': ['Base methods inherited from DPanel'],
        'liaItemMenu': ['Base methods inherited from EditablePanel'],
        'liaItemList': ['Base methods inherited from DFrame'],
        'liaItemSelector': ['Base methods inherited from DFrame'],
        'liaDoorMenu': ['Base methods inherited from DFrame'],
        'liaNotice': ['Base methods inherited from DPanel'],
        'liaLoadingFailure': ['Base methods inherited from DFrame'],
        'liaHorizontalScroll': ['Base methods inherited from DPanel'],
        'liaHorizontalScrollBar': ['Base methods inherited from DVScrollBar'],
        'liaSimpleCheckbox': ['Base methods inherited from DButton'],
        'liaUserGroupButton': ['Base methods inherited from DButton'],
        'liaUserGroupList': ['Base methods inherited from DPanel'],
        'liaCharacterAttribs': ['Base methods inherited from liaCharacterCreateStep'],
        'liaCharacterAttribsRow': ['Base methods inherited from DPanel'],
        'liaCharacterCreateStep': ['Base methods inherited from DPanel'],
        'liaQuick': ['Base methods inherited from EditablePanel'],
        'liaDProgressBar': ['Base methods inherited from DPanel'],
        'liaHugeButton': ['Base methods inherited from DButton'],
        'liaBigButton': ['Base methods inherited from DButton'],
        'liaMediumButton': ['Base methods inherited from DButton'],
        'liaSmallButton': ['Base methods inherited from DButton'],
        'liaMiniButton': ['Base methods inherited from DButton'],
        'liaNoBGButton': ['Base methods inherited from DButton']
    }

    return lia_panels

def create_equivalency_table(gmod_panels, lia_panels):
    """Create equivalency mappings between Lia panels and GMod panels"""
    equivalencies = {
        'liaButton': ['DButton'],
        'liaComboBox': ['DComboBox'],
        'liaScrollPanel': ['DScrollPanel'],
        'liaNumSlider': ['DSlider'],
        'liaDListView': ['DListView'],
        'liaChatBox': ['DPanel'],
        'liaModelPanel': ['DModelPanel'],
        'liaItemIcon': ['SpawnIcon'],
        'liaSpawnIcon': ['DModelPanel'],
        'liaSheet': ['DPanel'],
        'liaScoreboard': ['EditablePanel'],
        'liaRoster': ['EditablePanel'],
        'liaPrivilegeRow': ['DPanel'],
        'liaTabButton': ['DPanel'],
        'liaItemMenu': ['EditablePanel'],
        'liaItemList': ['DFrame'],
        'liaItemSelector': ['DFrame'],
        'liaDoorMenu': ['DFrame'],
        'liaNotice': ['DPanel'],
        'liaLoadingFailure': ['DFrame'],
        'liaHorizontalScroll': ['DPanel'],
        'liaHorizontalScrollBar': ['DVScrollBar'],
        'liaSimpleCheckbox': ['DCheckBox'],
        'liaCharacterCreateStep': ['DPanel'],
        'liaQuick': ['EditablePanel'],
        'liaDProgressBar': ['DProgress'],
        'liaHugeButton': ['DButton'],
        'liaBigButton': ['DButton'],
        'liaMediumButton': ['DButton'],
        'liaSmallButton': ['DButton'],
        'liaMiniButton': ['DButton'],
        'liaNoBGButton': ['DButton'],
        'liaUserGroupButton': ['DButton'],
        'liaUserGroupList': ['DPanel'],
        'liaCharacterAttribs': ['DPanel'],
        'liaCharacterAttribsRow': ['DPanel']
    }

    return equivalencies

def generate_comparison_markdown(gmod_panels, lia_panels, equivalencies):
    """Generate the comparison markdown file"""
    markdown = """# Lia Panel vs GMod Panel Equivalency Table

This document compares Lia panels with their equivalent GMod panels and shows which methods are missing.

## Overview

Lia panels are custom implementations that extend or replace standard GMod panels with enhanced styling and functionality.

## Equivalency Table

"""

    for lia_panel, gmod_equivalents in equivalencies.items():
        if lia_panel not in lia_panels:
            continue

        markdown += f"### {lia_panel}\n\n"
        markdown += f"**Equivalent to:** {', '.join(gmod_equivalents)}\n\n"

        # Get methods for comparison
        lia_methods = set(lia_panels[lia_panel])
        gmod_all_methods = set()

        for gmod_panel in gmod_equivalents:
            if gmod_panel in gmod_panels:
                gmod_all_methods.update(gmod_panels[gmod_panel])

        # Find missing methods
        missing_methods = gmod_all_methods - lia_methods

        markdown += f"**Lia Panel Methods:** {len(lia_methods)}\n"
        markdown += f"**GMod Panel Methods:** {len(gmod_all_methods)}\n"
        markdown += f"**Missing Methods:** {len(missing_methods)}\n\n"

        if missing_methods:
            markdown += "#### Missing Methods in Lia Panel:\n"
            for method in sorted(missing_methods):
                markdown += f"- `{method}`\n"
            markdown += "\n"
        else:
            markdown += "✅ **All GMod methods are implemented in Lia panel!**\n\n"

        markdown += "---\n\n"

    return markdown

def main():
    # Parse GMod panels
    print("Parsing GMod panel methods...")
    gmod_panels = parse_panel_methods('panel_methods.md')
    print(f"Found {len(gmod_panels)} GMod panels")

    # Get Lia panels (simplified for now)
    print("Identifying Lia panels...")
    lia_panels = identify_lia_panels()
    print(f"Found {len(lia_panels)} Lia panels")

    # Create equivalencies
    equivalencies = create_equivalency_table(gmod_panels, lia_panels)

    # Generate comparison
    print("Generating comparison markdown...")
    comparison = generate_comparison_markdown(gmod_panels, lia_panels, equivalencies)

    # Write to file
    with open('lia_vs_gmod_equivalency.md', 'w', encoding='utf-8') as f:
        f.write(comparison)

    print("Generated lia_vs_gmod_equivalency.md successfully")

if __name__ == "__main__":
    main()

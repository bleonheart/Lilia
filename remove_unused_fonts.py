import re

# Read the unused fonts from the report
unused_fonts = []
with open('font_usage_report.txt', 'r') as f:
    in_unused_section = False
    for line in f:
        line = line.strip()
        if line == "Unused fonts:":
            in_unused_section = True
            continue
        elif in_unused_section and line.startswith("- "):
            font_name = line[2:].strip()
            unused_fonts.append(font_name)
        elif in_unused_section and line == "" and len(unused_fonts) > 0:
            break

print(f"Found {len(unused_fonts)} unused fonts to remove:")
for font in unused_fonts:
    print(f"  - {font}")

# Read the fonts.lua file
with open('gamemode/core/libraries/fonts.lua', 'r') as f:
    content = f.read()

# Remove each unused font registration
for font_name in unused_fonts:
    # Create a regex pattern to match the entire font registration block
    pattern = r'lia\.font\.register\("' + re.escape(font_name) + r'",\s*\{\s*[^}]*?\s*\}\s*\n?'
    content = re.sub(pattern, '', content, flags=re.MULTILINE | re.DOTALL)

    # Also try to match with different formatting
    pattern2 = r'lia\.font\.register\("' + re.escape(font_name) + r'",\s*\{\s*[^}]*?\s*\}\s*\)\s*\n?'
    content = re.sub(pattern2, '', content, flags=re.MULTILINE | re.DOTALL)

# Write the updated content back
with open('gamemode/core/libraries/fonts.lua', 'w') as f:
    f.write(content)

print("Removed all unused font registrations from fonts.lua")

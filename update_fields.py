#!/usr/bin/env python3

# Mapping of field names to their default values
field_defaults = {
    'weapons': 'nil',
    'pay': '0',
    'payLimit': '0',
    'limit': '0',
    'health': 'nil',
    'armor': 'nil',
    'scale': '1',
    'runSpeed': 'nil',
    'runSpeedMultiplier': 'false',
    'walkSpeed': 'nil',
    'walkSpeedMultiplier': 'false',
    'jumpPower': 'nil',
    'jumpPowerMultiplier': 'false',
    'bloodcolor': '0',
    'bodyGroups': 'nil',
    'logo': 'nil',
    'scoreboardHidden': 'false',
    'skin': '0',
    'subMaterials': 'nil',
    'model': 'nil',
    'requirements': 'nil',
    'commands': 'nil',
    'canInviteToFaction': 'false',
    'canInviteToClass': 'false',
    'OnCanBe(client)': 'function(self, client) return true end'
}

# Read the file
with open('documentation/docs/definitions/class.md', 'r') as f:
    content = f.read()

# Replace remaining #### `field` with ### CLASS.field and add Default sections
for field, default in field_defaults.items():
    # Replace heading
    old_heading = f'#### `{field}`'
    new_heading = f'### CLASS.{field}'
    content = content.replace(old_heading, new_heading)

    # Add Default section if it doesn't exist
    if f'### CLASS.{field}' in content and '**Default:**' not in content[content.find(f'### CLASS.{field}'):content.find(f'### CLASS.{field}')+500]:
        # Find the Type section and add Default after it
        type_section = f'### CLASS.{field}\n\n**Type:**'
        if type_section in content:
            replacement = f'### CLASS.{field}\n\n**Type:**\n\n`{field_types.get(field, "unknown")}`\n\n**Default:**\n\n`{default}`\n\n**Description:**'
            # This is getting complex, let me do it differently
            pass

# Write back to file
with open('documentation/docs/definitions/class.md', 'w') as f:
    f.write(content)

print("Updated class.md fields")

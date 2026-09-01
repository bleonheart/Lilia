# Stackable Item Definition

Items track quantity inside one inventory entry when `maxStack` is greater than `1`. Use this for ammo boxes, scrap, food portions, crafting materials, or any other item type that should combine into stacks.

## Placement

Register items in:

```text
garrysmod/gamemodes/[schema folder]/schema/definitions/sh_items.lua
```

Use `lia.item.registerItem` in that shared file to define the item directly from code.

## Reference

| Field | Type | Purpose |
| --- | --- | --- |
| `name` | `string` | Display name shown in the inventory. |
| `model` | `string` | World and inventory model used by the item. |
| `width` | `number` | Inventory width in slots. |
| `height` | `number` | Inventory height in slots. |
| `maxStack` | `number` | Maximum number of units allowed in one stack. Defaults to `1`, which disables stacking. |
| `canSplit` | `boolean` | Controls whether players are allowed to split the stack. |

## Example

```lua
lia.item.registerItem("ammo_box", nil, {
    name = "Ammo Box",
    model = "models/props_junk/cardboard_box001a.mdl",
    width = 1,
    height = 1,
    maxStack = 50,
    canSplit = true
})
```

# Hooks

## `ExampleHook(Player client)`

Status:
    WIP

Purpose:
    Example hook entry for the species_creator_poc module. Replace this WIP entry with the module's documented hook API.

Category:
    Example

Parameters:
    client (Player)
        Player supplied to the hook.

Returns:
    nil

Example Usage:
    ```lua
    function MODULE:ExampleHook(client)
        if not IsValid(client) then return end
    end
    ```

Realm:
    Shared

Source:
    docs/hooks.md

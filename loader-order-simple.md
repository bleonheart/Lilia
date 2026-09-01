# Simple Load Order

## Helix

1. Start Helix.
2. Load the basic utility and data files.
3. Load `shared.lua`.
4. Load Helix core libraries and hooks.
5. Load default languages and items.
6. Load Helix plugins.
7. Load the schema plugin.
8. Load schema plugins.
9. Load config and options.

## Lilia

1. Start Lilia.
2. Load `shared.lua`.
3. Load the Lilia loader.
4. Load Lilia core libraries in its fixed order.
5. Load the schema module.
6. Load schema preload modules.
7. Load Lilia modules.
8. Load schema modules.
9. Load schema overrides.
10. Load schema items.
11. Load Lilia and schema entities.
12. Finish database and startup setup.

## File Realms

- `sv_` or `server.lua`: server only.
- `cl_` or `client.lua`: client only.
- `sh_` or `shared.lua`: server and client.

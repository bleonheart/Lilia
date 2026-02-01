# Installation

Welcome to Lilia! This guide will get your server up and running quickly.

## Install Lilia Via Workshop

Lilia is the core framework. You need to subscribe to it on the Steam Workshop.

- **Workshop ID:** `3527535922`
- [Subscribe to Lilia](https://steamcommunity.com/sharedfiles/filedetails/?id=3527535922)

## Install Schema

You also need a schema (gamemode) to run Lilia. We recommend starting with the Skeleton schema.

- [Download Skeleton Schema](https://github.com/LiliaFramework/Skeleton/releases/download/release/skeleton.zip)

1. Extract the ZIP.
2. Place the `skeleton` folder into `garrysmod/gamemodes/`.
3. Set your gamemode to `skeleton` (e.g., `+gamemode skeleton` in your startup command).

## Set Up Admin Access

You can set up admin access using Lilia's built-in system, or use a compatible admin mod like SAM, ULX, or ServerGuard. Lilia is compatible with all of them.

**Lilia Command:**
Run this in your server console:

```text
plysetgroup "STEAMID" "superadmin"
```

## Adjust Permissions

You can configure detailed permissions for your admin groups.

- Open the **Admin Menu** (usually F1 or context menu depending on config).
- Navigate to **Permissions**.
- Adjust access rights as needed.

## Create Your First Faction

Factions are the teams players belong to. Use our generator to create one easily.

- [Faction Generator](../generators/faction.md)

## Create Your First Class

Classes are sub-roles within a faction.

- [Class Generator](../generators/class.md)

## Add Items

Populate your server with items using our generators.

- [Item Generators](../generators/index.md)

## Install Custom Modules

Expand your server's functionality by placing custom modules in the `gamemode/modules` directory.

- [Lilia Modules Documentation](../development/libraries/index.md)

## Owner Essentials

For more advanced configuration and ownership tips, please refer to the Owner Essentials guide.

- [Owner Essentials](./features.md)

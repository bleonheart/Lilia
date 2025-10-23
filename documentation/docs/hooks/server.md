# Server Hooks

This page documents the hook functions available in the Lilia framework.

---

## Server Hooks

### CharPreSave

**Description:** Called before a character is saved to the database.

**Realm:** Server

**Parameters:**

* `character` (*Character*): Parameter: character

---

### PlayerLoadedChar

**Description:** Called when a player loads a character.

**Realm:** Server

**Parameters:**

* `client` (*Player*): Parameter: client
* `character` (*Character*): Parameter: character

---

### PlayerDeath

**Description:** Called when a player dies.

**Realm:** Server

**Parameters:**

* `client` (*Player*): Parameter: client
* `inflictor` (*Entity*): Parameter: inflictor
* `attacker` (*Entity*): Parameter: attacker

---

### PlayerShouldPermaKill

**Description:** Called to determine if a player should be permanently killed.

**Realm:** Server

**Parameters:**

* `client` (*Player*): Parameter: client

---

### CharLoaded

**Description:** Called when a character is loaded from the database.

**Realm:** Server

**Parameters:**

* `id` (*number*): Parameter: id

---

### PrePlayerLoadedChar

**Description:** Called before a player loads a character.

**Realm:** Server

**Parameters:**

* `client` (*Player*): Parameter: client

---

### OnPickupMoney

**Description:** Called when a player picks up money.

**Realm:** Server

**Parameters:**

* `client` (*Player*): Parameter: client
* `moneyEntity` (*Entity*): Parameter: moneyEntity

---

### CanItemBeTransfered

**Description:** Called to determine if an item can be transferred.

**Realm:** Server

**Parameters:**

* `item` (*Item*): Parameter: item
* `curInv` (*Inventory*): Parameter: curInv
* `inventory` (*Inventory*): Parameter: inventory

---

### CanPlayerInteractItem

**Description:** Called to determine if a player can interact with an item.

**Realm:** Server

**Parameters:**

* `client` (*Player*): Parameter: client
* `action` (*string*): Parameter: action
* `item` (*Item*): Parameter: item

---

### CanPlayerEquipItem

**Description:** Called to determine if a player can equip an item.

**Realm:** Server

**Parameters:**

* `client` (*Player*): Parameter: client
* `item` (*Item*): Parameter: item

---

### CanPlayerTakeItem

**Description:** Called to determine if a player can take an item.

**Realm:** Server

**Parameters:**

* `client` (*Player*): Parameter: client
* `item` (*Item*): Parameter: item

---

### CanPlayerDropItem

**Description:** Called to determine if a player can drop an item.

**Realm:** Server

**Parameters:**

* `client` (*Player*): Parameter: client
* `item` (*Item*): Parameter: item

---

### CheckPassword

**Description:** Called to check server password.

**Realm:** Server

**Parameters:**

* `steamID64` (*string*): Parameter: steamID64
* `_` (*any*): Unused parameter
* `serverPassword` (*string*): Parameter: serverPassword
* `clientPassword` (*string*): Parameter: clientPassword
* `playerName` (*string*): Parameter: playerName

---

### PlayerSay

**Description:** Called when a player says something in chat.

**Realm:** Server

**Parameters:**

* `client` (*Player*): Parameter: client
* `message` (*string*): Parameter: message

---

### CanPlayerHoldObject

**Description:** Called to determine if a player can hold an object.

**Realm:** Server

**Parameters:**

* `_` (*any*): Unused parameter
* `entity` (*Entity*): Parameter: entity

---

### EntityTakeDamage

**Description:** Called when an entity takes damage.

**Realm:** Server

**Parameters:**

* `entity` (*Entity*): Parameter: entity
* `dmgInfo` (*CTakeDamageInfo*): Parameter: dmgInfo

---

### KeyPress

**Description:** Called when a key is pressed.

**Realm:** Server

**Parameters:**

* `client` (*Player*): Parameter: client
* `key` (*number*): Parameter: key

---

### InitializedSchema

**Description:** Called when the schema is initialized.

**Realm:** Server

**Parameters:** None

---

### GetGameDescription

**Description:** Called to get the game description.

**Realm:** Server

**Parameters:** None

---

### PostPlayerLoadout

**Description:** Called after a player receives their loadout.

**Realm:** Server

**Parameters:**

* `client` (*Player*): Parameter: client

---

### ShouldSpawnClientRagdoll

**Description:** Called to determine if a client ragdoll should spawn.

**Realm:** Server

**Parameters:**

* `client` (*Player*): Parameter: client

---

### DoPlayerDeath

**Description:** Called when a player death occurs.

**Realm:** Server

**Parameters:**

* `client` (*Player*): Parameter: client
* `attacker` (*Entity*): Parameter: attacker

---

### PlayerSpawn

**Description:** Called when a player spawns.

**Realm:** Server

**Parameters:**

* `client` (*Player*): Parameter: client

---

### PreCleanupMap

**Description:** Called before map cleanup.

**Realm:** Server

**Parameters:** None

---

### PostCleanupMap

**Description:** Called after map cleanup.

**Realm:** Server

**Parameters:** None

---

### ShutDown

**Description:** Called when the server shuts down.

**Realm:** Server

**Parameters:** None

---

### PlayerAuthed

**Description:** Called when a player is authenticated.

**Realm:** Server

**Parameters:**

* `client` (*Player*): Parameter: client
* `steamid` (*string*): Parameter: steamid

---

### PlayerDisconnected

**Description:** Called when a player disconnects.

**Realm:** Server

**Parameters:**

* `client` (*Player*): Parameter: client

---

### PlayerInitialSpawn

**Description:** Called when a player first spawns on the server.

**Realm:** Server

**Parameters:**

* `client` (*Player*): Parameter: client

---

### PlayerLoadout

**Description:** Called when a player receives their loadout.

**Realm:** Server

**Parameters:**

* `client` (*Player*): Parameter: client

---

### CreateDefaultInventory

**Description:** Hook: CreateDefaultInventory

**Realm:** Server

**Parameters:**

* `character` (*Character*): Parameter: character

---

### SetupBotPlayer

**Description:** Hook: SetupBotPlayer

**Realm:** Server

**Parameters:**

* `client` (*Player*): Parameter: client

---

### PlayerShouldTakeDamage

**Description:** Called to determine if a player should take damage.

**Realm:** Server

**Parameters:**

* `client` (*Player*): Parameter: client

---

### CanDrive

**Description:** Called to determine if driving is allowed.

**Realm:** Server

**Parameters:** None

---

### PlayerDeathThink

**Description:** Called during player death think.

**Realm:** Server

**Parameters:** None

---

### SaveData

**Description:** Called to save game data.

**Realm:** Server

**Parameters:** None

---

### LoadData

**Description:** Called to load game data.

**Realm:** Server

**Parameters:** None

---

### OnEntityCreated

**Description:** Called when an entity is created.

**Realm:** Server

**Parameters:**

* `ent` (*Entity*): Parameter: ent

---

### UpdateEntityPersistence

**Description:** Called to update entity persistence.

**Realm:** Server

**Parameters:**

* `ent` (*Entity*): Parameter: ent

---

### EntityRemoved

**Description:** Called when an entity is removed.

**Realm:** Server

**Parameters:**

* `ent` (*Entity*): Parameter: ent

---

### LiliaTablesLoaded

**Description:** Called when Lilia database tables are loaded.

**Realm:** Server

**Parameters:** None

---

### PlayerCanHearPlayersVoice

**Description:** Called to determine if a player can hear another player's voice.

**Realm:** Server

**Parameters:**

* `listener` (*Player*): Parameter: listener
* `speaker` (*Player*): Parameter: speaker

---

### CreateSalaryTimers

**Description:** Called to create salary timers.

**Realm:** Server

**Parameters:** None

---

### PlayerSpray

**Description:** Called when a player sprays.

**Realm:** Server

**Parameters:** None

---

### PlayerDeathSound

**Description:** Called when a player death sound should play.

**Realm:** Server

**Parameters:** None

---

### CanPlayerSuicide

**Description:** Hook: CanPlayerSuicide

**Realm:** Server

**Parameters:** None

---

### AllowPlayerPickup

**Description:** Called to determine if player pickup is allowed.

**Realm:** Server

**Parameters:** None

---


# Administration Tools

A comprehensive guide to the administration tools and features available in Lilia for server management.

---

<strong>Overview</strong>

This guide explains the administration tools available in Lilia. These tools are designed to help server owners and admins manage the server, players, and game settings effectively. Most features are accessed through the Admin Tab (F1 Menu) or by using commands and tools in-game. The administration system provides complete control over server operations, from basic player management to advanced configuration and customization options.

---

<details>
<summary>Permissions</summary>
<div class="details-content">

<strong>What it is</strong>
<p>A system that decides who can do what.</p>

<strong>What it does</strong>
<p>It lets you assign specific powers (like spawning items or banning people) to different user groups (like "superadmin", "admin", or "moderator").</p>

<strong>Why it is used</strong>
<p>To prevent regular players from using admin powers and to give staff members the exact tools they need for their job.</p>

<strong>How to use</strong>
<p>Go to the Admin Tab, find the Permissions section, and select a rank to modify what they can and cannot do.</p>

</div>
</details>

---

<details>
<summary>SitRooms</summary>
<div class="details-content">

<strong>What it is</strong>
<p>A dedicated area for checking admin cases.</p>

<strong>What it does</strong>
<p>It teleports the admin and the player involved in a "sit" (admin situation) to a secluded room (usually on top of the map).</p>

<strong>Why it is used</strong>
<p>To have a private conversation without being interrupted by other players or gameplay.</p>

<strong>How to use</strong>
<p>Use the command (usually `/sitroom` or via the admin menu) while looking at a player or selecting them from a list to bring them to the room.</p>

</div>
</details>

---

<details>
<summary>Warnings</summary>
<div class="details-content">

<strong>What it is</strong>
<p>A record of rule-breaking behavior.</p>

<strong>What it does</strong>
<p>It logs a "warning" on a player's profile when they break a rule.</p>

<strong>Why it is used</strong>
<p>To keep track of repeat offenders. If a player has many warnings, you know they might need a stricter punishment like a temporary ban.</p>

<strong>How to use</strong>
<p>Open the Scoreboard or Admin Menu, right-click the player, and select "Give Warning". You can write a reason so other admins know what happened.</p>

</div>
</details>

---

<details>
<summary>Color Themes</summary>
<div class="details-content">

<strong>What it is</strong>
<p>The visual style of the server's interface.</p>

<strong>What it does</strong>
<p>Changes the colors of menus, buttons, and HUD elements.</p>

<strong>Why it is used</strong>
<p>To make your server look unique and match your community's style or logo.</p>

<strong>How to use</strong>
<p>Look for "Theme" or "Colors" in the Config or Admin settings. You can pick colors from a palette to update the server's look instantly.</p>

</div>
</details>

---

<details>
<summary>Spawns</summary>
<div class="details-content">

<strong>What it is</strong>
<p>Specific locations where players and items appear.</p>

<strong>What it does</strong>
<p>Sets the exact point where a new player joins, where they respawn after putting on a faction, or where items spawn.</p>

<strong>Why it is used</strong>
<p>To organize the map and prevent players from getting stuck or spawning in wrong areas.</p>

<strong>How to use</strong>
<p>Go to the location you want, run the setup spawn command (e.g., `/spawnadd faction_name`), and save.</p>

</div>
</details>

---

<details>
<summary>Tickets</summary>
<div class="details-content">

<strong>What it is</strong>
<p>A request system for players to get help.</p>

<strong>What it does</strong>
<p>Allows a player to send a "ticket" that pops up for all online admins.</p>

<strong>Why it is used</strong>
<p>So players can quietly ask for help without spamming the chat, and admins can see who needs help first.</p>

<strong>How to use</strong>
<p>As an admin, you will see a notification when a ticket is created. Click "Claim" to accept it and teleport to the player.</p>

</div>
</details>

---

<details>
<summary>Config</summary>
<div class="details-content">

<strong>What it is</strong>
<p>The main settings file or menu for the gamemode.</p>

<strong>What it does</strong>
<p>Controls global server options like starting money, chat settings, and potential automated messages.</p>

<strong>Why it is used</strong>
<p>To tweak the server's behavior to fit your needs without needing to write code.</p>

<strong>How to use</strong>
<p>Access the Config menu in the Admin Tab. Change the values (e.g., toggle an option on/off or type a number) and save.</p>

</div>
</details>

---

<details>
<summary>Vendors</summary>
<div class="details-content">

<strong>What it is</strong>
<p>NPC (Non-Player Character) shopkeepers.</p>

<strong>What it does</strong>
<p>They stand in one spot and sell items to players in exchange for in-game currency.</p>

<strong>Why it is used</strong>
<p>To create a server economy where players can buy weapons, food, or clothes.</p>

<strong>How to use</strong>
<p>Use the Admin Stick or a command to place a vendor. Then, configure what items they sell and for how much.</p>

</div>
</details>

---

<details>
<summary>Admin Stick</summary>
<div class="details-content">

<strong>What it is</strong>
<p>A special tool (weapon) only for admins.</p>

<strong>What it does</strong>
<p>It lets you modify objects in the world just by clicking on them. You can open doors, remove items, or set up vendor details.</p>

<strong>Why it is used</strong>
<p>It is much faster and easier than typing long commands for every little change.</p>

<strong>How to use</strong>
<p>Equip the Admin Stick from your weapon menu. Left-click or Right-click on entities (like doors or NPCs) to see options.</p>

</div>
</details>

---

<details>
<summary>Custom Modules</summary>
<div class="details-content">

<strong>What it is</strong>
<p>Extra features added to the base gamemode.</p>

<strong>What it does</strong>
<p>These are "plugins" or "addons" that add specific new abilities or systems not found in the default game.</p>

<strong>Why it is used</strong>
<p>To expand what your server can do.</p>

<strong>How to use</strong>
<p>These are usually installed by the server owner settings. In game, look for their specific tabs or settings in the Admin Menu if they have options.</p>

</div>
</details>

---

<details>
<summary>Staff Faction</summary>
<div class="details-content">

<strong>What it is</strong>
<p>A special team for admins when they are "on duty".</p>

<strong>What it does</strong>
<p>Gives the admin character a specific look (uniform) and often special tools (like the Admin Stick) automatically.</p>

<strong>Why it is used</strong>
<p>To let players know clearly that you are working as an admin and not playing as a regular character.</p>

<strong>How to use</strong>
<p>Open the Classes menu (F1) and switch to the Staff/Admin faction.</p>

</div>
</details>

---

<details>
<summary>Map Configurer</summary>
<div class="details-content">

<strong>What it is</strong>
<p>A tool to edit map features.</p>

<strong>What it does</strong>
<p>It lets you block off doors, remove map props that you don't like, or changing door names.</p>

<strong>Why it is used</strong>
<p>To customize the map for your specific roleplay needs without needing to be a map developer.</p>

<strong>How to use</strong>
<p>Enable the Map Configurer mode (usually a command or tool). Click on map objects to hide them or lock them permanently.</p>

</div>
</details>

---

<details>
<summary>Admin Tab</summary>
<div class="details-content">

<strong>What it is</strong>
<p>The central hub for all administration.</p>

<strong>What it does</strong>
<p>It holds all the different management tools in one menu.</p>

<strong>Why it is used</strong>
<p>So you don't have to remember dozens of chat commands. Everything is clickable.</p>

<strong>How to use</strong>
<p>Press F1 (or your menu key) and click on the "Admin" tab.</p>

### Online Staff

<strong>What it is</strong>
<p>A list of currently connected staff members.</p>

<strong>What it does</strong>
<p>Shows you which other admins are online right now.</p>

<strong>Why it is used</strong>
<p>To coordinate with your team.</p>

<strong>How to use</strong>
<p>Look at the designated list in the Admin Tab.</p>

### Faction Management

<strong>What it is</strong>
<p>A tool to edit game factions (teams).</p>

<strong>What it does</strong>
<p>Lets you change a faction's name, color, pay, or player limit live on the server.</p>

<strong>Why it is used</strong>
<p>To balance the game or fix mistakes in team setups without restarting.</p>

<strong>How to use</strong>
<p>Select a faction from the list and edit the fields (like Name or Salary).</p>

### Character List

<strong>What it is</strong>
<p>A database of every character created on the server.</p>

<strong>What it does</strong>
<p>Allows you to search for any character, even if they are offline.</p>

<strong>Why it is used</strong>
<p>To investigate players or restore deleted characters.</p>

<strong>How to use</strong>
<p>Type a name in the search bar. Click the character to see their details.</p>

### Flags Management

<strong>What it is</strong>
<p>A system for giving special access to characters.</p>

<strong>What it does</strong>
<p>"Flags" are single letters (like 'P' or 'y') that give a character permission to do specific things, like buy special guns or drive cars.</p>

<strong>Why it is used</strong>
<p>To reward players or unlock features for specific characters (e.g., a "Gun License" flag).</p>

<strong>How to use</strong>
<p>Select a player/character and type the flag letter you want to give them in the Flags field.</p>

### Logs

<strong>What it is</strong>
<p>A history of everything that happened.</p>

<strong>What it does</strong>
<p>Records chat, kills, item pickups, and connection info.</p>

<strong>Why it is used</strong>
<p>To prove who broke a rule or what happened when no admin was watching.</p>

<strong>How to use</strong>
<p>Open the Logs tab. Use filters to search for "Chat", "Damage", or specific player names.</p>

### Staff Management

<strong>What it is</strong>
<p>A tool to manage your admin team's ranks.</p>

<strong>What it does</strong>
<p>Lets you promote or demote staff members.</p>

<strong>Why it is used</strong>
<p>To easily manage your team directly in-game.</p>

<strong>How to use</strong>
<p>Select a user and change their Usergroup to the desired rank.</p>

### PK Manager

<strong>What it is</strong>
<p>A tool to manage Permanent Kills.</p>

<strong>What it does</strong>
<p>It creates specific rules for when a character dies permanently and cannot be used again.</p>

<strong>Why it is used</strong>
<p>For serious roleplay servers where death has permanent consequences.</p>

<strong>How to use</strong>
<p>You can "PK" a character (force them to be deleted/unusable) if they died in a way that fits the Permakill rules.</p>

### Players

<strong>What it is</strong>
<p>Management menu for current players.</p>

<strong>What it does</strong>
<p>Gives you options to Kick, Ban, Freeze, or Teleport players.</p>

<strong>Why it is used</strong>
<p>The core tool for handling rule-breakers instantly.</p>

<strong>How to use</strong>
<p>Find the player's name in the list, click extended options, and select the punishment or action.</p>

</div>
</details>

---

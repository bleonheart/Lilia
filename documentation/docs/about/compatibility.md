# Addon Compatibility

This page documents the optional compatibility libraries bundled with Lilia. These libraries greatly expand support for a variety of popular addons used across the Garry's Mod community.

The compatibility system provides seamless integration between Lilia and popular Garry's Mod addons. It automatically detects installed addons, handles version compatibility, and provides API bridging to ensure smooth operation without manual configuration. The system prevents addon conflicts with intelligent override management, maps functions and events between Lilia and addon systems, and provides detailed logging with automatic disable mechanisms to maintain stability. This enables you to use your favorite addons with Lilia while maintaining framework integrity and server performance.

<details class="realm-shared">
<summary><a id="DarkRP"></a>DarkRP</summary>
<div class="details-content">
<p>Ensures DarkRP addons and systems work seamlessly with Lilia.</p>

<strong>Features</strong>
<ul>
<li>Allows you to use almost all DarkRP addons directly with Lilia.</li>
<li>Maintains compatibility with DarkRP money, jobs, and entities.</li>
<li>Fixes common errors that usually happen when moving from DarkRP to a new framework.</li>
</ul>
</div>
</details>

<details class="realm-shared">
<summary><a id="AdvancedDuplicator"></a>Advanced Duplicator</summary>
<div class="details-content">
<p>Improves server stability and security when using the Advanced Duplicator tool.</p>

<strong>Features</strong>
<ul>
<li>Blocks players from spawning problematic or restricted dupes.</li>
<li>Prevents gigantic props from crashing the server.</li>
<li>Alerts admins if someone tries to use a malicious dupe.</li>
</ul>
</div>
</details>

<details class="realm-shared">
<summary><a id="AdvancedDuplicator2"></a>Advanced Duplicator 2</summary>
<div class="details-content">
<p>Adds safety checks to Advanced Duplicator 2 to keep your server running smoothly.</p>

<strong>Features</strong>
<ul>
<li>Stops players from spawning dupes that lag or crash the server.</li>
<li>Respects your server's blacklist settings.</li>
</ul>
</div>
</details>

<details class="realm-shared">
<summary><a id="ARCCW"></a>ArcCW</summary>
<div class="details-content">
<p>Optimizes ArcCW weapons for a better roleplay experience.</p>

<strong>Features</strong>
<ul>
<li>Hides the default ArcCW HUD so it doesn't clash with Lilia's interface.</li>
<li>Configures weapon dropping and attachments to feel natural in RP.</li>
<li>Automatically applies the best settings for server performance.</li>
</ul>
</div>
</details>

<details class="realm-shared">
<summary><a id="CAMI"></a>CAMI</summary>
<div class="details-content">
<p>Connects various admin mods to Lilia's permission system automatically.</p>

<strong>Features</strong>
<ul>
<li>Makes other admin addons recognize your Lilia staff ranks.</li>
<li>Automatically syncs rank changes to your database.</li>
<li>Prevents permission conflicts between different addons.</li>
</ul>
</div>
</details>

<details class="realm-shared">
<summary><a id="LVS"></a>LVS</summary>
<div class="details-content">
<p>Prevents accidents when using LVS vehicles.</p>

<strong>Features</strong>
<ul>
<li>Stops you from accidentally hurting yourself with your own vehicle's weapons or collisions.</li>
</ul>
</div>
</details>

<details class="realm-shared">
<summary><a id="PAC3"></a>PAC3</summary>
<div class="details-content">
<p>Integrates the PAC3 outfit editor safely into your server.</p>

<strong>Features</strong>
<ul>
<li>Ensures everyone sees each other's outfits correctly.</li>
<li>Adds easy commands to fix or disable outfits if they cause lag.</li>
<li>Prevents loading outfits from external websites for security.</li>
<li>Lets you control who can use PAC3 via the admin menu.</li>
<li>Automatically puts outfits on player ragdolls when they die.</li>
</ul>
</div>
</details>

<details class="realm-shared">
<summary><a id="PermaProps"></a>PermaProps</summary>
<div class="details-content">
<p>Prevents conflicts when saving props to the map.</p>

<strong>Features</strong>
<ul>
<li>Stops PermaProps from interfering with Lilia's own save system.</li>
<li>Warns you if you try to save a prop that is already saved by Lilia.</li>
</ul>
</div>
</details>

<details class="realm-shared">
<summary><a id="ProneMod"></a>Prone Mod</summary>
<div class="details-content">
<p>Fixes common bugs where players get stuck lying down.</p>

<strong>Features</strong>
<ul>
<li>Automatically stands players up when they die or switch characters.</li>
</ul>
</div>
</details>

<details class="realm-shared">
<summary><a id="SAM"></a>SAM</summary>
<div class="details-content">
<p>Fully integrates the SAM admin mod with Lilia.</p>

<strong>Features</strong>
<ul>
<li>Allows you to use SAM commands while keeping Lilia's permission system.</li>
<li>Syncs staff ranks perfectly between both systems.</li>
<li>Adds useful features like blind/unblind commands and playtime tracking.</li>
<li>Ensures admins can only ban/kick people lower than them.</li>
</ul>
</div>
</details>

<details class="realm-shared">
<summary><a id="SAdmin"></a>SAdmin</summary>
<div class="details-content">
<p>Fully integrates the SAdmin mod with Lilia.</p>

<strong>Features</strong>
<ul>
<li>Lets you use SAdmin's menu and commands with Lilia's ranks.</li>
<li>Enforces all proper permission checks for kicking, banning, etc.</li>
<li>Syncs usergroups automatically.</li>
</ul>
</div>
</details>

<details class="realm-shared">
<summary><a id="SimfphysVehicles"></a>Simfphys Vehicles</summary>
<div class="details-content">
<p>Improves Simfphys vehicles for roleplay.</p>

<strong>Features</strong>
<ul>
<li>Drivers take damage if they crash their car.</li>
<li>Prevents people from sitting on top of cars (anti-abuse).</li>
<li>Adds trunk storage support to vehicles.</li>
<li>Allows you to restrict vehicle editing to admins only.</li>
</ul>
</div>
</details>

<details class="realm-shared">
<summary><a id="SitAnywhere"></a>Sit Anywhere</summary>
<div class="details-content">
<p>Makes the Sit Anywhere addon safer and less abusive.</p>

<strong>Features</strong>
<ul>
<li>Stops players from sitting on each other or on moving cars.</li>
<li>Prevents players from using seats to glitch through walls.</li>
</ul>
</div>
</details>

<details class="realm-shared">
<summary><a id="ServerGuard"></a>ServerGuard</summary>
<div class="details-content">
<p>Integrates ServerGuard with Lilia.</p>

<strong>Features</strong>
<ul>
<li>Links ServerGuard's ranks with Lilia's permission system.</li>
<li>Allows ServerGuard commands to work seamlessly.</li>
</ul>
</div>
</details>

<details class="realm-shared">
<summary><a id="ULX"></a>ULX</summary>
<div class="details-content">
<p>Integrates the classic ULX admin mod with Lilia.</p>

<strong>Features</strong>
<ul>
<li>Lets you use ULX commands and menus with Lilia.</li>
<li>Syncs all your admins and superadmins automatically.</li>
<li>Ensures ULX respects Lilia's permission rules.</li>
</ul>
</div>
</details>

<details class="realm-shared">
<summary><a id="VCMod"></a>VCMod</summary>
<div class="details-content">
<p>Connects VCMod's economy to your character's wallet.</p>

<strong>Features</strong>
<ul>
<li>When you buy a car or upgrade in VCMod, it takes money from your character.</li>
<li>Ensures you can't buy things if you don't have the cash.</li>
</ul>
</div>
</details>

<details class="realm-shared">
<summary><a id="VJBase"></a>VJBase</summary>
<div class="details-content">
<p>Optimizes VJBase NPCs for better performance and security.</p>

<strong>Features</strong>
<ul>
<li>Removes laggy or insecure features automatically.</li>
<li>Prevents players from spawning game-breaking NPCs.</li>
<li>Adjusts settings based on how many players are online to reduce lag.</li>
</ul>
</div>
</details>

<details class="realm-shared">
<summary><a id="Wiremod"></a>Wiremod</summary>
<div class="details-content">
<p>Secures Wiremod and Expression 2 (E2) usage.</p>

<strong>Features</strong>
<ul>
<li>Prevents regular players from uploading potentially dangerous E2 code.</li>
<li>Restricts advanced features to Admins or Donators only.</li>
<li>Logs all upload attempts so you can see who is doing what.</li>
</ul>
</div>
</details>

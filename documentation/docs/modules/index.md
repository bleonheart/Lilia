# List of Modules

## Modules

<details id="advertisements">
<summary>Advertisements</summary>

### About

Implements a paid /advert command for server-wide announcements. Messages are colored, logged, and throttled by a cooldown to curb spam.

---

<strong>Overview</strong>

Implements a paid /advert command for server-wide announcements. Messages are colored, logged, and throttled by a cooldown to curb spam.

---

<div class="realm-shared">
<div class="realm-header">Advertisements</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Implements a paid /advert command for server-wide announcements. Messages are colored, logged, and throttled by a cooldown to curb spam.</p>

<strong>Main Features</strong>
<ul>
<li>Adds a paid /advert command (alias: /advertisement) for server-wide announcements</li>
<li>Adds colored broadcast messages across the server</li>
<li>Adds message logging for moderation purposes</li>
<li>Adds configurable cooldown system to prevent spam</li>
<li>Adds configurable pricing system</li>
<li>Adds notifications when players lack funds or are on cooldown</li>
</ul>

<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/advert.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.5

- Enhanced documentation with detailed configuration options including AdvertPrice and AdvertCooldown settings with usage guidelines
- Added comprehensive hooks documentation for the AdvertSent hook with multiple complexity examples
- Improved documentation structure and formatting for better readability

### Version 1.4

- Added comprehensive configuration documentation

### Version 1.3

- Added comprehensive hooks documentation

### Version 1.1

- Created docs

### Version 1.0

- Initial Release


</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/advert.zip)

</details>

<details id="afk-protection">
<summary>AFK Protection</summary>

### About

Comprehensive AFK protection system that automatically detects inactive players, prevents exploitation of AFK players, and integrates with restraint systems. Features configurable AFK detection, admin commands, multi-language support, and protection against various player actions.

---

<strong>Overview</strong>

Comprehensive AFK protection system that automatically detects inactive players, prevents exploitation of AFK players, and integrates with restraint systems. Features configurable AFK detection, admin commands, multi-language support, and protection against various player actions.

---

<div class="realm-shared">
<div class="realm-header">AFK Protection</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Comprehensive AFK protection system that automatically detects inactive players, prevents exploitation of AFK players, and integrates with restraint systems. Features configurable AFK detection, admin commands, multi-language support, and protection against various player actions.</p>

<strong>Main Features</strong>
<ul>
<li>Adds automatic AFK detection based on player activity</li>
<li>Adds protection against tying up, arresting, or stunning AFK players</li>
<li>Adds configurable AFK timeout duration and enable/disable toggle</li>
<li>Adds admin commands for managing player AFK status</li>
<li>Adds visual indicators for AFK status in character info and HUD</li>
<li>Adds multi-language support for all text elements</li>
<li>Adds integration with restraint systems</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/afk.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.3

- Added comprehensive configuration documentation

### Version 1.2

- Better UI

### Version 1.1

- Added comprehensive multi-language support (English, Spanish, French, German, Portuguese, Italian)
- Updated all hardcoded strings to use language system
- Enhanced module description with detailed feature list
- Improved documentation with complete feature overview
- Updated version number to reflect improvements
- Add Docs

### Version 1.0

- Initial Release


</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/afk.zip)

</details>

<details id="alcoholism">
<summary>Alcoholism</summary>

### About

Adds drinkable alcohol that increases a player's intoxication level. High BAC blurs vision and slows movement until the effect wears off.

---

<strong>Overview</strong>

Adds drinkable alcohol that increases a player's intoxication level. High BAC blurs vision and slows movement until the effect wears off.

---

<div class="realm-shared">
<div class="realm-header">Alcoholism</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Adds drinkable alcohol that increases a player's intoxication level. High BAC blurs vision and slows movement until the effect wears off.</p>

<strong>Main Features</strong>
<ul>
<li>Adds alcohol items that raise BAC (Blood Alcohol Content) and gradually wear off</li>
<li>Adds screen blur and movement effects that scale with intoxication</li>
<li>Adds player notification when reaching DrunkNotifyThreshold</li>
<li>Adds configurable BAC settings and degradation rates</li>
<li>Adds multiple drink items with varying strength (vodka, whiskey, wine, beer, etc.)</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/alcoholism.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.5

- Fixed localization format error in `alcoholDesc` string by correcting `%s%` to `%s%%` in all language files (English, Spanish, Portuguese, Italian, German, French)

### Version 1.4

- Added comprehensive configuration documentation

### Version 1.3

- Added comprehensive hooks documentation


### Version 1.2

- Updated function naming convention from PascalCase to camelCase for consistency:
  - `ResetBAC()` ? `resetBAC()`
  - `AddBAC()` ? `addBAC()`
  - `IsDrunk()` ? `isDrunk()`
  - `GetBAC()` ? `getBAC()`

### Version 1.1

- Created docs

### Version 1.0

- Initial Release


</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/alcoholism.zip)

</details>

<details id="anonymous-rumors">
<summary>Anonymous Rumors</summary>

### About

Adds an anonymous rumour chat command, hiding of the sender's identity, encouragement for roleplay intrigue, a cooldown to prevent spam, and admin logging of rumour messages.

---

<strong>Overview</strong>

Adds an anonymous rumour chat command, hiding of the sender's identity, encouragement for roleplay intrigue, a cooldown to prevent spam, and admin logging of rumour messages.

---

<div class="realm-shared">
<div class="realm-header">Anonymous Rumors</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Adds an anonymous rumour chat command, hiding of the sender's identity, encouragement for roleplay intrigue, a cooldown to prevent spam, and admin logging of rumour messages.</p>

<strong>Main Features</strong>
<ul>
<li>Adds an anonymous rumour chat command</li>
<li>Adds hiding of the sender's identity</li>
<li>Adds encouragement for roleplay intrigue</li>
<li>Adds a cooldown to prevent spam</li>
<li>Adds admin logging of rumour messages</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/rumour.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.3

- Added custom colors for rumor messages
- [RUMOUR] prefix now displays in orange color
- Rumor message text displays in white color
- Colors are now hardcoded local variables instead of configurable settings

### Version 1.2

- Added comprehensive hooks documentation

### Version 1.1

- Created docs

### Version 1.0

- Initial Release


</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/rumour.zip)

</details>

<details id="auto-restarter">
<summary>Auto Restarter</summary>

### About

Schedules automatic server restarts at set intervals. Players see a countdown so they can prepare before the map changes.

---

<strong>Overview</strong>

Schedules automatic server restarts at set intervals. Players see a countdown so they can prepare before the map changes.

---

<div class="realm-shared">
<div class="realm-header">Auto Restarter</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Schedules automatic server restarts at set intervals. Players see a countdown so they can prepare before the map changes.</p>

<strong>Main Features</strong>
<ul>
<li>Adds scheduling for automatic restarts using RestartInterval</li>
<li>Adds a countdown overlay configurable via RestartCountdownFont</li>
<li>Adds syncing of next restart time to clients</li>
<li>Adds automatic changelevel when the timer expires</li>
<li>Adds network messages to sync the restart countdown</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/autorestarter.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.3

- Added comprehensive configuration documentation
- Configuration updates and improvements

### Version 1.2

- Added comprehensive hooks documentation


### Version 1.1

- Created docs

### Version 1.0

- Initial Release


</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/autorestarter.zip)

</details>

<details id="bodygroup-closet">
<summary>BodyGroup Closet</summary>

### About

Spawns a bodygroup closet where players can edit their model's bodygroups. Admins may inspect others and configure the closet's model.

---

<strong>Overview</strong>

Spawns a bodygroup closet where players can edit their model's bodygroups. Admins may inspect others and configure the closet's model.

---

<div class="realm-shared">
<div class="realm-header">Body Group Editor</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Spawns a bodygroup closet where players can edit their model's bodygroups. Admins may inspect others and configure the closet's model.</p>

<strong>Main Features</strong>
<ul>
<li>Adds a spawnable closet entity for editing bodygroups</li>
<li>Adds the ability to customize its model via BodyGrouperModel configuration</li>
<li>Adds menu access that requires proximity or privilege</li>
<li>Adds an admin command to view another player's bodygroups</li>
<li>Adds a networked menu for editing bodygroups</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/bodygrouper.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 2.1

- Removed category wrapper from bodygroup UI to provide more space for controls
- Bodygroup sliders now display directly in the scroll panel without category container

### Version 2.0

- Simplified bodygroup UI by returning to liaCategory with AddItem approach
- Category now expands by default to immediately show all bodygroup options
- Removed complex contents panel management for cleaner, more reliable layout

### Version 1.9

- Fixed bodygroup slider visibility and spacing issues by improving liaCategory AddItem method
- Added automatic contents panel creation for proper layout management
- Category now expands by default to show bodygroups immediately

### Version 1.8

- Changed "Finish" button to "Submit" button with proper localization
- Updated button component from liaMediumButton to liaButton
- Submit button now always visible (no longer removed when no bodygroups/skins available)
- Added submit language entries for all supported languages

### Version 1.7

- UI components to use Lilia framework components (liaSlideBox, liaMediumButton, liaScrollPanel, liaCategory, liaFrame)
- BodygrouperModelPaint and BodygrouperPostDrawModel hooks for custom rendering
- Changed from DNumSlider to liaSlideBox with improved SetRange API

### Version 1.6

- Updated Vector method calls to use proper PascalCase naming (`distance` → `Distance`)

### Version 1.5

- Added comprehensive configuration documentation

### Version 1.4

- Added comprehensive hooks documentation


### Version 1.3

- Language files for all supported languages (English, French, German, Italian, Portuguese, Spanish)

### Version 1.2

- Updated function naming convention from PascalCase to camelCase for consistency

### Version 1.1

- Created docs

### Version 1.0

- Initial Release


</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/bodygrouper.zip)

</details>

<details id="broadcasts">
<summary>Broadcasts</summary>

### About

Allows staff to broadcast messages to chosen factions or classes. Every broadcast is logged and controlled through CAMI privileges.

---

<strong>Overview</strong>

Allows staff to broadcast messages to chosen factions or classes. Every broadcast is logged and controlled through CAMI privileges.

---

<div class="realm-shared">
<div class="realm-header">Broadcasts</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Allows staff to broadcast messages to chosen factions or classes. Every broadcast is logged and controlled through CAMI privileges.</p>

<strong>Main Features</strong>
<ul>
<li>Adds faction and class broadcast commands with CAMI checks</li>
<li>Adds logging of broadcast messages for staff review</li>
<li>Adds CAMI privileges for broadcast access</li>
<li>Adds menus to select factions or classes</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/broadcasts.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.2

- Added comprehensive hooks documentation


### Version 1.1

- Created docs

### Version 1.0

- Initial Release


</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/broadcasts.zip)

</details>

<details id="captions">
<summary>Captions</summary>

### About

Offers an API for timed on-screen captions suited for tutorials or story events. Captions can be triggered from the server or client and last for a chosen duration.

---

<strong>Overview</strong>

Offers an API for timed on-screen captions suited for tutorials or story events. Captions can be triggered from the server or client and last for a chosen duration.

---

<div class="realm-shared">
<div class="realm-header">Captions</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Offers an API for timed on-screen captions suited for tutorials or story events. Captions can be triggered from the server or client and last for a chosen duration.</p>

<strong>Main Features</strong>
<ul>
<li>Adds an API for timed on-screen captions (`lia.caption.start()`)</li>
<li>Adds support for both client and server use</li>
<li>Adds an easy way to deliver story prompts or tutorial messages</li>
<li>Adds admin commands to send captions to players</li>
<li>Adds duration control for each caption (default: 5 seconds)</li>
<li>Adds network synchronization for caption display</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/captions.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.3

- Added comprehensive hooks documentation
- Added libraries documentation

### Version 1.1

- Created docs

### Version 1.0

- Initial Release


</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/captions.zip)

</details>

<details id="cards">
<summary>Cards</summary>

### About

Adds a full deck of playing cards that can be shuffled and drawn. Card draws sync to all players for simple in-game minigames.

---

<strong>Overview</strong>

Adds a full deck of playing cards that can be shuffled and drawn. Card draws sync to all players for simple in-game minigames.

---

<div class="realm-shared">
<div class="realm-header">Cards</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Adds a full deck of playing cards that can be shuffled and drawn. Card draws sync to all players for simple in-game minigames.</p>

<strong>Main Features</strong>
<ul>
<li>Adds a full playing card deck (52 cards with suits and ranks)</li>
<li>Adds random card draws that sync to all players via chat</li>
<li>Adds support for simple minigames</li>
<li>Adds easy reshuffling through random draws</li>
<li>Adds hooks so other modules can use cards</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/cards.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.3

- Added comprehensive hooks documentation

### Version 1.1

- Created docs

### Version 1.0

- Initial Release


</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/cards.zip)

</details>

<details id="chat-messages">
<summary>Chat Messages</summary>

### About

Periodically posts automated advert messages in chat on a timer. Keeps players informed with rotating tips even when staff are offline.

---

<strong>Overview</strong>

Periodically posts automated advert messages in chat on a timer. Keeps players informed with rotating tips even when staff are offline.

---

<div class="realm-shared">
<div class="realm-header">Chat Messages</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Periodically posts automated advert messages in chat on a timer. Keeps players informed with rotating tips even when staff are offline.</p>

<strong>Main Features</strong>
<ul>
<li>Adds periodic server adverts to chat</li>
<li>Adds interval control via ChatMessagesInterval</li>
<li>Adds localized message support</li>
<li>Adds rotating tips for new players</li>
<li>Adds toggle to disable adverts per user</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/chatmessages.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.3

- Added comprehensive configuration documentation

### Version 1.2

- Added comprehensive hooks documentation


### Version 1.1

- Created docs

### Version 1.0

- Initial Release


</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/chatmessages.zip)

</details>

<details id="cinematic-text">
<summary>Cinematic Text</summary>

### About

Adds displays of cinematic splash text overlays, screen darkening with letterbox bars, support for scripted scenes, timed fades for dramatic effect, and customizable text fonts.

---

<strong>Overview</strong>

Adds displays of cinematic splash text overlays, screen darkening with letterbox bars, support for scripted scenes, timed fades for dramatic effect, and customizable text fonts.

---

<div class="realm-shared">
<div class="realm-header">Cinematic Text</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Adds displays of cinematic splash text overlays, screen darkening with letterbox bars, support for scripted scenes, timed fades for dramatic effect, and customizable text fonts.</p>

<strong>Main Features</strong>
<ul>
<li>Adds displays of cinematic splash text overlays</li>
<li>Adds screen darkening with letterbox bars</li>
<li>Adds support for scripted scenes</li>
<li>Adds timed fades for dramatic effect</li>
<li>Adds customizable text fonts</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/cinematictext.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.5

- Removed custom font configuration option
- Replaced custom font registrations with standard LiliaFont system
- Simplified font usage for better consistency

### Version 1.4

- Added comprehensive configuration documentation
- Configuration updates and improvements

### Version 1.3

- Added comprehensive hooks documentation


### Version 1.2

- Updated function naming convention from PascalCase to camelCase for consistency

### Version 1.1

- Created docs

### Version 1.0

- Initial Release


</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/cinematictext.zip)

</details>

<details id="climbing">
<summary>Climbing</summary>

### About

Adds the ability to climb ledges using movement keys, custom climbing animations, and hooks for climb attempts.

---

<strong>Overview</strong>

Adds the ability to climb ledges using movement keys, custom climbing animations, and hooks for climb attempts.

---

<div class="realm-shared">
<div class="realm-header">Climbing</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Adds the ability to climb ledges using movement keys, custom climbing animations, and hooks for climb attempts.</p>

<strong>Main Features</strong>
<ul>
<li>Adds the ability to climb ledges using movement keys</li>
<li>Adds custom climbing animations</li>
<li>Adds hooks for climb attempts</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/climb.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.2

- Added comprehensive hooks documentation

### Version 1.1

- Created docs

### Version 1.0

- Initial Release


</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/climb.zip)

</details>

<details id="code-utilities">
<summary>Code Utilities</summary>

### About

Adds extra helper functions in lia.util, simplified utilities for common scripting tasks, a central library used by other modules, utilities for networking data, and shared constants for modules.

---

<strong>Overview</strong>

Adds extra helper functions in lia.util, simplified utilities for common scripting tasks, a central library used by other modules, utilities for networking data, and shared constants for modules.

---

<div class="realm-shared">
<div class="realm-header">Code Utilities</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Adds extra helper functions in lia.util, simplified utilities for common scripting tasks, a central library used by other modules, utilities for networking data, and shared constants for modules.</p>

<strong>Main Features</strong>
<ul>
<li>Adds extra helper functions in lia.util</li>
<li>Adds simplified utilities for common scripting tasks</li>
<li>Adds a central library used by other modules</li>
<li>Adds utilities for networking data</li>
<li>Adds shared constants for modules</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/utilities.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.5

- Updated Vector method calls to use proper PascalCase naming (`distance` → `Distance`)

### Version 1.4

- Added comprehensive hooks documentation
- Added libraries documentation

### Version 1.2

- Updated function naming convention from PascalCase to camelCase for consistency:
  - `SpeedTest` → `speedTest`
  - `DaysBetween` → `daysBetween`
  - `LerpHSV` → `lerpHSV`
  - `Darken` → `darken`
  - `LerpColor` → `lerpColor`
  - `Blend` → `blend`
  - `Rainbow` → `rainbow`
  - `ColorCycle` → `colorCycle`
  - `ColorToHex` → `colorToHex`
  - `Lighten` → `lighten`
  - `SecondsToDHMS` → `secondsToDHMS`
  - `HMSToSeconds` → `hMSToSeconds`
  - `FormatTimestamp` → `formatTimestamp`
  - `WeekdayName` → `weekdayName`
  - `TimeUntil` → `timeUntil`
  - `CurrentLocalTime` → `currentLocalTime`
  - `TimeDifference` → `timeDifference`
  - `SerializeVector` → `serializeVector`
  - `DeserializeVector` → `deserializeVector`
  - `SerializeAngle` → `serializeAngle`
  - `DeserializeAngle` → `deserializeAngle`

### Version 1.1

- Created docs

### Version 1.0

- Initial Release


</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/utilities.zip)

</details>

<details id="community-commands">
<summary>Community Commands</summary>

### About

Adds chat commands to open community links, easy sharing of workshop and docs, configurable commands via settings, localization for command names, and the ability to add custom URLs.

---

<strong>Overview</strong>

Adds chat commands to open community links, easy sharing of workshop and docs, configurable commands via settings, localization for command names, and the ability to add custom URLs.

---

<div class="realm-shared">
<div class="realm-header">Community Commands</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Adds chat commands to open community links, easy sharing of workshop and docs, configurable commands via settings, localization for command names, and the ability to add custom URLs.</p>

<strong>Main Features</strong>
<ul>
<li>Adds chat commands to open community links</li>
<li>Adds easy sharing of workshop and docs</li>
<li>Adds configurable commands via settings</li>
<li>Adds localization for command names</li>
<li>Adds the ability to add custom URLs</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/communitycommands.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.3

- Added comprehensive configuration documentation

### Version 1.2
- Added comprehensive hooks documentation

### Version 1.1

- Created docs

### Version 1.0

- Initial Release



</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/communitycommands.zip)

</details>

<details id="cursor">
<summary>Cursor</summary>

### About

Adds a toggleable custom cursor for the UI, a purely client-side implementation, improved menu navigation, a hotkey to quickly show or hide the cursor, and compatibility with other menu modules.

---

<strong>Overview</strong>

Adds a toggleable custom cursor for the UI, a purely client-side implementation, improved menu navigation, a hotkey to quickly show or hide the cursor, and compatibility with other menu modules.

---

<div class="realm-shared">
<div class="realm-header">Cursor</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Adds a toggleable custom cursor for the UI, a purely client-side implementation, improved menu navigation, a hotkey to quickly show or hide the cursor, and compatibility with other menu modules.</p>

<strong>Main Features</strong>
<ul>
<li>Adds a toggleable custom cursor for the UI</li>
<li>Adds a purely client-side implementation</li>
<li>Adds improved menu navigation</li>
<li>Adds a hotkey to quickly show or hide the cursor</li>
<li>Adds compatibility with other menu modules</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/cursor.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.2
- Added comprehensive hooks documentation

### Version 1.1

- Created docs

### Version 1.0

- Initial Release



</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/cursor.zip)

</details>

<details id="cutscenes">
<summary>Cutscenes</summary>

### About

Adds a framework for simple cutscene playback, scenes defined through tables, syncing of camera movement across clients, commands to trigger cutscenes, and the ability for players to skip.

---

<strong>Overview</strong>

Adds a framework for simple cutscene playback, scenes defined through tables, syncing of camera movement across clients, commands to trigger cutscenes, and the ability for players to skip.

---

<div class="realm-shared">
<div class="realm-header">Cutscenes</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Adds a framework for simple cutscene playback, scenes defined through tables, syncing of camera movement across clients, commands to trigger cutscenes, and the ability for players to skip.</p>

<strong>Main Features</strong>
<ul>
<li>Adds a framework for simple cutscene playback</li>
<li>Adds scenes defined through tables in config.lua</li>
<li>Adds syncing of camera movement across clients</li>
<li>Adds admin commands to trigger cutscenes</li>
<li>Adds the ability for players to skip cutscenes</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/cutscenes.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.3

- Added comprehensive configuration documentation

### Version 1.2
- Added comprehensive hooks documentation

### Version 1.1

- Created docs

### Version 1.0

- Initial Release



</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/cutscenes.zip)

</details>

<details id="damage-numbers">
<summary>Damage Numbers</summary>

### About

Adds floating combat text when hitting targets, different colors for damage types, display of damage dealt and received, scaling text based on damage amount, and client option to disable numbers.

---

<strong>Overview</strong>

Adds floating combat text when hitting targets, different colors for damage types, display of damage dealt and received, scaling text based on damage amount, and client option to disable numbers.

---

<div class="realm-shared">
<div class="realm-header">Damage Numbers</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Adds floating combat text when hitting targets, different colors for damage types, display of damage dealt and received, scaling text based on damage amount, and client option to disable numbers.</p>

<strong>Main Features</strong>
<ul>
<li>Adds floating combat text when hitting targets</li>
<li>Adds different colors for damage types</li>
<li>Adds display of damage dealt and received</li>
<li>Adds scaling text based on damage amount</li>
<li>Adds client option to disable numbers</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/damagenumbers.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.5

- Updated Vector method calls to use proper PascalCase naming (`distance` → `Distance`)

### Version 1.4

- Added comprehensive configuration documentation
- Configuration updates and improvements

### Version 1.3

- Added comprehensive hooks documentation


### Version 1.2

- Updated function naming convention from PascalCase to camelCase for consistency

### Version 1.1

- Created docs

### Version 1.0

- Initial Release


</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/damagenumbers.zip)

</details>

<details id="development-hud">
<summary>Development HUD</summary>

### About

Adds a staff-only development HUD, font customization via DevHudFont, a requirement for the CAMI privilege, real-time server performance metrics, and a toggle command to show or hide the HUD.

---

<strong>Overview</strong>

Adds a staff-only development HUD, font customization via DevHudFont, a requirement for the CAMI privilege, real-time server performance metrics, and a toggle command to show or hide the HUD.

---

<div class="realm-shared">
<div class="realm-header">Development HUD</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Adds a staff-only development HUD, font customization via DevHudFont, a requirement for the CAMI privilege, real-time server performance metrics, and a toggle command to show or hide the HUD.</p>

<strong>Main Features</strong>
<ul>
<li>Adds a staff-only development HUD</li>
<li>Adds font customization via DevHudFont</li>
<li>Adds a requirement for the CAMI privilege</li>
<li>Adds real-time server performance metrics</li>
<li>Adds a toggle command to show or hide the HUD</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/developmenthud.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.5

- Updated Vector method calls to use proper PascalCase naming (`distance` → `Distance`)

### Version 1.4

- Added comprehensive configuration documentation
- Configuration updates and improvements

### Version 1.3

- Added comprehensive hooks documentation


### Version 1.2

- Updated function naming convention from PascalCase to camelCase for consistency

### Version 1.1

- Created docs

### Version 1.0

- Initial Release


</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/developmenthud.zip)

</details>

<details id="development-server">
<summary>Development Server</summary>

### About

Adds a development server mode for testing, the ability to run special development functions, a toggle via configuration, an environment flag for dev commands, and logging of executed dev actions.

---

<strong>Overview</strong>

Adds a development server mode for testing, the ability to run special development functions, a toggle via configuration, an environment flag for dev commands, and logging of executed dev actions.

---

<div class="realm-shared">
<div class="realm-header">Development Server</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Adds a development server mode for testing, the ability to run special development functions, a toggle via configuration, an environment flag for dev commands, and logging of executed dev actions.</p>

<strong>Main Features</strong>
<ul>
<li>Adds a development server mode for testing</li>
<li>Adds the ability to run special development functions</li>
<li>Adds a toggle via configuration</li>
<li>Adds an environment flag for dev commands</li>
<li>Adds logging of executed dev actions</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/developmentserver.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.3

- Added comprehensive configuration documentation

### Version 1.2
- Added comprehensive hooks documentation

### Version 1.1

- Created docs

### Version 1.0

- Initial Release



</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/developmentserver.zip)

</details>

<details id="donator">
<summary>Donator</summary>

### About

Adds libraries to manage donor perks, tracking for donor ranks and perks, configurable perks by tier, and commands to adjust character slots.

---

<strong>Overview</strong>

Adds libraries to manage donor perks, tracking for donor ranks and perks, configurable perks by tier, and commands to adjust character slots.

---

<div class="realm-shared">
<div class="realm-header">Donator</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Adds libraries to manage donor perks, tracking for donor ranks and perks, configurable perks by tier, and commands to adjust character slots.</p>

<strong>Main Features</strong>
<ul>
<li>Adds libraries to manage donor perks</li>
<li>Adds tracking for donor ranks and perks</li>
<li>Adds configurable perks by tier</li>
<li>Adds commands to adjust character slots</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/donator.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.4

- Added comprehensive configuration documentation

### Version 1.3

- Added comprehensive hooks documentation


### Version 1.2

- Updated function naming convention from PascalCase to camelCase for consistency:
  - `GetAdditionalCharSlots()` ? `getAdditionalCharSlots()`
  - `SetAdditionalCharSlots()` ? `setAdditionalCharSlots()`
  - `GiveAdditionalCharSlots()` ? `giveAdditionalCharSlots()`

### Version 1.1

- Created docs

### Version 1.0

- Initial Release


</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/donator.zip)

</details>

<details id="door-kick">
<summary>Door Kick</summary>

### About

Adds the ability to kick doors open with an animation, logging of door kick events, and a fun breach mechanic with physics force to fling doors open.

---

<strong>Overview</strong>

Adds the ability to kick doors open with an animation, logging of door kick events, and a fun breach mechanic with physics force to fling doors open.

---

<div class="realm-shared">
<div class="realm-header">Door Kick</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Adds the ability to kick doors open with an animation, logging of door kick events, and a fun breach mechanic with physics force to fling doors open.</p>

<strong>Main Features</strong>
<ul>
<li>Adds the ability to kick doors open with an animation</li>
<li>Adds logging of door kick events</li>
<li>Adds a fun breach mechanic</li>
<li>Adds physics force to fling doors open</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/doorkick.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.5

- Updated Vector method calls to use proper PascalCase naming (`distance` → `Distance`)

### Version 1.4

- Added comprehensive configuration documentation

### Version 1.3

- Added comprehensive hooks documentation


### Version 1.2

- Updated function naming convention from PascalCase to camelCase for consistency

### Version 1.1

- Created docs

### Version 1.0

- Initial Release


</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/doorkick.zip)

</details>

<details id="extended-descriptions">
<summary>Extended Descriptions</summary>

### About

Adds support for long item descriptions, localization for multiple languages, better RP text display, automatic line wrapping, and fallback to short descriptions.

---

<strong>Overview</strong>

Adds support for long item descriptions, localization for multiple languages, better RP text display, automatic line wrapping, and fallback to short descriptions.

---

<div class="realm-shared">
<div class="realm-header">Extended Descriptions</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Adds support for long item descriptions, localization for multiple languages, better RP text display, automatic line wrapping, and fallback to short descriptions.</p>

<strong>Main Features</strong>
<ul>
<li>Adds support for long item descriptions</li>
<li>Adds localization for multiple languages</li>
<li>Adds better RP text display</li>
<li>Adds automatic line wrapping</li>
<li>Adds fallback to short descriptions</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/extendeddescriptions.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.4

- Changed button component from liaSmallButton to liaButton for consistency

### Version 1.3

- Added comprehensive hooks documentation


### Version 1.2

- Updated function naming convention from PascalCase to camelCase for consistency

### Version 1.1

- Created docs

### Version 1.0

- Initial Release


</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/extendeddescriptions.zip)

</details>

<details id="first-person-effects">
<summary>First Person Effects</summary>

### About

Adds head bob and view sway, camera motion synced to actions, a realistic first-person feel, and adjustable intensity via config.

---

<strong>Overview</strong>

Adds head bob and view sway, camera motion synced to actions, a realistic first-person feel, and adjustable intensity via config.

---

<div class="realm-shared">
<div class="realm-header">First Person Effects</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Adds head bob and view sway, camera motion synced to actions, a realistic first-person feel, and adjustable intensity via config.</p>

<strong>Main Features</strong>
<ul>
<li>Adds head bob and view sway</li>
<li>Adds camera motion synced to actions</li>
<li>Adds a realistic first-person feel</li>
<li>Adds adjustable intensity via config</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/firstpersoneffects.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.4

- Added comprehensive configuration documentation

### Version 1.3

- Added comprehensive hooks documentation


### Version 1.2

- Updated function naming convention from PascalCase to camelCase for consistency

### Version 1.1

- Created docs

### Version 1.0

- Initial Release


</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/firstpersoneffects.zip)

</details>

<details id="flashlight">
<summary>Flashlight</summary>

### About

Adds a serious flashlight with dynamic light, darkening of surroundings when turned off, adjustable brightness, and keybind toggle support.

---

<strong>Overview</strong>

Adds a serious flashlight with dynamic light, darkening of surroundings when turned off, adjustable brightness, and keybind toggle support.

---

<div class="realm-shared">
<div class="realm-header">Flashlight</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Adds a serious flashlight with dynamic light, darkening of surroundings when turned off, adjustable brightness, and keybind toggle support.</p>

<strong>Main Features</strong>
<ul>
<li>Adds a serious flashlight with dynamic light</li>
<li>Adds darkening of surroundings when turned off</li>
<li>Adds adjustable brightness</li>
<li>Adds keybind toggle support</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/flashlight.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.4

- Standardized flashlight toggle sound behavior
- Simplified sound playback logic

### Version 1.3

- Added comprehensive configuration documentation

### Version 1.2
- Added comprehensive hooks documentation

### Version 1.1

- Created docs

### Version 1.0

- Initial Release



</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/flashlight.zip)

</details>

<details id="free-look">
<summary>Free Look</summary>

### About

Adds the ability to look around without turning the body, a toggle key similar to EFT, movement direction preservation, and adjustable sensitivity while freelooking.

---

<strong>Overview</strong>

Adds the ability to look around without turning the body, a toggle key similar to EFT, movement direction preservation, and adjustable sensitivity while freelooking.

---

<div class="realm-shared">
<div class="realm-header">Free Look</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Adds the ability to look around without turning the body, a toggle key similar to EFT, movement direction preservation, and adjustable sensitivity while freelooking.</p>

<strong>Main Features</strong>
<ul>
<li>Adds the ability to look around without turning the body</li>
<li>Adds a toggle key similar to EFT</li>
<li>Adds movement direction preservation</li>
<li>Adds adjustable sensitivity while freelooking</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/freelook.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.3

- Added comprehensive configuration documentation

### Version 1.2
- Added comprehensive hooks documentation

### Version 1.1

- Created docs

### Version 1.0

- Initial Release



</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/freelook.zip)

</details>

<details id="gamemaster-points">
<summary>Gamemaster Points</summary>

### About

Adds teleport points for game masters, quick navigation across large maps, saving of locations for reuse, a command to list saved points, and sharing of points with other staff.

---

<strong>Overview</strong>

Adds teleport points for game masters, quick navigation across large maps, saving of locations for reuse, a command to list saved points, and sharing of points with other staff.

---

<div class="realm-shared">
<div class="realm-header">Gamemaster Points</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Adds teleport points for game masters, quick navigation across large maps, saving of locations for reuse, a command to list saved points, and sharing of points with other staff.</p>

<strong>Main Features</strong>
<ul>
<li>Adds teleport points for game masters</li>
<li>Adds quick navigation across large maps</li>
<li>Adds saving of locations for reuse</li>
<li>Adds a command to list saved points</li>
<li>Adds sharing of points with other staff</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/gamemasterpoints.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.4

- Changed button font from ChatFont to LiliaFont.16 for better UI consistency

### Version 1.3

- Added comprehensive hooks documentation


### Version 1.2

- Client library functions and optimizations

### Version 1.1

- Created docs

### Version 1.0

- Initial Release


</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/gamemasterpoints.zip)

</details>

<details id="hospitals">
<summary>Hospitals</summary>

### About

Adds respawning of players at hospitals with support for multiple hospital spawn locations on different maps.

---

<strong>Overview</strong>

Adds respawning of players at hospitals with support for multiple hospital spawn locations on different maps.

---

<div class="realm-shared">
<div class="realm-header">Hospitals</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Adds respawning of players at hospitals with support for multiple hospital spawn locations on different maps.</p>

<strong>Main Features</strong>
<ul>
<li>Adds respawning of players at hospitals</li>
<li>Adds support for multiple hospital spawn locations</li>
<li>Supports different hospital locations for different maps</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/hospitals.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.0

- Initial Release



</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/hospitals.zip)

</details>

<details id="hud-extras">
<summary>HUD Extras</summary>

### About

Adds extra HUD elements like an FPS counter, fonts configurable with FPSHudFont, hooks so other modules can extend, performance stats display, and toggles for individual HUD elements.

---

<strong>Overview</strong>

Adds extra HUD elements like an FPS counter, fonts configurable with FPSHudFont, hooks so other modules can extend, performance stats display, and toggles for individual HUD elements.

---

<div class="realm-shared">
<div class="realm-header">HUD Extras</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Adds extra HUD elements like an FPS counter, fonts configurable with FPSHudFont, hooks so other modules can extend, performance stats display, and toggles for individual HUD elements.</p>

<strong>Main Features</strong>
<ul>
<li>Adds extra HUD elements like an FPS counter</li>
<li>Adds fonts configurable with FPSHudFont</li>
<li>Adds hooks so other modules can extend</li>
<li>Adds performance stats display</li>
<li>Adds toggles for individual HUD elements</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/hud_extras.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.4

- Added comprehensive configuration documentation
- Configuration updates and improvements

### Version 1.3

- Added comprehensive hooks documentation


### Version 1.2

- Updated blur effect to use network variables (`getNetVar`) instead of local variables (`getLocalVar`) for better synchronization

### Version 1.1

- Created docs

### Version 1.0

- Initial Release


</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/hud_extras.zip)

</details>

<details id="instakill">
<summary>Instakill</summary>

### About

Adds instant kill on headshots, lethality configurable per weapon, extra tension to combat, and integration with damage numbers.

---

<strong>Overview</strong>

Adds instant kill on headshots, lethality configurable per weapon, extra tension to combat, and integration with damage numbers.

---

<div class="realm-shared">
<div class="realm-header">Instakill</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Adds instant kill on headshots, lethality configurable per weapon, extra tension to combat, and integration with damage numbers.</p>

<strong>Main Features</strong>
<ul>
<li>Adds instant kill on headshots</li>
<li>Adds lethality configurable per weapon</li>
<li>Adds extra tension to combat</li>
<li>Adds integration with damage numbers</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/instakill.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.3

- Added comprehensive configuration documentation

### Version 1.2
- Added comprehensive hooks documentation

### Version 1.1

- Created docs

### Version 1.0

- Initial Release



</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/instakill.zip)

</details>

<details id="join-leave-messages">
<summary>Join Leave Messages</summary>

### About

Adds announcements when players join, notifications on disconnect, improved community awareness, relay of messages to Discord, and per-player toggle to hide messages.

---

<strong>Overview</strong>

Adds announcements when players join, notifications on disconnect, improved community awareness, relay of messages to Discord, and per-player toggle to hide messages.

---

<div class="realm-shared">
<div class="realm-header">Join Leave Messages</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Adds announcements when players join, notifications on disconnect, improved community awareness, relay of messages to Discord, and per-player toggle to hide messages.</p>

<strong>Main Features</strong>
<ul>
<li>Adds announcements when players join</li>
<li>Adds notifications on disconnect</li>
<li>Adds improved community awareness</li>
<li>Adds relay of messages to Discord</li>
<li>Adds per-player toggle to hide messages</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/joinleavemessages.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.2
- Added comprehensive hooks documentation

### Version 1.1

- Created docs

### Version 1.0

- Initial Release



</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/joinleavemessages.zip)

</details>

<details id="load-messages">
<summary>Load Messages</summary>

### About

Adds faction-based load messages, execution when players first load a character, customizable message text, color-coded formatting options, and per-faction enable toggles.

---

<strong>Overview</strong>

Adds faction-based load messages, execution when players first load a character, customizable message text, color-coded formatting options, and per-faction enable toggles.

---

<div class="realm-shared">
<div class="realm-header">Load Messages</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Adds faction-based load messages, execution when players first load a character, customizable message text, color-coded formatting options, and per-faction enable toggles.</p>

<strong>Main Features</strong>
<ul>
<li>Adds faction-based load messages</li>
<li>Adds execution when players first load a character</li>
<li>Adds customizable message text</li>
<li>Adds color-coded formatting options</li>
<li>Adds per-faction enable toggles</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/loadmessages.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.3

- Added comprehensive configuration documentation

### Version 1.2
- Added comprehensive hooks documentation

### Version 1.1

- Created docs

### Version 1.0

- Initial Release



</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/loadmessages.zip)

</details>

<details id="loyalism">
<summary>Loyalism</summary>

### About

Adds a loyalty tier system for players, the /partytier command access, permission control through flags, automatic tier progression, and customizable rewards per tier.

---

<strong>Overview</strong>

Adds a loyalty tier system for players, the /partytier command access, permission control through flags, automatic tier progression, and customizable rewards per tier.

---

<div class="realm-shared">
<div class="realm-header">Loyalism</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Adds a loyalty tier system for players, the /partytier command access, permission control through flags, automatic tier progression, and customizable rewards per tier.</p>

<strong>Main Features</strong>
<ul>
<li>Adds a loyalty tier system for players</li>
<li>Adds the /partytier command for tier management</li>
<li>Adds permission control through T flag</li>
<li>Adds automatic tier progression</li>
<li>Adds customizable rewards per tier</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/loyalism.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.3

- Added comprehensive configuration documentation

### Version 1.2
- Added comprehensive hooks documentation

### Version 1.1

- Created docs

### Version 1.0

- Initial Release



</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/loyalism.zip)

</details>

<details id="map-cleaner">
<summary>Map Cleaner</summary>

### About

Adds periodic cleaning of map debris, a configurable interval, reduced server lag, a whitelist for protected entities, and manual cleanup commands.

---

<strong>Overview</strong>

Adds periodic cleaning of map debris, a configurable interval, reduced server lag, a whitelist for protected entities, and manual cleanup commands.

---

<div class="realm-shared">
<div class="realm-header">Map Cleaner</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Adds periodic cleaning of map debris, a configurable interval, reduced server lag, a whitelist for protected entities, and manual cleanup commands.</p>

<strong>Main Features</strong>
<ul>
<li>Adds periodic cleaning of map debris (prop_physics entities)</li>
<li>Adds periodic cleaning of dropped items (lia_item entities)</li>
<li>Adds configurable cleanup intervals for items and map debris</li>
<li>Adds reduced server lag through automatic cleanup</li>
<li>Adds whitelist system for protected entity types</li>
<li>Adds enable/disable toggle for the cleanup system</li>
<li>Adds warning messages before cleanup (60 seconds prior)</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/mapcleaner.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.3

- Added comprehensive configuration documentation

### Version 1.2
- Added comprehensive hooks documentation

### Version 1.1

- Created docs

### Version 1.0

- Initial Release



</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/mapcleaner.zip)

</details>

<details id="model-pay">
<summary>Model Pay</summary>

### About

Adds payment to characters based on model, custom wage definitions, integration into the economy, config to exclude certain models, and logs of wages issued.

---

<strong>Overview</strong>

Adds payment to characters based on model, custom wage definitions, integration into the economy, config to exclude certain models, and logs of wages issued.

---

<div class="realm-shared">
<div class="realm-header">Model Pay</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Adds payment to characters based on model, custom wage definitions, integration into the economy, config to exclude certain models, and logs of wages issued.</p>

<strong>Main Features</strong>
<ul>
<li>Adds payment to characters based on model</li>
<li>Adds custom wage definitions</li>
<li>Adds integration into the economy</li>
<li>Adds config to exclude certain models</li>
<li>Adds logs of wages issued</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/modelpay.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.2
- Added comprehensive hooks documentation

### Version 1.1

- Created docs

### Version 1.0

- Initial Release



</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/modelpay.zip)

</details>

<details id="model-tweaker">
<summary>Model Tweaker</summary>

### About

Adds an entity to tweak prop models, adjustments for scale and rotation, easy UI controls, saving of tweaked props between restarts, and undo support for recent tweaks.

---

<strong>Overview</strong>

Adds an entity to tweak prop models, adjustments for scale and rotation, easy UI controls, saving of tweaked props between restarts, and undo support for recent tweaks.

---

<div class="realm-shared">
<div class="realm-header">Model Tweaker</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Adds an entity to tweak prop models, adjustments for scale and rotation, easy UI controls, saving of tweaked props between restarts, and undo support for recent tweaks.</p>

<strong>Main Features</strong>
<ul>
<li>Adds an entity to tweak prop models</li>
<li>Adds adjustments for scale and rotation</li>
<li>Adds easy UI controls</li>
<li>Adds saving of tweaked props between restarts</li>
<li>Adds undo support for recent tweaks</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/modeltweaker.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.4

- Added comprehensive configuration documentation

### Version 1.3

- Added comprehensive hooks documentation


### Version 1.2

- Updated function naming convention from PascalCase to camelCase for consistency

### Version 1.1

- Created docs

### Version 1.0

- Initial Release


</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/modeltweaker.zip)

</details>

<details id="npc-drop">
<summary>NPC Drop</summary>

### About

Adds NPCs that drop items on death, DropTable to define probabilities, encouragement for looting, editable drop tables per NPC type, and weighted chances for rare items.

---

<strong>Overview</strong>

Adds NPCs that drop items on death, DropTable to define probabilities, encouragement for looting, editable drop tables per NPC type, and weighted chances for rare items.

---

<div class="realm-shared">
<div class="realm-header">NPC Drop</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Adds NPCs that drop items on death, DropTable to define probabilities, encouragement for looting, editable drop tables per NPC type, and weighted chances for rare items.</p>

<strong>Main Features</strong>
<ul>
<li>Adds NPCs that drop items on death</li>
<li>Adds DropTable to define probabilities</li>
<li>Adds encouragement for looting</li>
<li>Adds editable drop tables per NPC type</li>
<li>Adds weighted chances for rare items</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/npcdrop.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.3

- Added comprehensive configuration documentation

### Version 1.2

- Added comprehensive hooks documentation

### Version 1.1

- Created docs

### Version 1.0

- Initial Release


</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/npcdrop.zip)

</details>

<details id="npc-money">
<summary>NPC Money</summary>

### About

Adds NPCs that give money to players on death, MoneyTable to define rewards, editable money amounts per NPC type, and configurable default values.

---

<strong>Overview</strong>

Adds NPCs that give money to players on death, MoneyTable to define rewards, editable money amounts per NPC type, and configurable default values.

---

<div class="realm-shared">
<div class="realm-header">NPC Money</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Adds NPCs that give money to players on death, MoneyTable to define rewards, editable money amounts per NPC type, and configurable default values.</p>

<strong>Main Features</strong>
<ul>
<li>Adds NPCs that give money to players on death</li>
<li>Adds MoneyTable to define reward amounts</li>
<li>Gives money directly to the player who killed the NPC</li>
<li>Adds editable money amounts per NPC type</li>
<li>Adds configurable default values for unlisted NPCs</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/npcmoney.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.0

- Initial Release


</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/npcmoney.zip)

</details>

<details id="npc-spawner">
<summary>NPC Spawner</summary>

### About

Adds automatic NPC spawns at points, the ability for admins to force spawns, logging of spawn actions, and configuration for spawn intervals.

---

<strong>Overview</strong>

Adds automatic NPC spawns at points, the ability for admins to force spawns, logging of spawn actions, and configuration for spawn intervals.

---

<div class="realm-shared">
<div class="realm-header">NPC Spawner</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Adds automatic NPC spawns at points, the ability for admins to force spawns, logging of spawn actions, and configuration for spawn intervals.</p>

<strong>Main Features</strong>
<ul>
<li>Adds automatic NPC spawns at points</li>
<li>Adds the ability for admins to force spawns</li>
<li>Adds logging of spawn actions</li>
<li>Adds configuration for spawn intervals</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/npcspawner.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.3

- Added comprehensive configuration documentation

### Version 1.2

- Added comprehensive hooks documentation

### Version 1.1

- Created docs

### Version 1.0

- Initial Release


</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/npcspawner.zip)

</details>

<details id="perma-remove">
<summary>Perma Remove</summary>

### About

Adds ability to permanently delete map entities, logging for each removed entity, an admin-only command, confirmation prompts before removal, and restore list to undo mistakes.

---

<strong>Overview</strong>

Adds ability to permanently delete map entities, logging for each removed entity, an admin-only command, confirmation prompts before removal, and restore list to undo mistakes.

---

<div class="realm-shared">
<div class="realm-header">Perma Remove</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Adds ability to permanently delete map entities, logging for each removed entity, an admin-only command, confirmation prompts before removal, and restore list to undo mistakes.</p>

<strong>Main Features</strong>
<ul>
<li>Adds ability to permanently delete map entities</li>
<li>Adds logging for each removed entity</li>
<li>Adds an admin-only command</li>
<li>Adds confirmation prompts before removal</li>
<li>Adds restore list to undo mistakes</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/permaremove.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.2

- Added comprehensive hooks documentation

### Version 1.1

- Created docs

### Version 1.0

- Initial Release


</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/permaremove.zip)

</details>

<details id="radio">
<summary>Radio</summary>

### About

Adds a radio chat channel for players, font configuration via RadioFont, workshop models for radios, frequency channels for groups, and handheld radio items.

---

<strong>Overview</strong>

Adds a radio chat channel for players, font configuration via RadioFont, workshop models for radios, frequency channels for groups, and handheld radio items.

---

<div class="realm-shared">
<div class="realm-header">Radio</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Adds a radio chat channel for players, font configuration via RadioFont, workshop models for radios, frequency channels for groups, and handheld radio items.</p>

<strong>Main Features</strong>
<ul>
<li>Adds a radio chat channel for players</li>
<li>Adds font configuration via RadioFont</li>
<li>Adds workshop models for radios</li>
<li>Adds frequency channels for groups</li>
<li>Adds handheld radio items</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/radio.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.6

- Updated Vector method calls to use proper PascalCase naming (`distance` → `Distance`)

### Version 1.5

- Added comprehensive configuration documentation
- Configuration updates and improvements

### Version 1.4

- Added comprehensive hooks documentation


### Version 1.3

- Shared library functions and language files for all supported languages (English, French, German, Italian, Portuguese, Spanish)
- Configuration and shared library optimizations

### Version 1.2

- Updated function naming convention from PascalCase to camelCase for consistency

### Version 1.1

- Created docs

### Version 1.0

- Initial Release


</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/radio.zip)

</details>

<details id="raised-weapons">
<summary>Raised Weapons</summary>

### About

Adds auto-lowering of weapons when running, a raise delay set by WeaponRaiseSpeed, prevention of accidental fire, a toggle to keep weapons lowered, and compatibility with melee weapons.

---

<strong>Overview</strong>

Adds auto-lowering of weapons when running, a raise delay set by WeaponRaiseSpeed, prevention of accidental fire, a toggle to keep weapons lowered, and compatibility with melee weapons.

---

<div class="realm-shared">
<div class="realm-header">Raised Weapons</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Adds auto-lowering of weapons when running, a raise delay set by WeaponRaiseSpeed, prevention of accidental fire, a toggle to keep weapons lowered, and compatibility with melee weapons.</p>

<strong>Main Features</strong>
<ul>
<li>Adds auto-lowering of weapons when running</li>
<li>Adds a raise delay set by WeaponRaiseSpeed</li>
<li>Adds prevention of accidental fire</li>
<li>Adds a toggle to keep weapons lowered</li>
<li>Adds compatibility with melee weapons</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/raisedweapons.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.4

- Updated Angle method calls to use proper PascalCase naming (`up` → `Up`, `Forward` → `Forward`, `right` → `Right`, `rotateAroundAxis` → `RotateAroundAxis`)

### Version 1.3

- Added comprehensive hooks documentation


### Version 1.2

- Updated function naming convention from PascalCase to camelCase for consistency

### Version 1.1

- Created docs

### Version 1.0

- Initial Release


</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/raisedweapons.zip)

</details>

<details id="realistic-view">
<summary>Realistic View</summary>

### About

Adds a first-person view that shows the full body, immersive camera transitions, compatibility with animations, smooth leaning animations, and optional third-person override.

---

<strong>Overview</strong>

Adds a first-person view that shows the full body, immersive camera transitions, compatibility with animations, smooth leaning animations, and optional third-person override.

---

<div class="realm-shared">
<div class="realm-header">Realistic View</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Adds a first-person view that shows the full body, immersive camera transitions, compatibility with animations, smooth leaning animations, and optional third-person override.</p>

<strong>Main Features</strong>
<ul>
<li>Adds a first-person view that shows the full body</li>
<li>Adds immersive camera transitions</li>
<li>Adds compatibility with animations</li>
<li>Adds smooth leaning animations</li>
<li>Adds optional third-person override</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/realisticview.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.4

- Updated Angle method calls to use proper PascalCase naming (`up` → `Up`)

### Version 1.3

- Added comprehensive hooks documentation


### Version 1.2

- Updated function naming convention from PascalCase to camelCase for consistency

### Version 1.1

- Created docs

### Version 1.0

- Initial Release


</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/realisticview.zip)

</details>

<details id="shoot-lock">
<summary>Shoot Lock</summary>

### About

Adds the ability to shoot door locks to open them, a quick breach alternative, a loud action that may alert others, and chance-based lock destruction.

---

<strong>Overview</strong>

Adds the ability to shoot door locks to open them, a quick breach alternative, a loud action that may alert others, and chance-based lock destruction.

---

<div class="realm-shared">
<div class="realm-header">Shoot Lock</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Adds the ability to shoot door locks to open them, a quick breach alternative, a loud action that may alert others, and chance-based lock destruction.</p>

<strong>Main Features</strong>
<ul>
<li>Adds the ability to shoot door locks to open them</li>
<li>Adds a quick breach alternative</li>
<li>Adds a loud action that may alert others</li>
<li>Adds chance-based lock destruction</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/shootlock.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.4

- Updated Vector method calls to use proper PascalCase naming (`distance` → `Distance`)

### Version 1.3

- Added comprehensive hooks documentation


### Version 1.2

- Updated function naming convention from PascalCase to camelCase for consistency

### Version 1.1

- Created docs

### Version 1.0

- Initial Release


</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/shootlock.zip)

</details>

<details id="simple-lockpicking">
<summary>Simple Lockpicking</summary>

### About

Adds a simple lockpick tool for doors, logging of successful picks, brute-force style gameplay, configurable pick time, and chance for tools to break.

---

<strong>Overview</strong>

Adds a simple lockpick tool for doors, logging of successful picks, brute-force style gameplay, configurable pick time, and chance for tools to break.

---

<div class="realm-shared">
<div class="realm-header">Simple Lockpicking</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Adds a simple lockpick tool for doors, logging of successful picks, brute-force style gameplay, configurable pick time, and chance for tools to break.</p>

<strong>Main Features</strong>
<ul>
<li>Adds a simple lockpick tool for doors</li>
<li>Adds logging of successful picks</li>
<li>Adds brute-force style gameplay</li>
<li>Adds configurable pick time</li>
<li>Adds chance for tools to break</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/simple_lockpicking.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.2

- Added comprehensive hooks documentation

### Version 1.1

- Created docs

### Version 1.0

- Initial Release


</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/simple_lockpicking.zip)

</details>

<details id="slot-machine">
<summary>Slot Machine</summary>

### About

Adds a slot machine minigame, a workshop model for the machine, handling of payouts to winners, customizable payout odds, and sound and animation effects.

---

<strong>Overview</strong>

Adds a slot machine minigame, a workshop model for the machine, handling of payouts to winners, customizable payout odds, and sound and animation effects.

---

<div class="realm-shared">
<div class="realm-header">Slot Machine</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Adds a slot machine minigame, a workshop model for the machine, handling of payouts to winners, customizable payout odds, and sound and animation effects.</p>

<strong>Main Features</strong>
<ul>
<li>Adds a slot machine minigame</li>
<li>Adds a workshop model for the machine</li>
<li>Adds handling of payouts to winners</li>
<li>Adds customizable payout odds</li>
<li>Adds sound and animation effects</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/slots.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.3

- Added comprehensive configuration documentation

### Version 1.2

- Added comprehensive hooks documentation

### Version 1.1

- Created docs

### Version 1.0

- Initial Release


</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/slots.zip)

</details>

<details id="slow-weapons">
<summary>Slow Weapons</summary>

### About

Adds slower movement while holding heavy weapons, speed penalties defined per weapon, encouragement for strategic choices, customizable weapon speed table, and automatic speed restore when switching.

---

<strong>Overview</strong>

Adds slower movement while holding heavy weapons, speed penalties defined per weapon, encouragement for strategic choices, customizable weapon speed table, and automatic speed restore when switching.

---

<div class="realm-shared">
<div class="realm-header">Slow Weapons</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Adds slower movement while holding heavy weapons, speed penalties defined per weapon, encouragement for strategic choices, customizable weapon speed table, and automatic speed restore when switching.</p>

<strong>Main Features</strong>
<ul>
<li>Adds slower movement while holding heavy weapons</li>
<li>Adds speed penalties defined per weapon</li>
<li>Adds encouragement for strategic choices</li>
<li>Adds customizable weapon speed table</li>
<li>Adds automatic speed restore when switching</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/slowweapons.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.3

- Added comprehensive configuration documentation

### Version 1.2

- Added comprehensive hooks documentation

### Version 1.1

- Created docs

### Version 1.0

- Initial Release


</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/slowweapons.zip)

</details>

<details id="steam-group-rewards">
<summary>Steam Group Rewards</summary>

### About

Provides Steam group membership rewards system that automatically checks group membership and gives money rewards to players who join your Steam group.

---

<strong>Overview</strong>

Provides Steam group membership rewards system that automatically checks group membership and gives money rewards to players who join your Steam group.

---

<div class="realm-shared">
<div class="realm-header">Steam Group Rewards</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Provides Steam group membership rewards system that automatically checks group membership and gives money rewards to players who join your Steam group.</p>

<strong>Main Features</strong>
<ul>
<li>Automatic Steam group membership checking every 5 minutes</li>
<li>Manual membership verification on demand</li>
<li>Configurable money rewards for group members</li>
<li>One-time claim per character system</li>
<li>Player commands for easy group access and reward claiming</li>
<li>Server-side tracking of claimed rewards</li>
<li>**GroupID**: Your Steam group ID/name (set in module.lua)</li>
<li>**MoneyReward**: Amount of money to reward players (default: 500, set in module.lua)</li>
<li>`/group`: Opens your Steam group page in the player's browser</li>
<li>`/claim`: Claims the group membership reward (if eligible)</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/steamgrouprewards.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.1

- Added comprehensive configuration documentation

### Version 1.0

- Initial Release


</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/steamgrouprewards.zip)

</details>

<details id="view-manipulation">
<summary>View Manipulation</summary>

### About

Adds VManip animation support, hand gestures for items, functionality within Lilia, API for custom gesture triggers, and fallback animations when VManip is missing.

---

<strong>Overview</strong>

Adds VManip animation support, hand gestures for items, functionality within Lilia, API for custom gesture triggers, and fallback animations when VManip is missing.

---

<div class="realm-shared">
<div class="realm-header">View Manipulation</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Adds VManip animation support, hand gestures for items, functionality within Lilia, API for custom gesture triggers, and fallback animations when VManip is missing.</p>

<strong>Main Features</strong>
<ul>
<li>Adds VManip animation support</li>
<li>Adds hand gestures for items</li>
<li>Adds functionality within Lilia</li>
<li>Adds API for custom gesture triggers</li>
<li>Adds fallback animations when VManip is missing</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/vmanip.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.2

- Added comprehensive hooks documentation

### Version 1.1

- Created docs

### Version 1.0

- Initial Release


</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/vmanip.zip)

</details>

<details id="war-table">
<summary>War Table</summary>

### About

Adds an interactive 3D war table, the ability to plan operations on a map, a workshop model, marker placement for strategies, and support for multiple map layouts.

---

<strong>Overview</strong>

Adds an interactive 3D war table, the ability to plan operations on a map, a workshop model, marker placement for strategies, and support for multiple map layouts.

---

<div class="realm-shared">
<div class="realm-header">War Table</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Adds an interactive 3D war table, the ability to plan operations on a map, a workshop model, marker placement for strategies, and support for multiple map layouts.</p>

<strong>Main Features</strong>
<ul>
<li>Adds an interactive 3D war table</li>
<li>Adds the ability to plan operations on a map</li>
<li>Adds a workshop model</li>
<li>Adds marker placement for strategies</li>
<li>Adds support for multiple map layouts</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/wartable.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.5

- Updated Angle method calls to use proper PascalCase naming (`rotateAroundAxis` → `RotateAroundAxis`)

### Version 1.4

- Added comprehensive configuration documentation

### Version 1.3

- Added comprehensive hooks documentation


### Version 1.2

- Updated function naming convention from PascalCase to camelCase for consistency

### Version 1.1

- Created docs

### Version 1.0

- Initial Release


</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/wartable.zip)

</details>

<details id="word-filter">
<summary>Word Filter</summary>

### About

Adds chat word filtering, blocking of banned phrases, an easy-to-extend list, and admin commands to modify the list.

---

<strong>Overview</strong>

Adds chat word filtering, blocking of banned phrases, an easy-to-extend list, and admin commands to modify the list.

---

<div class="realm-shared">
<div class="realm-header">Word Filter</div>
<div class="details-content">
<strong>Purpose</strong>
<p>Adds chat word filtering, blocking of banned phrases, an easy-to-extend list, and admin commands to modify the list.</p>

<strong>Main Features</strong>
<ul>
<li>Adds chat word filtering</li>
<li>Adds blocking of banned phrases</li>
<li>Adds an easy-to-extend list</li>
<li>Adds admin commands to modify the list</li>
</ul>


<p align="center"><a href="https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/wordfilter.zip" style="display:inline-block;padding:12px 24px;font-size:1.5rem;font-weight:bold;text-decoration:none;color:#fff;background-color:var(--md-primary-fg-color,#007acc);border-radius:4px;">DOWNLOAD HERE</a></p>
</div>
</div>

- <details><summary>Changelog</summary>

# Changelog

### Version 1.3

- Added comprehensive configuration documentation

### Version 1.2

- Added comprehensive hooks documentation


### Version 1.1

- Created docs

### Version 1.0

- Initial Release


</details>
- [Download Button](https://github.com/LiliaFramework/Modules/raw/refs/heads/gh-pages/wordfilter.zip)

</details>


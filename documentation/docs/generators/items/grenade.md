<p align="center">
 <h2 style="text-align: center;">Grenade Item Generator</h2>
</p>

<div id="grenade-generator">
  <div class="generator-section">
  <h3>Basic Information</h3>
  <div class="input-group">
  <label for="item-id">Unique ID:</label>
  <input type="text" id="item-id" placeholder="e.g., frag_grenade" value="grenade_frg" oninput="generateGrenadeItem()">
  <small>Unique identifier for this item (no spaces, lowercase)</small>
  </div>

  <div class="input-group">
  <label for="item-name">Item Name:</label>
  <input type="text" id="item-name" placeholder="e.g., Frag Grenade" value="Fragmentation Grenade" oninput="generateGrenadeItem()">
  </div>

  <div class="input-group">
  <label for="item-desc">Description:</label>
  <textarea id="item-desc" placeholder="e.g., A fragmentation grenade that explodes on impact" oninput="generateGrenadeItem()">A standard fragmentation grenade used to clear rooms and groups of enemies.</textarea>
  </div>

  <div class="input-group">
  <label for="item-category">Category:</label>
  <input type="text" id="item-category" placeholder="explosives" value="explosives" oninput="generateGrenadeItem()">
  <small>Inventory category for organization</small>
  </div>
  </div>

  <div class="generator-section">
  <h3>Visual Properties</h3>
  <div class="input-group">
  <label for="item-model">Model:</label>
  <input type="text" id="item-model" placeholder="models/weapons/w_grenade.mdl" value="models/weapons/w_grenade.mdl" oninput="generateGrenadeItem()">
  <small>3D model path for the grenade</small>
  </div>

  <div class="input-group">
  <label for="item-width">Width:</label>
  <input type="number" id="item-width" placeholder="1" min="1" value="1" oninput="generateGrenadeItem()">
  <small>Inventory slot width</small>
  </div>

  <div class="input-group">
  <label for="item-height">Height:</label>
  <input type="number" id="item-height" placeholder="1" min="1" value="1" oninput="generateGrenadeItem()">
  <small>Inventory slot height</small>
  </div>
  </div>

  <div class="generator-section">
  <h3>Grenade Properties</h3>
  <div class="input-group">
  <label for="weapon-class">Weapon Class:</label>
  <input type="text" id="weapon-class" placeholder="weapon_frag" value="weapon_frag" oninput="generateGrenadeItem()">
  <small>Weapon entity class that gets given to the player</small>
  </div>

  <div class="input-group">
  <label>
  <input type="checkbox" id="drop-on-death" checked onchange="generateGrenadeItem()"> Drop On Death
  </label>
  <small>Keep grenade logic consistent on player death</small>
  </div>
  </div>

  <div class="button-group">
  <button onclick="generateGrenadeItem()" class="generate-btn">Generate Grenade Item Code</button>
  <button onclick="fillExampleGrenadeItem()" class="generate-btn example-btn">Generate Example</button>
  </div>
</div>

## Generated Code

```lua
-- Generated grenade item code will appear here after clicking "Generate Grenade Item Code"
```

<style>
/* Material Design inspired styling for Lilia theme */
#grenade-generator {
  max-width: 1100px;
  margin: 0 auto;
  font-family: 'Noto Sans', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  line-height: 1.75;
}

.generator-section {
  background: var(--md-default-fg-color--lightest);
  border: 1px solid var(--md-default-fg-color--lighter);
  border-radius: 14px;
  padding: 28px;
  margin-bottom: 28px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  transition: box-shadow 0.3s ease;
}

[data-md-color-scheme="slate"] .generator-section {
  background: var(--md-default-fg-color--dark);
  border-color: var(--md-default-fg-color--light);
}

.generator-section:hover {
  box-shadow: 0 4px 16px rgba(0,0,0,0.15);
}

.generator-section h3 {
  margin: -8px -8px 24px -8px;
  padding: 18px 24px;
  background: linear-gradient(135deg,#009688 0%,#b39ddb 100%);
  color: white;
  border-radius: 8px 8px 0 0;
  font-weight: 500;
  font-size: 1.6em;
  letter-spacing: 0.02em;
}

[data-md-color-scheme="slate"] .generator-section h3 {
  background: linear-gradient(135deg,#26a69a 0%,#d1c4e9 100%);
}

.input-group {
  margin-bottom: 22px;
}

.input-group label {
  display: block;
  margin-bottom: 8px;
  font-weight: 600;
  color: var(--md-default-fg-color);
  font-size: 1.15em;
}

.input-group input[type="text"],
.input-group input[type="number"],
.input-group textarea {
  width: 100%;
  padding: 14px 18px;
  border: 2px solid var(--md-default-fg-color--lighter);
  border-radius: 10px;
  font-family: 'Roboto Mono', 'Courier New', monospace;
  font-size: 19px;
  background: var(--md-default-fg-color--lightest);
  color: var(--md-default-fg-color);
  transition: border-color 0.3s ease, box-shadow 0.3s ease;
  box-sizing: border-box;
}

[data-md-color-scheme="slate"] .input-group input[type="text"],
[data-md-color-scheme="slate"] .input-group input[type="number"],
[data-md-color-scheme="slate"] .input-group textarea {
  background: var(--md-default-fg-color--dark);
  border-color: var(--md-default-fg-color--light);
  color: var(--md-default-fg-color--light);
}

.input-group input[type="text"]:focus,
.input-group input[type="number"]:focus,
.input-group textarea:focus {
  outline: none;
  border-color:#009688;
  box-shadow: 0 0 0 3px rgba(0, 150, 136, 0.1);
}

[data-md-color-scheme="slate"] .input-group input[type="text"]:focus,
[data-md-color-scheme="slate"] .input-group input[type="number"]:focus,
[data-md-color-scheme="slate"] .input-group textarea:focus {
  border-color:#26a69a;
  box-shadow: 0 0 0 3px rgba(38, 166, 154, 0.2);
}

.input-group textarea {
  resize: vertical;
  min-height: 80px;
  line-height: 1.4;
}

.input-group small {
  display: block;
  color: var(--md-default-fg-color--light);
  font-style: normal;
  margin-top: 6px;
  font-size: 1.05em;
}

[data-md-color-scheme="slate"] .input-group small {
  color: var(--md-default-fg-color--lighter);
}

.input-group label input[type="checkbox"] {
  width: auto;
  margin-right: 10px;
  accent-color:#009688;
}

[data-md-color-scheme="slate"] .input-group label input[type="checkbox"] {
  accent-color:#26a69a;
}

/* Button group for multiple actions */
.button-group {
  display: flex;
  gap: 16px;
  margin: 28px 0;
}

.generate-btn {
  background: linear-gradient(135deg,#009688 0%,#b39ddb 100%);
  color: white;
  border: none;
  padding: 18px 34px;
  border-radius: 10px;
  cursor: pointer;
  font-size: 20px;
  font-weight: 600;
  display: block;
  width: 100%;
  transition: all 0.3s ease;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  box-shadow: 0 4px 12px rgba(0, 150, 136, 0.3);
}

.example-btn {
  background: linear-gradient(135deg,#673ab7 0%,#00bcd4 100%);
  box-shadow: 0 4px 12px rgba(103, 58, 183, 0.3);
}

[data-md-color-scheme="slate"] .generate-btn {
  background: linear-gradient(135deg,#26a69a 0%,#d1c4e9 100%);
  box-shadow: 0 4px 12px rgba(38, 166, 154, 0.3);
}

[data-md-color-scheme="slate"] .example-btn {
  background: linear-gradient(135deg,#7e57c2 0%,#26c6da 100%);
  box-shadow: 0 4px 12px rgba(126, 87, 194, 0.3);
}

.generate-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(0, 150, 136, 0.4);
}

.example-btn:hover {
  box-shadow: 0 6px 20px rgba(103, 58, 183, 0.4);
}

[data-md-color-scheme="slate"] .generate-btn:hover {
  box-shadow: 0 6px 20px rgba(38, 166, 154, 0.4);
}

.generate-btn:active {
  transform: translateY(0);
}

/* Code output styling */
.hljs {
  background: var(--md-code-bg-color) !important;
  color: var(--md-code-fg-color) !important;
}

pre {
  background: var(--md-code-bg-color) !important;
  border: 1px solid var(--md-default-fg-color--lighter) !important;
  border-radius: 8px !important;
  padding: 20px !important;
  overflow-x: auto !important;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1) !important;
}

code {
  font-family: 'Roboto Mono', 'Courier New', monospace !important;
  font-size: 16px !important;
  line-height: 1.5 !important;
}

/* Responsive design */
@media (max-width: 768px) {
 #grenade-generator {
  margin: 0 16px;
  }

  .generator-section {
  padding: 18px;
  margin-bottom: 18px;
  }

  .generator-section h3 {
  font-size: 1.4em;
  padding: 14px 18px;
  }

  .generate-btn {
  padding: 16px 26px;
  font-size: 19px;
  }
}

/* Material Design elevation */
.md-typeset .admonition {
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

[data-md-color-scheme="slate"] .md-typeset .admonition {
  box-shadow: 0 2px 8px rgba(0,0,0,0.2);
}
</style>

<script>
function generateGrenadeItem() {
  const uniqueId = (document.getElementById('item-id').value || '').trim() || 'grenade_example';
  const name = (document.getElementById('item-name').value || '').trim() || 'Grenade Item';
  const desc = (document.getElementById('item-desc').value || '').trim() || 'An explosive grenade item';
  const category = (document.getElementById('item-category').value || '').trim() || 'explosives';
  const model = (document.getElementById('item-model').value || '').trim() || 'models/weapons/w_grenade.mdl';
  const width = document.getElementById('item-width').value || '1';
  const height = document.getElementById('item-height').value || '1';
  const weaponClass = (document.getElementById('weapon-class').value || '').trim() || 'weapon_frag';
  const throwForce = document.getElementById('throw-force').value || '1000';
  const throwSound = document.getElementById('throw-sound').value.trim();
  const dropOnDeath = document.getElementById('drop-on-death').checked;

  let properties = [
  ` name = ${JSON.stringify(name)},`,
  ` desc = ${JSON.stringify(desc)},`,
  ` category = ${JSON.stringify(category)},`,
  ` model = ${JSON.stringify(model)},`,
  ` width = ${width},`,
  ` height = ${height},`,
  ` class = ${JSON.stringify(weaponClass)},`,
  ` DropOnDeath = ${dropOnDeath ? 'true' : 'false'},`
  ];

  const lines = [
  '-- Copy and paste this code into any Lua file that loads during initialization',
  '-- Example: gamemode/items/grenade.lua or schema/items.lua',
  '',
  `lia.item.registerItem(${JSON.stringify(uniqueId)}, "base_grenade", {`,
  ...properties,
  '})'
  ];

  const code = `${lines.join('\n')}\n`;

  const codeBlock = document.querySelector('code');
  if (codeBlock) {
  codeBlock.textContent = code;
  }

  const preElement = document.querySelector('pre');
  if (preElement) {
  preElement.innerHTML = `<code>${code.replace(/</g, '&lt;').replace(/>/g, '&gt;')}</code>`;
  }
}

function fillExampleGrenadeItem() {
  document.getElementById('item-id').value = 'grenade_smoke';
  document.getElementById('item-name').value = 'Smoke Grenade';
  document.getElementById('item-desc').value = 'A smoke grenade that creates a thick cloud of grey smoke, providing cover and blocking line of sight.';
  document.getElementById('item-category').value = 'utility';
  document.getElementById('item-model').value = 'models/weapons/w_smokegrenade.mdl';
  document.getElementById('item-width').value = '1';
  document.getElementById('item-height').value = '1';
  document.getElementById('weapon-class').value = 'weapon_smokegrenade';
  document.getElementById('drop-on-death').checked = false;

  generateGrenadeItem();
}

// Initial generation
document.addEventListener('DOMContentLoaded', () => {
  generateGrenadeItem();
});
</script>

---

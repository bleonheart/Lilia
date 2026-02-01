<p align="center">
 <h2 style="text-align: center;">Stackable Item Generator</h2>
</p>

<div id="stackable-generator">
  <div class="generator-section">
  <h3>Basic Information</h3>
  <div class="input-group">
  <label for="item-id">Unique ID:</label>
  <input type="text" id="item-id" placeholder="e.g., metal_scrap" value="scrap_metal" oninput="generateStackableItem()">
  <small>Unique identifier for this item (no spaces, lowercase)</small>
  </div>

  <div class="input-group">
  <label for="item-name">Item Name:</label>
  <input type="text" id="item-name" placeholder="e.g., Metal Scrap" value="Scrap Metal" oninput="generateStackableItem()">
  </div>

  <div class="input-group">
  <label for="item-desc">Description:</label>
  <textarea id="item-desc" placeholder="e.g., A piece of scrap metal that can be used for crafting" oninput="generateStackableItem()">A collection of rusty scrap metal pieces. Useful for crafting.</textarea>
  </div>

  <div class="input-group">
  <label for="item-category">Category:</label>
  <input type="text" id="item-category" placeholder="stackable" value="crafting" oninput="generateStackableItem()">
  <small>Inventory category for organization</small>
  </div>
  </div>

  <div class="generator-section">
  <h3>Visual Properties</h3>
  <div class="input-group">
  <label for="item-model">Model:</label>
  <input type="text" id="item-model" placeholder="models/props_debris/metal_panelchunk01d.mdl" value="models/props_junk/garbage_metalcan002a.mdl" oninput="generateStackableItem()">
  <small>3D model path for the item</small>
  </div>

  <div class="input-group">
  <label for="item-width">Width:</label>
  <input type="number" id="item-width" placeholder="1" min="1" value="1" oninput="generateStackableItem()">
  <small>Inventory slot width</small>
  </div>

  <div class="input-group">
  <label for="item-height">Height:</label>
  <input type="number" id="item-height" placeholder="1" min="1" value="1" oninput="generateStackableItem()">
  <small>Inventory slot height</small>
  </div>
  </div>

  <div class="generator-section">
  <h3>Stacking Properties</h3>
  <div class="input-group">
  <label for="max-quantity">Maximum Quantity:</label>
  <input type="number" id="max-quantity" placeholder="10" min="1" value="10" oninput="generateStackableItem()">
  <small>Maximum number of items that can stack together</small>
  </div>

  <div class="input-group">
  <label>
  <input type="checkbox" id="can-split" checked onchange="generateStackableItem()"> Can Split
  </label>
  <small>Allow players to split stacks by dropping partial amounts</small>
  </div>
  </div>

  <div class="button-group">
  <button onclick="generateStackableItem()" class="generate-btn">Generate Stackable Item Code</button>
  <button onclick="fillExampleStackableItem()" class="generate-btn example-btn">Generate Example</button>
  </div>
</div>

## Generated Code

```lua
-- Generated stackable item code will appear here after clicking "Generate Stackable Item Code"
```

<style>
/* Material Design inspired styling for Lilia theme */
#stackable-generator {
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
 #stackable-generator {
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
function generateStackableItem() {
  const uniqueId = (document.getElementById('item-id').value || '').trim() || 'stackable_example';
  const name = (document.getElementById('item-name').value || '').trim() || 'Stackable Item';
  const desc = (document.getElementById('item-desc').value || '').trim() || 'A stackable item description';
  const category = (document.getElementById('item-category').value || '').trim() || 'stackable';
  const model = (document.getElementById('item-model').value || '').trim() || 'models/props_debris/metal_panelchunk01d.mdl';
  const width = document.getElementById('item-width').value || '1';
  const height = document.getElementById('item-height').value || '1';
  const maxQuantity = document.getElementById('max-quantity').value || '10';
  const canSplit = document.getElementById('can-split').checked;

  const properties = [
  ` name = ${JSON.stringify(name)},`,
  ` desc = ${JSON.stringify(desc)},`,
  ` category = ${JSON.stringify(category)},`,
  ` model = ${JSON.stringify(model)},`,
  ` width = ${width},`,
  ` height = ${height},`,
  ` isStackable = true,`,
  ` maxQuantity = ${maxQuantity},`,
  ` canSplit = ${canSplit ? 'true' : 'false'}`
  ];

  const lines = [
  '-- Copy and paste this code into any Lua file that loads during initialization',
  '-- Example: gamemode/items/stackable.lua or schema/items.lua',
  '',
  `lia.item.registerItem(${JSON.stringify(uniqueId)}, "base_stackable", {`,
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

function fillExampleStackableItem() {
  document.getElementById('item-id').value = 'rare_crystals';
  document.getElementById('item-name').value = 'Rare Crystals';
  document.getElementById('item-desc').value = 'Glowing blue crystals harvested from deep within the caves. Extremely valuable and used in high-tech repairs.';
  document.getElementById('item-category').value = 'rare_items';
  document.getElementById('item-model').value = 'models/props_mining/crystal01a.mdl';
  document.getElementById('item-width').value = '1';
  document.getElementById('item-height').value = '1';
  document.getElementById('max-quantity').value = '5';
  document.getElementById('can-split').checked = true;

  generateStackableItem();
}

// Initial generation
document.addEventListener('DOMContentLoaded', () => {
  generateStackableItem();
});
</script>

---

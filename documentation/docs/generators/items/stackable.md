<div class="generator-grid">
  <!-- Input Column -->
  <div class="generator-card form-card">
    <div class="generator-section">
      <div class="form-grid-2">
        <div class="input-group">
          <label for="item-id">Unique ID:</label>
          <input type="text" id="item-id" placeholder="e.g., metal_scrap" value="scrap_metal" oninput="generateStackableItem()">
          <small>Unique identifier for this item (no spaces, lowercase)</small>
        </div>

        <div class="input-group">
          <label for="item-name">Item Name:</label>
          <input type="text" id="item-name" placeholder="e.g., Metal Scrap" value="Scrap Metal" oninput="generateStackableItem()">
        </div>
      </div>

      <div class="input-group">
        <label for="item-desc">Description:</label>
        <textarea id="item-desc" placeholder="e.g., A piece of scrap metal that can be used for crafting" oninput="generateStackableItem()">A collection of rusty scrap metal pieces. Useful for crafting.</textarea>
      </div>

    </div>

    <div class="generator-section">
      <div class="input-group">
        <label for="item-model">Model:</label>
        <input type="text" id="item-model" placeholder="models/props_debris/metal_panelchunk01d.mdl" value="models/props_junk/garbage_metalcan002a.mdl" oninput="generateStackableItem()">
        <small>3D model path for the item</small>
      </div>

      <div class="form-grid-2">
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
    </div>

    <div class="generator-section">
      <div class="form-grid-2">
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
    </div>

    <div class="button-group">
      <button onclick="generateStackableItem()" class="generate-btn">Generate Stackable Item Code</button>
      <button onclick="fillExampleStackableItem()" class="generate-btn example-btn">Generate Example</button>
    </div>
  </div>

  <!-- Output Column -->
  <div class="generator-card output-card">
    <div class="card-header">
      <h3>Generated Code</h3>
    </div>
    <textarea id="output-code" class="generator-code-output" readonly></textarea>
  </div>
</div>

<script>
function generateStackableItem() {
  const uniqueId = (document.getElementById('item-id').value || '').trim() || 'stackable_example';
  const name = (document.getElementById('item-name').value || '').trim() || 'Stackable Item';
  const desc = (document.getElementById('item-desc').value || '').trim() || 'A stackable item description';
  const model = (document.getElementById('item-model').value || '').trim() || 'models/props_debris/metal_panelchunk01d.mdl';
  const width = document.getElementById('item-width').value || '1';
  const height = document.getElementById('item-height').value || '1';
  const maxQuantity = document.getElementById('max-quantity').value || '10';
  const canSplit = document.getElementById('can-split').checked;

  const properties = [
    `    name = ${JSON.stringify(name)},`,
    `    desc = ${JSON.stringify(desc)},`,
    `    model = ${JSON.stringify(model)},`,
    `    width = ${width},`,
    `    height = ${height},`,
    `    isStackable = true,`,
    `    maxQuantity = ${maxQuantity},`,
    `    canSplit = ${canSplit ? 'true' : 'false'}`
  ];

  const lines = [
  '-- Copy and paste this code into any Lua file that loads during initialization',
  '-- Example: [schema folder]/schema/items.lua',
  '',
  `lia.item.registerItem(${JSON.stringify(uniqueId)}, "base_stackable", {`,
  ...properties,
  '})'
  ];

  const code = `${lines.join('\n')}\n`;

  const outputBox = document.getElementById('output-code');
  if (outputBox) {
    outputBox.value = code;
  }
}

function fillExampleStackableItem() {
  document.getElementById('item-id').value = 'rare_crystals';
  document.getElementById('item-name').value = 'Rare Crystals';
  document.getElementById('item-desc').value = 'Glowing blue crystals harvested from deep within the caves. Extremely valuable and used in high-tech repairs.';
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

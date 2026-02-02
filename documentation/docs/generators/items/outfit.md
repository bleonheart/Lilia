<div class="generator-grid">
  <!-- Input Column -->
  <div class="generator-card form-card">
    <div class="generator-section">
      <div class="form-grid-2">
        <div class="input-group">
          <label for="item-id">Unique ID:</label>
          <input type="text" id="item-id" placeholder="e.g., police_uniform" value="outfit_civilian" oninput="generateOutfitItem()">
          <small>Unique identifier for this item (no spaces, lowercase)</small>
        </div>

        <div class="input-group">
          <label for="item-name">Item Name:</label>
          <input type="text" id="item-name" placeholder="e.g., Police Uniform" value="Civilian Outfit" oninput="generateOutfitItem()">
        </div>
      </div>

      <div class="input-group">
        <label for="item-desc">Description:</label>
        <textarea id="item-desc" placeholder="e.g., Standard police officer uniform with body armor" oninput="generateOutfitItem()">A simple civilian outfit, comfortable and unassuming.</textarea>
      </div>

    </div>

    <div class="generator-section">
      <div class="input-group">
        <label for="item-model">Model:</label>
        <input type="text" id="item-model" placeholder="models/player/police.mdl" value="models/props_junk/garbage_bag001a.mdl" oninput="generateOutfitItem()">
        <small>3D model path for the outfit item</small>
      </div>

      <div class="form-grid-2">
        <div class="input-group">
          <label for="item-width">Width:</label>
          <input type="number" id="item-width" placeholder="2" min="1" value="2" oninput="generateOutfitItem()">
          <small>Inventory slot width</small>
        </div>

        <div class="input-group">
          <label for="item-height">Height:</label>
          <input type="number" id="item-height" placeholder="2" min="1" value="2" oninput="generateOutfitItem()">
          <small>Inventory slot height</small>
        </div>
      </div>
    </div>

    <div class="generator-section">
      <div class="input-group">
        <label for="outfit-category">Outfit Category:</label>
        <input type="text" id="outfit-category" placeholder="police" value="torso" oninput="generateOutfitItem()">
        <small>Category for outfit organization and replacement logic</small>
      </div>
    </div>

    <div class="button-group">
      <button onclick="generateOutfitItem()" class="generate-btn">Generate Outfit Item Code</button>
      <button onclick="fillExampleOutfitItem()" class="generate-btn example-btn">Generate Example</button>
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
function generateOutfitItem() {
  const uniqueId = (document.getElementById('item-id').value || '').trim() || 'outfit_example';
  const name = (document.getElementById('item-name').value || '').trim() || 'Outfit Item';
  const desc = (document.getElementById('item-desc').value || '').trim() || 'A wearable outfit item';
  const model = (document.getElementById('item-model').value || '').trim() || 'models/player/police.mdl';
  const width = document.getElementById('item-width').value || '2';
  const height = document.getElementById('item-height').value || '2';
  const outfitCategory = (document.getElementById('outfit-category').value || '').trim() || 'general';

  let properties = [
    `    name = ${JSON.stringify(name)},`,
    `    desc = ${JSON.stringify(desc)},`,
    `    model = ${JSON.stringify(model)},`,
    `    width = ${width},`,
    `    height = ${height},`,
    `    isOutfit = true,`,
    `    outfitCategory = ${JSON.stringify(outfitCategory)},`
  ];

  const lines = [
  '-- Copy and paste this code into any Lua file that loads during initialization',
  '-- Example: [schema folder]/schema/items.lua',
  '',
  `lia.item.registerItem(${JSON.stringify(uniqueId)}, "base_outfit", {`,
  ...properties,
  '})'
  ];

  const code = `${lines.join('\n')}\n`;

  const outputBox = document.getElementById('output-code');
  if (outputBox) {
    outputBox.value = code;
  }
}

function fillExampleOutfitItem() {
  document.getElementById('item-id').value = 'outfit_rebel';
  document.getElementById('item-name').value = 'Rebel Uniform';
  document.getElementById('item-desc').value = 'A worn rebel uniform, equipped with light padding and multiple pockets for gear.';
  document.getElementById('item-model').value = 'models/player/rebel.mdl';
  document.getElementById('item-width').value = '2';
  document.getElementById('item-height').value = '2';
  document.getElementById('outfit-category').value = 'outfit';

  generateOutfitItem();
}

// Initial generation
document.addEventListener('DOMContentLoaded', () => {
  generateOutfitItem();
});
</script>

---

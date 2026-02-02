<div class="generator-grid">
  <!-- Input Column -->
  <div class="generator-card form-card">
    <div class="generator-section">
      <div class="form-grid-2">
        <div class="input-group">
          <label for="item-id">Unique ID:</label>
          <input type="text" id="item-id" placeholder="e.g., frag_grenade" value="grenade_frg" oninput="generateGrenadeItem()">
          <small>Unique identifier for this item (no spaces, lowercase)</small>
        </div>

        <div class="input-group">
          <label for="item-name">Item Name:</label>
          <input type="text" id="item-name" placeholder="e.g., Frag Grenade" value="Fragmentation Grenade" oninput="generateGrenadeItem()">
        </div>
      </div>

      <div class="input-group">
        <label for="item-desc">Description:</label>
        <textarea id="item-desc" placeholder="e.g., A fragmentation grenade that explodes on impact" oninput="generateGrenadeItem()">A standard fragmentation grenade used to clear rooms and groups of enemies.</textarea>
      </div>

    </div>

    <div class="generator-section">
      <div class="input-group">
        <label for="item-model">Model:</label>
        <input type="text" id="item-model" placeholder="models/weapons/w_grenade.mdl" value="models/weapons/w_grenade.mdl" oninput="generateGrenadeItem()">
        <small>3D model path for the grenade</small>
      </div>

      <div class="form-grid-2">
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
    </div>

    <div class="generator-section">
      <div class="form-grid-2">
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
    </div>

    <div class="button-group">
      <button onclick="generateGrenadeItem()" class="generate-btn">Generate Grenade Item Code</button>
      <button onclick="fillExampleGrenadeItem()" class="generate-btn example-btn">Generate Example</button>
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
function generateGrenadeItem() {
  const uniqueId = (document.getElementById('item-id').value || '').trim() || 'grenade_example';
  const name = (document.getElementById('item-name').value || '').trim() || 'Grenade Item';
  const desc = (document.getElementById('item-desc').value || '').trim() || 'A grenade item';
  const model = (document.getElementById('item-model').value || '').trim() || 'models/weapons/w_grenade.mdl';
  const width = document.getElementById('item-width').value || '1';
  const height = document.getElementById('item-height').value || '1';
  const weaponClass = (document.getElementById('weapon-class').value || '').trim() || 'weapon_frag';
  const dropOnDeath = document.getElementById('drop-on-death').checked;

  let properties = [
    `    name = ${JSON.stringify(name)},`,
    `    desc = ${JSON.stringify(desc)},`,
    `    model = ${JSON.stringify(model)},`,
    `    width = ${width},`,
    `    height = ${height},`,
    `    class = ${JSON.stringify(weaponClass)},`,
    `    DropOnDeath = ${dropOnDeath ? 'true' : 'false'},`
  ];

  const lines = [
    '-- Copy and paste this code into any Lua file that loads during initialization',
    '-- Example: [schema folder]/schema/items.lua',
    '',
    `lia.item.registerItem(${JSON.stringify(uniqueId)}, "base_grenade", {`,
    ...properties,
    '})'
  ];

  const code = `${lines.join('\n')}\n`;

  const outputBox = document.getElementById('output-code');
  if (outputBox) {
    outputBox.value = code;
  }
}

function fillExampleGrenadeItem() {
  document.getElementById('item-id').value = 'grenade_smoke';
  document.getElementById('item-name').value = 'Smoke Grenade';
  document.getElementById('item-desc').value = 'A smoke grenade that creates a thick cloud of grey smoke, providing cover and blocking line of sight.';
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

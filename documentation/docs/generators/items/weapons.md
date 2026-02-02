<div class="generator-grid">
  <!-- Input Column -->
  <div class="generator-card form-card">
    <div class="generator-section">
      <div class="form-grid-2">
        <div class="input-group">
          <label for="item-id">Unique ID:</label>
          <input type="text" id="item-id" placeholder="e.g., pistol_9mm" value="pistol_9mm" oninput="generateWeaponsItem()">
          <small>Unique identifier for this item (no spaces, lowercase)</small>
        </div>

        <div class="input-group">
          <label for="item-name">Item Name:</label>
          <input type="text" id="item-name" placeholder="e.g., 9mm Pistol" value="9mm Pistol" oninput="generateWeaponsItem()">
        </div>
      </div>

      <div class="input-group">
        <label for="item-desc">Description:</label>
        <textarea id="item-desc" placeholder="e.g., A standard 9mm pistol with moderate damage and good accuracy" oninput="generateWeaponsItem()">A standard 9mm pistol with moderate damage and good accuracy</textarea>
      </div>

    </div>

    <div class="generator-section">
      <div class="input-group">
        <label for="item-model">Model:</label>
        <input type="text" id="item-model" placeholder="models/weapons/w_pistol.mdl" value="models/weapons/w_pistol.mdl" oninput="generateWeaponsItem()">
        <small>3D model path for the item</small>
      </div>

      <div class="form-grid-2">
        <div class="input-group">
          <label for="item-width">Width:</label>
          <input type="number" id="item-width" placeholder="1" min="1" value="2" oninput="generateWeaponsItem()">
          <small>Inventory slot width</small>
        </div>

        <div class="input-group">
          <label for="item-height">Height:</label>
          <input type="number" id="item-height" placeholder="1" min="1" value="1" oninput="generateWeaponsItem()">
          <small>Inventory slot height</small>
        </div>
      </div>
    </div>

    <div class="generator-section">
      <div class="input-group">
        <label for="weapon-class">Weapon Class:</label>
        <input type="text" id="weapon-class" placeholder="weapon_pistol" value="weapon_pistol" oninput="generateWeaponsItem()">
        <small>Weapon entity class that gets given to players</small>
      </div>

      <div class="input-group">
        <label>Required Skill Levels:</label>
        <div id="skills-list" class="dynamic-list"></div>
        <button onclick="addSkillRow()" class="add-btn">+ Add Skill</button>
        <small>Skill Name and Level</small>
      </div>

      <div class="input-group">
        <label>
          <input type="checkbox" id="drop-on-death" checked onchange="generateWeaponsItem()"> Drop on Death
        </label>
        <small>Weapon drops when player dies</small>
      </div>
    </div>

    <div class="button-group">
      <button onclick="generateWeaponsItem()" class="generate-btn">Generate Weapons Item Code</button>
      <button onclick="fillExampleWeaponsItem()" class="generate-btn example-btn">Generate Example</button>
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
// Helper to create a skill row (Skill, Level)
function addSkillRow(skill='', level='') {
  const container = document.getElementById('skills-list');
  const div = document.createElement('div');
  div.className = 'dynamic-row';
  div.innerHTML = `
  <input type="text" placeholder="Skill (e.g. guns)" value="${skill}" class="skill-name">
  <input type="number" placeholder="Level (e.g. 1)" value="${level}" class="skill-level small-input">
  <button onclick="this.parentElement.remove()" class="remove-btn">×</button>
  `;
  container.appendChild(div);
}

function toLuaTable(obj) {
  if (!obj || Object.keys(obj).length === 0) return '{}';
  const entries = Object.entries(obj).map(([k, v]) => `["${k}"] = ${v}`);
  return `{ ${entries.join(', ')} }`;
}

function getSkillValues() {
  const rows = document.querySelectorAll('#skills-list .dynamic-row');
  const skills = {};
  rows.forEach(row => {
    const skill = row.querySelector('.skill-name').value.trim();
    const level = row.querySelector('.skill-level').value.trim();
    if (skill && level) {
      skills[skill] = Number(level);
    }
  });
  return skills;
}

function generateWeaponsItem() {
  const uniqueId = (document.getElementById('item-id').value || '').trim() || 'weapon_example';
  const name = (document.getElementById('item-name').value || '').trim() || 'Weapon Name';
  const desc = (document.getElementById('item-desc').value || '').trim() || 'Weapon description';
  const model = (document.getElementById('item-model').value || '').trim() || 'models/weapons/w_pistol.mdl';
  const width = document.getElementById('item-width').value || '1';
  const height = document.getElementById('item-height').value || '1';
  const weaponClass = (document.getElementById('weapon-class').value || '').trim() || 'weapon_pistol';
  const dropOnDeath = document.getElementById('drop-on-death').checked;

  const skillLevels = getSkillValues();

  let properties = [
    `    name = ${JSON.stringify(name)},`,
    `    desc = ${JSON.stringify(desc)},`,
    `    model = ${JSON.stringify(model)},`,
    `    width = ${width},`,
    `    height = ${height},`,
    `    class = ${JSON.stringify(weaponClass)},`,
    `    isWeapon = true,`,
    `    DropOnDeath = ${dropOnDeath ? 'true' : 'false'},`
  ];

  if (Object.keys(skillLevels).length > 0) {
    properties.push(` RequiredSkillLevels = ${toLuaTable(skillLevels)},`);
  }

  const lines = [
  '-- Copy and paste this code into any Lua file that loads during initialization',
  '-- Example: [schema folder]/schema/items.lua',
  '',
  `lia.item.registerItem(${JSON.stringify(uniqueId)}, "base_weapons", {`,
  ...properties,
  '})'
  ];

  const code = `${lines.join('\n')}\n`;

  const outputBox = document.getElementById('output-code');
  if (outputBox) {
    outputBox.value = code;
  }
}

function fillExampleWeaponsItem() {
  document.getElementById('item-id').value = 'ak47_assault';
  document.getElementById('item-name').value = 'AK-47';
  document.getElementById('item-desc').value = 'A powerful Soviet assault rifle. Known for its reliability and high stopping power.';
  document.getElementById('item-model').value = 'models/weapons/w_rif_ak47.mdl';
  document.getElementById('item-width').value = '4';
  document.getElementById('item-height').value = '2';
  document.getElementById('weapon-class').value = 'weapon_ak47';
  document.getElementById('drop-on-death').checked = true;

  // Clear list
  document.getElementById('skills-list').innerHTML = '';
  // Add example skills
  addSkillRow('guns', '5');
  addSkillRow('strength', '3');

  generateWeaponsItem();
}

// Initial generation
document.addEventListener('DOMContentLoaded', () => {
  addSkillRow('guns', '2');
  addSkillRow('combat', '1');
  generateWeaponsItem(); // Call this afterwards since we added rows
});
</script>

---

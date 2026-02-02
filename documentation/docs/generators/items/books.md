<div class="generator-grid">
  <!-- Input Column -->
  <div class="generator-card form-card">
    <div class="generator-section">
      <div class="form-grid-2">
        <div class="input-group">
          <label for="item-id">Unique ID:</label>
          <input type="text" id="item-id" placeholder="e.g., skill_book_guns" value="guide_survival" oninput="generateBooksItem()">
          <small>Unique identifier for this item (no spaces, lowercase)</small>
        </div>

        <div class="input-group">
          <label for="item-name">Item Name:</label>
          <input type="text" id="item-name" placeholder="e.g., Skill Book: Guns" value="Survival Guide" oninput="generateBooksItem()">
        </div>
      </div>

      <div class="input-group">
        <label for="item-desc">Description:</label>
        <textarea id="item-desc" placeholder="e.g., A training manual that teaches firearm proficiency" oninput="generateBooksItem()">A small book containing survival tips and tricks for the wasteland.</textarea>
      </div>

    </div>

    <div class="generator-section">
      <div class="input-group">
        <label for="item-model">Model:</label>
        <input type="text" id="item-model" placeholder="models/props_lab/binderblue.mdl" value="models/props_lab/binderredlabel.mdl" oninput="generateBooksItem()">
        <small>3D model path for the book</small>
      </div>

      <div class="form-grid-2">
        <div class="input-group">
          <label for="item-width">Width:</label>
          <input type="number" id="item-width" placeholder="1" min="1" value="1" oninput="generateBooksItem()">
          <small>Inventory slot width</small>
        </div>

        <div class="input-group">
          <label for="item-height">Height:</label>
          <input type="number" id="item-height" placeholder="1" min="1" value="1" oninput="generateBooksItem()">
          <small>Inventory slot height</small>
        </div>
      </div>
    </div>

    <div class="generator-section">
      <div class="input-group">
        <label for="book-contents">Book Contents (HTML):</label>
        <textarea id="book-contents" placeholder="&lt;p&gt;Enter rich text or HTML for the book body&lt;/p&gt;" rows="6" oninput="generateBooksItem()">This book contains information on how to survive in the wasteland. It includes tips on finding food, water, and shelter, as well as how to avoid dangerous creatures and radiation.</textarea>
        <small>Content is stored as a single string; HTML is preserved</small>
      </div>
    </div>

    <div class="button-group">
      <button onclick="generateBooksItem()" class="generate-btn">Generate Books Item Code</button>
      <button onclick="fillExampleBooksItem()" class="generate-btn example-btn">Generate Example</button>
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
function generateBooksItem() {
  const uniqueId = (document.getElementById('item-id').value || '').trim() || 'book_example';
  const name = (document.getElementById('item-name').value || '').trim() || 'Book Item';
  const desc = (document.getElementById('item-desc').value || '').trim() || 'A readable book item';
  const model = (document.getElementById('item-model').value || '').trim() || 'models/props_lab/binderblue.mdl';
  const width = document.getElementById('item-width').value || '1';
  const height = document.getElementById('item-height').value || '1';
  const contentsRaw = document.getElementById('book-contents').value;
  const contents = contentsRaw && contentsRaw.trim() ? contentsRaw.trim() : '<p>Add book contents here.</p>';

  const properties = [
    `    name = ${JSON.stringify(name)},`,
    `    desc = ${JSON.stringify(desc)},`,
    `    model = ${JSON.stringify(model)},`,
    `    width = ${width},`,
    `    height = ${height},`,
    `    contents = ${JSON.stringify(contents)}`
  ];

  const lines = [
    '-- Copy and paste this code into any Lua file that loads during initialization',
    '-- Example: [schema folder]/schema/items.lua',
    '',
    `lia.item.registerItem(${JSON.stringify(uniqueId)}, "base_books", {`,
    ...properties,
    '})'
  ];

  const code = `${lines.join('\n')}\n`;

  const outputBox = document.getElementById('output-code');
  if (outputBox) {
    outputBox.value = code;
  }
}

function fillExampleBooksItem() {
  document.getElementById('item-id').value = 'ancient_tome';
  document.getElementById('item-name').value = 'Ancient Tome';
  document.getElementById('item-desc').value = 'A heavy, dust-covered tome bound in weathered leather. The pages contain cryptic symbols and forbidden knowledge.';
  document.getElementById('item-model').value = 'models/props_lab/binderblue.mdl';
  document.getElementById('item-width').value = '2';
  document.getElementById('item-height').value = '2';
  document.getElementById('book-contents').value = 'The tome speaks of long-forgotten rituals and the entities that dwell beyond the veil. Reading it for too long might induce madness.';

  generateBooksItem();
}

// Initial generation
document.addEventListener('DOMContentLoaded', () => {
  generateBooksItem();
});
</script>

---

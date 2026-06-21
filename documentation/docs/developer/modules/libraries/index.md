<style>
details > summary {
    position: relative;
    display: flex;
    align-items: center;
    min-height: 70px;
    padding-right: 180px;
}

details > summary .summary-main {
    min-width: 0;
}

details > summary .source-link-button--summary {
    position: absolute;
    right: 56px;
    top: 50%;
    transform: translateY(-50%);
    white-space: nowrap;
    z-index: 2;
}
</style>

# Libraries

Reference pages for documented Lilia libraries and module library helpers.

<div class="card-grid">
  <a href="./lia.attribs/" class="card">
    <h3>Attributes</h3>
    <p>Attribute helpers for loading, registering, and setting up character attributes.</p>
  </a>
  <a href="./lia.chat/" class="card">
    <h3>Chat</h3>
    <p>Chat helpers for registering chat classes, parsing player messages, formatting timestamps, and sending chat messages to eligible recipients.</p>
  </a>
  <a href="./lia.class/" class="card">
    <h3>Class</h3>
    <p>Character class helpers for registering, loading, retrieving, counting, validating, and resolving playable classes.</p>
  </a>
  <a href="./lia.doors/" class="card">
    <h3>Doors</h3>
    <p>Door data helpers for storing, syncing, validating, and extending map door configuration.</p>
  </a>
  <a href="./lia.faction/" class="card">
    <h3>Faction</h3>
    <p>Faction helpers for registering factions, loading faction definitions, resolving models, validating character customization, and querying faction membership data.</p>
  </a>
  <a href="./lia.inventory/" class="card">
    <h3>Inventory</h3>
    <p>Inventory helpers for registering inventory types, creating and loading inventory instances, managing persistent storage definitions, and opening inventory panels.</p>
  </a>
  <a href="./lia.log/" class="card">
    <h3>Log</h3>
    <p>Server log helpers for registering log types, formatting log messages, dispatching log hooks, printing log output, and saving log entries to the database.</p>
  </a>
</div>


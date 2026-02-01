# Derma

Advanced UI rendering and interaction system for the Lilia framework.

---

<strong>Overview</strong>

The derma library provides comprehensive UI rendering and interaction functionality for the Lilia framework. It handles advanced drawing operations including rounded rectangles, circles, shadows, blur effects, and gradients using custom shaders. The library offers a fluent API for creating complex UI elements with smooth animations, color pickers, player selectors, and various input dialogs. It includes utility functions for text rendering with shadows and outlines, entity text display, and menu positioning. The library operates primarily on the client side and provides both low-level drawing functions and high-level UI components for creating modern, visually appealing interfaces.

---

<details class="realm-client">
<summary><a id=lia.derma.dermaMenu></a>lia.derma.dermaMenu()</summary>
<div class="details-content">
<a id="liadermadermamenu"></a>
<strong>Purpose</strong>
<p>Opens a fresh `liaDermaMenu` at the current cursor position and tracks it in `lia.gui.menuDermaMenu`.</p>

<strong>When Called</strong>
<p>Use when you need a standard context menu for interaction options and want any previous one closed first.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="/development/meta/panel/">Panel</a></span> The newly created `liaDermaMenu` panel.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local menu = lia.derma.dermaMenu()
  menu:AddOption("Say hi", function() chat.AddText("hi") end)
  menu:Open()
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.optionsMenu></a>lia.derma.optionsMenu(rawOptions, config)</summary>
<div class="details-content">
<a id="liadermaoptionsmenu"></a>
<strong>Purpose</strong>
<p>Builds and shows the configurable options/interaction menu, filtering and categorising provided options before rendering buttons.</p>

<strong>When Called</strong>
<p>Use when presenting interaction, action, or custom options to the player, optionally tied to a targeted entity and network message.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">rawOptions</span> Option definitions keyed by id or stored in an array; entries can include `type`, `range`, `target`, `shouldShow`, `callback`, and `onSelect`.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">config</span> Optional settings such as `mode` ("interaction", "action", or "custom"), `entity`, `netMsg`, `preFiltered`, `registryKey`, sizing fields, and behaviour toggles like `closeOnSelect`.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="/development/meta/panel/">Panel|nil</a></span> The created frame when options are available; otherwise nil.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.derma.optionsMenu({
      greet = {type = "action", callback = function(client) chat.AddText(client, " waves") end}
  }, {mode = "action"})
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.interactionTooltip></a>lia.derma.interactionTooltip(rawOptions, config, mode, entity, title, closeKey, netMsg, preFiltered, emitHooks, registryKey, autoCloseDelay)</summary>
<div class="details-content">
<a id="liadermainteractiontooltip"></a>
<strong>Purpose</strong>
<p>Creates and displays a tooltip-style interaction menu similar to magic/item tooltips, with enhanced visual effects and modern styling.</p>

<strong>When Called</strong>
<p>Automatically called when opening player interaction (TAB) or personal actions (G) menus to provide a polished tooltip interface.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">rawOptions</span> Raw interaction/action options data from playerinteract system.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">config</span> Configuration options including:</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">mode</span> "interaction", "action", or "custom"</p>
<p><span class="types"><a class="type" href="/development/meta/entity/">Entity</a></span> <span class="parameter">entity</span> Target entity for interactions</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">title</span> Menu title override</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">closeKey</span> Key code to close menu</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">netMsg</span> Network message for server communication</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> <span class="parameter">preFiltered</span> Whether options are already filtered</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> <span class="parameter">emitHooks</span> Whether to trigger interaction hooks</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">registryKey</span> Key for GUI registry</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">autoCloseDelay</span> Auto-close timeout in seconds</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="/development/meta/panel/">Panel|nil</a></span> The created tooltip panel, or nil if no valid options.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  -- Automatically called by lia.playerinteract.openMenu()
  -- Can also be called directly:
  local tooltip = lia.derma.interactionTooltip(interactions, {
      mode = "interaction",
      title = "Player Interactions",
      entity = targetPlayer
  })
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.requestColorPicker></a>lia.derma.requestColorPicker(func, colorStandard)</summary>
<div class="details-content">
<a id="liadermarequestcolorpicker"></a>
<strong>Purpose</strong>
<p>Displays a modal color picker window that lets the user pick a hue and saturation/value, then returns the chosen color.</p>

<strong>When Called</strong>
<p>Use when you need the player to choose a color for a UI element or configuration field.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.6">function</a></span> <span class="parameter">func</span> Callback invoked with the selected Color when the user confirms.</p>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Color">Color</a></span> <span class="parameter">colorStandard</span> Optional starting color; defaults to white.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.derma.requestColorPicker(function(col) print("Picked", col) end, Color(0, 200, 255))
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.radialMenu></a>lia.derma.radialMenu(options)</summary>
<div class="details-content">
<a id="liadermaradialmenu"></a>
<strong>Purpose</strong>
<p>Spawns a radial selection menu using `liaRadialPanel` and stores the reference on `lia.gui.menu_radial`.</p>

<strong>When Called</strong>
<p>Use for quick circular option pickers, such as pie-menu interactions.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">options</span> Table passed directly to `liaRadialPanel:Init`, defining each radial entry.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="/development/meta/panel/">Panel</a></span> The created `liaRadialPanel` instance.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.derma.radialMenu({{label = "Yes", callback = function() print("yes") end}})
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.requestPlayerSelector></a>lia.derma.requestPlayerSelector(doClick)</summary>
<div class="details-content">
<a id="liadermarequestplayerselector"></a>
<strong>Purpose</strong>
<p>Opens a player selector window listing all connected players and runs a callback when one is chosen.</p>

<strong>When Called</strong>
<p>Use when an action needs the user to target a specific player from the current server list.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.6">function</a></span> <span class="parameter">doClick</span> Called with the selected player entity after the user clicks a card.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="/development/meta/panel/">Panel</a></span> The created selector frame stored on `lia.gui.menuPlayerSelector`.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.derma.requestPlayerSelector(function(pl) chat.AddText("Selected ", pl:Name()) end)
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.draw></a>lia.derma.draw(radius, x, y, w, h, col, flags)</summary>
<div class="details-content">
<a id="liadermadraw"></a>
<strong>Purpose</strong>
<p>Draws a rounded rectangle using the shader-based derma pipeline with the same radius on every corner.</p>

<strong>When Called</strong>
<p>Use when rendering a simple rounded box with optional shape or blur flags.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">radius</span> Corner radius to apply to all corners.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">x</span> X position of the box.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">y</span> Y position of the box.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">w</span> Width of the box.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">h</span> Height of the box.</p>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Color">Color</a></span> <span class="parameter">col</span> <span class="optional">optional</span> Fill color; defaults to solid white if omitted.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">flags</span> <span class="optional">optional</span> Optional bitmask using `lia.derma` flag constants (shape, blur, corner suppression).</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.derma.draw(8, 10, 10, 140, 48, Color(30, 30, 30, 220))
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.drawOutlined></a>lia.derma.drawOutlined(radius, x, y, w, h, col, thickness, flags)</summary>
<div class="details-content">
<a id="liadermadrawoutlined"></a>
<strong>Purpose</strong>
<p>Draws only the outline of a rounded rectangle with configurable thickness.</p>

<strong>When Called</strong>
<p>Use when you need a stroked rounded box while leaving the interior transparent.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">radius</span> Corner radius for all corners.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">x</span> X position of the outline.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">y</span> Y position of the outline.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">w</span> Width of the outline box.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">h</span> Height of the outline box.</p>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Color">Color</a></span> <span class="parameter">col</span> <span class="optional">optional</span> Outline color; defaults to white when nil.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">thickness</span> <span class="optional">optional</span> Outline thickness in pixels; defaults to 1.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">flags</span> <span class="optional">optional</span> Optional bitmask using `lia.derma` flags.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.derma.drawOutlined(10, 20, 20, 180, 60, lia.color.theme.text, 2)
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.drawTexture></a>lia.derma.drawTexture(radius, x, y, w, h, col, texture, flags)</summary>
<div class="details-content">
<a id="liadermadrawtexture"></a>
<strong>Purpose</strong>
<p>Draws a rounded rectangle filled with the provided texture.</p>

<strong>When Called</strong>
<p>Use when you need a textured rounded box instead of a solid color.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">radius</span> Corner radius for all corners.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">x</span> X position.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">y</span> Y position.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">w</span> Width.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">h</span> Height.</p>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Color">Color</a></span> <span class="parameter">col</span> <span class="optional">optional</span> Modulation color for the texture; defaults to white.</p>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/ITexture">ITexture</a></span> <span class="parameter">texture</span> Texture handle to apply to the rectangle.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">flags</span> <span class="optional">optional</span> Optional bitmask using `lia.derma` flags.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local tex = Material("vgui/gradient-u"):GetTexture("$basetexture")
  lia.derma.drawTexture(6, 50, 50, 128, 64, color_white, tex)
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.drawMaterial></a>lia.derma.drawMaterial(radius, x, y, w, h, col, mat, flags)</summary>
<div class="details-content">
<a id="liadermadrawmaterial"></a>
<strong>Purpose</strong>
<p>Convenience wrapper that draws a rounded rectangle using the base texture from a material.</p>

<strong>When Called</strong>
<p>Use when you have an `IMaterial` and want its base texture applied to a rounded box.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">radius</span> Corner radius for all corners.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">x</span> X position.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">y</span> Y position.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">w</span> Width.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">h</span> Height.</p>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Color">Color</a></span> <span class="parameter">col</span> <span class="optional">optional</span> Color modulation for the material.</p>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/IMaterial">IMaterial</a></span> <span class="parameter">mat</span> Material whose base texture will be drawn.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">flags</span> <span class="optional">optional</span> Optional bitmask using `lia.derma` flags.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.derma.drawMaterial(6, 80, 80, 100, 40, color_white, Material("vgui/gradient-d"))
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.drawCircle></a>lia.derma.drawCircle(x, y, radius, col, flags)</summary>
<div class="details-content">
<a id="liadermadrawcircle"></a>
<strong>Purpose</strong>
<p>Draws a filled circle using the rounded rectangle shader configured for circular output.</p>

<strong>When Called</strong>
<p>Use when you need a smooth circle without manually handling radii or shapes.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">x</span> Center X position.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">y</span> Center Y position.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">radius</span> Circle diameter; internally halved for corner radii.</p>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Color">Color</a></span> <span class="parameter">col</span> <span class="optional">optional</span> Fill color; defaults to white.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">flags</span> <span class="optional">optional</span> Optional bitmask using `lia.derma` flags.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.derma.drawCircle(100, 100, 48, Color(200, 80, 80, 255))
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.drawCircleOutlined></a>lia.derma.drawCircleOutlined(x, y, radius, col, thickness, flags)</summary>
<div class="details-content">
<a id="liadermadrawcircleoutlined"></a>
<strong>Purpose</strong>
<p>Draws only the outline of a circle with configurable thickness.</p>

<strong>When Called</strong>
<p>Use for circular strokes such as selection rings or markers.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">x</span> Center X position.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">y</span> Center Y position.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">radius</span> Circle diameter.</p>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Color">Color</a></span> <span class="parameter">col</span> <span class="optional">optional</span> Outline color.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">thickness</span> <span class="optional">optional</span> Outline thickness; defaults to 1.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">flags</span> <span class="optional">optional</span> Optional bitmask using `lia.derma` flags.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.derma.drawCircleOutlined(200, 120, 40, lia.color.theme.accent, 2)
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.drawCircleTexture></a>lia.derma.drawCircleTexture(x, y, radius, col, texture, flags)</summary>
<div class="details-content">
<a id="liadermadrawcircletexture"></a>
<strong>Purpose</strong>
<p>Draws a textured circle using a supplied texture handle.</p>

<strong>When Called</strong>
<p>Use when you want a circular render that uses a specific texture rather than a solid color.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">x</span> Center X position.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">y</span> Center Y position.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">radius</span> Circle diameter.</p>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Color">Color</a></span> <span class="parameter">col</span> <span class="optional">optional</span> Color modulation for the texture.</p>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/ITexture">ITexture</a></span> <span class="parameter">texture</span> Texture handle to apply.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">flags</span> <span class="optional">optional</span> Optional bitmask using `lia.derma` flags.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.derma.drawCircleTexture(64, 64, 32, color_white, Material("icon16/star.png"):GetTexture("$basetexture"))
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.drawCircleMaterial></a>lia.derma.drawCircleMaterial(x, y, radius, col, mat, flags)</summary>
<div class="details-content">
<a id="liadermadrawcirclematerial"></a>
<strong>Purpose</strong>
<p>Draws a textured circle using the base texture from an `IMaterial`.</p>

<strong>When Called</strong>
<p>Use when you have a material and need to render its base texture within a circular mask.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">x</span> Center X position.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">y</span> Center Y position.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">radius</span> Circle diameter.</p>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Color">Color</a></span> <span class="parameter">col</span> <span class="optional">optional</span> Color modulation for the material.</p>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/IMaterial">IMaterial</a></span> <span class="parameter">mat</span> Material whose base texture will be drawn.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">flags</span> <span class="optional">optional</span> Optional bitmask using `lia.derma` flags.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.derma.drawCircleMaterial(48, 48, 28, color_white, Material("vgui/gradient-l"))
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.drawBlur></a>lia.derma.drawBlur(x, y, w, h, flags, tl, Top, Top, tr, Top, Top, bl, Bottom, Bottom, br, Bottom, Bottom, thickness)</summary>
<div class="details-content">
<a id="liadermadrawblur"></a>
<strong>Purpose</strong>
<p>Renders a blurred rounded shape using the blur shader while respecting per-corner radii and optional outline thickness.</p>

<strong>When Called</strong>
<p>Use to blur a rectangular region (or other supported shapes) without drawing a solid fill.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">x</span> X position of the blurred region.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">y</span> Y position of the blurred region.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">w</span> Width of the blurred region.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">h</span> Height of the blurred region.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">flags</span> <span class="optional">optional</span> Bitmask using `lia.derma` flags to control shape, blur, and disabled corners.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">tl</span> <span class="optional">optional</span> Top-left radius override.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">unknown</a></span> <span class="parameter">Top</span> left radius override.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">unknown</a></span> <span class="parameter">Top</span> left radius override.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">tr</span> <span class="optional">optional</span> Top-right radius override.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">unknown</a></span> <span class="parameter">Top</span> right radius override.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">unknown</a></span> <span class="parameter">Top</span> right radius override.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">bl</span> <span class="optional">optional</span> Bottom-left radius override.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">unknown</a></span> <span class="parameter">Bottom</span> left radius override.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">unknown</a></span> <span class="parameter">Bottom</span> left radius override.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">br</span> <span class="optional">optional</span> Bottom-right radius override.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">unknown</a></span> <span class="parameter">Bottom</span> right radius override.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">unknown</a></span> <span class="parameter">Bottom</span> right radius override.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">thickness</span> <span class="optional">optional</span> Optional outline thickness for partial arcs.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.derma.drawBlur(0, 0, 220, 80, lia.derma.BLUR, 12, 12, 12, 12)
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.drawShadowsEx></a>lia.derma.drawShadowsEx(x, y, w, h, col, flags, tl, Top, Top, tr, Top, Top, bl, Bottom, Bottom, br, Bottom, Bottom, spread, intensity, thickness)</summary>
<div class="details-content">
<a id="liadermadrawshadowsex"></a>
<strong>Purpose</strong>
<p>Draws a configurable drop shadow behind a rounded shape, optionally using blur and manual color control.</p>

<strong>When Called</strong>
<p>Use when you want a soft shadow around a shape with fine control over radii, spread, intensity, and flags.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">x</span> X position of the shape casting the shadow.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">y</span> Y position of the shape casting the shadow.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">w</span> Width of the shape.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">h</span> Height of the shape.</p>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Color">Color|boolean</a></span> <span class="parameter">col</span> <span class="optional">optional</span> Shadow color; pass `false` to skip color modulation.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">flags</span> <span class="optional">optional</span> Bitmask using `lia.derma` flags (shape, blur, corner suppression).</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">tl</span> <span class="optional">optional</span> Top-left radius override.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">unknown</a></span> <span class="parameter">Top</span> left radius override.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">unknown</a></span> <span class="parameter">Top</span> left radius override.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">tr</span> <span class="optional">optional</span> Top-right radius override.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">unknown</a></span> <span class="parameter">Top</span> right radius override.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">unknown</a></span> <span class="parameter">Top</span> right radius override.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">bl</span> <span class="optional">optional</span> Bottom-left radius override.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">unknown</a></span> <span class="parameter">Bottom</span> left radius override.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">unknown</a></span> <span class="parameter">Bottom</span> left radius override.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">br</span> <span class="optional">optional</span> Bottom-right radius override.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">unknown</a></span> <span class="parameter">Bottom</span> right radius override.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">unknown</a></span> <span class="parameter">Bottom</span> right radius override.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">spread</span> <span class="optional">optional</span> Pixel spread of the shadow; defaults to 30.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">intensity</span> <span class="optional">optional</span> Shadow alpha scaling; defaults to `spread * 1.2`.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">thickness</span> <span class="optional">optional</span> Optional outline thickness when rendering arcs.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.derma.drawShadowsEx(40, 40, 200, 80, Color(0, 0, 0, 180), nil, 12, 12, 12, 12, 26, 32)
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.drawShadows></a>lia.derma.drawShadows(radius, x, y, w, h, col, spread, intensity, flags)</summary>
<div class="details-content">
<a id="liadermadrawshadows"></a>
<strong>Purpose</strong>
<p>Convenience wrapper to draw a drop shadow with the same radius on every corner.</p>

<strong>When Called</strong>
<p>Use when you need a uniform-radius shadow without manually specifying each corner.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">radius</span> Radius applied to all corners.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">x</span> X position.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">y</span> Y position.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">w</span> Width.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">h</span> Height.</p>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Color">Color</a></span> <span class="parameter">col</span> <span class="optional">optional</span> Shadow color.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">spread</span> <span class="optional">optional</span> Pixel spread of the shadow.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">intensity</span> <span class="optional">optional</span> Shadow alpha scaling.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">flags</span> <span class="optional">optional</span> Optional bitmask using `lia.derma` flags.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.derma.drawShadows(10, 60, 60, 180, 70, Color(0, 0, 0, 150))
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.drawShadowsOutlined></a>lia.derma.drawShadowsOutlined(radius, x, y, w, h, col, thickness, spread, intensity, flags)</summary>
<div class="details-content">
<a id="liadermadrawshadowsoutlined"></a>
<strong>Purpose</strong>
<p>Convenience wrapper that draws only the shadow outline for a uniform-radius shape.</p>

<strong>When Called</strong>
<p>Use when you need a stroked shadow ring around a rounded box.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">radius</span> Radius applied to all corners.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">x</span> X position.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">y</span> Y position.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">w</span> Width.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">h</span> Height.</p>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Color">Color</a></span> <span class="parameter">col</span> <span class="optional">optional</span> Shadow color.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">thickness</span> <span class="optional">optional</span> Outline thickness for the shadow.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">spread</span> <span class="optional">optional</span> Pixel spread of the shadow.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">intensity</span> <span class="optional">optional</span> Shadow alpha scaling.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">flags</span> <span class="optional">optional</span> Optional bitmask using `lia.derma` flags.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.derma.drawShadowsOutlined(12, 40, 40, 160, 60, Color(0, 0, 0, 180), 2)
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.rect></a>lia.derma.rect(x, y, w, h)</summary>
<div class="details-content">
<a id="liadermarect"></a>
<strong>Purpose</strong>
<p>Starts a chainable rectangle draw builder using the derma shader helpers.</p>

<strong>When Called</strong>
<p>Use when you want to configure a rectangle (radius, color, outline, blur, etc.) through a fluent API before drawing.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">x</span> X position of the rectangle.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">y</span> Y position of the rectangle.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">w</span> Width of the rectangle.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">h</span> Height of the rectangle.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> Chainable rectangle builder supporting methods like `:Rad`, `:Color`, `:Outline`, and `:Draw`.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.derma.rect(12, 12, 220, 80):Rad(10):Color(Color(40, 40, 40, 220)):Shadow():Draw()
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.circle></a>lia.derma.circle(x, y, r)</summary>
<div class="details-content">
<a id="liadermacircle"></a>
<strong>Purpose</strong>
<p>Starts a chainable circle draw builder using the derma shader helpers.</p>

<strong>When Called</strong>
<p>Use when you want to configure a circle (color, outline, blur, etc.) before drawing it.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">x</span> Center X position.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">y</span> Center Y position.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">r</span> Circle diameter.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> Chainable circle builder supporting methods like `:Color`, `:Outline`, `:Shadow`, and `:Draw`.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.derma.circle(100, 100, 50):Color(lia.color.theme.accent):Outline(2):Draw()
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.setFlag></a>lia.derma.setFlag(flags, flag, bool)</summary>
<div class="details-content">
<a id="liadermasetflag"></a>
<strong>Purpose</strong>
<p>Sets or clears a specific drawing flag on a bitmask using a flag value or named constant.</p>

<strong>When Called</strong>
<p>Use when toggling derma drawing flags such as shapes or corner suppression.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">flags</span> Current flag bitmask.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number|string</a></span> <span class="parameter">flag</span> Flag value or key in `lia.derma` (e.g., "BLUR").</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> <span class="parameter">bool</span> Whether to enable (`true`) or disable (`false`) the flag.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> Updated flag bitmask.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  flags = lia.derma.setFlag(flags, "BLUR", true)
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.setDefaultShape></a>lia.derma.setDefaultShape(shape)</summary>
<div class="details-content">
<a id="liadermasetdefaultshape"></a>
<strong>Purpose</strong>
<p>Updates the default shape flag used by the draw helpers (rectangles and circles) when no explicit flag is provided.</p>

<strong>When Called</strong>
<p>Use to globally change the base rounding style (e.g., figma, iOS, circle) for subsequent draw calls.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">shape</span> Shape flag constant such as `lia.derma.SHAPE_FIGMA`; defaults to `SHAPE_FIGMA` when nil.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.derma.setDefaultShape(lia.derma.SHAPE_IOS)
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.shadowText></a>lia.derma.shadowText(text, font, x, y, colortext, colorshadow, dist, xalign, yalign)</summary>
<div class="details-content">
<a id="liadermashadowtext"></a>
<strong>Purpose</strong>
<p>Draws text with a single offset shadow before the main text for lightweight legibility.</p>

<strong>When Called</strong>
<p>Use when you need a subtle shadow behind text without a full outline.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">text</span> Text to draw.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">font</span> Font name.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">x</span> X position.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">y</span> Y position.</p>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Color">Color</a></span> <span class="parameter">colortext</span> Foreground text color.</p>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Color">Color</a></span> <span class="parameter">colorshadow</span> Shadow color.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">dist</span> Pixel offset for both X and Y shadow directions.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">xalign</span> Horizontal alignment (`TEXT_ALIGN_*`).</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">yalign</span> Vertical alignment (`TEXT_ALIGN_*`).</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.derma.shadowText("Hello", "LiliaFont.18", 200, 100, color_white, Color(0, 0, 0, 180), 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.drawTextOutlined></a>lia.derma.drawTextOutlined(text, font, x, y, colour, xalign, outlinewidth, outlinecolour)</summary>
<div class="details-content">
<a id="liadermadrawtextoutlined"></a>
<strong>Purpose</strong>
<p>Draws text with a configurable outline by repeatedly rendering offset copies around the glyphs.</p>

<strong>When Called</strong>
<p>Use when you need high-contrast text that stays legible on varied backgrounds.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">text</span> Text to draw.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">font</span> Font name.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">x</span> X position.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">y</span> Y position.</p>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Color">Color</a></span> <span class="parameter">colour</span> Main text color.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">xalign</span> Horizontal alignment (`TEXT_ALIGN_*`).</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">outlinewidth</span> Total outline thickness in pixels.</p>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Color">Color</a></span> <span class="parameter">outlinecolour</span> Color applied to the outline renders.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> The value returned by `draw.DrawText` for the final text render.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.derma.drawTextOutlined("Warning", "LiliaFont.16", 50, 50, color_white, TEXT_ALIGN_LEFT, 2, Color(0, 0, 0, 200))
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.drawTip></a>lia.derma.drawTip(x, y, w, h, text, font, textCol, outlineCol)</summary>
<div class="details-content">
<a id="liadermadrawtip"></a>
<strong>Purpose</strong>
<p>Draws a speech-bubble style tooltip with a triangular pointer and centered label.</p>

<strong>When Called</strong>
<p>Use for lightweight tooltip rendering when you need a callout pointing to a position.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">x</span> Left position of the bubble.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">y</span> Top position of the bubble.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">w</span> Bubble width.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">h</span> Bubble height including pointer.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">text</span> Text to display inside the bubble.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">font</span> Font used for the text.</p>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Color">Color</a></span> <span class="parameter">textCol</span> Color of the label text.</p>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Color">Color</a></span> <span class="parameter">outlineCol</span> Color used to draw the bubble outline/fill.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.derma.drawTip(300, 200, 160, 60, "Hint", "LiliaFont.16", color_white, Color(20, 20, 20, 220))
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.drawText></a>lia.derma.drawText(text, x, y, color, alignX, alignY, font, alpha)</summary>
<div class="details-content">
<a id="liadermadrawtext"></a>
<strong>Purpose</strong>
<p>Draws text with a subtle shadow using `draw.TextShadow`, defaulting to common derma font and colors.</p>

<strong>When Called</strong>
<p>Use when rendering HUD/UI text that benefits from a small shadow for readability.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">text</span> Text to render.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">x</span> X position.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">y</span> Y position.</p>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Color">Color</a></span> <span class="parameter">color</span> <span class="optional">optional</span> Text color; defaults to white.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">alignX</span> <span class="optional">optional</span> Horizontal alignment (`TEXT_ALIGN_*`), defaults to left.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">alignY</span> <span class="optional">optional</span> Vertical alignment (`TEXT_ALIGN_*`), defaults to top.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">font</span> <span class="optional">optional</span> Font name; defaults to `LiliaFont.16`.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">alpha</span> <span class="optional">optional</span> Shadow alpha override; defaults to 57.5% of text alpha.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> Width returned by `draw.TextShadow`.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.derma.drawText("Objective updated", 20, 20, lia.color.theme.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.drawBoxWithText></a>lia.derma.drawBoxWithText(text, x, y, options)</summary>
<div class="details-content">
<a id="liadermadrawboxwithtext"></a>
<strong>Purpose</strong>
<p>Renders a configurable blurred box with optional border and draws one or more text lines inside it.</p>

<strong>When Called</strong>
<p>Use for notification overlays, labels, or caption boxes that need automatic sizing and padding.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string|table</a></span> <span class="parameter">text</span> Single string or table of lines to display.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">x</span> Reference X coordinate.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">y</span> Reference Y coordinate.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">options</span> <span class="optional">optional</span> Customisation table supporting `font`, `textColor`, `backgroundColor`, `borderColor`, `borderRadius`, `borderThickness`, `padding`, `blur`, `textAlignX`, `textAlignY`, `autoSize`, `width`, `height`, and `lineSpacing`.</p>

<strong>Returns</strong>
<p>number, number The final box width and height.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local w, h = lia.derma.drawBoxWithText("Saved", ScrW() * 0.5, 120, {textAlignX = TEXT_ALIGN_CENTER})
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.drawSurfaceTexture></a>lia.derma.drawSurfaceTexture(material, color, x, y, w, h)</summary>
<div class="details-content">
<a id="liadermadrawsurfacetexture"></a>
<strong>Purpose</strong>
<p>Draws a textured rectangle using either a supplied material or a material path.</p>

<strong>When Called</strong>
<p>Use when you need to render a texture/material directly without rounded corners.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/IMaterial">IMaterial|string</a></span> <span class="parameter">material</span> Material instance or path to the material.</p>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Color">Color</a></span> <span class="parameter">color</span> <span class="optional">optional</span> Color modulation for the draw; defaults to white.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">x</span> X position.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">y</span> Y position.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">w</span> Width.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">h</span> Height.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.derma.drawSurfaceTexture("vgui/gradient-l", color_white, 10, 10, 64, 64)
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.skinFunc></a>lia.derma.skinFunc(name, panel)</summary>
<div class="details-content">
<a id="liadermaskinfunc"></a>
<strong>Purpose</strong>
<p>Calls a named skin function on the panel's active skin (or the default skin) with the provided arguments.</p>

<strong>When Called</strong>
<p>Use to defer drawing or layout to the current Derma skin implementation.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">name</span> Skin function name to invoke.</p>
<p><span class="types"><a class="type" href="/development/meta/panel/">Panel</a></span> <span class="parameter">panel</span> <span class="optional">optional</span> Target panel whose skin should be used; falls back to the default skin.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> Whatever the skin function returns, or nil if unavailable.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.derma.skinFunc("PaintButton", someButton, w, h)
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.approachExp></a>lia.derma.approachExp(current, target, speed, dt)</summary>
<div class="details-content">
<a id="liadermaapproachexp"></a>
<strong>Purpose</strong>
<p>Smoothly moves a value toward a target using an exponential approach based on delta time.</p>

<strong>When Called</strong>
<p>Use for UI animations or interpolations that should ease toward a target without overshoot.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">current</span> Current value.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">target</span> Desired target value.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">speed</span> Exponential speed factor.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">dt</span> Frame delta time.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> The updated value after applying the exponential approach.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  scale = lia.derma.approachExp(scale, 1, 4, FrameTime())
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.easeOutCubic></a>lia.derma.easeOutCubic(t)</summary>
<div class="details-content">
<a id="liadermaeaseoutcubic"></a>
<strong>Purpose</strong>
<p>Returns a cubic ease-out interpolation for values between 0 and 1.</p>

<strong>When Called</strong>
<p>Use for easing animations that should start quickly and slow toward the end.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">t</span> Normalized time between 0 and 1.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> Eased value.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local eased = lia.derma.easeOutCubic(progress)
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.easeInOutCubic></a>lia.derma.easeInOutCubic(t)</summary>
<div class="details-content">
<a id="liadermaeaseinoutcubic"></a>
<strong>Purpose</strong>
<p>Returns a cubic ease-in/ease-out interpolation for values between 0 and 1.</p>

<strong>When Called</strong>
<p>Use when you want acceleration at the start and deceleration at the end of an animation.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">t</span> Normalized time between 0 and 1.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> Eased value.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local eased = lia.derma.easeInOutCubic(progress)
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.animateAppearance></a>lia.derma.animateAppearance(panel, targetWidth, targetHeight, duration, alphaDuration, callback, scaleFactor)</summary>
<div class="details-content">
<a id="liadermaanimateappearance"></a>
<strong>Purpose</strong>
<p>Animates a panel from a scaled, transparent state to a target size/position with exponential easing and optional callback.</p>

<strong>When Called</strong>
<p>Use to show panels with a smooth pop-in animation that scales and fades into place.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/panel/">Panel</a></span> <span class="parameter">panel</span> Panel to animate.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">targetWidth</span> Final width.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">targetHeight</span> Final height.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">duration</span> <span class="optional">optional</span> Time in seconds for the size/position animation; defaults to 0.18s.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">alphaDuration</span> <span class="optional">optional</span> Time in seconds for the fade animation; defaults to the duration.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.6">function</a></span> <span class="parameter">callback</span> <span class="optional">optional</span> Called once the animation finishes.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">scaleFactor</span> <span class="optional">optional</span> Starting scale factor relative to the final size; defaults to 0.8.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local pnl = vgui.Create("DPanel")
  pnl:SetPos(100, 100)
  lia.derma.animateAppearance(pnl, 300, 200, 0.2, nil, function() pnl:SetMouseInputEnabled(true) end)
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.clampMenuPosition></a>lia.derma.clampMenuPosition(panel)</summary>
<div class="details-content">
<a id="liadermaclampmenuposition"></a>
<strong>Purpose</strong>
<p>Repositions a panel so it remains within the visible screen area with a small padding.</p>

<strong>When Called</strong>
<p>Use after moving or resizing a popup to prevent it from clipping off-screen.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/panel/">Panel</a></span> <span class="parameter">panel</span> Panel to clamp.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.derma.clampMenuPosition(myPanel)
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.drawGradient></a>lia.derma.drawGradient(x, y, w, h, direction, colorShadow, radius, flags)</summary>
<div class="details-content">
<a id="liadermadrawgradient"></a>
<strong>Purpose</strong>
<p>Draws a rectangular gradient using common VGUI gradient materials and optional rounding.</p>

<strong>When Called</strong>
<p>Use when you need a directional gradient fill without creating custom materials.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">x</span> X position.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">y</span> Y position.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">w</span> Width.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">h</span> Height.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">direction</span> Gradient index (1 = up, 2 = down, 3 = left, 4 = right).</p>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Color">Color</a></span> <span class="parameter">colorShadow</span> Color modulation for the gradient texture.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">radius</span> <span class="optional">optional</span> Corner radius; defaults to 0.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">flags</span> <span class="optional">optional</span> Optional bitmask using `lia.derma` flags.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.derma.drawGradient(0, 0, 200, 40, 2, Color(0, 0, 0, 180), 6)
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.wrapText></a>lia.derma.wrapText(text, width, font)</summary>
<div class="details-content">
<a id="liadermawraptext"></a>
<strong>Purpose</strong>
<p>Splits text into lines that fit within a maximum width using the specified font.</p>

<strong>When Called</strong>
<p>Use before rendering multi-line text to avoid manual word wrapping.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">text</span> Text to wrap.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">width</span> Maximum line width in pixels.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">font</span> <span class="optional">optional</span> Font to measure with; defaults to `LiliaFont.16`.</p>

<strong>Returns</strong>
<p>table, number A table of wrapped lines and the widest measured width.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local lines, maxW = lia.derma.wrapText("Hello world", 180, "LiliaFont.16")
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.drawBlur></a>lia.derma.drawBlur(panel, amount, passes, alpha)</summary>
<div class="details-content">
<a id="liadermadrawblur"></a>
<strong>Purpose</strong>
<p>Applies a screen-space blur behind the given panel by repeatedly sampling the blur material.</p>

<strong>When Called</strong>
<p>Use when you want a translucent blurred background behind a Derma panel.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/panel/">Panel</a></span> <span class="parameter">panel</span> Panel whose bounds define the blur area.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">amount</span> <span class="optional">optional</span> Blur strength multiplier; defaults to 5.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">passes</span> <span class="optional">optional</span> Number of blur passes; defaults to 0.2 steps up to 1.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">alpha</span> <span class="optional">optional</span> Alpha applied to the blur draw; defaults to 255.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.derma.drawBlur(myPanel, 4, 1, 200)
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.drawBlackBlur></a>lia.derma.drawBlackBlur(panel, amount, passes, alpha, darkAlpha)</summary>
<div class="details-content">
<a id="liadermadrawblackblur"></a>
<strong>Purpose</strong>
<p>Draws a blur behind a panel and overlays a dark tint to emphasize foreground elements.</p>

<strong>When Called</strong>
<p>Use for modal backdrops or to dim the UI behind dialogs.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/panel/">Panel</a></span> <span class="parameter">panel</span> Panel whose bounds define the blur and tint area.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">amount</span> <span class="optional">optional</span> Blur strength; defaults to 6.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">passes</span> <span class="optional">optional</span> Number of blur passes; defaults to 5.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">alpha</span> <span class="optional">optional</span> Alpha applied to the blur draw; defaults to 255.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">darkAlpha</span> <span class="optional">optional</span> Alpha of the dark overlay; defaults to 220.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.derma.drawBlackBlur(myPanel, 8, 4, 255, 180)
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.drawBlurAt></a>lia.derma.drawBlurAt(x, y, w, h, amount, passes, alpha)</summary>
<div class="details-content">
<a id="liadermadrawblurat"></a>
<strong>Purpose</strong>
<p>Applies a blur effect to a specific screen-space rectangle defined by coordinates and size.</p>

<strong>When Called</strong>
<p>Use to blur a custom area of the screen that is not tied to a panel.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">x</span> X position of the blur rectangle.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">y</span> Y position of the blur rectangle.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">w</span> Width of the blur rectangle.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">h</span> Height of the blur rectangle.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">amount</span> <span class="optional">optional</span> Blur strength; defaults to 5.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">passes</span> <span class="optional">optional</span> Number of blur passes; defaults to 0.2 steps up to 1.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">alpha</span> <span class="optional">optional</span> Alpha applied to the blur draw; defaults to 255.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.derma.drawBlurAt(100, 100, 200, 120, 6, 1, 180)
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.requestArguments></a>lia.derma.requestArguments(title, argTypes, onSubmit, defaults)</summary>
<div class="details-content">
<a id="liadermarequestarguments"></a>
<strong>Purpose</strong>
<p>Builds a dynamic argument entry form with typed controls and validates input before submission.</p>

<strong>When Called</strong>
<p>Use when a command or action requires the player to supply multiple typed arguments.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">title</span> <span class="optional">optional</span> Title text key; defaults to `"enterArguments"`.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">argTypes</span> Ordered list or map describing fields; entries can be `"string"`, `"boolean"`, `"number"/"int"`, `"table"` (dropdown), or `"player"`, optionally with data and default values.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.6">function</a></span> <span class="parameter">onSubmit</span> <span class="optional">optional</span> Callback receiving `(true, resultsTable)` on submit or `(false)` on cancel.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">defaults</span> <span class="optional">optional</span> Default values keyed by field name.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.derma.createTableUI("Players", {
      {name = "name", field = "name"},
      {name = "steamid", field = "steamid"}
  }, playerRows)
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.createTableUI></a>lia.derma.createTableUI(title, columns, data, options, charID)</summary>
<div class="details-content">
<a id="liadermacreatetableui"></a>
<strong>Purpose</strong>
<p>Builds a full-screen table UI with optional context actions, populating rows from provided data and column definitions.</p>

<strong>When Called</strong>
<p>Use when you need to display tabular data (e.g., admin lists) with right-click options and copy support.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">title</span> <span class="optional">optional</span> Title text key; defaults to localized table list title.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">columns</span> Array of column definitions `{name = <lang key>, field = <data key>, width = <optional>}`.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">data</span> Array of row tables keyed by column fields.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">options</span> <span class="optional">optional</span> Optional array of context menu option tables with `name`, `net`, and optional `ExtraFields`.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">charID</span> <span class="optional">optional</span> Character identifier forwarded to network options.</p>

<strong>Returns</strong>
<p>Panel, Panel The created frame and the underlying `DListView`.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.derma.createTableUI("Players", {
      {name = "name", field = "name"},
      {name = "steamid", field = "steamid"}
  }, playerRows)
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.openOptionsMenu></a>lia.derma.openOptionsMenu(title, options)</summary>
<div class="details-content">
<a id="liadermaopenoptionsmenu"></a>
<strong>Purpose</strong>
<p>Opens a compact options window from either a keyed table or an array of `{name, callback}` entries.</p>

<strong>When Called</strong>
<p>Use for lightweight choice prompts where each option triggers a callback and then closes the window.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">title</span> <span class="optional">optional</span> Localized title text key; defaults to `"options"`.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">options</span> Either an array of option tables `{name=<text>, callback=<fn>}` or a map of `name -> callback`.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="/development/meta/panel/">Panel</a></span> The created options frame.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.derma.openOptionsMenu("Actions", {
      {name = "Heal", callback = function() net.Start("Heal") net.SendToServer() end}
  })
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.drawEntText></a>lia.derma.drawEntText(ent, text, posY, alphaOverride)</summary>
<div class="details-content">
<a id="liadermadrawenttext"></a>
<strong>Purpose</strong>
<p>Draws floating text above an entity with distance-based fade and easing, caching per-entity scales.</p>

<strong>When Called</strong>
<p>Use to display labels or names above entities that appear when nearby.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/entity/">Entity</a></span> <span class="parameter">ent</span> Target entity to label.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">text</span> Text to display.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">posY</span> <span class="optional">optional</span> Vertical offset for the text; defaults to 0.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">alphaOverride</span> <span class="optional">optional</span> Optional alpha multiplier or raw alpha value.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  hook.Add("PostDrawTranslucentRenderables", "DrawNames", function()
      for _, ent in ipairs(ents.FindByClass("npc_*")) do
          lia.derma.drawEntText(ent, ent:GetClass(), 0)
      end
  end)
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.requestDropdown></a>lia.derma.requestDropdown(title, options, callback, defaultValue)</summary>
<div class="details-content">
<a id="liadermarequestdropdown"></a>
<strong>Purpose</strong>
<p>Shows a modal dropdown prompt and returns the selected entry through a callback.</p>

<strong>When Called</strong>
<p>Use when you need the player to choose a single option from a list with optional default selection.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">title</span> <span class="optional">optional</span> Title text key; defaults to `"selectOption"`.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">options</span> Array of options, either strings or `{text, data}` tables.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.6">function</a></span> <span class="parameter">callback</span> <span class="optional">optional</span> Invoked with `selectedText` and optional `selectedData`, or `false` if cancelled.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any|table</a></span> <span class="parameter">defaultValue</span> <span class="optional">optional</span> Optional default selection value or `{text, data}` pair.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="/development/meta/panel/">Panel</a></span> The created dropdown frame.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.derma.requestDropdown("Choose color", {"Red", "Green", "Blue"}, function(choice) print("Picked", choice) end)
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.requestString></a>lia.derma.requestString(title, description, callback, defaultValue, Pre, Pre, maxLength)</summary>
<div class="details-content">
<a id="liadermarequeststring"></a>
<strong>Purpose</strong>
<p>Prompts the user for a single line of text with an optional description and default value.</p>

<strong>When Called</strong>
<p>Use for simple text input such as renaming or entering custom values.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">title</span> <span class="optional">optional</span> Title text key; defaults to `"enterText"`.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">description</span> <span class="optional">optional</span> Helper text displayed above the entry field.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.6">function</a></span> <span class="parameter">callback</span> <span class="optional">optional</span> Invoked with the entered string, or `false` when cancelled.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> <span class="parameter">defaultValue</span> <span class="optional">optional</span> Pre-filled value for the input field.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">unknown</a></span> <span class="parameter">Pre</span> filled value for the input field.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">unknown</a></span> <span class="parameter">Pre</span> filled value for the input field.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">maxLength</span> <span class="optional">optional</span> Optional character limit.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="/development/meta/panel/">Panel</a></span> The created input frame.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.derma.requestString("Rename", "Enter a new name:", function(val) if val then print("New name", val) end end, "Default")
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.requestOptions></a>lia.derma.requestOptions(title, options, callback, defaults)</summary>
<div class="details-content">
<a id="liadermarequestoptions"></a>
<strong>Purpose</strong>
<p>Presents multiple selectable options, supporting dropdowns and checkboxes, and returns the chosen set.</p>

<strong>When Called</strong>
<p>Use for multi-field configuration prompts where each option can be a boolean or a list of choices.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">title</span> <span class="optional">optional</span> Title text key; defaults to `"selectOptions"`.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">options</span> Array where each entry is either a value or `{display, data}` table; tables create dropdowns, values create checkboxes.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.6">function</a></span> <span class="parameter">callback</span> <span class="optional">optional</span> Invoked with a table of selected values or `false` when cancelled.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">defaults</span> <span class="optional">optional</span> Default selections; for dropdowns this can map option names to selected values.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="/development/meta/panel/">Panel</a></span> The created options frame.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.derma.requestOptions("Permissions", {{"Rank", {"User", "Admin"}}, "CanKick"}, function(result) PrintTable(result) end)
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.requestBinaryQuestion></a>lia.derma.requestBinaryQuestion(title, question, callback, yesText, noText)</summary>
<div class="details-content">
<a id="liadermarequestbinaryquestion"></a>
<strong>Purpose</strong>
<p>Displays a yes/no style modal dialog with customizable labels and forwards the response.</p>

<strong>When Called</strong>
<p>Use when you need explicit confirmation from the player before executing an action.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">title</span> <span class="optional">optional</span> Title text key; defaults to `"question"`.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">question</span> <span class="optional">optional</span> Prompt text; defaults to `"areYouSure"`.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.6">function</a></span> <span class="parameter">callback</span> <span class="optional">optional</span> Invoked with `true` for yes, `false` for no.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">yesText</span> <span class="optional">optional</span> Custom text for the affirmative button; defaults to `"yes"`.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">noText</span> <span class="optional">optional</span> Custom text for the negative button; defaults to `"no"`.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="/development/meta/panel/">Panel</a></span> The created dialog frame.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.derma.requestBinaryQuestion("Confirm", "Delete item?", function(ok) if ok then print("Deleted") end end)
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.requestButtons></a>lia.derma.requestButtons(title, buttons, callback, description)</summary>
<div class="details-content">
<a id="liadermarequestbuttons"></a>
<strong>Purpose</strong>
<p>Creates a dialog with a list of custom buttons and optional description, forwarding clicks to provided callbacks.</p>

<strong>When Called</strong>
<p>Use for multi-action prompts where each button can perform custom logic and optionally prevent auto-close by returning false.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">title</span> <span class="optional">optional</span> Title text key; defaults to `"selectOption"`.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">buttons</span> Array of button definitions; each can be a string or a table with `text`, `callback`, and optional `icon`.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.6">function</a></span> <span class="parameter">callback</span> <span class="optional">optional</span> Fallback invoked with `(index, buttonText)` when a button lacks its own callback; returning false keeps the dialog open.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">description</span> <span class="optional">optional</span> Optional descriptive text shown above the buttons.</p>

<strong>Returns</strong>
<p>Panel, table The created frame and a table of created button panels.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.derma.requestButtons("Choose action", {"Heal", "Damage"}, function(_, text) print("Pressed", text) end, "Pick an effect:")
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.derma.requestPopupQuestion></a>lia.derma.requestPopupQuestion(question, buttons)</summary>
<div class="details-content">
<a id="liadermarequestpopupquestion"></a>
<strong>Purpose</strong>
<p>Shows a small popup question with custom buttons, closing automatically unless a button callback prevents it.</p>

<strong>When Called</strong>
<p>Use for quick confirmation prompts that need more than a binary choice.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">question</span> <span class="optional">optional</span> Prompt text; defaults to `"areYouSure"`.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">buttons</span> Array of button definitions; each can be a string or `{text, callback}` table.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="/development/meta/panel/">Panel</a></span> The created popup frame.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.derma.requestPopupQuestion("Teleport where?", {{"City", function() net.Start("tp_city") net.SendToServer() end}, "Cancel"})
</code></pre>
</div>
</details>

---


# Color

Comprehensive color and theme management system for the Lilia framework.

---

<strong>Overview</strong>

The color library provides comprehensive functionality for managing colors and themes in the Lilia framework. It handles color registration, theme management, color manipulation, and smooth theme transitions. The library operates primarily on the client side, with theme registration available on both server and client. It includes predefined color names, theme switching capabilities, color adjustment functions, and smooth animated transitions between themes. The library ensures consistent color usage across the entire gamemode interface and provides tools for creating custom themes and color schemes.

---

<details class="realm-client">
<summary><a id=lia.color.register></a>lia.color.register(name, color)</summary>
<div class="details-content">
<a id="liacolorregister"></a>
<strong>Purpose</strong>
<p>Register a named color so string-based Color() calls can resolve it.</p>

<strong>When Called</strong>
<p>During client initialization or when adding palette entries at runtime.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">name</span> Identifier stored in lowercase.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table|Color</a></span> <span class="parameter">color</span> Table or Color with r, g, b, a fields.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.color.register("warning", Color(255, 140, 0))
  local c = Color("warning")
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.color.adjust></a>lia.color.adjust(color, aOffset)</summary>
<div class="details-content">
<a id="liacoloradjust"></a>
<strong>Purpose</strong>
<p>Apply additive offsets to a color to quickly tint or shade it.</p>

<strong>When Called</strong>
<p>While building UI states (hover/pressed) or computing theme variants.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Color">Color</a></span> <span class="parameter">color</span> Base color.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">aOffset</span> <span class="optional">optional</span> Optional alpha offset; defaults to 0.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Color">Color</a></span> Adjusted color.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local base = lia.color.getMainColor()
  button:SetTextColor(lia.color.adjust(base, -40, -20, -60))
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.color.darken></a>lia.color.darken(color, factor)</summary>
<div class="details-content">
<a id="liacolordarken"></a>
<strong>Purpose</strong>
<p>Darken a color by a fractional factor.</p>

<strong>When Called</strong>
<p>Deriving hover/pressed backgrounds from a base accent color.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Color">Color</a></span> <span class="parameter">color</span> Base color to darken.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">factor</span> <span class="optional">optional</span> Amount between 0-1; defaults to 0.1 and is clamped.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Color">Color</a></span> Darkened color.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local accent = lia.color.getMainColor()
  local pressed = lia.color.darken(accent, 0.2)
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.color.getCurrentTheme></a>lia.color.getCurrentTheme()</summary>
<div class="details-content">
<a id="liacolorgetcurrenttheme"></a>
<strong>Purpose</strong>
<p>Get the active theme id from config in lowercase.</p>

<strong>When Called</strong>
<p>Before looking up theme tables or theme-specific assets.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> Lowercased theme id (default "teal").</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  if lia.color.getCurrentTheme() == "dark" then
      panel:SetDarkMode(true)
  end
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.color.getCurrentThemeName></a>lia.color.getCurrentThemeName()</summary>
<div class="details-content">
<a id="liacolorgetcurrentthemename"></a>
<strong>Purpose</strong>
<p>Get the display name of the currently selected theme.</p>

<strong>When Called</strong>
<p>Showing UI labels or logs about the active theme.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> Theme name from config with original casing.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  chat.AddText(Color(180, 220, 255), "Theme: ", lia.color.getCurrentThemeName())
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.color.getMainColor></a>lia.color.getMainColor()</summary>
<div class="details-content">
<a id="liacolorgetmaincolor"></a>
<strong>Purpose</strong>
<p>Fetch the main color from the current theme with sensible fallbacks.</p>

<strong>When Called</strong>
<p>Setting accent colors for buttons, bars, and highlights.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Color">Color</a></span> Main theme color, falling back to the default theme or teal.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local accent = lia.color.getMainColor()
  button:SetTextColor(accent)
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.color.applyTheme></a>lia.color.applyTheme(themeName, useTransition)</summary>
<div class="details-content">
<a id="liacolorapplytheme"></a>
<strong>Purpose</strong>
<p>Apply a theme immediately or begin a smooth transition toward it, falling back to Teal/default palettes and firing OnThemeChanged after updates.</p>

<strong>When Called</strong>
<p>On config changes, theme selection menus, or client startup.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">themeName</span> <span class="optional">optional</span> Target theme id; defaults to the current config value.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> <span class="parameter">useTransition</span> <span class="optional">optional</span> If true, blends colors over time instead of swapping instantly.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  concommand.Add("lia_theme_preview", function(_, _, args)
      lia.color.applyTheme(args[1] or "Teal", true)
  end)
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.color.isTransitionActive></a>lia.color.isTransitionActive()</summary>
<div class="details-content">
<a id="liacoloristransitionactive"></a>
<strong>Purpose</strong>
<p>Check whether a theme transition is currently blending.</p>

<strong>When Called</strong>
<p>To avoid overlapping transitions or to gate UI animations.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> True if a transition is active, otherwise false.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  if lia.color.isTransitionActive() then return end
  lia.color.applyTheme("Dark", true)
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.color.testThemeTransition></a>lia.color.testThemeTransition(themeName)</summary>
<div class="details-content">
<a id="liacolortestthemetransition"></a>
<strong>Purpose</strong>
<p>Convenience wrapper to start a theme transition immediately.</p>

<strong>When Called</strong>
<p>From theme preview buttons to animate a swap.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">themeName</span> Target theme id.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  vgui.Create("DButton").DoClick = function()
      lia.color.testThemeTransition("Red")
  end
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.color.startThemeTransition></a>lia.color.startThemeTransition(name)</summary>
<div class="details-content">
<a id="liacolorstartthemetransition"></a>
<strong>Purpose</strong>
<p>Begin blending from the current palette toward a target theme, falling back to Teal when missing and finishing by firing OnThemeChanged once applied.</p>

<strong>When Called</strong>
<p>Inside applyTheme when transitions are enabled or via previews.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">name</span> Theme id to blend toward.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.color.transition.speed = 1.5
  lia.color.startThemeTransition("Ice")
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.color.isColor></a>lia.color.isColor(v)</summary>
<div class="details-content">
<a id="liacoloriscolor"></a>
<strong>Purpose</strong>
<p>Determine whether a value resembles a Color table.</p>

<strong>When Called</strong>
<p>While blending themes to decide how to lerp entries.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> <span class="parameter">v</span> Value to test.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> True when v has numeric r, g, b, a fields.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  if lia.color.isColor(entry) then
      panel:SetTextColor(entry)
  end
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.color.calculateNegativeColor></a>lia.color.calculateNegativeColor(mainColor)</summary>
<div class="details-content">
<a id="liacolorcalculatenegativecolor"></a>
<strong>Purpose</strong>
<p>Build a readable contrasting color (alpha 255) based on a main color.</p>

<strong>When Called</strong>
<p>Choosing text or negative colors for overlays and highlights.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Color">Color</a></span> <span class="parameter">mainColor</span> <span class="optional">optional</span> Defaults to the current theme main color when nil.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Color">Color</a></span> Contrasting color tuned for readability.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local negative = lia.color.calculateNegativeColor()
  frame:SetTextColor(negative)
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.color.returnMainAdjustedColors></a>lia.color.returnMainAdjustedColors()</summary>
<div class="details-content">
<a id="liacolorreturnmainadjustedcolors"></a>
<strong>Purpose</strong>
<p>Derive a suite of adjusted colors from the main theme color, including brightness-aware text and a calculated negative color.</p>

<strong>When Called</strong>
<p>Building consistent palettes for backgrounds, accents, and text.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> Contains background, sidebar, accent, text, hover, border, highlight, negative.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local palette = lia.color.returnMainAdjustedColors()
  panel:SetBGColor(palette.background)
  panel:SetTextColor(palette.text)
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.color.lerp></a>lia.color.lerp(frac, col1, col2)</summary>
<div class="details-content">
<a id="liacolorlerp"></a>
<strong>Purpose</strong>
<p>FrameTime-scaled color lerp helper.</p>

<strong>When Called</strong>
<p>Theme transitions or animated highlights needing smooth color changes.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">frac</span> Multiplier applied to FrameTime for lerp speed.</p>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Color">Color</a></span> <span class="parameter">col1</span> Source color; defaults to white when nil.</p>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Color">Color</a></span> <span class="parameter">col2</span> Target color; defaults to white when nil.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Color">Color</a></span> Interpolated color.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local blink = lia.color.lerp(6, Color(255, 0, 0), Color(255, 255, 255))
  panel:SetBorderColor(blink)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.color.registerTheme></a>lia.color.registerTheme(name, themeData)</summary>
<div class="details-content">
<a id="liacolorregistertheme"></a>
<strong>Purpose</strong>
<p>Register a theme table by name for later selection.</p>

<strong>When Called</strong>
<p>During initialization to expose custom palettes.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">name</span> Theme name/id; stored in lowercase.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">themeData</span> Map of color keys to Color values or arrays.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.color.registerTheme("MyStudio", {
      maincolor = Color(120, 200, 255),
      background = Color(20, 24, 32),
      text = Color(230, 240, 255)
  })
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.color.getAllThemes></a>lia.color.getAllThemes()</summary>
<div class="details-content">
<a id="liacolorgetallthemes"></a>
<strong>Purpose</strong>
<p>Return a sorted list of available theme ids.</p>

<strong>When Called</strong>
<p>To populate config dropdowns or theme selection menus.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> Sorted array of theme ids.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local options = {}
  for _, id in ipairs(lia.color.getAllThemes()) do
      options[#options + 1] = id
  end
</code></pre>
</div>
</details>

---


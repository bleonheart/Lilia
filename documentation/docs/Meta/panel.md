# Panel Meta

Panel management system for the Lilia framework.

---

Overview

The panel meta table provides comprehensive functionality for managing VGUI panels, UI interactions, and panel operations in the Lilia framework. It handles panel event listening, inventory synchronization, UI updates, and panel-specific operations. The meta table operates primarily on the client side, with the server providing data that panels can listen to and display. It includes integration with the inventory system for inventory change notifications, character system for character data display, network system for data synchronization, and UI system for panel management. The meta table ensures proper panel event handling, inventory synchronization, UI updates, and comprehensive panel lifecycle management from creation to destruction.

---

## Index

- [liaListenForInventoryChanges](#lialistenforinventorychanges)
- [liaDeleteInventoryHooks](#liadeleteinventoryhooks)
- [setScaledPos](#setscaledpos)
- [setScaledSize](#setscaledsize)
- [On](#on)
- [SetupTransition](#setuptransition)
- [FadeHover](#fadehover)
- [BarHover](#barhover)
- [FillHover](#fillhover)
- [Background](#background)
- [Material](#material)
- [TiledMaterial](#tiledmaterial)
- [Outline](#outline)
- [LinedCorners](#linedcorners)
- [SideBlock](#sideblock)
- [Text](#text)
- [DualText](#dualtext)
- [Blur](#blur)
- [CircleClick](#circleclick)
- [CircleHover](#circlehover)
- [SquareCheckbox](#squarecheckbox)
- [CircleCheckbox](#circlecheckbox)
- [AvatarMask](#avatarmask)
- [CircleAvatar](#circleavatar)
- [Circle](#circle)
- [CircleFadeHover](#circlefadehover)
- [CircleExpandHover](#circleexpandhover)
- [Gradient](#gradient)
- [SetOpenURL](#setopenurl)
- [NetMessage](#netmessage)
- [Stick](#stick)
- [DivTall](#divtall)
- [DivWide](#divwide)
- [SquareFromHeight](#squarefromheight)
- [SquareFromWidth](#squarefromwidth)
- [SetRemove](#setremove)
- [FadeIn](#fadein)
- [HideVBar](#hidevbar)
- [SetTransitionFunc](#settransitionfunc)
- [ClearTransitionFunc](#cleartransitionfunc)
- [SetAppendOverwrite](#setappendoverwrite)
- [ClearAppendOverwrite](#clearappendoverwrite)
- [ClearPaint](#clearpaint)
- [ReadyTextbox](#readytextbox)

---

<a id="lialistenforinventorychanges"></a>
### liaListenForInventoryChanges

#### 📋 Purpose
Registers the panel to mirror inventory events to its methods.

#### ⏰ When Called
Use when a panel needs to react to changes in a specific inventory.

#### ⚙️ Parameters

- `inventory` (Inventory) - Inventory instance whose events should be listened to.

#### ↩️ Returns
* nil
Only installs hooks.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    panel:liaListenForInventoryChanges(inv)

```

---

<a id="liadeleteinventoryhooks"></a>
### liaDeleteInventoryHooks

#### 📋 Purpose
Removes inventory event hooks previously registered on the panel.

#### ⏰ When Called
Call when tearing down a panel or when an inventory is no longer tracked.

#### ⚙️ Parameters

- `id` (number|nil) - Optional inventory ID to target; nil clears all known hooks.

#### ↩️ Returns
* nil
Cleans up and exits.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    panel:liaDeleteInventoryHooks(invID)

```

---

<a id="setscaledpos"></a>
### setScaledPos

#### 📋 Purpose
Sets the panel position using screen-scaled coordinates.

#### ⏰ When Called
Use when positioning should respect different resolutions.

#### ⚙️ Parameters

- `x` (number) - Horizontal position before scaling.
- `y` (number) - Vertical position before scaling.

#### ↩️ Returns
* nil
Updates the panel position.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    panel:setScaledPos(32, 48)

```

---

<a id="setscaledsize"></a>
### setScaledSize

#### 📋 Purpose
Sets the panel size using screen-scaled dimensions.

#### ⏰ When Called
Use when sizing should scale with screen resolution.

#### ⚙️ Parameters

- `w` (number) - Width before scaling.
- `h` (number) - Height before scaling.

#### ↩️ Returns
* nil
Updates the panel size.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    panel:setScaledSize(120, 36)

```

---

<a id="on"></a>
### On

#### 📋 Purpose
Appends an additional handler to a panel function without removing the existing one.

#### ⏰ When Called
Use to extend an existing panel callback (e.g., Paint, Think) while preserving prior logic.

#### ⚙️ Parameters

- `name` (string) - Panel function name to wrap.
- `fn` (function) - Function to run after the original callback.

#### ↩️ Returns
* nil
Rebinds the panel function.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    panel:On("Paint", function(s, w, h) draw.RoundedBox(0, 0, 0, w, h, col) end)

```

---

<a id="setuptransition"></a>
### SetupTransition

#### 📋 Purpose
Creates a smoothly lerped state property driven by a predicate function.

#### ⏰ When Called
Use when a panel needs an animated transition flag (e.g., hover fades).

#### ⚙️ Parameters

- `name` (string) - Property name to animate on the panel.
- `speed` (number) - Lerp speed multiplier.
- `fn` (function) - Predicate returning true when the property should approach 1.

#### ↩️ Returns
* nil
Adds Think hook to update the property.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    panel:SetupTransition("HoverAlpha", 6, function(s) return s:IsHovered() end)

```

---

<a id="fadehover"></a>
### FadeHover

#### 📋 Purpose
Draws a faded overlay that brightens when the panel is hovered.

#### ⏰ When Called
Apply to panels that need a simple hover highlight.

#### ⚙️ Parameters

- `col` (Color) - Overlay color and base alpha.
- `speed` (number) - Transition speed toward hover state.
- `rad` (number|nil) - Optional corner radius for rounded boxes.

#### ↩️ Returns
* nil
Paint hook handles drawing.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    panel:FadeHover(Color(255,255,255,40), 8, 4)

```

---

<a id="barhover"></a>
### BarHover

#### 📋 Purpose
Animates a horizontal bar under the panel while hovered.

#### ⏰ When Called
Use for button underlines or similar hover indicators.

#### ⚙️ Parameters

- `col` (Color) - Bar color.
- `height` (number) - Bar thickness in pixels.
- `speed` (number) - Transition speed toward hover state.

#### ↩️ Returns
* nil
Drawing occurs in PaintOver.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    panel:BarHover(Color(0,150,255), 2, 10)

```

---

<a id="fillhover"></a>
### FillHover

#### 📋 Purpose
Fills the panel from one side while hovered, optionally using a material.

#### ⏰ When Called
Use when a directional hover fill effect is desired.

#### ⚙️ Parameters

- `col` (Color) - Fill color.
- `dir` (number) - Direction constant (LEFT, RIGHT, TOP, BOTTOM).
- `speed` (number) - Transition speed toward hover state.
- `mat` (IMaterial|nil) - Optional material to draw instead of a solid color.

#### ↩️ Returns
* nil
PaintOver handles the drawing.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    panel:FillHover(Color(255,255,255,20), LEFT, 6)

```

---

<a id="background"></a>
### Background

#### 📋 Purpose
Paints a solid background for the panel with optional rounded corners.

#### ⏰ When Called
Use when a panel needs a consistent background fill.

#### ⚙️ Parameters

- `col` (Color) - Fill color.
- `rad` (number|nil) - Corner radius; nil or 0 draws a square rect.

#### ↩️ Returns
* nil
Assigns a Paint handler.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    panel:Background(Color(20,20,20,230), 6)

```

---

<a id="material"></a>
### Material

#### 📋 Purpose
Draws a textured material across the panel.

#### ⏰ When Called
Use when a static material should cover the panel area.

#### ⚙️ Parameters

- `mat` (IMaterial) - Material to render.
- `col` (Color) - Color tint applied to the material.

#### ↩️ Returns
* nil
Paint hook renders the material.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    panel:Material(Material("vgui/gradient-l"), Color(255,255,255))

```

---

<a id="tiledmaterial"></a>
### TiledMaterial

#### 📋 Purpose
Tiles a material over the panel at a fixed texture size.

#### ⏰ When Called
Use when repeating patterns should fill the panel.

#### ⚙️ Parameters

- `mat` (IMaterial) - Material to tile.
- `tw` (number) - Tile width in texture units.
- `th` (number) - Tile height in texture units.
- `col` (Color) - Color tint for the material.

#### ↩️ Returns
* nil
Paint hook renders the tiled material.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    panel:TiledMaterial(myMat, 64, 64, Color(255,255,255))

```

---

<a id="outline"></a>
### Outline

#### 📋 Purpose
Draws an outlined rectangle around the panel.

#### ⏰ When Called
Use to give a panel a simple border.

#### ⚙️ Parameters

- `col` (Color) - Outline color.
- `width` (number) - Border thickness in pixels.

#### ↩️ Returns
* nil
Paint hook handles drawing.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    panel:Outline(Color(255,255,255), 2)

```

---

<a id="linedcorners"></a>
### LinedCorners

#### 📋 Purpose
Draws minimal corner lines on opposite corners of the panel.

#### ⏰ When Called
Use for a lightweight corner accent instead of a full border.

#### ⚙️ Parameters

- `col` (Color) - Corner line color.
- `cornerLen` (number) - Length of each corner arm in pixels.

#### ↩️ Returns
* nil
Paint hook handles the drawing.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    panel:LinedCorners(Color(255,255,255), 12)

```

---

<a id="sideblock"></a>
### SideBlock

#### 📋 Purpose
Adds a solid strip to one side of the panel.

#### ⏰ When Called
Use for side indicators or separators on panels.

#### ⚙️ Parameters

- `col` (Color) - Strip color.
- `size` (number) - Strip thickness in pixels.
- `side` (number) - Side constant (LEFT, RIGHT, TOP, BOTTOM).

#### ↩️ Returns
* nil
Paint hook draws the strip.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    panel:SideBlock(Color(0,140,255), 4, LEFT)

```

---

<a id="text"></a>
### Text

#### 📋 Purpose
Renders a single line of text within the panel or sets label properties directly.

#### ⏰ When Called
Use to quickly add centered or aligned text to a panel.

#### ⚙️ Parameters

- `text` (string) - Text to display.
- `font` (string) - Font name to use.
- `col` (Color) - Text color.
- `alignment` (number) - TEXT_ALIGN_* constant controlling horizontal alignment.
- `paint` (boolean) - Force paint-based rendering even if label setters exist.

#### ↩️ Returns
* nil
Sets label fields or installs a Paint hook.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    panel:Text("Hello", "Trebuchet24", color_white, TEXT_ALIGN_CENTER)

```

---

<a id="dualtext"></a>
### DualText

#### 📋 Purpose
Draws two stacked text lines with independent styling.

#### ⏰ When Called
Use when a panel needs a title and subtitle aligned together.

#### ⚙️ Parameters

- `alignment` (number) - TEXT_ALIGN_* horizontal alignment.
- `centerSpacing` (number) - Offset to spread the two lines from the center point.

#### ↩️ Returns
* nil
Paint hook handles drawing.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    panel:DualText("Title", "Trebuchet24", lia.colors.primary, "Detail", "Trebuchet18", color_white)

```

---

<a id="blur"></a>
### Blur

#### 📋 Purpose
Draws a post-process blur behind the panel bounds.

#### ⏰ When Called
Use to blur the world/UI behind a panel while it is painted.

#### ⚙️ Parameters

- `amount` (number) - Blur intensity multiplier.

#### ↩️ Returns
* nil
Paint hook handles the blur passes.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    panel:Blur(8)

```

---

<a id="circleclick"></a>
### CircleClick

#### 📋 Purpose
Creates a ripple effect centered on the click position.

#### ⏰ When Called
Use for buttons that need animated click feedback.

#### ⚙️ Parameters

- `col` (Color) - Ripple color and opacity.
- `speed` (number) - Lerp speed for expansion and fade.
- `trad` (number|nil) - Target radius override; defaults to panel width.

#### ↩️ Returns
* nil
Paint and DoClick hooks manage the effect.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    panel:CircleClick(Color(255,255,255,40), 5)

```

---

<a id="circlehover"></a>
### CircleHover

#### 📋 Purpose
Draws a circular highlight that follows the cursor while hovering.

#### ⏰ When Called
Use for hover feedback centered on the cursor position.

#### ⚙️ Parameters

- `col` (Color) - Highlight color and base opacity.
- `speed` (number) - Transition speed for appearing/disappearing.
- `trad` (number|nil) - Target radius; defaults to panel width.

#### ↩️ Returns
* nil
Think and PaintOver hooks animate the effect.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    panel:CircleHover(Color(255,255,255,30), 6)

```

---

<a id="squarecheckbox"></a>
### SquareCheckbox

#### 📋 Purpose
Renders an animated square checkbox fill tied to the panel's checked state.

#### ⏰ When Called
Use on checkbox panels to visualize toggled state.

#### ⚙️ Parameters

- `inner` (Color) - Color of the filled square.
- `outer` (Color) - Color of the outline/background.
- `speed` (number) - Transition speed for filling.

#### ↩️ Returns
* nil
Paint hook handles the drawing.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    checkbox:SquareCheckbox()

```

---

<a id="circlecheckbox"></a>
### CircleCheckbox

#### 📋 Purpose
Renders an animated circular checkbox tied to the panel's checked state.

#### ⏰ When Called
Use on checkbox panels that should appear circular.

#### ⚙️ Parameters

- `inner` (Color) - Color of the inner filled circle.
- `outer` (Color) - Outline color.
- `speed` (number) - Transition speed for filling.

#### ↩️ Returns
* nil
Paint hook handles the drawing.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    checkbox:CircleCheckbox()

```

---

<a id="avatarmask"></a>
### AvatarMask

#### 📋 Purpose
Applies a stencil mask to an AvatarImage child using a custom shape.

#### ⏰ When Called
Use when an avatar needs to be clipped to a non-rectangular mask.

#### ⚙️ Parameters

- `mask` (function) - Draw callback that defines the stencil shape.

#### ↩️ Returns
* nil
Sets up avatar child and overrides paint functions.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    panel:AvatarMask(function(_, w, h) drawCircle(w/2, h/2, w/2) end)

```

---

<a id="circleavatar"></a>
### CircleAvatar

#### 📋 Purpose
Masks the panel's avatar as a circle.

#### ⏰ When Called
Use when a circular avatar presentation is desired.

#### ↩️ Returns
* nil
Delegates to AvatarMask.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    panel:CircleAvatar()

```

---

<a id="circle"></a>
### Circle

#### 📋 Purpose
Paints a filled circle that fits the panel bounds.

#### ⏰ When Called
Use for circular panels or backgrounds.

#### ⚙️ Parameters

- `col` (Color) - Circle color.

#### ↩️ Returns
* nil
Paint hook renders the circle.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    panel:Circle(Color(255,255,255))

```

---

<a id="circlefadehover"></a>
### CircleFadeHover

#### 📋 Purpose
Shows a fading circular overlay at the center while hovered.

#### ⏰ When Called
Use for subtle hover feedback on circular elements.

#### ⚙️ Parameters

- `col` (Color) - Overlay color and base alpha.
- `speed` (number) - Transition speed toward hover state.

#### ↩️ Returns
* nil
Paint hook manages the effect.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    panel:CircleFadeHover(Color(255,255,255,30), 6)

```

---

<a id="circleexpandhover"></a>
### CircleExpandHover

#### 📋 Purpose
Draws an expanding circle from the panel center while hovered.

#### ⏰ When Called
Use when a growing highlight is needed on hover.

#### ⚙️ Parameters

- `col` (Color) - Circle color and alpha.
- `speed` (number) - Transition speed toward hover state.

#### ↩️ Returns
* nil
Paint hook manages the drawing.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    panel:CircleExpandHover(Color(255,255,255,30), 6)

```

---

<a id="gradient"></a>
### Gradient

#### 📋 Purpose
Draws a directional gradient over the panel.

#### ⏰ When Called
Use to overlay a gradient tint from a chosen side.

#### ⚙️ Parameters

- `col` (Color) - Gradient color.
- `dir` (number) - Direction constant (LEFT, RIGHT, TOP, BOTTOM).
- `frac` (number) - Fraction of the panel to cover with the gradient.
- `op` (boolean) - When true, flips the gradient material for the given direction.

#### ↩️ Returns
* nil
Paint hook renders the gradient.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    panel:Gradient(Color(0,0,0,180), BOTTOM, 0.4)

```

---

<a id="setopenurl"></a>
### SetOpenURL

#### 📋 Purpose
Opens a URL when the panel is clicked.

#### ⏰ When Called
Attach to clickable panels that should launch an external link.

#### ⚙️ Parameters

- `url` (string) - URL to open.

#### ↩️ Returns
* nil
Registers a DoClick handler.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    panel:SetOpenURL("https://example.com")

```

---

<a id="netmessage"></a>
### NetMessage

#### 📋 Purpose
Sends a network message when the panel is clicked.

#### ⏰ When Called
Use for UI buttons that trigger server-side actions.

#### ⚙️ Parameters

- `name` (string) - Net message name.
- `data` (function) - Optional writer that populates the net message payload.

#### ↩️ Returns
* nil
Registers the click handler and sends the message.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    panel:NetMessage("liaAction", function(p) net.WriteEntity(p.Entity) end)

```

---

<a id="stick"></a>
### Stick

#### 📋 Purpose
Docks the panel with optional margin and parent invalidation.

#### ⏰ When Called
Use to pin a panel to a dock position with minimal boilerplate.

#### ⚙️ Parameters

- `dock` (number) - DOCK constant to apply; defaults to FILL.
- `margin` (number) - Optional uniform margin after docking.
- `dontInvalidate` (boolean) - Skip invalidating the parent when true.

#### ↩️ Returns
* nil
Adjusts docking and layout.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    panel:Stick(LEFT, 8)

```

---

<a id="divtall"></a>
### DivTall

#### 📋 Purpose
Sets the panel height to a fraction of another panel's height.

#### ⏰ When Called
Use for proportional layout against a parent or target panel.

#### ⚙️ Parameters

- `frac` (number) - Divisor applied to the target height.
- `target` (Panel) - Panel to reference; defaults to the parent.

#### ↩️ Returns
* nil
Adjusts panel height.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    panel:DivTall(3, parentPanel)

```

---

<a id="divwide"></a>
### DivWide

#### 📋 Purpose
Sets the panel width to a fraction of another panel's width.

#### ⏰ When Called
Use for proportional layout against a parent or target panel.

#### ⚙️ Parameters

- `frac` (number) - Divisor applied to the target width.
- `target` (Panel) - Panel to reference; defaults to the parent.

#### ↩️ Returns
* nil
Adjusts panel width.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    panel:DivWide(2, parentPanel)

```

---

<a id="squarefromheight"></a>
### SquareFromHeight

#### 📋 Purpose
Makes the panel width equal its current height.

#### ⏰ When Called
Use when the panel should become a square based on height.

#### ↩️ Returns
* nil
Updates the width.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    panel:SquareFromHeight()

```

---

<a id="squarefromwidth"></a>
### SquareFromWidth

#### 📋 Purpose
Makes the panel height equal its current width.

#### ⏰ When Called
Use when the panel should become a square based on width.

#### ↩️ Returns
* nil
Updates the height.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    panel:SquareFromWidth()

```

---

<a id="setremove"></a>
### SetRemove

#### 📋 Purpose
Removes a target panel when this panel is clicked.

#### ⏰ When Called
Use for close buttons or dismiss actions.

#### ⚙️ Parameters

- `target` (Panel|nil) - Panel to remove; defaults to the panel itself.

#### ↩️ Returns
* nil
Registers the click handler.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    closeButton:SetRemove(parentPanel)

```

---

<a id="fadein"></a>
### FadeIn

#### 📋 Purpose
Fades the panel in from transparent to a target alpha.

#### ⏰ When Called
Use when showing a panel with a quick fade animation.

#### ⚙️ Parameters

- `time` (number) - Duration of the fade in seconds.
- `alpha` (number) - Target opacity after fading.

#### ↩️ Returns
* nil
Starts the alpha animation.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    panel:FadeIn(0.2, 255)

```

---

<a id="hidevbar"></a>
### HideVBar

#### 📋 Purpose
Hides and collapses the vertical scrollbar of a DScrollPanel.

#### ⏰ When Called
Use when the scrollbar should be invisible but scrolling remains enabled.

#### ↩️ Returns
* nil
Adjusts VBar visibility and size.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    scrollPanel:HideVBar()

```

---

<a id="settransitionfunc"></a>
### SetTransitionFunc

#### 📋 Purpose
Sets a shared predicate used by transition helpers to determine state.

#### ⏰ When Called
Use before invoking helpers like SetupTransition to change their condition.

#### ⚙️ Parameters

- `fn` (function) - Predicate returning true when the transition should be active.

#### ↩️ Returns
* nil
Stores the predicate.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    panel:SetTransitionFunc(function(s) return s:IsVisible() end)

```

---

<a id="cleartransitionfunc"></a>
### ClearTransitionFunc

#### 📋 Purpose
Clears any predicate set for transition helpers.

#### ⏰ When Called
Use to revert transition helpers back to their default behavior.

#### ↩️ Returns
* nil
Removes the predicate.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    panel:ClearTransitionFunc()

```

---

<a id="setappendoverwrite"></a>
### SetAppendOverwrite

#### 📋 Purpose
Overrides the target function name used by the On helper.

#### ⏰ When Called
Use when On should wrap a different function name than the provided one.

#### ⚙️ Parameters

- `fn` (string) - Function name to force On to wrap.

#### ↩️ Returns
* nil
Stores the override name.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    panel:SetAppendOverwrite("PaintOver")

```

---

<a id="clearappendoverwrite"></a>
### ClearAppendOverwrite

#### 📋 Purpose
Removes any function name override set for the On helper.

#### ⏰ When Called
Use to return On to its default behavior.

#### ↩️ Returns
* nil
Deletes the override field.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    panel:ClearAppendOverwrite()

```

---

<a id="clearpaint"></a>
### ClearPaint

#### 📋 Purpose
Removes any custom Paint function on the panel.

#### ⏰ When Called
Use to revert a panel to its default painting behavior.

#### ↩️ Returns
* nil
Paint is set to nil.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    panel:ClearPaint()

```

---

<a id="readytextbox"></a>
### ReadyTextbox

#### 📋 Purpose
Prepares a text entry for Lilia styling by hiding its background and adding focus feedback.

#### ⏰ When Called
Use after creating a TextEntry to match framework visuals.

#### ↩️ Returns
* nil
Configures paint behaviors and transition state.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    textEntry:ReadyTextbox()

```

---


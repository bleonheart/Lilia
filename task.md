---

# Lilia Panel Theme Migration Task

## Objective
Convert all `lia` panels to match **Mantle's visual design** while using the **Lilia theme system** for proper color management and theme switching.

## Core Requirements

### 1. Theme System Integration
- **MANDATORY**: Use `lia.color.theme` for ALL colors - no hardcoded values
- **MANDATORY**: Support all registered Lilia themes (dark, light, blue, red, green, etc.)
- **MANDATORY**: Maintain visual consistency with Mantle design patterns

### 2. Code Standards
- **Standalone**: Do not use Mantle directly - only inspired by its design
- **Multi-step creation**: Replicate Mantle's complex creation patterns (e.g., `Mantle.ui.radial_menu`)
- **Incremental work**: Process 2-3 TODO items per request

### 3. Color Mapping Rules
```lua
-- WRONG - Hardcoded colors
local bgColor = Color(25, 25, 25)
local textColor = Color(255, 255, 255)

-- CORRECT - Theme-based colors
local bgColor = lia.color.theme.background
local textColor = lia.color.theme.text
```

---

# TODO List

## Migration Checklist

### UI Panels (Priority: High)
- [] **MantleBtn → liaButton** - Button component with theme integration
- [] **MantleFrame → liaFrame** - Window/frame component with draggable header
- [] **MantleCheckBox → liaCheckBox** - Checkbox with custom styling
- [] **MantleEntry → liaEntry** - Text input field with theme colors
- [] **MantleScrollPanel → liaScrollPanel** - Scrollable container
- [] **MantleTabs → liaTabs** - Tabbed interface component
- [] **MantleTable → liaTable** - Data table with sorting/filtering
- [] **MantleSlideBox → liaSlideBox** - Collapsible slide container
- [] **MantleComboBox → liaComboBox** - Dropdown selection component
- [] **MantleCategory → liaCategory** - Categorized content container
- [] **MantleText → DLabel** - Custom styled text labels
- [] **MantleDermaMenu → liaDermaMenu** - Context menu system

### UI Functions (Priority: Medium)
- [] **Mantle.ui.btn() → liaButton** - Button creation helper
- [] **Mantle.ui.frame() → liaFrame** - Frame creation helper
- [] **Mantle.ui.checkbox() → liaCheckBox** - Checkbox creation helper
- [] **Mantle.ui.desc_entry() → liaEntry** - Entry field creation helper
- [] **Mantle.ui.sp() → liaScrollPanel** - Scroll panel creation helper
- [] **Mantle.ui.panel_tabs() → liaTabs** - Tab creation helper
- [] **Mantle.ui.slidebox() → liaSlideBox** - Slide box creation helper
- [] **Mantle.ui.derma_menu() → liaDermaMenu** - Menu creation helper
- [] **Mantle.ui.radial_menu() → liaRadialPanel** - Radial menu creation helper

### Utility Functions (Priority: Low)
- [] **Mantle.func.animate_appearance() → lia.util.animateAppearance()** - Animation helper
- [] **Mantle.func.LerpColor() → lia.color.Lerp()** - Color interpolation
- [] **Mantle.func.approachExp() → lia.util.approachExp()** - Exponential approach
- [] **Mantle.func.easeInOutCubic() → lia.util.easeInOutCubic()** - Easing function
- [] **Mantle.func.blur() → lia.util.drawBlur()** - Blur effect
- [] **Mantle.func.gradient() → lia.util.drawGradient()** - Gradient drawing
- [] **Mantle.func.w() → ScreenScale()** - Width scaling (already exists)
- [] **Mantle.func.h() → ScreenScaleH()** - Height scaling (already exists)
- [] **Mantle.color → lia.color.theme** - Color system migration

---

## Theme System Reference

### Color Mapping Table
| Mantle Color | Lilia Theme Color | Usage |
|--------------|-------------------|-------|
| `Mantle.color_dark.background` | `lia.color.theme.background` | Main background |
| `Mantle.color_dark.sidebar` | `lia.color.theme.sidebar` | Sidebar/panel background |
| `Mantle.color_dark.theme` | `lia.color.theme.accent` | Accent/theme color |
| `Mantle.color_dark.text` | `lia.color.theme.text` | Text color |
| `Mantle.color_dark.button` | `lia.color.theme.button` | Button background |
| `Mantle.color_dark.button_hovered` | `lia.color.theme.button_hovered` | Button hover state |
| `Mantle.color_dark.hover` | `lia.color.theme.hover` | Hover highlight |
| `Mantle.color_dark.panel[1]` | `lia.color.theme.panel[1]` | Panel gradient start |
| `Mantle.color_dark.panel[2]` | `lia.color.theme.panel[2]` | Panel gradient middle |
| `Mantle.color_dark.panel[3]` | `lia.color.theme.panel[3]` | Panel gradient end |
| `Mantle.color_dark.header` | `lia.color.theme.header` | Header background |
| `Mantle.color_dark.header_text` | `lia.color.theme.header_text` | Header text |
| `Mantle.color_dark.border` | `lia.color.theme.border` | Border color |
| `Mantle.color_dark.window_shadow` | `lia.color.theme.window_shadow` | Window shadow |

### Code Examples

#### ❌ WRONG - Hardcoded Colors
```lua
function PANEL:Paint(w, h)
    draw.RoundedBox(8, 0, 0, w, h, Color(25, 25, 25))  -- Hardcoded
    draw.SimpleText("Title", "DermaDefault", 10, 10, Color(255, 255, 255))  -- Hardcoded
end
```

#### ✅ CORRECT - Theme Colors
```lua
function PANEL:Paint(w, h)
    draw.RoundedBox(8, 0, 0, w, h, lia.color.theme.background)
    draw.SimpleText("Title", "DermaDefault", 10, 10, lia.color.theme.text)
end
```

#### ✅ CORRECT - Theme Transitions
```lua
function PANEL:Paint(w, h)
    local bgColor = lia.color.Lerp(0.1, lia.color.theme.button, lia.color.theme.button_hovered)
    draw.RoundedBox(8, 0, 0, w, h, bgColor)
end
```

### Implementation Guidelines

1. **MANDATORY**: Replace ALL hardcoded colors with `lia.color.theme.*`
2. **MANDATORY**: Use `lia.color.Lerp()` for smooth transitions
3. **MANDATORY**: Test with multiple themes (dark, light, blue, red, green)
4. **MANDATORY**: Use gradient arrays `lia.color.theme.panel[1-3]` for visual effects
5. **MANDATORY**: Handle transparency with `lia.color.theme.background_alpha`
6. **MANDATORY**: Maintain Mantle's visual design patterns

---

## Usage Instructions

### For Cursor IDE
- **Progress Tracking**: Use `[]/[ ]` checkboxes to mark completed items
- **Section Navigation**: Jump between `UI Panels`, `UI Functions`, `Utility Functions`
- **Incremental Work**: Process 2-3 items per request for manageable chunks

### For AI Codex Integration
- **Clear Structure**: Hierarchical organization with priorities
- **Code Examples**: Concrete examples of right/wrong implementations
- **Mandatory Rules**: Explicit requirements with **MANDATORY** tags
- **Context Preservation**: All necessary information in one document

---

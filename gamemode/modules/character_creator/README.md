# Character Creator

This module replaces only the default **Create Character** flow while leaving the normal Lilia character menu and its load, main-character, staff, Discord, Workshop, mounting, and disconnect behavior intact.

The creator uses the species creator's visual composition as its UX reference: a world-space character preview, right-side floating workspace, numbered creation steps, active/ready state badges, animated camera transitions, review page, and inline validation feedback.

When the selected faction has more than one class marked `isDefault`, a **Class** step is inserted immediately after Faction. With zero default classes no class is sent; with exactly one default class it is selected automatically without adding an extra step. The selected class also drives Lilia's normal class model helpers.

## Registering creation tabs

Creation tabs are registered directly through `RegisterCharacterCreationTabs`. There is no `MODULE:RegisterCreationTab` API. Built-in and external tabs use the same hook mechanism.

```lua
hook.Add("RegisterCharacterCreationTabs", "exampleBackgroundTab", function(tabs)
    tabs["background"] = {
        name = "Background",
        order = 25,
        reviewHeader = "Character Background",

        onCreate = function(parent, context, creatorPanel)
            local panel = vgui.Create("DPanel", parent)
            panel:Dock(FILL)

            local entry = vgui.Create("liaEntry", panel)
            entry:Dock(TOP)
            entry:SetTall(40)
            entry:SetPlaceholderText("Character background")
            entry:SetValue(context.background or "")

            entry.OnValueChange = function(_, value)
                creatorPanel:SetCreationContext("background", value)
            end

            return panel
        end,

        onValidate = function(context)
            if string.Trim(context.background or "") == "" then
                return false, "Please enter a background."
            end

            return true
        end,

        onBuildSummary = function(context, summary)
            summary[#summary + 1] = {
                title = "Background",
                value = context.background or ""
            }
        end
    }
end)
```

Remove a custom tab by removing its registration hook:

```lua
hook.Remove("RegisterCharacterCreationTabs", "exampleBackgroundTab")
```

A custom tab may also define `icon`, `reviewHeader`, `shouldShow`, `onEnter`, `onLeave`, `onValidate`, `onBuildSummary`, and `onBuildPayload`.

The creator also calls these extension hooks:

- `CharacterCreationTabCreated`
- `CanShowCharacterCreationTab`
- `ValidateCharacterCreationTab`
- `BuildCharacterCreationSummary`
- `BuildCharacterCreationPayload`
- `CharacterCreationTabChanged`
- `CharacterCreationFinished`

## Customizing the review

Each tab's summary entries are grouped under a header in the review. By default the
header is the tab's `name`; set `reviewHeader` on a tab to override it. An individual
summary entry can set `header` to override its group label, which is also useful for
entries added through `BuildCharacterCreationSummary`. Summary entries may include an
optional `height`. The review invokes these hooks after the summary has been built:

- `CreateCharacterCreationReviewItem(parent, item, reviewPanel, context, creatorPanel)` — return a panel to replace the stock card, or `false` to hide that item.
- `CharacterCreationReviewItemCreated(card, item, reviewPanel, context, creatorPanel)` — style or configure a stock/replacement card after it is added.
- `CharacterCreationReviewLayout(reviewPanel, cards, summary, context, creatorPanel)` — adjust card positions or sizes after the default layout.
- `CharacterCreationReviewCreated(reviewPanel, summary, context, creatorPanel)` — customize the completed review page.

For example, review items can be grouped or displayed as separate values by changing
the summary in `BuildCharacterCreationSummary`, or by returning custom cards from
`CreateCharacterCreationReviewItem`.

Payload additions are filtered against `lia.char.vars` before the normal main-menu character creation function is called. Arbitrary client keys are not sent to character creation.

## Files

- `module.lua` — tab collection, sorted access, and shared creator state
- `derma/client.lua` — full client UI, built-in tab hooks, world preview, validation, payload construction, cleanup, and main-menu integration

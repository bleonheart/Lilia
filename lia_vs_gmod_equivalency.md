# Lia Panel vs GMod Panel Equivalency Table

This document compares Lia panels with their equivalent GMod panels and shows which methods are missing.

## Overview

Lia panels are custom implementations that extend or replace standard GMod panels with enhanced styling and functionality.

## Summary

- **Total Lia Panels Analyzed:** 37
- **Total GMod Panels Referenced:** 99
- **Panels with Complete Method Coverage:** 0 (All Lia panels are missing some methods from their GMod equivalents)
- **Most Complete Panel:** `liaComboBox` (26 Lia methods vs 15 GMod methods, but still missing 15)
- **Least Complete Panel:** Most panels are missing nearly all methods from their GMod equivalents

## Key Findings

### Example: liaComboBox vs DComboBox

The `liaComboBox` is Lia's equivalent to GMod's `DComboBox` (dropdown/combo box). Here's the comparison:

**liaComboBox Methods:** 26
- AddChoice, SetValue, ChooseOption, ChooseOptionID, ChooseOptionData, GetValue, SetPlaceholder, Clear, OpenMenu, CloseMenu, OnRemove, GetOptionData, SetConVar, GetSelectedID, GetSelectedData, GetSelectedText, IsMenuOpen, SetFont, RefreshDropdown, AutoSize, FinishAddingOptions, SetTall, RecalculateSize, PostInit, SetTextColor, GetTextColor

**DComboBox Methods:** 15
- AddChoice, ChooseOption, ChooseOptionID, Clear, CloseMenu, OpenMenu, SetSortItems, SetValue, etc.

**Missing in liaComboBox:** 15 methods including AddSpacer, CheckConVarChanges, SetSortItems, etc.

This shows that while `liaComboBox` has more methods (26 vs 15), it's missing some core DComboBox functionality.

## Methodology & Limitations

### How the Analysis Works

1. **Panel Method Extraction**: The script parses `panel_methods.md` (generated from scraping the GMod wiki) to extract all documented methods for each GMod panel
2. **Lia Panel Identification**: Lia panels are identified from `vgui.Register()` calls in the Lia codebase
3. **Method Mapping**: Each Lia panel is mapped to its most likely GMod equivalent based on naming and functionality
4. **Comparison**: Methods are compared to identify what's missing in Lia implementations

### Limitations

- **Incomplete Method Detection**: The Lia panel method detection is based on manual analysis and may miss some methods that aren't explicitly documented in the source files
- **Inheritance**: Many Lia panels inherit from base GMod panels, so they may have access to inherited methods that aren't explicitly listed
- **Custom Functionality**: Lia panels often add custom methods that don't exist in GMod panels
- **Dynamic Method Addition**: Some methods may be added dynamically at runtime

### Recommendations

For developers working with Lia panels:
1. **Check Base Classes**: Many "missing" methods may actually be available through inheritance
2. **Custom Method Priority**: Lia panels often add enhanced functionality (like better styling, animations, etc.)
3. **Compatibility Testing**: Always test panel behavior rather than relying solely on method signatures

## Equivalency Table

### liaButton

**Equivalent to:** DButton

**Lia Panel Methods:** 12
**GMod Panel Methods:** 6
**Missing Methods:** 6

#### Missing Methods in Lia Panel:
- `DButton:SetConsoleCommand( string command,  string args = nil )`
- `DButton:SetDrawBorder( boolean draw )`
- `DButton:SetIcon( string img = nil )`
- `DButton:SetImage( string img = nil )`
- `DButton:SetMaterial( IMaterial img = nil )`
- `DButton:UpdateColours( table skin )`

---

### liaComboBox

**Equivalent to:** DComboBox

**Lia Panel Methods:** 26
**GMod Panel Methods:** 15
**Missing Methods:** 15

#### Missing Methods in Lia Panel:
- `DComboBox:AddChoice( "option A" )`
- `DComboBox:AddChoice( "option B" )`
- `DComboBox:AddChoice( "option C" )`
- `DComboBox:AddSpacer()`
- `DComboBox:CheckConVarChanges()`
- `DComboBox:ChooseOption( string value,  number index )`
- `DComboBox:ChooseOptionID( number index )`
- `DComboBox:Clear()`
- `DComboBox:CloseMenu()`
- `DComboBox:OpenMenu()`
- `DComboBox:SetPos( 5, 30 )`
- `DComboBox:SetSize( 100, 20 )`
- `DComboBox:SetSortItems( boolean sort )`
- `DComboBox:SetValue( "options" )`
- `DComboBox:SetValue( string value )`

---

### liaScrollPanel

**Equivalent to:** DScrollPanel

**Lia Panel Methods:** 1
**GMod Panel Methods:** 7
**Missing Methods:** 7

#### Missing Methods in Lia Panel:
- `DScrollPanel:AddItem( Panel pnl )`
- `DScrollPanel:Dock( FILL )`
- `DScrollPanel:PerformLayoutInternal()`
- `DScrollPanel:Rebuild()`
- `DScrollPanel:ScrollToChild( Panel panel )`
- `DScrollPanel:SetCanvas( Panel canvas )`
- `DScrollPanel:SetPadding( number padding )`

---

### liaNumSlider

**Equivalent to:** DSlider

**Lia Panel Methods:** 1
**GMod Panel Methods:** 19
**Missing Methods:** 19

#### Missing Methods in Lia Panel:
- `DSlider:ConVarXNumberThink()`
- `DSlider:ConVarYNumberThink()`
- `DSlider:OnValuesChangedInternal()`
- `DSlider:SetBackground( string path )`
- `DSlider:SetConVarX( string convar )`
- `DSlider:SetConVarY( string convar )`
- `DSlider:SetDragging( boolean dragging )`
- `DSlider:SetImage()`
- `DSlider:SetImageColor()`
- `DSlider:SetLockX( number lockX = nil )`
- `DSlider:SetLockY( number lockY = nil )`
- `DSlider:SetNotchColor( Color clr )`
- `DSlider:SetNotches( number notches )`
- `DSlider:SetNumSlider( any slider )`
- `DSlider:SetSlideX( number x )`
- `DSlider:SetSlideY( number y )`
- `DSlider:SetTrapInside( boolean trap )`
- `Slider:SetPos( 50, 50 )`
- `Slider:SetSize( 100, 20 )`

---

### liaDListView

**Equivalent to:** DListView

**Lia Panel Methods:** 1
**GMod Panel Methods:** 15
**Missing Methods:** 15

#### Missing Methods in Lia Panel:
- `DListView:ClearSelection()`
- `DListView:DisableScrollbar()`
- `DListView:FixColumnsLayout()`
- `DListView:OnClickLine( Panel line,  boolean isSelected )`
- `DListView:OnRequestResize( Panel column,  number size )`
- `DListView:RemoveLine( number line )`
- `DListView:SelectFirstItem()`
- `DListView:SelectItem( Panel Line )`
- `DListView:SetDataHeight( number height )`
- `DListView:SetDirty( boolean isDirty )`
- `DListView:SetHeaderHeight( number height )`
- `DListView:SetHideHeaders( boolean hide )`
- `DListView:SetMultiSelect( boolean allowMultiSelect )`
- `DListView:SetSortable( boolean isSortable )`
- `DListView:SortByColumns( number column1 = nil,  boolean descrending1 = false,  number column2 = nil,  boolean descrending2 = false,  number column3 = nil,  boolean descrending3 = false,  number column4 = nil,  boolean descrending4 = false )`

---

### liaChatBox

**Equivalent to:** DPanel

**Lia Panel Methods:** 1
**GMod Panel Methods:** 9
**Missing Methods:** 9

#### Missing Methods in Lia Panel:
- `DPanel:SetBackgroundColor( table color )`
- `DPanel:SetDisabled( boolean disabled )`
- `DPanel:SetDrawBackground( boolean draw )`
- `DPanel:SetIsMenu( boolean isMenu )`
- `DPanel:SetPaintBackground( boolean paint )`
- `DPanel:SetPos( 10, 30 )`
- `DPanel:SetSize( 200, 200 )`
- `DPanel:SetTabbingDisabled( boolean draw )`
- `DPanel:UpdateColours()`

---

### liaModelPanel

**Equivalent to:** DModelPanel

**Lia Panel Methods:** 1
**GMod Panel Methods:** 10
**Missing Methods:** 10

#### Missing Methods in Lia Panel:
- `DModelPanel:DrawModel()`
- `DModelPanel:RunAnimation()`
- `DModelPanel:SetAmbientLight( table color )`
- `DModelPanel:SetAnimSpeed( number animSpeed )`
- `DModelPanel:SetAnimated( boolean animated )`
- `DModelPanel:SetColor( table color )`
- `DModelPanel:SetEntity( Entity ent )`
- `DModelPanel:SetLookAng( Angle ang )`
- `DModelPanel:SetLookAt( Vector pos )`
- `DModelPanel:SetModel( string model )`

---

### liaItemIcon

**Equivalent to:** SpawnIcon

**Lia Panel Methods:** 1
**GMod Panel Methods:** 4
**Missing Methods:** 4

#### Missing Methods in Lia Panel:
- `SpawnIcon:OpenMenu()`
- `SpawnIcon:SetBodyGroup( number bodyGroupId,  number activeSubModelId )`
- `SpawnIcon:SetModelName( string mdl )`
- `SpawnIcon:SetSkinID( number skin )`

---

### liaSpawnIcon

**Equivalent to:** DModelPanel

**Lia Panel Methods:** 1
**GMod Panel Methods:** 10
**Missing Methods:** 10

#### Missing Methods in Lia Panel:
- `DModelPanel:DrawModel()`
- `DModelPanel:RunAnimation()`
- `DModelPanel:SetAmbientLight( table color )`
- `DModelPanel:SetAnimSpeed( number animSpeed )`
- `DModelPanel:SetAnimated( boolean animated )`
- `DModelPanel:SetColor( table color )`
- `DModelPanel:SetEntity( Entity ent )`
- `DModelPanel:SetLookAng( Angle ang )`
- `DModelPanel:SetLookAt( Vector pos )`
- `DModelPanel:SetModel( string model )`

---

### liaSheet

**Equivalent to:** DPanel

**Lia Panel Methods:** 1
**GMod Panel Methods:** 9
**Missing Methods:** 9

#### Missing Methods in Lia Panel:
- `DPanel:SetBackgroundColor( table color )`
- `DPanel:SetDisabled( boolean disabled )`
- `DPanel:SetDrawBackground( boolean draw )`
- `DPanel:SetIsMenu( boolean isMenu )`
- `DPanel:SetPaintBackground( boolean paint )`
- `DPanel:SetPos( 10, 30 )`
- `DPanel:SetSize( 200, 200 )`
- `DPanel:SetTabbingDisabled( boolean draw )`
- `DPanel:UpdateColours()`

---

### liaScoreboard

**Equivalent to:** EditablePanel

**Lia Panel Methods:** 1
**GMod Panel Methods:** 0
**Missing Methods:** 0

✅ **All GMod methods are implemented in Lia panel!**

---

### liaRoster

**Equivalent to:** EditablePanel

**Lia Panel Methods:** 1
**GMod Panel Methods:** 0
**Missing Methods:** 0

✅ **All GMod methods are implemented in Lia panel!**

---

### liaPrivilegeRow

**Equivalent to:** DPanel

**Lia Panel Methods:** 1
**GMod Panel Methods:** 9
**Missing Methods:** 9

#### Missing Methods in Lia Panel:
- `DPanel:SetBackgroundColor( table color )`
- `DPanel:SetDisabled( boolean disabled )`
- `DPanel:SetDrawBackground( boolean draw )`
- `DPanel:SetIsMenu( boolean isMenu )`
- `DPanel:SetPaintBackground( boolean paint )`
- `DPanel:SetPos( 10, 30 )`
- `DPanel:SetSize( 200, 200 )`
- `DPanel:SetTabbingDisabled( boolean draw )`
- `DPanel:UpdateColours()`

---

### liaTabButton

**Equivalent to:** DPanel

**Lia Panel Methods:** 1
**GMod Panel Methods:** 9
**Missing Methods:** 9

#### Missing Methods in Lia Panel:
- `DPanel:SetBackgroundColor( table color )`
- `DPanel:SetDisabled( boolean disabled )`
- `DPanel:SetDrawBackground( boolean draw )`
- `DPanel:SetIsMenu( boolean isMenu )`
- `DPanel:SetPaintBackground( boolean paint )`
- `DPanel:SetPos( 10, 30 )`
- `DPanel:SetSize( 200, 200 )`
- `DPanel:SetTabbingDisabled( boolean draw )`
- `DPanel:UpdateColours()`

---

### liaItemMenu

**Equivalent to:** EditablePanel

**Lia Panel Methods:** 1
**GMod Panel Methods:** 0
**Missing Methods:** 0

✅ **All GMod methods are implemented in Lia panel!**

---

### liaItemList

**Equivalent to:** DFrame

**Lia Panel Methods:** 1
**GMod Panel Methods:** 18
**Missing Methods:** 18

#### Missing Methods in Lia Panel:
- `DFrame:Center()`
- `DFrame:Close()`
- `DFrame:MakePopup()`
- `DFrame:SetBackgroundBlur( boolean blur )`
- `DFrame:SetDeleteOnClose( boolean shouldDelete )`
- `DFrame:SetDraggable( boolean draggable )`
- `DFrame:SetIcon( string path )`
- `DFrame:SetIsMenu( boolean isMenu )`
- `DFrame:SetMinHeight( number minH )`
- `DFrame:SetMinWidth( number minW )`
- `DFrame:SetPaintShadow( boolean shouldPaint )`
- `DFrame:SetPos(100, 100)`
- `DFrame:SetScreenLock( boolean lock )`
- `DFrame:SetSizable( boolean sizeable )`
- `DFrame:SetSize(300, 200)`
- `DFrame:SetTitle( string title )`
- `DFrame:SetTitle("Derma Frame")`
- `DFrame:ShowCloseButton( boolean show )`

---

### liaItemSelector

**Equivalent to:** DFrame

**Lia Panel Methods:** 1
**GMod Panel Methods:** 18
**Missing Methods:** 18

#### Missing Methods in Lia Panel:
- `DFrame:Center()`
- `DFrame:Close()`
- `DFrame:MakePopup()`
- `DFrame:SetBackgroundBlur( boolean blur )`
- `DFrame:SetDeleteOnClose( boolean shouldDelete )`
- `DFrame:SetDraggable( boolean draggable )`
- `DFrame:SetIcon( string path )`
- `DFrame:SetIsMenu( boolean isMenu )`
- `DFrame:SetMinHeight( number minH )`
- `DFrame:SetMinWidth( number minW )`
- `DFrame:SetPaintShadow( boolean shouldPaint )`
- `DFrame:SetPos(100, 100)`
- `DFrame:SetScreenLock( boolean lock )`
- `DFrame:SetSizable( boolean sizeable )`
- `DFrame:SetSize(300, 200)`
- `DFrame:SetTitle( string title )`
- `DFrame:SetTitle("Derma Frame")`
- `DFrame:ShowCloseButton( boolean show )`

---

### liaDoorMenu

**Equivalent to:** DFrame

**Lia Panel Methods:** 1
**GMod Panel Methods:** 18
**Missing Methods:** 18

#### Missing Methods in Lia Panel:
- `DFrame:Center()`
- `DFrame:Close()`
- `DFrame:MakePopup()`
- `DFrame:SetBackgroundBlur( boolean blur )`
- `DFrame:SetDeleteOnClose( boolean shouldDelete )`
- `DFrame:SetDraggable( boolean draggable )`
- `DFrame:SetIcon( string path )`
- `DFrame:SetIsMenu( boolean isMenu )`
- `DFrame:SetMinHeight( number minH )`
- `DFrame:SetMinWidth( number minW )`
- `DFrame:SetPaintShadow( boolean shouldPaint )`
- `DFrame:SetPos(100, 100)`
- `DFrame:SetScreenLock( boolean lock )`
- `DFrame:SetSizable( boolean sizeable )`
- `DFrame:SetSize(300, 200)`
- `DFrame:SetTitle( string title )`
- `DFrame:SetTitle("Derma Frame")`
- `DFrame:ShowCloseButton( boolean show )`

---

### liaNotice

**Equivalent to:** DPanel

**Lia Panel Methods:** 1
**GMod Panel Methods:** 9
**Missing Methods:** 9

#### Missing Methods in Lia Panel:
- `DPanel:SetBackgroundColor( table color )`
- `DPanel:SetDisabled( boolean disabled )`
- `DPanel:SetDrawBackground( boolean draw )`
- `DPanel:SetIsMenu( boolean isMenu )`
- `DPanel:SetPaintBackground( boolean paint )`
- `DPanel:SetPos( 10, 30 )`
- `DPanel:SetSize( 200, 200 )`
- `DPanel:SetTabbingDisabled( boolean draw )`
- `DPanel:UpdateColours()`

---

### liaLoadingFailure

**Equivalent to:** DFrame

**Lia Panel Methods:** 1
**GMod Panel Methods:** 18
**Missing Methods:** 18

#### Missing Methods in Lia Panel:
- `DFrame:Center()`
- `DFrame:Close()`
- `DFrame:MakePopup()`
- `DFrame:SetBackgroundBlur( boolean blur )`
- `DFrame:SetDeleteOnClose( boolean shouldDelete )`
- `DFrame:SetDraggable( boolean draggable )`
- `DFrame:SetIcon( string path )`
- `DFrame:SetIsMenu( boolean isMenu )`
- `DFrame:SetMinHeight( number minH )`
- `DFrame:SetMinWidth( number minW )`
- `DFrame:SetPaintShadow( boolean shouldPaint )`
- `DFrame:SetPos(100, 100)`
- `DFrame:SetScreenLock( boolean lock )`
- `DFrame:SetSizable( boolean sizeable )`
- `DFrame:SetSize(300, 200)`
- `DFrame:SetTitle( string title )`
- `DFrame:SetTitle("Derma Frame")`
- `DFrame:ShowCloseButton( boolean show )`

---

### liaHorizontalScroll

**Equivalent to:** DPanel

**Lia Panel Methods:** 1
**GMod Panel Methods:** 9
**Missing Methods:** 9

#### Missing Methods in Lia Panel:
- `DPanel:SetBackgroundColor( table color )`
- `DPanel:SetDisabled( boolean disabled )`
- `DPanel:SetDrawBackground( boolean draw )`
- `DPanel:SetIsMenu( boolean isMenu )`
- `DPanel:SetPaintBackground( boolean paint )`
- `DPanel:SetPos( 10, 30 )`
- `DPanel:SetSize( 200, 200 )`
- `DPanel:SetTabbingDisabled( boolean draw )`
- `DPanel:UpdateColours()`

---

### liaHorizontalScrollBar

**Equivalent to:** DVScrollBar

**Lia Panel Methods:** 1
**GMod Panel Methods:** 5
**Missing Methods:** 5

#### Missing Methods in Lia Panel:
- `DVScrollBar:AnimateTo( number scroll,  number length,  number delay = 0,  number ease = -1 )`
- `DVScrollBar:Grip()`
- `DVScrollBar:SetHideButtons( boolean hide )`
- `DVScrollBar:SetScroll( number scroll )`
- `DVScrollBar:SetUp( number barSize,  number canvasSize )`

---

### liaSimpleCheckbox

**Equivalent to:** DCheckBox

**Lia Panel Methods:** 1
**GMod Panel Methods:** 4
**Missing Methods:** 4

#### Missing Methods in Lia Panel:
- `DCheckBox:DoClick()`
- `DCheckBox:SetChecked( boolean checked )`
- `DCheckBox:SetValue( boolean checked )`
- `DCheckBox:Toggle()`

---

### liaCharacterCreateStep

**Equivalent to:** DPanel

**Lia Panel Methods:** 1
**GMod Panel Methods:** 9
**Missing Methods:** 9

#### Missing Methods in Lia Panel:
- `DPanel:SetBackgroundColor( table color )`
- `DPanel:SetDisabled( boolean disabled )`
- `DPanel:SetDrawBackground( boolean draw )`
- `DPanel:SetIsMenu( boolean isMenu )`
- `DPanel:SetPaintBackground( boolean paint )`
- `DPanel:SetPos( 10, 30 )`
- `DPanel:SetSize( 200, 200 )`
- `DPanel:SetTabbingDisabled( boolean draw )`
- `DPanel:UpdateColours()`

---

### liaQuick

**Equivalent to:** EditablePanel

**Lia Panel Methods:** 1
**GMod Panel Methods:** 0
**Missing Methods:** 0

✅ **All GMod methods are implemented in Lia panel!**

---

### liaDProgressBar

**Equivalent to:** DProgress

**Lia Panel Methods:** 1
**GMod Panel Methods:** 4
**Missing Methods:** 4

#### Missing Methods in Lia Panel:
- `DProgress:SetFraction( 0.75 )`
- `DProgress:SetFraction( number fraction )`
- `DProgress:SetPos( 10, 30 )`
- `DProgress:SetSize( 200, 20 )`

---

### liaHugeButton

**Equivalent to:** DButton

**Lia Panel Methods:** 1
**GMod Panel Methods:** 6
**Missing Methods:** 6

#### Missing Methods in Lia Panel:
- `DButton:SetConsoleCommand( string command,  string args = nil )`
- `DButton:SetDrawBorder( boolean draw )`
- `DButton:SetIcon( string img = nil )`
- `DButton:SetImage( string img = nil )`
- `DButton:SetMaterial( IMaterial img = nil )`
- `DButton:UpdateColours( table skin )`

---

### liaBigButton

**Equivalent to:** DButton

**Lia Panel Methods:** 1
**GMod Panel Methods:** 6
**Missing Methods:** 6

#### Missing Methods in Lia Panel:
- `DButton:SetConsoleCommand( string command,  string args = nil )`
- `DButton:SetDrawBorder( boolean draw )`
- `DButton:SetIcon( string img = nil )`
- `DButton:SetImage( string img = nil )`
- `DButton:SetMaterial( IMaterial img = nil )`
- `DButton:UpdateColours( table skin )`

---

### liaMediumButton

**Equivalent to:** DButton

**Lia Panel Methods:** 1
**GMod Panel Methods:** 6
**Missing Methods:** 6

#### Missing Methods in Lia Panel:
- `DButton:SetConsoleCommand( string command,  string args = nil )`
- `DButton:SetDrawBorder( boolean draw )`
- `DButton:SetIcon( string img = nil )`
- `DButton:SetImage( string img = nil )`
- `DButton:SetMaterial( IMaterial img = nil )`
- `DButton:UpdateColours( table skin )`

---

### liaSmallButton

**Equivalent to:** DButton

**Lia Panel Methods:** 1
**GMod Panel Methods:** 6
**Missing Methods:** 6

#### Missing Methods in Lia Panel:
- `DButton:SetConsoleCommand( string command,  string args = nil )`
- `DButton:SetDrawBorder( boolean draw )`
- `DButton:SetIcon( string img = nil )`
- `DButton:SetImage( string img = nil )`
- `DButton:SetMaterial( IMaterial img = nil )`
- `DButton:UpdateColours( table skin )`

---

### liaMiniButton

**Equivalent to:** DButton

**Lia Panel Methods:** 1
**GMod Panel Methods:** 6
**Missing Methods:** 6

#### Missing Methods in Lia Panel:
- `DButton:SetConsoleCommand( string command,  string args = nil )`
- `DButton:SetDrawBorder( boolean draw )`
- `DButton:SetIcon( string img = nil )`
- `DButton:SetImage( string img = nil )`
- `DButton:SetMaterial( IMaterial img = nil )`
- `DButton:UpdateColours( table skin )`

---

### liaNoBGButton

**Equivalent to:** DButton

**Lia Panel Methods:** 1
**GMod Panel Methods:** 6
**Missing Methods:** 6

#### Missing Methods in Lia Panel:
- `DButton:SetConsoleCommand( string command,  string args = nil )`
- `DButton:SetDrawBorder( boolean draw )`
- `DButton:SetIcon( string img = nil )`
- `DButton:SetImage( string img = nil )`
- `DButton:SetMaterial( IMaterial img = nil )`
- `DButton:UpdateColours( table skin )`

---

### liaUserGroupButton

**Equivalent to:** DButton

**Lia Panel Methods:** 1
**GMod Panel Methods:** 6
**Missing Methods:** 6

#### Missing Methods in Lia Panel:
- `DButton:SetConsoleCommand( string command,  string args = nil )`
- `DButton:SetDrawBorder( boolean draw )`
- `DButton:SetIcon( string img = nil )`
- `DButton:SetImage( string img = nil )`
- `DButton:SetMaterial( IMaterial img = nil )`
- `DButton:UpdateColours( table skin )`

---

### liaUserGroupList

**Equivalent to:** DPanel

**Lia Panel Methods:** 1
**GMod Panel Methods:** 9
**Missing Methods:** 9

#### Missing Methods in Lia Panel:
- `DPanel:SetBackgroundColor( table color )`
- `DPanel:SetDisabled( boolean disabled )`
- `DPanel:SetDrawBackground( boolean draw )`
- `DPanel:SetIsMenu( boolean isMenu )`
- `DPanel:SetPaintBackground( boolean paint )`
- `DPanel:SetPos( 10, 30 )`
- `DPanel:SetSize( 200, 200 )`
- `DPanel:SetTabbingDisabled( boolean draw )`
- `DPanel:UpdateColours()`

---

### liaCharacterAttribs

**Equivalent to:** DPanel

**Lia Panel Methods:** 1
**GMod Panel Methods:** 9
**Missing Methods:** 9

#### Missing Methods in Lia Panel:
- `DPanel:SetBackgroundColor( table color )`
- `DPanel:SetDisabled( boolean disabled )`
- `DPanel:SetDrawBackground( boolean draw )`
- `DPanel:SetIsMenu( boolean isMenu )`
- `DPanel:SetPaintBackground( boolean paint )`
- `DPanel:SetPos( 10, 30 )`
- `DPanel:SetSize( 200, 200 )`
- `DPanel:SetTabbingDisabled( boolean draw )`
- `DPanel:UpdateColours()`

---

### liaCharacterAttribsRow

**Equivalent to:** DPanel

**Lia Panel Methods:** 1
**GMod Panel Methods:** 9
**Missing Methods:** 9

#### Missing Methods in Lia Panel:
- `DPanel:SetBackgroundColor( table color )`
- `DPanel:SetDisabled( boolean disabled )`
- `DPanel:SetDrawBackground( boolean draw )`
- `DPanel:SetIsMenu( boolean isMenu )`
- `DPanel:SetPaintBackground( boolean paint )`
- `DPanel:SetPos( 10, 30 )`
- `DPanel:SetSize( 200, 200 )`
- `DPanel:SetTabbingDisabled( boolean draw )`
- `DPanel:UpdateColours()`

---


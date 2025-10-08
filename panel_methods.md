# ContentHeader

ContentHeader:OpenMenu( string style,  string hookname = "PopulateContent" )
Creates a DermaMenu and adds a delete option before opening the menu

ContentHeader:ToTable( table bigtable )

# ContentIcon

ContentIcon:OpenMenu()
A hook for override, by default does nothing. Called when user right clicks on the content icon, you are supposed to open a DermaMenu here with additional options.

ContentIcon:SetAdminOnly( boolean adminOnly )
An AccessorFunc that sets whether the content item is admin only. This makes the icon to display a admin icon in the top left corner of the icon.

ContentIcon:SetColor( table clr )
An AccessorFunc that sets the color for the content icon. Currently is not used by the content icon panel.

ContentIcon:SetContentType( string type )
An AccessorFunc that sets the content type used to save and restore the content icon in a spawnlist.

ContentIcon:SetMaterial( string path )
Sets the material to be displayed as the content icon.

ContentIcon:SetName( string name )
Sets the tool tip and the "nice" name to be displayed by the content icon.

ContentIcon:SetNPCWeapon( table weapons )
An AccessorFunc that sets a table of weapon classes for the content icon with "NPC" content type to be randomly chosen from when user tries to spawn the NPC.

ContentIcon:SetSpawnName( string name )
An AccessorFunc that sets the internal "name" for the content icon, usually a class name for an entity.

# ContentSidebar

ContentSidebar:CreateSaveNotification( string style,  string hookname = "PopulateContent" )
Creates a Save Notification which will be shown when SANDBOX:SpawnlistContentChanged has been called.

ContentSidebar:EnableModify()
Internally calls ContentSidebar:EnableSearch, ContentSidebar:CreateSaveNotification and creates a ContentSidebarToolbox which is accessible under ContentSidebar.Toolbox. Call the Hook SANDBOX:OpenToolbox to open the created Toolbox

ContentSidebar:EnableSearch( string style,  string hookname = "PopulateContent" )
Creates a search bar which will be displayed over the Nodes.

ContentSidebar:Dock(FILL)

ContentSidebar:CreateSaveNotification()

# ContextBase

ContextBase:ControlValues( table contextData )
Called by spawnmenu functions (when creating a context menu) to fill this control with data.

ContextBase:SetConVar( string cvar )
Sets the ConVar for the panel to change/handle.

ContextBase:TestForChanges()
You should override this function and use it to check whether your convar value changed.

# ControlPanel

ControlPanel:AddPanel( Panel panel )
Adds an item by calling DForm:AddItem.

ControlPanel:ClearControls()
Deprecated: We advise against using this. It may be changed or removed in a future update.

ControlPanel:ControlValues( table data )
Sets control values of the control panel.

ControlPanel:FillViaFunction( function func )
Calls the given function with this panel as the only argument. Used by the spawnmenu to populate the control panel.

# ControlPresets

ControlPresets:AddConVar( string convar )
Adds a convar to be managed by this control.

ControlPresets:AddOption( string strName,  any data )
Adds option to the DComboBox subelement with DComboBox:AddChoice then adds it to the options subtable

ControlPresets:Clear()
Runs Panel:Clear on the Internal DComboBox

ControlPresets:OnSelect( number index,  any value,  table data )
Checks if Data is valid then uses pairs to iterate over the data parameter and run each entry using RunConsoleCommand

ControlPresets:QuickSaveInternal( string text )
ControlPresets:QuickSavePreset() ControlPresets:ReloadPresets() ControlPresets:SetLabel( string name )Set the name label text.

ControlPresets:SetOptions( table Options )
Uses table.Merge to combine the provided table into the Options subtable

ControlPresets:SetPreset( string strName )
ControlPresets:Update()Alias of ControlPresets:ReloadPresets

# CtrlNumPad

CtrlNumPad:SetConVar1( string cvar )
The name of the convar that will store the key code for player selected key of the left key binder.

CtrlNumPad:SetConVar2( string cvar )
If set and label2 is set, the name of the convar that will store the key code for player selected key of the right key binder.

CtrlNumPad:SetLabel1( string txt )
The label for the left key binder.

CtrlNumPad:SetLabel2( string txt )
If set and convar2 is set, the label for the right key binder.

# DAdjustableModelPanel

DAdjustableModelPanel:CaptureMouse()
Internal: This is used internally - although you're able to use it you probably shouldn't.

DAdjustableModelPanel:FirstPersonControls()
Internal: This is used internally - although you're able to use it you probably shouldn't.

DAdjustableModelPanel:SetFirstPerson( boolean enable )
Enables mouse and keyboard-based adjustment of the perspective.

DAdjustableModelPanel:SetMovementScale( number )
Sets the movement speed multiplier. Currently this only affects first person camera controls.

# DAlphaBar

DAlphaBar:SetBarColor( table clr )
Sets the base color of the alpha bar. This is the color for which the alpha channel is being modified. An AccessorFunc

DAlphaBar:SetValue( number alpha )
Sets the alpha value or the alpha bar. An AccessorFunc

DAlphaBar:SetPos( 20, 30 )

DAlphaBar:SetSize( 25, 125 )

DAlphaBar:SetValue( 0.25 )

# DBinder

DBinder:SetSelectedNumber( number keyCode )
Sets the current key bound by the DBinder, and updates the button's text as well as the ConVar.

DBinder:SetValue( number keyCode )
Alias of DBinder:SetSelectedNumber.

DBinder:UpdateText()
Internal: This is used internally - although you're able to use it you probably shouldn't.

# DBubbleContainer

DBubbleContainer:GetBackgroundColor()
Returns Background Color, See DBubbleContainer:SetBackgroundColor

DBubbleContainer:OpenForPos( number x,  number y,  number w,  number h )
Sets the speech bubble position and size along with the dialog point position.

DBubbleContainer:SetBackgroundColor( Color color )
Sets Background Color, See Also DBubbleContainer:GetBackgroundColor

DBubbleContainer:OpenForPos(50, 0, 280, 150)
Example

# DButton

DButton:SetConsoleCommand( string command,  string args = nil )
Sets a console command to be called when the button is clicked.

DButton:SetDrawBorder( boolean draw )
Deprecated: We advise against using this. It may be changed or removed in a future update.

DButton:SetIcon( string img = nil )
Sets an image to be displayed as the button's background. Alias of DButton:SetImage

DButton:SetImage( string img = nil )
Sets an image to be displayed as the button's background.

DButton:SetMaterial( IMaterial img = nil )
Sets an image to be displayed as the button's background.

DButton:UpdateColours( table skin )
A hook called from within DLabel's PANEL:ApplySchemeSettings to determine the color of the text on display.

# DCategoryList

DCategoryList:AddItem( Panel element )
Adds an element to the list.

DCategoryList:UnselectAll()
Calls Panel:UnselectAll on all child elements, if they have it.

# DCheckBox

DCheckBox:DoClick()
Calls DCheckBox:Toggle

DCheckBox:SetChecked( boolean checked )
An AccessorFunc that sets the checked state of the checkbox. Does not call the checkbox's DCheckBox:OnChange and Panel:ConVarChanged methods, unlike DCheckBox:SetValue.

DCheckBox:SetValue( boolean checked )
Sets the checked state of the checkbox, and calls the checkbox's DCheckBox:OnChange and Panel:ConVarChanged methods.

DCheckBox:Toggle()
Toggles the checked state of the checkbox, and calls the checkbox's DCheckBox:OnChange and Panel:ConVarChanged methods. DCheckBox:DoClick is an alias of this function.

# DCheckBoxLabel

DCheckBoxLabel:SetBright( boolean bright )
Sets the color of the DCheckBoxLabel's text to the bright text color defined in the skin.

DCheckBoxLabel:SetChecked( boolean checked )
Sets the checked state of the checkbox. Does not call DCheckBoxLabel:OnChange or Panel:ConVarChanged, unlike DCheckBoxLabel:SetValue.

DCheckBoxLabel:SetConVar( string convar )
Sets the console variable to be set when the checked state of the DCheckBoxLabel changes.

DCheckBoxLabel:SetDark( boolean darkify )
Sets the text of the DCheckBoxLabel to be dark colored in accordance with the currently active Derma skin.

DCheckBoxLabel:SetFont( string font )
Sets the font of the text part of the DCheckBoxLabel.

DCheckBoxLabel:SetIndent( number ident )
An AccessorFunc that sets the indentation of the element on the X axis.

DCheckBoxLabel:SetTextColor( table color )
Sets the text color for the DCheckBoxLabel.

DCheckBoxLabel:SetValue( boolean checked )
Sets the checked state of the checkbox, and calls DCheckBoxLabel:OnChange and the checkbox's Panel:ConVarChanged methods.

DCheckBoxLabel:SizeToContents()
Sizes the panel to the size of the internal DLabel and DButton

DCheckBoxLabel:Toggle()
Toggles the checked state of the DCheckBoxLabel.

# DCollapsibleCategory

DCollapsibleCategory:AnimSlide( table anim,  number delta,  table data )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DCollapsibleCategory:DoExpansion( boolean expand )
Forces the category to open or collapse

DCollapsibleCategory:SetAnimTime( number time )
Sets the time in seconds it takes to expand the DCollapsibleCategory

DCollapsibleCategory:SetContents( Panel pnl )
Sets the contents of the DCollapsibleCategory.

DCollapsibleCategory:SetDrawBackground( boolean draw )
Deprecated: We advise against using this. It may be changed or removed in a future update.

DCollapsibleCategory:SetExpanded( boolean expanded = true )
Sets whether the DCollapsibleCategory is expanded or not upon opening the container.

DCollapsibleCategory:SetHeaderHeight( number height )
Sets the header height of the DCollapsibleCategory.

DCollapsibleCategory:SetLabel( string label )
Sets the name of the DCollapsibleCategory.

DCollapsibleCategory:SetList( Panel pnl )
Used internally by DCategoryList when it creates a DCollapsibleCategory during DCategoryList:Add.

DCollapsibleCategory:SetPadding( number padding )
Deprecated: We advise against using this. It may be changed or removed in a future update.

DCollapsibleCategory:SetPaintBackground( boolean paint )
Sets whether or not the background should be painted.

DCollapsibleCategory:SetStartHeight( number height )
Deprecated: We advise against using this. It may be changed or removed in a future update.

DCollapsibleCategory:Toggle()
Toggles the expanded state of the DCollapsibleCategory.

DCollapsibleCategory:UpdateAltLines()
Internal: This is used internally - although you're able to use it you probably shouldn't.

# DColorButton

DColorButton:SetColor( table color,  boolean noTooltip = false )
Sets the color of the DColorButton.

DColorButton:SetDrawBorder( boolean draw )
Deprecated: We advise against using this. It may be changed or removed in a future update.

DColorButton:SetID( number id )
An AccessorFunc that is used internally by DColorPalette to detect which button is which.

DColorButton:SetPos( 1, 28 )

DColorButton:SetSize( 100, 30 )

DColorButton:Paint( 100, 30 )

DColorButton:SetText( "DColorButton" )

DColorButton:SetColor( Color( 0, 110, 160 )
)

# DColorCombo

DColorCombo:BuildControls()
Internal: This is used internally - although you're able to use it you probably shouldn't.

DColorCombo:SetColor( table clr )
An AccessorFunc that returns the color of this panel. See also DColorCombo:GetColor

# DColorCube

DColorCube:ResetToDefaultValue()
Sets the color to whatever DColorCube:GetDefaultColor returns

DColorCube:SetBaseRGB( table color )
An AccessorFunc that sets the base color and the color used to draw the color cube panel itself.

DColorCube:SetDefaultColor( table )
An AccessorFunc that sets the color cube's default color. This value will be used to reset to on middle mouse click of the color cube's draggable slider.

DColorCube:SetHue( number hue )
Deprecated: We advise against using this. It may be changed or removed in a future update.

DColorCube:SetRGB( table clr )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DColorCube:UpdateColor( number x = nil,  number y = nil )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DColorCube:SetPos( 50, 50 )

DColorCube:SetSize( 200, 200 )

DColorCube:SetBaseRGB( Color( 0, 255, 0 )
)Example

# DColorMixer

DColorMixer:ConVarThink()
Internal: This is used internally - although you're able to use it you probably shouldn't. DColorMixer:DoConVarThink( string cvar )Internal: This is used internally - although you're able to use it you probably shouldn't.boolean  DColorMixer:GetAlphaBar()An AccessorFunc that returns true if alpha bar is shown, false if not.

DColorMixer:SetAlphaBar( boolean show )
An AccessorFunc that show/hide the alpha bar in DColorMixer

DColorMixer:SetBaseColor( table clr )
Sets the base color of the DColorCube part of the DColorMixer.

DColorMixer:SetColor( table color )
An AccessorFunc that sets the color of the DColorMixer. See also DColorMixer:GetColor

DColorMixer:SetConVarA( string convar )
An AccessorFunc that sets the ConVar name for the alpha channel of the color.

DColorMixer:SetConVarB( string convar )
An AccessorFunc that sets the ConVar name for the blue channel of the color.

DColorMixer:SetConVarG( string convar )
An AccessorFunc that sets the ConVar name for the green channel of the color.

DColorMixer:SetConVarR( string convar )
An AccessorFunc that sets the ConVar name for the red channel of the color.

DColorMixer:SetLabel( string text = nil )
Sets the label's text to show.

DColorMixer:SetPalette( boolean enabled )
Show or hide the palette panel

DColorMixer:SetVector( Vector vec )
Sets the color of DColorMixer from a Vector. Alpha is not included.

DColorMixer:SetWangs( boolean show )
Show / Hide the colors indicators in DColorMixer

DColorMixer:UpdateColor( table clr )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DColorMixer:UpdateConVar( string cvar,  string part,  table clr )
Internal: This is used internally - although you're able to use it you probably shouldn't. DColorMixer:UpdateConVars( table clr )Internal: This is used internally - although you're able to use it you probably shouldn't. DColorMixer:UpdateDefaultColor()sets the default color of the element to the currently selected color

# DColorPalette

DColorPalette:DoClick( table clr,  Panel btn )
Deprecated: We advise against using this. It may be changed or removed in a future update.

DColorPalette:NetworkColorChange()
Internal: This is used internally - although you're able to use it you probably shouldn't.

DColorPalette:OnRightClickButton( Panel pnl )
Called when a palette button has been pressed. For Override

DColorPalette:Reset()
Resets this entire color palette to a default preset one, without saving.

DColorPalette:ResetSavedColors()
Resets this entire color palette to a default preset one and saves the changes.

DColorPalette:SaveColor( Panel btn,  table clr )
Saves the color of given button across sessions.

DColorPalette:SetButtonSize( number size )
Sets the size of each palette button.

DColorPalette:SetColor( table clr )
Deprecated: We advise against using this. It may be changed or removed in a future update.

DColorPalette:SetColorButtons( table tab )
Clears the palette and adds new buttons with given colors.

DColorPalette:SetConVarA( string convar )
An AccessorFunc that sets the ConVar name for the alpha channel of the color.

DColorPalette:SetConVarB( string convar )
An AccessorFunc that sets the ConVar name for the blue channel of the color.

DColorPalette:SetConVarG( string convar )
An AccessorFunc that sets the ConVar name for the green channel of the color.

DColorPalette:SetConVarR( string convar )
An AccessorFunc that sets the ConVar name for the red channel of the color.

DColorPalette:SetNumRows( number rows )
Roughly sets the number of colors that can be picked by the user. If the DColorPalette is exactly 6 rows tall, this function will set the number of colors shown per row in the palette. This is an AccessorFunc

DColorPalette:UpdateConVars( table clr )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DColorPalette:SetPos( 5, 50 )

DColorPalette:SetSize( 160, 50 )

# DColumnSheet

DColumnSheet:SetActiveButton( Panel active )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DColumnSheet:UseButtonOnlyStyle()
Makes the tabs/buttons show only the image and no text.

# DComboBox

DComboBox:AddSpacer()
Adds a spacer below the currently last item in the drop down. Recommended to use with DComboBox:SetSortItems set to false.

DComboBox:CheckConVarChanges()
Internal: This is used internally - although you're able to use it you probably shouldn't.

DComboBox:ChooseOption( string value,  number index )
Selects a combo box option by its index and changes the text displayed at the top of the combo box.

DComboBox:ChooseOptionID( number index )
Selects an option within a combo box based on its table index.

DComboBox:Clear()
Clears the combo box's text value, choices, and data values.

DComboBox:CloseMenu()
Closes the combo box menu. Called when the combo box is clicked while open.

DComboBox:OpenMenu()
Opens the combo box drop down menu. Called when the combo box is clicked.

DComboBox:SetSortItems( boolean sort )
An AccessorFunc that sets whether or not the items should be sorted alphabetically in the dropdown menu of the DComboBox. If set to false, items will appear in the order they were added by DComboBox:AddChoice calls.

DComboBox:SetValue( string value )
Sets the text shown in the combo box when the menu is not collapsed.

DComboBox:SetPos( 5, 30 )

DComboBox:SetSize( 100, 20 )

DComboBox:SetValue( "options" )

DComboBox:AddChoice( "option A" )

DComboBox:AddChoice( "option B" )

DComboBox:AddChoice( "option C" )

# DDragBase

DDragBase:DropAction_Copy( table drops,  boolean bDoDrop,  string command,  number y,  number x )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DDragBase:DropAction_Normal( table drops,  boolean bDoDrop,  string command,  number y,  number x )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DDragBase:DropAction_Simple( table drops,  boolean bDoDrop,  string command,  number y,  number x )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DDragBase:MakeDroppable( string name,  boolean allowCopy )
Makes the panel a receiver for any droppable panel with the same DnD name. Internally calls Panel:Receiver.

DDragBase:SetDnD( string name )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DDragBase:SetDropPos( string pos = "5" )
Determines where you can drop stuff.

DDragBase:SetReadOnly( boolean name )
Sets whether this panel is read only or not for drag'n'drop purposes. If set to true, you can only copy from this panel, and cannot modify its contents. This is an AccessorFunc

DDragBase:SetUseLiveDrag( boolean newState )
Whether to use live drag'n'drop previews. This is an AccessorFunc

DDragBase:UpdateDropTarget( number drop,  Panel pnl )
Internal: This is used internally - although you're able to use it you probably shouldn't.

# DDrawer

DDrawer:Close()
Closes the DDrawer.

DDrawer:Open()
Opens the DDrawer.

DDrawer:SetOpenSize( number Value )
An AccessorFunc that sets the height of DDrawer

DDrawer:SetOpenTime( number value )
An AccessorFunc that sets the time (in seconds) for DDrawer to open.

DDrawer:Toggle()
Toggles the DDrawer.

Drawer:SetOpenSize( 75 )
-- Default OpenSize is 100

Drawer:SetOpenTime( 0.2 )
-- Default OpenTime is 0.3

Drawer:Open()
-- You can also use Drawer:Close()  and  Drawer:Toggle()

# DEntityProperties

DEntityProperties:EditVariable( string varname,  table editdata )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DEntityProperties:EntityLost()
Internal: This is used internally - although you're able to use it you probably shouldn't.

DEntityProperties:RebuildControls()
Internal: This is used internally - although you're able to use it you probably shouldn't.

DEntityProperties:SetEntity( Entity ent )
Sets the entity to be edited by this panel. The entity must support the Editable Entities system or nothing will happen.

# DExpandButton

DExpandButton:SetExpanded( boolean expanded )
Sets whether this DExpandButton should be expanded or not. Only changes appearance.

# DFileBrowser

DFileBrowser:Clear()
Clears the file tree and list, and resets all values.

DFileBrowser:SetBaseFolder( string baseDir )
An AccessorFunc that sets the root directory/folder of the file tree.

DFileBrowser:SetCurrentFolder( string currentDir )
An AccessorFunc that sets the directory/folder from which to display the file list.

DFileBrowser:SetFileTypes( string fileTypes = "." )
An AccessorFunc that sets the file type filter for the file list.

DFileBrowser:SetModels( boolean showModels = false )
Enables or disables the model viewer mode. In this mode, files are displayed as SpawnIcons instead of a list.

DFileBrowser:SetOpen( boolean open = false,  boolean useAnim = false )
An AccessorFunc that opens or closes the file tree.

DFileBrowser:SetPath( string path )
An AccessorFunc that sets the access path for the file tree. This is set to GAME by default.

DFileBrowser:SetSearch( string filter = "*" )
An AccessorFunc that sets the search filter for the file tree.

DFileBrowser:ShowFolder( string currentDir )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DFileBrowser:SortFiles( boolean descending = false )
Sorts the file list.

# DForm

DForm:AddItem( Panel left,  Panel right = nil )
Adds one or two items to the DForm.

DForm:Rebuild()
Deprecated: We advise against using this. It may be changed or removed in a future update.

DForm:SetAutoSize( boolean arg1 )
Deprecated: We advise against using this. It may be changed or removed in a future update.

DForm:SetName( string name )
Sets the title (header) name of the DForm. This is Label until set.

# DFrame

DFrame:Center()
Centers the frame relative to the whole screen and invalidates its layout. This overrides Panel:Center.

DFrame:Close()
Hides or removes the DFrame, and calls DFrame:OnClose.

DFrame:SetBackgroundBlur( boolean blur )
Indicate that the background elements won't be usable.

DFrame:SetDeleteOnClose( boolean shouldDelete )
Determines whether or not the DFrame is removed when it is closed with DFrame:Close.

DFrame:SetDraggable( boolean draggable )
Sets whether the frame should be draggable by the user. The DFrame can only be dragged from its title bar.

DFrame:SetIcon( string path )
Adds or removes an icon on the left of the DFrame's title.

DFrame:SetIsMenu( boolean isMenu )
Sets whether the frame is part of a derma menu or not.

DFrame:SetMinHeight( number minH )
Sets the minimum height the DFrame can be resized to by the user.

DFrame:SetMinWidth( number minW )
Sets the minimum width the DFrame can be resized to by the user.

DFrame:SetPaintShadow( boolean shouldPaint )
Sets whether or not the shadow effect bordering the DFrame should be drawn.

DFrame:SetScreenLock( boolean lock )
Sets whether the DFrame is restricted to the boundaries of the screen resolution.

DFrame:SetSizable( boolean sizeable )
Sets whether or not the DFrame can be resized by the user.

DFrame:SetTitle( string title )
Sets the title of the frame.

DFrame:ShowCloseButton( boolean show )
Determines whether the DFrame's control box (close, minimise and maximise buttons) is displayed.

DFrame:SetPos(100, 100)
-- Set the position to 100x by 100y.

DFrame:SetSize(300, 200)
-- Set the size to 300x by 200y.

DFrame:SetTitle("Derma Frame")
-- Set the title in the top left to "Derma Frame".

DFrame:MakePopup()
-- Makes your mouse be able to move around.

# DGrid

DGrid:AddItem( Panel item )
Adds a new item to the grid.

DGrid:RemoveItem( Panel item,  boolean bDontDelete = false )
Removes given panel from the DGrid:GetItems.

DGrid:SetCols( number cols )
Sets the number of columns this panel should have.

DGrid:SetColWide( number colWidth )
Sets the width of each column.

DGrid:SetRowHeight( number rowHeight )
Sets the height of each row.

DGrid:SortByMember( string key,  boolean desc = true )
Sorts the items in the grid. Does not visually update the grid, use Panel:InvalidateLayout for that.

# DHorizontalDivider

DHorizontalDivider:SetDividerWidth( number width )
Sets the width of the horizontal divider bar.

DHorizontalDivider:SetDragging( boolean dragonot )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DHorizontalDivider:SetHoldPos( number x )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DHorizontalDivider:SetLeft( Panel pnl )
Sets the left side content of the DHorizontalDivider.

DHorizontalDivider:SetLeftMin( number minWidth )
Sets the minimum width of the left side

DHorizontalDivider:SetLeftWidth( number width )
Sets the current/starting width of the left side.

DHorizontalDivider:SetMiddle( Panel middle )
Sets the middle content, over the draggable divider bar panel.

DHorizontalDivider:SetRight( Panel pnl )
Sets the right side content

DHorizontalDivider:SetRightMin( number minWidth )
Sets the minimum width of the right side

DHorizontalDivider:StartGrab()
Internal: This is used internally - although you're able to use it you probably shouldn't.Validate: TODO Document meExample

# DHorizontalScroller

DHorizontalScroller:AddPanel( Panel pnl )
Adds a panel to the DHorizontalScroller.

DHorizontalScroller:MakeDroppable( string name )
Same as DDragBase:MakeDroppable.

DHorizontalScroller:ScrollToChild( Panel target )
Scrolls the DHorizontalScroller to given child panel.

DHorizontalScroller:SetOverlap( number overlap )
Controls the spacing between elements of the horizontal scroller.

DHorizontalScroller:SetScroll( number scroll )
Sets the scroll amount, automatically clamping the value.

DHorizontalScroller:SetShowDropTargets( boolean newState )
Sets whether this panel should show drop targets.

DHorizontalScroller:SetUseLiveDrag( boolean newState )
Same as DDragBase:SetUseLiveDrag

DHorizontalScroller:Dock( FILL )

DHorizontalScroller:SetOverlap( -4 )

DHorizontalScroller:AddPanel( DImage )

DHorizontalScroller:Dock( FILL )

DHorizontalScroller:SetOverlap( -4 )

DHorizontalScroller:AddPanel( DImage )

# DHScrollBar

DHScrollBar:AnimateTo( number scroll,  number length,  number delay = 0,  number ease = -1 )
Smoothly scrolls to given level.

DHScrollBar:Grip()
Internal: This is used internally - although you're able to use it you probably shouldn't.

DHScrollBar:SetHideButtons( boolean hide )
Allows hiding the left and right buttons for better visual stylisation.

DHScrollBar:SetScroll( number scroll )
Sets the scroll level in pixels.

DHScrollBar:SetUp( number barSize,  number canvasSize )
Sets up the scrollbar for use.

# DHTML

DHTML:AddFunction( string library,  string name,  function callback )
Defines a Javascript function that when called will call a Lua callback.

DHTML:QueueJavascript( string js )
Runs/Executes a string as JavaScript code in a panel.

DHTML:SetScrollbars( boolean show )
Deprecated: We advise against using this. It may be changed or removed in a future update.

# DHTMLControls

DHTMLControls:FinishedLoading()
Internal: This is used internally - although you're able to use it you probably shouldn't. DHTMLControls:SetButtonColor( table clr )Sets the color of the navigation buttons.

DHTMLControls:SetHTML( Panel dhtml )
Sets the DHTML element to control with these DHTMLControls.

DHTMLControls:StartedLoading()
Internal: This is used internally - although you're able to use it you probably shouldn't. DHTMLControls:UpdateHistory( string url )Internal: This is used internally - although you're able to use it you probably shouldn't.

DHTMLControls:UpdateNavButtonStatus()
Internal: This is used internally - although you're able to use it you probably shouldn't.Example

# DIconBrowser

DIconBrowser:Fill()
Internal: This is used internally - although you're able to use it you probably shouldn't.

DIconBrowser:FilterByText( string text )
A simple unused search feature, hides all icons that do not contain given text in their file path.

DIconBrowser:OnChange()
Called when the selected icon was changed. Use DIconBrowser:GetSelectedIcon to get the selected icon's filepath.

DIconBrowser:OnChangeInternal()
Internal: This is used internally - although you're able to use it you probably shouldn't.

DIconBrowser:ScrollToSelected()
Scrolls the browser to the selected icon

DIconBrowser:SelectIcon( string icon )
Selects an icon from file path

DIconBrowser:SetManual( boolean manual )
Sets whether or not the browser should automatically fill itself with icons.

DIconBrowser:SetSelectedIcon( string str )
Internal: This is used internally - although you're able to use it you probably shouldn't.

IconBrowser:Dock(FILL)

# DIconLayout

DIconLayout:CopyContents( Panel from )
Copies the contents (Child elements) of another DIconLayout to itself.

DIconLayout:Layout()
Resets layout vars before calling Panel:InvalidateLayout. This is called when children are added or removed, and must be called when the spacing, border or layout direction is changed.

DIconLayout:LayoutIcons_LEFT()
Internal: This is used internally - although you're able to use it you probably shouldn't.

DIconLayout:LayoutIcons_TOP()
Internal: This is used internally - although you're able to use it you probably shouldn't.

DIconLayout:SetBorder( number width )
Sets the internal border (padding) within the DIconLayout. This will not change its size, only the positioning of children. You must call DIconLayout:Layout in order for the changes to take effect.

DIconLayout:SetLayoutDir( number direction )
Sets the direction that it will be layed out, using the DOCK enum.

DIconLayout:SetSpaceX( number xSpacing )
Sets the horizontal (x) spacing between children within the DIconLayout. You must call DIconLayout:Layout in order for the changes to take effect.

DIconLayout:SetSpaceY( number ySpacing )
Sets the vertical (y) spacing between children within the DIconLayout. You must call DIconLayout:Layout in order for the changes to take effect.

DIconLayout:SetStretchHeight( boolean do_stretch )
If set to true, the icon layout will stretch its height to fit all the children.

DIconLayout:SetStretchWidth( boolean stretchW )
If set to true, the icon layout will stretch its width to fit all the children.

# DImage

DImage:DoLoadMaterial()
Internal: This is used internally - although you're able to use it you probably shouldn't.

DImage:FixVertexLitMaterial()
Internal: This is used internally - although you're able to use it you probably shouldn't.

DImage:LoadMaterial()
Internal: This is used internally - although you're able to use it you probably shouldn't.

DImage:PaintAt( number posX,  number posY,  number width,  number height )
Paints a ghost copy of the DImage panel at the given position and dimensions. This function overrides Panel:PaintAt.

DImage:SetFailsafeMatName( string backupMat )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DImage:SetImage( string strImage,  string strBackup = nil )
Sets the image to load into the frame. If the first image can't be loaded and strBackup is set, that image will be loaded instead.

DImage:SetImageColor( table col )
Sets the image's color override.

DImage:SetKeepAspect( boolean keep )
Sets whether the DImage should keep the aspect ratio of its image when being resized.

DImage:SetMaterial( IMaterial mat )
Sets a Material directly as an image.

DImage:SetMatName( string mat )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DImage:SetOnViewMaterial( string mat,  string backupMat )
Similar to DImage:SetImage, but will only do the expensive part of actually loading the textures/material if the material is about to be rendered/viewed.

# DImageButton

DImageButton:DepressImage()
Internal: This is used internally - although you're able to use it you probably shouldn't.

DImageButton:SetColor( table color )
Sets the color of the image. Equivalent of DImage:SetImageColor

DImageButton:SetDepressImage( boolean enable )
Controls whether DImageButton:DepressImage is functional or not.

DImageButton:SetIcon()
Deprecated: We advise against using this. It may be changed or removed in a future update.

DImageButton:SetImage( string strImage,  string strBackup = nil )
Sets the "image" of the DImageButton. Equivalent of DImage:SetImage.

DImageButton:SetImageVisible( boolean visible )
Hides or shows the image of the image button. Internally this calls Panel:SetVisible on the internal DImage.

DImageButton:SetKeepAspect( boolean keep )
Sets whether the DImageButton should keep the aspect ratio of its image. Equivalent of DImage:SetKeepAspect.

DImageButton:SetMaterial( IMaterial mat )
Sets a Material directly as an image. Equivalent of DImage:SetMaterial.

DImageButton:SetOnViewMaterial( string mat,  string backup )
See DImage:SetOnViewMaterial

DImageButton:SetStretchToFit( boolean stretch )
Sets whether the image inside the DImageButton should be stretched to fill the entire size of the button, without preserving aspect ratio.

# DKillIcon

DKillIcon:SetName( string iconName )
Sets the killicon to be displayed. You should call Panel:SizeToContents following this.

# DLabel

DLabel:DoClickInternal()
Called just before DLabel:DoClick.

DLabel:DoDoubleClickInternal()
Called just before DLabel:DoDoubleClick. In DLabel does nothing and is safe to override.

DLabel:SetAutoStretchVertical( boolean stretch )
Automatically adjusts the height of the label dependent of the height of the text inside of it.

DLabel:SetBright( boolean bright )
Sets the color of the text to the bright text color defined in the skin.

DLabel:SetColor( table color )
Changes color of label. Alias of DLabel:SetTextColor.

DLabel:SetDark( boolean dark )
Sets the color of the text to the dark text color defined in the skin.

DLabel:SetDisabled( boolean disable )
Deprecated: We advise against using this. It may be changed or removed in a future update.

DLabel:SetDoubleClickingEnabled( boolean enable )
Sets whether or not double clicking should call DLabel:DoDoubleClick.

DLabel:SetDrawBackground( boolean draw )
Deprecated: We advise against using this. It may be changed or removed in a future update.

DLabel:SetFont( string fontName )
Sets the font of the label.

DLabel:SetHighlight( boolean highlight )
Sets the color of the text to the highlight text color defined in the skin.

DLabel:SetIsMenu( boolean isMenu )
Used internally by DComboBox.

DLabel:SetIsToggle( boolean allowToggle )
Enables or disables toggle functionality for a label. Retrieved with DLabel:GetIsToggle.

DLabel:SetPaintBackground( boolean paint )
Sets whether or not the background should be painted. This is mainly used by derivative classes, such as DButton.

DLabel:SetTextColor( table color )
Sets the text color of the DLabel. This will take precedence over DLabel:SetTextStyleColor.

DLabel:SetTextStyleColor( table color )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DLabel:SetToggle( boolean toggleState )
Sets the toggle state of the label. This can be retrieved with DLabel:GetToggle and toggled with DLabel:Toggle.

DLabel:Toggle()
Toggles the label's state. This can be set and retrieved with DLabel:SetToggle and DLabel:GetToggle.

DLabel:UpdateColours( table skin )
A hook called from within PANEL:ApplySchemeSettings to determine the color of the text on display.

DLabel:UpdateFGColor()
Internal: This is used internally - although you're able to use it you probably shouldn't.

DLabel:SetPos( 40, 40 )

DLabel:SetText( "Hello, world!" )
Output:

# DLabelEditable

DLabelEditable:SetAutoStretch( boolean stretch )
Sets whether the editable label should stretch to the text entered or not.

# DLabelURL

DLabelURL:SetAutoStretchVertical( boolean draw )
Deprecated: We advise against using this. It may be changed or removed in a future update.

DLabelURL:SetColor( table col )
Alias of DLabelURL:SetTextColor.

DLabelURL:SetTextColor( table col )
Sets the text color of the DLabelURL. Overrides DLabelURL:SetTextStyleColor.

DLabelURL:SetTextStyleColor( table color )
Sets the base text color of the DLabelURL. This is overridden by DLabelURL:SetTextColor.

DLabelURL:UpdateFGColor()
Internal: This is used internally - although you're able to use it you probably shouldn't.

# DListBox

DListBox:SelectByName( string val )
Select a DListBoxItem based on its value.

DListBox:SelectItem( Panel item,  boolean onlyme )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DListBox:SetMultiple( boolean multiple )
Sets whether the list box can select multiple items.

DListBox:SetSelectedItems( table items )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DListBox:Dock( FILL )

DListBox:AddItem( "test1" )

DListBox:AddItem( "test2" )

DListBox:AddItem( "test3" )

DListBox:SetMultiple( true )

# DListBoxItem

DListBoxItem:Select( boolean onlyMe )
Selects this item.

DListBoxItem:SetMother( Panel parent )
Internal: This is used internally - although you're able to use it you probably shouldn't.

# DListView

DListView:ClearSelection()
Clears the current selection in the DListView.

DListView:DisableScrollbar()
Removes the scrollbar.

DListView:FixColumnsLayout()
Internal: This is used internally - although you're able to use it you probably shouldn't.

DListView:OnClickLine( Panel line,  boolean isSelected )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DListView:OnRequestResize( Panel column,  number size )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DListView:RemoveLine( number line )
Removes a line from the list view.

DListView:SelectFirstItem()
Selects the line at the first index of the DListView if one has been added.

DListView:SelectItem( Panel Line )
Selects a line in the listview.

DListView:SetDataHeight( number height )
Sets the height of all lines of the DListView except for the header line.

DListView:SetDirty( boolean isDirty )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DListView:SetHeaderHeight( number height )
Sets the height of the header line of the DListView.

DListView:SetHideHeaders( boolean hide )
Sets whether the header line should be visible on not.

DListView:SetMultiSelect( boolean allowMultiSelect )
Sets whether multiple lines can be selected by the user by using the ctrl or ⇧ shift keys. When set to false, only one line can be selected.

DListView:SetSortable( boolean isSortable )
Enables/disables the sorting of columns by clicking.

DListView:SortByColumns( number column1 = nil,  boolean descrending1 = false,  number column2 = nil,  boolean descrending2 = false,  number column3 = nil,  boolean descrending3 = false,  number column4 = nil,  boolean descrending4 = false )
Sorts the list based on given columns.

# DListView_Column

DListView_Column:ResizeColumn( number size )
Resizes the column, additionally adjusting the size of the column to the right, if any.

DListView_Column:SetColumnID( number index )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DListView_Column:SetDescending( boolean desc )
Sets whether the column is sorted in descending order or not.

DListView_Column:SetFixedWidth( number width )
Sets the fixed width of the column.

DListView_Column:SetMinWidth( number width )
Sets the minimum width of a column.

DListView_Column:SetName( string name )
Sets the text in the column's header.

DListView_Column:SetTextAlign( number alignment )
Sets the text alignment for the column

DListView_Column:SetWidth( number width )
Sets the width of the panel.

# DListView_Line

DListView_Line:DataLayout( DListView pnl )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DListView_Line:SetAltLine( boolean alt )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DListView_Line:SetID( number id )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DListView_Line:SetListView( DListView pnl )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DListView_Line:SetSelected( boolean selected )
Sets whether this line is selected or not.

DListView_Line:SetSortValue( number column,  any data )
Allows you to store data per column.

# DMenu

DMenu:AddPanel( Panel pnl )
Adds a panel to the DMenu as if it were an option.

DMenu:AddSpacer()
Adds a horizontal line spacer.

DMenu:ClearHighlights()
Deprecated: We advise against using this. It may be changed or removed in a future update.

DMenu:CloseSubMenu( Panel menu )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DMenu:GetChild( number childIndex )
Gets a child by its index.

DMenu:Hide()
Used to safely hide (not remove) the menu. This will also hide any opened submenues recursively.

DMenu:HighlightItem( Panel item )
Deprecated: We advise against using this. It may be changed or removed in a future update.

DMenu:Open( number x = gui.MouseX()
,  number y = gui.MouseY(),  any skipanimation = nil,  Panel ownerpanel = nil )Opens the DMenu at given position.

DMenu:OpenSubMenu( Panel item,  Panel menu = nil )
Closes any active sub menus, and opens a new one.

DMenu:OptionSelected( Panel option,  string optionText )
Called when a option has been selected

DMenu:OptionSelectedInternal( Panel option )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DMenu:SetDeleteSelf( boolean newState )
Set to true by default. IF set to true, the menu will be deleted when it is closed, not simply hidden.

DMenu:SetDrawBorder( boolean bool )
Deprecated: We advise against using this. It may be changed or removed in a future update.

DMenu:SetDrawColumn( boolean draw )
Sets whether the DMenu should draw the icon column with a different color.

DMenu:SetMaxHeight( number maxHeight )
Sets the maximum height the DMenu can have. If the height of all menu items exceed this value, a scroll bar will be automatically added.

DMenu:SetMinimumWidth( number minWidth )
Sets the minimum width of the DMenu. The menu will be stretched to match the given value.

DMenu:SetOpenSubMenu( Panel item )
Internal: This is used internally - although you're able to use it you probably shouldn't.

Menu:AddOption( "Simple option" )

Menu:AddSpacer()

Menu:Open()

# DMenuBar

DMenuBar:SetDrawBackground( boolean shouldPaint )
Deprecated: We advise against using this. It may be changed or removed in a future update.

DMenuBar:SetIsMenu( boolean isMenu )
Sets whether or not the panel is part of a DMenu.

DMenuBar:SetPaintBackground( boolean shouldPaint )
Sets whether or not the background should be painted. Is the same as DMenuBar:SetDrawBackground

MenuBar:DockMargin( -3, -6, -3, 0 )
--corrects MenuBar pos

# DMenuOption

DMenuOption:OnChecked( boolean checked )
Called whenever the DMenuOption's checked state changes.

DMenuOption:SetChecked( boolean checked )
Sets the checked state of the DMenuOption.

DMenuOption:SetIsCheckable( boolean checkable )
Sets whether the DMenuOption is a checkbox option or a normal button option.

DMenuOption:SetMenu( Panel pnl )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DMenuOption:SetRadio( boolean checked )
Sets whether this DMenuOption should act like a radio button.

DMenuOption:SetSubMenu( Panel menu )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DMenuOption:ToggleCheck()
Toggles the checked state of DMenuOption. Does not respect DMenuOption:GetIsCheckable.

# DMenuOptionCVar

DMenuOptionCVar:SetConVar( string cvar )
Sets the console variable to be used by DMenuOptionCVar.

DMenuOptionCVar:SetValueOff( string value )
Sets the value of the console variable when the DMenuOptionCVar is not checked.

DMenuOptionCVar:SetValueOn( string value )
Sets the value of the console variable when the DMenuOptionCVar is checked.

# DModelPanel

DModelPanel:DrawModel()
Internal: This is used internally - although you're able to use it you probably shouldn't.

DModelPanel:RunAnimation()
This function is used in DModelPanel:LayoutEntity. It will progress the animation, set using Entity:SetSequence. By default, it is the walking animation.

DModelPanel:SetAmbientLight( table color )
Sets the ambient lighting used on the rendered entity.

DModelPanel:SetAnimated( boolean animated )
Sets whether or not to animate the entity when the default DModelPanel:LayoutEntity is called.

DModelPanel:SetAnimSpeed( number animSpeed )
Sets the speed used by DModelPanel:RunAnimation to advance frame on an entity sequence.

DModelPanel:SetColor( table color )
Sets the color of the rendered entity.

DModelPanel:SetEntity( Entity ent )
Sets the entity to be rendered by the model panel.

DModelPanel:SetLookAng( Angle ang )
Sets the angles of the camera.

DModelPanel:SetLookAt( Vector pos )
Makes the panel's camera face the given position. Basically sets the camera's angles (DModelPanel:SetLookAng) after doing some math.

DModelPanel:SetModel( string model )
Sets the model of the rendered entity.

# DModelSelect

DModelSelect:SetHeight( number num = 2 )
Sets the height of the panel in the amount of 64px spawnicons.

DModelSelect:SetModelList( table models,  string convar,  boolean dontSort,  boolean dontCallListConVars )
Called to set the list of models within the panel element.

# DModelSelectMulti

DModelSelectMulti:AddModelList( string name,  table models,  string convar,  boolean dontSort,  boolean dontCallListConVars )
Adds a new tab of models.

# DNotify

DNotify:AddItem( Panel pnl,  number lifeLength = nil )
Adds a panel to the notification

DNotify:SetAlignment( number alignment )
Sets the alignment of the child panels in the notification

DNotify:SetLife( number time )
Sets the display time in seconds for the DNotify.

DNotify:SetSpacing( number spacing )
Sets the spacing between child elements of the notification panel.

DNotify:Shuffle()
Internal: This is used internally - although you're able to use it you probably shouldn't.

# DNumberScratch

DNumberScratch:DrawNotches( number level,  number x,  number y,  number w,  number h,  number range,  number value,  number min,  number max )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DNumberScratch:DrawScreen( number x,  number y,  number w,  number h )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DNumberScratch:LockCursor()
Internal: This is used internally - although you're able to use it you probably shouldn't.

DNumberScratch:PaintScratchWindow()
Internal: This is used internally - although you're able to use it you probably shouldn't.

DNumberScratch:SetActive( boolean active )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DNumberScratch:SetDecimals( number decimals )
Sets the desired amount of numbers after the decimal point.

DNumberScratch:SetFloatValue( number val )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DNumberScratch:SetFraction( number frac )
Sets the value of the DNumberScratch as a fraction, a value between 0 and 1 where 0 is the minimum and 1 is the maximum value of the DNumberScratch

DNumberScratch:SetMax( number max )
Sets the max value that can be selected on the number scratch

DNumberScratch:SetMin( number min )
Sets the minimum value that can be selected on the number scratch.

DNumberScratch:SetShouldDrawScreen( boolean shouldDraw )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DNumberScratch:SetValue( number val )
Sets the value of the DNumberScratch and triggers DNumberScratch:OnValueChanged

DNumberScratch:SetZoom( number zoom )
Sets the zoom level of the scratch panel.

DNumberScratch:UpdateConVar()
Internal: This is used internally - although you're able to use it you probably shouldn't.

# DNumberWang

DNumberWang:GetFraction( number val )
Returns a fraction representing the current number selector value to number selector min/max range ratio. If argument val is supplied, that number will be computed instead.

DNumberWang:HideWang()
Hides the number selector arrows.

DNumberWang:SetDecimals( number num )
Sets the amount of decimal places allowed in the number selector.

DNumberWang:SetFloatValue( number val )
Deprecated: We advise against using this. It may be changed or removed in a future update.

DNumberWang:SetFraction( number val )
Sets the value of the number selector based on the given fraction number.

DNumberWang:SetInterval( number min )
Sets interval at which the up and down buttons change the current value.

DNumberWang:SetMax( number max )
Sets the maximum numeric value allowed by the number selector.

DNumberWang:SetMin( number min )
Sets the minimum numeric value allowed by the number selector.

DNumberWang:SetMinMax( number min,  number max )
Sets the minimum and maximum value allowed by the number selector.

DNumberWang:SetValue( number val )
Sets the value of the DNumberWang and triggers DNumberWang:OnValueChanged

# DNumSlider

DNumSlider:ResetToDefaultValue()
Resets the slider to the default value, if one was set by DNumSlider:SetDefaultValue.

DNumSlider:SetConVar( string cvar )
Sets the console variable to be updated when the value of the slider is changed.

DNumSlider:SetDark( boolean dark )
Calls DLabel:SetDark on the DLabel part of the DNumSlider.

DNumSlider:SetDecimals( number decimals )
Sets the desired amount of numbers after the decimal point.

DNumSlider:SetMax( number max )
Sets the maximum value for the slider.

DNumSlider:SetMin( number min )
Sets the minimum value for the slider

DNumSlider:SetMinMax( number min,  number max )
Sets the minimum and the maximum value of the slider.

DNumSlider:SetValue( number val )
Sets the value of the DNumSlider.

DNumSlider:ValueChanged( number value )
Internal: This is used internally - although you're able to use it you probably shouldn't.

# DPanel

DPanel:SetBackgroundColor( table color )
Sets the background color of the panel.

DPanel:SetDisabled( boolean disabled )
Sets whether or not to disable the panel.

DPanel:SetDrawBackground( boolean draw )
Deprecated: We advise against using this. It may be changed or removed in a future update.

DPanel:SetIsMenu( boolean isMenu )
Used internally by DMenu.

DPanel:SetPaintBackground( boolean paint )
Sets whether or not to paint/draw the panel background.

DPanel:SetTabbingDisabled( boolean draw )
Deprecated: We advise against using this. It may be changed or removed in a future update.

DPanel:UpdateColours()
Deprecated: We advise against using this. It may be changed or removed in a future update.

DPanel:SetPos( 10, 30 )
-- Set the position of the panel

DPanel:SetSize( 200, 200 )
-- Set the size of the panel

# DPanelList

DPanelList:AddItem( Panel pnl,  string state = nil )
Adds a existing panel to the end of DPanelList.

DPanelList:CleanList()
Removes all items.

DPanelList:Clear( boolean remove )
Hides all child panels, and optionally deletes them.

DPanelList:EnableVerticalScrollbar()
Enables/creates the vertical scroll bar so that the panel list can be scrolled through.

DPanelList:InsertAtTop( Panel insert,  string strLineState )
Insert given panel at the top of the list.

DPanelList:Rebuild()
Internal: This is used internally - although you're able to use it you probably shouldn't.

DPanelList:SetAutoSize( boolean shouldSizeToContents )
Sets the DPanelList to size its height to its contents. This is set to false by default.

DPanelList:SetPadding( number Offset )
Sets the offset of the lists items from the panel borders

DPanelList:SetSpacing( number Distance )
Sets distance between list items

# DPanelOverlay

DPanelOverlay:PaintDifferentColours( table cola,  table colb,  table colc,  table cold,  number size )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DPanelOverlay:PaintInnerCorners( number size )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DPanelOverlay:SetColor( table color )
Sets the border color of the DPanelOverlay.

DPanelOverlay:SetType( number type )
Sets the type of the DPanelOverlay.

DPanelOverlay:SetType( 1 )
-- Sets the type of overlay to add to the DPanel

DPanelOverlay:SetColor( Color( 255, 0, 0 )
) -- Sets the colour of the borders

# DPanPanel

DPanPanel:AddItem( Panel pnl )
Parents the passed panel to the DPanPanel:GetCanvas.

DPanPanel:OnScroll( number x,  number y )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DPanPanel:ScrollToChild( Panel pnl )
Scroll to a specific child panel.

DPanPanel:SetCanvas( Panel pnl )
Internal: This is used internally - although you're able to use it you probably shouldn't.

# DProgress

DProgress:SetFraction( number fraction )
Sets the fraction of the progress bar. 0 is 0% and 1 is 100%.

DProgress:SetPos( 10, 30 )

DProgress:SetSize( 200, 20 )

DProgress:SetFraction( 0.75 )
Output:

# DProperties

DProperties:Dock( FILL )

# DProperty_Combo

DProperty_Combo:AddChoice( string Text,  any data,  boolean select = false )
Add a choice to your combo control.

DProperty_Combo:DataChanged( any data )
Called after the user selects a new value.

DProperty_Combo:SetSelected( number Id )
Set the selected option.

DProperty_Combo:Setup( table data = { text = 'Select...' } )
Internal: This is used internally - although you're able to use it you probably shouldn't.

# DProperty_Generic

DProperty_Generic:SetRow( Panel row )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DProperty_Generic:Setup( table data )
Sets up a generic control for use by DProperties.

DProperty_Generic:ValueChanged( any newVal,  boolean force )
Called by this control, or a derived control, to alert the row of the change.

# DProperty_VectorColor

DProperty_VectorColor:Setup( table settings )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DProperty_VectorColor:SetValue( Vector color )
Sets the color value of the property.

# DPropertySheet

DPropertySheet:CrossFade( table anim,  number delta,  table data )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DPropertySheet:SetActiveTab( Panel tab )
Sets the active tab of the DPropertySheet.

DPropertySheet:SetFadeTime( number time = 0.1 )
Sets the amount of time (in seconds) it takes to fade between tabs.

DPropertySheet:SetPadding( number padding = 8 )
Sets the padding from parent panel to children panel.

DPropertySheet:SetShowIcons( boolean show )
Deprecated: We advise against using this. It may be changed or removed in a future update.

DPropertySheet:SetupCloseButton( function func )
Creates a close button on the right side of the DPropertySheet that will run the given callback function when pressed.

DPropertySheet:SizeToContentWidth()
Sets the width of the DPropertySheet to fit the contents of all of the tabs.

DPropertySheet:SwitchToName( string name )
Switches the active tab to a tab with given name.

# DRGBPicker

DRGBPicker:SetRGB( table color )
Sets the color stored in the color picker.

# DScrollPanel

DScrollPanel:AddItem( Panel pnl )
Parents the passed panel to the DScrollPanel's canvas.

DScrollPanel:PerformLayoutInternal()
Internal: This is used internally - although you're able to use it you probably shouldn't.

DScrollPanel:Rebuild()
Internal: This is used internally - although you're able to use it you probably shouldn't.

DScrollPanel:ScrollToChild( Panel panel )
Scrolls to the given child

DScrollPanel:SetCanvas( Panel canvas )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DScrollPanel:SetPadding( number padding )
Deprecated: We advise against using this. It may be changed or removed in a future update.

DScrollPanel:Dock( FILL )

# DShape

DShape:SetBorderColor( table clr )
Sets the border color of the shape.

DShape:SetColor( table clr )
Sets the color to display the shape with.

DShape:SetType( string type )
Sets the shape to be drawn.

Shape:SetType( "Rect" )
-- This is the only type it can be

Shape:SetPos( 100, 100 )

Shape:SetColor( Color(0, 255, 0, 255)
)

Shape:SetSize( 200, 200 )
Output:

# DSizeToContents

DSizeToContents:SetSizeX( boolean sizeX )
Sets whether the DSizeToContents panel should size to contents horizontally. This is true by default.

DSizeToContents:SetSizeY( boolean sizeY )
Sets whether the DSizeToContents panel should size to contents vertically. This is true by default.

# DSlider

DSlider:ConVarXNumberThink()
Internal: This is used internally - although you're able to use it you probably shouldn't.

DSlider:ConVarYNumberThink()
Internal: This is used internally - although you're able to use it you probably shouldn't.

DSlider:OnValuesChangedInternal()
Internal: This is used internally - although you're able to use it you probably shouldn't.

DSlider:SetBackground( string path )
Sets the background for the slider.

DSlider:SetConVarX( string convar )
Sets the ConVar to be set when the slider changes on the X axis.

DSlider:SetConVarY( string convar )
Sets the ConVar to be set when the slider changes on the Y axis.

DSlider:SetDragging( boolean dragging )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DSlider:SetImage()
Deprecated: We advise against using this. It may be changed or removed in a future update.

DSlider:SetImageColor()
Deprecated: We advise against using this. It may be changed or removed in a future update.

DSlider:SetLockX( number lockX = nil )
Sets the lock on the X axis.

DSlider:SetLockY( number lockY = nil )
Sets the lock on the Y axis.

DSlider:SetNotchColor( Color clr )
Deprecated: We advise against using this. It may be changed or removed in a future update.

DSlider:SetNotches( number notches )
Deprecated: We advise against using this. It may be changed or removed in a future update.

DSlider:SetNumSlider( any slider )
Deprecated: We advise against using this. It may be changed or removed in a future update.

DSlider:SetSlideX( number x )
Used to position the draggable panel of the slider on the X axis.

DSlider:SetSlideY( number y )
Used to position the draggable panel of the slider on the Y axis.

DSlider:SetTrapInside( boolean trap )
Makes the slider itself, the "knob", trapped within the bounds of the slider panel. Example:

Slider:SetPos( 50, 50 )

Slider:SetSize( 100, 20 )

# DSprite

DSprite:SetColor( table color )
Sets the color modifier for the sprite.

DSprite:SetHandle( Vector vec )
Deprecated: We advise against using this. It may be changed or removed in a future update.

DSprite:SetMaterial( IMaterial material )
Sets the source material for the sprite.

DSprite:SetRotation( number ang )
Sets the 2D rotation angle of the sprite, in the plane of the screen.

# DTab

DTab:SetPanel( Panel pnl )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DTab:SetPropertySheet( Panel pnl )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DTab:Setup( string label,  Panel sheet,  Panel pnl,  string icon = nil )
Internal: This is used internally - although you're able to use it you probably shouldn't.

# DTextEntry

DTextEntry:AddHistory( string text )
Adds an entry to DTextEntry's history.

DTextEntry:OnTextChanged( boolean noMenuRemoval )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DTextEntry:OpenAutoComplete( table tab )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DTextEntry:SetCursorColor( table color )
Sets the cursor's color in DTextEntry (the blinking line).

DTextEntry:SetDisabled( boolean disabled )
Deprecated: We advise against using this. It may be changed or removed in a future update.

DTextEntry:SetDrawBackground( boolean show )
Deprecated: We advise against using this. It may be changed or removed in a future update.

DTextEntry:SetDrawBorder( boolean bool )
Deprecated: We advise against using this. It may be changed or removed in a future update.

DTextEntry:SetEditable( boolean enabled )
Disables Input on a DTextEntry. This differs from DTextEntry:SetDisabled - SetEditable will not affect the appearance of the textbox.

DTextEntry:SetEnterAllowed( boolean allowEnter )
Sets whether pressing the Enter key will cause the DTextEntry to lose focus or not, provided it is not multiline. This is true by default.

DTextEntry:SetFont( string font )
Changes the font of the DTextEntry.

DTextEntry:SetHighlightColor( table color )
Sets/overrides the default highlight/text selection color of the text entry.

DTextEntry:SetHistoryEnabled( boolean enable )
Enables or disables the history functionality of DTextEntry. This allows the player to scroll through history elements using up and down arrow keys.

DTextEntry:SetNumeric( boolean numericOnly )
Sets whether or not to decline non-numeric characters as input.

DTextEntry:SetPaintBackground( boolean show )
Sets whether to show the default background of the DTextEntry.

DTextEntry:SetPlaceholderColor( table color = Color(128, 128, 128)
)Allow you to set placeholder color.

DTextEntry:SetPlaceholderText( string text = nil )
Sets the placeholder text that will be shown while the text entry has no user text. The player will not need to delete the placeholder text if they decide to start typing.

DTextEntry:SetTabbingDisabled( boolean enabled )
Sets whether or not the panel accepts tab key.

DTextEntry:SetUpdateOnType( boolean updateOnType )
Sets whether we should fire DTextEntry:OnValueChange every time we type or delete a character or only when Enter is pressed.

DTextEntry:SetValue( string text )
Sets the text of the DTextEntry and calls DTextEntry:OnValueChange.

DTextEntry:UpdateFromHistory()
Internal: This is used internally - although you're able to use it you probably shouldn't.

DTextEntry:UpdateFromMenu()
Internal: This is used internally - although you're able to use it you probably shouldn't.

TextEntry:Dock( TOP )

# DTileLayout

DTileLayout:ClearTiles()
Internal: This is used internally - although you're able to use it you probably shouldn't.

DTileLayout:ConsumeTiles( number x,  number y,  number w,  number h )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DTileLayout:CopyContents( Panel source )
Creates copies of all the children from the given panel object and parents them to this one.

DTileLayout:Layout()
Resets the last width/height info, and invalidates the panel's layout, causing it to recalculate all child positions. It is called whenever a child is added or removed, and can be called to refresh the panel.

DTileLayout:LayoutTiles()
Internal: This is used internally - although you're able to use it you probably shouldn't.

DTileLayout:SetBaseSize( number size )
Sets the size of a single tile. If a child panel is larger than this size, it will occupy several tiles.

DTileLayout:SetBorder( number border )
Sets the spacing between the border/edge of the DTileLayout and all the elements inside.

DTileLayout:SetMinHeight( number minH )
Determines the minimum height the DTileLayout will resize to. This is useful if child panels will be added/removed often.

DTileLayout:SetSpaceX( number spacingX )
Sets the spacing between 2 elements in the DTileLayout on the X axis.

DTileLayout:SetSpaceY( number spaceY )
Sets the spacing between 2 elements in the DTileLayout on the Y axis.

DTileLayout:SetTile( number x,  number y,  any state )
Internal: This is used internally - although you're able to use it you probably shouldn't.

# DTooltip

DTooltip:Close()
Forces the tooltip to close. This will remove the panel.

DTooltip:DrawArrow( number x,  number y )
Used to draw a triangle beneath the DTooltip

DTooltip:PositionTooltip()
Internal: This is used internally - although you're able to use it you probably shouldn't.

DTooltip:SetContents( Panel panel,  boolean delete = false )
What Panel you want put inside of the DTooltip

# DTree

DTree:ExpandTo( boolean bExpand )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DTree:LayoutTree()
Deprecated: We advise against using this. It may be changed or removed in a future update.

DTree:MoveChildTo( Panel child,  number pos )
Moves given node to the top of DTrees children. (Makes it the topmost mode)

DTree:SetClickOnDragHover( boolean enable )
Enables the "click when drag-hovering" functionality.

DTree:SetExpanded( boolean bExpand )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DTree:SetIndentSize( number size )
Sets the indentation size of the DTree, the distance between each "level" of the tree is offset on the left from the previous level.

DTree:SetLineHeight( number h )
Sets the height of each DTree_Node in the tree.

DTree:SetSelectedItem( Panel node )
Set the currently selected top-level node.

DTree:SetShowIcons( boolean show )
Sets whether or not the Silkicons next to each node of the DTree will be displayed.

# DTree_Node

DTree_Node:AddPanel( Panel pnl )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DTree_Node:AnimSlide( table anim,  number delta,  table data )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DTree_Node:ChildExpanded( boolean expanded )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DTree_Node:CleanList()
Cleans up the internal table of items (sub-nodes) of this node from invalid panels or sub-nodes that were moved from this node to another.

DTree_Node:CreateChildNodes()
Internal: This is used internally - although you're able to use it you probably shouldn't.

DTree_Node:ExpandRecurse( boolean expand )
Expands or collapses this node, as well as ALL child nodes of this node.

DTree_Node:ExpandTo( boolean expand )
Collapses or expands all nodes from the topmost-level node to this one.

DTree_Node:FilePopulate( boolean bAndChildren,  boolean bExpand )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DTree_Node:FilePopulateCallback( table files,  table folders,  string foldername,  string path,  boolean bAndChildren,  string wildcard )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DTree_Node:Insert( Panel node,  Panel nodeNextTo,  boolean before )
Inserts a sub-node into this node before or after the given node.

DTree_Node:InsertNode( Panel node )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DTree_Node:InstallDraggable( Panel node )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DTree_Node:InternalDoClick()
Internal: This is used internally - although you're able to use it you probably shouldn't.

DTree_Node:InternalDoRightClick()
Internal: This is used internally - although you're able to use it you probably shouldn't.

DTree_Node:LeaveTree( Panel pnl )
Removes given node as a sub-node of this node.

DTree_Node:MakeFolder( string folder,  string path,  boolean showFiles = false,  string wildcard = "*",  boolean dontForceExpandable = false )
Makes this node a folder in the filesystem. This will make it automatically populated.

DTree_Node:MoveChildTo( Panel node )
Moves given panel to the top of the children of this node.

DTree_Node:MoveToTop()
Moves this node to the top of the level.

DTree_Node:PerformRootNodeLayout()
Internal: This is used internally - although you're able to use it you probably shouldn't.

DTree_Node:PopulateChildren()
Internal: This is used internally - although you're able to use it you probably shouldn't.

DTree_Node:PopulateChildrenAndSelf( boolean expand )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DTree_Node:SetDirty( boolean dirty )
Deprecated: We advise against using this. It may be changed or removed in a future update.

DTree_Node:SetDoubleClickToOpen( boolean enable )
Sets whether double clicking the node should expand/collapse it or not.

DTree_Node:SetDraggableName( string name )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DTree_Node:SetDrawLines( boolean draw )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DTree_Node:SetExpanded( boolean expand,  boolean surpressAnimation = false )
Expands or collapses this node.

DTree_Node:SetFileName( string filename )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DTree_Node:SetFolder( string folder )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DTree_Node:SetForceShowExpander( boolean forceShow )
Sets whether or not the expand/collapse button (+/- button) should be shown on this node regardless of whether it has sub-elements or not.

DTree_Node:SetHideExpander( boolean hide )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DTree_Node:SetIcon( string path )
Sets the material for the icon of the DTree_Node.

DTree_Node:SetLastChild( boolean last )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DTree_Node:SetNeedsChildSearch( boolean newState )
Internal: This is used internally - although you're able to use it you probably shouldn't.Deprecated: We advise against using this. It may be changed or removed in a future update.

DTree_Node:SetNeedsPopulating( boolean needs )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DTree_Node:SetParentNode( Panel parent )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DTree_Node:SetPathID( string path )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DTree_Node:SetRoot( Panel root )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DTree_Node:SetSelected( boolean selected )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DTree_Node:SetShowFiles( boolean showFiles )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DTree_Node:SetupCopy()
Deprecated: We advise against using this. It may be changed or removed in a future update.

DTree_Node:SetWildCard( string wildcard )
Internal: This is used internally - although you're able to use it you probably shouldn't.

# DVerticalDivider

DVerticalDivider:DoConstraints()
Internal: This is used internally - although you're able to use it you probably shouldn't.

DVerticalDivider:SetBottom( Panel pnl )
Sets the passed panel as the bottom content of the DVerticalDivider.

DVerticalDivider:SetBottomMin( number height )
Sets the minimum height of the bottom content panel.

DVerticalDivider:SetDividerHeight( number height )
Sets the height of the divider bar between the top and bottom content panels of the DVerticalDivider.

DVerticalDivider:SetDragging( boolean isDragging )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DVerticalDivider:SetHoldPos( number y )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DVerticalDivider:SetMiddle( Panel pnl )
Places the passed panel in between the top and bottom content panels of the DVerticalDivider.

DVerticalDivider:SetTop( Panel pnl )
Sets the passed panel as the top content of the DVerticalDivider.

DVerticalDivider:SetTopHeight( number height )
Sets the height of the top content panel.

DVerticalDivider:SetTopMax( number height )
Sets the maximum height of the top content panel. This is ignored if the panel would exceed the minimum bottom content panel height set from DVerticalDivider:SetBottomMin.

DVerticalDivider:SetTopMin( number height )
Sets the minimum height of the top content panel.

DVerticalDivider:StartGrab()
Internal: This is used internally - although you're able to use it you probably shouldn't.

# DVScrollBar

DVScrollBar:AnimateTo( number scroll,  number length,  number delay = 0,  number ease = -1 )
Smoothly scrolls to given level.

DVScrollBar:Grip()
Internal: This is used internally - although you're able to use it you probably shouldn't.

DVScrollBar:SetHideButtons( boolean hide )
Allows hiding the up and down buttons for better visual stylisation.

DVScrollBar:SetScroll( number scroll )
Sets the scroll level in pixels.

DVScrollBar:SetUp( number barSize,  number canvasSize )
Sets up the scrollbar for use.

# IconEditor

IconEditor:AboveLayout()
Applies the top-down view camera settings for the model in the DAdjustableModelPanel.

IconEditor:BestGuessLayout()
Applies the best camera settings for the model in the DAdjustableModelPanel, using the values returned by PositionSpawnIcon.

IconEditor:FillAnimations( Entity ent )
Internal: This is used internally - although you're able to use it you probably shouldn't.

IconEditor:FullFrontalLayout()
Applies the front view camera settings for the model in the DAdjustableModelPanel.

IconEditor:OriginLayout()
Places the camera at the origin (0,0,0), relative to the entity, in the DAdjustableModelPanel.

IconEditor:Refresh()
Updates the internal DAdjustableModelPanel and SpawnIcon.

IconEditor:RenderIcon()
Re-renders the SpawnIcon.

IconEditor:RightLayout()
Applies the right side view camera settings for the model in the DAdjustableModelPanel.

IconEditor:SetDefaultLighting()
Internal: This is used internally - although you're able to use it you probably shouldn't.

IconEditor:SetFromEntity( Entity ent )
Sets the editor's model and icon from an entity. Alternative to IconEditor:SetIcon, with uses a SpawnIcon.

IconEditor:SetIcon( Panel icon )
Sets the SpawnIcon to modify. You should call Panel:Refresh immediately after this, as the user will not be able to make changes to the icon beforehand.

IconEditor:UpdateEntity( Entity ent )
Internal: This is used internally - although you're able to use it you probably shouldn't.

# ImageCheckBox

ImageCheckBox:Set( boolean OnOff )
Sets the checked state of the checkbox.

ImageCheckBox:SetChecked( boolean bOn )
Sets the checked state of the checkbox.

ImageCheckBox:SetMaterial( string mat )
Sets the material that will be visible when the ImageCheckBox is checked.

ImageCheckBox:SetMaterial( "icon16/accept.png" )
-- Set its image

ImageCheckBox:SetWidth( 24 )
-- Make the check box a bit wider than the image so it looks nicer

ImageCheckBox:Dock( LEFT )
-- Dock it

ImageCheckBox:SetChecked( false )
-- Set unchecked

# Material

Material:SetAlpha( number alpha )
Sets the alpha value of the Material panel.

Material:SetMaterial( string matname )
Sets the material used by the panel.

# MatSelect

MatSelect:AddMaterial( string label,  string path )
Adds a new material to the selection list.

MatSelect:AddMaterialEx( string label,  string path,  any value,  table convars )
Adds a new material to the selection list, with some extra options.

MatSelect:FindAndSelectMaterial( string mat )
Find a material and selects it, if it exists in this panel.

MatSelect:SelectMaterial( DImageButton mat )
Internal: This is used internally - although you're able to use it you probably shouldn't.

MatSelect:SetAutoHeight( boolean autoSize )
Sets whether the panel should set its own height to fit all materials within its height.

MatSelect:SetItemHeight( number height )
Sets the height of a single material in pixels.

MatSelect:SetItemWidth( number width )
Sets the width of a single material in pixels.

MatSelect:SetNumRows( number rows )
Sets the target height of the panel, in number of rows.

MatSelect:Dock( TOP )

MatSelect:SetAutoHeight( true )

MatSelect:SetItemWidth( 64 )

MatSelect:SetItemHeight( 64 )

MatSelect:AddMaterial( "Item #" .. k, material )

# PropSelect

PropSelect:AddModel( string model,  table convars )
Adds a new model to the selection list.

PropSelect:AddModelEx( string value,  string model,  number skin )
Adds a new model to the selection list.

PropSelect:FindAndSelectButton( string mdl )
Find and select a SpawnIcon panel based on the input model path.

PropSelect:Dock( TOP )

PropSelect:AddModelEx( model, model, 0 )

# SpawnIcon

SpawnIcon:OpenMenu()
Called when right clicked on the SpawnIcon. It will not be called if there is a selection (Panel:GetSelectionCanvas), in which case SANDBOX:SpawnlistOpenGenericMenu is called.

SpawnIcon:SetBodyGroup( number bodyGroupId,  number activeSubModelId )
Internal: This is used internally - although you're able to use it you probably shouldn't.

SpawnIcon:SetModelName( string mdl )
Internal: This is used internally - although you're able to use it you probably shouldn't.

SpawnIcon:SetSkinID( number skin )
Internal: This is used internally - although you're able to use it you probably shouldn't.

# SpawnmenuContentPanel

SpawnmenuContentPanel:CallPopulateHook( string hookname )
Changes the Spawnmenu category to search in

SpawnmenuContentPanel:EnableModify()
Allows the modification of the ContentSidebar

SpawnmenuContentPanel:EnableSearch( string category,  string hookname )
Changes the Spawnmenu category to search in

SpawnmenuContentPanel:SwitchPanel( Panel panel )
Switches the current panel with the given panel

# TextEntry

DTextEntry:AddHistory( string text )
Adds an entry to DTextEntry's history.

DTextEntry:OnTextChanged( boolean noMenuRemoval )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DTextEntry:OpenAutoComplete( table tab )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DTextEntry:SetCursorColor( table color )
Sets the cursor's color in DTextEntry (the blinking line).

DTextEntry:SetDisabled( boolean disabled )
Deprecated: We advise against using this. It may be changed or removed in a future update.

DTextEntry:SetDrawBackground( boolean show )
Deprecated: We advise against using this. It may be changed or removed in a future update.

DTextEntry:SetDrawBorder( boolean bool )
Deprecated: We advise against using this. It may be changed or removed in a future update.

DTextEntry:SetEditable( boolean enabled )
Disables Input on a DTextEntry. This differs from DTextEntry:SetDisabled - SetEditable will not affect the appearance of the textbox.

DTextEntry:SetEnterAllowed( boolean allowEnter )
Sets whether pressing the Enter key will cause the DTextEntry to lose focus or not, provided it is not multiline. This is true by default.

DTextEntry:SetFont( string font )
Changes the font of the DTextEntry.

DTextEntry:SetHighlightColor( table color )
Sets/overrides the default highlight/text selection color of the text entry.

DTextEntry:SetHistoryEnabled( boolean enable )
Enables or disables the history functionality of DTextEntry. This allows the player to scroll through history elements using up and down arrow keys.

DTextEntry:SetNumeric( boolean numericOnly )
Sets whether or not to decline non-numeric characters as input.

DTextEntry:SetPaintBackground( boolean show )
Sets whether to show the default background of the DTextEntry.

DTextEntry:SetPlaceholderColor( table color = Color(128, 128, 128)
)Allow you to set placeholder color.

DTextEntry:SetPlaceholderText( string text = nil )
Sets the placeholder text that will be shown while the text entry has no user text. The player will not need to delete the placeholder text if they decide to start typing.

DTextEntry:SetTabbingDisabled( boolean enabled )
Sets whether or not the panel accepts tab key.

DTextEntry:SetUpdateOnType( boolean updateOnType )
Sets whether we should fire DTextEntry:OnValueChange every time we type or delete a character or only when Enter is pressed.

DTextEntry:SetValue( string text )
Sets the text of the DTextEntry and calls DTextEntry:OnValueChange.

DTextEntry:UpdateFromHistory()
Internal: This is used internally - although you're able to use it you probably shouldn't.

DTextEntry:UpdateFromMenu()
Internal: This is used internally - although you're able to use it you probably shouldn't.

TextEntry:Dock( TOP )

# UGCPublishWindow

UGCPublishWindow:CheckInput()
Checks if the Tags and Title are valid and if so it enables the publish button.

UGCPublishWindow:DisplayError( string err )
Displays the given error message.

UGCPublishWindow:DoPublish( string wsid,  string err )
Publishes the Item or throws an error if the Title or Tags are invalid

UGCPublishWindow:FitContents()
Rezises the panel to nicely fit all children

UGCPublishWindow:OnPublishFinished( string wsid,  string err )
Called when the Item was published or if any error occurred while publishing

UGCPublishWindow:Setup( string ugcType,  string file,  string imageFile,  WorkshopFileBase handler )
updated the Workshop items list.

UGCPublishWindow:UpdateWorkshopItems()
updated the Workshop items list.

# Button

DButton:SetConsoleCommand( string command,  string args = nil )
Sets a console command to be called when the button is clicked.

DButton:SetDrawBorder( boolean draw )
Deprecated: We advise against using this. It may be changed or removed in a future update.

DButton:SetIcon( string img = nil )
Sets an image to be displayed as the button's background. Alias of DButton:SetImage

DButton:SetImage( string img = nil )
Sets an image to be displayed as the button's background.

DButton:SetMaterial( IMaterial img = nil )
Sets an image to be displayed as the button's background.

DButton:UpdateColours( table skin )
A hook called from within DLabel's PANEL:ApplySchemeSettings to determine the color of the text on display.

# Frame

DFrame:Center()
Centers the frame relative to the whole screen and invalidates its layout. This overrides Panel:Center.

DFrame:Close()
Hides or removes the DFrame, and calls DFrame:OnClose.

DFrame:SetBackgroundBlur( boolean blur )
Indicate that the background elements won't be usable.

DFrame:SetDeleteOnClose( boolean shouldDelete )
Determines whether or not the DFrame is removed when it is closed with DFrame:Close.

DFrame:SetDraggable( boolean draggable )
Sets whether the frame should be draggable by the user. The DFrame can only be dragged from its title bar.

DFrame:SetIcon( string path )
Adds or removes an icon on the left of the DFrame's title.

DFrame:SetIsMenu( boolean isMenu )
Sets whether the frame is part of a derma menu or not.

DFrame:SetMinHeight( number minH )
Sets the minimum height the DFrame can be resized to by the user.

DFrame:SetMinWidth( number minW )
Sets the minimum width the DFrame can be resized to by the user.

DFrame:SetPaintShadow( boolean shouldPaint )
Sets whether or not the shadow effect bordering the DFrame should be drawn.

DFrame:SetScreenLock( boolean lock )
Sets whether the DFrame is restricted to the boundaries of the screen resolution.

DFrame:SetSizable( boolean sizeable )
Sets whether or not the DFrame can be resized by the user.

DFrame:SetTitle( string title )
Sets the title of the frame.

DFrame:ShowCloseButton( boolean show )
Determines whether the DFrame's control box (close, minimise and maximise buttons) is displayed.

DFrame:SetPos(100, 100)
-- Set the position to 100x by 100y.

DFrame:SetSize(300, 200)
-- Set the size to 300x by 200y.

DFrame:SetTitle("Derma Frame")
-- Set the title in the top left to "Derma Frame".

DFrame:MakePopup()
-- Makes your mouse be able to move around.

# HTML

DHTML:AddFunction( string library,  string name,  function callback )
Defines a Javascript function that when called will call a Lua callback.

DHTML:QueueJavascript( string js )
Runs/Executes a string as JavaScript code in a panel.

DHTML:SetScrollbars( boolean show )
Deprecated: We advise against using this. It may be changed or removed in a future update.

# Label

DLabel:DoClickInternal()
Called just before DLabel:DoClick.

DLabel:DoDoubleClickInternal()
Called just before DLabel:DoDoubleClick. In DLabel does nothing and is safe to override.

DLabel:SetAutoStretchVertical( boolean stretch )
Automatically adjusts the height of the label dependent of the height of the text inside of it.

DLabel:SetBright( boolean bright )
Sets the color of the text to the bright text color defined in the skin.

DLabel:SetColor( table color )
Changes color of label. Alias of DLabel:SetTextColor.

DLabel:SetDark( boolean dark )
Sets the color of the text to the dark text color defined in the skin.

DLabel:SetDisabled( boolean disable )
Deprecated: We advise against using this. It may be changed or removed in a future update.

DLabel:SetDoubleClickingEnabled( boolean enable )
Sets whether or not double clicking should call DLabel:DoDoubleClick.

DLabel:SetDrawBackground( boolean draw )
Deprecated: We advise against using this. It may be changed or removed in a future update.

DLabel:SetFont( string fontName )
Sets the font of the label.

DLabel:SetHighlight( boolean highlight )
Sets the color of the text to the highlight text color defined in the skin.

DLabel:SetIsMenu( boolean isMenu )
Used internally by DComboBox.

DLabel:SetIsToggle( boolean allowToggle )
Enables or disables toggle functionality for a label. Retrieved with DLabel:GetIsToggle.

DLabel:SetPaintBackground( boolean paint )
Sets whether or not the background should be painted. This is mainly used by derivative classes, such as DButton.

DLabel:SetTextColor( table color )
Sets the text color of the DLabel. This will take precedence over DLabel:SetTextStyleColor.

DLabel:SetTextStyleColor( table color )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DLabel:SetToggle( boolean toggleState )
Sets the toggle state of the label. This can be retrieved with DLabel:GetToggle and toggled with DLabel:Toggle.

DLabel:Toggle()
Toggles the label's state. This can be set and retrieved with DLabel:SetToggle and DLabel:GetToggle.

DLabel:UpdateColours( table skin )
A hook called from within PANEL:ApplySchemeSettings to determine the color of the text on display.

DLabel:UpdateFGColor()
Internal: This is used internally - although you're able to use it you probably shouldn't.

DLabel:SetPos( 40, 40 )

DLabel:SetText( "Hello, world!" )
Output:

# PanelList

DPanelList:AddItem( Panel pnl,  string state = nil )
Adds a existing panel to the end of DPanelList.

DPanelList:CleanList()
Removes all items.

DPanelList:Clear( boolean remove )
Hides all child panels, and optionally deletes them.

DPanelList:EnableVerticalScrollbar()
Enables/creates the vertical scroll bar so that the panel list can be scrolled through.

DPanelList:InsertAtTop( Panel insert,  string strLineState )
Insert given panel at the top of the list.

DPanelList:Rebuild()
Internal: This is used internally - although you're able to use it you probably shouldn't.

DPanelList:SetAutoSize( boolean shouldSizeToContents )
Sets the DPanelList to size its height to its contents. This is set to false by default.

DPanelList:SetPadding( number Offset )
Sets the offset of the lists items from the panel borders

DPanelList:SetSpacing( number Distance )
Sets distance between list items

# Slider

DSlider:ConVarXNumberThink()
Internal: This is used internally - although you're able to use it you probably shouldn't.

DSlider:ConVarYNumberThink()
Internal: This is used internally - although you're able to use it you probably shouldn't.

DSlider:OnValuesChangedInternal()
Internal: This is used internally - although you're able to use it you probably shouldn't.

DSlider:SetBackground( string path )
Sets the background for the slider.

DSlider:SetConVarX( string convar )
Sets the ConVar to be set when the slider changes on the X axis.

DSlider:SetConVarY( string convar )
Sets the ConVar to be set when the slider changes on the Y axis.

DSlider:SetDragging( boolean dragging )
Internal: This is used internally - although you're able to use it you probably shouldn't.

DSlider:SetImage()
Deprecated: We advise against using this. It may be changed or removed in a future update.

DSlider:SetImageColor()
Deprecated: We advise against using this. It may be changed or removed in a future update.

DSlider:SetLockX( number lockX = nil )
Sets the lock on the X axis.

DSlider:SetLockY( number lockY = nil )
Sets the lock on the Y axis.

DSlider:SetNotchColor( Color clr )
Deprecated: We advise against using this. It may be changed or removed in a future update.

DSlider:SetNotches( number notches )
Deprecated: We advise against using this. It may be changed or removed in a future update.

DSlider:SetNumSlider( any slider )
Deprecated: We advise against using this. It may be changed or removed in a future update.

DSlider:SetSlideX( number x )
Used to position the draggable panel of the slider on the X axis.

DSlider:SetSlideY( number y )
Used to position the draggable panel of the slider on the Y axis.

DSlider:SetTrapInside( boolean trap )
Makes the slider itself, the "knob", trapped within the bounds of the slider panel. Example:

Slider:SetPos( 50, 50 )

Slider:SetSize( 100, 20 )


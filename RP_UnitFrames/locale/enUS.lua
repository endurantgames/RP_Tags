-- US English localization ==========================================================================================================================================
-- ------------------ - core app strings

local RPTAGS = RPTAGS;

RPTAGS.queue:WaitUntil("LOAD_DATA_LOCALE",
function(self, event, ...)

  local RPTAGS = RPTAGS;

  local ModL = {};
  
  local APP_NAME = RPTAGS.cache.APP_NAME;
  local RP = RPTAGS.cache.RP;
  
  local APP_COLOR_RPUF = "|cffdd9933";

  local RPUF_NAME = RP .. APP_COLOR_RPUF .. "UnitFrames" .. "|r";
  local RPUF_ABBR = RP .. APP_COLOR_RPUF .. "UF" .. "|r";
  
  ModL["RPUF_NAME"]          = RPUF_NAME;
  ModL["RPUF_ABBR"]          = RPUF_ABBR;
  -- --- slash commands
  ModL["SLASH_RPUF"]         = "u|r|rpuf|unitframes";
  ModL["SLASH_LAYOUT"]       = "l|layout|frames";
  ModL["SLASH_TAGS"]         = "p|tags|panels";
  
  ModL["ADDON_RPUF"]         = "rp:UF";
  ModL["ADDON_RPUF"]         = RPUF_NAME;
  
  -- ------------------ - user interface -----------------------------------------------------------------------------------------------------------------------------
  -- --- context menus
  ModL["CONTEXT_HIDE_FRAMES"]    = "Hide all "   .. RPUF_NAME .. " in combat";
  ModL["CONTEXT_LOCK_FRAMES"]    = "Lock all "   .. RPUF_NAME .. " positions";
  ModL["CONTEXT_MENU_TITLE"]     = "Choose an Option";
  ModL["CONTEXT_SHOW_FRAMES"]    = "Show all "   .. RPUF_NAME .. " in combat";
  ModL["CONTEXT_UNLOCK_FRAMES"]  = "Unlock all " .. RPUF_NAME .. " positions";
  ModL["EDIT_ICON"]              = "Edit Icon Slot Tags";
  ModL["EDIT_PANEL"]             = "Edit Panel Tags";
  ModL["EDIT_TAGS"]              = "Edit Tags";
  ModL["EDIT_TAGS_FOR"]          = "Edit Tags for ";
  ModL["EDIT_TOOLTIP"]           = "Edit Tooltip Tags";
  ModL["OPEN_RPTAGS_CONFIG"]     = "Open " .. APP_NAME .. " Options";
  ModL["QUICK_SETTINGS"]         = "Quick Settings";
  -- --- keybindings
  ModL["KEYBIND_DISABLE_RPUF"]   = "Toggle " .. RPUF_NAME;
  ModL["KEYBIND_HIDE_IN_COMBAT"] = "Toggle Hide in Combat";
  ModL["KEYBIND_LOCK_FRAMES"]    = "Toggle Frame Lock";
  ModL["KEYBIND_TAG_EDITOR"]     = "Open the Tag Editor";
  -- --- tag editor
  ModL["TAG_EDITOR"]             = " Tag Editor";
  ModL["TAG_EDIT_CANCEL"]        = "Cancel";
  ModL["TAG_EDIT_DEFAULT"]       = "Default";
  ModL["TAG_EDIT_ERRORS"]        = "You have unknown tags. Save anyway?";
  ModL["TAG_EDIT_ERRORS_CANCEL"] = "Cancel";
  ModL["TAG_EDIT_ERRORS_EDIT"]   = "Edit Tags";
  ModL["TAG_EDIT_ERRORS_SAVE"]   = "Save Anyway";
  ModL["TAG_EDIT_HELP"]          = "|cff%s%s|r\n\n%s";
  ModL["TAG_EDIT_RESULTS"]       = "Test Results";
  ModL["TAG_EDIT_RESULTS_FAIL"]  = "Test Results: Errors Found";
  ModL["TAG_EDIT_RESULTS_PASS"]  = "Test Results: Passed";
  ModL["TAG_EDIT_REVERT"]        = "Revert";
  ModL["TAG_EDIT_TEST"]          = "Test Tags";
  ModL["TAG_EDIT_UPDATE"]        = "Save Tags";
  ModL["TAG_TEST_FAIL"]          = "Unknown tags found: ";
  ModL["TAG_TEST_FAIL_SINGULAR"] = "Unknown tag found: ";
  ModL["TAG_TEST_PASS"]          = "No errors found.";
  ModL["UNKNOWN_TAG_END"]        = "]|r";
  ModL["UNKNOWN_TAG_START"]      = "|cffff0000Tag Error: [";
  ModL["USE_TAG_EDITOR"]         = "Tag Editor";
  
  ModL["OPT_COLORS_RPUF"]       = RPUF_NAME .. " Colors";   -- used
  ModL["OPT_FORMATS"]           = "Tag Formats";            -- used
  ModL["OPT_FORMATS"]           = RP .. "Formats";
  ModL["OPT_KEYBINDINGS"]       = "Keybindings";
  ModL["OPT_FORMATS_I"]         = "These options control how RPTAGS displays certain tags.";
  ModL["OPT_RPUF_LAYOUT"]       = RPUF_ABBR .." Layout";
  ModL["OPT_RPUF_LAYOUT_I"]     = "Use these options to set the dimensions of the various panels in rp:UnitFrames Some layouts may not display all panels. For example, the details panel is only shown in frames set to the Detailed layout.";
  ModL["OPT_RPUF_MAIN"]         = RPUF_NAME;
  ModL["OPT_RPUF_MAIN_I"]       = "These options control the basic functionality of rp:UnitFrames.";
  ModL["OPT_RPUF_PANELS"]       = RPUF_ABBR .." Panels";
  ModL["OPT_RPUF_PANELS_I"]     = "You can change the tags displayed in rp:UnitFrames panels, as well as the tooltips shown when you move your mouse over that panel.";
  ModL["OPT_TITLE_RPUF_LAYOUT"] = RPUF_NAME .." Layout";
  ModL["OPT_TITLE_RPUF_MAIN"]   = RPUF_NAME .." General Settings";
  ModL["OPT_TITLE_RPUF_PANELS"] = RPUF_NAME .." Panels";
  -- beep
  ModL["SET_LAYOUT"]            = "Set ";
  ModL["WARNING_RPUF_DISABLED"] = "|cffdd0000Note:|r These options are disabled because you have turned off rp:UnitFrames. To re-enable, go to the RPUF options panel."; -- should be OPT_INSTRUCT_
  
    -- --------------------- - notifications ----------------------------------------------------------------------------------------------------------------------------
  -- error messages
  local ERROR_INLINE                  = "|cffdd0000Error!|r";
  local ERROR_STARTUP                 = APP_NAME .. "|cffff0000 Startup Error:|r\n\n";
  local ERROR_NO_RP_ADDON             = "but you aren't using a roleplaying addon that is recognized by RPTAGS.";
  
  ModL["ERROR_KEYBIND_NO_RPUF"]          = ERROR_INLINE .. "You tried to use a keybinding for RPUF but you don't have RPUF turned on.";
  ModL["ERROR_KEYBIND_TAG_EDITOR"]       = ERROR_INLINE .. "You used the keybinding to open the last panel you edited in the tag editor, " ..
                                        "but you haven't used it before. Opening the Options page for tags instead.";
  -- other notifications
  ModL["FRAMES_ARE_RESET"]               = "All " .. RPUF_NAME .. " have been reset to their original panel dimensions."; -- should be NOTIFY_
  ModL["FRAME_LOCATIONS_ARE_RESET"]      = "All " .. RPUF_NAME .. " have been reset to their original locations."; -- should be NOTIFY_
  ModL["LOCKING_FRAMES"]                 = RPUF_NAME .. " are now locked in position."; -- should be NOTIFY_
  ModL["NOTIFY_KEYBIND_TAG_EDITOR"]      = "Opening the RPUF Tag Editor with the last tag you edited.";
  ModL["NOTIFY_KEYBIND_TAG_EDITOR_OPEN"] = "|cffdddd00Ignored:|r You used the keybinding to open the tag editor, but you already have it open.";
  ModL["RPUF_ARE_DISABLED"]              = "RPUF are now disabled."; -- should be NOTIFY_
  ModL["RPUF_ARE_ENABLED"]               = "RPUF are now enabled."; -- should be NOTIFY_
  ModL["RPUF_HIDE_IN_COMBAT"]            = RPUF_NAME .. " are now hidden during combat."; -- should be NOTIFY_
  ModL["RPUF_SHOW_IN_COMBAT"]            = RPUF_NAME .. " will be shown during combat."; -- should be NOTIFY_
  ModL["TAGS_ARE_RESET"]                 = "All " .. RPUF_NAME .. " panels and tooltips have been reset to their default tag values."; -- should be NOTIFY_
  ModL["TRP3_CONFIG_OBSOLETE"]           = "Use the RPTAGS configuration system";
  ModL["TRP3_CONFIG_OBSOLETE_TT"]        = "RPTAGS is now configured using its own configuration system, accessible via the normal WoW addons options.";
  ModL["UNLOCKING_FRAMES"]               = RPUF_NAME .. " are now unlocked and can be moved."; -- should be NOTIFY_
  
    -- --------------------- - config -----------------------------------------------------------------------------------------------------------------------------------
  ModL["CONFIG_COLOR_RPUF"]                 = "Background Color";
  ModL["CONFIG_COLOR_RPUF_TEXT"]            = "Text Color";
  ModL["CONFIG_COLOR_RPUF_TEXT_TT"]         = "Choose the default font color for RPUF.";
  ModL["CONFIG_COLOR_RPUF_TOOLTIP"]         = "Tooltip Text Color";
  ModL["CONFIG_COLOR_RPUF_TOOLTIP_TT"]      = "Choose the default font color for RPUF tooltips.";
  ModL["CONFIG_COLOR_RPUF_TT"]              = "Choose a background color for RPUF.";
  
  ModL["CONFIG_DETAILHEIGHT"]               = "Details Panel Height";
  ModL["CONFIG_DETAILHEIGHT_TT"]            = "Choose how tall you want the details panel to be.";
  ModL["CONFIG_DETAILPANEL"]                = "Details Panel";
  ModL["CONFIG_DETAILPANEL_TT"]             = "Set the tags for the 'details' panel.";
  ModL["CONFIG_DETAIL_TOOLTIP"]             = "Details Panel Tooltip";
  ModL["CONFIG_DETAIL_TOOLTIP_TT"]          = "Set the tags for the 'details' panel tooltip.";
  ModL["CONFIG_DISABLE_BLIZZARD"]           = "Disable Blizzard Unit Frames";
  ModL["CONFIG_DISABLE_BLIZZARD_TT"]        = "You can disable Blizzard's unit frames. Don't worry, you can get them back by unchecking this button! |cffdd0000Warning:|r Changing this option will load the game.";
  ModL["CONFIG_DISABLE_RPUF"]               = "Disable RPUF";
  ModL["CONFIG_DISABLE_RPUF_TT"]            = "You can disable RPUF without disabling all of RPTAGS. One reason you might want to do this would be if you are running [[Elvui]] and don't need to use RPUF to display RPTAGS.";
  
  ModL["CONFIG_FOCUSFRAME_SCALE"]           = "Focus Frame Scale";
  ModL["CONFIG_FOCUSFRAME_SCALE_TT"]        = "Adjust the relative scale of the RPUF focus frame so it takes up more or less space on your screen.";
  ModL["CONFIG_FOCUSLAYOUT"]                = "Focus Frame Layout";
  ModL["CONFIG_FOCUSLAYOUT_TT"]             = "Choose the layout for your focus unit frame.";
  ModL["CONFIG_GAPSIZE"]                    = "Layout Spacing";
  ModL["CONFIG_GAPSIZE_TT"]                 = "Choose how much extra space you want left around the elements of the unitframes.";
  
  ModL["CONFIG_ICONWIDTH"]                  = "Icon Width";
  ModL["CONFIG_ICONWIDTH_TT"]               = "Choose how wide you want the icon bar to be.";
  ModL["CONFIG_ICON_1"]                     = "Icon Slot 1";
  ModL["CONFIG_ICON_1_TOOLTIP"]             = "Icon Slot 1 Tooltip";
  ModL["CONFIG_ICON_1_TOOLTIP_TT"]          = "Set the tags for the first icon slot tooltip.";
  ModL["CONFIG_ICON_1_TT"]                  = "Set the icon for the first icon slot. You should use icon tags.";
  ModL["CONFIG_ICON_2"]                     = "Icon Slot 2";
  ModL["CONFIG_ICON_2_TOOLTIP"]             = "Icon Slot 2 Tooltip";
  ModL["CONFIG_ICON_2_TOOLTIP_TT"]          = "Set the tags for the first icon slot tooltip.";
  ModL["CONFIG_ICON_2_TT"]                  = "Set the icon for the second icon slot. You should use icon tags.";
  ModL["CONFIG_ICON_3"]                     = "Icon Slot 3";
  ModL["CONFIG_ICON_3_TOOLTIP"]             = "Icon Slot 3 Tooltip";
  ModL["CONFIG_ICON_3_TOOLTIP_TT"]          = "Set the tags for the first icon slot tooltip.";
  ModL["CONFIG_ICON_3_TT"]                  = "Set the icon for the third icon slot. You should use icon tags.";
  ModL["CONFIG_ICON_4"]                     = "Icon Slot 4";
  ModL["CONFIG_ICON_4_TOOLTIP"]             = "Icon Slot 4 Tooltip";
  ModL["CONFIG_ICON_4_TOOLTIP_TT"]          = "Set the tags for the first icon slot tooltip.";
  ModL["CONFIG_ICON_4_TT"]                  = "Set the icon for the fourth icon slot. You should use icon tags.";
  ModL["CONFIG_ICON_5"]                     = "Icon Slot 5";
  ModL["CONFIG_ICON_5_TOOLTIP"]             = "Icon Slot 5 Tooltip";
  ModL["CONFIG_ICON_5_TOOLTIP_TT"]          = "Set the tags for the first icon slot tooltip.";
  ModL["CONFIG_ICON_5_TT"]                  = "Set the icon for the fifth icon slot. You should use icon tags.";
  ModL["CONFIG_ICON_6"]                     = "Icon Slot 6";
  ModL["CONFIG_ICON_6_TOOLTIP"]             = "Icon Slot 6 Tooltip";
  ModL["CONFIG_ICON_6_TOOLTIP_TT"]          = "Set the tags for the first icon slot tooltip.";
  ModL["CONFIG_ICON_6_TT"]                  = "Set the icon for the sixth icon slot. You should use icon tags.";
  
  ModL["CONFIG_INFOPANEL"]                  = "Info Panel";
  ModL["CONFIG_INFOPANEL_TT"]               = "Set the tags for the 'info' panel.";
  ModL["CONFIG_INFOWIDTH"]                  = "Info Panel Width";
  ModL["CONFIG_INFOWIDTH_TT"]               = "Choose how wide you want the info panel to be.";
  ModL["CONFIG_INFO_TOOLTIP"]               = "Info Panel Tooltip";
  ModL["CONFIG_INFO_TOOLTIP_TT"]            = "Set the tags for the 'info' panel tooltip.";
  
  ModL["CONFIG_LOCK_FRAMES"]                = "Lock Frames";
  ModL["CONFIG_LOCK_FRAMES_TT"]             = "Lock the unit frames so they can't be moved.";
  
  ModL["CONFIG_NAMEPANEL"]                  = "Name Panel";
  ModL["CONFIG_NAMEPANEL_TT"]               = "Set the tags for the 'name' panel. You don't have to use name tags.";
  ModL["CONFIG_NAME_TOOLTIP"]               = "Name Panel Tooltip";
  ModL["CONFIG_NAME_TOOLTIP_TT"]            = "Set the tags for the 'name' panel tooltip.";
  
  ModL["CONFIG_PLAYERFRAME_SCALE"]          = "Player Frame Scale";
  ModL["CONFIG_PLAYERFRAME_SCALE_TT"]       = "Adjust the relative scale of the RPUF player frame so it takes up more or less space on your screen.";
  ModL["CONFIG_PLAYERLAYOUT"]               = "Player Frame Layout";
  ModL["CONFIG_PLAYERLAYOUT_TT"]            = "Choose the layout for the player (that's you) unit frame.";
  
  ModL["CONFIG_PORTRAIT"]                   = "Portrait";
  ModL["CONFIG_PORTRAIT_TT"]                = "Set the tags for the portrait.";
  ModL["CONFIG_PORTRAIT_TOOLTIP"]           = "Portrait Tooltip";
  ModL["CONFIG_PORTRAIT_TOOLTIP_TT"]        = "Set the tags for the portrait tooltip.";
  ModL["CONFIG_PORTWIDTH"]                  = "Portrait Width";
  ModL["CONFIG_PORTWIDTH_TT"]               = "Choose how wide you want the portrait to be.";
  
  ModL["CONFIG_RESET_FRAME_LOCATIONS"]      = "Reset Frame Locations";
  ModL["CONFIG_RESET_FRAME_LOCATIONS_TT"]   = "Set all frames back to their default locations.";
  ModL["CONFIG_RESET_THESE_VALUES"]         = "Reset These Values";
  ModL["CONFIG_RESET_THESE_VALUES_TT"]      = "Set the displayed values back to their default values.";
  
  ModL["CONFIG_RPUFALPHA"]                  = "Background Transparency";
  ModL["CONFIG_RPUFALPHA_TT"]               = "Set the transparency of the background. 0 is completely invisible, while 100 is completely opaque.";
  ModL["CONFIG_RPUF_BACKDROP"]              = "Frame Border";
  ModL["CONFIG_RPUF_BACKDROP_TT"]           = "Choose what kind of border, if any, you want for RPUF.";
  
  ModL["CONFIG_RPUF_HIDE_COMBAT"]           = "Hide in Combat";
  ModL["CONFIG_RPUF_HIDE_COMBAT_TT"]        = "Check this to hide RPUF when you are in combat.";
  ModL["CONFIG_RPUF_HIDE_DEAD"]             = "Hide when Dead";
  ModL["CONFIG_RPUF_HIDE_DEAD_TT"]          = "Check this to hide RPUF when you are dead.";
  ModL["CONFIG_RPUF_HIDE_PARTY"]            = "Hide in Party";
  ModL["CONFIG_RPUF_HIDE_PARTY_TT"]         = "Check this to hide RPUF when you are in a party.";
  ModL["CONFIG_RPUF_HIDE_PETBATTLE"]        = "Hide in Pet Battle";
  ModL["CONFIG_RPUF_HIDE_PETBATTLE_TT"]     = "Check this to hide RPUF when you are in a pet battle.";
  ModL["CONFIG_RPUF_HIDE_RAID"]             = "Hide in Raid";
  ModL["CONFIG_RPUF_HIDE_RAID_TT"]          = "Check this to hide RPUF when you are in a raid.";
  ModL["CONFIG_RPUF_HIDE_VEHICLE"]          = "Hide in Vehicle";
  ModL["CONFIG_RPUF_HIDE_VEHICLE_TT"]       = "Check this to hide RPUF when you are in a vehicle.";
  
  ModL["CONFIG_STATUSHEIGHT"]               = "Height";
  ModL["CONFIG_STATUSHEIGHT_TT"]            = "Set the height of the 'status' panel.";
  ModL["CONFIG_STATUSPANEL"]                = "Status Panel";
  ModL["CONFIG_STATUSPANEL_TT"]             = "Set the tags for the 'status' panel. You don't have to use status tags.";
  ModL["CONFIG_STATUS_ALIGN"]               = "Alignment";
  ModL["CONFIG_STATUS_ALIGN_TT"]            = "Choose how you want the text on the status bar to be aligned.";
  ModL["CONFIG_STATUS_TEXTURE"]             = "Appearance";
  ModL["CONFIG_STATUS_TEXTURE_TT"]          = "Choose how you want the status bar to appear.";
  ModL["CONFIG_STATUS_TOOLTIP"]             = "Status Panel Tooltip";
  ModL["CONFIG_STATUS_TOOLTIP_TT"]          = "Set the tags for the 'status' panel tooltip.";
  
  ModL["CONFIG_TARGETFRAME_SCALE"]          = "Target Frame Scale";
  ModL["CONFIG_TARGETFRAME_SCALE_TT"]       = "Adjust the relative scale of the RPUF target frame so it takes up more or less space on your screen.";
  
  ModL["CONFIG_TARGETLAYOUT"]               = "Target Frame Layout";
  ModL["CONFIG_TARGETLAYOUT_TT"]            = "Choose the layout for the target unit frame.";
  
  ModL["CONFIG_TARGETTARGETFRAME_SCALE"]    = "TargetTarget Frame Scale";
  ModL["CONFIG_TARGETTARGETFRAME_SCALE_TT"] = "Adjust the relative scale of the RPUF target-of-target frame so it takes up more or less space on your screen.";
  
  ModL["CONFIG_UNLOCK_FRAMES"]              = "Unlock Frames";
  
    -- ----------- - rpuf --------------------------------------------------------------------------------------------------------------------------------------
    -- --- layouts
  ModL["RPUF_ABRIDGED"]         = "Standard";
  ModL["RPUF_COMPACT"]          = "Compact";
  ModL["RPUF_FULL"]             = "Detailed";
  ModL["RPUF_HIDDEN"]           = "Do not display";
  ModL["RPUF_PAPERDOLL"]        = "Portrait";
  ModL["RPUF_THUMBNAIL"]        = "Thumbnail";
    -- --- alignments
  ModL["BOTTOM"]                = "Bottom";
  ModL["BOTTOMLEFT"]            = "Bottom Left";
  ModL["BOTTOMRIGHT"]           = "Bottom Right";
  ModL["CENTER"]                = "Center";
  ModL["HORIZONTAL"]            = "Horizontal";
  ModL["LEFT"]                  = "Left";
  ModL["RIGHT"]                 = "Right";
  ModL["TOP"]                   = "Top";
  ModL["TOPLEFT"]               = "Top Left";
  ModL["TOPRIGHT"]              = "Top Right";
  ModL["VERTICAL"]              = "Vertical";
    -- --- textures
  ModL["BACKDROP_BLIZZTOOLTIP"] = "Border";
  ModL["BACKDROP_ORIGINAL"]     = "No Border";
  ModL["BACKDROP_THICK_LINE"]   = "Thick Line";
  ModL["BACKDROP_THIN_LINE"]    = "Thin Line";
  ModL["THICK_LINE"]            = "Thick Line";
  ModL["THIN_LINE"]             = "Thin Line";
  ModL["SKILLS"]                = "Skills Bar";
  ModL["SOLID"]                 = "Solid";
  ModL["RAID"]                  = "Raid Bar";
  ModL["STATUS_BAR"]            = "Status Bar";
  ModL["SHADED"]                = "Shaded";
  ModL["BAR"]                   = "Progress Bar";
  ModL["BLANK"]                 = "Blank";
  ModL["PORTRAIT_2D"]           = "2D Portrait";
  ModL["PORTRAIT_3D"]           = "3D Model";
  
  ModL["INTRO_MD"] = 
  [==========================================================================[
  # Introduction
  
  RPTAGS is an addon that lets you create special panels, called unit frames, to display roleplaying information of your
  choice, drawn from roleplaying addons such as [MyRolePlay](http:mrp), [Total RP 3](http:trp3), or [XRP](http:xrp).
  
  In addition, you can use any tags from RPTAGS in [ElvUI](http:elvui), although ElvUI is not required for RPTAGS.
  
  ## What's a Unit Frame?
  
  A unit frame is a window on your screen that appears when a certain type of unit exists in the
  game. For example, the Target Unit Frame is shown when you target someone.
  
  RPTAGS works with three types of unit frame: Player, Target, and Focus. When we talk about showing
  a unit's info, that means that your RP info is displayed in the player frame, your target's in the target frame,
  and your focus, if any, in the focus frame.
  
  ## What's a Tag?
  
  A tag, in this context, refers to a string of text that you asisgn to locations on the unit frames known
  as panels. Tags look like this:
  
  ### &nbsp; [rp:tagname]
  
  There are nearly 200 RPTAGS you can use, as well as several dozen provided by oUF, the framework addon upon
  which RPTAGS is built. Some of the most useful tags include:
  
  ### &nbsp; [rp:name], [rp:race], [rp:class], [rp:icon], [rp:color], [rp:status], [rp:curr]
  
  ## What are Panels?
  
  There are two types of panels: panels for text tags, and panels for icons. The text panels are Name Panel, Info Panel,
  Details Panel, and Status Bar. The icon panels are numbered from one to six.
  
  You can customize what is shown in each panel; in addition, you can also set the tooltips for when you move your
  mouse over that part of the unit frame.
  
  ## What's a Layout?
  
  There are five layouts provided by RPTAGS. Standard Layout shows all six icons, the name panel, info panel, and
  status bar. The Compact Layout only shows the first icon, name panel, and info panel. The Detailed Layout
  displays an animated 3-D portrait, all six icons, name panel, info panel, status bar, and a large space for the details
  panel. Portrait Layout is modeled after Blizzard's "paper doll" character screen and features a larger portrait,
  the name panel, the info panel, and all six icon slots. The Thumbnail Layout shows a small portrait, the name
  panel, and a single icon.
  
  You can set each panel to a different layout if you wish.
  
  ## Getting Started
  
  By default, RPTAGS begins with a set of predefined tags, but you can change those to whatever you wish. For example,
  the default tag found in the Name Panel is [rp:color][rp:name]. The first tag, [rp:color], changes the
  color of the following text to the the unit's personal color or custom class color. Then the second tag inserts the
  roleplaying name of the character.
  
  You can edit the content of a panel by right-clicking on that part of the frame, or by using the RPTAGS options
  panels. Your changes will immediately be reflected in the player frame, and also in whoever you target or focus on.
  
  ## Further Help
  
  If you need more assistance, you can peruse the rest of these help topics or ask for assistance on the
  [RPTAGS discord](http:discord) or ask [Oraibi on twitter](http:twitter).
  The easiest way to learn is to just start editing tags and experimenting. Have fun!
  
  ]==========================================================================];
  
  ModL["OPTIONS_MD"] = 
  [==========================================================================[
  # Options
  
  All settings are available through the RPTAGS options system.
  
  <a href="rpconfig:general">General Settings</a> let you determine what messages to show, how to display certain tags, and how to respond
  to notes that you've set on a unit. 
  
  <a href="rpconfig:colors">Colors Settings</a> let you change the various colors used by RPTAGS.
  
  You can use the <a href="rpconfig:rpuf">rp:UnitFrames Settings</a> control when and where RPUF will be shown.
  
  You can adjust the layout of RPUF in the <a href="rpconfig:layout">rp:UnitFrames Layout Settings</a>.
  
  To set the tags in each panel and icon slot, as well as tooltips for the same, use the
  <a href="rpconfig:tags">rp:UnitFrames Panels Settings</a>.
  
  If you want to restore the settings on a particular page to their default values, use the "Defaults" button in the lower left corner of the Interface window.
  ]==========================================================================];
  
  return ModL
end);
  

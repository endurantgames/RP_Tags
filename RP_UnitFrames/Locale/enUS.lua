-- US English localization ==========================================================================================================================================
-- ------------------ - core app strings

local addOnName, ns = ...
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("DATA_LOCALE",
function(self, event, ...)
  local L                                 = LibStub("AceLocale-3.0"):NewLocale(RPTAGS.CONST.APP_ID, "enUS", true);
  local RPTAGS                            = RPTAGS;
  local APP_NAME                          = RPTAGS.cache.APP_NAME;
  local RP                                = RPTAGS.cache.RP;
  local APP_COLOR_RPUF                    = "|cffdd9933";
  local RPUF_NAME                         = RP .. APP_COLOR_RPUF .. "UnitFrames" .. "|r";
  local RPUF_ABBR                         = RP .. APP_COLOR_RPUF .. "UF" .. "|r";
  local ERROR_INLINE                      = "|cffdd0000Error!|r";
  local ERROR_STARTUP                     = APP_NAME .. "|cffff0000 Startup Error:|r\n\n";
  local EDITOR                            = APP_NAME .. " Editor";
  local NBSP                              = RPTAGS.CONST.NBSP;
  local BUTTON                            = " Button";

  L["RPUF_NAME"                         ] = RPUF_NAME;
  L["RPUF_ABBR"                         ] = RPUF_ABBR;
  -- --- slash commands
  L["SLASH_FRAMES"                      ] = "frames|rpuf|unitframes|uf";
  L["SLASH_PLAYER"                      ] = "playerframe";
  L["SLASH_TARGET"                      ] = "targetframe";
  L["SLASH_FOCUS"                       ] = "focusframe";
  L["SLASH_TARGETTARGET"                ] = "targettargetframe";
  L["SLASH_PANELS"                      ] = "panels";
  L["SLASH_EDITOR"                      ] = "editor|tageditor";
  L["ADDON_RPUF"                        ] = "rp:UF";
  L["ADDON_RPUF"                        ] = RPUF_NAME;
  -- --- context menus
  L["CONTEXT_HIDE_FRAMES"               ] = "Hide all "   .. RPUF_NAME .. " in combat";
  L["CONTEXT_LOCK_FRAMES"               ] = "Lock all "   .. RPUF_NAME .. " positions";
  L["CONTEXT_MENU_TITLE"                ] = "Choose an Option";
  L["CONTEXT_SHOW_FRAMES"               ] = "Show all "   .. RPUF_NAME .. " in combat";
  L["CONTEXT_UNLOCK_FRAMES"             ] = "Unlock all " .. RPUF_NAME .. " positions";
  L["EDIT_ICON"                         ] = "Edit Icon Slot Tags";
  L["EDIT_PANEL"                        ] = "Edit Panel Tags";
  L["EDIT_TAGS"                         ] = "Edit Tags";
  L["EDIT_TAGS_FOR"                     ] = "Edit Tags for ";
  L["EDIT_TOOLTIP"                      ] = "Edit Tooltip Tags";
  L["OPEN_RPTAGS_CONFIG"                ] = "Open " .. APP_NAME .. " Options";
  L["QUICK_SETTINGS"                    ] = "Quick Settings";
  -- frames
  L["PLAYERFRAME"                       ] = "Player Frame";
  L["TARGETFRAME"                       ] = "Target Frame";
  L["FOCUSFRAME"                        ] = "Focus Frame";
  L["TARGETTARGETFRAME"                 ] = "Target-of-Target Frame"; 
  -- --- keybindings
  L["KEYBIND_DISABLE_RPUF"              ] = "Toggle " .. RPUF_NAME;
  L["KEYBIND_DISABLE_RPUF_TT"           ] = "Set a keybinding to toggle between " .. RPUF_NAME .. " being enabled and disabled.";
  L["KEYBIND_HIDE_IN_COMBAT"            ] = "Toggle Hide in Combat";
  L["KEYBIND_HIDE_IN_COMBAT_TT"         ] = "Set a keybinding to toggle between " .. RPUF_NAME .. " hiding when combat starts and returning when it ends.";
  L["KEYBIND_LOCK_FRAMES"               ] = "Toggle Frame Lock";
  L["KEYBIND_LOCK_FRAMES_TT"            ] = "Set a keybinding to toggle between " .. RPUF_NAME .. " frames being movable or not.";
  L["KEYBIND_TAG_EDITOR"                ] = "Open the " .. EDITOR;
  L["KEYBIND_TAG_EDITOR_TT"             ] = "Set a keybinding to open the " .. EDITOR .. " to the last panel you edited.";
  -- --- tag editor
  L["TAG_EDITOR"                        ] = EDITOR;
  L["TAG_EDIT_CANCEL"                   ] = "Cancel";
  L["TAG_EDIT_DEFAULT"                  ] = "Default";
  L["TAG_EDIT_ERRORS"                   ] = "You have unknown tags. Save anyway?";
  L["TAG_EDIT_ERRORS_CANCEL"            ] = "Cancel";
  L["TAG_EDIT_ERRORS_EDIT"              ] = "Edit Tags";
  L["TAG_EDIT_ERRORS_SAVE"              ] = "Save Anyway";
  L["TAG_EDIT_HELP"                     ] = "|cff%s%s|r\n\n%s";
  L["TAG_EDIT_RESULTS"                  ] = "Test Results";
  L["TAG_EDIT_RESULTS_FAIL"             ] = "Test Results: Errors Found";
  L["TAG_EDIT_RESULTS_PASS"             ] = "Test Results: Passed";
  L["TAG_EDIT_REVERT"                   ] = "Revert";
  L["TAG_EDIT_TEST"                     ] = "Test Tags";
  L["TAG_EDIT_UPDATE"                   ] = "Save Tags";
  L["TAG_TEST_FAIL"                     ] = "Unknown tags found: ";
  L["TAG_TEST_FAIL_SINGULAR"            ] = "Unknown tag found: ";
  L["TAG_TEST_PASS"                     ] = "No errors found.";
  L["UNKNOWN_TAG_END"                   ] = "] |r";
  L["UNKNOWN_TAG_START"                 ] = "|cffff0000Tag Error: [";
  L["USE_TAG_EDITOR"                    ] = "Editor";
  L["OPT_COLORS_RPUF"                   ] = RPUF_NAME .. " Colors";   -- used
  L["OPT_FORMATS"                       ] = "Tag Formats";            -- used
  L["OPT_PORTRAIT"                      ] = "Portrait";
  L["OPT_PORTRAIT_I"                    ] = "Set your preferences on the unit portait. (Not all layouts will display portraits.";
  L["OPT_SHARED_SETTINGS"               ] = "Shared Settings";
  L["OPT_EDITOR"                        ] = "Editor";
  L["OPT_FORMATS"                       ] = RP .. "Formats";
  L["OPT_KEYBINDINGS"                   ] = "Keybindings";
  L["OPT_FORMATS_I"                     ] = "These options control how RPTAGS displays certain tags.";
  L["OPT_RPUF_LAYOUT"                   ] = RPUF_NAME .." Layout";
  L["OPT_RPUF_LAYOUT_I"                 ] = "Use these options to set the dimensions of the various panels in rp:UnitFrames Some layouts may not display all panels. For example, the details panel is only shown in frames set to the Detailed layout.";
  L["PANEL_RPUF_MAIN"                   ] = RPUF_NAME;
  L["OPT_EDITOR_BUTTON_BAR"             ] = "Button Bar";
  L["OPT_EDITOR_BUTTON_BAR_I"           ] = "Customize the tag editor by choosing which buttons you wish to have on the button bar. You can pick up to " .. RPTAGS.CONST.RPUF.EDITOR_MAX_BUTTONS .. " buttons.";
  L["PANEL_RPUF_PANELS"                 ] = NBSP .. "Panels";
  L["PANEL_RPUF_FRAMES"                 ] = NBSP .. "Frames";
  L["PANEL_RPUF_EDITOR"                 ] = NBSP .. "Editor";
  L["OPT_EDITOR_I"                      ] = "These options control how the " .. EDITOR .. " works.";
  L["OPT_RPUF_MAIN"                     ] = RPUF_NAME;
  L["OPT_RPUF_MAIN_I"                   ] = "These options control the basic functionality of rp:UnitFrames.";
  L["OPT_RPUF_PANELS"                   ] = "Panels";
  L["OPT_RPUF_PANELS_I"                 ] = "You can change the tags displayed in rp:UnitFrames panels, as well as the tooltips shown when you move your mouse over that panel.";
  L["OPT_TITLE_RPUF_LAYOUT"             ] = "Layout";
  L["OPT_TITLE_RPUF_MAIN"               ] = "General Settings";
  L["OPT_TITLE_RPUF_PANELS"             ] = "Panels";
  L["SET_LAYOUT"                        ] = "Set ";
  L["WARNING_RPUF_DISABLED"             ] = "|cffdd0000Note:|r These options are disabled because you have turned off rp:UnitFrames. To re-enable, go to the RPUF options panel."; -- should be OPT_INSTRUCT_
  -- error messages
  L["ERROR_KEYBIND_NO_RPUF"             ] = ERROR_INLINE .. "You tried to use a keybinding for RPUF but you don't have RPUF turned on.";
  L["ERROR_KEYBIND_TAG_EDITOR"          ] = ERROR_INLINE .. "You used the keybinding to open the last panel you edited in the tag editor, but you haven't used it before. Opening the Options page for tags instead.";
  -- other notifications
  L["FRAMES_ARE_RESET"                  ] = "All " .. RPUF_NAME .. " have been reset to their original panel dimensions."; -- should be NOTIFY_
  L["FRAME_LOCATIONS_ARE_RESET"         ] = "All " .. RPUF_NAME .. " have been reset to their original locations."; -- should be NOTIFY_
  L["LOCKING_FRAMES"                    ] = RPUF_NAME .. " are now locked in position."; -- should be NOTIFY_
  L["NOTIFY_KEYBIND_TAG_EDITOR"         ] = "Opening the " .. EDITOR  .. " with the last tag you edited.";
  L["NOTIFY_KEYBIND_TAG_EDITOR_OPEN"    ] = "|cffdddd00Ignored:|r You used the keybinding to open the tag editor, but you already have it open.";
  L["RPUF_ARE_DISABLED"                 ] = "RPUF are now disabled."; -- should be NOTIFY_
  L["RPUF_ARE_ENABLED"                  ] = "RPUF are now enabled."; -- should be NOTIFY_
  L["RPUF_HIDE_IN_COMBAT"               ] = RPUF_NAME .. " are now hidden during combat."; -- should be NOTIFY_
  L["RPUF_SHOW_IN_COMBAT"               ] = RPUF_NAME .. " will be shown during combat."; -- should be NOTIFY_
  L["TAGS_ARE_RESET"                    ] = "All " .. RPUF_NAME .. " panels and tooltips have been reset to their default tag values."; -- should be NOTIFY_
  L["TRP3_CONFIG_OBSOLETE"              ] = "Use the RPTAGS configuration system";
  L["TRP3_CONFIG_OBSOLETE_TT"           ] = "RPTAGS is now configured using its own configuration system, accessible via the normal WoW addons options.";
  L["UNLOCKING_FRAMES"                  ] = RPUF_NAME .. " are now unlocked and can be moved."; -- should be NOTIFY_

  -- panel config
  local perFrame = 
  { 
    CONFIG_COLOR_RPUF             = "Background Color",
    CONFIG_COLOR_RPUF_TEXT        = "Text Color",
    CONFIG_COLOR_RPUF_TEXT_TT     = "Choose the default font color.",
    CONFIG_COLOR_RPUF_TOOLTIP     = "Tooltip Text Color",
    CONFIG_COLOR_RPUF_TOOLTIP_TT  = "Choose the default font color for tooltips.",
    CONFIG_COLOR_RPUF_TT          = "Choose a background color.",
    CONFIG_COLOR_STATUS_TEXT      = "Status Bar Text",
    CONFIG_COLOR_STATUS_TEXT_TT   = "Choose the color of text on the status bar.",
    CONFIG_COLOR_STATUS           = "Status Bar",
    CONFIG_COLOR_STATUS_TT        = "Choose the color of the status bar.",
    CONFIG_DETAILHEIGHT           = "Details Panel Height",
    CONFIG_DETAILHEIGHT_TT        = "Choose how tall you want the details panel to be.",
    CONFIG_FONTNAME               = "Font",
    CONFIG_FONTNAME_TT            = "Choose the font you want to use in this frame.",
    CONFIG_FONTSIZE               = "Font Size",
    CONFIG_FONTSIZE_TT            = "Choose the font size you want to use in this frame.",
    CONFIG_GAPSIZE                = "Layout Spacing",
    CONFIG_GAPSIZE_TT             = "Choose how much extra space you want left around the elements of the unitframes.",
    CONFIG_ICONWIDTH              = "Icon Width",
    CONFIG_ICONWIDTH_TT           = "Choose how wide you want the icon bar to be.",
    CONFIG_INFOWIDTH              = "Info Panel Width",
    CONFIG_INFOWIDTH_TT           = "Choose how wide you want the info panel to be.",
    CONFIG_LINK_FRAME             = "Link to Shared Settings",
    CONFIG_LINK_FRAME_TT          = "Choose whether to link this frame to the shared settings, or configure it separately.",
    CONFIG_LOCK_FRAMES            = "Lock Frame",
    CONFIG_LOCK_FRAMES_TT         = "Lock this unit frame so it can't be moved.";
    CONFIG_LSM_FILTER             = "Filter SharedMedia Files",
    CONFIG_LSM_FILTER_TT          = "Choose whether you want to see all available SharedMedia files, or just those we think work best.",
    CONFIG_MOUSEOVER_CURSOR       = "Change Cursor on Mouseover",
    CONFIG_MOUSEOVER_CURSOR_TT    = "Choose whether the cursor should change to a magnifying glass when you mouse over a panel.",
    CONFIG_PORTWIDTH              = "Portrait Width",
    CONFIG_PORTWIDTH_TT           = "Choose how wide you want the portrait to be.",


    CONFIG_RPUFALPHA              = "Background Opacity",
    CONFIG_RPUFALPHA_TT           = "Set the opacity of the background. 0 is completely invisible, while 100 is completely opaque.",
    CONFIG_RPUF_BACKDROP          = "Frame Background",
    CONFIG_RPUF_BACKDROP_TT       = "Choose what kind of background, if any, you want.",
    CONFIG_RPUF_BORDER            = "Frame Border",
    CONFIG_RPUF_BORDER_TT         = "Choose what kind of border, if any, you want.",
    CONFIG_RPUF_BORDER_WIDTH      = "Border Thickness",
    CONFIG_RPUF_BORDER_WIDTH_TT   = "Choose how thick the border should be.",
    CONFIG_RPUF_BORDER_INSETS     = "Background Inset",
    CONFIG_RPUF_BORDER_INSETS_TT  = "Choose how much the background should be inset relative to the border. You probably don't need to change this, unless the background is extending beyond the edge of the borders, or there's a gap between the border and the background.",
    CONFIG_RPUF_HIDE_COMBAT       = "Hide in Combat",
    CONFIG_RPUF_HIDE_COMBAT_TT    = "Check this to hide RPUF when you are in combat.",
    CONFIG_RPUF_HIDE_DEAD         = "Hide when Dead",
    CONFIG_RPUF_HIDE_DEAD_TT      = "Check this to hide RPUF when you are dead.",
    CONFIG_RPUF_HIDE_PARTY        = "Hide in Party",
    CONFIG_RPUF_HIDE_PARTY_TT     = "Check this to hide RPUF when you are in a party.",
    CONFIG_RPUF_HIDE_PETBATTLE    = "Hide in Pet Battle",
    CONFIG_RPUF_HIDE_PETBATTLE_TT = "Check this to hide RPUF when you are in a pet battle.",
    CONFIG_RPUF_HIDE_RAID         = "Hide in Raid",
    CONFIG_RPUF_HIDE_RAID_TT      = "Check this to hide RPUF when you are in a raid.",
    CONFIG_RPUF_HIDE_VEHICLE      = "Hide in Vehicle",
    CONFIG_RPUF_HIDE_VEHICLE_TT   = "Check this to hide RPUF when you are in a vehicle.",
    CONFIG_COLOR_RPUF_BORDER      = "Unit Frame Border Color",
    CONFIG_COLOR_RPUF_BORDER_TT   = "Choose the color that will tint the border around the unit frame.",
    CONFIG_SHOW_FRAME             = "Enable",
    CONFIG_SHOW_FRAME_TT          = "Choose whether to show or hide this frame.",
    CONFIG_STATUSHEIGHT           = "Height",
    CONFIG_STATUSHEIGHT_TT        = "Set the height of the 'status' panel.",
    CONFIG_STATUS_ALIGN           = "Alignment",
    CONFIG_STATUS_ALIGN_TT        = "Choose how you want the text on the status bar to be aligned.",
    CONFIG_STATUS_TEXTURE         = "Appearance",
    CONFIG_STATUS_TEXTURE_TT      = "Choose how you want the status bar to appear.",
    CONFIG_STATUS_ALPHA           = "Background Opacity",
    CONFIG_STATUS_ALPHA_TT        = "Set the opacity of the background. 0 is completely invisible, while 100 is completely opaque.",
  };

  for k, v in pairs(perFrame)
  do  L[k] = v;
      for frame, _ in pairs(RPTAGS.CONST.RPUF.FRAME_NAMES)
      do  local tt = k:match("_TT$");
          local key = k:gsub("_TT$","") .. "_" .. frame .. (tt or "");
          L[key] = v;
      end;
  end;
  local PANEL_FONTSIZE = "Font Size";
  local PANEL_FONTSIZE_TT = "Choose the relative font size for this panel.";
  local PANEL_FONTNAME = "Font";
  local PANEL_FONTNAME_TT = "Choose the font for this panel.";

  L["CONFIG_DETAILPANEL_FONTSIZE"    ] = PANEL_FONTSIZE;
  L["CONFIG_DETAILPANEL_FONTSIZE_TT" ] = PANEL_FONTSIZE_TT;
  L["CONFIG_ICON_1_FONTSIZE"         ] = PANEL_FONTSIZE;
  L["CONFIG_ICON_1_FONTSIZE_TT"      ] = PANEL_FONTSIZE_TT;
  L["CONFIG_ICON_2_FONTSIZE"         ] = PANEL_FONTSIZE;
  L["CONFIG_ICON_2_FONTSIZE_TT"      ] = PANEL_FONTSIZE_TT;
  L["CONFIG_ICON_3_FONTSIZE"         ] = PANEL_FONTSIZE;
  L["CONFIG_ICON_3_FONTSIZE_TT"      ] = PANEL_FONTSIZE_TT;
  L["CONFIG_ICON_4_FONTSIZE"         ] = PANEL_FONTSIZE;
  L["CONFIG_ICON_4_FONTSIZE_TT"      ] = PANEL_FONTSIZE_TT;
  L["CONFIG_ICON_5_FONTSIZE"         ] = PANEL_FONTSIZE;
  L["CONFIG_ICON_5_FONTSIZE_TT"      ] = PANEL_FONTSIZE_TT;
  L["CONFIG_ICON_6_FONTSIZE"         ] = PANEL_FONTSIZE;
  L["CONFIG_ICON_6_FONTSIZE_TT"      ] = PANEL_FONTSIZE_TT;
  L["CONFIG_INFOPANEL_FONTSIZE"      ] = PANEL_FONTSIZE;
  L["CONFIG_INFOPANEL_FONTSIZE_TT"   ] = PANEL_FONTSIZE_TT;
  L["CONFIG_NAMEPANEL_FONTSIZE"      ] = PANEL_FONTSIZE;
  L["CONFIG_NAMEPANEL_FONTSIZE_TT"   ] = PANEL_FONTSIZE_TT;
  L["CONFIG_STATUSPANEL_FONTSIZE"    ] = PANEL_FONTSIZE;
  L["CONFIG_STATUSPANEL_FONTSIZE_TT" ] = PANEL_FONTSIZE_TT;

  L["CONFIG_NAMEPANEL_FONTNAME"      ] = PANEL_FONTNAME;
  L["CONFIG_NAMEPANEL_FONTNAME_TT"   ] = PANEL_FONTNAME_TT;

  L["CONFIG_PORTRAIT_BG"      ]     = "Portrait Background";
  L["CONFIG_PORTRAIT_BG_TT"    ]     = "Set the background for the portrait.";
  L["CONFIG_PORTRAIT_BORDER" ]         = "Portrait Border";
  L["CONFIG_PORTRAIT_BORDER_TT" ]     = "Set the border for the portrait.";
  L["CONFIG_PORTRAIT_STYLE" ] =    "Portrait Styling";
  L["CONFIG_PORTRAIT_STYLE_TT"]     = "Select the style for portraits.";
  L["CONFIG_PORTRAIT_BORDER_STYLE"]  = "Portrait Frame Coloring";
  L["CONFIG_PORTRAIT_BORDER_STYLE_TT"] = "Select how you want to color the portrait frame.";
  -- 
  -- L["CONFIG_COLOR_RPUF"                 ] = "Background Color";
  -- L["CONFIG_COLOR_RPUF_TEXT"            ] = "Text Color";
  -- L["CONFIG_COLOR_RPUF_TEXT_TT"         ] = "Choose the default font color for RPUF.";
  -- L["CONFIG_COLOR_RPUF_TOOLTIP"         ] = "Tooltip Text Color";
  -- L["CONFIG_COLOR_RPUF_TOOLTIP_TT"      ] = "Choose the default font color for RPUF tooltips.";
  -- L["CONFIG_COLOR_RPUF_TT"              ] = "Choose a background color for RPUF.";
  -- L["CONFIG_DETAILHEIGHT"               ] = "Details Panel Height";
  -- L["CONFIG_DETAILHEIGHT_TT"            ] = "Choose how tall you want the details panel to be.";
  -- L["CONFIG_STATUSHEIGHT"               ] = "Height";
  -- L["CONFIG_STATUSHEIGHT_TT"            ] = "Set the height of the 'status' panel.";
  -- L["CONFIG_STATUS_ALIGN"               ] = "Alignment";
  -- L["CONFIG_STATUS_ALIGN_TT"            ] = "Choose how you want the text on the status bar to be aligned.";
  -- L["CONFIG_STATUS_TEXTURE"             ] = "Appearance";
  -- L["CONFIG_STATUS_TEXTURE_TT"          ] = "Choose how you want the status bar to appear.";
  -- L["CONFIG_GAPSIZE"                    ] = "Layout Spacing";
  -- L["CONFIG_GAPSIZE_TT"                 ] = "Choose how much extra space you want left around the elements of the unitframes.";
  -- L["CONFIG_ICONWIDTH"                  ] = "Icon Width";
  -- L["CONFIG_ICONWIDTH_TT"               ] = "Choose how wide you want the icon bar to be.";
  -- L["CONFIG_INFOWIDTH"                  ] = "Info Panel Width";
  -- L["CONFIG_INFOWIDTH_TT"               ] = "Choose how wide you want the info panel to be.";
  -- L["CONFIG_PORTWIDTH"                  ] = "Portrait Width";
  -- L["CONFIG_PORTWIDTH_TT"               ] = "Choose how wide you want the portrait to be.";
  -- L["CONFIG_RPUFALPHA"                  ] = "Background Transparency";
  -- L["CONFIG_RPUFALPHA_TT"               ] = "Set the transparency of the background. 0 is completely invisible, while 100 is completely opaque.";
  -- L["CONFIG_RPUF_BACKDROP"              ] = "Frame Border";
  -- L["CONFIG_RPUF_BACKDROP_TT"           ] = "Choose what kind of border, if any, you want for RPUF.";

  -- ---------------------------------------------------------------------
  -- scales
  L["CONFIG_FOCUSFRAME_SCALE"           ] = "Focus Frame Scale";
  L["CONFIG_FOCUSFRAME_SCALE_TT"        ] = "Adjust the relative scale of the RPUF focus frame so it takes up more or less space on your screen.";
  L["CONFIG_PLAYERFRAME_SCALE"          ] = "Player Frame Scale";
  L["CONFIG_PLAYERFRAME_SCALE_TT"       ] = "Adjust the relative scale of the RPUF player frame so it takes up more or less space on your screen.";
  L["CONFIG_TARGETFRAME_SCALE"          ] = "Target Frame Scale";
  L["CONFIG_TARGETFRAME_SCALE_TT"       ] = "Adjust the relative scale of the RPUF target frame so it takes up more or less space on your screen.";
  L["CONFIG_TARGETTARGETFRAME_SCALE"    ] = "TargetTarget Frame Scale";
  L["CONFIG_TARGETTARGETFRAME_SCALE_TT" ] = "Adjust the relative scale of the RPUF target-of-target frame so it takes up more or less space on your screen.";
  -- layouts
  L["CONFIG_TARGETLAYOUT"               ] = "Target Frame Layout";
  L["CONFIG_TARGETLAYOUT_TT"            ] = "Choose the layout for the target unit frame.";
  L["CONFIG_TARGETTARGETLAYOUT"         ] = "Target-of-Target Frame Layout";
  L["CONFIG_TARGETTARGETLAYOUT_TT"      ] = "Choose the layout for the target-of-target unit frame.";
  L["CONFIG_FOCUSLAYOUT"                ] = "Focus Frame Layout";
  L["CONFIG_FOCUSLAYOUT_TT"             ] = "Choose the layout for your focus unit frame.";
  L["CONFIG_PLAYERLAYOUT"               ] = "Player Frame Layout";
  L["CONFIG_PLAYERLAYOUT_TT"            ] = "Choose the layout for the player (that's you) unit frame.";

  -- visibility
  -- 
  L["CONFIG_DETAIL_TOOLTIP"             ] = "Details Panel Tooltip";
  L["CONFIG_DETAIL_TOOLTIP_TT"          ] = "Set the tags for the 'details' panel tooltip.";
  L["CONFIG_DETAILPANEL"                ] = "Details Panel";
  L["CONFIG_DETAILPANEL_TT"             ] = "Set the tags for the 'details' panel.";
  L["CONFIG_DISABLE_BLIZZARD"           ] = "Disable Blizzard Unit Frames";
  L["CONFIG_DISABLE_BLIZZARD_TT"        ] = "You can disable Blizzard's unit frames. Don't worry, you can get them back by unchecking this button! |cffdd0000Warning:|r Changing this option will load the game.";
  L["CONFIG_DISABLE_RPUF"               ] = "Disable RPUF";
  L["CONFIG_DISABLE_RPUF_TT"            ] = "You can disable RPUF without disabling all of RPTAGS. One reason you might want to do this would be if you are running [[Elvui                                                                               ]      ] and don't need to use RPUF to display RPTAGS.";
  L["CONFIG_ICON_1"                     ] = "Icon Slot 1";
  L["CONFIG_ICON_1_TOOLTIP"             ] = "Icon Slot 1 Tooltip";
  L["CONFIG_ICON_1_TOOLTIP_TT"          ] = "Set the tags for the first icon slot tooltip.";
  L["CONFIG_ICON_1_TT"                  ] = "Set the icon for the first icon slot. You should use icon tags.";
  L["CONFIG_ICON_2"                     ] = "Icon Slot 2";
  L["CONFIG_ICON_2_TOOLTIP"             ] = "Icon Slot 2 Tooltip";
  L["CONFIG_ICON_2_TOOLTIP_TT"          ] = "Set the tags for the first icon slot tooltip.";
  L["CONFIG_ICON_2_TT"                  ] = "Set the icon for the second icon slot. You should use icon tags.";
  L["CONFIG_ICON_3"                     ] = "Icon Slot 3";
  L["CONFIG_ICON_3_TOOLTIP"             ] = "Icon Slot 3 Tooltip";
  L["CONFIG_ICON_3_TOOLTIP_TT"          ] = "Set the tags for the first icon slot tooltip.";
  L["CONFIG_ICON_3_TT"                  ] = "Set the icon for the third icon slot. You should use icon tags.";
  L["CONFIG_ICON_4"                     ] = "Icon Slot 4";
  L["CONFIG_ICON_4_TOOLTIP"             ] = "Icon Slot 4 Tooltip";
  L["CONFIG_ICON_4_TOOLTIP_TT"          ] = "Set the tags for the first icon slot tooltip.";
  L["CONFIG_ICON_4_TT"                  ] = "Set the icon for the fourth icon slot. You should use icon tags.";
  L["CONFIG_ICON_5"                     ] = "Icon Slot 5";
  L["CONFIG_ICON_5_TOOLTIP"             ] = "Icon Slot 5 Tooltip";
  L["CONFIG_ICON_5_TOOLTIP_TT"          ] = "Set the tags for the first icon slot tooltip.";
  L["CONFIG_ICON_5_TT"                  ] = "Set the icon for the fifth icon slot. You should use icon tags.";
  L["CONFIG_ICON_6"                     ] = "Icon Slot 6";
  L["CONFIG_ICON_6_TOOLTIP"             ] = "Icon Slot 6 Tooltip";
  L["CONFIG_ICON_6_TOOLTIP_TT"          ] = "Set the tags for the first icon slot tooltip.";
  L["CONFIG_ICON_6_TT"                  ] = "Set the icon for the sixth icon slot. You should use icon tags.";
  L["CONFIG_INFOPANEL"                  ] = "Info Panel";
  L["CONFIG_INFOPANEL_TT"               ] = "Set the tags for the 'info' panel.";
  L["CONFIG_INFO_TOOLTIP"               ] = "Info Panel Tooltip";
  L["CONFIG_INFO_TOOLTIP_TT"            ] = "Set the tags for the 'info' panel tooltip.";
  L["CONFIG_LOCK_FRAMES"                ] = "Lock Frames";
  L["CONFIG_LOCK_FRAMES_TT"             ] = "Lock the unit frames so they can't be moved.";
  L["CONFIG_NAMEPANEL"                  ] = "Name Panel";
  L["CONFIG_NAMEPANEL_TT"               ] = "Set the tags for the 'name' panel. You don't have to use name tags.";
  L["CONFIG_NAME_TOOLTIP"               ] = "Name Panel Tooltip";
  L["CONFIG_NAME_TOOLTIP_TT"            ] = "Set the tags for the 'name' panel tooltip.";
  L["CONFIG_PORTRAIT"                   ] = "Portrait";
  L["CONFIG_PORTRAIT_TT"                ] = "Set the tags for the portrait.";
  L["CONFIG_PORTRAIT_TOOLTIP"           ] = "Portrait Tooltip";
  L["CONFIG_PORTRAIT_TOOLTIP_TT"        ] = "Set the tags for the portrait tooltip.";
  L["CONFIG_RESET_FRAME_LOCATIONS"      ] = "Reset Frame Locations";
  L["CONFIG_RESET_FRAME_LOCATIONS_TT"   ] = "Set all frames back to their default locations.";
  L["CONFIG_RESET_THESE_VALUES"         ] = "Reset These Values";
  L["CONFIG_RESET_THESE_VALUES_TT"      ] = "Set the displayed values back to their default values.";


  L["CONFIG_STATUSPANEL"                ] = "Status Panel";
  L["CONFIG_STATUSPANEL_TT"             ] = "Set the tags for the 'status' panel. You don't have to use status tags.";
  L["CONFIG_STATUS_TOOLTIP"             ] = "Status Panel Tooltip";
  L["CONFIG_STATUS_TOOLTIP_TT"          ] = "Set the tags for the 'status' panel tooltip.";
  L["CONFIG_UNLOCK_FRAMES"              ] = "Unlock Frames";
    -- --- editor settings
  L["CONFIG_EDITOR_FONT"                ] = "Editor Font";
  L["CONFIG_EDITOR_FONT_TT"             ] = "Select a font to use in the " .. EDITOR .. ".";
  L["CONFIG_EDITOR_FONTSIZE"            ] = "Font Size";
  L["CONFIG_EDITOR_FONTSIZE_TT"         ] = "Select the font size for the " .. EDITOR .. ".";
  L["CONFIG_EDITOR_BUTTON_BAR"          ] = "Show Tag Button Bar";
  L["CONFIG_EDITOR_BUTTON_BAR_TT"       ] = "Choose whether the tag button bar is shown in the " .. EDITOR .. ".";
  L["CONFIG_EDITOR_BUTTONS"             ] = "Buttons";
  L["CONFIG_EDITOR_BUTTONS_TT"          ] = "Choose which buttons to show in the " .. EDITOR .. ".";
    -- --- layouts
  L["RPUF_ABRIDGED"                   ] = "Standard";
  L["RPUF_COMPACT"                    ] = "Compact";
  L["RPUF_FULL"                       ] = "Detailed";
  L["RPUF_HIDDEN"                     ] = "Do not display";
  L["RPUF_PAPERDOLL"                  ] = "Portrait";
  L["RPUF_THUMBNAIL"                  ] = "Thumbnail";
    -- --- alignments
  L["BOTTOM"                            ] = "Bottom";
  L["BOTTOMLEFT"                        ] = "Bottom Left";
  L["BOTTOMRIGHT"                       ] = "Bottom Right";
  L["CENTER"                            ] = "Center";
  L["HORIZONTAL"                        ] = "Horizontal";
  L["LEFT"                              ] = "Left";
  L["RIGHT"                             ] = "Right";
  L["TOP"                               ] = "Top";
  L["TOPLEFT"                           ] = "Top Left";
  L["TOPRIGHT"                          ] = "Top Right";
  L["VERTICAL"                          ] = "Vertical";
    -- --- textures
  L["BACKDROP_BLIZZTOOLTIP"             ] = "Border";
  L["BACKDROP_ORIGINAL"                 ] = "No Border";
  L["BACKDROP_THICK_LINE"               ] = "Thick Line";
  L["BACKDROP_THIN_LINE"                ] = "Thin Line";
  L["THICK_LINE"                        ] = "Thick Line";
  L["THIN_LINE"                         ] = "Thin Line";
  L["SKILLS"                            ] = "Skills Bar";
  L["SOLID"                             ] = "Solid";
  L["RAID"                              ] = "Raid Bar";
  L["STATUS_BAR"                        ] = "Status Bar";
  L["SHADED"                            ] = "Shaded";
  L["BAR"                               ] = "Progress Bar";
  L["BLANK"                             ] = "Blank";
  L["PORTRAIT_2D"                       ] = "2D Portrait";
  L["PORTRAIT_3D"                       ] = "3D Model";

  for _, tag in ipairs(RPTAGS.CONST.RPUF.EDITOR_BUTTON_LIST)
  do  L["CONFIG_EDITOR_BUTTON_" .. tag:upper():gsub("[:%-]","")]
        = EDITOR .. BUTTON .. tag;
  end;

  L["INTRO_RPUF_MD"] = 
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
  
end);
  

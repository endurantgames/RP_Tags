-- ------------------------------------------------------------------------------
-- RP Tags 
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. To view a copy of the license, visit
--
--     https://creativecommons.org/licenses/by/4.0/

local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule("RP_Tags_totalRP3");

Module:WaitUntil("DATA_CONFIG",
function (self, event, ...)
    local KEYS = {      -- these are going away although there is still some code that refers to Keys[key] or whatever
        ADULT_GENDERS      = "rptags_adult_gender",
        CHANGES_MESSAGE    = "rptags_changes_message",
        COLOR_EQUALISH     = "rptags_color_equalish",
        COLOR_FEMALE       = "rptags_gendercolor_female",
        COLOR_GREATERTHAN  = "rptags_color_greaterthan",
        COLOR_HILITE_1     = "rptags_color_hilite_1",
        COLOR_HILITE_2     = "rptags_color_hilite_2",
        COLOR_HILITE_3     = "rptags_color_hilite_3",
        COLOR_IC           = "rptags_color_status_ic",
        COLOR_LESSTHAN     = "rptags_color_lessthan",
        COLOR_MALE         = "rptags_gendercolor_male",
        COLOR_NEUTER       = "rptags_gendercolor_neuter",
        COLOR_NPC          = "rptags_color_status_npc",
        COLOR_OOC          = "rptags_color_status_ooc",
        COLOR_RPUF         = "rptags_rpuf_frame_background_color",
        COLOR_RPUF_TEXT    = "rptags_rpuf_frame_text_color", 
        COLOR_RPUF_TOOLTIP = "rptags_rpuf_frame_tooltip_text_color",
        COLOR_THEY         = "rptags_gendercolor_they",
        COLOR_UNKNOWN      = "rptags_color_unknown",
        DETAILHEIGHT       = "rptags_rpuf_details_panel_height",
        DETAILPANEL        = "rptags_rpuf_details_panel_contents",
        DETAIL_TOOLTIP     = "rptags_rpuf_tooltips_details_panel",
        DISABLE_BLIZZARD   = "rptags_rpuf_disable_blizzard",
        DISABLE_RPUF       = "rptags_rpuf_disable_rp_unitframes",
        FOCUSLAYOUT        = "rptags_rpuf_focus_and_targettarget_layout",
        GAPSIZE            = "rptags_rpuf_layout_gap_size",
        GLANCE_COLON       = "rptags_at_first_glance_colon",
        GLANCE_DELIM       = "rptags_at_first_glance_delimiter",
        ICONWIDTH          = "rptags_rpuf_icon_panel_width",
        ICON_1             = "rptags_rpuf_icon_1_slot_contents",
        ICON_1_TOOLTIP     = "rptags_rpuf_tooltips_icon_slot_1",
        ICON_2             = "rptags_rpuf_icon_2_slot_contents",
        ICON_2_TOOLTIP     = "rptags_rpuf_tooltips_icon_slot_2",
        ICON_3             = "rptags_rpuf_icon_3_slot_contents",
        ICON_3_TOOLTIP     = "rptags_rpuf_tooltips_icon_slot_3",
        ICON_4             = "rptags_rpuf_icon_4_slot_contents",
        ICON_4_TOOLTIP     = "rptags_rpuf_tooltips_icon_slot_4",
        ICON_5             = "rptags_rpuf_icon_5_slot_contents",
        ICON_5_TOOLTIP     = "rptags_rpuf_tooltips_icon_slot_5",
        ICON_6             = "rptags_rpuf_icon_6_slot_contents",
        ICON_6_TOOLTIP     = "rptags_rpuf_tooltips_icon_slot_6",
        INFOPANEL          = "rptags_rpuf_info_panel_contents",
        INFOWIDTH          = "rptags_rpuf_info_panel_width",
        INFO_TOOLTIP       = "rptags_rpuf_tooltips_info_panel",
        LINEBREAKS         = "rptags_linebreaks",
        LOCK_FRAMES        = "rptags_rpuf_lock_frames", 
        LOGIN_MESSAGE      = "rptags_login_message",
        NAMEPANEL          = "rptags_rpuf_name_panel_contents",
        NAME_TOOLTIP       = "rptags_rpuf_tooltips_name_panel",
        NOTE_1_ICON        = "rptags_notes_alert_1_icon",
        NOTE_1_STRING      = "rptags_notes_alert_1",
        NOTE_2_ICON        = "rptags_notes_alert_2_icon",
        NOTE_2_STRING      = "rptags_notes_alert_2",
        NOTE_3_ICON        = "rptags_notes_alert_3_icon",
        NOTE_3_STRING      = "rptags_notes_alert_3",
        PARSE_AGE          = "rptags_parse_age",
        PARSE_GENDER       = "rptags_parse_gender",
        PARSE_HW           = "rptags_parse_height_weight",
        PLAYERLAYOUT       = "rptags_rpuf_player_layout",
        PORTRAIT_TOOLTIP   = "rptags_rpuf_tooltips_portrait",
        PORTRAIT_TYPE      = "rptags_rpuf_portrait_type_camera",
        PORTWIDTH          = "rptags_rpuf_portrait_width",
        PROFILESIZE_FMT    = "rptags_profilesize_format",
        REAL_ELLIPSES      = "rptags_real_ellipses",
        REFERENCE_TOPIC    = "rptags_reference_topic",
        RESET_COLORS       = "rptags_colors_reset",
        RESET_FRAMES       = "rptags_rpuf_reset_frame_dimensions",
        RESET_TAGS         = "rptags_rpuf_reset_tag_values",
        RPUFALPHA          = "rptags_rpuf_alpha",
        RPUF_BACKDROP      = "rptags_rpuf_backdrop_texture",
        RPUF_HIDE_COMBAT   = "rptags_rpuf_hide_in_combat",
        RPUF_HIDE_PETBATTLE   = "rptags_rpuf_hide_in_petbattle",
        RPUF_HIDE_PARTY    = "rptags_rpuf_hide_in_party",
        RPUF_HIDE_VEHICLE  = "rptags_rpuf_hide_in_vehicle",
        RPUF_HIDE_DEAD     = "rptags_rpuf_hide_when_dead",
        RPUF_HIDE_RAID     = "rptags_rpuf_hide_in_raid",
        RPUF_WITH_ELVUI    = "rptags_rpuf_runs_with_elvui",
        SIZEBUFF_FMT       = "rptags_sizebuffs_format",
        STATUSHEIGHT       = "rptags_rpuf_status_panel_height",
        STATUSPANEL        = "rptags_rpuf_status_panel_contents",
        STATUS_TOOLTIP     = "rptags_rpuf_tooltips_statusbar_panel",
        TARGETLAYOUT       = "rptags_rpuf_target_layout",
        UNITS_HEIGHT       = "rptags_units_height",
        UNITS_WEIGHT       = "rptags_units_weight",
  
        PLAYERFRAME_SCALE  = "rptags_rpuf_player_frame_scaling_factor",
        TARGETFRAME_SCALE  = "rptags_rpuf_target_frame_scaling_factor",
        FOCUSFRAME_SCALE   = "rptags_rpuf_focus_frame_scaling_factor",
        UNSUP_TAG          = "rptags_tag_unsupported_by_rp_client",
  
        PARTYLAYOUT        = "rptags_rpuf_party_and_raid_layout",  -- not yet implemented
        RAIDLAYOUT         = "rptags_rpuf_raid_layout",            -- not yet implemented
        PARTY_ORIENTATION  = "rptags_rpuf_party_orientation",
        RAID_GRID          = "rptags_rpuf_raid_grid",
        STATUS_TEXTURE     = "rptags_rpuf_status_bar_texture", 
        STATUS_ALIGN       = "rptags_rpuf_status_bar_alignment",
        PORTRAIT_STYLE     = "rptags_rpuf_portrait_style",
      }; -- KEYS
  
      if   not RP_TagsDB.TRP3_Config_Imported
      then local register = TRP3_API.configuration.registerConfigKey;
           for setting, key in pairs(KEYS)
           do  if    setting and key 
               then  TRP3_API.configuration.registerConfigKey(key, RPTAGS.CONST.CONFIG.DEFAULT[setting]); 
               -- trp3 has to be aware of these tags to get the values from them
                     local value = TRP3_API.configuration.getValue(key);
                     if    RP_TagsDB.settings[setting].trp3key == key         -- just make sure we are importing the same setting
                     then  RP_TagsDB.settings[setting].value   =  value;
                           -- TRP3_API.configuration.setValue(nil); -- clean it out of the user's settings -- hey that sounds dangerous!
                     end;  --if
               end;  -- if setting, key
           end; -- for setting, key
           RP_TagsDB.TRP3_Config_Imported    = true;
           RPTAGS.cache.TRP3_Config_Imported = true;
      end; --  if not already imported
  
  end -- function
);

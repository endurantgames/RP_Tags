-- ------------------------------------------------------------------------------
-- RP Tags
-- by Oraibi, Moon Guard (US) server
--
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. To view a copy of the license, visit
--
--     https://creativecommons.org/licenses/by/4.0/
--
local addOnName, addOn = ...
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:NewModule(addOnName, "unitFrames")

Module:WaitUntil("ADDON_LOAD",
function(self, event, ...)
  
    local E, _, _, P, _, _  = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB

    local RPT       = E:NewModule('rp:tags', 'AceHook-3.0');
    local EP        = LibStub("LibElvUIPlugin-1.0")
    -- local UF        = E:GetModule('UnitFrames');
    --
    RPT.version     = RPTAGS.utils.locale.loc("APP_VERSION");
    RPT.versionMinE = 10.49
    RPT.title       = RPTAGS.utils.locale.loc("APP_NAME");
    P['RPT']        = { ['enable'] = false, }
      
    function RPT:Initialize() 
      EP:RegisterPlugin(
        RPTAGS.addOnName, 
        RPT.InsertOptions) 
    end;

    E:RegisterModule(RPT:GetName())
end);

Module:WaitUntil("UTILS_TAGS",
function(self, event, ...)

    local MAP = 
    { GROUP = 
      { COLORS = "Colors",
        GENDER = "Names",
        SERVER = "Realm",
        TARGET = "Target",
      },
      TAG = 
      { ["rp:name"           ] = "Names",
        ["rp:firstname"      ] = "Names",
        ["rp:lastname"       ] = "Names",
        ["rp:name-known"     ] = "Names",
        ["rp:nick"           ] = "Names",
        ["rp:nick-quoted"    ] = "Names",
        ["rp:title"          ] = "Names",
        ["rp:fulltitle"      ] = "Names",
        ["rp:pvpicon"        ] = "PvP",
        ["rp:pvpicon-square" ] = "PvP",
        ["rp:xp-icon"        ] = "Level",
        ["rp:rookie-icon"    ] = "Level",
        ["rp:volunteer-icon" ] = "Level",
        ["rp:status"         ] = "Status",
        ["rp:ic"             ] = "Status",
        ["rp:ooc"            ] = "Status",
        ["rp:npc"            ] = "Classification",
        ["rp:open"           ] = "Status",
        ["rp:storyteller"    ] = "Status",
        ["rp:curr"           ] = "Status",
        ["rp:info"           ] = "Status",
        ["rp:experience"     ] = "Level",
        ["rp:xp"             ] = "Level",
        ["rp:rookie"         ] = "Level",
        ["rp:volunteer"      ] = "Level",
        ["rp:family"         ] = "Guild",
        ["rp:house"          ] = "Guild",
        ["rp:guild"          ] = "Guild",
        ["rp:guild-rank"     ] = "Guild",
        ["rp:guild-status"   ] = "Guild",
        ["rp:tribe"          ] = "Guild",
      }, -- beep
    };

    local E, _, _, _, _, _  = unpack(_G["ElvUI"]); 
    -- local UF                = E:GetModule('UnitFrames');

    -- registers one tag, an event to wait for, and a method to invoke when found --------------------------
    local function registerTag(tag, tagMethod, extraEvents)
      local events = RPTAGS.CONST.MAIN_EVENT .. (extraEvents or "");

      if not _G["ElvUF"].Tags.Events[tag] -- only make the tag if there isn't one by that name already
      then   _G["ElvUF"].Tags.Events[tag] = RPTAGS.CONST.MAIN_EVENT .. (extraEvents or "");
             _G["ElvUF"].Tags.Methods[tag] = tagMethod;
      end;
    end; -- function
    
    local function addTag(tag, group)
       if   tag and group
       then local tagDesc = tag.desc;
            if RPTAGS.CONST.UNSUP[tag.name] 
            then tagDesc = "|cff" .. RPTAGS.utils.config.get("COLOR_UNKNOWN") .. tagDesc .. "|r" 
            end;
            E:AddTagInfo(tag.name, MAP.TAG[tag.name] or MAP.GROUP[group.key] or group.title, tagDesc);
       end;
    end;

    RPTAGS.utils.modules.extend({ 
        ["tags.registerTag"] = registerTag,
        ["tags.addTag"]      = addTag,
    });

end);

Module:WaitUntil("UTILS_FRAMES",
function(Self, event, ...)

  local E, _, _, _, _, _  = unpack(_G["ElvUI"]); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
  local UF                = E:GetModule('UnitFrames');
  
  local function refreshFrame(frame)
    if     frame == "party" then UF:CreateAndUpdateHeaderGroup('party');
    elseif frame == "raid"  then UF:CreateAndUpdateHeaderGroup("raid")
    else                         UF:CreateAndUpdateUF(frame);
    end; -- if
  end;

  local function refreshAll() 
    UF:Update_AllFrames(); 
  end;

  RPTAGS.utils.modules.extend(
  { ["frames.refresh"] = refreshFrame,
    ["frames.refreshAll"] = refreshAll, 
  });

end);


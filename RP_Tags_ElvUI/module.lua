-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. 
local addOnName, ns = ...
local RPTAGS        = RPTAGS;
local Module        = RPTAGS.queue:NewModule(addOnName, "unitFrames")

Module:WaitUntil("ADDON_INIT",
function(self, event, ...)
  RPTAGS.cache = RPTAGS.cache or {};
  RPTAGS.cache.workAround = RPTAGS.cache.workAround or {};
end);

Module:WaitUntil("ADDON_LOAD",
function(self, event, ...)

  local E, _, _, P, _, _  = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB

  local RPT       = E:NewModule('rp:tags', 'AceHook-3.0');
  local EP        = LibStub("LibElvUIPlugin-1.0")
  -- local UF        = E:GetModule('UnitFrames');
  --
  RPT.version     = RPTAGS.utils.locale.loc("APP_VERSION");
  RPT.versionMinE = 12.2
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
    }, 
  };

  local E, _, _, _, _, _  = unpack(_G["ElvUI"]); 
  -- local UF                = E:GetModule('UnitFrames');

  if not RPTAGS.oUF then RPTAGS.oUF = ElvUF; end;

  -- registers one tag, an event to wait for, and a method to invoke when found --------------------------
  local function registerTag(tagName, tagMethod, tagExtraEvents)

    local Events  = _G["ElvUF"].Tags.Events;
    local Methods = _G["ElvUF"].Tags.Methods;

    if not Events[tagName] -- only make the tag if there isn't one by that name already
    then   Events[tagName] = 
             RPTAGS.CONST.MAIN_EVENT .. 
             (tagExtraEvents and (" " .. tagExtraEvents) or "");
           Methods[tagName] = tagMethod;
    end;

    return tagName, tagMethod, tagExtraEvents;
  end; -- function
  
  local function addTag(tag, group)
   
    if   tag and tag.name and not tag.external and group and not group.external
    then local tagDesc = tag.desc;
         if RPTAGS.CONST.UNSUP[tag.name] 
         then tagDesc = "|cff" .. RPTAGS.utils.config.get("COLOR_UNKNOWN") .. tagDesc .. "|r" 
         end;
         E:AddTagInfo(tag.name, MAP.TAG[tag.name] or MAP.GROUP[group.key] or group.title, tagDesc);
    end;
    return tag, group;
  end;

  local function registerTagSizeVariants(tagName, tagMethod, tagExtraEvents)
    local sizeTrim = RPTAGS.utils.text.sizeTrim;
    local sizes = { "xs", "s", "m", "l", "xl",
                    "extrasmall", "small", "medium", "large",
                    "extralarge", "extra-small", "extra-large" };
    for _, size in ipairs(sizes)
    do  RPTAGS.utils.tags.registerTag(
          tagName .. "(" .. size .. ")",
          function(...) return sizeTrim(tagMethod( ... ), size) end,
          tagExtraEvents
        );
    end;
    RPTAGS.utils.tags.registerTag(tagName, tagMethod, tagExtraEvents);
    return tagName, tagMethod, tagExtraEvents;
  end;

  RPTAGS.utils.modules.extend(
  { ["tags.registerTag"  ] = registerTag,
    ["tags.addTag"       ] = addTag,
    ["tags.sizeVariants" ] = registerTagSizeVariants,
  });

end);

Module:WaitUntil("MODULE_C",
function(self, event, ...)
  local registerFunction = RPTAGS.utils.modules.registerFunction;
  local E, _, _, _, _ = unpack(_G["ElvUI"]);

  registerFunction("ElvUI", "options",    function() E:ToggleOptionsUI()  end);
  registerFunction("ElvUI", "version",    function() E:ShowStatusReport() end);
  registerFunction("ElvUI", "about",      function() E:ShowStatusReport() end);
  registerFunction("ElvUI", "help",       function() E:EHelp()            end);
  registerFunction("ElvUI", "moveframes", function() E:ToggleMoveMode()   end);

end);

Module:WaitUntil("before DATA OPTIONS",
function(self, event, ...)
  RPTAGS.utils.modules.registerFunction("ElvUI", "options",
    function() 
      ElvUI[1]:ToggleOptionsUI();
    end);
end);

Module:WaitUntil("UTILS_FRAMES",
function(self, event, ...)

  local E, _, _, _, _, _  = unpack(_G["ElvUI"]); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
  local UF                = E:GetModule('UnitFrames');
  
  local function refreshFrame(frame)
    if     frame == "party" then UF:CreateAndUpdateHeaderGroup('party');
    elseif frame == "raid"  then UF:CreateAndUpdateHeaderGroup("raid")
    else                         UF:CreateAndUpdateUF(frame);
    end; -- if
    return frame;
  end;

  local function refreshAll(...) 
    UF:Update_AllFrames(); 
    return ...;
  end;

  RPTAGS.utils.modules.extend(
  { ["frames.refresh"]    = refreshFrame,
    ["frames.refreshAll"] = refreshAll, 
  });

end);


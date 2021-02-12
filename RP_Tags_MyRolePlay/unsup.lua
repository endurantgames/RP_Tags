-- ------------------------------------------------------------------------------
-- RP Tags 
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. To view a copy of the license, visit
--
--     https://creativecommons.org/licenses/by/4.0/

local addOnName, ns = ...
local RPTAGS        = RPTAGS;
local Module        = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("DATA_CONST",
function(self, event, ...)

  local UNSUP = RPTAGS.CONST.UNSUP;
  UNSUP["rp:actor"              ] = "unsup";
  UNSUP["rp:bodyclaim"          ] = "unsup";
  UNSUP["rp:faceclaim"          ] = "unsup";
  UNSUP["rp:markings"           ] = "unsup";
  UNSUP["rp:note-1"             ] = "unsup";
  UNSUP["rp:note-2"             ] = "unsup";
  UNSUP["rp:note-3"             ] = "unsup";
  UNSUP["rp:physiognomy"        ] = "unsup";
  UNSUP["rp:piercings"          ] = "unsup";
  UNSUP["rp:relation"           ] = "unsup";
  UNSUP["rp:relation-who"       ] = "unsup";
  UNSUP["rp:religion"           ] = "unsup";
  UNSUP["rp:style-ask"          ] = "unsup";
  UNSUP["rp:style-battle"       ] = "unsup";
  UNSUP["rp:style-battle-long"  ] = "unsup";
  UNSUP["rp:style-death"        ] = "unsup";
  UNSUP["rp:style-death-long"   ] = "unsup";
  UNSUP["rp:style-guild"        ] = "unsup";
  UNSUP["rp:style-guild-long"   ] = "unsup";
  UNSUP["rp:style-injury"       ] = "unsup";
  UNSUP["rp:style-injury-long"  ] = "unsup";
  UNSUP["rp:style-no"           ] = "unsup";
  UNSUP["rp:style-romance"      ] = "unsup";
  UNSUP["rp:style-romance-long" ] = "unsup";
  UNSUP["rp:tattoos"            ] = "unsup";
  UNSUP["rp:voiceclaim"         ] = "unsup";

end);

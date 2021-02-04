local RPTAGS = RPTAGS;
RPTAGS.queue:WaitUntil("UTILS_FRAMES",
function(self, event, ...)
-- RPQ ------------------------------------------------------------------------------------------------------------------------
  -- these will be extended by UF-specific functions
  local function refreshFrame(...) return ... end;
  local function refreshAll(...)   return ... end;
 
  RPTAGS.utils.frames            = RPTAGS.utils.frames or {};
  RPTAGS.utils.frames.refresh    = refreshFrame;
  RPTAGS.utils.frames.refreshAll = refreshAll;

-- RPQ -----------------------------------------------------------------------------------------------------------------------
end);


local RPTAGS = RPTAGS;

-- file for miscellaneous functions that need to go off
-- format for the event is usually:
--
--   after:EVENT_NAME
--
RPTAGS.queue:WaitUntil("after:DATA_LOCALE",
function(self, event, ...)
  RPTAGS.utils.locale.load();
end);

RPTAGS.queue:WaitUntil("after:DATA_TAGS",
function(self, event, ...)
RPTAGS.utils.tags.addAllTags();
end);

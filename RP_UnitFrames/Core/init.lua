local RPTAGS                        = RPTAGS
local addOnName, ns                 = ...;

Module                              = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("ADDON_INIT",
function(self, event, ...)

  _G["RP_UnitFramesDB"]  = RP_UnitFramesDB        or {}
  RP_UnitFramesDB.coords = RP_UnitFramesDB.coords or {}

end);

Module:WaitUntil("INIT_UTILS",
function(self, event, ...)

  RPTAGS.utils.tags                 = RPTAGS.utils.tags                  or {};
  RPTAGS.utils.frames               = RPTAGS.utils.frames                or {};
  RPTAGS.utils.frames.all           = RPTAGS.utils.frames.all            or {};

  local frameUtils                  = RPTAGS.utils.frames;
  local allFrameUtils               = RPTAGS.utils.frames.all;

  frameUtils.content                = frameUtils.content                or {};
  frameUtils.content.all            = frameUtils.content.all            or {};
  frameUtils.layout                 = frameUtils.layout                 or {};
  frameUtils.look                   = frameUtils.look                   or {};
  frameUtils.look.backdrop          = frameUtils.look.backdrop          or {};
  frameUtils.look.colors            = frameUtils.look.colors            or {};
  frameUtils.look.status            = frameUtils.look.status            or {};
  frameUtils.look.status.align      = frameUtils.look.status.align      or {};
  frameUtils.look.status.texture    = frameUtils.look.status.texture    or {};
  frameUtils.move                   = frameUtils.move                   or {};
  frameUtils.panels                 = frameUtils.panels                 or {};
  frameUtils.panels.align           = frameUtils.panels.align           or {};
  frameUtils.panels.all             = frameUtils.panels.all             or {};
  frameUtils.panels.all.content     = frameUtils.panels.all.content     or {};
  frameUtils.panels.all.layout      = frameUtils.panels.all.layout      or {};
  frameUtils.panels.all.size        = frameUtils.panels.all.size        or {};
  frameUtils.panels.content         = frameUtils.panels.content         or {};
  frameUtils.panels.layout          = frameUtils.panels.layout          or {};
  frameUtils.panels.size            = frameUtils.panels.size            or {};
  frameUtils.size                   = frameUtils.size                   or {};
  frameUtils.size.scale             = frameUtils.size.scale             or {};
  frameUtils.visibility             = frameUtils.visibility             or {};
  frameUtils.font                   = frameUtils.font                   or {};

  allFrameUtils.content             = allFrameUtils.content             or {};
  allFrameUtils.content.all         = allFrameUtils.content.all         or {};
  allFrameUtils.layout              = allFrameUtils.layout              or {};
  allFrameUtils.look                = allFrameUtils.look                or {};
  allFrameUtils.look.backdrop       = allFrameUtils.look.backdrop       or {};
  allFrameUtils.look.colors         = allFrameUtils.look.colors         or {};
  allFrameUtils.look.status         = allFrameUtils.look.status         or {};
  allFrameUtils.look.status.align   = allFrameUtils.look.status.align   or {};
  allFrameUtils.look.status.texture = allFrameUtils.look.status.texture or {};
  allFrameUtils.move                = allFrameUtils.move                or {};
  allFrameUtils.panels              = allFrameUtils.panels              or {};
  allFrameUtils.panels.align        = allFrameUtils.panels.align        or {};
  allFrameUtils.panels.all          = allFrameUtils.panels.all          or {};
  allFrameUtils.panels.all.content  = allFrameUtils.panels.all.content  or {};
  allFrameUtils.panels.all.layout   = allFrameUtils.panels.all.layout   or {};
  allFrameUtils.panels.all.size     = allFrameUtils.panels.all.size     or {};
  allFrameUtils.panels.content      = allFrameUtils.panels.content      or {};
  allFrameUtils.panels.layout       = allFrameUtils.panels.layout       or {};
  allFrameUtils.panels.size         = allFrameUtils.panels.size         or {};
  allFrameUtils.size                = allFrameUtils.size                or {};
  allFrameUtils.size.scale          = allFrameUtils.size.scale          or {};
  allFrameUtils.visibility          = allFrameUtils.visibility          or {};
end);

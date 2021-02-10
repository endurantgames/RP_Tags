local RPTAGS = RPTAGS;
local addOnName, ns = ...;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("MODULE POINT 2",
function(self, event, ...)
  local Editor = RPTAGS.cache.Editor;
  if not Editor then return "Error: no editor"; end;

  local Set = RPTAGS.utils.config.set;
  local Get = RPTAGS.utils.config.get;

  local loc = RPTAGS.utils.locale.loc;

  function Editor.Update(self)
    self.textbox:SetFocus();
    self.contentTitle:SetText(loc("CONFIG_" .. self.setting));
    self.displayBox:SetText(loc("CONFIG_" .. self.setting .. "_TT"));

    if   self.draft
    then self.textbox:SetText(self.draft)
         self.draft = nil;
    else self.textbox:SetText(
           Get(self.setting):gsub("%[p%]", "\n\n"):gsub("%[br%]", "\n");
         );
         self.testResults:SetText("");
         self.testResultsLabel:SetText(loc("TAG_EDIT_RESULTS"));
         self.testResultsLabel:SetTextColor(0.7, 0.7, 0.7);
    end;
  end;

  function Editor.EditTag(self, setting)
    self:Hide();
    if self.setting ~= self then self.draft = nil; end;
    self.setting = setting;
    RP_TagsDB.editor.last = setting;
    self:Update();
    self:Show();
  end;
    
end;

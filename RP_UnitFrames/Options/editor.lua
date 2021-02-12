local addOnName, ns = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("after MODULE_G",
function(self, event, ...)

  local loc               = RPTAGS.utils.locale.loc;
  local Get               = RPTAGS.utils.config.get;
  local Set               = RPTAGS.utils.config.set;
  local Default           = RPTAGS.utils.config.default;
  local addOptions        = RPTAGS.utils.modules.addOptions;
  local addOptionsPanel   = RPTAGS.utils.modules.addOptionsPanel;
  local source_order      = RPTAGS.utils.options.source_order;
  local Checkbox          = RPTAGS.utils.options.checkbox
  local Color_Picker      = RPTAGS.utils.options.color_picker
  local Common            = RPTAGS.utils.options.common
  local Dropdown          = RPTAGS.utils.options.dropdown
  local Header            = RPTAGS.utils.options.header
  local Instruct          = RPTAGS.utils.options.instruct
  local Keybind           = RPTAGS.utils.options.keybind
  local Pushbutton        = RPTAGS.utils.options.pushbutton
  local Spacer            = RPTAGS.utils.options.spacer
  local Reset             = RPTAGS.utils.options.reset
  local Frame_Scaler      = RPTAGS.utils.options.frame_scaler
  local Dim_Slider = RPTAGS.utils.options.dimensions_slider;
  local TagPanel          = RPTAGS.utils.options.tagpanel;
  local reqRPUF           = RPTAGS.utils.options.requiresRPUF;
  local collectionBrowser = RPTAGS.utils.options.collectionBrowser;
  local Font              = RPTAGS.utils.options.font;
  local split             = RPTAGS.utils.text.split;
  local listOfAllTags     = RPTAGS.utils.options.listOfAllTags;
  local ifConfig          = RPTAGS.utils.config.ifConfig;
  local Frame_Panel       = RPTAGS.utils.options.frame_panel;

  local menu = {};
  menu.backdrop  =
  { BLIZZTOOLTIP = loc("BACKDROP_BLIZZTOOLTIP" ),
    THIN_LINE    = loc("BACKDROP_ORIGINAL"     ),
    THICK_LINE   = loc("BACKDROP_THICK_LINE"   ),
    ORIGINAL     = loc("BACKDROP_THIN_LINE"    ), };
  menu.texture   =
  { BAR          = loc("BAR"                   ),
    SKILLS       = loc("SKILLS"                ),
    BLANK        = loc("BLANK"                 ),
    SHADED       = loc("SHADED"                ),
    SOLID        = loc("SOLID"                 ),
    RAID         = loc("RAID"                  ), };
  menu.align     =
  { LEFT         = loc("LEFT"                  ),
    CENTER       = loc("CENTER"                ),
    RIGHT        = loc("RIGHT"                 ), };
  menu.small     =
  { COMPACT      = loc("RPUF_COMPACT"          ),
    ABRIDGED     = loc("RPUF_ABRIDGED"         ),
    THUMBNAIL    = loc("RPUF_THUMBNAIL"        ), };
  menu.large     =
  { COMPACT      = loc("RPUF_COMPACT"          ),
    ABRIDGED     = loc("RPUF_ABRIDGED"         ),
    THUMBNAIL    = loc("RPUF_THUMBNAIL"        ),
    PAPERDOLL    = loc("RPUF_PAPERDOLL"        ),
    FULL         = loc("RPUF_FULL"             ), };


  addOptionsPanel("RPUF_Editor",
  { name                = loc("OPT_EDITOR"),
    order               = source_order(),
    type                = "group",
    args                = 
    { -- panel             = Header("editor", nil, reqRPUF ),
      instruct          = Instruct("editor", nil, reqRPUF ),
      useCustomFont     = Checkbox("editor custom font", nil, reqRPUF, true, true),
      customFont        = Font("config editor font", nil, function(self) return not reqRPUF() and not Get("EDITOR_CUSTOM_FONT") end),
      useButtonBar      = Checkbox("editor button bar", nil, reqRPUF),
      chooseButtons     = Pushbutton("editor buttons", nil, nil, 
                           function(self) return not Get("DISABLE_RPUF") and not Get("EDITOR_BUTTON_BAR") end, 
                            function(self)
                              Set("EDITOR_BUTTONS",
                                collectionBrowser(
                                  { current  = split(Get("EDITOR_BUTTONS"), "|"),
                                    all      = listOfAllTags(),
                                    defaults = split(Default("EDITOR_BUTTONS"), "|"), 
                                    nameFunc = function(str) return loc("TAG_" .. str .. "_NAME") end,
                                    descFunc = function(str) return loc("TAG_" .. str .. "_DESC") end,
                                  } -- params to collectionBrowser
                                )   -- collectionBrowser function call
                              ) -- Set function call
                            end -- "on pushed" function
                          ), -- Pushbutton function call
    }, -- tagEditor.args
  });
end);

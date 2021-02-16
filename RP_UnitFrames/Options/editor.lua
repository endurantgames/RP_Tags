local addOnName, ns = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("after MODULE_G",
function(self, event, ...)

  local Utils             = RPTAGS.utils
  local loc               = Utils.locale.loc;
  local getLabel          = Utils.locale.getLabel;
  local Config            = Utils.config
  local Get               = Config.get;
  local Set               = Config.set;
  local ifConfig          = Config.ifConfig;
  local Default           = Config.default;
  local buttonList        = RPTAGS.CONST.RPUF.EDITOR_BUTTON_LIST;
  local numButtons        = "EDITOR_NUM_BUTTONS";

  local split             = Utils.text.split;
  local addOptions        = Utils.modules.addOptions;
  local addOptionsPanel   = Utils.modules.addOptionsPanel;

  local optUtils          = Utils.options
  local source_order      = optUtils.source_order;
  local Blank_Line        = optUtils.blank_line
  local Checkbox          = optUtils.checkbox
  local Color_Picker      = optUtils.color_picker
  local Common            = optUtils.common
  local Dropdown          = optUtils.dropdown
  local Editor_Button     = optUtils.editor_button
  local Editor_Bar_Mockup = optUtils.editor_bar_mockup
  local Header            = optUtils.header
  local Instruct          = optUtils.instruct
  local Keybind           = optUtils.keybind
  local Pushbutton        = optUtils.pushbutton
  local Spacer            = optUtils.spacer
  local Reset             = optUtils.reset
  local Frame_Scaler      = optUtils.frame_scaler
  local Dim_Slider        = optUtils.dimensions_slider;
  local TagPanel          = optUtils.tagpanel;
  local reqRPUF           = optUtils.requiresRPUF;
  local collectionBrowser = optUtils.collectionBrowser;
  local Font              = optUtils.font;
  local listOfAllTags     = optUtils.listOfAllTags;
  local Frame_Panel       = optUtils.frame_panel;

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
      buttonBar =
      { type = "group",
        name = loc("OPT_EDITOR_BUTTON_BAR"),
        inline = true,
        order = source_order(),
        args = 
        { buttonBarinstruct = Instruct("editor button bar"),
          blank = Blank_Line(),
          uncheckAll =
          { type = "toggle",
            order = source_order(),
            name = "Uncheck All",
            get = function() return Get(numButtons) > 0 end,
            set = function()
                    for i, button in ipairs(buttonList)
                    do  Set("EDITOR_BUTTON_" .. button:upper():gsub("[:%-]",""), false);
                    end
                    Set(numButtons, 0);
                  end,
            disabled = function() return Get(numButtons) == 0 end,
          },
          barMockup = Editor_Bar_Mockup(),
          nameButtons =
          { type = "group",
            name = "Name Buttons",
            order = source_order(),
            inline = true,
            args = 
            { rpName = Editor_Button("rp:name"),
              rpFirstName = Editor_Button("rp:firstname"),
              rpLastName = Editor_Button("rp:lastname"),
              rpNickname = Editor_Button("rp:nick"),
            },
          },
          coreButtons =
          { type = "group",
            name = "Basic Details Buttons",
            order = source_order(),
            inline = true,
            args=
            { rpTitle = Editor_Button("rp:title"),
              rpFullTitle = Editor_Button("rp:fulltitle"),
              rpClass = Editor_Button("rp:class"),
              rpRace = Editor_Button("rp:race"),
              rpGender = Editor_Button("rp:gender"),
              rpPronouns = Editor_Button("rp:pronouns"),
              rpAge = Editor_Button("rp:age"),
              rpHeight = Editor_Button("rp:height"),
              rpWeight = Editor_Button("rp:weight"),
            },
          },
          statusButtons =
          { type = "group",
            name = "Status Buttons",
            order = source_order(),
            inline = true,
            args =
            { rpStatus = Editor_Button("rp:status"),
              rpIc = Editor_Button("rp:ic"),
              rpOoc = Editor_Button("rp:ooc"),
              rpNpc = Editor_Button("rp:npc"),
              rpCurr = Editor_Button("rp:curr"),
              rpOocInfo = Editor_Button("rp:info"),
            },
          },
          colorButtons =
          { type = "group",
            name = "Color Buttons",
            order = source_order(),
            inline = true,
            args =
            { rpColor = Editor_Button("rp:color"),
              rpEyeColor = Editor_Button("rp:eyecolor"),
              rpGenderColor = Editor_Button("rp:gendercolor"),
              rpRelationColor = Editor_Button("rp:relationcolor"),
              rpStatusColor = Editor_Button("rp:statuscolor"),
              rpAgeColor = Editor_Button("rp:agecolor"),
              rpHeightColor = Editor_Button("rp:heightcolor"),
              rpWeightColor = Editor_Button("rp:weightcolor"),
            },
          },
          iconButtons =
          { type = "group",
            name = "Icon Buttons",
            order = source_order(),
            inline = true,
            args =
            { rpIcon = Editor_Button("rp:icon"),
              rpGenderIcon = Editor_Button("rp:gendericon"),
              rpStatusIcon = Editor_Button("rp:statusicon"),
              rpRaceIcon = Editor_Button("rp:raceicon"),
              rpGlance1Icon = Editor_Button("rp:glance-1-icon"),
              rpGlance2Icon = Editor_Button("rp:glance-2-icon"),
              rpGlance3Icon = Editor_Button("rp:glance-3-icon"),
              rpGlance4Icon = Editor_Button("rp:glance-4-icon"),
              rpGlance5Icon = Editor_Button("rp:glance-5-icon"),
              rpGlance6Icon = Editor_Button("rp:glance-icons"),
            },
          },
          socialButtons =
          { type = "group",
            name = "Social Buttons",
            order = source_order(),
            inline = true,
            args =
            { rpAlignment = Editor_Button("rp:alignment"),
              rpBirthplace = Editor_Button("rp:birthplace"),
              rpFamily = Editor_Button("rp:family"),
              rpGuild = Editor_Button("rp:guild"),
              rpMotto = Editor_Button("rp:motto"),
              rpRstatus = Editor_Button("rp:rstatus"),
              rpHome = Editor_Button("rp:home"),
              rpSexuality = Editor_Button("rp:sexuality"),
            },
          },
          formattingButtons =
          { type = "group",
            name = "Formatting Buttons",
            order = source_order(),
            inline = true,
            args = 
            { formattingP = Editor_Button("p"),
              formattingBr = Editor_Button("br"),
            },
          },
        },
      },
    },
  });
    end);

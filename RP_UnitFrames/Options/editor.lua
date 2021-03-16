local addOnName, ns = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("after MODULE_G",
function(self, event, ...)

  local Utils             = RPTAGS.utils
  local Locale            = Utils.locale;
  local loc               = Locale.loc;
  local getLabel          = Locale.getLabel;
  local tagDesc           = Locale.tagDesc;
  local tagLabel          = Locale.tagLabel;
  local Config            = Utils.config
  local Get               = Config.get;
  local Set               = Config.set;
  local CONST             = RPTAGS.CONST;
  local buttonList        = CONST.RPUF.EDITOR_BUTTON_LIST;
  local fixedFonts        = RPTAGS.cache.Fonts.fixed;
  local Editor            = RPTAGS.Editor;

  local split             = Utils.text.split;
  local addOptions        = Utils.modules.addOptions;
  local addOptionsPanel   = Utils.modules.addOptionsPanel;

  local optUtils          = Utils.options
  local source_order      = optUtils.source_order;
  local Blank_Line        = optUtils.blank_line
  local Instruct          = optUtils.instruct
  local Spacer            = optUtils.spacer
  local Slider            = optUtils.slider;
  local reqRPUF           = optUtils.requiresRPUF;
  local Font              = optUtils.font;
  local Wide              = optUtils.set_width;
  local openEditor   = Config.openEditor;
  local Editor       = RPTAGS.Editor;

  local function refreshFont(widget)
    local setFunc = widget.set;
    widget.set = function(self, value) setFunc(self, value); Editor:LoadFont() end;
    return widget;
  end;

  local function build_editor_bar_button(str)
    local STR         = str:upper():gsub("[:%-]", "");
    local setting     = "EDITOR_BUTTON_" .. STR;
    local w           =
    { type            = "toggle",
      desc            = str,
      name            = loc("TAG_" .. str .. "_DESC"),
      order           = source_order(),
      get             = function() return Get(setting) end,
      disabled        = 
        function() 
          return (Editor:CountToolBar() >= CONST.RPUF.EDITOR_MAX_BUTTONS)
             and not Get(setting) 
        end,
      set             = 
        function(self, value)
          Set(setting, value);
          Editor:UpdateLayout();
        end,
    };

    return w;
  end;

  local function build_editor_bar_mockup(str)
    local w = 
    { name = "Editor Button Bar",
      type = "group",
      order = source_order(),
      inline = true,
      args = 
      { colorWheel =
        { type = "execute",
          name = RPTAGS.CONST.ICONS.COLORWHEEL,
          desc = "Change text color",
          order = source_order(),
          width = 0.375,
        },
        noColor =
        { type = "execute",
          name = RPTAGS.CONST.ICONS.COLORWHEEL,
          desc = "Reset Colors",
          order = source_order(),
          disabled = true,
          width = 0.375,
        },
      },
    };

    for _, button in ipairs(CONST.RPUF.EDITOR_BUTTON_LIST)
    do  w.args[button] =
        { type = "execute",
          name = tagLabel(button),
          desc = tagDesc(button),
          order = source_order(),
          width = 0.75,
          hidden = function() 
            return not Get("EDITOR_BUTTON_" .. button:upper():gsub("[:%-]",""));
          end,
        }
    end;

    return w;
  end;
  
  addOptionsPanel("RPUF_Editor",
  { name                = loc("OPT_EDITOR"),
    order               = source_order(),
    type                = "group",
    hidden              = function() return Get("DISABLE_RPUF") end,
    args                = 
    { instruct          = Instruct("editor", nil, reqRPUF ),
      fontFile          = refreshFont(Wide(
                             Font("EDITOR_FONT", nil, reqRPUF, fixedFonts), 
                             1.5)
                             ),
      fontspacer        = Spacer(),
      fontSize          = refreshFont(Slider("EDITOR_FONTSIZE", 6, 24, 1, 1.5)),
      editorStatus =
      { type = "group",
        name = "Editor Status",
        inline = true,
        order = source_order(),
        args =
        { lastEdited =
          { type = "description",
            name = function() 
                     return "Last Edited: **" .. 
                       (Editor:GetKey() and loc("CONFIG_" .. Editor:GetKey()) or "none") ..
                       "**"
                   end,
            order = source_order(),
            dialogControl = "LMD30_Description",
            width = 1.25,
          },
          status =
          { type = "description",
            name = 
              function() 
                return "Status: " ..
                  (Editor:IsSaved() and "|cff00ff00Saved|r" or "|cffff0000Not Saved|r")
              end,
            order = source_order(),
            dialogControl = "LMD30_Description",
            width = 1,
          },
          openEditor =
          { type = "execute",
            name = "Re-Open Editor",
            func = function() InterfaceOptionsFrame:Hide(); Editor:Edit() end,
            width = 1,
            order = source_order(),
          },
        },
      },

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
            get = function() return (Editor:CountToolBar() > 0) end,
            set = function()
                    for i, button in ipairs(buttonList)
                    do  Set("EDITOR_BUTTON_" .. button:upper():gsub("[:%-]",""), false, true);
                    end
                    Editor:UpdateLayout();
                  end,
            disabled = function() return Editor:CountToolBar() == 0 end,
          },
          barMockup = build_editor_bar_mockup(),
          nameButtons =
          { type          = "group",
            name          = "Name Buttons",
            order         = source_order(),
            inline        = true,
            args          =
            { rpName      = build_editor_bar_button("rp:name"),
              rpFirstName = build_editor_bar_button("rp:firstname"),
              rpLastName  = build_editor_bar_button("rp:lastname"),
              rpNickname  = build_editor_bar_button("rp:nick"),
            },
          },
          coreButtons     =
          { type          = "group",
            name          = "Basic Details Buttons",
            order         = source_order(),
            inline        = true,
            args          =
            { rpTitle     = build_editor_bar_button("rp:title"),
              rpFullTitle = build_editor_bar_button("rp:fulltitle"),
              rpClass     = build_editor_bar_button("rp:class"),
              rpRace      = build_editor_bar_button("rp:race"),
              rpGender    = build_editor_bar_button("rp:gender"),
              rpPronouns  = build_editor_bar_button("rp:pronouns"),
              rpAge       = build_editor_bar_button("rp:age"),
              rpHeight    = build_editor_bar_button("rp:height"),
              rpWeight    = build_editor_bar_button("rp:weight"),
            },
          },
          statusButtons =
          { type        = "group",
            name        = "Status Buttons",
            order       = source_order(),
            inline      = true,
            args        =
            { rpStatus  = build_editor_bar_button("rp:status"),
              rpIc      = build_editor_bar_button("rp:ic"),
              rpOoc     = build_editor_bar_button("rp:ooc"),
              rpNpc     = build_editor_bar_button("rp:npc"),
              rpCurr    = build_editor_bar_button("rp:curr"),
              rpOocInfo = build_editor_bar_button("rp:info"),
            },
          },
          colorButtons        =
          { type              = "group",
            name              = "Color Buttons",
            order             = source_order(),
            inline            = true,
            args              =
            { rpColor         = build_editor_bar_button("rp:color"),
              rpEyeColor      = build_editor_bar_button("rp:eyecolor"),
              rpGenderColor   = build_editor_bar_button("rp:gendercolor"),
              rpRelationColor = build_editor_bar_button("rp:relationcolor"),
              rpStatusColor   = build_editor_bar_button("rp:statuscolor"),
              rpAgeColor      = build_editor_bar_button("rp:agecolor"),
              rpHeightColor   = build_editor_bar_button("rp:heightcolor"),
              rpWeightColor   = build_editor_bar_button("rp:weightcolor"),
            },
          },
          iconButtons       =
          { type            = "group",
            name            = "Icon Buttons",
            order           = source_order(),
            inline          = true,
            args            =
            { rpIcon        = build_editor_bar_button("rp:icon"),
              rpGenderIcon  = build_editor_bar_button("rp:gendericon"),
              rpStatusIcon  = build_editor_bar_button("rp:statusicon"),
              rpRaceIcon    = build_editor_bar_button("rp:raceicon"),
              rpGlance1Icon = build_editor_bar_button("rp:glance-1-icon"),
              rpGlance2Icon = build_editor_bar_button("rp:glance-2-icon"),
              rpGlance3Icon = build_editor_bar_button("rp:glance-3-icon"),
              rpGlance4Icon = build_editor_bar_button("rp:glance-4-icon"),
              rpGlance5Icon = build_editor_bar_button("rp:glance-5-icon"),
              rpGlance6Icon = build_editor_bar_button("rp:glance-icons"),
            },
          },
          socialButtons    =
          { type           = "group",
            name           = "Social Buttons",
            order          = source_order(),
            inline         = true,
            args           =
            { rpAlignment  = build_editor_bar_button("rp:alignment"),
              rpBirthplace = build_editor_bar_button("rp:birthplace"),
              rpFamily     = build_editor_bar_button("rp:family"),
              rpGuild      = build_editor_bar_button("rp:guild"),
              rpMotto      = build_editor_bar_button("rp:motto"),
              rpRstatus    = build_editor_bar_button("rp:rstatus"),
              rpHome       = build_editor_bar_button("rp:home"),
              rpSexuality  = build_editor_bar_button("rp:sexuality"),
            },
          },
          formattingButtons =
          { type            = "group",
            name            = "Formatting Buttons",
            order           = source_order(),
            inline          = true,
            args            =
            { formattingP   = build_editor_bar_button("p"),
              formattingBr  = build_editor_bar_button("br"),
            },
          },
        },
      },
    },
  });
    end);

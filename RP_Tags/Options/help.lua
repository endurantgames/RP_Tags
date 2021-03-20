-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. 

RPTAGS.queue:WaitUntil("OPTIONS_HELP",
function(self, event, ...)
-- RPQ -----------------------------------------------------------------------------------------------------------------------------
--
  local Options            = RPTAGS.options;
  local Utils              = RPTAGS.utils;
  local Config             = Utils.config;
  local loc                = Utils.locale.loc
  local source_order       = Utils.options.source_order
  local Get                = Utils.config.get;

  local optUtils           = Utils.options;
  local Blank_Line         = optUtils.blank_line
  local Header             = optUtils.header
  local Instruct           = optUtils.instruct
  local Markdown           = optUtils.markdown
  local Pushbutton         = optUtils.pushbutton
  local Recipe             = optUtils.recipe
  local Spacer             = optUtils.spacer
  local Data_Table         = optUtils.data_table
  local FontSize           = optUtils.set_fontSize;

  local function sizeModifierTable() 
    local chars = loc("TABLE_CHARACTERS");
    return Data_Table(
      loc("TABLE_TAG_SIZES"),
      { { loc("TABLE_MODIFIER"), loc("TABLE_SHORT_FORM"),        loc("TABLE_MAX_SIZE"  ) },
        { "`(extra-small)`",     "`(xs)`", Get("TAG_SIZE_XS") .. chars },
        { "`(small)`",           "`(s)`",  Get("TAG_SIZE_S")  .. chars },
        { "`(medium)`",          "`(m)`",  Get("TAG_SIZE_M")  .. chars },
        { "`(large)`",           "`(l)`",  Get("TAG_SIZE_L")  .. chars },
        { "`(extra-large)`",     "`(xl)`", Get("TAG_SIZE_XL") .. chars }, }
      -- { width = { 0.75, 0.75, 0.75 } }
    );
  end;

  local function tagExampleTable()
    local units = loc("TABLE_THE_UNITS");
    return Data_Table(
    loc("TABLE_COMMON_TAGS"),
    { { loc("TABLE_TAG"),        loc("TABLE_DESC"),      loc("UI_MORE_INFORMATION")   },
      { "`[rp:name]`",   units.. loc("TAG_rp:name_DESC"  ), "[help](tag://rp:name)"   },
      { "`[rp:class]`",  units.. loc("TAG_rp:class_DESC" ), "[help](tag://rp:class)"  },
      { "`[rp:race]`",   units.. loc("TAG_rp:race_DESC"  ), "[help](tag://rp:race)"   },
      { "`[rp:icon]`",   units.. loc("TAG_rp:icon_DESC"  ), "[help](tag://rp:icon)"   },
      { "`[rp:color]`",  units.. loc("TAG_rp:color_DESC" ), "[help](tag://rp:color)"  },
      { "`[rp:status]`", units.. loc("TAG_rp:status_DESC"), "[help](tag://rp:status)" },
      { "`[rp:curr]`",   units.. loc("TAG_rp:curr_DESC"  ), "[help](tag://rp:name)"   },
    }, { width = { 0.75, 1.5, 1 }, blank_line = false }
    );
  end;

  local function colorModifierTable1()
    return Data_Table(
      loc("TABLE_COLOR_TRANSFORMS"),
      { { loc("TABLE_COLOR_XFORM"), loc("TABLE_COLOR_XFORM_DESC"), loc("TABLE_COLOR_XFORM_EXAMPLE") },
        { "*light*`[ness]`", loc("TABLE_COLOR_XFORM_LIGHT"), "|cffffff00[rp:color(*lightness*, `+0.25`)]|r" },
        { "*dark*`[ness]`", loc("TABLE_COLOR_XFORM_DARK"), "|cffffff00[rp:color(*darkness*, `+0.25`)]|r"},
        { "*bright*`[ness]`", loc("TABLE_COLOR_XFORM_BRIGHT"), "|cffffff00[rp:color(*brightness*, `+25%`)]|r"},
        { "*dim*`[ness]`", loc("TABLE_COLOR_XFORM_DIM"), "|cffffff00[rp:color(*darkness*, `+25%)`]|r"},
        { "*hue*", loc("TABLE_COLOR_XFORM_HUE"), "|cffffff00[rp:color(*hue*, `=0.90`)]|r", },
        { "*sat*`[uration]`", loc("TABLE_COLOR_XFORM_SAT"), "|cffffff00[rp:color(*saturation*, `min`)]|r" },
        { "*desat*`[uration]`", loc("TABLE_COLOR_XFORM_DESAT"), "|cffffff00[rp:color(*desat*, `half`)]|r" },
        { "*lighter*", loc("TABLE_COLOR_XFORM_LIGHTER"), "|cffffff00[rp:color(*lighter*, `0.25`)]|r" },
        { "*darker*", loc("TABLE_COLOR_XFORM_DARKER"), "|cffffff00[rp:color(*darker*, `25%`)]|r"},
        { "*brighter*", loc("TABLE_COLOR_XFORM_BRIGHTER"), "|cffffff00[rp:color(*brighter*, `more`)]|r"},
        { "*dimmer*", loc("TABLE_COLOR_XFORM_DIMMER"), "|cffffff00[rp:color(*dimmer*, `lots more`)]|r"},
      }, { width = { 0.75, 1.5, 1 }, blank_line = true, spacer = true, }
      );
  end;

  local function colorModifierTable2()
    return Data_Table(
      loc("TABLE_COLOR_XFORM_AMOUNTS"),
    {
      { loc("TABLE_COLOR_XFORM_TYPE"      ) , loc("TABLE_COLOR_XFORM_DESC"           ) , loc("TABLE_COLOR_XFORM_EXAMPLE"), },

      { loc("TABLE_COLOR_XFORM_PERCENT"   ) , loc("TABLE_COLOR_XFORM_PERCENT_DESC"   ) , "|cffffff00[rp:color(*brighter*, `25%`)]|r" },
      { loc("TABLE_COLOR_XFORM_DECIMAL"   ) , loc("TABLE_COLOR_XFORM_DECIMAL_DESC"   ) , "|cffffff00[rp:color(*brighter*, `0.25`)]|r" },
      { loc("TABLE_COLOR_XFORM_PLUS"      ) , loc("TABLE_COLOR_XFORM_PLUS_DESC"      ) , "|cffffff00[rp:color(*bright*, `+0.25`)]|r" },
      { loc("TABLE_COLOR_XFORM_MINUS"     ) , loc("TABLE_COLOR_XFORM_MINUS_DESC"     ) , "|cffffff00[rp:color(*bright*, `-25%`)]|r" },
      { loc("TABLE_COLOR_XFORM_EQUALS"    ) , loc("TABLE_COLOR_XFORM_EQUALS_DESC"    ) , "|cffffff00[rp:color(*bright*, = `25`)]|r" },
      { loc("TABLE_COLOR_XFORM_MORE"      ) , loc("TABLE_COLOR_XFORM_MORE_DESC"      ) , "|cffffff00[rp:color(*brighter*, `more`)]|r" },
      { loc("TABLE_COLOR_XFORM_LOTS_MORE" ) , loc("TABLE_COLOR_XFORM_LOTS_MORE_DESC" ) , "|cffffff00[rp:color(*brighter*, `lots more`)]|r" },
      { loc("TABLE_COLOR_XFORM_MORE"      ) , loc("TABLE_COLOR_XFORM_LESS_DESC"      ) , "|cffffff00[rp:color(*brighter*, `less`)]|r" },
      { loc("TABLE_COLOR_XFORM_LOTS_LESS" ) , loc("TABLE_COLOR_XFORM_LOTS_LESS_DESC" ) , "|cffffff00[rp:color(*brighter*, `lots less`)]|r" },
      { loc("TABLE_COLOR_XFORM_MIN"       ) , loc("TABLE_COLOR_XFORM_MIN_DESC"       ) , "|cffffff00[rp:color(*bright*, `min`)]|r" },
      { loc("TABLE_COLOR_XFORM_MAX"       ) , loc("TABLE_COLOR_XFORM_MAX_DESC"       ) , "|cffffff00[rp:color(*bright*, `max`)]|r" },
      { loc("TABLE_COLOR_XFORM_HALF"      ) , loc("TABLE_COLOR_XFORM_HALF_DESC"      ) , "|cffffff00[rp:color(*bright*, `half`)]|r" },

      }, { width = { 0.75, 1.5, 1 }, blank_line = true, spacer = true, }
    );
  end;


  -- ---------------------------------------------------------------------------------------------------------------------------------------------------------------

  local helpSystem        =
  { name                  = loc("PANEL_HELP"),
    order                 = source_order(),
    type                  = "group",
    childGroups = "tab",
    args                  =
    { intro               =
      { type              = "group",
        name              = loc("OPT_HELP_INTRO"),
        order             = source_order(),
        args              =
        { panel           = FontSize(Markdown(loc("INTRO_MD"  )), "medium"),
          tagExampleTable = tagExampleTable(),
          panel2          = FontSize(Markdown(loc("INTRO_2_MD")), "medium"),
        },
      },
      tags                = Options.taghelp(),
      tagModifiers        =
      { type              = "group",
        name              = loc("OPT_TAG_MODIFIERS"),
        order             = source_order(),
        childGroups       = "tab",
        args              =
        { intro       = FontSize(Markdown(loc("TAG_MODIFIERS_MD"  )), "medium"),
          labels =
          { type = "group", 
            name = loc("OPT_LABEL_MODIFIERS"),
            order = source_order(),
            args =
            { firstPart = FontSize(Markdown(loc("LABEL_MODIFIERS_MD")), "medium"),
            },
          },

          sizes =
          { type = "group",
            name = loc("OPT_SIZE_MODIFIERS"),
            order = source_order(),
            args =
            { firstPart = FontSize(Markdown(loc("SIZE_MODIFIERS_MD")), "medium"),

              b1 = Blank_Line(),
              sizeTable       = sizeModifierTable(),
              b2 = Blank_Line(),
              secondPart      = FontSize(Markdown(loc("SIZE_MODIFIERS_2_MD")), "medium"),
            },
          },
          colors =
          { type = "group",
            name = loc("OPT_COLOR_MODIFIERS"),
            order = source_order(),
            args = 
            { firstPart = FontSize(Markdown(loc("COLOR_MODIFIERS_MD")), "medium"),
              b1 = Blank_Line(),
              table1 = colorModifierTable1(),
              b2 = Blank_Line(),
              secondPart = FontSize(Markdown(loc("COLOR_MODIFIERS_2_MD")), "medium"),
              b3 = Blank_Line(),
              table2 = colorModifierTable2(),
              b4 = Blank_Line(),
              thirdPart = FontSize(Markdown(loc("COLOR_MODIFIERS_3_MD")), "medium"),
            },
          },
        },
      },
      recipes             =
      { name              = loc("OPT_RECIPES"),
        order             = source_order(),
        type              = "group",
        -- childGroups       = "tab",
        args              =
        { header          = Header("recipes"           ),
          instruct        = Instruct("recipes"         ),
          nameTitle       = Recipe("name titles"       ),
          eyes            = Recipe("eyes"              ),
          age             = Recipe("age"               ),
          currently       = Recipe("currently"         ),
          genderRaceClass = Recipe("gender race class" ),
          target          = Recipe("target"            ),
          profileSize     = Recipe("profilesize"       ),
          rpStyle         = Recipe("rp style"          ),
          friendName      = Recipe("friend name"       ),
          server          = Recipe("server"            ),
        },
      },
    },
  };

  RPTAGS.options.help = helpSystem;

end);

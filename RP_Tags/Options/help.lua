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

  local function sizeTable() 
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
        args              =
        { firstPart       = FontSize(Markdown(loc("TAG_MODIFIERS_MD"  )), "medium"),
          sizeTable       = sizeTable(),
          secondPart      = FontSize(Markdown(loc("TAG_MODIFIERS_2_MD")), "medium"),
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

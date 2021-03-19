    local w =
    { type = "group",
      name = loc("OPT_PORTRAIT"),
      order = source_order(),
      args = {}; 
    };

    w.args.header = 
    { type = "description",
      name = "# " .. loc("OPT_PORTRAIT"),
      order = source_order(),
      dialogControl = "LMD30_Description",
    };

    w.args.instruct =
    { type = "description",
      dialogControl = "LMD30_Description",
      name = loc("OPT_PORTRAIT_I"),
      order = source_order(),
    };

    w.args.portraitStyle =
    { type = "select",
      name = loc("CONFIG_PORTRAIT_STYLE"),
      desc = loc("CONFIG_PORTRAIT_STYLE_TT"),
      order = source_order(),
      values = menu.portraitStyle,
      get = function() return Get("PORTRAIT_STYLE") end,
      set = function(info, value) Set("PORTRAIT_STYLE", value);
             RPUF_Refresh("all", "portrait") end,
      width = "full",
    };

    w.args.portraitBackground =
    { type = "select",
      name = loc("CONFIG_PORTRAIT_BG"),
      desc = loc("CONFIG_PORTRAIT_BG_TT"),
      order = source_order(),
      dialogControl = "LSM30_Background",
      values = LibSharedMedia:HashTable("background"),
      get = function() return Get("PORTRAIT_BG") end,
      set = function(info, value) Set("PORTRAIT_BG", value);
              RPUF_Refresh("all", "portrait") end,
    };

    w.args.spaPort = Spacer();

    w.args.portraitBorder =
    { type = "select",
      name = loc("CONFIG_PORTRAIT_BORDER"),
      desc = loc("CONFIG_PORTRAIT_BORDER_TT"),
      order = source_order(),
      dialogControl = "LSM30_Border",
      values = LibSharedMedia:HashTable("border"),
      get = function() return Get("PORTRAIT_BORDER") end,
      set = function(info, value) Set("PORTRAIT_BORDER", value);
              RPUF_Refresh("all", "portrait") end,
    };

    w.args.portraitFrameColor =
    { type = "select",
      name = loc("CONFIG_PORTRAIT_BORDER_STYLE"),
      desc = loc("CONFIG_PORTRAIT_BORDER_STYLE_TT"),
      order = source_order(),
      width = "full",
      values = menu.portraitFrameColor,
      sorting = menu.portraitFrameColorOrder,
      get = function() return Get("PORTRAIT_BORDER_STYLE") end,
      set = function(info, value) Set("PORTRAIT_BORDER_STYLE", value);
              RPUF_Refresh("all", "portrait") end,
    };



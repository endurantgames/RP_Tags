local RPTAGS = RPTAGS;
RPTAGS.queue:WaitUntil("DATA_TAGS",
function(self, event, ...)

local L = LibStub("AceLocale-3.0"):GetLocale(RPTAGS.CONST.APP_ID);

local RPTAGS = RPTAGS;
local Get = RPTAGS.utils.get;

RPTAGS.CONST.TAG_DATA = {

 -- [group] = { title = "localized-title",
 --             help = "help-page",
 --             tags = { [tag], [tag], [tag],
 --                    },

-- --------------------------------------------------------------------------------------------------------------------------------------------------
 { key = "BASICS", title = L["TAG_GROUP_BASICS_TITLE"], help = L["TAG_GROUP_BASICS_HELP"],
   tags = {
     { name =           "rp:class",                  label =          L["TAG_rp:class_LABEL"],              desc =  L["TAG_rp:class_DESC"],
       method = Get.text.class,
       size =           true,                        elvui_category = "Miscellaneous" },
     { name =           "rp:race",                   label =          L["TAG_rp:race_LABEL"],               desc =  L["TAG_rp:race_DESC"],
       method = Get.text.race,
       size =           true,                        elvui_category = "Miscellaneous" },
     { name =           "rp:name",                   alias =          { "rp:fullname", "rp:name-full" },
       method = Get.text.name,
       label =          L["TAG_rp:name_LABEL"],      
     -- elvui_category = "Names",
                              desc =  L["TAG_rp:name_DESC"],         size = true },

     { name =           "rp:firstname",              alias =          { "rp:name-first" },                  label = L["TAG_rp:firstname_LABEL"],
       method = Get.text.firstname,
       
     -- elvui_category = "Names",
                     desc =           L["TAG_rp:firstname_DESC"],           size =  true },
     { name =           "rp:lastname",               alias =          { "rp:name-last",  },
       method = Get.text.lastname,
       label =          L["TAG_rp:lastname_LABEL"],  
     -- elvui_category = "Names",
                              desc =  L["TAG_rp:lastname_DESC"],     size = true },
     { name =           "rp:name-known",             label =          L["TAG_rp:name-known_LABEL"],         desc =  L["TAG_rp:name-known_DESC"],
       method = Get.text.knownName,
       
     -- elvui_category = "Names",
                     size =           true },
     { name =           "rp:nick",                   alias =          { "rp:nickname" },                    label = L["TAG_rp:nick_LABEL"],
       method = function(u) return Get.text.misc("nickname", u) end,
       
     -- elvui_category = "Names",
                     desc =           L["TAG_rp:nick_DESC"],                size =  true },
     { name =           "rp:nick-quoted",            alias =          { "rp:nickname-quoted" },             label = L["TAG_rp:nick-quoted_LABEL"],
       method = function(u) return Get.text.misc("nick-quoted", u) end,
       
     -- elvui_category = "Names",
                     desc =           L["TAG_rp:nick-quoted_DESC"],         size =  true },
     { name =           "rp:title",                  alias =          { "rp:title-short", "rp:honorific" },
       method = Get.text.title,
       label =          L["TAG_rp:title_LABEL"],     
     -- elvui_category = "Names",
                              desc =  L["TAG_rp:title_DESC"],        size = true },
     { name =           "rp:fulltitle",              alias =          { "rp:title-full", "rp:title-long" },
       method = Get.text.fulltitle,
       label =          L["TAG_rp:fulltitle_LABEL"], 
     -- elvui_category = "Names",
                              desc =  L["TAG_rp:fulltitle_DESC"],    size = true },

   }, -- tags
 }, -- basics
-- --------------------------------------------------------------------------------------------------------------------------------------------------
 { key = "APPEARANCE", title = L["TAG_GROUP_APPEARANCE_TITLE"], help = L["TAG_GROUP_APPEARANCE_HELP"],
   tags = {
     { name =  "rp:body",                  alias = { "rp:bodyshape" },            label = L["TAG_rp:body_LABEL"],
       method = function(u) return Get.text.weight(u, true) end,
       desc =  L["TAG_rp:body_DESC"],      size =  true },
     { name =  "rp:eyes",                  label = L["TAG_rp:eyes_LABEL"],        desc =  L["TAG_rp:eyes_DESC"],
       method = Get.text.eyes,
       size =  true },
     { name =  "rp:hair",                  label = L["TAG_rp:hair_LABEL"],        desc =  L["TAG_rp:hair_DESC"],
       method = function(u) return Get.text.misc("hair", u) end,
       size =  true,  },
     { name =  "rp:height",                label = L["TAG_rp:height_LABEL"],      desc =  L["TAG_rp:height_DESC"],
       method = Get.text.height,
       size =  true,  },
     { name =  "rp:markings",              label = L["TAG_rp:markings_LABEL"],    desc =  L["TAG_rp:markings_DESC"],
       method = function(u) return Get.text.misc("markings", u) end,
       size =  true,                       
     
  },
     { name =  "rp:physiognomy",           label = L["TAG_rp:physiognomy_LABEL"], desc =  L["TAG_rp:physiognomy_DESC"],
       method = function(u) return Get.text.misc("physiognomy", u) end,
       size =  true,                       
     
  },
     { name =  "rp:piercings",             label = L["TAG_rp:piercings_LABEL"],   desc =  L["TAG_rp:piercings_DESC"],
       method = function(u) return Get.text.misc("piercings", u) end,
       size =  true,                       
     
  },
     { name =  "rp:sizebuff",              label = L["TAG_rp:sizebuff_LABEL"],    desc =  L["TAG_rp:sizebuff_DESC"],
       extraEvents = "UNIT_AURA",
       method = Get.shared.sizebuff, },

     { name =  "rp:tattoos",               label = L["TAG_rp:tattoos_LABEL"],     desc =  L["TAG_rp:tattoos_DESC"],
       method = function(u) return Get.text.misc("tattoos", u) end,
       size =  true,                       
     
  },
     { name =  "rp:weight",                label = L["TAG_rp:weight_LABEL"],      desc =  L["TAG_rp:weight_DESC"],
       method = Get.text.weight,
       size =  true,  },
     { title = L["TAG_SUBTITLE_Claims"] },
     { name =  "rp:actor",                 alias = { "rp:actress" },              label = L["TAG_rp:actor_LABEL"],
       method = function(u) return Get.text.misc("actor", u) end,
       desc =  L["TAG_rp:actor_DESC"],     size =  true,                          
     
      }, 
     { name =  "rp:bodyclaim",             label = L["TAG_rp:bodyclaim_LABEL"],   desc =  L["TAG_rp:bodyclaim_DESC"],
       method = function(u) return Get.text.misc("bodyclaim", u) end,
       size =  true,                       
     
      }, 
     { name =  "rp:faceclaim",             label = L["TAG_rp:faceclaim_LABEL"],   desc =  L["TAG_rp:faceclaim_DESC"],
       method = function(u) return Get.text.misc("faceclaim", u) end,
       size =  true,                       
     
      }, 
     { name =  "rp:voiceclaim",            label = L["TAG_rp:voiceclaim_LABEL"],  desc =  L["TAG_rp:voiceclaim_DESC"],
       method = function(u) return Get.text.misc("voicelcim", u) end,
       size =  true,                       
     
  },


   }, -- tags
 }, -- body

-- --------------------------------------------------------------------------------------------------------------------------------------------------
 { key = "GLANCE", title = L["TAG_GROUP_GLANCE_TITLE"], help = L["TAG_GROUP_GLANCE_HELP"],
   tags = {

     { title = L["TAG_SUBTITLE_Glance 1"] },
     { name =  "rp:glance-1",                   alias = { "rp:glance-1-title" },        desc =  L["TAG_rp:glance-1_DESC"],
       method = function(u) return Get.text.glance(u, 1, { title = true }) end,
       size =  true },
     { name =  "rp:glance-1-text",              desc =  L["TAG_rp:glance-1-text_DESC"], size =  true,
       method = function(u) return Get.text.glance(u, 1, { text = true }) end,
     },
     { name =  "rp:glance-1-full",              desc =  L["TAG_rp:glance-1-full_DESC"], size =  true,
       method = function(u) return Get.text.glance(u, 1, { all = true }) end,
     },

     { title = L["TAG_SUBTITLE_Glance 2"]
        },
     { name =  "rp:glance-2",                   alias = { "rp:glance-2-title" },        desc =  L["TAG_rp:glance-2_DESC"],
       method = function(u) return Get.text.glance(u, 2, { title = true }) end,
        },
     { name =  "rp:glance-2-text",              desc =  L["TAG_rp:glance-2-text_DESC"], size =  true,
       method = function(u) return Get.text.glance(u, 2, { text = true }) end,
        },
     { name =  "rp:glance-2-full",              desc =  L["TAG_rp:glance-2-full_DESC"], size =  true,
       method = function(u) return Get.text.glance(u, 2, { all = true }) end,
        },

     { title = L["TAG_SUBTITLE_Glance 3"]
        },
     { name =  "rp:glance-3",                   alias = { "rp:glance-3-title" },        desc =  L["TAG_rp:glance-3_DESC"],
       method = function(u) return Get.text.glance(u, 3, { title = true }) end,
       size =  true
        },
     { name =  "rp:glance-3-text",              desc =  L["TAG_rp:glance-3-text_DESC"], size =  true,
       method = function(u) return Get.text.glance(u, 3, { text = true }) end,
        },
     { name =  "rp:glance-3-full",              desc =  L["TAG_rp:glance-3-full_DESC"], size =  true,
       method = function(u) return Get.text.glance(u, 3, { all = true }) end,
        },

     { title = L["TAG_SUBTITLE_Glance 4"]
        },
     { name =  "rp:glance-4",                   alias = { "rp:glance-4-title" },        desc =  L["TAG_rp:glance-4_DESC"],
       method = function(u) return Get.text.glance(u, 4, { title = true }) end,
       size =  true
        },
     { name =  "rp:glance-4-text",              desc =  L["TAG_rp:glance-4-text_DESC"], size =  true,
       method = function(u) return Get.text.glance(u, 4, { text = true }) end,
        },
     { name =  "rp:glance-4-full",              desc =  L["TAG_rp:glance-4-full_DESC"], size =  true,
       method = function(u) return Get.text.glance(u, 4, { all = true }) end,
        },

     { title = L["TAG_SUBTITLE_Glance 5"]
        },
     { name =  "rp:glance-5",                   alias = { "rp:glance-5-title" },        desc =  L["TAG_rp:glance-5_DESC"],
       method = function(u) return Get.text.glance(u, 5, { title = true }) end,
       size =  true
        },
     { name =  "rp:glance-5-text",              desc =  L["TAG_rp:glance-5-text_DESC"], size =  true,
       method = function(u) return Get.text.glance(u, 5, { text = true }) end,
        },
     { name =  "rp:glance-5-full",              desc =  L["TAG_rp:glance-5-full_DESC"], size =  true,
       method = function(u) return Get.text.glance(u, 5, { all = true }) end,
        },

     { title = L["TAG_SUBTITLE_All Glances"]
        },
     { name =  "rp:glance",                     alias = { "rp:glance-all"},             label = L["TAG_rp:glance_LABEL"],      desc = L["TAG_rp:glance_DESC"], size = true,
       method = function(u) return Get.text.glance(u, 0, { title = true }) end,
        },
     { name =  "rp:glance-full",                alias = { "rp:glance-all-full"},        label = L["TAG_rp:glance-full_LABEL"],
       method = function(u) return Get.text.glance(u, 0, { all = true }) end,
       desc =  L["TAG_rp:glance-full_DESC"]
        },

   }, -- tags ##
 }, -- glance

-- --------------------------------------------------------------------------------------------------------------------------------------------------
 { key = "COLORS", title = L["TAG_GROUP_COLORS_TITLE"], help = L["TAG_GROUP_COLORS_HELP"],
   
     -- elvui_category = "Colors",

   tags = {
     { name =  "rp:color",                            alias = { "rp:classcolor", "rp:namecolor" },
       method = Get.color.name,
       desc =  L["TAG_rp:color_DESC"] },
     { name =  "rp:eyecolor",                         desc =  L["TAG_rp:eyecolor_DESC"],
       method = Get.color.eye,
        },
     { name =  "rp:friendcolor",                      desc =  L["TAG_rp:friendcolor_DESC"] ,
       method = Get.shared.friendColor, extraEvents = "FRIENDLIST_UPDATE BN_FRIEND_INFO_CHANGED IGNORELIST_UPDATE", },
     { name =  "rp:gendercolor",                      alias = { "rp:sexcolor" },                                       
       method = Get.color.gender,
       desc =      L["TAG_rp:gendercolor_DESC"] },
     { name =  "rp:guildcolor",                       desc =  L["TAG_rp:guildcolor_DESC"] ,
       method = Get.shared.guildColor, extraEvents = "PLAYER_GUILD_UPDATE GUILD_ROSTER_UPDATE",
        },
     { name =  "rp:guildstatuscolor",                 desc =  L["TAG_rp:guildstatuscolor_DESC"],                       unsup =     "mrp" ,
       method = Get.color.guildstatus,
        },
     { name =  "rp:partycolor",                       alias = { "rp:raidcolor" },                                      
       method = Get.shared.partyColor,
       extraEvents = "UNITS_OTHER_PARTY_CHANGED GROUP_JOINED GROUP_LEFT",
       desc =      L["TAG_rp:partycolor_DESC"] },
     { name =  "rp:profilesizecolor",                 desc =  L["TAG_rp:profilesizecolor_DESC"] ,
       method = function(u) return Get.text.profileSize(u, "color") end,
        },
     { name =  "rp:relationcolor",                    desc =  L["TAG_rp:relationcolor_DESC"],                          unsup =     "mrp" ,
       method = Get.color.relation,
        },
     { name =  "rp:statuscolor",                      desc =  L["TAG_rp:statuscolor_DESC"] ,
       method = Get.color.status,
        },
     { name =  "nocolor",                             desc =  L["TAG_nocolor_DESC"],                                   no_prefix = true ,
       method = function(u) return "|r" end,
        },
     { title = L["TAG_SUBTITLE_Comparison Colors"] ,
        },
     { name =  "rp:agecolor",                         desc =  L["TAG_rp:agecolor_DESC"] ,
       method = Get.color.age,
        },
     { name =  "rp:heightcolor",                      desc =  L["TAG_rp:heightcolor_DESC"] ,
       method = Get.color.height,
        },
     { name =  "rp:weightcolor",                      desc =  L["TAG_rp:weightcolor_DESC"] ,
       method = Get.color.weight,
        },
     { title = L["TAG_SUBTITLE_Hilite Colors"] ,
        },
     { name =  "rp:hilite-1",                         alias = { "rp:hilite", "rp:hilite-color", "rp:hilite-color-1" }, desc =      L["TAG_rp:hilite-1_DESC"],
       method = function(u) return Get.shared.hiliteColor(1) end, },
     { name =  "rp:hilite-2",                         alias = { "rp:hilite-color-2" },
       method = function(u) return Get.shared.hiliteColor(1) end,                                  
       desc =      L["TAG_rp:hilite-2_DESC"] },
     { name =  "rp:hilite-3",                         alias = { "rp:hilite-color-3" },
       method = function(u) return Get.shared.hiliteColor(1) end,                                  
       desc =      L["TAG_rp:hilite-3_DESC"] },

   } -- tags
 
        }, -- colors

-- --------------------------------------------------------------------------------------------------------------------------------------------------
 { key = "FORMATTING", title = L["TAG_GROUP_FORMATTING_TITLE"], help = L["TAG_GROUP_FORMATTING_HELP"],
   
     -- elvui_category = "Miscellaneous",

   tags = {
     { name = "br", desc = L["TAG_br_DESC"], no_prefix = true, method = function() return "\n"   end, },
     { name = "p",  desc = L["TAG_p_DESC"],  no_prefix = true, method = function() return "\n\n" end, },

     }, -- tags
 }, -- formatting

-- --------------------------------------------------------------------------------------------------------------------------------------------------
 { key = "GENDER",
   title = L["TAG_GROUP_GENDER_TITLE"],
   help = L["TAG_GROUP_GENDER_HELP"],
   
     -- elvui_category = "Names",

   tags = {
     { name =  "rp:gender",                             alias = { "rp:sex" },               label = L["TAG_rp:gender_LABEL"],
       method = Get.text.gender,
       desc =  L["TAG_rp:gender_DESC"],                 size =  true },
     { name =  "rp:pronouns",                           label = L["TAG_rp:pronouns_LABEL"], desc =  L["TAG_rp:pronouns_DESC"],
       method = Get.text.pronouns,
       size =  true },
     { title = L["TAG_SUBTITLE_Nominative Pronouns"] },
     { name =  "rp:s",                                  desc =  L["TAG_rp:s_DESC"] ,
       method = function(u) return Get.text.pronoun(u, "s") end,
     },
     { name =  "rp:S",                                  desc =  L["TAG_rp:S_DESC"] ,
       method = function(u) return Get.text.pronoun(u, "S") end,
     },
     { title = L["TAG_SUBTITLE_Object Pronouns"] },
     { name =  "rp:o",                                  desc =  L["TAG_rp:o_DESC"] ,
       method = function(u) return Get.text.pronoun(u, "o") end,
     },
     { name =  "rp:O",                                  desc =  L["TAG_rp:O_DESC"] ,
       method = function(u) return Get.text.pronoun(u, "O") end,
     },
     { title = L["TAG_SUBTITLE_Possessive Pronouns"] },
     { name =  "rp:p",                                  desc =  L["TAG_rp:p_DESC"] ,
       method = function(u) return Get.text.pronoun(u, "p") end, },
     { name =  "rp:P",                                  desc =  L["TAG_rp:P_DESC"] ,
       method = function(u) return Get.text.pronoun(u, "P") end, },
     { title = L["TAG_SUBTITLE_Absolute Pronouns"] },
     { name =  "rp:a",                                  desc =  L["TAG_rp:a_DESC"] ,
       method = function(u) return Get.text.pronoun(u, "a") end, },
     { name =  "rp:A",                                  desc =  L["TAG_rp:A_DESC"] ,
       method = function(u) return Get.text.pronoun(u, "A") end, },
     { title = L["TAG_SUBTITLE_Reflexive Pronouns"] },
     { name =  "rp:r",                                  desc =  L["TAG_rp:r_DESC"] ,
       method = function(u) return Get.text.pronoun(u, "r") end, },
     { name =  "rp:R",                                  desc =  L["TAG_rp:R_DESC"] ,
       method = function(u) return Get.text.pronoun(u, "R") end,
     },

     }, -- tags
 }, -- gender

-- --------------------------------------------------------------------------------------------------------------------------------------------------
 { key = "HISTORY", title = L["TAG_GROUP_HISTORY_TITLE"], help = L["TAG_GROUP_HISTORY_HELP"],
   tags = {
     { name =  "rp:age",        label = L["TAG_rp:age_LABEL"],        desc = L["TAG_rp:age_DESC"],
       method = Get.text.age,
       size =  true },
     { name =  "rp:years",      label = L["TAG_rp:years_LABEL"],      desc = L["TAG_rp:years_DESC"] ,
       method = Get.text.years },
     { name =  "rp:years-old",  label = L["TAG_rp:years-old_LABEL"],  desc = L["TAG_rp:years-old_DESC"] ,
       method = function(u) return Get.text.years(u, "old") end , },
     { name =  "rp:years-ago",  label = L["TAG_rp:years-ago_LABEL"],  desc = L["TAG_rp:years-ago_DESC"] ,
       method = function(u) return Get.text.years(u, "ago") end , },
     { name =  "rp:birthday",   label = L["TAG_rp:birthday_LABEL"],   desc = L["TAG_rp:birthday_DESC"],
       method = function(u) return Get.text.misc(u, "birthday") end, 
       
           size =  true }, 
     { name =  "rp:birthplace", label = L["TAG_rp:birthplace_LABEL"], desc = L["TAG_rp:birthplace_DESC"],
       method = Get.text.birthplace,
       size =  true },

   }, -- tags
 }, -- history

-- --------------------------------------------------------------------------------------------------------------------------------------------------
 { key = "ICONS", title = L["TAG_GROUP_ICONS_TITLE"], help = L["TAG_GROUP_ICONS_HELP"],
   tags = {
     { name =           "rp:icon",                                 desc =  L["TAG_rp:icon_DESC"] ,
       method = Get.icon.unit,
     },
     { name =           "rp:gendericon",                           alias = { "rp:sexicon" },                    desc =           L["TAG_rp:gendericon_DESC"] ,
       method = Get.icon.gender,
     },
     { name =           "rp:raceicon",                             desc =  L["TAG_rp:raceicon_DESC"],           
     -- elvui_category = "Miscellaneous",

       method = Get.icon.race,
     },
     { name =           "rp:statusicon",                           desc =  L["TAG_rp:statusicon_DESC"],
       method = Get.icon.status,
     },
     { name =           "rp:pvpicon",                              desc =  L["TAG_rp:pvpicon_DESC"],            
     -- elvui_category = "PvP",

       method = Get.shared.pvpIcon, extraEvents = "PVP_ROLE_UPDATE",
     },
     { name =           "rp:pvpicon-square",                       desc =  L["TAG_rp:pvpicon-square_DESC"],     
     -- elvui_category = "PvP",

       method = function(u) return Get.shared.pvpIcon(u, "square") end, extraEvents = "PVP_ROLE_UPDATE",
     },
     { name =           "rp:relationicon",                         desc =  L["TAG_rp:relationicon_DESC"],       unsup =          "mrp" ,
       method = Get.icon.relation,
     },
     { name =           "rp:sizebufficon",                         desc =  L["TAG_rp:sizebufficon_DESC"] ,
       method = Get.shared.sizebuffIcon, extraEvents = "UNIT_AURA", 
     },
     { title =          L["TAG_SUBTITLE_At First-Glance Icons"] },
     { name =           "rp:glance-1-icon",                        desc =  L["TAG_rp:glance-1-icon_DESC"] ,
       method = function(u) return Get.text.glance(u, 1, { icon = true }) end,
     },
     { name =           "rp:glance-2-icon",                        desc =  L["TAG_rp:glance-2-icon_DESC"] ,
       method = function(u) return Get.text.glance(u, 2, { icon = true }) end,
     },
     { name =           "rp:glance-3-icon",                        desc =  L["TAG_rp:glance-3-icon_DESC"] ,
       method = function(u) return Get.text.glance(u, 3, { icon = true }) end,
     },
     { name =           "rp:glance-4-icon",                        desc =  L["TAG_rp:glance-4-icon_DESC"] ,
       method = function(u) return Get.text.glance(u, 4, { icon = true }) end,
     },
     { name =           "rp:glance-5-icon",                        desc =  L["TAG_rp:glance-5-icon_DESC"] ,
       method = function(u) return Get.text.glance(u, 5, { icon = true }) end,
     },
     { name =           "rp:glance-icons",                         desc =  L["TAG_rp:glance-icons_DESC"] ,
       method = Get.icon.glances,
     },
     { title =          L["TAG_SUBTITLE_Note Indicator Icons"] },
     { name =           "rp:note-1-icon",                          desc =  L["TAG_rp:note-1-icon_DESC"],        unsup =          "mrp",
       method = function(u) return Get.text.note(u, false, 1, "ICON") end,
     },
     { name =           "rp:note-2-icon",                          desc =  L["TAG_rp:note-2-icon_DESC"],        unsup =          "mrp",
       method = function(u) return Get.text.note(u, false, 2, "ICON") end,
     },
     { name =           "rp:note-3-icon",                          desc =  L["TAG_rp:note-3-icon_DESC"],        unsup =          "mrp" ,
       method = function(u) return Get.text.note(u, false, 3, "ICON") end,
     },
     { title =          L["TAG_SUBTITLE_RP Experience Icons"] },
     { name =           "rp:xp-icon",                              desc =  L["TAG_rp:xp-icon_DESC"],            unsup =          "mrp",
       method = function(u) return Get.text.xp(u, "icon") end,
       elvui_category = "Level" },
     { name =           "rp:rookie-icon",                          desc =  L["TAG_rp:rookie-icon_DESC"],        
     -- elvui_category = "Level",

       method = function(u) return Get.text.xp(u, "rookie-icon") end,
       unsup =          "mrp" },
     { name =           "rp:volunteer-icon",                       desc =  L["TAG_rp:volunteer-icon_DESC"],     
     -- elvui_category = "Level",

       method = function(u) return Get.text.xp(u, "volunteer-icon") end,
       unsup =          "mrp" },
     { title =          L["TAG_SUBTITLE_RP Style Icons"] },
     { name =           "rp:style-ic-icon",                        desc =  L["TAG_rp:style-ic-icon_DESC"] ,
       method = function(u) return Get.text.style(u, "ic", "ICON") end,
     },
     { name =           "rp:style-injury-icon",                    desc =  L["TAG_rp:style-injury-icon_DESC"],  unsup =          "mrp" ,
       method = function(u) return Get.text.style(u, "injury", "ICON") end,
     },
     { name =           "rp:style-death-icon",                     desc =  L["TAG_rp:style-death-icon_DESC"],   unsup =          "mrp" ,
       method = function(u) return Get.text.style(u, "death", "ICON") end,
     },
     { name =           "rp:style-battle-icon",                    desc =  L["TAG_rp:style-battle-icon_DESC"],  unsup =          "mrp" ,
       method = function(u) return Get.text.style(u, "battle", "ICON") end,
     },
     { name =           "rp:style-romance-icon",                   desc =  L["TAG_rp:style-romance-icon_DESC"], unsup =          "mrp" ,
       method = function(u) return Get.text.style(u, "romance", "ICON") end,
     },
     { name =           "rp:style-guild-icon",                     desc =  L["TAG_rp:style-guild-icon_DESC"],   unsup =          "mrp" ,
       method = function(u) return Get.text.style(u, "guild", "ICON") end,
     },
     { name =           "rp:style-icons",                          desc =  L["TAG_rp:style-icons_DESC"],        unsup =          "mrp" ,
       method = function(u) return Get.text.style(u, "icons") end,
     },

     }, -- tags
 }, -- icons

-- --------------------------------------------------------------------------------------------------------------------------------------------------
 { key = "PROFILE", title = L["TAG_GROUP_PROFILE_TITLE"], help = L["TAG_GROUP_PROFILE_HELP"],
   tags = {
     { name =  "rp:profilesize",                            label = L["TAG_rp:profilesize_LABEL"],                               desc = L["TAG_rp:profilesize_DESC"],
       method = function(u) return Get.text.profileSize(u, "word") end,
     },
     { title = L["TAG_SUBTITLE_Note Matches"] },
     { name =  "rp:note-1",                                 label = L["TAG_rp:note-1_LABEL"],                                    desc = L["TAG_rp:note-1_DESC"],
       method = function(u) return Get.text.note(u, 1) end,
       
     
                                       size =  true },
     { name =  "rp:note-2",                                 label = L["TAG_rp:note-2_LABEL"],                                    desc = L["TAG_rp:note-2_DESC"],
       method = function(u) return Get.text.note(u, 2) end,
       
     
                                       size =  true },
     { name =  "rp:note-3",                                 label = L["TAG_rp:note-3_LABEL"],                                    desc = L["TAG_rp:note-3_DESC"],
       method = function(u) return Get.text.note(u, 2) end,
       
     
                                       size =  true },
     { title = L["TAG_SUBTITLE_Relation Tags"] },
     { name =  "rp:relation",                               label = L["TAG_rp:relation_LABEL"],                                  desc = L["TAG_rp:relation_DESC"],
       method = Get.text.relation,
       
     
      }, 
     { name =  "rp:relation-who",                           label = L["TAG_rp:relation-who_LABEL"],                              desc = L["TAG_rp:relation-who_DESC"],
       method = Get.text.relwho,
       
     
      }, 
     { title = L["TAG_SUBTITLE_Roleplaying Client Tags"] },
     { name =  "rp:client",                                 label = L["TAG_rp:client_LABEL"],                                    desc = L["TAG_rp:client_DESC"] ,
       method = function(u) return Get.text.client(u, "long") end,
     },
     { name =  "rp:client-short",                           desc =  L["TAG_rp:client-short_DESC"] ,
       method = function(u) return Get.text.client(u, "short") end,
     },
     { name =  "rp:client-version",                         label = L["TAG_rp:client-version_LABEL"],                            desc = L["TAG_rp:client-version_DESC"] ,
       method = function(u) return Get.text.client(u, "version") end,
     },
     { name =  "rp:client-full",                            label = L["TAG_rp:client-full_LABEL"],                               desc = L["TAG_rp:client-full_DESC"] ,
       method = function(u) return Get.text.client(u, "full") end,
     },
     { title = L["TAG_SUBTITLE_rp:Specific Clients"] },
     { name =  "rp:mrp",                                    alias = { "rp:client-mrp", "rp:myroleplay" },
       method = function(u) return Get.text.client(u, "MRP") end,
       desc =  L["TAG_rp:mrp_DESC"] },
     { name =  "rp:trp",                                    alias = { "rp:client-trp", "rp:trp3", "rp:totalrp", "rp:totalrp3" }, desc = L["TAG_rp:trp_DESC"] ,
       method = function(u) return Get.text.client(u, "TRP") end,
     },
     { name =  "rp:extended",                               alias = { "rp:client-trp-extended", "rp:trp-extended" },
       method = function(u) return Get.text.client(u, "TRPE") end,
       desc =  L["TAG_rp:extended_DESC"] },
     { name =  "rp:xrp",                                    alias = { "rp:client-xrp" },                                         desc = L["TAG_rp:xrp_DESC"],
       method = function(u) return Get.text.client(u, "XRP") end, },
   }, -- tags
 }, -- misc

-- --------------------------------------------------------------------------------------------------------------------------------------------------
 { key = "STATUS", title = L["TAG_GROUP_STATUS_TITLE"], help = L["TAG_GROUP_STATUS_HELP"],
   tags = {
     { name =           "rp:status",                                label = L["TAG_rp:status_LABEL"],     desc =           L["TAG_rp:status_DESC"],
       method = Get.text.status,
       elvui_category = "Status" },
     { name =           "rp:ic",                                    desc =  L["TAG_rp:ic_DESC"],          
     -- elvui_category = "Status",

       method = Get.text.ic,
     },
     { name =           "rp:ooc",                                   desc =  L["TAG_rp:ooc_DESC"],         
     -- elvui_category = "Status",

       method = Get.text.ooc,
     },
     { name =           "rp:npc",                                   desc =  L["TAG_rp:npc_DESC"] ,        
     -- elvui_category = "Classification",

       method = Get.shared.npc,
     },
     { name =           "rp:open",                                  alias = { "rp:lfc", "rp:lfm", },
       method = function(u) return Get.text.extStatus(u, "open") end,
       
     -- elvui_category = "Status",
                                desc =  L["TAG_rp:open_DESC"] },
     { name =           "rp:storyteller",                           alias = { "rp:gm" },                  
     -- elvui_category = "Status",

       method = function(u) return Get.text.extStatus(u, "storyteller") end,
       desc =           L["TAG_rp:storyteller_DESC"] },
     { title =          L["TAG_SUBTITLE_Currently"] },
     { name =           "rp:curr",                                  alias = { "rp:currently" },           
     -- elvui_category = "Status",

       method = Get.text.curr,
       label =          L["TAG_rp:curr_LABEL"],                     desc =  L["TAG_rp:curr_DESC"],        size =           true, },
     { name =           "rp:info",                                  alias = { "rp:oocinfo",   },
       method = Get.text.info,
       
     -- elvui_category = "Status",
                                   label = L["TAG_rp:info_LABEL"],       desc =           L["TAG_rp:info_DESC"],   size = true },
     { title =          L["TAG_SUBTITLE_Roleplaying Experience"] },
     { name =           "rp:experience",                            label = L["TAG_rp:experience_LABEL"], 
     -- elvui_category = "Level",

       method = function(u) return Get.text.xp(u, "long") end,
       desc =           L["TAG_rp:experience_DESC"] },
     { name =           "rp:xp",                                    desc =  L["TAG_rp:xp_DESC"],          
     -- elvui_category = "Level",

       method = function(u) return Get.text.xp(u, "short") end,
       unsup =          "mrp" },
     { name =           "rp:rookie",                                desc =  L["TAG_rp:rookie_DESC"],      
     -- elvui_category = "Level",

       method = function(u) return Get.text.xp(u, "rookie") end,
       unsup =          "mrp" },
     { name =           "rp:volunteer",                             desc =  L["TAG_rp:volunteer_DESC"],   
     -- elvui_category = "Level",

       method = function(u) return Get.text.xp(u, "volunteer") end,
       unsup =          "mrp" },
     }, -- tags

 }, -- status
-- --------------------------------------------------------------------------------------------------------------------------------------------------
 { key = "STYLE", title = L["TAG_GROUP_STYLE_TITLE"], help = L["TAG_GROUP_STYLE_HELP"],
   tags = {
     { title = L["TAG_SUBTITLE_RP Styles"] },
     { name =  "rp:style-ic",                             label = L["TAG_rp:style-ic_LABEL"],           desc = L["TAG_rp:style-ic_DESC"] ,
       method = function(u) return Get.text.style(u, "ic") end,
     },
     { name =  "rp:style-injury",                         label = L["TAG_rp:style-injury_LABEL"],       desc = L["TAG_rp:style-injury_DESC"],
       method = function(u) return Get.text.style(u, "injury") end,
       
     
      }, 
     { name =  "rp:style-death",                          label = L["TAG_rp:style-death_LABEL"],        desc = L["TAG_rp:style-death_DESC"],
       method = function(u) return Get.text.style(u, "death") end,
       
     
      }, 
     { name =  "rp:style-romance",                        label = L["TAG_rp:style-romance_LABEL"],      desc = L["TAG_rp:style-romance_DESC"],
       method = function(u) return Get.text.style(u, "romance") end,
       
     
      }, 
     { name =  "rp:style-battle",                         label = L["TAG_rp:style-battle_LABEL"],       desc = L["TAG_rp:style-battle_DESC"],
       method = function(u) return Get.text.style(u, "battle") end,
       
     
      }, 
     { name =  "rp:style-guild",                          label = L["TAG_rp:style-guild_LABEL"],        desc = L["TAG_rp:style-guild_DESC"],
       method = function(u) return Get.text.style(u, "guild") end,
       
     
      }, 
     { title = L["TAG_SUBTITLE_RP Styles, long form"] },
     { name =  "rp:style-ic-long",                        label = L["TAG_rp:style-ic-long_LABEL"],      desc = L["TAG_rp:style-ic-long_DESC"] ,
       method = function(u) return Get.text.style(u, "ic", "LONG") end,
     },
     { name =  "rp:style-injury-long",                    label = L["TAG_rp:style-injury-long_LABEL"],  desc = L["TAG_rp:style-injury-long_DESC" ],
       method = function(u) return Get.text.style(u, "injury", "LONG") end,
       
     
      }, 
     { name =  "rp:style-death-long",                     label = L["TAG_rp:style-death-long_LABEL"],   desc = L["TAG_rp:style-death-long_DESC"],
       method = function(u) return Get.text.style(u, "death", "LONG") end,
       
     
      }, 
     { name =  "rp:style-romance-long",                   label = L["TAG_rp:style-romance-long_LABEL"], desc = L["TAG_rp:style-romance-long_DESC"],
       method = function(u) return Get.text.style(u, "romance", "LONG") end,
       
     
      }, 
     { name =  "rp:style-battle-long",                    label = L["TAG_rp:style-battle-long_LABEL"],  desc = L["TAG_rp:style-battle-long_DESC"],
       method = function(u) return Get.text.style(u, "battle", "LONG") end,
       
     
      }, 
     { name =  "rp:style-guild-long",                     label = L["TAG_rp:style-guild-long_LABEL"],   desc = L["TAG_rp:style-guild-long_DESC"],
       method = function(u) return Get.text.style(u, "guild", "LONG") end,
       
     
      }, 
     { title = L["TAG_SUBTITLE_All Style Preferences"] },
     { name =  "rp:style-yes",                            label = L["TAG_rp:style-yes_LABEL"],          desc = L["TAG_rp:style-yes_DESC"],
       method = function(u) return Get.text.style(u, "yes") end,
       
     
      }, 
     { name =  "rp:style-no",                             label = L["TAG_rp:style-no_LABEL"],           desc = L["TAG_rp:style-no_DESC"],
       method = function(u) return Get.text.style(u, "no") end,
       
     
      }, 
     { name =  "rp:style-ask",                            label = L["TAG_rp:style-ask_LABEL"],          desc = L["TAG_rp:style-ask_DESC"],
       method = function(u) return Get.text.style(u, "ask") end,
       
     
      }, 

   }, -- tags
 }, -- style

-- --------------------------------------------------------------------------------------------------------------------------------------------------
 { key = "SERVER", title = L["TAG_GROUP_SERVER_TITLE"], help = L["TAG_GROUP_SERVER_HELP"],
   
     -- elvui_category = "Realm",

   tags = {

     { name =  "rp:server",                                 alias = { "rp:server-name" },                label = L["TAG_rp:server_LABEL"],
       method = function(u) return Get.shared.server(u, "name") end,
       desc =  L["TAG_rp:server_DESC"] },
     { name =  "rp:server-mine",                            label = L["TAG_rp:server-mine_LABEL"],       desc =  L["TAG_rp:server-mine_DESC"] ,
       method = function(u) return Get.shared.server(u, "mine") end,
     },
     { name =  "rp:server-notmine",                         label = L["TAG_rp:server-notmine_LABEL"],    desc =  L["TAG_rp:server-notmine_DESC"] ,
       method = function(u) return Get.shared.server(u, "notmine") end,
     },
     { name =  "rp:server-abbr",                            label = L["TAG_rp:server-abbr_LABEL"],       desc =  L["TAG_rp:server-abbr_DESC"] ,
       method = function(u) return Get.shared.server(u, "abbr") end,
     },
     { name =  "rp:server-lang",                            label = L["TAG_rp:server-lang_LABEL"],       desc =  L["TAG_rp:server-lang_DESC"] ,
       method = function(u) return Get.shared.server(u, "lang") end,
     },
     { name =  "rp:server-lang-short",                      label = L["TAG_rp:server-lang-short_LABEL"], desc =  L["TAG_rp:server-lang-short_DESC"] ,
       method = function(u) return Get.shared.server(u, "lang-short") end,
     },
     { name =  "rp:server-region",                          label = L["TAG_rp:server-region_LABEL"],     desc =  L["TAG_rp:server-region_DESC"] ,
       method = function(u) return Get.shared.server(u, "region") end,
     },
     { name =  "rp:server-subregion",                       label = L["TAG_rp:server-subregion_LABEL"],  desc =  L["TAG_rp:server-subregion_DESC"] ,
       method = function(u) return Get.shared.server(u, "subregion") end,
     },
     { name =  "rp:server-type",                            label = L["TAG_rp:server-type_LABEL"],       desc =  L["TAG_rp:server-type_DESC"] ,
       method = function(u) return Get.shared.server(u, "type") end,
     },
     { name =  "rp:server-type-short",                      label = L["TAG_rp:server-type-short_LABEL"], desc =  L["TAG_rp:server-type-short_DESC"] ,
       method = function(u) return Get.shared.server(u, "type-short") end,
     },
     { title = L["TAG_SUBTITLE_Conditional Punctuation"] },
     { name =  "rp:server-star",                            alias = { "rp:server-asterisk" },            desc =  L["TAG_rp:server-star_DESC"] ,
       method = function(u) return Get.shared.server(u, "star") end,
     },
     { name =  "rp:server-dash",                            alias = { "rp:server-hyphen",   },
       method = function(u) return Get.shared.server(u, "dash") end,
       desc =  L["TAG_rp:server-dash_DESC"] },

    }, -- tags
 }, -- server

-- --------------------------------------------------------------------------------------------------------------------------------------------------
 { key = "SOCIAL", title = L["TAG_GROUP_SOCIAL_TITLE"], help = L["TAG_GROUP_SOCIAL_HELP"],
   tags = {
     { name =           "rp:alignment",              label = L["TAG_rp:alignment_LABEL"],   desc =           L["TAG_rp:alignment_DESC"],
       method = function(u) return Get.text.misc("alignment", u) end,
       unsup =          "mrp",                       size =  true },
     { name =           "rp:family",                 label = L["TAG_rp:family_LABEL"],      
     -- elvui_category = "Guild",

       method = function(u) return Get.text.misc("family", u) end,
       desc =           L["TAG_rp:family_DESC"],     size =  true },
     { name =           "rp:house",                  label = L["TAG_rp:house_LABEL"],       
     -- elvui_category = "Guild",

       method = function(u) return Get.text.misc("house", u) end,
       desc =           L["TAG_rp:house_DESC"],      size =  true },
     { name =           "rp:guild",                  alias = { "rp:guild-name" },           label =          L["TAG_rp:guild_LABEL"],
       method = function(u) return Get.text.guild(u, "name") end, extraEvents = "PLAYER_GUILD_UPDATE GUILD_ROSTER_UPDATE",
       
     -- elvui_category = "Guild",
                     desc =  L["TAG_rp:guild_DESC"],        size =           true,  },
     { name =           "rp:guild-rank",             label = L["TAG_rp:guild-rank_LABEL"],  
     -- elvui_category = "Guild",

       method = function(u) return Get.text.guild(u, "rank") end, extraEvents = "PLAYER_GUILD_UPDATE GUILD_ROSTER_UPDATE",  
       desc =           L["TAG_rp:guild-rank_DESC"], size =  true },
     { name =           "rp:guild-status",           desc =  L["TAG_rp:guild-status_DESC"], 
     -- elvui_category = "Guild",

       method = function(u) return Get.text.guild(u, "status") end, extraEvents = "PLAYER_GUILD_UPDATE GUILD_ROSTER_UPDATE",  
       unsup =          "mrp" },
     { name =           "rp:motto",                  label = L["TAG_rp:motto_LABEL"],       desc =           L["TAG_rp:motto_DESC"],
       method = function(u) return Get.text.misc("motto", u) end,
       size =           true },
     { name =           "rp:religion",               alias = { "rp:faith" },                label =          L["TAG_rp:religion_LABEL"],
       method = function(u) return Get.text.misc("religion", u) end,
       desc =           L["TAG_rp:religion_DESC"],   
     
                         size =           true },
     { name =           "rp:rstatus",                label = L["TAG_rp:rstatus_LABEL"],     desc =           L["TAG_rp:rstatus_DESC"],
       method = function(u) return Get.text.misc("rstatus", u) end,
       size =           true },
     { name =           "rp:home",                   alias = { "rp:residence" },            label =          L["TAG_rp:home_LABEL"],
       method = Get.text.home,
       desc =           L["TAG_rp:home_DESC"],       size =  true },
     { name =           "rp:sexuality",              label = L["TAG_rp:sexuality_LABEL"],   desc =           L["TAG_rp:sexuality_DESC"],
       method = function(u) return Get.text.misc("sexual", u) end,
       unsup =          "mrp",                       size =  true },
     { name =           "rp:tribe",                  label = L["TAG_rp:tribe_LABEL"],       
     -- elvui_category = "Guild",

       method = function(u) return Get.text.misc("tribe", u) end,
       desc =           L["TAG_rp:tribe_DESC"],      size =  true },

   }, -- tags ##
 }, -- social

 { key = "TARGET", title = L["TAG_GROUP_TARGET_TITLE"], help = L["TAG_GROUP_TARGET_HELP"],
   
     -- elvui_category = "Target",

   tags = {
     { name =  "rp:target",                       alias = { "rp:target-name" },                  label = L["TAG_rp:target_LABEL"],
       method = function(u) return Get.shared.target(u, "name") end, extraEvents = "UNIT_TARGET",
       desc =  L["TAG_rp:target_DESC"],           size =  true },
     { name =  "rp:target-class",                 label = L["TAG_rp:target-class_LABEL"],        desc =  L["TAG_rp:target-class_DESC"],
       method = function(u) return Get.shared.target(u, "class") end, extraEvents = "UNIT_TARGET",
       size =  true },
     { name =  "rp:target-gender",                label = L["TAG_rp:target-gender_LABEL"],       desc =  L["TAG_rp:target-gender_DESC"],
       method = function(u) return Get.shared.target(u, "gender") end, extraEvents = "UNIT_TARGET",
       size =  true },
     { name =  "rp:target-race",                  label = L["TAG_rp:target-race_LABEL"],         desc =  L["TAG_rp:target-race_DESC"],
       method = function(u) return Get.shared.target(u, "race") end, extraEvents = "UNIT_TARGET",
       size =  true },
     { name =  "rp:target-status",                desc =  L["TAG_rp:target-status_DESC"] ,
       method = function(u) return Get.shared.target(u, "status") end, extraEvents = "UNIT_TARGET",
     },
     { name =  "rp:target-title",                 label = L["TAG_rp:target-title_LABEL"],        desc =  L["TAG_rp:target-title_DESC"],
       method = function(u) return Get.shared.target(u, "title") end, extraEvents = "UNIT_TARGET",
       size =  true },
     { title = L["TAG_SUBTITLE_Colors"] },
     { name =  "rp:target-color",                 desc =  L["TAG_rp:target-color_DESC"] ,
       method = function(u) return Get.shared.target(u, "color") end, extraEvents = "UNIT_TARGET",
     },
     { name =  "rp:target-gendercolor",           desc =  L["TAG_rp:target-gendercolor_DESC"],
       method = function(u) return Get.shared.target(u, "gendercolor") end, extraEvents = "UNIT_TARGET",
     },
     { name =  "rp:target-statuscolor",           desc =  L["TAG_rp:target-statuscolor_DESC"] ,
       method = function(u) return Get.shared.target(u, "statuscolor") end, extraEvents = "UNIT_TARGET",
     },
     { title = L["TAG_SUBTITLE_Icons"] },
     { name =  "rp:target-icon",                  desc =  L["TAG_rp:target-icon_DESC"] ,
       method = function(u) return Get.shared.target(u, "icon") end, extraEvents = "UNIT_TARGET",
     },
     { name =  "rp:target-gendericon",            desc =  L["TAG_rp:target-gendericon_DESC"] ,
       method = function(u) return Get.shared.target(u, "gendericon") end, extraEvents = "UNIT_TARGET",
     },
     { name =  "rp:target-statusicon",            desc =  L["TAG_rp:target-statusicon_DESC"] ,
       method = function(u) return Get.shared.target(u, "statusicon") end, extraEvents = "UNIT_TARGET",
     },
     { title = L["TAG_SUBTITLE_Shorthand Tag"] },
     { name =  "rp:target-details",               label = L["TAG_rp:target-details_LABEL"],      desc =  L["TAG_rp:target-details_DESC"],
       method = function(u) return Get.shared.target(u, "details") end, extraEvents = "UNIT_TARGET",
       size =  true },

     }, -- tags
  }, -- target
-- --------------------------------------------------------------------------------------------------------------------------------------------------

{ key = "OUF", title = L["TAG_GROUP_OUF_TITLE"], help = L["TAG_GROUP_OUF_HELP"],
  external = true,
  tags = {
      -- {  name = "affix",               no_ prefix = true, },
      -- {  name = "arcanecharges",       no_ prefix = true, },
      -- {  name = "arenaspec",           no_ prefix = true, },
      -- {  name = "chi",                 no_ prefix = true, },
      -- {  name = "cpoints",             no_ prefix = true, },
      -- {  name = "curhp",               no_ prefix = true, },
      -- {  name = "curmana",             no_ prefix = true, },
      -- {  name = "curpp",               no_ prefix = true, },
      -- {  name = "deficit:name",        no_ prefix = true, },
      -- {  name = "holypower",           no_ prefix = true, },
      -- {  name = "leader",              no_ prefix = true, },
      -- {  name = "leaderlong",          no_ prefix = true, },
      -- {  name = "maxhp",               no_ prefix = true, },
      -- {  name = "maxmana",             no_ prefix = true, },
      -- {  name = "maxpp",               no_ prefix = true, },
      -- {  name = "missinghp",           no_ prefix = true, },
      -- {  name = "missingpp",           no_ prefix = true, },
      -- {  name = "perhp",               no_ prefix = true, },
      -- {  name = "perpp",               no_ prefix = true, },
      -- {  name = "plus",                no_ prefix = true, },
      -- {  name = "powercolor",          no_ prefix = true, },
      -- {  name = "raidcolor",           no_ prefix = true, },
      -- {  name = "rare",                no_ prefix = true, },
      -- {  name = "runes",               no_ prefix = true, },
      -- {  name = "shortclassification", no_ prefix = true, },
      -- {  name = "smartlevel",          no_ prefix = true, },
      -- {  name = "soulshards",          no_ prefix = true, },
      -- {  name = "threat",              no_ prefix = true, },
      -- {  name = "threatcolor",         no_ prefix = true, },
      -- 

      { name = "level",          desc = L["TAG_level_DESC"],          no_prefix = true },  -- these need to be orderd by the description, as done here
      { name = "smartclass",     desc = L["TAG_smartclass_DESC"],     no_prefix = true },
      { name = "creature",       desc = L["TAG_creature_DESC"],       no_prefix = true },
      { name = "dead",           desc = L["TAG_dead_DESC"],           no_prefix = true },
      { name = "class",          desc = L["TAG_class_DESC"],          no_prefix = true },
      { name = "faction",        desc = L["TAG_faction_DESC"],        no_prefix = true },
      { name = "name",           desc = L["TAG_name_DESC"],           no_prefix = true },
      { name = "race",           desc = L["TAG_race_DESC"],           no_prefix = true },
      { name = "sex",            desc = L["TAG_sex_DESC"],            no_prefix = true },
      { name = "status",         desc = L["TAG_status_DESC"],         no_prefix = true },
      { name = "group",          desc = L["TAG_group_DESC"],          no_prefix = true },
      { name = "offline",        desc = L["TAG_offline_DESC"],        no_prefix = true },
      { name = "pvp",            desc = L["TAG_pvp_DESC"],            no_prefix = true },
      { name = "difficulty",     desc = L["TAG_difficulty_DESC"],     no_prefix = true },
      { name = "resting",        desc = L["TAG_resting_DESC"],        no_prefix = true },
      { name = "classification", desc = L["TAG_classification_DESC"], no_prefix = true },
    }, -- tags ##
  }, -- ouf
}; -- TAG_DATA


end);

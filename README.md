# RP\_TAGS
## Or, rp:Tags, or [rp:tags], or ...

> **Important:** This version of the AddOn isn't functional yet! If you use it right now,
> it will probably break. When the new version is ready, it will be posted to
> CurseForge.

RP\_Tags lets you create customized unit frames based on fields from roleplaying 
profiles, such as those used by [totalRP3](https://www.curseforge.com/wow/addons/total-rp-3) or
[MyRolePlay](https://www.curseforge.com/wow/addons/my-role-play). This lets you choose 
which details are most important to you.

### What's a Unit Frame? What's a tag?

Unit frames are the boxes on your screen that show information about specific units -- 
for example, yourself ("Player" frame), your target ("Target"), your 
focus ("Focus"), or your target's target("TargetTarget").

These are created by addons such as [ElvUI](https://www.tukui.org/download.php?ui=elvui)

A tag is simply a word encased in square brackets that you use to customize unit frames.
The tags in RP\_Tags all start with `rp:` (with a few exceptions) and so, rp:tags.

Examples include:

| rp:tag            | Displays                                                               |
| :---------------: | :----------------------------------------                              |
|  `[rp:name]`      | The unit's roleplaying name                                            |
|  `[rp:race]`      | The unit's RP race, which might not be the same as their in-game race  |
|  `[rp:icon]`      | The unit's icon                                                        |
|  `[rp:age]`       | The unit's age. if listed                                              |
| `[rp:color]`      | Changes the following text to the unit's chosen color                  |

## Installation

The easiest way to install this is by [going to CurseForge](https://www.curseforge.com/wow/addons/rp-tags).

If you want to install it manually, go to your WoW directory, then `_retail_`,
`Interface`, `AddOns`, and unzip it there.

It will produce not one, not two, but *five* different addons?!

    RP_Tags/
    RP_Tags_ElvUI/
    RP_Tags_MyRolePlay/
    RP_Tags_totalRP3/
    RP_UnitFrames/

To understand why, we need to talk about ...

## AddOn Structure

This version of RP\_Tags is built on a modular base. Everything
that is specific to a certain module has been isolated there.
This allows us to use WoW's normal AddOn management system to
best adavantage.

For example, everything related to 
integrating [MyRolePlay](https://www.curseforge.com/wow/addons/my-role-play)
into the RP\_Tags framework can be found in `RP_Tags_MyRolePlay`.

The module won't load if you aren't running MyRolePlay.
Okay, it *might*, but we can't be responsible for any error messages
you might see! That said, we do have code to minimize actual errors
of that kind, instead popping up RP\_Tags alerts.

### rpClients and unitFrames

There are two kinds of modules for RP\_Tags:

 - A **Roleplaying AddOn** module that lets RP\_Tags access information
   about characters from a RP AddOn such as 
   [MyRolePlay](https://www.curseforge.com/wow/addons/my-role-play),
   which provides the information about
   characters by sending, receiving, and storing RP profiles; and

 - A **Unit Frames AddOn** module to display that information in a
   customizable format, such as the unit frames provided by
   [ElvUI](https://www.tukui.org/download.php?ui=elvui)

This means that you're going to have five addons active:

 1  Your roleplaying addon;
 2  A rpClient module that serves as a bridge between 
    RP\_Tags and the roleplaying addon;
 3  RP\_Tags itself, which provides the core functions;
 4  A unitFrames module that is the bridge to a unit frames
    Addon; and
 5  Your unitFrames addon itself.

The second, third, and fourth are all included with RP\_Tags.
In fact, we've even thrown in a simple unit frames addon as 
well, called RP\_UnitFrames, which can run alongside or parallel to
ElvUI's or Blizzard's frames.

### Supported AddOns

The current version of RP\_Tags supports integration with these
addons:

| AddOn Name             |   rpClient     |     unitFrames   |
| :-------------         |  :--------:    |    :----------:  |
| Blizzard's unit frames |     --         |        No        |
| ElvUI                  |     --         |        Yes       |
| MyRolePlay             |     Yes        |        --        |
| RP\_UnitFrames         |     --         |        Yes       |
| Total RP 3             |     Yes        |        --        |
| XRP                    |     No         |        --        |

## Using RP\_Tags

Assuming that you've got both a supported RP addon and a supported
unit frames addon, you can just start using the new tags wherever
they're found in your unit frames addon.

In ElvUI, you type `/ec` to open the options page, go to the 
Unit Frames section, and then choose a frame, such as your target
or the members of your party. Pick a field as Power -- or create a
custom field -- and then enter one or more rp:tags into the box.

In RP\_UnitFrames it's similar; you can specify not only what you
see when you are viewing the frame, but also the tooltip shown
when you mouse-over those sections of the frame. For example, you
could use this in the "Name" panel:

    [rp:name]

And this in the "Name Tooltip" panel:

    [rp:shorttitle] [rp:firstname] [rp:lastname] [br] [rp:title]

## rp:tags

A tag, in this sense, consists of an opening square
bracket -- `[` -- then the letters `rp`, then a colon -- `:` --
and the name of the tag in lowercase, all ending with a
closing square bracket, `]`.

You saw one example above. Here's another:

    [rp:glance-3-icon] [rp:glance-3] [rp:glance-3-text]

This serieso tags would display the subject's third "At First
Glance" icon, the title of it, and the associated description.

If any of those *aren't* set, nothing will be shown for that
setting.

## List of rp:tags

The full list of rp:tags is long -- and you can use modifier
tags on many as well. For that reason, we're not giving a complete
list here, but they are all listed in the online help that you
can access by typing `/rptags` (or just `/rpt` if you want).

### Modifier Tags

There are two types of modifier tags -- labels and sizes. 
A modifier is applied after the main tag, with a color (`:`)
between them. Like this:

    [rp:title:label] [rp:title:xs]

> Title: Stormwind Fashion Icon Storm

You can even mix the two if you want, but if you do, the `:label`
modifier has to come first:

    [rp:title:label:xs]

> Title: Storm

These two sequences don't actually do the same thing. The first one
puts a label in front of the unit's title, then the titled, 
followed again by their title -- but only the first 5 characters --
`:xs` stands for "extra small."

While the combined tag displays a label before the unit's title,
and then 5 their title itself -- but again, only 5 characters.

| Modifiers                   |   Abbreviations  |  Size          |
| :-------------------------- | :--------------: | -------------: |
| `:extrasmall`, `:veryshort` | `:xs`, `:vs`     | 5 characters   |
| `:small`, `:short`          | `:s`             | 10 characters  |
| `:medium`                   | `:m`             | 15 characters  |
| `:large`, `:long`           | `:l`             | 20 characters  |
| `:extralarge`, `:verylong`  | `:xl`, `:vl`     | 50 characters  |
| `:extraextralarge`          | `:xxl`           | 100 characters |
|                             | `:2x`, `:2xl`    | 150 characters |
|                             | `:3x, `:3xl`     | 250 characters |
| --                          | --               | no limit       |

## /Slash Commands

The following commands can be typed into the normal WoW chat box:

    /rptags

This brings up the help, tag reference, and configuration screen.

    /rptags options

The configuration screen.

    /rptags colors

The color screen.

    /rptags keybind

The keybindings.

    /rptags changes

The new changes since the previous version of RP\_Tags.

    /rptags version

The version number of RP\_Tags and associated modules and other addons.

## Configuration

Configuration is fairly simple; you can set your own colors for many of
the `color` tags, the formats for fields like height and weight (feet and
inches, or meters and centimeters?) and so on.

You *don't* have to tell RP\_Tags which rpClient or unitFrames modules to use;
it can figure out which ones to use based on which of the supported addons
you're already using.

## Localization

The addon is currently only available in English, but if you want help with
translations into other languages, you can.

## To Do

(Primarily for my own use)

  - Get configuration/~~help working~~
  - Get RP:UF working
  - XRP support
  - Config profiles with Ace3
  - `:xs`, `:s`, etc
  - Update for new gender settings in trp3
  - Something I forgot
  - ~~Make sure all the libraries are current~~
  - See if RPT can be generalized for any oUF addon
  - Miscellaneous bug fixes


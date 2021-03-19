-- RP Tags for ElvUI and Total RP 3
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
-- This work is licensed under the Creative Commons Attribution 4.0 International (CC BY 4.0) license.
local RPTAGS = RPTAGS;

RPTAGS.queue:WaitUntil("DATA_LOCALE",
function(self, event, ...)

local CONST = RPTAGS.CONST;
local Icon = CONST.ICONS;
local L = LibStub("AceLocale-3.0"):NewLocale(CONST.APP_ID, "enUS", true);

local T_ = Icon.T_;
local _t = Icon._t;

-- US English localization 
  L["INTRO_MD"] = 
[===[
# Introduction

rpTags lets you create custom unit frames displaying information drawn from
your roleplaying addons, such as [MyRolePlay](urldb://mrp) or
[Total RP 3](urldb://trp3).

## What's a Unit Frame?

A unit frame is a window on your screen that appears when a certain 
type of unit exists in the game. For example, the Target Unit Frame is 
shown when you target someone; until then, the "target" unit is undefined
for you.

rpTags works with a unit frames addon to display specialized unit frames.
Supported unit frame addons are [ElvUI](urldb://elvui) and rpUnitFrames
(which is included with rpTags).

## What's a Tag?

A tag, in this context, refers to a string of text that will be interpreted
by the unit frames addon as information.

Tags follow this general format:

    [rp:tagname]

There are over 300 rp:tags you can use, as well as several dozen 
provided by oUF, the framework upon which rpUnitFrames is built. 
Some of the most useful tags include:
]===];

  L["FMT_GROUPLIST_MD"] =
[===[
## [%s](opt://help/tags/%s)

%s
]===];

  L["INTRO_2_MD"] =
[===[
## Further Help

If you need more assistance, you can peruse the rest of these help 
topics or ask for assistance on the [RPTAGS discord](urldb://discord) 
or ask [Oraibi on twitter](urldb://twitter).
The easiest way to learn is to just start editing tags and experimenting. Have fun!
]===];

  L["DISABLED_NBCOLOR_MD"] =
[===[
The color for non-binary gender is currently disabled, because you haven't
enabled the option to [Parse Gender](setting://genderal/parse).
]===];
  L["DISABLED_HW_MD"] =
[===[
Height and weight formats are currently disabled, because you don't have [Parse Height and Weight](setting://general/parse) enabled.
]===];
  L["OPTIONS_MD"] = 
[===[
# Options

All settings are available through the rpTags options system.

[General Settings](opt://general) let you determine what messages to show, 
how to display certain tags, and how to respond
to notes that you've set on a unit. 

[Colors Settings](opt://colors) let you change the various colors used by RPTAGS.
]===];

  L["TAG_MODIFIERS_MD"] = 
[===[
# Tag Modifiers
There are two types of tag modifiers that change how a tag is displayed: **labels** and **size modifiers**.

## Labels

A label modifier can be applied to most tags that display information. 
You create a label tag by adding `-label` to the end of the tag. For example:

    [rp:fulltitle-label]

This will display a label before the unit's title:

> Title: Stormwind Fashion Icon

If a given unit doesn't have the listed field, nothing will be displayed. 
If you want to display a label anyway, simply create your own label in text:

    Title: [rp:fulltitle]

That will display even if the unit has no full title set:

> Title: 

Icon tags and color tags never display labels.

## Size Modifiers

A size modifier is also applied after a tag, and consists of a size in parentheses.

    [rp:fulltitle(8)]

The size given is the number of characters that will be displayed:

> Stormwin

You can use characters, or you can use keywords. The valid size keywords are:
]===];

L["TAG_MODIFIERS_2_MD"] = 
[===[
For example:

    [rp:fulltitle(medium)]

> Stormwind Fashi

    [rp:fulltitle(xs)]

> Storm

The length corresponding to each keyword can be changed by you 
in [Tag Size Options](setting://general/sizes).

|cffff9900Important note!|r ElvUI currently does not recognize tags with
numeric size modifiers (such as `(8)`); if you're using ElvUI you'll need
to use only keyword size modifiers, such as `(small)` or `(xl)`.

]===];

L["DEBUGGING_MESSAGE_MD"] =
[===[
To load debugging information, erase this message and replace it with only one of the following, no blank lines or leading spaces:

   |cffff0000debug|r |cffffff00libs|r
   |cffff0000debug|r |cffffff00addons|r    
   |cffff0000debug|r |cffffff00config|r
   
You can enter more than one, separated by spaces, but this is |cffff0000NOT|r recommended as it may cause your WoW client to lag indefinitely.
]===];
L["DEBUGGING_COMMANDS_MD"] = 
[===[
# Debugging Commands

Please |cffdd0000be very careful|r if using these commands; in general, you shouldn't need to execute them
unless instructed to by Oraibi. Some may erase your data.

### &nbsp; /rptags version
Lists the version of RPTAGS, plus the versions of associated programs. |cff00dd00Safe.|r

### &nbsp; /dump RP|cff000000|rTAGS.cache.state
If the previous command doesn't work, this will give the same information, albeit in a less readable form. |cff00dd00Safe.|r

### &nbsp; /dump RP|cff000000|rTAGS.cache.startLog
This will list each file in RPTAGS that loaded successfully, in order. If the last entry is 'Startup routines finished.', then 
everything loaded okay. |cff00dd00Safe.|r

### &nbsp; /script RP_TagsDB.settings = nil
Reset all your RPTAGS settings back to their defaults. |cffdd0000Caution.|r This is like doing a factory reset on your phone, but for RPTAGS.
You will need to use the [[/reload]] command to restart your WoW UI.

### &nbsp; /script RP_TagsDB.TRP3_Config_Imported = nil
This tells RPTAGS to try to re-import the RPTAGS settings previously stored in Total RP 3's config system. |cffdd0000Caution.|r This could overwrite
some of your current RPTAGS settings.
You will need to use the [[/reload]] command to restart your WoW UI.
]===];

L["CHANGES_MD"] = 
[===[

# Changes

## 9.0.5.5

- Fixed layouts
- Added new "BLIZZLIKE" layout
- Other bug fixes

## 9.0.5.2

- Removed a pair of debugging statements that were left in. Oops!

## 9.0.5.1

- First release for WoW 9
- rpUnitFrames should be working
- rpTags now supports Listener as well
- The addon is modularized; if you don't want to load a module, you can
  disable it -- or even delete it
- By default, rpTags will look for which other supported addons you have
  installed and enabled
- Added [rp:me] tags, plus [rp:listen] tags
- Help and configuration are all via the `/rptags` (or `/rpt`) command
- Tag sizes now supported -- use [rp:tagname(medium)] or [rp:tagname(m)]
  on ElvUI and rpUnitFrames; use [rp:tagname(10)] on rpUnitFrames

## 9.0.5.0 beta 3

Minor fixes:

- RP\_UnitFrames less broken
- Labels work (again)
- Various other bug fixes
- Removed all but one font; font collection moved to [rpFonts](urldb://rpfonts)

## 9.0.5.0 beta 1

Major updates including:

- Updated for WoW 9.0.5
- Version numbers now aligned with WoW's version numbers
- Many behind-the-scenes changes
- Added tag sizing `(xs)`, `(large)`, '(8)` etc
- Modules now load separately via WoW's addon dependencies system
- Updated [Help](opt://help)
- Revamped [About](opt://about)
- Redid [Options](opt://general)
- Restored USE\_REAL\_ELLIPSES
- Libraries updated
- Other bug fixes

### RP\_Tags\_ElvUI

- Tags are now categorized correctly in ElvUI, with the problem that the Miscellaneous category is broken.

## Coming Soon:

### RP_UnitFrames

- Frames can now be configured separately or linked to the [shared settings](opt://RPUF_Main)
- Editor improvements
- LibSharedMedia support on frames
- Live Previews for tag strings
- Restored TargetTarget frame

## 0.960

- Updated for WoW 8.2.
- Fixed bug.

## 0.952

- Fixed several bugs

## 0.951

- Added keybindings for RPTAGS help, RPTAGS options.
- Added keybinding for [[Open Mouseover Profile]] in both MRP and TRP3.
- Fixed a bug preventing the importation of RPTAGS options previously saved in Total RP 3's config system.

## 0.950

- Fixed some bugs since the previous verison;
- Re-added the reference menu in Options
- Something else that slips my mind.

## 0.940 beta 10

- Bug fixes;
- Added more granular control over hiding rp:UnitFrames;
- Styling of rp:UnitFrames status bar.

## 0.940 beta 8

- Bug fixes for MyRolePlay support, 
- removed TargetTarget frame, 
- added [rp:target] tags.

## 0.940 beta 6

- Improved support for running alongside mrp, including glances.

## 0.940 beta 2

Some relatively major changes since the last major release:

- New options system integrated with the WoW Interface -> AddOns menu. 
- Improved context menu on rp:UnitFrames. 
- Toggle rp:UnitFrames off and on without having to restart WoW. 
- Individual scaling for rp:UnitFrames. 
- Key bindings to toggle rp:UF, lock/unlock frames, hide in combat, open the tag editor, and go IC/OOC with supported clients. 
- Limited -- very limited -- support for using rp:tags with MyRolePlay. (Integration not completed so you should consider that an alpha.) 
- Minor bug fixes.
 
## 0.937

- Bug fixes. So many bug fixes. askdjfalshglaksdjfkasjfkadfh

## 0.936

- Fixed a bug. Don't use 0.935.
 
## 0.934

- Changed how rp:UnitFrames handle unknown tags. Instead of just crashing, it will now mark unknown tags with internal [err] [/err] tags displayed in
- red text in rp:UnitFrames.
- Minor fix to the tag editor: if an error is detected, the editbox will now highlight (select) the first unknown tag.
- Removed non-functioning line-wrapping code intended for ElvUI use.
- Made trp3 an "optional" dependency in preparation for mrp integration.

## 0.933

Fixed:

- [rp:guild] tags, they weren't working right before.

Added:

- Option to hide rp:UnitFrames in combat, accessible via context menu or trp3 config screens. Also hides in vehicles, pet battles, when dead. 
- [rp:guildstatuscolor], uses your "IC"/"OOC"/"NPC"/"Unknown" colors based on whether the unit's guild membership is IC or not. 
- [rp:actor] (or [rp:actress], same tag), defaults to [rp:faceclaim] or [rp:voiceclaim] if actor isn't set. 
- [rp:bodyclaim], works like [rp:faceclaim] and [rp:voiceclaim]. 

## 0.932

Changed the way you move rp:UnitFrames around on the screen. (Including clamping to them to screen so you can't accidentally drag them away.)

- Use the context menu or the trp3 config screen to unlock frames. A drag tab appears. 
- Drag the drag tab around to the desired location. 
- Click the lock to lock all frames in place, or click the reset button to restore frames to their default locations. 
- The latter will re-attach focus and targettarget to player and target frames respectively.
 
## 0.931

Most of the improvements are to rp:UnitFrames.

- Added configurable tooltips that can take rp:tags for the various parts of a unit frame.
- Added two new layouts, Portrait (which is loosely modeled after WoW's "paperdoll" window) and Thumbnail.
- Added context menus accessible via right-click for direct editing of panel and tooltip tags, plus changing the layout.
- Added rp:nick-quoted tag.
- Various bug fixes.
 
## 0.925

Adds the ability to run rp:UnitFrames alongside ElvUI unit frames. This is known as "parallel mode".

rp:tags now runs in three modes:

- "standalone", using rp:UF to display tags; 
- "elvui", using ElvUI to display tags; 
- "parallel", with both rp:UF and ElvUI displaying tags
 
## 0.920

- Improvements to the tag editor.
- New tags include [rp:style], [rp:client], [rp:server], [rp:friendcolor], [rp:guildcolor], [rp:partycolor], [rp:guild], and more.
- You can now change the colors of the rp:UF frames.
- Some other random cool stuff.

## 0.901

- Added standalone mode that operates without requiring ElvUI. 
- Added reference for tags in configuration settings for totalRP3. 
- Added several miscellaneous tags such as [rp:relation], [rp:relationcolor], and [rp:relationicon]. 
- Updated [rp:rstatus] to work with trp3's new relation status field. 
- Minor bug fixes.
 
## 0.850

- Updated for 8.1, changed a little about how wrapping and field size for glances work.

## Older Versions

For versions of RPTAGS prior to WoW 8.1, please see CurseForge.

]===];

  L["CREDITS_MD"] = 
[===[
# Credits

RPTAGS was created by |cffbb00bbOraibi|r of the Moon Guard server.
[Email Oraibi](mailto:kivaoraibi@gmail.com)

Libraries used to create RPTAGS include 
LibStub by Kaelten, Cladhaire, ccknight, Mikk, Ammo, Nevcairiel, and johsborke;
LibRealmInfo by Phanx; and LibSharedMedia by Elkano.
]===];

L["TAG_REFERENCE_MD"] = 
[===[
# Tag Reference

The categories of tags are:
]===];


L["LICENSE_MD"] = 
[===[
# Creative Commons Attribution 4.0 International

Creative Commons Corporation (“Creative Commons”) is not a law firm and does not provide legal services or legal advice. Distribution of Creative Commons public licenses does not create a lawyer-client or other relationship. Creative Commons makes its licenses and related information available on an “as-is” basis. Creative Commons gives no warranties regarding its licenses, any material licensed under their terms and conditions, or any related information. Creative Commons disclaims all liability for damages resulting from their use to the fullest extent possible.

### Using Creative Commons Public Licenses

Creative Commons public licenses provide a standard set of terms and conditions that creators and other rights holders may use to share original works of authorship and other material subject to copyright and certain other rights specified in the public license below. The following considerations are for informational purposes only, are not exhaustive, and do not form part of our licenses.

 * __Considerations for licensors:__ Our public licenses are intended for use by those authorized to give the public permission to use material in ways otherwise restricted by copyright and certain other rights. Our licenses are irrevocable. Licensors should read and understand the terms and conditions of the license they choose before applying it. Licensors should also secure all rights necessary before applying our licenses so that the public can reuse the material as expected. Licensors should clearly mark any material not subject to the license. This includes other CC-licensed material, or material used under an exception or limitation to copyright. [More considerations for licensors](http://wiki.creativecommons.org/Considerations_for_licensors_and_licensees#Considerations_for_licensors).

 * __Considerations for the public:__ By using one of our public licenses, a licensor grants the public permission to use the licensed material under specified terms and conditions. If the licensor’s permission is not necessary for any reason–for example, because of any applicable exception or limitation to copyright–then that use is not regulated by the license. Our licenses grant only permissions under copyright and certain other rights that a licensor has authority to grant. Use of the licensed material may still be restricted for other reasons, including because others have copyright or other rights in the material. A licensor may make special requests, such as asking that all changes be marked or described. Although not required by our licenses, you are encouraged to respect those requests where reasonable. [More considerations for the public](http://wiki.creativecommons.org/Considerations_for_licensors_and_licensees#Considerations_for_licensees).

## Creative Commons Attribution 4.0 International Public License

By exercising the Licensed Rights (defined below), You accept and agree to be bound by the terms and conditions of this Creative Commons Attribution 4.0 International Public License ("Public License"). To the extent this Public License may be interpreted as a contract, You are granted the Licensed Rights in consideration of Your acceptance of these terms and conditions, and the Licensor grants You such rights in consideration of benefits the Licensor receives from making the Licensed Material available under these terms and conditions.

### Section 1 – Definitions.

a. __Adapted Material__ means material subject to Copyright and Similar Rights that is derived from or based upon the Licensed Material and in which the Licensed Material is translated, altered, arranged, transformed, or otherwise modified in a manner requiring permission under the Copyright and Similar Rights held by the Licensor. For purposes of this Public License, where the Licensed Material is a musical work, performance, or sound recording, Adapted Material is always produced where the Licensed Material is synched in timed relation with a moving image.

b. __Adapter's License__ means the license You apply to Your Copyright and Similar Rights in Your contributions to Adapted Material in accordance with the terms and conditions of this Public License.

c. __Copyright and Similar Rights__ means copyright and/or similar rights closely related to copyright including, without limitation, performance, broadcast, sound recording, and Sui Generis Database Rights, without regard to how the rights are labeled or categorized. For purposes of this Public License, the rights specified in Section 2(b)(1)-(2) are not Copyright and Similar Rights.

d. __Effective Technological Measures__ means those measures that, in the absence of proper authority, may not be circumvented under laws fulfilling obligations under Article 11 of the WIPO Copyright Treaty adopted on December 20, 1996, and/or similar international agreements.

e. __Exceptions and Limitations__ means fair use, fair dealing, and/or any other exception or limitation to Copyright and Similar Rights that applies to Your use of the Licensed Material.

f. __Licensed Material__ means the artistic or literary work, database, or other material to which the Licensor applied this Public License.

g. __Licensed Rights__ means the rights granted to You subject to the terms and conditions of this Public License, which are limited to all Copyright and Similar Rights that apply to Your use of the Licensed Material and that the Licensor has authority to license.

h. __Licensor__ means the individual(s) or entity(ies) granting rights under this Public License.

i. __Share__ means to provide material to the public by any means or process that requires permission under the Licensed Rights, such as reproduction, public display, public performance, distribution, dissemination, communication, or importation, and to make material available to the public including in ways that members of the public may access the material from a place and at a time individually chosen by them.

j. __Sui Generis Database Rights__ means rights other than copyright resulting from Directive 96/9/EC of the European Parliament and of the Council of 11 March 1996 on the legal protection of databases, as amended and/or succeeded, as well as other essentially equivalent rights anywhere in the world.

k. __You__ means the individual or entity exercising the Licensed Rights under this Public License. __Your__ has a corresponding meaning.

### Section 2 – Scope.

a. ___License grant.___

 1. Subject to the terms and conditions of this Public License, the Licensor hereby grants You a worldwide, royalty-free, non-sublicensable, non-exclusive, irrevocable license to exercise the Licensed Rights in the Licensed Material to:

 A. reproduce and Share the Licensed Material, in whole or in part; and

 B. produce, reproduce, and Share Adapted Material.

 2. __Exceptions and Limitations.__ For the avoidance of doubt, where Exceptions and Limitations apply to Your use, this Public License does not apply, and You do not need to comply with its terms and conditions.

 3. __Term.__ The term of this Public License is specified in Section 6(a).

 4. __Media and formats; technical modifications allowed.__ The Licensor authorizes You to exercise the Licensed Rights in all media and formats whether now known or hereafter created, and to make technical modifications necessary to do so. The Licensor waives and/or agrees not to assert any right or authority to forbid You from making technical modifications necessary to exercise the Licensed Rights, including technical modifications necessary to circumvent Effective Technological Measures. For purposes of this Public License, simply making modifications authorized by this Section 2(a)(4) never produces Adapted Material.

 5. __Downstream recipients.__

 A. __Offer from the Licensor – Licensed Material.__ Every recipient of the Licensed Material automatically receives an offer from the Licensor to exercise the Licensed Rights under the terms and conditions of this Public License.

 B. __No downstream restrictions.__ You may not offer or impose any additional or different terms or conditions on, or apply any Effective Technological Measures to, the Licensed Material if doing so restricts exercise of the Licensed Rights by any recipient of the Licensed Material.

 6. __No endorsement.__ Nothing in this Public License constitutes or may be construed as permission to assert or imply that You are, or that Your use of the Licensed Material is, connected with, or sponsored, endorsed, or granted official status by, the Licensor or others designated to receive attribution as provided in Section 3(a)(1)(A)(i).

b. ___Other rights.___

 1. Moral rights, such as the right of integrity, are not licensed under this Public License, nor are publicity, privacy, and/or other similar personality rights; however, to the extent possible, the Licensor waives and/or agrees not to assert any such rights held by the Licensor to the limited extent necessary to allow You to exercise the Licensed Rights, but not otherwise.

 2. Patent and trademark rights are not licensed under this Public License.

 3. To the extent possible, the Licensor waives any right to collect royalties from You for the exercise of the Licensed Rights, whether directly or through a collecting society under any voluntary or waivable statutory or compulsory licensing scheme. In all other cases the Licensor expressly reserves any right to collect such royalties.

### Section 3 – License Conditions.

Your exercise of the Licensed Rights is expressly made subject to the following conditions.

a. ___Attribution.___

 1. If You Share the Licensed Material (including in modified form), You must:

 A. retain the following if it is supplied by the Licensor with the Licensed Material:

 i. identification of the creator(s) of the Licensed Material and any others designated to receive attribution, in any reasonable manner requested by the Licensor (including by pseudonym if designated);

 ii. a copyright notice;

 iii. a notice that refers to this Public License;

 iv. a notice that refers to the disclaimer of warranties;

 v. a URI or hyperlink to the Licensed Material to the extent reasonably practicable;

 B. indicate if You modified the Licensed Material and retain an indication of any previous modifications; and

 C. indicate the Licensed Material is licensed under this Public License, and include the text of, or the URI or hyperlink to, this Public License.

 2. You may satisfy the conditions in Section 3(a)(1) in any reasonable manner based on the medium, means, and context in which You Share the Licensed Material. For example, it may be reasonable to satisfy the conditions by providing a URI or hyperlink to a resource that includes the required information.

 3. If requested by the Licensor, You must remove any of the information required by Section 3(a)(1)(A) to the extent reasonably practicable.

 4. If You Share Adapted Material You produce, the Adapter's License You apply must not prevent recipients of the Adapted Material from complying with this Public License.

### Section 4 – Sui Generis Database Rights.

Where the Licensed Rights include Sui Generis Database Rights that apply to Your use of the Licensed Material:

a. for the avoidance of doubt, Section 2(a)(1) grants You the right to extract, reuse, reproduce, and Share all or a substantial portion of the contents of the database;

b. if You include all or a substantial portion of the database contents in a database in which You have Sui Generis Database Rights, then the database in which You have Sui Generis Database Rights (but not its individual contents) is Adapted Material; and

c. You must comply with the conditions in Section 3(a) if You Share all or a substantial portion of the contents of the database.

For the avoidance of doubt, this Section 4 supplements and does not replace Your obligations under this Public License where the Licensed Rights include other Copyright and Similar Rights.

### Section 5 – Disclaimer of Warranties and Limitation of Liability.

a. __Unless otherwise separately undertaken by the Licensor, to the extent possible, the Licensor offers the Licensed Material as-is and as-available, and makes no representations or warranties of any kind concerning the Licensed Material, whether express, implied, statutory, or other. This includes, without limitation, warranties of title, merchantability, fitness for a particular purpose, non-infringement, absence of latent or other defects, accuracy, or the presence or absence of errors, whether or not known or discoverable. Where disclaimers of warranties are not allowed in full or in part, this disclaimer may not apply to You.__

b. __To the extent possible, in no event will the Licensor be liable to You on any legal theory (including, without limitation, negligence) or otherwise for any direct, special, indirect, incidental, consequential, punitive, exemplary, or other losses, costs, expenses, or damages arising out of this Public License or use of the Licensed Material, even if the Licensor has been advised of the possibility of such losses, costs, expenses, or damages. Where a limitation of liability is not allowed in full or in part, this limitation may not apply to You.__

c. The disclaimer of warranties and limitation of liability provided above shall be interpreted in a manner that, to the extent possible, most closely approximates an absolute disclaimer and waiver of all liability.

### Section 6 – Term and Termination.

a. This Public License applies for the term of the Copyright and Similar Rights licensed here. However, if You fail to comply with this Public License, then Your rights under this Public License terminate automatically.

b. Where Your right to use the Licensed Material has terminated under Section 6(a), it reinstates:

 1. automatically as of the date the violation is cured, provided it is cured within 30 days of Your discovery of the violation; or
 2. upon express reinstatement by the Licensor.

 For the avoidance of doubt, this Section 6(b) does not affect any right the Licensor may have to seek remedies for Your violations of this Public License.

c. For the avoidance of doubt, the Licensor may also offer the Licensed Material under separate terms or conditions or stop distributing the Licensed Material at any time; however, doing so will not terminate this Public License.

d. Sections 1, 5, 6, 7, and 8 survive termination of this Public License.

### Section 7 – Other Terms and Conditions.

a. The Licensor shall not be bound by any additional or different terms or conditions communicated by You unless expressly agreed.

b. Any arrangements, understandings, or agreements regarding the Licensed Material not stated herein are separate from and independent of the terms and conditions of this Public License.

### Section 8 – Interpretation.

a. For the avoidance of doubt, this Public License does not, and shall not be interpreted to, reduce, limit, restrict, or impose conditions on any use of the Licensed Material that could lawfully be made without permission under this Public License.

b. To the extent possible, if any provision of this Public License is deemed unenforceable, it shall be automatically reformed to the minimum extent necessary to make it enforceable. If the provision cannot be reformed, it shall be severed from this Public License without affecting the enforceability of the remaining terms and conditions.

c. No term or condition of this Public License will be waived and no failure to comply consented to unless expressly agreed to by the Licensor.

d. Nothing in this Public License constitutes or may be interpreted as a limitation upon, or waiver of, any privileges and immunities that apply to the Licensor or You, including from the legal processes of any jurisdiction or authority.

Creative Commons is not a party to its public licenses. Notwithstanding, Creative Commons may elect to apply one of its public licenses to material it publishes and in those instances will be considered the “Licensor.” Except for the limited purpose of indicating that material is shared under a Creative Commons public license or as otherwise permitted by the Creative Commons policies published at [creativecommons.org/policies](http://creativecommons.org/policies), Creative Commons does not authorize the use of the trademark “Creative Commons” or any other trademark or logo of Creative Commons without its prior written consent including, without limitation, in connection with any unauthorized modifications to any of its public licenses or any other arrangements, understandings, or agreements concerning use of licensed material. For the avoidance of doubt, this paragraph does not form part of the public licenses.

Creative Commons may be contacted at creativecommons.org
]===];

end);

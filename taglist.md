# Tag List

Current as of 9.0.5.0 beta 5.

## Basic

These tags can be used to display basic information such as name, class, race, and title.

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[rp:class]` | Class |
| `[rp:race]` | Race |
| `[rp:name]` | Name |
| `[rp:firstname]` | First Name |
| `[rp:lastname]` | Last Name |
| `[rp:me]` | Me (i.e., you) |
| `[rp:name-known]` | Name, only if known |
| `[rp:nick]` | Nickname |
| `[rp:nick-quoted]` | Nickname, in quotes |
| `[rp:title]` | Honorific |
| `[rp:fulltitle]` | Long Title |

## Appearance

These tags describe the unit's facial and bodily characteristics,

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[rp:body]` | Body Shape |
| `[rp:eyes]` | Eyes |
| `[rp:hair]` | Hair |
| `[rp:height]` | Height |
| `[rp:markings]` | Markings |
| `[rp:physiognomy]` | Physiognomy |
| `[rp:piercings]` | Piercings |
| `[rp:sizebuff]` | Size Buff |
| `[rp:tattoos]` | Tattoos |
| `[rp:weight]` | Weight |

### Claims

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[rp:actor]` | Actor |
| `[rp:bodyclaim]` | Body Claim |
| `[rp:faceclaim]` | Face Claim |
| `[rp:voiceclaim]` | Voice Claim |

## At First Glance

A unit can have up to five at-first-glance fields. Each field has an associated title, text, and icon.

| rp:tag | Displays |
| :---------------------- | :-------------------------- |

### Glance 1

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[rp:glance-1]` | Glance Title 1 |
| `[rp:glance-1-text]` | Glance Text 1 |
| `[rp:glance-1-full]` | Glance Icon, Title, and Text |

### Glance 2

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[rp:glance-2]` | Glance Text 2 |
| `[rp:glance-2-text]` | Glance Text 2 |
| `[rp:glance-2-full]` | Glance 2 Icon, Title, and Text |

### Glance 3

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[rp:glance-3]` | Glance Title 3 |
| `[rp:glance-3-text]` | Glance Text 3 |
| `[rp:glance-3-full]` | Glance 3 Icon, Title, and Text |

### Glance 4

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[rp:glance-4]` | Glance Title 4 |
| `[rp:glance-4-text]` | Glance Text 4 |
| `[rp:glance-4-full]` | Glance 4 Icon, Title, and Text |

### Glance 5

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[rp:glance-5]` | Glance Title 5 |
| `[rp:glance-5-text]` | Glance Text 5 |
| `[rp:glance-5-full]` | Glance 5 Icon, Title, and Text |

### All Glances

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[rp:glance]` | All Titles |
| `[rp:glance-full]` | All Icons, Titles, Text |

## Color

All color tags change the text color until the end of the current tag set, or another color tag is used. Many of the colors can be changed in [settings](opt://colors). [Relative colors](opt://colors/comparison) are based on your own values compared to the unit's values.

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[rp:color]` | Profile Color |
| `[rp:eyecolor]` | Eye Color |
| `[rp:friendcolor]` | Friend Color |
| `[rp:gendercolor]` | Gender Color |
| `[rp:guildcolor]` | Guild Color |
| `[rp:guildstatuscolor]` | Guild Status Color |
| `[rp:mecolor]` | 'Me' Color |
| `[rp:partycolor]` | Party Color |
| `[rp:profilesizecolor]` | Profile Size Color |
| `[rp:relationcolor]` | Relation Color |
| `[rp:statuscolor]` | Status Color |
| `[nocolor]` | Reset Colors |

### Comparison Colors

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[rp:agecolor]` | Relative Age Color |
| `[rp:heightcolor]` | Relative Height Color |
| `[rp:weightcolor]` | Relative Weight Color |

### Hilite Colors

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[rp:hilite-1]` | Hilite Color 1 |
| `[rp:hilite-2]` | Hilite Color 2 |
| `[rp:hilite-3]` | Hilite Color 3 |

## Formatting

These tags can insert blank lines.

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[br]` | Line Break |
| `[p]` | Paragraph Break |

## Gender and Pronoun

RPTAGS understands a number of genders and pronouns. It will check a unit's 'Gender' or 'Pronouns' custom fields, and their 'Race' setting, before using the game gender. (See <a href= 'https://en.wikipedia.org/wiki/Third-person_pronoun#Summary'>Wikipedia</a> for details on the pronouns supported by RPTAGS.

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[rp:gender]` | Gender |
| `[rp:pronouns]` | Preferred Pronouns |

### Nominative Pronouns

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[rp:s]` | she, he, they, it |
| `[rp:S]` | She, He, They, It |

### Object Pronouns

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[rp:o]` | her, him, them, it |
| `[rp:O]` | Her, Him, Them, It |

### Possessive Pronouns

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[rp:p]` | her, his, their, its |
| `[rp:P]` | Her, His, Their, Its |

### Absolute Pronouns

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[rp:a]` | hers, his, theirs, its |
| `[rp:A]` | Hers, His, Theirs, Its |

### Reflexive Pronouns

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[rp:r]` | herself, himself, themselves |
| `[rp:R]` | Herself, Himself, Themselves |

## History

These tags give information based on the unit's age, birthplace, or custom birthday field.

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[rp:age]` | Age |
| `[rp:years]` | Age, in Years |
| `[rp:years-old]` | Age, in Years Old |
| `[rp:years-ago]` | Age, Years Ago Born |
| `[rp:birthday]` | Birthday |
| `[rp:birthplace]` | Birthplace |

## Icon

These tags display inline icons based on various fields.

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[rp:icon]` | Profile Icon |
| `[rp:gendericon]` | Gender Icon |
| `[rp:raceicon]` | Race Icon |
| `[rp:statusicon]` | IC/OOC Status Icon |
| `[rp:pvpicon]` | PVP Icon |
| `[rp:pvpicon-square]` | Square PVP Icon |
| `[rp:relationicon]` | Relation Icon |
| `[rp:sizebufficon]` | Size Buff Icon |

### At First-Glance Icons

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[rp:glance-1-icon]` | Glance Icon 1 |
| `[rp:glance-2-icon]` | Glance Icon 2 |
| `[rp:glance-3-icon]` | Glance Icon 3 |
| `[rp:glance-4-icon]` | Glance Icon 4 |
| `[rp:glance-5-icon]` | Glance Icon 5 |
| `[rp:glance-icons]` | All Glance Icons |

### Note Indicator Icons

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[rp:note-1-icon]` | Note Keyword 1 Icon |
| `[rp:note-2-icon]` | Note Keyword 2 Icon |
| `[rp:note-3-icon]` | Note Keyword 3 Icon |

### RP Experience Icons

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[rp:xp-icon]` | XP Icon |
| `[rp:rookie-icon]` | Beginner Icon |
| `[rp:volunteer-icon]` | Volunteer Icon |

### RP Style Icons

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[rp:style-ic-icon]` | IC Frequency Icon |
| `[rp:style-injury-icon]` | Accept Character Injury Icon |
| `[rp:style-death-icon]` | Accept Character Death |
| `[rp:style-battle-icon]` | Battles |
| `[rp:style-romance-icon]` | Accept Character Romance Icon |
| `[rp:style-guild-icon]` | Guild Membership IC/OOC Icon |
| `[rp:style-icons]` | All RP Style Icons |

## Profile and Client

These tags include those based on your note and relationship settings for the unit, and the unit's roleplaying client.

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[rp:profilesize]` | Profile Size |

### Note Matches

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[rp:note-1]` | Note Keyword 1 |
| `[rp:note-2]` | Note Keyword 2 |
| `[rp:note-3]` | Note Keyword 3 |

### Relation Tags

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[rp:relation]` | Relation Type |
| `[rp:relation-who]` | Relation Description |

### Roleplaying Client Tags

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[rp:client]` | Client Name |
| `[rp:client-short]` | Abbreviation |
| `[rp:client-version]` | Version |
| `[rp:client-full]` | Name and Version |

### rp:Specific Clients

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[rp:mrp]` | MyRolePlay indicator |
| `[rp:trp]` | Total RP 3 indicator |
| `[rp:extended]` | TRP3 Extended indicator |
| `[rp:xrp]` | XRP indicator |

## Roleplaying Status

These tags are based on in-character/out-of-character status, the currently/oocinfo setting, or the roleplaying experience setting.

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[rp:status]` | Status (IC, OOC, or NPC) |
| `[rp:ic]` | IC Indicator |
| `[rp:ooc]` | OOC Indicator |
| `[rp:npc]` | NPC Indicator |
| `[rp:open]` | Looking for Contact Indicator |
| `[rp:storyteller]` | Storyteller Indicator |

### Currently

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[rp:curr]` | IC Currently |
| `[rp:info]` | OOC Info |

### Roleplaying Experience

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[rp:experience]` | Rookie, Experienced, or Volunteer |
| `[rp:xp]` | [R], [E], or [V] |
| `[rp:rookie]` | Rookie RPer indicator |
| `[rp:volunteer]` | Volunteer RPer indicator |

## Roleplaying Style

These tags are based on the unit's roleplay style preferences.

| rp:tag | Displays |
| :---------------------- | :-------------------------- |

### RP Styles

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[rp:style-ic]` | IC Frequency |
| `[rp:style-injury]` | Accept Character Injury |
| `[rp:style-death]` | Accept Character Death |
| `[rp:style-romance]` | Accept Character Romance |
| `[rp:style-battle]` | RP Battles |
| `[rp:style-guild]` | IC Guild |

### RP Styles, long form

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[rp:style-ic-long]` | In-Character Frequence |
| `[rp:style-injury-long]` | Accept Character Injury |
| `[rp:style-death-long]` | Accept Character Death |
| `[rp:style-romance-long]` | Accept Character Romance |
| `[rp:style-battle-long]` | Roleplay Battle Resolution |
| `[rp:style-guild-long]` | Guild Membership IC/OOC |

### All Style Preferences

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[rp:style-yes]` | All 'Yes' |
| `[rp:style-no]` | All 'No' |
| `[rp:style-ask]` | All 'Ask First' |

## Server

These tags return information about the unit's home server.

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[rp:server]` | Server Name |
| `[rp:server-mine]` | Server Name, if yours |
| `[rp:server-notmine]` | Server Name, if not yours |
| `[rp:server-abbr]` | Server Name, abbreviated |
| `[rp:server-lang]` | Server Language |
| `[rp:server-lang-short]` | Server Language, abbreviated |
| `[rp:server-region]` | Server Region |
| `[rp:server-subregion]` | Server Subregion |
| `[rp:server-type]` | Server Type |
| `[rp:server-type-short]` | Server Type, abbreviated |

### Conditional Punctuation

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[rp:server-star]` | An asterisk, if not your server |
| `[rp:server-dash]` | A hyphen, if not your server |

## Social

The unit's role in society are defined by these tags.

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[rp:alignment]` | Alignment |
| `[rp:family]` | Family |
| `[rp:house]` | House Name |
| `[rp:guild]` | Guild Name |
| `[rp:guild-rank]` | Guild Rank |
| `[rp:guild-status]` | Guild IC or OOC |
| `[rp:motto]` | Motto |
| `[rp:religion]` | Religion |
| `[rp:rstatus]` | Relationship Status |
| `[rp:home]` | Residence |
| `[rp:sexuality]` | Sexuality |
| `[rp:tribe]` | Tribe |

## Target

These tags don't draw data from the unit's profile, but from that unit's target.

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[rp:target]` | Target's Name |
| `[rp:target-class]` | Class |
| `[rp:target-gender]` | Target's Gender |
| `[rp:target-race]` | Target's Race |
| `[rp:target-status]` | Target's Status |
| `[rp:target-title]` | Target's Title |
| `[rp:target-me]` | Target, if Me |

### Colors

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[rp:target-color]` | Character Color |
| `[rp:target-gendercolor]` | Target's Gender Color |
| `[rp:target-statuscolor]` | Target's Status Color |
| `[rp:target-mecolor]` | Target's Color, if Me |

### Icons

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[rp:target-icon]` | Target's Character Icon |
| `[rp:target-gendericon]` | Target's Gender Icon |
| `[rp:target-statusicon]` | Target's Status Icon |

### Shorthand Tag

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[rp:target-details]` | All Target's Details |

## Listener

Tags that provide information from the Listener addon.

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[rp:listen-last]` | Last thing heard by Listener |
| `[rp:listen-count]` | Count of Listener entries |
| `[rp:listen-emote]` | Last thing emoted |
| `[rp:listen-say]` | Last thing said |
| `[rp:listen-party]` | Last thing said in party or raid |
| `[rp:listen-toyou]` | Last thing said to you. |
| `[rp:listen-whisper]` | Last thing whispered to you |
| `[rp:listencolor]` | Color for last time whispered |

## Appendix: oUF Frames

oUF is the unit frame structure upon which RPTAGS is built. It provides tags mostly related to game play, but you can mix-and-match these with the tags from RPTAGS. These tags are those which are most useful in a roleplaying setting.

| rp:tag | Displays |
| :---------------------- | :-------------------------- |
| `[level]` | Character Level |
| `[smartclass]` | Class or Creature Type |
| `[creature]` | Creature Type |
| `[dead]` | Death Indicator |
| `[class]` | Game Class |
| `[faction]` | Game Faction |
| `[name]` | Game Name |
| `[race]` | Game Race |
| `[sex]` | Game Sex |
| `[status]` | Game Status Indicator |
| `[group]` | Group Number in Raid |
| `[offline]` | Offline Indicator |
| `[pvp]` | PVP Indicator |
| `[difficulty]` | Relative Difficulty |
| `[resting]` | Resting Indicator, self only |
| `[classification]` | Unit Classification |


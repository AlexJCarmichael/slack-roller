[![Build Status](https://semaphoreci.com/api/v1/dane/slack-roller/branches/master/badge.svg)](https://semaphoreci.com/dane/slack-roller)

#Slack Roller
This app is developed to aid players, via Slack, in the game Dungeon World--a fantasy table-top role-playing games based on Dungeons and Dragons.

##Usage
This app takes in a request from a Slack channel via forward slash commands. The following commands are supported by this app:

`/roll`: The app will return a string showing how many die were rolled and the total of the die. It allows rolling of up to 999 die with 999 sides. It also accepts modifier arguments (+, -, \*, /) and will drop the highest or lowest die. After a player registers and creates a character, he or she can apply his or her character stats or weapon/armor bonus to the roll by appending the stat or by appending `attack` or `defend`.

`/register`: This command registers the slack user so that the user can create a character.

`/new_char name: Halek, strength: 16, ...`: This command creates a character for the registered player. The player should input a name, strength, dexterity, constitution, intelligence, wisdom, charisma, weapon bonuses and armor.

`/edit_char`: This command allows the player to edit his character in case of a mistake or if the character's stats change. The player uses the same inputs as is used in `/new_char`

`/character`: This command returns the player's current character's character sheet. The player can append a name to the command to see a different character's character sheet.

`/characters`: This command returns a list of all characters that the player owns.

`/register_character Halek`: This command allows the player to switch between characters if he or she has made multiple characters.

`/roster`: This command displays a list of all players.

`/character_roster`: This command displays a list of all characters.

`/helpdw`: This is the help command and displays a list of all commands.

###Examples

`/roll` "{user} rolls 2d6, resulting in **2, 6** for a total of **8**"

`/roll 2d6 + 2` "{user} rolls 2d6 + 2, resulting in **4, 5** for a total of **11**"

`/roll 3d6 +2 drop low(est)` "{user} rolls 3d6 + 2 drop low, resulting in **5, 6** for a total of **13** _dropped 4_"

`/roll 2d6 str` "{user} rolls 2d6 str, resulting in **6, 3 +2** for a total of **11**"

`/roll 1d4 attack` "{user} rolls 1d4 attack, resulting in **3 +2** for a total of **5**"

`/roll 1d6 defend +1` "{user} rolls 1d4 defend +3, resulting in **4 +1 -1(piercing)** for a total of **4**"

`/new_char name: Thūm, strength: 16, dexterity: 13, constitution: 15, intelligence: 9, wisdom: 12, charisma: 8, weapon: 1, armor: 3`

`/edit_char strength: 17, constitution: 17`

[![Build Status](https://semaphoreci.com/api/v1/dane/slack-roller/branches/master/badge.svg)](https://semaphoreci.com/dane/slack-roller)

#Slack Roller

##Usage
This app takes in a request from a Slack channel via /roll. The app will return a string showing how many die were rolled and the total of the die. It allows rolling of up to 999 die with 999 sides. It also accepts modifier arguments (+, -, *, /) and will drop the highest or lowest die.

###Examples

`/roll` "{user} rolls 2d6, resulting in **2, 6** for a total of **8**"

`/roll 2d6 + 2` "{user} rolls 2d6 + 2, resulting in **4, 5** for a total of **11**"

`/roll 3d6 +2 drop low(est)` "{user} rolls 3d6 + 2 drop low, resulting in **5, 6** for a total of **13** _dropped 4_"
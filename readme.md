# Cricket Card Game
## Rules Not Implemented (not all of them deserve to be implemented either)
 - +1 momentum for maiden
 - +1 momentum for milestone (50, 100, etc) - requires individual player scores
 - Require deck rotation when buying a card (trash/buy)
 - Discard and redraw player hand on wicket
 - Batter draws 8 cards and discards one after the field is set. This simulates the batter looking at the field and making a decision based on how it is set
 - Playing more than two bouncers in an over is a wide
 - Yorker cards are trashed on use

## Known Issues (these should be fixed)
- disable all the buttons when the result is known
- required run rate always shows on p2; but if p2 bats first it should be on p1


## Making Lower Order Batsman Worse
I have been thinking about how to make tail end batters "worse"

The expansion of having individual player cards allows for things like "-1 from all shots played, etc"

One option is to reduce the hand size so the player has less to play with and then after that cards are "whatever comes from the deck"

number of wickets lost= 0-4; hand size = 7
number of wickets lost= 5-6; hand size = 6
number of wickets lost= 7-9; hand size = 5

## Bend Your Back
Whilst in Malaysia I thought of 'bend your back' cards that are the bowling equivalent of 'chance your arm' cards.

If yorkers end up in this deck; then the bouncer/yorker deck would become yorker only and might need to be reduced / merged with short cards.

Outcomes:
- wide - +1 (or whatever format the rules are) run to the batting team and the ball is rebowled
- no ball - +1 run (or +2; no free hit) but the bowler draws a card at random from the batters hand; this is the shot played. Outs are scored as runs.
- dot ball - no run off ball
- must play modifier is added to card (no effect if already on card)
- catchable modifier is added to card (no effect if batter shot already has card)
- catchable + must play modifier is added to card
- yorker - like the old card; but the only way to get yorkers
- full toss, will go for 4 if no fielder in outfield

## Rule Changes for Length Cards
Good can be used against full / short but not visa-versa; new good length cards are created; these are a weaker bowling option and may need to be changed to emphasise 'must play' / 'catchable'; with full balls being increasingly 'must play' but less catchable and short cards being more 'catchable' but with fewer 'must play' cards.

## Leagues and Tournaments
- friendly / exhibition match - defaults to un-timed; does not influence the result table
- league games - influences the result table; plays have to made every week (of a live game) or the game is forfeit

multiple leagues will be in effect with players being in a league based on their win / loss
- 1 - 5 seconds per play; 15 seconds per over;
- 2 - 10 seconds per play; 30 seconds per over;
- 3 - 30 seconds per play; 1 minute per over;
- 4 - un-timed; no guides
- 5...N - varying degree of guides are included
- N - all guides are on (entry league)

##guides
- each card shows the runs scored off it and the likelihood (%) of a 'chance your arm' option
- each card selected shows where in the field it would go (spot)
- each card selected shows where in the field it would go (slice)
- no visual on the field
- how many runs are scored in each spot
- how many runs are scored in each slice

## Visuals and Sound
- look to games like bejewelled for the background music while playing.
- the run rate (p1) required run rate (p2) could be used to speed up the music
- particle effects and the number coming out of the field spot when runs a scored
- explosions might be required for a wicket
- When chasing a score; each run should explode off the target with some drama and particle effects.

## mobile interface (phone)
centre page
-- runs / wickets (overs) (NRR, RRR)
-- current ball information
-- hand options (plus potential guides)
-- select card (two buttons available; play card, play card and chance arm)
-- countdown timer
swipe left 
- fielding positions (where the selected card will go)
swipe right
- detailed scoreboard

## Monetization
monetisation
- shareware model - 6 over / 3 wicket version of the game is free; no league
- app purchase - get the full version; league admission; a squad with 15 players
- in game purchase
-- $1 add a player to your squad
-- customise your own team (shirt, hats, logo)
-- buy players from the market (tie-ins: Ricky Ponting; generic abilities; counts as two fielders) - $1 per player; possible limit on how many can be used per tournament game (adds changes in playing style)
- the card game - basic set
- the card game - expansions: a) player packs b) weather conditions and pitch conditions c) world cup 2015 player tie in d) windies 80s tie in
- tournaments
-- the first would probably be free entry to all league (paying players) with a small prize of $1000
-- after that regular tournaments (knockout followed by best of 3) with entry fee with larger prize money
- in game advertising
- sell out to another company (needs a large fanbase)

## Challenge Modes
- You have to get 2 wickets in 5 overs when the other team needs 20 runs
- You have to chase down 290 when you are 5/120
- keep the required run rate from hitting 8. It should start at 7 as a challenge.

## Achievements
- 400 runs plus (ODI)
- 200 runs plus (twenty20)
- hat-trick

## AI
- It is possible to give each player (batter / bowler) their own AI which would give them their own personality
- It would be amusing if people could play Fantasy league cricket competitions basing their decisions on virtual cricket players

## Physical
### Layout Changes
- indicate on the yorker cards that they are 'one use only'
- indicate that it is not possible to make a bouncer 'must play'
- indicate that it is not possible to make a yorker 'can leave'
- change the 'chance your arm' deck colour to something other than yellow
- change the yorker colour from red as it is too close to the orange of short length
- make the border of the cards bleed to the edge
- change 'can leave' to 'optional play'?

### Scoring
A board is used like Carcassonne measuring 50 points and then a place to indicate multiples of 50; scores up to 800 are tracked. There is also a wickets column that moves up as each wicket is lost (like the outbreak spot on pandemic).

Scoring for individual players may be considered (pen and paper). Otherwise it is just one batter at a time; the last batter does not participate and this would be a simplified version of the game.

# Expansions
## Collectable Card Game
I think that the individual player cards with add another element but I think the game should work regardless of them.
I also think that having a site where you can 'build your own card' is a great idea.

There are about 60 options; not including permutations and splitting up +1, +2, +3 options.

common bonuses
- +1 momentum per over
- no benefit
- +1 full card per over
- +1 good card per over
- +1 short card per over
- +1 bouncer/yorker card per over
- discard/redraw once per over
- can buy card from the trashed pile
- +1 can-leave/must-play change per over
- move a fielder once per over
- replay a card already used this turn
- +1, +2, +3 cards in hand per over

fielder bonuses
- reduces runs in slice by 1
- reduces runs in spot by 1
- can be placed on a line (covers two spots)

batter bonuses
- no penalty when mixing shots
- +1 run on 2s
- +1 run on 1s
- free single for every dot ball
- free re-roll chancing arm
- +1 on die rolls (dropped)
- free block per over
- +1 momentum; never 'chances arm'
- -1 momentum; 2 free blocks per over
- -1 momentum per over; used to make bowler benefit stronger
- can play 1 card directly from supply (any pile); the card is either used and discard or trashed if not used
- once per over; draw one from each supply pile, shuffle and over turn first. This card is bowled to the batter (upsets bowler)
- when 'chancing arm' all 4's are 6's all infield catches are outfield catches (for big hitting, big failing tail enders)
- when 'chancing arm' all 6's are 4's all outfield catches are infield catches (really a negative; can be paired with a positive bowling)
- may remove 'catch' from one card per over (a batter that is harder to get out)
- must add 'catch' to one card per over (a batter who hits up more than they should)
- cannot play blocks except against yorker; if batter only has blocks draw an appropriate length card from the supply. This card must be used.
- may use short cards against bouncers
- may use short cards against full
- may use full cards against short
- can leave any ball except yorkers (should be paired with something like -1 momentum)
- must play bouncers; draw from supply if now cards are available (irresistible urge)
- -1 run per scoring shot (except 4 and 6); gains extra draw on 'chance your arm' (fat hobbits like inzamam al haq and boonie)

bowler bonuses
- -1 run on 2s
- -1 run on 1s
- +1 momentum to other player when batting; +1 momentum to this player when bowling
- once per over; draw one from each supply pile, shuffle and over turn first. This card is played to the batter
- may add 'catch' to one card per over (this influences batter)
- once per over; off side shots cannot be played (could also have a twice per over)
- once per over; on side shots cannot be played (could also have a twice per over)
- redraw on 'chance your arm'
- 'infield catches' when 'chancing arm' becomes 'outfield catches'
- 'outfield catches' when 'chancing arm' becomes 'infield catches'
- +1 momentum per over; batter doesnt need to pay for 'chancing arm'
- can bowl one less ball per over (counted as a dot ball)
- can bowl two less balls per over (counted as dot balls)

## Bonuses
These were going to be either bought or dealt out in some way
 - out of form - player cant sneak runs, or has fewer cards
 - in form - reverse of above
 - rail delay - lose a session (test only)


## Fatigue
Fatigue chip go onto the bowler and they dont leave until a break; where you get -5 fatigue per bowler. Breaks are session breaks rather than tea breaks.
Fatigue has a Fibonacci penalty so that the more you bowl the worst the penalty becomes.
5 units is -1
10 units is -3 
15 units is -5
20 units is -8
25 units is -13
30 units is -21
35 units is -34

With two breaks the best a bowler can do is bowl 15 overs before a penalty comes in. This seems appropriate for real life but may not make sense in the game.

Fatigue tokens should be made up with simple imagery that makes the penalty simple and easy to use.


## Pitch Conditions
There is a deck of starting pitch conditions that are played at the start of the game (just one):
- flat (batting +1)
- bouncy (fast +1)
- grassy (seamer +1)
- patchy (bowling +1)

There is a deck of pitch & weather condition cards that are played at the start of each session
The following replace the previous card:
- clear skies (no bonus)
- overcast (+1 swing - yorker full length impact)
- rained out session

The following are cumulative and played once a day
- developing foot marks (+1 to spin)
- crumbling pitch (+1 bowling)
- uneven bounce (+1 bowling)
- flat pitch (+1 batting)

weather
hard - bouncers, short balls are +1
flat - all shots are +1
grassy - no bonus
cracked - day 3-5 - all balls are +1

[pitch options per day]
day 1 - hard, flat, grassy
day 2 - hard, flat, grassy
day 3 - cracked, hard, grassy
day 4 - cracked, hard, grassy
day 5 - cracked, cracked, grassy




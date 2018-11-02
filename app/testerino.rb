require 'socket'
require 'active_record'
require_relative '../app/models/application_record'


"
0 - Hans - Servant of the Duke of Lumbridge.
    1 - Man - One of RuneScape's many citizens.
2 - Man - One of RuneScape's many citizens.
    3 - Man - One of RuneScape's many citizens.
4 - Woman - One of RuneScape's many citizens.
    5 - Woman - One of RuneScape's many citizens.
6 - Woman - One of RuneScape's many citizens.
    7 - Farmer - He grows the crops in this area.
    8 - Thief - Known for his light-fingered qualities.
    9 - Guard - He tries to keep order around here.
    10 - Guard - He tries to keep order around here.
    11 - Tramp - A man down on his luck.
    12 - Barbarian - Not very civilised looking.
    13 - Wizard - Slightly magical.
    14 - Druid - Loves nature.
    15 - Warrior woman - Not very fashion conscious.
    16 - Man - One of the citizens of Al-Kharid.
17 - Barbarian woman - Scary in an argument!
18 - Al-Kharid warrior - Part of Al-Kharid's elite fighting force.
19 - White Knight - Shiny armour!
20 - Paladin - A holy warrior.
21 - Hero - Heroic!
22 - Forester - They love the forests.
23 - Knight of Ardougne - A member of Ardougne's militia.
    24 - Man - One of RuneScape's many citizens.
25 - Woman - One of RuneScape's many citizens.
    26 - Knight of Ardougne - To protect and serve the populace of Ardougne.
    27 - Archer - Good with arrows.
    28 - Zoo keeper - Enjoys locking up animals in small pens.
    29 - Chuck - He's a lumberjack, and he's ok.
    30 - Barman - Doesn't water down the beer too much.
31 - Priest - A holy man.
32 - Guard - Keeps the peace... kind of.
33 - Door man - What a boring job he has.
34 - Watchman - Watches stuff. But who watches him?
35 - Soldier - A soldier of the town of Yanille.
36 - Wyson the gardener - The head gardener.
37 - Sigbert the Adventurer - A bold knight famed for his travels.
38 - Shipyard worker - Builds ships for a living.
39 - Shipyard worker - Builds ships for a living.
40 - Shark - Let's not go skinny dipping eh?
41 - Chicken - Yep, definitely a chicken.
        42 - Sheep - Freshly sheared.
    43 - Sheep - White and fluffy.
    44 - Duck - Quackers.
45 - Duck - She quackers.
    46 - Duckling - Mini quackers.
    47 - Rat - A popular dwarven delicacy.
    48 - Oomlie Bird - A jungle version of the chicken, but more vicious.
    49 - Hellhound - Hello, nice doggy...
                                     50 - King black dragon - The biggest, meanest dragon around.
    51 - Baby dragon - Young but still dangerous.
    52 - Baby blue dragon - Young but still dangerous.
    53 - Red dragon - A big powerful dragon.
    54 - Black dragon - A fierce dragon with black scales!
55 - Blue dragon - A mother dragon.
    56 - Dryad - A wood nymph.
    57 - Fairy - A delicate creature from this strange realm.
    58 - Shadow spider - Is it a spider or is it a shadow?
59 - Giant spider - I think this spider has been genetically modified.
    60 - Giant spider - I think this spider has been genetically modified.
    61 - Spider - Incey wincey.
    62 - Jungle spider - A barely visible deadly jungle spider.
    63 - Deadly red spider - I think this spider has been genetically modified.
    64 - Ice spider - I think this spider has been genetically modified.
    65 - Leprechaun - A funny little man normally associated with rainbows.
    66 - Gnome - Like a mini man!
67 - Gnome - Like a mini man!
68 - Gnome - Like a mini man!
69 - Lizard man - A scaly reptilian creature.
    70 - Turael - He looks dangerous!
71 - Orc - A hideous malformed elf.
    72 - Troll - A hideously deformed creature.
    73 - Zombie - Dead man walking.
    74 - Zombie - Dead man walking.
    75 - Zombie - The walking dead.
    76 - Zombie - The walking dead.
    77 - Summoned Zombie - The living dead.
    78 - Giant bat - Annoying flappy thing.
    79 - Death wing - A shadowy, barely visible flying entity from some evil place.
    80 - Camel - Oh, it's a camel.
81 - Cow - Converts grass to beef.
82 - Lesser demon - Lesser, but still pretty big.
83 - Greater demon - Big, red, and incredibly evil.
84 - Black Demon - A big, scary, jet-black demon.
85 - Golem - A creature made from clay.
86 - Giant rat - Overgrown vermin.
87 - Giant rat - Overgrown vermin.
88 - Dungeon rat - Overgrown vermin.
89 - Unicorn - Horse with a horn.
90 - Skeleton - Could do with gaining a few pounds.
91 - Skeleton - Could do with gaining a few pounds.
92 - Skeleton - Could do with gaining a few pounds.
93 - Skeleton - Could do with gaining a few pounds.
94 - Skeleton Mage - An undead worker of dark magic.
95 - Wolf - Not man's best friend.
    96 - White wolf - A vicious mountain wolf.
    97 - White wolf - A vicious mountain wolf.
    98 - Dog - Bow wow.
    99 - Guard dog - He doesn't seem pleased to see me.
100 - Goblin - An ugly green creature.
101 - Goblin - An ugly green creature.
102 - Goblin - These goblins have grown strong.
103 - Ghost - Eeek! A ghost!
104 - Ghost - Eeek! A ghost!
105 - Bear - Eek! A bear!
106 - Bear - Eek! A bear!
107 - Scorpion - An extremely vicious scorpion.
108 - Poison Scorpion - It has a very vicious looking tail.
109 - Pit Scorpion - Tiny, annoying, stinging thing.
110 - Fire giant - A very large elemental adversary.
111 - Ice giant - He's got icicles in his beard.
    112 - Moss giant - His beard seems to have a life of its own.
    113 - Jogre - An aggressive humanoid.
    114 - Ogre - A large dim looking humanoid.
    115 - Ogre - A large dim looking humanoid.
    116 - Cyclops - A one-eyed man eater.
    117 - Hill giant - A very large foe.
    118 - Dwarf - A short angry guy.
    119 - Chaos dwarf - A dwarf gone bad.
    120 - Dwarf - A mountain dwelling short angry guy.
    121 - Dwarf - A short angry guy.
    122 - Hobgoblin - An ugly, smelly creature.
    123 - Hobgoblin - An ugly, smelly creature, with a spear.
    124 - Earth warrior - A strange inhuman elemental warrior.
    125 - Ice warrior - A cold-hearted elemental warrior.
    126 - Otherworldly being - Is he invisible or just a set of floating clothing?
127 - Magic axe - A magic axe with a mind of its own.
    128 - Snake - A slithering serpent.
    129 - Skavid - Servant race to the ogres.
    130 - Yeti - The abominable snowman.
    131 - Penguin - An inhabitant of icy regions.
    132 - Monkey - Perhaps our oldest relatives?
133 - Black unicorn - A unicorn with a blackened heart.
    134 - Poison spider - I think this spider has been genetically modified.
    135 - Mammoth - A woolly elephantine monster.
    136 - Terrorbird - A giant raptor.
    137 - Mounted terrorbird gnome - These gnomes know how to get around!
138 - Mounted terrorbird gnome - These gnomes know how to get around!
139 - Entrana Fire Bird - Probably not a chicken.
    140 - Souless - A servant to Iban.
    141 - Big Wolf - Must be the pack leader.
    142 - Wolf - A social killer.
    143 - Jungle Wolf - A rare jungle wolf
144 - King Scorpion - Wow! Scorpions shouldn't grow that big.
145 - Ice warrior - The Ice Queen's Royal Guard.
    146 - Gull - A sea bird.
    147 - Cormorant - A sea bird.
    148 - Albatross - A sea bird.
    149 - Gull - A sea bird.
    150 - Gull - A sea bird.
    151 - Fly trap - No flies on me.
    152 - Tree - Its bark is worse than its swipe.
    153 - Butterfly - These look much better in the wild.
    154 - Butterfly - I love butterflies.
    155 - Butterfly - It's a Blue Morpho Butterfly.
156 - Butterfly - It's a Tiger Swallowtail Butterfly.
    157 - Butterfly - It's a Viceroy Butterfly.
158 - Shadow warrior - A fighter from the supernatural world, he's a shadow of his former self.
    159 - Gnome child - Small, even by gnome standards.
        160 - Gnome child - Small, even by gnome standards.
        161 - Gnome child - Small, even by gnome standards.
        162 - Gnome trainer - He can advise on training.
    163 - Gnome guard - A tree gnome guard.
    164 - Gnome guard - A tree gnome guard.
    165 - Gnome shop keeper - Sells gnomish things.
    166 - Gnome banker - Banks gnomish things.
    167 - Gnome baller - A professional gnome baller.
    168 - Gnome woman - A female gnome.
    169 - Gnome woman - A female gnome.
    170 - Gnome pilot - He can fly the glider.
    171 - Brimstail - Small but powerful.
    172 - Dark wizard - A practicer of dark arts.
    173 - Invrigar the Necromancer - An evil user of Magic powers
174 - Dark wizard - He works evil magic.
    175 - Mugger - He jumps out and attacks people.
    176 - Witch - The hat's a dead give away.
177 - Witch - The hat's a dead give away.
    178 - Black Knight - A dark-hearted knight.
    179 - Black Knight - A dark-hearted knight.
    180 - Highwayman - He holds up passers by.
    181 - Chaos druid - A crazy, evil druid.
    182 - Pirate - Yar! Shiver me timbers!
183 - Pirate - Avast ye scurvy land lubbers!
184 - Pirate - This one's had too much to drink!
185 - Pirate - A fine example of piracy's equal opportunities program.
    186 - Thug - Low on brains, high on aggression.
    187 - Rogue - Rogueish.
188 - Monk of Zamorak - An evil human cleric.
    189 - Monk of Zamorak - An evil human cleric.
    190 - Monk of Zamorak - An evil human cleric.
    191 - Tribesman - A primitive warrior.
    192 - Dark warrior - A warrior touched by chaos.
    193 - Chaos druid warrior - A crazy evil druid.
    194 - Necromancer - A crazy evil necromancer.
    195 - Bandit - A wilderness outlaw.
    196 - Guard Bandit - Bandit Camp guard.
    197 - Barbarian guard - Not very civilised looking.
    198 - Guild master - Master of the guild.
    199 - Gunthor the brave - A mighty warrior!
200 - Lord Daquarius - Wears a stylish suit of armour.
    201 - Jailer - Guards prisoners for the black knights.
    202 - Black Heather - Has a fearsome scowl.
    203 - Donny the lad - Has a fearsome posture.
    204 - Speedy Keith - Nice hair.
    205 - Salarin the twisted - A crazy evil druid
206 - Guard - A dwarven guard.
    207 - Dwarf youngster - A young Dwarf lad.
    208 - Dwarf Commander - He guards the mines.
    209 - Nulodion - The Dwarven armoury engineer.
    210 - Grail Maiden - She looks serene.
    211 - Sir Percival - One of the Knights of the Round Table.
    212 - King Percival - A former Knight of the Round Table.
    213 - Merlin - A powerful Wizard of the Knights of the Round Table.
    214 - Peasant - He looks unhappy...
                                 215 - Peasant - He looks happy...
                                                              216 - High Priest - High Priest of Entrana.
    217 - Crone - A crone.
    218 - Galahad - A former Knight of the Round Table.
    219 - Fisherman - It's a fisherman.
220 - The Fisher King - He doesn't look very well...
                                                                          221 - Black Knight Titan - He looks mean and powerful.
    222 - Monk - A holy man.
    223 - Brother Kojo - A peaceful monk.
    224 - Dungeon rat - A dirty rat.
    225 - Bonzo - The Fishing Contest judge.
    226 - Sinister Stranger - He looks a LOT like a vampire...
                                                        227 - Morris - He checks the entrants to the Fishing Contest.
    228 - Big Dave - I can see how he got his name.
    229 - Joshua - He loves to fish!
230 - Grandpa Jack - He looks elderly.
    231 - Forester - He likes to cut down trees.
    232 - Mountain Dwarf - He looks short and grumpy.
    233 - Fishing spot - I can fish here.
    234 - Fishing spot - I can fish here.
    235 - Fishing spot - I can fish here.
    236 - Fishing spot - I can fish here.
    237 - Renegade Knight - He isn't very friendly.
238 - Thrantax the Mighty - A terrifying spirit.
239 - Sir Lancelot - One of the Knights of the Round Table.
240 - Sir Gawain - One of the Knights of the Round Table.
241 - Sir Kay - One of the Knights of the Round Table.
242 - Sir Bedivere - One of the Knights of the Round Table.
243 - Sir Tristram - One of the Knights of the Round Table.
244 - Sir Pelleas - One of the Knights of the Round Table.
245 - Sir Lucan - One of the Knights of the Round Table.
246 - Sir Palomedes - One of the Knights of the Round Table.
247 - Sir Mordred - Leader of the Renegade Knights.
248 - Morgan Le Faye - An evil and powerful sorceress.
249 - Merlin - A powerful Wizard of the Knights of the Round Table.
250 - The Lady of the Lake - A powerful sorceress who guards Excalibur.
251 - King Arthur - Legendary King of the Britons.
252 - Beggar - He looks very hungry...
253 - Khazard Guard - It's one of General Khazard's guards.
254 - Khazard Guard - It's one of General Khazard's guards.
255 - Khazard Guard - It's one of General Khazard's guards.
256 - Khazard Guard - It's one of General Khazard's guards.
257 - Khazard Guard - It's one of General Khazard's guards.
258 - General Khazard - He looks really nasty. Smells bad too.
259 - Khazard barman - A tough looking barman.
260 - Kelvin - A fightslave. He looks mistreated and weak.
261 - Joe - A fightslave. He looks mistreated and weak.
262 - Fightslave - A fightslave. He looks mistreated and weak.
263 - Hengrad - He looks mistreated and weak.
264 - Lady Servil - She looks wealthy.
265 - Jeremy Servil - A young squire. He looks worse for wear.
266 - Jeremy Servil - A young squire. He looks worse for wear.
267 - Justin Servil - Jeremy's father Sir Servil.
    268 - Local - A scruffy looking chap.
    269 - Bouncer - Nice doggy.
    270 - Khazard Ogre - Khazard's strongest ogre warrior.
271 - Khazard Scorpion - A large angry scorpion.
272 - Lucien - He walks with a slight limp.
273 - Lucien - He walks with a slight limp.
274 - Guardian of Armadyl - A guard who has devoted their life to Armadyl.
275 - Guardian of Armadyl - A guard who has devoted their life to Armadyl.
276 - Winelda - A witch.
277 - Fire Warrior of Lesarkus - Intimidating!
278 - Cook - The head cook of Lumbridge castle.
279 - Brother Omad - An old monk.
280 - Brother Cedric - An old drunk monk.
281 - Monk - An Ardougne Monk.
282 - Thief - A dastardly blanket thief.
283 - Head Thief - The head of the treacherous blanket stealing gang.
284 - Doric - A dwarf smith. Quite handy with a hammer.
285 - Veronica - She doesn't look too happy.
    286 - Professor Oddenstein - A mad scientist if ever I saw one!
287 - Ernest - A former chicken.
    288 - Chicken - A strange chicken.
    289 - Councillor Halgrive - An official of Ardougne.
    290 - Doctor Orbon - A serious-looking doctor.
    291 - Farmer Brumty - A farmer who's seen happier times.
292 - null - It's a null.
    293 - null - It's a null.
294 - null - It's a null.
    295 - null - It's a null.
296 - General Bentnoze - An ugly green creature.
297 - General Wartface - An ugly green creature.
298 - Goblin - An ugly green creature.
299 - Goblin - An ugly green creature.
300 - Sedridor - Chief of research at Wizards' Tower.
    301 - Twig - Reminds me of playing pooh sticks.
    302 - Hadley - Could do with losing a bit of weight.
    303 - Gerald - Looks suspiciously like a fisherman.
    304 - Almera - Nice hair.
    305 - Hudon - Looks young.
    306 - Golrie - It's a tree gnome
307 - Hetty - An old motherly witch with a curious smile and a hooked nose.
308 - Master fisher - The man in charge of the fishing guild.
309 - Fishing spot - I can see fish swimming in the water.
310 - Fishing spot - I can see fish swimming in the water.
311 - Fishing spot - I can see fish swimming in the water.
312 - Fishing spot - I can see fish swimming in the water.
313 - Fishing spot - I can see fish swimming in the water.
314 - Fishing spot - I can see fish swimming in the water.
315 - Fishing spot - I can see fish swimming in the water.
316 - Fishing spot - I can see fish swimming in the water.
317 - Fishing spot - I can see fish swimming in the water.
318 - Fishing spot - I can see fish swimming in the water.
319 - Fishing spot - I can see fish swimming in the water.
320 - Fishing spot - I can see fish swimming in the water.
321 - Fishing spot - I can see fish swimming in the water.
322 - Fishing spot - I can see fish swimming in the water.
323 - Fishing spot - I can see fish swimming in the water.
324 - Fishing spot - I can see fish swimming in the water.
325 - Fishing spot - I can see fish swimming in the water.
326 - Fishing spot - I can see fish swimming in the water.
327 - Fishing spot - I can see fish swimming in the water.
328 - Fishing spot - I can see fish swimming in the water.
329 - Fishing spot - I can see fish swimming in the water.
330 - Fishing spot - I can see fish swimming in the water.
331 - Fishing spot - I can see fish swimming in the water.
332 - Fishing spot - I can see fish swimming in the water.
333 - Fishing spot - I can see fish swimming in the water.
334 - Fishing spot - I can see fish swimming in the water.
335 - null - It's a null.
    336 - Da Vinci - He has a colourful personality.
    337 - Da Vinci - He has a colourful personality.
    338 - Chancy - He's ready for a bet.
339 - Chancy - He's ready for a bet.
    340 - Hops - He's drunk.
341 - Hops - He's drunk.
    342 - Guidor's wife - She looks rather concerned.
343 - Guidor - He's not that ill.
    344 - Guard - He tries to keep order around here.
    345 - Guard - He tries to keep order around here.
    346 - Guard - He tries to keep order around here.
    347 - Mourner - A mourner, or plague healer.
    348 - Mourner - A mourner, or plague healer.
    349 - Kilron - He looks shifty.
    350 - Omart - A nervous looking fellow.
    351 - Man - One of RuneScape's many citizens.
352 - Woman - One of RuneScape's many citizens.
    353 - Woman - One of RuneScape's many citizens.
354 - Woman - One of RuneScape's many citizens.
    355 - Child - One of RuneScape's many citizens.
356 - Child - One of RuneScape's many citizens.
    357 - Mourner - A mourner, or plague healer.
    358 - Priest - A holy man.
    359 - Man - One of RuneScape's many citizens.
360 - Woman - One of RuneScape's many citizens.
    361 - Woman - One of RuneScape's many citizens.
362 - Woman - One of RuneScape's many citizens.
    363 - Woman - One of RuneScape's many citizens.
364 - King Lathas - King Lathas of East Ardougne.
365 - Paladin - A military man.
366 - Jerico - He looks friendly enough.
367 - Chemist - Smells very chemically...
368 - Guard - He tries to keep order around here.
369 - Mourner - A mourner, or plague healer.
370 - Mourner - A mourner, or plague healer.
371 - Mourner - A mourner, or plague healer.
372 - Mourner - A mourner, or plague healer.
373 - Nurse Sarah - She's quite a looker!
374 - Ogre - Big, ugly, and smelly.
        375 - Redbeard Frank - A pirate.
    376 - Captain Tobias - An old sea dog.
    377 - Seaman Lorris - A young sailor.
    378 - Seaman Thresnor - A young sailor.
    379 - Luthas - The owner of the banana plantation.
    380 - Customs officer - Inspects peoples' packages.
381 - Captain Barnaby - An old sailor.
382 - Dwarf - A dwarf who looks after the mining guild.
383 - Stankers - He's in control of the coal trucks.
    384 - Barbarian guard - Not very civilised looking.
    385 - Kharid Scorpion - Looks vicious!
386 - Kharid Scorpion - Looks vicious!
387 - Kharid Scorpion - Looks vicious!
388 - Seer - Could do with a shave...
                                 389 - Thormac - Nice hat.
    390 - Big fish - A big fish with a bigger mouth.
    391 - River troll - Likes fish... hates people.
    392 - River troll - Likes fish... hates people.
    393 - River troll - Likes fish... hates people.
    394 - River troll - Likes fish... hates people.
    395 - River troll - Likes fish... hates people.
    396 - River troll - Likes fish... hates people.
    397 - Cow - Beefy!
398 - Legends Guard - A Legends Guild Guard, he protects the entrance to the Legends Guild.
    399 - Legends Guard - A Legends Guild Guard, he protects the entrance to the Legends Guild.
    400 - Radimus Erkle - Radimus is the Grand Vizier of the Legends Guild.
    401 - Jungle Forester - He deals in exotic types of wood.
    402 - Jungle Forester - She deals in exotic types of wood.
    403 - Fishing spot - I can see fish swimming in the water.
    404 - Fishing spot - I can see fish swimming in the water.
    405 - Fishing spot - I can see fish swimming in the water.
    406 - Fishing spot - I can see fish swimming in the water.
    407 - Strange plant - A very strange plant.
    408 - Strange plant - A very strange plant.
    409 - Genie - Maybe he'll grant me a wish...
410 - Mysterious Old Man - A very strange old man...
411 - Swarm - A swarm of vicious insects!
412 - Bat - Annoying flappy thing.
413 - Rock Golem - Rock with attitude.
414 - Rock Golem - Rock with attitude.
415 - Rock Golem - Rock with attitude.
416 - Rock Golem - Rock with attitude.
417 - Rock Golem - Rock with attitude.
418 - Rock Golem - Rock with attitude.
419 - Zombie - The walking dead!
420 - Zombie - The walking dead!
421 - Zombie - The walking dead!
422 - Zombie - The walking dead!
423 - Zombie - The walking dead!
424 - Zombie - The walking dead!
425 - Shade - The angry dead!
426 - Shade - The angry dead!
427 - Shade - The angry dead!
428 - Shade - The angry dead!
429 - Shade - The angry dead!
430 - Shade - The angry dead!
431 - Watchman - The strong arm of the law.
432 - Watchman - The strong arm of the law.
433 - Watchman - The strong arm of the law.
434 - Watchman - The strong arm of the law.
435 - Watchman - The strong arm of the law.
436 - Watchman - The strong arm of the law.
437 - Cap'n Izzy No-Beard - Entrance clerk for the Brimhaven Agility Arena.
    438 - Tree spirit - A very angry nymph.
    439 - Tree spirit - A very angry nymph.
    440 - Tree spirit - A very angry nymph.
    441 - Tree spirit - A very angry nymph.
    442 - Tree spirit - A very angry nymph.
    443 - Tree spirit - A very angry nymph.
    444 - Goblin - An ugly green creature.
    445 - Goblin - An ugly green creature.
    446 - Giant rat - Overgrown vermin.
    447 - Jail guard - I wonder who he's guarding?
448 - Jail guard - I wonder who he's guarding?
449 - Jail guard - I wonder who he's guarding?
450 - Gull - A sea bird.
451 - Gull - A sea bird.
452 - Seth Groats - A large, well built farmer.
453 - Suit of armour - A dusty old suit of armour.
454 - Sanfew - An old druid.
455 - Kaqemeex - A wise druid.
456 - Father Aereck - Looks a bit holy.
457 - Restless ghost - Eek! A ghost!
458 - Father Urhney - Looks very holy.
459 - Skeleton - It rattles when it walks.
460 - Wizard Frumscone - A Wizard of the Magic Guild.
461 - Magic Store owner - A Supplier of Magical items.
462 - Wizard Distentor - Head of the Magic Guild.
463 - Murphy - Salty old sea dog.
464 - Murphy - Salty old sea dog.
465 - Murphy - Salty old sea dog.
466 - Murphy - Salty old sea dog.
467 - Shark - Let's not go skinny dipping eh?
468 - Shark - Let's not go skinny dipping eh?
469 - King Bolren - It's a gnome. He looks important.
    470 - Commander Montai - It's a tree gnome.
471 - Bolkoy - It's a tree gnome.
    472 - Remsai - It's a tree gnome.
473 - Elkoy - It's a tree gnome.
    474 - Elkoy - It's a tree gnome.
475 - Khazard trooper - It's one of General Khazard's warriors.
476 - Khazard trooper - It's one of General Khazard's warriors.
477 - Khazard warlord - He looks real nasty, smells bad too.
478 - Khazard commander - It's one of General Khazard's commanders.
479 - Gnome troop - It's a tree gnome trooper.
    480 - Gnome troop - It's a tree gnome trooper.
481 - Tracker gnome 1 - It's a gnome who specialises in covert operations.
    482 - Tracker gnome 2 - It's a gnome who specialises in covert operations.
483 - Tracker gnome 3 - It's a gnome who specialises in covert operations.
    484 - Local Gnome - It's a young tree gnome.
485 - Local Gnome - It's a young tree gnome.
    486 - Kalron - He looks lost.
    487 - Observatory assistant - He helps the professor.
    488 - Observatory professor - A learned man in the ways of the stars.
    489 - Goblin guard - I will have to kill him to get past him.
    490 - Observatory professor - A learned man in the ways of the stars.
    491 - Ghost - Spooky!
492 - Spirit of Scorpius - The essence of evil.
    493 - Grave Scorpion - A vicious little stinging thing.
    494 - Banker - He can look after my money.
    495 - Banker - Good with money.
    496 - Banker - A financial expert.
    497 - Banker - Looks after your money.
    498 - Banker - Manages money momentarily.
    499 - Banker - He can look after my money.
    500 - Mosol Rei - A warrior from Shilo Village.
    501 - Spirit of Zadimus - An unquiet soul.
    502 - Undead One - A minion of Rashiliyia.
    503 - Undead One - A minion of Rashiliyia.
    504 - Undead One - The animated dead, one of Rashiliyia's minions.
505 - Undead One - The animated dead, one of Rashiliyia's minions.
    506 - Rashiliyia - The animated spirit of Rashiliyia the Zombie Queen.
    507 - Nazastarool - A giant zombie of huge strength and devastating power.
    508 - Nazastarool - A giant skeleton of huge strength and devastating power.
    509 - Nazastarool - A giant ghost of huge strength and devastating power.
    510 - Hajedy - A cart driver, it looks like he's quite experienced.
511 - Vigroy - A cart driver, it looks like he's quite experienced.
    512 - Kaleb Paramaya - This is Kaleb Paramaya
513 - Yohnus - This is Yohnus
514 - Seravel - This is Seravel
515 - Yanni Salika - Yanni Salika
516 - Obli - An intelligent-looking shop owner.
    517 - Fernahei - This is Fernahei
518 - Captain Shanks - He's the Captain of the 'Lady of the Waves'.
519 - Bob - An expert on axes.
520 - Shop keeper - Sells stuff.
521 - Shop assistant - Helps sell stuff.
522 - Shop keeper - Likes people spending money.
523 - Shop assistant - Likes helping sell stuff.
524 - Shop keeper - A product of consumerist society.
525 - Shop assistant - Likes you more the more you spend.
526 - Shop keeper - A product of consumerist society.
527 - Shop assistant - Likes you more the more you spend.
528 - Shop keeper - If he doesn't have it, he can't sell it!
529 - Shop assistant - She's here on work experience.
    530 - Shop keeper - An interesting assortment of items for sale.
                                                           531 - Shop assistant - Works on commission.
      532 - Shop keeper - Clearly takes pride in his appearance.
      533 - Shop assistant - Needs a haircut.
      534 - Fairy shop keeper - Sells stuff.
      535 - Fairy shop assistant - Sells stuff.
      536 - Valaine - A champion of a sales woman!
  537 - Scavvo - He's got the best armour around!
538 - Peksa - Always up to date with the latest fashions in helmets.
539 - Silk trader - Very snappily dressed!
540 - Gem trader - Makes his money selling rocks.
541 - Zeke - Sells superior scimitars.
542 - Louie Legs - For the finest in armoured legware.
543 - Karim - Kebabs are full of meaty goodness!
544 - Ranael - She's an expert on armoured skirts!
  545 - Dommik - If crafting's your thing, he's your man!
  546 - Zaff - Sells superior staffs.
      547 - Baraek - Animal skins are a speciality.
      548 - Thessalia - Interesting assortment of clothes on offer...
                                                                 549 - Horvik - The man with the armour.
      550 - Lowe - Sells arrows.
      551 - Shop keeper - Ironically, makes a living from swords.
          552 - Shop assistant - Helps the shop keeper sell swords.
      553 - Aubury - Runes are his passion.
      554 - Fancy dress shop owner - For the interesting clothing items you just can't find elsewhere.
555 - Shop keeper - Has a fine moustache!
556 - Grum - Loves his gold!
557 - Wydin - Likes his food to be kept fresh.
558 - Gerrant - An expert on fishing.
559 - Brian - An expert on axes.
560 - Jiminua - Goods for sale and trade!
561 - Shop keeper - Could stand to lose a few pounds.
562 - Candle maker - Has an odd smell about him.
563 - Arhein - He looks fairly well-to-do.
564 - Jukat - A being from a mysterious other realm.
565 - Lunderwin - Smells strangely of cabbage.
566 - Irksol - Is he invisible or just a set of floating clothing?
567 - Fairy - Looks strange and mysterious.
568 - Zambo - Appears slightly drunk.
569 - Silver merchant - Looks fairly well fed.
570 - Gem merchant - Seems very well off.
571 - Baker - So where are the butcher and the candlestick maker?
572 - Spice seller - Has a very exotic aroma about him.
573 - Fur trader - Knows how to keep warm in the winter.
574 - Silk merchant - Seems very well off.
575 - Hickton - A master fletcher.
576 - Harry - Something fishy about him.
577 - Cassie - Nice eyes.
578 - Frincos - Kind of funny looking.
579 - Drogo dwarf - He runs a mining store.
580 - Flynn - The mace salesman.
581 - Wayne - An armourer.
582 - Dwarf - I wonder if he wants to buy my junk?
583 - Betty - She seems like a nice sort of person.
584 - Herquin - Seems very well-off.
585 - Rommik - If crafting's your thing, he's your man!
586 - Gaius - Ironically, makes a living from swords.
587 - Jatix - He runs the Herblore Shop.
588 - Davon - An amulet trader.
589 - Zenesha - Sells top quality plate mail armour.
590 - Aemad - He runs the adventurers' shop.
      591 - Kortan - He helps to run the adventurers' shop.
592 - Roachey - He runs the fishing guild shop.
593 - Frenita - A recipe for success...in cooking.
594 - Nurmof - He runs a pickaxe store.
595 - Tea seller - He seems to sell tea.
596 - Fat Tony - An expert on Pizzas. Both making and eating.
597 - Noterazzo - The lawless shop keeper.
598 - Hairdresser - Anyone fancy a trim?
599 - Make-over mage - Master of the mystical make-over.
600 - Hudo - It's another jolly tree gnome.
      601 - Rometti - It's a well dressed tree gnome.
602 - Gulluck - He sells weapons.
603 - Heckel Funch - It's another jolly tree gnome.
      604 - Thurgo - Dwarvish.
  605 - Sir Vyvin - An elderly White Knight.
      606 - Squire - Indentured servant of a Knight.
      607 - Gunnjorn - He maintains this agility course
  608 - Sir Amik Varze - Leader of the White Knights.
      609 - Fortress Guard - A generic evil henchman.
      610 - Black Knight - One of the Black Knights.
      611 - Witch - The Black Knights' resident witch.
612 - Greldo - An ugly green creature.
613 - Digsite workman - This person is working on the site.
614 - Digsite workman - This person is working on the site.
615 - Student - A student busily digging.
616 - Student - A student busily digging.
617 - Student - A student busily digging.
618 - Examiner - Upon examining the examiner you examine it is indeed an examiner!
619 - Archaeological expert - An expert on archaeology.
620 - Panning guide - A specialist in panning for gold.
621 - Gnome baller - A professional gnome baller.
622 - Gnome baller - A professional gnome baller.
623 - Gnome baller - A professional gnome baller.
624 - Gnome baller - A professional gnome baller.
625 - Gnome baller - A professional gnome baller.
626 - Gnome baller - A professional gnome baller.
627 - Gnome baller - A professional gnome baller.
628 - Gnome baller - A professional gnome baller.
629 - Gnome baller - A professional gnome baller.
630 - Gnome baller - A professional gnome baller.
631 - Gnome baller - A professional gnome baller.
632 - Gnome baller - A professional gnome baller.
633 - Gnome winger - A professional gnome baller.
634 - Gnome winger - A professional gnome baller.
635 - Gnome ball referee - Keeps the game fair.
636 - Cheerleader - Cheerleading is a real sport!
637 - Juliet - A tearful damsel, maybe I can help her?
638 - Apothecary - A dealer in potions.
639 - Romeo - Rather dense and soppy looking.
640 - Father Lawrence - A religious man... And occasional drunk.
641 - Tramp - Looks down on his luck.
642 - Katrine - An empowered woman.
643 - Weaponsmaster - Looks kind of obsessive...
644 - Straven - Kind of funny looking.
645 - Jonny the beard - Looks kind of shifty...
646 - Curator - He runs the museum.
647 - null - It's a null.
      648 - King Roald - Varrock's resident monarch.
649 - Archer - She looks quite experienced.
650 - Warrior - He looks big and dumb.
651 - Monk - He looks holy.
652 - Wizard - He looks kind of puny...
653 - Fairy Queen - Looks otherworldy...
654 - Shamus - A funny little man who lives in a tree.
655 - Tree spirit - Guardian of the dramen tree.
656 - Cave monk - Unsurprisingly monk like.
657 - Monk of Entrana - Holy looking.
658 - Monk of Entrana - Holy looking.
659 - Party Pete - He likes to paaaarty!
660 - Knight - You'd need a tin opener to get him out.
      661 - Megan - Pretty barmaid.
      662 - Lucy - Pretty barmaid.
      663 - Man - A well dressed nobleman.
      664 - Dimintheis - A well dressed nobleman.
      665 - Boot - A short angry guy.
      666 - Caleb - A well dressed nobleman.
      667 - Chronozon - Chronozon the blood demon.
      668 - Johnathon - A well dressed nobleman.
      669 - Hazelmere - An ancient looking gnome.
      670 - King Narnode Shareen - An important looking gnome.
      671 - Glough - A rough looking gnome.
      672 - Anita - Glough's girlfriend.
673 - Charlie - Poor guy, he looks frightened.
674 - Foreman - The boss!
675 - Shipyard worker - Builds ships for a living.
676 - Femi - A gnome trader.
677 - Black Demon - A big, scary, jet-black demon.
678 - Guard - Keeps order in the ranging guild.
679 - Ranging Guild Doorman - The keeper of the gates to the ranging guild.
680 - Leatherworker - An expert leatherworker.
681 - Weapon poison salesman - Supplier of deadly liquids.
682 - Armour salesman - Supplier of Rangers armour.
683 - Bow and Arrow salesman - Supplier of Archery equipment.
684 - Tower Advisor - Tower keeper and competition judge.
685 - Tower Advisor - Tower keeper and competition judge.
686 - Tower Advisor - Tower keeper and competition judge.
687 - Tower Advisor - Tower keeper and competition judge.
688 - Tower Archer - Defender of the north tower.
689 - Tower Archer - Defender of the east tower.
690 - Tower Archer - Defender of the south tower.
691 - Tower Archer - Defender of the west tower.
692 - Tribal Weapon Salesman - Supplier of authentic throwing weapons.
693 - Competition Judge - Overseer of the Archery competition.
694 - Ticket Merchant - Sells equipment in exchange for archery tickets.
695 - Bailey - He smells of fish...
696 - Caroline - She looks very worried about something.
697 - Kennith - He looks very scared.
698 - Holgart - A very good sailor.
699 - Holgart - A very good sailor.
700 - Holgart - A very good sailor.
701 - Kent - He looks very tired and hungry.
702 - Fisherman - He smells of salty fish.
703 - Fisherman - He smells of salty fish.
704 - Fisherman - He smells of salty fish.
705 - Fisherman - Something fishy about him...
706 - Wizard Mizgog - An old wizard.
707 - Wizard Grayzag - Master of imps.
708 - Imp - A cheeky little imp.
709 - Imp - A vicious little imp.
710 - Alrena - She looks concerned.
711 - Bravek - The city warder of West Ardougne.
712 - Carla - She looks upset.
713 - Clerk - A bureaucratic administrator.
714 - Edmond - A local civilian.
715 - null - It's a null.
      716 - Head mourner - In charge of people with silly outfits.
      717 - Mourner - A mourner, or plague healer.
          718 - Mourner - A mourner, or plague healer.
          719 - Mourner - A mourner, or plague healer.
          720 - Recruiter - A member of the Ardougne Royal Army.
      721 - Ted Rehnison - The head of the Rehnison family.
      722 - Martha Rehnison - A fairly poor looking woman.
      723 - Billy Rehnison - The Rehnisons' eldest son.
724 - Milli Rehnison - She doesn't seem very happy.
      725 - Jethick - A cynical old man.
      726 - Man - One of RuneScape's many citizens.
727 - Man - One of RuneScape's many citizens.
      728 - Man - One of RuneScape's many citizens.
729 - Man - One of RuneScape's many citizens.
      730 - Man - One of RuneScape's many citizens.
731 - Bartender - I could get a beer from him.
732 - Bartender - I could get a beer from him.
733 - Bartender - I could get a beer from him.
734 - Bartender - I could get a beer from him.
735 - Bartender - I could get a beer from him.
736 - Emily - Works in the Rising Sun.
737 - Bartender - I could get a beer from him.
738 - Bartender - I could get a beer from him.
739 - Bartender - I could get a beer from him.
740 - Trufitus - A wise old witch doctor.
741 - Duke Horacio - Duke Horacio of Lumbridge.
742 - Elvarg - Rawr! A dragon!
743 - Ned - An old sailor.
744 - Klarense - A young sailor.
745 - Wormbrain - A badly behaved goblin.
746 - Oracle - A mystical fount of knowledge.
747 - Oziach - A strange little man.
748 - Giant rat - Overgrown vermin.
749 - Ghost - Eeek! A ghost!
750 - Skeleton - Could do with gaining a few pounds.
751 - Zombie - The walking dead.
752 - Lesser demon - Lesser, but still pretty big.
753 - Melzar the mad - He looks totally insane!
754 - Cabin Boy Jenkins - His job is to keep the ship in tip-top condition!
755 - Morgan - He looks scared.
756 - Dr Harlow - A retired vampire hunter.
757 - Count Draynor - Stop looking and run!
758 - Fred the Farmer - A well fed looking farmer.
759 - Gertrude's cat - A friendly feline?
  760 - Kitten - It looks lost.
      761 - Kitten - A friendly little pet.
      762 - Kitten - A friendly little pet.
      763 - Kitten - A friendly little pet.
      764 - Kitten - A friendly little pet.
      765 - Kitten - A friendly little pet.
      766 - Kitten - A friendly little pet.
      767 - Crate - Can I hear kittens?
  768 - Cat - A fully grown feline.
      769 - Cat - A fully grown feline.
      770 - Cat - A fully grown feline.
      771 - Cat - A fully grown feline.
      772 - Cat - A fully grown feline.
      773 - Cat - A fully grown feline.
      774 - Overgrown cat - A friendly not-so little pet.
      775 - Overgrown cat - A friendly not-so little pet.
      776 - Overgrown cat - A friendly not-so little pet.
      777 - Overgrown cat - A friendly not-so little pet.
      778 - Overgrown cat - A friendly not-so little pet.
      779 - Overgrown cat - A friendly not-so little pet.
      780 - Gertrude - A busy housewife.
      781 - Shilop - One of Gertrude's sons.
782 - Philop - One of Gertrude's sons.
      783 - Wilough - One of Gertrude's sons.
784 - Kanel - One of Gertrude's sons.
      785 - Civilian - A citizen of Ardougne.
      786 - Civilian - A citizen of Ardougne.
      787 - Civilian - A citizen of Ardougne.
      788 - Garv - A diligent guard.
      789 - Grubor - A rough looking thief.
      790 - Trobert - A well dressed thief.
      791 - Seth - Slightly fishy smelling.
      792 - Grip - Looks like he's been in the wars...
793 - Alfonse the waiter - Smartly dressed, and ready to deliver food.
794 - Charlie the cook - Distinctly cook-like.
795 - Ice Queen - A cold hearted lady.
796 - Achietties - Distinctly heroic.
797 - Helemos - A retired hero.
798 - Velrak the explorer - He looks cold and hungry.
799 - Pirate Guard - A morally ambiguous guard.
800 - Fishing spot - I can see eels swimming in the lava.
801 - Abbot Langley - A holy man.
802 - Brother Jered - A holy man.
803 - Monk - A holy man.
804 - Tanner - Manufacturer of fine leathers.
805 - Master Crafter - He's in charge of the Crafting Guild.
      806 - Donovan the Family Handyman - He looks very tired...
                                                            807 - Pierre - His job doesn't look very fun...
808 - Hobbes - He looks kind of stuck up...
809 - Louisa - She looks like she enjoys her job.
810 - Mary - She looks very nervous...
811 - Stanford - He looks like he spends a lot of time outdoors.
812 - Guard - An officer of the Law.
813 - Gossip - One of those people who love to gossip!
814 - Anna - She's dressed in a red top and green trousers.
      815 - Bob - He's dressed all in red.
816 - Carol - She's wearing a blue top and red trousers.
      817 - David - He's dressed all in green.
818 - Elizabeth - She's wearing a green top and blue trousers.
      819 - Frank - He's dressed all in blue.
820 - Poison Salesman - He sure likes to sell stuff!
821 - Sinclair Guard dog - Big, noisy, and scary looking!
822 - Ana - She looks like a tourist.
823 - Ana - Stuffed.
824 - Female slave - She looks like she's been down here a long time.
      825 - Male slave - It looks like he's been here a long time.
826 - Escaping slave - He's making a break for it!
                                                                                       827 - Rowdy slave - He looks a bit aggressive.
                                                                                           828 - Mercenary - He looks a bit aggressive.
                                                                                           829 - Mercenary - He looks a bit aggressive.
                                                                                           830 - Mercenary Captain - He looks a bit aggressive.
                                                                                           831 - Captain Siad - He's in control of the whole mining camp.
832 - Al Shabim - He's the leader of the Bedabin tribe.
                                                                                           833 - Bedabin Nomad - A bedabin nomad, they live in the harshest extremes in the desert.
                                                                                           834 - Bedabin Nomad Guard - A bedabin nomad guard
                                                                                       835 - Irena - A resident of Al-Kharid.
                                                                                       836 - Shantay - He's in control of the Shantay pass.
837 - Shantay Guard - He patrols the Shantay Pass.
838 - Shantay Guard - He patrols the Shantay Pass.
839 - Desert Wolf - A vicious desert wolf.
840 - Ugthanki - A vicious attacking camel.
841 - Mine cart driver - He looks busy attending to his cart.
842 - Rowdy Guard - He looks a bit aggressive and rowdy.
843 - RPDT employee - Inefficient looking.
844 - Wizard Cromperty - The hat is a dead give away.
845 - Horacio - Could do with losing a few pounds.
846 - Kangai Mau - A happening kind of guy!
847 - Head chef - Despite his name, rarely actually cooks heads.
848 - Blurberry - He seems to run the cocktail bar.
849 - Barman - He serves cocktails.
850 - Aluft Gianne - It's a tree gnome chef.
                                                                                           851 - Gnome Waiter - He can serve you gnome food.
                                                                                           852 - Ogre chieftain - Tough looking.
                                                                                           853 - Og - A senior member of the ogre community.
                                                                                           854 - Grew - Very probably an ogre.
                                                                                           855 - Toban - Ogre-ish.
                                                                                       856 - Gorad - Big, dumb and ugly.
                                                                                           857 - Ogre guard - An ogre that guards.
                                                                                           858 - Ogre guard - These ogres protect the city.
                                                                                           859 - Ogre guard - An ogre that guards.
                                                                                           860 - Ogre guard - An ogre that guards.
                                                                                           861 - Ogre guard - An ogre that guards.
                                                                                           862 - City guard - Tries to keep the peace.
                                                                                           863 - Scared skavid - Frightened looking.
                                                                                           864 - Mad skavid - Looks mad.
                                                                                           865 - Skavid - A skavid.
                                                                                           866 - Skavid - A skavid.
                                                                                           867 - Skavid - A skavid.
                                                                                           868 - Skavid - A skavid.
                                                                                           869 - Skavid - A skavid.
                                                                                           870 - Enclave guard - Big and ugly looking.
                                                                                           871 - Ogre shaman - Seems intelligent... for an ogre.
                                                                                           872 - Watchtower wizard - The hat is a dead give away.
                                                                                           873 - Ogre trader - Funnily enough, doesn't actually buy or sell ogres.
874 - Ogre merchant - Funnily enough, doesn't actually buy or sell ogres.
                                                                                           875 - Ogre trader - Funnily enough, doesn't actually buy or sell ogres.
876 - Ogre trader - Funnily enough, doesn't actually buy or sell ogres.
                                                                                           877 - Tower guard - Tries to keep the peace.
                                                                                           878 - Colonel Radick - A military man.
                                                                                           879 - Delrith - A freshly summoned demon.
                                                                                           880 - Weakened Delrith - The demon doesn't look so strong now.
881 - Traiborn - An old wizard.
882 - Gypsy - An old gypsy lady.
883 - Sir Prysin - One of the king's knights.
                                                                                           884 - Captain Rovin - The head of the palace guard.
                                                                                           885 - Ceril Carnillean - Head of the Carnillean household.
                                                                                           886 - Claus the chef - The Carnillean family chef.
                                                                                           887 - Guard - On special duty to protect the Carnilleans.
                                                                                           888 - Philipe Carnillean - The newest member of the Carnillean family.
                                                                                           889 - Henryeta Carnillean - Ceril Carnilleans' wife.
890 - Butler Jones - The Carnillean family butler.
891 - Alomone - Leader of the Hazeel cult.
892 - Hazeel - An evil being raised from the dead.
893 - Clivet - A member of the Hazeel cult.
894 - Hazeel Cultist - A member of the Hazeel cult.
895 - Boy - A sad looking child...
896 - Nora T. Hagg - Distinctly witchey.
897 - Witches experiment - Looks unnatural.
898 - Witches experiment second form - Looks unnatural.
899 - Witches experiment third form - Looks unnatural.
900 - Witches experiment fourth form - Looks unnatural.
901 - Mouse - Deceptively mouse shaped.
902 - Gundai - He must get lonely out here.
903 - Lundail - He sells rune stones.
904 - Chamber guardian - He hasn't seen much sun lately.
                                                                                           905 - Kolodion - He runs the mage arena.
                                                                                           906 - Kolodion - He runs the mage arena.
                                                                                           907 - Kolodion - He runs the mage arena.
                                                                                           908 - Kolodion - He's a shape shifter.
909 - Kolodion - He's a shape shifter.
                                                                                           910 - Kolodion - He's a shape shifter.
911 - Kolodion - He's a shape shifter.
                                                                                           912 - Battle mage - He kills in the name of Zamorak.
                                                                                           913 - Battle mage - He kills in the name of Saradomin.
                                                                                           914 - Battle mage - He kills in the name of Guthix.
                                                                                           915 - Leela - She comes from Al-Kharid.
                                                                                       916 - Joe - Lady Keli's head guard.
917 - Jail guard - I wonder who he's guarding?
                                                                                       918 - Ned - An old sailor.
                                                                                           919 - Lady Keli - An infamous bandit.
                                                                                           920 - Prince Ali - A young prince.
                                                                                           921 - Prince Ali - Now that's an effective disguise!
922 - Aggie - A witch.
923 - Hassan - The chancellor to the Emir.
924 - Osman - He looks a little shifty.
925 - Border Guard - Guards the border.
926 - Border Guard - Guards the border.
927 - Fishing spot - I can see fish swimming in the water.
928 - Gujuo - A dark, charismatic jungle native.
929 - Ungadulu - The Kharazi tribe's elusive Shaman.
                                                                                           930 - Ungadulu - The Kharazi tribe's elusive Shaman
931 - Jungle Savage - An aggressive native of the Kharazi Jungle.
932 - Fionella - She sells general items at the Legends Guild.
933 - Siegfried Erkle - An eccentric shop keeper
934 - Nezikchened - An ancient powerful demon of the underworld.
935 - Viyeldi - The spirit of a long-dead wizard.
936 - San Tojalon - The spirit of a long dead warrior.
937 - Irvig Senay - The spirit of a long dead warrior.
938 - Ranalph Devere - The spirit of a long dead warrior.
939 - Boulder - I wonder what this is doing here.
940 - Echned Zekin - A spirit of the underworld.
941 - Green dragon - Must be related to Elvarg.
942 - Master Chef - An expert on all things culinary.
943 - Survival Expert - Very much an outdoors type.
944 - Combat Instructor - An expert on all forms of combat.
945 - RuneScape Guide - Your introduction to the world of RuneScape.
946 - Magic Instructor - A Master of Magics.
947 - Financial Advisor - An official representative from the First National Bank of RuneScape.
948 - Mining Instructor - An expert on mining related skills.
949 - Quest Guide - Your introduction to the world of RuneScape.
950 - Giant rat - Overgrown vermin.
951 - Chicken - Yep definitely a chicken.
952 - Fishing spot - I can see fish swimming in the water.
953 - Banker - He can look after my money.
954 - Brother Brace - A holy man.
955 - Cow - A cow by any other name would smell as sweet.
956 - Drunken Dwarf - He's had a fair bit to drink...
                                                                                                                                                                               957 - Mubariz - Tough looking combat type.
                                                                                           958 - Fadli - Looks kinda bored.
                                                                                           959 - A'abla - Trained to deal with all sorts of injuries.
960 - Sabreen - Wow! She's made a statement with that hair!
                                                                                       961 - Tafani - Looks after injured fighters.
                                                                                           962 - Jaraah - Has the messy job of putting players back together again.
                                                                                           963 - Zahwa - 'Battle scarred'.
                                                                                       964 - Ima - A citizen of Al Kharid.
                                                                                           965 - Sabeil - A citizen of Al Kharid.
                                                                                           966 - Jadid - A citizen of Al Kharid.
                                                                                           967 - Dalal - A citizen of Al Kharid.
                                                                                           968 - Afrah - A citizen of Al Kharid.
                                                                                           969 - Jeed - A citizen of Al Kharid.
                                                                                           970 - Diango - He smells funny.
                                                                                           971 - Chadwell - Shop keeper.
                                                                                           972 - Koftik - The cave guide.
                                                                                           973 - Koftik - The cave guide.
                                                                                           974 - Koftik - The cave guide.
                                                                                           975 - Koftik - The cave guide.
                                                                                           976 - Koftik - The cave guide.
                                                                                           977 - Blessed spider - It's one of Iban's pets.
                                                                                           978 - Blessed Giant rat - It's one of Iban's pet vermin.
                                                                                           979 - Slave - A wretched slave of Iban.
                                                                                           980 - Slave - A wretched slave of Iban.
                                                                                           981 - Slave - A wretched slave of Iban.
                                                                                           982 - Slave - A wretched slave of Iban.
                                                                                           983 - Slave - A wretched slave of Iban.
                                                                                           984 - Slave - A wretched slave of Iban.
                                                                                           985 - Slave - A wretched slave of Iban.
                                                                                           986 - Boulder - Precariously balanced....
                                                                                           987 - Unicorn - The animal is caged here.
                                                                                           988 - Sir Jerro - A mighty looking warrior.
                                                                                           989 - Sir Carl - A mighty looking warrior.
                                                                                           990 - Sir Harry - A mighty looking warrior.
                                                                                           991 - Half-Souless - A creature empty of emotion.
                                                                                           992 - Kardia - A dark and evil crone.
                                                                                           993 - Witch's cat - Curiosity is yet to kill this one...
994 - Niloof - A strong and hardy dwarf.
995 - Klank - A dwarven maker of gauntlets.
996 - Kamen - This dwarf looks intoxicated.
997 - Kalrag - A giant spider.
998 - Othainian - One of the Guardians of Iban.
999 - Doomion - One of the Guardians of Iban.
1000 - Holthion - One of the Guardians of Iban.
1001 - Dark mage - A dark magic user.
1002 - Iban disciple - A dark magic user.
1003 - Lord Iban - The great and dreadful Lord Iban
1004 - Spider - Incey wincey.
1005 - Giant bat - Annoying flappy thing.
1006 - Sea slug - A rather nasty looking crustacean.
1007 - Zamorak Wizard - A servant of Zamorak.
1008 - Hamid - A holy man.
1009 - Poison spider - A nasty poisonous arachnid.
1010 - Rantz - A large dim looking humanoid.
1011 - Fycie - This must be Rantz's daughter.
                                                                                           1012 - Bugs - This must be Rantz's son.
1013 - Swamp toad - A green skinned croaker, loves the swamp.
1014 - Bloated Toad - A green skinned croaker.
1015 - Chompy bird - A large boisterous bird, a delicacy for ogres.
1016 - Chompy bird - A once boisterous bird, closer to being an ogre delicacy.
1017 - Chicken - Yep, definitely a chicken.
1018 - Rooster - He rules the...er...roost.
1019 - Fire elemental - A fire elemental.
1020 - Earth elemental - An earth elemental.
1021 - Air elemental - An air elemental.
1022 - Water elemental - A water elemental.
1023 - Earth elemental - An earth elemental.
1024 - Man - One of RuneScape's many citizens.
                                                                                           1025 - Man - One of RuneScape's many citizens.
1026 - Man - One of RuneScape's many citizens.
                                                                                           1027 - Woman - One of RuneScape's many citizens.
1028 - Woman - One of RuneScape's many citizens.
                                                                                           1029 - Woman - One of RuneScape's many citizens.
1030 - Wolfman - Eek! A werewolf!
1031 - Wolfman - Eek! A werewolf!
1032 - Wolfman - Eek! A werewolf!
1033 - Wolfwoman - Eek! A werewolf!
1034 - Wolfwoman - Eek! A werewolf!
1035 - Wolfwoman - Eek! A werewolf!
1036 - Banker - He can look after my money.
1037 - Man - One of RuneScape's many citizens.
                                                                                           1038 - Rufus - There's something strange about him...
1039 - Barker - Has a distinguished air about him.
1040 - Fidelio - A lycanthrope shopkeeper.
1041 - Sbott - Has a faint smell of chemicals about him.
1042 - Roavar - Seems a jolly chap.
1043 - Will o' the wisp - Mysterious swamp lights...
                                                                                                                                                               1044 - Monk of Zamorak - An evil human cleric.
                                                                                           1045 - Monk of Zamorak - An evil human cleric.
                                                                                           1046 - Monk of Zamorak - An evil human cleric.
                                                                                           1047 - Temple guardian - Looks like a big ugly dog.
                                                                                           1048 - Drezel - A holy man.
                                                                                           1049 - Drezel - A holy man.
                                                                                           1050 - Filliman Tarlock - The animated spirit of a soul not at rest.
                                                                                           1051 - Nature Spirit - A spirit of Nature.
                                                                                           1052 - Ghast - Arrghhh... A Ghast.
                                                                                           1053 - Ghast - Arrghhh... A Ghast.
                                                                                           1054 - Ulizius - A slightly nervous guard.
                                                                                           1055 - Pirate Jackie the Fruit - Ticket trader for the Brimhaven Agility Arena.
                                                                                           1056 - Mime - A mute performer.
                                                                                           1057 - Strange watcher - A member of the audience.
                                                                                           1058 - Strange watcher - A member of the audience.
                                                                                           1059 - Strange watcher - A member of the audience.
                                                                                           1060 - Denulth - Commander of the Imperial Guard.
                                                                                           1061 - Sergeant - Sergeant of the Imperial Guard.
                                                                                           1062 - Sergeant - Sergeant of the Imperial Guard.
                                                                                           1063 - Soldier - A soldier of the Imperial Guard.
                                                                                           1064 - Soldier - A soldier of the Imperial Guard.
                                                                                           1065 - Soldier - A soldier of the Imperial Guard.
                                                                                           1066 - Soldier - A soldier of the Imperial Guard.
                                                                                           1067 - Soldier - A soldier of the Imperial Guard.
                                                                                           1068 - Soldier - A soldier of the Imperial Guard.
                                                                                           1069 - Soldier - A soldier of the Imperial Guard.
                                                                                           1070 - Saba - A dishevelled and irritable hermit.
                                                                                           1071 - Tenzing - An experienced Sherpa.
                                                                                           1072 - Eadburg - The Burthorpe Castle cook.
                                                                                           1073 - Archer - A Burthorpe Castle archer.
                                                                                           1074 - Archer - A Burthorpe Castle archer.
                                                                                           1075 - Archer - A Burthorpe Castle archer.
                                                                                           1076 - Guard - A Burthorpe Castle guard.
                                                                                           1077 - Guard - A Burthorpe Castle guard.
                                                                                           1078 - Harold - An off-duty Burthorpe Castle guard.
                                                                                           1079 - Tostig - Barman of the Toad and Chicken.
                                                                                           1080 - Eohric - Head servant for Prince Anlaf.
                                                                                           1081 - Servant - A servant for Prince Anlaf.
                                                                                           1082 - Dunstan - Smithy for Burthorpe.
                                                                                       1083 - Wistan - Shopkeeper for Burthorpe.
                                                                                         1084 - Breoca - A citizen of Burthorpe.
                                                                                               1085 - Ocga - A citizen of Burthorpe.
                                                                                               1086 - Man - One of RuneScape's many citizens.
1087 - Penda - A citizen of Burthorpe.
1088 - Hygd - A citizen of Burthorpe.
1089 - Ceolburg - A citizen of Burthorpe.
1090 - Hild - Pretty young woman with an air of mystery around her.
1091 - Bob - The Jagex cat.
1092 - White Knight - The Knight seems to be watching something.
1093 - Billy - Billy is a baahd goat.
1094 - Mountain Goat - This beast doesn't need climbing boots.
                                                                                               1095 - Rock - The biggest and baddest troll.
                                                                                               1096 - Stick - A big, bad troll.
                                                                                               1097 - Pee Hat - A nasty looking troll.
                                                                                               1098 - Kraka - A nasty looking troll.
                                                                                               1099 - Dung - Human is his speciality.
                                                                                               1100 - Ash - Human is his speciality.
                                                                                               1101 - Thrower Troll - Small for a troll but mean, ugly and throws rocks.
                                                                                               1102 - Thrower Troll - Small for a troll but mean, ugly and throws rocks.
                                                                                               1103 - Thrower Troll - Small for a troll but mean, ugly and throws rocks.
                                                                                               1104 - Thrower Troll - Small for a troll but mean, ugly and throws rocks.
                                                                                               1105 - Thrower Troll - Small for a troll but mean, ugly and throws rocks.
                                                                                               1106 - Mountain Troll - Small for a troll but mean and ugly.
                                                                                               1107 - Mountain Troll - Small for a troll but mean and ugly.
                                                                                               1108 - Mountain Troll - Small for a troll but mean and ugly.
                                                                                               1109 - Mountain Troll - Small for a troll but mean and ugly.
                                                                                               1110 - Mountain Troll - Small for a troll but mean and ugly.
                                                                                               1111 - Mountain Troll - Small for a troll but mean and ugly.
                                                                                               1112 - Mountain Troll - Small for a troll but mean and ugly.
                                                                                               1113 - Eadgar - A rather mad looking hermit.
                                                                                               1114 - Godric - Dunstan's son.
1115 - Troll General - One of the Troll Generals.
1116 - Troll General - One of the Troll Generals.
1117 - Troll General - One of the Troll Generals.
1118 - Troll Spectator - He's watching the arena.
                                                                                               1119 - Troll Spectator - He's watching the arena.
1120 - Troll Spectator - He's watching the arena.
                                                                                               1121 - Troll Spectator - He's watching the arena.
1122 - Troll Spectator - He's watching the arena.
                                                                                               1123 - Troll Spectator - He's watching the arena.
1124 - Troll Spectator - He's watching the arena.
                                                                                               1125 - Dad - An unusually large troll.
                                                                                               1126 - Twig - He's guarding the cells.
1127 - Berry - He's guarding the cells.
                                                                                               1128 - Twig - He's guarding the cells.
1129 - Berry - He's guarding the cells.
                                                                                               1130 - Thrower Troll - Small for a troll but mean, ugly and throws rocks.
                                                                                               1131 - Thrower Troll - Small for a troll but mean, ugly and throws rocks.
                                                                                               1132 - Thrower Troll - Small for a troll but mean, ugly and throws rocks.
                                                                                               1133 - Thrower Troll - Small for a troll but mean, ugly and throws rocks.
                                                                                               1134 - Thrower Troll - Small for a troll but mean, ugly and throws rocks.
                                                                                               1135 - Cook - Human is his speciality.
                                                                                               1136 - Cook - Human is his speciality.
                                                                                               1137 - Cook - Human is his speciality.
                                                                                               1138 - Mountain Troll - Small for a troll but mean and ugly.
                                                                                               1139 - Mushroom - He's fast asleep.
1140 - Mountain Goat - This beast doesn't need climbing boots.
                                                                                               1141 - Mountain Goat - This beast doesn't need climbing boots.
1142 - Guard - He's guarding the storeroom.
                                                                                               1143 - Guard - He's guarding the storeroom.
1144 - Guard - He's guarding the storeroom.
                                                                                               1145 - Guard - He's guarding the storeroom.
1146 - Guard - He's guarding the storeroom.
                                                                                               1147 - Guard - He's guarding the storeroom.
1148 - Guard - He's guarding the storeroom.
                                                                                               1149 - Guard - He's guarding the storeroom.
1150 - Guard - He's guarding the goutweed.
                                                                                               1151 - Burntmeat - Human is his speciality.
                                                                                               1152 - Weird Old Man - What's he mumbling about?
1153 - Kalphite Worker - I don't think insect repellent will work...
                                                                                                                                                                                            1154 - Kalphite Soldier - I don't think insect repellent will work...
1155 - Kalphite Guardian - I don't think insect repellent will work...
                                                                                                                                                                                                                                                                                               1156 - Kalphite Worker - I don't think insect repellent will work...
1157 - Kalphite Guardian - I don't think insect repellent will work...
                                                                                                                                                                                                                                                                                                                                                                                                 1158 - Kalphite Queen - I don't think insect repellent will work...
1159 - Kalphite Queen - I don't think insect repellent will work...
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               1160 - Kalphite Queen - I don't think insect repellent will work...
1161 - Kalphite Larva - I don't think insect repellent will work...
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             1162 - Timfraku - The imposing Chief of Tai Bwo Wannai.
                                                                                               1163 - Tiadeche - A rather depressed looking fisherman.
                                                                                               1164 - Tiadeche - A rather depressed looking fisherman.
                                                                                               1165 - Tinsay - A more than slightly eccentric looking priest.
                                                                                               1166 - Tinsay - A more than slightly eccentric looking priest.
                                                                                               1167 - Tamayu - A hunter who long ago succumbed to blood lust.
                                                                                               1168 - Tamayu - A hunter who long ago succumbed to blood lust.
                                                                                               1169 - Tamayu - A hunter who long ago succumbed to blood lust.
                                                                                               1170 - Tamayu - A hunter who long ago succumbed to blood lust.
                                                                                               1171 - Lubufu - A crotchety old fisherman who doesn't like young whippersnappers.
1172 - The Shaikahan - A huge beast, resembling in some ways a lion, but mostly a twisted nightmare.
1173 - The Shaikahan - A huge beast, resembling in some ways a lion, but mostly a twisted nightmare.
1174 - Fishing spot - There are brightly coloured fish swimming in the water.
1175 - Fishing spot - There are brightly coloured fish swimming in the water.
1176 - Fishing spot - Something dark green is lurking in these waters.
1177 - Fishing spot - Something dark green is lurking in these waters.
1178 - Fishing spot - Something dark green is lurking in these waters.
1179 - Gull - A sea bird.
1180 - Cormorant - A sea bird.
1181 - Albatross - A sea bird.
1182 - Lord Iorwerth - An elf lord.
1183 - Elf warrior - He looks pretty handy with that bow.
1184 - Elf warrior - I don't wanna be at the wrong end of that pike.
                                                                                               1185 - Elven city guard - An elven city guard.
                                                                                               1186 - Idris - An elven hunting party leader.
                                                                                               1187 - Essyllt - An elven war band leader.
                                                                                               1188 - Morvran - An elven warrior.
                                                                                               1189 - Fishing spot - I can see fish swimming in the water.
                                                                                               1190 - Fishing spot - I can see fish swimming in the water.
                                                                                               1191 - Fishing spot - I can see fish swimming in the water.
                                                                                               1192 - Rabbit - A cute bunny rabbit.
                                                                                               1193 - Rabbit - A cute bunny rabbit.
                                                                                               1194 - Rabbit - A cute bunny rabbit.
                                                                                               1195 - Grizzly bear - Eek! A big bear!
                                                                                           1196 - Grizzly bear cub - Eek! A bear cub!
                                                                                           1197 - Grizzly bear cub - Eek! A bear cub!
                                                                                           1198 - Dire Wolf - What big teeth you have.
                                                                                               1199 - Elf Tracker - An elf tracker.
                                                                                               1200 - Tyras guard - One of King Tyras's men.
1201 - Elf warrior - He looks pretty handy with that bow.
1202 - Arianwyn - An odd looking person.
1203 - Tyras guard - One of King Tyras's men.
                                                                                               1204 - Tyras guard - One of King Tyras's men.
1205 - Tyras guard - One of King Tyras's men.
                                                                                               1206 - Tyras guard - One of King Tyras's men.
1207 - General Hining - Leader of King Tyras's men.
                                                                                               1208 - Quartermaster - Responsible for the food and equipment of the troops.
                                                                                               1209 - Koftik - The cave guide.
                                                                                               1210 - Kings messenger - One of King Lathas' messengers.
1211 - Will o' the wisp - Mysterious swamp lights...
                                                                                                                                                                                          1212 - Will o' the wisp - Mysterious swamp lights...
1213 - Tegid - He's washing his clothes in the lake.
                                                                                               1214 - Thistle - It's a Troll Thistle.
1215 - Parrots - What a colourful bunch of parrots!
1216 - Parroty Pete - He seems strangely familiar...
1217 - Gardener - An old gardener.
1218 - Ghoul - It's totally savage.
                                                                                               1219 - Leech - Yuck! It's all slimy!
1220 - Vampire - Where did that come from?
1221 - Spider - Nasty little creature.
1222 - Mist - Is it a low cloud?
1223 - Vampire - It looks really hungry!
1224 - Vampyric hound - And I shall call him Fang.
1225 - Vampire - A royal pain in the neck.
1226 - Tree - Its bark is worse than its swipe.
1227 - Myre Blamish Snail - A marsh coloured blamish snail, these types are said to spit acid.
1228 - Blood Blamish Snail - A blood coloured blamish snail, these types are said to spit acid.
1229 - Ochre Blamish Snail - A muddy coloured blamish snail, these types are said to spit acid.
1230 - Bruise Blamish Snail - A bruise blue coloured blamish snail, these types are said to spit acid.
1231 - Bark Blamish Snail - A branch bark coloured blamish snail, these types are said to spit acid.
1232 - Myre Blamish Snail - A marsh coloured blamish snail, these types are said to spit acid.
1233 - Blood Blamish Snail - A blood coloured blamish snail, these types are said to spit acid.
1234 - Ochre Blamish Snail - A muddy coloured blamish snail, these types are said to spit acid.
1235 - Bruise Blamish Snail - A bruise blue coloured blamish snail, these types are said to spit acid.
1236 - Fishing spot - I can see 'things' swimming in the water.
1237 - Fishing spot - I can see 'things' swimming in the water.
1238 - Fishing spot - I can see 'things' swimming in the water.
1239 - Bedabin Nomad Fighter - A bedabin nomad fighter
1240 - Loar Shadow - A shadowy sort of entity, kind of creepy looking.
1241 - Loar Shade - The shadowy remains of a long departed soul.
1242 - Shade Spirit - A spirit rising towards eternal peace.
1243 - Phrin Shadow - A shadowy sort of entity, kind of creepy looking.
1244 - Phrin Shade - The shadowy remains of a long departed soul.
1245 - Riyl Shadow - A shadowy sort of entity, kind of creepy looking.
1246 - Riyl Shade - The shadowy remains of a long departed soul.
1247 - Asyn Shadow - A shadowy sort of entity, kind of creepy looking.
1248 - Asyn Shade - The shadowy remains of a long departed soul.
1249 - Fiyr Shadow - A shadowy sort of entity, kind of creepy looking.
1250 - Fiyr Shade - The shadowy remains of a long departed soul.
1251 - Afflicted(Ulsquire) - A local villager of Mort'ton.
                                                                                               1252 - Ulsquire Shauncy - A local villager of Mort'ton.
1253 - Afflicted(Razmire) - A local villager of Mort'ton.
                                                                                               1254 - Razmire Keelgan - A local villager of Mort'ton.
1255 - Mort'ton Local - A local villager of Mort'ton.
1256 - Mort'ton Local - A local villager of Mort'ton.
1257 - Afflicted - A local villager of Mort'ton.
                                                                                               1258 - Afflicted - A local villager of Mort'ton.
1259 - Mort'ton local - A local villager of Mort'ton.
1260 - Mort'ton local - A local villager of Mort'ton.
1261 - Afflicted - A local villager of Mort'ton.
                                                                                               1262 - Afflicted - A local villager of Mort'ton.
1263 - Wizard - Slightly more magical.
1264 - Saradomin Wizard - A follower of Saradomin.
1265 - Rock Crab - No one likes crabs...
1266 - Rocks - A rocky outcrop.
1267 - Rock Crab - No one likes crabs...
1268 - Rocks - A rocky outcrop.
1269 - Olaf the Bard - A Fremennik bard.
1270 - Lalli - Distinctly troll shaped.
1271 - Golden sheep - Freshly shorn.
1272 - Golden sheep - Lovely thick wool.
1273 - Fossegrimen - A powerful spirit that lives in this lake.
1274 - Ospak - Looks like he's had a few drinks already.
                                                                                               1275 - Styrmir - Doesn't look like the musical type.
1276 - Torbrund - Waiting for the show.
1277 - Fridgeir - A music lover?
1278 - Longhall Bouncer - He's fat, he's round, he bounces on the ground. That's how he got the job.
                                                                                               1279 - The Draugen - A fearful spirit of the drowned.
                                                                                               1280 - Butterfly - Flutter by oh butterfly.
                                                                                               1281 - Sigli the Huntsman - A Fremennik hunter.
                                                                                               1282 - Sigmund The Merchant - A Fremennik merchant.
                                                                                               1283 - Swensen the Navigator - A Fremennik navigator.
                                                                                               1284 - Bjorn - Looks like he's having fun!
1285 - Eldgrim - He's only as think as you drunk he is!
                                                                                           1286 - Manni the Reveller - Every innkeeper's best friend!
1287 - Council workman - Supposedly fixes things around RuneScape.
1288 - Peer the Seer - A Fremennik riddler.
1289 - Thorvald the Warrior - A Fremennik hero.
1290 - Koschei the deathless - Your challenge awaits!
1291 - Koschei the deathless - Your challenge awaits!
1292 - Koschei the deathless - Your challenge awaits!
1293 - Koschei the deathless - Your challenge awaits!
1294 - Brundt the Chieftain - The Fremennik tribe's chieftain.
                                                                                               1295 - Askeladden - Looks like a wanna be Fremennik.
                                                                                               1296 - Guard - Stands around and looks at stuff all day.
                                                                                               1297 - Guard - Stands around and looks tough all day.
                                                                                               1298 - Town Guard - What a rubbish job he has.
                                                                                               1299 - Town Guard - Who's going to steal a whole town anyway?
1300 - Thora the Barkeep - The Longhall barkeep
1301 - Yrsa - Pretty shabbily dressed for a clothes shop owner.
1302 - Fisherman - There's something fishy about this guy.
                                                                                               1303 - Skulgrimen - Sells and makes weapons and armour.
                                                                                               1304 - Sailor - He's strong to the finish, because he eats cabbage.
1305 - Agnar - One of Rellekka's many citizens.
                                                                                               1306 - Freidir - One of Rellekka's many citizens.
1307 - Borrokar - One of Rellekka's many citizens.
                                                                                               1308 - Lanzig - One of Rellekka's many citizens.
1309 - Pontak - One of Rellekka's many citizens.
                                                                                               1310 - Freygerd - One of Rellekka's many citizens.
1311 - Lensa - One of Rellekka's many citizens.
                                                                                               1312 - Jennella - One of Rellekka's many citizens.
1313 - Sassilik - One of Rellekka's many citizens.
                                                                                               1314 - Inga - One of Rellekka's many citizens.
1315 - Fish monger - Fish-tastic!
1316 - Fur trader - I wonder what he does with all that fur?
1317 - Market Guard - Keeps the stalls secure.
1318 - Warrior - A hardened Fremennik warrior.
1319 - Fox - Foxy.
1320 - Bunny - Hoppity, hoppity.
1321 - Bunny - Hoppity, hoppity.
1322 - Gull - A sea bird.
1323 - Gull - A sea bird.
1324 - Gull - A sea bird.
1325 - Gull - A sea bird.
1326 - Bear Cub - Cute. But deadly.
1327 - Bear Cub - Cute. But deadly.
1328 - Unicorn Foal - Horned Horsey.
1329 - Black unicorn Foal - Cute but evil.
1330 - Wolf - Not mans' best friend.
                                                                                               1331 - Fishing spot - I can see fish swimming in the water.
                                                                                               1332 - Fishing spot - I can see fish swimming in the water.
                                                                                               1333 - Fishing spot - I can see fish swimming in the water.
                                                                                               1334 - Jossik - Apparently he keeps a lighthouse.
                                                                                               1335 - Jossik - Looks like he's in trouble...
1336 - Larrissa - A fremennik girl.
1337 - Larrissa - A fremennik girl.
1338 - Dagannoth - A horror from the ocean depths...
1339 - Dagannoth - A horror from the ocean depths...
1340 - Dagannoth - A horror from the ocean depths...
1341 - Dagannoth - A horror from the ocean depths...
1342 - Dagannoth - A horror from the ocean depths...
1343 - Dagannoth - A horror from the ocean depths...
1344 - Dagannoth - A horror from the ocean depths...
1345 - Dagannoth - A horror from the ocean depths...
1346 - Dagannoth - A horror from the ocean depths...
1347 - Dagannoth - A horror from the ocean depths...
1348 - Dagannoth mother - A horror from the ocean depths...
1349 - Dagannoth mother - A horror from the ocean depths...
1350 - Dagannoth mother - A horror from the ocean depths...
1351 - Dagannoth mother - A horror from the ocean depths...
1352 - Dagannoth mother - A horror from the ocean depths...
1353 - Dagannoth mother - A horror from the ocean depths...
1354 - Dagannoth mother - A horror from the ocean depths...
1355 - Dagannoth mother - A horror from the ocean depths...
1356 - Dagannoth mother - A horror from the ocean depths...
1357 - Sam - Pretty barmaid.
1358 - Rachael - Pretty barmaid.
1359 - Queen Sigrid - The Queen of Etceteria.
1360 - Banker - He seems happy to see you.
1361 - Arnor - A subject of Etceteria.
1362 - Haming - A subject of Etceteria.
1363 - Moldof - A subject of Etceteria.
1364 - Helga - A subject of Etceteria.
1365 - Matilda - A subject of Etceteria.
1366 - Ashild - A subject of Etceteria.
1367 - Skraeling - A warrior of Etceteria.
1368 - Skraeling - A warrior of Etceteria.
1369 - Fishmonger - Hmm, he smells.
1370 - Greengrocer - At least he eats his greens.
1371 - Prince Brand - The Prince of Miscellania.
1372 - Princess Astrid - The Princess of Miscellania.
1373 - King Vargas - He's in no state to rule a kingdom.
                                                                                               1374 - Guard - He's guarding the throne room.
1375 - Advisor Ghrim - He probably hasn't smiled since the Third Age.
                                                                                               1376 - Derrik - Smithy for Sogthorpe.
                                                                                           1377 - Farmer - He's cutting the wheat.
1378 - Flower Girl - No-one would mistake her for a duchess.
1379 - Ragnar - A subject of Miscellania.
1380 - Einar - A subject of Miscellania.
1381 - Alrik - A subject of Miscellania.
1382 - Thorhild - A subject of Miscellania.
1383 - Halla - A subject of Miscellania.
1384 - Yrsa - A subject of Miscellania.
1385 - Sailor - He's strong to the finish, because he eats cabbage.
                                                                                                 1386 - Rannveig - A subject of Miscellania.
                                                                                                 1387 - Thora - A subject of Miscellania.
                                                                                                 1388 - Valgerd - A subject of Miscellania.
                                                                                                 1389 - Skraeling - A warrior of Miscellania.
                                                                                                 1390 - Broddi - A subject of Miscellania.
                                                                                                 1391 - Skraeling - A warrior of Miscellania.
                                                                                                 1392 - Ragnvald - A subject of Miscellania.
                                                                                                 1393 - Fishmonger - Hmm, he smells.
                                                                                                 1394 - Greengrocer - At least he eats his greens.
                                                                                                 1395 - Lumberjack Leif - He's a lumberjack, and he's okay.
                                                                                                 1396 - Miner Magnus - He's just mining his own business.
1397 - Fisherman Frodi - There's something fishy about him.
                                                                                                 1398 - Gardener Gunnhild - She's looking a bit weedy.
1399 - Fishing spot - I can see fish swimming in the water.
1400 - Gull - A sea bird.
1401 - Chicken - Yep, definitely a chicken.
1402 - Chicken - Yep, definitely a chicken.
1403 - Rooster - He rules the...er...roost.
1404 - Rabbit - Aww, how cute.
1405 - Fishing spot - I can see fish swimming in the water.
1406 - Fishing spot - I can see fish swimming in the water.
1407 - Daero - Daero gives off an easy sense of authority.
1408 - Waydar - Waydar is some kind of flight officer.
1409 - Waydar - Waydar is some kind of flight officer.
1410 - Waydar - Waydar is some kind of flight officer.
1411 - Garkor - A large and weathered looking Gnome veteran.
1412 - Garkor - A large and weathered looking Gnome veteran.
1413 - Lumo - A seasoned looking Gnome foot soldier.
1414 - Lumo - A seasoned looking Gnome foot soldier.
1415 - Bunkdo - A seasoned looking Gnome foot soldier.
1416 - Bunkdo - A seasoned looking Gnome foot soldier.
1417 - Carado - A seasoned looking Gnome foot soldier.
1418 - Carado - A seasoned looking Gnome foot soldier.
1419 - Lumdo - A seasoned looking Gnome foot soldier.
1420 - Karam - All you see is a glimmer of light and the suggestion of shadow.
1421 - Karam - All you see is a glimmer of light and the suggestion of shadow.
1422 - Karam - All you see is a glimmer of light and the suggestion of shadow.
1423 - Bunkwicket - This Gnome is busy applying some kind of pasty material to the cave walls.
1424 - Waymottin - This Gnome is busy applying some kind of pasty material to the cave walls.
1425 - Zooknock - A wizened little Gnome dressed in brightly coloured clothes.
1426 - Zooknock - A wizened little Gnome dressed in brightly coloured clothes.
1427 - G.L.O. Caranock - An official looking Gnome with small beady eyes.
1428 - G.L.O. Caranock - An official looking Gnome with small beady eyes.
1429 - Dugopul - A large hairy monkey with a spade.
1430 - Salenab - It's Salenab the monkey.
                                                                                                 1431 - Trefaji - A huge brutish gorilla. He looks like a jail guard.
                                                                                                 1432 - Aberab - A huge brutish gorilla. He looks like a jail guard.
                                                                                                 1433 - Solihib - The food merchant of Ape Atoll.
                                                                                                 1434 - Daga - A shrewd-looking monkey swordsmith.
                                                                                                 1435 - Tutab - A magical trinket dealer.
                                                                                                 1436 - Ifaba - A general store type of monkey.
                                                                                                 1437 - Hamab - A female monkey skilled in crafting.
                                                                                                 1438 - Hafuba - A huge gorilla, head priest of this temple.
                                                                                                 1439 - Denadu - A small, well dressed monkey clasping a mace. He looks like a priest.
                                                                                                 1440 - Lofu - A small, well dressed monkey clasping a mace. He looks like a priest.
                                                                                                 1441 - Kruk - A large ninja monkey wielding two scimitars.
                                                                                                 1442 - Duke - A large ninja monkey wielding two scimitars.
                                                                                                 1443 - Oipuis - A large ninja monkey wielding two scimitars.
                                                                                                 1444 - Uyoro - A large ninja monkey wielding two scimitars.
                                                                                                 1445 - Ouhai - A large ninja monkey wielding two scimitars.
                                                                                                 1446 - Uodai - A large ninja monkey wielding two scimitars.
                                                                                                 1447 - Padulah - A scimitar wielding ninja monkey. He looks like he is guarding something.
                                                                                                 1448 - Awowogei - A rather dapper little monkey.
                                                                                                 1449 - Uwogo - A smartly clothed large monkey.
                                                                                                 1450 - Muruwoi - A smartly clothed large monkey.
                                                                                                 1451 - Sleeping Monkey - A rather sleepy looking guard, wielding some kind of bat.
                                                                                                 1452 - Monkey Child - An adorable little monkey child.
                                                                                                 1453 - The Monkey's Uncle - He looks like the Monkey's Uncle.
                                                                                                 1454 - The Monkey's Aunt - She looks like the Monkey's Aunt.
                                                                                                 1455 - Monkey Guard - A scimitar wielding ninja monkey.
                                                                                                 1456 - Monkey Archer - A bow wielding ninja monkey.
                                                                                                 1457 - Monkey Archer - A bow wielding ninja monkey. It looks particularly dangerous.
                                                                                                 1458 - Monkey Archer - A bow wielding ninja monkey.
                                                                                                 1459 - Monkey Guard - A huge brutish gorilla armoured with dangerous looking vambraces.
                                                                                                 1460 - Monkey Guard - A huge brutish gorilla armoured with dangerous looking vambraces.
                                                                                                 1461 - Elder Guard - A huge brutish gorilla stands here, blocking the way.
                                                                                                 1462 - Elder Guard - A huge brutish gorilla stands here, blocking the way.
                                                                                                 1463 - Monkey - This monkey seems like it might want to talk!
                                                                                             1464 - Monkey - This poor pet monkey looks very lost.
                                                                                                 1465 - Monkey Zombie - A large and lumbering undead monkey.
                                                                                                 1466 - Monkey Zombie - A large and lumbering undead monkey stands here, blocking the way.
                                                                                                 1467 - Monkey Zombie - A recently deceased monkey. Its flesh seems to be worse for the wear.
                                                                                                 1468 - Bonzara - A small monkey dressed in purple clothes. He looks like a priest.
                                                                                                 1469 - Monkey Minder - He looks like the type of guy who would mind monkeys.
                                                                                                 1470 - Foreman - The boss!
                                                                                             1471 - Skeleton - It looks just a bit ... underfed.
                                                                                             1472 - Jungle Demon - A Greater Jungle Demon. A magical aura emanates from its hide.
                                                                                                 1473 - Spider - It's an extremely small brown spider. Probably very poisonous.
1474 - Spider - It's an extremely small and probably poisonous brown spider.
                                                                                                 1475 - Bird - It's a brightly coloured bird of the jungle.
1476 - Bird - It's a brightly coloured bird of the jungle. It flies very quickly.
                                                                                                 1477 - Scorpion - It's an extremely dangerous looking scorpion.
1478 - Jungle spider - A very dangerous looking spider, with its fangs unsheathed.
1479 - Snake - It's a camouflaged jungle snake.
                                                                                                 1480 - Small ninja monkey - It's a monkey.
1481 - Medium ninja monkey - It's a monkey.
                                                                                                 1482 - Gorilla - It's a gorilla.
1483 - Bearded gorilla - It's a gorilla.
                                                                                                 1484 - Ancient monkey - It's a monkey.
1485 - Small zombie monkey - It's a monkey.
                                                                                                 1486 - Large zombie monkey - It's a monkey.
1487 - Monkey - It's a monkey.
                                                                                                 1488 - Monkey - It's a monkey.
1489 - Monkey - It's a monkey.
                                                                                                 1490 - Monkey - It's a monkey.
1491 - Monkey - It's a monkey.
                                                                                                 1492 - Monkey - It's a monkey.
1493 - Monkey - It's a monkey.
                                                                                                 1494 - Monkey - It's a monkey.
1495 - Monkey - It's a monkey.
                                                                                                 1496 - Monkey - It's a monkey.
1497 - Monkey - It's a monkey.
                                                                                                 1498 - Monkey - It's a monkey.
1499 - Monkey - It's a monkey.
                                                                                                 1500 - Monkey - It's a monkey.
1501 - Monkey - It's a monkey.
                                                                                                 1502 - Monkey - It's a monkey.
1503 - Monkey - It's a monkey.
                                                                                                 1504 - Monkey - It's a monkey.
1505 - Monkey - It's a monkey.
                                                                                                 1506 - Monkey - It's a monkey.
1507 - Monkey - It's a monkey.
                                                                                                 1508 - Monkey - It's a monkey.
1509 - Monkey - It's a monkey.
                                                                                                 1510 - Monkey - It's a monkey.
1511 - Gnome - It's a gnome.
                                                                                                 1512 - Gnome - It's a gnome.
1513 - Gnome - It's a gnome.
                                                                                                 1514 - Ape - It's an ape.
1515 - Skeleton - Could do with gaining a few pounds.
1516 - Demon - Demonic.
1517 - Gnome - It's a gnome.
                                                                                                 1518 - Gnome - It's a gnome.
1519 - Gnome - It's a gnome.
                                                                                                 1520 - Gnome - It's a gnome.
1521 - Bird - A tropical bird.
1522 - Bird - A tropical bird.
1523 - King Scorpion - That's poisonous.
                                                                                                 1524 - Jungle spider - Arachnoid.
                                                                                             1525 - Weird snake. - Slightly more spherical than most snakes.
                                                                                                 1526 - Lanthus - He must run this place.
                                                                                                 1527 - Mine cart - Big, metal, and wheeled.
                                                                                                     1528 - Zealot - His robes prominently display the star of Saradomin.
                                                                                                 1529 - Sheep - White and fluffy.
                                                                                                 1530 - Rabbit - Bright eyes.
                                                                                                 1531 - Imp - A cheeky little imp.
                                                                                                 1532 - Barricade - A spiky barricade.
                                                                                                 1533 - Barricade - A spiky barricade.
                                                                                                 1534 - Barricade - A spiky barricade.
                                                                                                 1535 - Barricade - A spiky barricade.
                                                                                                 1536 - Possessed Pickaxe - How does it move of its own accord?
                                                                                             1537 - Bronze pickaxe - Useful for hitting rocks.
                                                                                                 1538 - Corpse - Well at least he doesn't have to worry about getting black lung.
1539 - Skeletal miner - I don't think the pickaxe is for hitting rocks.
                                                                                                 1540 - Treus Dayth - Eeek! A big ghost!
                                                                                             1541 - Ghost - Eeek! A ghost!
                                                                                             1542 - Loading crane - Those are some of the biggest teeth I've ever seen.
1543 - Innocent looking key - A shiny key sitting quietly on a crate.
1544 - Mine cart - Big, metal, and wheeled.
1545 - Mine cart - Big, metal, and wheeled.
1546 - Mine cart - Big, metal, and wheeled.
1547 - Mine cart - Big, metal, and wheeled.
1548 - Mine cart - Big, metal, and wheeled.
1549 - Ghost - Eeek! A ghost!
1550 - Haze - A strange disturbance in the air.
1551 - Mischievous Ghost - That ghost looks like he's up to something.
                                                                                                 1552 - Santa - He knows if you've been naughty or nice.
1553 - Ug - A frail little troll.
1554 - Aga - A beautiful troll.
1555 - Arrg - A massive, scary-looking troll.
1556 - Arrg - A massive, scary-looking troll.
1557 - Ug - A frail little troll.
1558 - Ice wolf - Not mans' best friend.
                                                                                                 1559 - Ice wolf - Not mans' best friend.
1560 - Ice Troll - Brrrrr...he must be cold!
1561 - Ice Troll - Brrrrr...he must be cold!
1562 - Ice Troll - Brrrrr...he must be cold!
1563 - Ice Troll - Brrrrr...he must be cold!
1564 - Ice Troll - Brrrrr...he must be cold!
1565 - Ice Troll - Brrrrr...he must be cold!
1566 - Ice Troll - Brrrrr...he must be cold!
1567 - Cyreg Paddlehorn - A tall and imposing man who's more than familiar with boating.
                                                                                                 1568 - Curpile Fyod - A typical, if overly heavy handed, jobs worth guard.
                                                                                                 1569 - Veliaf Hurtz - Looks like the leader of the Myreque.
                                                                                                 1570 - Sani Piliu - A pretty young rogue.
                                                                                                 1571 - Harold Evans - Hot headed big built youth who trained in the militia.
                                                                                                 1572 - Radigad Ponfit - A quick and agile fighter, a mercenary from Asgarnia.
                                                                                                 1573 - Polmafi Ferdygris - A member of the Myreque and intellectual assistant to Veliaf.
                                                                                                 1574 - Ivan Strom - A member of the Myreque and an aspiring young priest.
                                                                                                 1575 - Skeleton Hellhound - A creature summoned by Vanstrom to kill the remaining Myreque.
                                                                                                 1576 - Stranger - A typical villager of Canifis.
                                                                                                 1577 - Vanstrom Klause - A curious fellow.
                                                                                                 1578 - Mist - A billowing cloud of fine mist...it looks creepy.
                                                                                                 1579 - Vanstrom Klause - A curious fellow.
                                                                                                 1580 - Vanstrom Klause - An evil vampire.
                                                                                                 1581 - Vanstrom Klause - An evil vampire.
                                                                                                 1582 - Fire giant - A very large elemental adversary.
                                                                                                 1583 - Fire giant - A very large elemental adversary.
                                                                                                 1584 - Fire giant - A very large elemental adversary.
                                                                                                 1585 - Fire giant - A very large elemental adversary.
                                                                                                 1586 - Fire giant - A very large elemental adversary.
                                                                                                 1587 - Moss giant - His beard seems to have a life of its own.
                                                                                                 1588 - Moss giant - His beard seems to have a life of its own.
                                                                                                 1589 - Baby red dragon - Young but still dangerous.
                                                                                                 1590 - Bronze dragon - Its scales seem to be made of bronze.
                                                                                                 1591 - Iron dragon - Its scales seem to be made of iron.
                                                                                                 1592 - Steel dragon - Its scales seem to be made of steel.
                                                                                                 1593 - Wild dog - Looks like it's got Rabies!
1594 - Wild dog - An unsuitable pet.
1595 - Saniboch - Looks like he wants money.
1596 - Mazchna - He looks dangerous!
1597 - Vannaka - He looks dangerous!
1598 - Chaeldar - She looks dangerous!
1599 - Duradel - He looks dangerous!
1600 - Cave crawler - A spiky crawling critter.
1601 - Cave crawler - A spiky crawling critter.
1602 - Cave crawler - A spiky crawling critter.
1603 - Cave crawler - A spiky crawling critter.
1604 - Aberrant specter - A very smelly ghost.
1605 - Aberrant specter - A very smelly ghost.
1606 - Aberrant specter - A very smelly ghost.
1607 - Aberrant specter - A very smelly ghost.
1608 - Kurask - Large, heavy, with sharp things attached to its head.
1609 - Kurask - Larger, heavier, with sharper things attached to its head.
1610 - Gargoyle - Flies like a rock.
1611 - Gargoyle - Flies like a rock.
1612 - Banshee - A tortured screaming soul.
1613 - Nechryael - An evil death demon.
1614 - Death spawn - An evil death spawn.
1615 - Abyssal demon - It's escaped from the abyss.
                                                                                                 1616 - Basilisk - The eyes of evil.
                                                                                                 1617 - Basilisk - The eyes of evil.
                                                                                                 1618 - Bloodveld - The tongue of evil.
                                                                                                 1619 - Bloodveld - The tongue of evil.
                                                                                                 1620 - Cockatrice - The winged reptile.
                                                                                                 1621 - Cockatrice - The winged reptile.
                                                                                                 1622 - Rockslug - The slime of evil.
                                                                                                 1623 - Rockslug - The slime of evil.
                                                                                                 1624 - Dustdevil - The vacuumed face of evil.
                                                                                                 1625 - Smokedevil - The cave-dwelling cousin of the dustdevils.
                                                                                                 1626 - Turoth - He's one leg short!
1627 - Turoth - He's one big leg short!
                                                                                             1628 - Turoth - She's one leg short!
1629 - Turoth - It's one leg short!
                                                                                             1630 - Turoth - It's one small leg short!
1631 - Turoth - He's one big leg short!
                                                                                             1632 - Turoth - He's one big leg short!
1633 - Pyrefiend - A small fire demon.
1634 - Pyrefiend - A small fire demon.
1635 - Pyrefiend - A small fire demon.
1636 - Pyrefiend - A small fire demon.
1637 - Jelly - Looks scared to see me.
1638 - Jelly - Doesn't look so tough...
                                                                                                                                                   1639 - Jelly - Wibbly.
                                                                                             1640 - Jelly - There's always room for jelly.
1641 - Jelly - Needs cream.....
1642 - Jelly - Wobbly...
1643 - Infernal Mage - An evil magic user.
1644 - Infernal Mage - An evil magic user.
1645 - Infernal Mage - An evil magic user.
1646 - Infernal Mage - An evil magic user.
1647 - Infernal Mage - An evil magic user.
1648 - Crawling Hand - Gimmie five. Actually, don't.
                                                                                                 1649 - Crawling Hand - Gimmie five. Actually, don't.
1650 - Crawling Hand - Gimmie five. Actually, don't.
                                                                                                 1651 - Crawling Hand - Gimmie five. Actually, don't.
1652 - Crawling Hand - Gimmie five. Actually, don't.
                                                                                                 1653 - Crawling Hand - Now THAT's handy.
1654 - Crawling Hand - I'm glad its just the hand I can see...
                                                                                                                                                                                             1655 - Crawling Hand - A big severed hand.
                                                                                                 1656 - Crawling Hand - Give the guy a big hand.....
                                                                                                                                               1657 - Crawling Hand - A big severed hand.
                                                                                                 1658 - Robe Store owner - A Supplier of Magical robes.
                                                                                                 1659 - Skullball - A human skull used as a ball.
                                                                                                 1660 - Skullball Boss - He's in charge of the Skullball Course.
1661 - Agility Boss - He's in charge of the Agility Course.
                                                                                                 1662 - Skullball Trainer - A skullball guide.
                                                                                                 1663 - Agility Trainer - A werewolf agility trainer.
                                                                                                 1664 - Agility Trainer - Have you brought him the stick yet?
                                                                                             1665 - Werewolf - Looks like he's guarding a trapdoor...
1666 - null - It's a null.
                                                                                                 1667 - null - It's a null.
1668 - null - It's a null.
                                                                                                 1669 - null - It's a null.
1670 - Dr Fenkenstrain - Dr Fenkenstrain I presume.
1671 - null - It's a null.
                                                                                                 1672 - null - It's a null.
1673 - Fenkenstrain's Monster - A hideous mix of human flesh.
                                                                                                 1674 - Lord Rologarth - It looks like he has got his castle back at last.
                                                                                                 1675 - Gardener Ghost - He must find gardening difficult since the accident.
                                                                                                 1676 - Experiment - It has a key hanging from its collar.
                                                                                                 1677 - Experiment - One of Fenkenstrain's failed experiments.
1678 - Experiment - One of Fenkenstrain's failed experiments.
                                                                                                 1679 - Eluned - Wow
                                                                                             1680 - Islwyn - An elven bowyer.
                                                                                                 1681 - Moss giant - Bigger than your average moss giant.
                                                                                                 1682 - Golrie - No longer locked in his own cage.
                                                                                                 1683 - Velorina - A ghost lady.
                                                                                                 1684 - Necrovarus - An evil priest.
                                                                                                 1685 - Gravingas - This ghost looks quite rebellious.
                                                                                                 1686 - Ghost Disciple - A ghost disciple.
                                                                                                 1687 - null - It's a null.
1688 - Ak-Haranu - A trader from across the eastern sea.
1689 - null - It's a null.
                                                                                                 1690 - null - It's a null.
1691 - Undead Cow - It's an undead cow.
                                                                                                 1692 - Undead Chicken - Yep, definitely a chicken...an undead chicken
                                                                                             1693 - Giant Lobster - An extremely vicious lobster.
                                                                                                 1694 - Robin - A master bowman.
                                                                                                 1695 - Old crone - An old cranky lady.
                                                                                                 1696 - Old man - A creaky old man.
                                                                                                 1697 - Ghost Villager - A spooky ghost villager.
                                                                                                 1698 - Tortured Soul - This poor soul cannot understand why it has not passed to the next world.
                                                                                                 1699 - Ghost Shopkeeper - Beware the ghostly shopkeeper's wares!
1700 - Ghost Innkeeper - Doesn't look like the bar's open anymore.
1701 - Ghost Farmer - A spooky ghost farmer.
1702 - Ghost Banker - A ghost banker.
1703 - Ghost Sailor - A ghost sailor.
1704 - Ghost Captain - A Ghostship Captain.
1705 - Ghost Captain - A Ghostship Captain.
1706 - Ghost Guard - This ghost guards the gates of Port Phasmatys.
1707 - Ghost (?) - That ghost looks suspiciously like a cheap Halloween costume...
1708 - Ghost (?) - That ghost looks suspiciously like a cheap Halloween costume...
1709 - Johanhus Ulsbrecht - The leader of the 'Humans Against Monsters' group.
1710 - H.A.M. Guard - A guard for the humans against monster group.
1711 - H.A.M. Guard - A guard for the humans against monster group.
1712 - H.A.M. Guard - A guard for the humans against monster group.
1713 - H.A.M. Deacon - A deacon in the Humans Against Monsters group. A rather enthusiastic chap.
1714 - H.A.M. Member - A member of the 'Humans Against Monsters' group.
1715 - H.A.M. Member - A member of the 'Humans Against Monsters' group.
1716 - H.A.M. Member - A member of the 'Humans Against Monsters' group.
1717 - H.A.M. Member - A member of the 'Humans Against Monsters' group.
1718 - Jimmy the Chisel - A young man with a dark and mysterious past.
1719 - Tree - One of the most common trees in RuneScape.
1720 - Tree - One of the most common trees in RuneScape.
1721 - Tree - A commonly found tree.
1722 - Dead tree - This tree has long been dead.
1723 - Dead tree - This tree has long been dead.
1724 - Dead tree - It's only useful for firewood now.
                                                                                                 1725 - Dead tree - It's only useful for firewood now.
1726 - Dead tree - It's only useful for firewood now.
                                                                                                 1727 - Dead tree - It's only useful for firewood now.
1728 - Dead tree - It's only useful for firewood now.
                                                                                                 1729 - Dead tree - It's only useful for firewood now.
1730 - Dead tree - This tree has long been dead.
1731 - Dead tree - This tree has long been dead.
1732 - Dead tree - This tree has long been dead.
1733 - Dramen tree - An ancient magical tree.
1734 - Magic tree - The tree shimmers with a magical force.
1735 - Maple tree - I bet this makes good syrup!
1736 - Willow - These trees are found near water.
1737 - Willow - A droopy tree.
1738 - Willow - These trees are found near water.
1739 - Oak - A beautiful old oak.
1740 - Yew - A splendid tree.
1741 - Evergreen - A hardy evergreen tree.
1742 - Evergreen - A hardy evergreen tree.
1743 - Evergreen - This would make good firewood.
1744 - Tree - It's thick with snow.
                                                                                                 1745 - Dead tree - It's only useful for firewood now.
1746 - Achey Tree - An interesting tree with long straight branches.
1747 - Tree - A tree.
1748 - Tree - A tree.
1749 - Hollow tree - It's hollow...
                                                                                                                                                     1750 - Hollow tree - It's hollow...
1751 - Crow - Farmers' enemy...
                                                                                                 1752 - Crow - Farmers' enemy...
1753 - Crow - Farmers' enemy...
                                                                                                 1754 - Crow - Farmers' enemy...
1755 - Crow - Farmers' enemy...
                                                                                                 1756 - Crow - Farmers' enemy...
1757 - Farmer - He grows the crops in this area.
1758 - Farmer - He grows the crops in this area.
1759 - Farmer - Farming.
1760 - Farmer - Farming.
1761 - Farmer - Farming the wheat.
1762 - Sheep - Freshly sheared.
1763 - Sheep - White and fluffy.
1764 - Sheep - Freshly sheared.
1765 - Sheep - White and fluffy.
1766 - Cow calf - Prelude to a steak!
1767 - Cow - Where beef comes from.
1768 - Cow calf - Young and tender, nearly ready for the slaughter.
1769 - Goblin - An ugly green creature.
1770 - Goblin - An ugly green creature.
1771 - Goblin - An ugly green creature.
1772 - Goblin - An ugly green creature.
1773 - Goblin - An ugly green creature.
1774 - Goblin - An ugly green creature.
1775 - Goblin - An ugly green creature.
1776 - Goblin - An ugly green creature.
1777 - Ilfeen - A female elf.
1778 - William - A very brave merchant.
1779 - Ian - A very brave merchant.
1780 - Larry - A very brave merchant.
1781 - Darren - A very brave merchant.
1782 - Edward - A very brave merchant.
1783 - Richard - A very brave merchant.
1784 - Neil - A very brave merchant.
1785 - Edmond - A very brave merchant.
1786 - Simon - A very brave merchant.
1787 - Sam - A very brave merchant.
1788 - Lumdo - A seasoned looking Gnome foot soldier.
1789 - Bunkwicket - This Gnome is busy applying some kind of pasty material to the cave walls.
1790 - Waymottin - This Gnome is busy applying some kind of pasty material to the cave walls.
1791 - Jungle Tree - This is a fairly tall tree with sparse foliage.
1792 - Jungle Tree - This is a fairly tall tree with sparse foliage.
1793 - Tassie Slipcast - A hard-working potter.
1794 - Hammerspike Stoutbeard - He looks quite independent in an aggressive and business like way.
1795 - Dwarf gang member - A short stout menacing fellow.
1796 - Dwarf gang member - A short stout menacing fellow.
1797 - Dwarf gang member - A short stout menacing fellow.
1798 - Phantuwti Fanstuwi Farsight - A slightly more eccentric seer.
1799 - Tindel Marchant - He seems quietly enthusiastic about his profession.
1800 - Gnormadium Avlafrim - Enthusiastic gnome construction engineer.
1801 - Petra Fiyed - An energetic female adventuress.
1802 - Slagilith - This monster totally rocks!
1803 - Rock pile - A pile of boulders.
1804 - Slagilith - This monster totally rocks!
1805 - Guard - He seems to be guarding a pile of rocks. Interesting job.
1806 - Guard - He seems to be guarding a single rock. Interesting job.
1807 - Hamal the Chieftain - The chieftain of the mountain camp.
1808 - Ragnar - He looks a little lost himself.
1809 - Svidi - Is he walking around in circles?
1810 - Jokul - He seems to be minding the goats.
1811 - null - It's a null.
                                                                                                 1812 - The Kendal - Is that a bear... or a man?
                                                                                             1813 - The Kendal - Is that a bear... or a man?
                                                                                             1814 - Camp dweller - One of the inhabitants of the camp.
                                                                                                 1815 - Camp dweller - One of the inhabitants of the camp.
                                                                                                 1816 - Camp dweller - One of the inhabitants of the camp.
                                                                                                 1817 - Camp dweller - One of the inhabitants of the camp.
                                                                                                 1818 - Camp dweller - One of the inhabitants of the camp.
                                                                                                 1819 - Mountain Goat - Looks a little underfed.
                                                                                                 1820 - Mountain Goat - This goat belongs to the mountain camp people.
                                                                                                 1821 - Bald Headed Eagle - A big birdy.
                                                                                                 1822 - Cave goblin - A goblin with big bulging eyes.
                                                                                                 1823 - Cave goblin - A goblin with big bulging eyes.
                                                                                                 1824 - Cave goblin - A goblin with big bulging eyes.
                                                                                                 1825 - Cave goblin - A goblin with big bulging eyes.
                                                                                                 1826 - Hole in the wall - What could be hiding in that crack in the wall?
                                                                                             1827 - Wall Beast - A big scary hand!
                                                                                             1828 - Giant frog - It didn't get that big eating flies.
1829 - Big frog - It didn't get that big eating flies.
                                                                                                 1830 - Frog - It eats flies.
                                                                                                 1831 - Cave Slime - A foul-smelling blob of protoplasm.
                                                                                                 1832 - Cave Bug - A nasty crawling critter.
                                                                                                 1833 - Cave bug larva - A little slimy beetle-thing.
                                                                                             1834 - Candle seller - Has an odd smell about him.
                                                                                                 1835 - Easter Bunny - Cute and friendly.
                                                                                                 1836 - null - It's a null.
1837 - Dondakan the Dwarf - A short, old and gold loving guy.
1838 - Dondakan the Dwarf - A short, old and gold loving guy.
1839 - Dondakan the Dwarf - A short, old and gold loving guy.
1840 - Dwarven Engineer - A short angry guy.
1841 - Rolad - He looks a little absent-minded.
1842 - Khorvak, a dwarven engineer - The little guy is having trouble standing up right.
1843 - Dwarven Ferryman - It's probably you who will be paying the ferryman.
                                                                                                 1844 - Dwarven Ferryman - It's probably you who will be paying the ferryman.
1845 - null - It's a null.
                                                                                                 1846 - Dwarven Boatman - He seems to be in charge of the ship on the river.
                                                                                                 1847 - Miodvetnir - He seems deeply engaged in conversation with his fellow boatmen.
                                                                                                 1848 - Dernu - He seems deeply engaged in conversation with his fellow boatmen.
                                                                                                 1849 - Derni - He seems deeply engaged in conversation with his fellow boatmen.
                                                                                                 1850 - Arzinian Avatar of Strength - It is the avatar of the Arzinian Being of Bordanzan, representing strength.
                                                                                                 1851 - Arzinian Avatar of Strength - It is the avatar of the Arzinian Being of Bordanzan, representing strength.
                                                                                                 1852 - Arzinian Avatar of Strength - It is the avatar of the Arzinian Being of Bordanzan, representing strength.
                                                                                                 1853 - Arzinian Avatar of Ranging - It is the avatar of the Arzinian Being of Bordanzan, representing ranging.
                                                                                                 1854 - Arzinian Avatar of Ranging - It is the avatar of the Arzinian Being of Bordanzan, representing ranging.
                                                                                                 1855 - Arzinian Avatar of Ranging - It is the avatar of the Arzinian Being of Bordanzan, representing ranging.
                                                                                                 1856 - Arzinian Avatar of Magic - It is the avatar of the Arzinian Being of Bordanzan, representing magic.
                                                                                                 1857 - Arzinian Avatar of Magic - It is the avatar of the Arzinian Being of Bordanzan, representing magic.
                                                                                                 1858 - Arzinian Avatar of Magic - It is the avatar of the Arzinian Being of Bordanzan, representing magic.
                                                                                                 1859 - Arzinian Being of Bordanzan - It's the Arzinian Being, whatever that is, that comes from Bordanzan, wherever that is.
1860 - Brian - He sells ranging equipment.
1861 - null - It's a null.
                                                                                                 1862 - Ali Morrisane - A bazaar merchant.
                                                                                                 1863 - Drunken Ali - Drunk man.
                                                                                                 1864 - Ali The barman - A hassled looking barman.
                                                                                                 1865 - Ali the Kebab seller - A kebab seller.
                                                                                                 1866 - Market seller - A market stall keeper.
                                                                                                 1867 - Ali the Camel Man - Ali the discount animal seller.
                                                                                                 1868 - Street urchin - A mischievous looking child.
                                                                                                 1869 - null - It's a null.
1870 - Ali the Mayor - Mayor of Pollnivneach.
1871 - Ali the Hag - An old Hag named Alice.
1872 - Ali the Snake Charmer - A snake charmer.
1873 - Ali the Camel - A foul tempered ugly lumpy yellow horse prone to spitting.
1874 - Desert snake - A slithering serpent.
1875 - Snake - A toothless old Snake.
1876 - null - It's a null.
                                                                                                 1877 - null - It's a null.
1878 - Bandit Leader - Leads the Bandits.
1879 - null - It's a null.
                                                                                                 1880 - Bandit - A vicious thief.
                                                                                                 1881 - Bandit - A vicious thief.
                                                                                                 1882 - null - It's a null.
1883 - Bandit - Tough-looking.
1884 - Bandit - Tough-looking.
1885 - Bandit champion - A very tough-looking bandit.
1886 - Cowardly Bandit - Probably the weakest bandit in the world ....ever.
1887 - null - It's a null.
                                                                                                 1888 - Villager - An old male villager.
                                                                                                 1889 - Villager - An old male villager.
                                                                                                 1890 - Villager - An old male villager.
                                                                                                 1891 - null - It's a null.
1892 - Villager - Male desert villager.
1893 - Villager - Male desert villager.
1894 - Villager - Male desert villager.
1895 - null - It's a null.
                                                                                                 1896 - Villager - Female desert villager.
                                                                                                 1897 - Villager - Female desert villager.
                                                                                                 1898 - Villager - Female desert villager.
                                                                                                 1899 - null - It's a null.
1900 - null - It's a null.
                                                                                                 1901 - Menaphite Leader - Leader of the Menaphites.
                                                                                                 1902 - Ali the Operator - Smooth operator.
                                                                                                 1903 - null - It's a null.
1904 - Menaphite Thug - Menaphite thug.
1905 - Menaphite Thug - Menaphite thug.
1906 - Tough Guy - Tough looking Menaphite.
1907 - null - It's a null.
                                                                                                 1908 - Broken clay golem - An animated clay statue with a lot of clay missing.
                                                                                                 1909 - Damaged clay golem - An animated clay statue with some clay missing.
                                                                                                 1910 - Clay golem - An animated clay statue.
                                                                                                 1911 - Desert Phoenix - Definitely not a chicken.
                                                                                                 1912 - Elissa - An old archaeologist.
                                                                                                 1913 - Kamil - Ice warrior.
                                                                                                 1914 - Dessous - Vampire warrior of Zamorak.
                                                                                                 1915 - Dessous - Vampire warrior of Zamorak.
                                                                                                 1916 - Ruantun - Luckily, I can't see much of his face.
1917 - Bandit shopkeeper - I guess he sells what he steals...?
1918 - Archaeologist - Hardened by the cutthroat world of archaeology.
1919 - Stranger - Very mysterious looking...
1920 - Malak - One of Morytania's vampiric nobility.
                                                                                                 1921 - Bartender - Looks like a rough and ready type.
                                                                                                 1922 - null - It's a null.
1923 - Eblis - A very distinguished looking man.
1924 - null - It's a null.
                                                                                                 1925 - Eblis - A very distinguished looking man.
                                                                                                 1926 - Bandit - A tough-looking criminal.
                                                                                                 1927 - Bandit - A tough-looking criminal.
                                                                                                 1928 - Bandit - A tough-looking criminal.
                                                                                                 1929 - Bandit - A tough-looking criminal.
                                                                                                 1930 - Bandit - A tough-looking criminal.
                                                                                                 1931 - Bandit - A tough-looking criminal.
                                                                                                 1932 - null - It's a null.
1933 - Troll child - A little ice troll.
1934 - Troll child - A little ice troll.
1935 - Ice troll - An ice troll.
1936 - Ice Troll - Brrrrr...he must be cold!
1937 - Ice Troll - Brrrrr...he must be cold!
1938 - Ice Troll - Brrrrr...he must be cold!
1939 - Ice Troll - Brrrrr...he must be cold!
1940 - Ice Troll - Brrrrr...he must be cold!
1941 - Ice Troll - Brrrrr...he must be cold!
1942 - Ice Troll - Brrrrr...he must be cold!
1943 - null - It's a null.
                                                                                                 1944 - Ice block - A troll frozen in a block of ice.
                                                                                                 1945 - null - It's a null.
1946 - Ice block - A troll frozen in a block of ice.
1947 - null - It's a null.
                                                                                                 1948 - Troll father - An ice troll.
                                                                                                 1949 - null - It's a null.
1950 - Troll mother - An ice troll.
1951 - Ice wolf - Not man's best friend.
                                                                                                 1952 - Ice wolf - Not man's best friend.
1953 - Ice wolf - Not man's best friend.
                                                                                                 1954 - Ice wolf - Not man's best friend.
1955 - Ice wolf - Not man's best friend.
                                                                                                 1956 - Ice wolf - Not man's best friend.
1957 - null - It's a null.
                                                                                                 1958 - Mummy - Highly flammable!
                                                                                             1959 - Mummy - Highly flammable!
                                                                                             1960 - Mummy - A tightly wrapped monster.
                                                                                                 1961 - Mummy - A tightly wrapped monster.
                                                                                                 1962 - Mummy - But who's the Daddy?
1963 - Mummy - A victim of poor first aid.
1964 - Mummy - Spooky bandaged dead dude.
1965 - Mummy - A tightly wrapped monster.
1966 - Mummy - But who's the Daddy?
                                                                                             1967 - Mummy - A victim of poor first aid.
                                                                                                 1968 - Mummy - Spooky bandaged dead dude.
                                                                                                 1969 - Scarabs - I think they're some kind of beetle...
1970 - null - It's a null.
                                                                                                 1971 - Azzanadra - A Mahjarrat warrior.
                                                                                                 1972 - Rasolo - A travelling merchant.
                                                                                                 1973 - Giant skeleton - A giant skeleton.
                                                                                                 1974 - Damis - The warrior of darkness.
                                                                                                 1975 - Damis - The warrior of darkness.
                                                                                                 1976 - Shadow Hound - Looks hungry!
                                                                                             1977 - Fareed - Zamorak's warrior of fire.
1978 - Slave - A malnourished worker.
1979 - Slave - A malnourished worker.
1980 - Embalmer - A strange-smelling merchant.
1981 - Carpenter - A block of a man.
1982 - Linen Worker - A dedicated follower of fashion.
1983 - Siamun - I wonder if they dislike me examining them?
1984 - null - It's a null.
                                                                                                 1985 - null - It's a null.
1986 - High Priest - A very priestly man.
1987 - null - It's a null.
                                                                                                 1988 - Priest - Preach my brother!
                                                                                             1989 - Priest - Priestly.
                                                                                             1990 - Sphinx - An awe inspiring combination of a lady, a lion and an eagle.
                                                                                                 1991 - Possessed Priest - He has a dangerous glint in his eye.
                                                                                                 1992 - Neite - A graceful feline.
                                                                                                 1993 - Crocodile - Never smile at a...
                                                                                                                                       1994 - Jackal - He has had his day...
                                                                                                                                                                          1995 - Locust - Obnoxious overgrown insect.
                                                                                                 1996 - Vulture - If you see them circling... run.
                                                                                             1997 - Plague Frog - A very smelly frog.
                                                                                                 1998 - Plagued Cow - I might give the burgers a miss in this town.
                                                                                                 1999 - Plagued Cow - I don't fancy eating any part of this.
2000 - Plagued Cow - It's a sick-looking cow.
                                                                                                 2001 - Scarabs - I think they're some kind of beetle...
2002 - null - It's a null.
                                                                                                 2003 - null - It's a null.
2004 - null - It's a null.
                                                                                                 2005 - Wanderer - A red haired woman.
                                                                                                 2006 - Wanderer - A red haired woman.
                                                                                                 2007 - Het - Guardian of the liver. Guess he doesn't drink.
2008 - Apmeken - Body of a woman, face of a monkey.
2009 - Scabaras - A scarab headed demi-god.
2010 - Crondis - Body of a woman, head of a crocodile.
2011 - null - It's a null.
                                                                                                 2012 - Icthlarin - A jackal headed demi-god.
                                                                                             2013 - null - It's a null.
2014 - Klenter - A rather transparent character.
2015 - Mummy - A tightly wrapped monster.
2016 - Mummy - A tightly wrapped monster.
2017 - Mummy - A tightly wrapped monster.
2018 - Mummy - A tightly wrapped monster.
2019 - Mummy - A tightly wrapped monster.
2020 - null - It's a null.
                                                                                                 2021 - Light creature - A shimmering creature of blue light.
                                                                                                 2022 - Light creature - That one is carrying someone!
                                                                                             2023 - Juna - An ancient giant serpent.
                                                                                                 2024 - Strange Old Man - Wonder how long he's been here...
2025 - Ahrim the Blighted - A vengeful spirit corrupted by dark magic.
2026 - Dharok the Wretched - A vengeful spirit corrupted by dark magic.
2027 - Guthan the Infested - A vengeful spirit corrupted by dark magic.
2028 - Karil the Tainted - A vengeful spirit corrupted by dark magic.
2029 - Torag the Corrupted - A vengeful spirit corrupted by dark magic.
2030 - Verac the Defiled - A vengeful spirit corrupted by dark magic.
2031 - Bloodworm - Think I should keep my distance...
2032 - Crypt rat - A nasty little rodent.
2033 - Giant crypt rat - A nasty overgrown rodent.
2034 - Crypt spider - Incey wincey.
2035 - Giant crypt spider - Not very incey wincey...
2036 - Skeleton - Could do with gaining a few pounds.
2037 - Skeleton - Could do with gaining a few pounds.
2038 - Grish - An ogre shaman
2039 - Uglug Nar - An ogre shaman
2040 - Pilg - They're done for!
                                                                                             2041 - Grug - They're done for!
2042 - Ogre guard - An ogre that guards.
2043 - Ogre guard - An ogre that guards.
2044 - Zogre - A partially decomposing zombie ogre.
2045 - Zogre - A partially decomposing zombie ogre.
2046 - Zogre - A partially decomposing zombie ogre.
2047 - Zogre - A partially decomposing zombie ogre.
2048 - Zogre - A partially decomposing zombie ogre.
2049 - Zogre - A partially decomposing zombie ogre.
2050 - Skogre - It's falling apart!
                                                                                             2051 - Zogre - A partially decomposing zombie ogre.
                                                                                                 2052 - Zogre - A partially decomposing zombie ogre.
                                                                                                 2053 - Zogre - A partially decomposing zombie ogre.
                                                                                                 2054 - Zogre - A partially decomposing zombie ogre.
                                                                                                 2055 - Zogre - A partially decomposing zombie ogre.
                                                                                                 2056 - Skogre - A partially decomposing zombie ogre.
                                                                                                 2057 - Skogre - A skeletal ogre.
                                                                                                 2058 - Zombie - A human zombie.
                                                                                                 2059 - Zavistic Rarve - The Grand Secretary of the Wizards' Guild in Yanille.
2060 - Slash Bash - A powerful looking Zogre.
2061 - Sithik Ints - A sick, frail old man.
2062 - Sithik Ints - Is it a man or is it a monster?
2063 - Gargh - An ogre hunting chompies.
2064 - Scarg - An ogre hunting chompies.
2065 - Gruh - An ogre hunting chompies.
2066 - Irwin Feaselbaum - A young assistant necromancer.
2067 - Fishing spot - I can see fish swimming in the water.
2068 - Fishing spot - I can see fish swimming in the water.
2069 - Cave goblin miner - This one is slacking off.
2070 - Cave goblin miner - This one is slacking off.
2071 - Cave goblin miner - This one is slacking off.
2072 - Cave goblin miner - This one is slacking off.
2073 - Cave goblin guard - He protects the miners.
2074 - Cave goblin guard - He protects the miners.
2075 - Cave goblin miner - He's working away.
                                                                                                 2076 - Cave goblin miner - He's working away.
2077 - Cave goblin miner - He's working away.
                                                                                                 2078 - Cave goblin miner - He's working away.
2079 - null - It's a null.
                                                                                                 2080 - null - It's a null.
2081 - null - It's a null.
                                                                                                 2082 - Sigmund - Advisor to the Duke of Lumbridge.
                                                                                                 2083 - Sigmund - Former advisor to the Duke of Lumbridge.
                                                                                                 2084 - Mistag - He looks like he's in charge of the miners.
2085 - null - It's a null.
                                                                                                 2086 - Kazgar - He's standing guard.
2087 - Ur-tag - The ruler of the Dorgeshuun
2088 - Duke Horacio - Duke Horacio of Lumbridge.
2089 - Mistag - He looks like he's in charge of the miners.
                                                                                                 2090 - Sigmund - Former adviser to the Duke of Lumbridge.
                                                                                                 2091 - Secretary - Task master.
                                                                                                 2092 - Purple Pewter Secretary - The head secretary of the Purple Pewter mining company.
                                                                                                 2093 - Yellow Fortune Secretary - The head secretary of the Yellow Fortune mining company.
                                                                                                 2094 - Blue Opal Secretary - The head secretary of the Blue Opal mining company.
                                                                                                 2095 - Green Gemstone Secretary - The head secretary of the Green Gemstone mining company.
                                                                                                 2096 - White Chisel Secretary - The head secretary of the White Chisel mining company.
                                                                                                 2097 - Silver Cog Secretary - The head secretary of the Silver Cog mining company.
                                                                                                 2098 - Brown Engine Secretary - The head secretary of the Brown Engine mining company.
                                                                                                 2099 - Red Axe Secretary - The head secretary of the Red Axe mining company.
                                                                                                 2100 - Purple Pewter Director - One of the leaders of the business Consortium, a ruler of Keldagrim.
                                                                                                 2101 - Blue Opal Director - One of the leaders of the business Consortium, a ruler of Keldagrim.
                                                                                                 2102 - Yellow Fortune Director - One of the leaders of the business Consortium, a ruler of Keldagrim.
                                                                                                 2103 - Green Gemstone Director - One of the leaders of the business Consortium, a ruler of Keldagrim.
                                                                                                 2104 - White Chisel Director - One of the leaders of the business Consortium, a ruler of Keldagrim.
                                                                                                 2105 - Silver Cog Director - One of the leaders of the business Consortium, a ruler of Keldagrim.
                                                                                                 2106 - Brown Engine Director - One of the leaders of the business Consortium, a ruler of Keldagrim.
                                                                                                 2107 - Red Axe Director - One of the leaders of the business Consortium, a ruler of Keldagrim.
                                                                                                 2108 - Red Axe Cat - The cat belongs to the director of the Red Axe.
                                                                                                 2109 - Trader - A trader for the Purple Pewter mining company.
                                                                                                 2110 - Trader - A trader for the Purple Pewter mining company.
                                                                                                 2111 - Trader - A trader for the Blue Opal mining company.
                                                                                                 2112 - Trader - A trader for the Blue Opal mining company.
                                                                                                 2113 - Trader - A trader for the Yellow Fortune mining company.
                                                                                                 2114 - Trader - A trader for the Yellow Fortune mining company.
                                                                                                 2115 - Trader - A trader for the Green Gemstone mining company.
                                                                                                 2116 - Trader - A trader for the Green Gemstone mining company.
                                                                                                 2117 - Trader - A trader for the White Chisel mining company.
                                                                                                 2118 - Trader - A trader for the White Chisel mining company.
                                                                                                 2119 - Trader - A trader for the Silver Cog mining company.
                                                                                                 2120 - Trader - A trader for the Silver Cog mining company.
                                                                                                 2121 - Trader - A trader for the Brown Engine mining company.
                                                                                                 2122 - Trader - A trader for the Brown Engine mining company.
                                                                                                 2123 - null - It's a null.
2124 - Trader - A trader for the Red Axe mining company.
2125 - null - It's a null.
                                                                                                 2126 - Trader - A trader for the Red Axe mining company.
                                                                                                 2127 - Trade Referee - He is regulating the flow of goods on the trade floor and maintaining order.
                                                                                                 2128 - Supreme Commander - He is the Supreme Commander of all regiments of the Black Guard.
                                                                                                 2129 - Commander Veldaban - Veldaban, Commander of the Black Guard in Keldagrim.
                                                                                                 2130 - Black Guard - A member of the Black Guard, a special division of the dwarven army.
                                                                                                 2131 - Black Guard - A member of the Black Guard, a special division of the dwarven army.
                                                                                                 2132 - Black Guard - A member of the Black Guard, a special division of the dwarven army.
                                                                                                 2133 - Black Guard - A member of the Black Guard, a special division of the dwarven army.
                                                                                                 2134 - Black Guard Berserker - An elite member of the Black Guard.
                                                                                                 2135 - Black Guard Berserker - An elite member of the Black Guard.
                                                                                                 2136 - Black Guard Berserker - An elite member of the Black Guard.
                                                                                                 2137 - Gnome emissary - Apparantly negotiating some business with the Red Axe.
                                                                                                 2138 - Gnome traveller - A gnome traveller, visiting Keldagrim.
                                                                                                 2139 - Gnome traveller - A gnome traveller, visiting Keldagrim.
                                                                                                 2140 - Dromund's cat - Very protective of his master... and his property.
2141 - Blasidar the sculptor - Makes sculptures.
2142 - null - It's a null.
                                                                                                 2143 - Riki the sculptor's model - Models for sculptures.
2144 - Riki the sculptor's model - Models for sculptures.
                                                                                             2145 - Riki the sculptor's model - Models for sculptures.
2146 - Riki the sculptor's model - Models for sculptures.
                                                                                               2147 - Riki the sculptor's model - Models for sculptures.
2148 - Riki the sculptor's model - Models for sculptures.
                                                                                                 2149 - Riki the sculptor's model - Models for sculptures.
2150 - Riki the sculptor's model - Models for sculptures.
                                                                                                   2151 - Vigr - Proprietor of Vigr's Warhammers.
2152 - Santiri - Proprietor of the Quality Weapons Shop.
2153 - Saro - Proprietor of the Quality Armour Shop.
2154 - Gunslik - Proprietor of Gunslik's Assorted Items.
                                                                                                         2155 - Wemund - Looks like some kind of engineer or mechanic.
                                                                                                         2156 - Randivor - He's selling his bread on the market here.
2157 - Hervi - A gem stall owner, with goods from the deepest of mines.
2158 - Nolar - A crafty dwarf.
2159 - Gulldamar - He has lots of silver on display. And only silver.
2160 - Tati - An old mining dwarf, now he sells pickaxes and generally acts grumpy.
2161 - Agmundi - She seems to be doing rather well for herself, selling clothes in a palace shop.
2162 - Vermundi - A rather poor looking little dwarf, selling her clothes on the market.
2163 - Banker - A rather personable banker lady.
2164 - Banker - A rather serious old fella.
2165 - Librarian - He takes care of the library and its many books.
2166 - Assistant - Library assistant, to be exact.
2167 - Customer - A customer looking for books.
2168 - Customer - Looks like a human traveler visiting the library.
2169 - Dromund - What an eccentric little fellow!
2170 - Rind the gardener - He tends to the plants in the palace garden.
2171 - Factory Manager - Looks after the factory.
2172 - Factory Worker - Works hard at whatever it is he does.
2173 - Factory Worker - Works hard at whatever it is he does.
2174 - Factory Worker - Works hard at whatever it is he does.
2175 - Factory Worker - Works hard at whatever it is he does.
2176 - Inn Keeper - A keeper of the Inn.
2177 - Inn Keeper - A rich landlord, fat and jolly.
2178 - Barmaid - These Dwarf ladies are so attractive!
2179 - Barman - Makes a living off his tips I'm sure.
                                                                                                         2180 - Cart conductor - He makes sure the carts don't run anyone over.
2181 - Cart conductor - He makes sure the carts don't run anyone over.
                                                                                                         2182 - Cart conductor - He makes sure the carts don't run anyone over.
2183 - Cart conductor - He makes sure the carts don't run anyone over.
                                                                                                         2184 - Cart conductor - He makes sure the carts don't run anyone over.
2185 - Cart conductor - Remember: don't drink and ride in mine carts.
                                                                                                         2186 - Cart conductor - Keeps the line clear of traffic.
                                                                                                         2187 - Rowdy dwarf - A loud, drunk and generally obnoxious dwarf.
                                                                                                         2188 - Hegir - A bickering old dwarf.
                                                                                                         2189 - Haera - A bickering old dwarf.
                                                                                                         2190 - Runvastr - A sad old dwarf living in a sad old home.
                                                                                                         2191 - Sune - He seems to always be busy.
                                                                                                         2192 - Bentamir - This dwarf doesn't seem to be very well off.
2193 - Ulifed - A dwarf minding his own business.
2194 - Reinald - He's a bit short, but then again, he's a dwarf.
2195 - Karl - A short, merry guy.
2196 - Gauss - A beer drinking dwarf that is, for once, not totally drunk.
2197 - Myndill - A dwarf, wandering the streets of Keldagrim.
2198 - Kjut - His kebabs certainly smell delicious.
2199 - Tombar - He seems very tall. For a dwarf.
2200 - Odmar - A dwarf, wandering around Keldagrim.
2201 - Audmann - He seems to be very well off.
2202 - null - It's a null.
                                                                                                         2203 - Drunken Dwarf - He's had a fair bit to drink...
2204 - Drunken Dwarf - He's had a fair bit to drink...
                                                                                                                                                                                     2205 - Dwarven Boatman - You cannot see his ship, but presumably he has one.
                                                                                                         2206 - Dwarven Boatman - His ship miraculously survived the crash into the statue earlier.
                                                                                                         2207 - Dwarven Miner - He carries a heavy load.
                                                                                                         2208 - Dwarven Miner - He carries a heavy load.
                                                                                                         2209 - Dwarven Miner - He carries a heavy load.
                                                                                                         2210 - Dwarven Miner - He's delivered his ores.
2211 - Dwarven Miner - He carries a heavy load.
2212 - Dwarven Miner - He carries a heavy load.
2213 - Dwarven Miner - He carries a heavy load.
2214 - Dwarven Miner - He's delivered his ores.
                                                                                                         2215 - Dwarven Miner - He carries a heavy load.
                                                                                                         2216 - Dwarven Miner - He carries a heavy load.
                                                                                                         2217 - Dwarven Miner - He carries a heavy load.
                                                                                                         2218 - Dwarven Miner - He's delivered his ores.
2219 - Purple Pewter Director - One of the leaders of the business Consortium, a ruler of Keldagrim.
2220 - Purple Pewter Director - One of the leaders of the business Consortium, a ruler of Keldagrim.
2221 - Blue Opal Director - One of the leaders of the business Consortium, a ruler of Keldagrim.
2222 - Yellow Fortune Director - One of the leaders of the business Consortium, a ruler of Keldagrim.
2223 - Green Gemstone Director - One of the leaders of the business Consortium, a ruler of Keldagrim.
2224 - White Chisel Director - One of the leaders of the business Consortium, a ruler of Keldagrim.
2225 - Silver Cog Director - One of the leaders of the business Consortium, a ruler of Keldagrim.
2226 - Brown Engine Director - One of the leaders of the business Consortium, a ruler of Keldagrim.
2227 - Red Axe Director - One of the leaders of the business Consortium, a ruler of Keldagrim.
2228 - Commander Veldaban - Veldaban, Commander of the Black Guard in Keldagrim.
2229 - Red Axe Cat - The cat belongs to the director of the Red Axe.
2230 - Red Axe Cat - The cat belongs to the director of the Red Axe.
2231 - null - It's a null.
                                                                                                         2232 - Black Guard Berserker - A dwarven enforcer.
                                                                                                         2233 - Olivia - She's a seed merchant.
2234 - Master Farmer - A master at farming.
2235 - Master Farmer - A master at farming.
2236 - Market Guard - He guards the Draynor Market stalls from thieves.
2237 - Gee - A local farmer. He may be able to provide some useful information.
2238 - Donie - A local farmer. She may be able to provide some useful information.
2239 - Pig - Swine.
2240 - Pig - Porker.
2241 - Piglet - Hog.
2242 - Piglet - Porcine.
2243 - Piglet - I shall call him 'mini-pig'.
2244 - Lumbridge Guide - He provides new players with useful information.
2245 - Khazard trooper - It's one of General Khazard's warriors.
2246 - Khazard trooper - It's one of General Khazard's warriors.
2247 - Gnome troop - It's a tree gnome trooper.
                                                                                                         2248 - Gnome troop - It's a tree gnome trooper.
2249 - Gnome - Like a mini man!
2250 - Gnome - Like a mini man!
2251 - Gnome - Like a mini man!
2252 - Mounted terrorbird gnome - These gnomes know how to get around!
2253 - Wise Old Man - A venerable and rich sage.
2254 - Bed - It's a fairly ordinary bed, but...
                                                                                                         2255 - Thing under the bed - It's just like that dream I use to have when I was little.
2256 - Paladin - A holy warrior.
2257 - null - It's a null.
                                                                                                         2258 - Mage of Zamorak - A disciple of Zamorak.
                                                                                                         2259 - Mage of Zamorak - A disciple of Zamorak.
                                                                                                         2260 - null - It's a null.
2261 - Mage of Zamorak - A disciple of Zamorak.
2262 - Dark mage - An initiate of Zamorak.
2263 - Abyssal leech - A blood-drinking denizen of the abyss.
2264 - Abyssal guardian - It seems to have eyes in the back of its head...
2265 - Abyssal walker - Apparently walks the abyss.
2266 - Brian O'Richard - Head of the maze.
                                                                                                         2267 - Rogue Guard - Roguelike and guardish.
                                                                                                         2268 - Rogue Guard - Roguelike and guardish.
                                                                                                         2269 - Rogue Guard - Roguelike and guardish.
                                                                                                         2270 - Martin Thwait - A loveable rogue.
                                                                                                         2271 - Emerald Benedict - A rich banker man... Some say too rich.
                                                                                                         2272 - Spin Blades - I don't think I want to get too close to that!
2273 - Spin Blades - I don't think I want to get too close to that!
                                                                                                     2274 - Goblin - An ugly green creature.
                                                                                                         2275 - Goblin - An ugly green creature.
                                                                                                         2276 - Goblin - An ugly green creature.
                                                                                                         2277 - Goblin - An ugly green creature.
                                                                                                         2278 - Goblin - An ugly green creature.
                                                                                                         2279 - Goblin - An ugly green creature.
                                                                                                         2280 - Goblin - An ugly green creature.
                                                                                                         2281 - Goblin - An ugly green creature.
                                                                                                         2282 - Sir Spishyus - An observer for the Temple Knights.
                                                                                                         2283 - Lady Table - An observer for the Temple Knights.
                                                                                                         2284 - Sir Kuam Ferentse - An observer for the Temple Knights.
                                                                                                         2285 - Sir Leye - A warrior blessed by Saradomin.
                                                                                                         2286 - Sir Tinley - An observer for the Temple Knights.
                                                                                                         2287 - Sir Ren Itchood - An observer for the Temple Knights.
                                                                                                         2288 - Miss Cheevers - An observer for the Temple Knights.
                                                                                                         2289 - Ms. Hynn Terprett - An observer for the Temple Knights.
                                                                                                         2290 - Sir Tiffy Cashien - Head of recruitment for the Temple Knights.
                                                                                                         2291 - Rug Merchant - A carpet merchant.
                                                                                                         2292 - Rug Merchant - A carpet merchant.
                                                                                                         2293 - Rug Merchant - A man who deals in rugs.
                                                                                                         2294 - Rug Merchant - A man who deals in rugs.
                                                                                                         2295 - null - It's a null.
2296 - Rug Merchant - A man who deals in rugs.
2297 - null - It's a null.
                                                                                                         2298 - Rug Merchant - A man who deals in rugs.
                                                                                                         2299 - null - It's a null.
2300 - Rug Station Attendant - A man who deals in rugs.
2301 - Monkey - Perhaps our oldest relatives?
2302 - null - It's a null.
                                                                                                         2303 - null - It's a null.
2304 - Sarah - She sells farming equipment.
2305 - Vanessa - She sells farming equipment.
2306 - Richard - He sells farming equipment.
2307 - Alice - She sells farming equipment.
2308 - Capt' Arnav - Distinctly piratey.
                                                                                                         2309 - - -
                                                                                                         2310 - Cow calf - Young but still beefy.
                                                                                                         2311 - Sheepdog - Farmer-sheep liaison officer. Go on
                                                                                                     2312 - Rooster - He rules the...er...roost.
                                                                                                     2313 - Chicken - Yep, definitely a chicken.
                                                                                                             2314 - Chicken - Yep, definitely a chicken.
                                                                                                             2315 - Chicken - Yep, definitely a chicken.
                                                                                                             2316 - Pig - Swine.
                                                                                                     2317 - Pig - Porker.
                                                                                                     2318 - Piglet - Hog.
                                                                                                     2319 - Piglet - Porcine.
                                                                                                     2320 - Piglet - I shall call him 'mini-pig'.
                                                                                                         2321 - Blandebir - An expert on the brewing of ales and cider.
                                                                                                         2322 - Metarialus - In his former life an expert brewer.
                                                                                                         2323 - Elstan - Perhaps this gardener might look after your crops for you.
                                                                                                                                                                           2324 - Dantaera - Perhaps this gardener might look after your crops for you.
                                                                                                                                                                                                                                               2325 - Kragen - Perhaps this gardener might look after your crops for you.
                                                                                                                                                                                                                                                                                                                 2326 - Lyra - Perhaps this gardener might look after your crops for you.
                                                                                                                                                                                                                                                                                                                                                                                 2327 - Francis - Perhaps this gardener might look after your crops for you.
                                                                                                                                                                                                                                                                                                                                                                                                                                                    2328 - Gardener - Perhaps this gardener might look after your crops for you.
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        2329 - Iago - Perhaps this gardener might look after your crops for you.
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        2330 - Garth - Perhaps this gardener might look after your crops for you.
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         2331 - Ellena - Perhaps this gardener might look after your crops for you.
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           2332 - Selena - Perhaps this gardener might look after your crops for you.
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             2333 - Vasquen - Perhaps this gardener might look after your crops for you.
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                2334 - Rhonen - Perhaps this gardener might look after your crops for you.
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  2335 - Dreven - Perhaps this gardener might look after your crops for you.
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    2336 - Taria - Perhaps this gardener might look after your crops for you.
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     2337 - Rhazien - Perhaps this gardener might look after your crops for you.
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        2338 - Torrell - Perhaps this gardener might look after your crops for you.
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           2339 - Alain - Perhaps this gardener might look after your crops for you.
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            2340 - Heskel - Perhaps this gardener might look after your crops for you.
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              2341 - Treznor - Perhaps this gardener might look after your crops for you.
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 2342 - Fayeth - Perhaps this gardener might look after your crops for you.
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   2343 - Bolongo - Perhaps this gardener might look after your crops for you.
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      2344 - Gileth - Perhaps this gardener might look after your crops for you.
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        2345 - Sick-looking sheep (1) - The sheep looks distinctly unwell and has a slight red tinge.
                                                                                                                                                     2346 - Sick-looking sheep (2) - The sheep looks distinctly unwell and has a slight green tinge.
                                                                                                                                                     2347 - Sick-looking sheep (3) - The sheep looks distinctly unwell and has a slight blue tinge.
                                                                                                                                                     2348 - Sick-looking sheep (4) - The sheep looks distinctly unwell and has a slight yellow tinge.
                                                                                                                                                     2349 - Mourner - A mourner.
                                                                                                                                                     2350 - Mourner - A mourner.
                                                                                                                                                     2351 - Mourner - A mourner.
                                                                                                                                                     2352 - Eudav - Buys wholesale, sells retail.
                                                                                                                                                     2353 - Oronwen - An Elven Seamstress.
                                                                                                                                                     2354 - Banker - He can look after my money.
                                                                                                                                                     2355 - Banker - She can look after my money.
                                                                                                                                                     2356 - Dalldav - Buys and sells bows.
                                                                                                                                                     2357 - Gethin - Looks like he knows his way around a kitchen.
                                                                                                                                                     2358 - Arianwyn - An odd looking person.
                                                                                                                                                     2359 - Elf warrior - I don't wanna be at the wrong end of that pike.
2360 - Elf warrior - I don't wanna be at the wrong end of that pike.
                                                                                                                                                   2361 - Elf warrior - He looks pretty handy with that bow.
                                                                                                                                                   2362 - Elf warrior - He looks pretty handy with that bow.
                                                                                                                                                   2363 - Goreu - An Elf.
                                                                                                                                                   2364 - Ysgawyn - An Elf.
                                                                                                                                                   2365 - Arvel - An Elf.
                                                                                                                                                   2366 - Mawrth - An Elf.
                                                                                                                                                   2367 - Kelyn - An Elf.
                                                                                                                                                   2368 - Eoin - An Elven child.
                                                                                                                                                   2369 - Iona - An Elven child.
                                                                                                                                                   2370 - null - It's a null.
2371 - Gnome - A fearful Gnome.
2372 - Head mourner - A Mourner showing his true identity.
2373 - Mourner - A Mourner, or plague healer.
2374 - Mourner - A Mourner, or plague healer.
2375 - null - It's a null.
                                                                                                                                                   2376 - Eluned - Wow
                                                                                                                                               2377 - Sick-looking sheep (1) - This sheep is dyed red.
                                                                                                                                                   2378 - Sick-looking sheep (2) - This sheep is dyed green.
                                                                                                                                                   2379 - Sick-looking sheep (3) - This sheep is dyed blue.
                                                                                                                                                   2380 - Sick-looking sheep (4) - This sheep is dyed yellow.
                                                                                                                                                   2381 - null - It's a null.
2382 - null - It's a null.
                                                                                                                                                   2383 - null - It's a null.
2384 - null - It's a null.
                                                                                                                                                   2385 - null - It's a null.
2386 - null - It's a null.
                                                                                                                                                   2387 - null - It's a null.
2388 - null - It's a null.
                                                                                                                                                   2389 - null - It's a null.
2390 - null - It's a null.
                                                                                                                                                   2391 - null - It's a null.
2392 - null - It's a null.
                                                                                                                                                   2393 - null - It's a null.
2394 - null - It's a null.
                                                                                                                                                   2395 - null - It's a null.
2396 - null - It's a null.
                                                                                                                                                   2397 - Mysterious ghost - Seems to flitter in and out of existence...
                                                                                                                                                                                                                2398 - Mysterious ghost - Seems to flitter in and out of existence...
                                                                                                                                                                                                                                                                             2399 - Mysterious ghost - Seems to flitter in and out of existence...
                                                                                                                                                                                                                                                                                                                                          2400 - Mysterious ghost - Seems to flitter in and out of existence...
                                                                                                                                                                                                                                                                                                                                                                                                       2401 - Mysterious ghost - Seems to flitter in and out of existence...
                                                                                                                                                                                                                                                                                                                                                                                                                                                                    2402 - Mysterious ghost - Seems to flitter in and out of existence...
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 2403 - null - It's a null.
2404 - null - It's a null.
                                                                                                                                                   2405 - null - It's a null.
2406 - null - It's a null.
                                                                                                                                                   2407 - null - It's a null.
2408 - null - It's a null.
                                                                                                                                                   2409 - Cart conductor - He makes sure the carts don't run anyone over.
2410 - Red Axe Director - Walking stick, spiky hair, twirly moustache. He's a villain alright.
                                                                                                                                                   2411 - Red Axe Director - Walking stick, spiky hair, twirly moustache. He's a villain alright.
2412 - Red Axe Henchman - That's one mean looking dwarf the Red Axe has employed.
                                                                                                                                                   2413 - Red Axe Henchman - That's one mean looking dwarf the Red Axe has employed.
2414 - Red Axe Henchman - That's one mean looking dwarf the Red Axe has employed.
                                                                                                                                                   2415 - Colonel Grimsson - That's one mean looking dwarf the Red Axe has employed.
2416 - Colonel Grimsson - That's one mean looking dwarf the Red Axe has employed.
                                                                                                                                                   2417 - Ogre shaman - Seems intelligent... for an ogre.
                                                                                                                                                   2418 - Ogre shaman - Seems intelligent... for an ogre.
                                                                                                                                                   2419 - Grunsh - Seems intelligent... for an ogre.
                                                                                                                                                   2420 - Gnome emissary - Apparantly negotiating some business with the Red Axe.
                                                                                                                                                   2421 - Gnome companion - The companion of the gnome emissary.
                                                                                                                                                   2422 - Gnome companion - The companion of the gnome emissary.
                                                                                                                                                   2423 - Chaos dwarf - A dwarf gone bad.
                                                                                                                                                   2424 - Gunslik - Proprietor of Gunslik's Assorted Items.
2425 - Nolar - A crafty dwarf.
2426 - Factory Worker - Taking a break from work, presumably.
2427 - Cart conductor - Remember: don't drink and ride in minecarts.
                                                                                                                                                   2428 - Gauss - A beer drinking dwarf that is, for once, not totally drunk.
                                                                                                                                                   2429 - Drunken Dwarf - He's had a fair bit to drink...
2430 - Rowdy dwarf - A loud, drunk and generally obnoxious dwarf.
2431 - Ulifed - A dwarf minding his own business.
2432 - Red Axe Henchman - A short, but extremely tough looking dwarf...
2433 - Red Axe Henchman - A short, but extremely tough looking dwarf...
2434 - Ogre shaman - Seems intelligent... for an ogre.
2435 - null - It's a null.
                                                                                                                                                   2436 - Jarvald - A Fremennik raider.
                                                                                                                                                   2437 - Jarvald - A Fremennik raider.
                                                                                                                                                   2438 - Jarvald - A Fremennik raider.
                                                                                                                                                   2439 - Askeladden - Looks like a wanna be Fremennik.
                                                                                                                                                   2440 - Door-support - This support is propping the door closed.
                                                                                                                                                   2441 - Door - Without it's support, it was no problem!
2442 - Door - Without it's support, it was no problem!
                                                                                                                                               2443 - Door-support - This support is propping the door closed.
                                                                                                                                                   2444 - Door - This door seems to have a weak point.
                                                                                                                                                   2445 - Door - This door seems to have a weak point.
                                                                                                                                                   2446 - Door-support - This support is propping the door closed.
                                                                                                                                                   2447 - Door - This door seems to have a weak point.
                                                                                                                                                   2448 - Door - This door seems to have a weak point.
                                                                                                                                                   2449 - Egg - I bet it's not made of chocolate...
2450 - Egg - Moving eggs are worrying...
2451 - Egg - I wonder what was inside it?
2452 - Giant Rock Crab - No one likes crabs... especially really big ones!
2453 - Boulder - Heavy rock!
2454 - Dagannoth spawn - A teeny-tiny horror from the ocean depths...
2455 - Dagannoth - A darkened horror from the ocean depths...
2456 - Dagannoth - A spiney horror from the ocean depths...
2457 - Wallasalki - A fearsome magical water creature.
2458 - Freaky Forester - He's at home in the forests.
                                                                                                                                                   2459 - Pheasant - A brightly coloured game bird.
                                                                                                                                                   2460 - Pheasant - A brightly coloured game bird.
                                                                                                                                                   2461 - Pheasant - A brightly coloured game bird.
                                                                                                                                                   2462 - Pheasant - A brightly coloured game bird.
                                                                                                                                                   2463 - Evil Chicken - A fowl beast.
                                                                                                                                                   2464 - Evil Chicken - A fowl beast.
                                                                                                                                                   2465 - Evil Chicken - A fowl beast.
                                                                                                                                                   2466 - Evil Chicken - A fowl beast.
                                                                                                                                                   2467 - Evil Chicken - A fowl beast.
                                                                                                                                                   2468 - Evil Chicken - A fowl beast.
                                                                                                                                                   2469 - Frog - A frog.
                                                                                                                                                   2470 - Frog - A frog.
                                                                                                                                                   2471 - Frog - A frog.
                                                                                                                                                   2472 - Frog - A frog.
                                                                                                                                                   2473 - Frog - Eek! You're a frog!
2474 - Frog prince - What a handsome man!
2475 - Frog princess - What a nice dress!
2476 - Rick Turpentine - A Masked Highwayman.
2477 - Quiz Master - Apparently a master of quizzes!
2478 - Evil Bob - Hey, it's Bob the cat! Or... is it?
                                                                                                                                               2479 - Evil Bob - Hey, it's Bob the cat! Or... is it?
2480 - Servant - Servant of Evil Bob.
2481 - Servant - Servant of Evil Bob.
2482 - Giant bat - Annoying flappy thing.
2483 - null - It's a null.
                                                                                                                                                   2484 - null - It's a null.
2485 - null - It's a null.
                                                                                                                                                   2486 - null - It's a null.
2487 - null - It's a null.
                                                                                                                                                   2488 - null - It's a null.
2489 - Bush Snake - A slithering serpent that likes to hide in the bush.
2490 - Bush Snake - A slithering serpent that likes to hide in the bush.
2491 - Jungle spider - A barely visible deadly jungle spider.
2492 - Jungle Spider - A barely visible deadly jungle spider.
2493 - Large mosquito - A flying blood sucker.
2494 - Mosquito swarm - A swarm of three highly agile mosquitoes.
2495 - Mosquito swarm - A swarm of five highly agile mosquitoes.
2496 - Tribesman - A vicious warrior.
2497 - Tribesman - A vicious warrior.
2498 - Broodoo victim - An undead victim of some ancient murderous ritual, his skin appears deep green.
2499 - Broodoo victim - An undead victim of some ancient murderous ritual, his skin appears deep green.
2500 - Broodoo victim - An undead victim of some ancient murderous ritual, his skin appears pale yellow.
2501 - Broodoo victim - An undead victim of some ancient murderous ritual, his skin appears pale yellow.
2502 - Broodoo victim - An undead victim of some ancient murderous ritual, his skin is pale and drawn.
2503 - Broodoo victim - An undead victim of some ancient murderous ritual, his skin is pale and drawn.
2504 - null - It's a null.
                                                                                                                                                   2505 - Sharimika - A native of Tai Bwo Wannai.
                                                                                                                                                   2506 - Sharimika - A native of Tai Bwo Wannai.
                                                                                                                                                   2507 - null - It's a null.
2508 - Mamma Bufetta - A native of Tai Bwo Wannai.
2509 - Mamma Bufetta - A native of Tai Bwo Wannai.
2510 - null - It's a null.
                                                                                                                                                   2511 - Layleen - A native of Tai Bwo Wannai.
                                                                                                                                                   2512 - Layleen - A native of Tai Bwo Wannai.
                                                                                                                                                   2513 - null - It's a null.
2514 - Karaday - A native of Tai Bwo Wannai.
2515 - Karaday - A native of Tai Bwo Wannai.
2516 - null - It's a null.
                                                                                                                                                   2517 - Safta Doc - A native of Tai Bwo Wannai.
                                                                                                                                                   2518 - Safta Doc - A native of Tai Bwo Wannai.
                                                                                                                                                   2519 - null - It's a null.
2520 - Gabooty - A native of Tai Bwo Wannai.
2521 - Gabooty - A native of Tai Bwo Wannai.
2522 - null - It's a null.
                                                                                                                                                   2523 - Fanellaman - A native of Tai Bwo Wannai.
                                                                                                                                                   2524 - Fanellaman - A native of Tai Bwo Wannai.
                                                                                                                                                   2525 - null - It's a null.
2526 - Jagbakoba - A native of Tai Bwo Wannai.
2527 - Jagbakoba - A native of Tai Bwo Wannai.
2528 - null - It's a null.
                                                                                                                                                   2529 - Murcaily - A native of Tai Bwo Wannai.
                                                                                                                                                   2530 - Murcaily - A native of Tai Bwo Wannai.
                                                                                                                                                   2531 - null - It's a null.
2532 - Rionasta - A native of Tai Bwo Wannai.
2533 - Rionasta - A native of Tai Bwo Wannai.
2534 - Mahogany - A beautiful old mahogany tree.
2535 - Teak - A beautiful old teak tree.
2536 - Niles - The brother of Miles and Giles.
2537 - Miles - The brother of Niles and Giles.
2538 - Giles - The brother of Niles and Miles.
2539 - Cap'n Hand - Swashbuckles his way across the seven seas.
                                                                                                                                                   2540 - Dr Jekyll - He looks troubled...
                                                                                                                                                                                   2541 - Mr Hyde - This is not a good time to be examining him!
                                                                                                                                               2542 - Mr Hyde - This is not a good time to be examining him!
                                                                                                                                               2543 - Mr Hyde - This is not a good time to be examining him!
                                                                                                                                               2544 - Mr Hyde - This is not a good time to be examining him!
                                                                                                                                               2545 - Mr Hyde - This is not a good time to be examining him!
                                                                                                                                               2546 - Mr Hyde - This is not a good time to be examining him!
                                                                                                                                               2547 - Dr Ford - He's here to help.
2548 - Blackjack seller - A market stall keeper.
2549 - Ali the dyer - A colourful character.
2550 - Dwarven Miner - He carries a heavy load.
2551 - Dwarven Miner - He carries a heavy load.
2552 - Dwarven Miner - He carries a heavy load.
2553 - Blast Furnace Foreman - Looks after the blast furnace.
2554 - Tin ore - Some ore going into the furnace.
2555 - Copper ore - Some ore going into the furnace.
2556 - Iron ore - Some ore going into the furnace.
2557 - Mithril ore - Some ore going into the furnace.
2558 - Adamantite ore - Some ore going into the furnace.
2559 - Runite ore - Some ore going into the furnace.
2560 - Silver ore - Some ore going into the furnace.
2561 - Gold ore - Some ore going into the furnace.
2562 - Coal - Some ore going into the furnace.
2563 - Perfect gold ore - Some ore going into the furnace.
2564 - Ordan - He smells of rock dust.
2565 - Jorzik - He buys stuff.
2566 - Wise Old Man - A venerable sage.
2567 - Wise Old Man - A venerable and rich sage.
2568 - Banker - He can look after my money.
2569 - Banker - Good with money.
2570 - Banker - Good with money.
2571 - Market Guard - He guards the Draynor Market stalls from thieves.
2572 - Olivia - She's a seed merchant.
                                                                                                                                                   2573 - Watchman - The strong arm of the law.
                                                                                                                                                   2574 - Bank guard - He's guarding the bank.
2575 - Purepker895 - A player.
2576 - Qutiedoll - A player.
2577 - 1337sp34kr - A player.
2578 - Elfinlocks - A player.
2579 - Cool Mom227 - A player.
2580 - Bernald - Looks after the Burthorpe vinery.
2581 - Ellamaria - Queen Ellamaria of Varrock.
2582 - Trolley - This statue of Saradomin has been 'borrowed' for a while.
2583 - Trolley - This statue of a king has been 'borrowed' for a while.
2584 - Trolley - An empty trolley.
2585 - null - It's a null.
                                                                                                                                                   2586 - Billy, a guard of Falador - Somebody should have warned him when he signed up.
                                                                                                                                                   2587 - Bob, another guard of Falador - Shame his pension's going to waste.
2588 - Brother Althric - A holy man.
2589 - PKMaster0036 - A master of the wilderness.
2590 - King Roald - Varrock's resident monarch.
                                                                                                                                                   2591 - TzHaar-Mej - Appears to be some kind of mystic.
                                                                                                                                                   2592 - TzHaar-Mej - Appears to be some kind of mystic.
                                                                                                                                                   2593 - TzHaar-Mej - Appears to be some kind of mystic.
                                                                                                                                                   2594 - TzHaar-Mej - Appears to be some kind of mystic.
                                                                                                                                                   2595 - TzHaar-Mej - Appears to be some kind of mystic.
                                                                                                                                                   2596 - TzHaar-Mej - Appears to be some kind of mystic.
                                                                                                                                                   2597 - TzHaar-Mej - Appears to be some kind of mystic.
                                                                                                                                                   2598 - TzHaar-Hur - Looks like a craftsman of some kind.
                                                                                                                                                   2599 - TzHaar-Hur - Looks like a craftsman of some kind.
                                                                                                                                                   2600 - TzHaar-Hur - Looks like a craftsman of some kind.
                                                                                                                                                   2601 - TzHaar-Hur - Looks like a craftsman of some kind.
                                                                                                                                                   2602 - TzHaar-Hur - Looks like a craftsman of some kind.
                                                                                                                                                   2603 - TzHaar-Hur - Looks like a craftsman of some kind.
                                                                                                                                                   2604 - TzHaar-Xil - Doesn't look very social.
2605 - TzHaar-Xil - Doesn't look very social.
                                                                                                                                                   2606 - TzHaar-Xil - Doesn't look very social.
2607 - TzHaar-Xil - Doesn't look very social.
                                                                                                                                                   2608 - TzHaar-Xil - Doesn't look very social.
2609 - TzHaar-Xil - Doesn't look very social.
                                                                                                                                                   1337 - Created by Fasga -
                                                                                                                                                                         2610 - TzHaar-Ket - Must be a guard or something.
                                                                                                                                                   2611 - TzHaar-Ket - Must be a guard or something.
                                                                                                                                                   2612 - TzHaar-Ket - Must be a guard or something.
                                                                                                                                                   2613 - TzHaar-Ket - Must be a guard or something.
                                                                                                                                                   2614 - TzHaar-Ket - Must be a guard or something.
                                                                                                                                                   2615 - TzHaar-Ket - Must be a guard or something.
                                                                                                                                                   2616 - TzHaar-Ket - Must be a guard or something.
                                                                                                                                                   2617 - TzHaar-Mej-Jal - Another one of those mystic-types.
                                                                                                                                               2618 - TzHaar-Mej-Kah - Another one of those mystic-types.
                                                                                                                                               2619 - TzHaar-Ket-Zuh - Maybe it'll guard my possessions.
2620 - TzHaar-Hur-Tel - Wonder what it's making.
                                                                                                                                                   2621 - TzHaar-Hur-Koz - Wonder what it's making.
2622 - TzHaar-Hur-Lek - Wonder what it's making.
                                                                                                                                                   2623 - TzHaar-Mej-Roh - Another one of those mystic-types.
                                                                                                                                               2624 - TzHaar-Ket - Must be a guard or something.
                                                                                                                                                   2625 - TzHaar-Ket - Must be a guard or something.
                                                                                                                                                   2626 - Rocks - Stoney!
                                                                                                                                               2627 - Tz-Kih - Some kind of bat...
                                                                                                                                                                                2628 - Tz-Kih - Some kind of bat...
                                                                                                                                                                                                                 2629 - Tz-Kek - Looks like living lava...
                                                                                                                                                                                                                                                       2630 - Tz-Kek - Looks like living lava...
                                                                                                                                                                                                                                                                                             2631 - Tok-Xil - I don't like the look of those spines...
2632 - Tok-Xil - I don't like the look of those spines...
                                                                                                                                                                                                                                                                                                                                                                        2633 - Wise Old Man - A venerable sage.
                                                                                                                                                   2634 - Miss Schism - A busy-body who loves a bit of gossip.
                                                                                                                                                   2635 - Bob - The Jagex cat.
                                                                                                                                                   2636 - Bob - The Jagex cat.
                                                                                                                                                   2637 - Sphinx - An awe inspiring combination of a lady, a lion and an eagle.
                                                                                                                                                   2638 - Neite - A graceful feline.
                                                                                                                                                   2639 - Robert the Strong - A battle hardened hero.
                                                                                                                                                   2640 - Odysseus - Robert's beautiful panther.
2641 - Dragonkin - Creator of Dragons.
2642 - King Black Dragon - The biggest, meanest dragon around.
2643 - R4ng3rNo0b889 - A ranger.
2644 - Love Cats - Loving cats.
2645 - Love Cats - Loving cats.
2646 - Neite - A graceful feline.
2647 - Bob - The Jagex cat.
2648 - Beite - A special kitty.
2649 - Gnome - She gnows where its gnat.
2650 - Gnome - A gnome of sorts.
2651 - Odysseus - Robert's beautiful panther.
                                                                                                                                                   2652 - null - It's a null.
2653 - Neite - A graceful feline.
2654 - null - It's a null.
                                                                                                                                                   2655 - Unferth - Nice but dim.
                                                                                                                                                   2656 - Unferth - Nice but dim.
                                                                                                                                                   2657 - Unferth - Nice but dim.
                                                                                                                                                   2658 - Unferth - Nice but dim.
                                                                                                                                                   2659 - Unferth - Nice but dim.
                                                                                                                                                   2660 - Reldo - Reldo the librarian.
                                                                                                                                                   2661 - Reldo - Reldo the librarian.
                                                                                                                                                   2662 - Lazy cat - A friendly not so little pet.
                                                                                                                                                   2663 - Lazy cat - A friendly not so little pet.
                                                                                                                                                   2664 - Lazy cat - A friendly not so little pet.
                                                                                                                                                   2665 - Lazy cat - A friendly not so little pet.
                                                                                                                                                   2666 - Lazy cat - A friendly not so little pet.
                                                                                                                                                   2667 - Lazy cat - A friendly not so little pet.
                                                                                                                                                   2668 - Wily cat - A friendly little pet.
                                                                                                                                                   2669 - Wily cat - Wild.
                                                                                                                                               2670 - Wily cat - Wild.
                                                                                                                                               2671 - Wily cat - Wild.
                                                                                                                                               2672 - Wily cat - Wild.
                                                                                                                                               2673 - Wily cat - Wild.
                                                                                                                                               2674 - Thief - Known for his light-fingered qualities.
                                                                                                                                                   2675 - Man - One of RuneScape's many citizens.
2676 - Make-over mage - Master of the mystical make-over.
2677 - Highwayman - He holds up passers by.
2678 - Goblin - An ugly green creature.
2679 - Goblin - An ugly green creature.
2680 - Goblin - An ugly green creature.
2681 - Goblin - An ugly green creature.
2682 - Rat - A popular dwarven delicacy.
2683 - Hengel - A citizen of Rimmington.
2684 - Anja - A citizen of Rimmington.
2685 - Hobgoblin - An ugly, smelly creature.
2686 - Hobgoblin - An ugly, smelly creature.
2687 - Hobgoblin - An ugly, smelly creature.
2688 - Hobgoblin - An ugly, smelly creature wielding a spear.
2689 - Frog - Didn't the mage say this procedure was totally safe?
                                                                                                                                               2690 - Jack Seagull - A salty seafarer. Needs a wash.
                                                                                                                                                   2691 - Longbow Ben - A strange man with a strange name. Probably a strange past, too.
                                                                                                                                                   2692 - Ahab - So what can one do with a drunken sailor?
                                                                                                                                               2693 - Seagull - A messy bird.
                                                                                                                                                   2694 - Seagull - Smells of rotten fish.
                                                                                                                                                   2695 - Pirate - Yar! Shiver me timbers!
                                                                                                                                               2696 - Thief - Known for his lightfingered qualities.
                                                                                                                                                   2697 - Mugger - He jumps out and attacks people.
                                                                                                                                                   2698 - Black Knight - A dark-hearted knight.
                                                                                                                                                   2699 - Guard - He's guarding the prison.
2700 - Guard - A prison guard.
2701 - Guard - A prison guard.
2702 - Guard - A prison guard.
2703 - Guard - A prison guard.
2704 - Guard - He's asleep.
                                                                                                                                                   2705 - Guard - Keeping an eye out for suspicious activity.
                                                                                                                                                   2706 - Crab - No one likes crabs...
                                                                                                                                                                                  2707 - Seagull - A sea bird.
                                                                                                                                                   2708 - Seagull - A sea bird.
                                                                                                                                                   2709 - Fire Wizard - Caution
                                                                                                                                               2710 - Water Wizard - Hydro-power!
                                                                                                                                               2711 - Earth Wizard - His hands are covered in mud. At least, I hope that's mud.
2712 - Air Wizard - At least he looks solid enough to fight.
2713 - Malignius Mortifer - A master of necromancy!
2714 - Zombie - Dead man walking!
2715 - Skeleton - Rattle dem bones!
2716 - Ghost - WoooOOOOoooo!
2717 - Skeleton mage - Dead, but still powerful.
2718 - Betty - She seems like a nice sort of person.
2719 - Grum - Loves his gold!
2720 - Gerrant - An expert on fishing.
2721 - Wydin - Likes his food to be kept fresh.
2722 - Giant rat - Overgrown vermin.
2723 - Giant rat - Overgrown vermin.
2724 - Skeleton - Could do with gaining a few pounds.
2725 - Skeleton - Could do with gaining a few pounds.
2726 - Gull - A sea bird.
2727 - Gull - A sea bird.
2728 - Monk of Entrana - Holy looking.
2729 - Monk of Entrana - Holy looking.
2730 - Monk of Entrana - Holy looking.
2731 - Monk of Entrana - Holy looking.
2732 - Master Crafter - He works in the Crafting Guild.
2733 - Master Crafter - He wanders around the Crafting Guild pretending to be working.
2734 - Tz-Kih - Some kind of bat...
2735 - Tz-Kih - Some kind of bat...
2736 - Tz-Kek - Looks like living lava...
2737 - Tz-Kek - Looks like living lava...
2738 - Tz-Kek - Looks like living lava...
2739 - Tok-Xil - I don't like the look of those spines...
                                                                                                                                                                                                                                                                             2740 - Tok-Xil - I don't like the look of those spines...
2741 - Yt-MejKot - Holy reptile...
2742 - Yt-MejKot - Holy reptile...
2743 - Ket-Zek - Good doggy-lizard-thing...
2744 - Ket-Zek - Good doggy-lizard-thing...
2745 - TzTok-Jad - This is going to hurt...
2746 - Yt-HurKot - Mini menace.
2747 - Solus Dellagar - A powerful warrior mage.
2748 - Savant - Assigned to help tracking down Solus Dellagar.
2749 - Lord Daquarius - Wears a stylish suit of armour.
2750 - Solus Dellagar - A powerful warrior mage.
2751 - Black Knight - A dark-hearted knight.
2752 - Lord Daquarius - Wears a stylish suit of armour.
2753 - Mage of Zamorak - A disciple of Zamorak.
2754 - Mage of Zamorak - A disciple of Zamorak.
2755 - Mage of Zamorak - A disciple of Zamorak.
2756 - null - It's a null.
                                                                                                                                                   2757 - null - It's a null.
2758 - null - It's a null.
                                                                                                                                                   2759 - null - It's a null.
2760 - null - It's a null.
                                                                                                                                                   2761 - null - It's a null.
2762 - null - It's a null.
                                                                                                                                                   2763 - null - It's a null.
2764 - null - It's a null.
                                                                                                                                                   2765 - null - It's a null.
2766 - null - It's a null.
                                                                                                                                                   2767 - null - It's a null.
2768 - null - It's a null.
                                                                                                                                                   2769 - null - It's a null.
2770 - null - It's a null.
                                                                                                                                                   2771 - null - It's a null.
2772 - null - It's a null.
                                                                                                                                                   2773 - null - It's a null.
2774 - null - It's a null.
                                                                                                                                                   2775 - null - It's a null.
2776 - Woman - One of RuneScape's many citizens.
                                                                                                                                                   2777 - Black Knight - A dark-hearted knight.
                                                                                                                                                   2778 - Black Knight - A dark-hearted knight.
                                                                                                                                                   2779 - Ranger - A Ranger of the Temple Knights.
                                                                                                                                                   2780 - Solus Dellagar - A powerful warrior mage.
                                                                                                                                                   2781 - Gnome guard - A tree gnome guard.
                                                                                                                                                   2782 - Shadow - A shadow.
                                                                                                                                                   2783 - Dark Beast - From a darker dimension.
                                                                                                                                                   2784 - Mourner - A Mourner, or plague healer.
                                                                                                                                                       2785 - Slave - Digging.
                                                                                                                                               2786 - Slave - Digging.
                                                                                                                                               2787 - Slave - Confused.
                                                                                                                                               2788 - null - It's a null.
2789 - Thorgel - A short angry guy.
2790 - Sergeant Damien - Drill Sergeant from heck!
2791 - Pillory Guard - A law enforcer.
2792 - Tramp - A man down on his luck.
2793 - Tramp - A man down on his luck.
2794 - Tramp - A man down on his luck.
2795 - null - It's a null.
                                                                                                                                                   2796 - Skippy - He looks angry and smells drunk.
                                                                                                                                                   2797 - Skippy - Like a regular Skippy, just damper.
                                                                                                                                                   2798 - Skippy - Skippy, just looking a little 'tender'.
                                                                                                                                                   2799 - Skippy - He seems a lot less angry and smells a great deal fresher.
                                                                                                                                                   2800 - A pile of broken glass - It looks like some broken bottles
                                                                                                                                               2801 - Mogre - An angry Ogre in a funny hat.
                                                                                                                                                   2802 - Gnome Coach - A professional gnome baller coach.
                                                                                                                                                   2803 - Lizard - Run away, it's massive!
2804 - Desert Lizard - A cold-blooded creature, partial to warmth.
2805 - Desert Lizard - A cold-blooded creature, partial to warmth.
2806 - Desert Lizard - A cold-blooded creature, partial to warmth.
2807 - Small Lizard - A small cold-blooded creature, partial to warmth.
2808 - Small Lizard - A small cold-blooded creature, partial to warmth.
2809 - Al the Camel - A camel who has the soul of a poet.
2810 - Elly the Camel - A camel whose love is unrequited.
2811 - Ollie the Camel - A camel who wants to fly some day.
2812 - Cam the Camel - A camel who likes to rest.
2813 - null - It's a null.
                                                                                                                                                   2814 - Alice the Camel - A camel who's come from the south.
2815 - Neferti the Camel - A camel who wants to see the world.
2816 - null - It's a null.
                                                                                                                                                   2817 - null - It's a null.
2818 - null - It's a null.
                                                                                                                                                   2819 - null - It's a null.
2820 - Ali the Smith - One of Ali Morrisane's associates. Has a big hammer.
                                                                                                                                                   2821 - Ali the Farmer - One of Ali Morrisane's associates. Carries a rake.
2822 - Ali the Tailor - One of Ali Morrisane's associates. Those scissors look sharp.
                                                                                                                                                   2823 - Ali the Guard - One of Ali Morrisane's associates. Looks like he's seen a lot of fighting.
                                                                                                                                                   2824 - Ellis - Manufacturer of fine leathers.
                                                                                                                                                   2825 - Pirate Pete - A shifty-looking character.
                                                                                                                                                   2826 - Pirate Pete - A shifty-looking character.
                                                                                                                                                   2827 - Captain Braindeath - A shabby-looking leader.
                                                                                                                                                   2828 - 50% Luke - Most of an angry undead sea scoundrel.
                                                                                                                                                   2829 - Davey - Looks like he's taking a break.
2830 - Captain Donnie - I wonder if it was all the 'rum' that pickled him?
2831 - Zombie Protester - Sticking it to 'The Man'.
2832 - Zombie Protester - Sticking it to 'The Man'.
2833 - Zombie Protester - Sticking it to 'The Man'.
2834 - Zombie Protester - Sticking it to 'The Man'.
2835 - Zombie Protester - Sticking it to 'The Man'.
2836 - Zombie Protester - Sticking it to 'The Man'.
2837 - Zombie Pirate - An undead sea scoundrel.
2838 - Zombie Pirate - An undead sea scoundrel.
2839 - Zombie Pirate - An undead sea scoundrel.
2840 - Zombie Pirate - An undead sea scoundrel.
2841 - Zombie Pirate - An undead sea scoundrel.
2842 - Zombie Pirate - An undead sea scoundrel.
2843 - Zombie Swab - He talks a good fight.
2844 - Zombie Swab - He talks a good fight.
2845 - Zombie Swab - He talks a good fight.
2846 - Zombie Swab - He talks a good fight.
2847 - Zombie Swab - He talks a good fight.
2848 - Zombie Swab - He talks a good fight.
2849 - Evil Spirit - The pun was intended.
2850 - Fever Spider - A bunch of legs, eyes and teeth.
2851 - Brewer - A worker in the brewery.
2852 - Brewer - A worker in the brewery.
2853 - Brewer - A worker in the brewery.
2854 - Brewer - A worker in the brewery.
2855 - Brewer - A worker in the brewery.
2856 - Brewer - A worker in the brewery.
2857 - Brewer - A worker in the brewery.
2858 - Brewer - A worker in the brewery.
2859 - Fishing spot - I can see fish swimming in the water.
2860 - Karamthulhu - It's a sinister looking squid type thing.
                                                                                                                                                   2861 - Karamthulhu - I will call him Squiddy; and he shall be my Squiddy, and he shall be mine.
                                                                                                                                                       2862 - Death - Do not fear the Reaper.
                                                                                                                                                   2863 - Zombie - A zombie. He looks pretty dead.
                                                                                                                                                   2864 - Most of a Zombie - Legs 11, good at bingo but bad at doing handstands.
                                                                                                                                                       2865 - Most of a Zombie - He seems to be a little legless.
                                                                                                                                                   2866 - Zombie - A zombie, with a bit of a bald spot.
                                                                                                                                                   2867 - Most of a Zombie - A zombie, with a major bald spot!
                                                                                                                                               2868 - Zombie Head - I bet I could grab that...
                                                                                                                                                                                           2869 - Zombie - A zombie, he could probably do with a bath.
                                                                                                                                                   2870 - Half-Zombie - Half the man he used to be.
                                                                                                                                                   2871 - Other Half-Zombie - Clearly someones better half.
                                                                                                                                                   2872 - Child - One of RuneScape's many citizens.
2873 - Child - One of RuneScape's many citizens.
                                                                                                                                                   2874 - Child - One of RuneScape's many citizens.
2875 - Child - One of RuneScape's many citizens.
                                                                                                                                                   2876 - Child - One of RuneScape's many citizens.
2877 - Child - One of RuneScape's many citizens.
                                                                                                                                                   2878 - Zombie - A zombie, he could probably do with a bath.
                                                                                                                                                   2879 - Bardur - A Fremennik warrior, hard at work.
                                                                                                                                                   2880 - Dagannoth fledgeling - A knee-high horror from the ocean depths...
                                                                                                                                                                                                                       2881 - Dagannoth Supreme - The dagannoth king responsible for the death of the Bukalla.
                                                                                                                                                   2882 - Dagannoth Prime - A legendary dagannoth king, rumoured to fly on the North winds.
                                                                                                                                                   2883 - Dagannoth Rex - Firstborn of the legendary dagannoth kings.
                                                                                                                                                   2884 - Wallasalki - A fearsome magical water creature.
                                                                                                                                                   2885 - Giant Rock Crab - No one likes crabs... especially really big ones!
                                                                                                                                               2886 - Boulder - Heavy rock!
                                                                                                                                               2887 - Dagannoth - A spiney horror from the ocean depths...
                                                                                                                                                                                                     2888 - Dagannoth - A darkened horror from the ocean depths...
                                                                                                                                                                                                                                                             2889 - Rock lobster - It wasn't a rock... it was a rock lobster!
2890 - Rock - A Rock.
2891 - Suspicious water - If I didn't know better, I'd swear there's something in there...
                                                                                                                                                   2892 - Spinolyp - A sneaky, spiny, subterranean sea-dwelling scamp.
                                                                                                                                                   2893 - Suspicious water - If I didn't know better, I'd swear there's something in there...
2894 - Spinolyp - A sneaky, spiny, subterranean sea-dwelling scamp.
2895 - Suspicious water - If I didn't know better, I'd swear there's something in there...
                                                                                                                                                   2896 - Spinolyp - A sneaky, spiny, subterranean sea-dwelling scamp.
                                                                                                                                                   2897 - null - It's a null.
2898 - null - It's a null.
                                                                                                                                                   2899 - Father Reen - Looks a bit lost.
                                                                                                                                                   2900 - Father Reen - Looks a bit lost.
                                                                                                                                                   2901 - null - It's a null.
2902 - Father Badden - He looks very pious.
2903 - Father Badden - He looks very pious.
2904 - Denath - A practicer of dark arts.
2905 - Denath - A practicer of dark arts.
2906 - Eric - He looks nervous.
2907 - Eric - He looks nervous.
2908 - null - It's a null.
                                                                                                                                                   2909 - Evil Dave - He seems to like wearing black.
                                                                                                                                                   2910 - Evil Dave - He seems to like wearing black.
                                                                                                                                                   2911 - Matthew - He looks confused.
                                                                                                                                                   2912 - Matthew - He looks confused.
                                                                                                                                                   2913 - Jennifer - She looks enigmatic.
                                                                                                                                                   2914 - Jennifer - She looks enigmatic.
                                                                                                                                                   2915 - Tanya - She looks scary.
                                                                                                                                                   2916 - Tanya - She looks scary.
                                                                                                                                                   2917 - Patrick - He looks enthusiastic.
                                                                                                                                                   2918 - Patrick - He looks enthusiastic.
                                                                                                                                                   2919 - Agrith Naar - A summoned demon.
                                                                                                                                                   2920 - null - It's a null.
2921 - Sand storm - A nasty sand storm.
2922 - null - It's a null.
                                                                                                                                                   2923 - null - It's a null.
2924 - null - It's a null.
                                                                                                                                                   2925 - null - It's a null.
2926 - null - It's a null.
                                                                                                                                                   2927 - Clay golem - An animated clay statue.
                                                                                                                                                   2928 - Clay golem - An animated clay statue.
                                                                                                                                                   2929 - null - It's a null.
2930 - null - It's a null.
                                                                                                                                                   2931 - Ghost - Eeek! A ghost!
                                                                                                                                               2932 - Jorral - A sensible looking man.
                                                                                                                                                   2933 - null - It's a null.
2934 - Melina - Sullen looking Ghost Woman.
2935 - Melina - Sullen looking Ghost Woman.
2936 - null - It's a null.
                                                                                                                                                   2937 - Droalak - Not a happy ghost.
                                                                                                                                                   2938 - Droalak - Not a happy ghost.
                                                                                                                                                   2939 - Dron - He looks scary.
                                                                                                                                                   2940 - Blanin - A docile warrior
                                                                                                                                               2941 - The Beast - Who ate all the rats?
                                                                                                                                               2942 - Bellemorde - Unkempt and a bit smelly.
                                                                                                                                                   2943 - Pox - Not the healthiest cat you've ever seen.
2944 - Pox - Busy hunting rats.
2945 - Bones - Lovely, cute, and possibly what dreams are made of.
2946 - Grimesquit - Cracking personality.
2947 - Phingspet - Lovely girl, shame about the smell.
2948 - Hooknosed Jack - Obviously punches above his weight.
2949 - Jimmy Dazzler - Looks rich like an actor of sorts.
2950 - The Face - Once beautiful, now repugnant.
2951 - Felkrash - What is she looking at?
2952 - Smokin' Joe - What is he?
                                                                                                                                               2953 - Ceril Carnillean - Head of the Carnillean household.
                                                                                                                                                   2954 - Councillor Halgrive - An official of Ardougne.
                                                                                                                                                   2955 - Spice seller - Has a very exotic aroma about him.
                                                                                                                                                   2956 - Fur trader - Knows how to keep warm in the winter.
                                                                                                                                                   2957 - Gem merchant - Seems very well off.
                                                                                                                                                   2958 - Silver merchant - Looks fairly well fed.
                                                                                                                                                   2959 - Silk merchant - Seems very well off.
                                                                                                                                                   2960 - Zenesha - Sells top quality plate mail armour.
                                                                                                                                                   2961 - Ali Morrisane - A bazaar merchant.
                                                                                                                                                   2962 - Guard - He tries to keep order around here.
                                                                                                                                                   2963 - Guard - He tries to keep order around here.
                                                                                                                                                   2964 - Guard - He tries to keep order around here.
                                                                                                                                                   2965 - Guard - He tries to keep order around here.
                                                                                                                                                   2966 - Guard - He tries to keep order around here.
                                                                                                                                                   2967 - Guard - He tries to keep order around here.
                                                                                                                                                   2968 - Guard - He tries to keep order around here.
                                                                                                                                                   2969 - Guard - He tries to keep order around here.
                                                                                                                                                   2970 - Guard - He tries to keep order around here.
                                                                                                                                                   2971 - Guard - He tries to keep order around here.
                                                                                                                                                   2972 - Guard - He tries to keep order around here.
                                                                                                                                                   2973 - Guard - He tries to keep order around here.
                                                                                                                                                   2974 - null - It's a null.
2975 - null - It's a null.
                                                                                                                                                   2976 - null - It's a null.
2977 - null - It's a null.
                                                                                                                                                   2978 - null - It's a null.
2979 - null - It's a null.
                                                                                                                                                   2980 - Rat - A popular dwarven delicacy.
                                                                                                                                                   2981 - Rat - A popular dwarven delicacy.
                                                                                                                                                   2982 - King rat - The master of all rats.
                                                                                                                                                   2983 - Turbogroomer - Poorly named for such a scraggly cat.
                                                                                                                                                   2984 - Pusskins - Not a soft touch.
                                                                                                                                                   2985 - Loki - A tricky bag of troublesome fluff.
                                                                                                                                                   2986 - Captain Tom - A not-so friendly, not-so little cat.
                                                                                                                                                   2987 - Treacle - A sticky character.
                                                                                                                                                   2988 - Mittens - A fully grown feline.
                                                                                                                                                   2989 - Claude - Great set of mits for a young one.
                                                                                                                                                   2990 - Topsy - Cute and fluffy.
                                                                                                                                                   2991 - Rauborn - Barman.
                                                                                                                                                                                       2992 - Vaeringk - Black Guard off duty, I hope.
                                                                                                                                                                                           2993 - Oxi - The rat keeper.
                                                                                                                                                                                           2994 - Fior - Happy not to be working.
                                                                                                                                                                                           2995 - Sagira - Well tanned for someone who lives under a mountain.
                                                                                                                                                                                           2996 - Anleif - Prim and proper.
                                                                                                                                                                                           2997 - Gertrude's cat - A friendly feline?
2998 - Gambler - Very well to do. I wonder what he's doing here.
                                                                                                                                                                                           2999 - Gambler - He has a tortured look in his eye.
                                                                                                                                                                                           3000 - Barman - Definitely overworked.
                                                                                                                                                                                           3001 - Gambler - Rich.
                                                                                                                                                                                       3002 - Gambler - Poor.
                                                                                                                                                                                       3003 - Gambler - Poor.
                                                                                                                                                                                       3004 - Gambler - Poor.
                                                                                                                                                                                       3005 - Gambler - Poor.
                                                                                                                                                                                       3006 - Gambler - Poor.
                                                                                                                                                                                       3007 - Rat - A popular dwarven delicacy.
                                                                                                                                                                                           3008 - Rat - A popular dwarven delicacy.
                                                                                                                                                                                           3009 - Rat - A popular dwarven delicacy.
                                                                                                                                                                                           3010 - Rat - A popular dwarven delicacy.
                                                                                                                                                                                           3011 - Rat - A popular dwarven delicacy.
                                                                                                                                                                                           3012 - Rat - A popular dwarven delicacy.
                                                                                                                                                                                           3013 - Rat - A popular dwarven delicacy.
                                                                                                                                                                                           3014 - Rat - A popular dwarven delicacy.
                                                                                                                                                                                           3015 - Rat - A popular dwarven delicacy.
                                                                                                                                                                                           3016 - Rat - A popular dwarven delicacy.
                                                                                                                                                                                           3017 - Rat - A popular dwarven delicacy.
                                                                                                                                                                                           3018 - Rat - A popular dwarven delicacy.
                                                                                                                                                                                           3019 - Fishing spot - I can see fish swimming in the water.
                                                                                                                                                                                           3020 - Rug Merchant - A carpet merchant.
                                                                                                                                                                                           3021 - Tool Leprechaun - Looks after your farming tools.
                                                                                                                                                                                           3022 - Genie - Phenomenal cosmic powers, itty-bitty living space.
                                                                                                                                                                                           3023 - Nirrie - An elemental waterspirit.
                                                                                                                                                                                           3024 - Tirrie - An elemental waterspirit.
                                                                                                                                                                                           3025 - Hallak - An elemental waterspirit.
                                                                                                                                                                                           3026 - Black golem - An animated clay statue.
                                                                                                                                                                                           3027 - White golem - An animated clay statue.
                                                                                                                                                                                           3028 - Grey golem - An animated clay statue.
                                                                                                                                                                                           3029 - Ghaslor the Elder - The oldest man in Nardah.
                                                                                                                                                                                           3030 - Ali the Carter - A water salesman from Pollnivneach.
                                                                                                                                                                                           3031 - Usi - A citizen of Nardah.
                                                                                                                                                                                           3032 - Nkuku - A citizen of Nardah.
                                                                                                                                                                                           3033 - Garai - A citizen of Nardah.
                                                                                                                                                                                           3034 - Habibah - A citizen of Nardah.
                                                                                                                                                                                           3035 - Meskhenet - A citizen of Nardah.
                                                                                                                                                                                           3036 - Zahra - A citizen of Nardah.
                                                                                                                                                                                           3037 - Zahur - A herbalist... sells herbs.
                                                                                                                                                                                           3038 - Seddu - He specialises in shield sales.
                                                                                                                                                                                           3039 - Kazemde - A seller of many things.
                                                                                                                                                                                           3040 - Awusah the Mayor - The Mayor of Nardah.
                                                                                                                                                                                           3041 - Tarik - The mayor's guard.
3042 - Poltenip - The mayor's guard.
                                                                                                                                                                                           3043 - Radat - The mayor's guard.
3044 - Shiratti the Custodian - Custodian of the shrine to Elidinis.
3045 - Rokuh - A seller of tasty choc ices.
3046 - Nardah Banker - A banker of Nardah.
3047 - Target - Needs to be shot with a bow and arrow.
3048 - Target - Needs to be shot with a bow and arrow.
3049 - null - It's a null.
                                                                                                                                                                                           3050 - Larxus - Not the smartest of butlers.
                                                                                                                                                                                           3051 - Mystery figure - A mysterious watcher...
                                                                                                                                                                                                                                    3052 - Mystery figure - A mysterious watcher...
                                                                                                                                                                                                                                                                             3053 - Mystery figure - A mysterious watcher...
                                                                                                                                                                                                                                                                                                                      3054 - Mystery figure - A mysterious watcher...
                                                                                                                                                                                                                                                                                                                                                               3055 - Mystery figure - A mysterious watcher...
                                                                                                                                                                                                                                                                                                                                                                                                        3056 - Mystery figure - A mysterious watcher...
                                                                                                                                                                                                                                                                                                                                                                                                                                                 3057 - Earth Warrior Champion - Champion of the Earth Warriors!
                                                                                                                                                                                       3058 - Giant Champion - Champion of the Giants!
                                                                                                                                                                                       3059 - Ghoul Champion - Champion of the Ghouls!
                                                                                                                                                                                       3060 - Goblin Champion - Champion of the Goblins!
                                                                                                                                                                                       3061 - Hobgoblin Champion - Champion of the Hobgoblin!
                                                                                                                                                                                       3062 - Imp Champion - Champion of the Imps!
                                                                                                                                                                                       3063 - Jogre Champion - Champion of the Jogres!
                                                                                                                                                                                       3064 - Lesser Demon Champion - Champion of the Lesser Demons!
                                                                                                                                                                                       3065 - Skeleton Champion - Champion of the Skeletons!
                                                                                                                                                                                       3066 - Zombies Champion - Champion of the Zombies!
                                                                                                                                                                                       3067 - Leon D'Cour - Champion of Champions!
3068 - Skeletal Wyvern - A very dangerous pile of animated wyvern bones.
3069 - Skeletal Wyvern - A very dangerous pile of animated wyvern bones.
3070 - Skeletal Wyvern - A very dangerous pile of animated wyvern bones.
3071 - Skeletal Wyvern - A very dangerous pile of animated wyvern bones.
3072 - Ice giant - He's got icicles in his beard.
                                                                                                                                                                                           3073 - Ice warrior - A cold-hearted elemental warrior.
                                                                                                                                                                                           3074 - null - It's a null.
3075 - Monk - A hooded monk.
3076 - null - It's a null.
                                                                                                                                                                                           3077 - Dead Monk - A recently deceased follower of Saradomin.
                                                                                                                                                                                           3078 - High Priest - High Priest of Entrana.
                                                                                                                                                                                           3079 - Monk - A holy man.
                                                                                                                                                                                           3080 - Monk - A holy man.
                                                                                                                                                                                           3081 - Assassin - A stealthy assassin.
                                                                                                                                                                                           3082 - Rosie - An effervescent elfin.
                                                                                                                                                                                           3083 - Sorcha - Seriously sprightly even for a sprite.
                                                                                                                                                                                           3084 - Cait - A frenzied fey.
                                                                                                                                                                                           3085 - Cormac - Too volatile for his own good.
                                                                                                                                                                                           3086 - Fionn - One of Diango's itinerant pixies.
3087 - Donnacha - One of Diango's itinerant pixies.
                                                                                                                                                                                           3088 - Ronan - One of Diango's itinerant pixies.
3089 - - -
3090 - - -
3091 - - -
3092 - Hooded Stranger - A strange hooded... stranger?
3093 - null - It's a null.
                                                                                                                                                                                           3094 - Flying Book - The book moves by itself!
                                                                                                                                                                                       3095 - Flying Book - The book moves by itself!
                                                                                                                                                                                       3096 - Pizzaz Hat - A talking Hat!
                                                                                                                                                                                       3097 - Entrance Guardian - A guardian of the arena.
                                                                                                                                                                                           3098 - Telekinetic Guardian - A guardian of the arena.
                                                                                                                                                                                           3099 - Alchemy Guardian - A guardian of the arena.
                                                                                                                                                                                           3100 - Enchantment Guardian - A guardian of the arena.
                                                                                                                                                                                           3101 - Graveyard Guardian - A guardian of the arena.
                                                                                                                                                                                           3102 - Maze Guardian - A guardian of the arena.
                                                                                                                                                                                           3103 - Rewards Guardian - A guardian of the arena.
                                                                                                                                                                                           3104 - Charmed Warrior - Equipment that moves by itself!
                                                                                                                                                                                       3105 - Charmed Warrior - Equipment that moves by itself!
                                                                                                                                                                                       3106 - Charmed Warrior - Equipment that moves by itself!
                                                                                                                                                                                       3107 - Charmed Warrior - Equipment that moves by itself!
                                                                                                                                                                                       3108 - Bert - Bert seems to be covered in sand from head to toe.
                                                                                                                                                                                           3109 - Guard Captain - This guard looks rather drunk and has beer stains down his armour.
                                                                                                                                                                                           3110 - null - It's a null.
3111 - null - It's a null.
                                                                                                                                                                                           3112 - Sandy - Angry and stressed, he doesn't seem to have time for anything other than sand.
3113 - Sandy - He seems to be distracted, looking out of the window at something.
3114 - Mazion - Mazion seems to be covered in sand.
3115 - Blaec - Blaec seems to be covered in sand.
3116 - Reeso - Reeso seems to be covered in sand.
3117 - Sandwich lady - The sandwich lady.
3118 - Prison Pete - He wants to escape!
3119 - Balloon Animal - It looks like an animal.
3120 - Balloon Animal - It looks like an animal.
3121 - Balloon Animal - It looks like an animal.
3122 - Balloon Animal - It looks like an animal.
3123 - Simon Templeton - He looks like he's seen the inside of a few tombs.
                                                                                                                                                                                           3124 - Pyramid block - A pyramid block.
                                                                                                                                                                                           3125 - Pyramid block - A pyramid block.
                                                                                                                                                                                           3126 - Pentyn - He's been trapped here for thousands of years.
3127 - Aristarchus - A travelling scholar from Menaphos.
3128 - null - It's a null.
                                                                                                                                                                                           3129 - Boneguard - A spirit is trapped within it.
                                                                                                                                                                                           3130 - Pile of bones - These used to be alive.
                                                                                                                                                                                           3131 - Desert Spirit - It was trapped inside the boneguard.
                                                                                                                                                                                           3132 - null - It's a null.
3133 - Crust of ice - Very thick, and very cold.
3134 - null - It's a null.
                                                                                                                                                                                           3135 - Furnace grate - It seems to be blocked.
                                                                                                                                                                                           3136 - null - It's a null.
3137 - Enakhra - A mysterious hooded woman.
3138 - Enakhra - Who
3139 - null - It's a null.
                                                                                                                                                                                           3140 - Boneguard - A spirit is trapped within it.
                                                                                                                                                                                           3141 - Akthanakos - He's been freed from the boneguard.
3142 - Akthanakos - Just who is he, anyway?
3143 - null - It's a null.
                                                                                                                                                                                           3144 - null - It's a null.
3145 - null - It's a null.
                                                                                                                                                                                           3146 - null - It's a null.
3147 - Lazim - Very shifty-looking and sunburnt.
3148 - Enakhra - A mysterious hooded woman.
3149 - Akthanakos - A man with the head of a camel.
3150 - Knight - He's wearing heavy armour.
                                                                                                                                                                                           3151 - Skeleton - Could do with gaining a few pounds.
                                                                                                                                                                                           3152 - null - It's a null.
3153 - Harpie Bug Swarm - A swarm of bugs.
3154 - Count Draynor - Stop looking and run!
3155 - Bill Teach - Bill Teach the pirate.
3156 - Bill Teach - Bill Teach the pirate.
3157 - Bill Teach - Bill Teach the pirate.
3158 - Bill Teach - Bill Teach the pirate.
3159 - Bill Teach - Bill Teach the pirate.
3160 - Bill Teach - Bill Teach the pirate.
3161 - Charley - Two feet Charley.
3162 - Smith - Smithing Smith.
3163 - Joe - Harpoon Joe.
3164 - Mama - Mama La'Fiette.
                                                                                                                                                                                           3165 - Mama - Mama La'Fiette.
3166 - Mike - Dodgy Mike.
3167 - Pirate - A pirate of Mos Le'Harmless.
                                                                                                                                                                                           3168 - Pirate - A pirate of Mos Le'Harmless.
3169 - Pirate - A pirate of Mos Le'Harmless.
                                                                                                                                                                                           3170 - Pirate - A pirate of Mos Le'Harmless.
3171 - Pirate - A pirate of Mos Le'Harmless.
                                                                                                                                                                                           3172 - Pirate - A pirate of Mos Le'Harmless.
3173 - Pirate - A pirate of Mos Le'Harmless.
                                                                                                                                                                                           3174 - Pirate - A pirate of Mos Le'Harmless.
3175 - Pirate - A pirate of Mos Le'Harmless.
                                                                                                                                                                                           3176 - Pirate - A pirate of Mos Le'Harmless.
3177 - Pirate - A pirate of Mos Le'Harmless.
                                                                                                                                                                                           3178 - Pirate - A pirate of Mos Le'Harmless.
3179 - Pirate - A pirate of Mos Le'Harmless.
                                                                                                                                                                                           3180 - Pirate - A pirate of Mos Le'Harmless.
3181 - Pirate - A pirate of Mos Le'Harmless.
                                                                                                                                                                                           3182 - Pirate - A pirate of Mos Le'Harmless.
3183 - Pirate - A pirate of Mos Le'Harmless.
                                                                                                                                                                                           3184 - Pirate - A pirate of Mos Le'Harmless.
3185 - Pirate - A pirate of Mos Le'Harmless.
                                                                                                                                                                                           3186 - Pirate - A pirate of Mos Le'Harmless.
3187 - Pirate - An enemy pirate.
3188 - Pirate - An enemy pirate.
3189 - Pirate - An enemy pirate.
3190 - Pirate - An enemy pirate.
3191 - Pirate - An enemy pirate.
3192 - Pirate - An enemy pirate.
3193 - Pirate - An enemy pirate.
3194 - Pirate - An enemy pirate.
3195 - Pirate - An enemy pirate.
3196 - Pirate - An enemy pirate.
3197 - Gull - A sea bird.
3198 - Banker - He can look after my money.
3199 - Banker - He can look after my money.
3200 - Chaos Elemental - pUre A cHaOs of crEatuRe!
3201 - Killerwatt - An angry electrical shock!
3202 - Killerwatt - A ball of electrical energy.
3203 - Storm Cloud - A very small storm!
3204 - Storm Cloud - A very small storm!
3205 - Romily Weaklax - A family baker, from the North.
3206 - Priest - A priest.
3207 - Pious Pete - Ready for a theological party!
3208 - Taper - Useful for lighting things.
3209 - Elena - She looks concerned.
3210 - Alrena - She looks concerned.
3211 - Alrena - She looks concerned.
3212 - Bravek - The city warder of West Ardougne.
3213 - null - It's a null.
                                                                                                                                                                                           3214 - null - It's a null.
3215 - Elena - She doesn't look too happy.
                                                                                                                                                                                           3216 - Mourner - A mourner, or plague healer.
                                                                                                                                                                                           3217 - Kaylee - Works in the Rising Sun.
                                                                                                                                                                                           3218 - Tina - Works in the Rising Sun.
                                                                                                                                                                                           3219 - Dwarf - Loves mining.
                                                                                                                                                                                           3220 - Dwarf - Loves mining.
                                                                                                                                                                                           3221 - Dwarf - Loves mining.
                                                                                                                                                                                           3222 - Drunken man - One of RuneScape's many citizens, currently incapacitated by alcohol.
3223 - Man - One of RuneScape's many citizens.
                                                                                                                                                                                           3224 - Man - One of RuneScape's many citizens.
3225 - Man - One of RuneScape's many citizens. He looks worried about something.
                                                                                                                                                                                           3226 - Woman - One of RuneScape's many citizens.
3227 - Woman - One of RuneScape's many citizens. She looks rich.
                                                                                                                                                                                           3228 - Guard - He tries to keep order around here.
                                                                                                                                                                                           3229 - Guard - He tries to keep order around here.
                                                                                                                                                                                           3230 - Guard - He tries to keep order around here.
                                                                                                                                                                                           3231 - Guard - He tries to keep order around here.
                                                                                                                                                                                           3232 - Guard - Keeping an eye out for threats to the city.
                                                                                                                                                                                           3233 - Guard - Keeping an eye out for threats to the city.
                                                                                                                                                                                           3234 - Gardener - An old gardener.
                                                                                                                                                                                           3235 - Apprentice workman - He's learning a trade.
3236 - Workman - A busy workman
3237 - 'Cuffs' - He looks a bit dodgy.
3238 - Narf - Looks unpleasant.
3239 - Rusty - Seems to be loitering.
3240 - Jeff - Untrustworthy.
3241 - Guard - He's keeping an eye out.
                                                                                                                                                                                           3242 - Dark wizard - A practicer of dark arts.
                                                                                                                                                                                           3243 - Dark wizard - A practicer of dark arts.
                                                                                                                                                                                           3244 - Dark wizard - A practicer of dark arts.
                                                                                                                                                                                           3245 - Dark wizard - A practicer of dark arts.
                                                                                                                                                                                           3246 - Barbarian - Alberich, a fierce barbarian warrior.
                                                                                                                                                                                           3247 - Barbarian - Fafner, a tough barbarian warrior.
                                                                                                                                                                                           3248 - Barbarian - Fasolt, a strong barbarian warrior.
                                                                                                                                                                                           3249 - Barbarian - Siegmund, a guard in the Barbarian Village.
                                                                                                                                                                                           3250 - Barbarian - Siegfried, a young guard in the Barbarian Village.
                                                                                                                                                                                           3251 - Barbarian - Lydspor, a well-travelled barbarian warrior.
                                                                                                                                                                                           3252 - Barbarian - Hagen, a guard in the Barbarian Village.
                                                                                                                                                                                           3253 - Barbarian - Minarch, a barbarian who likes his beer.
                                                                                                                                                                                           3254 - Hunding - Likes a good fight.
                                                                                                                                                                                           3255 - Barbarian - Wotan, a sturdy barbarian warrior.
                                                                                                                                                                                           3256 - Barbarian - Acelin, a guard in the Barbarian Village.
                                                                                                                                                                                           3257 - Barbarian - Adelino, a barbarian warrior with a big axe.
                                                                                                                                                                                           3258 - Barbarian - Adolpho, a barbarian warrior with a warhammer.
                                                                                                                                                                                           3259 - Barbarian - Aitan, a barbarian archer.
                                                                                                                                                                                           3260 - Barbarian - Brunnhilde, a fierce barbarian warrior.
                                                                                                                                                                                           3261 - Barbarian - Gutrune, a mighty barbarian warrior.
                                                                                                                                                                                           3262 - Barbarian - Edelschwarz, a barbarian warrior with a spear.
                                                                                                                                                                                           3263 - Barbarian - Sieglinde, a muscular barbarian warrior.
                                                                                                                                                                                           3264 - Goblin - An ugly green creature.
                                                                                                                                                                                           3265 - Goblin - An ugly green creature.
                                                                                                                                                                                           3266 - Goblin - An ugly green creature.
                                                                                                                                                                                           3267 - Goblin - An ugly green creature.
                                                                                                                                                                                           3268 - Dwarf - A dwarven worker.
                                                                                                                                                                                           3269 - Dwarf - A dwarven worker.
                                                                                                                                                                                           3270 - Dwarf - A dwarven worker.
                                                                                                                                                                                           3271 - Dwarf - A dwarven worker.
                                                                                                                                                                                           3272 - Dwarf - A dwarven worker.
                                                                                                                                                                                           3273 - Dwarf - A dwarven worker.
                                                                                                                                                                                           3274 - Dwarf - A dwarven worker.
                                                                                                                                                                                           3275 - Dwarf - A dwarven worker.
                                                                                                                                                                                           3276 - Black Guard - A member of the Black Guard, a special division of the dwarven army.
                                                                                                                                                                                           3277 - Black Guard - A member of the Black Guard, a special division of the dwarven army.
                                                                                                                                                                                           3278 - Black Guard - A member of the Black Guard, a special division of the dwarven army.
                                                                                                                                                                                           3279 - Black Guard - A member of the Black Guard, a special division of the dwarven army.
                                                                                                                                                                                           3280 - Engineering assistant - He looks busy.
                                                                                                                                                                                           3281 - Engineering assistant - He's wandering around aimlesly with a box of spare parts.
3282 - Engineer - He's building a cannon.
                                                                                                                                                                                           3283 - Squirrel - Bushy tail!
                                                                                                                                                                                       3284 - Squirrel - Likes nuts.
                                                                                                                                                                                           3285 - Squirrel - Shave the tail, and you've got a rat.
3286 - Raccoon - A raccoon.
3287 - Raccoon - A raccoon.
3288 - Raccoon - A raccoon.
3289 - null - It's a null.
                                                                                                                                                                                           3290 - null - It's a null.
3291 - Skeleton - Could do with gaining a few pounds.
3292 - Witch - The hat's a dead give away.
                                                                                                                                                                                           3293 - null - It's a null.
3294 - Dwarf - A dwarf who looks after the mining guild.
3295 - Dwarf - A dwarf who looks after the mining guild.
3296 - Swan - A graceful bird.
3297 - Black swan - A rare bird.
3298 - Sweeper - Keeps this magic area tidy.
3299 - Martin the Master Gardener - A master at gardening.
3300 - Frog - A magical frog.
3301 - Storm Cloud - A very small storm!
3302 - Co-ordinator - Manages the Fey.
3303 - Fairy Nuff - A healing fairy.
3304 - Fairy Godfather - I'm gonna make him an offer he can't refuse.
3305 - Slim Louie - How am I funny, like a clown?
3306 - Fat Rocco - As far back as I can remember, I always wanted to be a gangster.
3307 - Gate Keeper - Guardian of the market gate.
3308 - Zandar Horfyre - A practicer of dark arts.
3309 - Cow - Converts grass to beef.
3310 - Sheep - White and fluffy.
3311 - Sheep - Freshly sheared.
3312 - Zanaris Choir - They're going to sing to you!
                                                                                                                                                                                       3313 - Tanglefoot - A walking thorn bush!
                                                                                                                                                                                       3314 - null - It's a null.
3315 - null - It's a null.
                                                                                                                                                                                           3316 - null - It's a null.
3317 - null - It's a null.
                                                                                                                                                                                           3318 - null - It's a null.
3319 - Baby Tanglefoot - An animated shrub
3320 - Baby Tanglefoot - An aggressive bush.
3321 - Gate Keeper - Guardian of the market gate.
3322 - Fairy Chef - Likes to cook with Mushrooms!
3323 - null - It's a null.
                                                                                                                                                                                           3324 - Draul Leptoc - This looks like an angry, aggressive man.
                                                                                                                                                                                           3325 - Phillipa - A quiet, more reserved sort of lady.
                                                                                                                                                                                           3326 - Martina Scorsby - A less enthusiastic ecclesiastic woman, she seems slightly tired.
                                                                                                                                                                                           3327 - Jeremy Clerksin - Rather more tired than most.
                                                                                                                                                                                           3328 - Tarquin - A dandy canoe man.
                                                                                                                                                                                           3329 - Sigurd - His furs look very damp.
                                                                                                                                                                                           3330 - Hari - Strange looking fella.
                                                                                                                                                                                           3331 - Barfy Bill - Looks a little green around the gills.
                                                                                                                                                                                           3332 - Trees - Trees and such.
                                                                                                                                                                                           3333 - Trees - Trees and such.
                                                                                                                                                                                           3334 - Cavemouth - A cave entrance.
                                                                                                                                                                                           3335 - Bullrush - A Bullrush.
                                                                                                                                                                                           3336 - Bullrush - A Bullrush.
                                                                                                                                                                                           3337 - Cave Scenery - Cave bits.
                                                                                                                                                                                           3338 - Cave Scenery - Cave bits.
                                                                                                                                                                                           3339 - Cave Scenery - Cave bits.
                                                                                                                                                                                           3340 - Giant Mole - Holy Mole-y!
                                                                                                                                                                                       3341 - Baby Mole - I will call him, Mini Mole.
                                                                                                                                                                                           3342 - Baby Mole - Mooooooooooooole.
                                                                                                                                                                                       3343 - Baby Mole - Moley, moley, moley!
                                                                                                                                                                                       3344 - Fungi - A fun guy. No wait, that's awful. Plus it doesn't even make sense.
                                                                                                                                                                                           3345 - Fungi - A fun guy. No wait, that's awful. Plus it doesn't even make sense.
                                                                                                                                                                                           3346 - Zygomite - A bouncy fungus.
                                                                                                                                                                                           3347 - Zygomite - A fun guy. No wait, that's awful..
3348 - White Knight - A White Knight proselyte.
3349 - White Knight - A White Knight acolyte.
3350 - White Knight - A White Knight partisan.
3351 - Genie - Maybe he'll grant me a wish...
                                                                                                                                                                                                                                                                                3352 - Mysterious Old Man - A very strange old man...
                                                                                                                                                                                                                                                                                                                                   3353 - Swarm - A swarm of vicious plankton!
                                                                                                                                                                                       3354 - Cap'n Hand - Swashbuckles his way across the seven seas.
3355 - Rick Turpentine - A Masked Highwayman.
3356 - Niles - The brother of Miles and Giles.
3357 - Miles - The brother of Niles and Giles.
3358 - Giles - The brother of Niles and Miles.
3359 - Dr Jekyll - He looks troubled...
3360 - Mr Hyde - This is not a good time to be examining him!
3361 - Mr Hyde - This is not a good time to be examining him!
3362 - Mr Hyde - This is not a good time to be examining him!
3363 - Mr Hyde - This is not a good time to be examining him!
3364 - Mr Hyde - This is not a good time to be examining him!
3365 - Mr Hyde - This is not a good time to be examining him!
3366 - Evil Chicken - A fowl beast.
3367 - Evil Chicken - A fowl beast.
3368 - Evil Chicken - A fowl beast.
3369 - Evil Chicken - A fowl beast.
3370 - Evil Chicken - A fowl beast.
3371 - Evil Chicken - A fowl beast.
3372 - Sir Amik Varze - Leader of the White Knights.
3373 - null - It's a null.
                                                                                                                                                                                           3374 - Sir Amik Varze - Leader of the White Knights.
                                                                                                                                                                                           3375 - Evil Chicken - A fowl beast.
                                                                                                                                                                                           3376 - Baby black dragon - Young but still dangerous.
                                                                                                                                                                                           3377 - K'klik - Could this be one of the Elder dragons?
3378 - Evil Dave - He seems to like wearing black.
3379 - null - It's a null.
                                                                                                                                                                                           3380 - Evil Dave - He seems to like wearing black.
                                                                                                                                                                                           3381 - Doris - One of RuneScape's many citizens.
3382 - Hell-Rat - Vermin from the underworld.
3383 - null - It's a null.
                                                                                                                                                                                           3384 - null - It's a null.
3385 - Gypsy - An old gypsy lady.
3386 - Gypsy - An old gypsy lady.
3387 - Culinaromancer - A demented evil wizard who specialises in food spells.
3388 - Osman - He looks a little shifty.
3389 - Pirate Pete - A shifty-looking character.
3390 - Mountain Dwarf - He looks short and grumpy.
3391 - General Wartface - An ugly green creature.
3392 - General Bentnoze - An ugly green creature.
3393 - Lumbridge Guide - He provides new players with useful information.
3394 - Evil Dave - He seems to like wearing black.
3395 - Sir Amik Varze - Leader of the White Knights.
3396 - Awowogei - A rather dapper little monkey.
3397 - Awowogei - A rather dapper little monkey.
3398 - Skrach Uglogwee - An ogre.
3399 - null - It's a null.
                                                                                                                                                                                           3400 - Culinaromancer - A demented evil wizard who specialises in food spells.
                                                                                                                                                                                           3401 - null - It's a null.
3402 - An old Dwarf - A dwarven father figure!
3403 - Rohak - A dwarven father figure!
3404 - null - It's a null.
                                                                                                                                                                                           3405 - Rohak - A dwarven father figure!
                                                                                                                                                                                       3406 - Icefiend - A small ice demon.
                                                                                                                                                                                           3407 - General Wartface - An ugly green creature.
                                                                                                                                                                                           3408 - General Bentnoze - An ugly green creature.
                                                                                                                                                                                           3409 - null - It's a null.
3410 - General Wartface - An ugly green creature.
3411 - null - It's a null.
                                                                                                                                                                                           3412 - General Bentnoze - An ugly green creature.
                                                                                                                                                                                           3413 - Goblin Cook - He's got funky socks, but he's still an ugly green creature.
                                                                                                                                                                                           3414 - Goblin Cook - More like a goblin cooked.
                                                                                                                                                                                           3415 - Goblin Cook - Half way up the wall is maybe not a naturally tenable position for a goblin.
                                                                                                                                                                                           3416 - Pirate Pete - He looks a little piratey.
                                                                                                                                                                                           3417 - null - It's a null.
3418 - Pirate Pete - He looks a little piratey.
3419 - Mogre Guard - An angry Ogre in a highly amusing hat.
3420 - Nung - A fat, angry Ogre in a highly amusing hat.
3421 - Crab - Nice claw!
3422 - Mudskipper - Not the most beautiful fish in the sea.
3423 - Mudskipper - Not the most beautiful fish in the sea.
3424 - Crab - Nice claw!
3425 - Fish - A Red Fantail.
3426 - Fish - A Red Fantail.
3427 - Fish - A Red Fantail.
3428 - Fish - A Black Moor Fantail.
3429 - Fish - A Black Moor Fantail.
3430 - Fish - A Black Moor Fantail.
3431 - Fish - An Angel Fish.
3432 - Fish - An Angel Fish.
3433 - Fish - An Angel Fish.
3434 - Fish - A Harlequin Fish.
3435 - Fish - A Harlequin Fish.
3436 - Fish - A Harlequin Fish.
3437 - Fish - A Discus Fish.
3438 - Fish - A Discus Fish.
3439 - Fish - A Discus Fish.
3440 - Fish - A Paradise Fish.
3441 - Fish - A Paradise Fish.
3442 - Fish - A Paradise Fish.
3443 - Fish - A shoal of Neon Tetra.
3444 - Fish - A shoal of Neon Tetra.
3445 - Fish - A shoal of Neon Tetra.
3446 - Fish - A shoal of Pearl Danio.
3447 - Fish - A shoal of Pearl Danio.
3448 - Fish - A shoal of Pearl Danio.
3449 - Lumbridge Guide - He provides new players with useful information.
3450 - null - It's a null.
                                                                                                                                                                                           3451 - Lumbridge Guide - He provides new players with useful information.
                                                                                                                                                                                           3452 - ? ? ? ? - Who could this be?
                                                                                                                                                                                       3453 - ? ? ? ? - Who could this be?
                                                                                                                                                                                       3454 - ? ? ? ? - Who could this be?
                                                                                                                                                                                       3455 - ? ? ? ? - Who could this be?
                                                                                                                                                                                       3456 - ? ? ? ? - Who could this be?
                                                                                                                                                                                       3457 - ? ? ? ? - Who could this be?
                                                                                                                                                                                       3458 - ? ? ? ? - Who could this be?
                                                                                                                                                                                       3459 - ? ? ? ? - Who could this be?
                                                                                                                                                                                       3460 - ? ? ? ? - Who could this be?
                                                                                                                                                                                       3461 - ? ? ? ? - Who could this be?
                                                                                                                                                                                       3462 - null - It's a null.
3463 - Skrach Uglogwee - An important looking ogre, he hits the table a lot.
3464 - Skrach Uglogwee - An important looking ogre.
3465 - null - It's a null.
                                                                                                                                                                                           3466 - Rantz - A large dim looking humanoid.
                                                                                                                                                                                           3467 - Rantz - A large dim looking humanoid.
                                                                                                                                                                                           3468 - Rantz - A large dim looking humanoid.
                                                                                                                                                                                           3469 - null - It's a null.
3470 - null - It's a null.
                                                                                                                                                                                           3471 - Ogre boat - Rantz's boat, operated by his kids Fycie and Bugs.
3472 - Ogre boat - Rantz's boat, operated by his kids Fycie and Bugs.
                                                                                                                                                                                           3473 - Balloon Toad - A toad inflated with swamp gas and tied up like a balloon.
                                                                                                                                                                                           3474 - Balloon Toad - A toad inflated with swamp gas and tied up like a balloon.
                                                                                                                                                                                           3475 - Balloon Toad - A quickly deflating balloon toad.
                                                                                                                                                                                           3476 - Jubbly bird - A large boisterous bird, a delicacy for ogres.
                                                                                                                                                                                                                                                    3477 - Jubbly bird - A large boisterous bird, a delicacy for ogres.
                                                                                                                                                                                                                                                                                                             3478 - King Awowogei - A rather dapper little monkey.
                                                                                                                                                                                               3479 - null - It's a null.
3480 - King Awowogei - He's looking a bit static.
                                                                                                                                                                                               3481 - Mizaru - He sees no evil.
                                                                                                                                                                                               3482 - Kikazaru - He hears no evil.
                                                                                                                                                                                               3483 - Iwazaru - He speaks no evil.
                                                                                                                                                                                               3484 - Big Snake - A big snake.
                                                                                                                                                                                               3485 - Culinaromancer - A demented evil wizard who specialises in food spells.
                                                                                                                                                                                               3486 - Culinaromancer - A demented evil wizard who specialises in food spells.
                                                                                                                                                                                               3487 - Culinaromancer - A demented evil wizard who specialises in food spells.
                                                                                                                                                                                               3488 - Culinaromancer - A demented evil wizard who specialises in food spells.
                                                                                                                                                                                               3489 - Culinaromancer - A demented evil wizard who specialises in food spells.
                                                                                                                                                                                               3490 - Culinaromancer - A demented evil wizard who specialises in food spells.
                                                                                                                                                                                               3491 - Culinaromancer - A demented evil wizard who specialises in food spells.
                                                                                                                                                                                               3492 - Culinaromancer - A demented evil wizard who specialises in food spells.
                                                                                                                                                                                               3493 - Agrith-Na-Na - Big, scary, angry and a good source of energy.
                                                                                                                                                                                               3494 - Flambeed - Will give you a beating as well as indigestion.
                                                                                                                                                                                               3495 - Karamel - Pure evil lightly whipped with a juicy cherry on top.
                                                                                                                                                                                               3496 - Dessourt - Bad for your teeth...and the rest of your body too.
                                                                                                                                                                                               3497 - Gelatinnoth Mother - Deadly AND fruity!
                                                                                                                                                                                           3498 - Gelatinnoth Mother - Deadly AND fruity!
                                                                                                                                                                                           3499 - Gelatinnoth Mother - Deadly AND fruity!
                                                                                                                                                                                           3500 - Gelatinnoth Mother - Deadly AND fruity!
                                                                                                                                                                                           3501 - Gelatinnoth Mother - Deadly AND fruity!
                                                                                                                                                                                           3502 - Gelatinnoth Mother - Deadly AND fruity!
                                                                                                                                                                                           3503 - Overgrown hellcat - A hellish not-so little pet.
                                                                                                                                                                                               3504 - Hellcat - A hellish pet cat!
                                                                                                                                                                                           3505 - Kitten - A hellish little pet.
                                                                                                                                                                                               3506 - Lazy HellCat - A hellish not-so-little pet.
                                                                                                                                                                                               3507 - Wily hellcat - Wild and hellish.
                                                                                                                                                                                               3508 - Leo - A lazy undertaker.
                                                                                                                                                                                               3509 - Sorin - A flea infested, pale looking excuse of a man.
                                                                                                                                                                                               3510 - null - It's a null.
3511 - Wiskit - A flea infested, pale looking excuse of a man.
3512 - null - It's a null.
                                                                                                                                                                                               3513 - null - It's a null.
3514 - Vampyre Juvinate - An initiate juvenile vampire.
3515 - Vampyre Juvinate - An initiate juvenile vampire.
3516 - null - It's a null.
                                                                                                                                                                                               3517 - Gadderanks - A human suppporter of the Vampyric overlords.
                                                                                                                                                                                               3518 - Gadderanks - A human suppporter of the Vampyric overlords.
                                                                                                                                                                                               3519 - Gadderanks - A human suppporter of the Vampyric overlords.
                                                                                                                                                                                               3520 - Vampyre Juvinate - An initiate juvenile vampire.
                                                                                                                                                                                               3521 - Vampyre Juvinate - An initiate juvenile vampire.
                                                                                                                                                                                               3522 - Vampyre Juvinate - An initiate juvenile vampyre.
                                                                                                                                                                                               3523 - Vampyre Juvinate - An initiate juvenile vampyre.
                                                                                                                                                                                               3524 - Vampyre Juvinate - An initiate juvenile vampyre.
                                                                                                                                                                                               3525 - Vampyre Juvinate - An initiate juvenile vampyre.
                                                                                                                                                                                               3526 - Vampyre Juvinate - An initiate juvenile vampyre, he looks really angry.
                                                                                                                                                                                               3527 - Held Vampyre Juvinate - A Juvinate vampyre, held in a powerful spell.
                                                                                                                                                                                               3528 - Vampyre Juvinate - An initiate juvenile vampyre.
                                                                                                                                                                                               3529 - Vampyre Juvinate - An initiate juvenile vampyre.
                                                                                                                                                                                               3530 - Mist - A billowing cloud of fine mist...it looks creepy.
                                                                                                                                                                                               3531 - Vampyre Juvenile - He looks really hungry!
                                                                                                                                                                                           3532 - Vampyre Juvenile - He looks really hungry!
                                                                                                                                                                                           3533 - Vampyre Juvenile - He looks really hungry!
                                                                                                                                                                                           3534 - Vampyre Juvenile - He looks really hungry!
                                                                                                                                                                                           3535 - Ivan Strom - A member of the Myreque and an aspiring young priest.
                                                                                                                                                                                               3536 - Ivan Strom - A member of the Myreque and an aspiring young priest.
                                                                                                                                                                                               3537 - Vampyre Juvinate - An initiate juvenile vampire.
                                                                                                                                                                                               3538 - Vampyre Juvinate - An initiate juvenile vampire.
                                                                                                                                                                                               3539 - Veliaf Hurtz - Looks like the leader of the Myreque.
                                                                                                                                                                                               3540 - Elisabeta - The leader of Burgh de Rott.
                                                                                                                                                                                               3541 - Aurel - A flea infested, pale looking excuse of a man.
                                                                                                                                                                                               3542 - Sorin - A flea infested, pale looking excuse of a man.
                                                                                                                                                                                               3543 - Luscion - A citizen of Burgh de Rott.
                                                                                                                                                                                               3544 - Sergiu - A citizen of Burgh de Rott.
                                                                                                                                                                                               3545 - Radu - A citizen of Burgh de Rott.
                                                                                                                                                                                               3546 - Grigore - A citizen of Burgh de Rott.
                                                                                                                                                                                               3547 - Ileana - A citizen of Burgh de Rott.
                                                                                                                                                                                               3548 - Valeria - A citizen of Burgh de Rott.
                                                                                                                                                                                               3549 - Emilia - A citizen of Burgh de Rott.
                                                                                                                                                                                               3550 - Florin - A citizen of Burgh de Rott.
                                                                                                                                                                                               3551 - Catalina - Its a village kid.
                                                                                                                                                                                               3552 - Ivan - Its a village kid.
                                                                                                                                                                                               3553 - Victor - Its a village kid.
                                                                                                                                                                                               3554 - Helena - Its a village kid.
                                                                                                                                                                                               3555 - Teodor - He tries to grow the crops in this area.
                                                                                                                                                                                               3556 - Marius - A bed ridden man.
                                                                                                                                                                                               3557 - Gabriela - A citizen of Burgh de Rott.
                                                                                                                                                                                               3558 - Vladimir - An empty villager.
                                                                                                                                                                                               3559 - Calin - A citizen of Burgh de Rott.
                                                                                                                                                                                               3560 - Mihail - A citizen of Burgh de Rott.
                                                                                                                                                                                               3561 - Nicoleta - A citizen of Burgh de Rott.
                                                                                                                                                                                               3562 - Simona - A citizen of Burgh de Rott.
                                                                                                                                                                                               3563 - Vasile - A citizen of Burgh de Rott.
                                                                                                                                                                                               3564 - Razvan - A citizen of Burgh de Rott.
                                                                                                                                                                                               3565 - Luminata - A citizen of Burgh de Rott.
                                                                                                                                                                                               3566 - null - It's a null.
3567 - null - It's a null.
                                                                                                                                                                                               3568 - Cornelius - A citizen of Burgh de Rott.
                                                                                                                                                                                               3569 - Cornelius - The sole banker of Burgh de Rott.
                                                                                                                                                                                               3570 - Benjamin - A human returned from vampyric form.
                                                                                                                                                                                               3571 - Liam - A human returned from vampyric form.
                                                                                                                                                                                               3572 - Miala - A human returned from vampyric form.
                                                                                                                                                                                               3573 - Verak - A human returned from vampyric form.
                                                                                                                                                                                               3574 - Fishing spot - I can see fish swimming in the water.
                                                                                                                                                                                               3575 - Fishing spot - I can see fish swimming in the water.
                                                                                                                                                                                               3576 - Juvinate - It looks really hungry!
                                                                                                                                                                                           3577 - Juvinate - It looks really hungry!
                                                                                                                                                                                           3578 - Juvinate - It looks really hungry!
                                                                                                                                                                                           3579 - Sheep - A Sheep?
                                                                                                                                                                                           3580 - Tentacle - I'm glad I can't see the rest of it!
                                                                                                                                                                                           3581 - Skeleton - He guards the dungeon with the faithfulness of the undead.
                                                                                                                                                                                               3582 - Guard dog - Beware of the dog!
                                                                                                                                                                                           3583 - Hobgoblin - He doesn't look very welcoming.
3584 - Troll - A pet Troll!
3585 - Huge Spider - No spider could get that big! It's unrealistic!
                                                                                                                                                                                           3586 - Hellhound - Good doggie...
                                                                                                                                                                                               3587 - Ogre - He's full of pent-up aggression.
3588 - Baby red dragon - Young but still dangerous.
3589 - Kalphite Soldier - I don't think insect repellent will work...
                                                                                                                                                                                                                                                                                  3590 - Steel dragon - Its scales seem to be made of steel.
                                                                                                                                                                                               3591 - Dagannoth - A darkened horror from the ocean depths...
                                                                                                                                                                                                                                                       3592 - Tok-Xil - I don't like the look of those spines...
3593 - Demon - A freshly summoned demon.
3594 - Rocnar - It's full of pent-up aggression.
                                                                                                                                                                                               3595 - Toy Soldier - Nice piece of crafting that...
                                                                                                                                                                                                                                               3596 - Toy Doll - Nice piece of crafting that...
                                                                                                                                                                                                                                                                                            3597 - Toy Mouse - Nice piece of crafting that...
                                                                                                                                                                                                                                                                                                                                          3598 - Clockwork cat - An amazing piece of crafting.
                                                                                                                                                                                               3599 - Swamp snake - A large snake that thrives in swamps.
                                                                                                                                                                                               3600 - Swamp snake - A large snake that thrives in swamps.
                                                                                                                                                                                               3601 - Swamp snake - A large snake that thrives in swamps.
                                                                                                                                                                                               3602 - Swamp snake - A dead snake, it thrived in the swamp until it met you.
                                                                                                                                                                                               3603 - Dead swamp snake - A dead snake, it thrived in the swamp until it met you.
                                                                                                                                                                                               3604 - Dead swamp snake - A dead snake, it thrived in the swamp until it met you.
                                                                                                                                                                                               3605 - Dead swamp snake - A dead snake, it thrived in the swamp until it met you.
                                                                                                                                                                                               3606 - Ghast - Arrghhh... A Ghast.
                                                                                                                                                                                               3607 - Ghast - Arrghhh... A Ghast.
                                                                                                                                                                                               3608 - Ghast - Arrghhh... A Ghast.
                                                                                                                                                                                               3609 - Ghast - Arrghhh... A Ghast.
                                                                                                                                                                                               3610 - Ghast - Arrghhh... A Ghast.
                                                                                                                                                                                               3611 - Ghast - Arrghhh... A Ghast.
                                                                                                                                                                                               3612 - Giant snail - Euew.
                                                                                                                                                                                           3613 - Giant snail - Euew.
                                                                                                                                                                                           3614 - Giant snail - Euew.
                                                                                                                                                                                           3615 - Riyl shadow - The shadowy remains of a long departed soul.
                                                                                                                                                                                               3616 - Asyn shadow - The shadowy remains of a long departed soul.
                                                                                                                                                                                               3617 - Shade - The shadowy remains of a long departed soul.
                                                                                                                                                                                               3618 - Tentacle - I'm glad I can't see the rest of it!
                                                                                                                                                                                           3619 - Head - I'm glad I can't see the rest of it!
                                                                                                                                                                                           3620 - Head - I'm glad I can't see the rest of it!
                                                                                                                                                                                           3621 - Tentacle - I'm glad I can't see the rest of it!
                                                                                                                                                                                           3622 - Zombie - I wonder if he'd let me borrow his axe?
3623 - null - It's a null.
                                                                                                                                                                                               3624 - Smiddi Ryak - Small lonely child.
                                                                                                                                                                                               3625 - null - It's a null.
3626 - Rolayne Twickit - Old lonely man.
3627 - null - It's a null.
                                                                                                                                                                                               3628 - Jayene Kliyn - A Burgh de Rott female militia volunteer.
                                                                                                                                                                                               3629 - null - It's a null.
3630 - Valantay Eppel - A Burgh de Rott male militia volunteer.
3631 - null - It's a null.
                                                                                                                                                                                               3632 - Dalcian Fang - A retired but dangerous looking man
                                                                                                                                                                                           3633 - null - It's a null.
3634 - Fyiona Fray - A retired but dangerous looking female soldier.
3635 - Abidor Crank - The good samaritan.
3636 - Spirit tree - A young sentient tree.
3637 - Spirit tree - An ancient sentient tree.
3638 - null - It's a null.
                                                                                                                                                                                               3639 - Launa - She looks tired of waiting.
                                                                                                                                                                                               3640 - Launa - She looks tired of arguing.
                                                                                                                                                                                               3641 - Brana - An old man.
                                                                                                                                                                                               3642 - null - It's a null.
3643 - Tolna - Where did his boot go?
3644 - Tolna - A kid.
3645 - Angry bear - He looks a little on the cross side!
3646 - Angry unicorn - He looks a little on the cross side!
3647 - Angry giant rat - He looks a little on the cross side!
3648 - Angry goblin - He looks a little on the cross side!
3649 - Fear reaper - AHHHHH!
3650 - Confusion beast - What on RuneScape is that?!?
3651 - Confusion beast - What on RuneScape is that?!?
3652 - Confusion beast - What on RuneScape is that?!?
3653 - Confusion beast - What on RuneScape is that?!?
3654 - Confusion beast - What on RuneScape is that?!?
3655 - Hopeless creature - A hopeless poor creature.
3656 - Hopeless creature - A hopeless poor creature.
3657 - Hopeless creature - A hopeless poor creature.
3658 - Tolna - Is that really Tolna?
3659 - Tolna - Is that really Tolna?
3660 - Tolna - Is that really Tolna?
3661 - Angry unicorn - He looks a little on the cross side!
3662 - Angry giant rat - He looks a little on the cross side!
3663 - Angry goblin - He looks a little on the cross side!
3664 - Angry bear - He looks a little on the cross side!
3665 - Fear reaper - AHHHH!
3666 - Confusion beast - What on RuneScape is that?!?
3667 - Hopeless creature - A hopeless poor creature.
3668 - Hopeless beast - A hopeless poor creature.
3669 - Hopeless beast - A hopeless poor creature."



def require_all(_dir)
  Dir[File.expand_path(File.join(File.dirname(File.absolute_path(__FILE__)), _dir)) + "/**/*.rb"].each do |file|
    require file
  end
end

require_all("./models/")

@hello = 0
def db_configuration
  db_configuration_file = File.join(File.expand_path('..', __FILE__), '..', 'config', 'database.yml')
  YAML.load(File.read(db_configuration_file))
end

ActiveRecord::Base.establish_connection(db_configuration["development"])


array = string.split(':')
itemID = 0
itemName = "name"
array.each do |item|
  newArray = item.split(" - ")
  itemID =  newArray[0].gsub(' ', '').chomp.to_i
  itemName = newArray[1].chomp
  #item = RsItem.new(itemId: itemID, itemName: itemName)
  #item.save
end
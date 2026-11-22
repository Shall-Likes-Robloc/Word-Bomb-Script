-- ============================================================================
-- ROBLOX WORD BOMB AUTO-TYPER (Rigid Tactical UI | Reliable Auto-Type | F1/F2)
-- ============================================================================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local HAS_KEYPRESS = (type(keypress) == "function" and type(keyrelease) == "function")

-- CONFIGURATION & CONSTANTS
local CONFIG = {
    WordBankFile = "word_bomb.txt",
    Enabled = true,
    PreferLonger = true,             -- true = Longest words first, false = Shortest first
    HumanTypos = false,              -- Occasional neighbor-key typo + backspace
    ThinkDelay = false,              -- 0.35-1.0s reaction pause before auto-typing
    CalibrateKey = Enum.KeyCode.F1,  -- Calibrate when arrow is on you (+ type)
    ResetUsedKey = Enum.KeyCode.F2,  -- Reset word bank after every round
    TurnSettleDelay = 0.16,
    ArrowStableTime = 0.12,
    MaxAttemptsPerTurn = 2,
    MinKeyDelay = 0.04,
    MaxKeyDelay = 0.09,
    RetryDelay = 0.85,
    InputMode = HAS_KEYPRESS and "OS" or "Direct",
}

-- Embedded word bank: 7 words per combo, so no word_bomb.txt is needed in the workspace.
-- (Format: [COMBO] word, word, ... one combo per line.)
local EMBEDDED_WORD_BANK = [==[
[AA] aardvark, aah, baa, bazaar, naan, haar, salaam
[AB] able, about, cabin, crab, table, label, above
[AC] ace, acid, back, beach, face, macro, package
[AD] add, bread, glad, head, shadow, advance, read
[AE] aerial, algae, maestro, sundae, vertebrae, diaeresis, vitae
[AF] afar, after, craft, giraffe, safe, leaf, affine
[AG] again, age, bag, dragon, magic, image, message
[AH] aha, ahead, ahoy, dahlia, graham, yahoo, blah
[AI] aid, air, brain, chair, train, raise, domain
[AJ] ajar, cajole, major, majesty, pajamas, trajectory, swaraj
[AK] awake, bake, cake, kayak, snake, make, break
[AL] alarm, alien, animal, metal, oval, false, value
[AM] amber, camp, dream, family, game, name, lambda
[AN] anchor, angel, banana, dance, hand, and, range
[AO] aorta, cacao, chaos, karaoke, pharaoh, kaon, ciao
[AP] apart, ape, apple, map, paper, shape, append
[AQ] aqua, opaque, plaque, maquette, claque, faquir, aqueous
[AR] arch, arm, car, dark, star, array, are
[AS] ash, ask, basket, fast, glass, assert, class
[AT] ate, atom, cat, gate, water, data, path
[AU] audio, author, autumn, cause, sauce, default, auto
[AV] avatar, brave, cave, lava, wave, have, unravel
[AW] awake, award, claw, draw, hawk, raw, await
[AX] axe, axis, relax, taxi, max, syntax, pax
[AY] away, clay, day, play, stay, array, may
[AZ] azalea, azure, blaze, crazy, maze, lazy, hazmat
[BA] baby, back, banana, bank, bat, global, base
[BB] abbey, bubble, cabbage, pebble, rabbit, gobble, hobby
[BC] bobcat, hubcap, subculture, webcam, subclass, subcellular, subcontract
[BD] abdicate, abdomen, abduct, lambda, subdue, molybdenum, obduce
[BE] beach, bear, bed, bee, bell, number, begin
[BF] clubfoot, subfamily, subfloor, subfield, obfuscate, tubful, gabfest
[BG] hobgoblin, subgenre, subglacial, subgroup, crabgrass, subgroups, subgenus
[BH] abhor, clubhouse, subhead, bhakti, bharal, bhaji, bhang
[BI] bicycle, big, bike, bird, rabbit, binary, bit
[BJ] abject, object, subject, abjure, frabjous, objurgate, nonobjective
[BL] black, blade, blink, blue, table, public, double
[BM] cabman, clubman, submerge, webmaster, submitted, submission, submarine
[BN] abnegate, abnormal, cobnut, hobnail, thumbnail, subnormal, dubnium
[BO] board, boat, bomb, book, box, boost, symbol
[BP] subpar, webpage, bombproof, thumbprint, subplot, subpoena, subplots
[BR] brain, brave, bread, brick, zebra, library, bracket
[BS] absent, absorb, crabs, lobster, observe, subs, jobs
[BT] debt, doubt, obtain, subtle, obtuse, undoubtedly, indebted
[BU] bubble, bucket, bug, burger, bus, but, buffer
[BV] obviate, subversive, subvocal, unobvious, subverting, obvert, obvolute
[BW] cobweb, subway, webworm, bwana, lobworm, ribwort, barbwire
[BY] baby, bypass, hobby, ruby, bytes, hereby, bye
[CA] cabin, cactus, cake, camera, car, can, caption
[CC] accent, broccoli, raccoon, soccer, success, accuracy, according
[CD] anecdotal, ecdysis, synecdoche, anecdote, ecdysone, ecdyses, anecdotic
[CE] cedar, cell, center, dance, ice, license, except
[CH] chair, cheese, cherry, chicken, watch, check, anchor
[CI] cider, cinema, circle, city, special, decimal, precision
[CK] back, black, clock, duck, quick, check, package
[CL] clam, clap, claw, clean, cloud, class, include
[CM] acme, chacma, socman, blancmange, acmes, chacmas, blancmanges
[CN] acne, picnic, acnode, cnemis, tacnode, chicness, cnidarian
[CO] coach, coat, coffee, coin, color, controls, code
[CQ] acquire, becquerel, reacquire, lacquer, jacquard, racquetball, unacquainted
[CR] crab, craft, crane, cream, crown, macro, description
[CS] basics, comics, graphics, optics, physics, metrics, docs
[CT] act, cactus, doctor, fact, picture, object, function
[CU] cub, cucumber, cup, rescue, current, circuit, document
[CY] cyan, cycle, fancy, spicy, legacy, policy, frequency
[CZ] czar, eczema, czarina, czarist, czars, czardas, czardom
[DA] dad, daisy, dance, dark, panda, data, lambda
[DB] feedback, goodbye, handbag, oddball, sandbox, headband, speedboat
[DC] broadcast, handcuff, hardcore, podcast, wildcard, breadcrumb, grandchild
[DD] add, buddy, ladder, middle, puddle, odd, hidden
[DE] deal, deep, deer, desert, shade, def, index
[DF] blindfold, goldfish, handful, wildfire, windfall, boldface, mindful
[DG] badge, bridge, dodge, edge, judge, knowledge, widget
[DH] adhere, childhood, madhouse, redhead, sandhi, dharma, handhelds
[DI] diamond, dice, dig, dinosaur, radio, dict, dist
[DJ] adjacent, adjoin, adjust, djinn, nonadjacent, readjust, adjective
[DK] bodkin, vodka, roadkill, weedkiller, handkerchief, bodkins, vodkas
[DL] badly, candle, handle, middle, needle, bundle, regardless
[DM] admin, badminton, grandma, landmarks, admonition, goodman, amendments
[DN] goodness, kidnap, madness, midnight, badness, endnote, handedness
[DO] doctor, dog, dolphin, door, shadow, random, domain
[DP] bedpan, deadpan, headphone, midpoint, tadpole, endpoint, dpi
[DR] dragon, draw, dream, drink, drum, drop, address
[DS] birds, cards, clouds, friends, hands, bounds, fields
[DT] bedtime, breadth, hardtop, midtown, width, bandwidth, roundtrip
[DU] duck, dude, dune, dust, duty, module, dummy
[DV] advance, adventure, advice, advertising, aardvark, disadvantage, adversary
[DW] dwarf, dwell, hardware, midway, bandwidth, worldwide, goodwill
[DY] body, candy, dye, lady, ready, already, dynamic
[DZ] adze, kudzu, dzo, dziggetai, adzes, kudzus, dzos
[EA] each, eagle, earth, leaf, ocean, read, create
[EB] cobweb, debate, ebb, pebble, zebra, debug, hereby
[EC] check, echo, eclipse, neck, secret, object, expected
[ED] bed, edge, edit, red, expected, used, protected
[EE] bee, cheese, deep, green, tree, see, between
[EF] brief, chef, effect, left, thief, def, ref
[EG] beg, egg, leg, omega, integer, regex, category
[EH] behave, behind, reheat, vehicle, placeholder, somehow, household
[EI] beige, ceiling, eight, neighbor, weird, height, weight
[EJ] deject, eject, reject, prejudicial, rejoin, unprejudiced, deejay
[EK] cheek, creek, eureka, geek, week, seek, peek
[EL] elbow, elephant, elf, hotel, yellow, self, else
[EM] email, ember, emerald, gem, lemon, empty, element
[EN] bench, end, engine, green, open, license, append
[EO] chameleon, geode, leopard, neon, video, geometry, timeout
[EP] deep, epic, keep, pepper, sleep, except, step
[EQ] equal, equip, sequel, freq, request, subsequent, infrequent
[ER] berry, butter, river, tiger, water, assert, letter
[ES] chest, desk, dress, forest, yes, test, result
[ET] basket, comet, jet, planet, sweet, return, get
[EU] eulogy, euphoria, feud, museum, queue, pseudo, euclidean
[EV] clever, eleven, evening, lever, seven, every, however
[EW] brew, chew, dew, jewel, new, view, rewrite
[EX] exact, exam, exit, extra, next, index, latex
[EY] alley, eye, honey, key, monkey, they, galley
[EZ] breeze, fez, freeze, sneeze, timezone, squeeze, trapezoid
[FA] face, fact, fairy, family, fast, false, default
[FB] offbeat, goofball, halfback, hoofbeat, puffball, snuffbox, surfbird
[FE] fear, feather, fence, giraffe, safe, buffer, reference
[FF] cliff, coffee, fluff, muffin, waffle, offset, buffer
[FI] field, fig, fire, fish, file, define, first
[FJ] fjord, fjeld, fjords
[FL] flag, flame, flash, flower, fly, float, floor
[FO] foam, fog, food, forest, fox, format, font
[FR] frame, free, fresh, friend, frog, from, freq
[FS] briefs, chefs, cliffs, puffs, roofs, offset, refs
[FT] after, craft, gift, left, soft, shift, draft
[FU] fudge, fuel, fun, future, fusion, full, useful
[FY] clarify, comfy, defy, leafy, verify, modify, simplify
[GA] galaxy, game, garage, garden, gate, gamma, negative
[GB] eggbeater, logbook, ragbag, tugboat, dingbat, songbird, rugby
[GD] kingdom, ringdove, fogdog, ogdoad, hangdog, smaragd, amygdala
[GE] gear, gecko, gem, orange, tiger, get, range
[GF] bigfoot, dogfight, hagfish, kingfish, segfault, meaningful, bagful
[GG] bigger, dagger, egg, giggle, juggle, logger, ragged
[GH] bright, ghost, high, light, night, height, right
[GI] giant, gift, ginger, giraffe, magic, begin, given
[GL] glad, glass, globe, glove, glow, single, angle
[GM] dogma, enigma, magma, pigment, stigma, sigma, segment
[GN] align, design, gnome, magnet, sign, ignore, gnu
[GO] goat, gold, golf, goose, mango, category, algorithm
[GP] bagpipe, flagpole, pigpen, eggplant, magpie, kingpin, gangplow
[GR] grab, grain, grape, grass, green, group, degree
[GS] bags, bugs, dogs, eggs, frogs, flags, warnings
[GT] pigtail, ragtag, ringtone, length, strength, wavelength, longtime
[GU] guard, guess, guitar, gum, penguin, argument, language
[GW] bigwig, dogwood, gangway, hogwash, ragweed, bagwig, logway
[GY] biology, energy, foggy, gym, strategy, gyre, morphology
[GZ] zigzag, zugzwang, zigzagged, zigzagging, zigzags, zigzagger
[HA] habit, hair, hammer, hand, happy, that, shape
[HB] dashboard, fishbowl, highbrow, lunchbox, wishbone, neighbors, pushbutton
[HC] ashcan, fishcake, flashcard, highchair, pushcart, trashcan, healthcare
[HD] birthday, touchdown, washday, withdraw, watchdog, archduke, deathday
[HE] head, heart, heat, hello, hero, the, height
[HF] bashful, faithful, mouthful, truthful, wishful, pitchfork, pathfinder
[HH] bathhouse, beachhead, fishhook, hitchhike, withhold, roughhew, touchhole
[HI] hide, high, hill, hippo, history, this, which
[HJ] mahjong, mahjongg, mahjongs, mahjonggs
[HL] athlete, breathless, flashlight, highlight, ruthless, roughly, monthly
[HM] asthma, bathmat, isthmus, logarithm, rhythm, algorithm, benchmark
[HN] ethnic, highness, technique, technology, john, pathname, smoothness
[HO] hobby, hockey, home, honey, horse, method, anchor
[HP] dishpan, highpoint, pushpin, launchpad, throughput, dashpot, toothpaste
[HR] chrome, phrase, shrimp, three, through, christian, synchronized
[HS] baths, births, earths, months, paths, glyphs, graphs
[HT] bright, eight, fight, light, night, height, right
[HU] hug, human, hundred, hungry, chunk, shuffle, thus
[HW] archway, dishwater, highway, inchworm, pathway, northwest, southwest
[HY] hyena, hymn, rhyme, shy, physics, hyper, why
[IA] diamond, diary, giant, piano, trivia, initial, special
[IB] bible, crib, fiber, ibex, ribbon, lib, attribute
[IC] brick, ice, magic, music, quick, license, public
[ID] acid, hide, idea, kid, spider, width, invalid
[IE] alien, cookie, field, friend, pie, series, modified
[IF] cliff, gift, knife, life, shift, diff, modified
[IG] big, dig, igloo, pig, tiger, height, right
[IH] annihilate, nihilism, likelihood, dihedral, chihuahua, maihem, mihrab
[II] genii, radii, shiitake, skiing, taxiing, iii, viii
[IJ] bijou, hijab, ouija, bijection, bijugate, demijohn, jipijapa
[IK] alike, bike, hike, like, spike, wiki, unlike
[IL] build, child, hill, milk, smile, file, will
[IM] climb, dim, image, lime, swim, import, time
[IN] brain, drink, king, wind, index, int, string
[IO] action, audio, lion, onion, radio, version, function
[IP] chip, clip, flip, ship, zip, skip, description
[IQ] antique, boutique, liquid, unique, clique, oblique, technique
[IR] bird, circle, fire, girl, shirt, first, spirit
[IS] fish, island, list, mist, wish, this, raise
[IT] bit, city, fruit, kite, sit, with, initial
[IU] radius, medium, chromium, consortium, equilibrium, sodium, trapezium
[IV] dive, five, hive, ivory, river, given, active
[IW] kiwi, periwinkle, antiwar, diwan, skiwear, taxiway, biweekly
[IX] affix, fix, mix, pixel, six, matrix, prefix
[IY] riyal, teriyaki, aliyah, ouguiya, rufiyaa, biyearly, hiya
[IZ] dizzy, fizz, lizard, pizza, quiz, size, parametrize
[JA] jacket, jade, jaguar, jam, jazz, adjacent, java
[JE] jeans, jeep, jelly, jet, jewel, object, project
[JI] jiffy, jig, jinx, emoji, jitter, kanji, jimmy
[JO] job, jog, join, joke, joy, major, john
[JU] judge, juice, jump, jungle, just, adjust, conjugate
[KA] kale, kangaroo, karaoke, kayak, package, kappa, karma
[KB] workbook, checkbox, cookbook, blackberry, backbone, trackball, blackboard
[KC] blockchain, backchat, bankcard, blackcap, bookcase, crankcase, deckchair
[KD] markdown, weekday, breakdown, workday, backdrop, jackdaws, sheikdom
[KE] bake, cake, keep, key, snake, like, make
[KF] backfill, workflow, breakfast, thankfully, taskforce, forkful, nakfa
[KH] khaki, khan, sheikh, workhorse, backhand, samekh, lakh
[KI] kick, kid, king, kitchen, kite, skip, kind
[KK] bookkeeping, jackknife, grokked, chukka, likker, markka, sukkah
[KL] ankle, buckle, klutz, pickle, sparkle, franklin, blacklist
[KM] bookmark, checkmark, milkman, pockmark, workman, hackman, junkman
[KN] knee, knife, knight, knock, knot, unknown, known
[KO] koala, kohlrabi, koi, kook, kosher, checkout, mako
[KP] checkpoint, breakpoints, backpack, workplace, cockpit, duckpin, jackpot
[KR] kraal, kraken, krill, krypton, okra, kris, kraft
[KS] books, ducks, forks, parks, sharks, works, blocks
[KT] backtalk, cocktail, desktop, necktie, buckteeth, worktable, breakthrough
[KU] haiku, kudos, kudzu, kumquat, skull, lookup, markup
[KW] awkward, backward, bookworm, clockwork, milkweed, shockwave, parkway
[KY] bulky, lucky, rocky, sky, sticky, tricky, flaky
[LA] label, lake, lamp, land, lava, class, latex
[LB] album, bulb, elbow, mailbox, sailboat, toolbar, callback
[LC] alchemy, balcony, calcium, falcon, volcano, wheelchair, welcome
[LD] build, child, cold, gold, wild, should, field
[LE] apple, eagle, leaf, lemon, turtle, file, let
[LF] calf, elf, golf, half, wolf, self, itself
[LG] algae, bilge, bulge, indulge, vulgar, algorithm, algebraic
[LH] bullhorn, dollhouse, jailhouse, schoolhouse, silhouette, bellhop, metalhead
[LI] light, lilac, lily, line, lion, license, list
[LK] chalk, elk, folk, milk, walk, bulk, talk
[LL] ball, bell, hill, shell, wall, will, all
[LM] almond, calm, elm, film, palm, bellman, realm
[LN] kiln, ulna, vulnerable, walnut, telnet, usefulness, illness
[LO] cloud, flower, lock, log, love, color, float
[LP] alpaca, gulp, help, kelp, pulp, alpha, sculpture
[LR] already, railroad, alright, rivalry, walrus, bulrush, cavalry
[LS] bells, calls, goals, hills, owls, else, controls
[LT] belt, bolt, melt, quilt, salt, result, default
[LU] blue, club, luck, lunch, plush, value, include
[LV] dissolve, evolve, silver, solve, twelve, resolve, convolve
[LW] always, bulwark, hallway, railway, stalwart, bullwhip, tailwind
[LY] daily, family, fly, jelly, lynx, only, apply
[MA] magic, magnet, mango, map, mask, format, matrix
[MB] amber, bomb, climb, lamb, thumb, number, symbol
[MC] armchair, camcorder, emcee, tomcat, tramcar, kimchi, plumcot
[MD] humdrum, fremd, dumdum, filmdom, gumdrop, slumdog, mdse
[ME] camel, game, home, meal, melon, name, method
[MF] armful, brimful, comfort, harmful, circumflex, emf, chamfered
[MH] armhole, farmhouse, mho, wormhole, crumhorn, drumhead, micromho
[MI] mice, milk, mind, mint, smile, limit, missing
[ML] aimless, farmland, hamlet, hemline, seamless, randomly, uniformly
[MM] common, dummy, gamma, immediate, symmetric, summary, recommended
[MN] autumn, column, condemn, hymn, solemn, randomness, amnesty
[MO] lemon, monkey, monster, moon, mouse, module, mode
[MP] camp, jump, lamp, pumpkin, stamp, import, empty
[MR] amrita, comrade, nimrod, shamrock, ramrod, armrest, rimrock
[MS] arms, drums, gems, storms, teams, items, terms
[MT] warmth, amt, femtosecond, tomtit, gumtree, palmtop, mtge
[MU] mud, muffin, mug, museum, music, must, maximum
[MW] gumwood, swimwear, tramway, wormwood, firmware, dimwitted, clamworm
[MY] army, dummy, mummy, mystery, myth, academy, myself
[NA] banana, nail, name, napkin, nature, optional, binary
[NB] inborn, pinball, rainbow, sunburn, unbraced, unbounded, unbiased
[NC] anchor, bench, dance, fence, lunch, include, function
[ND] band, candle, hand, island, sand, and, index
[NE] bone, neck, needle, nest, phone, none, new
[NF] bonfire, confuse, infant, sunflower, unfair, info, infer
[NG] bring, king, ring, sing, wing, string, range
[NH] downhill, enhance, inhale, inherit, unhappy, sinh, tanh
[NI] animal, finish, night, nine, ninja, initial, union
[NJ] banjo, conjure, enjoy, injure, ninja, inject, benjamin
[NK] bank, blink, drink, pink, tank, unknown, link
[NL] enlist, inlet, online, only, sunlight, inline, unless
[NM] gunman, inmate, penman, unmade, environment, alignment, assignment
[NN] banner, bunny, dinner, funny, tunnel, cannot, inner
[NO] noble, noise, north, snow, none, not, node
[NP] input, manpower, nonprofit, pinpoint, unpack, unprocessed, davenport
[NQ] banquet, conquer, inquire, tranquil, vanquish, unquote, enqueue
[NR] enrich, enroll, sunrise, unreal, unravel, henry, goldenrod
[NS] answer, beans, coins, lens, sense, license, columns
[NT] ant, giant, mint, paint, plant, controls, int
[NU] menu, nucleus, number, nurse, nut, numeric, null
[NV] anvil, canvas, envy, invade, invent, convert, environment
[NW] inward, onward, runway, unwind, unwrap, downwards, unweighted
[NX] sphinx, minx, lynx, anxious, quincunx, phalanx, larynx
[NY] any, bunny, canyon, pony, sunny, many, company
[NZ] bonanza, bronze, enzyme, frenzy, stanza, nonzero, unzip
[OA] boat, coach, goat, oak, toast, float, load
[OB] cobweb, job, lobster, object, robot, global, gobble
[OC] block, clock, doctor, ocean, rock, local, process
[OD] blood, code, food, good, wood, method, node
[OE] amoeba, canoe, poem, shoe, does, phoenix, coefficients
[OF] coffee, off, roof, soft, proof, profile, cutoff
[OG] dog, fog, frog, log, yogurt, program, google
[OH] alcohol, mohawk, ohm, john, johannes, prohibited, coherence
[OI] boil, choice, coin, oil, voice, point, join
[OJ] mojo, sojourn, project, emoji, kilojoule, jojoba, turbojet
[OK] book, cook, joke, look, smoke, token, hook
[OL] cold, dolphin, gold, old, wolf, controls, color
[OM] bomb, comet, home, tomato, from, random, common
[ON] bone, dragon, lemon, moon, onion, none, controls
[OO] book, cool, food, moon, ooze, boost, toolbar
[OP] drop, hop, open, shop, stop, copyright, option
[OQ] baroque, colloquial, croquet, eloquent, loquacious, loquitur, coquelicot
[OR] acorn, corn, door, forest, orange, import, format
[OS] boss, fossil, ghost, moss, rose, boost, pos
[OT] hot, knot, otter, robot, not, other, protected
[OU] cloud, house, mouse, out, round, you, should
[OV] above, cover, dove, glove, love, over, provided
[OW] bow, cow, owl, shadow, snow, row, allow
[OX] box, fox, oxygen, toxic, approx, proxy, mailbox
[OY] boy, enjoy, joy, oyster, toy, royalty, destroy
[OZ] booze, cozy, dozen, frozen, ozone, lozenge, unfrozen
[PA] panda, paper, park, party, pasta, path, package
[PB] clipboard, cupboard, scrapbook, upbeat, raspberry, peepbo, hipbath
[PC] popcorn, topcoat, upcast, upcountry, opcode, cupcake, upcoming
[PD] stepdad, update, updraft, lapdog, sheepdog, slapdash, trapdoor
[PE] ape, grape, open, peach, penguin, type, shape
[PF] campfire, cupful, helpful, stepfather, upfront, deepfreeze, unhelpful
[PG] upgrade, stopgap, popgun, campground, topgallant, upgraded, upgrades
[PH] alpha, dolphin, elephant, graph, phone, glyphs, digraph
[PI] pie, pig, pillow, pineapple, pizza, spirit, typing
[PK] pumpkin, napkin, pipkin, upkeep, bumpkin, limpkin, topknot
[PL] apple, plane, play, example, tuple, samples, simple
[PM] chipmunk, equipment, shipment, topmast, upmost, development, chapman
[PN] apnea, hypnosis, pneumonia, shrapnel, sharpness, steepness, dyspnea
[PO] pocket, poem, point, pond, potato, import, pos
[PP] apple, happy, pepper, puppy, slipper, append, mapping
[PR] price, prince, prize, property, protected, prefix, process
[PS] lapse, lips, psalm, pseudo, psyche, groups, ellipse
[PT] adapt, captain, chapter, crypt, kept, empty, except
[PU] public, puddle, puff, pumpkin, puppy, input, output
[PW] shopworn, shipwreck, upward, stepwise, stopwatch, tripwire, upwell
[PY] copy, happy, puppy, pyramid, python, pyx, entropy
[QA] qadi, qaid, qanat, qat, sheqalim, qats, qanats
[QI] qintar, qiviut, faqir, qibla, qindarka, faqirs, qintars
[QU] quake, queen, quick, quiet, quote, equal, sequence
[RA] rabbit, radar, radio, rain, zebra, array, raise
[RB] absorb, barb, curb, herb, orbit, verbose, arbitrary
[RC] arch, birch, circle, march, torch, source, search
[RD] bird, board, card, lizard, word, order, keyword
[RE] bread, green, red, tree, treasure, return, result
[RF] dwarf, scarf, surf, turf, performance, interface, overflow
[RG] barge, burger, charge, energy, large, org, target
[RH] diarrhea, myrrh, rhino, rhyme, rhythm, rho, perhaps
[RI] brick, bridge, drink, rice, river, series, string
[RJ] marjoram, overjoy, perjury, surjection, lumberjack, interjects, alforja
[RK] bark, dark, fork, park, shark, mark, work
[RL] curl, early, girl, pearl, world, overload, underline
[RM] alarm, arm, farm, storm, warm, format, normal
[RN] acorn, barn, corn, horn, unicorn, return, kernel
[RO] frog, iron, road, robot, rock, from, controls
[RP] carp, harp, purple, sharp, warp, corporation, interpolate
[RQ] parquet, torque, marquess, turquoise, remarque, cirque, charqui
[RR] arrow, berry, carrot, mirror, parrot, array, error
[RS] bears, horse, nurse, stars, version, first, parse
[RT] art, cart, earth, heart, turtle, assert, import
[RU] brush, drum, fruit, ruby, truck, true, rule
[RV] carve, curve, nerve, serve, starve, interval, reserved
[RW] airway, earwig, forward, narwhal, stairway, otherwise, overwrite
[RY] berry, cherry, dry, fairy, story, try, binary
[RZ] borzoi, marzipan, scherzo, terzetto, furze, mirza, forzando
[SA] salad, salt, sand, sauce, message, same, samples
[SB] frisbee, husband, chessboard, crossbones, misbehave, asbestosis, busboy
[SC] scale, scarf, school, science, scout, score, description
[SD] wisdom, jurisdiction, transduction, misdirected, rigsdaler, asdic, disdain
[SE] cheese, house, mouse, rose, sea, self, assert
[SF] blissfully, misfire, satisfy, transfer, successful, unsuccessful, unsatisfied
[SG] disguise, misgive, transgressive, newsgroups, transgender, thanksgiving, disgraced
[SH] brush, fish, shark, shell, ship, shape, should
[SI] music, side, sign, silver, sit, version, size
[SJ] disjoint, misjudge, disjunction, masjid, musjid, sjambok, crossjack
[SK] ask, desk, mask, skate, sky, skip, skin
[SL] island, sled, sleep, slice, slow, slash, slide
[SM] prism, small, smart, smile, smoke, smooth, mismatch
[SN] snack, snail, snake, snap, snow, snippet, fresnel
[SO] soap, sock, soda, solar, source, also, software
[SP] space, spider, spoon, sport, wasp, sparse, spirit
[SQ] squad, squid, squeeze, basque, risque, bisque, mosque
[SR] disrepair, disrespect, misread, sri, disregard, classroom, disruption
[SS] boss, class, glass, grass, moss, assert, message
[ST] castle, fast, ghost, star, stone, test, list
[SU] sugar, summer, sun, super, sushi, result, sub
[SV] misvalue, svelte, transversal, disvalue, transvalue, transvestism, svelter
[SW] swan, sweet, swim, swing, sword, switch, answer
[SY] busy, daisy, easy, symbol, system, syllable, syntax
[TA] guitar, pasta, star, table, taco, data, state
[TB] football, frostbite, heartbeat, outback, softball, textbook, basketball
[TC] catch, kitchen, match, pitch, watch, batch, patch
[TD] outdo, shutdown, stdio, postdate, countdown, meltdown, letdown
[TE] gate, kite, monster, team, test, letter, latex
[TF] artful, catfish, outfit, pitfall, platform, postfix, restful
[TG] nightgown, outgo, shotgun, mortgage, catgut, roentgen, postgraduate
[TH] bath, earth, feather, north, thunder, the, this
[TI] action, arctic, tiger, time, tiny, function, option
[TK] catkin, pocketknife, hotkey, kibitka, latke, rootkit, giantkiller
[TL] atlas, battle, bottle, castle, title, directly, currently
[TM] atmosphere, boatman, nightmare, oatmeal, utmost, bitmap, treatment
[TN] chutney, fitness, fortnight, partner, witness, footnote, attn
[TO] potato, toast, tomato, tooth, toy, vector, token
[TP] footpath, hotpot, outpost, postponed, marketplace, nitpick, hatpin
[TR] train, trap, treasure, tree, truck, controls, true
[TS] ants, boots, cats, hats, plants, points, rights
[TT] better, butter, kitten, letter, otter, pattern, attribute
[TU] cactus, statue, tulip, tuna, turtle, return, tuple
[TV] outvote, statvolt, zemstvo, bodhisattva, outvoted, outvotes, outvoting
[TW] between, network, tweet, twin, twist, software, two
[TY] city, empty, party, pretty, type, style, property
[TZ] blitz, hertz, pretzel, quartz, waltz, ersatz, quetzal
[UA] actual, aqua, equal, guard, usual, language, square
[UB] bubble, club, cube, rubber, submarine, public, double
[UC] bucket, duck, luck, truck, zucchini, such, product
[UD] bud, cloud, mud, puddle, study, include, exclude
[UE] blue, clue, fuel, queen, true, value, sequence
[UF] buffalo, fluff, muffin, puff, stuff, suffix, shuffle
[UG] bug, hug, juggle, mug, rug, debug, through
[UI] build, fruit, guide, juice, quick, circuit, required
[UK] duke, fluke, jukebox, nuke, ukulele, puke, auk
[UL] bulb, full, gulp, pulse, skull, result, default
[UM] drum, gum, jump, pumpkin, summer, number, columns
[UN] bunny, fun, jungle, sun, thunder, count, under
[UO] buoy, duo, fluoride, liquor, quote, contiguous, continuous
[UP] cup, puppet, soup, group, tuple, update, support
[UR] burger, burn, fur, purple, turtle, return, source
[US] bus, cactus, house, mushroom, music, use, must
[UT] butter, cut, donut, nut, out, input, without
[UU] continuum, duumvir, muumuu, residuum, vacuum, lituus, menstruum
[UV] duvet, juvenile, louver, rejuvenate, uvula, mauve, guv
[UX] crux, flux, luxury, tuxedo, aux, tableaux, faux
[UY] buy, guy, wiseguys, exequy, tuyere, obloquy, obsequy
[UZ] buzz, fuzz, guzzle, muzzle, puzzle, cruzeiro, huzzah
[VA] lava, vacation, vacuum, valley, vase, value, advance
[VE] cave, five, glove, love, wave, version, level
[VI] anvil, movie, video, vine, violin, provided, divide
[VO] avocado, avoid, voice, volcano, vote, voltage, vowel
[VR] chevron, oeuvre, vroom, livre, sovran, bahuvrihi, vrooms
[VU] convulse, revulsion, vulva, vulgar, vulture, vulnerable, uvular
[VV] savvy, bovver, revved, skivvy, bevvy, civvies, divvy
[VY] bevy, curvy, envy, heavy, navy, levy, wavy
[WA] awake, swamp, swan, walk, water, software, warning
[WB] cowbell, lawbreaker, newborn, snowball, shadowbox, drawbar, rowboat
[WC] cowcatcher, newcomer, showcase, slowcoach, snowcap, flowchart, bawcock
[WD] bawdy, crowd, dowdy, rowdy, shrewd, powder, slowdown
[WE] answer, flower, sweet, web, west, weight, between
[WF] awful, crawfish, lawful, snowfall, unlawful, blowfish, newfangled
[WG] cowgirl, showgirl, gewgaw, blowgun, lawgiver, shadowgraph, sparrowgrass
[WH] whale, wheat, wheel, whisper, white, which, when
[WI] kiwi, swim, twin, wind, wing, with, width
[WK] awkward, gawk, hawk, squawk, tomahawk, mohawk, mawkin
[WL] bowl, crawl, growl, owl, prowl, newline, knowledge
[WM] lawmaker, sawmill, showman, snowman, bowman, endowments, cowman
[WN] brown, clown, crown, dawn, town, unknown, down
[WO] wolf, woman, wonder, wood, world, work, keyword
[WP] cowpoke, snowplow, viewpoint, gawping, pawpaw, brewpub, stewpan
[WR] wrap, wreath, wreck, wrist, write, rewrite, wrong
[WS] brows, claws, cows, jaws, news, windows, rows
[WT] bowtie, kowtow, newt, pewter, growth, sawtooth, drawtube
[WU] blowup, swung, followup, wurst, mugwump, wussy, swum
[WW] powwow, slowworm, bowwow, glowworm, arrowwood, screwworm, strawworm
[WY] chewy, dewy, lawyer, snowy, wyvern, viewy, sawyer
[XA] exact, exalt, exam, hexagon, inexact, fixation, relaxation
[XC] exceed, excite, exclude, exch, boxcar, excuse, nonexclusive
[XE] axes, boxer, mixer, oxen, fixed, execute, indexer
[XF] boxfish, foxfire, sixfold, oxford, exfoliant, boxful, exfoliate
[XH] exhale, exhibit, exhume, exhort, boxhaul, foxhole, oxheart
[XI] axis, exit, taxi, toxic, exist, maximum, auxiliary
[XL] axle, boxlike, sexless, transaxle, sphinxlike, laxly, convexly
[XM] taxman, fluxmeter, taxmen
[XO] axon, exodus, exonerate, exoskeleton, exotic, xor, saxophone
[XP] expand, expect, explore, express, export, unexpanded, unexpected
[XT] context, extra, next, sixth, text, extension, external
[XU] exude, exult, luxurious, plexus, nexus, asexual, exurb
[XW] boxwood, waxwing, maxwell, paxwax, waxwork, maxwells, waxwings
[XY] boxy, foxy, galaxy, oxygen, proxy, doxy, prexy
[YA] kayak, lanyard, royal, yak, yard, cyan, dyadic
[YB] bayberry, daybreak, keyboard, maybe, playboy, hybrid, anybody
[YC] bicycle, cycle, psychic, recycle, barycentric, acyclic, motorcycle
[YD] dehydrate, hydra, payday, everyday, honeydew, aldehyde, carbohydrate
[YE] bye, dye, eye, yellow, yes, year, layer
[YF] crayfish, dayfly, joyful, playful, wayfarer, jellyfish, mayfly
[YG] oxygen, playground, polygon, pygmy, zygote, syzygy, bygone
[YH] boyhood, greyhound, keyhole, mayhem, playhouse, polyhedron, anyhow
[YI] crying, flying, lying, playing, yield, underlying, copying
[YK] tyke, pyknic, fyke, tykes
[YL] asylum, daylight, nylon, style, vinyl, syllable, payload
[YM] acronym, gym, hymn, symbol, symmetric, asymptotic, anonymous
[YN] larynx, lynx, sync, synonym, syntax, polynomial, dynamic
[YO] beyond, canyon, crayon, yogurt, young, your, layout
[YP] crypt, gypsy, hype, type, typical, glyphs, hieroglyph
[YR] lyric, myriad, pyramid, syrup, tyrant, copyright, gyre
[YS] abyss, crystal, mystery, oyster, system, keys, arrays
[YT] byte, myth, python, rhythm, scythe, anything, everything
[YU] yucca, yuck, yule, yummy, yurt, yuan, yup
[YW] anyway, byway, keyway, skyward, wayward, playwright, flyweight
[YX] pyx, onyx, calyx, coccyx, myxoma, apteryx, asphyxia
[YZ] analyze, catalyze, electrolyze, hydrolyze, paralyze, byzantine, syzygy
[ZA] bazaar, blizzard, hazard, lizard, pizza, optimization, byzantine
[ZB] fuzzball, whizzbang, fuzzballs, whizzbangs
[ZE] amaze, breeze, freeze, zebra, zero, size, parametrize
[ZH] muzhik, zho, muzhiks, zhos
[ZI] magazine, zip, zigzag, lazily, unzip, zigs, brazil
[ZL] dazzle, drizzle, fizzle, puzzle, sizzle, swizzle, muzzle
[ZM] gizmo, jazzman, hazmat, razzmatazz, sitzmark, quizmaster, gizmos
[ZO] amazon, horizon, ozone, zodiac, zoo, timezone, zone
[ZU] azure, kudzu, yuzu, zucchini, gazump, lazuli, mazuma
[ZW] buzzword, zwieback, zugzwang, buzzwords
[ZY] breezy, crazy, dizzy, fuzzy, lazy, syzygy, woozy
[ZZ] buzz, dizzy, jazz, pizza, puzzle, fuzzy, swizzle
[AAR] aardvark, aardwolf, bazaar, haar, bazaars, aardwolves, aardvarks
[ABY] baby, aby, labyrinth, gigabytes, megabytes, terabytes, wallaby
[ADW] headwater, roadways, adware, gadwall, madwort, deadwood, leadwort
[AEG] aegis, jaeger, aegrotat, aegises, jaegers
[AEO] aeon, aeolian, palaeontology, archaeology, caeoma, paeony, archaeornis
[AIR] air, chair, fair, hair, stair, pair, wheelchair
[AIZ] maize, baiza, archaize, maizes, baize, baizas, archaized
[AKE] bake, cake, lake, make, snake, take, fake
[AKS] breaks, peaks, leaks, tweaks, croaks, sneaks, speaks
[ALK] balk, chalk, stalk, talk, walk, smalltalk, alk
[ALL] ball, call, fall, small, wall, all, install
[ALY] analysis, anomaly, mealy, catalyst, calyx, eucalyptus, galyak
[AMP] camp, champ, lamp, stamp, swamp, example, samples
[AND] band, hand, island, land, sand, and, random
[ANG] bang, fang, hang, mango, tango, range, angle
[ANK] bank, blank, crank, prank, tank, rank, thanks
[ANZ] stanza, garbanzo, banzai, kwanza, panzer, bonanza, canzona
[AOU] caoutchouc, giaour, miaou, aoudad, miaous, aoudads, caoutchoucs
[AQU] aqua, aqueduct, aquifer, opaque, maquette, plaque, claque
[ARK] bark, dark, mark, park, shark, benchmark, quark
[ART] art, cart, heart, part, smart, start, chart
[ARW] narwhals, earwax, carwash, tarweed, bearwood, clearway, rearward
[ASH] cash, crash, flash, smash, splash, hash, dash
[ASK] ask, bask, cask, flask, mask, task, unmasked
[AST] blast, cast, fast, last, past, least, east
[ATE] crate, date, gate, plate, skate, latex, state
[AUN] aunt, daunt, gaunt, haunt, launch, fauna, sauna
[AUX] aux, tableaux, faux, bateaux, bauxite, gateaux, reseaux
[AWB] drawbar, strawberry, bawbee, jawbone, sawbuck, rawboned, lawbreaker
[AWK] awkward, gawk, hawk, squawk, tomahawk, mohawk, mawkin
[AWL] crawl, drawl, trawler, awl, shawl, flawless, yawl
[AWN] dawn, fawn, lawn, pawn, yawn, drawn, spawn
[AXE] axes, relaxed, maxes, taxes, faxes, axeman, axenic
[AYB] maybe, playback, waybill, daybed, jaybird, payback, bayberry
[AYL] payload, daylight, playlist, waylay, hayloft, rayless, grayling
[AZA] bazaar, hazard, lazar, plaza, azalea, chazan, mazard
[AZE] blaze, craze, daze, gaze, maze, hazel, amazed
[AZY] crazy, hazy, lazy, mazy, sleazy, azygous, crazyweed
[BAK] bake, baklava, prebake, clambake, sunbaked, baksheesh, baking
[BBL] babble, bubble, cobble, pebble, wobble, gobble, nibble
[BIZ] biz, showbiz, syllabize, bizarre, bize, bizarrerie, bizarreness
[BLI] blind, bliss, blizzard, goblin, public, bibliography, sibling
[BOW] rainbow, bow, elbow, crossbow, fogbow, sunbow, embow
[BST] abstract, substitute, substantial, lobster, obstacle, substrate, obstruct
[CAV] caveat, concave, cavity, scavenge, cavort, cavalla, peccavi
[CCH] bacchanal, gnocchi, saccharin, zucchini, zecchino, radicchio, ecchymosis
[CHL] chlorine, hatchling, branchless, richly, schlep, chlamys, cichlid
[CHR] chrome, chrysanthemum, christian, synchronized, monochrome, asynchronous, ochre
[CHS] epochs, fuchsia, psychs, stomachs, aurochs, eunuchs, scotchs
[CIV] civilian, xciv, conducive, civet, civvies, civically, lascivious
[CKF] backfill, sackful, jackfish, rockfall, wreckful, blackface, chockfull
[CKL] buckle, cackle, chuckle, pickle, blacklist, quickly, backlog
[CKO] checkout, knockout, reckon, gecko, blackout, lockout, beckon
[CKU] backup, pickup, checkups, cockup, lockup, ruckus, crackup
[CLU] club, cluck, clue, clump, cluster, include, exclude
[COV] cover, covariance, discovery, recover, uncover, alcove, hardcover
[CRU] crude, cruel, cruise, crumb, crunch, crucial, breadcrumb
[CTN] correctness, compactness, strictness, exactness, perfectness, inexactness, erectness
[CTU] actual, cactus, fracture, lecture, picture, structure, punctuation
[CYC] bicycle, cycle, recycle, tricycle, acyclic, motorcycle, polycyclic
[CYS] cysteine, encyst, otocyst, cystitis, cholecyst, cystocarp, cystolith
[CZA] czar, czarina, czarist, czars, czardas, czardom, czarism
[DBR] endbrain, midbrain, redbrick, birdbrain, broadbrim, goldbrick, handbrake
[DDL] cuddle, fiddle, middle, paddle, puddle, oddly, saddle
[DEX] index, subindex, dexter, caudex, codex, spandex, ambidexter
[DGE] badge, bridge, edge, fudge, judge, knowledge, widget
[DIZ] dizen, dizygotic, dizzy, standardize, jeopardize, oxidized, fluidized
[DLY] badly, deadly, friendly, gladly, oddly, repeatedly, rapidly
[DOX] doxy, orthodox, paradox, unorthodox, indoxyl, doxology, heterodox
[DSP] loudspeaker, godspeed, feldspar, bedspread, handspike, bloodsport, headspring
[DTH] breadth, hundredth, thousandth, width, bandwidth, hairbreadth, handbreadth
[DWA] dwarf, hardware, midway, headwater, groundwater, roadways, adware
[DWI] bandwidth, worldwide, goodwill, sandwich, woodwind, hardwired, dwindles
[DYL] cacodyl, condyle, idyll, ladylike, odyl, bandylegged, spondylitis
[DZO] dzo, dzos
[EAK] beak, break, freak, peak, speak, weak, leak
[EAL] deal, heal, meal, real, seal, ideal, areal
[EAU] beau, bureau, plateau, tableau, eau, bandeau, ponceau
[EAW] giveaway, seaweed, areaway, reawake, fleawort, hideaway, takeaway
[ECH] echo, leech, speech, tech, mechanism, echelon, sech
[EEV] sleeve, reeves, beeves, steeve, weever, peeve, unreeve
[EEZ] breeze, freeze, sneeze, squeeze, wheeze, deepfreeze, unfreeze
[EGG] beggar, egg, legged, arpeggio, dreggy, pegged, reggae
[EIG] beige, eight, freight, neighbor, weigh, height, eigenvalues
[EIV] received, perceived, conceivable, deceive, reive, undeceive, apperceive
[EIZ] seize, disseize, marbleize, seized, seizer, seizes, seizure
[EKE] weekend, housekeeping, peeked, safekeeping, seeker, shekel, peke
[ELK] elk, welkin, whelk, gavelkind, elks, elkhound, whelks
[ELV] themselves, kelvin, twelve, ourselves, shelve, selves, velvet
[EMP] empty, exempt, hemp, temper, attempt, emphasis, empirical
[ENJ] benjamin, enjoin, basenji, enjambment, katzenjammer, unenjoyable, enjoy
[ENW] greenwood, enwind, enwomb, enwrap, openwork, ovenware, treenware
[ENZ] benzene, cadenza, frenzy, influenza, enzyme, coenzyme, credenza
[EOP] leopard, people, reopen, geophysics, jeopardize, pleopod, geoponic
[EPH] elephant, nephew, shepherd, ephemeral, aleph, telephone, zephyr
[EQU] equal, equip, sequel, request, frequency, subsequent, infrequent
[ESK] desktop, pesky, weskit, doeskin, esker, capeskin, copydesk
[ETW] between, network, retweets, wetware, fretwork, basketwork, streetwise
[EUX] euxenite, purlieux, religieux, hypozeuxis
[EVO] devote, evoke, evolve, revolt, irrevocable, elevon, rilievo
[EWI] piecewise, rewind, lewis, likewise, viewing, sidewinder, sewing
[EWY] chewy, dewy, sinewy, viewy, screwy, mildewy, thewy
[EXA] example, exact, inexact, hexadecimal, hexagram, exaggeration, hexahedron
[EXH] exhale, exhibit, exhume, exhort, reexhibit, exhaust, exhilarate
[EYB] keyboard, honeybee, moneybag, trolleybus, volleyball, keybindings, greyback
[EZE] squeeze, freeze, breeze, deepfreeze, unfreeze, frieze, sneeze
[EZZ] fezzes, mezzanine, muezzin, prezzie, embezzle, mezzotint, intermezzi
[FFL] baffle, muffle, raffle, shuffle, waffle, offline, riffle
[FFY] fluffy, jiffy, iffy, spiffy, chaffy, chuffy, cliffy
[FIZ] fizz, fizgig, hafiz, fizzed, fizzle, fizzles, fizzy
[FLI] flick, flight, fling, flip, conflict, offline, shuffling
[FTH] fifth, twelfth, tufthunter, softhearted, fifths, twelfths, fifthly
[FTY] fifty, lefty, shifty, nifty, crafty, crufty, drafty
[FUZ] fuzz, fuzzed, fuzzes, fuzzier, fuzzy, fuzzing, fuzzily
[GAZ] gaze, stargaze, magazine, gazpacho, gazing, gazump, newsmagazine
[GEY] bigeye, bugeye, geyser, bogey, cagey, pogey, fogeydom
[GGL] gaggle, giggle, goggle, juggle, wiggle, toggle, smuggle
[GHS] highs, neighs, laughs, thighs, troughs, outweighs, boughs
[GHT] bright, eight, fight, light, night, height, right
[GIZ] gizmo, gizzard, apologizes, elegize, energize, eulogize, analogize
[GLY] smugly, snuggly, squiggly, ugly, wiggly, glyphs, hieroglyph
[GNA] gnarl, gnash, gnat, gnaw, signal, designated, pregnant
[GNO] gnome, ignore, diagnostics, agnostic, segno, magnon, cognomen
[GSH] mugshot, eggshell, bigshot, flagship, grogshop, hogshead, kingship
[GUE] argue, league, plague, rogue, tongue, guess, prologue
[GYM] gym, bogyman, clergyman, junglegym, gymnast, gymnastics, gyms
[GYN] epigynous, hypogynous, gynecic, gynandry, gynarchy, misogyny, monogyny
[GYP] gyp, gypped, gypsy, gypsum, gypper, gypping, gypster
[HAW] shaw, thaw, rickshaw, mohawk, hawk, bashaw, hawser
[HAZ] hazard, haze, hazy, hazmat, chazan, hazily, ghazi
[HCH] highchair, ahchoo, pushchair, highchairs, pushchairs
[HEI] heifer, height, heinous, heir, heist, their, atheism
[HIV] archive, shiva, beehive, chive, hive, yeshiva, unchivalrous
[HLE] athlete, pamphlet, ruthless, worthless, branchless, phlegm, schlep
[HMA] asthma, bathmat, drachma, benchmark, ohmage, bushman, yashmak
[HMO] earthmover, fishmonger, ethmoid, schmo, shmooze, arithmomancy, schmoes
[HNO] ethnology, technology, ethnographic, schnoz, shnorrer, arachnoid, ichnology
[HOI] choice, hoist, echoing, anechoic, hoiden, hoick, lithoid
[HOK] choke, hokey, hokier, hokku, hokum, kazachok, artichoke
[HRU] shrub, thrush, subshrub, upthrust, hearthrug, preshrunk, pyrethrum
[HTF] delightful, insightful, rightfully, thoughtfully, eightfold, frightful, lightface
[HTH] eighth, diphtheria, ophthalmology, lighthouse, phthalein, monophthong, diphthongs
[HTY] eighty, mighty, naughty, lightyear, almighty, doughty, flighty
[HYL] methyl, ethylene, polyethylene, phylum, subphylum, superphylum, chyle
[HYM] hymn, thyme, rhyme, chyme, ecthyma, hymen, dysthymia
[HYP] hype, hyphen, hypnosis, hypothesis, hypotenuse, unhyphenated, hypogynous
[HYT] rhythmic, arrhythmia, epiphyte, geophyte, neophyte, trachyte, zoophyte
[IAL] dial, facial, material, social, trial, initial, special
[IAN] guardian, librarian, magician, musician, piano, valiant, variant
[IBB] dribble, gibbon, nibble, quibble, ribbon, scribble, cribbed
[ICE] dice, ice, mice, nice, spice, license, notice
[ICK] brick, chick, kick, quick, trick, pickle, tick
[IDG] bridge, fridge, midge, porridge, ridge, widget, cartridge
[IEU] adieu, lieu, milieu, purlieu, monsieur, banlieue, maieutic
[IEW] view, preview, overview, review, interview, purview, teleview
[IFF] cliff, diff, jiffy, sniff, stiff, tiff, riff
[IGH] bright, high, light, night, sight, height, right
[IGN] align, design, foreign, reign, sign, ignore, assign
[IJA] hijab, ouija, jipijapa, hijabs, hijack, hijacker, hijacking
[ILK] ilk, milk, silk, bilker, soymilk, devilkin, buttermilk
[ILL] bill, chill, hill, mill, skill, will, fill
[IMB] climb, imbue, limb, nimble, imbalance, gimbal, imbrication
[IMP] chimp, impact, limp, shrimp, simple, import, implied
[ING] bring, king, ring, sing, wing, string, using
[INK] blink, drink, link, pink, think, shrink, unlink
[INQ] inquire, relinquish, cinque, clinquant, chinquapin, delinquent, quinquefid
[INX] jinx, minx, sphinx, meninx, pinxit, syrinx, salpinx
[ION] action, lion, million, onion, potion, version, function
[IQU] antique, boutique, clique, liquid, unique, oblique, technique
[IRK] dirk, irk, quirk, shirk, smirk, firkin, chirk
[IRY] airy, fairy, expiry, hairy, dairy, glairy, inquiry
[ISH] dish, fish, polish, radish, wish, english, published
[ISM] optimism, prism, realism, tourism, organism, mismatch, mechanism
[IST] artist, fist, list, twist, wrist, dist, exist
[ITH] faith, pith, smith, with, either, algorithm, neither
[ITZ] blitz, glitz, kibitz, spritz, fritz, howitzer, britzka
[IVO] pivot, ivory, divorced, unequivocal, semivowel, survivors, omnivore
[IWI] kiwi, periwinkle, iwis, bailiwick, pilliwinks, contrariwise, kiwifruit
[IXE] fixed, mixed, pixel, prefixed, suffixes, postfixes, affixes
[IZO] horizontal, schizo, epizoa, chorizo, mestizo, rhizoid, recognizor
[IZZ] blizzard, dizzy, fizz, pizza, swizzle, quizzes, grizzly
[JAZ] jazz, jazzed, jazzes, jazzier, jazzy, jazzily, jazzman
[JEC] eject, inject, object, project, reject, subject, conjecture
[JER] jersey, jerry, jerky, jerboa, jerid, jeremiad, jeroboam
[JIG] jig, thingamajig, thingumajig, rejigs, jiggle, jigsaw, jigs
[JOC] jock, jocular, jocose, jockey, jockeys, jocks, jocund
[JOI] join, adjoint, disjoint, subjoined, conjoined, rejoin, nonjoiner
[JOU] joule, journal, joust, sojourn, kilojoule, megajoule, bijoux
[JUD] judge, judicial, judo, prejudice, unprejudiced, judder, adjudge
[JUG] conjugal, jug, bijugate, subjugate, unijugate, juggle, juggler
[JUX] juxtapose, juxtaposed, juxtaposes, juxtaposing, juxtaposition
[KAB] breakable, clickable, checkable, unbreakable, lockable, nonbreakable, kab
[KAI] kail, kaiser, kain, kaiak, kaif, polkaing, kaisers
[KAK] kakapo, kakemono, kaki, kaka, kakis
[KAL] alkali, kale, kali, kalpak, lookalike, jackal, kalmia
[KAN] kangaroo, kanji, katakana, kana, alkanes, kantar, askance
[KAP] kappa, kaph, kakapo, kapok, kaput, okapi, chinkapin
[KAY] kayak, kayo, okay, tokay, kayaks, okays, kayaking
[KAZ] kamikaze, kazoo, kazachok, kazoos, kamikazes
[KBA] trackball, taskbar, sickbay, workbag, brickbat, kickback, neckband
[KEB] kebab, kebob, ikebana, jukebox, chokebore, pokeberry, snakebird
[KEP] kept, skeptical, kepi, pikeperch, smokeproof, unkept, skepfuls
[KFU] thankfully, forkful, sackful, tankful, wreckful, chockfull, unthankful
[KHA] khaki, khan, backhand, kharif, charkha, khaddar, khamsin
[KIB] kibitz, kibosh, kibble, kiblah, skibob, kibe, kibitzer
[KIM] kimono, skimmer, akimbo, kimchi, hakim, dybbukim, kimberlite
[KIW] kiwi, skiwear, kiwifruit, kiwis, kiwifruits
[KKE] bookkeeping, grokked, likker, yakked, yukked, chukker, trekked
[KLA] klaxon, necklace, klatch, baklava, backlash, dockland, parkland
[KLU] kludge, klutz, kluge, mukluk, lackluster, klutzes, klutzier
[KMA] bookmark, checkmark, hackman, workman, junkman, kirkman, linkman
[KNA] knack, knapsack, knave, nickname, knawel, knapping, knapweed
[KNE] knead, knee, knell, knew, thickness, darkness, sickness
[KNI] knickers, knife, knight, knit, jackknife, knives, pyknic
[KNO] knob, knock, knoll, knot, know, unknown, acknowledge
[KNU] knuckle, knurl, locknut, knuckles, knuckled, knuckling, knur
[KOA] koala, skoal, koan, koalas, koa, skoals, koans
[KOI] koi, kois, koine, koines
[KOO] kook, cuckoo, koodoo, rockoon, kookaburra, kooks, kooky
[KOS] kos, arkose, skosh, nonkosher, dekkos, geckos, pinkos
[KRA] kraal, kraken, kraut, okra, kraft, buckra, krait
[KRI] krill, kris, krimmer, kukri, blitzkrieg, kriegspiel, blitzkriegs
[KRO] kroon, cockroach, krone, checkrow, darkroom, backroom, bankroll
[KST] lockstep, workstation, backstop, bookstore, kickstart, huckster, inkstand
[KUD] kudos, kudzu, kudu, kudzus, kudo, kudus
[KUM] kumquat, bunkum, kumiss, kummel, hokum, oakum, kumquats
[KWA] kwacha, kwanza, backward, awkward, shockwave, parkway, folkway
[KWE] inkwell, duckweed, hawkweed, milkweed, neckwear, rockweed, silkweed
[LAV] flavor, slave, lavender, clave, palaver, lava, lavish
[LCH] belch, filch, gulch, mulch, squelch, wheelchair, alchemical
[LDF] boldface, goldfish, wildfires, holdfast, baldfaced, fieldfare, oldfangled
[LEV] level, relevant, clever, levy, irrelevant, eleven, levin
[LFL] selfless, elfland, gallfly, damselfly, ballflower, bellflower, wallflower
[LGE] bilge, bulge, divulge, indulge, algebraic, fulgent, squilgee
[LIQ] clique, oblique, liquid, siliqua, aliquot, relique, applique
[LKE] walker, alkene, bilker, milker, talker, caulker, skulker
[LKY] bulky, chalky, milky, silky, sulky, alkyne, stalky
[LLF] gallfly, willful, billfish, bullfrog, fallfish, hellfire, skillful
[LLP] wallpaper, ballpoint, cellphone, ballparks, bullpen, millpond, smallpox
[LOV] love, rollover, clover, gloves, sloven, plover, beloved
[LPH] alpha, dolphin, sylph, cellphone, delphinium, telpher, sulphone
[LPT] sculpt, sculpted, sculptor, sculpture, sculptress, sculptural, sculpts
[LRY] rivalry, cavalry, devilry, jewelry, revelry, chivalry, hostelry
[LTH] filth, health, stealth, wealth, although, commonwealth, maltha
[LTS] results, defaults, faults, alts, segfaults, halts, volts
[LTZ] schmaltz, waltz, seltzer, waltzed, waltzer, waltzes, schmaltzy
[LUX] deluxe, flux, influx, lux, afflux, efflux, hallux
[LVI] kelvin, solving, involving, resolving, halving, shelving, revolving
[LYB] flyback, molybdenum, jellybean, bullyboy, mealybug, bellyband, chalybite
[LYM] lymph, polymorphic, copolymer, flyman, tallyman, endolymph, ginglymus
[LYN] lynch, lynx, polynomial, slyness, polynuclear, polyneuritis, lynched
[LYR] lyric, lyre, lyrate, ballyrag, bullyrag, collyrium, jellyroll
[MAK] make, making, mako, remake, pacemaker, policymaker, comake
[MAZ] amaze, maze, mazy, mazard, mazuma, mazzard, smaze
[MBL] amble, crumble, fumble, humble, tumble, preamble, ensemble
[MBR] cambric, embrace, membrane, sombrero, umbrella, imbrication, hombre
[MBU] ambush, combust, humbug, nimbus, hamburg, rhombus, imbue
[MEZ] mezcal, mezzanine, timezone, mezuza, mezereon, mezzotint, intermezzi
[MIX] mixed, mixture, mixing, remix, intermixed, unmixed, commix
[MNE] amnesia, mnemonic, randomness, columned, chimney, dimness, calmness
[MOI] chamois, memoir, moist, turmoil, sigmoid, moire, demoiselle
[MOV] remove, move, moving, movable, earthmover, immovable, unmoved
[MPH] lymph, nymph, oomph, pamphlet, triumph, emphasis, amphibious
[MSH] clamshell, cumshaw, gumshoe, camshaft, dramshop, almshouse, scrimshaw
[MUZ] muzzle, muzhik, muzak, unmuzzle, muzzled, muzzles, muzzling
[MYR] myriad, myrrh, myrtle, myrmidon, tommyrot, myrobalan, myrmecology
[MYT] myth, stichomythia, mythic, mythical, mythology, myths, mythological
[NAI] fingernail, hobnail, nail, naive, snail, thumbnail, naira
[NAK] snake, naked, kanaka, canakin, manakin, nakfa, spinnaker
[NCH] bench, branch, crunch, lunch, punch, anchor, launchpad
[NCL] include, enclosed, unclear, conclusion, nomenclature, concluding, inconclusive
[NDF] handful, mindful, grandfather, sandfly, landfall, windfall, blindfish
[NDL] bundle, candle, dwindle, handle, spindle, friendly, unhandled
[NDP] endpoint, endpaper, grandparent, standpoint, sandpaper, handpick, windpipe
[NEW] new, renew, anew, knew, kilonewton, sinewy, foreknew
[NFR] infringement, infrequent, mainframe, unfrozen, unfreeze, confronted, unfriendly
[NGA] conga, hangar, kangaroo, manga, tonga, engaged, ingather
[NGH] dinghy, gingham, stronghold, shanghai, longhair, binghi, bunghole
[NGT] length, strength, wavelength, longtime, wellington, wingtip, bangtail
[NGU] anguish, distinguish, language, penguin, tongue, singular, triangular
[NIV] university, omnivore, carnivore, univalence, knives, snivel, connive
[NJA] ninja, unjam, benjamin, sanjak, ganja, popinjay, panjandra
[NKH] ankh, inkhorn, lunkhead, monkhood, sinkhole, bunkhouse, stinkhorn
[NKL] ankle, crinkle, sprinkle, twinkle, wrinkle, franklin, periwinkle
[NKY] funky, inky, clunky, wonky, chunky, cranky, stinky
[NOW] unknown, now, known, snowman, acknowledge, unowned, renowned
[NQU] banquet, conquer, jonquil, tranquil, vanquish, unquote, enqueue
[NRY] henry, weaponry, almonry, canonry, felonry, heronry, masonry
[NSM] transmission, transmitted, transmogrify, transmuter, kinsmen, nonsmokers, retransmits
[NTH] anthem, month, ninth, panther, tenth, parenthesis, seventh
[NTW] entwine, intwine, bentwood, frontward, jointworm, lintwhite, paintwork
[NTZ] chintz, blintz, chintzy, blintze, chintzily, blintzes, chintzier
[NUA] annual, manual, nuance, continuation, attenuator, sinuate, biannual
[NUD] nudge, denude, nudism, nudnik, nudest, nudged, nudges
[NUZ] nuzzle, nuzzled, nuzzles, nuzzling, nuzzler, nuzzlers
[NVO] invoke, convolve, envoy, renvoi, unvoice, nonvocal, uninvolved
[NXE] jinxed, lynxes, minxes, sphinxes, syrinxes, phalanxes, salpinxes
[NYL] nylon, vinyl, carbonyl, phenyl, uranyl, nylghau, biphenyl
[NYM] acronym, antonym, homonym, nymph, synonym, anonymous, anymore
[NYX] onyx, sardonyx, onyxes, sardonyxes
[NZE] nonzero, bronze, benzene, quinze, panzer, bonze, winze
[NZY] frenzy, benzyl, bronzy, enzyme, coenzyme, apoenzyme, exoenzyme
[OAK] cloak, croak, oak, soak, presoak, uncloak, oaken
[OAR] boar, hoard, oar, roar, clipboard, keyboard, checkerboard
[OAS] boast, coast, oasis, roast, toast, oast, moas
[OBL] goblin, noble, oblique, oblong, problem, subproblem, oblate
[OBO] hobo, oboe, robot, nobody, bonobo, lobo, corroborated
[OCH] brooch, epoch, loch, mocha, ochre, stochastic, pooch
[OCT] doctor, nocturnal, octagon, octopus, octet, ioctl, octuple
[ODD] odd, plodded, toddler, dodder, goddess, shoddy, modding
[OEB] amoeba, phoebe, roebuck, shoebox, woebegone, amoebae, amoebas
[OEV] whatsoever, whoever, coeval, soever, howsoever, whosoever, whensoever
[OFF] coffee, off, scoff, cutoff, unofficial, payoff, runoff
[OFT] aloft, loft, oft, soft, semisoft, zoftig, croft
[OGL] ogle, google, hieroglyph, dogleg, ogling, goglet, bogle
[OGU] catalogue, dialogue, mogul, rogue, vogue, bogus, prologue
[OHM] ohm, megohm, abohms, ohmic, ohms, ohmmeter, ohmage
[OID] android, asteroid, avoid, cuboid, thyroid, void, centroid
[OIL] boil, broil, coil, foil, oil, spoiler, toil
[OIN] coin, join, oink, point, doing, endpoint, adjoint
[OIS] hoist, moist, noise, poison, tortoise, turquoise, croissant
[OIT] adroit, exploit, goiter, loiter, quoits, doit, droit
[OKR] okra, bookrack, okras, bookrest
[OKS] hooks, looks, books, notebooks, groks, textbooks, brooks
[OLF] golf, olfactory, wolf, aardwolf, werewolf, woolfell, rauwolfia
[OLK] folk, polka, yolk, toolkit, kinfolk, kolkhoz, menfolk
[OLP] dolphin, foolproof, colpitis, holp, volplane, woolpack, colpotomy
[OLY] holy, monopoly, polyglot, polynomial, polymorphic, polyhedron, polycyclic
[OMB] bomb, comb, tomb, womb, zombie, coulomb, rhombus
[OMN] insomnia, omnibus, somnolent, randomness, buxomness, somniloquy, somniferous
[OMP] chomp, company, pomp, stomp, prompt, incompatible, incomplete
[ONG] along, belong, long, song, strong, wrong, among
[ONK] bonk, donkey, honk, monk, wonky, plonk, clonk
[ONW] commonwealth, onward, ironware, moonwalk, nonwhite, nonwoven, buttonwood
[ONY] agony, bony, colony, harmony, pony, acronym, anonymous
[ONZ] bronze, nonzero, gonzo, bonze, monzonite, bronzed, bronzer
[OOD] blood, food, good, mood, wood, likelihood, neighborhood
[OOF] goof, hoof, proof, roof, spoof, oof, woof
[OOK] book, cook, hook, look, shook, workbook, handbook
[OOL] cool, fool, pool, school, tool, boolean, spool
[OOM] bloom, boom, broom, gloom, room, zoom, mushroom
[OON] balloon, cartoon, moon, raccoon, spoon, harpoon, noon
[OOP] coop, droop, hoop, loop, scoop, oops, poop
[OOR] door, floor, moor, poor, spoor, coordinate, boor
[OOS] boost, choose, goose, loose, moose, bamboos, swoosh
[OOT] boot, foot, hoot, root, shoot, smooth, uproot
[OOZ] booze, ooze, oozing, woozy, snooze, floozy, foozle
[OPA] opal, opaque, topaz, copaiba, opacity, propagate, leopard
[OPH] gopher, sophomore, trophy, xylophone, apostrophe, microphone, philosophy
[OQU] baroque, croquet, eloquent, loquacious, soliloquy, loquitur, colloquial
[ORB] absorb, orbit, sorbet, morbid, forbidden, colorblind, orbs
[OSM] cosmos, osmosis, microcosm, macrocosm, osmium, anosmia, osmunda
[OTH] bother, brother, cloth, moth, tooth, other, another
[OTY] prototype, monotype, autotype, logotype, genotype, stereotypes, snooty
[OUG] bought, cough, dough, rough, through, enough, though
[OUI] ouija, bouillon, louis, bedouin, ratatouille, oui, bouilli
[OUL] could, foul, ghoul, should, soul, would, joule
[OUN] bounce, found, mountain, round, sound, count, background
[OUP] coupe, croup, group, soup, troupe, subgroup, uncouple
[OUR] course, flour, four, hour, pour, source, your
[OUS] curious, famous, house, mouse, nervous, previous, various
[OUT] about, out, scout, shout, trout, without, layout
[OWA] towards, allowable, nowadays, throwaway, unknowable, rowan, kilowatt
[OWF] blowfish, snowflake, bowfin, cowfish, crowfeet, marrowfat, snowfield
[OWM] snowman, bowman, endowments, cowman, plowman, showman, fellowman
[OWY] snowy, yellowy, arrowy, bowyer, billowy, blowy, meadowy
[OXY] boxy, epoxy, foxy, oxygen, proxy, doxy, hematoxylin
[OYE] destroyed, employee, deployed, unemployed, annoyed, enjoyed, voyeur
[OYS] boys, enjoys, joys, oyster, toys, employs, destroys
[OZE] booze, doze, frozen, ooze, lozenge, unfrozen, snooze
[OZO] ozone, protozoan, bozo, rebozo, entozoa, bryozoan, holozoic
[OZY] boozy, cozy, dozy, oozy, woozy, floozy, doozy
[OZZ] nozzle, schnozzle, sozzled, mozzetta, mozzarella, nozzles, schnozzles
[PAV] paved, pavane, paving, spavin, pavlova, pavonine, papaverine
[PEX] apex, auspex, tippex, aruspex, perspex, haruspex, epexegesis
[PHA] alpha, elephant, phantom, pharmacy, phase, emphasis, orphans
[PHE] cipher, gopher, pheasant, sphere, shepherd, hyphen, encipher
[PHI] amphibian, dolphin, graphite, philosophy, sapphire, isomorphic, pictographic
[PHL] pamphlet, phlegm, phlox, nymphlike, phlyctena, sylphlike, phloem
[PHO] megaphone, phone, photo, siphon, symphony, phoenix, semaphore
[PHR] diaphragm, phrase, paraphrase, phrenic, rephrase, tephra, uphroe
[PHT] diphtheria, naphtha, ophthalmology, phthisic, phthalein, monophthong, diphthongs
[PHY] atrophy, hypertrophy, physics, trophy, zephyr, bibliography, cryptography
[PIZ] pizza, epizoa, pizzas, pizzazz, pizzeria, pizzicato, epizoic
[PNE] apnea, dyspnea, pneumatic, pneumonia, sharpness, steepness, grapnel
[POI] appoint, point, poise, spoil, endpoint, midpoint, checkpoint
[POK] spokes, poke, poking, bespoke, cowpoke, kapok, yapok
[PPL] apple, grapple, nipple, ripple, topple, supplied, pineapple
[PRY] pry, spry, gossipry, prying, spryer, spryest, spryness
[PSA] psalm, knapsack, ripsaw, hopsack, sapsago, topsail, whipsaw
[PSE] collapse, eclipse, lapse, pseudo, relapse, ellipse, elapsed
[PSH] snapshot, upshot, pshaw, peepshow, slipshod, crapshoot, lampshade
[PSI] capsicum, epsilon, psi, upside, ellipsis, synopsis, collapsing
[PSY] autopsy, biopsy, gypsy, psychic, tipsy, dropsy, epilepsy
[PTE] chapter, helicopter, pterodactyl, pterosaur, scepter, adapted, accepted
[PTO] kleptomania, krypton, laptop, tiptoe, descriptor, cryptography, asymptotic
[PTR] uptrend, calyptra, claptrap, dioptric, temptress, catoptrics, sculptress
[PTY] empty, nonempty, diptych, ptyalin, triptych, anaptyxis, polyptych
[PUZ] puzzle, puzzled, puzzler, puzzles, puzzling, puzzlement, puzzlers
[PYG] pygmy, pygidium, spyglass, uropygium, callipygean, steatopygia, pygmies
[PYI] copying, occupying, photocopying, spying, espying, canopying, recopying
[PYR] pyre, pyramid, pyrite, pyromania, copyright, papyrus, pyrrhic
[PYX] pyx, pyxes, pyxie, pyxidium, pyxies
[QUA] quack, quake, quality, quarter, equal, square, quad
[QUE] bouquet, queen, quest, queue, sequence, request, unique
[QUI] quick, quiet, quill, quiz, required, equivalent, quiver
[QUO] quoits, quorum, quota, unquote, quod, turquoise, sequoia
[RAX] praxis, borax, anthrax, storax, styrax, thorax, abraxas
[RAZ] craze, graze, razor, razz, brazil, raze, frazil
[RBS] barbs, absorbs, verbs, orbs, blurbs, adverbs, disturbs
[RCH] arch, birch, church, march, torch, search, hierarchy
[RDL] regardless, hardly, weirdly, thirdly, absurdly, cowardly, awkwardly
[REJ] reject, prejudicial, rejoin, unprejudiced, aparejo, forejudge, rejuvenate
[REY] palfrey, surrey, prey, murrey, osprey, comfrey, greyhen
[RGE] barge, charge, forge, large, merge, target, surge
[RGR] evergreen, wintergreen, undergrad, burgrave, hairgrip, margrave, overgrew
[RHA] rhapsody, rhatany, perhaps, overhang, underhanded, dirham, rhachis
[RHE] diarrhea, rhea, rhetoric, rheumatism, overhead, letterhead, superhero
[RHI] rhino, rhizome, errhine, pyrrhic, murrhine, rhigolene, catarrhine
[RHO] rhododendron, rhomb, neighborhood, rhodamine, rhos, orthorhombic, barhop
[RHY] rhyme, rhythm, arrhythmia, rhyolite, biorhythm, eurhythmy, unrhythmic
[RIX] matrix, directrix, rectrix, tectrix, varix, aviatrix, cicatrix
[RIZ] drizzle, frizz, grizzly, horizon, parametrize, vectorized, factorize
[RKL] darkling, sparkle, workload, corklike, forklift, parkland, schnorkle
[RKS] works, marks, landmarks, networks, trademarks, benchmarks, remarks
[RLY] early, underlying, curly, properly, clearly, similarly, formerly
[RMP] armpit, stormproof, armpits
[RNL] hornless, patternless, sternly, modernly, forlornly, slatternly, southernly
[ROI] adroit, android, asteroid, broil, centroid, steroid, spheroidal
[ROX] approx, proxy, xerox, hydroxyl, peroxide, tetroxide, paroxysm
[RPH] amorphous, morph, orphan, polymorph, isomorphic, meromorphic, homomorphism
[RPR] interpreter, fingerprint, overprint, surprising, enterprise, reinterpret, misinterpret
[RQU] marquee, torque, turquoise, parquet, remarque, cirque, charqui
[RRH] catarrh, cirrhosis, diarrhea, hemorrhage, myrrh, arrhythmia, errhine
[RRY] carry, sorry, berry, worry, blackberry, cherry, curry
[RSP] perspective, interspersed, airspeed, forspent, superspy, fluorspar, hairspray
[RTH] birth, earth, fourth, north, worth, further, orthogonal
[RTN] partnership, shortness, curtness, pertness, tartness, alertness, copartner
[RTZ] hertz, megahertz, quartz, gigahertz, kilohertz, terahertz, quartzite
[RVA] interval, observations, curvature, conservative, preservation, pervasive, unobservable
[RWE] overweight, underweight, interweave, spiderweb, burweed, forwent, tarweed
[RYA] rya, dryad, carryall, caryatid, dooryard, hamadryad, lumberyard
[RYM] corymb, juryman, tryma, dairyman, everyman, ferryman, lacrymal
[RYN] larynx, pharynx, dryness, eryngo, wryneck, spryness, nasopharynx
[RYP] crypt, encrypt, krypton, decrypt, tryptophan, drypoint, apocrypha
[RYS] chrysalis, crystal, tryst, aneurysm, drys, xenocryst, chrysolite
[RZA] sforzando, mirza, forzando, scherzando, sforzati, sforzato, sforzandi
[RZO] borzoi, scherzo, orzo, borzois, scherzos
[SAK] sake, namesake, forsake, keepsake, moussaka, godforsaken, unforsaken
[SAU] dinosaur, sauna, sausage, saute, saucer, assault, sauropod
[SCH] scheme, scholar, schnitzel, schwa, eschar, reschedule, kirsch
[SCI] conscience, fascinate, science, scissors, oscillator, discipline, abscissa
[SCL] disclaimer, muscle, disclosed, sclera, mascle, sclaff, mesclun
[SCR] scrap, scream, description, script, discrete, subscript, superscript
[SCU] scuba, scuff, sculpt, scurry, discussion, masculine, obscured
[SEY] jersey, bullseye, odyssey, causey, horsey, kersey, malmsey
[SHA] shadow, shake, shape, shark, reshape, shall, marshal
[SHE] shed, sheep, shelf, published, furnished, dashed, hashes
[SHI] shield, shift, shine, ship, shirt, relationship, ownership
[SHL] freshly, flashlight, foolishly, stylishly, ashlar, fleshly, bushland
[SHO] shock, shoe, shoot, shop, short, should, show
[SHR] shred, shriek, shrub, mushroom, shrank, enshrine, ashram
[SHU] shuck, shudder, shuffle, shun, shut, shushing, shul
[SHW] bushwa, dishware, fishwife, meshwork, brushwood, washwoman, freshwater
[SHY] ashy, bushy, fishy, flashy, shy, pushy, fleshy
[SIZ] capsize, sizable, size, sizzle, resize, parenthesize, sizing
[SKA] skate, rollerskate, askance, boskage, britska, skald, saskatoon
[SKE] skeet, skeleton, sketch, skewer, skeptic, masked, asked
[SKI] ski, asking, masking, risking, multitasking, unmasking, buskin
[SKU] skua, skulk, skunk, numskull, skull, skunks, skullcap
[SKY] dusky, husky, pesky, risky, sky, frisky, bosky
[SLY] grisly, sly, previously, expressly, grossly, obviously, analogously
[SMA] dismal, small, smart, smash, smatter, mismatch, plasma
[SME] smear, smell, cosmetic, assessment, smegma, kinsmen, busmen
[SMI] smile, smirk, smite, transmission, dismiss, transmitted, cosmic
[SMO] smock, smog, smoke, smolder, smooth, transmogrify, cosmology
[SMU] smug, smudge, smut, transmute, bismuth, smurf, inasmuch
[SNA] snack, snag, snail, snake, snap, misnamed, snare
[SNE] sneak, sneer, fresnel, seriousness, recklessness, puisne, demesne
[SNI] snicker, sniff, snip, persnickety, snider, snitch, snivel
[SNO] snob, snoop, snore, snow, snout, misnomer, snot
[SNU] snub, snuff, snug, misnumber, snuggle, snuggles, snuffy
[SOI] soil, soiree, topsoil, sinusoidal, ellipsoid, vichyssoise, assoil
[SOU] soul, sound, soup, sour, south, resource, sought
[SPA] space, spade, spark, spatula, whitespace, span, dispatch
[SPE] speak, special, speed, spell, aspect, inspect, respect
[SPH] asphalt, atmosphere, sphere, sphinx, biosphere, hemisphere, phosphorus
[SPI] spice, spider, spike, spill, spin, spirit, despite
[SPL] splash, splendid, splinter, splurge, display, splitter, misplaced
[SPO] spoil, spoke, sponge, spoon, sport, response, transpose
[SPR] sprain, spread, spring, newsprint, sprockets, spruce, misprint
[SPU] spud, spume, spun, spur, disputes, sputnik, transputer
[SPY] crispy, espy, spy, wispy, raspy, superspy, counterspy
[SQU] squad, squid, squeeze, basque, risque, bisque, mosque
[SSF] successful, unsuccessful, blissful, glassful, crossfire, stressful, distressful
[SSH] crosshatch, glasshouse, misshape, dosshouse, transship, grasshopper, crossheads
[SSP] misspelled, passport, cesspit, fusspot, tosspot, grassplot, misspoken
[STA] stack, stage, stair, stamp, star, state, distance
[STE] steak, steel, step, system, instead, register, nested
[STF] postfix, restful, boastful, trustful, breastfed, fistful, lustful
[STH] aesthetic, asthma, isthmus, masthead, sthenic, dustheap, esthesia
[STI] stick, stiff, still, sting, stir, estimator, testing
[STL] bristle, castle, nestle, rustle, whistle, mostly, costly
[STO] stock, stomach, stone, stool, stop, custom, store
[STR] straight, street, strong, string, distributed, structure, construct
[STU] stubborn, student, stuff, gesturing, stupid, stuck, postulate
[STY] crusty, dusty, frosty, rusty, style, amnesty, nasty
[SUI] pursuit, suit, lawsuit, issuing, unsuitable, swimsuit, ensuing
[SWA] swallow, swamp, swan, swap, swarm, swash, swain
[SWE] swear, sweep, answer, bittersweet, swept, minesweeper, swelled
[SWI] swift, swim, swing, swipe, switch, swig, swizzle
[SWO] swollen, swoon, sword, password, guesswork, crossword, swot
[SYI] gypsyish, sissyish, busying, gussying, palsying, biopsying, curtsying
[SYM] symbol, symmetry, sympathy, symphony, asymptotic, asymmetric, symposium
[SYN] sync, syndicate, syndrome, synonym, syntax, asynchronous, synagogue
[SYR] syringe, syrup, syrupy, syrinx, syringa, syrups, syringas
[TAV] octave, ottava, staves, taverna, atavism, centavo, palstave
[TBR] flatbread, paintbrush, heartbroken, nutbrown, outbrave, footbridge, shortbread
[TCH] catch, kitchen, match, pitch, watch, batch, patch
[THA] thank, that, thaw, lethal, shorthand, futhark, enthalpy
[THE] theater, theme, there, these, weather, other, either
[THF] pathfinder, faithful, truthful, youthful, mouthful, ruthful, deathful
[THI] thick, thief, thigh, thing, this, within, nothing
[THL] athlete, breathless, deathless, ruthless, toothless, monthly, smoothly
[THM] asthma, isthmus, logarithm, rhythm, algorithm, arithmetic, earthmover
[THO] thorn, those, though, method, python, without, author
[THR] thread, thrill, throat, thrust, thrash, anthrax, arthropod
[THU] thud, thug, thumb, thunder, thus, thulium, enthusiasm
[THW] bathwater, earthworm, northward, southward, thwart, pathway, athwart
[THY] earthy, healthy, thyme, worthy, thyristor, timothy, methyl
[TIO] action, motion, nation, potion, station, function, option
[TIZ] baptize, citizen, sanitize, tizzy, magnetize, quantize, digitize
[TLE] battle, bottle, castle, little, turtle, title, subtitle
[TLY] bluntly, brightly, gently, quietly, softly, directly, currently
[TOI] stoic, toil, tortoise, repertoire, patois, entoil, cestoid
[TOK] token, stokes, betoken, tokay, cytokines, foretoken, tokoloshe
[TOU] detour, touch, tough, tour, contour, tout, cutout
[TRA] track, trade, train, trap, travel, extra, transform
[TRE] treasure, tree, tremble, trend, stream, upstream, extreme
[TRI] triangle, tribe, trick, trim, trip, string, matrix
[TRO] troll, trombone, troop, trophy, trout, controls, stroke
[TRU] truck, true, truffle, trumpet, trunk, structure, construct
[TRY] country, entry, pantry, pastry, try, geometry, registry
[TSH] nutshell, hotshot, potshot, outshine, cadetship, courtship, dustsheet
[TSK] tsk, britska, goatskin, outskirt, tsked, tsking, tsks
[TSU] tsunami, catsuit, jujitsu, netsuke, satsuma, shiatsu, wetsuit
[TSY] curtsy, tootsy, antsy, artsy, ditsy, gutsy, patsy
[TTL] battle, bottle, cattle, kettle, little, nettle, settle
[TUA] actual, mutual, ritual, virtual, punctuation, perpetual, situation
[TUX] tux, tuxedo, tuxedos, tuxes
[TWA] twain, twang, outward, software, leftwards, rightwards, partway
[TWE] tweak, tweed, twelve, twenty, between, lightweight, retweets
[TWI] twice, twig, twilight, twin, twist, twitter, twirl
[TWO] artwork, network, two, trustworthy, driftwood, cutwork, notwork
[TYI] tying, emptying, partying, untying, guarantying, pitying, fortyish
[TYP] atypical, prototype, type, typical, typo, subtype, datatype
[TZA] matzah, tzar, quetzal, tzatziki, matzahs, tzars, tzarina
[TZE] blitzes, pretzel, waltzes, howitzer, kreutzer, seltzer, blintze
[TZI] glitzier, ritzier, futzing, deutzia, hoatzin, hoactzin, tzatziki
[UAL] actual, annual, equal, manual, usual, individual, mutual
[UCH] couch, much, ouch, pouch, touch, such, gauche
[UCK] buck, duck, luck, stuck, truck, struck, suck
[UCT] conduct, deduct, duct, product, structure, construct, reduction
[UDD] buddy, cuddle, huddle, muddy, puddle, suddenly, cruddy
[UDG] budge, fudge, grudge, judge, nudge, kludge, bludge
[UED] argued, blued, clued, glued, queued, valued, issued
[UEL] cruel, duel, fuel, gruel, sequel, uniquely, valueless
[UFF] bluff, fluff, muffin, puff, stuff, buffer, suffix
[UGG] buggy, juggle, luggage, nugget, smuggle, debugging, suggested
[UGH] cough, dough, laugh, rough, through, enough, though
[UGL] bugle, ugly, ugliness, euglena, fugleman, smugly, snugly
[UID] druid, fluid, guide, liquid, squid, quid, equidistant
[UIL] build, guilt, quill, tranquil, rebuild, equilibrium, prebuilt
[UIN] genuine, guinea, penguin, ruin, squint, quinone, issuing
[UIR] acquire, inquire, quirk, require, squirm, reacquire, faquir
[UIS] bruise, cruise, cuisine, disguise, squishy, distinguish, louis
[UIT] biscuit, circuit, fruit, guitar, suit, quite, ambiguity
[UIZ] quiz, prologuize, soliloquize, quizzed, quizzes, quizzical, quizzing
[UKE] duke, fluke, jukebox, nuke, puke, lukewarm, peruke
[UKI] puking, kabuki, bouzouki, dybbukim, rebuking, sukiyaki, interleukin
[ULB] bulb, mulberry, flashbulb, bulbous, bulbs, bulbar, bulbil
[ULC] fulcrum, mulch, ulcer, inculcating, dulcet, sulcus, culch
[ULD] boulder, cauldron, could, shoulder, would, pauldron, gulden
[ULF] engulf, gulf, sulfur, fulfill, disulfide, ingulf, soulful
[ULG] bulge, divulge, indulge, vulgar, fulgor, effulgent, refulgent
[ULK] bulk, hulk, skulk, sulk, caulk, yarmulka, bulky
[ULL] bull, full, gull, pull, skull, null, successfully
[ULN] ulna, vulnerable, usefulness, helpfulness, youthfulness, foulness, awfulness
[ULP] gulp, pulp, sculpt, culprit, exculpate, vulpine, sulphone
[ULT] adult, cult, fault, insult, result, default, multi
[ULV] culvert, pulverize, vulva, fulvous, pulvinus, griseofulvin, vulvae
[UMB] crumb, dumb, humble, number, thumb, renumber, umbrella
[UMP] bump, clump, jump, pumpkin, stump, assumptions, dump
[UNC] bunch, crunch, hunch, lunch, punch, function, launchpad
[UND] around, bundle, found, ground, hundred, under, bound
[UNG] bungle, hung, jungle, lung, young, rung, sung
[UNI] juniper, tunic, unicorn, uniform, unique, union, unit
[UNK] bunk, chunk, dunk, junk, skunk, unknown, shrunk
[UNQ] unquote, unquoted, unqualified, unquoting, unquotes, unquiet, unquenchably
[UNT] aunt, blunt, count, hunt, mount, until, runtime
[UOR] fluoride, liquor, quorum, languor, septuor, hydrofluoric, inquorate
[UOT] quota, unquote, duotone, aliquot, misquote, underquote, quotas
[UPL] couple, duplex, quadruple, quintuple, upland, tuple, upload
[UPP] cuppa, guppy, puppet, supper, upper, unsupported, uppity
[UPY] occupy, croupy, syrupy, soupy, chirrupy, preoccupy, reoccupy
[URB] curb, disturb, suburb, turban, urban, perturb, blurb
[URC] church, lurch, purchase, source, urchin, resource, outsource
[URD] absurd, curd, hurdle, murder, sturdy, surd, burden
[URF] scurf, surf, turf, smurf, subsurface, curfew, furfur
[URG] burger, purge, surge, urgent, hamburg, hourglass, liturgical
[URK] lurk, murky, turkey, burke, mazurka, lurked, lurker
[URL] burl, curl, furl, hurl, purl, hourly, churl
[URN] burn, churn, return, turn, urn, furnace, journal
[URP] burp, purple, slurp, surpass, usurp, murphy, multipurpose
[URR] burrow, curry, furry, hurry, purr, recurrence, occurred
[URS] burst, curse, nurse, purse, recursion, course, occurs
[URT] blurt, court, curtain, hurt, turtle, further, fourth
[URV] curve, scurvy, survey, purvey, incurve, excurved, outcurve
[USC] muscle, manuscript, obfuscate, susceptible, minuscule, majuscule, tusche
[USH] blush, brush, crush, mushroom, push, flush, hushed
[USK] dusk, husk, musk, tusk, busk, rusk, mollusk
[UST] crust, dust, gust, must, rust, custom, just
[UTC] butcher, clutch, crutch, dutch, hutch, outcome, nautch
[UTH] author, mouth, ruth, south, truth, azimuth, unauthorized
[UTT] butter, clutter, flutter, mutter, pushbutton, putting, gutter
[UTZ] chutzpah, klutz, putz, futz, kreutzer, halutz, chalutz
[UUM] continuum, residuum, vacuum, muumuu, duumvir, menstruum, vacuums
[UVA] kuvasz, louvar, couvade, helluva, adjuvant, pyruvate, uvarovite
[UVE] duvet, juvenile, louver, rejuvenate, souvenir, mauve, cuvette
[UVU] uvula, vuvuzela, uvular, uvulas, uvulitis, uvulars, vuvuzelas
[UXE] deluxe, fluxes, tuxes, auxeses, euxenite, luxe, cruxes
[UXO] uxorial, buxom, auxochrome, uxorious, buxomness, uxoricide, uxoriousness
[UZE] cruzeiro, gauze, ouzel, suzerain, vuvuzela, douzepers, schnauzer
[UZZ] buzz, fuzz, guzzle, muzzle, puzzle, huzzah, nuzzle
[VAC] evacuate, vacant, vacuum, privacy, vaccine, vivace, medevac
[VAI] available, unavailable, prevailing, vain, travail, vair, vaivode
[VAL] avalanche, carnival, festival, oval, valley, value, invalid
[VAM] vamp, revamp, vamoose, gravamen, vambrace, vampire, vampires
[VAN] advance, caravan, van, relevant, irrelevant, observance, disadvantage
[VAP] evaporate, vapor, vapid, vape, vaporize, vapors, vapory
[VEG] vegetable, vegan, vegged, lovegrass, waveguide, revegetate, vegeburger
[VEL] bevel, gravel, level, novel, velvet, unravel, ravel
[VEN] adventure, eleven, event, oven, seven, given, vendor
[VER] beaver, clover, every, river, silver, version, convert
[VES] gloves, harvest, invest, vest, waves, gives, derivatives
[VEX] convex, vex, biconvex, vexation, vexed, vexes, convexity
[VEY] survey, convey, slavey, graveyard, garvey, jarvey, peavey
[VID] provided, divide, individual, video, evidence, subdivide, vivid
[VIE] movie, preview, review, view, overview, vier, heavier
[VIG] invigorate, navigate, vigil, vigor, vignette, vigesimal, levigate
[VIL] anvil, civil, devil, evil, village, curvilinear, heavily
[VIN] divine, vine, vintage, having, moving, giving, removing
[VIO] obvious, ravioli, violet, behavior, previous, devious, oblivious
[VIR] environ, viral, virgin, virtual, virus, viridian, duumvir
[VIS] advise, invisible, supervise, visible, division, revision, visual
[VIV] revive, survive, viva, vivid, convivial, redivivus, vive
[VIX] vixen, cervix, vixens, vixenish, vixenishly
[VIZ] vizier, relativize, vizard, previze, vizcacha, misadvize, passivize
[VOC] advocate, avocado, vocal, irrevocable, invocation, revocation, havoc
[VOD] vodka, vaivode, vodkas
[VOG] vogue, levogyrate, vogues, voguish
[VOI] avoid, devoid, invoice, voice, void, reservoir, unavoidable
[VOL] evolve, involve, volcano, volley, volume, voltage, convolve
[VOO] voodoo, voodoos, voodooism, voodooed, voodooing
[VOR] carnivore, flavor, herbivore, ivory, favor, unfavorable, divorced
[VOS] provost, avos, mikvos, bravos, salvos, servos, octavos
[VOU] devour, nervous, rendezvous, vouch, fulvous, avouch, bivouac
[VOW] avow, disavow, vow, semivowel, advowson, unavowed, vowed
[VOY] convoy, envoy, voyage, voyeur, savoy, clairvoyant, voyager
[VRO] vroom, chevron, vroomed, vrooming, vrooms, chevrotain, chevrons
[VUL] convulse, revulsion, vulgar, vulture, vulnerable, uvular, ovular
[WAB] allowable, drawable, viewable, unknowable, renewable, reviewable, wabbit
[WAC] wack, kwacha, thwack, swacked, greywacke, wackier, wacko
[WAF] waft, wafer, waffle, wafted, waffles, waffled, waffler
[WAG] bandwagons, swag, wag, cowage, sewage, towage, wigwag
[WAI] waist, wait, waive, await, swain, twain, wainwright
[WAK] awake, wake, waking, reawake, rewaken, kittiwake, unawakened
[WAL] boardwalk, sidewalk, walk, wall, walnut, swallow, firewall
[WAM] swamp, wampum, wamble, wigwam, wame, swampy, swami
[WAN] swan, wand, want, wane, allowance, unwanted, waning
[WAR] award, dwarf, forward, swarm, warm, software, warning
[WAS] wash, wasp, waste, wasabi, swash, rewash, awash
[WAT] kilowatt, swatch, watch, water, watt, stopwatch, underwater
[WAV] microwave, wave, wavy, waving, shockwave, airwave, heatwave
[WAX] beeswax, earwax, wax, paxwax, woadwaxen, woodwaxen, waxed
[WAY] always, away, highway, pathway, way, anyway, midway
[WDE] powder, crowded, chowder, gunpowder, uncrowded, belowdecks, lewder
[WEA] sweat, weak, wealth, weapon, weather, tweak, wearing
[WEB] cobweb, web, spiderweb, webcam, webpage, website, weber
[WED] wed, allowed, followed, viewed, shadowed, disallowed, skewed
[WEE] between, seaweed, sweet, week, tweet, weed, bittersweet
[WEI] weird, weigh, flyweight, lightweight, unweighted, overweight, underweight
[WEL] dwell, jewel, swell, twelve, welcome, vowel, well
[WEN] twenty, went, wench, wend, underwent, forwent, forewent
[WET] wet, bedwetting, bellwether, wetly, wetness, wetsuit, wetter
[WHA] narwhal, whale, wharf, what, somewhat, whack, whamming
[WHE] wheat, wheel, when, where, whether, elsewhere, anywhere
[WHI] while, whim, whip, whisper, white, which, whine
[WHO] who, knowhow, blowhole, sawhorse, brewhouse, widowhood, unwholesome
[WHY] why, forwhy, whys, whydah, whydahs
[WIC] sandwich, wicked, twice, wicopy, bailiwick, midwicket, candlewick
[WID] wide, widow, width, worldwide, widget, bandwidth, twiddle
[WIE] wield, wiener, zwieback, unwieldy, dowie, dewier, blowier
[WIF] housewife, midwife, swift, wife, kiwifruit, alewife, oldwife
[WIG] bigwig, earwig, twig, wig, swig, bagwig, periwig
[WIL] bewildered, wild, will, goodwill, twilight, wilted, wily
[WIM] swim, wimp, wimble, nonswimmer, swimmer, wimpy, swimming
[WIN] twin, wind, wing, winter, following, drawing, allowing
[WIP] swipe, wipe, wiping, sideswipe, wiped, wiper, wipes
[WIR] wire, wiring, wiry, swirl, rewiring, twirl, tripwire
[WIS] twist, wisdom, wise, wish, wisp, otherwise, piecewise
[WIT] switch, twitch, wit, howitzer, wherewithal, herewith, dimwitted
[WIV] swivel, wives, wiving, alewives, midwives, oldwives, fishwives
[WIZ] swizzle, wiz, wizard, wizards, wizardry, swizz, wizen
[WLE] knowledge, acknowledge, bowler, crawler, trawler, flawless, shadowless
[WMA] snowman, bowman, cowman, lawman, crewman, plowman, showman
[WNS] owns, downscale, unknowns, spawns, towns, downshift, downsizing
[WOB] wobble, collywobbles, wobbled, wobbles, wobbling, wobbly, wobblier
[WOE] woe, woeful, woes, woefully, woebegone, woefuller, woefullest
[WOK] awoke, woke, woks, reawoke, woken, wok, awoken
[WOL] swollen, wolf, wolverine, wold, aardwolf, werewolf, rauwolfia
[WOM] woman, wombat, women, policewoman, enwomb, wommera, airwoman
[WON] won, unwon, wonder, wonderful, wonky, wont, wondering
[WOO] wood, woof, wool, swoosh, greenwood, redwood, woozy
[WOR] sword, word, work, world, worm, keyword, network
[WOU] wound, would, rewound, unwound, swound, blowout, throwout
[WOV] interwoven, wove, nonwoven, handwoven, rewove, unwove, inwoven
[WOW] bowwow, powwow, wow, wowed, wows, wowing, wowser
[WRA] unwrap, wrap, wrath, wraith, rewrap, wrangle, bewray
[WRE] wreath, wreck, wren, wrestle, wretch, lawrencium, enwreathe
[WRI] wriggle, wring, wrist, write, rewrite, overwrite, playwright
[WRO] wrought, wrong, wrote, rewrote, elbowroom, overwrote, towrope
[WRY] awry, wry, dowry, outlawry, wryer, wryest, wryly
[XAN] xanthan, hexane, relaxant, siloxane, exanimate, exanthema, alexandrine
[XAT] fixation, relaxation, taxation, indexation, luxate, laxation, vexation
[XEN] xenolith, xenophobia, boxen, oxen, axenic, vixen, xenia
[XER] boxer, fixer, mixer, xerox, xeric, indexer, lexer
[XIA] axial, triaxial, alexia, anoxia, ataxia, abaxial, adaxial
[XIC] lexicology, toxic, taxicab, lexically, paradoxical, lexicography, ataxic
[XID] oxide, peroxide, hydroxide, tetroxide, dioxide, monoxide, pyxidium
[XIL] axil, exile, auxiliary, foxily, sexily, flexile, maxilla
[XIM] maximize, oximeter, proximity, approximate, eximious, taximeter, maximum
[XIN] boxing, coaxing, fixing, mixing, toxin, indexing, waxing
[XIO] anxious, axiom, flexion, noxious, obnoxious, fluxion, defluxion
[XIS] axis, exist, sexist, nonexistent, maxis, preexisting, xis
[XIT] exit, complexity, perplexity, convexity, fixity, laxity, pinxit
[XOD] exodus, loxodromes, exoduses, loxodrome, exodontics, exodontist, loxodromic
[XON] axon, exon, taxon, hexone, klaxon, cytotaxonomy, axons
[XOT] exotic, quixotic, exotica, exotically, exotics, exoteric, exotoxin
[XPE] expected, unexpected, experimental, expensive, experience, inexpensive, expenditure
[XTI] extinction, sixtieth, extinguish, textile, sextillion, bissextile, flextime
[XUA] bisexual, sexuality, asexual, unsexual, nonsexual, unisexual, homosexual
[XUL] exult, exultant, exultation, exulted, exulting, exults, exultantly
[XYL] xylem, xylophone, hematoxylin, hydroxyl, hexyl, indoxyl, xylidine
[YAC] yacht, hyacinth, chyack, oxyacid, playact, bellyache, yachted
[YAK] kayak, yak, galyak, sukiyaki, teriyaki, kayaks, yakked
[YAM] yam, polyamide, hyoscyamus, yammer, yams, yammerer, polyamory
[YAN] banyan, cyan, yank, yang, conveyance, buoyancy, annoyance
[YAP] yap, mayapple, yapped, yapping, yaps, yapper, yapok
[YAR] backyard, barnyard, courtyard, yard, yarn, yarrow, graveyard
[YAS] yashmak, eyas, sannyasi, dryasdust, myasthenia, papayas, ouguiyas
[YAW] yaw, flyaway, layaway, yawl, yawn, yawned, yawning
[YBO] keyboard, anybody, everybody, storyboard, cyborg, toyboy, copyboy
[YCI] glycine, bombycid, calycine, neomycin, actinomycin, erythromycin, streptomycin
[YDE] honeydew, aldehyde, hoyden, zydeco, copydesk, pachyderm, chlamydeous
[YEA] year, yeast, yeah, lightyear, midyear, biyearly, yean
[YEL] yell, yelp, eyelid, myelin, dyeline, outyell, pyelitis
[YEN] yen, cayenne, doyen, hyena, yens, yenta, yentas
[YEP] eyepieces, yep, yeps, eyepiece
[YER] buyer, flyer, fryer, layer, player, lawyer, prayer
[YES] eyes, yesterday, polyester, ayes, dyes, shyest, wryest
[YET] yeti, polyethylene, hyetal, layette, vilayet, eyeteeth, eyetooth
[YEW] yew, dyewood, eyewash, yews, eyewitness, dyewoods, eyewitnesses
[YGO] polygon, bygone, zygoma, azygous, playgoer, dizygotic, easygoing
[YIE] yield, clayier, unyielding, nonyielding, yielded, yielding, yields
[YIN] buying, crying, flying, lying, yin, underlying, copying
[YIP] yip, bunyip, yipped, yippee, yipping, yips, yippie
[YLA] skylark, fairyland, waylay, amylase, astylar, boyla, bylaw
[YLO] payload, pylon, nylon, xylophone, amyloid, chylous, daylong
[YMA] handyman, layman, policymaker, flyman, zymase, bogyman, cymar
[YMP] asymptotic, symposium, symptoms, sympathizing, nympha, tympan, lymph
[YND] syndrome, syndication, syndesis, wynd, asyndeton, syndactyl, syndicalism
[YOD] yodel, yodle, diphyodont, yodeled, yodeler, yodeling, yodels
[YOG] yoga, yogi, yogurt, yogh, cryogenic, myogenic, karyogamy
[YOI] yoicks, hyoid, pyoid, ichthyoid, mylohyoid, botryoidal, kayoing
[YOK] yokel, karyokinesis, unyoke, yoking, yokels, yoke, yoked
[YOL] yolk, crayola, payola, embryol, myology, bryology, cryolite
[YON] beyond, canyon, crayon, yonder, anyone, everyone, rayon
[YOT] coyote, peyote, chayote, guyot, myotome, eyot, karyotin
[YOU] bayou, you, layout, carryout, joyous, payout, buyout
[YOW] yowl, yowled, yowling, yowls, yow
[YPH] glyph, hyphen, typhoon, hieroglyph, unhyphenated, scyphi, sypher
[YPO] hypo, typo, honeypot, maypole, drypoint, polypody, monkeypot
[YPT] crypt, encrypt, eucalypt, decrypt, krypton, tryptophan, glyptic
[YRA] pyramid, tyrant, gyrator, lyrate, styrax, hayrack, hyraces
[YRE] byre, gyre, lyre, pyre, tyre, polystyrene, styrene
[YRI] lyric, myriad, copyright, thyristor, keyring, syringe, labyrinth
[YRO] gyro, pyromania, tyro, byroad, chyron, joyrode, payroll
[YRR] myrrh, pyrrhic, pyrrhotite, pyrrhuloxia, pyrrolidine, pyrrhics, pyrrhuloxias
[YRT] myrtle, myrtles, myrtaceous
[YSA] sysadmin, babysat, oxysalt, skysail, trysail, naysayer, staysail
[YSC] skyscraper, cityscape, dyscrasia, playschool, bathyscaphe, skyscrapers, skyscape
[YSM] abysmal, cataclysm, paroxysm, aneurysm, platysma, abysm, aneurysmal
[YSS] odyssey, vichyssoise, byssus, hyssop, abyss, alyssum, lyssa
[YST] amethyst, analyst, catalyst, crystal, mystery, system, keystroke
[YTH] myth, rhythm, scythe, python, anything, everything, arrhythmia
[YTO] cytology, cytoplasmic, rhyton, baryton, cytosine, oxytocic, claytonia
[YUC] yucca, yuck, yuccas, yucky, yuckier, yuckiest
[YUK] yuk, yuks, yukky, yukked, yukking
[YUL] yule, guayule, yulan, yuletide, guayules
[YUM] yum, yummy, yummier, yummiest
[YUP] yup, layup, yuppie, yuppies, yuppify, yuppiedom, layups
[YUR] yurt, polyurethane, pyuria, dasyure, brachyuran, yurts, dasyures
[YXE] myxedema, onyxes, oryxes, calyxes, pyxes, apteryxes, epicalyxes
[ZAG] zigzag, zigzagged, zigzagging, zigzags, zigzagger
[ZAN] zany, zanies, byzantine, bezant, chazan, hazan, azan
[ZAP] zap, zapped, zapper, zapping, zaps, zappy, zapateado
[ZAR] bizarre, blizzard, hazard, lizard, wizards, lazar, alizarin
[ZAZ] pizzazz, pzazz, zazen, pizzazzes
[ZEA] zeal, overzealous, zealot, zealous, zealotry, zealousness, zealots
[ZEB] zebra, zebu, gazebo, jezebel, zebec, sleazebag, squeezebox
[ZED] amazed, blazed, dazed, glazed, zed, normalized, serialized
[ZEE] chimpanzee, zee, razee, recognizee, zees, chimpanzees
[ZEL] hazel, pretzel, bezel, gazelle, ouzel, vuvuzela, schnitzel
[ZEN] citizen, dozen, frozen, zen, lozenge, unfrozen, benzene
[ZEP] zephyr, zeppelin, diazepam, douzepers, zephyrs, zeppelins, diazepams
[ZER] blazer, freezer, zero, bulldozer, nonzero, optimizer, analyzer
[ZES] amazes, breezes, freezes, prizes, zest, sizes, initializes
[ZIG] zigzag, zigs, ziggurat, dziggetai, zigzagged, zigzagging, zigzags
[ZIL] brazil, zillion, lazily, crazily, fuzzily, gazillions, cozily
[ZIN] amazing, blazing, magazine, zinc, zinnia, sizing, resizing
[ZIP] unzip, zip, marzipan, zipped, zipper, zippy, zips
[ZIR] zircon, zirconia, zirconium, zircons, zirconias
[ZIT] zit, zizith, kunzite, monazite, chabazite, quartzite, zither
[ZIZ] zizz, zizith, zizzes, zizzed
[ZOA] zoa, bezoar, epizoa, entozoa, benzoate, bryozoan, polyzoan
[ZOE] zoea, zoeae, zoeas
[ZOI] borzoi, azoic, trapezoid, benzoic, epizoic, rhizoid, entozoic
[ZOM] zombie, rhizome, diazomethane, schizomycete, zombies, zombielike, rhizomes
[ZON] amazon, horizon, ozone, zone, timezone, zonal, rezone
[ZOO] bazooka, kazoo, zoo, epizoon, wazoo, entozoon, enzootic
[ZOR] razor, machzor, zorch, zoril, recognizor, razors, razorback
[ZUC] zucchini, zucchinis, zucchetto
[ZYG] azygous, zygoma, syzygy, dizygotic, homozygote, monozygotic, heterozygote
[ZYM] enzyme, zyme, zymase, zymogen, zymurgy, coenzyme, lysozyme
[ZZA] pizza, blizzard, huzzah, izzard, piazza, buzzard, gizzard
[ZZI] dizzier, fuzzier, jazzier, pizzicato, razzia, jacuzzi, muezzin
[ZZL] dazzle, drizzle, fizzle, puzzle, sizzle, swizzle, muzzle
[ZZO] mezzo, terrazzo, palazzo, paparazzo, intermezzo, mezzos, mezzotint
[ZZY] dizzy, fizzy, frizzy, fuzzy, jazzy, scuzzy, snazzy
[AARD] aardvark, aardwolf, aardvarks, aardwolves
[ABBY] crabby, flabby, grabby, scabby, shabby, cabby, gabby
[ABLE] cable, fable, stable, table, vegetable, callable, variable
[ACHE] ache, backache, headache, machete, toothache, cache, apache
[ADGE] badge, cadge, gadget, headgear, fadge, wadge, badger
[ALTY] penalty, royalty, specialty, loyalty, casualty, fealty, realty
[AQUE] aqueduct, opaque, plaque, maquette, claque, macaque, vaquero
[ARKS] marks, landmarks, trademarks, benchmarks, remarks, bookmarks, sparks
[ATCH] batch, catch, hatch, match, watch, patch, dispatch
[AUGH] caught, daughter, laugh, naughty, taught, uncaught, haugh
[AVAS] avast, lavash, extravasate, guavas, kavas, cassavas, balaclavas
[AXED] relaxed, taxed, coaxed, hoaxed, faxed, maxed, untaxed
[BANK] bank, embank, claybank, sandbank, snowbank, interbank, riverbank
[BBLE] babble, bubble, cobble, pebble, wobble, gobble, nibble
[CHOO] achoo, choose, school, ahchoo, preschool, homeschool, playschool
[CIFY] specify, calcify, pacify, crucify, dulcify, silicify, decalcify
[CKLE] buckle, cackle, chuckle, pickle, knuckle, speckle, reckless
[CKMA] checkmark, hackman, pockmark, stockman, trackman, blackmail, clockmaker
[CRYP] crypt, encrypt, decrypt, apocrypha, procryptic, cryptic, encryption
[DARY] boundary, secondary, dromedary, legendary, lapidary, quandary, solidary
[DDLE] cuddle, fiddle, middle, paddle, puddle, saddle, piddle
[DIZZ] dizzy, dizzied, dizzier, dizziest, dizzying, dizziness, dizzily
[DYIN] dying, tidying, studying, embodying, undying, birdying, caddying
[EAUX] chateaux, tableaux, bateaux, gateaux, reseaux, bandeaux, jambeaux
[EDGE] edge, hedge, knowledge, ledge, wedge, acknowledge, dredge
[EEVE] sleeve, reeves, beeves, steeve, weever, peeve, unreeve
[EEZE] breeze, freeze, sneeze, squeeze, wheeze, deepfreeze, unfreeze
[EIGH] eight, freight, height, neighbor, weigh, flyweight, lightweight
[ENZY] benzyl, enzyme, frenzy, coenzyme, apoenzyme, exoenzyme, ectoenzyme
[ETCH] fetch, ketch, sketch, stretch, wretch, fletcher, bletch
[EVES] retrieves, believes, achieves, reeves, eves, sleeves, sieves
[EWOM] policewoman, forewoman, tirewoman, horsewoman, noblewoman, spacewoman, gentlewoman
[EZIN] freezing, sneezing, squeezing, breeziness, wheeziness, nonfreezing, subfreezing
[EZZO] mezzo, intermezzo, mezzos, mezzotint, mezzotints, intermezzos, mezzotinter
[FFLE] baffle, muffle, raffle, shuffle, waffle, riffle, souffle
[FIZZ] fizz, fizzed, fizzle, fizzles, fizzy, fizzes, fizzier
[FRIZ] frizz, frizzed, frizzle, frizzes, frizzy, frize, frizette
[FUZZ] fuzz, fuzzed, fuzzes, fuzzier, fuzzy, fuzzing, fuzzily
[GGLE] gaggle, giggle, goggle, juggle, wiggle, toggle, smuggle
[GHTY] eighty, flighty, mighty, naughty, weighty, lightyear, almighty
[GNOM] gnome, cognomen, agnomen, ignominy, pathognomy, physiognomy, gnomes
[GWOR] bagworm, figwort, legwork, lugworm, ragwort, lungworm, ringworm
[HIZZ] whizzed, whizzes, whizzing, whizzbang, whizzbangs
[HONY] phony, euphony, diaphony, symphony, antiphony, cacophony, colophony
[HYTH] rhythm, arrhythmia, biorhythm, eurhythmy, unrhythmic, nonrhythmic, rhythmic
[ICKN] thickness, nickname, sickness, quickness, slickness, airsickness, carsickness
[IDGE] bridge, fridge, midge, porridge, ridge, widget, cartridge
[IGHT] bright, fight, flight, light, night, height, right
[INKA] linkage, shrinkage, sinkable, kinkajou, stotinka, chinkapin, drinkable
[IQUE] antique, boutique, clique, technique, unique, oblique, etiquette
[ISTY] mistyped, feisty, twisty, epistyle, sacristy, touristy, peristyle
[ITCH] ditch, itch, kitchen, pitch, witch, switch, fitch
[IZZE] quizzes, mizzen, whizzed, pizzeria, fizzed, zizzed, frizzed
[IZZY] dizzy, fizzy, frizzy, tizzy, dizzying
[JAZZ] jazz, jazzed, jazzes, jazzier, jazzy, jazzily, jazzman
[KENI] weakening, darkening, tokenism, awakening, sickening, zinkenite, thickening
[KILY] luckily, trickily, jokily, pokily, bulkily, cockily, flakily
[KLUT] klutz, klutzes, klutzier, klutzy, klutziness, klutziest
[KNIG] knight, weeknight, unknightly, knighted, knighthood, knightly, knights
[KWOR] bookworm, hackwork, hookworm, linkwork, milkwort, muckworm, silkworm
[LEVI] levin, television, alleviate, mendelevium, alevin, clevis, replevin
[LLYI] tallying, allying, bellying, bullying, collying, dallying, jellying
[LVIN] kelvin, solving, involving, resolving, halving, shelving, revolving
[MEZZ] mezzanine, mezzotint, intermezzi, mezzanines, mezzo, mezzos, intermezzo
[MIXE] mixed, intermixed, unmixed, amphimixes, admixed, immixed, remixed
[MNEM] mnemonic, mnemonics, mneme, mnemonically
[NERY] machinery, stationery, scenery, chicanery, finery, ornery, pinery
[NKLE] ankle, crinkle, sprinkle, twinkle, wrinkle, periwinkle, rankle
[NOMY] economy, astronomy, taxonomy, autonomy, isonomy, agronomy, antinomy
[NOZZ] nozzle, schnozzle, nozzles, schnozzles
[NZYM] enzyme, coenzyme, apoenzyme, exoenzyme, ectoenzyme, endoenzyme, holoenzyme
[ODGE] dodge, hodgepodge, lodge, bodge, codger, stodge, smoodge
[OLVA] solvable, resolvable, unsolvable, unresolvable, volva, irresolvable, evolvable
[OQUE] baroque, croquet, toque, eloquence, coquelicot, roque, moquette
[ORAX] borax, storax, thorax, mesothorax, hydrothorax, pneumothorax, prothorax
[OTCH] blotch, crotch, notch, scotch, gotchas, butterscotch, botch
[OUGH] bought, cough, dough, rough, through, enough, though
[OVES] removes, moves, improves, groves, proves, gloves, loves
[OXES] boxes, mailboxes, sandboxes, toolboxes, unboxes, coxes, detoxes
[OZZL] nozzle, schnozzle, sozzled, nozzles, schnozzles
[PAYM] payment, prepayment, nonpayment, underpayment, copayment, repayment, overpayment
[PHOB] phobia, xenophobia, hydrophobic, homophobe, lyophobic, zoophobia, acrophobia
[PIZZ] pizza, pizzas, pizzazz, pizzeria, pizzerias, pizzicato, pizzicati
[PNEU] pneumatic, pneumonia, pneumectomy, pneumatics, pneumonic, pneuma, pneumatical
[PPLE] apple, grapple, nipple, ripple, topple, supplement, pineapple
[PSYC] psyche, panpsychist, psychic, psychology, psychosis, psychs, psych
[PUZZ] puzzle, puzzled, puzzler, puzzles, puzzling, puzzlement, puzzlers
[PYRI] copyright, pyrite, papyri, lampyrid, antipyrine, aminopyrine, arsenopyrite
[QUAK] quake, earthquake, seaquake, quaked, quakes, quaking, quaky
[QUAR] quarrel, square, headquarters, hindquarters, aquarist, jacquard, antiquary
[QUEE] queen, squeeze, marquee, queenly, queens, queer, queerer
[QUER] conquer, lacquer, query, masquerade, becquerel, brusquer, equerry
[QUES] conquest, quest, request, sequester, cliques, marquess, techniques
[QUIC] quick, quicken, quicker, quickly, quicksand, quickest, quiche
[QUIE] quiet, requiem, acquiescence, unquiet, disquiet, exequies, obsequies
[QUIL] quill, tequila, tranquil, equilibrium, equilateral, jonquil, squill
[QUIN] mannequin, quince, sequin, harlequin, squinting, equinox, asquint
[QUIR] acquire, inquire, quirk, require, squirrel, reacquire, faquir
[QUIT] acquit, mosquito, quit, equitable, loquitur, sequitur, ubiquity
[QUIV] quiver, equivalent, unequivocal, aquiver, equivocal, quivered, quivering
[QUOT] quota, unquote, aliquot, misquote, underquote, quote, quoted
[RAYI] spraying, grayish, braying, fraying, praying, arraying, foraying
[RAZZ] razz, frazzle, terrazzo, paparazzi, razzed, razzes, razzle
[RHIN] rhino, errhine, murrhine, catarrhine, antirrhinum, leptorrhine, rhinoceros
[RHYM] rhyme, unrhymed, rhymed, rhymer, rhymes, rhyming, rhymester
[RHYT] rhythm, arrhythmia, biorhythm, eurhythmy, unrhythmic, nonrhythmic, rhythmic
[RIFY] verify, purify, clarify, transmogrify, scorify, terrifying, aerify
[ROWN] brown, thrown, crown, frowning, grown, drown, uncrown
[RVIE] overview, interview, purview, serviette, subservient, curvier, nervier
[SCHM] schmaltz, schmooze, schmears, schmucks, schmaltzy, schmo, schmuck
[SCHN] schnapps, schnitzel, schnozzle, schnorkle, schnauzer, schnoz, schnook
[SCUL] sculpt, masculine, minuscule, majuscule, bascule, oscular, esculent
[SEQU] sequence, subsequent, consequently, sequitur, obsequy, sequacity, inconsequent
[SHRE] shred, beshrew, shredder, shrew, shrewd, shrewish, shredded
[SHRO] shroud, mushroom, enshroud, unshroud, washroom, shrouded, shrouding
[SION] decision, explosion, mansion, mission, vision, version, fusion
[SIZZ] sizzle, sizzled, sizzler, sizzles, sizzling, sizzlers, sizzlingly
[SNAZ] snazzy, snazzier, snazziest, snazzily, snazziness
[SORY] compulsory, advisory, accessory, cursory, provisory, elusory, sensory
[SPHI] sphinx, phosphide, androsphinx, sphinxes, sphincter, phosphine, sphinxlike
[SQUA] squad, disqualified, musquash, setsquare, desquamate, foursquare, diddlysquat
[SQUI] squid, mosquito, disquisition, asquint, esquire, pasquil, mesquite
[TARY] elementary, rotary, unitary, military, monetary, voluntary, proprietary
[TION] action, motion, nation, potion, station, function, option
[TIZZ] tizzy, tizzies, tizz
[TONY] tony, antonym, stony, betony, atony, cottony, metonym
[TTLE] battle, bottle, cattle, kettle, little, nettle, settle
[TYPI] typing, atypical, mistyping, prototyping, untypical, genotypic, monotypic
[UDGE] budge, fudge, grudge, judge, nudge, kludge, bludge
[UNKE] chunked, shrunken, sunken, plunked, bunker, hunker, junker
[UTCH] clutch, crutch, dutch, hutch, butcher, nautch, scutch
[UZZY] fuzzy, muzzy, scuzzy
[VAGE] salvage, savage, gavage, lavage, lovage, ravage, rivage
[VENI] convenience, intervening, evening, inconvenient, venire, souvenir, contravening
[VIED] vied, moviedom, envied, levied, chevied, chivied, divvied
[VITE] invited, uninvited, evite, sylvite, vitellin, uvarovite, ovovitellin
[WATC] watch, stopwatch, swatch, unwatched, dogwatch, deathwatch, smartwatch
[WHIR] whir, awhirl, whirl, whirlpool, whirlwind, whirred, whirring
[WILL] will, goodwill, twill, unwilling, swill, freewill, pigswill
[WNES] skewness, slowness, fewness, lowness, newness, rawness, callowness
[WRIG] wriggle, playwright, wainwright, wheelwright, millwright, shipwright, wriggled
[XIST] exist, nonexistent, preexisting, coexist, inexistent, sexist, nonsexist
[XYLO] xylophone, xylotomy, xylograph, haematoxylon, xylophones, xylophonist, xyloid
[YEST] yesterday, polyester, shyest, wryest, dyestuff, eyestalk, yestreen
[YNES] dryness, grayness, coyness, gayness, shyness, slyness, wryness
[YSTO] cystoid, dystopi, systole, drystone, keystone, holystone, cherrystone
[ZIGZ] zigzag, zigzagged, zigzagging, zigzags, zigzagger
[ZILY] lazily, crazily, fuzzily, cozily, dozily, hazily, dizzily
[ZOMB] zombie, zombies, zombielike
[ZZLE] dazzle, drizzle, fizzle, puzzle, sizzle, swizzle, muzzle
[ZZLY] drizzly, frizzly, grizzly
[ZUCCH] zucchini, zucchinis, zucchetto
]==]

local INPUT_MODES = {
    { Id = "OS",     Name = "OS Keys", Desc = "Simulates real key presses (most reliable — keep Roblox focused)." },
    { Id = "Direct", Name = "Direct",  Desc = "Writes straight into the box without OS keypresses." },
}

local LENGTH_MODES = {
    { PreferLonger = true,  Name = "Longest"  },
    { PreferLonger = false, Name = "Shortest" },
}

local SPEED_PRESETS = {
    { Name = "Human",  Min = 0.08,  Max = 0.15 },
    { Name = "Normal", Min = 0.04,  Max = 0.09 },
    { Name = "Fast",   Min = 0.015, Max = 0.04 },
}

local THEMES = {
    { Name = "Cyber",    Primary = Color3.fromRGB(56, 189, 248),  Secondary = Color3.fromRGB(52, 211, 153) },
    { Name = "Matcha",   Primary = Color3.fromRGB(163, 217, 165), Secondary = Color3.fromRGB(110, 200, 150) },
    { Name = "Amethyst", Primary = Color3.fromRGB(192, 132, 252), Secondary = Color3.fromRGB(244, 114, 182) },
    { Name = "Crimson",  Primary = Color3.fromRGB(248, 113, 113), Secondary = Color3.fromRGB(251, 146, 60)  },
}

local QWERTY_NEIGHBORS = {
    a = "sqwz", b = "vghn", c = "xdfv", d = "serfcx", e = "wsdr",
    f = "drtgvc", g = "ftyhbv", h = "gyujnb", i = "ujko", j = "huikmn",
    k = "jiolm", l = "kop", m = "njk", n = "bhjm", o = "iklp",
    p = "ol", q = "wa", r = "edft", s = "awedxz", t = "rfgy",
    u = "yhji", v = "cfgb", w = "qase", x = "zsdc", y = "tghu", z = "asx",
}

local UI_STOPWORDS = {
    containing = true, english = true, word = true, words = true,
    type = true, players = true, chat = true, round = true,
    rounds = true, turns = true, turn = true, streak = true,
    elapsed = true, time = true, gameover = true, press = true,
    spectating = true, lobby = true, waiting = true, winner = true,
    joined = true, left = true, game = true, bomb = true,
}

local COLORS = {
    Bg        = Color3.fromRGB(14, 16, 22),
    Header    = Color3.fromRGB(20, 23, 32),
    Card      = Color3.fromRGB(24, 28, 39),
    CardHover = Color3.fromRGB(31, 36, 50),
    Border    = Color3.fromRGB(52, 60, 82),
    SubBorder = Color3.fromRGB(38, 44, 62),
    Text      = Color3.fromRGB(243, 246, 252),
    SubText   = Color3.fromRGB(165, 175, 198),
    Green     = Color3.fromRGB(52, 211, 153),
    Cyan      = Color3.fromRGB(56, 189, 248),
    Amber     = Color3.fromRGB(251, 191, 36),
    Red       = Color3.fromRGB(248, 113, 113),
    ToggleOff = Color3.fromRGB(50, 57, 76),
    ButtonBg  = Color3.fromRGB(34, 40, 56),
    DarkInk   = Color3.fromRGB(13, 17, 24),
}

local UI_NAME = "WordBombAutoTyperUI"

-- CENTRALIZED RUNTIME STATE
local STATE: { [string]: any } = {
    running = true,
    isTyping = false,
    isWindowFocused = true,
    isCalibrated = false,
    arrowMotionVerified = false,
    currentlyMyTurn = false,
    wasMyTurn = false,
    themeIndex = 1,
    activeTab = "Play",

    -- Word bank
    comboMap = {},
    masterWordList = {},
    masterWordSet = {},
    usedWords = {},
    usedCount = 0,
    mySentCount = 0,
    otherUsedCount = 0,
    fileLoaded = false,
    loadedFileName = nil,
    loadError = nil,

    -- UI & connections
    connections = {},
    guiListenerConns = {},
    hookedPromptGui = nil,
    lastDetectedBox = nil,
    lastPromptGui = nil,
    lastPromptLabel = nil,
    activeTurnPlayerPos = nil,
    turnSourceText = "Uncal",
    lastHeadline = "",
    lastDetail = "",
    diagText = "Not calibrated",

    -- Player name & UserId cache
    playerLookup = {},
    playerNamesSet = {},
    playerByIdStr = {},

    -- Calibration & arrow
    calSnapshots = {},
    calMyPos = nil,
    calArenaCenter = nil,
    learnedArrowName = nil,
    learnedArrowPath = nil,
    learnedPivotMode = "self", -- "self" | "parent" | "arena"
    confirmedArrow = nil,
    arrowMode = "rot",
    manualArrowOffset = nil,
    lastArrowSample = nil,
    arrowStableSince = 0,
    samePlayerTarget = nil,
    samePlayerSince = 0,
    cachedArenaPlayers = {},
    cachedArenaCenter = nil,
    cachedArenaAt = 0,
    reacquireHistory = {},

    -- Replicated state turn tracker (strictly turn-keyword filtered)
    stateCandidates = {},
    confirmedState = nil,
    lastStateScan = 0,

    -- Locked combo & opponent word tracking
    lockedCombo = nil,
    lockedForPlayer = nil,
    prevTurnCombo = nil,
    comboUnlockedAt = 0,
    promptMissingSince = nil,
    trackedTurnPlayer = nil,
    pendingOtherWord = nil,
    pendingOtherConf = 0,
    finishedOtherWord = nil,
    finishedOtherCombo = nil,
    finishedOtherAt = 0,
    turnAttempts = 0,
    lastAttemptSignature = nil,
}

local Bank: { [string]: any } = {}
local UI: { [string]: any } = {}
local Detector: { [string]: any } = {}
local Tracker: { [string]: any } = {}
local Typer: { [string]: any } = {}

-- Cached player maps (names, display names, and UserIds)
local function refreshPlayerCache()
    table.clear(STATE.playerLookup)
    table.clear(STATE.playerNamesSet)
    table.clear(STATE.playerByIdStr)
    for _, plr in ipairs(Players:GetPlayers()) do
        local n = plr.Name:lower()
        local d = plr.DisplayName:lower()
        STATE.playerLookup[n] = plr
        STATE.playerLookup[d] = plr
        STATE.playerNamesSet[n] = true
        STATE.playerNamesSet[d] = true
        STATE.playerByIdStr[tostring(plr.UserId)] = plr
    end
end

refreshPlayerCache()
table.insert(STATE.connections, Players.PlayerAdded:Connect(refreshPlayerCache))
table.insert(STATE.connections, Players.PlayerRemoving:Connect(refreshPlayerCache))
table.insert(STATE.connections, UserInputService.WindowFocused:Connect(function()
    STATE.isWindowFocused = true
end))
table.insert(STATE.connections, UserInputService.WindowFocusReleased:Connect(function()
    STATE.isWindowFocused = false
end))

-- ============================================================================
-- 1. WORD BANK MODULE (EMBEDDED-READY + WORKSPACE FALLBACK)
-- ============================================================================
function Bank.parse(rawText)
    local comboMap, allWordsSet, allWordsList = {}, {}, {}

    for line in rawText:gmatch("[^\r\n]+") do
        local lastBracketPos = line:match(".*()%[[A-Z]+%]")
        if lastBracketPos then
            line = line:sub(lastBracketPos)
        end

        local combo, rest = line:match("^%[([A-Z]+)%]%s*(.+)$")
        if combo and rest then
            if rest:find("->", 1, true) then
                rest = rest:match(".*%->%s*(.+)$") or rest
            end
            local lowerRest = rest:lower()
            if not lowerRest:find("skip", 1, true) and not lowerRest:find("verified below", 1, true) then
                rest = rest:gsub("%(5%-letter bonus%)", "")
                comboMap[combo] = comboMap[combo] or {}
                local lowerCombo = combo:lower()

                for entry in rest:gmatch("[^,]+") do
                    local lowerEntry = entry:lower()
                    if not lowerEntry:find("%(no") and not lowerEntry:find("%(proper") and not lowerEntry:find("%(skip") then
                        local word = lowerEntry:match("^%s*([a-z]+)%s*$")
                        if word and word:find(lowerCombo, 1, true) then
                            table.insert(comboMap[combo], word)
                            if not allWordsSet[word] then
                                allWordsSet[word] = true
                                table.insert(allWordsList, word)
                            end
                        end
                    end
                end
            end
        end
    end

    if #allWordsList == 0 then
        for line in rawText:gmatch("[^\r\n]+") do
            local word = line:lower():match("^%s*([a-z]+)%s*$")
            if word and #word >= 2 and not allWordsSet[word] then
                allWordsSet[word] = true
                table.insert(allWordsList, word)
            end
        end
    end

    return comboMap, allWordsList, allWordsSet
end

function Bank.sort()
    local cmp = CONFIG.PreferLonger
        and function(a, b) return #a > #b end
        or function(a, b) return #a < #b end

    for _, list in pairs(STATE.comboMap) do
        table.sort(list, cmp)
    end
    table.sort(STATE.masterWordList, cmp)
end

function Bank.findFile()
    if not isfile then
        return nil, "Executor missing isfile()"
    end

    for _, name in ipairs({ CONFIG.WordBankFile, "word_bomb.txt", "word_bomb", "word_bomb.txt.txt" }) do
        local ok, exists = pcall(isfile, name)
        if ok and exists then
            return name, nil
        end
    end

    if listfiles then
        local ok, files = pcall(listfiles, "")
        if ok and type(files) == "table" then
            for _, path in ipairs(files) do
                if type(path) == "string" and path:lower():find("word_bomb", 1, true) then
                    local fOk, exists = pcall(isfile, path)
                    if fOk and exists then
                        return path, nil
                    end
                end
            end
        end
    end

    return nil, "Not found: word_bomb.txt in workspace"
end

function Bank.load()
    if type(EMBEDDED_WORD_BANK) == "string" and EMBEDDED_WORD_BANK:match("%S") then
        STATE.comboMap, STATE.masterWordList, STATE.masterWordSet = Bank.parse(EMBEDDED_WORD_BANK)
        Bank.sort()
        if #STATE.masterWordList > 0 then
            STATE.fileLoaded = true
            STATE.loadedFileName = "Embedded"
            STATE.loadError = nil
            return true
        end
    end

    if not readfile then
        STATE.fileLoaded, STATE.loadError = false, "Executor missing readfile()"
        return false
    end

    local path, err = Bank.findFile()
    if not path then
        STATE.fileLoaded, STATE.loadError = false, err
        return false
    end

    local ok, rawText = pcall(readfile, path)
    if not ok or type(rawText) ~= "string" then
        STATE.fileLoaded, STATE.loadError = false, "Failed to read " .. path
        return false
    end

    STATE.comboMap, STATE.masterWordList, STATE.masterWordSet = Bank.parse(rawText)
    Bank.sort()

    if #STATE.masterWordList == 0 then
        STATE.fileLoaded, STATE.loadError = false, path .. " has 0 valid words"
        return false
    end

    STATE.fileLoaded = true
    STATE.loadedFileName = path
    STATE.loadError = nil
    return true
end

function Bank.findWord(combo)
    combo = combo:upper()
    local lowerCombo = combo:lower()
    local directList = STATE.comboMap[combo]

    if directList then
        for _, word in ipairs(directList) do
            if not STATE.usedWords[word] then
                return word
            end
        end
    end

    for _, word in ipairs(STATE.masterWordList) do
        if not STATE.usedWords[word] and word:find(lowerCombo, 1, true) then
            return word
        end
    end

    return nil
end

if not Bank.load() then
    CONFIG.Enabled = false
end

-- ============================================================================
-- 2. RIGID TACTICAL HUD, SMOOTH DRAGGING & 2-TAB LAYOUT
-- ============================================================================
local EXPANDED_W, EXPANDED_H = 364, 524
local CUBE_SIZE = 64

local function create(className, props, parent)
    local inst = Instance.new(className)
    for k, v in pairs(props) do
        inst[k] = v
    end
    if parent then
        inst.Parent = parent
    end
    return inst
end

local function addBorder(parent, color, thickness)
    return create("UIStroke", {
        Color = color or COLORS.SubBorder,
        Thickness = thickness or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, parent)
end

local function getTheme()
    return THEMES[STATE.themeIndex] or THEMES[1]
end

local function clampOffset(x, y, width, height)
    local cam = workspace.CurrentCamera
    if not cam then
        return x, y
    end
    local vp = cam.ViewportSize
    return math.clamp(x, 8, math.max(8, vp.X - width - 8)),
           math.clamp(y, 8, math.max(8, vp.Y - height - 8))
end

UI.dragActive = false
UI.smoothLerpActive = false
UI.dragTargetX = 24
UI.dragTargetY = 120
UI.curX = 24
UI.curY = 120

local function startSmoothDragLoop()
    table.insert(STATE.connections, RunService.RenderStepped:Connect(function(dt)
        if not STATE.running or not UI.smoothLerpActive or not UI.mainFrame or not UI.mainFrame.Parent then
            return
        end
        local alpha = 1 - math.exp(-20 * math.min(dt, 0.1))
        UI.curX = UI.curX + (UI.dragTargetX - UI.curX) * alpha
        UI.curY = UI.curY + (UI.dragTargetY - UI.curY) * alpha
        UI.mainFrame.Position = UDim2.fromOffset(math.floor(UI.curX + 0.5), math.floor(UI.curY + 0.5))

        if not UI.dragActive and math.abs(UI.dragTargetX - UI.curX) < 0.4 and math.abs(UI.dragTargetY - UI.curY) < 0.4 then
            UI.curX = UI.dragTargetX
            UI.curY = UI.dragTargetY
            UI.mainFrame.Position = UDim2.fromOffset(math.floor(UI.curX + 0.5), math.floor(UI.curY + 0.5))
            UI.smoothLerpActive = false
        end
    end))
end

function UI.setMinimized(minimize)
    if not UI.mainFrame then
        return
    end
    UI.minimized = minimize
    local theme = getTheme()
    local tweenInfo = TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

    if minimize then
        UI.header.Visible = false
        UI.tabBar.Visible = false
        UI.bodyFrame.Visible = false
        UI.footerFrame.Visible = false
        UI.cubeOverlay.Visible = true
        TweenService:Create(UI.mainFrame, tweenInfo, {
            Size = UDim2.fromOffset(CUBE_SIZE, CUBE_SIZE),
        }):Play()
        TweenService:Create(UI.mainStroke, tweenInfo, {
            Color = theme.Primary,
            Thickness = 2,
        }):Play()
    else
        UI.smoothLerpActive = false
        local cx, cy = clampOffset(UI.mainFrame.Position.X.Offset, UI.mainFrame.Position.Y.Offset, EXPANDED_W, EXPANDED_H)
        UI.curX, UI.curY = cx, cy
        UI.dragTargetX, UI.dragTargetY = cx, cy

        UI.cubeOverlay.Visible = false
        UI.header.Visible = true
        UI.tabBar.Visible = true
        UI.bodyFrame.Visible = true
        UI.footerFrame.Visible = true

        TweenService:Create(UI.mainFrame, tweenInfo, {
            Size = UDim2.fromOffset(EXPANDED_W, EXPANDED_H),
            Position = UDim2.fromOffset(math.floor(cx), math.floor(cy)),
        }):Play()
        TweenService:Create(UI.mainStroke, tweenInfo, {
            Color = COLORS.Border,
            Thickness = 1.4,
        }):Play()
    end
end

function UI.selectTab(tabName)
    STATE.activeTab = tabName
    local isPlay = (tabName == "Play")
    if UI.playPage then
        UI.playPage.Visible = isPlay
    end
    if UI.settingsPage then
        UI.settingsPage.Visible = not isPlay
    end
    local theme = getTheme()
    if UI.playTabBtn and UI.settingsTabBtn then
        UI.playTabBtn.TextColor3 = isPlay and COLORS.Text or COLORS.SubText
        UI.playTabBtn.BackgroundColor3 = isPlay and COLORS.Bg or COLORS.Header
        UI.playTabLine.BackgroundColor3 = theme.Primary
        UI.playTabLine.Visible = isPlay

        UI.settingsTabBtn.TextColor3 = (not isPlay) and COLORS.Text or COLORS.SubText
        UI.settingsTabBtn.BackgroundColor3 = (not isPlay) and COLORS.Bg or COLORS.Header
        UI.settingsTabLine.BackgroundColor3 = theme.Primary
        UI.settingsTabLine.Visible = not isPlay
    end
end

function UI.applyTheme()
    local theme = getTheme()
    if UI.accentGrad then
        UI.accentGrad.Color = ColorSequence.new(theme.Primary, theme.Secondary)
    end
    if UI.themeDot then
        UI.themeDot.BackgroundColor3 = theme.Primary
    end
    if UI.comboValue then
        UI.comboValue.TextColor3 = theme.Primary
    end
    if UI.cubeLabel then
        UI.cubeLabel.TextColor3 = theme.Primary
    end
    if UI.minimized and UI.mainStroke then
        UI.mainStroke.Color = theme.Primary
    end
    if UI.speedRangeLabel then
        UI.speedRangeLabel.TextColor3 = theme.Primary
    end
    if UI.refreshLengthHighlight then
        UI.refreshLengthHighlight()
    end
    if UI.refreshSpeedHighlight then
        UI.refreshSpeedHighlight()
    end
    if UI.refreshModeHighlight then
        UI.refreshModeHighlight()
    end
    if STATE.isCalibrated and STATE.arrowMotionVerified and UI.calibrateBtn then
        UI.calibrateBtn.BackgroundColor3 = theme.Primary
    end
    UI.selectTab(STATE.activeTab)
end

function UI.setStatus(headline, detail, accentColor)
    if headline == STATE.lastHeadline and detail == STATE.lastDetail then
        return
    end
    STATE.lastHeadline, STATE.lastDetail = headline, detail
    UI.statusTitle.Text = headline
    UI.statusTitle.TextColor3 = accentColor
    UI.statusDetail.Text = detail
    UI.statusDot.BackgroundColor3 = accentColor
    UI.statusStripe.BackgroundColor3 = accentColor
    UI.statusStroke.Color = accentColor
    if UI.cubeStatusDot then
        UI.cubeStatusDot.BackgroundColor3 = accentColor
    end
end

function UI.setDiag(text)
    if text == STATE.diagText then
        return
    end
    STATE.diagText = text
    if UI.diagLabel then
        UI.diagLabel.Text = text
    end
end

function UI.setCombo(comboText, isLocked)
    UI.comboValue.Text = comboText or "--"
    UI.comboTag.Text = isLocked and "COMBO • LOCKED" or "COMBO"
    if UI.cubeLabel and UI.cubeSubLabel then
        local hasCombo = (comboText ~= nil and comboText ~= "--" and comboText ~= "")
        UI.cubeLabel.Text = hasCombo and comboText or "WB"
        UI.cubeLabel.TextSize = (hasCombo and #comboText >= 4) and 17 or 22
        UI.cubeSubLabel.Text = hasCombo and "COMBO" or "OPEN"
    end
end

function UI.setOtherWord(wordText)
    UI.otherWordValue.Text = wordText or "--"
    UI.otherWordValue.TextColor3 = wordText and COLORS.Amber or COLORS.SubText
end

function UI.updateStats()
    local badge = (STATE.isCalibrated and STATE.arrowMotionVerified) and STATE.turnSourceText
        or (STATE.isCalibrated and "Sync..." or "Uncal")
    UI.statsLabel.Text = string.format(
        "Used: %d (+%d) • Bank: %d • %s",
        STATE.usedCount, STATE.otherUsedCount, #STATE.masterWordList, badge
    )
    if UI.sentPillLabel then
        UI.sentPillLabel.Text = string.format("%d sent", STATE.mySentCount)
    end
end

function UI.updateCalibration()
    local theme = getTheme()
    if STATE.isCalibrated and STATE.arrowMotionVerified then
        UI.calibrateBtn.Text = "RECALIBRATE [F1]"
        TweenService:Create(UI.calibrateBtn, TweenInfo.new(0.2), { BackgroundColor3 = theme.Primary }):Play()
        UI.setAutoToggle(CONFIG.Enabled, "Calibrated — auto-typer armed")
    elseif STATE.isCalibrated then
        UI.calibrateBtn.Text = "SYNCING ARROW..."
        TweenService:Create(UI.calibrateBtn, TweenInfo.new(0.2), { BackgroundColor3 = COLORS.Amber }):Play()
        UI.setAutoToggle(CONFIG.Enabled, "Locking onto moving arrow...")
    else
        UI.calibrateBtn.Text = "CALIBRATE [F1]"
        TweenService:Create(UI.calibrateBtn, TweenInfo.new(0.2), { BackgroundColor3 = COLORS.Amber }):Play()
        UI.setAutoToggle(CONFIG.Enabled, "Press F1 on your turn to start")
    end
    UI.updateStats()
end

function UI.dismissPopup()
    if UI.popupBackdrop and UI.popupBackdrop.Parent then
        UI.popupBackdrop:Destroy()
    end
    if UI.mainFrame then
        UI.mainFrame.Visible = true
    end
end

function UI.unlockCombo(keepPrev)
    STATE.prevTurnCombo = keepPrev and STATE.lockedCombo or nil
    STATE.lockedCombo = nil
    STATE.comboUnlockedAt = os.clock()
end

function UI.toggleAutoTyper(desiredState)
    if desiredState and not STATE.fileLoaded then
        Bank.load()
        UI.updateStats()
    end
    if not STATE.fileLoaded then
        CONFIG.Enabled = false
        UI.setAutoToggle(false)
        UI.setStatus("FILE ERROR", STATE.loadError or "Missing word_bomb.txt", COLORS.Red)
        return
    end
    CONFIG.Enabled = desiredState
    UI.setAutoToggle(CONFIG.Enabled)
    if CONFIG.Enabled then
        if not STATE.isCalibrated then
            UI.setStatus("NOT CALIBRATED", "Wait for arrow on you, then press F1", COLORS.Amber)
        elseif not STATE.arrowMotionVerified then
            UI.setStatus("VERIFYING ARROW", "Waiting for turn to pass to lock arrow...", COLORS.Amber)
        else
            UI.setStatus("ACTIVE • WAITING", "Watching bomb arrow & turns...", COLORS.Green)
        end
    else
        UI.setStatus("PAUSED", "Auto-typer is turned off", COLORS.Amber)
    end
end

function UI.resetUsedWords()
    table.clear(STATE.usedWords)
    STATE.usedCount = 0
    STATE.mySentCount = 0
    STATE.otherUsedCount = 0
    STATE.pendingOtherWord = nil
    STATE.pendingOtherConf = 0
    STATE.finishedOtherWord = nil
    STATE.finishedOtherCombo = nil
    STATE.turnAttempts = 0
    STATE.lastAttemptSignature = nil
    STATE.lockedForPlayer = nil
    STATE.wasMyTurn = false
    UI.unlockCombo(false)
    UI.updateStats()
    UI.setCombo("--", false)
    UI.setOtherWord(nil)

    UI.resetBtn.Text = "CLEARED!"
    TweenService:Create(UI.resetBtn, TweenInfo.new(0.15), {
        BackgroundColor3 = COLORS.Green,
        TextColor3 = COLORS.DarkInk,
    }):Play()
    task.delay(0.8, function()
        if UI.resetBtn and UI.resetBtn.Parent then
            UI.resetBtn.Text = "RESET [F2]"
            TweenService:Create(UI.resetBtn, TweenInfo.new(0.2), {
                BackgroundColor3 = COLORS.ButtonBg,
                TextColor3 = COLORS.Text,
            }):Play()
        end
    end)
end

local function makeToggleRow(parent, order, labelText, subText, initialState, onColor, onToggle)
    local activeColor = onColor or COLORS.Green
    local row = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 52), BackgroundColor3 = COLORS.Card,
        BorderSizePixel = 0, Text = "", AutoButtonColor = false, LayoutOrder = order,
    }, parent)
    addBorder(row, COLORS.SubBorder, 1)

    row.MouseEnter:Connect(function()
        TweenService:Create(row, TweenInfo.new(0.12), { BackgroundColor3 = COLORS.CardHover }):Play()
    end)
    row.MouseLeave:Connect(function()
        TweenService:Create(row, TweenInfo.new(0.12), { BackgroundColor3 = COLORS.Card }):Play()
    end)

    create("TextLabel", {
        Size = UDim2.new(1, -84, 0, 22), Position = UDim2.new(0, 12, 0, 6),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = labelText,
        TextColor3 = COLORS.Text, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left,
    }, row)

    local subLbl = create("TextLabel", {
        Size = UDim2.new(1, -84, 0, 18), Position = UDim2.new(0, 12, 0, 28),
        BackgroundTransparency = 1, Font = Enum.Font.GothamMedium, Text = subText or "",
        TextColor3 = COLORS.SubText, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, row)

    local badge = create("TextLabel", {
        Size = UDim2.new(0, 58, 0, 28), Position = UDim2.new(1, -68, 0.5, -14),
        BackgroundColor3 = initialState and activeColor or COLORS.ToggleOff,
        BorderSizePixel = 0, Font = Enum.Font.GothamBlack,
        Text = initialState and "ON" or "OFF",
        TextColor3 = initialState and COLORS.DarkInk or COLORS.SubText,
        TextSize = 13,
    }, row)
    addBorder(badge, COLORS.Border, 1)

    local state = initialState
    local function setVisual(newState, newSub)
        state = newState
        if newSub then
            subLbl.Text = newSub
        end
        badge.Text = state and "ON" or "OFF"
        TweenService:Create(badge, TweenInfo.new(0.15), {
            BackgroundColor3 = state and activeColor or COLORS.ToggleOff,
            TextColor3 = state and COLORS.DarkInk or COLORS.SubText,
        }):Play()
    end

    row.MouseButton1Click:Connect(function()
        onToggle(not state)
    end)
    return setVisual
end

function UI.showPopup(isStartup)
    if UI.popupBackdrop and UI.popupBackdrop.Parent then
        UI.popupBackdrop:Destroy()
    end
    local screenGui = UI.screenGui
    if not screenGui then
        return
    end

    local backdrop = create("Frame", {
        Name = "StartupPopupBackdrop", Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 0.52,
        BorderSizePixel = 0, ZIndex = 20,
    }, screenGui)
    UI.popupBackdrop = backdrop

    local card = create("Frame", {
        Size = UDim2.fromOffset(460, 384), Position = UDim2.new(0.5, -230, 0.5, -192),
        BackgroundColor3 = COLORS.Bg, BorderSizePixel = 0, ZIndex = 21,
    }, backdrop)
    addBorder(card, getTheme().Primary, 1.6)

    local topLine = create("Frame", {
        Size = UDim2.new(1, 0, 0, 3), BackgroundColor3 = getTheme().Primary, BorderSizePixel = 0, ZIndex = 24,
    }, card)
    create("UIGradient", { Color = ColorSequence.new(getTheme().Primary, getTheme().Secondary) }, topLine)

    local hdr = create("Frame", {
        Size = UDim2.new(1, 0, 0, 48), Position = UDim2.fromOffset(0, 3),
        BackgroundColor3 = COLORS.Header, BorderSizePixel = 0, ZIndex = 22,
    }, card)
    create("Frame", {
        Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = COLORS.Border, BorderSizePixel = 0, ZIndex = 23,
    }, hdr)
    create("TextLabel", {
        Size = UDim2.new(1, -56, 1, 0), Position = UDim2.fromOffset(16, 0),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBlack, Text = "WORD BOMB  //  QUICK START",
        TextColor3 = COLORS.Text, TextSize = 18, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 23,
    }, hdr)

    local closeX = create("TextButton", {
        Size = UDim2.fromOffset(30, 30), Position = UDim2.new(1, -40, 0.5, -15),
        BackgroundColor3 = COLORS.ButtonBg, Font = Enum.Font.GothamBold, Text = "X",
        TextColor3 = COLORS.SubText, TextSize = 15, AutoButtonColor = false, ZIndex = 23,
    }, hdr)
    addBorder(closeX, COLORS.Border, 1)
    closeX.MouseButton1Click:Connect(UI.dismissPopup)

    local function addStep(yPos, height, badgeText, badgeColor, title, desc)
        local row = create("Frame", {
            Size = UDim2.new(1, -32, 0, height), Position = UDim2.fromOffset(16, yPos),
            BackgroundColor3 = COLORS.Card, BorderSizePixel = 0, ZIndex = 22,
        }, card)
        addBorder(row, COLORS.SubBorder, 1)

        create("TextLabel", {
            Size = UDim2.fromOffset(58, 42), Position = UDim2.new(0, 12, 0.5, -21),
            BackgroundColor3 = badgeColor, BorderSizePixel = 0, Font = Enum.Font.GothamBlack,
            Text = badgeText, TextColor3 = COLORS.DarkInk, TextSize = 16, ZIndex = 23,
        }, row)

        create("TextLabel", {
            Size = UDim2.new(1, -88, 0, 22), Position = UDim2.fromOffset(82, 8),
            BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = title,
            TextColor3 = COLORS.Text, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 23,
        }, row)
        create("TextLabel", {
            Size = UDim2.new(1, -88, 1, -34), Position = UDim2.fromOffset(82, 30),
            BackgroundTransparency = 1, Font = Enum.Font.GothamMedium, Text = desc,
            TextColor3 = COLORS.SubText, TextSize = 13, TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 23,
        }, row)
    end

    addStep(
        62, 74, "F1", COLORS.Amber,
        "Calibrate When Arrow Is On You",
        "Wait until the bomb arrow stops on you, then press F1 once. It types your word and locks onto the arrow."
    )
    addStep(
        144, 74, "F2", COLORS.Cyan,
        "Reset Word Bank Every Round",
        "After every round ends, press F2 to clear used words so the bank stays fresh."
    )
    addStep(
        226, 92, "MODE", COLORS.Green,
        "OS Keys vs. Direct Mode",
        "OS Keys simulates real key presses (most reliable, keep Roblox focused). Direct writes straight into the box without OS keys."
    )

    local gotIt = create("TextButton", {
        Size = UDim2.new(1, -32, 0, 42), Position = UDim2.new(0, 16, 1, -54),
        BackgroundColor3 = COLORS.Green, BorderSizePixel = 0, Font = Enum.Font.GothamBlack,
        Text = isStartup and "GOT IT — OPEN MENU" or "CLOSE GUIDE",
        TextColor3 = COLORS.DarkInk, TextSize = 15, AutoButtonColor = false, ZIndex = 23,
    }, card)
    gotIt.MouseButton1Click:Connect(UI.dismissPopup)
end

local function buildCubeOverlay(mainFrame)
    local cubeBtn = create("TextButton", {
        Name = "CubeOverlay", Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = COLORS.Header, BorderSizePixel = 0,
        Text = "", AutoButtonColor = false, Visible = false, ZIndex = 10,
    }, mainFrame)
    UI.cubeOverlay = cubeBtn

    UI.cubeStatusDot = create("Frame", {
        Size = UDim2.fromOffset(8, 8), Position = UDim2.new(1, -13, 0, 7),
        BackgroundColor3 = COLORS.Amber, BorderSizePixel = 0, ZIndex = 12,
    }, cubeBtn)

    UI.cubeLabel = create("TextLabel", {
        Size = UDim2.new(1, -8, 0, 28), Position = UDim2.fromOffset(4, 13),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBlack, Text = "WB",
        TextColor3 = COLORS.Cyan, TextSize = 22, ZIndex = 11,
    }, cubeBtn)

    UI.cubeSubLabel = create("TextLabel", {
        Size = UDim2.new(1, -8, 0, 14), Position = UDim2.fromOffset(4, 43),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = "OPEN",
        TextColor3 = COLORS.SubText, TextSize = 10, ZIndex = 11,
    }, cubeBtn)

    cubeBtn.MouseEnter:Connect(function()
        TweenService:Create(cubeBtn, TweenInfo.new(0.12), { BackgroundColor3 = COLORS.CardHover }):Play()
    end)
    cubeBtn.MouseLeave:Connect(function()
        TweenService:Create(cubeBtn, TweenInfo.new(0.12), { BackgroundColor3 = COLORS.Header }):Play()
    end)

    local moved, dragStart, startX, startY = false, nil, 0, 0
    cubeBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            UI.dragActive = true
            moved = false
            dragStart = input.Position
            startX = mainFrame.Position.X.Offset
            startY = mainFrame.Position.Y.Offset
            UI.curX, UI.curY = startX, startY
            UI.dragTargetX, UI.dragTargetY = startX, startY
        end
    end)
    table.insert(STATE.connections, UserInputService.InputChanged:Connect(function(input)
        if UI.dragActive and UI.minimized and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            if delta.Magnitude >= 6 then
                moved = true
            end
            if moved then
                UI.dragTargetX = startX + delta.X
                UI.dragTargetY = startY + delta.Y
                UI.smoothLerpActive = true
            end
        end
    end))
    table.insert(STATE.connections, UserInputService.InputEnded:Connect(function(input)
        if UI.dragActive and UI.minimized and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            UI.dragActive = false
            if not moved then
                UI.setMinimized(false)
            end
        end
    end))
end

local function buildHeaderAndTabs(mainFrame)
    local accentBar = create("Frame", {
        Size = UDim2.new(1, 0, 0, 3), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 15,
    }, mainFrame)
    UI.accentGrad = create("UIGradient", {
        Color = ColorSequence.new(COLORS.Cyan, COLORS.Green),
    }, accentBar)

    local header = create("Frame", {
        Size = UDim2.new(1, 0, 0, 44), Position = UDim2.fromOffset(0, 3),
        BackgroundColor3 = COLORS.Header, BorderSizePixel = 0,
    }, mainFrame)
    UI.header = header

    create("Frame", {
        Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = COLORS.Border, BorderSizePixel = 0,
    }, header)

    UI.statusDot = create("Frame", {
        Size = UDim2.fromOffset(10, 10), Position = UDim2.new(0, 14, 0.5, -5),
        BackgroundColor3 = COLORS.Amber, BorderSizePixel = 0,
    }, header)

    create("TextLabel", {
        Size = UDim2.new(0, 134, 1, 0), Position = UDim2.fromOffset(32, 0),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBlack, Text = "WORD BOMB",
        TextColor3 = COLORS.Text, TextSize = 18, TextXAlignment = Enum.TextXAlignment.Left,
    }, header)

    local sentPill = create("Frame", {
        Size = UDim2.fromOffset(72, 24), Position = UDim2.new(0, 170, 0.5, -12),
        BackgroundColor3 = COLORS.Card, BorderSizePixel = 0,
    }, header)
    addBorder(sentPill, COLORS.SubBorder, 1)
    UI.sentPillLabel = create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold, Text = "0 sent", TextColor3 = COLORS.SubText, TextSize = 13,
    }, sentPill)

    local themeBtn = create("TextButton", {
        Size = UDim2.fromOffset(28, 28), Position = UDim2.new(1, -104, 0.5, -14),
        BackgroundColor3 = COLORS.ButtonBg, BorderSizePixel = 0, Text = "", AutoButtonColor = false,
    }, header)
    addBorder(themeBtn, COLORS.Border, 1)
    UI.themeDot = create("Frame", {
        Size = UDim2.fromOffset(12, 12), Position = UDim2.new(0.5, -6, 0.5, -6),
        BackgroundColor3 = COLORS.Cyan, BorderSizePixel = 0,
    }, themeBtn)
    themeBtn.MouseButton1Click:Connect(function()
        STATE.themeIndex = (STATE.themeIndex % #THEMES) + 1
        UI.applyTheme()
    end)

    local function makeHeaderBtn(text, xOffset, hoverColor)
        local btn = create("TextButton", {
            Size = UDim2.fromOffset(28, 28), Position = UDim2.new(1, xOffset, 0.5, -14),
            BackgroundColor3 = COLORS.ButtonBg, BorderSizePixel = 0, Font = Enum.Font.GothamBold,
            Text = text, TextColor3 = COLORS.SubText, TextSize = 15, AutoButtonColor = false,
        }, header)
        addBorder(btn, COLORS.Border, 1)
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundColor3 = hoverColor, TextColor3 = COLORS.Text }):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundColor3 = COLORS.ButtonBg, TextColor3 = COLORS.SubText }):Play()
        end)
        return btn
    end

    local minBtn = makeHeaderBtn("-", -70, COLORS.Border)
    local closeBtn = makeHeaderBtn("X", -36, COLORS.Red)

    UI.minimized = false
    minBtn.MouseButton1Click:Connect(function()
        UI.setMinimized(true)
    end)

    closeBtn.MouseButton1Click:Connect(function()
        STATE.running = false
        CONFIG.Enabled = false
        Tracker.disconnectListeners()
        for _, conn in ipairs(STATE.connections) do
            if conn.Connected then
                conn:Disconnect()
            end
        end
        UI.screenGui:Destroy()
    end)

    local dragStart, startX, startY = nil, 0, 0
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            UI.dragActive = true
            dragStart = input.Position
            startX = mainFrame.Position.X.Offset
            startY = mainFrame.Position.Y.Offset
            UI.curX, UI.curY = startX, startY
            UI.dragTargetX, UI.dragTargetY = startX, startY
        end
    end)
    table.insert(STATE.connections, UserInputService.InputChanged:Connect(function(input)
        if UI.dragActive and not UI.minimized and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            UI.dragTargetX = startX + d.X
            UI.dragTargetY = startY + d.Y
            UI.smoothLerpActive = true
        end
    end))
    table.insert(STATE.connections, UserInputService.InputEnded:Connect(function(input)
        if UI.dragActive and not UI.minimized and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            UI.dragActive = false
        end
    end))

    local tabBar = create("Frame", {
        Size = UDim2.new(1, 0, 0, 34), Position = UDim2.fromOffset(0, 47),
        BackgroundColor3 = COLORS.Header, BorderSizePixel = 0,
    }, mainFrame)
    UI.tabBar = tabBar
    create("Frame", {
        Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = COLORS.Border, BorderSizePixel = 0,
    }, tabBar)

    local function makeTab(label, xScale, tabKey)
        local btn = create("TextButton", {
            Size = UDim2.new(0.5, 0, 1, -1), Position = UDim2.new(xScale, 0, 0, 0),
            BackgroundColor3 = COLORS.Header, BorderSizePixel = 0, Font = Enum.Font.GothamBlack,
            Text = label, TextColor3 = COLORS.SubText, TextSize = 13, AutoButtonColor = false,
        }, tabBar)
        local line = create("Frame", {
            Size = UDim2.new(1, 0, 0, 2), Position = UDim2.new(0, 0, 1, -2),
            BackgroundColor3 = COLORS.Cyan, BorderSizePixel = 0, Visible = false,
        }, btn)
        btn.MouseButton1Click:Connect(function()
            UI.selectTab(tabKey)
        end)
        return btn, line
    end

    UI.playTabBtn, UI.playTabLine = makeTab("PLAY", 0, "Play")
    UI.settingsTabBtn, UI.settingsTabLine = makeTab("SETTINGS", 0.5, "Settings")
end

local function buildPlayTab(parent)
    local page = create("Frame", {
        Name = "PlayPage", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
    }, parent)
    create("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, page)
    UI.playPage = page

    local row = create("Frame", { Size = UDim2.new(1, 0, 0, 64), BackgroundTransparency = 1, LayoutOrder = 1 }, page)

    local comboBox = create("Frame", {
        Size = UDim2.new(0, 122, 1, 0), BackgroundColor3 = COLORS.Card, BorderSizePixel = 0,
    }, row)
    addBorder(comboBox, COLORS.SubBorder, 1)
    UI.comboTag = create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 16), Position = UDim2.fromOffset(0, 6), BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold, Text = "COMBO", TextColor3 = COLORS.SubText, TextSize = 11,
    }, comboBox)
    UI.comboValue = create("TextLabel", {
        Size = UDim2.new(1, -8, 0, 36), Position = UDim2.fromOffset(4, 22), BackgroundTransparency = 1,
        Font = Enum.Font.GothamBlack, Text = "--", TextColor3 = COLORS.Cyan, TextSize = 28,
    }, comboBox)

    local otherBox = create("Frame", {
        Size = UDim2.new(1, -130, 1, 0), Position = UDim2.fromOffset(130, 0),
        BackgroundColor3 = COLORS.Card, BorderSizePixel = 0,
    }, row)
    addBorder(otherBox, COLORS.SubBorder, 1)
    create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 16), Position = UDim2.fromOffset(12, 6), BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold, Text = "OTHER'S LAST WORD", TextColor3 = COLORS.SubText,
        TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left,
    }, otherBox)
    UI.otherWordValue = create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 32), Position = UDim2.fromOffset(12, 24), BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold, Text = "--", TextColor3 = COLORS.SubText,
        TextSize = 18, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
    }, otherBox)

    UI.setAutoToggle = makeToggleRow(page, 2, "Auto-Typer", "Press F1 on your turn to start", CONFIG.Enabled, COLORS.Green, function(v)
        UI.toggleAutoTyper(v)
    end)

    do
        local sec = create("Frame", { Size = UDim2.new(1, 0, 0, 58), BackgroundTransparency = 1, LayoutOrder = 3 }, page)
        create("TextLabel", {
            Size = UDim2.new(0.55, 0, 0, 19), BackgroundTransparency = 1, Font = Enum.Font.GothamBold,
            Text = "Word Length", TextColor3 = COLORS.Text, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left,
        }, sec)
        local lenSub = create("TextLabel", {
            Size = UDim2.new(0.45, 0, 0, 19), Position = UDim2.new(0.55, 0, 0, 0), BackgroundTransparency = 1,
            Font = Enum.Font.GothamMedium, Text = "Longest first", TextColor3 = COLORS.SubText, TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Right,
        }, sec)

        local holder = create("Frame", {
            Size = UDim2.new(1, 0, 0, 36), Position = UDim2.fromOffset(0, 22),
            BackgroundColor3 = COLORS.Card, BorderSizePixel = 0,
        }, sec)
        addBorder(holder, COLORS.SubBorder, 1)

        local btns = {}
        local function refreshHighlight()
            local theme = getTheme()
            for i, m in ipairs(LENGTH_MODES) do
                local sel = (m.PreferLonger == CONFIG.PreferLonger)
                TweenService:Create(btns[i], TweenInfo.new(0.14), {
                    BackgroundColor3 = sel and theme.Secondary or COLORS.Card,
                    TextColor3 = sel and COLORS.DarkInk or COLORS.SubText,
                }):Play()
            end
        end
        UI.refreshLengthHighlight = refreshHighlight

        for i, m in ipairs(LENGTH_MODES) do
            local btn = create("TextButton", {
                Size = UDim2.new(0.5, -4, 1, -4), Position = UDim2.new((i - 1) * 0.5, 2, 0, 2),
                BackgroundColor3 = COLORS.Card, BorderSizePixel = 0, Font = Enum.Font.GothamBold,
                Text = m.Name, TextColor3 = COLORS.SubText, TextSize = 14, AutoButtonColor = false,
            }, holder)
            btn.MouseButton1Click:Connect(function()
                CONFIG.PreferLonger = m.PreferLonger
                Bank.sort()
                lenSub.Text = CONFIG.PreferLonger and "Longest first" or "Shortest first"
                refreshHighlight()
            end)
            btns[i] = btn
        end
        refreshHighlight()
    end

    do
        local sec = create("Frame", { Size = UDim2.new(1, 0, 0, 58), BackgroundTransparency = 1, LayoutOrder = 4 }, page)
        create("TextLabel", {
            Size = UDim2.new(0.5, 0, 0, 19), BackgroundTransparency = 1, Font = Enum.Font.GothamBold,
            Text = "Typing Speed", TextColor3 = COLORS.Text, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left,
        }, sec)
        UI.speedRangeLabel = create("TextLabel", {
            Size = UDim2.new(0.5, 0, 0, 19), Position = UDim2.new(0.5, 0, 0, 0), BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold, Text = "40-90ms", TextColor3 = COLORS.Cyan, TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Right,
        }, sec)

        local holder = create("Frame", {
            Size = UDim2.new(1, 0, 0, 36), Position = UDim2.fromOffset(0, 22),
            BackgroundColor3 = COLORS.Card, BorderSizePixel = 0,
        }, sec)
        addBorder(holder, COLORS.SubBorder, 1)

        local btns, selectedIdx = {}, 2
        local function refreshHighlight()
            local theme = getTheme()
            for i, btn in ipairs(btns) do
                local sel = (i == selectedIdx)
                TweenService:Create(btn, TweenInfo.new(0.14), {
                    BackgroundColor3 = sel and theme.Primary or COLORS.Card,
                    TextColor3 = sel and COLORS.DarkInk or COLORS.SubText,
                }):Play()
            end
        end
        UI.refreshSpeedHighlight = refreshHighlight

        local function selectSpeed(idx)
            selectedIdx = idx
            local p = SPEED_PRESETS[idx]
            CONFIG.MinKeyDelay, CONFIG.MaxKeyDelay = p.Min, p.Max
            UI.speedRangeLabel.Text = string.format("%d-%dms", math.floor(p.Min * 1000), math.floor(p.Max * 1000))
            refreshHighlight()
        end

        for i, p in ipairs(SPEED_PRESETS) do
            local btn = create("TextButton", {
                Size = UDim2.new(1 / #SPEED_PRESETS, -4, 1, -4), Position = UDim2.new((i - 1) / #SPEED_PRESETS, 2, 0, 2),
                BackgroundColor3 = COLORS.Card, BorderSizePixel = 0, Font = Enum.Font.GothamBold,
                Text = p.Name, TextColor3 = COLORS.SubText, TextSize = 14, AutoButtonColor = false,
            }, holder)
            btn.MouseButton1Click:Connect(function() selectSpeed(i) end)
            btns[i] = btn
        end
        selectSpeed(2)
    end

    local actionRow = create("Frame", { Size = UDim2.new(1, 0, 0, 42), BackgroundTransparency = 1, LayoutOrder = 5 }, page)
    UI.calibrateBtn = create("TextButton", {
        Size = UDim2.new(0.58, -4, 1, 0), BackgroundColor3 = COLORS.Amber, BorderSizePixel = 0,
        Font = Enum.Font.GothamBlack, Text = "CALIBRATE [F1]", TextColor3 = COLORS.DarkInk,
        TextSize = 14, AutoButtonColor = false,
    }, actionRow)
    UI.calibrateBtn.MouseButton1Click:Connect(function() Typer.calibrateAndType() end)

    UI.resetBtn = create("TextButton", {
        Size = UDim2.new(0.42, -4, 1, 0), Position = UDim2.new(0.58, 4, 0, 0),
        BackgroundColor3 = COLORS.ButtonBg, BorderSizePixel = 0, Font = Enum.Font.GothamBold,
        Text = "RESET [F2]", TextColor3 = COLORS.Text, TextSize = 14, AutoButtonColor = false,
    }, actionRow)
    addBorder(UI.resetBtn, COLORS.Border, 1)
    UI.resetBtn.MouseButton1Click:Connect(UI.resetUsedWords)
end

local function buildSettingsTab(parent)
    local page = create("Frame", {
        Name = "SettingsPage", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false,
    }, parent)
    create("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, page)
    UI.settingsPage = page

    do
        local sec = create("Frame", { Size = UDim2.new(1, 0, 0, 92), BackgroundTransparency = 1, LayoutOrder = 1 }, page)
        create("TextLabel", {
            Size = UDim2.new(0.55, 0, 0, 19), BackgroundTransparency = 1, Font = Enum.Font.GothamBold,
            Text = "Input Method", TextColor3 = COLORS.Text, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left,
        }, sec)
        create("TextLabel", {
            Size = UDim2.new(0.45, 0, 0, 19), Position = UDim2.new(0.55, 0, 0, 0), BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold, Text = HAS_KEYPRESS and "OS Ready" or "Direct Only",
            TextColor3 = HAS_KEYPRESS and COLORS.Green or COLORS.Amber, TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Right,
        }, sec)

        local holder = create("Frame", {
            Size = UDim2.new(1, 0, 0, 36), Position = UDim2.fromOffset(0, 21),
            BackgroundColor3 = COLORS.Card, BorderSizePixel = 0,
        }, sec)
        addBorder(holder, COLORS.SubBorder, 1)

        local descLbl = create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 30), Position = UDim2.fromOffset(0, 60), BackgroundTransparency = 1,
            Font = Enum.Font.GothamMedium, Text = "", TextColor3 = COLORS.SubText, TextSize = 12,
            TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
        }, sec)

        local btns = {}
        local function refreshHighlight()
            local theme = getTheme()
            for i, m in ipairs(INPUT_MODES) do
                local sel = (m.Id == CONFIG.InputMode)
                if sel then
                    descLbl.Text = m.Desc
                end
                TweenService:Create(btns[i], TweenInfo.new(0.14), {
                    BackgroundColor3 = sel and theme.Secondary or COLORS.Card,
                    TextColor3 = sel and COLORS.DarkInk or COLORS.SubText,
                }):Play()
            end
        end
        UI.refreshModeHighlight = refreshHighlight

        local function selectMode(modeId)
            if modeId == "OS" and not HAS_KEYPRESS then
                modeId = "Direct"
            end
            CONFIG.InputMode = modeId
            refreshHighlight()
        end

        for i, m in ipairs(INPUT_MODES) do
            local btn = create("TextButton", {
                Size = UDim2.new(0.5, -4, 1, -4), Position = UDim2.new((i - 1) * 0.5, 2, 0, 2),
                BackgroundColor3 = COLORS.Card, BorderSizePixel = 0, Font = Enum.Font.GothamBold,
                Text = m.Name, TextColor3 = COLORS.SubText, TextSize = 14, AutoButtonColor = false,
            }, holder)
            btn.MouseButton1Click:Connect(function() selectMode(m.Id) end)
            btns[i] = btn
        end
        selectMode(CONFIG.InputMode)
    end

    local setTyposToggle
    setTyposToggle = makeToggleRow(
        page, 2, "Realistic Typos", "Occasionally mistypes a nearby key & fixes it",
        CONFIG.HumanTypos, COLORS.Amber,
        function(v)
            CONFIG.HumanTypos = v
            setTyposToggle(v)
        end
    )

    local setThinkToggle
    setThinkToggle = makeToggleRow(
        page, 3, "Think Pause", "Adds a 0.35s-1.0s reaction pause on your turn",
        CONFIG.ThinkDelay, COLORS.Cyan,
        function(v)
            CONFIG.ThinkDelay = v
            setThinkToggle(v)
        end
    )

    -- Live Turn Tracking Diagnostics Box
    local diagBox = create("Frame", {
        Size = UDim2.new(1, 0, 0, 44), BackgroundColor3 = COLORS.Card, BorderSizePixel = 0, LayoutOrder = 4,
    }, page)
    addBorder(diagBox, COLORS.SubBorder, 1)
    create("TextLabel", {
        Size = UDim2.new(1, -16, 0, 14), Position = UDim2.fromOffset(10, 4), BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold, Text = "TRACKER DIAGNOSTICS", TextColor3 = COLORS.SubText,
        TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left,
    }, diagBox)
    UI.diagLabel = create("TextLabel", {
        Size = UDim2.new(1, -16, 0, 18), Position = UDim2.fromOffset(10, 20), BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium, Text = "Not calibrated", TextColor3 = COLORS.Cyan,
        TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
    }, diagBox)

    local guideBtn = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = COLORS.ButtonBg, BorderSizePixel = 0,
        Font = Enum.Font.GothamBold, Text = "OPEN QUICK START GUIDE", TextColor3 = COLORS.Text,
        TextSize = 13, AutoButtonColor = false, LayoutOrder = 5,
    }, page)
    addBorder(guideBtn, COLORS.Border, 1)
    guideBtn.MouseEnter:Connect(function()
        TweenService:Create(guideBtn, TweenInfo.new(0.12), { BackgroundColor3 = COLORS.CardHover }):Play()
    end)
    guideBtn.MouseLeave:Connect(function()
        TweenService:Create(guideBtn, TweenInfo.new(0.12), { BackgroundColor3 = COLORS.ButtonBg }):Play()
    end)
    guideBtn.MouseButton1Click:Connect(function()
        UI.showPopup(false)
    end)
end

function UI.build()
    local old = PlayerGui:FindFirstChild(UI_NAME)
    if old then
        old:Destroy()
    end

    local screenGui = create("ScreenGui", {
        Name = UI_NAME, ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, PlayerGui)
    UI.screenGui = screenGui

    local cam = workspace.CurrentCamera
    local vp = cam and cam.ViewportSize or Vector2.new(1920, 1080)
    local initX = 24
    local initY = math.max(24, math.floor((vp.Y - EXPANDED_H) * 0.5))
    UI.curX, UI.curY = initX, initY
    UI.dragTargetX, UI.dragTargetY = initX, initY

    local mainFrame = create("Frame", {
        Name = "MainFrame", Size = UDim2.fromOffset(EXPANDED_W, EXPANDED_H),
        Position = UDim2.fromOffset(initX, initY),
        BackgroundColor3 = COLORS.Bg, BorderSizePixel = 0, ClipsDescendants = true, Visible = false,
    }, screenGui)
    UI.mainStroke = addBorder(mainFrame, COLORS.Border, 1.4)
    UI.mainFrame = mainFrame

    buildHeaderAndTabs(mainFrame)
    buildCubeOverlay(mainFrame)

    local bodyFrame = create("Frame", {
        Size = UDim2.new(1, -24, 1, -142), Position = UDim2.fromOffset(12, 91), BackgroundTransparency = 1,
    }, mainFrame)
    UI.bodyFrame = bodyFrame

    local statusCard = create("Frame", {
        Size = UDim2.new(1, 0, 0, 54), BackgroundColor3 = COLORS.Card, BorderSizePixel = 0,
    }, bodyFrame)
    UI.statusStroke = addBorder(statusCard, COLORS.Amber, 1.2)
    UI.statusStripe = create("Frame", {
        Size = UDim2.new(0, 4, 1, 0), BackgroundColor3 = COLORS.Amber, BorderSizePixel = 0,
    }, statusCard)

    UI.statusTitle = create("TextLabel", {
        Size = UDim2.new(1, -24, 0, 21), Position = UDim2.fromOffset(14, 6), BackgroundTransparency = 1,
        Font = Enum.Font.GothamBlack, Text = "NOT CALIBRATED", TextColor3 = COLORS.Amber,
        TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
    }, statusCard)

    UI.statusDetail = create("TextLabel", {
        Size = UDim2.new(1, -24, 0, 19), Position = UDim2.fromOffset(14, 28), BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium, Text = "Wait for arrow on you, then press F1", TextColor3 = COLORS.SubText,
        TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
    }, statusCard)

    local tabContent = create("Frame", {
        Size = UDim2.new(1, 0, 1, -64), Position = UDim2.fromOffset(0, 64), BackgroundTransparency = 1,
    }, bodyFrame)

    buildPlayTab(tabContent)
    buildSettingsTab(tabContent)

    local footerFrame = create("Frame", {
        Size = UDim2.new(1, 0, 0, 42), Position = UDim2.new(0, 0, 1, -42),
        BackgroundColor3 = COLORS.Header, BorderSizePixel = 0,
    }, mainFrame)
    UI.footerFrame = footerFrame
    create("Frame", {
        Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = COLORS.Border, BorderSizePixel = 0,
    }, footerFrame)

    UI.statsLabel = create("TextLabel", {
        Size = UDim2.new(1, -16, 1, 0), Position = UDim2.fromOffset(8, 0), BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold, TextColor3 = COLORS.SubText, TextSize = 13, TextTruncate = Enum.TextTruncate.AtEnd,
    }, footerFrame)

    startSmoothDragLoop()
    UI.showPopup(true)
    UI.applyTheme()
    UI.updateStats()
    UI.setOtherWord(nil)

    if STATE.fileLoaded then
        UI.setStatus("NOT CALIBRATED", "Wait for arrow on you, then press F1", COLORS.Amber)
    else
        UI.setStatus("FILE ERROR", STATE.loadError or "Place word_bomb.txt in workspace", COLORS.Red)
    end

    task.spawn(function()
        while STATE.running and UI.statusDot and UI.statusDot.Parent do
            if STATE.isCalibrated and CONFIG.Enabled then
                TweenService:Create(UI.statusDot, TweenInfo.new(0.75, Enum.EasingStyle.Sine), { BackgroundTransparency = 0.45 }):Play()
                if UI.cubeStatusDot then
                    TweenService:Create(UI.cubeStatusDot, TweenInfo.new(0.75, Enum.EasingStyle.Sine), { BackgroundTransparency = 0.45 }):Play()
                end
                task.wait(0.75)
                if not STATE.running or not UI.statusDot or not UI.statusDot.Parent then
                    break
                end
                TweenService:Create(UI.statusDot, TweenInfo.new(0.75, Enum.EasingStyle.Sine), { BackgroundTransparency = 0 }):Play()
                if UI.cubeStatusDot then
                    TweenService:Create(UI.cubeStatusDot, TweenInfo.new(0.75, Enum.EasingStyle.Sine), { BackgroundTransparency = 0 }):Play()
                end
                task.wait(0.75)
            else
                UI.statusDot.BackgroundTransparency = 0
                if UI.cubeStatusDot then
                    UI.cubeStatusDot.BackgroundTransparency = 0
                end
                task.wait(0.35)
            end
        end
    end)
end

-- ============================================================================
-- 3. GUI, COMBO & SELF-HEALING ARROW DETECTOR MODULE
-- ============================================================================
local function angleDiff(a, b)
    return math.abs((a - b + 180) % 360 - 180)
end

local function getRelativePath(obj, root)
    local parts = {}
    local cur = obj
    while cur and cur ~= root and cur ~= PlayerGui do
        table.insert(parts, 1, cur.Name)
        cur = cur.Parent
    end
    return table.concat(parts, "/")
end

local function isTurnKeyword(name)
    local n = name:lower()
    return n:find("turn", 1, true)
        or n:find("currentplayer", 1, true)
        or n:find("activeplayer", 1, true)
        or n:find("bombtarget", 1, true)
        or n:find("typer", 1, true)
        or n == "current"
        or n == "active"
        or n == "target"
end

function Detector.isGuiVisible(obj)
    if not obj or not obj:IsA("GuiObject") then
        return false
    end
    if not obj.Visible or obj.AbsoluteSize.X < 2 or obj.AbsoluteSize.Y < 2 then
        return false
    end
    local cur = obj.Parent
    while cur and cur ~= PlayerGui do
        if cur:IsA("GuiObject") and not cur.Visible then
            return false
        elseif cur:IsA("ScreenGui") and not cur.Enabled then
            return false
        end
        cur = cur.Parent
    end
    return cur == PlayerGui
end

function Detector.isChatOrSidebar(obj)
    local cur = obj
    while cur and cur ~= PlayerGui do
        local n = cur.Name:lower()
        if n:find("chat", 1, true) or n:find("playerlist", 1, true) or n:find("leaderboard", 1, true) or n:find("sidebar", 1, true) then
            return true
        end
        cur = cur.Parent
    end
    if obj:IsA("TextBox") then
        local ph = (obj.PlaceholderText or ""):lower()
        if ph:find("chat", 1, true) or ph:find("press /", 1, true) then
            return true
        end
    end
    return false
end

function Detector.getActiveScreenGuis()
    local guis = {}
    for _, child in ipairs(PlayerGui:GetChildren()) do
        if child:IsA("ScreenGui") and child.Enabled and child.Name ~= UI_NAME and not child.Name:lower():find("chat", 1, true) then
            table.insert(guis, child)
        end
    end
    return guis
end

function Detector.isInsidePromptBand(guiObj, promptLabel)
    if not promptLabel or not promptLabel.Parent or not guiObj:IsA("GuiObject") then
        return false
    end
    local pPos, pSize = promptLabel.AbsolutePosition, promptLabel.AbsoluteSize
    local pos, size = guiObj.AbsolutePosition, guiObj.AbsoluteSize
    local dy = pos.Y - (pPos.Y + pSize.Y)
    return dy >= -8 and dy <= 55 and math.abs((pos.X + size.X * 0.5) - (pPos.X + pSize.X * 0.5)) <= 145
end

function Detector.extractCombo(promptLabel, rootGui)
    local pPos, pSize = promptLabel.AbsolutePosition, promptLabel.AbsoluteSize
    local pCenterX, pBottomY = pPos.X + pSize.X * 0.5, pPos.Y + pSize.Y
    local candidates, multiCandidate, multiBestDy = {}, nil, 999

    for _, desc in ipairs(rootGui:GetDescendants()) do
        if desc:IsA("TextLabel") and desc ~= promptLabel and Detector.isGuiVisible(desc) and not Detector.isChatOrSidebar(desc) then
            local cleaned = (desc.Text or ""):gsub("<[^>]+>", ""):gsub("%s+", ""):upper()
            local pos, size = desc.AbsolutePosition, desc.AbsoluteSize
            local centerX, dy = pos.X + size.X * 0.5, pos.Y - pBottomY

            if dy >= -2 and dy <= 52 and math.abs(centerX - pCenterX) <= 135 then
                if cleaned:match("^%a$") then
                    table.insert(candidates, { char = cleaned, x = centerX, y = pos.Y, w = size.X, h = size.Y, dy = dy })
                elseif cleaned:match("^%a%a%a?%a?$") and dy < multiBestDy then
                    multiBestDy, multiCandidate = dy, cleaned
                end
            end
        end
    end

    if #candidates >= 2 then
        table.sort(candidates, function(a, b) return a.dy < b.dy end)
        local anchor, rowTiles = candidates[1], {}
        for _, tile in ipairs(candidates) do
            if math.abs(tile.y - anchor.y) <= 10 and math.abs(tile.h - anchor.h) <= 12 then
                table.insert(rowTiles, tile)
            end
        end
        table.sort(rowTiles, function(a, b) return a.x < b.x end)

        local deduped, lastX = {}, nil
        for _, tile in ipairs(rowTiles) do
            if not lastX or (tile.x - lastX) >= math.max(tile.w * 0.4, 8) then
                table.insert(deduped, tile.char)
                lastX = tile.x
            end
        end
        if #deduped >= 2 and #deduped <= 4 then
            return table.concat(deduped)
        end
    end

    return multiCandidate
end

function Detector.findComboAndGui()
    for _, gui in ipairs(Detector.getActiveScreenGuis()) do
        for _, desc in ipairs(gui:GetDescendants()) do
            if desc:IsA("TextLabel") and Detector.isGuiVisible(desc) and not Detector.isChatOrSidebar(desc) then
                local low = desc.Text:lower()
                if low:find("containing", 1, true) or low:find("word with", 1, true) then
                    return Detector.extractCombo(desc, gui), gui, desc
                end
            end
        end
    end
    return nil, nil, nil
end

function Detector.findTypebox(preferredGui)
    local cam = workspace.CurrentCamera
    local vp = cam and cam.ViewportSize or Vector2.new(1920, 1080)
    local bestBox, bestScore = nil, -999

    for _, gui in ipairs(Detector.getActiveScreenGuis()) do
        for _, desc in ipairs(gui:GetDescendants()) do
            if desc:IsA("TextBox") and desc.TextEditable and Detector.isGuiVisible(desc) and not Detector.isChatOrSidebar(desc) then
                if desc.AbsoluteSize.X >= 40 and desc.AbsoluteSize.Y >= 14 then
                    local score = (preferredGui and gui == preferredGui) and 50 or 0
                    local n = desc.Name:lower()
                    if n:find("type") or n:find("word") or n:find("input") or n:find("answer") then
                        score += 30
                    end
                    local cx = desc.AbsolutePosition.X + desc.AbsoluteSize.X * 0.5
                    local cy = desc.AbsolutePosition.Y + desc.AbsoluteSize.Y * 0.5
                    if math.abs(cx - vp.X * 0.5) < vp.X * 0.25 then
                        score += 25
                    end
                    if cy > vp.Y * 0.55 then
                        score += 15
                    end
                    if desc.AbsoluteSize.X >= 180 then
                        score += 10
                    end
                    if score > bestScore then
                        bestScore, bestBox = score, desc
                    end
                end
            end
        end
    end
    return bestBox
end

function Detector.resolvePlayer(val)
    if typeof(val) == "Instance" and val:IsA("Player") then
        return val
    elseif type(val) == "string" then
        return STATE.playerLookup[val:lower()]
    elseif type(val) == "number" and val > 0 then
        return STATE.playerByIdStr[tostring(math.floor(val))]
    end
    return nil
end

function Detector.matchPlayerFromLabel(rawText)
    if type(rawText) ~= "string" or rawText == "" then
        return nil
    end
    local clean = rawText:gsub("<[^>]+>", ""):match("^%s*(.-)%s*$")
    if not clean or clean == "" then
        return nil
    end
    clean = clean:gsub("^@", "")
    local low = clean:lower()

    local exact = STATE.playerLookup[low]
    if exact then
        return exact
    end

    local prefix = low:match("^(.+)%.%.%.$")
    if prefix and #prefix >= 4 then
        for nameKey, plr in pairs(STATE.playerLookup) do
            if nameKey:sub(1, #prefix) == prefix then
                return plr
            end
        end
    end

    return nil
end

-- Strict replicated turn-state scanner: ONLY accepts explicitly turn-named values
-- that started on LocalPlayer during F1 calibration and transitioned away to another player.
function Detector.scanReplicatedTurnState(promptGui, forceNow)
    local now = os.clock()
    if not forceNow and (now - STATE.lastStateScan) < 0.8 then
        return
    end
    STATE.lastStateScan = now

    local roots = { ReplicatedStorage, workspace, LocalPlayer }
    if promptGui then
        table.insert(roots, promptGui)
    end

    local function register(key, kind, obj, attr, keywordName, val)
        if not isTurnKeyword(keywordName) then
            return
        end
        local plr = Detector.resolvePlayer(val)
        if not plr then
            return
        end
        local entry = STATE.stateCandidates[key]
        if not entry then
            if forceNow and plr == LocalPlayer then
                STATE.stateCandidates[key] = { kind = kind, obj = obj, attr = attr, lastPlr = plr, startedOnMe = true }
            end
        elseif entry.startedOnMe and entry.lastPlr ~= plr then
            entry.lastPlr = plr
            if not STATE.confirmedState then
                STATE.confirmedState = entry
                STATE.arrowMotionVerified = true
                STATE.turnSourceText = "State*"
                UI.updateCalibration()
            end
        end
    end

    for _, root in ipairs(roots) do
        pcall(function()
            for attr, val in pairs(root:GetAttributes()) do
                register(root:GetFullName() .. "@" .. attr, "attr", root, attr, attr, val)
            end
            for _, desc in ipairs(root:GetDescendants()) do
                if desc:IsA("ObjectValue") or desc:IsA("StringValue") or desc:IsA("IntValue") or desc:IsA("NumberValue") then
                    register(desc:GetFullName(), "val", desc, nil, desc.Name, desc.Value)
                end
                local attrs = desc:GetAttributes()
                if next(attrs) ~= nil then
                    for attr, val in pairs(attrs) do
                        register(desc:GetFullName() .. "@" .. attr, "attr", desc, attr, attr, val)
                    end
                end
            end
        end)
    end
end

function Detector.readReplicatedTurnPlayer()
    local st = STATE.confirmedState
    if not st then
        return nil
    end
    if not st.obj or not st.obj.Parent then
        STATE.confirmedState = nil
        return nil
    end
    local val = (st.kind == "val") and st.obj.Value or st.obj:GetAttribute(st.attr)
    return Detector.resolvePlayer(val)
end

function Detector.findArenaPlayers(promptGui)
    local now = os.clock()
    local cam = workspace.CurrentCamera
    local vp = cam and cam.ViewportSize or Vector2.new(1920, 1080)
    local maxX = vp.X * 0.85
    local minY = -45
    local maxY = vp.Y - 15

    local found = {}

    local function scanGui(rootGui)
        if not rootGui then
            return
        end
        for _, desc in ipairs(rootGui:GetDescendants()) do
            local isText = desc:IsA("TextLabel")
            local isImg = (not isText) and (desc:IsA("ImageLabel") or desc:IsA("ImageButton"))

            if (isText or isImg) and Detector.isGuiVisible(desc) and not Detector.isChatOrSidebar(desc) then
                local cx = desc.AbsolutePosition.X + desc.AbsoluteSize.X * 0.5
                local cy = desc.AbsolutePosition.Y + desc.AbsoluteSize.Y * 0.5

                if cx > 10 and cx < maxX and cy >= minY and cy <= maxY then
                    if isText then
                        local plr = Detector.matchPlayerFromLabel(desc.Text)
                        if plr and not found[plr] then
                            found[plr] = Vector2.new(cx, cy + 28)
                        end
                    elseif isImg then
                        local img = desc.Image
                        if type(img) == "string" and img ~= "" and desc.AbsoluteSize.X >= 22 and desc.AbsoluteSize.X <= 160 then
                            local idStr = img:match("[?&]id=(%d+)") or img:match("userid=(%d+)")
                            if idStr then
                                local plr = STATE.playerByIdStr[idStr]
                                if plr and not found[plr] then
                                    found[plr] = Vector2.new(cx, cy)
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    scanGui(promptGui)

    if not found[LocalPlayer] then
        for _, gui in ipairs(Detector.getActiveScreenGuis()) do
            if gui ~= promptGui then
                scanGui(gui)
            end
        end
    end

    local list, sum = {}, Vector2.new(0, 0)
    for plr, pos in pairs(found) do
        table.insert(list, { player = plr, pos = pos })
        sum += pos
    end

    if #list > 0 then
        STATE.cachedArenaPlayers = list
        STATE.cachedArenaCenter = sum / #list
        STATE.cachedArenaAt = now
        return list, STATE.cachedArenaCenter
    end
    if (now - STATE.cachedArenaAt) <= 1.0 and #STATE.cachedArenaPlayers > 0 then
        return STATE.cachedArenaPlayers, STATE.cachedArenaCenter
    end
    return {}, nil
end

function Detector.beginF1Calibration(promptGui)
    refreshPlayerCache()

    -- Clear any previous replicated state lock so recalibration starts 100% fresh
    table.clear(STATE.stateCandidates)
    table.clear(STATE.reacquireHistory)
    STATE.confirmedState = nil
    Detector.scanReplicatedTurnState(promptGui, true)

    local arenaPlayers, arenaCenter = Detector.findArenaPlayers(promptGui)
    if not arenaCenter then
        return false, "Could not find players in arena"
    end

    local myPos = nil
    for _, p in ipairs(arenaPlayers) do
        if p.player == LocalPlayer then
            myPos = p.pos
            break
        end
    end
    if not myPos then
        return false, "Could not find your name in arena"
    end

    -- Brief pause so if F1 was pressed mid-swing, the arrow finishes settling on you
    task.wait(0.06)

    STATE.calMyPos = myPos
    STATE.calArenaCenter = arenaCenter
    table.clear(STATE.calSnapshots)
    STATE.confirmedArrow = nil
    STATE.manualArrowOffset = nil
    STATE.learnedArrowName = nil
    STATE.learnedArrowPath = nil
    STATE.arrowMotionVerified = (#arenaPlayers <= 1)

    for _, desc in ipairs(promptGui:GetDescendants()) do
        if (desc:IsA("ImageLabel") or desc:IsA("ImageButton") or desc:IsA("Frame"))
            and Detector.isGuiVisible(desc) and not Detector.isChatOrSidebar(desc)
        then
            local n = desc.Name:lower()
            local skip = n:find("spark", 1, true) or n:find("particle", 1, true) or n:find("heart", 1, true)
                or n:find("avatar", 1, true) or n:find("profile", 1, true) or n:find("headshot", 1, true)
            if not skip then
                local center = desc.AbsolutePosition + desc.AbsoluteSize * 0.5
                local dist = (center - arenaCenter).Magnitude
                if dist <= 280 and desc.AbsoluteSize.X >= 14 and desc.AbsoluteSize.Y >= 14 and desc.AbsoluteSize.X <= 460 then
                    local named = n:find("arrow", 1, true) or n:find("pointer", 1, true) or n:find("needle", 1, true) or n:find("hand", 1, true)
                    table.insert(STATE.calSnapshots, {
                        obj = desc,
                        path = getRelativePath(desc, promptGui),
                        rot = desc.AbsoluteRotation,
                        center = center,
                        isImage = desc:IsA("ImageLabel") or desc:IsA("ImageButton"),
                        named = named ~= nil,
                        dist = dist,
                    })
                end
            end
        end
    end

    STATE.isCalibrated = true
    STATE.turnSourceText = STATE.arrowMotionVerified and "Solo*" or "Sync..."
    UI.setDiag(string.format("Synced %d candidates • waiting for spin", #STATE.calSnapshots))
    UI.updateCalibration()
    return true, nil
end

function Detector.getDynamicPivot(arrowObj, arenaCenter)
    if STATE.learnedPivotMode == "self" and arrowObj and arrowObj:IsA("GuiObject") then
        return arrowObj.AbsolutePosition + arrowObj.AbsoluteSize * 0.5
    elseif STATE.learnedPivotMode == "parent" and arrowObj and arrowObj.Parent and arrowObj.Parent:IsA("GuiObject") then
        return arrowObj.Parent.AbsolutePosition + arrowObj.Parent.AbsoluteSize * 0.5
    end
    return arenaCenter
end

function Detector.tryVerifyMovingArrow()
    if STATE.arrowMotionVerified or #STATE.calSnapshots == 0 or not STATE.calMyPos then
        return STATE.arrowMotionVerified
    end

    local bestRot, bestRotScore = nil, -999
    local bestPos, bestPosScore = nil, -999

    for _, snap in ipairs(STATE.calSnapshots) do
        local obj = snap.obj
        if obj and obj.Parent and Detector.isGuiVisible(obj) then
            local curCenter = obj.AbsolutePosition + obj.AbsoluteSize * 0.5
            local dRot = angleDiff(obj.AbsoluteRotation, snap.rot)
            local dPos = (curCenter - snap.center).Magnitude

            -- Require >= 18 deg jump so small bomb wobble/idle animations never falsely qualify
            if dRot >= 18 then
                local score = (snap.named and 240 or 0) + (snap.isImage and 40 or 0) + (280 - snap.dist) + (dPos <= 6 and 90 or 0) + math.min(dRot, 120)
                if score > bestRotScore then
                    bestRotScore, bestRot = score, snap
                end
            elseif dPos >= 22 then
                local score = (snap.named and 240 or 0) + (snap.isImage and 40 or 0) + dPos
                if score > bestPosScore then
                    bestPosScore, bestPos = score, snap
                end
            end
        end
    end

    if bestRot then
        local obj = bestRot.obj
        local curCenter = obj.AbsolutePosition + obj.AbsoluteSize * 0.5
        local pivot

        if (curCenter - bestRot.center).Magnitude <= 8 then
            STATE.learnedPivotMode = "self"
            pivot = bestRot.center
        elseif obj.Parent and obj.Parent:IsA("GuiObject") and obj.Parent.AbsoluteSize.X <= 460 then
            STATE.learnedPivotMode = "parent"
            pivot = obj.Parent.AbsolutePosition + obj.Parent.AbsoluteSize * 0.5
        else
            STATE.learnedPivotMode = "arena"
            pivot = STATE.calArenaCenter
        end

        local v = STATE.calMyPos - pivot
        STATE.manualArrowOffset = (math.deg(math.atan2(v.Y, v.X)) - bestRot.rot) % 360
        STATE.confirmedArrow = obj
        STATE.learnedArrowName = obj.Name
        STATE.learnedArrowPath = bestRot.path
        STATE.arrowMode = "rot"
        STATE.arrowMotionVerified = true
        STATE.turnSourceText = "Arrow*"
        UI.setDiag(string.format("Locked: %s (off %.0f°)", obj.Name, STATE.manualArrowOffset))
        UI.updateCalibration()
        return true
    end

    if bestPos then
        STATE.confirmedArrow = bestPos.obj
        STATE.learnedArrowName = bestPos.obj.Name
        STATE.learnedArrowPath = bestPos.path
        STATE.learnedPivotMode = "arena"
        STATE.arrowMode = "pos"
        STATE.arrowMotionVerified = true
        STATE.turnSourceText = "Arrow*"
        UI.setDiag("Locked pos arrow: " .. bestPos.obj.Name)
        UI.updateCalibration()
        return true
    end

    return false
end

-- Self-healing arrow reacquisition: matches exact relative path first, then falls back to live rotation jump
function Detector.reacquireArrow(promptGui, arenaCenter)
    if STATE.confirmedArrow and STATE.confirmedArrow.Parent and Detector.isGuiVisible(STATE.confirmedArrow) then
        return STATE.confirmedArrow
    end
    STATE.confirmedArrow = nil
    if not promptGui or not arenaCenter then
        return nil
    end

    -- 1. Exact relative path match (prevents grabbing generic "ImageLabel" bomb sprites)
    if STATE.learnedArrowPath then
        for _, desc in ipairs(promptGui:GetDescendants()) do
            if desc.Name == STATE.learnedArrowName and desc:IsA("GuiObject") and Detector.isGuiVisible(desc) then
                if getRelativePath(desc, promptGui) == STATE.learnedArrowPath then
                    STATE.confirmedArrow = desc
                    return desc
                end
            end
        end
    end

    -- 2. Motion-verified reacquisition if the GUI hierarchy changed between rounds
    for _, desc in ipairs(promptGui:GetDescendants()) do
        if (desc:IsA("ImageLabel") or desc:IsA("ImageButton") or desc:IsA("Frame"))
            and Detector.isGuiVisible(desc) and not Detector.isChatOrSidebar(desc)
        then
            local center = desc.AbsolutePosition + desc.AbsoluteSize * 0.5
            if (center - arenaCenter).Magnitude <= 280 and desc.AbsoluteSize.X >= 14 and desc.AbsoluteSize.X <= 460 then
                local rot = desc.AbsoluteRotation
                local prev = STATE.reacquireHistory[desc]
                if prev and angleDiff(rot, prev) >= 18 then
                    STATE.confirmedArrow = desc
                    STATE.learnedArrowName = desc.Name
                    STATE.learnedArrowPath = getRelativePath(desc, promptGui)
                    table.clear(STATE.reacquireHistory)
                    return desc
                end
                STATE.reacquireHistory[desc] = rot
            end
        end
    end

    return nil
end

function Detector.detectArrowTurnPlayer(promptGui)
    local arenaPlayers, arenaCenter = Detector.findArenaPlayers(promptGui)
    if #arenaPlayers == 0 or not arenaCenter then
        UI.setDiag("No arena players visible")
        return nil, false, nil
    end
    if #arenaPlayers == 1 and arenaPlayers[1].player == LocalPlayer then
        UI.setDiag("Solo match • Your turn")
        return LocalPlayer, true, arenaPlayers[1].pos
    end
    if not STATE.arrowMotionVerified then
        return nil, false, nil
    end

    local arrowObj = Detector.reacquireArrow(promptGui, arenaCenter)
    if not arrowObj then
        UI.setDiag("Reacquiring arrow...")
        return nil, false, nil
    end

    local pivot = Detector.getDynamicPivot(arrowObj, arenaCenter)
    local now = os.clock()
    local pointAngle = nil

    if STATE.arrowMode == "pos" then
        local ov = (arrowObj.AbsolutePosition + arrowObj.AbsoluteSize * 0.5) - pivot
        if ov.Magnitude < 8 then
            return nil, false, nil
        end
        pointAngle = math.deg(math.atan2(ov.Y, ov.X)) % 360
    else
        if STATE.manualArrowOffset == nil then
            return nil, false, nil
        end
        pointAngle = (arrowObj.AbsoluteRotation + STATE.manualArrowOffset) % 360
    end

    if STATE.lastArrowSample == nil or angleDiff(pointAngle, STATE.lastArrowSample) >= 4.0 then
        STATE.lastArrowSample = pointAngle
        STATE.arrowStableSince = now
    end
    local isStable = (now - STATE.arrowStableSince) >= CONFIG.ArrowStableTime

    local bestPlr, bestPos, bestDiff, secondDiff = nil, nil, 999, 999
    for _, p in ipairs(arenaPlayers) do
        local v = p.pos - pivot
        local d = angleDiff(pointAngle, math.deg(math.atan2(v.Y, v.X)))
        if d < bestDiff then
            secondDiff, bestDiff, bestPlr, bestPos = bestDiff, d, p.player, p.pos
        elseif d < secondDiff then
            secondDiff = d
        end
    end

    -- Adaptive cone scales cleanly from 2-player lobbies up to 12+ player circles
    local maxCone = math.clamp(180 / #arenaPlayers, 20, 48)
    local marginOk = (#arenaPlayers <= 2) or ((secondDiff - bestDiff) >= 2)

    if bestPlr then
        UI.setDiag(string.format("%s | %s (%.0f°) | %dp", arrowObj.Name, bestPlr.DisplayName, bestDiff, #arenaPlayers))
    end

    if bestPlr and bestDiff <= maxCone and marginOk then
        if bestPlr ~= STATE.samePlayerTarget then
            STATE.samePlayerTarget, STATE.samePlayerSince = bestPlr, now
        end
        return bestPlr, (isStable or (now - STATE.samePlayerSince) >= 0.25), bestPos
    end
    return nil, false, nil
end

function Detector.detectTurn(promptGui)
    Detector.scanReplicatedTurnState(promptGui, false)
    local statePlr = Detector.readReplicatedTurnPlayer()
    if statePlr then
        local pos = nil
        for _, p in ipairs(STATE.cachedArenaPlayers) do
            if p.player == statePlr then
                pos = p.pos
                break
            end
        end
        UI.setDiag("State* | " .. statePlr.DisplayName)
        return (statePlr == LocalPlayer), statePlr, "State*", true, pos
    end

    local arrowPlr, arrowStable, plrPos = Detector.detectArrowTurnPlayer(promptGui)
    if arrowPlr then
        return (arrowPlr == LocalPlayer), arrowPlr, "Arrow*", arrowStable, plrPos
    end

    return false, nil, STATE.arrowMotionVerified and "Scan" or "Sync...", false, nil
end

-- ============================================================================
-- 4. OTHER-PLAYER WORD TRACKER MODULE
-- ============================================================================
function Tracker.disconnectListeners()
    for _, c in ipairs(STATE.guiListenerConns) do
        if c.Connected then
            c:Disconnect()
        end
    end
    table.clear(STATE.guiListenerConns)
    STATE.hookedPromptGui = nil
end

function Tracker.extractStrictWord(rawText)
    if type(rawText) ~= "string" or rawText == "" then
        return nil
    end
    local cleaned = rawText:gsub("<[^>]+>", ""):match("^%s*(.-)%s*$")
    if not cleaned or cleaned == "" then
        return nil
    end
    cleaned = cleaned:gsub("[|_]+$", ""):match("^%s*(.-)%s*$")
    if cleaned and cleaned:match("^[A-Za-z]+$") then
        return cleaned:lower()
    end
    return nil
end

function Tracker.isHighConfidenceObj(obj)
    if not obj or not obj:IsA("GuiObject") then
        return false
    end
    if obj:IsA("TextBox") then
        return true
    end
    if STATE.lastDetectedBox and obj.Parent == STATE.lastDetectedBox.Parent then
        return true
    end

    local n = obj.Name:lower()
    if n:find("type", 1, true) or n:find("word", 1, true) or n:find("input", 1, true) or n:find("answer", 1, true) then
        return true
    end

    local cam = workspace.CurrentCamera
    local vp = cam and cam.ViewportSize or Vector2.new(1920, 1080)
    local cx = obj.AbsolutePosition.X + obj.AbsoluteSize.X * 0.5
    local cy = obj.AbsolutePosition.Y + obj.AbsoluteSize.Y * 0.5

    if cy > vp.Y * 0.58 and math.abs(cx - vp.X * 0.5) < vp.X * 0.34 then
        return true
    end
    if STATE.activeTurnPlayerPos and (Vector2.new(cx, cy) - STATE.activeTurnPlayerPos).Magnitude <= 155 then
        return true
    end
    return false
end

function Tracker.recordPending(word, confidence, fromLiveChange)
    if not word or not STATE.lockedCombo or STATE.isTyping or STATE.currentlyMyTurn then
        return
    end
    local lowerCombo = STATE.lockedCombo:lower()
    if #word < math.max(3, #lowerCombo) or #word > 34 or word == lowerCombo then
        return
    end
    if UI_STOPWORDS[word] or STATE.playerNamesSet[word] then
        return
    end
    if not word:find(lowerCombo, 1, true) then
        return
    end

    local inBank = (STATE.masterWordSet[word] == true)
    if not inBank and confidence < 2 and not fromLiveChange then
        return
    end

    local eff = confidence + (inBank and 2 or 0) + (fromLiveChange and 1 or 0)
    if not STATE.pendingOtherWord
        or eff > STATE.pendingOtherConf
        or (eff == STATE.pendingOtherConf and (#word >= #STATE.pendingOtherWord or STATE.pendingOtherWord:sub(1, #word) ~= word))
    then
        STATE.pendingOtherWord = word
        STATE.pendingOtherConf = eff
    end
end

local function inspectLiveTextObj(obj)
    if not STATE.running or not STATE.isCalibrated or STATE.isTyping or STATE.currentlyMyTurn or not STATE.lockedCombo then
        return
    end
    if obj == STATE.lastPromptLabel or not Detector.isGuiVisible(obj) then
        return
    end
    if Detector.isInsidePromptBand(obj, STATE.lastPromptLabel) then
        return
    end

    local w = Tracker.extractStrictWord(obj.Text)
    if w then
        Tracker.recordPending(w, Tracker.isHighConfidenceObj(obj) and 3 or 1, true)
    end
end

local function attachTextWatcher(obj)
    if not (obj:IsA("TextLabel") or obj:IsA("TextBox")) or Detector.isChatOrSidebar(obj) then
        return
    end
    if STATE.isCalibrated and not STATE.currentlyMyTurn then
        inspectLiveTextObj(obj)
    end
    table.insert(STATE.guiListenerConns, obj:GetPropertyChangedSignal("Text"):Connect(function()
        inspectLiveTextObj(obj)
    end))
end

function Tracker.ensureListeners(promptGui)
    if not promptGui or promptGui == STATE.hookedPromptGui then
        return
    end
    Tracker.disconnectListeners()
    STATE.hookedPromptGui = promptGui

    for _, desc in ipairs(promptGui:GetDescendants()) do
        attachTextWatcher(desc)
    end
    table.insert(STATE.guiListenerConns, promptGui.DescendantAdded:Connect(function(desc)
        if STATE.running and STATE.isCalibrated then
            attachTextWatcher(desc)
        end
    end))
end

function Tracker.observe(typebox, activeCombo, promptLabel)
    if not activeCombo or #activeCombo < 2 then
        return
    end
    local lowerCombo = activeCombo:lower()
    local bestWord, bestConf, bestScore = nil, -1, -1

    local function consider(w, conf)
        if not w or #w < math.max(3, #lowerCombo) or #w > 34 or w == lowerCombo then
            return
        end
        if UI_STOPWORDS[w] or STATE.playerNamesSet[w] or not w:find(lowerCombo, 1, true) then
            return
        end
        local inBank = (STATE.masterWordSet[w] == true)
        if conf < 2 and not inBank then
            return
        end
        local score = (conf * 40) + (#w * 3) + (inBank and 60 or 0)
        if score > bestScore then
            bestScore, bestWord, bestConf = score, w, conf
        end
    end

    if typebox then
        consider(Tracker.extractStrictWord(typebox.Text), 3)
        if typebox.Parent then
            for _, sib in ipairs(typebox.Parent:GetDescendants()) do
                if sib ~= typebox and sib:IsA("TextLabel") and Detector.isGuiVisible(sib) then
                    consider(Tracker.extractStrictWord(sib.Text), 3)
                end
            end
        end
    end

    local cam = workspace.CurrentCamera
    local arenaMaxX = (cam and cam.ViewportSize.X or 1920) * 0.84
    local singleTiles = {}

    for _, gui in ipairs(Detector.getActiveScreenGuis()) do
        for _, desc in ipairs(gui:GetDescendants()) do
            if (desc:IsA("TextLabel") or desc:IsA("TextBox"))
                and desc ~= promptLabel and Detector.isGuiVisible(desc)
                and not Detector.isChatOrSidebar(desc) and not Detector.isInsidePromptBand(desc, promptLabel)
            then
                local pos, size = desc.AbsolutePosition, desc.AbsoluteSize
                if pos.X < arenaMaxX and type(desc.Text) == "string" and desc.Text ~= "" then
                    local single = desc.Text:gsub("<[^>]+>", ""):match("^%s*([A-Za-z])%s*$")
                    if single then
                        table.insert(singleTiles, {
                            char = single:lower(), x = pos.X, y = pos.Y + size.Y * 0.5,
                            w = size.X, h = size.Y, highConf = Tracker.isHighConfidenceObj(desc),
                        })
                    else
                        local w = Tracker.extractStrictWord(desc.Text)
                        if w then
                            consider(w, Tracker.isHighConfidenceObj(desc) and 2 or 1)
                        end
                    end
                end
            end
        end
    end

    if #singleTiles >= 2 then
        table.sort(singleTiles, function(a, b) return a.y < b.y end)
        local clusters = {}
        for _, tile in ipairs(singleTiles) do
            local placed = false
            for _, cl in ipairs(clusters) do
                if math.abs(tile.y - cl.y) <= 12 and math.abs(tile.h - cl.h) <= 10 then
                    table.insert(cl.tiles, tile)
                    placed = true
                    break
                end
            end
            if not placed then
                table.insert(clusters, { y = tile.y, h = tile.h, tiles = { tile } })
            end
        end

        for _, cl in ipairs(clusters) do
            if #cl.tiles >= 2 then
                table.sort(cl.tiles, function(a, b) return a.x < b.x end)
                local runChars, runHigh, prev = {}, false, nil
                local function flush()
                    if #runChars >= 3 and #runChars <= 34 then
                        consider(table.concat(runChars), runHigh and 2 or 1)
                    end
                    table.clear(runChars)
                    runHigh = false
                end
                for _, t in ipairs(cl.tiles) do
                    if not prev then
                        table.insert(runChars, t.char)
                        runHigh, prev = t.highConf, t
                    else
                        local dx = t.x - prev.x
                        if dx >= 4 then
                            if dx <= math.max(prev.w * 1.8, 46) then
                                table.insert(runChars, t.char)
                                runHigh = runHigh or t.highConf
                            else
                                flush()
                                table.insert(runChars, t.char)
                                runHigh = t.highConf
                            end
                            prev = t
                        end
                    end
                end
                flush()
            end
        end
    end

    if bestWord then
        Tracker.recordPending(bestWord, bestConf, false)
    end
end

function Tracker.stashBeforeTurnChange(oldCombo)
    if STATE.pendingOtherWord and oldCombo then
        STATE.finishedOtherWord = STATE.pendingOtherWord
        STATE.finishedOtherCombo = oldCombo
        STATE.finishedOtherAt = os.clock()
    end
    STATE.pendingOtherWord = nil
    STATE.pendingOtherConf = 0
end

function Tracker.tryCommitFinished(newCombo)
    if not STATE.finishedOtherWord then
        return
    end

    if newCombo and STATE.finishedOtherCombo then
        if newCombo ~= STATE.finishedOtherCombo then
            if not STATE.usedWords[STATE.finishedOtherWord] then
                STATE.usedWords[STATE.finishedOtherWord] = true
                STATE.usedCount += 1
                STATE.otherUsedCount += 1
                UI.updateStats()
            end
            UI.setOtherWord(STATE.finishedOtherWord)
            STATE.finishedOtherWord, STATE.finishedOtherCombo = nil, nil
        elseif (os.clock() - STATE.finishedOtherAt) >= 0.55 then
            STATE.finishedOtherWord, STATE.finishedOtherCombo = nil, nil
        end
    elseif (os.clock() - STATE.finishedOtherAt) >= 2.0 then
        STATE.finishedOtherWord, STATE.finishedOtherCombo = nil, nil
    end
end

-- ============================================================================
-- 5. TYPING, SUBMISSION & CALIBRATION EXECUTION MODULE
-- ============================================================================
function Typer.sendOSKey(vkCode)
    if not HAS_KEYPRESS or not STATE.isWindowFocused then
        return false
    end
    return pcall(function()
        keypress(vkCode)
        task.wait(0.015)
        keyrelease(vkCode)
    end)
end

function Typer.sendSubmit(typebox)
    Typer.sendOSKey(0x0D)
    task.wait(0.03)
    if typebox then
        pcall(function()
            if typebox:IsFocused() then
                typebox:ReleaseFocus(true)
            end
        end)
        task.wait(0.02)
        pcall(function()
            if typebox:IsFocused() then
                typebox:ReleaseFocus(false)
            end
        end)
    end
end

function Typer.typeWord(typebox, word, isManual)
    if STATE.isTyping then
        return false
    end
    STATE.isTyping = true
    local completed = false

    local ok, err = pcall(function()
        if typebox then
            pcall(function() typebox:CaptureFocus() end)
            task.wait(0.05)
            pcall(function() typebox.Text = "" end)
        end

        local typedSoFar, madeTypo = "", false
        local function pushChar(ch)
            typedSoFar ..= ch
            if CONFIG.InputMode == "Direct" and typebox then
                typebox.Text = typedSoFar
            elseif not Typer.sendOSKey(string.byte(ch:upper())) and typebox then
                typebox.Text = typedSoFar
            end
        end
        local function pushBackspace()
            typedSoFar = typedSoFar:sub(1, math.max(0, #typedSoFar - 1))
            if CONFIG.InputMode == "Direct" and typebox then
                typebox.Text = typedSoFar
            elseif not Typer.sendOSKey(0x08) and typebox then
                typebox.Text = typedSoFar
            end
        end

        for i = 1, #word do
            if not STATE.running or (not isManual and not CONFIG.Enabled) then
                return
            end
            if typebox and not Detector.isGuiVisible(typebox) then
                return
            end

            local ch = word:sub(i, i):lower()
            if CONFIG.HumanTypos and not madeTypo and i > 1 and i < #word and math.random() < 0.08 then
                local nb = QWERTY_NEIGHBORS[ch]
                if nb and #nb > 0 then
                    madeTypo = true
                    local idx = math.random(1, #nb)
                    pushChar(nb:sub(idx, idx))
                    task.wait(0.09 + math.random() * 0.09)
                    pushBackspace()
                    task.wait(0.05 + math.random() * 0.07)
                end
            end

            pushChar(ch)
            task.wait(CONFIG.MinKeyDelay + math.random() * (CONFIG.MaxKeyDelay - CONFIG.MinKeyDelay))
        end

        if STATE.running and (isManual or CONFIG.Enabled) then
            task.wait(0.04)
            Typer.sendSubmit(typebox)
            completed = true
        end
    end)

    STATE.isTyping = false
    if not ok then
        UI.setStatus("TYPE ERROR", tostring(err), COLORS.Red)
    end
    return completed
end

function Typer.execute(combo, typebox, promptGui, isManual)
    if not STATE.fileLoaded then
        UI.setStatus("FILE ERROR", STATE.loadError or "Missing word_bomb.txt", COLORS.Red)
        return
    end
    if not combo or #combo < 2 then
        UI.setStatus("NO COMBO", "Wait for prompt letters to appear", COLORS.Amber)
        return
    end

    local word = Bank.findWord(combo)
    if not word then
        UI.setStatus("NO WORD FOUND", "No unused match for [" .. combo .. "]", COLORS.Amber)
        task.wait(0.8)
        return
    end

    STATE.usedWords[word] = true
    STATE.usedCount += 1
    STATE.mySentCount += 1
    STATE.pendingOtherWord = nil
    STATE.pendingOtherConf = 0
    UI.updateStats()

    UI.setStatus("TYPING (" .. CONFIG.InputMode .. ")", string.format("[%s] -> %s", combo, word), COLORS.Cyan)
    UI.setCombo(combo, true)

    local activeBox = (typebox and typebox.Parent) and typebox or Detector.findTypebox(promptGui)
    if not Typer.typeWord(activeBox, word, isManual) then
        return
    end

    local elapsed = 0
    while elapsed < CONFIG.RetryDelay and STATE.running do
        task.wait(0.06)
        elapsed += 0.06
        local curRaw, curGui = Detector.findComboAndGui()

        if not STATE.arrowMotionVerified then
            Detector.scanReplicatedTurnState(curGui or promptGui, false)
            if Detector.tryVerifyMovingArrow() then
                UI.unlockCombo(true)
                break
            end
        else
            local stillMine, curPlr = Detector.detectTurn(curGui or promptGui)
            if not stillMine then
                UI.unlockCombo(true)
                STATE.lockedForPlayer = curPlr
                STATE.trackedTurnPlayer = curPlr
                break
            elseif curRaw and curRaw ~= combo then
                STATE.lockedCombo = curRaw
                UI.setCombo(curRaw, true)
                break
            end
        end
    end

    if STATE.running and CONFIG.Enabled then
        if STATE.arrowMotionVerified then
            UI.setStatus("WAITING FOR TURN", "Submitted: " .. word, COLORS.Green)
        else
            UI.setStatus("VERIFYING ARROW", "Waiting for arrow to turn to next player...", COLORS.Amber)
        end
    end
end

function Typer.calibrateAndType()
    UI.dismissPopup()
    if STATE.isTyping then
        return
    end
    task.spawn(function()
        local ok, err = pcall(function()
            local rawCombo, promptGui, promptLabel = Detector.findComboAndGui()
            local activeGui = promptGui or STATE.lastPromptGui
            local typebox = Detector.findTypebox(activeGui)

            STATE.lastPromptGui = activeGui
            STATE.lastPromptLabel = promptLabel or STATE.lastPromptLabel
            STATE.lastDetectedBox = typebox or STATE.lastDetectedBox

            if not activeGui then
                UI.setStatus("NOT IN MATCH", "Join a round & press F1 on your turn", COLORS.Amber)
                return
            end

            local okCal, calErr = Detector.beginF1Calibration(activeGui)
            if not okCal then
                UI.setStatus("CALIBRATION FAILED", calErr or "Make sure arrow is on you & press F1", COLORS.Red)
                return
            end

            Tracker.ensureListeners(activeGui)
            STATE.lockedForPlayer = LocalPlayer
            STATE.trackedTurnPlayer = LocalPlayer
            STATE.wasMyTurn = true
            STATE.turnAttempts = 1

            if rawCombo and #rawCombo >= 2 then
                STATE.lockedCombo = rawCombo
                UI.setCombo(rawCombo, true)
                UI.setStatus("CALIBRATING...", "Typing word & syncing arrow...", COLORS.Cyan)
                Typer.execute(rawCombo, STATE.lastDetectedBox, activeGui, true)
            else
                UI.setStatus("CALIBRATING...", "Waiting for arrow motion...", COLORS.Amber)
            end
        end)

        if not ok then
            UI.setStatus("CALIBRATION ERROR", tostring(err), COLORS.Red)
        end
    end)
end

-- ============================================================================
-- 6. BOOTSTRAP UI, HOTKEYS (F1 & F2) & MAIN LOOP
-- ============================================================================
UI.build()

table.insert(STATE.connections, UserInputService.InputBegan:Connect(function(input, _gp)
    if not STATE.running then
        return
    end
    if input.KeyCode == CONFIG.CalibrateKey then
        Typer.calibrateAndType()
    elseif input.KeyCode == CONFIG.ResetUsedKey then
        UI.resetUsedWords()
    end
end))

task.spawn(function()
    while STATE.running do
        if not STATE.isCalibrated then
            task.wait(0.15)
            continue
        end

        task.wait(0.06)

        if STATE.fileLoaded and not STATE.isTyping then
            local ok, err = pcall(function()
                local rawCombo, promptGui, promptLabel = Detector.findComboAndGui()
                local typebox = Detector.findTypebox(promptGui)

                STATE.lastDetectedBox = typebox
                STATE.lastPromptGui = promptGui
                STATE.lastPromptLabel = promptLabel

                if promptGui then
                    Tracker.ensureListeners(promptGui)
                end

                if not STATE.arrowMotionVerified then
                    Detector.scanReplicatedTurnState(promptGui, false)
                    if promptGui then
                        Detector.tryVerifyMovingArrow()
                    end
                    if not STATE.arrowMotionVerified then
                        UI.setStatus("VERIFYING ARROW", "Waiting for arrow to move (F1 to retry)", COLORS.Amber)
                        return
                    end
                end

                local isMyTurn, turnPlr, src, turnStable, plrPos = Detector.detectTurn(promptGui)
                STATE.currentlyMyTurn = isMyTurn
                STATE.activeTurnPlayerPos = plrPos

                if src ~= STATE.turnSourceText then
                    STATE.turnSourceText = src
                    UI.updateStats()
                end

                if turnPlr and STATE.lockedForPlayer and turnPlr ~= STATE.lockedForPlayer then
                    if STATE.lockedForPlayer ~= LocalPlayer then
                        Tracker.stashBeforeTurnChange(STATE.lockedCombo)
                    end
                    UI.unlockCombo(true)
                    STATE.lockedForPlayer = turnPlr
                    STATE.trackedTurnPlayer = turnPlr
                elseif turnPlr and not STATE.lockedForPlayer then
                    STATE.lockedForPlayer = turnPlr
                    STATE.trackedTurnPlayer = turnPlr
                end

                if not promptGui then
                    STATE.promptMissingSince = STATE.promptMissingSince or os.clock()
                    if os.clock() - STATE.promptMissingSince >= 0.6 then
                        UI.unlockCombo(false)
                        STATE.lockedForPlayer = nil
                        STATE.trackedTurnPlayer = nil
                        STATE.wasMyTurn = false
                        STATE.turnAttempts = 0
                        STATE.lastAttemptSignature = nil
                        UI.setCombo("--", false)
                        UI.setStatus("WAITING FOR MATCH", "Press F2 to reset bank between rounds", COLORS.Amber)
                    end
                    return
                else
                    STATE.promptMissingSince = nil
                end

                if not STATE.lockedCombo and rawCombo and #rawCombo >= 2 then
                    if not STATE.prevTurnCombo or rawCombo ~= STATE.prevTurnCombo or (os.clock() - STATE.comboUnlockedAt) >= 0.40 then
                        STATE.lockedCombo = rawCombo
                        STATE.prevTurnCombo = nil
                        UI.setCombo(rawCombo, true)
                        Tracker.tryCommitFinished(rawCombo)
                    end
                elseif STATE.lockedCombo then
                    UI.setCombo(STATE.lockedCombo, true)
                    if STATE.finishedOtherWord and rawCombo and rawCombo ~= STATE.finishedOtherCombo then
                        Tracker.tryCommitFinished(rawCombo)
                    end
                end

                local activeCombo = STATE.lockedCombo

                if activeCombo and not isMyTurn then
                    Tracker.observe(typebox, activeCombo, promptLabel)
                end

                if not CONFIG.Enabled then
                    STATE.wasMyTurn = false
                    return
                end
                if not activeCombo then
                    UI.setStatus("READING COMBO", "Waiting for fresh prompt...", COLORS.Amber)
                    return
                end
                if not isMyTurn then
                    STATE.wasMyTurn = false
                    STATE.turnAttempts = 0
                    STATE.lastAttemptSignature = nil
                    UI.setStatus("WAITING FOR TURN", "Current turn: " .. (turnPlr and turnPlr.DisplayName or "Scanning..."), COLORS.Green)
                    return
                end
                if not turnStable then
                    UI.setStatus("ARROW MOVING", "Waiting for turn to settle...", COLORS.Amber)
                    return
                end

                local sig = activeCombo .. "|" .. tostring(STATE.lockedForPlayer)
                if sig ~= STATE.lastAttemptSignature then
                    STATE.lastAttemptSignature = sig
                    STATE.turnAttempts = 0
                end
                if STATE.turnAttempts >= CONFIG.MaxAttemptsPerTurn then
                    UI.setStatus("TURN CAP REACHED", "Waiting for next turn (F1 to force)", COLORS.Amber)
                    return
                end

                if not STATE.wasMyTurn then
                    STATE.wasMyTurn = true
                    UI.setStatus("YOUR TURN!", "Locking combo (" .. src .. ")...", COLORS.Cyan)
                    task.wait(CONFIG.TurnSettleDelay)

                    if CONFIG.ThinkDelay then
                        local think = 0.35 + math.random() * 0.65
                        UI.setStatus("THINKING...", string.format("Waiting %.2fs...", think), COLORS.Cyan)
                        local waited = 0
                        while waited < think and STATE.running and CONFIG.Enabled do
                            task.wait(0.05)
                            waited += 0.05
                        end
                    end

                    local freshRaw, freshGui = Detector.findComboAndGui()
                    local freshBox = Detector.findTypebox(freshGui)
                    local stillMine, freshPlr = Detector.detectTurn(freshGui or promptGui)
                    if not stillMine or not CONFIG.Enabled then
                        STATE.wasMyTurn = false
                        return
                    end
                    if not STATE.lockedCombo and freshRaw then
                        STATE.lockedCombo = freshRaw
                        UI.setCombo(freshRaw, true)
                    end
                    STATE.lockedForPlayer = freshPlr or STATE.lockedForPlayer
                    activeCombo = STATE.lockedCombo or freshRaw
                    typebox = freshBox or typebox
                    promptGui = freshGui or promptGui
                end

                STATE.turnAttempts += 1
                Typer.execute(activeCombo, typebox, promptGui, false)
            end)

            if not ok then
                UI.setStatus("RUNTIME ERROR", tostring(err), COLORS.Red)
                task.wait(1)
            end
        end
    end
end)
-- Roblox script for Word Bomb by OMG. Made by Shall, with the use of Gemini, and Claude.
-- !!! I USED POTASSIUM EXECUTOR FOR THIS, I DONT KNOW ABOUT MOBILE eg: Delta OR OTHER FREE EXECUTORS eg: Xeno. SO IF IT DOESNT WORK, I AM REALLY SORRY, I WILL WORK ON AN OPTIMIZATION IF THAT HAPPENS !!!

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local HAS_KEYPRESS = (type(keypress) == "function" and type(keyrelease) == "function")

-- Configuration and constants
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

--[[This is an embedded word bank, meaning you dont have to have a .txt in your executor workspace for it to work.
It contains, probably, all current letter combos in the game. This word bank is 100% AI generated.
Word bank ends on line 7492]]
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
[BK] lambkin, lebkuchen, knobkerrie, subkingdom, lambkins, knobkerries, subkingdoms
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
[BZ] subzero
[CA] cabin, cactus, cake, camera, car, can, caption
[CB] ecbolic
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
[CP] acpt, ecphoneses, ecphonesis
[CQ] acquire, becquerel, reacquire, lacquer, jacquard, racquetball, unacquainted
[CR] crab, craft, crane, cream, crown, macro, description
[CS] basics, comics, graphics, optics, physics, metrics, docs
[CT] act, cactus, doctor, fact, picture, object, function
[CU] cub, cucumber, cup, rescue, current, circuit, document
[CV] xcvii, xcvi
[CW] colicweed
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
[DQ] headquarters, hindquarters, headquarter, hindquarter
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
[FC] briefcase, offcuts, beefcake, chiffchaff, halfcocked, beefcakes, briefcases
[FD] fiefdom, serfdom, chiefdom, fiefdoms
[FE] fear, feather, fence, giraffe, safe, buffer, reference
[FF] cliff, coffee, fluff, muffin, waffle, offset, buffer
[FG] afghani, roofgarden, afghan, afghans, afghanis
[FH] offhand, selfheal, wolfhound, leafhopper, cliffhanger, halfhearted, selfhood
[FI] field, fig, fire, fish, file, define, first
[FJ] fjord, fjeld, fjords
[FK] offkey
[FL] flag, flame, flash, flower, fly, float, floor
[FM] turfman, staffman, engulfment
[FN] stiffness, hafnium, briefness, deafness, aloofness, bluffness, gruffness
[FO] foam, fog, food, forest, fox, format, font
[FP] offprint, halfpence, surfperch, halfpenny, offprints, halfpennies
[FR] frame, free, fresh, friend, frog, from, freq
[FS] briefs, chefs, cliffs, puffs, roofs, offset, refs
[FT] after, craft, gift, left, soft, shift, draft
[FU] fudge, fuel, fun, future, fusion, full, useful
[FW] halfway, beefwood, gulfweed, fwy, halfwit, halfwitted, halfwits
[FY] clarify, comfy, defy, leafy, verify, modify, simplify
[GA] galaxy, game, garage, garden, gate, gamma, negative
[GB] eggbeater, logbook, ragbag, tugboat, dingbat, songbird, rugby
[GC] eggcup, dogcart, kingcup, lingcod, agcy, longcloth, kingcraft
[GD] kingdom, ringdove, fogdog, ogdoad, hangdog, smaragd, amygdala
[GE] gear, gecko, gem, orange, tiger, get, range
[GF] bigfoot, dogfight, hagfish, kingfish, segfault, meaningful, bagful
[GG] bigger, dagger, egg, giggle, juggle, logger, ragged
[GH] bright, ghost, high, light, night, height, right
[GI] giant, gift, ginger, giraffe, magic, begin, given
[GJ] logjam, logjams
[GL] glad, glass, globe, glove, glow, single, angle
[GM] dogma, enigma, magma, pigment, stigma, sigma, segment
[GN] align, design, gnome, magnet, sign, ignore, gnu
[GO] goat, gold, golf, goose, mango, category, algorithm
[GP] bagpipe, flagpole, pigpen, eggplant, magpie, kingpin, gangplow
[GR] grab, grain, grape, grass, green, group, degree
[GS] bags, bugs, dogs, eggs, frogs, flags, warnings
[GT] pigtail, ragtag, ringtone, length, strength, wavelength, longtime
[GU] guard, guess, guitar, gum, penguin, argument, language
[GV] dogvane
[GW] bigwig, dogwood, gangway, hogwash, ragweed, bagwig, logway
[GY] biology, energy, foggy, gym, strategy, gyre, morphology
[GZ] zigzag, zugzwang, zigzagged, zigzagging, zigzags, zigzagger
[HA] habit, hair, hammer, hand, happy, that, shape
[HB] dashboard, fishbowl, highbrow, lunchbox, wishbone, neighbors, pushbutton
[HC] ashcan, fishcake, flashcard, highchair, pushcart, trashcan, healthcare
[HD] birthday, touchdown, washday, withdraw, watchdog, archduke, deathday
[HE] head, heart, heat, hello, hero, the, height
[HF] bashful, faithful, mouthful, truthful, wishful, pitchfork, pathfinder
[HG] sprechgesang, fishgig, chge, flashgun, hgwy, lychgate, churchgoer
[HH] bathhouse, beachhead, fishhook, hitchhike, withhold, roughhew, touchhole
[HI] hide, high, hill, hippo, history, this, which
[HJ] mahjong, mahjongg, mahjongs, mahjonggs
[HK] kishke, droshky, babushka, latchkey, munchkin, piroshki, kishkes
[HL] athlete, breathless, flashlight, highlight, ruthless, roughly, monthly
[HM] asthma, bathmat, isthmus, logarithm, rhythm, algorithm, benchmark
[HN] ethnic, highness, technique, technology, john, pathname, smoothness
[HO] hobby, hockey, home, honey, horse, method, anchor
[HP] dishpan, highpoint, pushpin, launchpad, throughput, dashpot, toothpaste
[HQ] earthquake, earthquakes
[HR] chrome, phrase, shrimp, three, through, christian, synchronized
[HS] baths, births, earths, months, paths, glyphs, graphs
[HT] bright, eight, fight, light, night, height, right
[HU] hug, human, hundred, hungry, chunk, shuffle, thus
[HV] boschvark
[HW] archway, dishwater, highway, inchworm, pathway, northwest, southwest
[HY] hyena, hymn, rhyme, shy, physics, hyper, why
[HZ] machzor
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
[JJ] hajjes, hajji, hajj, hajjis
[JN] prajna
[JO] job, jog, join, joke, joy, major, john
[JT] adjt
[JU] judge, juice, jump, jungle, just, adjust, conjugate
[KA] kale, kangaroo, karaoke, kayak, package, kappa, karma
[KB] workbook, checkbox, cookbook, blackberry, backbone, trackball, blackboard
[KC] blockchain, backchat, bankcard, blackcap, bookcase, crankcase, deckchair
[KD] markdown, weekday, breakdown, workday, backdrop, jackdaws, sheikdom
[KE] bake, cake, keep, key, snake, like, make
[KF] backfill, workflow, breakfast, thankfully, taskforce, forkful, nakfa
[KG] background, ginkgo, backgammon, blackguard, backgrounds, ginkgoes, backgrounder
[KH] khaki, khan, sheikh, workhorse, backhand, samekh, lakh
[KI] kick, kid, king, kitchen, kite, skip, kind
[KJ] lockjaw, buckjump, blackjack, stockjobber, blackjacks, buckjumper, blackjacked
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
[KV] kvetch, mikvah, kvass, mikveh, mikvos, mikvot, mikva
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
[LJ] killjoy, killjoys
[LK] chalk, elk, folk, milk, walk, bulk, talk
[LL] ball, bell, hill, shell, wall, will, all
[LM] almond, calm, elm, film, palm, bellman, realm
[LN] kiln, ulna, vulnerable, walnut, telnet, usefulness, illness
[LO] cloud, flower, lock, log, love, color, float
[LP] alpaca, gulp, help, kelp, pulp, alpha, sculpture
[LQ] calque, pulque, catafalque, milquetoast, unnilquadium, calques, pulques
[LR] already, railroad, alright, rivalry, walrus, bulrush, cavalry
[LS] bells, calls, goals, hills, owls, else, controls
[LT] belt, bolt, melt, quilt, salt, result, default
[LU] blue, club, luck, lunch, plush, value, include
[LV] dissolve, evolve, silver, solve, twelve, resolve, convolve
[LW] always, bulwark, hallway, railway, stalwart, bullwhip, tailwind
[LX] lxvii, calx, lxii, lxiv, lxix, clxvii, clxii
[LY] daily, family, fly, jelly, lynx, only, apply
[LZ] calzone, colza, colzas
[MA] magic, magnet, mango, map, mask, format, matrix
[MB] amber, bomb, climb, lamb, thumb, number, symbol
[MC] armchair, camcorder, emcee, tomcat, tramcar, kimchi, plumcot
[MD] humdrum, fremd, dumdum, filmdom, gumdrop, slumdog, mdse
[ME] camel, game, home, meal, melon, name, method
[MF] armful, brimful, comfort, harmful, circumflex, emf, chamfered
[MG] slumgullion, slumgullions
[MH] armhole, farmhouse, mho, wormhole, crumhorn, drumhead, micromho
[MI] mice, milk, mind, mint, smile, limit, missing
[MJ] ramjet, jimjams, circumjacent, ramjets
[MK] bumkin, boomkin, gymkhana, gymkhanas
[ML] aimless, farmland, hamlet, hemline, seamless, randomly, uniformly
[MM] common, dummy, gamma, immediate, symmetric, summary, recommended
[MN] autumn, column, condemn, hymn, solemn, randomness, amnesty
[MO] lemon, monkey, monster, moon, mouse, module, mode
[MP] camp, jump, lamp, pumpkin, stamp, import, empty
[MQ] kumquat, kumquats
[MR] amrita, comrade, nimrod, shamrock, ramrod, armrest, rimrock
[MS] arms, drums, gems, storms, teams, items, terms
[MT] warmth, amt, femtosecond, tomtit, gumtree, palmtop, mtge
[MU] mud, muffin, mug, museum, music, must, maximum
[MV] circumvent, duumvir, decemvir, triumvir, circumvented, circumvents, triumviri
[MW] gumwood, swimwear, tramway, wormwood, firmware, dimwitted, clamworm
[MY] army, dummy, mummy, mystery, myth, academy, myself
[MZ] hamza
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
[PJ] kopje, propjet, flapjack, skipjack, slapjack, kopjes, propjets
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
[PV] impv
[PW] shopworn, shipwreck, upward, stepwise, stopwatch, tripwire, upwell
[PY] copy, happy, puppy, pyramid, python, pyx, entropy
[PZ] pzazz
[QA] qadi, qaid, qanat, qat, sheqalim, qats, qanats
[QE] sheqel
[QI] qintar, qiviut, faqir, qibla, qindarka, faqirs, qintars
[QO] qoph, qophs
[QQ] seqq
[QT] qty, qto
[QU] quake, queen, quick, quiet, quote, equal, sequence
[QW] qwerty
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
[SZ] groszy, kuvasz, grosz
[TA] guitar, pasta, star, table, taco, data, state
[TB] football, frostbite, heartbeat, outback, softball, textbook, basketball
[TC] catch, kitchen, match, pitch, watch, batch, patch
[TD] outdo, shutdown, stdio, postdate, countdown, meltdown, letdown
[TE] gate, kite, monster, team, test, letter, latex
[TF] artful, catfish, outfit, pitfall, platform, postfix, restful
[TG] nightgown, outgo, shotgun, mortgage, catgut, roentgen, postgraduate
[TH] bath, earth, feather, north, thunder, the, this
[TI] action, arctic, tiger, time, tiny, function, option
[TJ] muntjac, bootjack, nightjar, straitjacket, muntjacs, bootjacks, nightjars
[TK] catkin, pocketknife, hotkey, kibitka, latke, rootkit, giantkiller
[TL] atlas, battle, bottle, castle, title, directly, currently
[TM] atmosphere, boatman, nightmare, oatmeal, utmost, bitmap, treatment
[TN] chutney, fitness, fortnight, partner, witness, footnote, attn
[TO] potato, toast, tomato, tooth, toy, vector, token
[TP] footpath, hotpot, outpost, postponed, marketplace, nitpick, hatpin
[TQ] cotquean
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
[UH] huh, buhl, duh, brouhaha, fuhrer, uhlan, buhr
[UI] build, fruit, guide, juice, quick, circuit, required
[UJ] jujube, moujik, jujitsu, mujik, thuja, mujahidin, hallelujah
[UK] duke, fluke, jukebox, nuke, ukulele, puke, auk
[UL] bulb, full, gulp, pulse, skull, result, default
[UM] drum, gum, jump, pumpkin, summer, number, columns
[UN] bunny, fun, jungle, sun, thunder, count, under
[UO] buoy, duo, fluoride, liquor, quote, contiguous, continuous
[UP] cup, puppet, soup, group, tuple, update, support
[UQ] bouquet, tuque, chautauqua, tuques, bouquets
[UR] burger, burn, fur, purple, turtle, return, source
[US] bus, cactus, house, mushroom, music, use, must
[UT] butter, cut, donut, nut, out, input, without
[UU] continuum, duumvir, muumuu, residuum, vacuum, lituus, menstruum
[UV] duvet, juvenile, louver, rejuvenate, uvula, mauve, guv
[UW] thruway, rauwolfia, thruways, rauwolfias
[UX] crux, flux, luxury, tuxedo, aux, tableaux, faux
[UY] buy, guy, wiseguys, exequy, tuyere, obloquy, obsequy
[UZ] buzz, fuzz, guzzle, muzzle, puzzle, cruzeiro, huzzah
[VA] lava, vacation, vacuum, valley, vase, value, advance
[VD] avdp
[VE] cave, five, glove, love, wave, version, level
[VG] avg
[VI] anvil, movie, video, vine, violin, provided, divide
[VL] pavlova, pavlovas
[VN] hryvnia, guvnor, czarevna, tsarevna, avn, guvnors
[VO] avocado, avoid, voice, volcano, vote, voltage, vowel
[VR] chevron, oeuvre, vroom, livre, sovran, bahuvrihi, vrooms
[VS] abbrevs, revs, pervs, shivs, spivs, guvs, lavs
[VT] invt, advt
[VU] convulse, revulsion, vulva, vulgar, vulture, vulnerable, uvular
[VV] savvy, bovver, revved, skivvy, bevvy, civvies, divvy
[VY] bevy, curvy, envy, heavy, navy, levy, wavy
[VZ] evzone
[WA] awake, swamp, swan, walk, water, software, warning
[WB] cowbell, lawbreaker, newborn, snowball, shadowbox, drawbar, rowboat
[WC] cowcatcher, newcomer, showcase, slowcoach, snowcap, flowchart, bawcock
[WD] bawdy, crowd, dowdy, rowdy, shrewd, powder, slowdown
[WE] answer, flower, sweet, web, west, weight, between
[WF] awful, crawfish, lawful, snowfall, unlawful, blowfish, newfangled
[WG] cowgirl, showgirl, gewgaw, blowgun, lawgiver, shadowgraph, sparrowgrass
[WH] whale, wheat, wheel, whisper, white, which, when
[WI] kiwi, swim, twin, wind, wing, with, width
[WJ] blowjob, showjumping, blowjobs
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
[WZ] blowzy, frowzy, blowzed, frowzily, frowziness, blowzier, frowzier
[XA] exact, exalt, exam, hexagon, inexact, fixation, relaxation
[XB] oxblood, oxbow, waxbill, boxberry, boxboard, oxbows, boxberries
[XC] exceed, excite, exclude, exch, boxcar, excuse, nonexclusive
[XD] sexdecillion, flexdollars
[XE] axes, boxer, mixer, oxen, fixed, execute, indexer
[XF] boxfish, foxfire, sixfold, oxford, exfoliant, boxful, exfoliate
[XG] foxglove, foxgloves
[XH] exhale, exhibit, exhume, exhort, boxhaul, foxhole, oxheart
[XI] axis, exit, taxi, toxic, exist, maximum, auxiliary
[XL] axle, boxlike, sexless, transaxle, sphinxlike, laxly, convexly
[XM] taxman, fluxmeter, taxmen
[XN] laxness, complexness
[XO] axon, exodus, exonerate, exoskeleton, exotic, xor, saxophone
[XP] expand, expect, explore, express, export, unexpanded, unexpected
[XQ] exquisite, exquisitely
[XR] xref, exr, boxroom, xrefs, boxrooms
[XS] axseed, exsect, exscind, coxswain, flaxseed, exsiccate, exsanguine
[XT] context, extra, next, sixth, text, extension, external
[XU] exude, exult, luxurious, plexus, nexus, asexual, exurb
[XV] xvi, xxviii, xxxvii, lxvii, clxvii, xviii, xvii
[XW] boxwood, waxwing, maxwell, paxwax, waxwork, maxwells, waxwings
[XX] xxxii, xxi, xxviii, xxxvii, xxii, xxxi, xxxiii
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
[YJ] skyjack, skyjacker, skyjacking, skyjacks, skyjacked, skyjackers, skyjackings
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
[YV] hryvnia, jayvee, gyve, polyvinyl, polyvalent, gyving, wyvern
[YW] anyway, byway, keyway, skyward, wayward, playwright, flyweight
[YX] pyx, onyx, calyx, coccyx, myxoma, apteryx, asphyxia
[YY] sayyid
[YZ] analyze, catalyze, electrolyze, hydrolyze, paralyze, byzantine, syzygy
[ZA] bazaar, blizzard, hazard, lizard, pizza, optimization, byzantine
[ZB] fuzzball, whizzbang, fuzzballs, whizzbangs
[ZC] vizcacha, mezcaline, mezcal
[ZD] samizdat, samizdats
[ZE] amaze, breeze, freeze, zebra, zero, size, parametrize
[ZG] fizgig, wayzgoose, fizgigs
[ZH] muzhik, zho, muzhiks, zhos
[ZI] magazine, zip, zigzag, lazily, unzip, zigs, brazil
[ZK] britzka, whizkid, buzzkill, blitzkrieg, buzzkills, blitzkriegs
[ZL] dazzle, drizzle, fizzle, puzzle, sizzle, swizzle, muzzle
[ZM] gizmo, jazzman, hazmat, razzmatazz, sitzmark, quizmaster, gizmos
[ZN] kibbutznik, kibbutzniks
[ZO] amazon, horizon, ozone, zodiac, zoo, timezone, zone
[ZP] gazpacho, chutzpah
[ZS] buzzsaw
[ZU] azure, kudzu, yuzu, zucchini, gazump, lazuli, mazuma
[ZV] mitzvah, rendezvous, mitzvoth, rendezvoused, rendezvouses
[ZW] buzzword, zwieback, zugzwang, buzzwords
[ZY] breezy, crazy, dizzy, fuzzy, lazy, syzygy, woozy
[ZZ] buzz, dizzy, jazz, pizza, puzzle, fuzzy, swizzle
[AAE] baaed
[AAF] haaf
[AAG] laager, laagers
[AAH] aah
[AAI] kamaaina, baaing
[AAL] aalii, craal, kraal, kraals
[AAM] salaam, salaams, salaamed, salaaming
[AAN] naan, balmacaan, naans
[AAR] aardvark, aardwolf, bazaar, haar, bazaars, aardwolves, aardvarks
[AAS] baas, meshugaas
[AAT] advocaat
[ABA] database, aba, syllabary, sabayon, baba, cinnabar, guanabana
[ABB] abbrev, grabber, jabber, rabbit, tabbed, abba, gabber
[ABC] dabchick, abcoulomb, dabchicks, abcoulombs
[ABD] abdominal, abduce, abdicate, labdanum, cabdriver, rhabdomancy, subabdominal
[ABE] label, babel, alphabet, diabetes, relabel, unlabeled, abed
[ABF] gabfest, abfarads, gabfests
[ABG] crabgrass
[ABH] abhor, abhenries, abhorred, abhorrer, abhorrent, abhorring, abhorrence
[ABI] liability, probability, capabilities, ability, suitability, inability, stability
[ABJ] abject, abjure, frabjous, abjurer, abjection, abjectness, abjuration
[ABL] table, callable, variable, iterable, syllable, available, enable
[ABM] cabman, cabmen
[ABN] abnormal, abnegate, drabness, abnormally, abnormality, abnegator, abnormity
[ABO] above, about, abort, parabola, laboratory, elaborations, whereabouts
[ABR] abr, fabricant, unabridged, labret, tabret, macabre, sabra
[ABS] abs, tabs, labs, stabs, dabs, grabs, cabs
[ABU] tabular, vocabulary, abuse, abundant, abut, fabulous, abulia
[ABV] abvolts
[ABW] crabwise, abwatts
[ABY] baby, aby, labyrinth, gigabytes, megabytes, terabytes, wallaby
[ACA] academy, facade, vacancies, placard, coelacanth, maracas, alpaca
[ACC] accent, accuracy, according, accumulators, accompanying, inaccurate, accidentally
[ACE] space, replace, face, whitespace, place, trace, interface
[ACH] each, cache, apache, machine, attach, reached, approach
[ACI] opacity, spacing, capacity, facing, tracing, pacific, replacing
[ACK] package, black, stack, bracket, back, callback, unpack
[ACL] oracle, obstacle, miracle, tentacle, spectacle, manacles, cenacle
[ACM] acme, chacma, acmes, chacmas
[ACN] acnode, tacnode, acne, anthracnose, acned
[ACO] bacon, peacock, taco, anaconda, draconic, acoustics, beacon
[ACP] acpt
[ACQ] acquire, reacquire, lacquer, jacquard, racquetball, unacquainted, acquired
[ACR] macro, across, diacritic, acre, lacrosse, sacrifice, acrylic
[ACS] facsimile, macs, lilacs, cognacs, ipecacs, maniacs, tambacs
[ACT] action, actual, factor, exact, extract, contract, character
[ACU] acute, vacuum, faculties, barracuda, abacus, teacup, evacuate
[ACY] legacy, accuracy, acyclic, privacy, conjugacy, inaccuracy, piracy
[ADA] metadata, adapted, readable, radar, cicada, loadable, unreadable
[ADB] headband, breadbox, roadbed, deadbeat, shadbush, broadband, threadbare
[ADC] broadcast, breadcrumb, rebroadcast, headcount, madcap, shadchan, headcloth
[ADD] add, padding, ladder, saddle, faddy, straddle, madden
[ADE] header, reader, made, loaded, shade, upgrade, trademark
[ADF] gadfly, deadfall, dreadful, toadfish, headfirst, steadfast, threadfin
[ADG] badge, gadget, headgear, cadger, fadge, wadge, badger
[ADH] adhere, madhouse, roadhouse, adhibit, sadhu, samadhi, deadhead
[ADI] radius, heading, leading, gradient, loading, reading, shading
[ADJ] adjust, adjoint, adjacent, nonadjacent, readjust, adjective, unadjusted
[ADK] roadkill
[ADL] headline, deadline, badly, sadly, broadly, cradle, gladly
[ADM] admin, admonition, badminton, cadmium, inadmissible, madmen, sysadmin
[ADN] badness, madness, sadness, adnate, padnag, breadnut, deadness
[ADO] shadow, adobe, radon, tornado, adopted, avocado, readout
[ADP] headphone, tadpole, deadpan, headpiece, headphones, headpin, deadpanned
[ADQ] headquarters, headquarter
[ADR] quadratic, quadruple, cadre, biquadratic, hadrons, headroom, quadrillion
[ADS] heads, loads, threads, leads, reads, downloads, spreadsheet
[ADT] breadth, hairbreadth, broadtail, handbreadth, headteacher, stadtholder, hairsbreadth
[ADU] adult, graduate, caduceus, bahadur, postgraduate, maduro, shaduf
[ADV] advance, advised, advertising, disadvantage, adversary, adventure, inadvertent
[ADW] headwater, roadways, adware, gadwall, madwort, deadwood, leadwort
[ADY] already, ready, steady, lady, heady, shady, adytum
[ADZ] adze, adzes
[AEA] paean, nymphaea, amoebaean, paeans
[AEB] blaeberry, blaeberries
[AEC] aecium, caecilian, gynaeceum, haecceity, aecia, aeciospore, caecilians
[AED] aedile, aedes, unideaed, propaedeutic, togaed, visaed, baaed
[AEF] praefect
[AEG] aegis, jaeger, aegrotat, aegises, jaegers
[AEI] scarabaeid, scarabaeids
[AEL] paella, tael, maelstrom, chamaeleon, paellas, maelstroms, chamaeleons
[AEM] daemon, haemostat, hexaemeron, haematoxylon, daemonic, daemons, haemostats
[AEN] maenad, aeneous, faena, anabaena, encaenia, praenomen, scorpaenid
[AEO] aeon, aeolian, palaeontology, archaeology, caeoma, paeony, archaeornis
[AER] diaeresis, aerosol, aerial, faerie, haeres, aerate, hetaera
[AES] aesthetic, caesura, maestro, unaesthetic, braes, sundaes, arborvitaes
[AET] aether, praetor, chaeta, phaeton, laetrile, spaetzle, polychaete
[AEU] scarabaeus, uraeus, athenaeum, coryphaeus, propylaeum, athenaeums, scarabaeuses
[AEV] naevus, naevi
[AFA] safari, afar, seafaring, cafard, leafage, megafauna, catafalque
[AFE] safe, unsafe, falafel, cafe, wafer, afeard, carafe
[AFF] affine, affect, staff, traffic, unaffected, faff, giraffe
[AFG] afghani, afghan, afghans, afghanis
[AFH] leafhopper, leafhoppers
[AFI] afield, tafia, oafish, afire, hafiz, kafir, mafia
[AFL] leaflet, afloat, aflame, aflutter, seafloor, gigaflops, megaflops
[AFN] hafnium, deafness
[AFO] terraform, afore, afoul, afoot, peafowl, plafond, seafood
[AFR] afraid, afresh, afrit, seafront, safranine, sassafras, permafrost
[AFS] leafs, decafs, kenafs, pilafs, loafs, oafs, cloverleafs
[AFT] after, draft, shaft, hereafter, thereafter, craft, graft
[AFU] snafu, teniafuge, snafus
[AFY] leafy
[AGA] against, propagate, hiragana, saga, magazine, agape, agate
[AGB] hagbut, ragbag, shagbark, hagberry, hagbuts, shagbarks, hagberries
[AGC] agcy
[AGD] smaragd, magdalen, smaragdine, smaragdite, magdalens
[AGE] image, message, package, page, language, damages, usage
[AGF] bagful, hagfish, stagflation, bagfuls
[AGG] dagger, ragged, aggregate, tagged, bagging, flagged, aggressive
[AGH] spaghetti, agha, curagh, ataghan, claddagh, slagheap, yataghan
[AGI] magic, imaginary, packaging, fragile, pagination, averaging, managing
[AGL] eagle, aglet, tagline, beagle, raglan, aglow, daglock
[AGM] fragment, magma, pragmatic, diaphragm, bagman, gagman, ragman
[AGN] magnitude, diagnostics, agnostic, magnetic, magnified, champagne, stagnation
[AGO] diagonal, hexagon, pentagon, dragon, octagon, ago, imago
[AGP] bagpipe, magpie, flagpole, ragpicker, bagpiper, magpies, bagpipes
[AGR] paragraph, diagram, agreement, subparagraph, hexagram, tetragram, disagree
[AGS] flags, tags, frags, bags, lags, dags, mags
[AGT] ragtag, wagtail, ragtop, ragtime, ragtags, wagtails
[AGU] baguette, seagull, vague, league, asparagus, plaguing, colleagues
[AGW] bagwig, nagware, ragweed, bagworm, ragwort, ragworts
[AGY] cabbagy, stagy, geophagy, spagyric, xerophagy
[AHA] graham, aha, bahadur, brouhaha, mahatma, dahabeah, tomahawk
[AHC] ahchoo
[AHE] ahead, tetrahedron, octahedron, icosahedral, dodecahedron, subtrahend, ahem
[AHI] tahini, ahimsa, cahier, wahine, sahib, spahi, fellahin
[AHJ] mahjong, mahjongg, mahjongs, mahjonggs
[AHL] dahlia, fahlband, mahlstick, dahl, dahlias, dahls, mahlsticks
[AHN] autobahn, gahnite, hahnium, autobahns
[AHO] yahoo, mahogany, seahorse, ahoy, cahoot, quahog, wahoo
[AHR] tahr
[AHS] ephahs, obeahs, rajahs, aliyahs, amahs, ayahs, blahs
[AHT] baht, bahts
[AHU] chihuahua, kahuna, sahuaro, bahuvrihi, kahunas, sahuaros, chihuahuas
[AHY] hexahydrate, parahydrogen
[AIA] kaiak, naiad, guaiacol, loaiasis, guaiacum, naiads, guaiacums
[AIB] copaiba, zaibatsu, copaibas
[AIC] algebraic, archaic, mosaic, alcaic, laical, plaice, deltaic
[AID] braid, said, aid, mermaid, laid, paid, plaid
[AIE] gaiety, faience, maieutic, shanghaied
[AIF] waifish, kaif, naif, waif, naifs, waifs
[AIG] straight, champaign, campaign, aiglet, aigret, maiger, arraign
[AIH] maihem
[AII] shanghaiing
[AIK] haiku, aikido, daikon, glaikit, balalaika, haik, aikidos
[AIL] detail, fail, available, email, tail, trailing, braille
[AIM] disclaimer, claim, aim, counterclaim, declaim, proclaim, exclaim
[AIN] domain, main, plain, train, container, obtain, against
[AIO] aioli, aiolis
[AIP] taipan, traipse, taipans, traipsed, traipses, traipsing
[AIQ] daiquiri, daiquiris
[AIR] air, chair, fair, hair, stair, pair, wheelchair
[AIS] raise, kaiser, waist, liaison, ais, daisy, malaise
[AIT] traits, await, wait, portrait, faith, ait, bait
[AIV] naive, waiver, glaive, vaivode, waived, waives, waive
[AIZ] maize, baiza, archaize, maizes, baize, baizas, archaized
[AJA] pajama, rajahs, ajar, maharajah, pajamas, rajah, maharajahs
[AJE] trajectory, majesty, cajeput, hajes, rajes, trajectories, traject
[AJI] fajita, bhaji, thingamajig, thingumajig, fajitas, thingamajigs, thingumajigs
[AJJ] hajjes, hajji, hajj, hajjis
[AJN] prajna
[AJO] major, megajoule, cajole, sapajou, carcajou, exajoule, kinkajou
[AJU] majuscule, cajuput, majuscular
[AKA] katakana, aka, breakable, unbreakable, nonbreakable, leakage, unmistakable
[AKB] sneakbox
[AKD] breakdown, breakdowns
[AKE] bake, cake, lake, make, snake, take, fake
[AKF] breakfast, nakfa, weakfish, breakfront, breakfasts, weakfishes, breakfasted
[AKH] lakh, astrakhan, steakhouse, lakhs, steakhouses
[AKI] making, taking, breaking, speaking, leaking, shaking, khaki
[AKK] yakked, yakka, yakking
[AKL] weakly, baklava, bleakly, weakling, weaklings
[AKN] weakness, bleakness, breakneck, weaknesses
[AKO] mako, breakout, shako, shakoes, shakos, makos, breakouts
[AKP] breakpoints
[AKR] cloakroom, cloakrooms
[AKS] breaks, peaks, leaks, tweaks, croaks, sneaks, speaks
[AKT] breakthrough, bhakti
[AKU] breakup, haku, makuta, karakul, oakum, breakups
[AKW] teakwood, breakwater, teakwoods, breakwaters
[AKY] flaky, freaky, sneaky, shaky, creaky, leaky, peaky
[ALA] scalar, balanced, unbalanced, alarm, koala, inhalation, palatal
[ALB] albeit, albatross, album, halberd, albino, balboa, falbala
[ALC] calculate, falcon, alchemical, recalculate, alcove, precalculate, calcination
[ALD] bald, emerald, waldo, aldehyde, caldera, herald, scald
[ALE] scale, locale, palette, equivalent, dialect, stale, calendar
[ALF] half, behalf, malformed, malfunction, palfrey, calf, alfalfa
[ALG] algorithm, algebraic, amalgamation, algae, hidalgo, realgar, nostalgic
[ALH] metalhead, metalheads
[ALI] invalid, valid, alias, align, normalize, italic, initialize
[ALK] balk, chalk, stalk, talk, walk, smalltalk, alk
[ALL] ball, call, fall, small, wall, all, install
[ALM] almost, realm, palm, facepalming, salmon, calm, almanac
[ALN] realness, specialness, walnut, balneal, usualness, casualness, frugalness
[ALO] along, dialog, catalog, standalone, analog, halo, paralogisms
[ALP] alpha, enthalpy, alpaca, alpine, kalpak, calpac, catalpa
[ALQ] calque, catafalque, calques, catafalques
[ALR] already, alright, rivalry, walrus, cavalry, chivalry, unchivalrous
[ALS] false, also, equals, narwhals, locals, reals, intervals
[ALT] penalty, alt, royalty, salt, health, stealth, halt
[ALU] value, evaluate, eigenvalues, unevaluated, alumni, salute, reevaluate
[ALV] halve, valve, alveolar, salvage, galvanic, alvine, bivalve
[ALW] always, malware, thalweg, mealworm, stalwart, metalware, sandalwood
[ALX] calx, calxes
[ALY] analysis, anomaly, mealy, catalyst, calyx, eucalyptus, galyak
[ALZ] calzone
[AMA] damages, exclamation, llama, dramatic, aquamarine, amazon, panama
[AMB] lambda, preamble, ambiguous, scramble, disambiguate, unambiguous, hamburg
[AMC] tramcar, camcorder, creamcups, tramcars, camcorders
[AME] name, frame, same, parameters, filename, rename, pathname
[AMF] chamfered, foamflower, steamfitter, chamfrons, chamfer, chamfering, chamfron
[AMI] family, dynamic, roaming, naming, examine, pyramid, benjamin
[AMJ] ramjet, ramjets
[AML] streamline, seamless, tramlines, hamlet, camlet, dreamland, streamlined
[AMM] gamma, digamma, grammar, programming, hamming, ammeter, mammal
[AMN] amnesty, amnion, damnify, goddamn, anamneses, catamnesis, paramnesia
[AMO] amount, among, diamond, dynamo, famous, cinnamon, guacamole
[AMP] camp, champ, lamp, stamp, swamp, example, samples
[AMR] shamrock, amrita, ramrod, tramroad, steamroll, ramrodded, ramrodding
[AMS] streams, diagrams, lams, programs, histograms, teams, phonograms
[AMT] amt, steamtight
[AMU] unamused, hippopotamus, amulet, gamut, amused, mandamus, shamus
[AMW] tramway, clamworm, teamwork, streamway, dreamworld, bantamweight, tramways
[AMY] steamy, dreamy, amyl, bigamy, creamy, digamy, gleamy
[AMZ] hamza
[ANA] manager, analysis, explanation, katakana, planar, hiragana, kana
[ANB] cranberry, fanboy, beanbag, tanbark, sanbenito, loganberry, beanball
[ANC] anchor, advance, distance, instance, enhancement, performance, branch
[AND] band, hand, island, land, sand, and, random
[ANE] plane, panel, cleaned, cane, lane, permanent, airplane
[ANF] canfield, manful, panful, fanfare, beanfeast, oceanfront, anfractuous
[ANG] bang, fang, hang, mango, tango, range, angle
[ANH] tanh, manhattan, anhinga, piranha, anhedral, stanhope, swanherd
[ANI] anim, meaning, manifest, sanitize, mechanism, organization, companion
[ANJ] kanji, banjo, fanjet, sanjak, ganja, panjandra, banjoist
[ANK] bank, blank, crank, prank, tank, rank, thanks
[ANL] cleanly, anlage, branle, manlike, unmanly, womanly, banlieue
[ANM] manmade
[ANN] cannot, channel, annotations, spanning, manner, banner, annex
[ANO] another, canonical, anode, anonymous, nanoseconds, anomaly, paranoia
[ANP] panpipe, beanpole, manpower, panpipes, panpsychist, beanpoles
[ANQ] manque, banquet, yanqui, tranquil, vanquish, palanquin, blanquette
[ANR] manrope, yeomanry, charlatanry
[ANS] transform, means, sans, transpose, answer, expansion, translate
[ANT] variant, constant, want, warranty, granted, important, quant
[ANU] manual, cleanup, alphanumeric, granularity, peanuts, lanthanum, anuran
[ANV] canvas, anvil, canvases, canvass, canvasser, canvasback, anvils
[ANW] meanwhile, loanwords, vanward, sapanwood, sappanwood, loanword
[ANX] anxious, phalanx, antianxiety, overanxious, anxiety, anxiousness, anxieties
[ANY] any, many, company, accompanying, mahogany, banyan, meany
[ANZ] stanza, garbanzo, banzai, kwanza, panzer, bonanza, canzona
[AOB] baobab, baobabs
[AOC] intraocular, contraoctave
[AOH] pharaoh, pharaohs
[AOK] karaoke, karaokes
[AOL] kaolin, haole, kaoliang, kaolinite, kaoliangs, kaolinites
[AON] kaon, kaons
[AOR] aorta, aorist, supraorbital, aortal, aortic, aoristic, aortas
[AOS] chaos, naos, cacaos, ciaos, carabaos
[AOT] chaotic, chaotically
[AOU] caoutchouc, giaour, miaou, aoudad, miaous, aoudads, caoutchoucs
[APA] apache, capacity, capabilities, apart, japan, wraparound, papaya
[APB] soapbox, chapbook, lapboard, snapback, clapboard, scrapbook, soapbark
[APD] lapdog, slapdash, trapdoor, flapdoodle, snapdragon, lapdogs, trapdoors
[APE] shape, escape, reshape, paper, landscape, trapezoid, taper
[APF] capful, lapful, leapfrog, chapfallen, leapfrogged, leapfrogging, capfuls
[APH] graph, digraph, ideograph, paragraph, bibliography, cryptography, pictographic
[API] capital, escaping, rapidly, shaping, reshaping, sapiens, scraping
[APJ] flapjack, slapjack, flapjacks
[APK] napkin, napkins
[APL] maple, staple, cheaply, aplomb, aplite, caplet, aplasia
[APM] chapman, mapmaker, entrapment, chapmen, mapmakers
[APN] apnea, grapnel, shrapnel, cheapness, apneas, grapnels
[APO] extrapolate, apostrophe, teapot, weapon, apothem, vapor, apologizes
[APP] append, apply, mapping, approx, wrapper, kappa, happen
[APR] apricot, apropos, apraxia, caprice, paprika, taproom, malaprop
[APS] maps, perhaps, wraps, snapshot, collapse, elapsed, caps
[APT] caption, chapter, adapted, apt, laptop, rapt, baptism
[APU] caput, papule, kaput, scapula, catapult, crapulent, ultrapure
[APW] lapwing, sapwood, knapweed, soapwort, lapwings, knapweeds, soapworts
[APY] papyrus, chemotherapy, crapy, soapy, therapy, apyretic, capybara
[AQI] faqir, faqirs
[AQU] aqua, aqueduct, aquifer, opaque, maquette, plaque, claque
[ARA] parameters, character, parallel, separate, paragraph, declaration, appearance
[ARB] arbitrary, barb, garbage, tarball, carbon, nearby, starburst
[ARC] search, arc, hierarchy, march, research, parcel, demarcate
[ARD] standard, forward, backward, regard, guard, card, hard
[ARE] are, software, parent, square, compare, shared, declare
[ARF] warfare, headscarf, fearful, scarf, barf, dwarf, snarf
[ARG] target, argument, large, charge, margin, enlarge, argon
[ARH] barhop, carhop, warhead, parhelia, boarhound, hoarhound, spearhead
[ARI] variable, glossaries, comparison, covariance, arising, arithmetic, multivariate
[ARJ] carjack, marjoram, tearjerker, carjacker, carjacking, carjacks, carjacked
[ARK] bark, dark, mark, park, shark, benchmark, quark
[ARL] early, clearly, similarly, nearly, linearly, particularly, carl
[ARM] karma, harmonic, warm, arm, marmot, charm, harmless
[ARN] warning, learn, harness, barn, varnish, earnings, yarn
[ARO] around, workaround, maroon, aromatic, arose, carom, kangaroo
[ARP] carp, sharp, harpoon, warp, arpeggio, earpiece, earphone
[ARQ] parquet, marquess, remarque, charqui, arquebus, harquebus, barquentine
[ARR] array, arrow, warranty, barrier, starred, arrester, narrow
[ARS] parse, sparse, chars, vars, scalars, marshal, appears
[ART] art, cart, heart, part, smart, start, chart
[ARU] acarus, asarum, arugula, aruspex, labarum, larum, parulis
[ARV] arvo, carve, starving, parvis, harvest, garvey, jarvey
[ARW] narwhals, earwax, carwash, tarweed, bearwood, clearway, rearward
[ARY] binary, library, dictionary, boundary, glossary, necessary, summary
[ARZ] marzipan, zarzuela, bilharzia, bilharziases, bilharziasis
[ASA] nasal, basal, asap, unpleasant, pleasant, kielbasa, peasants
[ASB] asbestosis, gasbag, rasbora, canvasback, smorgasbord, asbestos, gasbags
[ASC] ascending, pascal, cascade, seascape, masculine, fascicules, ascension
[ASD] asdic, dryasdust, asdics
[ASE] base, case, release, please, dataset, phase, aliases
[ASH] cash, crash, flash, smash, splash, hash, dash
[ASI] basic, increasing, easily, feasible, decreasing, emphasis, casing
[ASJ] masjid, masjids
[ASK] ask, bask, cask, flask, mask, task, unmasked
[ASL] asleep, aslant, aslope, gaslit, haslet, measly, measles
[ASM] plasma, jasmine, enthusiasm, inasmuch, cytoplasmic, gasman, miasma
[ASN] glasnost
[ASO] reason, season, mason, unreasonable, parasol, gasoline, ultrasonic
[ASP] aspect, gasp, raspberry, aspiration, jasper, grasp, teaspoon
[ASQ] basque, masquerade, casque, asquint, pasquil, antimasque, masquer
[ASS] assert, class, pass, assign, assume, subclass, associated
[AST] blast, cast, fast, last, past, least, east
[ASU] measure, erasure, casual, pleasure, treasury, omasum, asunder
[ASW] aswarm, gasworks
[ASY] easy, asymptotic, asymmetric, asynchronous, fantasy, asylum, greasy
[ASZ] kuvasz
[ATA] data, metadata, catalog, fatal, katakana, errata, avatar
[ATB] flatbread, hatbox, ratbag, catbird, fatback, peatbog, boatbill
[ATC] match, batch, patch, dispatch, catch, hatch, watch
[ATE] crate, date, gate, plate, skate, latex, state
[ATF] platform, catfish, batfish, ratfink, flatfeet, goatfish, pratfall
[ATG] catgut, wheatgerm
[ATH] path, math, rather, gather, cathode, death, feather
[ATI] rational, native, location, negative, relative, rotation, derivative
[ATK] catkin, latke, latkes, catkins
[ATL] atlas, greatly, natl, neatly, ratline, flatland, featly
[ATM] treatment, atm, batman, pretreatment, boatman, catmint, mahatma
[ATN] flatness, beatnik, whatnot, neatness, greatness, catnap, fatness
[ATO] operator, estimator, iterator, generator, locator, separator, atomic
[ATP] hatpin, heatproof, floatplane, sweatpants, meatpacking, hatpins, floatplanes
[ATR] matrix, patrol, quatre, albatross, compatriots, atrocious, psychiatry
[ATS] stats, formats, floats, whatsoever, cats, repeats, treats
[ATT] pattern, attribute, attention, formatter, flatten, scatter, attach
[ATU] status, feature, signature, ligature, nature, quadrature, datum
[ATV] statvolt
[ATW] atween, batwing, catwalk, fatwa, atwitter, flatware, heatwave
[ATY] datatype, treaty, platypus, atypical, floaty, sweaty, katydid
[ATZ] ersatz, matzoh, hoatzin, tzatziki, katzenjammer, matzot, matzo
[AUB] auburn, aubergine, aubade, bauble, bedaub, dauber, blaubok
[AUC] gauche, saucer, auction, bureaucracy, glaucous, caucus, faucal
[AUD] audio, cauda, baud, lauder, audacity, marauder, belaud
[AUE] sauerkraut, sauerbraten, plateaued, sauerbratens
[AUF] gauffer, chauffer, langlauf, gallimaufry, chauffeur, gauffers, chauffeurs
[AUG] aug, caught, uncaught, gauge, laughing, haugh, naughty
[AUI] plateauing
[AUK] auk, padauk, auklet, auklets, padauks, auks
[AUL] default, segfault, fault, assault, vault, cauldron, overhaul
[AUM] heaume, trauma, naumachia, lebensraum, meerschaum, thaumatrope, thaumaturge
[AUN] aunt, daunt, gaunt, haunt, launch, fauna, sauna
[AUP] taupe, dauphine, pauper, yaupon, graupel, scauper, nauplius
[AUQ] chautauqua
[AUR] sauropod, aurora, aural, thesaurus, restaurant, aureolin, dinosaurs
[AUS] because, clause, caused, gauss, pause, exhausted, plausible
[AUT] auto, author, caution, hauteur, astronaut, beautiful, umlaut
[AUV] mauve, fauve, chauvinism, fauvism, fauvist, mauvish, chauvinist
[AUW] rauwolfia, rauwolfias
[AUX] aux, tableaux, faux, bateaux, bauxite, gateaux, reseaux
[AUZ] gauze, schnauzer, gauzily, gauzy, gauziness, gauzier, gauziest
[AVA] available, java, unavailable, avatar, naval, ottava, travail
[AVD] avdp
[AVE] have, unravel, save, average, wave, grave, leave
[AVG] avg
[AVI] behavior, having, navigation, saving, gravity, leaving, heavily
[AVL] pavlova, pavlovas
[AVN] avn
[AVO] avoid, flavor, favor, unfavorable, octavo, avocado, havoc
[AVS] lavs
[AVU] bravura, clavus, favus, gravure, avulsion, avuncular, rotogravure
[AVV] savvy, navvy, navvies, savvied, savvier, savvies, savviest
[AVY] heavy, wavy, navy, gravy, cavy, superheavy, heavyweight
[AWA] await, aware, away, drawable, runaway, unaware, awake
[AWB] drawbar, strawberry, bawbee, jawbone, sawbuck, rawboned, lawbreaker
[AWC] bawcock
[AWD] crawdad, bawdry, dawdle, tawdry, sawdust, gawd, bawdily
[AWE] drawer, awesome, flawed, seaweed, brawer, rawest, aweigh
[AWF] awful, lawfully, sawfly, godawful, hawfinch, strawflower, crawfish
[AWG] lawgiver, lawgivers
[AWH] awhile, rawhide, sawhorse, awhirl, sawhorses
[AWI] drawing, redrawing, pawing, overdrawing, rawinsonde, cawing, hawing
[AWK] awkward, gawk, hawk, squawk, tomahawk, mohawk, mawkin
[AWL] crawl, drawl, trawler, awl, shawl, flawless, yawl
[AWM] lawman, sawmill, shawm, yawmeter, lawmen, lawmaker, lawmaking
[AWN] dawn, fawn, lawn, pawn, yawn, drawn, spawn
[AWO] awoken, fleawort, seaworthy, zebrawood, camerawork, reawoke, unseaworthy
[AWP] gawping, pawpaw, yawp, drawplate, gawp, gawped, yawped
[AWR] awry, lawrencium, outlawry, outlawries
[AWS] draws, laws, flaws, paws, redraws, jackdaws, jaws
[AWT] sawtooth, drawtube, hawthorn, hawthorns
[AWW] strawworm, strawworms
[AWY] lawyer, sawyer, flawy, lawyers, sawyers, lawyerly
[AXA] relaxation, taxation, abraxas, laxation, taraxacum, taxaceous, nontaxable
[AXB] waxbill
[AXE] axes, relaxed, maxes, taxes, faxes, axeman, axenic
[AXH] saxhorn, saxhorns
[AXI] axis, maximum, axiom, axial, taxicab, waxing, relaxing
[AXL] axle, transaxle, laxly, axletree, axles, axletrees
[AXM] taxman, taxmen
[AXN] laxness
[AXO] saxophone, taxon, klaxon, axolotl, axon, cytotaxonomy, taxonomy
[AXP] taxpayer, waxplant, taxpaying, taxpayers
[AXS] axseed, flaxseed, axseeds, flaxseeds
[AXT] saxtuba
[AXW] maxwell, paxwax, waxwing, waxwork, maxwells, waxwings, waxworks
[AXY] galaxy, ataraxy, braxy, epitaxy, waxy, anthotaxy, metaxylem
[AYA] ayah, displayable, papaya, payable, kayak, maya, playable
[AYB] maybe, playback, waybill, daybed, jaybird, payback, bayberry
[AYC] daycare, haycock, paycheck, haycocks, paychecks
[AYD] payday, mayday, daydream, daydreamer, maydays, paydays, daydreams
[AYE] layer, delayed, displayed, player, splayed, prayer, payed
[AYF] playful, dayfly, mayfly, hayfork, crayfish, wayfarer, splayfeet
[AYG] playground, playgoing, playgirls, playgirl, playgoer, playgroup, playgoers
[AYH] mayhap, playhouse, mayhem, playhouses
[AYI] playing, displaying, saying, zayin, ayin, decaying, replaying
[AYL] payload, daylight, playlist, waylay, hayloft, rayless, grayling
[AYM] payment, layman, prepayment, haymow, drayman, claymore, playmate
[AYN] grayness, paynim, gayness, paynims
[AYO] layout, crayon, rayon, payoff, mayo, sabayon, bayonet
[AYP] claypan, maypole, playpen, payphone, laypeople, layperson, maypoles
[AYR] hayrack, payroll, tayra, playroom, hayrick, hayride, playreader
[AYS] arrays, always, days, ways, displays, holidays, says
[AYT] daytime, payt, playtime, claytonia, plaything, playthings
[AYU] cayuse, guayule, layup, picayune, layups, cayuses, guayules
[AYV] jayvee
[AYW] playwright, haywire, baywood, jaywalk, mayweed, paywall, wayward
[AYY] sayyid
[AYZ] wayzgoose
[AZA] bazaar, hazard, lazar, plaza, azalea, chazan, mazard
[AZE] blaze, craze, daze, gaze, maze, hazel, amazed
[AZI] lazily, brazil, azimuth, magazine, amazing, crazily, gazing
[AZM] hazmat
[AZO] amazon, razor, azote, blazon, azoic, azole, bazooka
[AZP] gazpacho
[AZU] azure, gazump, lazuli, mazuma, azurite, mazurka, lazulite
[AZY] crazy, hazy, lazy, mazy, sleazy, azygous, crazyweed
[AZZ] dazzle, jazz, pizzazz, razzmatazz, piazza, snazzy, frazzle
[BAA] baa, baas, baaing, baaed
[BAB] babel, probably, baby, kebab, baba, improbable, describable
[BAC] back, callback, fallback, feedback, rollback, playback, bacon
[BAD] bad, aubade, forbade, gambade, lambada, subadar, tribade
[BAE] scarabaeus, amoebae, anabaena, amphisbaena, rumbaed, sambaed, scubaed
[BAF] baffle, abaft, baffler, bafflement, baffled, baffles, bafflers
[BAG] garbage, bag, handbag, moneybag, cabbage, airbag, bumbag
[BAH] bah, autobahn, jubbah, baht, bahadur, bahuvrihi, bahts
[BAI] bail, bait, bainite, bairn, baiza, ouabain, thebaine
[BAK] bake, baklava, prebake, clambake, sunbaked, baksheesh, baking
[BAL] global, balanced, ball, tarball, handball, unbalanced, verbal
[BAM] bamboos, ferbam, abamp, carbamate, meprobamate, bamboo, bambino
[BAN] band, banner, turban, shebang, bang, banana, bank
[BAO] baobab, carabao, baobabs, carabaos
[BAP] baptism, rebaptism, subapical, baps, unbaptized, baptized, bap
[BAQ] subaqua, subaquatic, subaqueous
[BAR] toolbar, bar, foobar, sidebar, handlebars, drawbar, syllabary
[BAS] base, basic, database, bash, basket, basque, nonbasic
[BAT] batch, verbatim, battery, dingbat, acrobat, bath, cubature
[BAU] baud, bauble, bauxite, debauch, usquebaugh, subaudition, subauricular
[BAV] bavardage, subaverage
[BAW] bawbee, bawdry, bawcock, bawl, bawdily, bawdy, bawd
[BAX] abaxial, subaxillary
[BAY] bay, sabayon, embay, rosebay, sickbay, bayard, bayonet
[BAZ] bazaar, bazooka, bazillion, bombazine, carbazole, chabazite, bashibazouk
[BBA] abba, cabbage, jubbah, bubba, ribband, sabbath, subbase
[BBE] grabber, jabber, tabbed, rubber, clobber, subbed, gabber
[BBI] rabbit, tabbing, grabbing, rubbish, hobbit, bobbin, dobbin
[BBL] babble, bubble, cobble, pebble, wobble, gobble, nibble
[BBO] ribbons, gibbous, stubborn, abbot, yobbo, tabbouleh, shibboleth
[BBR] abbrev, gabbro, subbranch, abbr, abbreviation, abbreviated, abbreviate
[BBS] gibbsite, ebbs
[BBU] hubbub, dibbuk, dybbuk, kibbutz, dybbukim, kibbutzim, kibbutznik
[BBY] hobby, bobby, chubby, lobby, nubby, clubby, crabby
[BCA] webcast, bobcat, hubcap, mobcap, ribcage, subcategory, webcasting
[BCE] subcellular, subcelestial
[BCH] dabchick, subchaser, subchloride, subchapter, dabchicks
[BCL] subclass, subclasses, subclauses, subclimax, subclavian, subclavius, subclassify
[BCO] subcontract, subcommittee, bibcock, abcoulomb, obcordate, subcortex, subcompact
[BCR] subcranial, subcritical
[BCU] subculture, subcutaneous, subcultural, subcultures
[BDA] lambda, labdanum, molybdate, lambdas, lambdacism, labdanums
[BDE] molybdenum, subdeacon, bdellium, subdelirium, subdebutante, subdeb, subdean
[BDI] subdirectory, subdivision, subdividing, abdicate, molybdic, subdistrict, subdiaconate
[BDO] subdomain, abdominal, rubdown, hebdomad, lambdoid, climbdown, molybdous
[BDR] cabdriver, cabdrivers
[BDT] obdt
[BDU] subdued, abduce, obduce, unsubdued, abduct, subdue, subdual
[BEA] beast, beam, bearer, beautiful, beat, beaver, beach
[BEB] cubeb, bebeeru, bebop, bebeerine, bebops, cubebs
[BEC] because, become, becquerel, beck, xebec, imbecile, becharm
[BED] embedded, described, bed, tabbed, subscribed, perturbed, prescribed
[BEE] been, beer, beetle, beep, beef, honeybee, beechen
[BEF] before, befits, befall, befell, befriend, befuddle, globefish
[BEG] begin, began, begun, begone, begs, beggar, beget
[BEH] behavior, behind, beholder, misbehave, behead, behalves, behooved
[BEI] being, beige, albeit, corbeil, howbeit, inbeing, obeisant
[BEJ] bejewel, bejewels, bejeweled, bejeweling
[BEK] unbeknownst
[BEL] label, below, babel, bell, relabel, barbell, unlabeled
[BEM] bema, bemean, bemire, bemoan, bemuse, bemock, bemused
[BEN] bend, benchmark, benefit, benjamin, bent, workbench, subentry
[BEO] rubeola, cicisbeo, rubeolas
[BEP] hebephrenia, hebephrenias
[BEQ] bequests, bequest, bequeath, bequeaths, bequeathal, bequeathed, bequeather
[BER] number, member, fiber, remember, berlin, libero, grabber
[BES] best, tubes, describes, beside, probes, cubes, lobes
[BET] between, beta, better, alphabet, diabetes, beth, abetting
[BEV] bevel, bevies, bevvy, bevatron, bevy, beverage, beveled
[BEW] beware, bewildering, bewray, bewigged, bewitching, bewhiskered, bewail
[BEX] ibex, ibexes
[BEY] beyond, obey, disobey, abbey, abeyant, beys, obeyed
[BEZ] bezel, bezant, bezoar, bezique, cabezon, embezzle, bezonian
[BFA] subfamily, abfarads, subfamilies
[BFE] gabfest, webfeet, clubfeet, gabfests
[BFI] subfield, numbfish
[BFL] subfloor, subflooring
[BFO] webfoot, clubfoot, dumbfound, clubfooted, dumbfounds, dumbfounded, dumbfounding
[BFR] subfreezing
[BFU] obfuscate, tubful, subfusc, obfuscation, obfuscated, obfuscatory, tubfuls
[BGE] subgenus, subgenre, subgenera
[BGL] subglacial
[BGO] hobgoblin, hobgoblins
[BGR] subgroup, crabgrass, subgroups
[BHA] bhakti, bharal, bhaji, bhang, clubhaul, subharmonic, bhangs
[BHE] subheading, dumbhead, abhenries, subhead, subheadings, subheads
[BHO] abhor, clubhouse, jobholder, abhorred, abhorrer, abhorrent, abhorring
[BHU] subhuman, subhumans
[BIA] bias, unbiased, labial, bilabial, tibia, ambiance, verbiage
[BIB] bibliography, bibs, imbibe, bibcock, bibelot, bibb, bibulous
[BIC] cubic, bicyclist, biceps, alembic, bicolor, syllabic, rhombic
[BID] forbidden, bid, ibid, abide, rubidium, libido, morbidity
[BIE] zombie, ambient, barbie, biennial, bier, babies, corbie
[BIF] bifid, biff, bifurcation, biform, verbify, bifacial, cubiform
[BIG] big, ambiguous, disambiguate, unambiguous, abigail, rubiginous, globigerina
[BII] alibiing
[BIJ] bijection, bijoux, bijugate, bijou, bijouterie
[BIK] biking, bike, motorbike, minibike, pushbike, bikini, biker
[BIL] liability, possibility, probability, capabilities, visibility, mobile, ability
[BIM] bimodal, bimah, bimbo, bimetal, cherubim, bimonthly, bimodality
[BIN] binary, bind, bins, combining, binomial, binned, describing
[BIO] bio, amphibious, dubious, labiodental, gabion, abiosis, gobioid
[BIP] bipartite, bipolar, biplane, biped, biphenyl, bipinnate, biparietal
[BIQ] biquadratic, ubiquity, biquarterly, ubiquitous, biquadrate, ubiquitarian, biquadratics
[BIR] bird, birch, birth, songbird, firebird, rebirth, seabird
[BIS] bisect, ibis, bison, bishop, bisque, rubbish, hibiscus
[BIT] bit, arbitrary, orbital, exhibit, prohibited, rabbit, inhibit
[BIU] erbium, niobium, terbium, ytterbium, labium, cambium, columbium
[BIV] bivalent, ambivalent, bivouac, herbivore, ambiversion, bivalve, ambivert
[BIW] biweekly, biweeklies
[BIY] biyearly
[BIZ] biz, showbiz, syllabize, bizarre, bize, bizarrerie, bizarreness
[BJA] subjacent, subjacency
[BJE] object, subject, abject, nonobjective, objects, objective, objectify
[BJO] subjoined, frabjous, subjoin, subjoinder, subjoins, subjoining
[BJU] subjunctive, abjure, objurgate, subjugate, abjurer, abjuration, abjuratory
[BKE] knobkerrie, knobkerries
[BKI] lambkin, subkingdom, lambkins, subkingdoms
[BKU] lebkuchen
[BLA] black, blank, blah, blame, blaze, tabla, oblate
[BLE] table, double, callable, variable, gobble, visible, iterable
[BLI] blind, bliss, blizzard, goblin, public, bibliography, sibling
[BLO] block, blob, blog, blond, blossom, blowup, blood
[BLU] blue, blur, blush, bluish, doublure, blunt, bludge
[BLY] possibly, probably, reasonably, assembly, reliably, presumably, doubly
[BMA] submarine, webmaster, cabman, clubman, submaxillary, submariner, submarginal
[BME] submerged, cabmen, submember, enjambment, entombment, submediant, submerge
[BMI] submit, resubmitting, webmistress, resubmission, submitted, submission, submitting
[BMO] submolecular
[BMU] submultiple, obmutescence
[BNA] thumbnail, hobnail, thumbnails, hobnails, hobnailed, hobnailing
[BNE] abnegate, drabness, dumbness, glibness, numbness, abnegator, abnegation
[BNI] dubnium, stibnite, stibnites
[BNO] subnormal, abnormal, obnoxious, hobnob, subnotebook, abnormally, abnormality
[BNU] cobnut, obnubilate, cobnuts
[BOA] clipboard, boat, keyboard, board, tugboat, checkerboard, chessboard
[BOB] bob, skibob, cabob, nabob, thingamabob, thingumabob, kebobs
[BOC] bock, bocage, boccie, cabochon, robocall, amebocyte, mobocracy
[BOD] body, bodies, bode, nobody, anybody, somebody, embodiments
[BOE] oboe, buboes, lavaboes, mamboed, oboes
[BOF] boffin, turbofan, riboflavin, subofficer, boffo, boffins, turbofans
[BOG] bogus, gamboge, bogged, bogbean, bogey, bogie, bogle
[BOH] carbohydrate, bohrium, bohemian, rhombohedral, bohunk, tohubohu, nielsbohrium
[BOI] boilerplate, cuboid, boink, framboises, oboist, reboil, garboil
[BOJ] turbojet, turbojets
[BOK] blaubok, blesbok, gemsbok, sjambok, bontebok, boschbok, steenbok
[BOL] symbol, bold, parabola, hyperbolic, bolt, embolden, extrabold
[BOM] bomb, robomb, abomasa, firebomb, mailbomb, hydrobomb, superbomb
[BON] bond, ribbons, bonus, bone, carbon, backbone, bonkers
[BOO] boost, boolean, book, workbook, bootstrap, handbook, notebook
[BOP] bop, suboptimal, bebop, turboprop, teenybopper, bopped, bopper
[BOR] border, neighbors, abort, laboratory, born, borrowed, elaborations
[BOS] verbose, boson, emboss, boss, combos, ambos, ribose
[BOT] both, bottom, robot, bots, verboten, botany, botch
[BOU] about, bound, bout, unbounded, whereabouts, bouquet, gibbous
[BOV] above, bovine, bovver, obovate, arbovirus, bovid, obovoid
[BOW] rainbow, bow, elbow, crossbow, fogbow, sunbow, embow
[BOX] box, mailbox, checkbox, toolbox, unbox, sandbox, shadowbox
[BOY] boy, cowboy, attaboy, busboy, carboy, fanboy, lowboy
[BOZ] bozo, rebozo, bozos
[BPA] subparagraph, webpage, subparallel, subpart, subpar
[BPH] subphylum, subphyla
[BPL] subplots, subplot
[BPO] subpoena, subpoenas, subpoenaed, subpoenaing
[BPR] subproblem, subprogram, bombproof, thumbprint, subprincipal, subprograms, subprime
[BRA] library, bracket, branch, braid, algebraic, calibration, unbraced
[BRE] break, abbrev, brewer, breve, brent, umbrella, unbreakable
[BRI] bridge, bright, brick, brief, equilibrium, hybrid, bring
[BRO] broadcast, browser, broken, subroutine, brought, unbroken, broom
[BRU] brute, brush, paintbrush, toothbrush, abruptly, bruise, sagebrush
[BRY] bryony, embryo, ambry, coxcombry, embryol, bryology, bryozoan
[BSA] subsample, ambsace
[BSC] subscript, abscissa, obscured, unsubscribed, absconder, lobscouse, obscenity
[BSE] subset, observed, absence, unobserved, obsessed, obsecrate, obsequent
[BSH] sibship, jobshare, subshrub, bombshell, jobshares, subshrubs, bombshells
[BSI] website, subsidiary, obsidian, subsistence, absinthe, bombsite, curbside
[BSK] lambskin, lambskins
[BSL] bobsled, bobsleigh, bobsledded, bobsledder, bobsleighs, bobsledding, bobsleds
[BSM] gobsmacked
[BSO] absolute, obsolete, absorbed, reabsorb, subsoil, absonant, dobsonfly
[BSP] subspace, subspaces, subspecies, subspecialty
[BSQ] absquatulate
[BST] abstract, substitute, substantial, lobster, obstacle, substrate, obstruct
[BSU] absurd, subsumed, subsumes, subsume, absurdly, subsurface, absurdities
[BSW] jobsworth, lambswool, jobsworths
[BSY] subsystem, fubsy, subsystems
[BTA] obtain, doubtable, unobtainable, bobtail, thumbtack, subtangent, redoubtably
[BTE] subtext, undoubtedly, indebted, obtect, doubter, subtended, obtest
[BTF] doubtful, doubtfulness, doubtfully
[BTH] subthreshold
[BTI] subtitle, doubting, undoubting, subtitles, subtile, subtilize, subtitled
[BTL] subtle, unsubtle, doubtless, oversubtle, supersubtle, subtly, subtleties
[BTO] subtotal, debtor, subtotals, subtopic, subtonic, subtorrid, debtors
[BTR] subtract, unobtrusive, obtrude, btry, subtraction, subtracted, subtracting
[BTS] doubts, debts, redoubts
[BTU] obtuse, obtund, obturate, obtusity, obtuseness, obtunds, obtuser
[BTY] subtype, subtypes
[BUB] bubble, hubbub, buboes, bubal, syllabub, bubs, bub
[BUC] bucket, trebuchet, buccal, bucolic, jumbuck, roebuck, sawbuck
[BUD] budget, buddy, earbud, redbud, budlike, rosebud, ombudsman
[BUE] imbue, bueno, imbues, imbued
[BUF] buffer, rebuff, buffers, buffered, buffering, buff, buffalo
[BUG] debug, bug, ladybug, bedbug, humbug, redbug, billbug
[BUH] buhl, buhr, buhrstone, buhls
[BUI] build, rebuild, prebuilt, unbuild, upbuild, overbuild, jerrybuilt
[BUK] dibbuk, dybbuk, kabuki, rebuke, dybbukim, rebuking, dibbuks
[BUL] tabular, bullet, bulk, vocabulary, bulb, bulge, ambulance
[BUM] bump, bummer, album, bumbag, bumkin, plumbum, sebum
[BUN] bundle, bunch, bung, bunk, bunny, subunit, abundant
[BUO] buoy, lifebuoy, sonobuoy, buoyancy, buoyage, buoyant, buoyed
[BUP] buprestid, ibuprofen
[BUR] burke, burl, burger, burr, hamburg, starburst, burden
[BUS] robust, business, busy, nimbus, abuse, rhombus, omnibus
[BUT] but, attribute, distributed, contributor, redistribute, pushbutton, debut
[BUX] buxom, buxomness, buxomnesses
[BUY] buyer, buying, buys, buyout, buyback, overbuy, buy
[BUZ] buzz, abuzz, buzzer, buzzword, buzzwords, buzzard, buzzsaw
[BVA] subvariety
[BVE] subversion, subverting, obvert, subvention, subvert, subverted, obverse
[BVI] obvious, unobvious, subvisible, obviously, obviate, obviated, obviates
[BVO] obvolute, subvocal, abvolts
[BWA] subway, bwana, dumbwaiter, abwatts, subways, dumbwaiters
[BWE] cobweb, cobwebby, cobwebbed, cobwebs, cobwebbier, cobwebbiest
[BWH] bobwhite, bobwhites
[BWI] barbwire, crabwise
[BWO] lobworm, ribwort, webworm, cribwork, clubwoman, scrubwoman, lobworms
[BYC] bombycid, bombycids
[BYE] bye, goodbye, lobbyer, byes, goodbyes
[BYG] bygone, bygones
[BYH] babyhood, cubbyhole, hobbyhorse, cubbyholes, hobbyhorses
[BYI] babyish, hobbyist, lobbyism, abying, lobbyist, babying, lobbying
[BYL] byline, bylaw, sibyl, carbylamine, sibylline, bylaws, sibyls
[BYO] presbyopia, presbyopic
[BYP] bypass, byproduct, byplay, bypassing, bypassed, bypasses, bypath
[BYR] labyrinth, byrnie, byroad, byre, labyrinths, labyrinthian, labyrinthine
[BYS] abysmal, bystanders, byssus, flybys, babysat, bystreet, standbys
[BYT] bytes, kilobyte, gigabytes, megabytes, terabytes, exabytes, babytalk
[BYW] byword, byway, byways, bywords
[BYZ] byzantine
[BZE] subzero
[CAA] advocaat, balmacaan
[CAB] applicable, vocab, irrevocable, cab, practicable, taxicab, amicable
[CAC] cache, cactus, efficacy, acacia, macaco, cacao, cackling
[CAD] academy, cascade, cad, decade, cicada, facade, avocado
[CAE] caesura, vesicae, caeoma, plicae, thecae, cloacae, loricae
[CAF] scaffold, cafe, cafard, caftan, decaf, caff, beccafico
[CAG] decagon, dodecagon, cage, undecagon, bocage, cagier, encage
[CAH] dodecahedron, cahier, cahoot, alcahest, decahedra, dodecahedral, decahedral
[CAI] cain, alcaic, caiman, caird, caisson, caitiff, eucaine
[CAJ] cajole, cajeput, cajuput, carcajou, cajoler, cajolery, cajoling
[CAK] cake, cupcake, shortcake, pancakes, hoecake, hotcake, oatcake
[CAL] scale, local, call, vertical, categorical, mathematical, calculate
[CAM] camera, became, campo, guacamole, webcam, bicameral, camouflage
[CAN] can, scan, significant, secant, cosecant, vacancies, toucan
[CAO] cacao, curacao, caoutchouc, cacaos, caoutchoucs
[CAP] caption, capital, escape, capacity, capabilities, landscape, caps
[CAQ] macaque, macaques
[CAR] carp, card, care, discard, carrier, cart, wildcard
[CAS] case, cast, broadcast, lowercase, uppercase, upcast, casing
[CAT] category, location, application, deprecated, modification, catch, scatter
[CAU] because, caused, caught, caution, uncaught, precaution, cauda
[CAV] caveat, concave, cavity, scavenge, cavort, cavalla, peccavi
[CAW] caw, macaw, cawing, macaws, cawed, caws
[CAY] decay, cay, picayune, decaying, decays, decayed, cayuse
[CAZ] alcazar, alcazars
[CBO] ecbolic
[CCA] occasionally, moccasin, staccato, peccant, acciaccatura, buccal, baccate
[CCE] accent, success, eccentricity, unsuccessful, inaccessible, soccer, unacceptable
[CCH] bacchanal, gnocchi, saccharin, zucchini, zecchino, radicchio, ecchymosis
[CCI] accidentally, vaccine, succinct, occipital, cappuccino, acciaccatura, boccie
[CCL] ecclesiastic, occluded, acclaimed, acclimate, acclivity, acclamation, ecclesiology
[CCO] according, accompanying, accounting, accommodate, accomplish, morocco, raccoon
[CCR] accrue, eccrine, disaccredit, unaccredited, accrued, accrete, accrual
[CCT] acct
[CCU] accuracy, occur, accumulators, inaccurate, accusative, sacculus, accustomed
[CCY] coccyx, baccy, coccyges, coccygeal
[CDO] anecdote, synecdoche, anecdotal, anecdotic, anecdotage, anecdotist, synecdochic
[CDY] ecdyses, ecdysis, ecdysiasm, ecdysiast, ecdysone, ecdysiasts
[CEA] enforceable, cease, ocean, conceal, noticeable, replaceable, sliceable
[CEB] iceberg, placebo, ricebird, spaceband, spicebush, noticeboard, serviceberry
[CEC] cecity, icecap, cecal, cecum, facecloth, racecourse, spacecraft
[CED] reduced, precedence, replaced, placed, cedilla, balanced, procedure
[CEE] proceed, succeed, exceeds, emcee, fiancee, glaceed, sycee
[CEF] gracefully, henceforth, forcefully, peacefully, icefall, voiceful, ungraceful
[CEG] racegoer, vicegerent, vicegerency, racegoers, vicegerents
[CEH] placeholder, racehorse, icehouse, officeholder, placeholders, icehouses, racehorses
[CEI] received, ceiling, perceived, conceivable, deceit, orcein, caducei
[CEK] hacek, placekick, peacekeeper, placekicker, peacekeeping, haceks, placekicks
[CEL] cell, cancel, excel, celt, accelerate, decelerate, marcel
[CEM] enhancement, replacement, placement, announcement, displacement, enforcement, policeman
[CEN] license, center, accent, percent, recent, adjacent, descent
[CEO] ceorl, piceous, araceous, poaceous, ceraceous, cetaceous, embraceor
[CEP] except, accept, intercept, concept, apperception, facepalming, perceptions
[CER] certain, producer, concerning, uncertainty, cancer, officer, reducers
[CES] process, indices, matrices, references, access, necessary, preprocessed
[CET] facet, placet, ceteris, scilicet, videlicet, acetic, nicety
[CEU] caduceus, lyceum, douceur, farceur, berceuse, gynaeceum, pharmaceutic
[CEW] piecewise, policewoman, raceway, lacewing, lancewood, sluiceway, spacewalk
[CEY] dicey, pricey, spacey, pacey
[CHA] char, changes, chapter, chain, unchanged, mechanism, cham
[CHB] boschbok, lunchbox, matchbox, punchbag, aitchbone, hatchback, hunchback
[CHC] pinchcock, watchcase, beachcomber, breechcloth, scratchcard, beachcombing, breechcloths
[CHD] watchdog, archduke, touchdown, witchdoctor, archducal, archduchy, archdeacon
[CHE] check, cache, apache, schema, matches, dispatcher, patches
[CHF] pitchfork, watchful, archfiend, beachfront, reproachful, watchfulness, archfiends
[CHG] sprechgesang, chge, lychgate, churchgoer, switchgear, churchgoing, lychgates
[CHH] hitchhiker, beachhead, touchhole, hitchhike, beachheads, hitchhiked, hitchhikes
[CHI] child, archive, matching, machine, chimera, chip, searching
[CHK] latchkey, munchkin, latchkeys, munchkins
[CHL] chlorine, hatchling, branchless, richly, schlep, chlamys, cichlid
[CHM] benchmark, attachment, drachma, parchment, enrichment, schmuck, detachment
[CHN] technical, technology, polytechnic, technetium, richness, schnoz, ichnite
[CHO] anchor, choice, choose, chosen, echo, chop, school
[CHP] launchpad, hotchpot, linchpin, catchpole, marchpane, sketchpad, pinchpenny
[CHR] chrome, chrysanthemum, christian, synchronized, monochrome, asynchronous, ochre
[CHS] epochs, fuchsia, psychs, stomachs, aurochs, eunuchs, scotchs
[CHT] lunchtime, archt, yacht, chthonic, echt, ichthyic, autochthon
[CHU] chunk, church, chuck, chub, brochure, parachute, chute
[CHV] boschvark
[CHW] schwa, patchwork, inchworm, archway, hatchway, beachwear, beechwood
[CHY] hierarchy, achy, stretchy, peachy, crunchy, sketchy, monarchy
[CHZ] machzor
[CIA] special, associated, commercial, official, especially, social, beneficial
[CIB] irreducible, reproducible, reducible, forcibly, coercible, decibels, crucible
[CIC] cicada, fascicules, cicero, icicles, calcic, acicula, boracic
[CID] incidental, decide, coincide, accidentally, acid, undecidable, lucid
[CIE] coefficients, dependencies, efficient, scientific, frequencies, society, sufficient
[CIF] specified, pacific, unspecified, calcify, cruciform, mercifully, dulcify
[CIG] cig, decigram, cigarette, cigar, cigarillo, cigars, decigrams
[CII] xcii, coraciiform
[CIL] stencil, facility, oscillator, council, pencil, deciles, oscilloscope
[CIM] decimal, hexadecimal, specimen, duodecimo, cimex, cimbalom, dulcimer
[CIN] spacing, facing, tracing, forcing, slicing, replacing, reducing
[CIO] coercion, malicious, suspicious, spacious, delicious, sociology, precious
[CIP] cipher, principal, recipient, encipher, reciprocal, participant, decipher
[CIQ] cacique, caciques
[CIR] circuit, semicircle, encircle, cirrus, cire, cirque, cirsoid
[CIS] precision, decision, exercise, concise, cisco, abscissa, scissors
[CIT] opacity, explicit, capacity, cite, implicit, velocity, publicity
[CIU] calcium, francium, americium, lawrencium, silicium, androecium, aecium
[CIV] civilian, xciv, conducive, civet, civvies, civically, lascivious
[CIX] xcix
[CIZ] criticized, italicized, laicize, ethicize, logicize, anglicize, metricize
[CKA] package, clickable, checkable, lockable, prepackaged, cockatoo, trackable
[CKB] checkbox, blackberry, backbone, trackball, blackboard, hackbut, lockbox
[CKC] blockchain, backchat, blackcap, deckchair, neckcloth, sackcloth, backcomb
[CKD] backdrop, jackdaws, blackdamp, crackdown, knockdown, backdoor, backdrops
[CKE] bracket, socket, checked, stacked, packer, ticket, tracker
[CKF] backfill, sackful, jackfish, rockfall, wreckful, blackface, chockfull
[CKG] background, backgammon, blackguard, backgrounds, backgrounder, blackguards, blackguardly
[CKH] backhand, blockhead, blackheart, stockholders, deckhand, dickhead, dockhand
[CKI] checking, blocking, tracking, unpacking, locking, packing, stacking
[CKJ] lockjaw, buckjump, blackjack, stockjobber, blackjacks, buckjumper, blackjacked
[CKK] jackknife, brickkiln, knickknack, jackknives, brickkilns, jackknifed, jackknifes
[CKL] buckle, cackle, chuckle, pickle, blacklist, quickly, backlog
[CKM] checkmark, hackman, pockmark, stockman, trackman, blackmail, clockmaker
[CKN] thickness, acknowledge, nickname, sickness, slackness, blackness, cockney
[CKO] checkout, knockout, reckon, gecko, blackout, lockout, beckon
[CKP] checkpoint, backpack, cockpit, duckpin, jackpot, chickpea, crackpot
[CKR] cockroach, checkrow, buckra, backrest, muckrake, rickrack, rockrose
[CKS] blocks, checks, ticks, backslash, callbacks, locks, socks
[CKT] backtrack, cocktail, necktie, buckteeth, blacktop, ducktail, ticktack
[CKU] backup, pickup, checkups, cockup, lockup, ruckus, crackup
[CKW] backward, clockwise, shockwave, duckweed, hackwork, muckworm, neckwear
[CKY] sticky, tricky, rocky, lucky, bricky, unlucky, icky
[CLA] class, clause, declare, subclass, disclaimer, claim, exclamation
[CLE] cycle, circle, clear, article, particle, clever, oracle
[CLI] client, clip, click, euclidean, cyclic, clique, cline
[CLO] close, clock, clone, cloud, enclosed, cloak, unclosed
[CLU] club, cluck, clue, clump, cluster, include, exclude
[CLV] clvii, clvi
[CLX] clxvii, clxii, clxiv, clxix, clxvi, clxi
[CLY] publicly, muscly, clypeus, clyster, treacly, cataclysm, chicly
[CMA] chacma, socman, blancmange, chacmas, blancmanges
[CME] acme, acmes
[CNE] cnemis, acne, chicness, prosaicness, gastrocnemii, publicness, graphicness
[CNI] picnic, cnidarian, pycnidium, cnidoblast, picnicked, picnicker, picnicking
[CNO] acnode, tacnode, pycnometer, anthracnose
[COA] coated, cocoa, coalesce, coarse, uncoated, coaster, charcoal
[COB] cobra, cobblestone, cobalt, cobnut, coburg, cobweb, cobia
[COC] cocoa, peacock, cocktail, cochineal, cockatoo, cockroach, ricochet
[COD] code, encoding, decode, coding, opcode, bytecode, recode
[COE] coefficients, coerce, coelacanth, coexist, coeval, cacoepy, ciscoes
[COF] coffin, picofarad, scoff, coffee, coff, coffins, coffer
[COG] recognized, unrecognized, cog, incognito, lexicography, glycogen, oncogene
[COH] coherence, incoherence, cohesion, cohort, alcohol, cohune, cohabit
[COI] coil, coin, bitcoin, recoilless, coitus, coif, dacoit
[COK] coke, coking, coked, cokes
[COL] color, columns, collection, cols, protocol, semicolon, collapse
[COM] com, recommended, incompatible, become, outcome, incomplete, precomputed
[CON] controls, second, convert, conditions, constant, continue, container
[COO] coordinate, cookie, cool, scooter, raccoon, coop, coon
[COP] copyright, scope, copies, coplanar, copyleft, copper, cope
[COQ] coquelicot, coquille, monocoque, coquettish, coquetries, coquet, coquina
[COR] score, core, corner, record, correct, decorate, according
[COS] cos, icosahedral, viscosity, ecosystem, picoseconds, cocos, glucose
[COT] cot, scotch, apricot, dovecot, mascot, terracotta, butterscotch
[COU] count, could, couple, course, account, encountered, uncouple
[COV] cover, covariance, discovery, recover, uncover, alcove, hardcover
[COW] cow, scowl, locoweed, stuccowork, cowboy, cows, cowbell
[COX] cox, coxae, coxcomb, coxa, coxalgia, coxswain, coxcombry
[COY] decoy, coyote, coypu, coyness, coyest, coyly, coy
[COZ] coz, cozy, cozens, cozily, cozen, coze, cozenage
[CPH] ecphoneses, ecphonesis
[CPT] acpt
[CQU] acquire, becquerel, reacquire, lacquer, jacquard, racquetball, unacquainted
[CRA] crash, scratch, crates, cram, crayon, crawl, crack
[CRE] create, screen, discrete, increasing, secret, concrete, increment
[CRI] description, script, subscript, superscript, critical, criterion, diacritic
[CRO] macro, cross, across, croak, scroll, micro, crop
[CRU] crude, cruel, cruise, crumb, crunch, crucial, breadcrumb
[CRY] cryptography, encryption, decrypt, crying, crystal, outcry, acrylic
[CSI] facsimile, tocsin, facsimiles, facsimileing, tocsins, facsimiled
[CSO] frolicsome
[CST] ecstasy, ecstatic, ecstatically, ecstasies, ecstatics
[CTA] rectangle, octave, expectation, reactants, connectable, tractable, inductance
[CTE] expected, protected, character, directed, connected, detected, selected
[CTF] respectfully, tactful, neglectful, unrespectful, untactful, respectful, tactfulness
[CTG] actg
[CTH] ecthyma
[CTI] function, action, section, direction, collection, connection, dictionary
[CTL] directly, exactly, correctly, strictly, indirectly, incorrectly, perfectly
[CTM] enactment, selectman, indictment, ejectment, reenactment, selectmen, enactments
[CTN] correctness, compactness, strictness, exactness, perfectness, inexactness, erectness
[CTO] vector, factor, directory, selector, constructor, detector, inductor
[CTR] electron, spectral, directrix, doctrine, octroi, actress, plectra
[CTS] objects, products, effects, expects, projects, affects, defects
[CTU] actual, cactus, fracture, lecture, picture, structure, punctuation
[CTW] selectwoman, selectwomen
[CTY] dactyl, ectype, syndactyl, tridactyl, adactylous, amphictyon, polydactyl
[CTZ] hoactzin, hoactzins
[CUA] evacuate, arcuate, acuate, escuage, evacuation, evacuant, arcuation
[CUB] cubic, cube, hypercube, cubature, cuboid, incubator, cubby
[CUC] cucumber, cuckoo, cucurbit, cucullate, cuculiform, cuckold, cuckoldry
[CUD] barracuda, cud, escudo, incudes, scudded, docudrama, cuddle
[CUE] rescue, curlicue, cue, evacuees, fescue, miscue, autocue
[CUF] cuff, scuff, handcuff, fisticuff, scuffle, fisticuffs, cuffed
[CUI] circuit, cuisine, rescuing, biscuits, acuity, cuirass, vacuity
[CUK] cuke, cukes
[CUL] particular, calculate, circular, molecule, difficult, recalculate, curriculum
[CUM] document, circumflex, cumulative, accumulators, undocumented, circumvent, cucumber
[CUN] cuneiform, quincunx, fecundity, secund, cunning, jocund, lacuna
[CUO] vacuous, innocuous, nocuous, conspicuous, perspicuous, promiscuous, transpicuous
[CUP] cup, occupy, teacup, eggcup, eyecup, hiccup, oilcup
[CUR] current, curve, cursor, accuracy, recursion, recurrence, procurement
[CUS] custom, focus, discussion, circus, excuse, abacus, crocus
[CUT] cut, acute, execute, shortcut, consecutive, haircut, uppercut
[CUU] vacuum, vacuums, vacuumed, vacuuming
[CUV] cuvette
[CUZ] scuzzy, jacuzzi, scuzzier, scuzziest
[CVI] xcvii, xcvi
[CWE] colicweed
[CYA] cyan, cyathus, hyoscyamus, isocyanide, anthocyanin, ferricyanide, ferrocyanide
[CYB] cybernetics, cyberpunk, cyborg, cybercafe, cyberbully, cyberspace, psilocybin
[CYC] bicycle, cycle, recycle, tricycle, acyclic, motorcycle, polycyclic
[CYG] cygnet, coccyges, coccygeal, cygnets
[CYH] policyholder
[CYI] fancying
[CYL] cylinder, acyl, salicylic, cyl, cylindrical, cylix, cylindroid
[CYM] policymaker, cymbal, cymene, cymoid, cymar, policymakers, cymose
[CYN] cynic, cynosure, colocynth, apocynthion, apocynaceous, pericynthion, cynical
[CYO] halcyon
[CYP] scyphi, cypress, cypsela, pelecypod, cyperaceous, scyphus, cyprinid
[CYS] cysteine, encyst, otocyst, cystitis, cholecyst, cystocarp, cystolith
[CYT] cytology, cytoplasmic, oocyte, scythe, cytaster, cytosine, gonocyte
[CYW] fancywork
[CYX] coccyx
[CZA] czar, czarina, czarist, czars, czardas, czardom, czarism
[CZE] eczema, eczematous
[DAB] expandable, readable, foldable, dab, extendable, loadable, unreadable
[DAC] redact, headache, dactyl, audacity, dacoit, dacha, edacity
[DAD] dad, crawdad, aoudad, caudad, doodad, alidade, saudade
[DAE] daemon, sundae, daemonic, daemons, sundaes
[DAF] daft, daff, daffodil, daftly, daffodils, daffily, daffy
[DAG] dagger, bandage, dags, bondage, pedagogical, adage, dagoba
[DAH] dahlia, doodah, howdah, keddah, purdah, whidah, whydah
[DAI] daily, daisy, dairy, daikon, daimio, dainty, midair
[DAK] dak, daks
[DAL] standalone, sinusoidal, chordal, medal, modal, trapezoidal, pyramidal
[DAM] damages, damper, fundamental, dame, dammit, rhodamine, madame
[DAN] redundant, avoidance, danish, guidance, accordance, descendant, dangling
[DAP] adapted, dap, edaphic, preadapt, maladapted, nonadaptive, readapt
[DAR] standard, dark, boundary, calendar, secondary, radar, dart
[DAS] pandas, dash, lambdas, amidase, czardas, dastard, dasyure
[DAT] data, date, update, metadata, validate, foundation, candidate
[DAU] landau, daughter, dauphine, bedaub, dauber, padauk, daunt
[DAV] davenport, affidavits, cadaver, davit, amadavat, avadavat, affidavit
[DAW] dawn, jackdaws, dawdle, bradawl, predawn, foldaway, godawful
[DAX] adaxial, addax, broadax, pseudaxis, addaxes, broadaxes
[DAY] day, today, weekday, holidays, workday, someday, birthday
[DAZ] dazzle, dazed, bedazzle, imidazole, dazing, daze, dazzler
[DBA] feedback, handball, headband, oddball, hardball, sandbag, windbag
[DBE] cudbear, roadbed, seedbed, childbed, deadbeat, rudbeckia, shadberry
[DBI] tidbit, redbird, handbill, reedbird, woodbine, broadbill, soundbite
[DBL] roadblock, sandblast, windblown, woodblock, mindblower, coldblooded, sandblaster
[DBO] handbook, sandbox, speedboat, breadbox, cardboard, bandbox, deadbolt
[DBR] endbrain, midbrain, redbrick, birdbrain, broadbrim, goldbrick, handbrake
[DBU] bedbug, redbud, headbutt, reedbuck, shadbush, windburn, cloudburst
[DBY] goodbye, standby, standbys, goodbyes
[DCA] broadcast, wildcard, rebroadcast, madcap, mudcat, redcap, handcar
[DCH] grandchild, godchild, shadchan, windchill, woodchuck, bedchamber, headcheese
[DCL] handclap, headcloth, bedclothes, broadcloth, groundcloth, handclasp, groundcloths
[DCO] hardcover, headcount, redcoat, bedcover, woodcock, midcourse, hardcore
[DCR] breadcrumb, handcrafted, goldcrest, woodcraft, swordcraft, breadcrumbs, handcraft
[DCU] woodcut, handcuff, redcurrant, woodcutter, woodcutting, woodcuts, handcuffs
[DDA] midday, addable, cheddar, keddah, chuddar, goddamn, khaddar
[DDB] oddball, oddballs
[DDE] added, hidden, embedded, padded, forbidden, overridden, ladder
[DDF] eisteddfod, eisteddfods
[DDH] buddhi
[DDI] additional, padding, embedding, additively, oddity, reddish, wedding
[DDL] cuddle, fiddle, middle, paddle, puddle, oddly, saddle
[DDM] oddment, oddments
[DDN] oddness
[DDO] eddoes, haddock, kiddo, paddock, piddock, ruddock, shaddock
[DDR] address, unaddressed, headdress, misaddress, preaddress, readdress, addresses
[DDS] adds, odds, rudds
[DDU] adduct, siddur, diddums, adductor, adduce, adducible, adduction
[DDY] teddy, eddy, muddy, faddy, toddy, cruddy, shoddy
[DEA] deal, euclidean, ideal, dead, deactivate, death, deaf
[DEB] debug, sidebar, debate, debt, debris, debit, indebted
[DEC] decimal, decode, declare, decreasing, hexadecimal, predecessor, decay
[DED] provided, needed, added, expanded, loaded, extended, included
[DEE] deep, deemed, indeed, deed, deer, redeemed, deejay
[DEF] def, undefined, redefine, indefinite, predefined, prideful, spadeful
[DEG] degree, degenerate, degas, bodega, degust, biodegrade, bridegroom
[DEH] aldehyde, dehorn, dehisce, dehydrator, dehypnotize, hobbledehoy, paraldehyde
[DEI] deity, deicer, deific, codeine, deign, deist, fideism
[DEJ] deject, dejecta, dejected, dejection, dejects, dejecting, dejectedly
[DEK] dekko, baudekin, dekagram, sidekick, dekaliter, dekameter, dekkos
[DEL] model, delta, delete, delay, delimiter, guidelines, deliberate
[DEM] demo, trademark, demand, academy, indemnify, idem, demean
[DEN] indent, hidden, dense, identity, denom, confidence, dependency
[DEO] ideograph, video, fadeout, hideous, ideological, deodar, odeon
[DEP] depth, deprecated, independent, dependency, depletion, department, deployment
[DEQ] adequate, dequeue, inadequate, adequacy, adequately, dequeued, inadequacy
[DER] order, under, header, border, builder, der, reader
[DES] nodes, description, codes, desired, provides, destination, includes
[DET] detail, determine, detected, undetermined, detriment, geodetic, cadet
[DEU] deuteron, deuce, odeum, froideur, grandeur, stomodeum, deutoplasm
[DEV] device, developer, deva, devoted, undeveloped, bedevil, medevac
[DEW] sideways, honeydew, codewords, dew, mildew, sundew, bedew
[DEX] index, subindex, dexter, caudex, codex, spandex, ambidexter
[DEY] dey, snidey, deadeye, goldeye
[DEZ] morbidezza, rendezvous, rendezvoused, rendezvouses
[DFA] boldface, grandfather, bedfast, deadfall, handfast, holdfast, landfall
[DFE] bedfellow, bedfellows
[DFI] goldfish, wildfires, redfin, codfish, mudfish, bloodfin, landfill
[DFL] gadfly, mudflap, sandfly, toadflax, wildflower, windflower, mudflat
[DFO] landform, wildfowl, blindfold, eisteddfod, godforsaken, hundredfold, headforemost
[DFR] breadfruit, chaudfroid, breadfruits
[DFU] handful, mindful, heedful, needful, dreadful, crowdfund, regardful
[DGA] endgame, windgall, floodgate, boardgames, endgames, floodgates
[DGE] badge, bridge, edge, fudge, judge, knowledge, widget
[DGI] fudging, nudging, pidgins, bridging, dodgier, hedging, judging
[DGL] fledgling, sandglass, fledglings, sandglasses
[DGM] judgment, abridgment, lodgment, adjudgment, misjudgment, prejudgment, dislodgment
[DGR] handgrip, landgrave, waldgrave, landgravine, landgraviate, handgrips, landgraves
[DGU] midgut, handgun, hindgut, mudguard, handguns, hindguts, mudguards
[DGY] dodgy, edgy, fledgy, sludgy, smudgy, stodgy, pudgy
[DHA] dharma, hardhat, guildhall, behindhand, loudhailer, secondhand, karmadharaya
[DHE] adhere, handhelds, gesundheit, bedhead, godhead, redhead, baldhead
[DHI] sandhi, buddhi, adhibit, samadhi, bodhisattva
[DHO] childhood, groundhog, madhouse, roadhouse, dhobi, dhole, dhoti
[DHP] jodhpur, jodhpurs
[DHS] ceilidhs
[DHU] dhurrie, sadhu, headhunt, goodhumored, headhunter, headhunting, sadhus
[DHY] dhyana
[DIA] immediate, median, diag, dialog, diamond, diabetes, diaeresis
[DIB] dib, edible, incredibly, audible, credibility, erodible, inedible
[DIC] dict, indices, predict, radical, periodic, dyadic, vedic
[DID] candidate, did, undid, redid, iodide, misdid, outdid
[DIE] die, gradient, bodies, studied, audience, medieval, remedies
[DIF] diff, modified, unmodified, indifference, solidify, codify, nidify
[DIG] digit, digraph, digest, digamma, indigo, pedigree, paradigm
[DIH] dihedral, dihybrid, dihydric, hardihood, dihedron
[DII] radii
[DIK] diktat, dike, predikant, diking, diked, dikes, diktats
[DIL] cedilla, dilation, readily, greedily, crocodile, diluted, dill
[DIM] dim, embodiments, rudimentary, impediment, bedim, pediment, sediment
[DIN] encoding, including, coordinate, heading, leading, padding, ending
[DIO] diode, audio, radio, studio, stdio, idiom, tedious
[DIP] dip, serendipity, adipose, oedipal, audiphone, dandiprat, nifedipine
[DIR] dir, indirect, redirect, undirected, subdirectory, misdirected, nadir
[DIS] dist, display, disable, redistribute, disclaimer, discrete, disjoint
[DIT] conditions, additional, edit, credit, validity, ditto, traditional
[DIU] radius, medium, sodium, stadium, indium, iridium, rhodium
[DIV] divide, individual, divergence, subdivision, diversity, divorced, indivisible
[DIW] diwan, handiwork, diwans
[DIX] appendix, radix, spadix, dixie, dixieland, dixies, radixes
[DIZ] dizen, dizygotic, dizzy, standardize, jeopardize, oxidized, fluidized
[DJA] adjacent, nonadjacent, windjammer, adjacency, adjacently, windjammers
[DJE] adjective, djebel, djellaba, adjectives, adjectival, djellabas, adjectivally
[DJI] djinni, djinns, djinn
[DJO] adjoint, readjourn, adjoin, adjoined, adjoining, adjourn, adjournment
[DJT] adjt
[DJU] adjust, readjust, unadjusted, coadjutor, preadjust, maladjusted, adjusted
[DKA] vodka, vodkas
[DKE] handkerchief
[DKI] bodkin, roadkill, weedkiller, bodkins, weedkillers
[DLA] headlamp, bedlam, medlar, badland, midland, mudlark, landlady
[DLE] handle, middle, bundle, regardless, idle, headless, unhandled
[DLI] handling, headline, deadline, bundling, midline, seedling, fiddling
[DLO] deadlock, wedlock, endlong, feedlot, padlock, sandlot, woodlot
[DLU] hoodlum, landlubber, hoodlumism, hoodlums, landlubbers, landlubberly
[DLV] dlvy
[DLY] badly, deadly, friendly, gladly, oddly, repeatedly, rapidly
[DMA] landmarks, goodman, grandma, freedman, handmade, admass, badman
[DME] amendments, madmen, badmen, hodmen, admen, bondmen, headmen
[DMI] admin, badminton, cadmium, windmill, inadmissible, sysadmin, goldmine
[DMO] admonition, godmother, grandmother, admonishment, endmost, midmost, badmouth
[DNA] echidna, ordnance, kidnapping, adnate, padnag, kidnap, kidnapped
[DNE] badness, goodness, handedness, kidney, oddness, madness, boldness
[DNI] midnight, nudnik, goodnight, grandniece, prednisone, nudnick, midnights
[DNO] endnote, headnote, woodnote, monadnock, dreadnought, hydnocarpate, dreadnoughts
[DNU] breadnut, quidnunc, groundnut, groundnuts
[DOA] doable, ogdoad, zedoary, ogdoads
[DOB] adobe, dob, cordoba, endoblast, cnidoblast, dobro, adobes
[DOC] doc, undocumented, endocrine, burdock, haddock, paddock, piddock
[DOD] dodge, dodecahedron, dodo, dodder, endoderm, rhododendron, dodecagons
[DOE] does, undoes, torpedoes, dadoes, didoes, eddoes, dildoes
[DOF] doff, handoff, sendoff, iodoform, standoff, standoffish, doffed
[DOG] dog, watchdog, endogenous, bandog, fogdog, lapdog, seadog
[DOI] doit, doing, undoing, redoing, gadoid, boudoir, doily
[DOK] judoka
[DOL] dollar, dolor, methodology, dolphin, dolmen, gadolinium, dolce
[DOM] random, domain, freedom, domino, subdomain, seldom, wisdom
[DON] done, tendon, donkey, radon, pseudonym, donate, dong
[DOO] door, doomed, doodah, hoodoo, voodoo, backdoor, outdoors
[DOP] adopted, pseudopod, readopt, dopier, doper, dopa, acidophil
[DOR] vendor, endorse, fedora, pandora, commodore, dor, unadorned
[DOS] dos, escudos, pseudos, kudos, commandos, aldose, nodose
[DOT] dot, ridotto, anecdote, peridot, epidote, acidotic, antidote
[DOU] double, handout, foldout, doughnut, standout, readout, hazardous
[DOV] dove, holdover, cordovan, dovish, handover, ringdove, turtledove
[DOW] down, window, markdown, shadow, shutdown, widow, breakdown
[DOX] doxy, orthodox, paradox, unorthodox, indoxyl, doxology, heterodox
[DOY] doyen, doyenne, doyens, doyennes
[DOZ] dozen, dozily, bulldoze, dozy, dozens, doze, bulldozer
[DPA] endpaper, grandparent, sandpaper, bedpan, deadpan, hardpan, mudpack
[DPE] woodpecker, woodpeckers
[DPH] headphone, headphones
[DPI] dpi, headpin, sandpit, codpiece, handpick, windpipe, woodpile
[DPL] endplay, bedplate, wordplay, swordplay, floodplain, floodplains
[DPO] endpoint, midpoint, tadpole, standpoint, bedpost, redpoll, seedpod
[DPR] skidproof, windproof, woodprint, childproof, soundproof, childproofs, soundproofs
[DQU] headquarters, hindquarters, headquarter, hindquarter
[DRA] draw, draft, quadratic, drag, drain, redraw, dihedral
[DRE] address, children, hundred, cadre, dress, drew, dreamy
[DRI] driver, drink, cylindrical, drift, drill, quadric, screwdriver
[DRO] drop, android, polyhedron, tetrahedron, hydrogen, teardrop, octahedron
[DRU] quadruple, drug, drum, woodruff, drudge, drubbed, druid
[DRY] dry, sundry, foundry, laundry, bawdry, tawdry, balladry
[DSA] bandsaw, handsaw, headsail, windsail, bandsaws, handsaws, headsails
[DSC] landscape, headscarf, cloudscape, soundscape, adscription, adscititious, landscaped
[DSE] headset, mindset, handsets, godsend, birdseed, mdse, groundsel
[DSH] handshake, spreadsheet, redshift, friendship, amidships, godship, midship
[DSI] midsize, broadside, hindsight, bedsit, woodsia, landside, roadside
[DSK] kidskin, redskin, mudskipper, redskins, mudskippers
[DSL] landslid, mudslide, landslip, landslide, mudslinger, mudslinging, landslips
[DSM] guardsman, bandsman, wordsmith, beadsman, bondsman, headsman, herdsman
[DSO] handsome, adsorb, godson, bedsore, birdsong, gladsome, grandson
[DSP] loudspeaker, godspeed, feldspar, bedspread, handspike, bloodsport, headspring
[DST] midst, headstone, sandstone, feedstock, gladstone, yardstick, standstill
[DSU] windsurf, midsummer, bloodsucker, windsurfer, windsurfing, bloodsucking, windsurfs
[DSW] windswept, bondswoman, broadsword, codswallop, groundswell, bondswomen, broadswords
[DSY] woodsy, sudsy
[DTA] hardtack, broadtail, swordtail, birdtables, broadtails, swordtails
[DTE] midterm, headteacher, midterms, headteachers
[DTH] breadth, hundredth, thousandth, width, bandwidth, hairbreadth, handbreadth
[DTI] bedtime, seedtime, windtight, bedtimes, seedtimes
[DTO] redtop, hardtop, midtown, hardtops
[DTR] roundtrip, soundtrack, soundtracks
[DUA] individual, dual, residual, graduate, postgraduate, decidua, duarchy
[DUB] dubious, dubnium, dubbed, overdub, indubitably, dubs, dub
[DUC] product, reduce, reproduce, duck, inductor, introduction, deduce
[DUD] dud, dude, dudeen, dudish, dudgeon, duding, duded
[DUE] due, residue, subdued, fondue, overdue, undue, vendue
[DUF] duff, shaduf, duffing, duffs, duffel, duffer, duffed
[DUG] dug, skulduggery, dugong, dugout, dugongs, dugouts
[DUH] duh
[DUI] conduit, duiker, assiduity, enduing, subduing, conduits, assiduities
[DUK] duke, archduke, dukedom, dukes, dukedoms, archdukes
[DUL] module, scheduler, adult, dull, pendulum, reschedule, unscheduled
[DUM] dummy, dump, addendum, dumb, memorandum, definiendum, duma
[DUN] redundant, dun, induna, peduncle, whodunit, coadunate, granduncle
[DUO] duo, deciduous, arduous, assiduous, indeciduous, duotone, duopoly
[DUP] dup, speedup, roundup, buildup, avoirdupois, holdup, redupl
[DUR] during, duration, procedure, bordure, durability, bahadur, nondurable
[DUS] solidus, industrial, fundus, dusty, dusk, stardust, exodus
[DUT] dutch, duty, duties, duteous, undutiful, edutainment, dutifully
[DUU] residuum, duumvir, duumvirate
[DUV] duvet, duvetyn, duvets
[DUX] redux, dux
[DVA] advance, aardvark, disadvantage, dvandva, advanced, advantage, advances
[DVE] advertising, adversary, adventure, inadvertent, adverbial, advection, advertence
[DVI] advised, inadvisable, misadvize, worldview, unadvised, advice, advise
[DVO] advocate, advowson, advocaat, advocacy, advocator, advocated, advocates
[DVT] advt
[DWA] dwarf, hardware, midway, headwater, groundwater, roadways, adware
[DWE] dwelling, cudweed, dweeb, indwell, midweek, bindweed, pondweed
[DWI] bandwidth, worldwide, goodwill, sandwich, woodwind, hardwired, dwindles
[DWO] redwood, hardworking, headword, groundwork, madwort, aardwolf, cordwood
[DWR] handwritten, handwriting
[DYA] dyadic, dyarchy, dyad, dyads, dyarchies
[DYB] ladybug, dybbuk, pandybat, bodyboard, bodybuilder, ladybugs, dybbukim
[DYC] bodycheck, bradycardia, bradycardias
[DYD] athodyd, athodyds
[DYE] dyer, midyear, dyes, dyeing, dyeline, dyewood, overdye
[DYF] candyfloss, ladyfinger, ladyfingers
[DYG] bodyguard, gobbledygook, bodyguards
[DYH] bawdyhouse, bawdyhouses
[DYI] dying, tidying, studying, embodying, undying, birdying, caddying
[DYL] cacodyl, condyle, idyll, ladylike, odyl, bandylegged, spondylitis
[DYM] handyman, neodymium, praseodymium, didymium, epididymis, tetradymite, didymous
[DYN] dynamic, dynode, dyne, anodyne, adynamia, aerodyne, didynamous
[DYS] dyspnea, odyssey, dystopi, dysuria, ecdyses, bodysuit, dysgenic
[DYT] adytum, candytuft, bradytelic, troglodyte, troglodytic, troglodytism, candytufts
[DYW] bodywork
[DZE] adze, adzes
[DZI] dziggetai, dziggetais
[DZO] dzo, dzos
[DZU] kudzu, kudzus
[EAB] writeable, enforceable, shareable, whereabouts, permeability, changeable, noticeable
[EAC] each, reached, deactivate, breach, teacher, unreachable, peace
[EAD] read, header, instead, thread, already, leading, spread
[EAE] cochleae, tracheae, unideaed, zoeae
[EAF] leaf, deaf, hereafter, interleaf, thereafter, overleaf, sheaf
[EAG] eager, eagle, lineage, mileage, seagull, beagle, league
[EAH] yeah, seahorse, obeahs, peahen, dahabeah, teahouse, enneahedron
[EAK] beak, break, freak, peak, speak, weak, leak
[EAL] deal, heal, meal, real, seal, ideal, areal
[EAM] stream, preamble, team, upstream, beam, steamy, scream
[EAN] mean, boolean, clean, euclidean, jean, lean, ocean
[EAP] heap, leap, cheap, reap, teapot, weapon, pineapple
[EAQ] seaquake, seaquakes
[EAR] linear, search, clear, year, appear, early, learn
[EAS] reason, least, measure, release, east, northeast, please
[EAT] create, feature, repeat, greater, treated, death, eat
[EAU] beau, bureau, plateau, tableau, eau, bandeau, ponceau
[EAV] heavy, leave, interleave, beaver, cleave, sleave, weave
[EAW] giveaway, seaweed, areaway, reawake, fleawort, hideaway, takeaway
[EAX] poleax, battleaxe, poleaxe, poleaxed, poleaxes, poleaxing, battleaxes
[EAZ] sleaze, sleazy, sleazily, sleazebag, sleazeball, sleaziness, sleazes
[EBA] sidebar, shebang, handlebars, baseball, debate, wastebasket, eyeballs
[EBB] ebb, webbed, pebble, plebby, nebbich, cobwebby, pebbly
[EBC] webcast, webcasting, webcam, webcams, webcasts
[EBD] hebdomad, hebdomadal, hebdomadary, hebdomads
[EBE] weber, iceberg, forebears, blueberries, grebe, xebec, prebend
[EBF] webfeet, webfoot
[EBI] rebind, debit, firebird, amoebic, ephebic, freebie, rarebit
[EBK] lebkuchen
[EBL] treble, weblog, feeble, pueblo, enfeeble, iceblink, boneblack
[EBM] webmaster, webmistress, webmasters
[EBO] notebook, somebody, whiteboard, reboot, placebo, phrasebook, skateboard
[EBP] webpage
[EBR] algebraic, zebra, eyebrow, rebroadcast, firebrick, tiebreaker, celebration
[EBS] website, ardebs, celebs, cubebs, dweebs, blebs, cobwebs
[EBT] debt, indebted, debtor, indebtedness, debtors, debts
[EBU] debug, rebuild, prebuilt, trebuchet, cheeseburger, nebula, firebug
[EBW] webworm, webworms
[EBY] hereby, thereby, whereby
[ECA] because, deprecated, recall, secant, decay, dodecahedron, cosecant
[ECB] ecbolic
[ECC] eccentricity, ecclesiastic, peccant, secco, breccia, eccrine, mecca
[ECD] anecdote, ecdyses, synecdoche, ecdysis, anecdotal, anecdotic, ecdysiasm
[ECE] received, necessary, piecewise, precedence, predecessor, unnecessary, decelerate
[ECH] echo, leech, speech, tech, mechanism, echelon, sech
[ECI] special, decimal, precision, recipient, reciprocal, hexadecimal, especially
[ECK] check, unchecked, bottleneck, neck, deck, heck, recheck
[ECL] declare, undeclared, eclipse, recline, preclude, eclectic, tablecloth
[ECO] second, decode, record, milliseconds, become, precomputed, bytecode
[ECP] ecphoneses, ecphonesis
[ECQ] becquerel, becquerels
[ECR] secret, decreasing, decrement, recreate, decrypted, firecracker, ecru
[ECS] specs, secs, execs, ecstasy, parsecs, tenrecs, pecs
[ECT] object, expected, protected, vector, project, section, direct
[ECU] execute, recursion, recurrence, security, consecutive, molecule, insecure
[ECY] recycling, secrecy, fleecy, prophecy, lecythus, secy, cholecyst
[ECZ] eczema, eczematous
[EDA] medal, impedance, redact, predates, cedar, pedal, someday
[EDB] feedback, speedboat, bedbug, redbud, seedbed, reedbird, biofeedback
[EDC] redcap, bedcover, seedcase, friedcake, bedchamber, bedclothes, redcoat
[EDD] embedded, reddish, teddy, eddy, wedding, meddle, cheddar
[EDE] needed, precedence, redefine, credentials, predecessor, exceeded, predefined
[EDF] redfin, bedfast, heedful, needful, stedfast, hundredfold, unheedful
[EDG] edge, knowledge, wedge, acknowledge, ledger, hedgehog, dredge
[EDH] bedhead, redhead, edh, bedheads, redheads, redheaded
[EDI] medium, predict, immediate, redistribute, edit, redirect, cedilla
[EDK] weedkiller, weedkillers
[EDL] repeatedly, unexpectedly, needle, seedling, admittedly, supposedly, medley
[EDM] freedman, bedmate, piedmont, embedment, bedmaker, freedmen, bedmakers
[EDN] handedness, tiredness, raggedness, boundedness, guardedness, redneck, fixedness
[EDO] freedom, redo, tuxedo, fedora, teredo, credo, torpedo
[EDP] bedpan, redpoll, seedpod, bedpost, bedplate, bedpans, bedposts
[EDR] redraw, dihedral, polyhedron, tetrahedron, octahedron, icosahedral, dodecahedron
[EDS] needs, speeds, exceeds, succeeds, seeds, reds, eds
[EDT] hundredth, redtop, bedtime, seedtime, hundredths, bedtimes, seedtimes
[EDU] reduce, procedure, scheduler, deduce, irreducible, speedup, education
[EDW] redwood, speedway, bedwarmer, bedwetting, freedwoman, redware, redwing
[EDY] greedy, remedy, speedy, comedy, reedy, tweedy, needy
[EEA] agreeable, foreseeable, disagreeable, agreeably, disagreeably
[EEB] freebase, feeble, dweeb, beebread, enfeeble, leeboard, feebly
[EEC] speech, beechen, breech, fleecy, leech, reecho, beseech
[EED] need, seed, speed, freedom, feed, agreed, guaranteed
[EEF] freeform, beef, reefer, gleeful, keef, threefold, beefalo
[EEG] greegree, squeegee, squeegeeing, greegrees, squeegeed, squeegees
[EEH] freehand, beehive, heehaw, kneehole, treehopper, coffeehouse, freehold
[EEI] seeing, freeing, guaranteeing, agreeing, disagreeing, geeing, peeing
[EEJ] deejay, veejay, deejays, veejays
[EEK] seek, peek, weekday, cheeks, geek, eek, creek
[EEL] wheel, freely, feel, kneeling, cartwheeling, steel, heel
[EEM] agreement, seems, deemed, freeman, preemptive, disagreement, esteem
[EEN] between, been, green, seen, screen, sheen, unseen
[EEP] keep, deep, sleep, sheep, sweep, steep, beep
[EEQ] reequip, reequips, reequipped, reequipping
[EER] peer, engineering, beer, leer, pioneers, steer, deer
[EES] degrees, trees, agrees, fees, guarantees, cheese, sees
[EET] sheet, worksheet, street, feet, meet, spreadsheet, greeting
[EEV] sleeve, reeves, beeves, steeve, weever, peeve, unreeve
[EEW] leeway, freeware, peewee, freewheel, peewit, freeway, leeward
[EEX] preexisting, reexport, preexpose, reexhibit, preexamine, reexchange, reexamine
[EEZ] breeze, freeze, sneeze, squeeze, wheeze, deepfreeze, unfreeze
[EFA] default, typeface, preface, refactor, nefarious, putrefaction, befall
[EFB] beefburger, beefburgers
[EFC] briefcase, beefcake, beefcakes, briefcases
[EFD] fiefdom, chiefdom, fiefdoms
[EFE] reference, prefer, deferred, referring, defective, defensive, linefeed
[EFF] effect, coefficients, effort, efficient, inefficient, ineffective, efface
[EFI] define, prefix, undefined, refine, redefine, indefinite, predefined
[EFL] reflect, deflate, briefly, preflight, chiefly, firefly, horsefly
[EFN] briefness
[EFO] before, therefore, reformed, waveforms, freeform, henceforth, deform
[EFR] refresh, defrost, wavefront, grapefruit, therefrom, befriend, carefree
[EFS] refs, xrefs, briefs, beliefs, clefs, beefsteak, chiefs
[EFT] left, copyleft, cleft, deft, heft, eft, bereft
[EFU] useful, careful, hopefully, refused, gracefully, defused, purposefully
[EFW] beefwood, beefwoods
[EFY] defy, casefy, rarefy, tepefy, tumefy, beefy, liquefy
[EGA] negative, legacy, omega, nonnegative, regard, illegal, delegate
[EGB] pegboard, pegboards
[EGE] integer, regex, legend, degenerate, privileges, college, alleged
[EGF] segfault, segfaults
[EGG] beggar, egg, legged, arpeggio, dreggy, pegged, reggae
[EGH] leghorn, leghorns
[EGI] begin, register, strategies, regional, alleging, legitimate, unregistered
[EGL] negligence, negligible, neglected, eyeglasses, wineglass, kegler, reglet
[EGM] segment, smegma, subsegment, bregma, legman, phlegm, tegmen
[EGN] segno, pregnant, regnal, thegn, impregnate, interregnal, nonpregnant
[EGO] category, ego, foregoing, negotiate, begone, prolegomena, renegotiate
[EGR] degree, integral, regression, foreground, telegraph, negro, segregate
[EGS] legs, begs, megs, dregs, sheerlegs, kriegspiel, yellowlegs
[EGU] regular, irregular, begun, safeguard, bubblegum, wiseguys, degust
[EGW] legwork, legwarmer, legwarmers
[EGY] strategy, elegy, junglegym, panegyric, bibliopegy, panegyrist, panegyrize
[EHA] behavior, beforehand, rehash, freehand, misbehave, sledgehammer, heehaw
[EHE] forehead, comprehend, apprehension, whitehead, figurehead, rehearse, behead
[EHI] behind, vehicle, beehive, prehistory, dehisce, molehill, rehi
[EHL] gehlenite
[EHN] foehn, foehns
[EHO] placeholder, somehow, household, warehouse, beholder, hedgehog, racehorse
[EHR] fuehrer, lehr, fuehrers
[EHU] rehung, jehu, prehuman, househusband, dehumanize, dehumidify, prehumans
[EHY] aldehyde, rehydrate, dehydrator, dehypnotize, paraldehyde, acetaldehyde, benzaldehyde
[EIA] pleiad, buddleia, plebeian, mythopoeia, peripeteia, onomatopoeia, prosopopoeia
[EIB] ceiba
[EIC] nucleic, deicer, oleic, seicento, diarrheic, mythopeic, apodeictic
[EID] eide, dreidl, eidola, nereid, tineid, ureide, clupeid
[EIE] lammergeier, lammergeiers
[EIF] cuneiform, reified, deific, heifer, galeiform, calceiform, proteiform
[EIG] beige, eight, freight, neighbor, weigh, height, eigenvalues
[EIK] sheikh, eikon, aniseikonia, sheikhs, sheikdom, sheikdoms, aniseikonias
[EIL] ceiling, veil, abseil, surveillance, unveil, nonpareil, sheila
[EIM] reimport, isocheim, reimburse, wisenheimer, reimporting, reimpress, reimprison
[EIN] being, herein, reinstall, seeing, protein, therein, reinitialize
[EIO] meioses, deionize, gorgoneion, semeiology, meiosis, meiotic, meiotically
[EIP] receipt, nonreceipt, receipts, receiptor, receipted, receipting
[EIR] their, weird, heirs, cruzeiro, oneiric, coheir, eirenic
[EIS] theism, atheism, moreish, seismic, reissue, leis, blueish
[EIT] either, neither, homogeneity, albeit, forfeit, reiterate, meitnerium
[EIV] received, perceived, conceivable, deceive, reive, undeceive, apperceive
[EIZ] seize, disseize, marbleize, seized, seizer, seizes, seizure
[EJA] deejay, sejant, veejay, applejack, ejaculate, bluejacket, supplejack
[EJE] reject, eject, deject, bejewel, bluejeans, rejected, rejects
[EJI] rejigs, rejig, rejigged, rejigger, rejiggers, rejigging, rejiggered
[EJO] rejoin, aparejo, pejoration, surrejoinder, rejoinder, rejoins, rejoined
[EJU] prejudicial, unprejudiced, jejuna, forejudge, rejuvenate, prejudgment, smokejumper
[EKA] weka, peekaboo, eureka, pekan, dekagram, dekaliter, dekameter
[EKB] cheekbone, cheekbones
[EKD] weekday, weekdays
[EKE] weekend, housekeeping, peeked, safekeeping, seeker, shekel, peke
[EKH] samekh, samekhs
[EKI] seeking, peeking, rekindling, dovekie, ramekin, sleekit, baudekin
[EKK] dekko, trekked, trekker, trekking, dekkos, trekkers
[EKL] weekly, biweekly, triweekly, newsweekly, semiweekly, kaffeeklatch, meekly
[EKN] reknit, foreknew, meekness, sleekness, weeknight, unbeknownst, foreknow
[EKO] pekoe
[EKP] cheekpiece, cheekpieces
[EKS] weeks, seeks, cheeks, peeks, reeks, breeks, creeks
[EKT] nekton, tektite, nektons, tektites
[EKY] cheeky, geeky, reeky
[ELA] relax, delay, correlation, elapsed, elastic, unrelated, elaborations
[ELB] elbow, kielbasa, keelboat, camelback, wheelbase, panelboard, shovelboard
[ELC] wheelchair, welcome, unwelcome, belched, squelched, gelcap, colonelcy
[ELD] field, yield, held, shield, weld, subfield, seldom
[ELE] element, select, release, delete, labeled, electron, skeleton
[ELF] self, itself, elf, yourself, myself, himself, ourself
[ELG] belga, eelgrass, feelgood, kieselguhr, doppelganger, eelgrasses, kieselguhrs
[ELH] pelham, keelhaul, camelhair, steelhead, barrelhead, flugelhorn, shovelhead
[ELI] baseline, pipeline, delimiter, likelihood, eliminate, relies, labeling
[ELK] elk, welkin, whelk, gavelkind, elks, elkhound, whelks
[ELL] cell, ellipse, shell, well, yellow, hello, sell
[ELM] elm, helmet, overwhelm, pelmet, unhelm, whelm, abelmosk
[ELN] telnet, hazelnut, cruelness, levelness, shovelnose, genteelness, hazelnuts
[ELO] below, envelope, velocity, developer, reload, echelon, melon
[ELP] help, mantelpiece, unhelpful, whelp, delphinium, kelpie, eelpout
[ELR] jewelry, revelry, hostelry, jewelries, revelries, hostelries
[ELS] else, labels, levels, models, pixels, channels, kernels
[ELT] delta, celt, melt, novelty, belt, felt, cruelty
[ELU] prelude, deluxe, beluga, obelus, reluctance, elucidate, velure
[ELV] themselves, kelvin, twelve, ourselves, shelve, selves, velvet
[ELW] wheelwright, eelworm, edelweiss, jewelweed, navelwort, steelwork, crewelwork
[ELY] immediately, likely, freely, completely, separately, recursively, respectively
[EMA] mathematical, schema, email, remainder, trademark, demand, female
[EMB] member, embedded, ensemble, remember, assemble, nonmember, disassemble
[EMC] emcee, emceeing, emceed, emcees
[EMD] fremd
[EME] element, enhancement, scheme, statement, implemented, theme, agreement
[EMF] emf, emfs
[EMI] itemize, emit, semi, academic, chemical, alchemical, remix
[EML] gremlin, seemly, hemline, kremlin, stemless, unseemly, hemlock
[EMM] lemma, gemma, stemming, dilemma, femme, chemmy, hemmed
[EMN] indemnify, remnant, lemniscate, solemnly, condemnable, contemn, belemnite
[EMO] remove, memory, emoji, demo, daemon, emotion, mnemonic
[EMP] empty, exempt, hemp, temper, attempt, emphasis, empirical
[EMS] items, systems, problems, themselves, seems, theorems, stems
[EMT] femtosecond, femtoseconds
[EMU] emu, remuneration, bemuse, demure, femur, lemur, chemurgy
[EMV] decemvir, decemvirate
[EMW] stemware, stemwinder
[EMY] academy, enemy, demy, alchemy, frenemy, polysemy, archenemy
[ENA] filename, enable, penalty, rename, maintenance, concatenate, codename
[ENB] henbit, ovenbird, steenbok, greenback, boysenberry, henbane, greenbelt
[ENC] sequence, reference, encoding, frequency, difference, french, benchmark
[END] end, append, extend, legend, render, send, independent
[ENE] general, energy, opened, listener, homogeneous, flattened, renew
[ENF] enforce, greenfield, enface, enfeoff, menfolk, tenfold, enfilade
[ENG] length, engine, english, strength, challenge, engraver, wavelength
[ENH] enhancement, senhor, greenheart, menhir, henhouse, alpenhorn, penholder
[ENI] phoenix, opening, convenience, denied, shortening, genie, lenient
[ENJ] benjamin, enjoin, basenji, enjambment, katzenjammer, unenjoyable, enjoy
[ENK] enkindle, penknife, womenkind, penknives, enkindled, enkindles, enkindling
[ENL] greenlet, enlarge, evenly, mistakenly, penlight, suddenly, unevenly
[ENM] enmesh, enmity, penman, greenmail, mizenmast, sixteenmo, eighteenmo
[ENN] antenna, sienna, tennis, fennel, penname, pfennig, evenness
[ENO] enough, denom, phenomena, solenoidal, menorah, exogenous, endogenous
[ENP] davenport, screenplay, tenpin, enplane, henpeck, ovenproof, chickenpox
[ENQ] enqueue, enqueued, enqueues, enquirer, enquiringly, enquirers
[ENR] henry, goldenrod, enrich, genre, enraged, enrobe, tenrec
[ENS] license, extension, ensure, tensor, tokens, dense, dimension
[ENT] current, element, center, parent, comment, content, entry
[ENU] menu, enumerate, renumber, attenuator, genuine, venue, revenue
[ENV] environment, envelope, eigenvalues, eigenvectors, envoy, envisage, envy
[ENW] greenwood, enwind, enwomb, enwrap, openwork, ovenware, treenware
[ENY] deny, greeny, progeny, teeny, phenyl, weeny, sheeny
[ENZ] benzene, cadenza, frenzy, influenza, enzyme, coenzyme, credenza
[EOB] osteoblast, stereobate, paleobotany, paleobiology, osteoblasts
[EOC] neoclassical, geocentric, reoccurred, geocache, teocalli, theocrat, neocortex
[EOD] geodesic, neodymium, praseodymium, deodar, creodont, theodicy, videodisc
[EOE] paleoecology, videoed
[EOF] thereof, hereof, takeoff, enfeoff, feoff, whereof, griseofulvin
[EOG] ideograph, geographic, stereogram, biogeography, geognosy, theogony, oleograph
[EOH] eohippus, eohippuses
[EOI] bourgeois, geoid, osteoid, clupeoid, scarabaeoid, stereoisomer, videoing
[EOL] archaeology, theology, alveolar, creoles, aeolian, aureolin, flageolet
[EOM] geometry, caeoma, cleome, yeoman, osteoma, geomancy, neomycin
[EON] someone, neon, thereon, chameleon, leone, surgeon, eon
[EOP] leopard, people, reopen, geophysics, jeopardize, pleopod, geoponic
[EOR] theory, reorder, meteor, ceorl, georama, embraceor, oleoresin
[EOS] videos, eosin, caseose, creosol, speos, teleost, proteose
[EOT] nucleotide, videotape, geothermal, stereotypes, leotard, neoteny, geotaxis
[EOU] timeout, closeout, homogeneous, erroneous, strikeout, extraneous, simultaneous
[EOV] moreover, makeover, takeover, voiceover, changeover, antitakeover, makeovers
[EOW] meow, preowned, homeowner, meowed, meowing, meows, homeowners
[EOX] deoxygenate, deoxyribose, deoxidize, deoxidized, deoxidizes, deoxidizing, deoxyriboses
[EOZ] paleozoology
[EPA] prepare, separate, homepage, repair, department, discrepancy, epact
[EPB] peepbo, sweepback, stepbrother, stepbrothers
[EPC] hepcat, sheepcote, stepchild, stepchildren, sheepcotes
[EPD] stepdad, sheepdog, stepdame, stepdaughter, stepdads, sheepdogs
[EPE] repeat, independent, dependency, prepend, deeper, steepest, keeper
[EPF] deepfreeze, deepfrozen, skepful, sheepfold, stepfather, deepfakes, deepfake
[EPH] elephant, nephew, shepherd, ephemeral, aleph, telephone, zephyr
[EPI] keeping, epigraph, epilogue, sleeping, epic, bookkeeping, depicted
[EPL] replace, depletion, deployment, deeply, steeple, peplos, preplan
[EPM] stepmom, stepmother, stepmoms, stepmothers
[EPN] steepness, deepness
[EPO] report, epoch, epos, teleport, preposition, deposit, horsepower
[EPP] stepper, pepper, grepped, hepper, preppy, seppuku, repp
[EPR] deprecated, preprocessed, represent, reproduce, blueprint, reprocess, depreciated
[EPS] steps, epsilon, keeps, reps, peps, biceps, yeps
[EPT] except, depth, accept, intercept, concept, kept, apperception
[EPU] reputation, republic, repulsion, deputy, repudiate, peepul, cajeput
[EPW] stepwise, sheepwalk, sleepwalk, sleepwear, sleepwalker, sleepwalking, sheepwalks
[EPY] sleepy, creepy, cacoepy, weepy, orthoepy, sleepyhead, sleepyheads
[EQA] sheqalim
[EQE] sheqel
[EQQ] seqq
[EQU] equal, equip, sequel, request, frequency, subsequent, infrequent
[ERA] general, operator, literal, iterable, enumerate, average, tolerance
[ERB] verbose, hyperbolic, checkerboard, adverb, herb, erbium, reverb
[ERC] intercept, percent, exercise, lowercase, uppercase, commercial, coerce
[ERD] verdict, nerd, yesterday, overdue, quarterdeck, perdu, halberd
[ERE] there, where, here, reference, were, different, ordered
[ERF] performance, interface, overflow, underflow, powerful, perfectly, butterfly
[ERG] merge, energy, convergence, divergence, erg, iceberg, berg
[ERH] perhaps, overhead, letterhead, superhero, underhanded, afterheat, deerhound
[ERI] series, numeric, period, generic, derivative, verify, material
[ERJ] lumberjack, interjects, overjoy, perjure, serjeant, verjuice, amberjack
[ERK] berk, gherkin, perky, overkill, berserker, erk, clerk
[ERL] overload, underline, hyperlink, properly, berlin, formerly, interleave
[ERM] terms, permission, determine, permitted, permutation, german, hermitian
[ERN] kernel, pattern, external, internal, alternative, modern, eastern
[ERO] zero, nonzero, hieroglyph, erosion, libero, meromorphic, deuteron
[ERP] interpolate, interpreter, perpetual, boilerplate, perplexity, fingerprint, overprint
[ERQ] perquisite, underquote, perquisites, underquoted, underquotes, underquoting
[ERR] error, override, interruption, deferred, inferred, preferred, referred
[ERS] version, parameters, person, inverse, reverse, headers, numbers
[ERT] assert, property, insert, convert, vertical, invert, certain
[ERU] rerun, cerulean, serum, overuse, superuser, peruse, eruption
[ERV] interval, reserved, server, observed, preserve, overview, conservative
[ERW] otherwise, overwrite, afterwards, overweight, underwood, interweave, jabberwocky
[ERY] every, query, very, battery, gallery, discovery, machinery
[ERZ] scherzo, terzetto, overzealous, scherzando, scherzos, terzettos
[ESA] resample, mesa, courtesan, sesame, wholesale, sprechgesang, cesar
[ESB] blesbok, lesbian, presbyter, lesbianism, presbyopia, presbyopic, presbytery
[ESC] description, escape, descending, rescale, describing, coalesce, crescent
[ESD] domesday, mesdames, eavesdrop, eavesdropped, eavesdropper, eavesdrops
[ESE] these, reserved, present, typeset, represent, parentheses, research
[ESF] tradesfolk
[ESG] salesgirl, salesgirls
[ESH] reshape, threshold, mesh, refresh, fresh, slideshow, afresh
[ESI] desired, thesis, residual, resistor, diaeresis, hypothesis, parenthesis
[ESK] desktop, pesky, weskit, doeskin, esker, capeskin, copydesk
[ESL] tesla, muesli, coleslaw, sideslip, beslobber, saleslady, preslavery
[ESM] salesman, desman, besmear, bedesman, bluesman, dalesman, gamesmen
[ESN] fresnel, demesne, mesne, resnatron, rattlesnake, mesnalty, demesnes
[ESO] resource, resolution, meson, resolvent, awesome, esoteric, peso
[ESP] response, whitespace, corresponds, respectively, especially, despite, irrespective
[ESQ] burlesque, esquire, mesquite, arabesque, grotesque, desquamate, humoresque
[ESR] salesroom, salesrooms
[ESS] message, process, unless, express, fitness, less, access
[EST] test, estimator, northwest, request, forest, best, west
[ESU] result, presumably, caesura, presumption, nonesuch, gesundheit, presupposed
[ESW] minesweeper, beeswax, aloeswood, sideswipe, saleswoman, spokeswoman, stateswoman
[ESY] courtesy, geodesy, bluesy, cheesy, cutesy, heresy, poesy
[ETA] meta, detail, theta, beta, retain, zeta, eta
[ETB] basketball, setbacks, netball, wetback, carpetbag, packetboat, pocketbook
[ETC] etc, fetch, stretch, sketch, fletcher, bletch, wretch
[ETD] letdown, retd, letdowns
[ETE] parameters, complete, delete, determine, detected, discrete, interpreter
[ETF] forgetful, fretful, basketful, bucketful, metformin, pocketful, regretful
[ETH] method, whether, something, together, altogether, beth, stethoscope
[ETI] arithmetic, alphabetic, sometimes, deletion, completion, repetition, magnetic
[ETK] pocketknife, wicketkeeper, pocketknives
[ETL] beetle, quietly, secretly, fetlock, wetland, jetliner, sheetlike
[ETM] hetman, abetment, revetment, sweetmeat, cabinetmaker, abetments, revetments
[ETN] etna, wetness, quietness, fleetness, sweetness, discreetness, etnas
[ETO] singleton, skeleton, magneton, thereto, hereto, treetop, proprietor
[ETP] marketplace, jetport, bulletproof, jetports, bulletproofs, marketplaces
[ETR] geometry, parametrize, metric, symmetric, retry, asymmetric, photometric
[ETS] sets, offsets, targets, datasets, gets, widgets, brackets
[ETT] letter, setting, better, pretty, palette, getting, typesetting
[ETU] return, setup, perpetual, etudes, meetup, impetus, quietus
[ETW] between, network, retweets, wetware, fretwork, basketwork, streetwise
[ETY] safety, society, variety, ninety, entirety, teletype, archetype
[ETZ] pretzel, quetzal, spaetzle, pretzels, quetzals
[EUA] feuar
[EUC] euclidean, leucine, eucalyptus, isoleucine, euchre, deuce, eucaine
[EUD] pseudo, feudal, eudemon, eudiometer, infeudation, subinfeudate, pseudonym
[EUE] queue, enqueue, dequeue, banlieue, queues, queued, enqueued
[EUG] zeugma, eugenics, sheugh, euglena, hypozeugma, eugenic, eugenol
[EUH] euhemerism, euhemerize
[EUI] queuing, fauteuil, feuilleton, fauteuils
[EUK] leukemia, eukaryote, leukocyte, leukoderma, leukorrhea, interleukin, leukemic
[EUL] eulogy, eulachon, heulandite, eulogia, eulogist, eulogium, eulogize
[EUM] neume, petroleum, museum, pneumonia, lyceum, pileum, rheumy
[EUN] hereunder, reunion, eunuch, exeunt, thereunto, transeunt, whereunto
[EUO] euonymus
[EUP] writeup, whereupon, lineup, makeup, closeup, euphoria, hereupon
[EUR] euro, heuristic, hauteur, neural, longueur, fleuron, auteur
[EUS] reuse, nucleus, chartreuse, caduceus, scarabaeus, aureus, cereus
[EUT] neutral, deuteron, sleuth, kreutzer, antineutrino, lieutenant, eutectic
[EUV] oeuvre, maneuver, outmaneuver, oeuvres, maneuvers, maneuvered, maneuvering
[EUX] euxenite, purlieux, religieux, hypozeuxis
[EVA] evaluate, relevant, deva, unevaluated, irrelevant, elevation, retrieval
[EVE] level, event, every, however, reverse, never, prevent
[EVI] device, previous, revision, abbreviation, levin, evidence, evil
[EVN] czarevna, tsarevna
[EVO] devote, evoke, evolve, revolt, irrevocable, elevon, rilievo
[EVR] chevron, chevre, chevrette, chevrotain, chevres, chevrons, chevrotains
[EVS] abbrevs, revs
[EVU] nevus, naevus, revue, evulsion, levulose, revulsion, revulsive
[EVV] revved, bevvy, revving, bevvies
[EVY] levy, chevy, replevy, bevy, levying, chevying
[EVZ] evzone
[EWA] beware, steward, sideways, firewall, leeway, gateway, prewarm
[EWB] newborn, dewberry, skewback, screwball, newbie, skewbald, newbies
[EWC] newcomers, dewclaw, newcomer, dewclaws
[EWD] screwdriver, shrewd, dewdrop, lewd, lewdness, shrewdness, lewder
[EWE] brewer, viewer, fewer, newer, skewed, reviewer, renewed
[EWF] newfangled, jewfish, newfound, viewfinder, newfashioned, viewfinders
[EWG] gewgaw, gewgaws
[EWH] elsewhere, somewhat, freewheel, erewhile, brewhouse, horsewhip, nosewheel
[EWI] piecewise, rewind, lewis, likewise, viewing, sidewinder, sewing
[EWL] newline, dewlap, mewl, thewless, viewless, newlines, newly
[EWM] crewman, shrewmice, aircrewman, brewmaster, crewmen, crewmate, shrewmouse
[EWN] skewness, strewn, fewness, newness, shewn, bestrewn, sewn
[EWO] framework, homework, reworked, foreword, coursework, codewords, fireworks
[EWP] viewpoint, brewpub, stewpan, brewpubs, stewpans, viewpoints
[EWR] rewrite, typewriter, bewray, homewrecker, rewritten, rewrites, rewriting
[EWS] views, news, reviews, screws, skews, previews, overviews
[EWT] newton, kilonewton, pewter, strewth, newtons, newt, kilonewtons
[EWW] screwworm, screwworms
[EWY] chewy, dewy, sinewy, viewy, screwy, mildewy, thewy
[EXA] example, exact, inexact, hexadecimal, hexagram, exaggeration, hexahedron
[EXC] except, exclude, exch, excuse, excitation, nonexclusive, excitement
[EXD] sexdecillion, flexdollars
[EXE] execute, indexer, lexer, exercise, exemplary, complexes, multiplexer
[EXF] exfoliant, exfoliate, exfoliator, exfoliated, exfoliates, exfoliating, exfoliation
[EXH] exhale, exhibit, exhume, exhort, reexhibit, exhaust, exhilarate
[EXI] exist, exit, indexing, lexical, flexible, complexity, nonexistent
[EXL] sexless, convexly, reflexly, complexly, sexlessness, sexlessly
[EXN] complexness
[EXO] exotic, exogenous, hexose, exon, exorbitant, exodus, flexor
[EXP] exp, unexpanded, unexpected, regexp, inexpensive, unexposed, reexport
[EXQ] exquisite, exquisitely
[EXR] exr
[EXS] exsect, exscind, exsiccate, exsanguine, exstipulate, exsert, exsanguinate
[EXT] text, next, extra, extension, context, external, extending
[EXU] plexus, nexus, asexual, exudate, exult, exurb, exuviae
[EXY] prexy, hexyl, apoplexy, cataplexy
[EYA] graveyard, conveyance, abeyant, boneyard, cattleya, eyas, foreyard
[EYB] keyboard, honeybee, moneybag, trolleybus, volleyball, keybindings, greyback
[EYC] honeycomb, keycard, barleycorn, moneychanger, honeycombs, barleycorns, honeycombed
[EYD] honeydew, heyday, fogeydom, heydays, honeydews
[EYE] eye, keyed, conveyed, fisheye, bullseye, obeyed, surveyed
[EYF] cockneyfy
[EYH] greyhen, keyhole, greyhound, keyholes, greyhounds
[EYI] conveying, obeying, surveying, keying, fogeyish, phoneying, cockneyism
[EYL] greylag, moneyless, honeylocust, feyly, moneylender, greylags, moneylenders
[EYM] bogeyman, boogeyman, honeymoon, journeyman, kerseymere, moneymaker, bogeymen
[EYN] keynote, poleyn, homeyness, greynesses, feyness, keynoter, keynoted
[EYO] beyond, surveyor, conveyor, peyote, eyot, purveyor, surveyors
[EYP] keypad, honeypot, monkeypot, chimneypiece, keypunch, keypuncher, keypads
[EYR] keyring, eyrir, eyra, eyre, eyras
[EYS] keys, smileys, attorneys, obeys, surveys, conveys, alleys
[EYW] keyword, alleyway, greywacke, moneywort, journeywork, keywords, keyway
[EZA] squeezable, bezant, guereza, freezable, bezants, guerezas
[EZC] mezcaline, mezcal
[EZE] squeeze, freeze, breeze, deepfreeze, unfreeze, frieze, sneeze
[EZI] trapezium, freezing, sneezing, squeezing, bezique, breezily, wheezily
[EZO] timezone, trapezoid, rezone, bezoar, cabezon, timezones, trapezoidal
[EZU] mezuza, mezuzah, mezuzot, mezuzoth
[EZV] rendezvous, rendezvoused, rendezvouses
[EZY] breezy, wheezy
[EZZ] fezzes, mezzanine, muezzin, prezzie, embezzle, mezzotint, intermezzi
[FAB] fab, prefab, confab, affable, effable, ineffably, fabricant
[FAC] factor, face, interface, facing, surface, artifact, typeface
[FAD] fade, fading, faddy, fadge, fado, intifada, unfading
[FAE] faerie, faena, faeries
[FAF] faff, faffed, faffing, faffs
[FAG] fagged, fagot, leafage, serfage, wharfage, fagaceous, fagging
[FAH] loofah, terefah, fahlband, loofahs
[FAI] fail, fair, unfair, faith, faint, affairs, faience
[FAJ] fajita, fajitas
[FAK] fake, faking, deepfake, faker, faked, fakes, fakery
[FAL] false, fallback, falcon, buffalo, falafel, pitfall, downfall
[FAM] family, subfamily, famous, fame, unfamiliar, defame, infamy
[FAN] fancy, fantasy, fang, fans, infantry, fandom, fanning
[FAQ] faquir, faqir, faqirs, faquirs
[FAR] far, sofar, safari, warfare, welfare, insofar, afar
[FAS] fast, fashion, fascicules, breakfast, fascinating, bedfast, sunfast
[FAT] fatal, father, nonfatal, fate, fatigue, fatter, prefatory
[FAU] default, segfault, fault, faux, fauna, faucal, faugh
[FAV] favor, unfavorable, favus, fave, disfavor, favorite, favors
[FAW] fawn, guffaw, fawner, fawning, fawned, fawners, fawns
[FAX] fax, faxing, faxes, faxed
[FAY] fay, ofay, fayalite, fayest, fayer, fays
[FAZ] fazed, fazing, unfazed, faze, fazes
[FBA] goofball, halfback, puffball, goofballs, halfbacks, puffballs
[FBE] offbeat, halfbeak, hoofbeat, offbeats, halfbeaks
[FBI] surfbird, surfbirds
[FBO] snuffbox, surfboat, hoofbound, surfboard, surfboats, snuffboxes, surfboards
[FBR] halfbreed
[FBU] beefburger, beefburgers
[FCA] briefcase, beefcake, beefcakes, briefcases
[FCH] chiffchaff
[FCO] halfcocked
[FCU] offcuts
[FDO] fiefdom, serfdom, chiefdom, fiefdoms
[FEA] feature, feasible, infeasible, fear, defeat, unfeasible, misfeature
[FEB] febrile, afebrile, lifebelt, antifebrile, febrific, lifeboat, lifebuoy
[FEC] effect, affect, perfect, defects, fec, unaffected, ineffective
[FED] fed, stuffed, sniffed, unfed, diffed, serifed, breastfed
[FEE] fee, coffee, linefeed, toffee, feoffee, webfeet, clubfeet
[FEF] lifeforms
[FEG] safeguard, lifeguard, solfeggio, safeguards, safeguarded, lifeguards, safeguarding
[FEH] wifehood
[FEI] forfeit, feint, feisty, feign, surfeit, caffeine, counterfeit
[FEK] safekeeping
[FEL] safely, feline, fell, falafel, felt, duffel, unsafely
[FEM] female, feminine, femme, femtosecond, femoral, femur, feme
[FEN] fenced, defend, offending, fennel, pfennig, fend, fenestra
[FEO] enfeoff, feoff, feoffee, feoffs
[FER] buffer, reference, different, infer, prefer, transfer, offer
[FES] manifest, confess, professor, lifespan, fest, safest, fess
[FET] fetch, safety, lifetime, confetti, buffet, cafeteria, fetter
[FEU] feu, coiffeur, chauffeur, infeudation, subinfeudate, feudal, feuar
[FEV] fever, feverfew, feverish, feverous, feverroot, feverwort, feverishness
[FEW] few, curfew, feverfew, lifework, fewer, fewest, fewness
[FEX] pontifex, spinifex
[FEY] fey, feyly, feyness
[FEZ] fez, fezzes
[FFA] buffalo, affairs, efface, guffaw, luffa, offal, bouffant
[FFB] offbeat, puffball, snuffbox, offbeats, puffballs, snuffboxes
[FFC] offcuts, chiffchaff
[FFE] buffer, different, effect, affect, coffee, offer, unaffected
[FFH] offhand, cliffhanger, offhanded, cliffhanging, offhandedly, cliffhangers
[FFI] suffix, coefficients, affine, coffin, office, efficient, difficult
[FFK] offkey
[FFL] baffle, muffle, raffle, shuffle, waffle, offline, riffle
[FFM] staffman
[FFN] stiffness, bluffness, gruffness
[FFO] effort, scaffold, afford, buffoon, daffodil, boffo, chiffon
[FFP] offprint, offprints
[FFR] diffraction, saffron, taffrail, affricates, riffraff, suffrage, staffroom
[FFS] offset, diffs, cutoffs, payoffs, puffs, cliffs, duffs
[FFT] clifftop, offtrack, clifftops
[FFU] diffusion, effuse, suffuse, affusion, coiffure, diffusers, diffuse
[FFY] fluffy, jiffy, iffy, spiffy, chaffy, chuffy, cliffy
[FGA] roofgarden
[FGH] afghani, afghan, afghans, afghanis
[FHA] offhand, cliffhanger, offhanded, cliffhanging, offhandedly, cliffhangers
[FHE] selfheal, halfhearted
[FHO] selfhood, wolfhound, leafhopper, wolfhounds, leafhoppers
[FIA] satisfiable, modifiable, unverifiable, identifiable, fiat, verifiable, specifiable
[FIB] fiber, fibbed, fibril, fibula, fibster, microfiber, defibrillate
[FIC] specific, modification, coefficients, office, efficient, scientific, certificate
[FID] confidence, fid, bifid, disulfide, perfidy, affidavits, trifid
[FIE] field, modified, specified, identifier, classifier, simplified, unmodified
[FIF] fifth, fifer, fifty, fifteen, fifths, fiftieth, fifteenth
[FIG] figure, configure, figs, firefighter, transfigure, reconfigure, fight
[FIL] file, fill, filter, profile, affiliates, backfill, filament
[FIM] fimble, fimbria, fimbriate, fimbriation
[FIN] define, find, undefined, finite, final, infinity, affine
[FIO] fiorin, mafiosi, mafioso, fioritura
[FIP] fipple, fipples
[FIR] first, affirmer, confirm, fired, firm, spitfire, gunfire
[FIS] fisher, fist, blowfish, fiscal, fission, catfish, selfish
[FIT] fit, profits, refit, benefit, unfitted, graffiti, misfit
[FIV] five, spoilfive, fiver, fives, fivefold, fivepenny, fivers
[FIX] prefix, suffix, fixed, fixture, affix, postfix, infix
[FIY] rufiyaa, kaffiyeh, keffiyeh
[FIZ] fizz, fizgig, hafiz, fizzed, fizzle, fizzles, fizzy
[FJE] fjeld
[FJO] fjord, fjords
[FKE] offkey
[FLA] flag, flat, flavor, deflate, flask, inflate, flap
[FLE] shuffle, circumflex, reflect, flex, deflection, retroflex, fletcher
[FLI] flick, flight, fling, flip, conflict, offline, shuffling
[FLO] float, flow, floor, overflow, floc, underflow, floruit
[FLU] flush, influence, fluid, flux, flute, superfluous, confluent
[FLY] flyweight, flying, butterfly, briefly, flyback, dragonfly, chiefly
[FMA] turfman, staffman
[FME] engulfment
[FNE] stiffness, briefness, deafness, aloofness, bluffness, gruffness, selfness
[FNI] hafnium
[FOA] foam, foal, styrofoam, foaming, foamy, foaminess, foamflower
[FOB] fobbed, fobs, fobbing, fob
[FOC] focus, focal, confocal, bifocal, epifocal, trifocal, suffocate
[FOD] daffodil, fodder, eisteddfod, cannonfodder, daffodils, fodders, eisteddfods
[FOE] foe, foeman, foemen, foehn, foehns, foes
[FOG] fog, befog, defogger, pettifog, foggy, fogbow, fogdog
[FOI] foils, hydrofoil, foible, foison, airfoil, tinfoil, trefoil
[FOL] following, fold, manifold, folio, folklore, portfolio, unfold
[FOM] foment, infomercial, fomentation, foments, fomented, fomenter, fomenters
[FON] font, fond, chiffon, griffon, plafond, overfond, sinfonia
[FOO] foo, bigfoot, tomfoolery, buffoon, forefoot, befool, afoot
[FOP] fop, foppery, foppish, foppishness, fops, foppishly
[FOR] for, before, transform, platform, information, performance, uniform
[FOS] foster, fosse, fostering, fossil, fossa, fossick, fossette
[FOT] fylfot, infotainment
[FOU] found, four, confounded, fouling, profound, rufous, afoul
[FOV] fovea, foveola, foveas
[FOW] fowl, batfowl, peafowl, moorfowl, wildfowl, waterfowl, fowled
[FOX] fox, outfox, foxtrot, foxily, foxfire, foxhole, foxhunt
[FOY] foyer, foyers
[FPE] halfpence, surfperch, halfpenny, halfpennies
[FPR] offprint, offprints
[FRA] frame, fraction, fragment, franklin, wolfram, refractive, infra
[FRE] free, freq, french, refresh, infrequent, fresh, fret
[FRI] infringement, friendly, fringe, friction, frisk, frills, fright
[FRO] from, frozen, front, frowning, defrost, frog, froufrou
[FRU] fruit, kiwifruit, grapefruit, frustrating, fructose, unfruitful, frugal
[FRY] fry, belfry, refry, gallimaufry, fryer, fryers, frying
[FSA] selfsame
[FSB] wolfsbane, wolfsbanes
[FSE] offset, offsets, offsetting
[FSH] offshore, offshoot, offshoots, offshoring
[FSI] offside, offsite, offsides
[FSK] calfskin, scarfskin
[FST] offstage, beefsteak, leafstalk, offstages, beefsteaks, leafstalks
[FTA] liftable, caftan, softa, waftage, driftage, chieftain, chieftaincy
[FTB] softball, softback, softbound, softballs
[FTC] softcover
[FTE] after, often, shifted, sifted, hereafter, lifter, drafter
[FTH] fifth, twelfth, tufthunter, softhearted, fifths, twelfths, fifthly
[FTI] lifting, shifting, drafting, sifting, drifting, fiftieth, loftier
[FTL] shiftless, daftly, swiftlet, thriftless, deftly, softly, swiftly
[FTM] leftmost, aftmost, aircraftman, aircraftmen
[FTN] softness, daftness, deftness, driftnet, swiftness, driftnets
[FTO] leftover, halftone, liftoff, clifftop, rooftop, halftones, leftovers
[FTP] ftpers, ftping
[FTR] offtrack, rooftree, halftrack, rooftrees
[FTS] shifts, lefts, drafts, lifts, shafts, gifts, sifts
[FTT] ofttimes
[FTU] wafture, waftures
[FTW] software, leftwards, driftwood, craftwork, delftware, leftward, softwood
[FTY] fifty, lefty, shifty, nifty, crafty, crufty, drafty
[FUB] fubsy
[FUC] fuchsia, fucoid, fucus, fuchsin, fucoids, fucuses, fuchsias
[FUD] fudge, fuddle, befuddle, fudging, fudged, befuddlement, fudges
[FUE] fuel, fuehrer, synfuel, refuel, fueler, fueled, fueling
[FUF] kerfuffle, kerfuffles
[FUG] centrifugal, fug, refugees, calcifuge, febrifuge, teniafuge, vermifuge
[FUH] fuhrer, fuhrers
[FUL] full, useful, successful, careful, helpful, colorful, beautiful
[FUM] fum, perfume, sfumato, suffumigate, fume, fumes, fumbling
[FUN] function, fundamental, funny, malfunction, funky, defunct, funeral
[FUR] further, furnished, sulfur, furlong, furry, furious, furor
[FUS] fusion, fuse, confusion, diffusion, refused, defused, fussy
[FUT] future, futhark, irrefutable, futile, refutations, futz, confute
[FUZ] fuzz, fuzzed, fuzzes, fuzzier, fuzzy, fuzzing, fuzzily
[FWA] halfway
[FWE] gulfweed, gulfweeds
[FWI] halfwit, halfwitted, halfwits
[FWO] beefwood, beefwoods
[FWY] fwy
[FYI] specifying, satisfying, modifying, identifying, verifying, justifying, simplifying
[FYK] fyke
[FYL] fylfot
[FYR] fyrd
[GAA] meshugaas
[GAB] navigable, gabber, gigabytes, megabytes, gabion, gablet, bugaboo
[GAC] legacy, conjugacy, fugacity, sagacity, fagaceous, megacycle, surrogacy
[GAD] gad, brigade, egad, megadose, renegade, rigadoon, haggadist
[GAE] algae, reggae, togaed, congaed
[GAF] gaffer, gigaflops, megafauna, megaflops, gaffe, gaff, gaffed
[GAG] engaged, luggage, gag, baggage, mortgage, degage, burgage
[GAH] gigahertz, megahertz, gahnite, meshugah
[GAI] against, gain, abigail, bargain, gait, regained, gaiety
[GAJ] megajoule, gigajoule, gigajoules, megajoules
[GAL] legal, galley, illegal, centrifugal, galas, gale, jugal
[GAM] gamma, digamma, game, gamble, gamut, amalgamation, cryptogams
[GAN] organization, hiragana, gan, began, elegant, mahogany, logan
[GAP] gap, agape, megaphone, stopgap, gigapixel, megapixel, gigapascal
[GAR] regard, vulgar, garbage, logarithm, sugar, garden, kangaroo
[GAS] gas, omegas, degas, biogas, megass, bagasse, teargas
[GAT] gate, negative, ligature, conjugate, nonnegative, gather, delegate
[GAU] gauss, gauche, gaunt, gauge, degauss, gaudery, gauffer
[GAV] gave, gavage, gavial, agave, forgave, gavotte, misgave
[GAW] gawk, megawatt, gawping, gewgaw, gawd, gigawatt, gawkily
[GAY] gay, margay, nosegay, gayness, gayest, gayer, margays
[GAZ] gaze, stargaze, magazine, gazpacho, gazing, gazump, newsmagazine
[GBA] dingbat, ragbag, bugbane, dogbane, hogback, shagbark, wingback
[GBE] eggbeater, bogbean, bugbear, dogberry, hagberry, bogbeans, bugbears
[GBI] songbird, hummingbird, hangbird, kingbird, mockingbird, hangbirds, kingbirds
[GBO] tugboat, songbook, logbook, fogbow, longbow, kingbolt, pegboard
[GBU] hagbut, gangbusters, hagbuts
[GBY] rugby
[GCA] dogcart, dogcatcher, dogcarts, dogcatchers
[GCL] longcloth
[GCO] lingcod, lingcods
[GCR] kingcraft
[GCU] eggcup, kingcup, eggcups, kingcups
[GCY] agcy
[GDA] amygdala, magdalen, amygdalin, amygdalate, amygdaline, amygdaloid, amygdalas
[GDI] wingding, smaragdine, smaragdite, wingdings
[GDO] kingdom, fogdog, ogdoad, hangdog, ringdove, wrongdoer, subkingdom
[GEA] gear, changeable, pharyngeal, unmanageable, headgear, laryngeal, manageable
[GEB] algebraic, sagebrush, pageboy, edgebone, bargeboard, vegeburger, vergeboard
[GEC] gecko, stagecoach, stagecraft, geckos, stagecoaches
[GED] changed, unchanged, ragged, merged, tagged, managed, converged
[GEE] gee, bungee, negligee, refugees, apogee, burgee, pongee
[GEF] pageful, dirgeful, vengeful, changeful, prestigeful, rangefinder, stagefright
[GEG] gegenschein, gegenscheins
[GEH] hedgehog, sledgehammer, gehlenite, stagehand, bridgehead, cabbagehead, largehearted
[GEI] ageism, geisha, lugeing, singeing, tingeing, swingeing, whingeing
[GEL] angel, gel, largely, bagel, edgeless, strangely, archangel
[GEM] infringement, management, arrangement, gem, enlargement, engagement, derangement
[GEN] general, legend, gens, negligence, magenta, convergence, homogeneous
[GEO] geometry, geographic, geodesic, advantageous, surgeon, geophysics, pigeon
[GEP] bargepole, ridgepole, hodgepodge, ridgepoles, hodgepodges
[GER] integer, logger, german, longer, manager, larger, dagger
[GES] changes, edges, damages, pages, images, packages, digest
[GET] get, target, together, widget, forget, altogether, budget
[GEU] geum, hypogeum, voyageur, arbitrageur, voyageurs, arbitrageurs
[GEV] longevity, longevous
[GEW] gewgaw, edgewise, bridgework, orangewood, passageway, wageworker, cabbageworm
[GEX] regex, regexp, regexps
[GEY] bigeye, bugeye, geyser, bogey, cagey, pogey, fogeydom
[GFA] segfault, dogface, segfaults
[GFE] songfest, songfests
[GFI] dogfish, hagfish, hogfish, pigfish, frogfish, kingfish, lungfish
[GFL] stagflation
[GFO] bigfoot
[GFR] sangfroid
[GFU] meaningful, bagful, jugful, mugful, lungful, songful, wrongful
[GGA] luggage, baggage, beggar, nuggar, quagga, reggae, boggart
[GGB] eggbeater, eggbeaters
[GGC] eggcup, eggcups
[GGE] logger, dagger, ragged, trigger, bigger, tagged, debugger
[GGH] egghead, eggheads
[GGI] logging, debugging, tagging, bagging, hugging, shrugging, biggie
[GGL] gaggle, giggle, goggle, juggle, wiggle, toggle, smuggle
[GGN] eggnog
[GGO] maggot, doggo, doggone, maggoty, maggots, doggoner, doggones
[GGP] eggplant, eggplants
[GGR] aggregate, aggressive, aggravated, aggrieved, puggree, aggrandize, unaggressive
[GGS] eggs, yeggs, mahjonggs, eggshell, eggshells
[GGU] ziggurat
[GGY] buggy, foggy, piggy, baggy, cloggy, craggy, draggy
[GHA] ogham, shanghai, afghani, longhair, agha, gharry, ataghan
[GHB] neighbors, highboy, doughboy, thighbone, weighbridge, thoroughbred, unneighborly
[GHC] highchair, roughcast, highchairs, roughcasts, roughcasting
[GHE] higher, gherkin, spaghetti, ghee, bighead, weighed, tougher
[GHF] highflier, highfalutin, thoroughfare, highfliers
[GHH] roughhew, highhanded, roughhewn, roughhouse, roughhoused, roughhouses, highhandedly
[GHI] laughing, weighing, highish, roughing, binghi, toughie, dunghill
[GHL] highlight, roughly, thoroughly, highlander, toughly, highlighting, highlighter
[GHN] doughnut, roughness, highness, toughness, thoroughness, roughneck, doughnuts
[GHO] throughout, ghost, bighorn, foghorn, ghoul, leghorn, lughole
[GHP] throughput, highpoint, boughpot
[GHR] tughrik, highroad, roughrider, tughriks, highroads, roughriders
[GHS] highs, neighs, laughs, thighs, troughs, outweighs, boughs
[GHT] bright, eight, fight, light, night, height, right
[GHU] bulghur, sorghum, bulghurs
[GHW] highway, superhighway, thoroughwort, highwayman, highwaymen, highways
[GHY] dinghy, doughy, ghyll, sloughy
[GIA] giant, vestigial, appoggiatura, giaour, loggia, elegiac, eulogia
[GIB] eligible, gib, intelligible, negligible, legible, tangible, ineligible
[GIC] logic, magic, topological, ontological, astrological, pathological, strategic
[GID] gid, rigid, turgid, frigid, pongid, algid, energid
[GIE] strategies, technologies, energies, biggie, anthologies, boogie, aggie
[GIF] gift, fungiform, spongiform, gifts, gifted, gifting, giftedness
[GIG] gig, fizgig, fishgig, whirligig, gigabytes, gigantic, gigabyte
[GII] congii
[GIL] fragile, gilt, sigil, gilbert, gill, agile, vigilant
[GIM] gimel, gimp, gimbal, regime, gimme, gimlet, gimcrack
[GIN] begin, original, engine, margin, logging, gin, plugins
[GIO] region, subregion, arpeggio, religion, legion, contagious, egregious
[GIP] gipon, frangipane, frangipani, frangipanes, frangipanis
[GIR] girl, giraffe, girth, girder, giro, begird, engird
[GIS] register, logistic, gist, technologist, paralogisms, unregistered, syllogism
[GIT] digit, git, longitude, legitimate, regurgitate, agitated, augite
[GIU] seaborgium, congius, eulogium, patagium, collegium, contagium, fastigium
[GIV] given, giving, forgiving, thanksgiving, unforgiving, ogival, gingiva
[GIZ] gizmo, gizzard, apologizes, elegize, energize, eulogize, analogize
[GJA] logjam, logjams
[GLA] glasses, hourglass, sunglasses, glance, glad, eyeglasses, glam
[GLE] single, angle, rectangle, google, triangle, toggle, dogleg
[GLI] english, negligence, glib, dangling, juggling, mangling, glimpse
[GLO] global, glossaries, glottal, glow, glorious, gloves, glom
[GLU] glue, gluon, glucose, glut, unglue, glum, englut
[GLY] smugly, snuggly, squiggly, ugly, wiggly, glyphs, hieroglyph
[GMA] sigma, stigma, magma, enigma, pragmatic, zeugma, smegma
[GME] segment, fragment, augment, judgment, pigment, abridgment, figment
[GMI] agminate, astigmia, quagmire, sphygmic, nystagmic, stalagmite, pygmies
[GMO] sigmoid, frogmouth, bigmouth, sphygmoid, thigmotaxis, bigmouths, frogmouths
[GMS] paradigms, apothegms, diaphragms, apophthegms
[GMU] nystagmus, borborygmus
[GMY] phlegmy, pygmy
[GNA] gnarl, gnash, gnat, gnaw, signal, designated, pregnant
[GNB] signboard, signboards
[GNE] signed, aligned, assigned, unsigned, designed, magnetic, unaligned
[GNI] magnitude, significant, recognized, assigning, unrecognized, magnified, designing
[GNL] benignly, malignly, condignly, sovereignly
[GNM] alignment, assignment, reassignment, misalignment, realignment, arraignment, consignment
[GNN] foreignness
[GNO] gnome, ignore, diagnostics, agnostic, segno, magnon, cognomen
[GNP] signpost, signposts, signposted, signposting
[GNS] signs, aligns, assigns, designs, reassigns, ensigns, resigns
[GNT] sovereignty
[GNU] gnu, magnum, hognut, pignus, wingnut, sphagnum, interregnum
[GOA] goal, goat, goad, scapegoat, goals, goatee, goa
[GOB] gobble, goblin, gobsmacked, dagoba, engobe, gobang, gobioid
[GOC] phagocyte, egocentric, oligoclase, oligochaete, phagocytic, egocentrism, phagocytosis
[GOD] ergodic, god, pagoda, demigod, ungodly, stegodon, zygodactyl
[GOE] goes, embargoed, mangoes, undergoes, chigoe, dagoes, cargoes
[GOF] logoff, goffer, gofer, gofers, goffers, logoffs
[GOG] logogram, goggles, synagogue, pedagogical, agog, goglet, anagoge
[GOH] megohm, megohms
[GOI] going, outgoing, ongoing, foregoing, undergoing, egoism, ingoing
[GOL] gold, golfing, mongol, marigold, gigolo, googol, argol
[GOM] prolegomena, gomuti, zygoma, dragoman, egomania, gombroon, algometer
[GON] polygon, diagonal, orthogonal, trigon, hexagon, gone, pentagon
[GOO] google, goods, goon, goose, goof, mongoose, lagoon
[GOP] gopher, oligopoly, gopak, tragopan, zygophyte, algophobia, ergophobia
[GOR] category, algorithm, rigorous, gorgon, gorilla, gorse, gory
[GOS] logos, gospel, gosh, egos, argosy, gossip, rugose
[GOT] got, forgotten, negotiate, logotype, renegotiate, maggot, spigot
[GOU] analogous, logout, gout, gourd, humongous, agouti, congou
[GOV] governing, hangover, hungover, wingover, misgovern, ungoverned, governed
[GOW] gown, gowan, ballgown, gowk, hoosegow, nightgown, gownsman
[GOY] goyish, gargoyle, goys, goyim, goy, gargoyled, gargoyles
[GPE] pigpen, pigpens
[GPI] bagpipe, magpie, kingpin, ragpicker, stringpiece, bagpiper, magpies
[GPL] eggplant, gangplow, gangplank, eggplants, gangplanks
[GPO] flagpole, flagpoles
[GRA] graph, program, integral, granted, digraph, gradient, gray
[GRE] degree, green, regression, greater, progress, agreement, grep
[GRI] grid, integrity, grinning, grip, grille, pilgrim, grimacing
[GRO] group, background, grot, grow, foreground, subgroup, newsgroups
[GRU] congruence, grumpy, incongruity, gruel, grunt, grub, grudgingly
[GRY] angry, hungry
[GSA] jigsaw, lugsail, cheongsam, studdingsail, jigsaws, jigsawed, lugsails
[GSB] dogsbody, dogsbodies
[GSD] rigsdaler
[GSG] billingsgate
[GSH] mugshot, eggshell, bigshot, flagship, grogshop, hogshead, kingship
[GSI] alongside, ringside, longsighted
[GSK] pigskin, pigskins
[GSL] dogsled, dogsleds
[GSM] cragsman, swagsman, cragsmen
[GSO] longsome, singsong, singsongs, singsonged, singsonging
[GSP] longspur, wingspan, frogspawn, singspiel, kriegspiel, singspiele, wingspans
[GST] tungsten, angst, longstanding, pigsty, gangsta, dragster, ringster
[GSW] pigswill
[GSY] langsyne, langsynes
[GTA] ragtag, pigtail, wagtail, bangtail, ringtail, springtail, ragtags
[GTE] dogteeth
[GTH] length, strength, wavelength, restrengthen, lengthy, strengthen, lengthening
[GTI] longtime, hogtie, ragtime, wingtip, springtime, hogtied, hogties
[GTO] wellington, ragtop, dogtooth, ringtone, ringtones, wellingtons
[GTR] dogtrot, bogtrotter, dogtrotted, dogtrotting, dogtrots
[GTY] hogtying
[GUA] language, guard, unguarded, disambiguate, multilingual, arguably, lingua
[GUB] guberniya, lugubrious, lugubriously
[GUC] guck, gucks
[GUD] guddle, gudgeon, gudgeons
[GUE] argue, league, plague, rogue, tongue, guess, prologue
[GUF] argufy, guffaw, guff, guffaws, argufied, argufies, guffawed
[GUG] guggle, guggled, guggles, guggling
[GUH] kieselguhr, kieselguhrs
[GUI] guide, distinguish, ambiguity, penguin, linguistic, guinea, contiguity
[GUL] regular, singular, triangular, angular, rectangular, ligula, irregular
[GUM] argument, gum, bubblegum, legume, tergum, begum, hegumen
[GUN] begun, gun, burgundy, shotgun, outgun, popgun, progun
[GUO] contiguous, ambiguous, unambiguous, languor, exiguous, irriguous, contiguously
[GUP] hangup, guppy, guppies, hangups
[GUR] figure, configure, guru, transfigure, reconfigure, gurney, regurgitate
[GUS] august, bogus, gust, asparagus, fungus, vulgus, disgusting
[GUT] gutter, guts, orangutan, catgut, midgut, rotgut, foregut
[GUV] guv, guvnor, guvnors, guvs
[GUY] guy, wiseguys, guys, guyot, wiseguy, guying, guyots
[GUZ] guzzle, guzzler, guzzled, guzzles, guzzlers, guzzling
[GVA] dogvane
[GWA] logway, wigwag, gangway, hogwash, nagware, dogwatch, longways
[GWE] hogweed, ngwee, pigweed, ragweed, hogweeds, pigweeds
[GWH] cogwheel, cogwheels
[GWI] bagwig, bigwig, bigwigs
[GWO] bagworm, dogwood, figwort, legwork, logwood, lugworm, ragwort
[GWR] songwriter, songwriting, songwriters
[GWU] mugwump, mugwumpery, mugwumps
[GWY] hgwy
[GYB] piggyback, piggybacking, piggybacks, piggybacked
[GYI] fogyish
[GYL] argyle, argyles
[GYM] gym, bogyman, clergyman, junglegym, gymnast, gymnastics, gyms
[GYN] epigynous, hypogynous, gynecic, gynandry, gynarchy, misogyny, monogyny
[GYP] gyp, gypped, gypsy, gypsum, gypper, gypping, gypster
[GYR] gyre, gyrator, gyroscope, gyrus, spagyric, gyrfalcon, gyroplane
[GYV] gyve, gyving, gyved, gyves
[GYW] clergywoman, baggywrinkle, clergywomen
[GZA] zigzag, zigzagged, zigzagger, zigzagging, zigzags
[GZW] zugzwang
[HAA] haar, haaf
[HAB] alphabet, reachable, unreachable, searchable, habitant, patchable, stretchable
[HAC] hack, hacek, whack, hachure, shackle, chacma, rhachis
[HAD] shadow, had, chad, bahadur, jihad, khaddar, eyeshade
[HAE] archaeology, hae, chaeta, hyphae, phaeton, nymphaea, coryphaeus
[HAF] shaft, hafnium, chaff, hafiz, camshaft, haft, jackshaft
[HAG] chagrin, hag, shaggy, phage, esophagi, geophagy, roughage
[HAH] shah, brouhaha, ephahs, hahnium, ephah, shahs, brouhahas
[HAI] chain, hair, wheelchair, archaic, haiku, shanghai, crosshair
[HAJ] haj, bhaji, hajjes, hajes, hajji, hajj, hajjis
[HAK] handshake, shake, khaki, milkshake, haku, bhakti, hakim
[HAL] half, shall, narwhals, behalf, marshal, challenge, halt
[HAM] hamming, hamza, cham, graham, ogham, hamburg, shamrock
[HAN] handle, than, changes, enhancement, unchanged, phantom, hang
[HAO] chaos, haole, chaotic, chaotically
[HAP] shape, chapter, reshape, happen, perhaps, unhappy, misshaped
[HAQ] chaqueta, methaqualone
[HAR] char, shared, harness, hard, harmonic, harpoon, flowchart
[HAS] has, phase, alphas, emphasis, stochastic, chassis, gotchas
[HAT] that, what, hat, chat, somewhat, manhattan, phat
[HAU] hauteur, exhausted, haugh, overhaul, haul, haunts, inhaul
[HAV] have, behavior, having, havoc, shaved, misbehave, drawshave
[HAW] shaw, thaw, rickshaw, mohawk, hawk, bashaw, hawser
[HAY] hay, shay, sashay, chayote, haystack, haywire, hays
[HAZ] hazard, haze, hazy, hazmat, chazan, hazily, ghazi
[HBA] cashback, highball, mothball, punchbag, pushball, flashback, hatchback
[HBE] deathbed, pinchbeck, heathberry, torchbearer, deathbeds, pinchbecks, torchbearers
[HBI] pushbike, archbishop, highbinder, sheathbill, pushbikes, archbishops, highbinders
[HBL] deathblow, breechblock, deathblows, breechblocks
[HBO] neighbors, dashboard, cashbox, highboy, boschbok, doughboy, fishbolt
[HBR] toothbrush, highbred, weighbridge, pathbreaking, thoroughbred, highbrow, highbrowism
[HBU] pushbutton, bushbuck, flashbulb, swashbuckler, bushbucks, flashbulbs
[HCA] flashcards, trashcan, healthcare, ashcan, fishcake, pushcart, roughcast
[HCH] highchair, ahchoo, pushchair, highchairs, pushchairs
[HCL] dishcloth, washcloth, breechcloth, dishcloths, washcloths, breechcloths
[HCO] forthcoming, pinchcock, beachcomber, beachcombing, beachcombers
[HCR] bushcraft
[HCU] flashcube, flashcubes
[HDA] birthday, washday, deathday, washdays, birthdays
[HDE] archdeacon, archdeaconry, archdeacons
[HDI] archdiocese, archdiocesan, archdioceses
[HDO] watchdog, touchdown, splashdown, witchdoctor, watchdogs, touchdowns, splashdowns
[HDR] withdraw, withdrawn, withdrawal, withdrew, withdraws, withdrawals, withdrawing
[HDU] archduke, archducal, archduchy, archduchess, archdukes, archduchies
[HEA] header, northeast, heavy, heart, heap, southeast, ahead
[HEB] shebang, ephebe, hebetic, thebe, hebdomad, shebangs, ephebic
[HEC] check, unchecked, hectometer, heck, recheck, spellcheck, theca
[HED] published, cached, matched, furnished, dashed, reached, attached
[HEE] sheet, wheel, worksheet, spreadsheet, cheese, cartwheeling, heel
[HEF] chef, heft, theft, antitheft, blitheful, heftily, hefty
[HEG] hegira, hegumen, thegn, apothegm, hegemony, metheglin, apophthegm
[HEI] heifer, height, heinous, heir, heist, their, atheism
[HEK] shekel, shekels
[HEL] help, shell, hello, held, echelon, helix, nevertheless
[HEM] them, mathematical, schema, chemical, alchemical, grapheme, hem
[HEN] when, then, hyphen, hence, henry, authenticate, phenomena
[HEO] theory, archeol, pheon, luncheon, pantheon, puncheon, rheo
[HEP] hep, cachepot, shepherd, cathepsin, heptagon, heptode, heptagonal
[HEQ] sheqel, exchequer, discotheque, cinematheque, sheqalim, exchequers, discotheques
[HER] other, either, there, where, whether, here, another
[HES] these, matches, hashes, patches, hessian, hypothesis, parenthesis
[HET] whether, theta, aesthetic, synthetic, hypothetical, heth, crochet
[HEU] heuristic, rheumy, sheugh, theurgy, nympheum, accoucheur, heulandite
[HEV] chevron, whichever, dishevel, bolshevism, chevalier, chevet, chevre
[HEW] chew, phew, whew, nephew, hew, cashew, eschew
[HEX] hex, narthex, cachexia, cathexes, cyclohexane, unnilhexium, anticathexis
[HEY] they, hey, fisheye, whey, heyday, heydays
[HEZ] chez
[HFA] soothfast, highfalutin, thoroughfare
[HFE] mouthfeel
[HFI] pathfinder, bushfire, archfiend, archfiends, pathfinders
[HFL] cashflow, highflier, highfliers
[HFO] pitchfork, pitchforks, pitchforked, pitchforking
[HFR] beachfront
[HFU] bashful, faithful, truthful, youthful, mouthful, ruthful, wishful
[HGA] lychgate, lychgates
[HGE] sprechgesang, chge, switchgear
[HGI] fishgig, fishgigs
[HGO] churchgoer, churchgoing, churchgoers
[HGU] flashgun, flashguns
[HGW] hgwy
[HHA] bushhammer, highhanded, highhandedly
[HHE] withheld, roughhew, beachhead, roughhewn, beachheads
[HHI] hitchhiker, hitchhike, hitchhiked, hitchhikes, hitchhikers, hitchhiking
[HHO] fishhook, withhold, bathhouse, touchhole, washhouse, roughhouse, sleuthhound
[HIA] hiatus, parochial, psychiatry, chiack, ischia, lithia, lochia
[HIB] exhibit, prohibited, inhibit, amphibious, hibiscus, adhibit, chibouk
[HIC] which, thickness, graphics, isomorphic, pictographic, ideographic, hierarchical
[HID] hidden, hide, hiding, orchid, echidna, hidalgo, unhidden
[HIE] hieroglyph, hierarchy, shield, achieve, neckerchief, chiefly, mischief
[HIF] shift, redshift, downshift, makeshift, chiffon, mythify, whiff
[HIG] high, thigh, chigoe, higgle, shigella, amphigory, pemphigus
[HIH] chihuahua, chihuahuas
[HII] shiitake, shiitakes
[HIJ] hijack, hijacking, hijacks, hijacked, hijab, hijacker, hijabs
[HIK] hiking, hitchhiker, muzhik, shiksa, dashiki, hiker, apparatchik
[HIL] while, child, annihilator, nihil, hill, philosophy, grandchild
[HIM] chimera, shim, him, whimsy, ahimsa, thimble, archimage
[HIN] within, nothing, something, matching, machine, thing, anything
[HIO] fashion, pistachio, cushion, methionine, thiol, falchion, finochio
[HIP] relationship, ownership, chip, authorship, membership, ship, partnership
[HIR] third, shirt, hiragana, hires, chirp, undershirt, whirl
[HIS] this, histogram, isomorphism, historical, homomorphism, whiskers, endomorphism
[HIT] white, hit, architecture, graphite, thither, bronchitis, chit
[HIU] lithium, promethium, ischium, bacchius, brachium, hypanthium, perionychium
[HIV] archive, shiva, beehive, chive, hive, yeshiva, unchivalrous
[HIY] hiya
[HIZ] schizo, phiz, sympathizing, rhizoid, whizkid, catechize, empathize
[HJO] mahjong, mahjongg, mahjongs, mahjonggs
[HKA] babushka, babushkas
[HKE] kishke, latchkey, kishkes, latchkeys
[HKI] munchkin, piroshki, droshkies, munchkins
[HKY] droshky
[HLA] ashlar, chlamys, uhlan, bushland, highland, heathland, marchland
[HLB] fahlband
[HLE] athlete, pamphlet, ruthless, worthless, branchless, phlegm, schlep
[HLI] highlight, dahlia, flashlight, hatchling, cichlid, shashlik, suchlike
[HLO] monthlong, chlorine, pentathlon, phlox, schlock, biathlon, antichlor
[HLR] kohlrabi, kohlrabies
[HLS] mahlstick, buhls, dahls, kohls, mahlsticks
[HLU] archlute
[HLY] highly, roughly, monthly, freshly, thoroughly, smoothly, earthly
[HMA] asthma, bathmat, drachma, benchmark, ohmage, bushman, yashmak
[HME] arithmetic, attachment, parchment, enrichment, punishment, detachment, admonishment
[HMI] logarithmic, algorithmic, rhythmic, arrhythmia, ohmic, isthmian, eurythmic
[HML] rhythmless
[HMM] ohmmeter, ohmmeters
[HMO] earthmover, fishmonger, ethmoid, schmo, shmooze, arithmomancy, schmoes
[HMS] algorithms, logarithms, ohms, rhythms, abohms, megohms, biorhythms
[HMU] isthmus, schmuck, shmuck, isthmuses, schmucks
[HMY] eurhythmy
[HNA] pathname, ethnarch, schnapps, schnauzer, schnauzers
[HNE] smoothness, freshness, roughness, technetium, richness, daphne, fishnet
[HNI] technical, polytechnic, ethnic, gahnite, hahnium, ichnite, lychnis
[HNN] johnny, johnnycake, johnnies, johnnycakes
[HNO] ethnology, technology, ethnographic, schnoz, shnorrer, arachnoid, ichnology
[HNS] johns, foehns, autobahns, demijohns
[HNU] doughnut, beechnut, earthnut, beechnuts, doughnuts, earthnuts
[HOA] whoa, hoard, hoagie, hoaxer, hoatzin, shoal, hoactzin
[HOB] hobby, hydrophobic, hobnob, phobia, dhobi, cohobate, hobo
[HOC] hoc, chocolate, shock, phocine, chockfull, hollyhock, aftershock
[HOD] method, cathode, orthodox, rhodamine, hod, shoddy, unorthodox
[HOE] phoenix, shoe, whoever, hoe, echoed, backhoe, gumshoe
[HOF] shofar, brushoff, shofroth, shofars, brushoffs
[HOG] orthogonal, hog, lithography, mahogany, hedgehog, orthography, warthog
[HOI] choice, hoist, echoing, anechoic, hoiden, hoick, lithoid
[HOK] choke, hokey, hokier, hokku, hokum, kazachok, artichoke
[HOL] whole, hold, threshold, placeholder, morphology, holidays, hole
[HOM] home, whom, homogeneous, chomp, homomorphism, rhombus, homology
[HON] python, phone, telephone, honor, microphone, colophon, hong
[HOO] hook, choose, likelihood, neighborhood, school, yahoo, hood
[HOP] hope, chop, bishop, shopping, workshop, hoping, hops
[HOR] anchor, author, short, horizontal, horse, semaphore, chordal
[HOS] those, host, whose, chosen, ghost, stethoscope, hospital
[HOT] snapshot, photo, hot, screenshot, shot, mugshot, upshot
[HOU] should, without, though, hour, although, house, silhouette
[HOV] hover, shovel, switchover, anchovy, pushover, echovirus, flashover
[HOW] however, show, somehow, anyhow, howl, slideshow, reshow
[HOX] zanthoxylum, methoxychlor
[HOY] hoy, ahoy, hobbledehoy, hoyden, hoydenish, hoydens, hoys
[HOZ] kolkhoz, anthozoan, scyphozoan, trophozoite, kolkhozes, anthozoans, scyphozoans
[HPA] launchpad, toothpaste, dishpan, southpaw, marchpane, mouthpart, sketchpad
[HPE] catchpenny, pinchpenny
[HPI] pushpin, linchpin, toothpick, mouthpiece, pushpins, linchpins, toothpicks
[HPL] fishplate, trothplight, fishplates
[HPO] dashpot, highpoint, boughpot, fishpond, fleshpot, hotchpot, catchpole
[HPR] mothproof, mothproofs, mothproofed, mothproofer, mothproofing
[HPU] throughput, jodhpur, jodhpurs
[HQU] earthquake, earthquakes
[HRA] phrase, paraphrase, diaphragm, shrank, thrash, anthrax, rephrase
[HRE] thread, ochre, phrenic, shred, euchre, fuhrer, beshrew
[HRI] shrink, christian, thrift, bohrium, enshrine, tughrik, inshrine
[HRO] through, chromium, synchronized, monochrome, asynchronous, mushroom, chronology
[HRS] buhrstone, kieselguhrs
[HRU] shrub, thrush, subshrub, upthrust, hearthrug, preshrunk, pyrethrum
[HRY] hryvnia, chrysalid, lachrymal, chrysolite, chrysotile, chrysoberyl, chrysoprase
[HSA] soothsay, vouchsafe, soothsayer, soothsaying, vouchsafed, vouchsafes, soothsayers
[HSE] aurochses
[HSH] dachshund, roughshod, messiahship, dachshunds, messiahships
[HSI] fuchsia, tahsildar, hearthside, fuchsin, fuchsias
[HSK] rathskeller, rathskellers
[HSL] whsle
[HSO] loathsome, toothsome, smithsonite, whichsoever, loathsomely, toothsomely
[HSP] strathspey
[HST] withstanding, washstand, touchstone, withstand, withstood, washstands, withstands
[HTA] hashtag, straightaway, fishtail, hightail, freightage, breathtaking, hashtags
[HTB] eightball, fightback, draughtboard
[HTC] nightcap, nightcaps
[HTE] weighted, highlighter, unweighted, copyrighted, firefighter, lighter, eighteen
[HTF] delightful, insightful, rightfully, thoughtfully, eightfold, frightful, lightface
[HTG] nightgown, nightgowns
[HTH] eighth, diphtheria, ophthalmology, lighthouse, phthalein, monophthong, diphthongs
[HTI] highlighting, weighting, lighting, fighting, eightieth, lunchtime, shtick
[HTJ] nightjar, nightjars
[HTL] slightly, tightly, lightly, rightly, nightly, unsightly, weightlifter
[HTM] rightmost, nightmare, nightmarish, nightmares
[HTN] brightness, lightness, tightness, straightness, rightness, slightness, uprightness
[HTO] righto, dishtowel, watchtower, dishtowels, watchtowers
[HTP] eightpence, flightpath
[HTR] ashtray, deathtrap, sightread, tightrope, nightrider, ashtrays, deathtraps
[HTS] rights, weights, heights, copyrights, highlights, lights, eights
[HTT] nighttime
[HTU] bathtub, washtub, bathtubs, washtubs
[HTW] rightwards, lightweight, tightwad, nightwear, brightwork, straightway, rightward
[HTY] eighty, mighty, naughty, lightyear, almighty, doughty, flighty
[HUA] chihuahua, sahuaro, huarache, sahuaros, huaraches, chihuahuas
[HUB] hub, chub, rhubarb, tohubohu, hubs, chubby, hubbub
[HUC] chuck, shucks, upchuck, cachucha, huckster, huckaback, woodchuck
[HUD] shudder, huddled, chuddar, thudded, huddle, thud, thudding
[HUE] hue, hues, hued
[HUF] shuffle, huff, reshuffling, chuffy, shuffled, shuffling, shuffles
[HUG] huge, hugging, hugs, chugged, meshuga, thuggee, hiphuggers
[HUH] huh
[HUI] euphuism, euphuist, euphuistic, euphuisms
[HUJ] thuja
[HUK] chukar, chukka, chukkar, chukker, chukkas, chukkers
[HUL] hull, thulium, shul, hulky, hula, pyrrhuloxia, hulls
[HUM] human, thumb, hump, humidity, humble, humor, hummingbird
[HUN] chunk, hundred, hung, hunt, shunting, thunder, hunk
[HUP] ketchup, huppah, mashup, chuppah, matchup, smashup, whupped
[HUR] church, hurt, brochure, hurl, hurry, hurst, hachure
[HUS] thus, hushed, shushing, husky, enthusiasm, husband, hussar
[HUT] shutdown, hut, shutting, parachute, chute, shutoffs, shut
[HUV] bahuvrihi
[HUY] thuya
[HUZ] huzzah, huzzahs, huzzahed, huzzahing
[HVA] boschvark
[HWA] pathway, schwa, thwart, highway, hwan, northward, southward
[HWE] northwest, southwest, beachwear, catchweight, northwestern, northwester, southwester
[HWH] bushwhack, coachwhip, bushwhacker, bushwhacks, coachwhips, bushwhacked, bushwhackers
[HWI] fishwife, forthwith, widthwise, fishwives
[HWO] patchwork, inchworm, fishworm, meshwork, beechwood, birthwort, brushwood
[HWR] speechwriter
[HWY] hwy
[HYA] hyacinth, chyack, dhyana, bathyal, hyaline, churchyard, hyalite
[HYB] hybrid, dihybrid, hybris, hybrids, hybridism, hybridity, hybridize
[HYC] phycology, phycomycete, tachycardia
[HYD] hydrogen, aldehyde, carbohydrate, whydah, hydatid, dihydric, hydracid
[HYE] hyetal, shyest, hyena, shyer, hyetology, hyetograph, hyetography
[HYG] hygiene, apophyge, sphygmic, hygrostat, hypophyge, hygrograph, hygrometer
[HYI] hying, ichthyic, shying, atrophying
[HYL] methyl, ethylene, polyethylene, phylum, subphylum, superphylum, chyle
[HYM] hymn, thyme, rhyme, chyme, ecthyma, hymen, dysthymia
[HYN] ethyne, shyness, ethynes
[HYO] hyoid, tachyon, hyoscine, ichthyol, rhyolite, mylohyoid, diphyodont
[HYP] hype, hyphen, hypnosis, hypothesis, hypotenuse, unhyphenated, hypogynous
[HYR] thyristor, zephyr, chyron, hyraces, porphyry, dithyramb, melaphyre
[HYS] physics, metaphysics, geophysics, hysteresis, astrophysics, amethyst, vichyssoise
[HYT] rhythmic, arrhythmia, epiphyte, geophyte, neophyte, trachyte, zoophyte
[HYU] brachyuran, brachyurans
[HYX] asphyxia, asphyxiant, asphyxiate, asphyxiator, asphyxiation, asphyxiated, asphyxiates
[HZO] machzor
[IAB] variable, liability, diabetes, satisfiable, reliable, viable, modifiable
[IAC] diacritic, mediacy, zodiac, cardiac, ammoniac, paranoiac, acciaccatura
[IAD] variadic, triad, myriad, diadem, pleiad, chiliad, gliadin
[IAE] diaeresis, curiae, striae, tibiae, exuviae, scoriae, facetiae
[IAF] piaffe, teniafuge, piaffes
[IAG] diag, carriage, marriage, triaged, verbiage, foliage, ferriage
[IAH] rupiah, pariah, messiah, shariah, pariahs, rupiahs, messiahs
[IAI] liaison, antiaircraft, liaisons, liaise, liaised, liaises, liaising
[IAK] kaiak, umiak, diakineses, diakinesis, umiaks
[IAL] dial, facial, material, social, trial, initial, special
[IAM] diamond, parliament, milliampere, iambic, siamang, choriamb, thiamine
[IAN] guardian, librarian, magician, musician, piano, valiant, variant
[IAO] ciao, giaour, chiao, miaous, ciaos, miaou
[IAP] diaphragm, periapt, priapic, diapason, myriapod, diaphyses, lagniappe
[IAQ] semiaquatic
[IAR] auxiliary, familiar, tertiary, peculiar, subsidiary, intermediary, diary
[IAS] alias, bias, unbiased, ecclesiastic, enthusiasm, arias, fiasco
[IAT] immediate, associated, variation, appropriate, multivariate, deviation, intermediate
[IAU] fabliau, biauriculate, fabliaux
[IAX] triaxial, biaxial, uniaxial
[IAZ] piazza, diazine, thiazine, triazine, isoniazid, diazo, diazole
[IBA] cannibalism, millibar, describable, ribald, tribal, ceiba, copaiba
[IBB] dribble, gibbon, nibble, quibble, ribbon, scribble, cribbed
[IBC] bibcock, ribcage
[IBE] fiber, describe, libero, subscribe, deliberate, prescribed, unsubscribed
[IBI] possibility, visibility, exhibit, ibis, describing, prohibited, feasibility
[IBL] visible, possible, compatible, bibliography, incompatible, sibling, feasible
[IBN] stibnite, glibness, stibnites
[IBO] ribose, caribou, kibosh, skibob, chibouk, ciboria, epiboly
[IBR] library, calibration, equilibrium, vibration, uncalibrated, recalibrate, fibril
[IBS] bibs, fibster, sibship, dibs, spareribs, sahibs, squibs
[IBU] attribute, distributed, contributor, redistribute, omnibus, minibus, tribute
[IBW] ribwort, cribwork, ribworts
[IBY] sibyl, sibylline, sibyls
[ICA] vertical, application, categorical, mathematical, modification, logical, musical
[ICC] piccolo, hiccup, sicced, chiccory, spiccato, capriccio, desiccant
[ICE] dice, ice, mice, nice, spice, license, notice
[ICH] which, rich, multichannel, affiche, fiche, sandwich, enrich
[ICI] explicit, coefficients, implicit, efficient, publicity, official, sufficient
[ICK] brick, chick, kick, quick, trick, pickle, tick
[ICL] article, particle, publicly, vehicle, versicle, triclinic, antiparticle
[ICN] picnic, chicness, prosaicness, publicness, graphicness, prolificness, picnicked
[ICO] icon, semicolon, silicon, lexicon, icosahedral, medico, apricot
[ICR] micro, omicron, ludicrous, mimicry, picrate, dicrotic, anticrime
[ICS] physics, metrics, graphics, statistics, optics, dynamics, mechanics
[ICT] dict, strict, predict, picture, restriction, conflict, jurisdiction
[ICU] particular, difficult, curriculum, lenticular, articulation, fascicules, curlicue
[ICW] colicweed
[ICY] policy, bicyclist, icy, juicy, spicy, epicycle, impolicy
[IDA] validate, candidate, avoidance, sinusoidal, holidays, guidance, consolidate
[IDB] tidbit, midbrain, tidbits, midbrains
[IDC] midcourse
[IDD] hidden, middle, forbidden, overridden, ridden, fiddled, bidder
[IDE] provided, divide, side, inside, outside, identity, override
[IDF] midfield, midfielder, midfielders
[IDG] bridge, fridge, midge, porridge, ridge, widget, cartridge
[IDH] ceilidh, ceilidhs
[IDI] providing, validity, overriding, sliding, hiding, avoiding, dividing
[IDL] idle, rapidly, validly, midline, idling, stupidly, sidle
[IDM] midmost
[IDN] midnight, kidney, echidna, aridness, avidness, quidnunc, acridness
[IDO] widow, lido, ridotto, libido, peridot, idol, aikido
[IDP] midpoint, skidpan, midpoints, skidproof, skidpans
[IDR] midrib, antidrug, hidroses, midrash, midriff, hidrosis, hidrotic
[IDS] ids, avoids, kids, grids, centroids, braids, forbids
[IDT] width, bandwidth, midterm, widths, bandwidths, midtown, widthwise
[IDU] individual, solidus, residual, deciduous, fiducial, nidus, oviduct
[IDW] midway, skidway, midweek, midwife, midwives, midwicket, midwifery
[IDY] tidy, midyear, untidy, perfidy, subsidy, idyll, didymium
[IEB] tiebreaker, dieback, piebald, zwieback, muliebrity, veggieburger, tiebacks
[IEC] piecewise, frontispiece, earpiece, timepiece, mantelpiece, piecemeal, masterpiece
[IED] modified, specified, implied, applied, copied, supplied, tried
[IEF] brief, relief, belief, neckerchief, chiefly, lief, debrief
[IEG] besiege, liege, siege, moviegoer, variegate, blitzkrieg, kriegspiel
[IEI] hieing, pieing, birdieing, boogieing, sortieing, stymieing
[IEK] shriek, shrieks, shrieked, shrieker, shriekers, shrieking
[IEL] field, yield, shield, subfield, ariel, spiel, infield
[IEM] siemens, hiemal, requiem, seriema, millieme, boogieman, tiemannite
[IEN] client, gradient, coefficients, orient, quotient, efficient, recipient
[IEP] tiepin, pieplant, tiepins, pieplants
[IER] hieroglyph, identifier, modifier, classifier, specifier, barrier, hierarchy
[IES] series, copies, categories, glossaries, properties, warranties, entries
[IET] quiet, society, variety, proprietary, dieter, twentieth, piet
[IEU] adieu, lieu, milieu, purlieu, monsieur, banlieue, maieutic
[IEV] retrieve, sieve, achieve, believe, medieval, relieved, aggrieved
[IEW] view, preview, overview, review, interview, purview, teleview
[IEZ] frieze, friezes
[IFA] artifact, avifauna, bifacial, califate, intifada, bifarious, trifacial
[IFE] manifest, life, knife, jackknife, conifer, wife, serifed
[IFF] cliff, diff, jiffy, sniff, stiff, tiff, riff
[IFI] modified, specified, identifier, classifier, scientific, certificate, significant
[IFL] rifle, trifle, stifle, oriflamme, semifluid, persiflage, uniflorous
[IFO] uniform, cuneiform, manifold, nonuniform, trifoliate, californium, cruciform
[IFR] kiwifruit, antifriction, ossifrage, saxifrage, antifreeze, dentifrice, kiwifruits
[IFS] ifs, serifs, motifs, kalifs, coifs, massifs, naifs
[IFT] shift, fifth, lift, sift, redshift, drift, swift
[IFU] beautiful, centrifugal, pitiful, plentiful, bifurcation, dutifully, mercifully
[IFY] modify, simplify, verify, specify, notify, justify, unify
[IGA] ligature, digamma, navigation, litigation, obligations, investigate, abigail
[IGE] digest, negligence, eigenvalues, beige, eigenvectors, tiger, intelligence
[IGF] bigfoot, pigfish
[IGG] trigger, bigger, wiggly, squiggle, digging, piggy, swigging
[IGH] bright, high, light, night, sight, height, right
[IGI] original, digit, rigid, eligible, sigil, aboriginal, intelligible
[IGL] piglet, aiglet, diglot, siglos, wiglet, igloo, inveigle
[IGM] sigma, stigma, enigma, pigment, paradigm, figment, astigmatism
[IGN] align, design, foreign, reign, sign, ignore, assign
[IGO] trigon, indigo, rigorous, marigold, oligopoly, amigo, chigoe
[IGP] pigpen, pigpens
[IGR] digraph, epigraph, migration, trigram, pedigree, centigrade, calligraphy
[IGS] figs, zigs, jigsaw, swigs, pigs, rigsdaler, digs
[IGT] pigtail, pigtails, pigtailed
[IGU] figure, contiguous, ambiguous, configure, ligula, disambiguate, unambiguous
[IGW] bigwig, wigwag, figwort, pigweed, wigwam, wigwagged, wigwagging
[IGY] epigynous, effigy, prodigy, perigynous
[IGZ] zigzag, zigzagged, zigzagger, zigzagging, zigzags
[IHA] jihad, antihalation, jihadist, jihads, jihadists
[IHE] dihedral, maihem, antihero, clerihew, perihelia, trihedral, hemihedral
[IHI] annihilator, nihil, bahuvrihi, annihilation, annihilate, annihilators, annihilated
[IHO] likelihood, hardihood, lustihood, livelihood, unlikelihood, likelihoods, livelihoods
[IHR] mihrab, ihram
[IHU] chihuahua, antihumanism, chihuahuas
[IHY] dihybrid, dihydric, trihydric, hemihydrate
[IID] saturniid, saturniids
[IIF] coraciiform
[III] iii, viii, xviii, xiii, xxviii, xxxiii, xxiii
[IIN] skiing, coniine, piing, taxiing, alibiing, safariing, shanghaiing
[IIT] shiitake, shiitakes
[IJA] hijab, ouija, jipijapa, hijabs, hijack, hijacker, hijacking
[IJE] bijection
[IJO] bijoux, demijohn, skijoring, bijou, bijouterie, demijohns
[IJU] bijugate, marijuana, unijugate
[IKA] mikado, troika, likably, palikar, paprika, shikari, kamikaze
[IKD] sheikdom, sheikdoms
[IKE] like, unlike, strike, mike, alike, spike, bike
[IKH] sheikh, sheikhs
[IKI] wiki, biking, hiking, liking, viking, spiking, striking
[IKK] likker
[IKN] antiknock, camiknickers
[IKO] daikon, eikon, aniseikonia, daikons, aniseikonias
[IKS] shiksa, refuseniks, batiks, mujiks, moujiks, muzhiks, susliks
[IKT] diktat, diktats
[IKU] haiku, likuta
[IKV] mikvah, mikveh, mikvos, mikvot, mikva, mikvoth
[IKY] spiky
[ILA] available, similar, compilation, dilation, unavailable, filament, annihilator
[ILB] mailbox, gilbert, sailboat, bilbo, trilby, astilbe, filbert
[ILC] oilcan, filch, milch, pilch, zilch, railcard, tailcoat
[ILD] build, child, tilde, wild, rebuild, grandchild, unbuild
[ILE] file, while, compile, failed, tile, percentile, profile
[ILF] pilfer, pailful, toilful, wailful, milf, oilfield, sailfish
[ILG] pilgrim, gilgai, nilgai, bilge, squilgee, tailgate, pilgarlic
[ILH] silhouette, nailhead, railhead, bilharzia, jailhouse, philhellene, unnilhexium
[ILI] utility, liability, auxiliary, possibility, probability, capabilities, tilings
[ILK] ilk, milk, silk, bilker, soymilk, devilkin, buttermilk
[ILL] bill, chill, hill, mill, skill, will, fill
[ILM] film, mailman, microfilm, oilman, refilm, ailment, biofilm
[ILN] kiln, evilness, limekiln, brickkiln, frailness, kilned, kilning
[ILO] epsilon, upsilon, kilogram, pilot, bailout, epilogue, philosophy
[ILP] megilp, pilpul, tailpipe, sailplane, unnilpentium, tailpiece, tailplane
[ILQ] milquetoast, unnilquadium, milquetoasts
[ILR] railroad, devilry, milreis, tailrace, daredevilry, railroader, railroading
[ILS] details, fails, coils, tails, thumbnails, emails, whilst
[ILT] filter, built, quilt, gilt, prebuilt, tilt, rebuilt
[ILU] failure, diluted, nautilus, filum, hilum, poilu, silurid
[ILV] silver, quicksilver, silva, silvern, silvery, silverfish, silverside
[ILW] railway, tailwind, toilworn, mailwoman, councilwoman, railways, railwayman
[ILY] family, easily, necessarily, temporarily, lazily, daily, primarily
[IMA] image, estimator, decimal, minimalist, optimal, primary, animation
[IMB] climb, imbue, limb, nimble, imbalance, gimbal, imbrication
[IMC] kimchi, gimcrack, gimcrackery, gimcracks
[IME] time, prime, dimension, disclaimer, runtime, mime, experimental
[IMF] flimflam, brimful, flimflammed, flimflammer, flimflammery, flimflamming, flimflams
[IMI] limit, similar, optimize, primitive, timing, minimize, delimiter
[IMJ] jimjams
[IML] dimly, gimlet, aimless, rimless, brimless, slimline, victimless
[IMM] immediate, immutable, trimmed, swimming, dimmed, jimmy, imminent
[IMN] chimney, limn, dimness, dislimn, grimness, primness, slimness
[IMO] timothy, primo, antimony, kimono, unanimous, parsimonious, ultimo
[IMP] chimp, impact, limp, shrimp, simple, import, implied
[IMR] nimrod, rimrock, primrose, nimrods, primroses
[IMS] claims, dims, disclaims, crimson, trims, sims, aims
[IMU] maximum, minimum, optimum, simulate, azimuth, stimulate, primus
[IMW] dimwitted, swimwear, dimwit, dimwits
[IMY] slimy, limy, daimyo, grimy, rimy
[INA] binary, original, final, coordinate, terminal, imaginary, combination
[INB] rainbow, pinball, inbox, finback, inbeing, shinbone, steinbok
[INC] include, since, incr, incidental, incompatible, distinct, inch
[IND] index, find, kind, indices, window, bind, remainder
[INE] line, define, undefined, engine, inline, container, newline
[INF] info, infer, infinity, infringement, inflate, infrequent, mainframe
[ING] bring, king, ring, sing, wing, string, using
[INH] sinh, inherited, inhibit, inhalation, inherently, disinherit, inhabited
[INI] initial, finite, minimum, definition, containing, infinity, combining
[INJ] inject, injury, ninja, popinjay, uninjured, injected, injection
[INK] blink, drink, link, pink, think, shrink, unlink
[INL] inline, mainly, plainly, inlet, certainly, thinly, inlay
[INM] containment, sustainment, binman, inmate, inmesh, inmost, chainman
[INN] inner, beginning, binned, pinned, spinner, winner, grinning
[INO] minor, binomial, domino, quinone, rhino, terminology, merino
[INP] input, pinpoint, inpour, tinpot, brainpan, pinprick, drainpipe
[INQ] inquire, relinquish, cinque, clinquant, chinquapin, delinquent, quinquefid
[INR] inrush, jinrikisha, inroad, inroads, inrushes, jinrikishas
[INS] insert, instead, contains, inside, against, plugins, bins
[INT] int, point, print, maintained, constraints, joint, endpoint
[INU] minus, continue, sinusoidal, terminus, diminution, discontinued, platinum
[INV] invalid, inverse, invoke, invisible, invitations, invt, reinvent
[INW] inward, pinwheel, wainwright, chinwag, tinware, brainwash, rainwater
[INX] jinx, minx, sphinx, meninx, pinxit, syrinx, salpinx
[INY] tiny, shiny, pinyin, winy, rainy, briny, vinyl
[INZ] quinze, winze
[IOA] radioactive
[IOB] niobium, idioblast, radiobiology, sociobiology, spongioblast, niobic, niobous
[IOC] ioctl, biochemistry, idiocy, mediocre, manioc, brioche, carioca
[IOD] period, diode, triode, aperiodic, iodine, labiodental, iodate
[IOE] bioethics, dioecious, bioecology, bioengineer, radioelement, intaglioed, mustachioed
[IOF] biofilm, bibliofilm, craniofacial, semiofficial, biofeedback, biofilms
[IOG] bibliography, biog, radiographs, angiogram, audiogenic, cardiogram, heliograph
[IOI] cardioid, opioid, gobioid, chorioid, blennioid, radioisotope, opioids
[IOL] violin, biological, sociology, physiology, radiological, vitriol, epidemiology
[IOM] axiom, idiom, biomechanics, biomedical, radiometric, biometrics, unidiomatic
[ION] action, lion, million, onion, potion, version, function
[IOP] diopter, calliope, biopic, cioppino, idiopathy, idiophone, idioplasm
[IOR] prior, behavior, interior, superior, exterior, inferior, posterior
[IOS] ratios, scenarios, studios, folios, adios, radios, portfolios
[IOT] iota, chariot, idiot, riot, heliotrope, compatriots, biota
[IOU] previous, various, tortious, obvious, serious, spurious, malicious
[IOV] labiovelar, audiovisual, audiovisuals
[IOX] dioxin, trioxide, amphioxus, antioxidant, sesquioxide, dioxide, dioxins
[IOZ] heliozoan, heliozoans
[IPA] bipartite, principal, multipart, participant, anticipate, antiparallel, nipa
[IPB] clipboard, hipbath, chipboard, shipboard, shipbuilder, clipboards, hipbone
[IPC] tipcat, ripcord, slipcase, whipcord, slipcover, ripcords, slipcases
[IPE] pipe, wiper, recipe, stripes, viper, sniper, bagpipe
[IPF] shipfitter, worshipful, worshipfully
[IPH] cipher, encipher, decipher, periphery, epiphany, diphthong, aliphatic
[IPI] recipient, piping, incipit, precipitate, striping, lipid, occipital
[IPJ] skipjack, skipjacks
[IPK] pipkin, slipknot, slipknots
[IPL] multiple, triple, principles, discipline, diploma, biplane, participle
[IPM] equipment, chipmunk, shipman, midshipman, gossipmonger, reshipment, transhipment
[IPN] dipnoan, hipness, slipnoose
[IPO] lollipop, dipole, antipodal, tripod, bipolar, lipoproteins, ipomea
[IPP] skipped, clipped, snippet, stripped, flipped, zipped, hippo
[IPR] reciprocal, equiprobable, lipread, semipro, gossipry, dandiprat, antiproton
[IPS] ellipse, skips, tips, strips, chips, lips, clips
[IPT] description, script, subscript, superscript, elliptic, receipt, manuscript
[IPU] manipulate, stipulates, multipurpose, slipup, euripus, guipure, occiput
[IPW] tripwire, shipway, slipway, tulipwood, shipworm, shipwreck, shipwright
[IPY] stripy, gossipy, shipyard, antipyrine, callipygean, antipyresis, antipyretic
[IQU] antique, boutique, clique, liquid, unique, oblique, technique
[IRA] hiragana, spiral, expiration, undesirable, desirable, giraffe, naira
[IRB] airborne, hairbreadth, airbrush, airburst, choirboy, chairborne, airbases
[IRC] circuit, haircut, semicircle, birch, encircle, staircase, zirconium
[IRD] third, weird, bird, songbird, girder, firebird, seabird
[IRE] required, direct, desired, indirect, entire, redirect, undirected
[IRF] airfare, airflow, airfoil, airfield, airframe, airfreight, airfares
[IRG] virgin, airglow, dirge, hairgrip, fairground, virgule, virga
[IRH] dirham, airhead, stairhead, dirhams, airheads, stairheads
[IRI] spirit, iris, empirical, requiring, pairing, acquiring, expiring
[IRK] dirk, irk, quirk, shirk, smirk, firkin, chirk
[IRL] girl, fairly, swirl, airline, twirl, whirl, hairline
[IRM] affirmer, confirm, firm, chairman, unconfirmed, airman, infirm
[IRN] fairness, unfairness, dirndl, bairn, cairn, hairnet, firn
[IRO] environment, iron, cruzeiro, giro, pirogi, andiron, midiron
[IRP] chirp, airplane, hairpin, airports, stirps, extirpate, chairperson
[IRQ] cirque, cirques
[IRR] mirror, irrational, irrevocable, irrelevant, irreducible, squirrel, irregular
[IRS] first, pairs, stairs, theirs, heirs, repairs, kirsch
[IRT] virtual, dirty, shirt, thirty, birth, undershirt, girth
[IRU] viruses, jabiru, hirudin, spirula, babirusa, antivirus, arbovirus
[IRV] nirvana, clairvoyant, clairvoyance, clairvoyants
[IRW] pairwise, airway, fairway, hairworm, stairway, chairwoman, repairwoman
[IRY] airy, fairy, expiry, hairy, dairy, glairy, inquiry
[IRZ] mirza
[ISA] disable, nuisance, advisable, misaligned, visage, paisa, palisades
[ISB] misbehave, cicisbeo, disburse, misbrand, disbranch, misbecome, misbelief
[ISC] disclaimer, discrete, misc, discovery, discussion, discarded, disconnect
[ISD] jurisdiction, wisdom, misdirected, disdain, misdealt, misdoing, unwisdom
[ISE] raise, otherwise, piecewise, advised, noise, exercise, pairwise
[ISF] satisfy, unsatisfied, misfit, dissatisfied, disfrock, disfeature, disfavor
[ISG] disguise, misguided, disgraced, misgiven, cisgender, misgovern, disgruntle
[ISH] dish, fish, polish, radish, wish, english, published
[ISI] visible, precision, arising, decision, division, revision, advertising
[ISJ] disjoint, disjunction, misjudge, misjoinder, disjunctive, disjoin, disjunctions
[ISK] asterisk, disk, risk, whiskers, frisk, basilisk, bisk
[ISL] islands, misleading, isle, dislike, legislation, paisley, mislabels
[ISM] optimism, prism, realism, tourism, organism, mismatch, mechanism
[ISN] misnamed, misnomer, puisne, misnumber, whatshisname, misnomers, misname
[ISO] comparison, isolated, divisor, isomorphic, isotope, bison, isosceles
[ISP] display, lisp, whisper, frontispiece, misplaced, redisplay, hemisphere
[ISQ] risque, bisque, disquisition, disqualified, misquote, odalisque, disquieted
[ISR] disrupt, misread, disregard, disregarded, disregarding, disruption, disruptive
[ISS] missing, issue, permission, kiss, mantissa, transmission, admission
[IST] artist, fist, list, twist, wrist, dist, exist
[ISU] visual, misused, disulfide, leisure, disunion, nonvisual, nisus
[ISV] disvalue, misvalue
[ISW] misword, semisweet, trelliswork, miswrite
[ISY] noisy, daisy, cramoisy, pleurisy, hypocrisy, disyllabic, trisyllable
[ITA] capital, italic, limitation, digital, orbital, editable, suitable
[ITB] spitball, politburo, spitballs, politburos
[ITC] switch, pitch, witch, ditch, fitch, kitchen, stitching
[ITE] write, item, finite, limited, literal, white, iterable
[ITF] spitfire, pitfall, fruitful, unfruitful, fitful, titfer, deceitful
[ITG] zeitgeist, zeitgeists
[ITH] faith, pith, smith, with, either, algorithm, neither
[ITI] initial, position, conditions, additional, definition, writing, partition
[ITJ] straitjacket
[ITK] kibitka
[ITL] title, explicitly, subtitle, implicitly, entitled, untitled, retitle
[ITM] bitmap, commitment, litmus, pitman, fitment, titmice, leitmotif
[ITN] fitness, witness, meitnerium, explicitness, jitney, licitness, tacitness
[ITO] repository, capacitor, editor, monitor, visitor, territory, triton
[ITP] nitpick, agitprop, waitperson, nitpicker, nitpicking, nitpicks, nitpicked
[ITR] arbitrary, nitrogen, citrus, vitriol, positron, mitral, titrant
[ITS] its, limits, traits, units, digits, bits, splits
[ITT] written, permitted, fitted, little, omitted, splitter, emitted
[ITU] substitute, institute, magnitude, amplitude, situation, constitutes, latitude
[ITW] nitwit, knitwear, creditworthy, nitwits
[ITY] utility, liability, entity, density, opacity, identity, infinity
[ITZ] blitz, glitz, kibitz, spritz, fritz, howitzer, britzka
[IUM] medium, chromium, consortium, equilibrium, sodium, trapezium, symposium
[IUN] multiunit, triune, aliunde, antiunion, triunity
[IUP] wikiup, wickiup, wickiups
[IUR] diurnal, demiurge, sciurine, semidiurnal, diuresis, diuretic, sciuroid
[IUS] radius, denarius, genius, dupondius, medius, congius, sardius
[IUT] qiviut, prosciutti, prosciutto
[IVA] derivative, private, equivalent, activate, multivariate, deactivate, survival
[IVE] given, active, native, negative, positive, relative, derivative
[IVI] divide, individual, connectivity, trivial, activity, giving, sensitivity
[IVO] pivot, ivory, divorced, unequivocal, semivowel, survivors, omnivore
[IVR] livre, livraison
[IVS] shivs, spivs, leitmotivs
[IVU] divulge, rivulet, redivivus, divulgate, divulsion, divulgence, divulged
[IVV] skivvy, civvies, divvy, flivver, divvied, divvies, divvying
[IVY] ivy, chivy, privy, tantivy, jivy, chivying
[IWA] antiwar, diwan, taxiway, williwaw, galliwasp, kittiwake, diwans
[IWE] skiwear, biweekly, triweekly, semiweekly, biweeklies, semiweeklies
[IWI] kiwi, periwinkle, iwis, bailiwick, pilliwinks, contrariwise, kiwifruit
[IWO] golliwog, polliwog, antiworld, handiwork, golliwogs, polliwogs
[IXA] fixation, affixation, suffixation, mixable, fixations, fixable, fixate
[IXE] fixed, mixed, pixel, prefixed, suffixes, postfixes, affixes
[IXF] sixfold
[IXI] mixing, fixing, elixir, prefixing, suffixing, nixing, affixing
[IXL] prolixly
[IXO] quixotic, mixology, quixotry, quixotism, mixologist, quixotically, quixotisms
[IXP] sixpence, sixpenny, sixpences
[IXS] sixshooter
[IXT] fixture, mixture, sixth, twixt, betwixt, ixtle, admixture
[IYA] aliyah, ouguiya, riyal, rufiyaa, hiya, sukiyaki, teriyaki
[IYE] biyearly, kaffiyeh, keffiyeh, multiyear, semiyearly
[IZA] optimization, organization, quantization, minimization, localization, serializable, utilization
[IZC] vizcacha
[IZD] samizdat, samizdats
[IZE] size, parametrize, normalize, optimize, initialize, minimize, quantize
[IZG] fizgig, fizgigs
[IZI] sizing, resizing, utilizing, minimizing, optimizing, normalizing, initializing
[IZK] whizkid
[IZM] gizmo, quizmaster, gizmos, quizmasters
[IZO] horizontal, schizo, epizoa, chorizo, mestizo, rhizoid, recognizor
[IZU] seizure, seizures
[IZY] dizygotic
[IZZ] blizzard, dizzy, fizz, pizza, swizzle, quizzes, grizzly
[JAB] jabber, jabs, jabiru, hijab, jabot, jab, jabberwocky
[JAC] adjacent, jack, nonadjacent, hijack, lumberjack, carjack, jacal
[JAD] jade, jading, jaded, jadeite, jadedness, jadedly, jades
[JAE] jaeger, jaegers
[JAG] jag, jagged, jags, jaggies, jaguar, jaggery, jaggy
[JAH] rajahs, maharajah, mujahidin, hallelujah, mujaheddin, rajah, maharajahs
[JAI] jails, jailer, jail, jailbird, jailbreak, jailhouse, jailed
[JAK] jakes, sanjak, jakeses
[JAL] jalopy, jalap, jalapeno, jalousie, jalopies, jalapenos, jalousies
[JAM] jam, benjamin, logjam, pajama, jimjams, sjambok, unjam
[JAN] jane, jangle, sejant, janitor, panjandra, jangly, jangler
[JAP] japan, japery, japonica, jipijapa, japing, japanned, jape
[JAR] jar, ajar, nightjar, jargon, jarring, jars, jarful
[JAS] jasper, jasmine, ganjas, ninjas, ouijas, jasmines
[JAT] jato, jatos
[JAU] jaunty, unjaundiced, jaunt, jaundice, jauntily, jaundiced, jauntiness
[JAV] java, javelin, javelins
[JAW] jaw, lockjaw, jaws, jawbone, jawless, jawline, jawbreaker
[JAY] jay, deejay, veejay, popinjay, jayvee, jaybird, jaywalk
[JAZ] jazz, jazzed, jazzes, jazzier, jazzy, jazzily, jazzman
[JEA] jean, jealous, serjeant, bluejeans, jeans, jealousy, jealously
[JEB] djebel, jebel
[JEC] eject, inject, object, project, reject, subject, conjecture
[JEE] jeering, jeep, jeez, jeer, jeered, jeerer, jeepers
[JEF] jefe
[JEH] jehu
[JEJ] jejuna, jejune, jejunal, jejunum, jejuneness, jejunely, jejunenesses
[JEL] jellyfish, jellybean, fjeld, djellaba, jellylike, jellyroll, jellabas
[JEM] jemadar, jemmy, jemmied, jemmies, jemmying
[JEN] jennet, jenny, jennets, jennies
[JEO] jeopardize, jeopardy, jeopardous, jeopardized, jeopardizes, jeopardizing
[JEP] cajeput
[JEQ] jequirity
[JER] jersey, jerry, jerky, jerboa, jerid, jeremiad, jeroboam
[JES] jester, jess, majesty, hajjes, hajes, rajes, kopjes
[JET] jet, objet, fanjet, ramjet, propjet, turbojet, electrojet
[JEW] jew, bejewel, jewel, jewels, jeweler, jewelry, jewfish
[JEZ] jezebel, jezebels
[JIB] jibbed, jibe, jibing, jibs, jibber, jibbing, jib
[JID] masjid, musjid, masjids, musjids
[JIF] jiffies, jiffy, jiff, jiffs
[JIG] jig, thingamajig, thingumajig, rejigs, jiggle, jigsaw, jigs
[JIH] jihad, jihadist, jihads, jihadists
[JIK] moujik, mujik, mujiks, moujiks
[JIL] jill, jilt, jillion, jilted, jilting, jilts
[JIM] jimmy, jimjams, jimsonweed, jimmied, jimmies, jimmying
[JIN] jingle, jinni, jink, jinx, jinrikisha, djinni, jingled
[JIP] jipijapa
[JIS] emojis, hajjis, basenjis
[JIT] jitter, fajita, jitney, jujitsu, jittery, fajitas, jitters
[JIV] jivey, jiva, jivy, jiving, jive, jived, jiver
[JJE] hajjes
[JJI] hajji, hajjis
[JNA] prajna
[JOA] joannes
[JOB] jobs, jobbed, jojoba, blowjob, jobless, jobholder, stockjobber
[JOC] jock, jocular, jocose, jockey, jockeys, jocks, jocund
[JOD] jodhpur, jodhpurs
[JOE] joey, joeys
[JOG] jogger, jogs, joggle, jog, joggling, jogged, jogging
[JOH] john, johannes, demijohn, johnny, johns, johnnycake, johnnies
[JOI] join, adjoint, disjoint, subjoined, conjoined, rejoin, nonjoiner
[JOJ] jojoba
[JOK] joker, jokingly, joke, jokier, jokily, joking, jokey
[JOL] jolt, jolly, cajole, majolica, jolter, cajoler, jollify
[JON] mahjong, jonquil, donjon, jongleur, currajong, kurrajong, donjons
[JOO] jook
[JOR] major, fjord, jor, marjoram, skijoring, pejoration, majority
[JOS] josh, joss, jostle, chaparajos, banjos, mojos, josher
[JOT] jot, jottings, jotted, jotter, jotting, jota, jotters
[JOU] joule, journal, joust, sojourn, kilojoule, megajoule, bijoux
[JOV] jovial, joviality, jovially
[JOW] jowly, jowl, jowlier, jowls, jowliest
[JOY] enjoyment, joy, killjoy, overjoy, enjoyable, unenjoyable, enjoy
[JUA] marijuana
[JUB] jubilee, jubbah, jujube, juba, jube, jubilant, jubilate
[JUD] judge, judicial, judo, prejudice, unprejudiced, judder, adjudge
[JUG] conjugal, jug, bijugate, subjugate, unijugate, juggle, juggler
[JUI] juice, verjuice, juicer, juicily, juicy, juiciness, juiced
[JUJ] jujube, jujitsu, juju, jujubes, jujus
[JUK] jukebox, juke, jukeboxes
[JUL] julep, julienne, juleps
[JUM] jump, jumbo, buckjump, showjumping, smokejumper, jumps, jumper
[JUN] junk, conjunction, junction, junior, disjunction, jungle, subjunctive
[JUP] cajuput, jupon
[JUR] jurisdiction, conjure, injury, jura, jury, juridical, abjure
[JUS] just, adjust, readjust, unjustified, majuscule, unadjusted, jussive
[JUT] jut, adjutant, coadjutor, jutted, jutting, jutty, jute
[JUV] juvenal, adjuvant, rejuvenate, juvenile, juvenilia, juvenility, juvenilize
[JUX] juxtapose, juxtaposed, juxtaposes, juxtaposing, juxtaposition
[KAA] markkaa
[KAB] breakable, clickable, checkable, unbreakable, lockable, nonbreakable, kab
[KAC] kachina, backache, backaches
[KAD] blockade, kadi, mikado, cockade, kaddish, lackaday, stockade
[KAE] polkaed
[KAF] kafir, kaffiyeh, kaffeeklatch, kafirs
[KAG] package, linkage, shrinkage, breakage, prepackaged, leakage, repackaged
[KAH] hookah, kahuna, punkah, sukkah, alkahest, workaholic, hookahs
[KAI] kail, kaiser, kain, kaiak, kaif, polkaing, kaisers
[KAJ] kinkajou, kinkajous
[KAK] kakapo, kakemono, kaki, kaka, kakis
[KAL] alkali, kale, kali, kalpak, lookalike, jackal, kalmia
[KAM] kami, kamala, kampong, kamseen, kame, dekameter, hackamore
[KAN] kangaroo, kanji, katakana, kana, alkanes, kantar, askance
[KAO] kaon, kaolin, kaons, kaoliang, kaolinite, kaoliangs, kaolinites
[KAP] kappa, kaph, kakapo, kapok, kaput, okapi, chinkapin
[KAR] karma, workaround, karate, karst, chukar, kaross, palikar
[KAS] kasher, jackass, ukase, burkas, parkas, polkas, tankas
[KAT] katakana, skate, cockatoo, meerkat, rollerskate, katydid, katabasis
[KAU] kauri, kauris
[KAV] kava, kavas
[KAW] breakaway, rockaway, walkaway, walkaways, breakaways
[KAX] pickax, pickaxed, pickaxes, pickaxing
[KAY] kayak, kayo, okay, tokay, kayaks, okays, kayaking
[KAZ] kamikaze, kazoo, kazachok, kazoos, kamikazes
[KBA] trackball, taskbar, sickbay, workbag, brickbat, kickback, neckband
[KBE] blackberry, workbench, sickbed, backbeat, inkberry, hackberry, backbend
[KBI] backbit, duckbill, hawkbill, blackbird, bookbinder, backbite, backbiter
[KBL] inkblot, backblocks, inkblots
[KBO] workbook, checkbox, cookbook, backbone, blackboard, linkboy, lockbox
[KBR] crackbrain, whiskbroom, backbreaker, stockbroker, stockbreeder, backbreaking, stockbroking
[KBU] hackbut, sackbut, stinkbug, blockbuster, blockbusting, hackbuts, sackbuts
[KCA] bankcard, blackcap, bookcase, crankcase, bankcards, blackcaps, bookcases
[KCH] blockchain, backchat, deckchair, backchats, deckchairs, blockchains
[KCL] backcloth, neckcloth, sackcloth, backcloths, neckcloths
[KCO] backcomb, blackcock, backcourt, backcombs, backcombed, blackcocks, backcombing
[KCR] backcross, bookcraft, backcrossed, backcrosses, backcrossing
[KCU] blackcurrant
[KDA] weekday, workday, jackdaws, backdate, blackdamp, weekdays, workdays
[KDO] markdown, breakdown, backdoor, sheikdom, crackdown, knockdown, markdowns
[KDR] backdrop, backdrops
[KEA] kea, skean, takeaway, shakeable, speakeasy, unlikeable, keas
[KEB] kebab, kebob, ikebana, jukebox, chokebore, pokeberry, snakebird
[KEC] keck, chokecherry, smokechaser
[KED] masked, marked, checked, stacked, linked, packed, chunked
[KEE] keep, bookkeeping, housekeeping, keen, keeling, zookeeper, safekeeping
[KEF] kef, wakeful, makefast, lakefront, yokefellow, keffiyeh, wakefulness
[KEG] keg, muskeg, skeg, kegler, muskegs, skegs, kegs
[KEH] stakeholder, rakehell, bakehouse, stokehold, smokehouse, stokehole, stokeholds
[KEI] keister, keitloa, skein, skeins, keisters
[KEJ] smokejumper
[KEL] likely, kelvin, skeleton, unlikely, kelly, nickel, berkelium
[KEM] pikeman, unkempt, brakeman, kakemono, leukemia, snakemouth, brakemen
[KEN] token, taken, broken, chicken, unbroken, ken, weekend
[KEO] strikeout, takeout, makeover, shakeout, stakeout, antitakeover, takeoff
[KEP] kept, skeptical, kepi, pikeperch, smokeproof, unkept, skepfuls
[KER] kernel, marker, worker, packer, checker, tracker, ticker
[KES] makes, takes, invokes, likes, snakes, spokes, stokes
[KET] bracket, socket, ticket, bucket, packet, market, pocket
[KEU] makeup, shakeup, makeups, shakeups
[KEV] kevel
[KEW] skew, likewise, lukewarm, askew, bikeway, cakewalk, pokeweed
[KEX] kex
[KEY] key, monkey, donkey, hockey, dickey, turkey, hickey
[KFA] breakfast, nakfa, rockfall, workfare, blackface, rockfalls, blackfaces
[KFE] talkfest, blackfellow
[KFI] backfill, jackfish, milkfish, monkfish, rockfish, weakfish, blackfish
[KFL] workflow, backflow, workflows, backflows
[KFO] taskforce, workforce, workforces
[KFR] jackfruit, breakfront, jackfruits, breakfronts
[KFU] thankfully, forkful, sackful, tankful, wreckful, chockfull, unthankful
[KGA] backgammon
[KGO] ginkgo, ginkgoes
[KGR] background, backgrounds, backgrounder
[KGU] blackguard, blackguards, blackguardly
[KHA] khaki, khan, backhand, kharif, charkha, khaddar, khamsin
[KHE] blockhead, blackheart, kheda, bulkhead, dickhead, lunkhead, crackhead
[KHO] workhorse, stockholders, backhoe, inkhorn, khoum, kolkhoz, markhor
[KHS] ankhs, lakhs, samekhs, sheikhs
[KIA] clarkia, kiang, skiable, rudbeckia, skiagraph, skiascope, skiagraphs
[KIB] kibitz, kibosh, kibble, kiblah, skibob, kibe, kibitzer
[KIC] kick, autarkic, dropkick, sidekick, placekick, kicker, kicks
[KID] kid, aikido, nonskid, skidded, whizkid, schoolkid, kids
[KIE] cookie, skier, stickies, brickies, trickier, kielbasa, bookie
[KIF] kif, skiff, skiffle, skiffs, skiffles
[KII] skiing
[KIJ] skijoring
[KIK] kike, kikes
[KIL] kill, kilogram, skill, kilometer, luckily, kilobyte, overkill
[KIM] kimono, skimmer, akimbo, kimchi, hakim, dybbukim, kimberlite
[KIN] kind, skin, checking, making, working, taking, looking
[KIO] kiosk, kiosks
[KIP] skip, kip, mudskipper, skipped, skipping, skips, skipper
[KIR] kirsch, fakir, kirtle, kirkman, kirmess, skirl, kirigami
[KIS] kiss, pinkish, darkish, hackish, wikis, skis, kish
[KIT] kit, toolkit, weskit, glaikit, rootkit, skite, sleekit
[KIU] wikiup, wickiup, wickiups
[KIV] skivvy, kiva, skive, skived, skiver, skives, skivers
[KIW] kiwi, skiwear, kiwifruit, kiwis, kiwifruits
[KIY] sukiyaki
[KJA] lockjaw, blackjack, blackjacks, blackjacked, blackjacking
[KJO] stockjobber, stockjobbers
[KJU] buckjump, buckjumper
[KKA] chukka, markka, sukkah, pukka, yakka, chukkar, markkaa
[KKE] bookkeeping, grokked, likker, yakked, yukked, chukker, trekked
[KKI] yakking, yukking, grokking, trekking, brickkiln, brickkilns
[KKN] jackknife, knickknack, jackknives, jackknifed, jackknifes, jackknifing, knickknacks
[KKO] dekko, dekkos
[KKU] hokku
[KKY] yukky
[KLA] klaxon, necklace, klatch, baklava, backlash, dockland, parkland
[KLE] pickle, booklet, sparkle, sprinkle, periwinkle, knuckle, speckle
[KLI] franklin, pickling, blacklist, checklist, sparkling, buckling, duckling
[KLO] backlog, folklore, workload, klong, kloof, cockloft, picklock
[KLU] kludge, klutz, kluge, mukluk, lackluster, klutzes, klutzier
[KLY] weakly, quickly, weekly, sickly, frankly, thickly, fickly
[KMA] bookmark, checkmark, hackman, workman, junkman, kirkman, linkman
[KME] linkmen, milkmen, workmen, stockmen, muskmelon, embankment, embarkment
[KMI] taskmistress
[KMO] folkmoot, bookmobile, bookmobiles
[KNA] knack, knapsack, knave, nickname, knawel, knapping, knapweed
[KNE] knead, knee, knell, knew, thickness, darkness, sickness
[KNI] knickers, knife, knight, knit, jackknife, knives, pyknic
[KNO] knob, knock, knoll, knot, know, unknown, acknowledge
[KNU] knuckle, knurl, locknut, knuckles, knuckled, knuckling, knur
[KOA] koala, skoal, koan, koalas, koa, skoals, koans
[KOB] kob, kobold, kobo, kobos, kobs
[KOC] leukocyte, leukocytic, leukocytes
[KOD] leukoderma, leukodermas
[KOE] koel, pekoe, shakoes
[KOF] checkoff, kickoff, knockoff, kickoffs, checkoffs, knockoffs
[KOH] kohl, kohlrabi, kohlrabies, kohls
[KOI] koi, kois, koine, koines
[KOK] kokanee
[KOL] kolo, cuckold, kolkhoz, kola, kolinsky, skol, tokoloshe
[KOM] komatik, drunkometer
[KON] reckon, beckon, daikon, eikon, koniology, misreckon, aniseikonia
[KOO] kook, cuckoo, koodoo, rockoon, kookaburra, kooks, kooky
[KOP] kop, kopeck, kopje, koph, kopjes, kopecks
[KOR] kor, einkorn, hickory, leukorrhea, kwashiorkor, koruna, korma
[KOS] kos, arkose, skosh, nonkosher, dekkos, geckos, pinkos
[KOT] koto, kotos
[KOU] checkout, breakout, knockout, blackout, lockout, koumis, cookout
[KOV] walkover, walkovers
[KOW] kowtow, kowtows, kowtowed, kowtower, kowtowing
[KOX] muskox, muskoxen
[KPA] backpack, backpacker, backpacking, backpacks, backpacked, backpackers
[KPE] chickpea, backpedal, workpeople, chickpeas, backpedals, backpedaled, backpedaling
[KPI] cockpit, duckpin, porkpie, crankpin, stickpin, neckpiece, stockpile
[KPL] workplace, backplate, bookplate, frankpledge, backplates, bookplates, workplaces
[KPO] checkpoint, breakpoints, jackpot, crackpot, duckpond, stinkpot, stockpot
[KPR] shockproof
[KRA] kraal, kraken, kraut, okra, kraft, buckra, krait
[KRE] kreutzer, kremlin, backrest, bookrest, kreplach, checkrein, kremlins
[KRI] krill, kris, krimmer, kukri, blitzkrieg, kriegspiel, blitzkriegs
[KRO] kroon, cockroach, krone, checkrow, darkroom, backroom, bankroll
[KRU] bankruptcy, kruller, krummhorn, krugerrand, bankrupt, bankrupts, bankrupted
[KRY] krypton, gimmickry
[KSA] shiksa, backsaw, bucksaw, hacksaw, rucksack, quicksand, packsaddle
[KSC] cockscomb, cockscombs
[KSE] backset, thickset, stickseed, bookseller, shuckses, backseat, backseats
[KSG] thanksgiving
[KSH] worksheet, milkshake, rickshaw, bookshelf, cockshy, buckshee, cookshop
[KSI] backside, banksia, dockside, worksite, folksiness, quicksilver, tricksier
[KSK] buckskin, sharkskin, buckskins
[KSL] backslash, backslashes, backslap, backslid, backslide, backslider, backslapped
[KSM] marksman, cracksman, jacksmelt, locksmith, blacksmith, marksmen, cracksmen
[KSN] jacksnipe, blacksnake, blacksnakes
[KSO] irksome, milksop, darksome, folksong, kicksorter, irksomeness, milksops
[KSP] backspace, workspace, cockspur, larkspur, lickspittle, backspaces, workspaces
[KST] lockstep, workstation, backstop, bookstore, kickstart, huckster, inkstand
[KSU] checksum, cocksure, tracksuit, cocksucker, tracksuits
[KSW] backswept, cockswain, markswoman, backswing, backsword, backswords
[KSY] tricksy, folksy
[KTA] cocktail, worktable, diktat, backtalk, ducktail, folktale, ticktack
[KTE] buckteeth
[KTH] breakthrough, buckthorn, blackthorn, buckthorns, blackthorns
[KTI] necktie, bhakti, tektite, hacktivist, sticktight, neckties, tektites
[KTO] desktop, nekton, cooktop, worktop, blacktop, plankton, ticktock
[KTR] backtrack, backtracking, backtracks, backtracked
[KUA] skua, skuas
[KUC] kuchen, lebkuchen, kuchens
[KUD] kudos, kudzu, kudu, kudzus, kudo, kudus
[KUK] kukri
[KUL] skull, karakul, kulak, ukulele, numskull, skullcap, skulk
[KUM] kumquat, bunkum, kumiss, kummel, hokum, oakum, kumquats
[KUN] skunk, kunzite, kuna, skunks, skunked, kunzites, skunking
[KUP] lookup, markup, backup, pickup, breakup, checkups, cockup
[KUR] kurtosis, kurbash, kurus, kurrajong, kurrajongs
[KUS] ruckus, ankus, ruckuses
[KUT] likuta, makuta
[KUV] kuvasz
[KVA] mikvah, kvass, mikva, kvasses
[KVE] kvetch, mikveh, kvetcher, kvetched, kvetches, kvetchers, kvetching
[KVO] mikvos, mikvot, mikvoth
[KWA] kwacha, kwanza, backward, awkward, shockwave, parkway, folkway
[KWE] inkwell, duckweed, hawkweed, milkweed, neckwear, rockweed, silkweed
[KWH] buckwheat
[KWI] clockwise
[KWO] bookworm, corkwood, hackwork, hookworm, linkwork, milkwort, muckworm
[KWU] knockwurst, knockwursts
[KWY] pkwy
[KYA] kyanite, backyard, dockyard, junkyard, kyat, brickyard, stockyard
[KYB] buckyball, dickybird, stickybeak, buckyballs, dickybirds
[KYC] skycap, skycaps
[KYD] alkyd, skydive, skydiver, skydiving, alkyds, skydived, skydives
[KYH] skyhook
[KYI] flunkyism, skying
[KYJ] skyjack, skyjacker, skyjacking, skyjacks, skyjacked, skyjackers, skyjackings
[KYL] kyle, skyline, alkyl, kylix, ankylose, skylines, skylark
[KYM] kymograph, kymographs
[KYN] alkyne
[KYP] kyphoses, kyphosis
[KYR] skyrocket, skyrockets, skyrocketed, skyrocketing
[KYS] skysail, whiskys, skyscape, skyscraper, skysweeper, skysails, skyscrapers
[KYW] skyway, skywalk, skyward, skywriter, skywriting, skywards, skywriters
[LAA] salaam, laager, laagers, salaams, salaamed, salaaming
[LAB] label, callable, syllable, available, relabel, unavailable, laboratory
[LAC] black, replace, place, slack, lack, interlace, displace
[LAD] ladder, laden, salad, blade, glad, lady, ladies
[LAE] formulae, alae, axillae, feculae, fibulae, nebulae, ampullae
[LAF] falafel, pilaf, sclaff, plafond, pilafs, sclaffs, falafels
[LAG] flag, lag, plage, anlage, village, slag, blag
[LAH] blah, fellah, hallah, kiblah, mullah, wallah, challah
[LAI] plain, disclaimer, claim, explain, complain, counterclaim, laid
[LAK] flake, lake, snowflake, lakh, kulak, slake, laky
[LAL] fallal, halala, slalom, molal, doolally, dyslalia, methylal
[LAM] lambda, exclamation, lams, clamp, llama, filament, lamp
[LAN] language, blank, plane, explanation, balanced, landscape, landmarks
[LAP] overlap, collapse, elapsed, lap, clap, flap, burlap
[LAQ] plaque, claque, claqueur, claques, plaques
[LAR] scalar, large, particular, declare, regular, similar, tabular
[LAS] class, last, subclass, slash, backslash, lasso, formulas
[LAT] latex, platform, relative, template, flat, calculate, translate
[LAU] clause, launchpad, umlaut, plausible, laughing, implausible, subclauses
[LAV] flavor, slave, lavender, clave, palaver, lava, lavish
[LAW] law, claw, flaw, outlaw, rollaway, bylaw, dewclaw
[LAX] relax, lax, galaxy, parallax, flax, klaxon, smilax
[LAY] layout, display, layer, playwright, delay, overlay, relay
[LAZ] lazy, lazily, blaze, lazar, plaza, ablaze, glazed
[LBA] toolbar, callback, fallback, rollback, pullback, albatross, kielbasa
[LBE] albeit, gilbert, mulberry, halberd, astilbe, filbert, bilberry
[LBI] albino, bulbil, oilbird, bellbird, jailbird, stilbite, hillbilly
[LBL] cellblock, chilblain, gallbladder, trailblazer, trailblazing, cellblocks, chilblains
[LBO] mailbox, toolbox, sailboat, stillborn, schoolbook, elbow, bilbo
[LBR] jailbreak, nailbrush, balbriggan, jailbreaks, balbriggans, nailbrushes
[LBS] bulbs, albs, flashbulbs
[LBU] album, bulbul, billbug, tilbury, lactalbumin, tolbutamide, albumen
[LBY] trilby
[LCA] volcano, skullcap, inculcating, alcaic, calcar, gelcap, lolcat
[LCE] dolce, calces, dulcet, ulcer, demulcent, discalced, chalcedony
[LCH] belch, filch, gulch, mulch, squelch, wheelchair, alchemical
[LCI] calcify, dulcify, sulci, analcite, decalcify, falciform, recalcitrant
[LCL] oilcloth, sailcloth, smallclothes, oilcloths
[LCO] falcon, welcome, alcove, unwelcome, balcony, ballcock, tailcoat
[LCR] fulcrum, fulcrums
[LCT] mulct, mulcts, mulcted, mulcting
[LCU] calculate, recalculate, precalculate, oilcup, sulcus, talcum, animalcule
[LCY] halcyon, normalcy, colonelcy
[LDA] foldable, holdall, beldam, goldarn, milldam, havildar, baldachin
[LDB] childbed, foldboat, holdback, goldbrick, moldboard, coldblooded, childbirth
[LDC] wildcard, childcare, goldcrest, wildcards, wildcat, wildcatted, wildcatter
[LDE] builder, tilde, folder, holder, placeholder, older, golden
[LDF] boldface, goldfish, wildfires, holdfast, baldfaced, fieldfare, oldfangled
[LDG] waldgrave
[LDH] childhood, baldhead, guildhall, baldheads, baldheaded, childhoods, guildhalls
[LDI] holding, building, folding, yielding, rebuilding, soldier, welding
[LDL] childless, mildly, wildly, worldly, baldly, boldly, coldly
[LDM] goldmine, childminder, childminding, goldmines, childminders
[LDN] boldness, oldness, baldness, coldness, mildness, wildness, manifoldness
[LDO] foldout, seldom, waldo, holdover, aldose, bulldog, dildo
[LDP] baldpate, childproof, fieldpiece, baldpates, childproofs, childproofed
[LDR] children, cauldron, pauldron, aldrin, baldric, chaldron, dieldrin
[LDS] fields, builds, yields, holds, thresholds, folds, wilds
[LDU] buildup, holdup, shelduck, skulduggery, holdups, buildups, shelducks
[LDV] worldview, worldviews
[LDW] worldwide, oldwife, wildwood, fieldwork, oldwives, fieldworker, fieldworkers
[LDY] wieldy, unwieldy, baldy, moldy
[LEA] boolean, clear, least, release, please, leading, leaf
[LEB] handlebars, celebration, plebby, glebe, bleb, anklebone, bumblebee
[LEC] select, collection, dialect, reflect, electron, deflection, intellectual
[LED] scaled, called, filled, failed, enabled, installed, handled
[LEE] sleep, bleed, lee, asleep, jubilee, fleecy, bailee
[LEF] left, copyleft, clef, olefin, baleful, doleful, malefic
[LEG] legend, legacy, illegal, delegate, telegraph, alleging, dogleg
[LEH] alehouse, lehr, molehill, tabouleh, tabbouleh, bufflehead, fiddlehead
[LEI] nuclei, lei, phthalein, aculei, mallei, pleiad, sleigh
[LEJ] applejack, supplejack, steeplejack, supplejacks, steeplejacks
[LEK] lek, telekinesis, telekinetic, leks
[LEL] parallel, solely, antiparallel, scaleless, nonparallel, allele, ukulele
[LEM] element, problem, implemented, complement, lemma, supplement, subproblem
[LEN] length, filename, equivalent, silent, calendar, blend, challenge
[LEO] leopard, chameleon, leone, nucleotide, napoleon, paleo, cleome
[LEP] aleph, telephone, elephant, lepton, slept, proleptic, telepathy
[LEQ] harlequin, harlequinade, harlequins
[LER] handler, tolerance, caller, compiler, smaller, scaler, filler
[LES] files, samples, examples, unless, less, modules, variables
[LET] let, complete, delete, palette, singleton, bullet, greenlet
[LEU] nucleus, sleuth, fleuron, leu, petroleum, isoleucine, coleus
[LEV] level, relevant, clever, levy, irrelevant, eleven, levin
[LEW] lewis, cableway, blew, flew, tumbleweed, curlew, alewife
[LEX] complex, lexer, circumflex, lexical, simplex, flex, perplexity
[LEY] galley, smileys, bailey, valley, pulley, trolleybus, volleyball
[LFA] welfare, alfalfa, sulfa, coalface, bisulfate, olfaction, solfatara
[LFB] halfback, halfbeak, halfbreed, halfbacks, halfbeaks
[LFC] halfcocked
[LFE] golfer, pilfer, telfer, pedalfer, woolfell, solfeggio, solferino
[LFF] wolffish
[LFH] selfheal, wolfhound, halfhearted, selfhood, wolfhounds
[LFI] fulfill, golfing, selfie, disulfide, unselfish, elfish, sulfide
[LFL] selfless, elfland, gallfly, damselfly, ballflower, bellflower, wallflower
[LFM] engulfment
[LFN] selfness
[LFO] malformed, fylfot, alforja, billfold, sulfonate, funnelform, malformation
[LFP] halfpence, halfpenny, halfpennies
[LFR] wolfram, palfrey, belfry, alfresco, bullfrog, girlfriend, schoolfriend
[LFS] wolfs, calfskin, selfsame, engulfs, golfs, gulfs, milfs
[LFT] halftone, twelfth, delft, halftones, halftime, delftware, halftrack
[LFU] malfunction, sulfur, bowlful, pailful, soulful, toilful, wailful
[LFW] halfway, gulfweed, halfwit, halfwitted, halfwits, gulfweeds
[LGA] vulgar, amalgamation, algae, realgar, gilgai, nilgai, belga
[LGE] bilge, bulge, divulge, indulge, algebraic, fulgent, squilgee
[LGH] bulghur, nylghau, bulghurs, nylghaus
[LGI] nostalgic, algid, myalgia, otalgia, ballgirl, coxalgia, bulginess
[LGO] algorithm, hidalgo, fulgor, algology, ballgown, feelgood, algometer
[LGR] pilgrim, eelgrass, woolgrower, hellgrammite, pilgrimage, pilgrimize, pilgrims
[LGU] vulgus, bulgur, valgus, fulgurant, kieselguhr, fulgurate, fulgurite
[LGY] bulgy
[LHA] pelham, keelhaul, bilharzia, camelhair, foolhardy, philharmonic, foolhardily
[LHE] metalhead, allheal, billhead, bullhead, nailhead, railhead, wellhead
[LHO] silhouette, bellhop, bullhorn, schoolhouse, billhook, girlhood, hellhole
[LIA] alias, liability, auxiliary, compliant, affiliates, reliable, civilian
[LIB] lib, glib, calibration, equilibrium, deliberate, uncalibrated, millibar
[LIC] license, public, slice, application, italic, policy, explicit
[LID] invalid, valid, slide, solid, euclidean, holidays, consolidate
[LIE] implied, client, applied, supplied, lie, earlier, outlier
[LIF] simplify, lift, qualified, amplifiers, life, nullify, unqualified
[LIG] align, light, ligature, highlight, negligence, slightly, obligations
[LIH] likelihood, livelihood, millihenry, unlikelihood, likelihoods, livelihoods, millihenries
[LII] lii, aalii, clii
[LIK] like, unlike, alike, liking, dislike, lookalike, plantlike
[LIL] lily, lilac, milliliter, holily, oilily, wilily, galilee
[LIM] limit, delimiter, eliminate, unlimited, prelim, climbing, lime
[LIN] line, link, inline, calling, newline, scaling, spline
[LIO] bibliography, folio, lion, millions, portfolio, dandelion, billion
[LIP] ellipse, clip, flip, lips, blip, lollipop, eclipse
[LIQ] clique, oblique, liquid, siliqua, aliquot, relique, applique
[LIR] lira, lire, flirty, delirium, liripipe, bilirubin, subdelirium
[LIS] list, english, published, minimalist, milliseconds, lisp, polish
[LIT] split, literal, utility, liability, little, equality, centrality
[LIU] helium, gallium, allium, thulium, nobelium, thallium, berkelium
[LIV] live, alive, olive, deliver, living, livre, outlive
[LIW] golliwog, polliwog, williwaw, bailiwick, galliwasp, pilliwinks, golliwogs
[LIX] helix, elixir, lix, bollix, prolix, cylix, kylix
[LIY] aliyah, aliyahs
[LIZ] normalize, initialize, serialized, finalize, localize, generalized, visualize
[LJO] killjoy, killjoys
[LKA] alkali, walkable, polka, yarmulka, antalkali, silkaline, talkathon
[LKB] chalkboard, chalkboards
[LKE] walker, alkene, bilker, milker, talker, caulker, skulker
[LKF] milkfish, talkfest
[LKH] kolkhoz, bulkhead, elkhound, bulkheads, elkhounds, kolkhozes
[LKI] walking, toolkit, talking, folkie, welkin, bulkily, erlking
[LKL] folklore, folkloric, folklorist, folkloristic, folklorists
[LKM] milkman, folkmoot, milkmen, milkmaid, milkmaids
[LKO] walkout, walkover, walkouts, walkovers
[LKS] walks, milkshake, folks, talks, stalks, kinfolks, menfolks
[LKT] folktale, folktales
[LKU] walkup
[LKW] folkway, walkway, milkweed, silkweed, milkwort, silkworm, folkways
[LKY] bulky, chalky, milky, silky, sulky, alkyne, stalky
[LLA] callable, syllable, dollar, cedilla, installation, collate, cancellation
[LLB] callback, fallback, rollback, stillborn, pullback, billboard, ballboy
[LLC] skullcap, spellcheck, hellcat, ballcock, wallchart, smallclothes, spellchecker
[LLD] bulldog, milldam, killdeer, helldiver, spelldown, thralldom, bulldoze
[LLE] called, collection, filled, parallel, installed, controlled, smaller
[LLF] gallfly, willful, billfish, bullfrog, fallfish, hellfire, skillful
[LLG] ballgame, tollgate, hellgrammite, ballgirl, ballgown, ballgames, ballgirls
[LLH] bellhop, bullhorn, allheal, billhead, hellhole, wellhead, dollhouse
[LLI] calling, ellipse, rolling, milliseconds, filling, falling, installing
[LLJ] killjoy, killjoys
[LLK] hellkite
[LLM] bellman, fulfillment, installment, rollmop, cellmate, hallmark, enrollment
[LLN] illness, dullness, fullness, tallness, gallnut, bullnose, wellness
[LLO] allow, following, yellow, hello, pillow, shallow, disallow
[LLP] wallpaper, ballpoint, cellphone, ballparks, bullpen, millpond, smallpox
[LLR] millrun, ballroom, bullring, grillroom, millrace, millruns, ballrooms
[LLS] calls, cells, nulls, falls, tells, shells, fills
[LLT] smalltalk, hilltop, telltale, pralltriller, smalltime, hilltops, telltales
[LLU] illustration, cellule, illuminant, pollute, collusion, vellum, tellurium
[LLW] bullwhip, hallway, rollway, tollway, bellwort, bollworm, millwork
[LLY] finally, actually, fully, really, usually, normally, specifically
[LMA] bellman, mailman, dolman, almanac, dalmatian, fulmar, oilman
[LMB] psalmbook
[LMD] filmdom
[LME] helmet, dolmen, palmer, fulfillment, installment, overwhelmed, oilmen
[LMI] facepalming, holmium, almighty, overwhelming, culminating, kalmia, balmily
[LML] calmly
[LMM] filmmaker, embalmment, filmmaking, filmmakers, embalmments
[LMN] calmness
[LMO] almost, salmon, pulmonic, rollmop, abelmosk, psalmody, goalmouth
[LMS] realms, palms, elms, films, psalms, qualms, almsman
[LMT] palmtop, palmtops
[LMU] almuce, almucantar
[LMY] balmy, filmy, palmy
[LNA] ulnae, ulnar, ulna, ulnas
[LNE] telnet, usefulness, vulnerable, illness, realness, dullness, fullness
[LNI] kilning
[LNO] bullnose, shovelnose, malnourished, bullnoses
[LNS] kilns, limekilns, brickkilns
[LNU] walnut, gallnut, hazelnut, malnutrition, walnuts, hazelnuts
[LOA] float, load, overload, download, payload, upload, reload
[LOB] global, blob, clobber, lobster, lobe, kilobyte, slob
[LOC] block, local, lock, clock, velocity, allocator, floc
[LOD] explode, implode, lode, plod, melody, lodge, unexploded
[LOE] loess, aloe, felloe, phloem, holloed, floe, sloe
[LOF] falloff, loft, aloft, hayloft, selloff, cockloft, toplofty
[LOG] log, dialog, catalog, blog, analog, kilogram, morphology
[LOH] kilohertz, aloha, mylohyoid, holohedral, cyclohexane, alohas
[LOI] exploit, tabloid, loin, cycloids, paraboloid, soloists, eloign
[LOJ] kilojoule, kilojoules
[LOK] blokes, bloke, blokish
[LOL] lollipop, philology, lolcat, salol, xylol, loblolly, lollygag
[LOM] coulomb, kilometer, shalom, glom, holomorphic, diploma, conglomerate
[LON] long, along, clone, colon, epsilon, upsilon, belonging
[LOO] loop, lookup, floor, loose, balloon, blood, outlook
[LOP] slope, envelope, developer, lop, colophon, flop, encyclopedia
[LOQ] loquitur, eloquence, colloquial, obloquy, loquacity, soliloquy, ineloquent
[LOR] color, dolor, floruit, explore, bachelor, folklore, lord
[LOS] close, loss, glossaries, lost, enclosed, blossom, losing
[LOT] plot, subplots, slot, lot, pilot, ballot, glottal
[LOU] cloud, loudspeaker, bailout, louis, loup, lout, flourish
[LOV] love, rollover, clover, gloves, sloven, plover, beloved
[LOW] allow, below, lower, following, flow, yellow, overflow
[LOX] lox, phlox, gloxinia, siloxane, phylloxera, pyrrhuloxia, loxodromes
[LOY] deployment, employment, alloy, unemployment, loyalty, caloyer, cloying
[LOZ] lozenge, gloze, holozoic, hylozoism, lozengy, lozenges
[LPA] wallpaper, culpa, alpaca, kalpak, ballpark, exculpate, calpac
[LPB] pulpboard
[LPE] helper, gulper, bullpen, scalpel, alpenglow, alpenhorn, alpenstock
[LPF] helpful, unhelpful, helpfully, helpfulness, unhelpfully
[LPH] alpha, dolphin, sylph, cellphone, delphinium, telpher, sulphone
[LPI] helping, mantelpiece, alpine, kelpie, pulpit, salpinx, sculpin
[LPL] helplines, volplane, sailplane, tailplane, ballplayer, googolplex, helplessness
[LPM] helpmate, helpmates
[LPO] ballpoint, whirlpool, eelpout, goalpost, heelpost, millpond, smallpox
[LPR] culprit, foolproof, shellproof, malpractice, culprits, malpractices
[LPS] helps, sculpsit, scalps, whelps, gulps, megilps, pulps
[LPT] sculpt, sculpted, sculptor, sculpture, sculptress, sculptural, sculpts
[LPU] pilpul
[LPW] pulpwood
[LPY] enthalpy, pulpy
[LQU] calque, pulque, catafalque, milquetoast, unnilquadium, calques, pulques
[LRA] kohlrabi, millrace, tailrace, kohlrabies, millraces, tailraces
[LRE] already, milreis
[LRI] alright, bullring, chivalric, cavalries, devilries, jewelries, revelries
[LRO] railroad, ballroom, poolroom, grillroom, chivalrous, schoolroom, unchivalrous
[LRU] walrus, bulrush, millrun, millruns, walruses, bulrushes
[LRY] rivalry, cavalry, devilry, jewelry, revelry, chivalry, hostelry
[LSA] salsa, balsamic, pulsar, woolsack, convulsant, balsam, balsa
[LSB] nielsbohrium
[LSC] foolscap, goalscorer, goalscorers
[LSE] else, false, impulse, pulse, bullseye, grilse, allseed
[LSG] palsgrave, palsgraves
[LSH] welsh, bolshie, mailshot, consulship, generalship, mantelshelf, marshalship
[LSI] falsified, pulsing, hillside, repulsion, propulsion, felsite, salsify
[LSK] oilskin, sealskin, oilskins
[LSM] bailsman, foilsman, spoilsman, wheelsman, bailsmen
[LSN] pilsner, pilsners
[LSO] also, compulsory, nelson, kelson, telson, fulsome, keelson
[LSP] allspice, tailspin, crawlspace, spoilsport, tailspins, crawlspaces, spoilsports
[LST] whilst, pollster, millstone, ulster, bolster, holster, oilstone
[LSW] smallsword
[LSY] ballsy, selsyn, palsy, minstrelsy, palsying
[LTA] delta, voltage, resultant, simultaneous, smalltalk, facultative, occultation
[LTB] saltbox, faltboat, saltboxes
[LTC] cultch, saltcellar, saltcellars
[LTD] meltdown, meltdowns
[LTE] filter, alternative, psalter, resulted, unaltered, tilted, defaulted
[LTF] faultfinder, faultfinding, faultfinders
[LTH] filth, health, stealth, wealth, although, commonwealth, maltha
[LTI] multi, resulting, builtin, royalties, penalties, defaulting, faculties
[LTL] faultless, guiltless, occultly, difficultly, faultlessly, guiltlessly
[LTM] voltmeter, voltmeters
[LTN] occultness
[LTO] altogether, melton, rialto, smalto, biltong, deltoid, hilltop
[LTP] saltpeter
[LTR] ultra, filtration, poultry, paltry, peltry, sultry, caltrop
[LTS] results, defaults, faults, alts, segfaults, halts, volts
[LTU] culture, agricultural, saltus, celtuce, multure, vulture, asphaltum
[LTW] beltway, saltwort, meltwater, basaltware, saltwater, saltworks, beltways
[LTY] penalty, royalty, novelty, difficulty, faulty, faculty, specialty
[LTZ] schmaltz, waltz, seltzer, waltzed, waltzer, waltzes, schmaltzy
[LUA] evaluate, unevaluated, valuable, luau, reevaluate, invaluable, devaluation
[LUB] club, lubricants, flub, lubber, blubber, soluble, voluble
[LUC] lucent, cluck, lucky, lucid, unlucky, reluctance, fluctuations
[LUD] include, exclude, kludge, prelude, conclude, preclude, occluded
[LUE] value, blue, eigenvalues, glue, influence, clue, confluent
[LUF] fluffy, bluff, luffa, sluff, fluff, bluffer, fluffily
[LUG] plugins, slug, luggage, beluga, kluge, colugo, deluge
[LUI] fluid, bluish, gluier, sluice, alleluia, semifluid, toluidine
[LUJ] hallelujah, hallelujahs
[LUK] lukewarm, mukluk, fluke, taluk, fluky, lukewarmness, flukes
[LUL] cellule, lulu, subcellular, alula, lullaby, ululant, petiolule
[LUM] columns, volume, pendulum, plum, curriculum, illuminant, alumni
[LUN] lunate, voluntary, lung, lunch, plunger, clunky, lune
[LUO] gluon, superfluous, fluorescent, toluol, fluorosis, fluorspar, fluoridate
[LUP] lupus, lupine, clupeid, pluperfect, voluptuary, lupulin, clupeoid
[LUR] plural, failure, blur, slurp, flurry, doublure, lur
[LUS] plus, cluster, flush, exclusive, modulus, inclusive, calculus
[LUT] absolute, solution, resolution, convolution, evolution, pluton, salute
[LUV] eluvium, fluvial, helluva, pluvial, alluvial, diluvial, effluvia
[LUX] deluxe, flux, influx, lux, afflux, efflux, hallux
[LVA] solvable, silva, resolvable, unsolvable, salvage, unresolvable, galvanic
[LVE] solve, resolve, convolve, themselves, twelve, involved, silver
[LVI] kelvin, solving, involving, resolving, halving, shelving, revolving
[LVO] salvo, fulvous, volvox, malvoisie, solvolysis, salvos
[LVU] valvule, volvulus, convolvulus, valvular, valvulitis, valvulitises
[LVY] dlvy
[LWA] always, railway, bulwark, hallway, malware, rollway, tollway
[LWE] thalweg, lwei, edelweiss, jewelweed, bellwether, pickerelweed, lweis
[LWH] bullwhip, bullwhips
[LWI] tailwind, whirlwind, tailwinds, whirlwinds
[LWO] awlwort, eelworm, bellwort, bollworm, mealworm, millwork, toilworn
[LWR] wheelwright, millwright, millwrights, wheelwrights
[LXE] calxes
[LXI] lxii, lxiv, lxix, clxii, lxi, clxiv, clxix
[LXV] lxvii, clxvii, lxvi, clxvi
[LYA] galyak, flyaway, halyard, kailyard, bellyache, polyamide, polyandry
[LYB] flyback, molybdenum, jellybean, bullyboy, mealybug, bellyband, chalybite
[LYC] polycyclic, glycine, lyceum, calycle, lychnis, billycan, phlyctena
[LYD] lyddite, dillydally, polydactyl, polydipsia, polydipsic, dillydallied, dillydallies
[LYE] polyethylene, lye, polyester, flyers, flyer, polyesters
[LYF] jellyfish, bellyful, gillyflower, bellyfuls, jellyfishes, gillyflowers
[LYG] polygon, lollygag, amblygonite, polygons, polygonal, polygraphic, polygamy
[LYH] polyhedron, tallyho, ballyhoo, hollyhock, polyhistor, polyhydric, polyhedral
[LYI] underlying, applying, lying, multiplying, relying, complying, supplying
[LYL] flyleaf, acrylyl, allyl, tolyl, jellylike, slyly, flyleaves
[LYM] lymph, polymorphic, copolymer, flyman, tallyman, endolymph, ginglymus
[LYN] lynch, lynx, polynomial, slyness, polynuclear, polyneuritis, lynched
[LYO] flyover, amblyopia, lyonnaise, lyophilic, lyophobic, glyoxaline, lyophilize
[LYP] glyphs, hieroglyph, eucalyptus, polypeptide, calypso, clypeus, flypast
[LYR] lyric, lyre, lyrate, ballyrag, bullyrag, collyrium, jellyroll
[LYS] polys, analysis, catalyst, lyse, lysine, alyssum, clyster
[LYT] analytic, electrolytic, polytechnic, catalytic, acolyte, elytron, flyte
[LYU] polyurethane
[LYV] polyvinyl, polyvalent, polyvalence, polyvalency
[LYW] flyweight, plywood, flywheel, newlywed, tiddlywink, collywobbles, flyway
[LYX] calyx, epicalyx, calyxes, epicalyxes
[LYZ] analyze, dialyze, catalyze, paralyze, polyzoan, pyrolyze, autolyzes
[LZA] colza, colzas
[LZO] calzone
[MAA] kamaaina
[MAB] presumably, flammable, inflammable, programmable, summable, reclaimable, estimable
[MAC] macro, machine, macs, grimacing, stomach, macaroni, macula
[MAD] made, handmade, remade, madness, madame, madden, madmen
[MAE] gemmae, maenad, maestro, maelstrom, chamaeleon, maenadic, maestoso
[MAF] maffick, mafia, permafrost, mafiosi, mafioso, mafias, mafficks
[MAG] image, damages, magic, magenta, magnitude, magnetic, magazine
[MAH] mahjong, mahogany, amahs, bimah, mahatma, tomahawk, mahlstick
[MAI] domain, main, email, remainder, mail, subdomain, mermaid
[MAJ] major, majesty, majuscule, thingamajig, thingumajig, majority, majors
[MAK] make, making, mako, remake, pacemaker, policymaker, comake
[MAL] small, normal, decimal, minimalist, optimal, female, formal
[MAM] mammal, mama, firmament, edamame, imamate, mamba, mamelon
[MAN] command, man, performance, roman, woman, german, human
[MAP] map, bitmap, semaphore, remap, unmapped, sitemap, photomap
[MAQ] maquette, maquiladora, maquis, maquiladoras
[MAR] mark, margin, smart, summary, benchmark, martin, grammar
[MAS] mask, master, mass, smash, sigmas, commas, unmasked
[MAT] format, matrix, match, math, estimator, information, material
[MAU] mauve, mauger, maul, maundy, maudlin, amauroses, mausoleum
[MAV] maven, mavis, primavera, maverick, mavens, mavises, mavericks
[MAW] maw, mawkin, mawkish, mawkishness, maws, mawkishly
[MAX] max, climax, disclimax, subclimax, anticlimax, premaxilla, submaxillary
[MAY] may, dismay, undismayed, maybe, mayo, mayor, maya
[MAZ] amaze, maze, mazy, mazard, mazuma, mazzard, smaze
[MBA] combat, samba, imbalance, gimbal, embargoed, wombat, embarcadero
[MBB] dumbbell, dumbbells
[MBD] lambda, climbdown, lambdas, lambdoid, lambdacism
[MBE] number, member, embedded, remember, lambert, renumber, unnumbered
[MBF] numbfish, dumbfound, dumbfounds, dumbfounded, dumbfounding
[MBH] dumbhead
[MBI] combining, ambiguous, zombie, climbing, disambiguate, unambiguous, alembic
[MBK] lambkin, lambkins
[MBL] amble, crumble, fumble, humble, tumble, preamble, ensemble
[MBM] enjambment, entombment, enjambments
[MBN] thumbnail, dumbness, numbness, thumbnails
[MBO] symbol, combo, limbo, emboss, trombone, bamboos, boombox
[MBP] bombproof, thumbprint, thumbprints
[MBR] cambric, embrace, membrane, sombrero, umbrella, imbrication, hombre
[MBS] thumbs, crumbs, breadcrumbs, combs, coulombs, bombs, limbs
[MBT] thumbtack, thumbtacks
[MBU] ambush, combust, humbug, nimbus, hamburg, rhombus, imbue
[MBW] dumbwaiter, dumbwaiters
[MBY] brumby, crumby, nimby, bombycid, bombycids
[MCA] tomcat, tramcar, tomcats, tramcars
[MCE] emcee, emceeing, emceed, emcees
[MCH] armchair, kimchi, armchairs
[MCI] circumcise, circumcised, circumcision, circumcises, circumcising
[MCO] plumcot, broomcorn, camcorder, plumcots, broomcorns, camcorders
[MCR] gimcrack, gimcrackery, gimcracks
[MCU] creamcups
[MDI] humdinger, humdingers
[MDO] filmdom, slumdog, slumdogs
[MDR] gumdrop, humdrum, gumdrops
[MDS] mdse
[MDU] dumdum, dumdums
[MEA] mean, measure, mead, meat, permeability, demean, mealy
[MEB] somebody, comeback, homeboy, endameba, amebocyte, lamebrain, homebody
[MEC] mechanism, biomechanics, mecca, smectic, gamecock, timecard, humectant
[MED] medium, immediate, named, assumed, transformed, disclaimed, performed
[MEE] meet, meerkat, shmeer, unmeet, schmeer, meed, meek
[MEF] tumefy, blameful, shameful, shamefaced, tumefacient, tumefaction, shamefulness
[MEG] omega, mega, smegma, megs, megilp, megohm, megrim
[MEH] somehow, meh
[MEI] meitnerium, meiny, meioses, vermeil, semeiology, gemeinschaft, meiosis
[MEK] samekh, ramekin, limekiln, gamekeeper, timekeeper, samekhs, timekeeping
[MEL] melt, timeline, namely, extremely, camel, gimel, melon
[MEM] member, memory, remember, nonmember, mems, sememe, memento
[MEN] element, menu, comment, argument, document, enhancement, environment
[MEO] timeout, someone, meow, cameo, romeo, flameout, bromeosin
[MEP] homepage, timepiece, mephitic, nameplate, someplace, flameproof, meperidine
[MER] numeric, merge, enumerate, transformer, disclaimer, timer, commercial
[MES] message, names, timestamp, frames, filenames, mesh, assumes
[MET] method, parameters, geometry, meta, metric, something, symmetric
[MEU] dormeuse, charmeuse, comeuppance, comeuppances
[MEV] whomever, primeval, primevally
[MEW] framework, somewhat, homework, mew, smew, timework, limewater
[MEX] cimex, remex
[MEY] blimey, homey, limey, mamey, samey, gorblimey, homeyness
[MEZ] mezcal, mezzanine, timezone, mezuza, mezereon, mezzotint, intermezzi
[MFE] chamfered, chamfer, chamfering, chamfers
[MFI] comfit, drumfire, discomfit, formfitting, steamfitter, drumfish, discomfiture
[MFL] circumflex, flimflam, foamflower, flimflammed, flimflammer, circumfluent, circumfluous
[MFO] comfortable, tomfoolery, comfortless, discomfort, comfortingly, comfortably, comfort
[MFR] comfrey, pomfret, chamfron, comfreys, pomfrets, chamfrons
[MFS] emfs
[MFU] harmful, armful, brimful, roomful, unharmful, circumfuse, harmfulness
[MFY] comfy
[MGU] slumgullion, slumgullions
[MHA] farmhand, scrumhalf, scrumhalves, farmhands
[MHE] drumhead, warmhearted, drumheads
[MHO] mho, wormhole, armhole, crumhorn, micromho, farmhouse, krummhorn
[MIA] polynomial, binomial, monomial, academia, bohemian, arrhythmia, amimia
[MIB] semibreve, demibastion, semibreves
[MIC] dynamic, atomic, micro, semicolon, omicron, logarithmic, mimic
[MID] middle, midpoint, midway, pyramid, midnight, midi, midline
[MIE] dummies, premier, economies, amie, armies, dichotomies, anomie
[MIF] miff, semifinal, ramification, mummify, semifluid, vermiform, pomiferous
[MIG] might, migration, amigo, almighty, fumigation, immigration, emigre
[MIH] mihrab, hemihedral, hemihydrate
[MII] gastrocnemii
[MIJ] demijohn, demijohns
[MIK] mike, mikado, mikvah, kamikaze, camiknickers, miking, mikes
[MIL] family, similar, milliseconds, smiling, milestone, subfamily, military
[MIM] mime, mimic, amimia, mimosa, demimonde, pantomime, hemimorphic
[MIN] min, determine, timing, terminal, denominator, programming, assuming
[MIO] fermion, epidemiology, daimio, miosis, osmious, acromion, eximious
[MIP] semipro, hemipode, primipara, armipotent, gemmiparous, hemiplegia, semipostal
[MIQ] semiquaver, semiquavers
[MIR] mirror, smirk, emirates, mirage, admiral, mire, bemire
[MIS] missing, permission, misc, mismatch, thermistor, transmission, mistake
[MIT] limit, miter, permitted, primitive, omit, delimiter, commit
[MIU] chromium, cadmium, osmium, fermium, holmium, premium, neodymium
[MIV] semivowel, demivolt, semivitreous, semivowels
[MIW] semiweekly, semiweeklies
[MIX] mixed, mixture, mixing, remix, intermixed, unmixed, commix
[MIY] semiyearly
[MIZ] optimize, minimize, itemize, customize, randomized, maximize, atomize
[MJA] jimjams, circumjacent
[MJE] ramjet, ramjets
[MKH] gymkhana, gymkhanas
[MKI] bumkin, boomkin
[MLA] umlaut, farmland, dreamland, bottomland, umlauts, farmlands, bottomlands
[MLE] harmless, seamless, hamlet, armlet, camlet, gimlet, aimless
[MLI] streamline, tramlines, gremlin, drumlin, hemline, kremlin, slimline
[MLO] armload, hemlock, slumlord, armloads, hemlocks, slumlords
[MLU] circumlunar
[MLY] randomly, uniformly, firmly, dimly, seemly, unseemly, calmly
[MMA] command, gamma, summary, digamma, grammar, lemma, mammal
[MME] comment, immediate, symmetric, recommended, trimmed, asymmetric, hammer
[MMH] krummhorn, krummhorns
[MMI] commit, programming, dummies, hamming, trimming, summing, swimming
[MMO] common, accommodate, uncommon, mammoth, immortal, bottommost, immovable
[MMU] community, commutative, immutable, immunities, ammunition, hummus, gemmule
[MMY] dummy, jimmy, jammy, yummy, crummy, shimmy, whammy
[MNA] remnant, columnar, gymnastics, autumnal, condemnable, alumna, hymnal
[MNB] hymnbook, hymnbooks
[MNE] amnesia, mnemonic, randomness, columned, chimney, dimness, calmness
[MNI] indemnify, alumni, omnibus, lemniscate, amnion, damnify, hymnist
[MNL] solemnly
[MNN] solemnness
[MNO] somnolence, hymnody, contemnor, limnology, gymnosperm, gymnosophist, insomnolence
[MNS] columns, autumns, damns, hymns, limns, condemns, contemns
[MNU] alumnus, circumnutate
[MNY] calumny
[MOA] moan, moat, moas, bemoan, moa, moaning, moaner
[MOB] mobile, automobile, mobbed, mobcap, mobster, immobile, airmobile
[MOC] mock, thermocouple, moccasin, mocha, democracy, bemock, hammock
[MOD] module, mode, modified, unmodified, mods, modal, accommodate
[MOE] amoeba, schmoes, homoerotic, demoed, amoebae, amoebic, amoeboid
[MOF] mofette, bromoform
[MOG] homogeneous, mog, tomography, demographic, transmogrify, homogenized, smog
[MOH] mohawk, mohur, mohair, mohawks
[MOI] chamois, memoir, moist, turmoil, sigmoid, moire, demoiselle
[MOJ] emoji, mojo, emojis, mojos
[MOK] smoke, nonsmokers, amok, moke, antismoking, smoking, smoker
[MOL] molar, molecule, tremolo, homology, moll, mold, guacamole
[MOM] moment, homomorphism, thermometer, moms, momism, mommy, stepmom
[MON] common, month, monotonic, monopoles, among, diamond, harmonic
[MOO] smooth, moon, mood, moose, moored, moot, simoom
[MOP] mop, rollmop, cymophane, homophile, homopolar, omophagia, cormophyte
[MOQ] moquette, moquettes
[MOR] more, memory, isomorphic, morphology, anymore, furthermore, meromorphic
[MOS] almost, most, topmost, leftmost, rightmost, demos, mosaic
[MOT] promote, motion, remote, marmot, emotion, timothy, motorized
[MOU] amount, mouse, mouth, anonymous, mount, autonomous, famous
[MOV] remove, move, moving, movable, earthmover, immovable, unmoved
[MOW] haymow, unmown, mower, lawnmower, mowing, mows, mow
[MOX] lummox, flummox, moxie, moxa, tamoxifen, amoxicillin, lummoxes
[MOY] cherimoya, cherimoyas
[MOZ] mozzetta, homozygote, mozzarella, homozygous
[MPA] compare, incompatible, accompanying, impact, incomparable, champagne, encompasses
[MPB] humpback, lampblack, humpbacks, humpbacked
[MPC] dumpcart, dumpcarts
[MPD] clampdown, clampdowns
[MPE] ampersand, damper, temperature, dumper, imperial, compensation, jumper
[MPF] campfire, impf, lumpfish, campfires
[MPG] campground, campgrounds
[MPH] lymph, nymph, oomph, pamphlet, triumph, emphasis, amphibious
[MPI] compile, empirical, damping, vampire, recompile, dumping, champion
[MPK] pumpkin, bumpkin, limpkin, pumpkinseed, bumpkins, limpkins, pumpkins
[MPL] example, samples, simple, complex, implied, template, resample
[MPM] decampment, encampment, encampments
[MPN] dampness, limpness, plumpness
[MPO] import, component, composite, temporary, decompose, idempotent, trampoline
[MPP] lamppost, dampproof, lampposts
[MPR] compress, uncompressed, improve, decompress, recompress, empress, unimpressed
[MPS] dumps, comps, timestamps, jumps, stamps, temps, bumps
[MPT] empty, assumptions, prompt, attempt, asymptotic, nonempty, consumption
[MPU] compute, precomputed, impulse, recompute, campus, ampule, rumpus
[MPV] impv
[MPY] grumpy, bumpy, gimpy, lumpy, clumpy, crimpy, frumpy
[MQU] kumquat, kumquats
[MRA] comrade, broomrape, comradery, comradeship, comrades, comradely, comraderies
[MRE] armrest, armrests
[MRI] amrita
[MRO] shamrock, nimrod, ramrod, rimrock, alumroot, primrose, tramroad
[MRU] rumrunner, rumrunners
[MRY] bottomry
[MSA] ahimsa, samsara, memsahib, doomsayer, samsaric, memsahibs, doomsayers
[MSB] gemsbok, gemsboks
[MSC] circumscribe
[MSD] doomsday
[MSE] themselves, himself, damsel, kamseen, malmsey, wormseed, damselfly
[MSG] almsgiver, almsgivers
[MSH] clamshell, cumshaw, gumshoe, camshaft, dramshop, almshouse, scrimshaw
[MSI] khamsin, adamsite, clumsily, flimsily, whimsical, clumsiness, flimsiness
[MSK] numskull, numskulls
[MSL] gymslip, gymslips
[MSM] almsman, helmsman, groomsman, helmsmen, groomsmen
[MSO] crimson, plimsoll, damson, stemson, encrimson, jimsonweed, whomsoever
[MSP] circumspect
[MST] circumstance, hamster, broomstick, drumsticks, doomster, gemstone, zemstvo
[MSU] swimsuit, swimsuits
[MSW] almswoman
[MSY] clumsy, whimsy, flimsy, slimsy
[MTG] mtge
[MTH] warmth
[MTI] tomtit, steamtight, tomtits
[MTO] femtosecond, palmtop, femtoseconds, palmtops
[MTR] gumtree, gumtrees
[MUC] much, insomuch, muck, mucus, schmuck, inasmuch, almuce
[MUD] mud, smudge, bermudas, curmudgeon, muddy, mudcat, muddle
[MUE] muenster, muesli, muezzin, mueslis, muezzins
[MUF] muffler, earmuff, mufti, unmuffle, ragamuffin, muffin, muffle
[MUG] smuggle, mugshot, mugful, mugged, mugwump, mug, mugs
[MUJ] mujik, mujahidin, mujaheddin, mujahideen, mujiks
[MUK] mukluk, mukluks
[MUL] multi, formula, cumulative, accumulators, emulate, simulate, stimulate
[MUM] maximum, minimum, optimum, mum, subminimum, minimums, maximums
[MUN] community, mun, remuneration, immunities, chipmunk, ammunition, osmunda
[MUO] muon, muons
[MUR] murphy, murmur, mure, smurf, murder, murky, armure
[MUS] must, musical, muscle, muse, muss, mush, emus
[MUT] permutation, mutual, commutative, immutable, mutation, azimuth, muted
[MUU] muumuu, muumuus
[MUZ] muzzle, muzhik, muzak, unmuzzle, muzzled, muzzles, muzzling
[MVE] circumvent, circumvented, circumvents
[MVI] duumvir, decemvir, triumvir, triumviri, duumvirate, triumviral, decemvirate
[MWA] tramway, firmware, stemware, streamway, ransomware, tramways
[MWE] gromwell, swimwear, bantamweight, gromwells
[MWI] dimwitted, stemwinder, dimwit, dimwits
[MWO] gumwood, clamworm, formwork, teamwork, wormwood, dreamworld, gumwoods
[MYA] myall, farmyard, myasthenia, myalgia, myalgic, myasthenic, myalgias
[MYC] mycol, mycelia, neomycin, ascomycete, myxomycete, actinomycin, phycomycete
[MYD] chlamydia, mydriasis, achlamydeous, mydriatic, chlamydate, chlamydiae, chlamydeous
[MYE] myelin, unmyelinated, myeline, myeloid, myeloma, myelitis, myelomata
[MYG] amygdala, amygdalin, amygdalate, amygdaline, amygdaloid, amygdalas
[MYI] myiasis, jemmying, jimmying, shimmying
[MYL] amyl, formyl, chromyl, mylonite, mylohyoid, amylum, amylase
[MYN] myna, mynas
[MYO] myopic, myocardial, daimyo, myosin, myology, myotome, myogenic
[MYR] myriad, myrrh, myrtle, myrmidon, tommyrot, myrobalan, myrmecology
[MYS] myself, mystery, chlamys, demystify, mysterious, mystical, mysteriously
[MYT] myth, stichomythia, mythic, mythical, mythology, myths, mythological
[MYW] armyworm, armyworms
[MYX] myxoma, myxedema, polymyxin, myxomycete, myxomatoses, myxomatosis, myxedemas
[MZA] hamza
[NAA] naan, naans
[NAB] enable, unable, reasonable, inability, definable, assignable, tunable
[NAC] inactive, inaccurate, tenacity, inaccessible, enact, nonactive, unacceptable
[NAD] monad, tornado, grenade, promenade, nonadjacent, inadmissible, inadequate
[NAE] nae, venae, antennae, personae, alumnae, lacunae, laminae
[NAF] unaffected, hereinafter, unaffiliated, kenaf, snaffle, naff, pinafore
[NAG] manager, nag, micromanager, synagogue, unmanageable, linage, nonagon
[NAH] nah, hosannah
[NAI] fingernail, hobnail, nail, naive, snail, thumbnail, naira
[NAK] snake, naked, kanaka, canakin, manakin, nakfa, spinnaker
[NAL] optional, original, rational, signal, final, external, internal
[NAM] name, filename, dynamic, rename, pathname, username, codename
[NAN] maintenance, determinant, consonant, nanoseconds, discriminant, banana, dominant
[NAO] naos
[NAP] snap, nap, anaphoric, synaptic, inapplicable, knapsack, kidnapping
[NAR] binary, dictionary, narwhals, imaginary, unary, ordinary, narrow
[NAS] nasty, antennas, unassigned, nasal, anas, arenas, bananas
[NAT] native, signature, coordinate, alternative, combination, destination, explanation
[NAU] astronaut, unauthorized, nautical, naughty, nauseated, aeronautics, aquanaut
[NAV] nav, unavailable, unavoidable, knave, coronavirus, unnavigable, unavenged
[NAW] runaway, unaware, knawel, nawab, gnaw, mackinaw, chinaware
[NAX] monaxial, chronaxie
[NAY] nay, chardonnay, naysayer, nays, naysayers, chardonnays
[NAZ] snazzy, denazify, monazite, phenazine, snazzily, snazzier, monazites
[NBA] unbalanced, pinball, nonbasic, cannonball, unbacked, beanbag, finback
[NBE] cranberry, unbearably, unbeatable, unbelievably, sunbed, inbeing, downbeat
[NBI] unbiased, henbit, hornbill, ovenbird, spoonbill, nonbinding, unbidden
[NBL] unblock, sunblock, hornblende, unblessed, unblocked, unblocks, unblocking
[NBO] rainbow, unbounded, inbox, bonbon, unboxing, fanboy, sunbow
[NBR] unbraced, unbroken, unbreakable, nonbreakable, sunbreak, unbridle, cornbread
[NBU] unbuild, sunburn, downburst, turnbuckle, nonburnable, inbuilt, unbundled
[NCA] truncate, concatenate, downcast, uncaught, encapsulated, uncalibrated, incantation
[NCE] advance, distance, instance, sequence, reference, since, once
[NCH] bench, branch, crunch, lunch, punch, anchor, launchpad
[NCI] incidental, dependencies, principal, frequencies, encipher, concise, stencil
[NCK] zincked, zincking
[NCL] include, enclosed, unclear, conclusion, nomenclature, concluding, inconclusive
[NCM] blancmange, blancmanges
[NCO] encoding, incompatible, incorrect, incomplete, incorporated, encountered, inconsistent
[NCR] incr, concrete, encryption, encroachment, uncropped, chancre, cancroid
[NCS] incs, syncs, broncs, francs, zincs, charabancs
[NCT] function, punctuation, distinct, conjunction, junction, malfunction, extinction
[NCU] concurrent, incurred, incumbent, unencumbered, quincunx, inculcating, uncut
[NCY] frequency, dependency, fancy, latency, currency, adjacency, consistency
[NDA] standard, pandas, foundation, boundary, expandable, calendar, mandatory
[NDB] handball, sandbox, standby, bandbox, windbag, endbrain, soundbar
[NDC] grandchild, handcrafted, handclasp, poundcake, windchill, sandcastle, soundcheck
[NDD] granddad, granddaddy, granddads, granddaddies
[NDE] index, under, render, expanded, extended, unexpanded, rounded
[NDF] handful, mindful, grandfather, sandfly, landfall, windfall, blindfish
[NDG] endgame, handgun, hindgut, windgall, landgrave, sandglass, handgrip
[NDH] sandhi, handhelds, groundhog, gesundheit, roundheel, windhover, behindhand
[NDI] indices, conditions, ending, appendix, candidate, pending, bounding
[NDJ] windjammer, windjammers
[NDK] handkerchief
[NDL] bundle, candle, dwindle, handle, spindle, friendly, unhandled
[NDM] landmarks, grandma, amendments, handmade, windmill, bondman, endmost
[NDN] endnote, roundness, kindness, blindness, soundness, fondness, blandness
[NDO] random, window, vendor, endorse, undo, tendon, handout
[NDP] endpoint, endpaper, grandparent, standpoint, sandpaper, handpick, windpipe
[NDQ] hindquarters, hindquarter
[NDR] android, hundred, cylindrical, sundry, palindrome, foundry, laundry
[NDS] bounds, commands, seconds, depends, ends, corresponds, milliseconds
[NDT] roundtrip, thousandth, windtight, soundtrack, soundtracks
[NDU] inductor, addendum, pendulum, industrial, roundup, conductance, fundus
[NDV] dvandva
[NDW] bandwidth, sandwich, handwritten, groundwater, endways, indwell, bendwise
[NDY] handy, candy, randy, sandy, burgundy, bendy, dandy
[NEA] linear, near, nonlinear, bilinear, curvilinear, collinear, rectilinear
[NEB] neb, ninebark, baneberry, boneblack, canebrake, inebriant, tenebrous
[NEC] connection, necessary, unnecessary, disconnect, bottleneck, neck, unconnected
[NED] defined, undefined, returned, maintained, signed, aligned, assigned
[NEE] need, engineering, kneeling, pioneers, unneeded, assignee, sneezing
[NEF] benefit, inefficient, ineffective, linefeed, nefarious, baneful, ganef
[NEG] negative, negligence, nonnegative, negotiate, negligible, vinegar, neglected
[NEH] bonehead, swineherd, boneheads, boneheaded, swineherds
[NEI] cuneiform, neighbors, neither, homogeneity, oneiric, gneiss, tineid
[NEK] nekton, nektons
[NEL] kernel, channel, panel, sentinel, tunnel, multichannel, fresnel
[NEM] nonempty, mnemonic, kinematic, refinement, cinema, unemployment, enemy
[NEN] component, exponent, prominent, permanent, continents, pertinent, linen
[NEO] homogeneous, neon, erroneous, extraneous, simultaneous, spontaneous, neoclassical
[NEP] neper, neptunium, nephew, inept, ninepin, nepotism, peneplain
[NEQ] inequality, unequal, henequen, mannequin, inequitable, inequalities, unequivocal
[NER] general, inner, container, corner, owner, maintainer, energy
[NES] lines, fitness, ones, thickness, nested, business, defines
[NET] net, internet, magnetic, ninety, planet, monetary, telnet
[NEU] neutral, neural, neume, antineutrino, lineup, pneumonia, tuneup
[NEV] never, whenever, unevaluated, inevitable, geneva, unevenly, nevus
[NEW] new, renew, anew, knew, kilonewton, sinewy, foreknew
[NEX] next, unexpanded, unexpected, inexact, nonexistent, annex, nonexclusive
[NEY] money, attorney, honeydew, barney, kidney, journey, gurney
[NFA] unfavorable, nonfatal, downfall, infantry, infarction, unfamiliar, rainfall
[NFE] infer, conference, unfeasible, conferring, confession, confederacy, enfeoff
[NFI] infinity, confidence, configure, unfilled, confirmed, unfitted, unfinished
[NFL] conflict, inflate, dragonfly, sunflower, cornflower, greenfly, gunflint
[NFO] info, enforce, conformance, unfortunate, confounded, unfolded, reinforce
[NFR] infringement, infrequent, mainframe, unfrozen, unfreeze, confronted, unfriendly
[NFU] confusion, painful, unfunny, infuse, manful, panful, sinful
[NGA] conga, hangar, kangaroo, manga, tonga, engaged, ingather
[NGB] dingbat, songbird, hummingbird, longbow, hangbird, kingbird, wingback
[NGC] kingcup, lingcod, longcloth, kingcraft, kingcups, lingcods
[NGD] kingdom, hangdog, ringdove, wingding, wrongdoer, subkingdom, wrongdoing
[NGE] range, changes, longer, unchanged, orange, infringement, hinge
[NGF] meaningful, lungful, songful, kingfish, wrongful, clingfilm, sangfroid
[NGG] ringgit, mahjongg, ringgits, mahjonggs
[NGH] dinghy, gingham, stronghold, shanghai, longhair, binghi, bunghole
[NGI] engine, changing, belonging, hanging, longitude, ranging, infringing
[NGL] single, angle, rectangle, english, triangle, strongly, accordingly
[NGM] hangman, kingmaker, strongman, ringmaster, workingman, hangmen, strongmen
[NGN] willingness, wrongness, wingnut, hangnail, fittingness, lastingness, nothingness
[NGO] ongoing, mango, mongo, tango, bingo, flamingo, dingo
[NGP] kingpin, gangplow, stringpiece, gangplank, kingpins, gangplanks
[NGR] downgrade, engraver, congruence, angry, ingredients, hungry, incongruity
[NGS] warnings, strings, drawings, settings, things, tilings, dealings
[NGT] length, strength, wavelength, longtime, wellington, wingtip, bangtail
[NGU] anguish, distinguish, language, penguin, tongue, singular, triangular
[NGW] gangway, ngwee, kingwood, longways, lungworm, ringworm, angwantibo
[NGY] thingy, stringy, clingy, fringy, grungy, orangy, slangy
[NHA] enhancement, manhattan, unhandled, inhalation, inhabited, unharmed, unhappily
[NHE] inherited, inherently, unhelpful, disinherit, dragonhead, greenheart, unheeded
[NHI] inhibit, downhill, unhidden, unhindered, menhir, anhinga, uninhibited
[NHO] senhor, unhook, manhole, nunhood, pinhole, tinhorn, bonhomie
[NHU] inhume, unhurt, manhunt, cornhusk, nonhuman, inhuman, inhumane
[NHY] unhyphenated, anhydride, unhygienic, anhydrite, anhydrous, anhydrides
[NIA] denial, hryvnia, miniature, mania, ammoniac, biennial, pneumonia
[NIB] nibble, omnibus, minibus, cannibalism, discernible, niblick, exponible
[NIC] canonical, monotonic, harmonic, nice, mechanics, technical, electronic
[NID] unidiomatic, nonidentical, snider, actinides, lanthanides, unidentified, nidify
[NIE] convenience, denied, genie, lenient, definiens, accompanied, companies
[NIF] uniform, manifest, significant, indemnify, knife, sniff, magnified
[NIG] knight, night, midnight, benign, enigma, pfennig, shenanigans
[NIH] annihilator, nihil, annihilation, annihilate, annihilators, annihilated, nihilism
[NII] coniine, genii, saturniid, saturniids
[NIJ] unijugate
[NIK] sputnik, beatnik, moniker, nudnik, canikin, manikin, cannikin
[NIL] nil, vanilla, anil, nonillion, unilaterally, manila, penile
[NIM] minimum, anim, nimbus, nimrod, denim, unanimous, unimportant
[NIN] warning, containing, meaning, running, combining, opening, nine
[NIO] union, quaternion, opinion, companion, onion, junior, minion
[NIP] snippet, manipulate, nip, juniper, catnip, turnip, unipod
[NIQ] unique, technique, iniquity, communique, tourniquet, uniquely, uniqueness
[NIR] nirvana, venire, souvenir, omnirange, premunire, unironed, venireman
[NIS] finish, furnished, mechanism, danish, nisi, vanish, anisotropic
[NIT] initial, unit, finite, definition, infinity, knit, sanitize
[NIU] dubnium, hafnium, rhenium, uranium, actinium, polonium, selenium
[NIV] university, omnivore, carnivore, univalence, knives, snivel, connive
[NIX] phoenix, nix, fornix, phenix, nixed, nixing, nixes
[NIY] guberniya
[NIZ] organization, recognized, unrecognized, synchronized, homogenize, ionization, reorganize
[NJA] ninja, unjam, benjamin, sanjak, ganja, popinjay, panjandra
[NJE] inject, conjecture, fanjet, injected, injection, conjectures, injects
[NJI] kanji, basenji, basenjis
[NJO] enjoyment, conjoined, banjo, nonjoiner, donjon, enjoinder, enjoyable
[NJU] conjugate, conjunction, injury, unjustified, nonjuror, conjuration, uninjured
[NKA] linkage, shrinkage, tanka, sinkable, punkah, drunkard, kinkajou
[NKB] inkblot, linkboy, bankbook, stinkbug, blankbook, inkberry, inkblots
[NKC] bankcard, crankcase, bankcards, crankcases
[NKE] linked, chunked, monkey, ranked, donkey, yanked, bonkers
[NKF] thankfully, tankful, monkfish, trunkfish, unthankful, frankfurter, thankful
[NKG] ginkgo, ginkgoes
[NKH] ankh, inkhorn, lunkhead, monkhood, sinkhole, bunkhouse, stinkhorn
[NKI] ranking, linking, shrinking, thinking, chunking, pinkish, winking
[NKL] ankle, crinkle, sprinkle, twinkle, wrinkle, franklin, periwinkle
[NKM] junkman, linkman, bunkmate, embankment, brinkmanship, linkmen, bunkmates
[NKN] unknown, banknote, blankness, rankness, dankness, lankness, penknife
[NKO] stinko, einkorn, pinko, nonkosher, drunkometer, pinkos
[NKP] crankpin, stinkpot, frankpledge, stinkpots
[NKR] bankruptcy, bankrolls, bankroll, bankrupt, bankrupts, bankrolled, bankrupted
[NKS] chunks, thanks, links, ranks, blanks, hyperlinks, shanks
[NKT] plankton, zooplankton, planktonic, zooplanktons
[NKU] bunkum, linkup, ankus, linkups
[NKW] inkwell, linkwork, stinkweed, stinkwood, inkwells, stinkweeds
[NKY] funky, inky, clunky, wonky, chunky, cranky, stinky
[NLA] enlarge, unlabeled, anlage, mainland, inlay, fenland, sunlamp
[NLE] unless, greenlet, inlet, brainlessly, branle, runlet, sinless
[NLI] inline, unlike, nonlinear, online, penlight, sunlight, cleanliness
[NLO] download, unload, gunlock, onlooker, panlogism, trainload, nonlogical
[NLU] unlucky, unluckier, unluckily, unluckiest, unluckiness
[NLY] only, mainly, evenly, plainly, commonly, certainly, cleanly
[NMA] unmasked, unmatched, unmapped, unmaintained, unmanned, unmarried, manmade
[NME] environment, alignment, assignment, government, nonmember, containment, reassignment
[NMI] unmixed, enmity, nonmilitant, nonmigratory, unmistakable, unmindful, unmissable
[NMO] unmodified, unmounted, unmolested, inmost, nonmoral, lawnmower, sixteenmo
[NMU] unmuffle, unmuzzle, unmusical, unmutilated, unmuzzled, unmusically
[NMY] unmyelinated
[NNA] antenna, unnamed, annals, sienna, wanna, nonnative, penname
[NNE] inner, connection, channel, nonnegative, binned, manner, runner
[NNI] running, beginning, spanning, scanning, annihilator, binning, grinning
[NNK] innkeeper, innkeepers
[NNO] cannot, annotations, announce, annoying, innocent, dunno, innovation
[NNS] conns, banns, djinns, inns
[NNU] unnumbered, annual, nonnumerical, cannula, ennui, pinnule, stannum
[NNY] funny, canny, bunny, sunny, johnny, skinny, nanny
[NOA] genoa, quinoa, dipnoan, anoa, monoacid, immunoassay, monoatomic
[NOB] nobs, nobody, unobserved, knobs, noble, nobelium, bonobo
[NOC] monochrome, knockout, innocent, monocular, rhinoceros, binocular, inoculated
[NOD] node, anode, dynode, nodal, nodule, noddy, nodi
[NOE] noel, canoe, noes, noetic, dominoes, dianoetic, gynoecium
[NOF] unofficial, runoff, turnoff, ganof, pianoforte, stroganoff, inofficious
[NOG] phonogram, monogram, nog, stenographic, carcinogenic, ethnographic, oceanography
[NOH] nohow, monohydric, cyanohydrin, glenohumeral, monohydroxy, cyanohydrins
[NOI] noise, paranoia, solenoidal, noil, anoint, conoid, ganoid
[NOL] technology, terminology, knoll, chronology, monolithic, phenols, canola
[NOM] polynomial, denom, binomial, gnome, monomial, nom, economic
[NON] none, nonzero, canonical, nonnegative, nonlinear, nonce, anonymous
[NOO] noon, chinook, afternoon, snoopy, noodle, nookie, noose
[NOP] monopoles, synopsis, unopened, nope, knop, monophthong, canopy
[NOR] ignore, normal, northwest, northeast, minor, unordered, honor
[NOS] diagnostics, nos, nanoseconds, agnostic, luminosity, rhinos, lanose
[NOT] not, cannot, another, footnote, annotations, knot, monotonic
[NOU] enough, announce, noumena, synchronous, asynchronous, turnout, noun
[NOV] novelty, nova, novices, turnover, innovation, renovate, synovia
[NOW] unknown, now, known, snowman, acknowledge, unowned, renowned
[NOX] obnoxious, equinox, noxious, anoxia, monoxide, innoxious, minoxidil
[NOY] annoying, noyade, annoy, annoyingly, annoyance, annoys, annoyed
[NOZ] nozzle, schnoz, chernozem, actinozoan, monozygotic, nozzles, schnozzle
[NPA] unpack, nonpareil, brainpan, gunpaper, nonpaying, nonpaternal, inpatient
[NPE] henpeck, unpeg, tenpenny, nonperson, sevenpence, unpen, unpeople
[NPH] enphytotic, nonphysical
[NPI] unpick, turnpike, tenpin, panpipe, downpipe, hornpipe, drainpipe
[NPL] screenplay, unplanned, unpleasant, downplay, commonplace, enplane, gunplay
[NPO] davenport, signpost, unpopulated, nonpolar, pinpoint, inpour, tinpot
[NPR] unprocessed, unprintable, unprotected, unprovided, unprivileged, unprepared, unpressed
[NPS] panpsychist
[NPU] input, unpublished, nonpublic, unpunctual, unpunished, unpurified, unpublicized
[NQU] banquet, conquer, jonquil, tranquil, vanquish, unquote, enqueue
[NRA] unravel, enraged, downrange, moonraker, nonracial, nonrandom, unraveled
[NRE] unrecognized, unrelated, unreachable, unreserved, unrestricted, unreliable, unreadable
[NRH] unrhythmic, nonrhythmic, unrhymed
[NRI] sunrise, downright, enrich, unripe, moonrise, nonrigid, jinrikisha
[NRO] goldenrod, unrolled, unrounded, enrobe, cornrow, genro, manrope
[NRU] inrush, onrush, unruly, nonrural, gunrunner, gunrunning, unruliness
[NRY] henry, weaponry, almonry, canonry, felonry, heronry, masonry
[NSA] unsafe, transaction, compensation, licensable, condensation, insane, sensation
[NSC] unscaled, transcript, downscale, transcendent, inscribed, unscramble, mensch
[NSD] transduction, transdermal, transducer, transducers
[NSE] license, insert, response, dense, sense, unset, ensemble
[NSF] transform, kinsfolk, townsfolk, transformer, transfer, transformed, transforms
[NSG] transgender, transgress, transgenic, transgressor, transgenders, transgressed, transgresses
[NSH] relationship, screenshot, sunshine, downshift, kinship, enshrine, internship
[NSI] extension, inside, density, dimension, consider, expansion, unsigned
[NSK] nonsked, coonskin, kolinsky, swanskin, onionskin, unskilled, nonskid
[NSL] translate, untranslated, unsliced, retranslate, enslave, nonslip, manslayer
[NSM] transmission, transmitted, transmogrify, transmuter, kinsmen, nonsmokers, retransmits
[NSN] unsnapped, ensnare, insnare, unsnarled, ensnarement, unsnap, unsnaps
[NSO] tensor, console, sensor, censored, unsorted, uncensored, sponsor
[NSP] transpose, inspect, unspecified, sunspot, bonspiel, conspire, ensphere
[NSQ] lansquenet
[NSR] lebensraum
[NSS] transship, transsonic, transsexual, transshipped, transships, transsexuals
[NST] instead, constant, against, unstack, reconstruct, uninstall, reinstall
[NSU] ensure, unsupported, consume, census, insular, unsuccessful, unsupervised
[NSV] transversal, transvalue, transvestism, transverse, transvestite, transverses, transversely
[NSW] answer, unswear, enswathe, menswear, downswing, kinswoman, clanswoman
[NSY] quinsy, weensy, pansy, phrensy, tansy, unsystematic
[NTA] container, horizontal, syntax, maintained, elementary, incidental, orientation
[NTB] paintbox, frontbench, pointblank, paintbrush, paintball, paintboxes, frontbencher
[NTC] viscountcy, paramountcy, viscountcies
[NTD] countdown, saintdom, countdowns
[NTE] integer, center, content, counter, granted, pointer, implemented
[NTF] eventful, resentful, uneventful, unresentful, eventfulness, eventfully, resentfully
[NTG] roentgen, montgolfier, roentgens
[NTH] anthem, month, ninth, panther, tenth, parenthesis, seventh
[NTI] continue, warranties, entity, until, identity, attention, runtime
[NTJ] muntjac, muntjacs
[NTK] giantkiller
[NTL] currently, silently, differently, efficiently, apparently, frequently, consequently
[NTM] appointment, ointment, stuntman, tentmaker, anointment, printmaker, resentment
[NTN] currentness, centner, vintner, bluntness, faintness, gauntness, scantness
[NTO] into, contour, phantom, onto, untouched, pentode, printout
[NTR] controls, entry, central, country, intrusive, intrinsic, introduction
[NTS] points, elements, arguments, fonts, contents, components, counts
[NTU] quantum, momentum, eventually, century, intuitive, venture, accentuated
[NTW] entwine, intwine, bentwood, frontward, jointworm, lintwhite, paintwork
[NTY] warranty, uncertainty, twenty, pointy, seventy, county, plenty
[NTZ] chintz, blintz, chintzy, blintze, chintzily, blintzes, chintzier
[NUA] annual, manual, nuance, continuation, attenuator, sinuate, biannual
[NUB] snub, nub, connubial, manubrium, obnubilate, nubby, nubbin
[NUC] nuclear, knuckle, eunuch, penuche, nucellus, enucleate, binucleate
[NUD] nudge, denude, nudism, nudnik, nudest, nudged, nudges
[NUE] continue, venue, revenue, avenue, minuend, discontinued, detinue
[NUF] manufacturer, snuffy, genuflect, manufacture, manuf, snuff, snuffer
[NUG] snug, nugget, lanugo, nugatory, fenugreek, nuggar, snugged
[NUI] continuity, genuine, nuisance, annuity, tenuis, ennui, ingenuity
[NUK] nuke, gerenuk, nuking, nukes, nuked, gerenuks
[NUL] null, annulus, granularity, penultimate, canula, inulin, lunula
[NUM] number, numeric, enumerate, renumber, alphanumeric, unnumbered, magnum
[NUN] nun, nonuniform, inundate, quidnunc, conundrum, enunciate, annunciate
[NUO] continuous, tenuous, strenuous, sinuous, cernuous, ingenuous, disingenuous
[NUP] cleanup, prenup, grownup, nuptial, pinup, sunup, postnuptial
[NUR] nursery, tenure, anuran, conure, kronur, manure, penury
[NUS] minus, unused, sinusoidal, bonus, manuscript, menus, genus
[NUT] minute, doughnut, chestnut, nut, coconut, diminution, donut
[NUU] continuum
[NUZ] nuzzle, nuzzled, nuzzles, nuzzling, nuzzler, nuzzlers
[NVA] invalid, canvas, eigenvalues, unvaried, convalesce, noninvasive, nonvascular
[NVE] convert, inverse, envelope, eigenvectors, unverified, unconverted, inconvenient
[NVI] environment, invisible, invitations, convince, unvisited, envisage, nonvisual
[NVO] invoke, convolve, envoy, renvoi, unvoice, nonvocal, uninvolved
[NVT] invt
[NVU] convulse, invulnerable, convulsant, convulsion, convulsive, convulsed, convulses
[NVY] envy, envying, envyingly
[NWA] downwards, unwanted, inward, onward, runway, unwarned, unwatched
[NWE] unweighted, commonwealth, unwelcome, ironweed, rosinweed, cottonweed, jimsonweed
[NWH] pinwheel, meanwhile, nonwhite, unwholesome, nonwhites, pinwheels, pinwheeled
[NWI] unwind, enwind, sunwise, downwind, nationwide, pigeonwing, unwise
[NWO] greenwood, unwound, loanwords, enwomb, pinwork, hornwort, ironwood
[NWR] unwrap, wainwright, enwrap, screenwriter, inwrap, unwrapped, unwrapping
[NXE] jinxed, lynxes, minxes, sphinxes, syrinxes, phalanxes, salpinxes
[NXI] anxious, pinxit, minxish, antianxiety, overanxious, jinxing, anxiety
[NXL] sphinxlike
[NYA] banyan, nyala, gunyah, minyan, lanyard, barnyard, sannyasi
[NYB] anybody, nybble, donnybrook, teenybopper, nybbles, anybodies, donnybrooks
[NYC] johnnycake, nyctalopia, paronychia, nyctophobia, bonnyclabber, perionychium, johnnycakes
[NYF] manyfold
[NYH] anyhow, ninnyhammer
[NYI] accompanying, pinyin, denying, bunyip, cronyism, unyielding, nonyielding
[NYL] nylon, vinyl, carbonyl, phenyl, uranyl, nylghau, biphenyl
[NYM] acronym, antonym, homonym, nymph, synonym, anonymous, anymore
[NYO] anyone, canyon, pinyon, unyoke, canyons, pinyons, unyoked
[NYP] anyplace, manyplies
[NYR] pennyroyal, pennyroyals
[NYS] nystatin, dionysian, gunnysack, nystagmic, nystagmus, nystatins, gunnysacks
[NYT] anything, ponytail, phenytoin, anytime, anythings, ponytails
[NYW] anyway, pennyworth, pennyweight, anywhere, anyways, anywise, pennyworths
[NYX] onyx, sardonyx, onyxes, sardonyxes
[NZA] stanza, cadenza, influenza, banzai, kwanza, bonanza, organza
[NZE] nonzero, bronze, benzene, quinze, panzer, bonze, winze
[NZI] unzip, frenzies, benzine, fanzine, kunzite, organzine, gaberlunzie
[NZO] gonzo, garbanzo, benzol, canzona, enzootic, monzonite, garbanzos
[NZU] kanzu, kanzus
[NZY] frenzy, benzyl, bronzy, enzyme, coenzyme, apoenzyme, exoenzyme
[OAB] doable, proabortion
[OAC] approach, radioactive, roach, cockroach, proactive, coact, encroachment
[OAD] load, overload, broadcast, download, payload, upload, reload
[OAF] loaf, oafish, meatloaf, oafs, loafer, oaf, oafishness
[OAG] hoagie, coagulum, photoaging, coagulant, coagulase, coagulate, coagulable
[OAI] loaiasis
[OAK] cloak, croak, oak, soak, presoak, uncloak, oaken
[OAL] goal, koala, coalesce, charcoal, coalition, shoal, skoal
[OAM] roaming, foam, microampere, coaming, gloam, loamy, jeroboam
[OAN] loan, moan, groaning, bemoan, dipnoan, joannes, reboant
[OAP] soap, coaptation, soapbox, soapily, soapy, soapbark, soapsuds
[OAR] boar, hoard, oar, roar, clipboard, keyboard, checkerboard
[OAS] boast, coast, oasis, roast, toast, oast, moas
[OAT] float, coated, boat, tugboat, uncoated, rowboat, goat
[OAU] coauthor, coauthors, coauthored, coauthoring
[OAV] loaves, soave, meatloaves
[OAX] coaxer, hoaxer, coaxial, coaxing, coax, hoax, coaxed
[OBA] global, probably, foobar, acrobat, cobalt, autobahn, improbable
[OBB] gobble, hobby, clobber, bobble, cobblestone, lobby, obb
[OBC] bobcat, mobcap, obcordate, bobcats, mobcaps
[OBD] obduce, obdt, obduracy, obdurate, obdurateness, obdurately
[OBE] adobe, probe, obey, globe, lobe, obelus, microbe
[OBF] obfuscate, obfuscation, obfuscated, obfuscatory, obfuscates, obfuscating, obfuscations
[OBG] hobgoblin, hobgoblins
[OBH] jobholder, jobholders
[OBI] mobile, robin, probing, automobile, niobium, obi, hydrophobic
[OBJ] object, objurgate, nonobjective, obj, objects, objective, objectify
[OBK] knobkerrie, knobkerries
[OBL] goblin, noble, oblique, oblong, problem, subproblem, oblate
[OBM] obmutescence
[OBN] obnoxious, cobnut, hobnob, obnubilate, obnoxiously, hobnail, hobnobbed
[OBO] hobo, oboe, robot, nobody, bonobo, lobo, corroborated
[OBR] cobra, dobro, sobriety, microbrew, obreption, opprobrium, aerobraking
[OBS] jobs, observed, obsolete, blobs, nobs, globs, unobserved
[OBT] obtain, obtuse, unobtrusive, unobtainable, obtect, bobtail, obtrude
[OBU] robust, coburg, lobule, autobus, colobus, globule, jacobus
[OBV] obvious, unobvious, obvert, obvolute, obviously, obviate, obviated
[OBW] cobweb, lobworm, bobwhite, cobwebby, cobwebbed, cobwebs, lobworms
[OBY] kilobyte, booby, looby, goby, kilobytes
[OCA] local, vocalic, allocator, reciprocal, irrevocable, invocation, focal
[OCC] occur, occasionally, soccer, morocco, broccoli, moccasin, occluded
[OCE] process, preprocessed, unprocessed, ocean, quattrocento, reprocess, innocent
[OCH] brooch, epoch, loch, mocha, ochre, stochastic, pooch
[OCI] associated, velocity, society, reciprocity, unassociated, disassociate, loci
[OCK] block, socket, lock, clock, mock, pocket, stock
[OCL] monocle, proclaim, neoclassical, socle, isocline, autoclave, iconoclasm
[OCM] socman
[OCN] gastrocnemii
[OCO] protocol, thermocouple, cocoa, chocolate, locomotive, crocodile, photocopying
[OCR] endocrine, mediocre, democracy, ocrea, apocrine, autocrat, exocrine
[OCS] docs, blocs, chocs, tocsin, flocs, maniocs, nostocs
[OCT] doctor, nocturnal, octagon, octopus, octet, ioctl, octuple
[OCU] document, procurement, focus, undocumented, crocus, ocular, locus
[OCY] idiocy, oocyte, otocyst, gonocyte, hemocyte, monocyte, amebocyte
[ODA] today, modal, accommodate, rhodamine, nodal, coda, antipodal
[ODB] goodbye, woodbine, bloodbath, woodblock, woodborer, bloodbaths, goodbyes
[ODC] podcast, woodcut, godchild, woodcock, woodchuck, woodcraft, woodcarver
[ODD] odd, plodded, toddler, dodder, goddess, shoddy, modding
[ODE] code, node, mode, encode, decode, diode, ode
[ODF] codfish, bloodfin, godfather, godforsaken, codfishes, godfathers
[ODG] dodge, bodge, lodge, codger, stodge, smoodge, splodge
[ODH] godhead, jodhpur, bloodhound, clodhopper, bodhisattva, goodhearted, goodhumored
[ODI] modified, encoding, periodic, coding, decoding, unmodified, bodies
[ODK] vodka, bodkin, vodkas, bodkins
[ODL] poodle, godly, goodly, oodles, boodle, doodle, noodle
[ODM] goodman, godmother, hodman, woodman, broodmare, bloodmobile, hodmen
[ODN] goodness, woodnote, goodnight
[ODO] methodology, codon, dodo, orthodox, godown, commodore, hoodoo
[ODP] codpiece, woodpile, godparent, floodplain, woodprint, woodpecker, codpieces
[ODR] woodruff, loxodromes, godroon, prodrome, acrodrome, aerodrome, bloodroot
[ODS] methods, periods, goods, mods, pods, woods, rods
[ODT] bloodthirsty
[ODU] module, product, reproduce, introduction, byproduct, reintroduce, nodule
[ODW] goodwill, woodwind, godwit, hoodwink, bloodworm, floodwater, goodwife
[ODY] body, nobody, anybody, somebody, moody, everybody, embody
[OEA] toea, zoeae, toeas, zoeas, zoea
[OEB] amoeba, phoebe, roebuck, shoebox, woebegone, amoebae, amoebas
[OEC] androecium, toecap, hoecake, oecology, dioecious, gynoecium, bioecology
[OED] zeroed, echoed, embargoed, tattooed, torpedoed, hoedown, holloed
[OEE] cooee
[OEF] coefficients, woefully, coefficient, woeful, woefuller, woefullest, woefulness
[OEH] foehn, toehold, pahoehoe, shoehorn, foehns, toeholds, shoehorns
[OEI] hoeing, toeing, shoeing, canoeing, oeillade, tiptoeing, gumshoeing
[OEL] noel, coelacanth, koel, shoelace, coelostat, blastocoel, coelentera
[OEM] poem, foeman, phloem, proem, shoemaker, aeroembolism, poems
[OEN] phoenix, roentgen, oenomel, toenail, coenurus, coenzyme, subpoena
[OEP] cacoepy, orthoepy
[OEQ] coequal, coequality, coequals, coequally
[OER] coerce, oersted, toerag, forgoer, wooer, doer, evildoer
[OES] does, goes, zeroes, undoes, shoes, toes, mangoes
[OET] poetry, noetic, goethite, shoetree, unpoetic, bioethics, cacoethes
[OEU] oeuvre, oeuvres
[OEV] whatsoever, whoever, coeval, soever, howsoever, whosoever, whensoever
[OEW] canoewood
[OEX] coexist, coexistence, coextend, coexecutor, coexistent, coextensive, coexists
[OEY] joey, phooey, gooey, hooey, joeys
[OFA] sofar, insofar, picofarad, microfarad, loofah, shofar, profane
[OFB] goofball, hoofbeat, hoofbound, goofballs
[OFE] professor, roofer, twofer, woofer, gofer, mofette, spoofery
[OFF] coffee, off, scoff, cutoff, unofficial, payoff, runoff
[OFG] roofgarden
[OFI] profile, proofing, retrofit, microfilm, unprofitable, roofie, biofilm
[OFL] retroflex, roofless, photoflash, profligacy, riboflavin, lactoflavin, microfloppy
[OFN] aloofness
[OFO] proforma, twofold, hydrofoil, heretofore, iodoform, octofoil, bromoform
[OFR] proofread, shofroth, proofreader, proofreads, proofreaders, proofreading
[OFS] proofs, hoofs, goofs, spoofs, poofs, profs, roofs
[OFT] aloft, loft, oft, soft, semisoft, zoftig, croft
[OFU] tofu, profusion, scrofula, benzofuran, profundity, griseofulvin, profuse
[OFY] goofy
[OGA] logarithm, surrogate, derogatory, mahogany, interrogate, slogan, hogan
[OGB] logbook, fogbow, bogbean, dogbane, hogback, dogberry, fogbound
[OGC] dogcart, dogcatcher, dogcarts, dogcatchers
[OGD] fogdog, ogdoad, ogdoads
[OGE] together, homogeneous, altogether, roger, hydrogen, exogenous, endogenous
[OGF] dogface, hogfish, frogfish, dogfish, dogfight, dogfights, dogfishes
[OGG] logger, toggle, foggy, goggles, clogging, jogger, blogger
[OGH] ogham, yogh, foghorn, doghouse, froghopper, foghorns, doghouses
[OGI] logic, topological, technologies, paralogisms, ontological, astrological, pathological
[OGJ] logjam, logjams
[OGL] ogle, google, hieroglyph, dogleg, ogling, goglet, bogle
[OGM] frogmouth, dogma, frogmarch, undogmatic, nondogmatic, frogman, frogmen
[OGN] recognized, unrecognized, cognitive, bologna, cologne, cognomen, incognito
[OGO] logo, orthogonal, analogous, pogo, googol, isogon, trogon
[OGR] program, histogram, ideograph, bibliography, cryptography, pictographic, kilogram
[OGS] logs, dogs, catalogs, hogs, blogs, frogs, analogs
[OGT] hogtie, dogtrot, bogtrotter, dogteeth, dogtooth, hogtying, dogtrotted
[OGU] catalogue, dialogue, mogul, rogue, vogue, bogus, prologue
[OGV] dogvane
[OGW] logway, dogwood, hogwash, cogwheel, hogweed, logwood, dogwatch
[OGY] morphology, technology, topology, symbology, ontology, archaeology, terminology
[OHA] johannes, mohawk, aloha, cohabit, twohanded, mohair, cohabitant
[OHE] coherence, incoherence, cohesion, bohemian, kilohertz, rhombohedral, holohedral
[OHI] prohibited, eohippus, doohickey, protohistory, oohing, poohing, unprohibited
[OHL] kohl, kohlrabi, kohlrabies, kohls
[OHM] ohm, megohm, abohms, ohmic, ohms, ohmmeter, ohmage
[OHN] john, demijohn, johnny, johns, johnnycake, johnnies, demijohns
[OHO] boohoo, cohort, alcohol, gasohol, nohow, oho, chocoholic
[OHR] bohrium, nielsbohrium
[OHS] matzohs, poohs, oohs, pharaohs, ohs
[OHU] bohunk, cohune, mohur, tohubohu, protohuman, glenohumeral, cohunes
[OHY] carbohydrate, mylohyoid, monohydric, cryohydrate, cyanohydrin, autohypnosis, chlorohydrin
[OIA] paranoia, sequoia, dianoia, metanoia, paranoiac, sequoias, paranoiacs
[OIB] foible, foibles
[OIC] choice, invoice, voiced, heroic, anechoic, echoic, yoicks
[OID] android, asteroid, avoid, cuboid, thyroid, void, centroid
[OIE] gooier, moiety, leucopoiesis, gooiest, moieties
[OIF] coif, coiffed, coiffeur, coiffing, coiffure, coiffeuse, coifs
[OIG] eloign, soigne, coign, poignant, frankalmoign, soignee, poignance
[OIK] oik, troika, perestroika, poikilotherm, troikas, oiks
[OIL] boil, broil, coil, foil, oil, spoiler, toil
[OIM] autoimmune, autoimmunity
[OIN] coin, join, oink, point, doing, endpoint, adjoint
[OIR] memoir, reservoir, repertoire, avoir, moire, devoir, soiree
[OIS] hoist, moist, noise, poison, tortoise, turquoise, croissant
[OIT] adroit, exploit, goiter, loiter, quoits, doit, droit
[OIX] mirepoix
[OIZ] ghettoize, ghettoized, ghettoizes, ghettoizing
[OJE] project, turbojet, introject, electrojet, projection, projects, projections
[OJI] emoji, emojis
[OJO] mojo, kilojoule, jojoba, sojourn, kilojoules, sojourner, mojos
[OKA] okay, pooka, lookalike, hookah, judoka, bazooka, kokanee
[OKB] cookbook, crookback, bookbinder, cookbooks, bookbindery, bookbinding, crookbacks
[OKC] bookcase, bookcraft, bookcases
[OKE] token, stroke, broken, invoke, smoke, unbroken, keystroke
[OKH] cookhouse, cookhouses
[OKI] cookie, looking, invoking, stroking, smoking, choking, hooking
[OKK] bookkeeping, grokked, hokku, grokking, bookkeeper, bookkeepers
[OKL] booklet, brooklet, booklets, booklover, brooklime, brooklets, brooklimes
[OKM] bookmark, bookmarks, bookman, bookmarked, bookmarking, bookmaker, bookmaking
[OKN] hooknose, crookneck, hooknoses, crooknecks
[OKO] cookout, lookout, smoko, tokoloshe, cookouts, lookouts
[OKP] bookplate, bookplates
[OKR] okra, bookrack, okras, bookrest
[OKS] hooks, looks, books, notebooks, groks, textbooks, brooks
[OKT] cooktop
[OKU] lookup, hookup, hokum, hookups
[OKW] bookworm, cookware, hookworm, brookweed, bookwork, bookworms, cookwares
[OKY] spooky, hooky, kooky, nooky, rooky, smoky, poky
[OLA] polar, interpolate, isolated, extrapolate, parabola, violation, molar
[OLB] toolbar, schoolbook, tolbooth, tolbutamide, toolbox, toolbars, toolboxes
[OLC] volcano, dolce, lolcat, colchicum, colcothar, nonvolcanic, schoolchild
[OLD] old, bold, fold, hold, threshold, gold, placeholder
[OLE] boolean, whole, tolerance, console, role, poles, monopoles
[OLF] golf, olfactory, wolf, aardwolf, werewolf, woolfell, rauwolfia
[OLG] schoolgirl, woolgather, woolgrower, schoolgirls, woolgathers, woolgathered
[OLH] schoolhouse, foolhardy, foolhardily, foolhardier, foolhardiest, schoolhouses
[OLI] policy, solid, symbolic, violin, hyperbolic, holidays, olive
[OLK] folk, polka, yolk, toolkit, kinfolk, kolkhoz, menfolk
[OLL] following, collection, controlled, rolling, dollar, scroll, collapse
[OLM] dolmen, holmium, patrolman, schoolman, toolmaker, solmization, extolment
[OLN] coolness
[OLO] color, semicolon, morphology, technology, topological, dolor, polo
[OLP] dolphin, foolproof, colpitis, holp, volplane, woolpack, colpotomy
[OLR] poolroom, schoolroom, poolrooms, schoolrooms
[OLS] controls, symbols, tools, cols, protocols, sols, pools
[OLT] voltage, bolt, holt, statvolt, colt, jolt, kilovolt
[OLU] columns, absolute, solution, resolution, volume, convolution, evolution
[OLV] solve, resolve, convolve, involved, unsolved, dissolve, revolving
[OLW] schoolwork, patrolwoman, patrolwomen
[OLY] holy, monopoly, polyglot, polynomial, polymorphic, polyhedron, polycyclic
[OLZ] colza, colzas
[OMA] domain, roman, woman, automatic, ottoman, subdomain, aromatic
[OMB] bomb, comb, tomb, womb, zombie, coulomb, rhombus
[OMC] tomcat, broomcorn, tomcats, broomcorns
[OME] geometry, some, moment, omega, home, become, gnome
[OMF] comfortable, tomfoolery, pomfret, roomful, discomfit, comfortless, comfiest
[OMH] micromho, customhouse, customhouses
[OMI] polynomial, atomic, binomial, omit, denominator, monomial, omicron
[OMK] boomkin
[OML] randomly, cromlech, bottomland, fathomless, symptomless, cromlechs, bottomless
[OMM] common, recommended, accommodate, uncommon, bottommost, subcommittee, pommel
[OMN] insomnia, omnibus, somnolent, randomness, buxomness, somniloquy, somniferous
[OMO] promote, isomorphic, homogeneous, meromorphic, homomorphism, monomorphic, automobile
[OMP] chomp, company, pomp, stomp, prompt, incompatible, incomplete
[OMR] comrade, bottomry, broomrape, comradery, comradeship, comrades, comradely
[OMS] atoms, oms, bottoms, customs, toms, axioms, idioms
[OMT] tomtit, tomtits
[OMU] insomuch, gomuti, homunculus, photomural, promulgate, promulgator, promulgation
[OMW] gromwell, ransomware, gromwells
[OMY] economy, anatomy, astronomy, taxonomy, dichotomy, autonomy, lobotomy
[ONA] optional, rational, additional, dictionary, diagonal, conditional, functional
[ONB] nonbasic, nonbreakable, bonbon, cannonball, onboard, ironbark, moonbeam
[ONC] once, concept, nonce, oncoming, reconcile, ponceau, bronchitis
[OND] second, conditions, bond, corresponds, milliseconds, diamond, beyond
[ONE] none, one, tone, done, component, exponent, clone
[ONF] confidence, conflict, configure, confusion, conference, conformance, confirmed
[ONG] along, belong, long, song, strong, wrong, among
[ONH] dragonhead, nonhero, bonhomie, coonhound, buttonhole, ironhanded, matronhood
[ONI] canonical, monotonic, harmonic, positioning, monitor, electronic, sectioning
[ONJ] conjugate, conjunction, conjecture, conjoined, nonjoiner, donjon, nonjuror
[ONK] bonk, donkey, honk, monk, wonky, plonk, clonk
[ONL] only, nonlinear, online, commonly, moonlit, ironlike, matronly
[ONM] environment, nonmember, abandonment, conman, nonmoral, cantonment, ironmaster
[ONN] connection, nonnegative, disconnect, tonne, nonnative, unconnected, bonne
[ONO] monotonic, monopoles, monomial, economic, phonogram, honor, monochrome
[ONP] nonpolar, nonpareil, commonplace, nonpaying, nonperson, nonprofit, nonpublic
[ONQ] conquer, jonquil, reconquer, unconquered, conquistador, conquering, conquest
[ONR] weaponry, onrush, almonry, canonry, felonry, heronry, masonry
[ONS] options, functions, conditions, constant, response, versions, positions
[ONT] controls, font, continue, container, horizontal, contents, month
[ONU] bonus, nonuniform, coconut, donut, monumental, clonus, conure
[ONV] convert, unconverted, inconvenient, nonvisual, reconvert, biconvex, nonvocal
[ONW] commonwealth, onward, ironware, moonwalk, nonwhite, nonwoven, buttonwood
[ONY] agony, bony, colony, harmony, pony, acronym, anonymous
[ONZ] bronze, nonzero, gonzo, bonze, monzonite, bronzed, bronzer
[OOB] foobar, booby, goober, looby, boobed, boobies, boobing
[OOC] pooch, brooch, oocyte, smooch, hooch, mooch, zoochore
[OOD] blood, food, good, mood, wood, likelihood, neighborhood
[OOE] tattooed, phooey, cooee, gooey, hooey, wooer, shampooer
[OOF] goof, hoof, proof, roof, spoof, oof, woof
[OOG] google, booger, stooge, oogonia, scrooge, zooglea, oogeneses
[OOH] pooh, boohoo, ooh, doohickey, poohs, oohs, oohing
[OOI] gooier, zooid, tattooist, voodooism, booing, cooing, mooing
[OOK] book, cook, hook, look, shook, workbook, handbook
[OOL] cool, fool, pool, school, tool, boolean, spool
[OOM] bloom, boom, broom, gloom, room, zoom, mushroom
[OON] balloon, cartoon, moon, raccoon, spoon, harpoon, noon
[OOP] coop, droop, hoop, loop, scoop, oops, poop
[OOR] door, floor, moor, poor, spoor, coordinate, boor
[OOS] boost, choose, goose, loose, moose, bamboos, swoosh
[OOT] boot, foot, hoot, root, shoot, smooth, uproot
[OOU] isochroous
[OOV] groovy, hoover, behoove, microgroove, groove, grooved, hooves
[OOZ] booze, ooze, oozing, woozy, snooze, floozy, foozle
[OPA] opal, opaque, topaz, copaiba, opacity, propagate, leopard
[OPB] mopboard, mopboards
[OPC] opcode, popcorn, topcoat, stopcock, opcodes, topcoats, stopcocks
[OPD] topdressing, topdressings
[OPE] property, open, operator, scope, slope, hope, envelope
[OPF] topfull, scoopful, shopfront, chopfallen, shopfitter, topflight, shopfitting
[OPG] stopgap, popgun, topgallant, popguns, stopgaps, topgallants
[OPH] gopher, sophomore, trophy, xylophone, apostrophe, microphone, philosophy
[OPI] copies, opinion, topic, looping, utopia, scoping, developing
[OPJ] kopje, propjet, kopjes, propjets
[OPK] topknot, dropkick, shopkeeper, shopkeeping, topknots, dropkicks, shopkeepers
[OPL] people, coplanar, droplet, hoopla, cytoplasmic, poplar, hoplite
[OPM] development, topmost, propman, envelopment, developments, propmen, topmast
[OPN] topnotch
[OPO] monopoles, proportion, topological, proposition, metropolis, topography, hippopotamus
[OPP] dropped, opposite, stopping, popped, sloppy, cropped, copper
[OPR] appropriate, proprietary, cyclopropane, soprano, lipoproteins, copra, isoprene
[OPS] ops, props, synopsis, loops, stops, drops, tops
[OPT] option, opts, adopted, helicopter, suboptimal, opted, diopter
[OPU] population, opus, popularity, octopus, repopulate, unpopulated, copula
[OPW] stopwatch, dropwort, shopworn, slopwork, shopwindow, shopwindows, stopwatches
[OPY] copyright, entropy, copyleft, copyable, copyedit, microscopy, spectroscopy
[OQU] baroque, croquet, eloquent, loquacious, soliloquy, loquitur, colloquial
[ORA] storage, decorate, temporary, corporation, orange, incorporated, oracle
[ORB] absorb, orbit, sorbet, morbid, forbidden, colorblind, orbs
[ORC] force, torch, enforce, orc, motorcycle, perforce, divorced
[ORD] order, keyword, border, word, coordinate, record, password
[ORE] more, before, ignore, score, core, forest, store
[ORF] colorful, forfeit, corf, moorfowl, doorframe, flavorful, forfend
[ORG] org, forget, gorgon, borg, reorganize, seaborgium, morgen
[ORH] neighborhood, orthorhombic, moorhen, biorhythm, poorhouse, coleorhiza, doorhandles
[ORI] original, algorithm, horizontal, categorical, orient, priority, tutorial
[ORJ] alforja, doorjamb, forjudge, doorjambs
[ORK] work, network, fork, framework, york, homework, guesswork
[ORL] world, poorly, colorless, majorly, schorl, ceorl, forlorn
[ORM] format, normal, transform, platform, information, performance, uniform
[ORN] corner, ornament, thorn, horn, worn, tornado, born
[ORO] corollary, morocco, rigorous, thorough, boron, coronary, toroidal
[ORP] corporation, isomorphic, incorporated, morphology, meromorphic, polymorphic, homomorphism
[ORQ] torque, rorqual, torques, torquey, torqued, rorquals, torquing
[ORR] correct, incorrect, sorry, worry, borrowed, horrible, uncorrelated
[ORS] colors, errors, authors, factors, vectors, neighbors, operators
[ORT] import, support, port, sort, northwest, short, northeast
[ORU] floruit, forum, chorus, quorum, torus, phosphorus, koruna
[ORV] corvette, arborvitae, corvee, corves, corvine, corvees, corvettes
[ORW] forward, motorway, doorway, colorway, moorwort, vaporware, anchorwoman
[ORY] category, memory, directory, factory, theory, history, repository
[ORZ] borzoi, forzando, orzo, sforzati, sforzato, sforzandi, sforzando
[OSA] proposal, mosaic, disposal, icosahedral, closable, dosage, transposal
[OSB] grosbeak, grosbeaks
[OSC] oscillator, isosceles, stethoscope, microscope, oscilloscope, spectroscopy, groschen
[OSE] close, purpose, verbose, those, transpose, choose, whose
[OSG] phosgene, grosgrain, diphosgene, phosgenite, phosgenes
[OSH] cosh, josh, swoosh, posh, gosh, nosh, mackintosh
[OSI] position, closing, composite, repository, cosine, opposite, erosion
[OSK] bosk, kiosk, abelmosk, exoskeletal, endoskeleton, bosket, boskage
[OSL] gosling, proslavery, goslings
[OSM] cosmos, osmosis, microcosm, macrocosm, osmium, anosmia, osmunda
[OSO] boson, philosophy, aerosol, prosody, drosophila, arioso, amoroso
[OSP] prosper, introspect, hospital, atmosphere, phosphorus, gospel, aerospace
[OSQ] mosque, bosquet, mosquito, mosquitoes, mosques
[OSS] loss, possible, glossaries, cross, across, impossible, blossom
[OST] boost, almost, most, post, host, cost, lost
[OSU] closure, exposure, enclosure, disclosure, overexposure, cynosure, composure
[OSY] posy, ecosystem, rosy, argosy, choosy, goosy, leprosy
[OSZ] groszy, grosz
[OTA] rotate, total, annotations, notation, quotation, iota, subtotal
[OTB] football, hotbed, potboy, bootblack, hotbox, footboy, potbelly
[OTC] notch, gotchas, scotch, butterscotch, dotcom, botch, splotches
[OTE] protected, note, quote, footnote, promote, remote, potential
[OTF] botfly, potful, hotfoot, footfall, snootful, parrotfish, potfuls
[OTG] shotgun, rotgut, footgear, knotgrass, shotgunned, shotgunning, shotguns
[OTH] bother, brother, cloth, moth, tooth, other, another
[OTI] notice, motion, quotient, asymptotic, promotion, emotion, voting
[OTJ] bootjack, bootjacks
[OTK] hotkey, rootkit, hotkeys, rootkits
[OTL] rootless, rotl, spotlight, hotlink, footle, motley, tootle
[OTM] footmarks, motmot, potman, allotment, potmen, footman, footmen
[OTN] footnote, hotness, botnet, footnotes, footnoting, botnets, footnoted
[OTO] protocol, monotonic, photo, isotope, motorized, motorcycle, duotone
[OTP] footprint, hotpot, potpie, footpaths, footplate, footprints, footpad
[OTQ] cotquean
[OTR] protrusion, isotropic, anisotropic, protractor, protruding, heliotrope, orthotropic
[OTS] roots, dots, subplots, plots, slots, bootstrap, knots
[OTT] bottom, dotted, plotting, ottoman, glottal, forgotten, gotten
[OTU] lotus, rotunda, botulin, cloture, notum, orotund, scrotum
[OTW] footwear, notwork, knotweed, footway, footwall, footwork, footworn
[OTY] prototype, monotype, autotype, logotype, genotype, stereotypes, snooty
[OUA] bivouac, gouache, ouabain, tatouay, bivouacked, bivouacking, bivouacs
[OUB] double, trouble, undoubtedly, redoubt, soubise, misdoubt, oubliette
[OUC] touch, untouched, pouch, couch, ouch, cartouche, voucher
[OUD] cloud, loudspeaker, proud, oud, stroud, aoudad, shroud
[OUE] silhouette, roue, moue, pirouette, denouement, silhouettes, moues
[OUF] froufrou, souffle, camouflage, bouffe, pouffe, mouflon, bouffant
[OUG] bought, cough, dough, rough, through, enough, though
[OUH] brouhaha, brouhahas
[OUI] ouija, bouillon, louis, bedouin, ratatouille, oui, bouilli
[OUJ] moujik, moujiks
[OUK] chibouk, bouzouki, souk, bashibazouk, souks, bouzoukis
[OUL] could, foul, ghoul, should, soul, would, joule
[OUM] noumena, koumis, douma, foumart, khoum, coumarin, noumenal
[OUN] bounce, found, mountain, round, sound, count, background
[OUP] coupe, croup, group, soup, troupe, subgroup, uncouple
[OUQ] bouquet, bouquets
[OUR] course, flour, four, hour, pour, source, your
[OUS] curious, famous, house, mouse, nervous, previous, various
[OUT] about, out, scout, shout, trout, without, layout
[OUV] souvenir, louvar, couvade, trouveur, louver, trouvaille, louvers
[OUX] roux, bijoux
[OUZ] touzle, ouzel, bouzouki, ouzo, douzepers, ouzels, ouzos
[OVA] covariance, removal, oval, nova, movable, approval, provable
[OVE] above, over, remove, cover, move, governing, improve
[OVI] provided, moving, removing, improving, novices, soviet, approving
[OVO] provoke, kilovolt, obovoid, ovoid, ovolo, microvolt, ovotestis
[OVR] sovran
[OVU] ovular, ovum, zidovudine, ovulate, ovule, ovulation, ovulatory
[OVV] bovver
[OVY] groovy, anchovy
[OWA] towards, allowable, nowadays, throwaway, unknowable, rowan, kilowatt
[OWB] shadowbox, cowboy, snowball, rowboat, lowboy, crowbar, howbeit
[OWC] flowchart, showcase, snowcap, chowchow, slowcoach, cowcatcher, pillowcase
[OWD] powder, crowd, slowdown, howdy, chowder, dowdily, lowdown
[OWE] lower, allowed, however, power, vowel, followed, slower
[OWF] blowfish, snowflake, bowfin, cowfish, crowfeet, marrowfat, snowfield
[OWG] blowgun, cowgirl, showgirl, shadowgraph, sparrowgrass, showground, shadowgraphs
[OWH] arrowhead, nowhere, knowhow, towhee, bowhead, cowhand, blowhard
[OWI] following, allowing, showing, throwing, rowing, growing, bowing
[OWJ] blowjob, showjumping, blowjobs
[OWK] bowknot, gowk, bowknots
[OWL] knowledge, acknowledge, owl, slowly, bowl, howl, scowl
[OWM] snowman, bowman, endowments, cowman, plowman, showman, fellowman
[OWN] unknown, down, known, owner, markdown, shown, brown
[OWO] showoff, blowout, coworker, throwout, autoworker, stuccowork, blowouts
[OWP] cowpat, towpath, blowpipe, slowpoke, snowplow, showpiece, showplace
[OWR] elbowroom, cowrie, dowry, towrope, showroom, arrowroot, cowries
[OWS] windows, rows, allows, arrows, browser, follows, throws
[OWT] growth, bowtie, showtime, outgrowth, kowtow, blowtube, ingrowth
[OWU] blowup, followup, blowups, followups
[OWW] bowwow, powwow, glowworm, slowworm, arrowwood, hollowware, willowware
[OWY] snowy, yellowy, arrowy, bowyer, billowy, blowy, meadowy
[OWZ] blowzy, frowzy, blowzed, frowzily, frowziness, blowzier, frowzier
[OXA] oxalic, coxae, oxazine, moxa, siloxane, glyoxaline, hypoxanthine
[OXB] oxblood, oxbow, boxberry, boxboard, oxbows, boxberries
[OXC] boxcar, oxcart, coxcomb, coxcombry, boxcars, oxcarts, coxcombs
[OXE] boxed, unboxed, mailboxes, sandboxes, toolboxes, oxen, toxemia
[OXF] oxford, boxful, foxfire, boxfish, boxfuls, oxfords
[OXG] foxglove, foxgloves
[OXH] boxhaul, foxhole, oxheart, foxhunt, foxhound, foxholes, foxhunts
[OXI] approximate, proxies, boxing, toxic, oxidation, obnoxious, unboxing
[OXL] boxlike, orthodoxly
[OXO] loxodromes, toxoid, doxology, loxodrome, loxodromic, doxological, toxophilite
[OXP] oxpecker
[OXR] boxroom, boxrooms
[OXS] coxswain, coxswains
[OXT] foxtrot, oxtail, boxthorn, foxtail, foxtrotted, foxtrotting, oxtails
[OXU] amphioxus, amphioxuses
[OXW] boxwood
[OXY] boxy, epoxy, foxy, oxygen, proxy, doxy, hematoxylin
[OYA] royalty, voyage, loyalty, buoyancy, annoyance, noyade, boyar
[OYB] soybeans, toyboy, soybean, toyboys
[OYC] boycott, boycotts, boycotted, boycotting
[OYD] hoyden, hoydenish, hoydens
[OYE] destroyed, employee, deployed, unemployed, annoyed, enjoyed, voyeur
[OYF] joyful, boyfriend, joyfuller, joyfullest, joyfulness, joyfully, boyfriends
[OYH] boyhood, boyhoods
[OYI] annoying, destroying, deploying, employing, enjoying, boyish, goyish
[OYL] benzoyl, boyla, joyless, gargoyle, coyly, joylessness, gargoyled
[OYM] deployment, employment, enjoyment, unemployment, soymilk, redeployment, reemployment
[OYN] coyness
[OYO] arroyo, coyote, joyous, coyotillo, joyousness, arroyos, coyotes
[OYP] coypu, coypus
[OYR] joyride, joyrode, joyrider, joyridden, joyriding, joyrides, joyriders
[OYS] boys, enjoys, joys, oyster, toys, employs, destroys
[OZA] lalapalooza, lollapalooza
[OZE] booze, doze, frozen, ooze, lozenge, unfrozen, snooze
[OZI] cozily, dozily, woozily, oozier, boozier, floozies, snoozing
[OZL] foozle, bamboozle, bamboozled, bamboozles, bamboozling
[OZO] ozone, protozoan, bozo, rebozo, entozoa, bryozoan, holozoic
[OZY] boozy, cozy, dozy, oozy, woozy, floozy, doozy
[OZZ] nozzle, schnozzle, sozzled, mozzetta, mozzarella, nozzles, schnozzles
[PAB] capabilities, mappable, trappable, incapable, shippable, stoppable, inescapable
[PAC] package, space, apache, whitespace, unpack, opacity, capacity
[PAD] padding, launchpad, pads, spade, notepad, keypad, padre
[PAE] paella, paeony, paean, pupae, spae, scorpaenid, propaedeutic
[PAG] page, propagate, homepage, stoppage, pagination, webpage, spaghetti
[PAH] pah, huppah, chuppah, opahs, spahi, chutzpah, shopaholic
[PAI] pair, paint, repair, impair, paid, unpaired, postpaid
[PAJ] pajama, sapajou, pajamas
[PAK] spake, kalpak, gopak
[PAL] palette, principal, palm, facepalming, palatal, palindrome, pallets
[PAM] spam, pam, diazepam, dopamine, verapamil, pamphlet, pamper
[PAN] pandas, expand, span, unexpanded, company, panel, accompanying
[PAP] paper, newspaper, notepaper, wallpaper, endpaper, pappus, papaya
[PAQ] opaque, radiopaque, opaqueness, opaqued, opaquer, opaques, opaquely
[PAR] parse, part, parameters, parent, sparse, compare, prepare
[PAS] pass, past, bypass, pascal, compass, kappas, encompasses
[PAT] path, pattern, patch, compatible, dispatch, patent, incompatible
[PAU] pause, pauldron, paunch, pauper, epaulet, paucity, diapause
[PAV] paved, pavane, paving, spavin, pavlova, pavonine, papaverine
[PAW] spawn, pawn, paws, pawing, pawpaw, catspaw, forepaw
[PAX] pax, paxwax, paxes
[PAY] payload, payment, payoff, payday, payed, paying, pays
[PAZ] topaz, topazolite, topazes
[PBA] hipbath, humpback, snapback, soapbark, sweepback, hipbaths, humpbacks
[PBE] raspberry, upbear, cupbearer, soapberry, upbeat, upbeats, cupbearers
[PBL] lampblack
[PBO] clipboard, cupboard, peepbo, hipbone, soapbox, chapbook, lapboard
[PBR] upbraid, crispbread, stepbrother, upbringing, upbraids, upbraided, upbraiding
[PBU] upbuild, shipbuilder, shipbuilding, shipbuilders
[PCA] upcast, cupcake, hepcat, tipcat, dumpcart, slipcase, upcasts
[PCH] upchuck, stepchild, stepchildren, upchucks, upchucked, upchucking
[PCO] opcode, upcoming, popcorn, ripcord, soupcon, topcoat, stopcock
[PDA] update, stepdad, slapdash, updated, updates, updating, updater
[PDO] lapdog, sheepdog, trapdoor, updo, clampdown, flapdoodle, lapdogs
[PDR] updraft, snapdragon, topdressing, updrafts, snapdragons, topdressings
[PEA] repeat, appear, peak, loudspeaker, speak, disappear, peace
[PEB] pebble, typebar, peba, palpebrate, pebbly, pebas, pebbled
[PEC] expected, special, aspect, inspect, respect, unexpected, especially
[PED] mapped, wrapped, grouped, typed, dropped, skipped, escaped
[PEE] speed, peek, peer, rupee, peep, peeling, airspeed
[PEF] typeface, hopefully, grapefruit, tepefy, pipeful, stupefy, typefaces
[PEG] peg, arpeggio, unpeg, scapegoat, bibliopegy, mumbletypeg, pegged
[PEH] tempeh
[PEI] speiss, clupeid, peignoir, mythopeic, epeirogeny, clupeids, peignoirs
[PEJ] pejoration, pejorative, pejoratives, pejoratively
[PEK] pekan, pekoe, peke, pekineses, pekingese, pekans, pekes
[PEL] pipeline, spell, misspelled, appel, chapel, compelled, propeller
[PEM] apeman, pemmican, elopement, pemphigus, apopemptic, escapement, apemen
[PEN] append, open, penalty, independent, dependency, pending, happen
[PEO] people, peonage, speos, clupeoid, repeople, unpeople, dispeople
[PEP] pep, polypeptide, copepod, eupepsia, dipeptide, dyspepsia, peps
[PER] property, upper, operator, period, person, super, permission
[PES] types, shapes, scopes, escapes, stripes, recipes, slopes
[PET] peter, snippet, perpetual, repetition, petal, competition, petter
[PEU] clypeus, therapeutic, therapeutics, therapeutist, clypeuses
[PEV] grapevine, grapevines
[PEW] typewriter, spew, pewter, pewee, pewit, ropeway, gapeworm
[PEX] apex, auspex, tippex, aruspex, perspex, haruspex, epexegesis
[PEY] stripey, crepey, peyote, dopey, mopey, popeyed, strathspey
[PEZ] trapezoid, trapezoidal, trapezium, trapezoids, trapeze, trapezius, trapeziform
[PFA] deepfake, chapfallen, chopfallen, stepfather, deepfakes, stepfathers
[PFE] pfennig, pfennige, pfennigs
[PFI] campfire, lumpfish, shipfitter, shopfitter, shopfitting, campfires, shopfitters
[PFL] topflight
[PFO] sheepfold, sheepfolds
[PFR] deepfreeze, upfront, deepfrozen, leapfrog, shopfront, deepfroze, leapfrogged
[PFU] helpful, unhelpful, capful, cupful, lapful, skepful, topfull
[PGA] stopgap, topgallant, stopgaps, topgallants
[PGR] upgrade, campground, upgrading, upgraded, upgrades, upgradable, upgradeable
[PGU] popgun, popguns
[PHA] alpha, elephant, phantom, pharmacy, phase, emphasis, orphans
[PHE] cipher, gopher, pheasant, sphere, shepherd, hyphen, encipher
[PHI] amphibian, dolphin, graphite, philosophy, sapphire, isomorphic, pictographic
[PHL] pamphlet, phlegm, phlox, nymphlike, phlyctena, sylphlike, phloem
[PHN] daphne, daphnes
[PHO] megaphone, phone, photo, siphon, symphony, phoenix, semaphore
[PHR] diaphragm, phrase, paraphrase, phrenic, rephrase, tephra, uphroe
[PHS] glyphs, graphs, paragraphs, ideographs, digraphs, hieroglyphs, epigraphs
[PHT] diphtheria, naphtha, ophthalmology, phthisic, phthalein, monophthong, diphthongs
[PHU] tophus, typhus, scyphus, euphuism, sulphuryl, hiphuggers, euphuist
[PHY] atrophy, hypertrophy, physics, trophy, zephyr, bibliography, cryptography
[PIA] utopia, sepia, thespian, rupiah, piano, marsupial, apiary
[PIB] epiboly, pibroch, epiblast, pibrochs
[PIC] pickle, picture, typically, topic, pics, epic, tropical
[PID] spider, rapidly, stupid, intrepid, piddle, cupid, epidermis
[PIE] copies, piecewise, recipient, frontispiece, occupied, pier, pies
[PIF] spiffy, piffle, typify, yuppify, epifocal, napiform, pretypify
[PIG] pig, epigraph, epigynous, spigot, serpigo, epigeous, champignon
[PII] piing
[PIJ] jipijapa
[PIK] spike, pike, turnpike, garpike, pika, handspike, marlinespike
[PIL] compile, pillow, pilot, pupil, epilogue, recompile, pilgrim
[PIM] pimento, pimp, orpiment, pimiento, dissepiment, epimorphosis, pimple
[PIN] typing, mapping, pin, grouping, stopping, keeping, opinion
[PIO] pioneers, champion, copious, scorpion, pious, opioid, campion
[PIP] pipe, piping, pipping, bagpipe, epiphany, pips, pipage
[PIQ] piquet, piquant, pique, piquancy, piquante, piqued, piques
[PIR] spirit, empirical, expires, inspired, vampire, respiratory, pirate
[PIS] pis, episode, sharpish, despises, impish, mopish, papism
[PIT] capital, despite, pitch, spitfire, decrepit, hospital, pitfall
[PIU] europium, opium, marsupium, principium, opiumism
[PIV] pivot, spiv, apivorous, pivots, pivoting, pivoted, pivotal
[PIX] pixel, pixie, gigapixel, megapixel, terapixel, pixels, pix
[PIZ] pizza, epizoa, pizzas, pizzazz, pizzeria, pizzicato, epizoic
[PJA] flapjack, skipjack, slapjack, flapjacks, skipjacks
[PJE] kopje, propjet, kopjes, propjets
[PKE] upkeep, shopkeeper, shopkeeping, shopkeepers
[PKI] pumpkin, napkin, pipkin, bumpkin, limpkin, dropkick, pumpkinseed
[PKN] topknot, slipknot, topknots, slipknots
[PKW] pkwy
[PLA] replace, plain, platform, template, display, place, playwright
[PLE] example, tuple, samples, simple, complex, multiple, people
[PLI] split, implied, simplify, application, explicit, sampling, compliant
[PLO] plot, subplots, upload, explode, deployment, employment, implode
[PLU] plus, plugins, plural, plum, pluton, surplus, plunger
[PLY] apply, multiply, simply, supply, reply, comply, imply
[PMA] chapman, propman, shipman, topmast, helpmate, mapmaker, upmarket
[PME] development, equipment, chapmen, propmen, shipment, decampment, encampment
[PMI] topminnow, midshipmite, topminnows
[PMO] topmost, upmost, stepmom, gossipmonger, stepmother, stepmoms, stepmothers
[PMU] chipmunk, chipmunks
[PNA] hypnagogic
[PNE] apnea, dyspnea, pneumatic, pneumonia, sharpness, steepness, grapnel
[PNO] dipnoan, hypnoses, topnotch, slipnoose, dehypnotize, autohypnosis, posthypnotic
[POA] poachy, hypoacidity, poach, poacher, poaceous, poaching, poached
[POB] hypoblast, hypoblasts
[POC] epoch, pocket, poco, apocarp, pochard, lipocaic, adipocere
[POD] pod, sauropod, antipodal, pseudopod, tripod, arthropod, apodal
[POE] poetry, poem, hoopoe, poesy, subpoena, unpoetic, apoenzyme
[POF] ripoff, stopoff, ripoffs
[POG] typography, topography, pogo, hypogynous, appoggiatura, apogee, pogrom
[POI] appoint, point, poise, spoil, endpoint, midpoint, checkpoint
[POK] spokes, poke, poking, bespoke, cowpoke, kapok, yapok
[POL] poly, policy, polar, interpolate, poles, monopoles, extrapolate
[POM] pom, ipomea, lipoma, apomict, hypomania, paralipomena, pomelo
[PON] response, component, exponent, upon, corresponds, ponder, sponsor
[POO] pool, harpoon, poor, pooch, spool, poop, poodle
[POP] pop, lollipop, hippopotamus, repopulate, unpopulated, depopulate, lipoproteins
[POR] import, support, port, export, report, temporary, corporation
[POS] pos, purpose, transpose, composite, repository, opposite, expose
[POT] potential, hypothesis, spot, potato, idempotent, potter, teapot
[POU] compound, pour, pound, pouting, pouch, spouse, dropout
[POV] poverty, popover, slipover, stopover, sleepover, empoverish, impoverish
[POW] power, powder, horsepower, impower, empowerment, overpowering, powwow
[POX] pox, epoxy, cowpox, hypoxia, smallpox, chickenpox, hypoxanthine
[POY] charpoy, sepoy
[POZ] hypozeugma, hypozeuxis
[PPA] kappa, mappable, stoppage, apparently, apparatus, trappable, cuppa
[PPE] append, upper, wrapper, mapped, happen, dropped, skipped
[PPH] sapphire, sapphic, sapphism, sapphirine, sapphics, sapphires, sapphisms
[PPI] mapping, stopping, clipping, skipping, wrapping, overlapping, tipping
[PPL] apple, grapple, nipple, ripple, topple, supplied, pineapple
[PPO] support, unsupported, opposite, hippo, rapport, opportunity, disappointed
[PPR] approx, suppress, disapprove, oppression, unapproved, unsuppressed, dampproof
[PPS] apps, schnapps, repps
[PPU] pappus, cappuccino, oppugn, appulse, seppuku, eohippus, suppurate
[PPY] sloppy, happy, snappy, floppy, puppy, unhappy, gappy
[PRA] practice, pram, prayer, spray, pragmatic, impractical, praxis
[PRE] prefix, express, predict, present, precision, deprecated, pretty
[PRI] print, prime, prior, private, footprint, appropriate, spring
[PRO] property, protected, process, project, provided, product, program
[PRU] prune, cuprum, prudent, spruce, uprush, prurigo, prussic
[PRY] pry, spry, gossipry, prying, spryer, spryest, spryness
[PSA] psalm, knapsack, ripsaw, hopsack, sapsago, topsail, whipsaw
[PSC] upscale, hopscotch, rapscallion, hopscotched, hopscotches, hopscotching, rapscallions
[PSE] collapse, eclipse, lapse, pseudo, relapse, ellipse, elapsed
[PSF] capsful
[PSH] snapshot, upshot, pshaw, peepshow, slipshod, crapshoot, lampshade
[PSI] capsicum, epsilon, psi, upside, ellipsis, synopsis, collapsing
[PSK] sheepskin, cheapskate, sheepskins, cheapskates
[PSL] slipslop
[PSM] corpsman, corpsmen
[PSO] ellipsoid, calypso, dipso, opsonin, psoas, stepson, topsoil
[PSP] topspin, upspring, soupspoon, klipspringer, soupspoons
[PSQ] pipsqueak, pipsqueaks
[PST] upstream, lipstick, chopsticks, capstan, gypster, hipster, ripstop
[PSU] capsule, encapsulated, gypsum, lapsus, upsurge, jumpsuit, soapsuds
[PSW] upsweep, upswell, upswept, upswing, upswings
[PSY] autopsy, biopsy, gypsy, psychic, tipsy, dropsy, epilepsy
[PTA] adaptation, acceptance, unacceptable, heptagon, temptation, captain, adaptability
[PTB] sweptback, promptbook, promptbooks
[PTC] bankruptcy, bankruptcies
[PTE] chapter, helicopter, pterodactyl, pterosaur, scepter, adapted, accepted
[PTH] depth, upthrow, groupthink, depths, upthrust, upthrows, upthrusts
[PTI] option, caption, exception, description, assumptions, interruption, adaptive
[PTL] promptly, abruptly, raptly, adeptly, aptly, inaptly, ineptly
[PTN] aptness, raptness, adeptness, ineptness, abruptness, promptness, corruptness
[PTO] kleptomania, krypton, laptop, tiptoe, descriptor, cryptography, asymptotic
[PTR] uptrend, calyptra, claptrap, dioptric, temptress, catoptrics, sculptress
[PTS] opts, accepts, scripts, concepts, attempts, prompts, subscripts
[PTU] capture, sculpture, perceptual, conceptually, upturn, scripture, neptunium
[PTW] scriptwriter, sweptwing
[PTY] empty, nonempty, diptych, ptyalin, triptych, anaptyxis, polyptych
[PUB] public, republic, unpublished, pubs, pubes, brewpub, pubic
[PUC] puce, puck, cappuccino, capuche, prepuce, puccoon, puca
[PUD] pud, impudence, repudiate, spud, impudicity, pudding, puddle
[PUE] pueblo, puerile, spue, puerilism, puerility, puerperal, puerperium
[PUF] puff, puffs, puffed, puffer, puffin, puffery, puffy
[PUG] pug, impugn, oppugn, repugn, expugnable, inexpugnable, pugs
[PUI] puissance, impuissant, spuing, puissant, puisne, impuissance, puissances
[PUK] puke, puking, pukka, seppuku, puked, pukes
[PUL] pull, population, impulse, pulse, compulsory, manipulate, popularity
[PUM] pump, pumice, pummel, wampum, spume, puma, despumate
[PUN] punctuation, punitive, punt, spun, punk, expunge, punishment
[PUP] popup, pupil, puppet, pupa, slipup, pups, popups
[PUR] purpose, pure, impurity, purl, purify, spurious, purge
[PUS] push, corpus, opus, platypus, pappus, octopus, campus
[PUT] input, output, put, compute, precomputed, imputation, recompute
[PUZ] puzzle, puzzled, puzzler, puzzles, puzzling, puzzlement, puzzlers
[PWA] upwards, stopwatch, shipway, slipway, groupware, sheepwalk, sleepwalk
[PWE] upwell, knapweed, sleepwear, knapweeds, upwelling
[PWI] stepwise, tripwire, upwind, lapwing, shopwindow, lapwings, tripwires
[PWN] pwning, pwned
[PWO] sapwood, dropwort, pulpwood, shipworm, shopworn, slopwork, soapwort
[PWR] shipwreck, shipwright, shipwrecks, shipwrecked, shipwrights, shipwrecking
[PYA] copyable, pya, shipyard, scrapyard, pyas, shipyards, scrapyards
[PYB] copyboy, capybara, copybook, capybaras, copybooks
[PYC] copycat, poppycock, pycnidium, pycnometer, copycatted, copycatting, copycats
[PYD] copydesk
[PYE] copyedit, pye, empyema, copyediting, pyemia, pyelitis, copyeditor
[PYG] pygmy, pygidium, spyglass, uropygium, callipygean, steatopygia, pygmies
[PYH] copyholder, spyhole, poppyhead, sleepyhead, copyhold, copyholds, copyholders
[PYI] copying, occupying, photocopying, spying, espying, canopying, recopying
[PYK] pyknic
[PYL] copyleft, pylon, isopropyl, micropyle, propylene, pylons, pylori
[PYM] spymaster, spymasters
[PYO] pyosis, pyoid, pyorrhea, pyonephritis, pyorrheal
[PYR] pyre, pyramid, pyrite, pyromania, copyright, papyrus, pyrrhic
[PYT] python, pythons, pythoness, pythonesses
[PYU] pyuria
[PYW] spyware, copywriter, copywriting, copywriters
[PYX] pyx, pyxes, pyxie, pyxidium, pyxies
[PZA] pzazz
[QAD] qadi
[QAI] qaids, qaid
[QAL] sheqalim
[QAN] qanats, qanat
[QAT] qat, qats
[QEL] sheqel
[QIB] qibla
[QIN] qintar, qindarka, qintars, qindarkas
[QIR] faqir, faqirs
[QIV] qiviut
[QOP] qoph, qophs
[QTO] qto
[QTY] qty
[QUA] quack, quake, quality, quarter, equal, square, quad
[QUE] bouquet, queen, quest, queue, sequence, request, unique
[QUI] quick, quiet, quill, quiz, required, equivalent, quiver
[QUO] quoits, quorum, quota, unquote, quod, turquoise, sequoia
[QUY] exequy, obloquy, obsequy, colloquy, soliloquy, somniloquy, ventriloquy
[QWE] qwerty
[RAA] craal, kraal, kraals
[RAB] iterable, grab, parabola, separable, comparable, rabbit, undesirable
[RAC] bracket, extract, contract, character, trace, fraction, abstract
[RAD] radius, gradient, upgrade, trademark, downgrade, traditional, farad
[RAE] praetor, agorae, uraeus, pleurae, amphorae, brae, frae
[RAF] draft, traffic, craft, giraffe, graft, handcrafted, kraft
[RAG] average, storage, paragraph, coverage, ragged, fragment, subparagraph
[RAH] graham, tetrahedron, menorah, rah, subtrahend, sirrah, hurrah
[RAI] raise, train, constraints, braid, straight, algebraic, rainbow
[RAJ] trajectory, swaraj, raj, prajna, currajong, kurrajong, maharajah
[RAK] drake, rake, braking, mandrake, strake, anorak, kraken
[RAL] general, literal, integral, parallel, plural, central, several
[RAM] frame, parameters, program, histogram, diagram, grammar, wolfram
[RAN] range, random, transform, rank, warranty, granted, branch
[RAO] karaoke, pharaoh, intraocular, contraoctave, supraorbital, pharaohs, karaokes
[RAP] graph, wrap, digraph, ideograph, paragraph, bibliography, cryptography
[RAQ] paraquat, craquelure, terraqueous
[RAR] library, arbitrary, temporary, hierarchy, literary, rare, contrary
[RAS] extras, erasure, phrase, raster, crash, contrast, paras
[RAT] generate, operator, rational, iterator, enumerate, separate, integrate
[RAU] fraught, kraut, marauder, trauma, craunch, defraud, graupel
[RAV] unravel, grave, ravel, travel, engraver, brave, contravene
[RAW] draw, raw, redraw, crawl, straw, withdraw, faraway
[RAX] praxis, borax, anthrax, storax, styrax, thorax, abraxas
[RAY] array, gray, ray, tray, crayon, stray, prayer
[RAZ] craze, graze, razor, razz, brazil, raze, frazil
[RBA] verbatim, garbage, turban, tarball, urban, perturbation, disturbances
[RBE] barbell, perturbed, absorbed, riverbed, undisturbed, disturbed, elderberry
[RBI] arbitrary, orbital, forbidden, turbine, absorbing, disturbing, barbie
[RBL] marble, colorblind, garbled, superbly, burble, warble, purblind
[RBO] verbose, hyperbolic, turbo, checkerboard, carbon, airborne, mortarboard
[RBR] hairbreadth, airbrush, charbroil, interbred, merbromin, underbred, afterbrain
[RBS] barbs, absorbs, verbs, orbs, blurbs, adverbs, disturbs
[RBU] starburst, turbulence, airbus, earbud, arbutus, barbule, overbuy
[RBW] barbwire
[RBY] nearby, derby, forby, herby, passerby, carbylamine
[RCA] lowercase, uppercase, demarcate, orca, staircase, circa, embarcadero
[RCE] source, force, resource, intercept, percent, coerce, enforce
[RCH] arch, birch, church, march, torch, search, hierarchy
[RCI] exercise, commercial, forcing, coercion, enforcing, piercing, carcinogenic
[RCL] circle, superclass, semicircle, counterclaim, paperclip, encircle, parclose
[RCO] overcome, percolation, charcoal, zirconium, intercourse, interconnect, garcon
[RCR] hovercraft, aircraft, overcrop, intercrop, undercroft, watercraft, buttercream
[RCS] arcs, marcs, narcs, orcs
[RCT] arctic, infarction, antarctic, coarctate, subarctic, transarctic, subantarctic
[RCU] circuit, haircut, hypercube, mercury, semicircular, uppercut, percussive
[RCY] motorcycle, mercy, farcy, gramercy, motorcycles, motorcyclist, motorcycled
[RDA] chordal, accordance, yesterday, discordant, concordant, recordable, gardant
[RDB] hardball, cardboard, birdbath, wordbook, swordbill, hardback, birdbaths
[RDC] hardcover, birdcage, swordcraft, hardcore, birdcages, hardcovers
[RDE] order, border, unordered, recorded, reorder, discarded, forwarded
[RDF] regardful, swordfish, disregardful, swordfishes
[RDG] boardgames
[RDH] hardhat, birdhouse, cardholder, guardhouse, hardhack, hardheaded, hardhearted
[RDI] coordinate, according, ordinal, regarding, recording, cardinal, standardize
[RDL] regardless, hardly, weirdly, thirdly, absurdly, cowardly, awkwardly
[RDM] birdman, yardman, wardmote, orchardman, bombardment, retardment, yardmen
[RDN] ordn, hardness, weirdness, pardner, absurdness, inwardness, awkwardness
[RDO] hazardous, weirdo, fordo, overdo, stardom, cordovan, ordo
[RDP] hardpan, wordplay, swordplay, hardpans
[RDR] teardrop, overdraw, wardrobe, airdrop, eardrop, wizardry, boardroom
[RDS] words, keywords, records, backwards, leftwards, rightwards, towards
[RDT] hardtop, swordtail, birdtables, hardtack, hardtops, swordtails
[RDU] bordure, overdue, perdu, stardust, avoirdupois, ordure, arduous
[RDV] aardvark, aardvarks
[RDW] hardware, aardwolf, cordwain, gurdwara, boardwalk, birdwatcher, hardwired
[RDY] hardy, wordy, sturdy, curdy, lardy, nerdy, overdye
[REA] read, create, stream, break, real, reason, thread
[REB] hereby, rebuild, thereby, prebuilt, rebind, rebroadcast, whereby
[REC] direct, precision, rectangle, deprecated, record, correct, indirect
[RED] required, predict, red, shared, desired, ordered, stored
[REE] free, tree, degree, three, green, screen, agreement
[REF] ref, prefix, therefore, xref, careful, firefighter, irrefutable
[REG] regex, register, regular, regression, regard, aggregate, foreground
[REH] beforehand, warehouse, rehash, forehead, comprehend, apprehension, figurehead
[REI] herein, foreign, reinstall, therein, reinitialize, reinserts, wherein
[REJ] reject, prejudicial, rejoin, unprejudiced, aparejo, forejudge, rejuvenate
[REK] trek, rekindling, eureka, reknit, foreknew, scorekeeper, storekeeper
[REL] relax, release, correlation, rely, prerelease, relies, reload
[REM] remove, theorem, remainder, procurement, requirement, remember, increment
[REN] current, parent, reference, different, render, children, french
[REO] thereof, reorder, moreover, hereof, stereo, reopen, creoles
[REP] replace, repeat, report, prepare, represent, reproduce, grep
[REQ] freq, request, infrequent, prerequisite, prequel, lambrequin, unrequited
[RER] renderer, scorer, rerun, prerelease, bearer, reread, manufacturer
[RES] result, reserved, features, forest, express, present, reshape
[RET] return, pretty, retain, discrete, interpreter, retry, secret
[REU] reuse, hereunder, chartreuse, kreutzer, whereupon, reunion, thereupon
[REV] reverse, previous, revision, abbrev, breve, irrevocable, forever
[REW] rewrite, brewer, rewind, firewall, screw, reworked, prewarm
[REX] prexy, overextend, overexposure, lurex, murex, pyrexia, anorexia
[REY] palfrey, surrey, prey, murrey, osprey, comfrey, greyhen
[REZ] rezone, guereza, prezzie, warez, rezoned, rezones, guerezas
[RFA] interface, surface, warfare, waterfall, subsurface, airfare, carfare
[RFB] surfbird, surfboat, surfboard, surfbirds, surfboats, surfboards, surfboarded
[RFD] serfdom
[RFE] perfect, interfere, surfer, imperfect, forfeit, barfed, dwarfed
[RFI] surfing, superficial, overfilled, perfidy, hyperfine, interfile, garfish
[RFL] overflow, underflow, butterfly, superfluous, barfly, airflow, deerfly
[RFM] turfman
[RFO] performance, outperform, airfoil, fourfold, moorfowl, overfond, hyperform
[RFP] surfperch
[RFR] hoarfrost, airframe, doorframe, starfruit, riverfront, waterfront, airfreight
[RFS] surfs, dwarfs, barfs, scarfskin, smurfs, snarfs, serfs
[RFU] colorful, overfull, powerful, fearful, wonderful, perfunctory, earful
[RFY] scurfy, turfy
[RGA] organization, bargain, purgatory, reorganize, virga, forgat, ergative
[RGE] barge, charge, forge, large, merge, target, surge
[RGH] burghs, sorghum, barghest, narghile, larghetto, burgh, burghal
[RGI] margin, merging, energies, forgiving, diverging, converging, virgin
[RGL] hourglass, afterglow, interglacial, burgle, gargle, gurgle, airglow
[RGN] epergne, lorgnon, lorgnette, epergnes, lorgnettes
[RGO] forgotten, argon, cargo, ergo, jargon, gorgon, largo
[RGR] evergreen, wintergreen, undergrad, burgrave, hairgrip, margrave, overgrew
[RGS] reorgs, bergs, burgs, cyborgs, ergs, hamburgs, homburgs
[RGU] argument, arguably, virgule, burgundy, marguerite, morgue, tergum
[RGY] energy, allergy, synergy, orgy, anergy, argyle, clergy
[RHA] rhapsody, rhatany, perhaps, overhang, underhanded, dirham, rhachis
[RHE] diarrhea, rhea, rhetoric, rheumatism, overhead, letterhead, superhero
[RHI] rhino, rhizome, errhine, pyrrhic, murrhine, rhigolene, catarrhine
[RHO] rhododendron, rhomb, neighborhood, rhodamine, rhos, orthorhombic, barhop
[RHU] rhubarb, rhumb, overhung, scirrhus, underhung, superhuman, preterhuman
[RHY] rhyme, rhythm, arrhythmia, rhyolite, biorhythm, eurhythmy, unrhythmic
[RIA] variable, material, triangle, covariance, tutorial, factorial, appropriate
[RIB] attribute, distributed, contributor, redistribute, describe, ribbons, subscribe
[RIC] numeric, metric, strict, generic, matrices, categorical, symmetric
[RID] grid, override, stride, ridge, bridge, hybrid, ride
[RIE] series, categories, glossaries, entries, orient, libraries, directories
[RIF] verify, serif, purify, riff, clarify, drift, unverified
[RIG] right, copyright, original, playwright, trigger, bright, wright
[RIH] clerihew, bahuvrihi, perihelia, trihedral, trihydric, trihedron, perihelion
[RII] torii, sartorii, safariing
[RIJ] marijuana
[RIK] strike, tugrik, crikey, shrike, paprika, trike, tughrik
[RIL] necessarily, temporarily, primarily, arbitrarily, grille, ordinarily, customarily
[RIM] prime, trim, experimental, perimeter, discriminant, crimson, shrimp
[RIN] string, print, ring, during, centering, footprint, rendering
[RIO] period, prior, various, interior, criterion, serious, scenario
[RIP] description, script, strip, subscript, superscript, triple, roundtrip
[RIQ] perique, briquette, sobriquet, triquetrous, briquettes, sobriquets
[RIR] eyrir, trireme, sriracha, quadrireme, triremes
[RIS] iris, comparison, arising, asterisk, risk, christian, thyristor
[RIT] write, spirit, algorithm, rewrite, overwrite, priority, arithmetic
[RIU] equilibrium, triumph, barium, curium, bohrium, thorium, yttrium
[RIV] derivative, private, driver, trivial, nontrivial, arrive, river
[RIW] periwinkle, triweekly, contrariwise, periwig, periwigs, periwinkles
[RIX] matrix, directrix, rectrix, tectrix, varix, aviatrix, cicatrix
[RIY] riyal, teriyaki, riyals, teriyakis
[RIZ] drizzle, frizz, grizzly, horizon, parametrize, vectorized, factorize
[RJA] lumberjack, alforja, carjack, doorjamb, amberjack, natterjack, crackerjack
[RJE] surjection, interjects, serjeant, tearjerker, interject, interjection, interjectory
[RJO] overjoy, marjoram, interjoin, overjoys, overjoyed, overjoying
[RJU] perjure, forjudge, verjuice, perjury, perjurer, perjurious, perjured
[RKA] workaround, remarkably, meerkat, unremarkable, bidarka, burka, corkage
[RKB] workbook, corkboard, workbench, workbooks, workbag, workbasket, workbags
[RKD] markdown, workday, workdays, markdowns
[RKE] marker, worker, burke, forked, darker, reworked, turkey
[RKF] workflow, forkful, workflows, workforce, workfare, forkfuls, workforces
[RKH] workhorse, charkha, markhor, workhouse, markhors, workhorses, workhouses
[RKI] working, marking, forking, benchmarking, gherkin, networking, darkish
[RKK] markka, markkaa
[RKL] darkling, sparkle, workload, corklike, forklift, parkland, schnorkle
[RKM] workman, kirkman, embarkment, workmen, workmate, workmanlike, workmanship
[RKN] darkness, doorknob, interknit, starkness, semidarkness, doorknocker, doorknobs
[RKO] arkose, parkour, workout, kwashiorkor, workouts
[RKP] workplace, porkpie, workpiece, workpeople, porkpies, workpieces, workplaces
[RKR] darkroom, workroom, sauerkraut, darkrooms, workrooms
[RKS] works, marks, landmarks, networks, trademarks, benchmarks, remarks
[RKT] worktable, worktop, worktops, worktables
[RKU] markup, workup, markups, workups
[RKW] parkway, corkwood, workweek, jerkwater, workwoman, parkways, corkwoods
[RKY] perky, quirky, jerky, murky, smirky, snarky, sparky
[RLA] overlap, underlay, interlace, burlap, garland, parlance, superlative
[RLD] world, earldom, antiworld, afterworld, dreamworld, otherworld, underworld
[RLE] interleave, numberless, overleaf, harlequin, scarlet, starlet, colorless
[RLF] girlfriend, girlfriends
[RLH] girlhood, girlhoods
[RLI] underline, hyperlink, earlier, overline, berlin, interline, borderline
[RLK] erlking
[RLO] overload, interlocked, waterloo, charlotte, furlong, harlot, merlon
[RLP] whirlpool, curlpaper, whirlpools
[RLS] pearls, girls, swirls, churls, gnarls, knurls, skirls
[RLU] wanderlust, interludes, gaberlunzie, superlunary, interlude, interlunar, interluded
[RLW] whirlwind, whirlwinds
[RLY] early, underlying, curly, properly, clearly, similarly, formerly
[RMA] format, normal, information, performance, german, karma, permanent
[RMB] armband, warmblooded, armbands
[RMC] armchair, armchairs
[RME] transformer, performed, intermediate, formed, affirmer, malformed, reformed
[RMF] harmful, armful, unharmful, formfitting, harmfulness, armfuls, harmfully
[RMH] wormhole, armhole, farmhand, warmhearted, farmhouse, armholes, farmhands
[RMI] permission, determine, permitted, terminal, hermitian, fermi, thermistor
[RML] uniformly, harmless, firmly, armlet, farmland, formless, gormless
[RMN] firmness, warmness, uniformness, lukewarmness, infirmness
[RMO] harmonic, marmot, furthermore, thermocouple, armor, innermost, outermost
[RMP] armpit, stormproof, armpits
[RMR] armrest, armrests
[RMS] terms, forms, platforms, transforms, performs, norms, perms
[RMT] warmth
[RMU] formula, permutation, murmur, reformulated, armure, earmuff, bermudas
[RMW] firmware, formwork, wormwood
[RMY] stormy, army, formyl, smarmy, barmy, germy, squirmy
[RNA] external, internal, alternative, journal, username, ternary, ornament
[RNB] cornball, hornbeam, turnbuckle, hornbill, hornbook, cornbread, hornblende
[RNC] corncob, turncoat, corncrib, corncrake, corncobs, turncoats, corncrakes
[RND] dirndl, turndown, turndowns
[RNE] kernel, returned, corner, turned, harness, governed, internet
[RNF] cornflower, mournful, scornful, urnfield, cornfield, cornflakes, cornflake
[RNG] cairngorm, cairngorms
[RNH] cornhusk, cornhusks, cornhusking, cornhuskings
[RNI] warning, furnished, learning, returning, quaternion, governing, kerning
[RNK] turnkey, turnkeys
[RNL] hornless, patternless, sternly, modernly, forlornly, slatternly, southernly
[RNM] government, adornments, cornmeal, sternmost, internment, adjournment, discernment
[RNN] sternness, modernness, forlornness, stubbornness
[RNO] turnout, inferno, governor, afternoon, journo, burnout, carnotite
[RNP] turnpike, cornpone, hornpipe, sternpost, cornpones, hornpipes, turnpikes
[RNR] cornrow, cornrows, cornrowed, cornrowing
[RNS] returns, warns, patterns, turns, horns, concerns, externs
[RNT] burnt, horntail, turntable, unburnt, turntables
[RNU] cornu, sternum, alburnum, cernuous, laburnum, viburnum, bitternut
[RNW] hornwort, sternway, hornworts
[RNY] thorny, carny, corny, ferny, horny, barnyard, barnyards
[ROA] broadcast, croak, approach, roaming, railroad, road, rebroadcast
[ROB] robust, problem, robin, subproblem, acrobat, robot, microbe
[ROC] process, preprocessed, roc, reciprocal, unprocessed, crochet, morocco
[ROD] product, reproduce, introduction, rod, tetrode, goldenrod, eroded
[ROE] zeroes, roe, androecium, heroes, uphroe, euphroe, proem
[ROF] profile, retroflex, hydrofoil, microfilm, unprofitable, shroff, croft
[ROG] program, hieroglyph, surrogate, spectrogram, roger, hydrogen, derogatory
[ROH] prohibited, microhenry, chlorohydrin, unprohibited, prohibit, prohibits, prohibition
[ROI] adroit, android, asteroid, broil, centroid, steroid, spheroidal
[ROJ] project, introject, electrojet, projection, projects, projections, projected
[ROK] stroke, broken, unbroken, keystroke, grok, heartbroken, upstroke
[ROL] controls, role, rolling, scroll, prologue, corollary, astrological
[ROM] from, roman, prompt, chromium, meromorphic, aromatic, micrometer
[RON] environment, strong, wrong, front, macron, electron, acronym
[ROO] root, proof, room, maroon, uproot, broom, rook
[ROP] property, drop, entropy, appropriate, crop, propagate, proportion
[ROQ] baroque, croquet, roque, chloroquine, hydroquinone, croquette, roquelaure
[ROR] error, mirror, horrors, prorated, aurora, furor, terrorist
[ROS] zeros, cross, macros, across, erosion, microsecond, prosper
[ROT] protected, rotate, protocol, grot, wrote, parrot, protrusion
[ROU] group, round, background, around, through, routine, foreground
[ROV] provided, improve, approved, trove, groves, provenance, provable
[ROW] row, arrow, browser, throw, grow, narrow, crown
[ROX] approx, proxy, xerox, hydroxyl, peroxide, tetroxide, paroxysm
[ROY] royalty, destroy, troy, arroyo, viceroy, stroy, corduroy
[ROZ] frozen, unfrozen, deepfrozen, croze, hydrozoan, merozoite, sporozoite
[RPA] counterpart, surpasses, overpass, underpass, carpal, tarpan, warpage
[RPE] perpetual, warped, serpent, sharpen, arpeggio, carpenter, torpedo
[RPH] amorphous, morph, orphan, polymorph, isomorphic, meromorphic, homomorphism
[RPI] hairpin, earpiece, scorpion, caterpillar, warping, sharpish, masterpiece
[RPL] purple, boilerplate, perplexity, airplane, hyperplane, surplus, doorplate
[RPM] escarpment, escarpments
[RPN] sharpness
[RPO] purpose, corporation, interpolate, incorporated, harpoon, airport, multipurpose
[RPR] interpreter, fingerprint, overprint, surprising, enterprise, reinterpret, misinterpret
[RPS] corps, warps, chirps, stirps, turps, harpsichord, sharpshooter
[RPT] excerpt, absorption, sorption, adsorption, resorption, reabsorption, desorption
[RPU] corpus, cyberpunk, carpus, purpura, sourpuss, metacarpus, counterpunch
[RPY] chirpy, harpy, hyperpyrexia
[RQU] marquee, torque, turquoise, parquet, remarque, cirque, charqui
[RRA] array, warranty, irrational, errata, rearrange, barracuda, narrative
[RRE] current, correct, recurrence, starred, arrester, deferred, inferred
[RRH] catarrh, cirrhosis, diarrhea, hemorrhage, myrrh, arrhythmia, errhine
[RRI] override, barrier, carrier, referring, territory, occurring, curriculum
[RRO] error, arrow, mirror, narrow, parrot, surrogate, surrounding
[RRS] errs, burrstone, chirrs, churrs, shirrs, birrs, parrs
[RRU] interruption, corrupt, overrun, garrulous, cirrus, stirrup, uncorrupted
[RRY] carry, sorry, berry, worry, blackberry, cherry, curry
[RSA] ampersand, universal, traversal, versa, transversal, reversal, ersatz
[RSB] passersby, hairsbreadth
[RSC] superscript, underscore, kirsch, overscore, butterscotch, airscrew, fourscore
[RSE] parse, sparse, inverse, reverse, intersection, course, endorse
[RSH] marshal, ownership, authorship, membership, partnership, watershed, overshoot
[RSI] version, parsing, conversion, recursion, university, cursive, sparsity
[RSK] rollerskate, torsk, bearskin, deerskin, overskirt, samarskite, underskirt
[RSL] warsle, harslet, parsley, nursling, purslane, oversleep, underslung
[RSM] oarsman, steersman, supersmart, coppersmith, silversmith, frontiersman, oarsmen
[RSN] persnickety, parsnip, gingersnap, guttersnipe, parsnips, gingersnaps, guttersnipes
[RSO] person, cursor, verso, parsons, reverso, torso, cumbersome
[RSP] perspective, interspersed, airspeed, forspent, superspy, fluorspar, hairspray
[RSQ] foursquare
[RST] first, understand, worst, erst, starburst, burst, verst
[RSU] versus, pursuit, marsupial, thyrsus, excursus, persuaded, dorsum
[RSW] bittersweet, forswear, oarswoman, oversweet, forswore, forsworn, oarswomen
[RSY] pursy, forsythia, outdoorsy, controversy, supersystem, forsythias
[RTA] important, certain, pertaining, uncertainty, portable, mortal, spartan
[RTB] heartbeat, dirtball, dartboard, shortbread, heartbroken, heartbeats, heartburn
[RTC] shortcut, portcullis, shortcuts, shortcake, shortcoming, shortcomings, shortcrust
[RTE] sorted, supported, converted, vertex, inverted, shortest, unsupported
[RTF] portfolio, shortfall, artful, hurtful, effortful, heartfelt, shirtfront
[RTG] mortgage, concertgoer, remortgage, mortgages, mortgagee, mortgagor, mortgageable
[RTH] birth, earth, fourth, north, worth, further, orthogonal
[RTI] partial, vertical, properties, starting, artist, bipartite, advertising
[RTL] turtle, partly, shortly, overtly, smartly, myrtle, heartland
[RTM] department, compartment, assortment, portmanteaus, mortmain, apartment, deportment
[RTN] partnership, shortness, curtness, pertness, tartness, alertness, copartner
[RTO] kurtosis, tortoise, repertoire, cartouche, barton, burton, quarto
[RTP] smartphone, smartphones
[RTR] portrait, chartreuse, cartridge, tartrate, summertree, fortress, courtroom
[RTS] parts, supports, starts, ports, reports, imports, converts
[RTT] shirttail, shirttails
[RTU] virtual, startup, perturb, aperture, torture, opportunity, unfortunate
[RTW] cartwheeling, artwork, partway, intertwined, heartwood, shortwave, shirtwaist
[RTY] property, party, dirty, thirty, smarty, forty, countertype
[RTZ] hertz, megahertz, quartz, gigahertz, kilohertz, terahertz, quartzite
[RUA] truant, accrual, construal, menstrual, premenstrual, truancy, menstruate
[RUB] ruby, rubber, rubric, scrub, ruble, rubidium, shrubbery
[RUC] structure, construct, instructions, reconstruct, destructor, unstructured, crucial
[RUD] crude, extrude, rudimentary, prudent, protrude, intrude, ruddy
[RUE] true, construed, congruence, rue, cruel, accrue, gruel
[RUF] ruff, woodruff, cruft, rufous, scruff, gruff, rufiyaa
[RUG] shrugging, drug, rug, struggles, trug, frugal, grugru
[RUI] floruit, fruit, cruise, bruise, ruin, kiwifruit, grapefruit
[RUK] peruke, perukes
[RUL] rule, truly, ruling, cerulean, overrule, garrulous, curule
[RUM] spectrum, instruments, centrum, forum, trump, crumbs, drum
[RUN] run, truncate, rerun, prune, shrunk, overrun, crunch
[RUO] congruous, incongruous, congruously
[RUP] interruption, corrupt, quadruple, disrupt, rupee, rupiah, abruptly
[RUR] rural, crural, prurigo, macruran, nonrural, chirurgeon, interurban
[RUS] trust, rust, intrusive, protrusion, thrust, brush, chorus
[RUT] strut, brute, truth, crutch, ruth, scrutinize, inscrutable
[RUU] menstruum
[RUV] pyruvate
[RUW] thruway, thruways
[RUX] crux, cruxes
[RUZ] cruzeiro, cruzado, cruzeiros
[RVA] interval, observations, curvature, conservative, preservation, pervasive, unobservable
[RVE] reserved, server, curve, observed, preserve, survey, unobserved
[RVI] service, overview, survive, curvilinear, preserving, supervised, unsupervised
[RVO] reservoir, arvo, nervous, servo, fervor, chervonets, clairvoyant
[RVS] pervs
[RVY] curvy, scurvy, nervy
[RWA] forward, afterwards, earwax, motorway, underwater, airway, carwash
[RWE] overweight, underweight, interweave, spiderweb, burweed, forwent, tarweed
[RWH] narwhals, overwhelm, forwhy, gearwheel, otherwhere, underwhelm, waterwheel
[RWI] otherwise, pairwise, earwig, overwind, clearwing, underwing, cornerwise
[RWO] afterword, underwood, jabberwocky, interwoven, overworking, forworn, airwoman
[RWR] overwrite, underwriter, overwritten, overwriting, overwrites, overwrote, underwrite
[RWU] liverwurst
[RYA] rya, dryad, carryall, caryatid, dooryard, hamadryad, lumberyard
[RYB] everybody, storyboard, crybaby, ferryboat, corybantic, jerrybuilt, storybook
[RYC] barycentric, carrycot, jerrycan, currycomb, strychnic, terrycloth, barycenter
[RYD] everyday, corydalis, shandrydan, corydalises
[RYE] dryer, rye, wryest, barye, fryer, gramarye, hairdryer
[RYG] apterygial, borborygmus
[RYI] trying, varying, querying, crying, carrying, retrying, worrying
[RYL] beryllium, acrylic, fairyland, storyline, tetryl, pteryla, aryl
[RYM] corymb, juryman, tryma, dairyman, everyman, ferryman, lacrymal
[RYN] larynx, pharynx, dryness, eryngo, wryneck, spryness, nasopharynx
[RYO] everyone, carryon, baryons, cryogenic, bryony, embryo, tryout
[RYP] crypt, encrypt, krypton, decrypt, tryptophan, drypoint, apocrypha
[RYS] chrysalis, crystal, tryst, aneurysm, drys, xenocryst, chrysolite
[RYT] everything, baryta, erythema, arytenoid, eurythmic, fairytale, prytaneum
[RYV] hryvnia
[RYW] everywhere, drywall, entryway, jurywoman, worrywart, dairywoman, countrywide
[RYX] apteryx, oryx, oryxes, apteryxes
[RYZ] coryza, coryzas
[RZA] sforzando, mirza, forzando, scherzando, sforzati, sforzato, sforzandi
[RZE] furze, terzetto, overzealous, terzettos
[RZI] marzipan, bilharzia, bilharziases, bilharziasis
[RZO] borzoi, scherzo, orzo, borzois, scherzos
[RZU] zarzuela
[RZY] furzy
[SAB] disable, usable, licensable, addressable, reusable, traversable, disposable
[SAC] transaction, sac, knapsack, ambsace, amesace, cossack, hopsack
[SAD] sad, disadvantage, palisades, crusader, sysadmin, dorsad, pesade
[SAE] bursae, medusae, vibrissae, visaed
[SAF] safe, unsafe, safari, saffron, asafetida, disaffirm, safranine
[SAG] message, usage, sag, massage, passage, disagree, sausage
[SAH] icosahedral, tussah, sahib, sahuaro, madrasah, memsahib, icosahedron
[SAI] said, mosaic, sailor, saint, assail, aforesaid, bonsai
[SAK] sake, namesake, forsake, keepsake, moussaka, godforsaken, unforsaken
[SAL] sale, universal, salt, traversal, proposal, disallow, psalter
[SAM] same, samples, resample, subsample, disambiguate, sesame, samba
[SAN] sans, sanitize, ampersand, thousand, sandbox, sane, puissance
[SAP] disappear, asap, sap, misapplied, sousaphone, misapprehend, sarsaparilla
[SAR] glossaries, necessary, unnecessary, sari, adversary, cesar, sard
[SAS] disassemble, sass, disastrous, sashay, abscissas, mantissas, disassociate
[SAT] satisfy, satellite, saturation, compensation, condensation, unsatisfied, unsaturated
[SAU] dinosaur, sauna, sausage, saute, saucer, assault, sauropod
[SAV] save, saving, savoring, savage, savvy, unsavory, screensaver
[SAW] saw, jigsaw, seesaw, pitsaw, ripsaw, backsaw, bandsaw
[SAX] sax, transaxle, saxophone, saxophones, saxhorn, saxtuba, saxifrage
[SAY] say, essay, assay, hearsay, daresay, gainsay, unsay
[SBA] crossbar, husband, gasbag, mossback, ratsbane, wolfsbane, canvasback
[SBE] misbehave, asbestosis, cicisbeo, grosbeak, crossbeam, misbecome, misbelief
[SBI] lesbian, crossbill, busbies, lesbianism, lesbians, crossbills
[SBL] glassblower, glassblowing, glassblowers
[SBO] chessboard, crossbones, busboy, blesbok, gemsbok, newsboy, rasbora
[SBR] misbrand, crossbred, disbranch, hairsbreadth, crossbreed, crossbreeds
[SBU] disburse, fussbudget, mossbunker, disbursal, disbudding, disbursement, disbud
[SBY] busby, passersby, presbyter, presbyopia, presbyopic, presbytery, presbyteral
[SCA] scale, escape, scan, scatter, landscape, discard, pascal
[SCE] descent, ascending, scene, coalesce, crescent, isosceles, susceptible
[SCH] scheme, scholar, schnitzel, schwa, eschar, reschedule, kirsch
[SCI] conscience, fascinate, science, scissors, oscillator, discipline, abscissa
[SCL] disclaimer, muscle, disclosed, sclera, mascle, sclaff, mesclun
[SCO] score, scope, underscore, discovery, disconnect, discouraged, cisco
[SCR] scrap, scream, description, script, discrete, subscript, superscript
[SCS] discs, fiscs, videodiscs
[SCU] scuba, scuff, sculpt, scurry, discussion, masculine, obscured
[SCY] scyphi, scythe, hyoscyamus, scyphus, scyphate, scyphozoan, hyoscyamine
[SDA] rigsdaler, disdain, misdate, domesday, doomsday, mesdames, disdainful
[SDE] misdeal, newsdealer, transdermal, misdeed, misdeem, misdealt, misdefine
[SDI] jurisdiction, misdirected, asdic, misdiagnose, misdid, misdial, misdirect
[SDO] wisdom, misdo, unwisdom, misdoes, misdone, misdoing, misdoubt
[SDR] eavesdrop, eavesdropped, eavesdropper, eavesdrops
[SDU] transduction, dryasdust, transducer, transducers
[SEA] search, research, season, seal, seamless, disease, seagull
[SEB] baseball, phrasebook, cheeseburger, fusebox, nosebag, rosebay, sebum
[SEC] second, section, subsection, intersection, milliseconds, secret, security
[SED] used, licensed, closed, passed, based, raised, preprocessed
[SEE] see, licensee, addressee, unseen, foresee, fusee, reseeding
[SEF] useful, purposefully, casefy, easeful, horsefly, housefly, rosefish
[SEG] segment, segfault, segno, segregate, wiseguys, subsegment, assegai
[SEH] household, falsehood, gooseherd, hawsehole, horsehair, leasehold, caseharden
[SEI] abseil, seine, seismic, seize, aseity, casein, ossein
[SEJ] sejant
[SEK] housekeeping, housekeeper, housekeepers
[SEL] self, select, itself, baseline, sell, themselves, useless
[SEM] ensemble, semi, assemble, semantic, semaphore, endorsement, semester
[SEN] present, send, sent, represent, chosen, sense, absence
[SEO] closeout, gaseous, praseodymium, caseose, osseous, roseola, griseous
[SEP] separate, sept, sepia, horsepower, inseparable, mousepad, sepses
[SEQ] seq, subsequent, consequently, obsequy, inconsequent, sequence, sequences
[SER] assert, series, insert, reserved, user, parser, server
[SES] raises, classes, cases, licenses, uses, aliases, session
[SET] set, offset, reset, subset, dataset, preset, typeset
[SEU] pseudo, museum, closeup, diseur, poseur, danseur, friseur
[SEV] seven, persevering, whosever, asseverate, oversevere, dissever, inseverable
[SEW] elsewhere, coursework, sewing, rosewood, pesewa, sewage, oversew
[SEX] sextant, unisex, bissextile, sexagenary, sexdecillion, sexily, sexpot
[SEY] jersey, bullseye, odyssey, causey, horsey, kersey, malmsey
[SFA] satisfactory, disfavor, satisfaction, disfavors, disfavored, disfavoring
[SFE] transfer, misfeature, sferics, disfeature, misfeasance, transferred, transferring
[SFI] satisfied, transfigure, unsatisfied, misfit, transfinite, dissatisfied, crossfire
[SFL] newsflash, newsflashes
[SFO] transform, misfortunes, kinsfolk, sforzati, coltsfoot, townsfolk, tradesfolk
[SFR] disfrock, hausfrau, disfranchise
[SFU] successful, unsuccessful, capsful, sfumato, blissful, glassful, stressful
[SFY] satisfy, unsatisfying, dissatisfy, satisfying, satisfyingly
[SGA] misgave, billingsgate
[SGE] transgender, dysgenic, phosgene, cisgender, diphosgene, phosgenite, transgenic
[SGI] thanksgiving, busgirl, misgive, newsgirl, almsgiver, salesgirl, misgiven
[SGO] misgovern, disgorgement, disgorge, disgorged, disgorges, disgorging, misgoverns
[SGR] newsgroups, disgraced, grosgrain, palsgrave, sgraffiti, disgruntle, dysgraphia
[SGU] disguise, misguided, undisguised, disguised, disgusting, misguide, disgusted
[SHA] shadow, shake, shape, shark, reshape, shall, marshal
[SHB] pushbutton, dashboard, cashbox, bushbuck, fishbolt, washbowl, wishbone
[SHC] flashcards, trashcan, ashcan, fishcake, pushcart, bushcraft, dishcloth
[SHD] washday, splashdown, washdays, splashdowns
[SHE] shed, sheep, shelf, published, furnished, dashed, hashes
[SHF] bashful, cashflow, wishful, blushful, bushfire, bashfulness, wishfulness
[SHG] fishgig, flashgun, fishgigs, flashguns
[SHH] fishhook, washhouse, bushhammer, fishhooks, washhouses
[SHI] shield, shift, shine, ship, shirt, relationship, ownership
[SHK] kishke, droshky, babushka, piroshki, kishkes, babushkas, droshkies
[SHL] freshly, flashlight, foolishly, stylishly, ashlar, fleshly, bushland
[SHM] punishment, fishmonger, admonishment, diminishment, shmear, shmuck, bushman
[SHN] freshness, fishnet, lushness, rashness, shnorrer, brashness, harshness
[SHO] shock, shoe, shoot, shop, short, should, show
[SHP] pushpin, dashpot, dishpan, fishpond, fleshpot, fishplate, dishpans
[SHR] shred, shriek, shrub, mushroom, shrank, enshrine, ashram
[SHS] washstand, washstands
[SHT] hashtag, borsht, shtick, ashtray, bushtit, washtub, fishtail
[SHU] shuck, shudder, shuffle, shun, shut, shushing, shul
[SHW] bushwa, dishware, fishwife, meshwork, brushwood, washwoman, freshwater
[SHY] ashy, bushy, fishy, flashy, shy, pushy, fleshy
[SIA] hessian, fuchsia, artemisia, ecclesiastic, enthusiasm, cassia, mesial
[SIB] visible, possible, sibling, feasible, accessible, impossible, responsible
[SIC] basic, classic, physics, musical, intrinsic, geodesic, extrinsic
[SID] side, inside, outside, consider, residual, upside, aside
[SIE] easier, sieve, transient, sienna, siemens, sierra, dossier
[SIF] classifier, sift, densify, falsified, massif, intensify, declassify
[SIG] sign, assign, sigma, unsigned, design, unassigned, insight
[SIK] sika, sike, sikas
[SIL] epsilon, easily, silent, upsilon, silicon, silhouette, silver
[SIM] simple, similar, simulate, assimilated, sims, facsimile, sima
[SIN] single, using, missing, since, arising, parsing, processing
[SIO] version, fusion, extension, precision, expression, permission, dimension
[SIP] sip, dissipated, gossip, insipid, basipetal, erysipelas, fissiparous
[SIQ] physique, physiqued, physiques
[SIR] desired, undesirable, siren, sirrah, sirdar, sirloin, sirocco
[SIS] basis, thesis, analysis, consistent, ellipsis, resistor, synopsis
[SIT] position, density, visit, site, composite, repository, university
[SIU] symposium, hassium, magnesium, potassium, dysprosium, cesium, indusium
[SIV] exclusive, recursive, inclusive, intrusive, cursive, expensive, permissive
[SIX] six, sixth, sixteen, sixty, sixteenth, sixteenths, sixths
[SIZ] capsize, sizable, size, sizzle, resize, parenthesize, sizing
[SJA] sjambok, crossjack, crossjacks
[SJE] disject
[SJI] masjid, musjid, masjids, musjids
[SJO] disjoint, misjoinder, disjoin, disjointed, disjoins, disjoined, disjoints
[SJU] disjunction, misjudge, disjunctive, disjunctions, disjunct, disjuncture, misjudgment
[SKA] skate, rollerskate, askance, boskage, britska, skald, saskatoon
[SKB] taskbar, whiskbroom, whiskbrooms
[SKE] skeet, skeleton, sketch, skewer, skeptic, masked, asked
[SKF] taskforce
[SKI] ski, asking, masking, risking, multitasking, unmasking, buskin
[SKL] briskly
[SKM] muskmelon, taskmaster, taskmistress, muskmelons, taskmasters
[SKN] briskness
[SKO] muskox, skoal, skosh, skol, skoals, muskoxen
[SKR] muskrat, muskrats
[SKS] tasks, masks, risks, disks, asks, asterisks, unmasks
[SKT] desktop, desktops
[SKU] skua, skulk, skunk, numskull, skull, skunks, skullcap
[SKW] taskwork
[SKY] dusky, husky, pesky, risky, sky, frisky, bosky
[SLA] slash, backslash, translate, slack, slant, islands, slave
[SLE] sleep, lossless, misleading, sleuth, sled, sleave, slept
[SLI] slice, slide, slightly, slit, slim, slip, dislike
[SLO] slope, slot, slow, sloven, sloop, slob, slogan
[SLU] slug, slurp, translucent, slum, sludge, sluice, slushy
[SLY] grisly, sly, previously, expressly, grossly, obviously, analogously
[SMA] dismal, small, smart, smash, smatter, mismatch, plasma
[SME] smear, smell, cosmetic, assessment, smegma, kinsmen, busmen
[SMI] smile, smirk, smite, transmission, dismiss, transmitted, cosmic
[SMO] smock, smog, smoke, smolder, smooth, transmogrify, cosmology
[SMS] mechanisms, isomorphisms, paralogisms, isms, organisms, catechisms, neologisms
[SMU] smug, smudge, smut, transmute, bismuth, smurf, inasmuch
[SNA] snack, snag, snail, snake, snap, misnamed, snare
[SNE] sneak, sneer, fresnel, seriousness, recklessness, puisne, demesne
[SNI] snicker, sniff, snip, persnickety, snider, snitch, snivel
[SNO] snob, snoop, snore, snow, snout, misnomer, snot
[SNU] snub, snuff, snug, misnumber, snuggle, snuggles, snuffy
[SOA] soap, soaked, soared, outsoar, presoak, psoas, soave
[SOB] sob, isobaric, disobey, mesoblast, chrysoberyl, insobriety, sober
[SOC] socket, associated, society, soccer, unassociated, disassociate, dissociate
[SOD] sodium, episode, prosody, soda, sodomized, sodded, mesoderm
[SOE] whatsoever, soever, fatsoes, howsoever, whosoever, whensoever, whomsoever
[SOF] software, sofar, softness, softball, insofar, semisoft, softcover
[SOG] isogon, soggily, mesoglea, misogamy, dissogeny, kissogram, nosography
[SOH] gasohol
[SOI] soil, soiree, topsoil, sinusoidal, ellipsoid, vichyssoise, assoil
[SOJ] sojourn, sojourner, sojourns, sojourned, sojourners, sojourning
[SOK] soke
[SOL] solve, resolve, absolute, console, solution, solid, isolated
[SOM] some, isomorphic, blossom, awesome, isometric, insomuch, troublesome
[SON] person, reason, comparison, meson, consonant, bison, boson
[SOO] soon, bassoon, soothe, forsook, gossoon, monsoon, nainsook
[SOP] philosophy, sop, drosophila, hyssop, isopod, milksop, soursop
[SOR] sort, tensor, cursor, divisor, accessor, processor, regressor
[SOS] isosceles, lassos, versos, isostasy, lysosomal, sostenuto, mesosphere
[SOT] isotope, sot, anisotropic, esoteric, besot, risotto, creosote
[SOU] soul, sound, soup, sour, south, resource, sought
[SOV] crossover, soviet, sovereign, sovran, passover, dorsoventral, crossovers
[SOW] sow, disown, resow, curassow, cassowary, sower, sown
[SOX] bobbysoxer, bobbysoxers
[SOY] soy, paduasoy, soybeans, soybean, soymilk, soymilks
[SOZ] sozzled, lysozyme
[SPA] space, spade, spark, spatula, whitespace, span, dispatch
[SPB] raspberry, crispbread, crispbreads, raspberries
[SPE] speak, special, speed, spell, aspect, inspect, respect
[SPH] asphalt, atmosphere, sphere, sphinx, biosphere, hemisphere, phosphorus
[SPI] spice, spider, spike, spill, spin, spirit, despite
[SPL] splash, splendid, splinter, splurge, display, splitter, misplaced
[SPN] dyspnea, crispness, dyspneas
[SPO] spoil, spoke, sponge, spoon, sport, response, transpose
[SPR] sprain, spread, spring, newsprint, sprockets, spruce, misprint
[SPS] lisps, clasps, crisps, grasps, cusps, gasps, hasps
[SPU] spud, spume, spun, spur, disputes, sputnik, transputer
[SPY] crispy, espy, spy, wispy, raspy, superspy, counterspy
[SQU] squad, squid, squeeze, basque, risque, bisque, mosque
[SRA] disrate, lebensraum
[SRE] disregard, misread, newsreel, disrelish, disrepair, disremember, disrespect
[SRI] sri, sriracha
[SRO] classroom, grassroots, disrobe, messroom, newsroom, crossroad, pressroom
[SRU] disrupt, misrule, sruti, crossruff, disruption, disruptive, disrupted
[SSA] message, glossaries, necessary, mantissa, unnecessary, massage, puissance
[SSB] chessboard, crossbones, mossback, passbook, brassbound, crossbreed, fussbudget
[SSC] crosscheck, crisscross, crosscurrent, crosscutting, crosscut, crosscuts, crosschecks
[SSE] assert, classes, passed, preprocessed, lesser, compressed, expressed
[SSF] successful, unsuccessful, blissful, glassful, crossfire, stressful, distressful
[SSH] crosshatch, glasshouse, misshape, dosshouse, transship, grasshopper, crossheads
[SSI] missing, assign, possible, expression, permission, classic, regression
[SSJ] crossjack, crossjacks
[SSK] passkey, passkeys
[SSL] expressly, lossless, grossly, needlessly, seamlessly, shamelessly, hassle
[SSM] assessment, businessman, pressman, chessman, glassman, messmate, classmate
[SSN] recklessness, crassness, crossness, grossness, remissness, agelessness, aimlessness
[SSO] associated, lasso, accessor, processor, regressor, successors, compressor
[SSP] misspelled, passport, cesspit, fusspot, tosspot, grassplot, misspoken
[SSQ] grassquit
[SSR] classroom, grassroots, messroom, crossroad, pressroom, crossruff, crossroads
[SST] asst, guesstimate, misstep, crosstie, newsstand, mosstrooper, misstate
[SSU] issue, assume, pressure, tissue, reassurances, possum, colossus
[SSW] password, guesswork, crossword, expressways, basswood, brassware, classwork
[SSY] glossy, messy, fussy, classy, grassy, sassy, mossy
[STA] stack, stage, stair, stamp, star, state, distance
[STB] postbox, testbed, dustbin, fastback, frostbit, eastbound, firstborn
[STC] postcard, dustcart, testcard, waistcoat, christcross, priestcraft, postcode
[STD] stdio, postdate, postdoc, postdiluvian, postdoctoral, postdocs, postdated
[STE] steak, steel, step, system, instead, register, nested
[STF] postfix, restful, boastful, trustful, breastfed, fistful, lustful
[STG] postgraduate, stge, coastguard, postglacial, coastguards
[STH] aesthetic, asthma, isthmus, masthead, sthenic, dustheap, esthesia
[STI] stick, stiff, still, sting, stir, estimator, testing
[STL] bristle, castle, nestle, rustle, whistle, mostly, costly
[STM] adjustment, postmark, investment, readjustment, dustman, ostmark, costmary
[STN] robustness, chestnut, vastness, fastness, justness, moistness, postnasal
[STO] stock, stomach, stone, stool, stop, custom, store
[STP] postponed, dustpan, breastpin, rustproof, postpartum, postprandial, postpaid
[STR] straight, street, strong, string, distributed, structure, construct
[STS] tests, exists, lists, consists, requests, artists, costs
[STU] stubborn, student, stuff, gesturing, stupid, stuck, postulate
[STV] zemstvo
[STW] trustworthy, eastward, postwar, westward, coastward, frostwork, leastwise
[STY] crusty, dusty, frosty, rusty, style, amnesty, nasty
[SUA] usually, visual, unusual, casual, pursuant, issuance, suave
[SUB] sub, unsubscribed, resubmitting, chasuble, oversubtle, supersubtle, unsubdued
[SUC] such, success, suck, unsuccessful, nonesuch, suction, sucres
[SUD] sud, soapsuds, transude, suddenly, sudden, sudor, sudsy
[SUE] issue, sue, tissue, ensue, reissue, pursue, nonissue
[SUF] suffix, insufficient, usufruct, insufflate, insufferable, sufficient, suffixes
[SUG] suggested, sugar, suggest, suggestion, suggestions, suggests, suggesting
[SUI] pursuit, suit, lawsuit, issuing, unsuitable, swimsuit, ensuing
[SUK] sukkah, netsuke, sukiyaki
[SUL] result, capsule, consult, insular, encapsulated, sulfur, disulfide
[SUM] sum, assume, consume, checksum, resume, presumably, unconsumed
[SUN] sun, disunion, gesundheit, asunder, tsunami, countersunk, unsung
[SUO] sensuous, sensuosity, sensuousness, sensuously
[SUP] support, super, unsupported, unsupervised, sups, marsupial, supreme
[SUR] ensure, measure, sure, closure, erasure, surface, surge
[SUS] versus, consensus, census, suspend, misused, sustained, susceptible
[SUT] sutra, suture, sutler, suttee, hirsute, hirsutism, hirsuteness
[SUV] vesuvian, vesuvianite, vesuvians, vesuvianites
[SUZ] suzerain, suzerainty, suzerains
[SVA] disvalue, misvalue, transvalue
[SVE] transversal, svelte, transvestism, transverse, transvestite, svelter, sveltest
[SWA] swallow, swamp, swan, swap, swarm, swash, swain
[SWE] swear, sweep, answer, bittersweet, swept, minesweeper, swelled
[SWI] swift, swim, swing, swipe, switch, swig, swizzle
[SWO] swollen, swoon, sword, password, guesswork, crossword, swot
[SWR] miswrite
[SWU] swung, swum
[SYB] busybody, sybarite, sybaritic, sybaritism, sybarites, busybodies
[SYC] psychs, sycee, sycosis, sycamine, panpsychist, psych, psychiatry
[SYD] clepsydra, clepsydras
[SYG] easygoing
[SYI] gypsyish, sissyish, busying, gussying, palsying, biopsying, curtsying
[SYL] syllable, syllogism, polysyllabic, asylum, sylphs, sylvan, nitrosyl
[SYM] symbol, symmetry, sympathy, symphony, asymptotic, asymmetric, symposium
[SYN] sync, syndicate, syndrome, synonym, syntax, asynchronous, synagogue
[SYP] sypher, syphilis, syphilitic, syphilology, syphilitics
[SYR] syringe, syrup, syrupy, syrinx, syringa, syrups, syringas
[SYS] system, subsystem, ecosystem, sysadmin, sysop, supersystem, extrasystole
[SYT] forsythia, forsythias
[SYU] dasyure, dasyures
[SYW] busywork
[SYZ] syzygy, syzygies, syzygial
[SZY] groszy
[TAB] table, tabular, stable, database, executable, editable, suitable
[TAC] stack, contact, attach, unstack, detach, intact, tack
[TAD] metadata, tadpole, tads, stadium, conquistador, heptad, pentad
[TAE] vitae, setae, chaetae, hetaera, tael, arborvitae, arborvitaes
[TAF] staff, tafia, taffrail, distaff, ratafia, tipstaff, estafette
[TAG] tag, voltage, stage, percentage, postage, pentagon, advantage
[TAH] cheetah, octahedron, tahini, chetah, tahr, tahsildar, heptahedron
[TAI] detail, container, obtain, tail, maintained, retain, certain
[TAJ] petajoule, petajoules
[TAK] take, taking, katakana, mistake, undertaken, stakes, retake
[TAL] capital, install, total, horizontal, italic, incidental, experimental
[TAM] timestamp, stamp, tam, contaminated, hippopotamus, statampere, catamount
[TAN] distance, instance, standard, constant, rectangle, important, tan
[TAP] tap, metaphysics, staple, juxtapose, videotape, metaphoric, wiretapped
[TAQ] totaquine
[TAR] start, target, elementary, rotary, restart, unitary, tarball
[TAS] dataset, task, deltas, stash, thetas, betas, fantasy
[TAT] state, rotate, limitation, permutation, annotations, notation, quotation
[TAU] tau, restaurant, centaur, staunch, bucentaur, chautauqua, instauration
[TAV] octave, ottava, staves, taverna, atavism, centavo, palstave
[TAW] taw, cutaway, castaway, straightaway, getaway, petawatt, mulligatawny
[TAX] syntax, taxicab, taxon, taxes, taxation, ataxia, pretax
[TAY] stay, mainstay, bobstay, outstay, satay, tayra, backstay
[TAZ] razzmatazz, tazza, altazimuth, altazimuths
[TBA] football, basketball, softball, setbacks, ratbag, cutback, fatback
[TBE] heartbeat, testbed, hotbed, flatbed, potbelly, seatbelt, frontbench
[TBI] outbid, catbird, dustbin, boatbill, frostbit, frostbite, outbidding
[TBL] bootblack, hotblooded, pointblank, bootblacks
[TBO] textbook, postbox, paintbox, outbox, hatbox, hotbox, potboy
[TBR] flatbread, paintbrush, heartbroken, nutbrown, outbrave, footbridge, shortbread
[TBU] outburst, gutbucket, heartburn, politburo, trustbuster, outbuilding, outbursts
[TCA] postcard, shortcake, suitcase, catcall, flatcar, hotcake, nutcase
[TCE] saltcellar, saltcellars
[TCH] catch, kitchen, match, pitch, watch, batch, patch
[TCI] baronetcies, bankruptcies, viscountcies
[TCL] outclass, dustcloth, footcloth, quitclaim, waistcloth, waistcloths, outclassed
[TCO] outcome, postcode, bitcoin, softcover, shortcoming, dotcom, sitcom
[TCR] outcry, nutcracker, shortcrust, christcross, priestcraft, outcrop, outcross
[TCU] shortcut, outcurve, portcullis, shortcuts, portcullises
[TCY] bankruptcy, cornetcy, baronetcy, viscountcy, paramountcy
[TDA] outdated, postdate, outdare, outdate, postdated, postdates, postdating
[TDI] stdio, outdid, postdiluvian, outdistance, outdistanced, outdistances
[TDO] shutdown, countdown, meltdown, outdoors, letdown, postdoc, nextdoor
[TDR] outdraw, outdrew, outdrawn, outdraws, outdrawing
[TEA] instead, team, writeable, stealth, teacher, teal, anteater
[TEB] notebook, whiteboard, skateboard, wastebasket, pasteboard, invertebrate, bontebok
[TEC] protected, detect, architecture, bytecode, technical, technology, antecedents
[TED] expected, protected, distributed, generated, sorted, created, limited
[TEE] guaranteed, tee, trustees, fifteen, sixteen, steep, eighteen
[TEF] wasteful, gratefully, antefix, fateful, hateful, gatefold, plateful
[TEG] integer, category, strategy, protege, reintegrate, tegmen, cortege
[TEH] statehood, whitehead, gatehouse, statehouse, gatehouses, whiteheads, statehouses
[TEI] protein, stein, einsteinium, cysteine, lipoproteins, glutei, anteing
[TEK] tektite, gatekeeper, tektites, gatekeepers
[TEL] tell, immediately, intel, completely, separately, pastel, satellite
[TEM] item, temp, system, statement, attempt, stem, subsystem
[TEN] content, extension, tensor, written, attention, patent, flatten
[TEO] courteous, whiteout, meteor, buteo, duteous, luteous, osteoid
[TEP] step, notepaper, instep, lockstep, sidestep, gatepost, tepefy
[TEQ] tequila, tequilas
[TER] letter, after, parameters, center, filter, pattern, interval
[TES] test, bytes, attributes, whitespace, notes, latest, dates
[TET] octet, tetragram, tetrahedron, stethoscope, teth, lutetium, sextet
[TEU] hauteur, auteur, writeup, amateur, rapporteur, gluteus, fauteuil
[TEV] whatever, antevert, stevedore, anteversion, stevedores
[TEW] steward, gateway, noteworthy, bitewing, agateware, statewide, whitewall
[TEX] latex, text, context, vertex, hypertext, pretext, subtext
[TEY] whitey, chantey, cutey, matey, shuteye, cuteys, mateys
[TFA] pitfall, shortfall, catfall, outface, footfall, pratfall, lightface
[TFE] breastfed, titfer, flatfeet, heartfelt, tortfeasor, breastfeed, breastfeeds
[TFI] postfix, spitfire, catfish, outfit, batfish, ratfink, flatfish
[TFL] outflow, botfly, outflank, outflatter, botflies, outflows, outflanks
[TFO] platform, portfolio, outfox, batfowl, hotfoot, flatfoot, eightfold
[TFR] shirtfront, shirtfronts
[TFU] restful, doubtful, delightful, boastful, fruitful, trustful, forgetful
[TGA] mortgage, nutgall, remortgage, mortgages, mortgagee, mortgagor, mortgageable
[TGE] roentgen, footgear, mtge, stge, wheatgerm, zeitgeist, outgeneral
[TGL] postglacial
[TGO] outgoing, nightgown, concertgoer, montgolfier, outgo, outgoes, outgoings
[TGR] outgrow, postgraduate, knotgrass, outgrowth, outgrew, outgrown, outgrowths
[TGU] catgut, shotgun, outgun, rotgut, coastguard, outguard, outguess
[THA] thank, that, thaw, lethal, shorthand, futhark, enthalpy
[THB] toothbrush, deathbed, mothball, earthborn, clothbound, heathberry, northbound
[THC] healthcare, forthcoming
[THD] withdraw, birthday, deathday, withdrawn, withdrawal, withdrew, birthdays
[THE] theater, theme, there, these, weather, other, either
[THF] pathfinder, faithful, truthful, youthful, mouthful, ruthful, deathful
[THH] withheld, bathhouse, sleuthhound, withhold, withholding, withholds, bathhouses
[THI] thick, thief, thigh, thing, this, within, nothing
[THL] athlete, breathless, deathless, ruthless, toothless, monthly, smoothly
[THM] asthma, isthmus, logarithm, rhythm, algorithm, arithmetic, earthmover
[THN] pathname, smoothness, ethnographic, earthnut, ethnarch, ethnicity, ethnology
[THO] thorn, those, though, method, python, without, author
[THP] toothpaste, southpaw, mothproof, mouthpart, trothplight, toothpicks, toothpick
[THQ] earthquake, earthquakes
[THR] thread, thrill, throat, thrust, thrash, anthrax, arthropod
[THS] paths, widths, months, depths, deaths, fifths, meths
[THT] bathtub, deathtrap, breathtaking, bathtubs, deathtraps
[THU] thud, thug, thumb, thunder, thus, thulium, enthusiasm
[THW] bathwater, earthworm, northward, southward, thwart, pathway, athwart
[THY] earthy, healthy, thyme, worthy, thyristor, timothy, methyl
[TIA] initial, partial, exponential, substantial, differential, inertia, spatial
[TIB] compatible, incompatible, invertible, convertible, susceptible, combustibles, destructible
[TIC] notice, vertical, particular, mathematical, static, tick, article
[TID] tidy, peptide, nucleotide, tidied, tiddler, tide, untidy
[TIE] properties, warranties, tie, capabilities, utilities, quotient, parties
[TIF] identifier, tiff, notify, justify, scientific, certificate, artifact
[TIG] contiguous, tight, litigation, tiger, investigate, stigma, centigrade
[TIH] antihero, lustihood, antihelix, antiheroes, antiheroic, antiheroine, antihalation
[TIK] battik, batik, komatik, swastika, tiki, antiknock, identikit
[TIL] utility, still, tilde, until, tile, percentile, tilings
[TIM] time, estimator, optimize, verbatim, timing, runtime, sometimes
[TIN] setting, continue, testing, writing, existing, floating, starting
[TIO] action, motion, nation, potion, station, function, option
[TIP] multiple, tip, antipodal, antiparallel, stipulates, fingertip, centipede
[TIQ] antique, etiquette, pratique, boutique, critique, mystique, plastique
[TIR] entire, retired, saltire, tired, stirred, untiring, tiring
[TIS] statistic, artist, advertising, satisfy, mantissa, scientist, frontispiece
[TIT] title, entity, identity, partition, quantity, bipartite, substitute
[TIU] consortium, lutetium, multiunit, strontium, technetium, tritium, ostium
[TIV] active, native, negative, positive, relative, derivative, primitive
[TIW] antiwar, kittiwake, antiworld, kittiwakes
[TIY] multiyear
[TIZ] baptize, citizen, sanitize, tizzy, magnetize, quantize, digitize
[TJA] muntjac, bootjack, nightjar, straitjacket, muntjacs, bootjacks, nightjars
[TKA] kibitka
[TKE] hotkey, latke, wicketkeeper, hotkeys, latkes
[TKI] catkin, rootkit, giantkiller, catkins, rootkits
[TKN] pocketknife, pocketknives
[TLA] atlas, cutlass, outlaw, flatland, heartland, titlark, wetland
[TLE] battle, bottle, castle, little, turtle, title, subtitle
[TLI] outline, titling, wrestling, spotlight, hotlink, settling, throttling
[TLO] outlook, fetlock, keitloa, settlor, whitlow, boatload, cartload
[TLS] rotls, axolotls
[TLU] postlude, potluck, potlucks, postludes
[TLY] bluntly, brightly, gently, quietly, softly, directly, currently
[TMA] bitmap, batman, postmark, nightmare, footmarks, portmanteaus, hetman
[TME] treatment, adjustment, voltmeter, department, compartment, commitment, investment
[TMI] catmint, titmice, gristmill, absentminded, postmistress, catmints, gristmills
[TMO] leftmost, rightmost, atmosphere, utmost, outmost, motmot, aftmost
[TMU] litmus
[TNA] etna, catnap, postnasal, catnapped, postnatal, catnapping, catnaps
[TNE] fitness, robustness, correctness, partnership, brightness, lightness, witness
[TNI] lightning, sputnik, beatnik, catnip, fortnight, beatniks, sputniks
[TNO] footnote, whatnot, footnotes, footnoting, footnoted
[TNU] chestnut, outnumber, postnuptial, chestnuts, outnumbers, outnumbered, outnumbering
[TOA] toast, stoa, toad, hoptoad, photoaging, milquetoast, photoactive
[TOB] autobahn, stob, tobacco, toboggan, ectoblast, entoblast, azotobacter
[TOC] protocol, stochastic, photocopying, mattock, feedstock, buttocks, photocopiers
[TOD] today, pentode, custodian, heptode, toddy, mastodon, stodge
[TOE] toes, potatoes, toea, tomatoes, tiptoe, toecap, toeing
[TOF] cutoff, tofu, toff, liftoff, heretofore, shutoffs, castoff
[TOG] histogram, together, cryptography, toggle, pictographic, altogether, photography
[TOH] tohubohu, protohuman, autohypnosis, phytohormone, protohistory
[TOI] stoic, toil, tortoise, repertoire, patois, entoil, cestoid
[TOK] token, stokes, betoken, tokay, cytokines, foretoken, tokoloshe
[TOL] tolerance, ontology, told, stolen, pistol, cytology, tolu
[TOM] bottom, custom, atomic, phantom, automatic, tom, photometric
[TON] tone, button, monotonic, singleton, newton, proton, skeleton
[TOO] toolbar, understood, took, tooth, sawtooth, cockatoo, cartoon
[TOP] stop, top, desktop, isotope, atop, utopia, laptop
[TOQ] toques, toque
[TOR] vector, operator, estimator, factor, store, iterator, directory
[TOS] kurtosis, toss, photos, mitosis, pentose, custos, fructose
[TOT] total, asymptotic, prototype, subtotal, autotype, totes, tots
[TOU] detour, touch, tough, tour, contour, tout, cutout
[TOV] leftover, stove, estovers, cookstove, photovoltaic, stratovision, leftovers
[TOW] towards, tower, town, stow, untoward, bestow, kowtow
[TOX] toxic, hematoxylin, toxoid, detox, toxemia, exotoxin, nontoxic
[TOY] toy, chatoyant, toyboy, toyshop, chatoyance, chatoyancy, toying
[TOZ] entozoa, protozoa, cryptozoic, hematozoon, mycetozoan, spermatozoa, entozoic
[TPA] postpaid, dustpan, footpad, outpace, flightpath, sweatpants, meatpacking
[TPE] outperform, saltpeter, eightpence, waitperson, ftpers, outperforms, waitpersons
[TPH] smartphone, smartphones
[TPI] nitpick, hatpin, potpie, nutpick, breastpin, ftping, nitpicker
[TPL] marketplace, outplay, hotplate, footplate, floatplane, breastplate, outplace
[TPO] outport, postponed, hotpot, jetport, potpourri, postpone, outpoints
[TPR] footprint, agitprop, dustproof, heatproof, rustproof, outproduce, bulletproof
[TPU] output, cutpurse, outputs, outputting, outputted, outpull, cutpurses
[TQU] cotquean
[TRA] track, trade, train, trap, travel, extra, transform
[TRE] treasure, tree, tremble, trend, stream, upstream, extreme
[TRI] triangle, tribe, trick, trim, trip, string, matrix
[TRO] troll, trombone, troop, trophy, trout, controls, stroke
[TRU] truck, true, truffle, trumpet, trunk, structure, construct
[TRY] country, entry, pantry, pastry, try, geometry, registry
[TSA] jetsam, pitsaw, flotsam, fretsaw, outsail, tsarevna, tsarists
[TSB] ratsbane, goatsbeard, goatsbeards
[TSC] kitsch, putsch, outscore, setscrew, sportscast, deutschemark, kitschy
[TSE] itself, outset, listserver, tsetse, petuntse, sightseer, bestseller
[TSF] coltsfoot, coltsfoots
[TSH] nutshell, hotshot, potshot, outshine, cadetship, courtship, dustsheet
[TSI] outside, whatsit, shortsighted, footsie, gutsily, retsina, tootsie
[TSK] tsk, britska, goatskin, outskirt, tsked, tsking, tsks
[TSL] footslog, shirtsleeve, footslogged, footslogging, footslogs, shirtsleeves
[TSM] batsman, boatsman, huntsman, outsmart, craftsman, draftsman, pointsman
[TSO] whatsoever, outsource, stetson, fatso, footsore, sweetsop, heartsome
[TSP] catspaw, hotspur, outspan, craftspeople, craftsperson, dessertspoon, sportspeople
[TSQ] setsquare, setsquares
[TST] bootstrap, outstanding, footstool, bitstock, hatstand, rootstock, shortstop
[TSU] tsunami, catsuit, jujitsu, netsuke, satsuma, shiatsu, wetsuit
[TSW] boatswain, sportswear, craftswoman, draftswoman, craftswomen, draftswomen, sportswoman
[TSY] curtsy, tootsy, antsy, artsy, ditsy, gutsy, patsy
[TTA] attach, manhattan, glottal, settable, ottava, gotta, gettable
[TTE] letter, pattern, written, better, palette, attention, formatter
[TTH] outthink, cutthroat, cutthroats
[TTI] setting, formatting, fitting, getting, plotting, typesetting, lattice
[TTL] battle, bottle, cattle, kettle, little, nettle, settle
[TTM] wattmeter
[TTN] attn
[TTO] bottom, button, stretto, pushbutton, ditto, ottoman, attorney
[TTR] attribute, attracting, quattrocento, yttrium, rattrap, buttress, mattress
[TTS] watts, butts, setts, rickettsia, abwatts, bitts, mitts
[TTU] lettuce, attune, battue, tittup, outturn, guttural, affettuoso
[TTV] bodhisattva
[TTW] rottweiler, rottweilers
[TTY] pretty, patty, putty, atty, chatty, witty, bitty
[TUA] actual, mutual, ritual, virtual, punctuation, perpetual, situation
[TUB] tubes, stub, bathtub, drawtube, tubular, tubate, tubful
[TUC] stuck, tucker, lettuce, tuchun, untuck, celtuce, fettuccine
[TUD] magnitude, studio, amplitude, latitude, longitude, altitude, etudes
[TUE] constituent, substituent, virtue, statue, battue, habitue, spirituel
[TUF] stuff, tufts, restuff, dyestuff, tufa, tuff, candytuft
[TUG] tug, tugboat, tugrik, tugged, tugging, tughrik, tugriks
[TUI] intuitive, tui, perpetuity, pituitary, gratuitous, fatuity, etui
[TUL] tulip, postulate, capitulum, titular, intitule, mutule, setula
[TUM] quantum, momentum, datum, dictum, erratum, tum, autumn
[TUN] tunnel, tuning, tune, tunable, tungsten, opportunity, unfortunate
[TUO] tortuous, fatuous, septuor, unctuous, virtuoso, fructuous, impetuous
[TUP] tuple, setup, startup, stupid, octuple, meetup, tupelo
[TUQ] tuque, tuques
[TUR] return, feature, future, signature, structure, fixture, picture
[TUS] status, lotus, apparatus, cactus, hiatus, virtus, obtuse
[TUT] tutorial, substitute, institute, constitutes, statute, tutti, restitution
[TUU] lituus
[TUX] tux, tuxedo, tuxedos, tuxes
[TUY] tuyere
[TVA] bodhisattva
[TVO] statvolt, outvote, zemstvo, outvoted, outvotes, outvoting
[TWA] twain, twang, outward, software, leftwards, rightwards, partway
[TWE] tweak, tweed, twelve, twenty, between, lightweight, retweets
[TWH] cartwheeling, lintwhite, printwheel, cartwheel, cartwheels, cartwheeled
[TWI] twice, twig, twilight, twin, twist, twitter, twirl
[TWO] artwork, network, two, trustworthy, driftwood, cutwork, notwork
[TWR] scriptwriter, ghostwrite, ghostwrote, ghostwriter, ghostwritten, ghostwrites, ghostwriters
[TWU] bratwurst, bratwursts
[TYA] ptyalin, boatyard, tiltyard, courtyard, satyagraha, ptyalism, ptyalins
[TYC] tycoon, diptych, tychism, kittycat, triptych, polyptych, diptychs
[TYD] katydid, katydids
[TYE] lightyear, outyell
[TYF] platyfish
[TYG] tyg
[TYH] pantyhose
[TYI] tying, emptying, partying, untying, guarantying, pitying, fortyish
[TYK] tyke, tykes
[TYL] style, restyle, hairstyle, freestyle, dactyl, butyl, acetyl
[TYM] etymon, stymie, tymbal, tympan, tympani, tympany, tympanic
[TYN] duvetyn
[TYO] amphictyon, amphictyony
[TYP] atypical, prototype, type, typical, typo, subtype, datatype
[TYR] polystyrene, styrene, tyranny, tyrosine, martyr, butyrin, satyr
[TYS] cityscape, platys, zlotys, ttys, suretyship, platysma
[TYT] shantytown, shantytowns
[TYW] citywide, countywide, pantywaist, pantywaists
[TYX] anaptyxis
[TZA] matzah, tzar, quetzal, tzatziki, matzahs, tzars, tzarina
[TZE] blitzes, pretzel, waltzes, howitzer, kreutzer, seltzer, blintze
[TZI] glitzier, ritzier, futzing, deutzia, hoatzin, hoactzin, tzatziki
[TZK] britzka, blitzkrieg, blitzkriegs
[TZL] spaetzle
[TZM] sitzmark
[TZN] kibbutznik, kibbutzniks
[TZO] matzoh, matzot, matzo, matzohs, matzos, matzoth
[TZP] chutzpah
[TZV] mitzvah, mitzvoth
[TZY] glitzy, klutzy, chintzy, ritzy, schmaltzy
[UAB] valuable, arguably, invaluable, continuable, suable, equable, ouabain
[UAC] quack, adequacy, guacamole, bivouac, gouache, aquacade, guacharo
[UAD] quad, biquadratic, squad, persuaded, dissuade, duad, unnilquadium
[UAF] quaff, quaffs, quaffed, quaffer, quaffing
[UAG] language, quagga, assuage, escuage, messuage, metalanguage, unassuaged
[UAH] chihuahua, quahog, quahogs, chihuahuas
[UAI] quaint, acquainted, cinquain, guaiacol, reacquaint, unacquainted, quailed
[UAK] quake, earthquake, seaquake, quaky, quaked, quakes, quaking
[UAL] actual, annual, equal, manual, usual, individual, mutual
[UAM] aquamarine, squama, quamash, aquamanile, desquamate, squame, squamose
[UAN] quant, pursuant, yuan, issuance, guanabana, nuanced, iguana
[UAP] aquaplane, chinquapin, aquaplaned, aquaplanes, aquaplaning, chinquapins
[UAQ] quaquaversal
[UAR] square, guard, quark, unguarded, headquarters, safeguard, mortuary
[UAS] quasi, squash, persuasive, linguas, oquassa, suasion, musquash
[UAT] evaluate, equation, punctuation, quaternion, situation, continuation, unevaluated
[UAU] luau, luaus
[UAV] suave, quaver, aquavit, guava, semiquaver, quaquaversal, quavery
[UAW] squawks, squawk, squaw, squawker, squaws, squawked, squawkers
[UAY] quay, guayule, tatouay, quayside, quays, guayules, tatouays
[UBA] cubature, rhubarb, subarea, incubator, aubade, rubato, tubate
[UBB] bubble, rubber, subbed, chubby, stubbed, scrubber, shrubbery
[UBC] subclass, subcellular, subcontract, subcommittee, hubcap, subchaser, subcortex
[UBD] subdomain, subdirectory, subdivision, subdividing, subdeacon, rubdown, subdural
[UBE] tubes, cube, hypercube, drawtube, subentry, aubergine, pubes
[UBF] subfamily, subfield, tubful, clubfeet, subfloor, subfreezing, subfamilies
[UBG] subgroup, subgenus, subglacial, subgroups, subgenre, subgenera
[UBH] subheading, clubhaul, subhuman, subharmonic, subhead, subheadings, clubhouse
[UBI] cubic, subindex, dubious, jubilee, rubidium, ubiquity, nubile
[UBJ] subject, subjoined, subj, subjects, subjective, subjected, subjectively
[UBK] subkingdom, subkingdoms
[UBL] public, double, trouble, republic, unpublished, sublimate, ruble
[UBM] submit, resubmitting, clubman, resubmission, submitted, submission, submarine
[UBN] subnormal, dubnium, subnotebook, subnormality
[UBO] suboptimal, cuboid, subordinate, buboes, blaubok, faubourg, suboxide
[UBP] subplots, subparagraph, subproblem, subprogram, subphylum, subpoena, subparallel
[UBR] subroutine, rubric, subregion, lubricants, hubris, clubroom, colubrid
[UBS] subs, stubs, hubs, clubs, unsubscribed, pubs, shrubs
[UBT] subtype, doubt, undoubtedly, unsubtle, redoubt, misdoubt, oversubtle
[UBU] subunit, auburn, tubular, incubus, succubus, subunits, suburb
[UBV] subversion, subverting, subvocal, subvariety, subvention, subvisible, subvert
[UBW] subway, clubwoman, scrubwoman, subways
[UBY] ruby
[UBZ] subzero
[UCA] education, toucan, eucalyptus, coucal, faucal, ducal, lucarne
[UCC] success, unsuccessful, stucco, zucchini, cappuccino, buccal, felucca
[UCE] reduce, produce, reproduce, introduced, deduce, induced, lucent
[UCH] couch, much, ouch, pouch, touch, such, gauche
[UCI] irreducible, reproducible, reducing, producing, introducing, crucial, lucid
[UCK] buck, duck, luck, stuck, truck, struck, suck
[UCL] euclidean, nuclear, enucleate, binucleate, nonnuclear, pronucleus, antinuclear
[UCO] glucose, glaucous, fucoid, mucoid, bucolic, leucoma, raucous
[UCR] bureaucracy, sucres, lucre, mucro, involucre, sucrase, sucre
[UCS] caoutchoucs
[UCT] conduct, deduct, duct, product, structure, construct, reduction
[UCU] cucumber, mucus, caucus, fucus, cucurbit, luculent, cucullate
[UCY] saucy
[UDA] barracuda, cauda, audacity, aoudad, feudal, acaudal, exudate
[UDB] cudbear, studbook, rudbeckia, cloudberry, cloudburst, cudbears, studbooks
[UDC] mudcat, mudcats
[UDD] buddy, cuddle, huddle, muddy, puddle, suddenly, cruddy
[UDE] include, exclude, magnitude, student, amplitude, latitude, longitude
[UDF] mudfish, chaudfroid, mudflap, mudflat, mudflow, mudflaps, mudflats
[UDG] budge, fudge, grudge, judge, nudge, kludge, bludge
[UDH] studhorse, loudhailer, studhorses, loudhailers
[UDI] including, audio, excluding, studio, judicial, prejudicial, rudimentary
[UDL] loudly, caudle, studly, budlike, maudlin, mudlark, cloudlet
[UDM] loudmouth, loudmouths, loudmouthed
[UDN] nudnik, loudness, proudness, nudnick
[UDO] pseudo, escudo, ludo, udo, kudos, judo, boudoir
[UDP] mudpack, mudpacks
[UDR] mudra, docudrama, foudroyant, mudroom, mudras, mudrooms, docudramas
[UDS] loudspeaker, clouds, studs, sudsy, mudslide, mudstone, soapsuds
[UDU] kudu, fraudulent, fraudulence, kudus, fraudulently
[UDW] cudweed, cudweeds
[UDY] study, cloudy, pseudy, gaudy, overstudy, understudy, restudy
[UDZ] kudzu, kudzus
[UEA] squeak, queasy, bequeath, cotquean, pipsqueak, squeal, squeaky
[UEB] blueberries, pueblo, arquebus, harquebus, bluebonnet, bluebottle, usquebaugh
[UEC] bluecoat, cinquecento
[UED] argued, blued, clued, glued, queued, valued, issued
[UEE] squeeze, marquee, queen, evacuees, distinguee, squeezed, squeezing
[UEF] liquefied, rueful, bluefish, cinquefoil, quinquefid, pasqueflower, liquefy
[UEG] bluegill, bluegrass, bluegills
[UEH] fuehrer, truehearted, fuehrers
[UEI] blueish, segueing, appliqueing
[UEJ] bluejeans, bluejacket, bluejackets
[UEL] cruel, duel, fuel, gruel, sequel, uniquely, valueless
[UEM] denouement, denouements
[UEN] sequence, frequency, subsequent, infrequent, influence, consequently, congruence
[UEO] aqueous, subaqueous, terraqueous
[UEP] blueprint, bluepoint, blueprints, bluepoints, blueprinted, blueprinting
[UER] query, issuer, becquerel, conquer, valuer, continuer, marguerite
[UES] values, request, question, issues, guess, eigenvalues, cliques
[UET] parquet, silhouette, bouquet, baguette, maquette, quetzal, etiquette
[UEU] queue, enqueue, longueur, dequeue, liqueur, claqueur, queues
[UEW] agueweed, blueweed, agueweeds, blueweeds
[UEY] bluey, maguey, cliquey, gluey, lacquey, torquey, magueys
[UEZ] muezzin, muezzins
[UFA] manufacturer, chufa, tufa, manufacture, manufactory, chufas, manufactured
[UFE] rufescent, rufescence
[UFF] bluff, fluff, muffin, puff, stuff, buffer, suffix
[UFI] rufiyaa, argufied, argufies
[UFL] camouflage, mouflon, genuflect, camouflager, genuflector, genuflexion, genuflection
[UFO] rufous, ufology, ufologist, ufologists
[UFR] froufrou, usufruct, gallimaufry
[UFS] poufs
[UFT] cruft, tufts, mufti, candytuft, crufty, tufter, tufty
[UFY] argufy, argufying
[UGA] conjugate, sugar, centrifugal, beluga, jugal, cougar, frugal
[UGB] tugboat, rugby, bugbane, plugboard, bugbear, bugbanes, bugbears
[UGE] huge, gauge, rouge, mauger, kluge, eugenics, refugees
[UGF] jugful, mugful, jugfuls, mugfuls
[UGG] buggy, juggle, luggage, nugget, smuggle, debugging, suggested
[UGH] cough, dough, laugh, rough, through, enough, though
[UGI] plugins, augite, bougie, fugitive, pugilism, ferruginous, frugivorous
[UGL] bugle, ugly, ugliness, euglena, fugleman, smugly, snugly
[UGM] augment, zeugma, hypozeugma, augmentation, augmented, augmenting, augments
[UGN] impugn, oppugn, repugn, smugness, snugness, pugnacity, expugnable
[UGO] colugo, dugong, lanugo, rugose, erugo, plugola, nidifugous
[UGR] tugrik, grugru, rugrat, fenugreek, grugrus, rugrats, tugriks
[UGS] bugs, mugshot, plugs, slugs, hugs, jugs, ladybugs
[UGU] august, arugula, fugue, jugular, ouguiya, inaugural, lugubrious
[UGW] lugworm, mugwump, mugwumpery, lugworms, mugwumps
[UGZ] zugzwang
[UHA] brouhaha, brouhahas
[UHE] euhemerism, euhemerize
[UHF] uhf
[UHL] buhl, uhlan, buhls
[UHR] fuhrer, buhr, kieselguhr, buhrstone, fuhrers, kieselguhrs
[UIA] equiangular, colloquial, alleluia, conquian, obloquial, reliquiae, sesquialtera
[UIB] quibble, squib, guib, quibbles, quibbler, squibber, squibs
[UIC] quick, juice, sluice, suicidal, verjuice, unguiculate, quickly
[UID] druid, fluid, guide, liquid, squid, quid, equidistant
[UIE] quiet, acquiescence, gluier, requiem, unquiet, disquiet, exequies
[UIF] aquifer, quiff, squiffy, linguiform, quiffs, aquifers, squiffier
[UIG] squiggle, squiggly, squiggled, squiggles, squiggling
[UIJ] ouijas, ouija
[UIK] duiker, spruik
[UIL] build, guilt, quill, tranquil, rebuild, equilibrium, prebuilt
[UIM] guimpe, guimpes
[UIN] genuine, guinea, penguin, ruin, squint, quinone, issuing
[UIO] baguio, obloquious, obsequious, sesquioxide, obsequiously
[UIP] equipment, equiprobable, guipure, quipped, equipoise, equipping, sesquiplane
[UIR] acquire, inquire, quirk, require, squirm, reacquire, faquir
[UIS] bruise, cruise, cuisine, disguise, squishy, distinguish, louis
[UIT] biscuit, circuit, fruit, guitar, suit, quite, ambiguity
[UIU] colloquium, colloquiums
[UIV] equivalent, quiver, unequivocal, aquiver, equivocal, pursuivant, equiv
[UIX] quixotic, quixotry, quixotism, quixotically, quixotisms
[UIY] ouguiya, ouguiyas
[UIZ] quiz, prologuize, soliloquize, quizzed, quizzes, quizzical, quizzing
[UJA] thuja, mujahidin, hallelujah, mujaheddin, mujahideen, hallelujahs
[UJI] moujik, jujitsu, mujik, mujiks, moujiks
[UJU] jujube, juju, jujubes, jujus
[UKA] chukar, ukase, eukaryote, eukaryotic, ukases, eukaryotes
[UKE] duke, fluke, jukebox, nuke, puke, lukewarm, peruke
[UKI] puking, kabuki, bouzouki, dybbukim, rebuking, sukiyaki, interleukin
[UKK] chukka, sukkah, yukked, pukka, chukkar, chukker, yukking
[UKL] auklet, mukluk, auklets, mukluks
[UKO] leukocyte, leukoderma, leukorrhea, leukocytic, leukocytes, leukodermas, leukorrheas
[UKR] kukri
[UKS] dibbuks, dybbuks, mukluks, padauks, souks, auks, gerenuks
[UKU] seppuku, ukulele, ukuleles
[UKY] fluky
[ULA] particular, formula, regular, tabular, calculate, singular, triangular
[ULB] bulb, mulberry, flashbulb, bulbous, bulbs, bulbar, bulbil
[ULC] fulcrum, mulch, ulcer, inculcating, dulcet, sulcus, culch
[ULD] boulder, cauldron, could, shoulder, would, pauldron, gulden
[ULE] module, rule, scheduler, joule, molecule, capsule, cellule
[ULF] engulf, gulf, sulfur, fulfill, disulfide, ingulf, soulful
[ULG] bulge, divulge, indulge, vulgar, fulgor, effulgent, refulgent
[ULI] peculiar, masculine, scheduling, moduli, ruling, tulip, fouling
[ULK] bulk, hulk, skulk, sulk, caulk, yarmulka, bulky
[ULL] bull, full, gull, pull, skull, null, successfully
[ULM] pulmonic, culminating, fulmar, haulm, soulmate, annulment, ulmaceous
[ULN] ulna, vulnerable, usefulness, helpfulness, youthfulness, foulness, awfulness
[ULO] modulo, coulomb, garrulous, ridiculous, tuberculosis, fabulous, scrupulous
[ULP] gulp, pulp, sculpt, culprit, exculpate, vulpine, sulphone
[ULQ] pulque, pulques
[ULR] bulrush, bulrushes
[ULS] impulse, pulse, compulsory, repulsion, propulsion, souls, ulster
[ULT] adult, cult, fault, insult, result, default, multi
[ULU] modulus, calculus, pendulum, curriculum, annulus, regulus, capitulum
[ULV] culvert, pulverize, vulva, fulvous, pulvinus, griseofulvin, vulvae
[ULW] bulwark, bulwarks
[ULY] truly, unduly, unruly, duly, iconoduly, untruly
[UMA] human, presumably, plumage, duma, consumable, brumal, mazuma
[UMB] crumb, dumb, humble, number, thumb, renumber, umbrella
[UMC] plumcot, circumcise, circumcised, circumcision, plumcots, circumcises, circumcising
[UMD] dumdum, gumdrop, humdrum, slumdog, humdinger, dumdums, gumdrops
[UME] numeric, argument, document, enumerate, assume, volume, consume
[UMF] circumflex, bumf, drumfire, drumfish, circumfuse, circumfluent, circumfluous
[UMG] slumgullion, slumgullions
[UMH] crumhorn, drumhead, scrumhalf, scrumhalves, crumhorns, drumheads
[UMI] assuming, illuminant, consuming, luminance, resuming, luminosity, humidity
[UMJ] circumjacent
[UMK] bumkin
[UML] umlaut, drumlin, slumlord, circumlunar, glumly, umlauts, drumlins
[UMM] dummy, summary, cumming, bummer, yummy, crummy, tummy
[UMN] columns, alumni, autumn, calumny, glumness, circumnutate, column
[UMO] humor, tumor, sumo, pneumonia, rumors, grumous, plumose
[UMP] bump, clump, jump, pumpkin, stump, assumptions, dump
[UMQ] kumquat, kumquats
[UMR] alumroot, rumrunner, circumrotate, alumroots, rumrunners
[UMS] sums, minimums, circumstance, maximums, clumsy, circumscribe, forums
[UMT] gumtree, gumtrees
[UMU] cumulative, accumulators, muumuu, tumuli, humus, plumule, altocumuli
[UMV] circumvent, duumvir, triumvir, circumvented, circumvents, triumviri, duumvirate
[UMW] gumwood, gumwoods
[UMY] rheumy, plumy, spumy, fumy
[UNA] unary, unable, unavailable, lunate, tunable, unaligned, unaltered
[UNB] unbraced, unbounded, unbiased, unbroken, unbalanced, unblock, unbreakable
[UNC] bunch, crunch, hunch, lunch, punch, function, launchpad
[UND] around, bundle, found, ground, hundred, under, bound
[UNE] cuneiform, unexpanded, unexpected, prune, unevaluated, unequal, tune
[UNF] unfilled, unfavorable, unfortunate, unfitted, unfinished, sunflower, unfolded
[UNG] bungle, hung, jungle, lung, young, rung, sung
[UNH] unhandled, unhelpful, unhyphenated, unhook, unhidden, unharmed, unheeded
[UNI] juniper, tunic, unicorn, uniform, unique, union, unit
[UNJ] unjustified, unjam, unjointed, unjustness, unjust, unjammed, unjustly
[UNK] bunk, chunk, dunk, junk, skunk, unknown, shrunk
[UNL] unless, unlike, unlabeled, unload, unlucky, sunlight, dunlin
[UNM] unmodified, unmasked, unmatched, unmapped, unmaintained, unmanned, gunmetal
[UNN] running, tunnel, unnecessary, unnamed, funny, unnumbered, unneeded
[UNO] unordered, unobserved, unofficial, unopened, runoff, unowned, unobvious
[UNP] unpack, unprocessed, unprintable, unpublished, unplanned, unpick, unpleasant
[UNQ] unquote, unquoted, unqualified, unquoting, unquotes, unquiet, unquenchably
[UNR] unravel, unrecognized, unrelated, unreachable, unreserved, unrestricted, sunrise
[UNS] runs, unsigned, unsupported, unsafe, unset, unstack, unspecified
[UNT] aunt, blunt, count, hunt, mount, until, runtime
[UNU] unused, unutterably, eunuch, lunula, jejunum, sunup, unutilized
[UNV] unverified, unvisited, unvoice, unvaried, unvalued, unveiled, unvanquished
[UNW] unwrap, unweighted, unwanted, unwind, runway, unwelcome, unwarned
[UNX] quincunx
[UNY] bunyip, gunyah, puny, unyielding, unyoke, unyoked, unyokes
[UNZ] unzip, kunzite, gaberlunzie, unzipped, unzipping, unzips, kunzites
[UOD] quod, duodecimo, duodiode, duodenary, duodecillion, duodena, duodenal
[UOI] turquoise, sequoia, quoin, quoit, quoins, quoits, quoited
[UOL] toluol, vacuole, duologue, vacuolar, vacuoles, duologues
[UOM] duomo
[UON] gluon, muon, quondam, euonymus, gluons, muons
[UOP] duopoly, duopolies
[UOR] fluoride, liquor, quorum, languor, septuor, hydrofluoric, inquorate
[UOS] virtuoso, sinuosity, affettuoso, flexuosity, sensuosity, tortuosity, impetuosity
[UOT] quota, unquote, duotone, aliquot, misquote, underquote, quotas
[UOU] contiguous, continuous, ambiguous, unambiguous, superfluous, tortuous, deciduous
[UOX] fluoxetine
[UOY] buoy, lifebuoy, sonobuoy, buoyancy, buoyage, buoyant, buoyed
[UPA] occupations, stupa, pupa, eupatrid, upas, decoupage, dupability
[UPB] cupboard, upbear, upbraid, upbuild, cupbearer, upbeat, upbringing
[UPC] upcast, cupcake, upcoming, soupcon, upchuck, upcountry, upcasts
[UPD] update, updraft, updo, updated, updates, updating, updater
[UPE] super, grouped, unsupervised, loupe, rupee, dupe, coupe
[UPF] upfront, cupful, teacupful, cupfuls, teacupfuls
[UPG] upgrade, upgrading, upgraded, upgrades, upgradable, upgradeable, upgrowth
[UPH] uphill, dauphine, euphoria, upheld, uphold, uphroe, ouphe
[UPI] grouping, pupil, stupid, occupied, rupiah, marsupial, cupid
[UPK] upkeep
[UPL] couple, duplex, quadruple, quintuple, upland, tuple, upload
[UPM] upmost, upmarket, recoupment
[UPO] upon, quadrupole, whereupon, hereupon, dupondius, thereupon, avoirdupois
[UPP] cuppa, guppy, puppet, supper, upper, unsupported, uppity
[UPR] upright, uproot, cuprum, uprate, supreme, uprear, uprush
[UPS] groups, upstream, upsilon, newsgroups, subgroups, backups, cleanups
[UPT] interruption, corrupt, disrupt, upturn, abruptly, eruption, bankruptcy
[UPU] lupus, scrupulous, cupule, cajuput, acupuncture, unscrupulous, lupulin
[UPW] upwards, upwell, upwind, groupware, upward, upwardly, upwelling
[UPY] occupy, croupy, syrupy, soupy, chirrupy, preoccupy, reoccupy
[UQU] bouquet, tuque, chautauqua, tuques, bouquets
[URA] plural, accuracy, duration, natural, structural, encourage, saturation
[URB] curb, disturb, suburb, turban, urban, perturb, blurb
[URC] church, lurch, purchase, source, urchin, resource, outsource
[URD] absurd, curd, hurdle, murder, sturdy, surd, burden
[URE] feature, ensure, figure, future, measure, signature, structure
[URF] scurf, surf, turf, smurf, subsurface, curfew, furfur
[URG] burger, purge, surge, urgent, hamburg, hourglass, liturgical
[URH] eurhythmy, eurhythmic, eurhythmics
[URI] during, security, courier, impurity, heuristic, jurisdiction, purify
[URJ] surjection
[URK] lurk, murky, turkey, burke, mazurka, lurked, lurker
[URL] burl, curl, furl, hurl, purl, hourly, churl
[URM] murmur, durmast, gourmet, surmise, turmoil, furmenty, curmudgeon
[URN] burn, churn, return, turn, urn, furnace, journal
[URO] euro, neuron, fleuron, sauropod, aurora, adventurous, furor
[URP] burp, purple, slurp, surpass, usurp, murphy, multipurpose
[URQ] turquoise, turquoises
[URR] burrow, curry, furry, hurry, purr, recurrence, occurred
[URS] burst, curse, nurse, purse, recursion, course, occurs
[URT] blurt, court, curtain, hurt, turtle, further, fourth
[URU] guru, thesaurus, urus, curule, aurum, durum, kurus
[URV] curve, scurvy, survey, purvey, incurve, excurved, outcurve
[URW] burweed, sourwood, fourwheeled, sourwoods
[URY] century, mercury, injury, bury, jury, luxury, treasury
[URZ] furze, furzy
[USA] usage, usable, thousand, reusable, causal, unusable, sausage
[USB] husband, busboy, househusband, busby, husbandry, husbandman, husbandmen
[USC] muscle, manuscript, obfuscate, susceptible, minuscule, majuscule, tusche
[USE] use, because, clause, caused, fuse, unused, mouse
[USF] hausfrau
[USG] busgirl, busgirls
[USH] blush, brush, crush, mushroom, push, flush, hushed
[USI] using, fusion, musical, business, exclusive, inclusive, intrusive
[USJ] musjid, musjids
[USK] dusk, husk, musk, tusk, busk, rusk, mollusk
[USL] previously, obviously, analogously, erroneously, seriously, anonymously, contiguously
[USM] busman, busmen
[USN] seriousness, piousness, joyousness, odiousness, porousness, amorousness, anxiousness
[USO] sinusoidal, blouson, elusory, illusory, mausoleum, infusorian, sarrusophone
[USP] suspend, cusp, unsuspecting, auspices, aruspex, bicuspid, haruspex
[USQ] brusquer, musquash, usquebaugh, brusque, brusquerie, brusqueness, brusquely
[USS] gauss, discussion, truss, muss, fussy, buss, russet
[UST] crust, dust, gust, must, rust, custom, just
[USU] usually, unusual, usurped, susurrus, usufruct, usual, usu
[USY] busy, lousy, circusy, mousy, jealousy, busybody, busyness
[UTA] permutation, computation, executable, commutative, immutable, mutation, imputation
[UTB] outbox, cutback, hautboy, nutbrown, gutbucket, outbound, outbid
[UTC] butcher, clutch, crutch, dutch, hutch, outcome, nautch
[UTD] shutdown, outdated, outdoors, outdrawn, outdistance, withoutdoors, shutdowns
[UTE] compute, attribute, distributed, outer, acute, execute, absolute
[UTF] outflow, outfit, outfox, outface, outfall, outfoot, outfield
[UTG] outgoing, outgrowth, nutgall, outguard, outgeneral, outgo, outgrow
[UTH] author, mouth, ruth, south, truth, azimuth, unauthorized
[UTI] distribution, utility, solution, routine, computing, execution, contribution
[UTL] outline, butler, cutlass, nutlet, sutler, gutless, gemutlich
[UTM] utmost, outmost, abutment, nutmeg, hutment, scoutmaster, outman
[UTN] sputnik, outnumber, chutney, tautness, stoutness, devoutness, chutneys
[UTO] auto, contributor, tutorial, cutoff, executor, statutory, distributors
[UTP] output, nutpick, cutpurse, outputs, outport, outputting, outpoints
[UTR] neutral, sutra, outright, antineutrino, nutrient, outrageous, putrefaction
[UTS] inputs, outside, outputs, layouts, cuts, puts, timeouts
[UTT] butter, clutter, flutter, mutter, pushbutton, putting, gutter
[UTU] future, mutual, autumn, suture, scutum, sputum, arbutus
[UTV] outvote, outvoted, outvotes, outvoting
[UTW] outward, cutwork, nutwood, goutweed, outwards, outweigh, outweighs
[UTY] duty, beauty, deputy, butyl, grouty, fluty, gouty
[UTZ] chutzpah, klutz, putz, futz, kreutzer, halutz, chalutz
[UUM] continuum, residuum, vacuum, muumuu, duumvir, menstruum, vacuums
[UUS] lituus, muumuus
[UVA] kuvasz, louvar, couvade, helluva, adjuvant, pyruvate, uvarovite
[UVE] duvet, juvenile, louver, rejuvenate, souvenir, mauve, cuvette
[UVI] eluvium, exuviae, fauvism, fluvial, mauvish, pluvial, alluvial
[UVN] guvnor, guvnors
[UVR] oeuvre, bahuvrihi, oeuvres
[UVS] guvs
[UVU] uvula, vuvuzela, uvular, uvulas, uvulitis, uvulars, vuvuzelas
[UWA] thruway, thruways
[UWO] rauwolfia, rauwolfias
[UXA] luxate, luxation, luxations
[UXE] deluxe, fluxes, tuxes, auxeses, euxenite, luxe, cruxes
[UXI] auxiliary, bauxite, fluxion, defluxion, hypozeuxis, refluxing, auxiliaries
[UXM] fluxmeter
[UXO] uxorial, buxom, auxochrome, uxorious, buxomness, uxoricide, uxoriousness
[UXT] juxtapose, juxtaposing, juxtaposed, juxtaposes
[UXU] luxury, luxuriant, luxuriate, luxurious, luxuriance, luxuriation, luxuries
[UYA] thuya
[UYB] buyback, buybacks
[UYE] buyer, tuyere, guyed, buyers
[UYI] buying, guying, overbuying
[UYO] buyout, guyot, guyots, buyouts
[UYS] guys, wiseguys, buys, overbuys
[UZA] mezuza, cruzado, muzak, mezuzah
[UZE] cruzeiro, gauze, ouzel, suzerain, vuvuzela, douzepers, schnauzer
[UZH] muzhik, muzhiks
[UZI] gauzily, gauziness, gauzier, gauziest
[UZL] touzle
[UZO] mezuzot, bouzouki, ouzo, mezuzoth, ouzos, bouzoukis
[UZU] yuzus, yuzu
[UZY] gauzy
[UZZ] buzz, fuzz, guzzle, muzzle, puzzle, huzzah, nuzzle
[VAB] solvable, movable, removable, observable, provable, resolvable, conceivable
[VAC] evacuate, vacant, vacuum, privacy, vaccine, vivace, medevac
[VAD] evade, invader, vadose, bravado, couvade, pervade, avadavat
[VAE] larvae, vulvae, novae, gingivae, supernovae
[VAG] vague, salvage, savage, extravagant, vagaries, gavage, lavage
[VAH] halvah, mikvah, shivah, mitzvah, shivahs
[VAI] available, unavailable, prevailing, vain, travail, vair, vaivode
[VAL] avalanche, carnival, festival, oval, valley, value, invalid
[VAM] vamp, revamp, vamoose, gravamen, vambrace, vampire, vampires
[VAN] advance, caravan, van, relevant, irrelevant, observance, disadvantage
[VAP] evaporate, vapor, vapid, vape, vaporize, vapors, vapory
[VAQ] vaquero, vaqueros
[VAR] variable, covariance, vars, multivariate, invariant, varistor, vary
[VAS] canvas, vast, invasive, pervasive, avast, vase, divas
[VAT] derivative, private, activate, observations, deactivate, curvature, conservative
[VAU] vault, avaunt, vaunt, vaudeville, vaulty, vaulter, vaulting
[VAV] vav
[VDP] avdp
[VEA] caveat, reveal, giveaway, fovea, uvea, veal, unrevealing
[VEB] giveback, lovebird, waveband, aboveboard, livebearer, givebacks, lovebirds
[VEC] vector, eigenvectors, dovecot, convect, evection, advection, invective
[VED] reserved, removed, saved, received, derived, observed, moved
[VEE] corvee, jayvee, veejay, levee, veery, veep, veer
[VEF] waveforms, wavefront, cavefish, fivefold, twelvefold, waveform
[VEG] vegetable, vegan, vegged, lovegrass, waveguide, revegetate, vegeburger
[VEH] vehicle, mikveh, vehement, slaveholder, vehicles, vehemence, vehemency
[VEI] veil, surveillance, unveil, vein, inveigh, uveitis, cleveite
[VEK] dovekie, dovekies
[VEL] bevel, gravel, level, novel, velvet, unravel, ravel
[VEM] movement, improvement, caveman, achievements, pavement, hivemind, twelvemo
[VEN] adventure, eleven, event, oven, seven, given, vendor
[VEO] alveolar, foveola, niveous, faveolate, alveoli, alveolus, alveolate
[VEP] fivepenny, stovepipe, stovepipes
[VER] beaver, clover, every, river, silver, version, convert
[VES] gloves, harvest, invest, vest, waves, gives, derivatives
[VET] vet, brevet, rivet, velvet, grivet, revet, corvette
[VEU] trouveur
[VEW] driveway, liveware, driveways
[VEX] convex, vex, biconvex, vexation, vexed, vexes, convexity
[VEY] survey, convey, slavey, graveyard, garvey, jarvey, peavey
[VIA] via, trivial, deviation, abbreviation, nontrivial, aviation, alleviate
[VIB] vibration, vibes, vibrissa, viburnum, vibraharp, vibraculum, vibraphone
[VIC] device, service, advice, vice, victor, evicted, vicinity
[VID] provided, divide, individual, video, evidence, subdivide, vivid
[VIE] movie, preview, review, view, overview, vier, heavier
[VIF] vivify, oviform, avifauna, claviform, revivify, vivified, vivifier
[VIG] invigorate, navigate, vigil, vigor, vignette, vigesimal, levigate
[VII] viii, xviii, xxviii, xxxvii, lxvii, xcvii, lvii
[VIK] viking, vikings
[VIL] anvil, civil, devil, evil, village, curvilinear, heavily
[VIM] vim, gravimeter, vimineous, gravimetric, vimen, gravimeters
[VIN] divine, vine, vintage, having, moving, giving, removing
[VIO] obvious, ravioli, violet, behavior, previous, devious, oblivious
[VIP] viper, oviposit, oviparity, viviparity, viperine, viperish, viperous
[VIR] environ, viral, virgin, virtual, virus, viridian, duumvir
[VIS] advise, invisible, supervise, visible, division, revision, visual
[VIT] connectivity, activity, gravity, vitae, sensitivity, permittivity, invited
[VIU] mendelevium, qiviut, eluvium, trivium, alluvium, diluvium, lixivium
[VIV] revive, survive, viva, vivid, convivial, redivivus, vive
[VIX] vixen, cervix, vixens, vixenish, vixenishly
[VIZ] vizier, relativize, vizard, previze, vizcacha, misadvize, passivize
[VLO] pavlova, pavlovas
[VNA] czarevna, tsarevna
[VNI] hryvnia
[VNO] guvnor, guvnors
[VOB] novobiocin, novobiocins
[VOC] advocate, avocado, vocal, irrevocable, invocation, revocation, havoc
[VOD] vodka, vaivode, vodkas
[VOE] voe, voes
[VOG] vogue, levogyrate, vogues, voguish
[VOI] avoid, devoid, invoice, voice, void, reservoir, unavoidable
[VOK] invoke, revoked, provoke, convoke, evoke, unrevoked, unprovoked
[VOL] evolve, involve, volcano, volley, volume, voltage, convolve
[VOM] vomit, vomer, servomotor, vomiting, vomitory, vomitous, vomiturition
[VON] elevon, flavone, evonymus, favonian, pavonine, chervonets
[VOO] voodoo, voodoos, voodooism, voodooed, voodooing
[VOP] flavoprotein
[VOQ] equivoque
[VOR] carnivore, flavor, herbivore, ivory, favor, unfavorable, divorced
[VOS] provost, avos, mikvos, bravos, salvos, servos, octavos
[VOT] pivot, vote, voting, devoted, divot, mikvot, votary
[VOU] devour, nervous, rendezvous, vouch, fulvous, avouch, bivouac
[VOV] slivovitz, ovovitellin, slivovitzes
[VOW] avow, disavow, vow, semivowel, advowson, unavowed, vowed
[VOX] volvox
[VOY] convoy, envoy, voyage, voyeur, savoy, clairvoyant, voyager
[VRA] sovran, livraison
[VRE] livre, chevre, oeuvre, chevrette, chevres, oeuvres
[VRI] bahuvrihi
[VRO] vroom, chevron, vroomed, vrooming, vrooms, chevrotain, chevrons
[VUD] zidovudine, zidovudines
[VUE] revue, revues
[VUL] convulse, revulsion, vulgar, vulture, vulnerable, uvular, ovular
[VUM] ovum
[VUN] avuncular, avunculate, avuncularly
[VUR] bravura, gravure, rotogravure, heliogravure, photogravure, bravuras, gravures
[VUS] nevus, clavus, naevus, favus, redivivus
[VUV] vuvuzela, vuvuzelas
[VUZ] vuvuzela, vuvuzelas
[VVE] bovver, revved, flivver
[VVI] civvies, revving, bevvies, divvied, navvies, savvied, skivvied
[VVY] savvy, skivvy, bevvy, divvy, navvy, divvying, savvying
[VYH] heavyhearted
[VYI] envying, vying, heavyish, levying, chevying, chivying, divvying
[VYS] heavyset
[VYW] heavyweight, heavyweights
[VZO] evzone
[WAB] allowable, drawable, viewable, unknowable, renewable, reviewable, wabbit
[WAC] wack, kwacha, thwack, swacked, greywacke, wackier, wacko
[WAD] wad, nowadays, swaddle, twaddle, tightwad, wads, wade
[WAF] waft, wafer, waffle, wafted, waffles, waffled, waffler
[WAG] bandwagons, swag, wag, cowage, sewage, towage, wigwag
[WAH] wahine, wahoo, wahoos
[WAI] waist, wait, waive, await, swain, twain, wainwright
[WAK] awake, wake, waking, reawake, rewaken, kittiwake, unawakened
[WAL] boardwalk, sidewalk, walk, wall, walnut, swallow, firewall
[WAM] swamp, wampum, wamble, wigwam, wame, swampy, swami
[WAN] swan, wand, want, wane, allowance, unwanted, waning
[WAP] swap, wapiti, wapentake, swapped, swaps, swapping, swapper
[WAR] award, dwarf, forward, swarm, warm, software, warning
[WAS] wash, wasp, waste, wasabi, swash, rewash, awash
[WAT] kilowatt, swatch, watch, water, watt, stopwatch, underwater
[WAU] caterwaul, caterwauls, caterwauled, caterwauling
[WAV] microwave, wave, wavy, waving, shockwave, airwave, heatwave
[WAW] waw, throwaway, stowaway, williwaw, waws, stowaways, williwaws
[WAX] beeswax, earwax, wax, paxwax, woadwaxen, woodwaxen, waxed
[WAY] always, away, highway, pathway, way, anyway, midway
[WAZ] wazoo, wazoos
[WBA] snowball, drawbar, cowbane, crowbar, browband, skewback, screwball
[WBE] strawberry, cowbell, bawbee, howbeit, browbeat, dewberry, snowbelt
[WBI] newbie, cowbind, showbiz, snowbird, yellowbird, cowbird, newbies
[WBL] snowblink, snowblower, snowblowers
[WBO] shadowbox, cowboy, snowboarder, rowboat, newborn, lowboy, jawbone
[WBR] lowbred, showbread, drawbridge, jawbreaker, lawbreaker, lowbrow, lawbreaking
[WBU] sawbuck, sawbucks
[WCA] showcase, snowcap, cowcatcher, pillowcase, showcases, showcased, showcasing
[WCH] flowchart, chowchow, flowcharts, chowchows
[WCL] dewclaw, dewclaws
[WCO] newcomers, bawcock, slowcoach, newcomer, slowcoaches
[WDA] crawdad, howdah, howdahs, crawdads
[WDE] powder, crowded, chowder, gunpowder, uncrowded, belowdecks, lewder
[WDF] crowdfund, crowdfunds, crowdfunded, crowdfunding
[WDI] crowding, bawdily, dowdily, rowdily, overcrowding, pandowdies, bawdiness
[WDL] dawdle, bowdlerism, lewdly, shrewdly, dawdler, bowdlerize, dawdled
[WDN] lewdness, shrewdness
[WDO] slowdown, lowdown, showdown, slowdowns, showdowns
[WDR] screwdriver, bawdry, tawdry, dewdrop, snowdrop, windowdress, tawdrily
[WDS] crowds, bawds, overcrowds
[WDU] sawdust
[WDY] howdy, bawdy, dowdy, rowdy, pandowdy, rowdyish, rowdyism
[WEA] sweat, weak, wealth, weapon, weather, tweak, wearing
[WEB] cobweb, web, spiderweb, webcam, webpage, website, weber
[WED] wed, allowed, followed, viewed, shadowed, disallowed, skewed
[WEE] between, seaweed, sweet, week, tweet, weed, bittersweet
[WEF] weft, wefts
[WEG] thalweg, thalwegs
[WEI] weird, weigh, flyweight, lightweight, unweighted, overweight, underweight
[WEK] weka, wekas
[WEL] dwell, jewel, swell, twelve, welcome, vowel, well
[WEN] twenty, went, wench, wend, underwent, forwent, forewent
[WEP] swept, upswept, wept, backswept, windswept, unwept, sweptback
[WER] lower, power, were, answer, wert, brewer, viewer
[WES] northwest, west, southwest, lowest, newest, awesome, slowest
[WET] wet, bedwetting, bellwether, wetly, wetness, wetsuit, wetter
[WEV] however, sweven
[WFA] newfangled, snowfall, marrowfat, newfashioned, snowfalls
[WFE] crowfeet
[WFI] blowfish, bowfin, cowfish, jewfish, sawfish, hawfinch, snowfield
[WFL] snowflake, sawfly, blowfly, strawflower, sawflies, blowflies, snowflakes
[WFO] crowfoot, newfound, crowfoots
[WFU] awful, lawfully, godawful, sorrowful, unlawful, awfully, lawful
[WGA] gewgaw, gewgaws
[WGI] cowgirl, lawgiver, showgirl, cowgirls, lawgivers, showgirls
[WGR] showground, shadowgraph, sparrowgrass, shadowgraphs, showgrounds
[WGU] blowgun, blowguns
[WHA] narwhal, whale, wharf, what, somewhat, whack, whamming
[WHE] wheat, wheel, when, where, whether, elsewhere, anywhere
[WHI] while, whim, whip, whisper, white, which, whine
[WHO] who, knowhow, blowhole, sawhorse, brewhouse, widowhood, unwholesome
[WHS] whsle
[WHU] whupped, whup, whupping, whups
[WHY] why, forwhy, whys, whydah, whydahs
[WIB] twibill
[WIC] sandwich, wicked, twice, wicopy, bailiwick, midwicket, candlewick
[WID] wide, widow, width, worldwide, widget, bandwidth, twiddle
[WIE] wield, wiener, zwieback, unwieldy, dowie, dewier, blowier
[WIF] housewife, midwife, swift, wife, kiwifruit, alewife, oldwife
[WIG] bigwig, earwig, twig, wig, swig, bagwig, periwig
[WIK] wiki, wikis, wikiup
[WIL] bewildered, wild, will, goodwill, twilight, wilted, wily
[WIM] swim, wimp, wimble, nonswimmer, swimmer, wimpy, swimming
[WIN] twin, wind, wing, winter, following, drawing, allowing
[WIP] swipe, wipe, wiping, sideswipe, wiped, wiper, wipes
[WIR] wire, wiring, wiry, swirl, rewiring, twirl, tripwire
[WIS] twist, wisdom, wise, wish, wisp, otherwise, piecewise
[WIT] switch, twitch, wit, howitzer, wherewithal, herewith, dimwitted
[WIV] swivel, wives, wiving, alewives, midwives, oldwives, fishwives
[WIX] twixt, betwixt
[WIZ] swizzle, wiz, wizard, wizards, wizardry, swizz, wizen
[WJO] blowjob, blowjobs
[WJU] showjumping
[WKB] hawkbill, hawkbills
[WKE] hawker, squawker, gawked, tomahawked, gawker, hawked, hawkers
[WKI] mawkin, gawkily, hawkish, squawking, tomahawking, mawkish, gawkiness
[WKL] wkly
[WKN] bowknot, drawknife, drawknives, bowknots
[WKS] hawks, squawks, gawks, mohawks, goshawks, tomahawks, nighthawks
[WKW] awkward, hawkweed, awkwardly, awkwardness, awkwarder, hawkweeds, awkwardest
[WKY] gawky
[WLA] dewlap, lowland, blowlamp, meadowland, shadowland, lowlander, meadowlark
[WLE] knowledge, acknowledge, bowler, crawler, trawler, flawless, shadowless
[WLF] bowlful, bowlfuls
[WLI] newline, bowling, owlish, crawling, trawling, cowlick, jawline
[WLL] bowllike
[WLO] rowlock, rowlocks
[WLS] crawls, owls, brawls, drawls, growls, prowls, scowls
[WLW] awlwort, awlworts
[WLY] newly, slowly, narrowly, shallowly, crawly, jowly, lowly
[WMA] snowman, bowman, cowman, lawman, crewman, plowman, showman
[WME] snowmen, endowments, bowmen, cowmen, lawmen, crewmen, plowmen
[WMI] sawmill, shrewmice, sawmills
[WMO] shrewmouse, snowmobile, snowmobiled, snowmobiler, snowmobiles, snowmobiling
[WMS] shawms
[WNB] downbeat, pawnbroker, downburst, pawnbroking, downbeats, pawnbrokers
[WNC] downcast, downcome, downcomer
[WND] downdraft, downdrafts
[WNE] owner, skewness, spawned, unowned, renowned, slowness, crowned
[WNF] downfall, brownfield, downfield, downfalls, downfallen
[WNG] downgrade, downgrading, downgraded, downgrades
[WNH] downhill, townhouse, downhaul, downhearted, downhills, townhouses
[WNI] frowning, spawning, owning, yawning, brownish, townie, crowning
[WNL] download, downloads, downloaded, downloading, downloadable, downland, downlands
[WNM] lawnmower, downmarket, lawnmowers
[WNN] brownness
[WNO] brownout, brownouts
[WNP] downplay, crownpiece, downpipe, downpour, downpipes, downplays, downpours
[WNR] downright, downrange, downriver
[WNS] owns, downscale, unknowns, spawns, towns, downshift, downsizing
[WNT] downtime, downtick, downtown, downturn, downtempo, downtrend, downtrodden
[WNU] grownup, grownups
[WNW] downwards, crownwork, downward, downwash, downwind, crownworks, downwardly
[WNY] tawny, brawny, downy, scrawny, mulligatawny
[WOA] woald, woad, woadwaxen, woaded, woadwaxens
[WOB] wobble, collywobbles, wobbled, wobbles, wobbling, wobbly, wobblier
[WOC] jabberwocky
[WOD] wodge, wodges
[WOE] woe, woeful, woes, woefully, woebegone, woefuller, woefullest
[WOF] showoff, twofold, twofer, twofers, showoffs
[WOG] wog, golliwog, polliwog, hornswoggle, wogs, golliwogs, polliwogs
[WOH] twohanded
[WOK] awoke, woke, woks, reawoke, woken, wok, awoken
[WOL] swollen, wolf, wolverine, wold, aardwolf, werewolf, rauwolfia
[WOM] woman, wombat, women, policewoman, enwomb, wommera, airwoman
[WON] won, unwon, wonder, wonderful, wonky, wont, wondering
[WOO] wood, woof, wool, swoosh, greenwood, redwood, woozy
[WOP] wop, twopence, twopenny, twopences
[WOR] sword, word, work, world, worm, keyword, network
[WOS] twos, twosome, twosomes
[WOT] wot, swot, wotcha, swotted, swotting, swots
[WOU] wound, would, rewound, unwound, swound, blowout, throwout
[WOV] interwoven, wove, nonwoven, handwoven, rewove, unwove, inwoven
[WOW] bowwow, powwow, wow, wowed, wows, wowing, wowser
[WPA] cowpat, pawpaw, stewpan, towpath, windowpane, towpaths, cowpats
[WPE] cowpea, gawped, yawped, yawper, cowpeas
[WPI] gawping, blowpipe, showpiece, yawping, blowpipes, showpieces
[WPL] snowplow, drawplate, showplace, snowplows, showplaces, snowplowed, snowplowing
[WPO] viewpoint, cowpox, slowpoke, cowpoke, cowpokes, slowpokes, viewpoints
[WPS] gawps, yawps
[WPU] brewpub, cowpuncher, brewpubs, cowpunchers
[WRA] unwrap, wrap, wrath, wraith, rewrap, wrangle, bewray
[WRE] wreath, wreck, wren, wrestle, wretch, lawrencium, enwreathe
[WRI] wriggle, wring, wrist, write, rewrite, overwrite, playwright
[WRO] wrought, wrong, wrote, rewrote, elbowroom, overwrote, towrope
[WRU] wrung
[WRY] awry, wry, dowry, outlawry, wryer, wryest, wryly
[WSA] dowsabel, newsagent, newsagents
[WSB] newsboy, newsboys
[WSC] newscast, newscaster, newscasts, newscasters
[WSD] newsdealer, newsdealers
[WSE] browser, dowser, drowse, hawser, bowse, wowser, browsers
[WSF] newsflash, newsflashes
[WSG] newsgroups, newsgirls, newsgroup, newsgirl
[WSH] fellowship, bowshot, cowshed, snowshed, drawshave, newshound, plowshare
[WSI] browsing, drowsiness, windowsill, bowsing, dowsing, newsier, drowsily
[WSK] cowskin, cowskins
[WSL] newsletter, cowslip, snowslide, pillowslip, newsletters, cowslips, pillowslips
[WSM] newsman, newsmen, newsmonger, newsmagazine, newsmongers
[WSO] advowson, howsoever, advowsons
[WSP] newspaper, newsprint, bowsprit, newspeak, newspapers, newspaperman, newspapermen
[WSR] newsreel, newsroom, newsreader, newsreels, newsrooms, newsreaders
[WSS] newsstand, newsstands
[WST] drawstring, showstopping, frowst, bowstring, snowstorm, showstopper, bowstrings
[WSU] lawsuit, snowsuit, lawsuits, snowsuits
[WSW] newswoman, newsweekly, meadowsweet, unnewsworthy, newswomen, newsworthy, newsweeklies
[WSY] drowsy, newsy
[WTA] yellowtail, swallowtail, yellowtails, swallowtails
[WTE] pewter, pewters, pewterer
[WTH] growth, outgrowth, hawthorn, ingrowth, upgrowth, overgrowth, aftergrowth
[WTI] bowtie, showtime, bowties
[WTO] newton, sawtooth, kilonewton, kowtow, blowtorch, newtons, kilonewtons
[WTS] newts
[WTU] drawtube, blowtube, blowtubes
[WUL] wulfenite
[WUM] mugwump, swum, mugwumpery, mugwumps
[WUN] swung, wunderkind, wunderkinds, wunderkinder
[WUP] blowup, followup, blowups, followups
[WUR] wurst, bratwurst, knockwurst, liverwurst, wursts, bratwursts, knockwursts
[WUS] wussy, wuss, wusses, wussier, wussies, wussiest
[WWA] hollowware, willowware, hollowwares, willowwares
[WWE] yellowweed
[WWO] bowwow, powwow, glowworm, slowworm, arrowwood, screwworm, strawworm
[WYE] lawyer, sawyer, bowyer, lawyers, sawyers, lawyerly
[WYN] wynd
[WYV] wyvern, wyverns
[WZE] blowzed
[WZI] frowzily, blowzier, frowziness, frowzier, blowziest, frowziest
[WZY] blowzy, frowzy
[XAB] fixable, taxable, exabytes, nontaxable, mixable, exabyte
[XAC] exact, inexact, hexachord, taraxacum, taxaceous, unexacting, exactly
[XAD] hexadecimal, hexadecimals, hexad, hexads
[XAE] coxae, hexaemeron
[XAG] hexagon, exaggeration, sexagenary, sexagesimal, hexagram, hexagonal, hexagons
[XAH] hexahedron, hexahydrate, hexahedrons
[XAJ] exajoule, exajoules
[XAL] oxalic, exalt, coxalgia, glyoxaline, oxalis, oxalate, exaltation
[XAM] example, unexamined, hexameter, preexamine, reexamine, unexampled, examples
[XAN] xanthan, hexane, relaxant, siloxane, exanimate, exanthema, alexandrine
[XAP] hexapla, hexapod, hexapody, hexapartite
[XAR] exarch, hexarchy, exarate, exarchate
[XAS] abraxas, hexastich, exasperate, hexastyle, exasperated, exasperating, exasperation
[XAT] fixation, relaxation, taxation, indexation, luxate, laxation, vexation
[XAV] hexavalent
[XAZ] oxazine
[XBE] boxberry, boxberries
[XBI] waxbill
[XBL] oxblood
[XBO] oxbow, boxboard, oxbows
[XCA] boxcar, oxcart, excavate, excaudate, excavator, excavation, boxcars
[XCE] except, sexcentenary, unexcelled, exception, exceptions, excel, excess
[XCH] exch, reexchange, exchange, exchanged, exchanger, exchanges, exchanging
[XCI] excitation, excitement, xcii, xciv, xcix, excision, excipient
[XCL] exclude, nonexclusive, exclusive, exclusion, exclamation, excluded, excluding
[XCO] coxcomb, excoriate, excogitate, coxcombry, excoriation, coxcombs, excoriated
[XCR] excruciated, excrement, excretion, excrescent, excreta, excrete, excretory
[XCU] excuse, unexcused, inexcusable, excursion, excused, excursus, exculpate
[XCV] xcvii, xcvi
[XDE] sexdecillion
[XDO] flexdollars
[XEA] exeat
[XEB] xebec
[XEC] execute, coexecutor, inexecution, exec, execution, executed, executable
[XED] fixed, mixed, indexed, prefixed, boxed, suffixed, tuxedo
[XEG] exegete, epexegesis, exegeses, exegesis, exegetic, exegetical, exegetics
[XEH] axehead, axeheads
[XEL] pixel, gigapixel, megapixel, terapixel, pixels, pixelation, pixelate
[XEM] exemplary, lexemes, exemption, axeman, taxeme, toxemia, anoxemia
[XEN] xenolith, xenophobia, boxen, oxen, axenic, vixen, xenia
[XEQ] exequy, exequies, exequatur
[XER] boxer, fixer, mixer, xerox, xeric, indexer, lexer
[XES] axes, indexes, boxes, fixes, prefixes, suffixes, complexes
[XET] fluoxetine
[XEU] exeunt
[XFI] boxfish, foxfire
[XFO] oxford, sixfold, exfoliant, exfoliate, exfoliator, oxfords, exfoliated
[XFU] boxful, boxfuls
[XGL] foxglove, foxgloves
[XHA] exhausted, exhaling, boxhaul, exhaust, exhaustive, exhaustion, exhale
[XHE] oxheart, oxhearts
[XHI] exhibit, reexhibit, exhibits, exhibition, exhilarating, exhibited, exhibiting
[XHO] exhort, foxhole, saxhorn, foxhound, exhortation, exhortative, exhortatory
[XHU] exhume, foxhunt, exhumation, exhumed, exhumes, exhuming, foxhunts
[XIA] axial, triaxial, alexia, anoxia, ataxia, abaxial, adaxial
[XIB] flexible, inflexible, nonflexible, flexibility, flexibly, flexibleness, inflexibly
[XIC] lexicology, toxic, taxicab, lexically, paradoxical, lexicography, ataxic
[XID] oxide, peroxide, hydroxide, tetroxide, dioxide, monoxide, pyxidium
[XIE] proxies, anxiety, dixie, moxie, pixie, pyxie, chronaxie
[XIF] detoxify, plexiform, saxifrage, tamoxifen, detoxified, detoxifies, saxifrages
[XIG] exigent, lexigraphy, exigence, exigency, exigible, exiguity, exiguous
[XII] xii, xxxii, xxii, lxii, clxii, taxiing, xiii
[XIL] axil, exile, auxiliary, foxily, sexily, flexile, maxilla
[XIM] maximize, oximeter, proximity, approximate, eximious, taximeter, maximum
[XIN] boxing, coaxing, fixing, mixing, toxin, indexing, waxing
[XIO] anxious, axiom, flexion, noxious, obnoxious, fluxion, defluxion
[XIP] xiphoid, taxiplane, alexipharmic, xiphisternum
[XIR] elixir, elixirs
[XIS] axis, exist, sexist, nonexistent, maxis, preexisting, xis
[XIT] exit, complexity, perplexity, convexity, fixity, laxity, pinxit
[XIU] unnilhexium, unnilhexiums
[XIV] xiv, reflexive, xxxiv, xxiv, lxiv, clxiv, lixivium
[XIW] taxiway, taxiways
[XIX] xix, xxxix, xxix, lxix, clxix
[XLE] axle, sexless, transaxle, axletree, sexlessness, axles, axletrees
[XLI] boxlike, sphinxlike
[XLY] laxly, convexly, prolixly, reflexly, complexly, orthodoxly
[XMA] taxman
[XME] taxmen, fluxmeter
[XNE] laxness, complexness
[XOB] exobiology, exobiologist
[XOC] exocarp, auxochrome, exocrine, exocentric, exocarps
[XOD] exodus, loxodromes, exoduses, loxodrome, exodontics, exodontist, loxodromic
[XOE] exoergic, exoenzyme
[XOG] exogenous, exogamous, exogamy, exogamies, exogenously
[XOI] toxoid
[XOL] axolotl, doxology, mixology, sexology, reflexology, mixologist, sexologist
[XOM] myxoma, buxom, buxomness, myxomycete, myxomatoses, myxomatosis, buxomnesses
[XON] axon, exon, taxon, hexone, klaxon, cytotaxonomy, axons
[XOP] saxophone, exoplanet, toxophilite, exophthalmos, saxophones, saxophonist, exoplanets
[XOR] xor, exorbitant, flexor, plexor, uxorial, exorable, exorcise
[XOS] hexose, exospore, exosmosis, exostosis, exoskeletal, hexoses, hexosan
[XOT] exotic, quixotic, exotica, exotically, exotics, exoteric, exotoxin
[XPA] expand, unexpanded, taxpayer, overexpand, sexpartite, expanded, expansion
[XPE] expected, unexpected, experimental, expensive, experience, inexpensive, expenditure
[XPI] expires, unexpired, inexpiable, expire, expired, expiration, expiring
[XPL] explicit, explanation, explained, explosion, exploration, exploding, exploited
[XPO] export, unexposed, reexport, overexposure, sexpot, preexpose, underexpose
[XPR] express, inexpressive, unexpressive, expression, expressions, expressed, expressly
[XPS] regexps
[XPU] expunge, inexpungible, inexpugnable, unexpurgated, expunged, expulsion, expulsive
[XQU] exquisite, exquisitely
[XRE] xref, xrefs
[XRO] boxroom, boxrooms
[XSA] exsanguine, exsanguinate
[XSC] exscind
[XSE] axseed, exsect, flaxseed, exsert, axseeds, flaxseeds
[XSH] sixshooter
[XSI] exsiccate
[XST] exstipulate
[XSW] coxswain, coxswains
[XTA] sextant, extant, juxtapose, oxtail, foxtail, juxtaposing, sextan
[XTB] textbook, textbooks
[XTD] nextdoor
[XTE] extension, external, extending, xterm, sixteen, extempore, dexter
[XTH] sixth, boxthorn, sixths, sixthly, boxthorns
[XTI] extinction, sixtieth, extinguish, textile, sextillion, bissextile, flextime
[XTL] ixtle, contextless
[XTO] extortion, sexton, extolled, extort, extol, extoller, extolling
[XTR] extra, foxtrot, dextro, ambidextrous, fluidextract, inextricably, extract
[XTS] texts, contexts, sexts, pretexts, subtexts, teletexts
[XTU] fixture, mixture, textual, contextual, saxtuba, sextuple, admixture
[XTY] sixty
[XUA] bisexual, sexuality, asexual, unsexual, nonsexual, unisexual, homosexual
[XUB] exuberant, exuberate, exuberance, exuberantly
[XUD] exudate, exude, exudation, exuded, exudes, exuding, exudates
[XUL] exult, exultant, exultation, exulted, exulting, exults, exultantly
[XUO] flexuous, flexuosity
[XUR] luxury, exurb, flexure, exurban, exurbia, luxuriant, luxuriate
[XUS] plexus, nexus, amphioxus, nexuses, plexuses, amphioxuses
[XUV] exuviae, exuviate, exuviated, exuviates, exuviating
[XVI] xvi, xxviii, xxxvii, lxvii, clxvii, xviii, xvii
[XWA] paxwax
[XWE] maxwell, maxwells
[XWI] waxwing, waxwings
[XWO] boxwood, waxwork, waxworks
[XXI] xxxii, xxi, xxii, xxxi, xxxiii, xxiii, xxxiv
[XXV] xxviii, xxxvii, xxvii, xxxvi, xxxviii, xxvi
[XXX] xxxii, xxxvii, xxxi, xxxiii, xxxiv, xxxix, xxxvi
[XYA] oxyacid, oxyacetylene, oxyacids
[XYC] oxycephaly, methoxychlor, oxycephalies
[XYG] oxygen, deoxygenate, oxygenic, oxygenate, oxygenous, oxygenation, oxygenated
[XYH] oxyhydrogen
[XYI] epoxying
[XYL] xylem, xylophone, hematoxylin, hydroxyl, hexyl, indoxyl, xylidine
[XYM] oxymora, oxymoron, oxymoronic
[XYR] deoxyribose, deoxyriboses
[XYS] xyster, oxysalt, paroxysm, paroxysmal, paroxysms
[XYT] oxytocic, oxytocin, oxytocins
[YAA] rufiyaa
[YAB] copyable, displayable, payable, playable, yabber, layabout, enjoyable
[YAC] yacht, hyacinth, chyack, oxyacid, playact, bellyache, yachted
[YAD] dyadic, noyade, dryad, bayadere, hamadryad, dyad, dyads
[YAG] voyage, buoyage, drayage, satyagraha, voyager, voyageur, voyaged
[YAH] yahoo, ayah, aliyah, gunyah, yah, aliyahs, ayahs
[YAK] kayak, yak, galyak, sukiyaki, teriyaki, kayaks, yakked
[YAL] royalty, nyala, myall, loyalty, bathyal, hyaline, ptyalin
[YAM] yam, polyamide, hyoscyamus, yammer, yams, yammerer, polyamory
[YAN] banyan, cyan, yank, yang, conveyance, buoyancy, annoyance
[YAP] yap, mayapple, yapped, yapping, yaps, yapper, yapok
[YAR] backyard, barnyard, courtyard, yard, yarn, yarrow, graveyard
[YAS] yashmak, eyas, sannyasi, dryasdust, myasthenia, papayas, ouguiyas
[YAT] cyathus, caryatid, kyat, yataghan, ayatollah, polyatomic, ayatollahs
[YAU] yaupon, yautia, yautias
[YAW] yaw, flyaway, layaway, yawl, yawn, yawned, yawning
[YBA] playback, flyback, moneybag, volleyball, piggyback, buyback, crybaby
[YBB] dybbuk, nybble, dybbukim, dybbuks, nybbles
[YBD] molybdenum, molybdic, molybdate, molybdous, molybdenite, molybdenous, molybdenites
[YBE] maybe, honeybee, cybernetics, cyberpunk, jellybean, soybeans, daybed
[YBI] waybill, keybindings, jaybird, ladybird, playbill, chalybite, dickybird
[YBL] flyblow, twayblade, flyblown, twayblades
[YBO] keyboard, anybody, everybody, storyboard, cyborg, toyboy, copyboy
[YBR] hybrid, daybreak, dihybrid, donnybrook, hybris, hybrids, hybridism
[YBU] trolleybus, ladybug, mealybug, honeybunch, jerrybuilt, bellybutton, bodybuilder
[YBY] flybys, flyby
[YCA] skycap, copycat, cycad, daycare, keycard, billycan, jerrycan
[YCE] barycentric, lyceum, mycelia, sycee, glyceric, ascomycete, myxomycete
[YCH] psychs, diptych, lychnis, tychism, paycheck, triptych, bodycheck
[YCI] glycine, bombycid, calycine, neomycin, actinomycin, erythromycin, streptomycin
[YCL] cycle, acyclic, bicyclist, recycling, motorcycle, polycyclic, encyclopedia
[YCN] pycnidium, pycnometer, pycnidiums
[YCO] mycol, honeycomb, glycol, tycoon, boycott, haycock, sycosis
[YCT] phlyctena, nyctalopia, nyctophobia, nyctalopias, nyctophobias
[YCY] polycyclic, polycythemia
[YDA] everyday, payday, heyday, mayday, whydah, hydatid, corydalis
[YDD] lyddite
[YDE] honeydew, aldehyde, hoyden, zydeco, copydesk, pachyderm, chlamydeous
[YDI] katydid, skydive, chlamydia, polydipsia, skydiver, skydiving, chlamydiae
[YDN] hydnocarpate
[YDO] fogeydom
[YDR] hydrogen, carbohydrate, daydream, dihydric, hydracid, anhydride, clepsydra
[YDS] alkyds, athodyds
[YEA] year, yeast, yeah, lightyear, midyear, biyearly, yean
[YEB] eyebrow, eyebrows, eyeballs, eyeball, eyeballing, eyebolt, eyebright
[YEC] eyecup, embryectomy, eyecups
[YED] delayed, displayed, keyed, destroyed, splayed, conveyed, played
[YEE] employee, payee, fedayeen, employees, payees
[YEF] eyeful, eyefuls
[YEG] eyeglasses, yegg, eyeglass, yeggs
[YEH] eyehole, kaffiyeh, keffiyeh
[YEI] dyeing, eyeing, redyeing, dyeings
[YEL] yell, yelp, eyelid, myelin, dyeline, outyell, pyelitis
[YEM] pyemia, empyema
[YEN] yen, cayenne, doyen, hyena, yens, yenta, yentas
[YEO] yeoman, eyeopener, yeomen, yeomanry, eyeopening, yeomanly, eyeopeners
[YEP] eyepieces, yep, yeps, eyepiece
[YER] buyer, flyer, fryer, layer, player, lawyer, prayer
[YES] eyes, yesterday, polyester, ayes, dyes, shyest, wryest
[YET] yeti, polyethylene, hyetal, layette, vilayet, eyeteeth, eyetooth
[YEU] voyeur, voyeurism, voyeuristic, voyeurs
[YEW] yew, dyewood, eyewash, yews, eyewitness, dyewoods, eyewitnesses
[YEY] clayey
[YEZ] oyez
[YFA] wayfarer, wayfaring, wayfarers, wayfarings
[YFE] splayfeet, playfellow, playfellows
[YFI] jellyfish, crayfish, hayfield, platyfish, ladyfinger, hayfields, crayfishes
[YFL] dayfly, mayfly, candyfloss, gillyflower, dayflower, mayflower, dayflies
[YFO] hayfork, manyfold, splayfoot, hayforks, splayfooted
[YFR] boyfriend, boyfriends
[YFU] playful, joyful, bellyful, joyfuller, joyfullest, joyfulness, playfulness
[YFY] cockneyfy
[YGA] lollygag, polygamy, zygapophysis, polygamist, polygamous, lollygagged, lollygagging
[YGD] amygdala, amygdalin, amygdalate, amygdaline, amygdaloid, amygdalas
[YGE] oxygen, apophyge, coccyges, hypophyge, callipygean, deoxygenate, polygenesis
[YGI] syzygies, hygiene, playgirl, pygidium, uropygium, apterygial, unhygienic
[YGL] polyglot, spyglass, polyglotism, polyglots, spyglasses
[YGM] pygmean, sphygmic, borborygmus, pygmy, sphygmoid, sphygmograph, pygmies
[YGN] cygnet, cygnets
[YGO] polygon, bygone, zygoma, azygous, playgoer, dizygotic, easygoing
[YGR] playground, polygraphic, hygrostat, hygrograph, hygrometer, tachygraphy, hygrophilous
[YGU] bodyguard, bodyguards
[YGY] syzygy, polygyny, polygynist, polygynous, polygynies, polygynists
[YHA] mayhap, ninnyhammer
[YHE] polyhedron, mayhem, greyhen, poppyhead, sleepyhead, heavyhearted, polyhedral
[YHI] polyhistor
[YHO] anyhow, copyholder, boyhood, keyhole, skyhook, spyhole, tallyho
[YHY] polyhydric, oxyhydrogen, polyhydroxy
[YIA] myiasis
[YIC] ichthyic
[YID] sayyid, yid, yids
[YIE] yield, clayier, unyielding, nonyielding, yielded, yielding, yields
[YIK] yikes
[YIM] goyim
[YIN] buying, crying, flying, lying, yin, underlying, copying
[YIP] yip, bunyip, yipped, yippee, yipping, yips, yippie
[YIS] boyish, dryish, goyish, babyish, clayish, copyist, fogyish
[YJA] skyjack, skyjacker, skyjacking, skyjacks, skyjacked, skyjackers, skyjackings
[YKE] fyke, tyke, tykes
[YKN] pyknic
[YLA] skylark, fairyland, waylay, amylase, astylar, boyla, bylaw
[YLE] style, copyleft, kyle, restyle, ethylene, hairstyle, polyethylene
[YLF] fylfot
[YLG] nylghau, nylghaus
[YLI] cylinder, styling, daylight, skyline, hematoxylin, byline, playlist
[YLL] syllable, syllogism, beryllium, polysyllabic, phyllo, ghyll, idyll
[YLO] payload, pylon, nylon, xylophone, amyloid, chylous, daylong
[YLP] sylphs, sylph, sylphic, sylphid, sylphlike
[YLS] alkyls, allyls, beryls, sibyls, vinyls, acetyls, benzyls
[YLU] phylum, subphylum, superphylum, amylum, asylum, stylus, malonylurea
[YLV] sylvan, sylvite, sylvanite, sylviculture, sylvites, sylvanites
[YLY] acrylyl, tachylyte, spryly, coyly, dryly, feyly, shyly
[YMA] handyman, layman, policymaker, flyman, zymase, bogyman, cymar
[YMB] symbol, corymb, cymbal, tymbal, symbols, symbolic, symbology
[YME] payment, deployment, employment, polymer, enjoyment, unemployment, rhyme
[YMI] patronymic, anonymity, neodymium, praseodymium, stymie, thymic, enzymic
[YMK] gymkhana, gymkhanas
[YMM] symmetric, asymmetric, dissymmetry, symmetry, symmetries, symmetrize, symmetrized
[YMN] gymnastics, hymnal, gymnasiast, gymnosperm, gymnosophist, gymnast, hymnist
[YMO] anonymous, anymore, polymorphic, synonymous, eponymous, homonymous, cymoid
[YMP] asymptotic, symposium, symptoms, sympathizing, nympha, tympan, lymph
[YMS] acronyms, synonyms, gymslip, anonyms, eponyms, antonyms, homonyms
[YMU] thymus, zymurgy, euonymus, evonymus, ginglymus, thymuses, ginglymuses
[YMY] eponymy, antonymy, homonymy, meronymy, metonymy, paronymy, synonymy
[YNA] dynamic, synagogue, synaptic, adynamia, gynandry, gynarchy, myna
[YNC] sync, asynchronous, lynch, lipsynch, geosyncline, idiosyncrasy, synchronized
[YND] syndrome, syndication, syndesis, wynd, asyndeton, syndactyl, syndicalism
[YNE] dyne, dryness, synergy, grayness, alkyne, ethyne, anodyne
[YNF] synfuel, synfuels
[YNG] pharyngeal, laryngeal, eryngo, syngamy, eryngoes, larynges, pharynges
[YNI] paynim, cynic, gyniatrics, misogynist, polygynist, philogynist, pleurodynia
[YNO] polynomial, synopsis, dynode, synonyms, keynote, epigynous, hypogynous
[YNS] synsepalous
[YNT] syntax, colocynth, apocynthion, resynthesis, biosyntheses, pericynthion, syntactic
[YNU] polynuclear
[YNX] lynx, larynx, pharynx, nasopharynx, lynxes
[YNY] misogyny, monogyny, polygyny, androgyny, philogyny
[YOB] yobs, yobbo, cryobiology, yob, yobbos
[YOC] myocardial, myocardia, myocardium, myocarditis, myocardiums
[YOD] yodel, yodle, diphyodont, yodeled, yodeler, yodeling, yodels
[YOE] kayoed
[YOF] payoff, layoff, playoff, payoffs, layoffs, playoffs
[YOG] yoga, yogi, yogurt, yogh, cryogenic, myogenic, karyogamy
[YOH] cryohydrate
[YOI] yoicks, hyoid, pyoid, ichthyoid, mylohyoid, botryoidal, kayoing
[YOK] yokel, karyokinesis, unyoke, yoking, yokels, yoke, yoked
[YOL] yolk, crayola, payola, embryol, myology, bryology, cryolite
[YOM] cryometer, cryometers
[YON] beyond, canyon, crayon, yonder, anyone, everyone, rayon
[YOP] myopic, amblyopia, bryophyte, caryopses, lyophilic, lyophobic, karyoplasm
[YOR] york, surveyor, mayor, conveyor, purveyor, pyorrhea, yore
[YOS] myosin, pyosis, cryostat, hyoscine, karyosome, actomyosin, ichthyosis
[YOT] coyote, peyote, chayote, guyot, myotome, eyot, karyotin
[YOU] bayou, you, layout, carryout, joyous, payout, buyout
[YOV] flyover, layover, carryover, flyovers, layovers, carryovers
[YOW] yowl, yowled, yowling, yowls, yow
[YOX] glyoxaline
[YOZ] bryozoan, bryozoans
[YPA] bypass, keypad, smartypants, claypan, flypast, typal, polypary
[YPE] type, hyper, subtype, datatype, prototype, countertype, monotype
[YPH] glyph, hyphen, typhoon, hieroglyph, unhyphenated, scyphi, sypher
[YPI] typing, atypical, mistyping, prototyping, untypical, genotypic, monotypic
[YPL] anyplace, byplay, manyplies, polyploid, everyplace, polyploids
[YPN] hypnoses, hypnagogic, dehypnotize, autohypnosis, posthypnotic, hypnosis, hypnotic
[YPO] hypo, typo, honeypot, maypole, drypoint, polypody, monkeypot
[YPP] gypped, gypper, gypping, gyppers
[YPR] byproduct, cypress, cyprinid, cyprinoid, cyprinodont, cypripedium, cypresses
[YPS] gypsum, calypso, cypsela, stypsis, trypsin, apocalypse, hypsometer
[YPT] crypt, encrypt, eucalypt, decrypt, krypton, tryptophan, glyptic
[YPU] platypus, coypu, polypus, keypunch, keypuncher, coypus, polypuses
[YPW] typw
[YPY] phonotypy, phototypy, stenotypy, stereotypy
[YRA] pyramid, tyrant, gyrator, lyrate, styrax, hayrack, hyraces
[YRD] fyrd, martyrdom
[YRE] byre, gyre, lyre, pyre, tyre, polystyrene, styrene
[YRF] gyrfalcon, gyrfalcons
[YRI] lyric, myriad, copyright, thyristor, keyring, syringe, labyrinth
[YRM] myrmidon, myrmecology, myrmidons
[YRN] byrnie, byrnies
[YRO] gyro, pyromania, tyro, byroad, chyron, joyrode, payroll
[YRR] myrrh, pyrrhic, pyrrhotite, pyrrhuloxia, pyrrolidine, pyrrhics, pyrrhuloxias
[YRS] yrs, thyrsus, satyrs, martyrs, zephyrs, thyrse
[YRT] myrtle, myrtles, myrtaceous
[YRU] papyrus, syrupy, gyrus, pyruvate, hydrargyrum, syrup, syrups
[YRY] martyry, porphyry
[YSA] sysadmin, babysat, oxysalt, skysail, trysail, naysayer, staysail
[YSC] skyscraper, cityscape, dyscrasia, playschool, bathyscaphe, skyscrapers, skyscape
[YSE] myself, analyses, lyse, geyser, ecdyses, hayseed, thyself
[YSF] dysfunction, dysfunctions
[YSG] dysgenic, dysgraphia, dysgenics
[YSH] toyshop, flysheet, ladyship, suretyship, monkeyshine, viceroyship, attorneyship
[YSI] physics, analysis, metaphysics, geophysics, astrophysics, lysine, zoysia
[YSL] payslip, dyslalia, dyslexia, dyslogia, dyslexic, dyslectic, dyslogistic
[YSM] abysmal, cataclysm, paroxysm, aneurysm, platysma, abysm, aneurysmal
[YSO] hyson, sysop, lysozyme, lysosomal, bobbysocks, chrysolite, chrysotile
[YSP] dyspnea, flyspeck, dayspring, bathysphere, dysprosium, dyspepsia, dyspeptic
[YSQ] diddlysquat
[YSS] odyssey, vichyssoise, byssus, hyssop, abyss, alyssum, lyssa
[YST] amethyst, analyst, catalyst, crystal, mystery, system, keystroke
[YSU] dysuria, bodysuit, playsuit, honeysucker, bodysurf, honeysuckle, bodysuits
[YSW] flyswatter, skysweeper, flyswatters
[YSY] polysyllabic, polysyndeton, polysyllable
[YTA] baryta, babytalk, cytaster, ponytail, epiphytal, fairytale, prytaneum
[YTE] bytes, kilobyte, polytechnic, gigabytes, megabytes, terabytes, exabytes
[YTH] myth, rhythm, scythe, python, anything, everything, arrhythmia
[YTI] analytic, daytime, electrolytic, anytime, catalytic, lytic, dialytic
[YTO] cytology, cytoplasmic, rhyton, baryton, cytosine, oxytocic, claytonia
[YTR] elytron, flytrap, hemelytron, hemielytron, polytrophic, elytrons, flytraps
[YTT] yttrium, ytterbium, lytta, yttria, ytterbia, ytterbite, yttriferous
[YTU] adytum, candytuft, candytufts
[YTY] polytypic
[YUA] yuan
[YUC] yucca, yuck, yuccas, yucky, yuckier, yuckiest
[YUK] yuk, yuks, yukky, yukked, yukking
[YUL] yule, guayule, yulan, yuletide, guayules
[YUM] yum, yummy, yummier, yummiest
[YUN] picayune
[YUP] yup, layup, yuppie, yuppies, yuppify, yuppiedom, layups
[YUR] yurt, polyurethane, pyuria, dasyure, brachyuran, yurts, dasyures
[YUS] cayuse, cayuses
[YUZ] yuzus, yuzu
[YVA] polyvalent, polyvalence, polyvalency
[YVE] jayvee, gyve, wyvern, gyved, gyves, wyverns
[YVI] polyvinyl, gyving
[YVN] hryvnia
[YWA] anyway, flyway, keyway, skyway, byway, drywall, hayward
[YWE] flyweight, heavyweight, mayweed, newlywed, crazyweed, pennyweight, mayweeds
[YWH] anywhere, everywhere, flywheel, anywheres, flywheels
[YWI] haywire, anywise, citywide, ywis, countywide, tiddlywink, countrywide
[YWO] keyword, plywood, byword, baywood, wayworn, armyworm, bodywork
[YWR] playwright, skywriter, copywriter, baggywrinkle, skywriting, copywriting, playwriting
[YXE] myxedema, onyxes, oryxes, calyxes, pyxes, apteryxes, epicalyxes
[YXI] pyxie, asphyxia, anaptyxis, polymyxin, pyxidium, asphyxiant, asphyxiate
[YXO] myxoma, myxomycete, myxomatoses, myxomatosis, myxomycetes
[YYI] sayyid
[YZA] byzantine, coryza, analyzable, hydrolyzate, coryzas, hydrolyzates
[YZE] analyze, dialyze, catalyze, paralyze, pyrolyze, autolyzes, hydrolyze
[YZG] wayzgoose
[YZI] analyzing, paralyzing, dialyzing, catalyzing, hydrolyzing, reanalyzing, paralyzingly
[YZO] polyzoan, polyzoic, polyzoarium, polyzoans
[YZY] syzygy, syzygies, syzygial
[ZAA] bazaar, bazaars
[ZAB] serializable, recognizably, realizable, normalizable, sizable, optimizable, squeezable
[ZAC] kazachok
[ZAD] cruzado
[ZAE] stanzaed
[ZAF] zaffer, zaftig
[ZAG] zigzag, zigzagged, zigzagging, zigzags, zigzagger
[ZAH] huzzah, mezuzah, matzah, huzzahs, matzahs, huzzahed, huzzahing
[ZAI] banzai, zaire, stanzaic, zaibatsu, zaires, banzais
[ZAK] muzak
[ZAL] quetzal, azalea, surprizal, benzaldehyde, azaleas, quetzals
[ZAM] zamia, zamindar, zamias
[ZAN] zany, zanies, byzantine, bezant, chazan, hazan, azan
[ZAP] zap, zapped, zapper, zapping, zaps, zappy, zapateado
[ZAR] bizarre, blizzard, hazard, lizard, wizards, lazar, alizarin
[ZAS] stanzas, pizzas, plazas, baizas, colzas, coryzas, kwanzas
[ZAT] optimization, organization, quantization, minimization, localization, utilization, finalization
[ZAX] zax, zaxes
[ZAY] zayin, zayins
[ZAZ] pizzazz, pzazz, zazen, pizzazzes
[ZBA] fuzzball, whizzbang, fuzzballs, whizzbangs
[ZCA] vizcacha, mezcaline, mezcal
[ZDA] samizdat, samizdats
[ZEA] zeal, overzealous, zealot, zealous, zealotry, zealousness, zealots
[ZEB] zebra, zebu, gazebo, jezebel, zebec, sleazebag, squeezebox
[ZEC] zecchino
[ZED] amazed, blazed, dazed, glazed, zed, normalized, serialized
[ZEE] chimpanzee, zee, razee, recognizee, zees, chimpanzees
[ZEF] prizefight, prizefighter, prizefights
[ZEH] gazehound
[ZEI] cruzeiro, zeitgeist, cruzeiros, zeitgeists
[ZEL] hazel, pretzel, bezel, gazelle, ouzel, vuvuzela, schnitzel
[ZEM] eczema, zemstvo, amazement, chernozem, amortizement, eczematous
[ZEN] citizen, dozen, frozen, zen, lozenge, unfrozen, benzene
[ZEO] zeolite, azeotrope, zeolites
[ZEP] zephyr, zeppelin, diazepam, douzepers, zephyrs, zeppelins, diazepams
[ZER] blazer, freezer, zero, bulldozer, nonzero, optimizer, analyzer
[ZES] amazes, breezes, freezes, prizes, zest, sizes, initializes
[ZET] zeta, gazette, frizette, mozzetta, terzetto, gazetteer, zetas
[ZEU] zeugma, hypozeugma, zeugmatic, hypozeuxis, zeugmas
[ZEW] breezeway, prizewinner, prizewinning, breezeways, prizewinners
[ZGI] fizgig, fizgigs
[ZGO] wayzgoose
[ZHI] muzhik, muzhiks
[ZHO] zho, zhos
[ZIA] razzia, deutzia, bilharzia, bilharziases, bilharziasis, deutzias
[ZIB] zibet, zibeline
[ZIC] pizzicato, quizzical, pizzicati, quizzicality, quizzically
[ZID] azide, benzidine, isoniazid, zidovudine, azides, zidovudines
[ZIE] vizier, frenzies, brazier, glazier, grazier, prezzie, gaberlunzie
[ZIF] denazify, trapeziform, denazified, denazifies, denazifying
[ZIG] zigzag, zigs, ziggurat, dziggetai, zigzagged, zigzagging, zigzags
[ZIK] tzatziki
[ZIL] brazil, zillion, lazily, crazily, fuzzily, gazillions, cozily
[ZIM] azimuth, kibbutzim, altazimuth, azimuthal, azimuths, altazimuths
[ZIN] amazing, blazing, magazine, zinc, zinnia, sizing, resizing
[ZIP] unzip, zip, marzipan, zipped, zipper, zippy, zips
[ZIQ] bezique, beziques
[ZIR] zircon, zirconia, zirconium, zircons, zirconias
[ZIT] zit, zizith, kunzite, monazite, chabazite, quartzite, zither
[ZIU] trapezium, trapezius, trapeziums
[ZIZ] zizz, zizith, zizzes, zizzed
[ZKA] britzka
[ZKI] whizkid, buzzkill, buzzkills
[ZKR] blitzkrieg, blitzkriegs
[ZLE] swizzle, puzzle, muzzle, dazzle, nozzle, razzle, fizzle
[ZLI] puzzling, dazzling, sizzling, fizzling, guzzling, mizzling, muzzling
[ZLO] zlotys, zloty, zloties
[ZLY] grizzly, drizzly, frizzly
[ZMA] hazmat, razzmatazz, jazzman, sitzmark, quizmaster, quizmasters
[ZME] jazzmen
[ZMO] gizmo, gizmos
[ZNI] kibbutznik, kibbutzniks
[ZOA] zoa, bezoar, epizoa, entozoa, benzoate, bryozoan, polyzoan
[ZOB] rhizobium, azobenzene
[ZOC] benzocaine, rhizocarpous, benzocaines
[ZOD] zodiac, zodiacal, zodiacs
[ZOE] zoea, zoeae, zoeas
[ZOF] zoftig, benzofuran, benzofurans
[ZOG] rhizogenic, schizogony, schizogonies
[ZOH] matzoh, matzohs
[ZOI] borzoi, azoic, trapezoid, benzoic, epizoic, rhizoid, entozoic
[ZOL] benzol, azole, diazole, pyrazole, thiazole, carbazole, imidazole
[ZOM] zombie, rhizome, diazomethane, schizomycete, zombies, zombielike, rhizomes
[ZON] amazon, horizon, ozone, zone, timezone, zonal, rezone
[ZOO] bazooka, kazoo, zoo, epizoon, wazoo, entozoon, enzootic
[ZOP] rhizopod, schizopod, benzophenone, rhizopods
[ZOR] razor, machzor, zorch, zoril, recognizor, razors, razorback
[ZOS] garbanzos, zoster, matzos, mezzos, bozos, ouzos, schizos
[ZOT] azote, matzot, mezuzot, diazotize, mezzotint, rhizotomy, schizothymia
[ZOU] zounds, bouzouki, bashibazouk, bouzoukis
[ZOY] zoysia, benzoyl, zoysias
[ZPA] gazpacho, chutzpah
[ZSA] buzzsaw
[ZUC] zucchini, zucchinis, zucchetto
[ZUE] zarzuela
[ZUG] zugzwang
[ZUL] lazuli, lazulite, lazulis
[ZUM] gazump, mazuma, gazumps, gazumped, gazumping
[ZUR] azure, mazurka, seizure, lazurite, azurite, azures, mazurkas
[ZUS] kanzus, kudzus, yuzus
[ZUZ] mezuza, mezuzah, mezuzot, mezuzoth
[ZVA] mitzvah
[ZVO] mitzvoth, rendezvous, rendezvoused, rendezvouses
[ZWA] zugzwang
[ZWI] zwieback
[ZWO] buzzword, buzzwords
[ZYB] lazybones
[ZYD] zydeco
[ZYG] azygous, zygoma, syzygy, dizygotic, homozygote, monozygotic, heterozygote
[ZYI] lazying, dizzying
[ZYL] benzyl, benzyls
[ZYM] enzyme, zyme, zymase, zymogen, zymurgy, coenzyme, lysozyme
[ZYW] crazyweed, crazyweeds
[ZZA] pizza, blizzard, huzzah, izzard, piazza, buzzard, gizzard
[ZZB] fuzzball, whizzbang, fuzzballs, whizzbangs
[ZZE] buzzer, quizzes, fuzzes, fezzes, mizzen, whizzed, mozzetta
[ZZI] dizzier, fuzzier, jazzier, pizzicato, razzia, jacuzzi, muezzin
[ZZK] buzzkill, buzzkills
[ZZL] dazzle, drizzle, fizzle, puzzle, sizzle, swizzle, muzzle
[ZZM] razzmatazz, jazzman, jazzmen
[ZZO] mezzo, terrazzo, palazzo, paparazzo, intermezzo, mezzos, mezzotint
[ZZS] buzzsaw
[ZZW] buzzword, buzzwords
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
    learnedPivotMode = "self",
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

    -- Replicated state turn tracker
    stateCandidates = {},
    confirmedState = nil,
    lastStateScan = 0,

    -- Locked combo, and oppent word tracker
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
UI.themeToggles = {}
local Detector: { [string]: any } = {}
local Tracker: { [string]: any } = {}
local Typer: { [string]: any } = {}

-- Player maps (names, display names, and UserIds)
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


-- 1. EMBEDDED WORD BANK MODULE

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


-- 2. THE UI
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
    for _, refresh in ipairs(UI.themeToggles) do
        refresh()
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
    -- If what we picked up is NOT an actual word, dont guess it, just provide "NOT IN DATABANK"
    local isKnown = wordText ~= nil and STATE.masterWordSet[wordText] == true
    if wordText and not isKnown then
        UI.otherWordValue.Text = "NOT IN DATABANK"
        UI.otherWordValue.TextColor3 = COLORS.Red
    else
        UI.otherWordValue.Text = wordText or "--"
        UI.otherWordValue.TextColor3 = wordText and COLORS.Amber or COLORS.SubText
    end
end

function UI.updateStats()
    local badge = (STATE.isCalibrated and STATE.arrowMotionVerified) and STATE.turnSourceText
        or (STATE.isCalibrated and "Sync..." or "Uncal")
    UI.statsLabel.Text = string.format(
        "Used: %d (You: %d, Opp: %d) • Bank: %d • %s",
        STATE.usedCount, STATE.mySentCount, STATE.otherUsedCount, #STATE.masterWordList, badge
    )
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

local function makeToggleRow(parent, order, labelText, subText, initialState, onToggle)
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
        BackgroundColor3 = initialState and getTheme().Secondary or COLORS.ToggleOff,
        BorderSizePixel = 0, Font = Enum.Font.GothamBlack,
        Text = initialState and "ON" or "OFF",
        TextColor3 = initialState and COLORS.DarkInk or COLORS.SubText,
        TextSize = 13,
    }, row)
    addBorder(badge, COLORS.Border, 1)

    local state = initialState
    local function setVisual(newState, newSub)
        if newState ~= nil then
            state = newState
        end
        if newSub then
            subLbl.Text = newSub
        end
        badge.Text = state and "ON" or "OFF"
        TweenService:Create(badge, TweenInfo.new(0.15), {
            BackgroundColor3 = state and getTheme().Secondary or COLORS.ToggleOff,
            TextColor3 = state and COLORS.DarkInk or COLORS.SubText,
        }):Play()
    end

    row.MouseButton1Click:Connect(function()
        onToggle(not state)
    end)
    table.insert(UI.themeToggles, function() setVisual(nil) end)
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

    UI.setAutoToggle = makeToggleRow(page, 2, "Auto-Typer", "Press F1 on your turn to start", CONFIG.Enabled, function(v)
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
            Font = Enum.Font.GothamBold, Text = "40-90ms", TextColor3 = getTheme().Primary, TextSize = 13,
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
                    BackgroundColor3 = sel and theme.Secondary or COLORS.Card,
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
        CONFIG.HumanTypos,
        function(v)
            CONFIG.HumanTypos = v
            setTyposToggle(v)
        end
    )

    local setThinkToggle
    setThinkToggle = makeToggleRow(
        page, 3, "Think Pause", "Adds a 0.35s-1.0s reaction pause on your turn",
        CONFIG.ThinkDelay,
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


-- 3. GUI, AND ARROW DETECTION

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

--[[Cache the last prompt label/gui we found and reuse it while it is
still on screen, instead of walking every descendant of every ScreenGui on
every tick. This is what caused the heavy lag while waiting for your turn
(the full-tree scan ran repeatedly per second the whole time you weren't typing).]]
local ComboCache = { gui = nil, label = nil, lastScan = 0 }
local COMBO_RESCAN_INTERVAL = 0.5 -- full GUI re-scan MAX twice a second

function Detector.findComboAndGui()
    local cached = ComboCache.label
    if cached and cached.Parent and ComboCache.gui and ComboCache.gui.Parent
        and Detector.isGuiVisible(cached) then
        local low = cached.Text:lower()
        if low:find("containing", 1, true) or low:find("word with", 1, true) then
            return Detector.extractCombo(cached, ComboCache.gui), ComboCache.gui, cached
        end
    end

    local now = os.clock()
    if now - ComboCache.lastScan < COMBO_RESCAN_INTERVAL then
        return nil, nil, nil
    end
    ComboCache.lastScan = now

    for _, gui in ipairs(Detector.getActiveScreenGuis()) do
        for _, desc in ipairs(gui:GetDescendants()) do
            if desc:IsA("TextLabel") and Detector.isGuiVisible(desc) and not Detector.isChatOrSidebar(desc) then
                local low = desc.Text:lower()
                if low:find("containing", 1, true) or low:find("word with", 1, true) then
                    ComboCache.gui, ComboCache.label = gui, desc
                    return Detector.extractCombo(desc, gui), gui, desc
                end
            end
        end
    end
    ComboCache.gui, ComboCache.label = nil, nil
    return nil, nil, nil
end

local TypeboxCache = { box = nil, forGui = nil }

function Detector.findTypebox(preferredGui)
    local cached = TypeboxCache.box
    if cached and cached.Parent and cached.TextEditable and Detector.isGuiVisible(cached)
        and (not preferredGui or TypeboxCache.forGui == preferredGui or TypeboxCache.forGui == nil) then
        return cached
    end

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
    TypeboxCache.box, TypeboxCache.forGui = bestBox, preferredGui
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

    -- Small pause so if F1 was pressed mid-swing, the arrow finishes settling on you
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

function Detector.reacquireArrow(promptGui, arenaCenter)
    if STATE.confirmedArrow and STATE.confirmedArrow.Parent and Detector.isGuiVisible(STATE.confirmedArrow) then
        return STATE.confirmedArrow
    end
    STATE.confirmedArrow = nil
    if not promptGui or not arenaCenter then
        return nil
    end

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


-- 4. OTHER-PLAYER WORD TRACKER

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


-- 5. TYPING, SUBMISSION & CALIBRATION EXECUTION

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

-- 6. BOOTSTRAP UI, HOTKEYS (F1 and F2) and MAIN LOOP

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

        task.wait(0.1)

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

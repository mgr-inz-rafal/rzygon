;	@com.wudsn.ide.asm.mainsourcefile=main.asm

STR_CLEAR_CIST	dta d"   "
STR_CLEAR_CIST1 dta d"  "
STR_CLEAR_LONG	dta d"   "
ITEM_CLEAR		dta d"     "
ACT_MENU_CLR	dta d"    "
STR_CLEAR		dta d" "
CISTERN_CLR_0	dta d"  "
CISTERN_CLR_1	dta d"   "
DEMON_CLR		dta d" "
ACT_CURSOR_CLR	dta d"  "
CHAR_CLR		dta d" ",b($9b)
				dta b(71),b(71),b(71),b(71),b(71)
				dta b(71),b(71),b(71),b(71),b(71)
				dta b(71),b(71),b(71),b(71),b(71)
				dta b(71),b(71),b(71),b(71)
				dta	b(71),b($9b)
LVLNAME_BRD_COR	dta b(70)
LVLNAME_BORDER	dta b($9b)
ACT_CURSOR		dta b(0),b(66),b(0),b($9b)
STATUS_MSG_BR1	dta b(73),b(94),b(87),b(87),b(87),b(87),b(87),b(87),b(87),b(87),b(87),b(87),b(87),b(87),b(87),b(87),b(87),b(87),b(87),b(87),b(87),b(87),b(87),b(87),b(87),b(87),b(87),b(87),b(87),b(87),b(87),b(87),b(87),b(87),b(87),b(87),b(87),b(87),b(94),b(74),b($9b)
STATUS_MSG_BR2	dta b(84),b(95),b(89),b(89),b(89),b(89),b(89),b(89),b(89),b(89),b(89),b(89),b(89),b(89),b(89),b(89),b(89),b(89),b(89),b(89),b(89),b(89),b(89),b(89),b(89),b(89),b(89),b(89),b(89),b(89),b(89),b(89),b(89),b(89),b(89),b(89),b(89),b(89),b(95),b(85),b($9b)

; Moved bed
MOVED_BED_TOP	dta b(89),b(118),b(48),b(0),b(0),b($9b)
MOVED_BED_BOT	dta b(121),b(122),b(123),b(0),b(0),b($9b)

; Action menu border
ACT_MENU_BRDR	dta b(66),d"            ",b(66),b($9b)

; Title
TITLE_01	; Top border
				dta b(73),b(94)
:36				dta b(87)
				dta b(94),b(74)
				dta b($9b)
TITLE_02	; Bottom border
				dta b(84),b(95)
:36				dta b(89)
				dta b(95),b(85)
				dta b($9b)
TITLE_03	; Middle
				dta b(91),b(93)
:36				dta b(0)
				dta b(93),b(92)
				dta b($9b)

; Pliterki:
;e - 69
;o - 79
;a - 65
;s - 83
;l - 76
;z - 90
;x - 75
;c - 67
;n - 78
;" - 2

DISCLAIMER_00	dta "             WARNING!             ",b($9b)
DISCLAIMER_01	dta "Main hero of this game is a priest",b($9b)
DISCLAIMER_02	dta "hanging around some strange worlds",b($9b)
DISCLAIMER_03	dta "and interacting with smelly items.",b($9b)
DISCLAIMER_04	dta "Therefore, if you are religious   ",b($9b)
DISCLAIMER_05	dta "person you may feel offended.     ",b($9b)
DISCLAIMER_06	dta "If you want to give it a try press",b($9b)
DISCLAIMER_07	dta "the FIRE button at your own risk. ",b($9b)
DISCLAIMER_08	dta "Otherwise, please shutdown your   ",b($9b)
DISCLAIMER_09	dta "computer and do something else.   ",b($9b)
TITLEPAGE_00
				dta "                                  "
				dta "      DUSZPASTERZ JAN RZYGO",b(77),"      "
				dta "an adventure-platform-jumping game"
				dta "                                  "
				dta "Mgr in",b(90),". Rafa",b(76),"'s  Advanced Virtual"
				dta "  Computer Entertainment Studios  "
				dta "                                  "
				dta "    use joystick to flip pages    "
				dta "                                  "
				dta "               v1.2 (EN) - 01.2016"
TITLEPAGE_01
				dta "  Tight presbytery, monastery,    "
				dta "milk-bar ",b(2),"Fed Fred",b(2)," and local     "
				dta "liquor store. That was his entire "
				dta "life. Priest John McPuke as ex-   "
				dta "tremely dull and straightforward  "
				dta "person enjoyed only two things -  "
				dta "preaching older people and Chris- "
				dta "tianizing poor guys that happen to"
				dta "enter his church. Quite a paro-   "
				dta "chial hobby.                      "

TITLEPAGE_02
				dta "  Each time the horde of faithful "
				dta "people gathered in the church John"
				dta "McPuke felt very pleased and joy- "
				dta "ful. Aisles have been bursting at "
				dta "the seams, bishop couldn't catch  "
				dta "up to spawn the holy water, fleas "
				dta "and other eerie bugs were repro-  "
				dta "ducing like crazy among the mul-  "
				dta "titude of sweaty bodies.          "
				dta "                                  "
				
TITLEPAGE_03
				dta "  One Sunday morning John was pre-"
				dta "paring to celebrate High Mass.    "
				dta "Suddenly he felt anxious,         "
				dta "trembling feeling inside the in-  "
				dta "testine. He quickly realized that "
				dta "next few hours will be spent sit- "
				dta "ting on the toilet bowl. Despite  "
				dta "the big rush he managed to text   "
				dta "bishop and beg for substitution   "
				dta "during the ritual.                "

TITLEPAGE_04
				dta "  Are you fucking kidding me? -   "
				dta "came the reply. You're the one and"
				dta "only priest in our diocese. Please"
				dta "defecate as quickly as possible   "
				dta "and get your ass here. I will take"
				dta "care about the wild crowd of fol- "
				dta "lowers until your arrival.        "
				dta "  Whether he liked it or not, John"
				dta "promptly cored out his intestine  "
				dta "and went to perform the ritual.   "
				
TITLEPAGE_05
				dta "  However, the constant, burning  "
				dta "pain in the ass and the vision of "
				dta "brown smudge at the bottom of the "
				dta "toiled made him devoted to solve  "
				dta "the vocations crisis that bothers "
				dta "church for many years now.        "
				dta "  He spent about 200 years study- "
				dta "ing ancient manuscripts, meditat- "
				dta "ing in the ominous woods and eat- "
				dta "ing poisonous mushrooms. That     "

TITLEPAGE_06
				dta "helped him to clear his mind and  "
				dta "find the solution. Finally he knew"
				dta "how to attract entire legions of  "
				dta "young men to join the seminary.   "
				dta "The trick is to obtain the Divine "
				dta "Serum and squirt it over the en-  "
				dta "tire planet.                      "
				dta "  John McPuke knew that bishop    "
				dta "owns an intergalactic starship    "
				dta "dedicated to look through the     "
TITLEPAGE_07
				dta "neighbor constellations in order  "
				dta "to find some god. Therefore John  "
				dta "decided to pay him a visit, to-   "
				dta "gether with his favorite acolyte  "
				dta "and a bottle of vodka. That even- "
				dta "ing was misty and rainy, but John "
				dta "knew that some significant things "
				dta "will happen. Just before the clock"
				dta "struck midnight, first bottle was "
				dta "empty, and...                     "
TITLEPAGE_08
				dta "...everything got fucked up. No-  "
				dta "body remembers anything.          "
				dta "  Now, you need to assist John    "
				dta "McPuke with his severely difficult"
				dta "mission of battling the vocations "
				dta "crisis. A shit lot of people, in- "
				dta "cluding wrinkled grannies, count  "
				dta "on you. Every modern country needs"
				dta "courts, jurisdiction, military,   "
				dta "politicians and The Church!       "
TITLEPAGE_09
				dta "  Use joystick to move John       "
				dta "around. Left and right - easy.    "
				dta "Push the lever up to check what   "
				dta "items you gathered under the cas- "
				dta "sock so far. Penetrate each nook  "
				dta "and niche well. Should you find   "
				dta "something interesting, pull the   "
				dta "lever down to begin so-called ",b(2),"in-"
				dta "teraction with the environment",b(2),".  "
				dta "                                  "
TITLEPAGE_10
TITLEPAGE_LAST
				dta "  The game requires joystick with "
				dta "button, because button is used to "
				dta "jump.                             "
				dta "  At any moment you can save the  "
				dta "current state to disk by using    "
				dta b(2),"SELECT",b(2),". Such state could be     "
				dta "loaded back by using ",b(2),"OPTION",b(2),".    "
				dta "Bear in mind that this feature re-"
				dta "quires DOS to be present.         "
				dta "  GOOD LICK!                      "

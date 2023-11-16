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

DISCLAIMER_00	dta "              UWAGA!              ",b($9b)
DISCLAIMER_01	dta "G",b(76),b(79),"wnym bohaterem niniejszej gry  ",b($9b)
DISCLAIMER_02	dta "jest ksi",b(65),"dz, istnieje zatem ry-   ",b($9b)
DISCLAIMER_03	dta "zyko, ",b(90),"e Twoje ",b(2),"uczucia religijne",b(2),b($9b)
DISCLAIMER_04	dta "zostan",b(65)," naruszone.                ",b($9b)
DISCLAIMER_05	dta "Je",b(83),"li jeste",b(83)," zdecydowany zagra",b(67),",  ",b($9b)
DISCLAIMER_06	dta "wci",b(83),"nij przycisk joysticka na w",b(76),"a-",b($9b)
DISCLAIMER_07	dta "sn",b(65)," odpowiedzialno",b(83),b(67),".             ",b($9b)
DISCLAIMER_08	dta "Je",b(83),"li masz w",b(65),"tpliwo",b(83),"ci, wy",b(76),b(65),"cz    ",b($9b)
DISCLAIMER_09	dta "komputer i zajmij si",b(69)," czym",b(83)," innym.",b($9b)
TITLEPAGE_00
				dta "                                  "
				dta "      DUSZPASTERZ JAN RZYGO",b(77),"      "
				dta " gra przygodowo-logiczno-skacz",b(65),"ca "
				dta "                                  "
				dta "Mgr in",b(90),". Rafa",b(76),"'s  Advanced Virtual"
				dta "  Computer Entertainment Studios  "
				dta "                                  "
				dta "u",b(90),"yj d",b(90),"ojstika aby zmienia",b(67)," strony"
				dta "                                  "
				dta "                    v1.2 - 01.2016"
TITLEPAGE_01
				dta "  Ciasna plebania, Dom Zakonny    "
				dta "Ksi",b(69),b(90),"y Werbist",b(79),"w, Bar Mleczny     "
				dta b(2),"Syta Elwira",b(2)," i miejscowy sklep   "
				dta "monopolowy to by",b(76),"o ca",b(76),"e jego ",b(90),"y-  "
				dta "cie. Jan Rzygo",b(78)," nie by",b(76)," osob",b(65)," am- "
				dta "bitn",b(65)," - by",b(76)," maksymalnie nudny i   "
				dta "odtw",b(79),"rczy. Wi",b(69),"kszo",b(83),b(67)," swojego ",b(90),"ycia"
				dta "sp",b(69),"dza",b(76)," na nawracaniu owieczek na "
				dta "jedynie s",b(76),"uszn",b(65)," w jego za",b(83),"cianko- "
				dta "wej ojczy",b(75),"nie wiar",b(69)," katolick",b(65),".    "

TITLEPAGE_02
				dta "  Radowa",b(76)," si",b(69)," bardzo i dr",b(90),"a",b(76)," ze   "
				dta "szcz",b(69),b(83),"cia gdy zauwa",b(90),"a",b(76),", ",b(90),"e jego   "
				dta "kazania przyci",b(65),"gaj",b(65)," do ko",b(83),"cio",b(76),"a   "
				dta "coraz wi",b(69),"cej ludzi. Nawy boczne   "
				dta "p",b(69),"ka",b(76),"y w szwach, biskup nie nad",b(65),"- "
				dta b(90),"a",b(76)," z produkcj",b(65)," wody ",b(83),"wi",b(69),"conej, a "
				dta "pch",b(76),"y w przepoconym t",b(76),"umie mno",b(90),"y",b(76),"y"
				dta "si",b(69)," jak szalone.                  "
				dta "  Pewnego niedzielnego poranka Jan"
				dta "szykowa",b(76)," si",b(69)," do odprawienia sumy. "
				
TITLEPAGE_03
				dta "Niestety co",b(83)," mu w trzewiach zabul-"
				dta "gota",b(76),"o i nagle zda",b(76)," sobie spraw",b(69),", "
				dta b(90),"e poranek zamiast przy o",b(76),"tarzu   "
				dta "sp",b(69),"dzi na klopie. Po pierwszym    "
				dta "ataku stolca zebra",b(76)," si",b(69)," w sobie i "
				dta "przedzwoni",b(76)," do infu",b(76),"ata z pro",b(83),"b",b(65)," o"
				dta "zast",b(69),"pstwo.                       "
				dta "  Czy",b(83)," Ty zdurnia",b(76),"? - us",b(76),"ysza",b(76)," w  "
				dta "s",b(76),"uchawce - Nie ma szans. Jeste",b(83),"  "
				dta "jedynym ksi",b(69),"dzem w naszym woje-   "

TITLEPAGE_04
				dta "w",b(79),"dztwie. Prosz",b(69),", aby",b(83)," defekowa",b(76)," w"
				dta "miar",b(69)," sprawnie i nast",b(69),"pnie przyby",b(76)
				dta "szybko do ko",b(83),"cio",b(76),"a. Ja jako",b(83)," do   "
				dta "Twojego przyj",b(83),"cia postaram si",b(69),"    "
				dta "uspokoi",b(67)," dziki t",b(76),"um wyznawc",b(79),"w.    "
				dta "  Rad nierad, Jan udro",b(90),"ni",b(76)," jelito,"
				dta "spu",b(83),"ci",b(76)," wod",b(69),", chrz",b(65),"kn",b(65),b(76)," i pop",b(69),"dzi",b(76)
				dta "odprawia",b(67)," nabo",b(90),"e",b(78),"stwo. Piek",b(65),"cy b",b(79),"l"
				dta "zlokalizowany mi",b(69),"dzy po",b(83),"ladkami   "
				dta "oraz wci",b(65),b(90)," wyra",b(75),"nie wyryty w pa-  "
				
TITLEPAGE_05
				dta "mi",b(69),"ci obraz br",b(65),"zowych smug na dnie"
				dta "muszli klozetowej spowodowa",b(76),"y, ",b(90),"e "
				dta "postanowi",b(76)," reszt",b(69)," ",b(90),"ycia po",b(83),"wi",b(69),"ci",b(67)," "
				dta "na uporanie si",b(69)," z kryzysem powo-  "
				dta b(76),"a",b(78),", kt",b(79),"ry od wielu lat niszczy   "
				dta "Ko",b(83),"ci",b(79),b(76)," Katolicki.                "
				dta "  D",b(76),"ugo studiowa",b(76)," staro",b(90),"ytne manu-"
				dta "skrypty, medytowa",b(76)," w ost",b(69),"pach le- "
				dta b(83),"nych, jad",b(76)," truj",b(65),"ce grzyby i robi",b(76)
				dta "pompki. Po zaledwie dwustu latach "

TITLEPAGE_06
				dta "w samotno",b(83),"ci ju",b(90)," wiedzia",b(76)," jak wy- "
				dta "hodowa",b(67)," ca",b(76),"e pokolenia m",b(69),b(90),"czyzn,  "
				dta "kt",b(79),"rzy ch",b(69),"tnie wst",b(65),"pi",b(65)," do Semina- "
				dta "rium. Jedyne co trzeba zrobi",b(67),", to "
				dta "pozyska",b(67)," SOK STWORZYCIELA i z wy- "
				dta "sokiej orbity spryska",b(67)," nim ca",b(76),b(65),"   "
				dta "planet",b(69),".                          "
				dta "  Wiedzia",b(76),", ",b(90),"e infu",b(76),"at dysponuje  "
				dta "odpowiednim pojazdem kosmicznym,  "
				dta "kt",b(79),"rego u",b(90),"ywa do szukania Boga je-"
TITLEPAGE_07
				dta "dynego. Kupi",b(76)," wi",b(69),"c flaszk",b(69)," i uda",b(76)," "
				dta "si",b(69)," do niego w odwiedziny, zabie- "
				dta "raj",b(65),"c po drodze swojego ulubionego"
				dta "ministranta, aby pom",b(79),"g",b(76)," w negocja-"
				dta "cjach. O godz. 19:00 wypito pierw-"
				dta "szego grzdyla i...                "
				dta "                                  "
				dta "                                  "
				dta "                                  "
				dta "                                  "
TITLEPAGE_08
				dta "  I chuj. Nikt nic nie pami",b(69),"ta.   "
				dta "Teraz Ty musisz pom",b(79),"c dzielnemu   "
				dta "Janowi Rzygoniowi w neandertalsko "
				dta "wr",b(69),"cz trudnej misji za",b(90),"egnania    "
				dta "kryzysu powo",b(76),"a",b(78),"! Licz",b(65)," na Ciebie  "
				dta "ca",b(76),"e zast",b(69),"py bab",b(67),", kt",b(79),"re boj",b(65)," si",b(69),","
				dta b(90),"e nied",b(76),"ugo nie b",b(69),"dzie ju",b(90)," komu   "
				dta "odda",b(67)," swojej emerytury. Nowoczesne"
				dta "pa",b(78),"stwo nie poradzi sobie bez s",b(65),"- "
				dta "d",b(79),"w, wojska i Ko",b(83),"cio",b(76),"a!           "
TITLEPAGE_09
				dta "  Sterowanie Janem odbywa si",b(69)," za  "
				dta "pomoc",b(65)," d",b(90),"ojstika. Raz lewo, raz   "
				dta "prawo - wiadomo. Poci",b(65),"gnij d",b(90),"oja w"
				dta "g",b(79),"r",b(69)," aby sprawdzi",b(67)," co uda",b(76),"o si",b(69),"   "
				dta "zgromadzi",b(67)," w sutannie. Dobrze pe- "
				dta "netruj ka",b(90),"dy zak",b(65),"tek, a jak zoba- "
				dta "czysz co",b(83)," wa",b(90),"nego, to poci",b(65),"gnij   "
				dta "d",b(90),"oja w d",b(79),b(76),", aby wej",b(83),b(67)," w tzw. in- "
				dta "terakcj",b(69)," z otoczeniem.            "
				dta "                                  "
TITLEPAGE_10
TITLEPAGE_LAST
				dta "  Gra wymaga d",b(90),"ojstika wyposa",b(90),"o-  "
				dta "nego w guzik, bo guzikiem si",b(69)," ska-"
				dta "cze.                              "
				dta "  W ka",b(90),"dej chwili mo",b(90),"esz zapisa",b(67),"  "
				dta "stan gry wciskaj",b(65),"c klawisz ",b(2),"SE-   "
				dta "LECT",b(2),". Taki zapisany stan mo",b(90),"esz  "
				dta "potem odczyta",b(67)," za pomoc",b(65)," ",b(2),"OPTION",b(2),"."
				dta "Potrzebny jest tylko jaki",b(83)," DOS.   "
				dta "                                  "
				dta "  Powzwodzenia!                   "

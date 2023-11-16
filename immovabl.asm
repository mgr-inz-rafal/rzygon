;	@com.wudsn.ide.asm.mainsourcefile=main.asm

; Procedures that are used by logic DLLs.
; Therefore their addresses cannot change.
; WARNING: Modifying this file requires rebuilding of all logic DLLs!

; Store the target vector for the action
; handling routine.
; It is set up in the process_logic_MXXX routines
; and called-back from within the game.
.var act_on_action_vector .word
.var current_action_menu_item .byte

; Used to iterate temporary loops
.zpvar tmp_loop_iterator .byte

; How much should delay delay
.var	to_be_delayed	.byte

; Represents the game state
.var	game_state 		game

; Used for comparing maps
.var 	part2 .word

.var			item1_tmp_pos		.byte

; Indicates the position of the hanging skull that
; should trigger the adventure menu
.var	hanging_skull_pos .byte

.var	cipsko				.byte

;	ITEM_X_DATA has the following structure
;		byte   0				= UNUSED
;		bytes  1 to 20			= item name
;		bytes 21 to 25			= item ID 
ITEM_1_DATA
				dta b(0)
				dta b(0),b(0),b(0),b(0),b(0)
				dta b(0),b(0),b(0),b(0),b(0)
				dta b(0),b(0),b(0),b(0),b(0)
				dta b(0),b(0),b(0),b(0),b(0)
ITEM_1_ID
				dta b(0),b(0),b(0),b(0),b(0) ; Offset = 21
ITEM_DATA_LEN	equ *-ITEM_1_DATA
ITEM_2_DATA
				dta b(0)
				dta b(0),b(0),b(0),b(0),b(0)
				dta b(0),b(0),b(0),b(0),b(0)
				dta b(0),b(0),b(0),b(0),b(0)
				dta b(0),b(0),b(0),b(0),b(0)
ITEM_2_ID
				dta b(0),b(0),b(0),b(0),b(0)
ITEM_3_DATA
				dta b(0)
				dta b(0),b(0),b(0),b(0),b(0)
				dta b(0),b(0),b(0),b(0),b(0)
				dta b(0),b(0),b(0),b(0),b(0)
				dta b(0),b(0),b(0),b(0),b(0)
ITEM_3_ID
				dta b(0),b(0),b(0),b(0),b(0)
ITEM_4_DATA
				dta b(0)
				dta b(0),b(0),b(0),b(0),b(0)
				dta b(0),b(0),b(0),b(0),b(0)
				dta b(0),b(0),b(0),b(0),b(0)
				dta b(0),b(0),b(0),b(0),b(0)
ITEM_4_ID
				dta b(0),b(0),b(0),b(0),b(0)
								
ITEM_CONTACT	; ID od the item being in contact with main hero followed by the sprite number
				dta b(0),b(0),b(0),b(0),b(0)
ITEM_CONTACT_S	dta b(0)
							
; Slots for action menu items
ACTION_MENU_SLOT_1
				dta d"          ",b($9b)
ACTION_MENU_SLOT_2
				dta d"          ",b($9b)
ACTION_MENU_SLOT_3
				dta d"          ",b($9b)
ACTION_MENU_SLOT_4
				dta d"Lekcewa",b(90),b($9b)

				
; Hero data
.var hero_state hero
; ORIGINAL
.var hero_XPos .byte
.var hero_YPos .byte
;.var hero_XPos=$5c .byte
;.var hero_YPos=$8e .byte
; DEBUG
;.var hero_XPos=$c6 .byte
;.var hero_YPos=$78 .byte

; Specifies which action item is currently active
; IDs to be found in strings.asm
.var	current_action			.word

; Action strings
ACT_EMPTY		equ STR_CLEAR
ACT_EXPLORE		dta d"Zbadaj",b($9b)
ACT_MOVE		dta d"Przesu",b(78),b($9b)
ACT_OPEN		dta d"Otw",b(79),"rz",b($9b)
ACT_USE			dta d"U",b(90),"yj",b($9b)
ACT_BITE		dta d"Przegry",b(75),b($9b)
ACT_SQUEEZE		dta d"Id",b(75)," dziur",b(65),b($9b)
ACT_ACTIVATE	dta d"Aktywuj",b($9b)
ACT_FLUSH		dta d"Spu",b(83),b(67)," si",b(69),b($9b)
ACT_SNIFF		dta d"W",b(65),"chaj",b($9b)
ACT_DROP		dta d"Wrzu",b(67),b($9b)
ACT_HAVECRAP	dta d"Sraj do",b($9b)
ACT_TALK		dta d"Zagadaj",b($9b)
ACT_GIVE		dta d"Daj",b($9b)
ACT_PLUG		dta d"Zaklej",b($9b)
ACT_OPERATE		dta d"Operuj",b($9b)
ACT_CHOP		dta d"Odr",b(65),"b nog",b(69),b($9b)
ACT_CLEANUP		dta d"Drap kup",b(69),b($9b)
ACT_INSERT		dta d"Wsad",b(75),b($9b)
ACT_ENTER		dta d"Przekrocz",b($9b)
ACT_ROTATE		dta d"Przekr",b(69),b(67),b($9b)
ACT_LICK		dta d"Poli",b(90),b($9b)
ACT_UNJAM		dta d"Odklinuj",b($9b)
ACT_READ		dta d"Przeczytaj",b($9b)
ACT_PENETRATE	dta d"Penetruj",b($9b)
ACT_TYPE		dta d"Wpisz",b($9b)
ACT_KNOCK		dta d"Zapukaj",b($9b)
ACT_PROFANE		dta d"Sprofanuj",b($9b)
ACT_PLACE		dta d"Postaw",b($9b)
ACT_TICKLE		dta d"Gilaj",b($9b)
ACT_SCRATCH		dta d"Drap",b($9b)
ACT_LUBRICATE	dta d"Smaruj",b($9b)
ACT_EXPLODE		dta d"Wysad",b(75),b($9b)
ACT_RAPE		dta d"Wyruchaj",b($9b)
ACT_PRAY		dta d"M",b(79),"dl si",b(69),b($9b)
ACT_CARVE		dta d"Wydr",b(65),b(90),b($9b)	
ACT_SPILL		dta d"Oblej",b($9b)	
ACT_BLOW		dta d"Obci",b(65),"gnij",b($9b)	
ACT_PUFF		dta d"Chuchnij",b($9b)
ACT_SMASH		dta d"Rozbij co",b(83),b($9b)
ACT_PUSH		dta d"Popchnij",b($9b)
ACT_FEED		dta d"Nakarm",b($9b)
ACT_HARASS		dta	d"Molestuj",b($9b)
ACT_START		dta	d"Odpalaj",b($9b)
ACT_GATHER_DNA	dta d"Zassaj DNA",b($9b)
ACT_POWERUP		dta d"Zasil",b($9b)
ACT_SAW			dta d"Pi",b(76),"uj",b($9b)
ACT_TOSS		dta d"Wrzu",b(67),b($9b)
ACT_CRUSH		dta d"Mia",b(90),"d",b(90),b($9b)
ACT_CUT			dta d"Obetnij",b($9b)
ACT_PEE			dta d"Oszczaj",b($9b)
ACT_PEE1		dta d"Nasikaj",b($9b)
ACT_GATHER		dta d"Pobierz",b($9b)
ACT_RECITE		dta d"Deklamuj",b($9b)

; Strings representing action objects
A_M0003_001		dta d"Prycza",b($9b)					\ A_M0003_001_ID	equ 1
A_M0003_002		dta d"Drewniane drzwi",b($9b)			\ A_M0003_002_ID	equ 2
A_M0003_003		dta d"Druciana krata",b($9b)			\ A_M0003_003_ID	equ 3
A_M0003_004		dta d"Wajcha",b($9b)					\ A_M0003_004_ID	equ 4
A_M0003_005		dta d"Sp",b(76),"uczka",b($9b)			\ A_M0003_005_ID	equ 5
A_M0003_006		dta d"Kibel",b($9b)						\ A_M0003_006_ID	equ 6
A_M0003_007		dta d"Krucha czaszka",b($9b)			\ A_M0003_007_ID	equ 7
A_M0003_008		dta d"Podgrzewacz",b($9b)				\ A_M0003_008_ID	equ 8
A_M0003_009		dta d"R",b(79),"j much",b($9b)			\ A_M0003_009_ID	equ 9
A_M0003_010		dta d"Szczelina",b($9b)					\ A_M0003_010_ID	equ 10
A_M0003_011		dta d"Zapora",b($9b)					\ A_M0003_011_ID	equ 11
A_M0003_012		dta d"Straszyd",b(76),"o",b($9b)		\ A_M0003_012_ID	equ 12
A_M0003_013		dta d"Krata",b($9b)						\ A_M0003_013_ID	equ 13
A_M0003_014		dta d"Drzwi do zakrystii",b($9b)		\ A_M0003_014_ID	equ 14
A_M0003_015		dta d"P",b(69),"kni",b(69),"ta rura",b($9b)	\ A_M0003_015_ID	equ 15
A_M0003_016		dta d"Nowoczesne drzwi",b($9b)			\ A_M0003_016_ID	equ 16
A_M0003_017		dta d"Pan Zwami",b($9b)					\ A_M0003_017_ID	equ 17
A_M0003_018		dta d"Kurczak mutant",b($9b)			\ A_M0003_018_ID	equ 18
A_M0003_019		dta d"P",b(76),"aski kurczak",b($9b)	\ A_M0003_019_ID	equ 19
A_M0003_020		dta d"Umrzyk",b($9b)					\ A_M0003_020_ID	equ 20
A_M0003_021		dta d"Nagrobek",b($9b)					\ A_M0003_021_ID	equ 21
A_M0003_022		dta d"Zawa",b(76),b($9b)				\ A_M0003_022_ID	equ 22
A_M0003_023		dta d"Zag",b(79),"wniony nagrobek",b($9b) \ A_M0003_023_ID	equ 23
A_M0003_024		dta d"Dupa glisty",b($9b) 				\ A_M0003_024_ID	equ 24
A_M0003_025		dta d"Szczur serojad",b($9b) 			\ A_M0003_025_ID	equ 25
A_M0003_026		dta d"Obelisk",b($9b) 					\ A_M0003_026_ID	equ 26
A_M0003_027		dta d"Kolumna",b($9b) 					\ A_M0003_027_ID	equ 27
A_M0003_028		dta d"T",b(69),"gi chwast",b($9b) 		\ A_M0003_028_ID	equ 28
A_M0003_029		dta d"Znicz nap",b(69),"dowy",b($9b)	\ A_M0003_029_ID	equ 29
A_M0003_030		dta d"Smardz",b($9b)					\ A_M0003_030_ID	equ 30
A_M0003_031		dta d"Kundel",b($9b)					\ A_M0003_031_ID	equ 31
A_M0003_032		dta d"Ci",b(69),b(90),"ki g",b(76),"az",b($9b) \ A_M0003_032_ID	equ 32
A_M0003_033		dta d"Przycisk no",b(90),"ny",b($9b)	\ A_M0003_033_ID	equ 33
A_M0003_034		dta d"Mocarna bariera",b($9b)			\ A_M0003_034_ID	equ 34
A_M0003_035		dta d"Wrota piekie",b(76),b($9b)		\ A_M0003_035_ID	equ 35
A_M0003_036		dta d"Wisz",b(65),"ca czaszka",b($9b)	\ A_M0003_036_ID	equ 36
A_M0003_037		dta d"Zaw",b(79),"r",b($9b)				\ A_M0003_037_ID	equ 37
A_M0003_038		dta d"Guzik",b($9b)						\ A_M0003_038_ID	equ 38
A_M0003_039		dta d"Notatka",b($9b)					\ A_M0003_039_ID	equ 39
A_M0003_040		dta d"Z",b(76),"owieszcze drzwi",b($9b)	\ A_M0003_040_ID	equ 40
A_M0003_041		dta d"Drzwi do Biesa",b($9b)			\ A_M0003_041_ID	equ 41
A_M0003_042		dta d"Wrota krypty",b($9b)				\ A_M0003_042_ID	equ 42
A_M0003_043		dta d"Mechaniczna blokada",b($9b)		\ A_M0003_043_ID	equ 43
A_M0003_044		dta d"Nora",b($9b)						\ A_M0003_044_ID	equ 44
A_M0003_045		dta d"Po",b(76),"amane drzwiczki",b($9b) \ A_M0003_045_ID	equ 45
A_M0003_046		dta d"Klawiaturka",b($9b) 				\ A_M0003_046_ID	equ 46
A_M0003_047		dta d"Plakietka",b($9b) 				\ A_M0003_047_ID	equ 47
A_M0003_048		dta d"Pusty o",b(76),"tarz",b($9b) 		\ A_M0003_048_ID	equ 48
A_M0003_049		dta d"Sopelek",b($9b) 					\ A_M0003_049_ID	equ 49
A_M0003_050		dta d"Zombik",b($9b) 					\ A_M0003_050_ID	equ 50
A_M0003_051		dta d"Pijaczyna",b($9b) 				\ A_M0003_051_ID	equ 51
A_M0003_052		dta d"Kufel piwa",b($9b)				\ A_M0003_052_ID	equ 52
A_M0003_053		dta d"Gr",b(79),"b Nierz",b(65),"dnicy",b($9b) \ A_M0003_053_ID	equ 53
A_M0003_054		dta d"Kupa kupy",b($9b) 				\ A_M0003_054_ID	equ 54
A_M0003_055		dta d"Dupa trupa",b($9b) 				\ A_M0003_055_ID	equ 55
A_M0003_056		dta d"Stopy trupa",b($9b) 				\ A_M0003_056_ID	equ 56
A_M0003_057		dta d"Dziura z gwintem",b($9b) 			\ A_M0003_057_ID	equ 57
A_M0003_058		dta d"Stalowe drzwi",b($9b) 			\ A_M0003_058_ID	equ 58
A_M0003_059		dta d"Srogie pud",b(76),"o",b($9b) 		\ A_M0003_059_ID	equ 59
A_M0003_060		dta d"Murek",b($9b) 					\ A_M0003_060_ID	equ 60
A_M0003_061		dta d"Janusz",b($9b) 					\ A_M0003_061_ID	equ 61
A_M0003_062		dta d"Katolickie drzwi",b($9b)			\ A_M0003_062_ID	equ 62
A_M0003_063		dta d"Wied",b(75),"min",b($9b)			\ A_M0003_063_ID	equ 63
A_M0003_064		dta d"Pokraka",b($9b)					\ A_M0003_064_ID	equ 64
A_M0003_065		dta d"Plugawy Gad",b($9b)				\ A_M0003_065_ID	equ 65
A_M0003_066		dta d"Kutas",b($9b)						\ A_M0003_066_ID	equ 66
A_M0003_067		dta d"Gruby Paladyn",b($9b)				\ A_M0003_067_ID	equ 67
A_M0003_068		dta d"Spi",b(90),"owa mogi",b(76),"a",b($9b) \ A_M0003_068_ID	equ 68
A_M0003_069		dta d"Dekiel z cyny",b($9b) 			\ A_M0003_069_ID	equ 69
A_M0003_070		dta d"Sejf apteczny",b($9b) 			\ A_M0003_070_ID	equ 70
A_M0003_071		dta b(88),d"abka",b($9b) 				\ A_M0003_071_ID	equ 71
A_M0003_072		dta d"Salaterka",b($9b) 				\ A_M0003_072_ID	equ 72
A_M0003_073		dta b(88),d"abi zgniotek",b($9b)		\ A_M0003_073_ID	equ 73
A_M0003_074		dta "Niestabilna trumna",b($9b)			\ A_M0003_074_ID	equ 74
A_M0003_075		dta "Z",b(76),"y Ptaszek",b($9b)		\ A_M0003_075_ID	equ 75
A_M0003_076		dta "Baba Wanga",b($9b)					\ A_M0003_076_ID	equ 76
A_M0003_077		dta "O",b(76),"tarzyk",b($9b)			\ A_M0003_077_ID	equ 77
A_M0003_078		dta b(68),"limaczek",b($9b)				\ A_M0003_078_ID	equ 78
A_M0003_079		dta "Panel sterowania",b($9b)			\ A_M0003_079_ID	equ 79
A_M0003_080		dta "Barchanowy fotel",b($9b)			\ A_M0003_080_ID	equ 80
A_M0003_081		dta b(88),"ona ordynatora",b($9b)		\ A_M0003_081_ID	equ 81
A_M0003_082		dta "Panel pompy",b($9b)				\ A_M0003_082_ID	equ 82
A_M0003_083		dta "D",b(69),"bowa k",b(76),"oda",b($9b)	\ A_M0003_083_ID	equ 83
A_M0003_084		dta "Mo",b(75),"dzie",b(90),b($9b)		\ A_M0003_084_ID	equ 84
A_M0003_085		dta "Drakul",b($9b)						\ A_M0003_085_ID	equ 85
A_M0003_086		dta "Aspersorium",b($9b)				\ A_M0003_086_ID	equ 86
A_M0003_087		dta "Z",b(76),"a wiadomo",b(83),b(67),b($9b) \ A_M0003_087_ID	equ 87
A_M0003_088		dta "Kruchy sufit",b($9b) 				\ A_M0003_088_ID	equ 88
A_M0003_089		dta "Betonowy szalunek",b($9b) 			\ A_M0003_089_ID	equ 89

; Definition of the messages
STATUSMSG_000	dta b($30),b($30),b($30)
STATUSMSG_001	dta b($30),b($30),b($31)
STATUSMSG_002	dta b($30),b($30),b($32)
STATUSMSG_003	dta b($30),b($30),b($33)
STATUSMSG_004	dta b($30),b($30),b($34)
STATUSMSG_005	dta b($30),b($30),b($35)
STATUSMSG_006	dta b($30),b($30),b($36)
STATUSMSG_007	dta b($30),b($30),b($37)
STATUSMSG_008	dta b($30),b($30),b($38)
STATUSMSG_009	dta b($30),b($30),b($39)
STATUSMSG_010	dta b($30),b($31),b($30)
STATUSMSG_011	dta b($30),b($31),b($31)
STATUSMSG_012	dta b($30),b($31),b($32)
STATUSMSG_013	dta b($30),b($31),b($33)
STATUSMSG_014	dta b($30),b($31),b($34)
STATUSMSG_015	dta b($30),b($31),b($35)
STATUSMSG_016	dta b($30),b($31),b($36)
STATUSMSG_017	dta b($30),b($31),b($37)
STATUSMSG_018	dta b($30),b($31),b($38)
STATUSMSG_019	dta b($30),b($31),b($39)
STATUSMSG_020	dta b($30),b($32),b($30)
STATUSMSG_021	dta b($30),b($32),b($31)
STATUSMSG_022	dta b($30),b($32),b($32)
STATUSMSG_023	dta b($30),b($32),b($33)
STATUSMSG_024	dta b($30),b($32),b($34)
STATUSMSG_025	dta b($30),b($32),b($35)
STATUSMSG_026	dta b($30),b($32),b($36)
STATUSMSG_027	dta b($30),b($32),b($37)
STATUSMSG_028	dta b($30),b($32),b($38)
ADVMSG_029		dta b($30),b($32),b($39)
STATUSMSG_030	dta b($30),b($33),b($30)
STATUSMSG_031	dta b($30),b($33),b($31)
STATUSMSG_032	dta b($30),b($33),b($32)
STATUSMSG_033	dta b($30),b($33),b($33)
STATUSMSG_034	dta b($30),b($33),b($34)
ADVMSG_035		dta b($30),b($33),b($35)
ADVMSG_036		dta b($30),b($33),b($36)
STATUSMSG_037	dta b($30),b($33),b($37)
STATUSMSG_038	dta b($30),b($33),b($38)
STATUSMSG_039	dta b($30),b($33),b($39)
STATUSMSG_040	dta b($30),b($34),b($30)
ADVMSG_041		dta b($30),b($34),b($31)
STATUSMSG_042	dta b($30),b($34),b($32)
ADVMSG_043		dta b($30),b($34),b($33)
STATUSMSG_044	dta b($30),b($34),b($34)
STATUSMSG_045	dta b($30),b($34),b($35)
STATUSMSG_046	dta b($30),b($34),b($36)
STATUSMSG_047	dta b($30),b($34),b($37)
STATUSMSG_048	dta b($30),b($34),b($38)
STATUSMSG_049	dta b($30),b($34),b($39)
ADVMSG_050		dta b($30),b($35),b($30)
STATUSMSG_051	dta b($30),b($35),b($31)
STATUSMSG_052	dta b($30),b($35),b($32)
STATUSMSG_053	dta b($30),b($35),b($33)
STATUSMSG_054	dta b($30),b($35),b($34)
STATUSMSG_055	dta b($30),b($35),b($35)
STATUSMSG_056	dta b($30),b($35),b($36)
STATUSMSG_057	dta b($30),b($35),b($37)
STATUSMSG_058	dta b($30),b($35),b($38)
STATUSMSG_059	dta b($30),b($35),b($39)
STATUSMSG_060	dta b($30),b($36),b($30)
STATUSMSG_061	dta b($30),b($36),b($31)
STATUSMSG_062	dta b($30),b($36),b($32)
ADVMSG_063		dta b($30),b($36),b($33)
STATUSMSG_064	dta b($30),b($36),b($34)
STATUSMSG_065	dta b($30),b($36),b($35)
STATUSMSG_066	dta b($30),b($36),b($36)
STATUSMSG_067	dta b($30),b($36),b($37)
STATUSMSG_068	dta b($30),b($36),b($38)
STATUSMSG_069	dta b($30),b($36),b($39)
STATUSMSG_070	dta b($30),b($37),b($30)
STATUSMSG_071	dta b($30),b($37),b($31)
STATUSMSG_072	dta b($30),b($37),b($32)
STATUSMSG_073	dta b($30),b($37),b($33)
STATUSMSG_074	dta b($30),b($37),b($34)
STATUSMSG_075	dta b($30),b($37),b($35)
STATUSMSG_076	dta b($30),b($37),b($36)
STATUSMSG_077	dta b($30),b($37),b($37)
STATUSMSG_078	dta b($30),b($37),b($38)
STATUSMSG_079	dta b($30),b($37),b($39)
STATUSMSG_080	dta b($30),b($38),b($30)
STATUSMSG_081	dta b($30),b($38),b($31)
STATUSMSG_082	dta b($30),b($38),b($32)
STATUSMSG_083	dta b($30),b($38),b($33)
STATUSMSG_084	dta b($30),b($38),b($34)
STATUSMSG_085	dta b($30),b($38),b($35)
STATUSMSG_086	dta b($30),b($38),b($36)
STATUSMSG_087	dta b($30),b($38),b($37)
STATUSMSG_088	dta b($30),b($38),b($38)
STATUSMSG_089	dta b($30),b($38),b($39)
STATUSMSG_090	dta b($30),b($39),b($30)
STATUSMSG_091	dta b($30),b($39),b($31)
STATUSMSG_092	dta b($30),b($39),b($32)
STATUSMSG_093	dta b($30),b($39),b($33)
STATUSMSG_094	dta b($30),b($39),b($34)
STATUSMSG_095	dta b($30),b($39),b($35)
STATUSMSG_096	dta b($30),b($39),b($36)
ADVMSG_097		dta b($30),b($39),b($37)
STATUSMSG_098	dta b($30),b($39),b($38)
STATUSMSG_099	dta b($30),b($39),b($39)
STATUSMSG_100	dta b($31),b($30),b($30)
STATUSMSG_101	dta b($31),b($30),b($31)
STATUSMSG_102	dta b($31),b($30),b($32)
STATUSMSG_103	dta b($31),b($30),b($33)
STATUSMSG_104	dta b($31),b($30),b($34)
STATUSMSG_105	dta b($31),b($30),b($35)
STATUSMSG_106	dta b($31),b($30),b($36)
STATUSMSG_107	dta b($31),b($30),b($37)
STATUSMSG_108	dta b($31),b($30),b($38)
STATUSMSG_109	dta b($31),b($30),b($39)
STATUSMSG_110	dta b($31),b($31),b($30)
STATUSMSG_111	dta b($31),b($31),b($31)
STATUSMSG_112	dta b($31),b($31),b($32)
STATUSMSG_113	dta b($31),b($31),b($33)
STATUSMSG_114	dta b($31),b($31),b($34)
STATUSMSG_115	dta b($31),b($31),b($35)
STATUSMSG_116	dta b($31),b($31),b($36)
STATUSMSG_117	dta b($31),b($31),b($37)
STATUSMSG_118	dta b($31),b($31),b($38)
STATUSMSG_119	dta b($31),b($31),b($39)
STATUSMSG_120	dta b($31),b($32),b($30)
ADVMSG_121		dta b($31),b($32),b($31)	; @Sonar
STATUSMSG_122	dta b($31),b($32),b($32)
STATUSMSG_123	dta b($31),b($32),b($33)
STATUSMSG_124	dta b($31),b($32),b($34)
STATUSMSG_125	dta b($31),b($32),b($35)
STATUSMSG_126	dta b($31),b($32),b($36)
ADVMSG_127		dta b($31),b($32),b($37)	; @Sonar
STATUSMSG_128	dta b($31),b($32),b($38)
STATUSMSG_129	dta b($31),b($32),b($39)
STATUSMSG_130	dta b($31),b($33),b($30)
STATUSMSG_131	dta b($31),b($33),b($31)
STATUSMSG_132	dta b($31),b($33),b($32)
STATUSMSG_133	dta b($31),b($33),b($33)
STATUSMSG_134	dta b($31),b($33),b($34)
STATUSMSG_135	dta b($31),b($33),b($35)
STATUSMSG_136	dta b($31),b($33),b($36)
STATUSMSG_137	dta b($31),b($33),b($37)
STATUSMSG_138	dta b($31),b($33),b($38)
STATUSMSG_139	dta b($31),b($33),b($39)
STATUSMSG_140	dta b($31),b($34),b($30)
ADVMSG_141		dta b($31),b($34),b($31)
STATUSMSG_142	dta b($31),b($34),b($32)
STATUSMSG_143	dta b($31),b($34),b($33)
STATUSMSG_144	dta b($31),b($34),b($34)
STATUSMSG_145	dta b($31),b($34),b($35)
STATUSMSG_146	dta b($31),b($34),b($36)
STATUSMSG_147	dta b($31),b($34),b($37)
ADVMSG_148		dta b($31),b($34),b($38)
STATUSMSG_149	dta b($31),b($34),b($39)
STATUSMSG_150	dta b($31),b($35),b($30)
STATUSMSG_151	dta b($31),b($35),b($31)
STATUSMSG_152	dta b($31),b($35),b($32)
ADVMSG_153		dta b($31),b($35),b($33)
ADVMSG_154		dta b($31),b($35),b($34)
STATUSMSG_155	dta b($31),b($35),b($35)
ADVMSG_156		dta b($31),b($35),b($36)
STATUSMSG_157	dta b($31),b($35),b($37)
STATUSMSG_158	dta b($31),b($35),b($38)
STATUSMSG_159	dta b($31),b($35),b($39)
STATUSMSG_160	dta b($31),b($36),b($30)
STATUSMSG_161	dta b($31),b($36),b($31)
ADVMSG_162		dta b($31),b($36),b($32)
STATUSMSG_163	dta b($31),b($36),b($33)
STATUSMSG_164	dta b($31),b($36),b($34)
STATUSMSG_165	dta b($31),b($36),b($35)
STATUSMSG_166	dta b($31),b($36),b($36)
STATUSMSG_167	dta b($31),b($36),b($37)
STATUSMSG_168	dta b($31),b($36),b($38)
STATUSMSG_169	dta b($31),b($36),b($39)
STATUSMSG_170	dta b($31),b($37),b($30)
STATUSMSG_171	dta b($31),b($37),b($31)
STATUSMSG_172	dta b($31),b($37),b($32)
STATUSMSG_173	dta b($31),b($37),b($33)
STATUSMSG_174	dta b($31),b($37),b($34)
STATUSMSG_175	dta b($31),b($37),b($35)
STATUSMSG_176	dta b($31),b($37),b($36)
STATUSMSG_177	dta b($31),b($37),b($37)
STATUSMSG_178	dta b($31),b($37),b($38)
STATUSMSG_179	dta b($31),b($37),b($39)
STATUSMSG_180	dta b($31),b($38),b($30)
ADVMSG_181		dta b($31),b($38),b($31)
STATUSMSG_182	dta b($31),b($38),b($32)
ADVMSG_183		dta b($31),b($38),b($33)
STATUSMSG_184	dta b($31),b($38),b($34)
STATUSMSG_185	dta b($31),b($38),b($35)
ADVMSG_186		dta b($31),b($38),b($36)
STATUSMSG_187	dta b($31),b($38),b($37)
STATUSMSG_188	dta b($31),b($38),b($38)
STATUSMSG_189	dta b($31),b($38),b($39)
STATUSMSG_190	dta b($31),b($39),b($30)
STATUSMSG_191	dta b($31),b($39),b($31)
ADVMSG_192		dta b($31),b($39),b($32)
STATUSMSG_193	dta b($31),b($39),b($33)
STATUSMSG_194	dta b($31),b($39),b($34)
STATUSMSG_195	dta b($31),b($39),b($35)
STATUSMSG_196	dta b($31),b($39),b($36)
STATUSMSG_197	dta b($31),b($39),b($37)
STATUSMSG_198	dta b($31),b($39),b($38)
STATUSMSG_199	dta b($31),b($39),b($39)
STATUSMSG_200	dta b($32),b($30),b($30)
STATUSMSG_201	dta b($32),b($30),b($31)
STATUSMSG_202	dta b($32),b($30),b($32)
STATUSMSG_203	dta b($32),b($30),b($33)
ADVMSG_204		dta b($32),b($30),b($34)
STATUSMSG_205	dta b($32),b($30),b($35)
STATUSMSG_206	dta b($32),b($30),b($36)
STATUSMSG_207	dta b($32),b($30),b($37)
STATUSMSG_208	dta b($32),b($30),b($38)
STATUSMSG_209	dta b($32),b($30),b($39)
STATUSMSG_210	dta b($32),b($31),b($30)
STATUSMSG_211	dta b($32),b($31),b($31)
STATUSMSG_212	dta b($32),b($31),b($32)
STATUSMSG_213	dta b($32),b($31),b($33)
ADVMSG_214		dta b($32),b($31),b($34)
STATUSMSG_215	dta b($32),b($31),b($35)
STATUSMSG_216	dta b($32),b($31),b($36)
STATUSMSG_217	dta b($32),b($31),b($37)
STATUSMSG_218	dta b($32),b($31),b($38)
STATUSMSG_219	dta b($32),b($31),b($39)
STATUSMSG_220	dta b($32),b($32),b($30)
STATUSMSG_221	dta b($32),b($32),b($31)
STATUSMSG_222	dta b($32),b($32),b($32)
ADVMSG_223		dta b($32),b($32),b($33)
STATUSMSG_224	dta b($32),b($32),b($34)
STATUSMSG_225	dta b($32),b($32),b($35)
STATUSMSG_226	dta b($32),b($32),b($36)
ADVMSG_227		dta b($32),b($32),b($37)
STATUSMSG_228	dta b($32),b($32),b($38)
STATUSMSG_229	dta b($32),b($32),b($39)
STATUSMSG_230	dta b($32),b($33),b($30)
STATUSMSG_231	dta b($32),b($33),b($31)
STATUSMSG_232	dta b($32),b($33),b($32)
STATUSMSG_233	dta b($32),b($33),b($33)
STATUSMSG_234	dta b($32),b($33),b($34)
STATUSMSG_235	dta b($32),b($33),b($35)
STATUSMSG_236	dta b($32),b($33),b($36)
STATUSMSG_237	dta b($32),b($33),b($37)
STATUSMSG_238	dta b($32),b($33),b($38)
STATUSMSG_239	dta b($32),b($33),b($39)
ADVMSG_240		dta b($32),b($34),b($30)
STATUSMSG_241	dta b($32),b($34),b($31)
STATUSMSG_242	dta b($32),b($34),b($32)
STATUSMSG_243	dta b($32),b($34),b($33)
STATUSMSG_244	dta b($32),b($34),b($34)
STATUSMSG_245	dta b($32),b($34),b($35)
STATUSMSG_246	dta b($32),b($34),b($36)
STATUSMSG_247	dta b($32),b($34),b($37)
STATUSMSG_248	dta b($32),b($34),b($38)
STATUSMSG_249	dta b($32),b($34),b($39)
STATUSMSG_250	dta b($32),b($35),b($30)
STATUSMSG_251	dta b($32),b($35),b($31)
STATUSMSG_252	dta b($32),b($35),b($32)
STATUSMSG_253	dta b($32),b($35),b($33)

; Logic flags 000
.var logic_flags_000	.byte
LF_BED_MOVED			equ %00000001
LF_BORER_USED			equ %00000010
LF_SEWER_LEVER_OPE_USED	equ %00000100
LF_SEWER_MSG1			equ %00001000
LF_CISTERN_EMPTY		equ %00010000
LF_BIG_CISTERN_EMPTY	equ	%00100000
LF_SKULL_CRACKED		equ	%01000000
LF_BRAIN_FIRED			equ	%10000000
; Logic flags 001
.var logic_flags_001	.byte
LF_FLY_SWARM_EXPELLED	equ %00000001
LF_WAREHOUSE_OPENED		equ %00000010
LF_DEMON_BRIBED			equ %00000100
LF_SEWER_GRATE_REMOVED	equ %00001000
LF_VESTRY_OPENED		equ %00010000
LF_PIPE_SNOTTED			equ %00100000
LF_CHICKEN_KILLED		equ %01000000
LF_CHICKEN_LEG_TAKEN	equ %10000000
; Logic flags 002
.var logic_flags_002	.byte
LF_BOLTS_CROPPED		equ %00000001
LF_ROCKS_PICKAXED		equ %00000010
LF_TUNNELS_MSG1			equ %00000100
LF_GRAVE_CLEANED		equ %00001000
LF_BASCULE_BRIDGE_LOW	equ %00010000
LF_WORM_CLEANED			equ %00100000
LF_RAT_FED				equ %01000000
LF_WORM_PLUGGED			equ %10000000
; Logic flags 003
.var logic_flags_003	.byte
LF_OBELISK_MOVED		equ %00000001
LF_COLUMN_REMOVED		equ %00000010
LF_WEED_REMOVED			equ %00000100
LF_DROPS_GIVEN			equ %00001000
LF_RZYGON_DEAD			equ %00010000
LF_DOG_TRAILS_SHOWN		equ %00100000
LF_HARD_ROCK_MOVED		equ %01000000
LF_RETURN_FROM_HELL_MSG	equ %10000000
; Logic flags 004
.var logic_flags_004	.byte
LF_GRAVEUNDER_OPENED	equ %00000001
LF_HELLGATE_DISAPPEARED	equ %00000010
LF_VALVE_LICKED			equ %00000100
LF_VALVE1_ROTATED		equ %00001000
LF_VALVE2_UNJAMMED		equ %00010000
LF_VALVE2_ROTATED		equ %00100000
LF_BUTTON_PRESSED		equ %01000000
LF_HELL_WEED_REMOVED	equ %10000000
; Logic flags 005
.var logic_flags_005	.byte
LF_HELL_DEMON_PISSING	equ %00000001
LF_HELL_DOOR_OPENED		equ %00000010
LF_DEVIL_DOOR_OPENED	equ %00000100
LF_ZUG_MSG_DISPLAYED	equ %00001000
LF_HLEJNIA_PLAYING		equ %00010000
LF_HOSPITAL_OPENED		equ %00100000
LF_GRAIL_GIVEN			equ %01000000
LF_ZOMBIE_HAS_BRAIN		equ %10000000
; Logic flags 006
.var logic_flags_006	.byte
LF_ICICLE_MELTED		equ %00000001
LF_BEER_FOAMED			equ %00000010
LF_GRAVE_LOWERED		equ %00000100
LF_SHIT_CLEARED			equ %00001000
LF_CRYPT_OPENED			equ %00010000
LF_SUPPOSITORY			equ %00100000
LF_EMMENTALER			equ %01000000
LF_STEEL_DOOR_OPENED	equ %10000000
; Logic flags 007
.var logic_flags_007	.byte
LF_CRATE_OILED			equ %00000001
LF_CRATE_MOVED			equ %00000010
LF_1ST_WALL_BLOWN		equ %00000100
LF_2ND_WALL_BLOWN		equ %00001000
LF_HERO_MSG_SHOWN		equ %00010000
LF_PRAYER_SPEAKED		equ %00100000
LF_WITCHER_HANDLED		equ %01000000
LF_SWORD_MENTIONED		equ %10000000
; Logic flags 008
.var logic_flags_008	.byte
LF_BEAST_CARVED			equ %00000001
LF_KUTAS_SHRINKED		equ %00000010
LF_RODERIC_INTOXICATED	equ %00000100
LF_EGG_SMASHED			equ %00001000
LF_TIN_HATCH_MELTED		equ %00010000
LF_SAFE_PUSHED			equ %00100000
LF_FROG_SEDUCED			equ %01000000
LF_EBOLA_FOUND			equ %10000000
; Logic flags 009
.var logic_flags_009	.byte
LF_COFFIN_MOVED			equ %00000001
LF_CROW_KILLED			equ %00000010
LF_WITCH_REMOVED		equ %00000100
LF_FREAK_HARRASED		equ %00001000
LF_URN_PLACED			equ %00010000
LF_VALVE3_ROTATED		equ %00100000
LF_HERO_ALIVE			equ %01000000
LF_SLUG_FED				equ %10000000
; Logic flags 010
.var logic_flags_010	.byte
LF_POOPUMP_SCREWS		equ %00000001
LF_POOPUMP_MUCUS		equ %00000010
LF_ARMCHAIR_WHEEL		equ %00000100
LF_ARMCHAIR_PUSHED		equ %00001000
LF_POOPUMP_STARTED		equ %00010000
LF_DILDO_GIVEN			equ %00100000
LF_DNA_GATHERED			equ %01000000
LF_SLUGDE_FLUSHED		equ %10000000
; Logic flags 011
.var logic_flags_011	.byte
LF_SLUGDE_POWERED		equ %00000001
LF_SLUDGE_DOOR_OPENED	equ %00000010
LF_OAK_LOG				equ %00000100
LF_VISCERA1				equ %00001000
LF_VISCERA2				equ %00010000
LF_VISCERA3				equ %00100000
LF_VISCERA4				equ %01000000
LF_VISCERA5				equ %10000000
; Logic flags 012
.var logic_flags_012	.byte
LF_VISCERA6				equ %00000001
LF_VISCERA7				equ %00000010
LF_VISCERA_DNA			equ %00000100
LF_VISCERA_WORCESTER	equ %00001000
LF_MOREL_CUT			equ %00010000
LF_DRAKUL_SPILLED		equ %00100000
LF_HOLYWATER_PEE		equ %01000000
LF_HOLYWATER_PRAY		equ %10000000
; Logic flags 013
.var logic_flags_013	.byte
LF_WICK_INSERTED		equ %00000001
LF_GOLD_BARS_GIVEN		equ %00000010
LF_MONGREL_REMOVED		equ %00000100
LF_PICKAXE_WAREHOUSE	equ %00001000
LF_CEILING_DESTROYED	equ %00010000
LF_FLASK_USED			equ %00100000
;LF_HOLYWATER_PEE		equ %01000000
;LF_HOLYWATER_PRAY		equ %10000000

; Stores the offset of the item selected from the pocket
.var pocket_selection_offset .word

; Indicates whether slow animation should be executed
; when processing actions
.var slow .byte

; Action items
ACTI_SAW		dta c"SAWWW"
ACTI_BORER		dta c"BORER"
ACTI_HAMMER		dta c"HAMME"
ACTI_DRY_BRAIN	dta c"DRYBR"
ACTI_FIRE_BRAIN	dta c"DRYBF"
ACTI_DOG_SHEET	dta c"DOGSH"
ACTI_GOLD_CROSS dta c"CROSR"
ACTI_CHEESE		dta c"CHEES"
ACTI_WRENCH		dta c"WRENC"
ACTI_RUSTY_KEY	dta c"KEY00"
ACTI_SNOT		dta c"SNOT0"
ACTI_AXE		dta c"AXE00"
ACTI_CHICKENLEG	dta c"CHKLG"
ACTI_BOLT_CROPP	dta c"BOLTC"
ACTI_PICKAXE	dta c"PCKAX"
ACTI_SHIT_SCRAP	dta c"SHITS"
ACTI_HOSPITAL_C	dta c"HCODE"
ACTI_DROPPINGS	dta c"DROPS"
ACTI_ASS_PLUG	dta c"SUPPO"
ACTI_SCISSORS	dta c"SCISS"
ACTI_WORM_DROPS	dta c"DROPS"
ACTI_HELL_KEY	dta c"KEY02"
ACTI_GRAIL		dta c"GRAIL"
ACTI_PRAYBOOK	dta c"PRAYB"
ACTI_GRAVELIGHT	dta c"GRVLT"
ACTI_BEER_FOAM	dta c"BFOAM"
ACTI_SKULL		dta c"SKULL"
ACTI_FOSSILIZED	dta c"BUG00"
ACTI_WYBIERAK	dta c"SHITS"
ACTI_TOILETBRSH	dta c"TOIBR"
ACTI_ROTTENKEY	dta c"KEY01"
ACTI_FEATHER	dta c"FEATH"
ACTI_CRANK		dta c"CRANK"
ACTI_ID_CARD	dta c"IDCAR"
ACTI_ROTTENFISH	dta c"RFISH"
ACTI_WD_40		dta c"WD400"
ACTI_2_DYNAMS	dta c"DYNA2"
ACTI_DYNAMITE	dta c"DYNA1"
ACTI_GOLDBARS	dta	c"BARGD"
ACTI_SWORD		dta c"SWORD"
ACTI_ICE_WATER	dta c"COLDW"
ACTI_EGG		dta c"EGG00"
ACTI_CHICK		dta c"CHICK"
ACTI_SOLDERTOOL	dta c"SOLDE"
ACTI_EBOLA		dta c"EBOLA"
ACTI_COFFIN_HND	dta c"COFHO"
ACTI_ZIGMUNT	dta c"RINGZ"
ACTI_DILDO		dta c"DILDO"
ACTI_URN		dta c"URN00"
ACTI_MUCUS		dta c"MUCUS"
ACTI_SCREWDRVR	dta c"SCRWD"
ACTI_WHEEL		dta c"WHEEL"
ACTI_SYRINGE	dta c"SYRIN"
ACTI_DNA		dta c"DNAAA"
ACTI_BATTERY	dta c"BATTE"
ACTI_VISCERA1	dta c"VISC1"
ACTI_VISCERA2	dta c"VISC2"
ACTI_VISCERA3	dta c"VISC3"
ACTI_VISCERA4	dta c"VISC4"
ACTI_VISCERA5	dta c"VISC5"
ACTI_VISCERA6	dta c"VISC6"
ACTI_VISCERA7	dta c"VISC7"
ACTI_WORCESTER	dta c"WORCE"
ACTI_PESTLE		dta c"PSTLE"
ACTI_ESSENCE	dta c"ESSEN"
ACTI_PENKNIFE	dta c"KNIFE"
ACTI_HOLYWATER	dta c"HWATE"
ACTI_FLASK		dta c"FLASK"
ACTI_CANDLEWICK	dta c"WICKK"
ACTI_PNEUMO		dta c"PNEUM"
ACTI_ROSARY		dta c"ROSAR"
ACTI_POEM		dta c"APOEM"

; Some helpers for logic-size optimization.
.proc show_status_message_003
				show_status_message #STATUSMSG_003
				rts
.endp

; X=1 then current map matches the passed one
; X=0 otherwise
.proc is_on_map_3030(.word part2) .var
				ldx #0
				#if .word part2 = game_state.current_map+2 .and .word game_state.current_map = #$3030
					inx
				#end
				rts
.endp
.proc is_on_map_3130(.word part2) .var
				ldx #0
				#if .word part2 = game_state.current_map+2 .and .word game_state.current_map = #$3130
					inx
				#end
				rts
.endp

; Shows status message from the specified file
.proc show_status_message(.word id_) .var
.var id_ .word
				show_status_message_INTERNAL id_
				rts
.endp

; Turs the hero into skeleton
.proc turn_hero_dead
				turn_hero_dead_INTERNAL
				rts
.endp

; Turs the hero alive
.proc turn_hero_alive
				turn_hero_alive_INTERNAL
				rts
.endp

.proc hero_gravity_IMMOVABLE
				hero_gravity
				rts
.endp

; Loads current map from disk, sets up all items
; and mechanism accordingly to currect state
.proc prepare_map
				disable_antic
				load_map
				
				; Check if we are on "Hlejnia" easter egg maps.
				; If yes, there is no place for post load logic
				; actions in the DLL.
				is_on_30319234
				cpx #1
				beq pm_01
				is_on_30319334
				cpx #1
				beq pm_02
				jsr logic_dll_post
pm_01			enable_antic
				rts
pm_02
				; Let's play Hlejnia!
				music_play_cmc_hlejnia
				jmp pm_01
.endp

; Displays the adventure message on the screen
; and handles all logic within the message.
.proc show_adventure_message(.word id_) .var
.var id_ .word
				show_adventure_message_INTERNAL id_
				rts
.endp

; Shows pocket on the screen
.proc show_pocket
				show_pocket_INTERNAL
				rts
.endp

; Checks if the particular item has been
; selected from the pocket.
; X=0 - not chosen, otherwise X=1
.proc is_chosen_in_pocket(.word item_) .var
.var item_ .word
				is_chosen_in_pocket_INTERNAL item_
				rts
.endp

.proc finish_with_message_006
 				prepare_map
				show_status_message #STATUSMSG_006
				rts
.endp

; Moves the main hero left
; MinPos = $30
.proc hero_left
				hero_left_INTERNAL
				rts
.endp

; Follows the map to the right
.proc follow_right(.byte cipsko) .var
				mwa game_state.link_right		game_state.current_map
				mwa game_state.link_right+2		game_state.current_map+2
				prepare_map
				lda cipsko
				cmp #0
				beq @+
				pla
				pla
@				rts
.endp

; Follows the map to the bottom
.proc follow_down(.byte cipsko) .var
				mwa game_state.link_bottom		game_state.current_map
				mwa game_state.link_bottom+2	game_state.current_map+2
				prepare_map
				lda cipsko
				cmp #0
				beq @+
				pla
				pla
@				rts
.endp

; Follows the map to the top
.proc follow_up(.byte cipsko) .var
				mwa game_state.link_top			game_state.current_map
				mwa game_state.link_top+2		game_state.current_map+2
				prepare_map
				lda cipsko
				cmp #0
				beq @+
				pla
				pla				
@				rts
.endp

; Spawns new item in the pocket
.proc spawn_in_pocket(.word item_name) .var
				find_free_pocket_socket
				sty bar_blink_counter
				ldy #0
				sty pocket_highlight
@				lda (item_name),y
				ldy bar_blink_counter
				sta POCKET,y
				inc bar_blink_counter
				inc pocket_highlight
				ldy pocket_highlight
				cpy #5
				bne @-
				rts
.endp

; Moves the main hero right
; MaxPos = $c8
.proc hero_right
				hero_right_INTERNAL
				rts
.endp

; Clears memory used by sprite 0 (hero)
.proc clear_hero
				lda #0
				ldy #0
@				sta pmg_hero,y
				iny
				cpy #0
				bne @- 
				rts
.endp

; Draws the main hero on the current position
.proc draw_hero
				draw_hero_INTERNAL
				rts
.endp

; Writes the action object name on the statusbar
.proc write_action_name(.word name) .var
.var name .word				
				print_string name, #1, #21, #0
				rts
.endp

; Propagates first three rows of the action
; menu with specified items.
.proc propagate_action_menu(.word item1 .word item2 .word item3) .var
.var item1, item2, item3 .word
			mwa #ACTION_MENU_SLOT_1 tmp_trg
			mwa item1 tmp_src
			jsr propagate_single_action_item
			mwa #ACTION_MENU_SLOT_2 tmp_trg
			mwa item2 tmp_src
			jsr propagate_single_action_item
			mwa #ACTION_MENU_SLOT_3 tmp_trg
			mwa item3 tmp_src
			jsr propagate_single_action_item
			
			rts
.endp
.proc propagate_action_menu_EXEMEM
			propagate_action_menu #ACT_EXPLORE #ACT_EMPTY #ACT_EMPTY
			rts
.endp
.proc propagate_action_menu_EXOPUS
			propagate_action_menu #ACT_EXPLORE #ACT_OPEN #ACT_USE
			rts
.endp
.proc propagate_action_menu_EXUSEM
			propagate_action_menu #ACT_EXPLORE #ACT_USE #ACT_EMPTY
			rts
.endp

; Performs the jump
.proc hero_jump
				lda hero_state.state
				cmp #hs_grounded
				bne @+ 
				mva #hs_jumping 	hero_state.state
				mva #hero_jump_time hero_state.jump_counter
@				rts
.endp

.proc print_string(.word buffer .byte xpos,ypos .byte translate) .var
.zpvar buffer	.word
.var xpos 		.byte
.var ypos		.byte
.var translate	.byte
				txa
				pha

				mwa #screen_mem screen_tmp
				ldy ypos
ps_3			cpy #0
				beq ps_2
				adw screen_tmp #40
				dey
				jmp ps_3  

ps_2			clc
				lda screen_tmp
				adc xpos
				sta screen_tmp
				lda screen_tmp+1
				adc #0
				sta screen_tmp+1

				ldy #0
ps_0			lda (buffer),y
				cmp #$9b
				beq ps_1
				ldx translate
				cpx #1
				bne ps_4
				Atascii2Internal @ 
ps_4			sta (screen_tmp),y
				iny
				jmp ps_0 
				
ps_1			
				pla
				tax
				rts
.endp

; Puts single char (stored in A) in the
; "transparent chars" table.
.proc add_single_char_to_transparent_chars
				is_on_transchar_list_already
				lda tmp_transchar
				cpx #1
				beq @+
				ldy TRANSCHAR_COUNT
				sta TRANSCHARS,y
				inc TRANSCHAR_COUNT
@				rts
.endp

; Provides a short delay
.proc delay
				delay_INTERNAL
				rts
.endp

; Removes the specified item from pocket
.proc remove_from_pocket(.word item_) .var
.var	item_ .word
				remove_from_pocket_INTERNAL item_
				rts
.endp

; Enables the strobo effect
.proc enable_strobo
				setup_strobo

				lda game_flags
				ora #FLAGS_STROBO
				sta game_flags
				rts
.endp

; Disables the strobo effect
.proc disable_strobo
				lda game_flags
				and #~FLAGS_STROBO
				sta game_flags
				rts
.endp

; Enables the lightning effect
.proc enable_lightning
				lda game_flags
				ora #FLAGS_LIGHTNING
				sta game_flags
				rts
.endp

; Disables the lightning effect
.proc disable_lightning
				lda game_flags
				and #~FLAGS_LIGHTNING
				sta game_flags
				rts
.endp

.proc is_on_30319234
				is_on_map_3130 #$3234
				rts
.endp
.proc is_on_30319334
				is_on_map_3130 #$3334
				rts
.endp
; Check whether the item is currently in the pocket.
; A=1 it is, otherwise A=0
.proc is_item_in_pocket(.word object) .var
				ldx #0
				mwa #POCKET current_pocket
iiip1			ldy #0
iiip0			lda (object),y
				cmp (current_pocket),y
				bne @+
				iny
				cpy #5
				bne iiip0
				lda #1		; Item found!
				rts
@				adw current_pocket #5
				inx
				cpx #51
				bne iiip1
				lda #0		; Entire pocket iterated, item not found
				rts
.endp

				jmp finale_loader


IMMOVABLE_CODE_END
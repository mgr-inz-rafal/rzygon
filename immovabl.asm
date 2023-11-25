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

; Used for comparing maps
.var 	part2 .word

.var			item1_tmp_pos		.byte

; Indicates the position of the hanging skull that
; should trigger the adventure menu
.var	hanging_skull_pos .byte

.var	cipsko				.byte

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

IMMOVABLE_CODE_END
; Reads binary font data directly into font memory
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

KONT_TU
			org $8442
; Represents the game state
.var	game_state 		game
			org KONT_TU

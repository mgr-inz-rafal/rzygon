;	@com.wudsn.ide.asm.mainsourcefile=main.asm

; Activates the currently loaded Display List
; .proc			activate_display_list

				; ldx <display_list
				; ldy >display_list
				; stx SDLSTL
				; sty SDLSTL+1
				
				; rts
; .endp

; Loads the specific Display List
; .proc			set_display_list(.word dl_name .byte dl_len) .var
; .zpvar			dl_name .word
; .var			dl_len	.byte

; 				dec dl_len
; 				ldy #$ff
; sdl_0			iny
; 				lda (dl_name),y
; 				sta display_list,y
; 				dec	dl_len
; 				bpl sdl_0
				
; 				rts 
; .endp

; Display List used for Adventure Message
klotnitz
				org sprite_mem
dl_adventure_message
				dta b(%11110000)			; DLI - begin
				dta b(%01110000)
				dta b(%01110000)
				dta b(%01001101)
				dta a(screen_mem)			; screen memory
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%10001101)			; DLI - text
				dta b(%00010000)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b($41),a(dl_adventure_message)
dl_adventure_message_len	equ *-dl_adventure_message

; Display List used for Main Game Screen
dl_game_screen
				dta b(%11110000)		; DLI - begin
				dta b(%01110000)
				dta b(%01110000)
				dta b(%01000010)
				dta a(screen_mem)		; screen memory
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)			
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%10000010)		; DLI - footer
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b($41),a(dl_game_screen)
dl_game_screen_len	equ *-dl_game_screen
; Display List used for initialization

; Represents the game state
; Strings representing action objects
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
; Specifies which action item is currently active
; IDs to be found in strings.asm

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

.var		msg_wait_fire		.byte

PIZDA_CHUJ

			org klotnitz
.var		display_list .word
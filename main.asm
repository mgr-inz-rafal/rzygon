				opt h+l+
				
pstart			equ $2C20
pocket_scr_buf	equ SCREEN_BUFFER
logic_dll		equ $9c60
logic_dll_post	equ $ad80
immovable		equ $8DFD	; TODO - at the end of the day, immovable (.slow) must finish at $9C5F
loader_start	equ $8CD5

; These three files are generated by Items, Object and Messages compiler.
; They just contain the sizes of particular files.
				icl 'it_size.asm'
				icl 'ob_size.asm'
				icl 'ms_size.asm'
				icl 'mt_size.asm'

				;icl 'io_loader.asm'
				
				org pstart

.zpvar =		$80

; Result of MEM_DETECT
;.var			ext_ram_banks	.byte

level_font		equ	$2000			; Size = $400
screen_mem		equ $2400			; Size = $81f ($2c20 is next free)
sprite_mem		equ $b800
text_font		equ $b400
display_list	equ	sprite_mem+$200	; Must fit into unused $300 bytes of sprites memory
io_buffer		equ	$b900			; Size = io_buffer_size
io_buffer_cart	equ	1536
io_buffer_size	equ	$ff

;MUSIC			equ $af40
;PLAYER			equ MUSIC-$7db

; Deal with the memory banks at the very beginning
;@TAB_MEM_BANKS  EQU $0400
				lda #1
				sta $03F8 ; basicf
				lda $D301
				ora #$02
				sta $D301
				lda #$C0
				sta $6A ; ramtop

				lda PORTB
				sta game_state
;				jsr sparta_detect
;				sta sparta_bank
;		        JSR @MEM_DETECT
;		        sta ext_ram_banks
;		        cmp #0
;		        beq @+
;		        jsr establish_extended_bank 
@				jmp start
				
; Includes				
				; General ATARI registes
				icl 'atari.inc'
				
				; Single-use code, which can be overwritten with buffers, etc.
				icl 'one_use.asm'
				
				; Bank-sensitive code, must be assembled before $4000
				icl 'banked.asm'
				
				; Bank independent section
				; Tools
				icl 'tools.asm'
				icl 'strings.asm'
								
				; Game
				icl	'g_main.asm'
				icl	'g_dl.asm'
				icl 'g_hero.asm'
				icl 'g_map.asm'
				icl 'g_items.asm'
				icl 'g_actmen.asm'
				icl 'g_pocket.asm'
				icl 'g_status.asm'
				icl 'g_logic.asm'
				
				; DLI
				icl 'dli_main.asm'
				
				; Title
				icl 't_main.asm'
				
				; Joystick
				icl 'j_stick.asm'
				
				; Display
				icl 'd_strgs.asm'
				icl 'd_map.asm'
				icl 'd_msgs.asm'
				icl 'd_actmen.asm'
				icl 'd_effect.asm'
				
				; Sprites
				icl 's_main.asm'
				
				; VBXE
				icl 'vbxe.asm'
				
				; Music
				icl 'm_player.asm'
				
; ----------------------
; Program start
;-----------------------		
start
;				jsr adapt_mem_banks
;				jsr initialization
				lda #0
				sta pocket_loaded
				mva #0 game_state.current_msg_file

				lda #34
				sta 559
				global_init
				legal_disclaimer
restart
				lda #34
				sta 559
				global_init
				title_screen				
				
				run_game
				jmp restart 

SCREEN_BUFFER
ADV_MESSAGE_BUFFER
:273 	dta b(0)	; Longest message is ~270 bytes long

.proc read_font
.zpvar	ptr .word
.zpvar	ptr2 .word
				lda #0
				sta NMIEN

				ldy io_buffer+$60
				sta PERSISTENCY_BANK_CTL,y
				sta wsync				

				mwa #CART_RAM_START ptr
				mwa #level_font ptr2
				ldy #0

rf_00
				lda (ptr),y
				sta (ptr2),y
				inw ptr
				inw ptr2
				#if .word ptr2 = #level_font+1024
					sta CART_DISABLE_CTL
					sta wsync
					rts
				#end
				jmp rf_00
.endp

; Performs some global initialization tasks
.proc global_init
				lda #1
				sta use_folders
				
				mwa #0 current_action 
				sta SOUNDR
				sta TRANSCHAR_COUNT
				sta logic_flags_000
				sta logic_flags_001
				sta logic_flags_002
				sta logic_flags_003
				sta logic_flags_004
				sta logic_flags_005
				sta logic_flags_006
				sta logic_flags_007
				sta logic_flags_008
				sta logic_flags_009
				sta logic_flags_010
				sta logic_flags_011
				sta logic_flags_012
				sta logic_flags_013
				
				mwa #hero_data hero_data_offset
				mva #hero_anim_time hero_anim_count
;				jsr music_init
				
				; Restore original font (needed when coming back from game)
				lda #>text_font
				sta CHBAS
				rts
.endp


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


; adapt_mem_banks
; 				lda game_state
; 				and #%00000001
; 				cmp #%00000001
; 				beq @+1
; ;				bne @+1
				
; 				; Need to keep the OS-ROM switched off
; 				ldy #0
; @				lda $400,y
; 				and #%11111110
; 				sta $400,y
; 				iny
; 				cpy ext_ram_banks
; 				bne @-
; 				lda $400,y
; 				and #%11111110
; 				sta $400,y
				
; @				rts

; Vidol - version 3
hero_data
				dta b(0),b(8),b(28),b(8),b(28),b(28),b(0),b(28)
				dta b(44),b(28),b(8),b(28),b(20),b(62),b(58),b(63)
				dta b(93),b(95),b(62),b(62),b(127),b(127),b(65),b(195)
				
				dta b(0),b(8),b(28),b(8),b(28),b(28),b(0),b(28)
				dta b(44),b(28),b(8),b(28),b(20),b(28),b(30),b(26)
				dta b(62),b(30),b(60),b(62),b(62),b(62),b(38),b(96)
				
				dta b(8),b(28),b(8),b(28),b(28),b(0),b(28),b(44)
				dta b(28),b(8),b(28),b(20),b(28),b(22),b(30),b(26)
				dta b(26),b(30),b(30),b(30),b(30),b(30),b(28),b(48)
				
				dta b(8),b(28),b(8),b(28),b(28),b(0),b(28),b(44)
				dta b(28),b(8),b(28),b(20),b(28),b(20),b(20),b(22)
				dta b(28),b(30),b(30),b(30),b(30),b(30),b(24),b(24)
				
				dta b(8),b(28),b(8),b(28),b(28),b(0),b(28),b(44)
				dta b(28),b(8),b(28),b(20),b(30),b(20),b(22),b(22)
				dta b(30),b(14),b(30),b(30),b(30),b(30),b(52),b(12)
				
				dta b(8),b(28),b(8),b(28),b(28),b(0),b(28),b(44)
				dta b(28),b(8),b(28),b(20),b(28),b(22),b(28),b(46)
				dta b(46),b(30),b(62),b(62),b(62),b(62),b(98),b(6)
				
				dta b(0),b(8),b(28),b(8),b(28),b(28),b(0),b(28)
				dta b(44),b(28),b(8),b(28),b(20),b(30),b(54),b(62)
				dta b(46),b(125),b(62),b(62),b(126),b(126),b(193),b(3)
				
				dta b(0),b(8),b(28),b(8),b(28),b(28),b(0),b(28)
				dta b(44),b(28),b(8),b(28),b(20),b(30),b(46),b(62)
				dta b(93),b(125),b(62),b(62),b(127),b(127),b(65),b(195)
				
				dta b(0),b(8),b(28),b(8),b(28),b(28),b(0),b(28)
				dta b(44),b(28),b(8),b(28),b(20),b(28),b(22),b(44)
				dta b(46),b(30),b(62),b(62),b(62),b(62),b(38),b(96)
				
				dta b(8),b(28),b(8),b(28),b(28),b(0),b(28),b(44)
				dta b(28),b(8),b(28),b(20),b(30),b(20),b(22),b(30)
				dta b(14),b(30),b(30),b(30),b(30),b(30),b(28),b(48)
				
				dta b(8),b(28),b(8),b(28),b(28),b(0),b(28),b(44)
				dta b(28),b(8),b(28),b(20),b(28),b(20),b(20),b(22)
				dta b(28),b(30),b(30),b(30),b(30),b(30),b(24),b(24)
				
				dta b(8),b(28),b(8),b(28),b(28),b(0),b(28),b(44)
				dta b(28),b(8),b(28),b(20),b(28),b(22),b(30),b(26)
				dta b(26),b(30),b(30),b(30),b(30),b(30),b(52),b(12)
				
				dta b(8),b(28),b(8),b(28),b(28),b(0),b(28),b(44)
				dta b(28),b(8),b(28),b(20),b(28),b(30),b(26),b(62)
				dta b(30),b(60),b(62),b(62),b(62),b(62),b(98),b(6)
				
				dta b(0),b(8),b(28),b(8),b(28),b(28),b(0),b(28)
				dta b(44),b(28),b(8),b(28),b(20),b(60),b(58),b(62)
				dta b(93),b(95),b(62),b(62),b(126),b(126),b(193),b(3)
hero_data_finish

hero_data_dead
				dta b(0),b(16),b(56),b(16),b(56),b(56),b(0),b(56)
				dta b(24),b(56),b(16),b(24),b(60),b(200),b(148),b(12)
				dta b(24),b(12),b(28),b(20),b(34),b(34),b(65),b(195)

				dta b(0),b(16),b(56),b(16),b(56),b(56),b(0),b(56)
				dta b(24),b(56),b(16),b(24),b(60),b(200),b(148),b(12)
				dta b(24),b(12),b(20),b(20),b(34),b(34),b(38),b(96)
				
				dta b(16),b(56),b(16),b(56),b(56),b(0),b(56),b(24)
				dta b(56),b(16),b(24),b(252),b(136),b(20),b(12),b(24)
				dta b(12),b(8),b(12),b(20),b(20),b(20),b(28),b(48)
				
				dta b(16),b(56),b(16),b(56),b(56),b(0),b(56),b(24)
				dta b(56),b(16),b(24),b(252),b(136),b(20),b(12),b(24)
				dta b(12),b(8),b(8),b(8),b(8),b(24),b(8),b(24)
				
				dta b(16),b(56),b(16),b(56),b(56),b(0),b(56),b(24)
				dta b(56),b(16),b(24),b(60),b(200),b(148),b(12),b(24)
				dta b(12),b(8),b(8),b(12),b(20),b(20),b(52),b(12)
				
				dta b(0),b(16),b(56),b(16),b(56),b(56),b(0),b(56)
				dta b(24),b(56),b(16),b(24),b(60),b(200),b(148),b(12)
				dta b(24),b(8),b(28),b(20),b(20),b(34),b(98),b(6)
hero_data_dead_finish
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
.proc show_advmessage_border
.zpvar	ptr .word
.zpvar	ptr2 .word
				lda #0
				sta NMIEN

				sta PERSISTENCY_BANK_CTL+27
				sta wsync

				mwa #$AFE9 ptr
				mwa #screen_mem+$640 ptr2

				ldy #0
sab_0
				lda (ptr),y
				sta (ptr2),y
				#if .word ptr = #$B1C9
					sta CART_DISABLE_CTL
					sta wsync
					rts
				#end
				inw ptr
				inw ptr2
				jmp sab_0
.endp

				org PLAYER
				icl "rmtplayr.a65"

; Table of transparent chars (hero can move through them)
; -> Will use the bytes spared by introducing one_use.asm.
TRANSCHAR_COUNT	dta b(0)
TRANSCHARS		
:54 dta b(0) ; Max transchars is 52 on MAP0064 (Sala operacyjna), we're allowing more for some not "object" realted transchars to be added
POCKET
:51 dta b(0)
END_POCKET
; -> Will use the bytes spared by introducing one_use.asm.
LEVEL_NAME_BUFFER1
:22 dta b(0)
LEVEL_NAME_BUFFER2
:22 dta b(0)

; RMT module
	opt h-						;RMT module is standard Atari binary file already
	ins "instruction.rmt"				;include music RMT module
	opt h+
MODUL equ $7750


				org text_font
				ins 'fnt_msg.bin'
				
				;org immovable
				org $ba3e ; After dli
				icl 'immovabl.asm'
								
				org $02e0
				dta a(pstart)

				end



// TODO:
// These functions to be removed:
;				io_find_free_iocb
;				io_open_file_OPT1
;				io_read_binary
;				io_read_binary
;				io_close_file				
;	@com.wudsn.ide.asm.mainsourcefile=main.asm

; Various game flags
; Bit 0 = In pocket?
; Bit 1 = In adventure message?
; Bit 2 = Is hero turned left?
; Bit 3 = Is hero facing front?
; Bit 4 = UNUSED
; Bit 5 = UNUSED
; Bit 6 = UNUSED
; Bit 7 = UNUSED
.var	game_flags					.byte
.var	logic_dll_name_to_be_used	.word

FLAGS_INPOCKET		equ 	%00000001
FLAGS_INADVMESSAGE	equ 	%00000010
FLAGS_HERO_LEFT		equ		%00000100
FLAGS_HERO_FRONT	equ		%00001000
FLAGS_HERO_TUPTA	equ		%00010000
FLAGS_IN_ACTMENU	equ		%00100000
FLAGS_STROBO		equ		%01000000
FLAGS_LIGHTNING		equ		%10000000

screen_width		equ		40
screen_height		equ		24

COLOR_FOOTER_BCKG	equ		$13
COLOR_FOOTER_FONT	equ		201

detected_vbxe		dta b(0)

.var default_font		.byte

.var use_folders		.byte

.proc clear_game_screen
				mwa #screen_mem screen_tmp
				ldy #0
cgs0			lda #0
				sta (screen_tmp),y
				adw screen_tmp #1
				cpw screen_tmp #screen_mem+screen_width*screen_height
				bne cgs0 
				rts
.endp

; Switches the display list to the game DL
.proc game_screen
				; Configure display list
				set_display_list #dl_game_screen #dl_game_screen_len
								
				rts
.endp

; Clears the item name on the footer
.proc clear_item_name
				lda #0
				sta ITEM_CONTACT
				print_string #ITEM_CLEAR, #1, #21, #0
				rts
.endp

; Handles the contact with item 
.proc handle_item_contact
				cpy #0
				jeq hic_X
				write_item_name ,
				rts
hic_X			lda current_action
				cmp #0
				bne @+
				clear_item_name
@				rts
.endp

// MAP structure:
// FONT ID - 9b
// BUILDER COUNT - 9b
// MAP CHUNK (aka BUILDER) - each separated with 9b
// LINK TO OTHER MAP - 9b
// LINK TO OTHER MAP - 9b
// LINK TO OTHER MAP - 9b
// LINK TO OTHER MAP - 9b

; Reads entire map structure from disk and
; writes it on the screen
.proc read_map
				lda #0
				sta NMIEN

				lda #75
				sta load_map.slot

rm_04
				ldy load_map.slot
				sta PERSISTENCY_BANK_CTL,y
				sta wsync
				mwa #CART_RAM_START show_message_prerequisites.ptr
				mwa #io_buffer_cart+4 show_message_prerequisites.ptr2

rm_02
				ldy #0

				lda (show_message_prerequisites.ptr),y
				cmp #$ff
				bne @+
				inc load_map.slot
				jmp rm_04
@				cmp io_buffer_cart,y
				bne rm_00
				iny
				lda (show_message_prerequisites.ptr),y
				cmp io_buffer_cart,y
				bne rm_00
				iny
				lda (show_message_prerequisites.ptr),y
				cmp io_buffer_cart,y
				bne rm_00
				iny
				lda (show_message_prerequisites.ptr),y
				cmp io_buffer_cart,y
				bne rm_00

				; Found map, copy 800 bytes into screen_mem
				adw show_message_prerequisites.ptr #4
				ldy #0
rm_05
				lda (show_message_prerequisites.ptr),y
				sta (show_message_prerequisites.ptr2),y
				inw show_message_prerequisites.ptr
				inw show_message_prerequisites.ptr2
				#if .word show_message_prerequisites.ptr2 = #io_buffer_cart+4+97
					jmp rm_X
				#end
				jmp rm_05

rm_00
				; Not this map, add 101 and continue
				ldy #0
rm_01
				adw show_message_prerequisites.ptr #101
				jmp rm_02

rm_X
				// Font bank: io_buffer_cart+4
				ldy io_buffer_cart+4
				sta PERSISTENCY_BANK_CTL,y
				ldy #0
				mwa #$a000 show_message_prerequisites.ptr
				mwa #level_font show_message_prerequisites.ptr2
rm_17
				lda (show_message_prerequisites.ptr),y
				sta (show_message_prerequisites.ptr2),y
				inw show_message_prerequisites.ptr
				inw show_message_prerequisites.ptr2
				#if .word show_message_prerequisites.ptr2 = #level_font+1024
					jmp rm_X2
				#end
				jmp rm_17
rm_X2

				sta CART_DISABLE_CTL
				sta wsync



; 				; Read text records from file
; 				; 1. Font to be used
; ;				jsr io_read_record_OPT1
; 				lda io_buffer
; 				cmp #'9'		; Special (default) font?
; 				bne @+
; 				inc default_font
; 				jmp rmf_0
; @				mva #0 default_font
; 				compare_fonts				
; 				cmp #1
; 				beq @+
; 				mwy io_buffer	game_state.current_font
; 				mvy io_buffer+2	game_state.current_font+2
; 				load_font
				
; rmf_0			; 2. Number of builders
; @				ldx cio_handle
; ;				jsr io_read_record_OPT1

; 				; 3. Read all builders and draw map
; 				string2byte #io_buffer
; 				tay
; rm1				cpy #0
; 				beq rm2
; 				tya
; 				pha
; ;				jsr io_read_record_OPT1
; 				display_map_chunk
; 				pla
; 				tay
; 				dey
; 				jmp rm1
				
; 				; 4. Read links to other maps
; rm2
; ;				jsr io_read_record_OPT1
; 				mwa io_buffer		game_state.link_right
; 				mwa io_buffer+2		game_state.link_right+2
; ;				jsr io_read_record_OPT1
; 				mwa io_buffer		game_state.link_left
; 				mwa io_buffer+2		game_state.link_left+2
; ;				jsr io_read_record_OPT1
; 				mwa io_buffer		game_state.link_top
; 				mwa io_buffer+2		game_state.link_top+2
; ;				jsr io_read_record_OPT1
; 				mwa io_buffer		game_state.link_bottom
; 				mwa io_buffer+2		game_state.link_bottom+2
				
; 				; 5. Read colors
; 				; COLOR1 = text
; 				; COLOR2 = background
; 				; jsr io_read_record_OPT1
; 				string2byte #io_buffer
; 				sta COLOR1
; 				; jsr io_read_record_OPT1
; 				string2byte #io_buffer
; 				ldy detected_vbxe
; 				cpy #1
; 				bne @+
; 				sta COLOR1
; @
; ;				jsr io_read_record_OPT1
; 				string2byte #io_buffer
; 				sta COLOR2
; ;				jsr io_read_record_OPT1
; 				string2byte #io_buffer
; 				ldy detected_vbxe
; 				cpy #1
; 				bne @+
; 				sta COLOR2
; @				
; 				; 5.5. Read two bytes representing logic DLL
; 				txa
; 				pha
; 				io_read_binary #logic_dll_name_to_be_used #2
; 				#if .word logic_dll_name_to_be_used <> game_state.logic_dll_name 
; 					load_logic_block
; 					mwa logic_dll_name_to_be_used game_state.logic_dll_name
; 				#end
; 				pla
; 				tax
				
; 				; 6. Number of objects 				
; 				; jsr io_read_record_OPT1
; 				string2byte #io_buffer
				
; 				; 7. Read all map objects and draw them
; 				tay
; rm3				cpy #0
; 				jeq rm4
; 				tya
; 				pha
; 				; jsr io_read_record_OPT1
; 				txa
; 				pha
; 				load_map_object
; 				pla
; 				tax
; 				pla
; 				tay
; 				dey
; 				jmp rm3			
				
; 				; 8. Number of items 				
; rm4
; ; 				jsr io_read_record_OPT1
; 				string2byte #io_buffer

; 				; 9. Read all map items and draw them
; 				pha
; 				clear_sprites_memory #1
; 				pla
; 				tay
; rm6				cpy #0
; 				jeq rm5
; 				tya
; 				pha
; 				; jsr io_read_record_OPT1
; 				mwa io_buffer+6 io_buffer+$57
; 				mva io_buffer+8 io_buffer+$59
								
; 				txa
; 				pha
				
; 				; If object is in pocket, do not load
; 				is_item_in_pocket #io_buffer
; 				cmp #1
; 				beq rm7
; 				; Some items are not loaded depending on the
; 				; current state of the game logic (for example:
; 				; cheese that has been given to a rat already).
; 				should_spawn_this_item
; 				cmp #1
; 				beq rm7
; 				load_map_item
; rm7				pla
; 				tax
; 				pla
; 				tay
; 				dey
; 				jmp rm6			
; rm5
				
; 				; 10. Level name 
; 				mva #72 io_buffer
; 				;io_read_record #io_buffer+1 #io_buffer_size
; 				display_level_name
				
rm_ERR			rts
.endp

; Performs the game initialization
.proc run_game
				disable_antic
				initialize_game_state
				initialize_hero_state
				game_screen
				enable_antic
				setup_sprites
				
				show_adventure_message #ADVMSG_035
								
				prepare_map
				mva hero_XPos HPOSP0

				spawn_in_pocket #ACTI_ROSARY
				; DEBUG
;				spawn_in_pocket #ACTI_BATTERY
;				spawn_in_pocket #ACTI_POEM
;				spawn_in_pocket #ACTI_PNEUMO
;				spawn_in_pocket #ACTI_PENKNIFE
;				spawn_in_pocket #ACTI_ESSENCE
;				spawn_in_pocket #ACTI_FLASK
;				spawn_in_pocket #ACTI_CANDLEWICK
;				spawn_in_pocket #ACTI_HOLYWATER
;				spawn_in_pocket #ACTI_PESTLE
;				spawn_in_pocket #ACTI_WORCESTER
;				spawn_in_pocket #ACTI_VISCERA1
;				spawn_in_pocket #ACTI_VISCERA2
;				spawn_in_pocket #ACTI_VISCERA3
;				spawn_in_pocket #ACTI_VISCERA4
;				spawn_in_pocket #ACTI_VISCERA5
;				spawn_in_pocket #ACTI_VISCERA6
;				spawn_in_pocket #ACTI_VISCERA7
;				spawn_in_pocket #ACTI_DNA
;				spawn_in_pocket #ACTI_SAW
;				spawn_in_pocket #ACTI_DYNAMITE
;				spawn_in_pocket #ACTI_2_DYNAMS
;				spawn_in_pocket #ACTI_GRAVELIGHT
;				spawn_in_pocket #ACTI_WD_40
;				spawn_in_pocket #ACTI_BEER_FOAM
;				spawn_in_pocket #ACTI_SKULL
;				spawn_in_pocket #ACTI_GRAIL
;				spawn_in_pocket #ACTI_HAMMER
;				spawn_in_pocket #ACTI_FIRE_BRAIN
;				spawn_in_pocket #ACTI_ID_CARD
;				spawn_in_pocket #ACTI_DOG_SHEET
;				spawn_in_pocket #ACTI_WRENCH
;				spawn_in_pocket #ACTI_BOLT_CROPP
;				spawn_in_pocket #ACTI_RUSTY_KEY
;				spawn_in_pocket #ACTI_PRAYBOOK
;				spawn_in_pocket #ACTI_FOSSILIZED
;				spawn_in_pocket #ACTI_WYBIERAK
;				spawn_in_pocket #ACTI_TOILETBRSH
;				spawn_in_pocket #ACTI_ROTTENKEY
;				spawn_in_pocket #ACTI_FEATHER
;				spawn_in_pocket #ACTI_DROPPINGS
;				spawn_in_pocket #ACTI_CRANK
;				spawn_in_pocket #ACTI_CHEESE
;				spawn_in_pocket #ACTI_ASS_PLUG
;				spawn_in_pocket #ACTI_ROTTENFISH
;				spawn_in_pocket #ACTI_AXE
;				spawn_in_pocket #ACTI_CHICKENLEG
;				spawn_in_pocket #ACTI_PICKAXE
;				spawn_in_pocket #ACTI_GOLDBARS
;				spawn_in_pocket #ACTI_MUCUS
;				spawn_in_pocket #ACTI_SWORD
;				spawn_in_pocket #ACTI_ICE_WATER
;				spawn_in_pocket #ACTI_EGG
;				spawn_in_pocket #ACTI_SHIT_SCRAP
;				spawn_in_pocket #ACTI_CHICK
;				spawn_in_pocket #ACTI_SOLDERTOOL
;				spawn_in_pocket #ACTI_COFFIN_HND
;				spawn_in_pocket #ACTI_EBOLA
;				spawn_in_pocket #ACTI_ZIGMUNT
;				spawn_in_pocket #ACTI_DILDO
;				spawn_in_pocket #ACTI_URN
;				spawn_in_pocket #ACTI_SCREWDRVR
;				spawn_in_pocket #ACTI_SHIT_SCRAP
;				spawn_in_pocket #ACTI_WHEEL
;				spawn_in_pocket #ACTI_SYRINGE
;				turn_hero_dead
				
				
;				lda logic_flags_010
;				ora #LF_POOPUMP_STARTED
;				sta logic_flags_010

;				lda logic_flags_010
;				ora #LF_SLUGDE_FLUSHED
;				sta logic_flags_010
				
				; Below is not Debug!
;				lda logic_flags_009
;				ora #LF_HERO_ALIVE
;				sta logic_flags_009
				
rg0				deal_with_atract
				check_collisions
				handle_item_contact
		
				lda STICK0
				and #%00001000
				cmp #%00000000	; Right
				jeq rg3						
				lda STICK0
				and #%00000100
				cmp #%00000000	; Left
				jeq rg4
				lda STICK0
				cmp #13			; Down
				jeq rg9
				cmp #14			; Up
				jeq rga

return_from_action
rg8				
				lda STRIG0
				cmp #0
				jeq rgb
				
				jmp rg7

;---------- Process movement
; Stick right
rg3				
				jsr restore_hero_walk_animation
				hero_right_INTERNAL
				jmp rg8
; Stick left
rg4
				jsr restore_hero_walk_animation
				hero_left_INTERNAL
				jmp rg8

; Stick button pressed
rgb				hero_jump
				jmp rg7
; Stick down
rg9				lda current_action
				cmp #0
				beq rgc
				display_action_menu
				process_action_menu
				
				; Invoke appropriate action handler
				#if .byte current_action_menu_item < #3	; 3 means "Cancel" in any case, so no action is needed
					lda >return_from_action-1
					pha
					lda <return_from_action-1
					pha
					lda act_on_action_vector+1
					pha
					lda act_on_action_vector
					pha
					rts
				#end
				jmp rg8
rgc				hero_action
				jmp rg8
; Stick up
rga				is_on_30319334	; Do not show pocket when Hlejnia is playing
				cpx #1
				beq @+
				lda hero_state.state	; Do not show pocket when hero isn't on the ground
				cmp #hs_grounded 	
				bne @+
				show_pocket
				prepare_map
@				jmp rg8
			

;---------- Process other game elements
rg7				
				jsr logic_dll
				process_hero_state
				process_strobo
				process_lightning
				synchro
				
;---------- Save / Load state
				is_on_30319334	; Do not allow load/save when Hlejnia is playing
				cpx #1
				beq @+
				lda CONSOL
				cmp #5
				beq save_state
				cmp #3
				beq load_state
@				jmp rgd
				
save_state
				inc msg_wait_fire
				show_status_message #STATUSMSG_000
				dec msg_wait_fire
				lda #$ff
				sta CH
save_state_00	synchro
				lda CH
				cmp #35
				beq save_state_02
				cmp #43
				beq save_state_03
				cmp #45
				beq save_state_03
				lda #$ff
				sta CH
				jmp save_state_00
				
save_state_03	save_game_state_to_file
				recover_from_status_message
				lda save_load_ok
				cmp #1
				beq save_state_01
				show_status_message #STATUSMSG_037
				jmp save_state_02
save_state_01	show_status_message #STATUSMSG_038
save_state_02	recover_from_status_message
				jmp rgd
				
load_state
				inc msg_wait_fire
				show_status_message #STATUSMSG_008
				dec msg_wait_fire
				lda #$ff
				sta CH
load_state_00	synchro
				lda CH
				cmp #35
				beq load_state_02
				cmp #43
				beq load_state_03
				cmp #45
				beq load_state_03
				lda #$ff
				sta CH
				jmp load_state_00
				
load_state_03	restore_hero_walk_animation
				load_game_state_from_file
				recover_from_status_message
				prepare_map
				clear_hero
				draw_hero
				show_hero
				lda save_load_ok
				cmp #1
				beq load_state_01
				show_status_message #STATUSMSG_037
				jmp load_state_02
load_state_01	show_status_message #STATUSMSG_038
load_state_02	recover_from_status_message
				jmp rgd

rgd
;---------------- DEBUG
; A = 63
; D = 58
; W = 46
; S = 62
; Q = 47
				lda CH		; $02FC (hard to look-up in atari.inc)
				 ; cmp #63	; A = left
				 ; jne @+
				 ; follow_left
				 ; lda #$ff
				 ; sta CH
				 ; jmp rg0
; @				cmp #58 ; D = right
				 ; jne @+
				 ; follow_right #0
				 ; lda #$ff
				 ; sta CH
				 ; jmp rg0
; @				cmp #46 ; W = up
				 ; jne @+
				 ; follow_up #0
				 ; lda #$ff
				 ; sta CH
				 ; jmp rg0
; @				cmp #62 ; S = down
				 ; jne @+
				 ; follow_down #0
				 ; lda #$ff
				 ; sta CH
				 ; jmp rg0
; @				cmp #47 ; Q = various debug calls
				 ; jne @+
 				; remove_from_pocket #ACTI_ASS_PLUG
 				; lda logic_flags_002
 				; eor #LF_WORM_PLUGGED
 				; sta logic_flags_002
				 ; lda #$ff
				 ; sta CH
				 ; jmp rg0
				cmp #28 ; ESC - back to start screen
				jne @+
				lda #$ff
				sta CH
				rts
@				jmp rg0

				lda #$ff
				sta CH
				
;--------------------------------------
				
@				jmp rg0
				
				rts
.endp

; Follows the map to the left
.proc follow_left
				music_stop_cmc_hlejnia
				
				mwa game_state.link_left		game_state.current_map
				mwa game_state.link_left+2		game_state.current_map+2
				prepare_map
				rts
.endp

; Sets up all objects necessary to start a game
.proc initialize_game_state
				; Init various flags
				lda #%00000000
				sta game_flags
				sta msg_wait_fire
				sta default_font
				
				; Start with map #3 (Ascii: 0003 = $30 $30 $30 $33)
; ORIGINAL
				mwa #$3030 game_state.current_map		; 00
				mwa #$3330 game_state.current_map+2		; 03
; DEBUG
;				mwa #$3130 game_state.current_map
;				mwa #$3537 game_state.current_map+2
				
				mwa #9999 logic_dll_name_to_be_used

				; Pocket starts display from the first item.
				mva #0 pocket_offset

				; Current font set to X (to force load font on first map)
				invalidate_logic_dll
				invalidate_font
				sta HITCLR
				
				; Setup font
				mva #>level_font CHBAS
				
				; Initialize DLI
				dli_init
				
				; Clear pocket
				ldy #0
				lda #0
@				sta POCKET,y
				iny
				cpy #$ff
				bne @-
				
				; Initially, the first skull in hell will trigger
				; the action menu
				mva #$5c hanging_skull_pos
				
				rts
.endp

.proc build_file_name
				; mwa drive_id		io_buffer
				; mva #77				io_buffer+2
				; lda use_folders
				; cmp #1
				; beq @+
				; mwa game_state.current_map		io_buffer+3
				; mwa game_state.current_map+2	io_buffer+5
				; mwa	map_file_ext	io_buffer+7
				; mwa	map_file_ext+2	io_buffer+9
				
				; Not necessary for opening file, but in case
				; of error it comes in handy for displaying
				; the filename on screen
				; mva #$9b			io_buffer+11
				; rts
@				
				; mva game_state.current_map+3	io_buffer+3
				; mva #62	io_buffer+4
				; mva #77				io_buffer+2+3
				mwa game_state.current_map		io_buffer_cart
				mwa game_state.current_map+2	io_buffer_cart+2
				; mwa	map_file_ext	io_buffer+7+3
				; mwa	map_file_ext+2	io_buffer+9+3
				; mva #$9b			io_buffer+11+3
				
				
				rts
.endp

.proc build_file_name_map
				; mwa drive_id		io_buffer
				; mva #77				io_buffer+2
				; lda use_folders
				; cmp #1
				; beq @+
				; mwa game_state.current_map		io_buffer+3
				; mwa game_state.current_map+2	io_buffer+5
				; mwa	map_file_ext	io_buffer+7
				; mwa	map_file_ext+2	io_buffer+9
				
				; Not necessary for opening file, but in case
				; of error it comes in handy for displaying
				; the filename on screen
				; mva #$9b			io_buffer+11
				; rts
@				
				; mva game_state.current_map+3	io_buffer+3
				; mva #62	io_buffer+4
				 mva #77				io_buffer_cart
				mva game_state.current_map+1	io_buffer_cart+1
				mwa game_state.current_map+2	io_buffer_cart+2
				; mwa	map_file_ext	io_buffer+7+3
				; mwa	map_file_ext+2	io_buffer+9+3
				; mva #$9b			io_buffer+11+3
				
				
				rts
.endp

; Creates the font file name in the io_buffer+$60
.proc build_font_file_name
				; mwa drive_id		io_buffer+$60
				; mva #70				io_buffer+2+$60
				; lda use_folders
				; cmp #1
				; beq @+
				; mwa io_buffer		io_buffer+3+$60
				; mva io_buffer+2		io_buffer+5+$60
				; mwa	font_file_ext	io_buffer+6+$60
				; mwa	font_file_ext+2	io_buffer+8+$60
				
				; ; Not necessary for opening file, but in case
				; ; of error it comes in handy for displaying
				; ; the filename on screen
				; mva #$9b			io_buffer+10+$60
				; rts

; @				mva #62	io_buffer+3+$60
				; mva #70	io_buffer+4+$60
				; mwa io_buffer		io_buffer+5+$60
				; mva io_buffer+2		io_buffer+7+$60
				; mwa	font_file_ext	io_buffer+8+$60
				; mwa	font_file_ext+2	io_buffer+10+$60
				; mva #$9b			io_buffer+12+$60
				rts
				
.endp

; Creates the object file name in the io_buffer+$60
; .proc build_object_file_name
				; mwa drive_id		io_buffer+$60
				; mwa #$424f 			io_buffer+$62	; "OB"
				; mva #$9b			io_buffer+$64
				; rts
; .endp

; ; Creates the item file name in the io_buffer+$60
; .proc build_item_file_name
				; mwa drive_id		io_buffer+$60
				; mwa #$5449 			io_buffer+$62	; "IT"
				; mva #$9b			io_buffer+$64
				; rts
; .endp

; Loads current map from disk
; Maps are stored in files "XXYY.MAP" where
; XXYY is the current map number (for example:
; 0000.MAP, A9E1.MAP, 0001.MAP, etc.)
.proc load_map
.var	slot .byte
				; Clear screen memory
				clear_game_screen
				
				; Initialize the index of items being loaded
				mva #1 item_being_loaded
				
				; Initialize the number of transparent chars.
				; (1, since char "0" is always present on the list)
				mva #0 TRANSCHAR_COUNT
				
				; Build appropriate filename in the I/O buffer
				build_file_name_map

				lda #0
				sta NMIEN

				lda #55
				sta slot

lm_04
				ldy slot
				sta PERSISTENCY_BANK_CTL,y
				sta wsync
				mwa #CART_RAM_START show_message_prerequisites.ptr
				mwa #screen_mem show_message_prerequisites.ptr2

lm_02
				ldy #0

				lda (show_message_prerequisites.ptr),y
				cmp #$ff
				bne @+
				inc slot
				jmp lm_04
@				cmp io_buffer_cart,y
				bne lm_00
				iny
				lda (show_message_prerequisites.ptr),y
				cmp io_buffer_cart,y
				bne lm_00
				iny
				lda (show_message_prerequisites.ptr),y
				cmp io_buffer_cart,y
				bne lm_00
				iny
				lda (show_message_prerequisites.ptr),y
				cmp io_buffer_cart,y
				bne lm_00

				; Found map, copy 800 bytes into screen_mem
				adw show_message_prerequisites.ptr #4
				ldy #0
lm_05
				lda (show_message_prerequisites.ptr),y
				sta (show_message_prerequisites.ptr2),y
				inw show_message_prerequisites.ptr
				inw show_message_prerequisites.ptr2
				#if .word show_message_prerequisites.ptr2 = #screen_mem+800 
					jmp lm_X
				#end
				jmp lm_05

lm_00
				; Not this map, add 804 and continue
				ldy #0
lm_01
				adw show_message_prerequisites.ptr #804
				jmp lm_02

lm_X
				sta CART_DISABLE_CTL
				sta wsync
				
				; Open the file for reading
				; open_map_file
				; stx cio_handle
				; bmi lm_ERR
				
				; Read map data
				; ldx cio_handle

				; TODO - continue here as we need to parse loaded map

				read_map; reload
				; bmi lm_ERR
				
				; Close map file
				; ldx cio_handle
				; io_close_file
				
lm_ERR			rts
.endp

; Routine for loading the font
.proc load_font
				; build_font_file_name
				; open_object_file		; Reuse the method used to open object
				; bmi lf_ERR
				
				; read_font
				; bmi lf_ERR
				
				; io_close_file
				
lf_ERR			rts
.endp

; Compares the font number in io_buffer and game_state.current_font.
; If they are the same, 1 is stored in A
.proc compare_fonts
				lda io_buffer
				cmp game_state.current_font
				bne @+
				lda io_buffer+1
				cmp game_state.current_font+1
				bne @+
				lda io_buffer+2
				cmp game_state.current_font+2
				bne @+
				lda #1
				rts
@				lda #0
				rts
.endp

; Opens the map file
; .proc open_map_file
				; io_find_free_iocb
				; io_open_file_OPT1
				; rts
; .endp

; Opens the object file
; .proc open_object_file
				; io_find_free_iocb
				; io_open_file #io_buffer+$60 #OPNIN
				; rts
; .endp

; Loads the current game state from a file
.proc load_game_state_from_file
; 				mva #1 save_load_ok
; 				disable_antic
; 				io_find_free_iocb
; 				io_open_file #save_state_file #OPNIN
; 				jmi lgstf_e
				
; 				; Read pocket offset
; 				io_read_binary #pocket_offset #1
; 				jmi lgstf_e

; 				; Read pocket content
; 				io_read_binary #POCKET #51*5
; 				jmi lgstf_e
				
; 				; Read hero position
; 				io_read_binary #hero_XPos #1
; 				jmi lgstf_e
; 				io_read_binary #hero_YPos #1
; 				jmi lgstf_e

; 				; Read hero direction (bit in the game_flags)
; 				io_read_binary #game_flags #1
; 				jmi lgstf_e
				
; 				; Read the logic state of the game
; 				io_read_binary #logic_flags_000 #1
; 				jmi lgstf_e
; 				io_read_binary #logic_flags_001 #1
; 				jmi lgstf_e
; 				io_read_binary #logic_flags_002 #1
; 				jmi lgstf_e
; 				io_read_binary #logic_flags_003 #1
; 				jmi lgstf_e
; 				io_read_binary #logic_flags_004 #1
; 				jmi lgstf_e
; 				io_read_binary #logic_flags_005 #1
; 				jmi lgstf_e
; 				io_read_binary #logic_flags_006 #1
; 				jmi lgstf_e
; 				io_read_binary #logic_flags_007 #1
; 				jmi lgstf_e
; 				io_read_binary #logic_flags_008 #1
; 				jmi lgstf_e
; 				io_read_binary #logic_flags_009 #1
; 				jmi lgstf_e
; 				io_read_binary #logic_flags_010 #1
; 				jmi lgstf_e
; 				io_read_binary #logic_flags_011 #1
; 				jmi lgstf_e
; 				io_read_binary #logic_flags_012 #1
; 				jmi lgstf_e
; 				io_read_binary #logic_flags_013 #1
; 				jmi lgstf_e
; 				io_read_binary #hanging_skull_pos #1
; 				jmi lgstf_e
				
; 				; Read current map number
; 				io_read_binary #game_state.current_map #4
; 				jmi lgstf_e
				
; 				; If hero is dead, turn him dead
; 				lda logic_flags_003
; 				and #LF_RZYGON_DEAD
; 				cmp #LF_RZYGON_DEAD
; 				bne @+

; 				; ---- Don't call 'turn hero dead'
; 				mwa #hero_data_dead hero_data_offset
; 				mva #hero_anim_time hero_anim_count
; 				lda #hc_dead
; 				sta PCOLR0				
; ;				draw_hero
; 				; ---- because it will modify logic_flags_003
				
; @				; Load process OK
; 				jmp lgstf0
	
; lgstf_e			dec save_load_ok
				
; lgstf0			io_close_file
; 				enable_antic
				rts
.endp

; Saves the current game state to a file
.proc save_game_state_to_file
				; mva #1 save_load_ok
				; disable_antic
				; io_find_free_iocb
				; io_open_file #save_state_file #OPNOT
				; jmi sgstf_e
				
				; ; Store pocket offset
				; io_write_binary #pocket_offset #1
				; jmi sgstf_e
				
				; ; Store pocket content
				; io_write_binary #POCKET #51*5
				; jmi sgstf_e
				
				; ; Store hero position
				; io_write_binary #hero_XPos #1
				; jmi sgstf_e
				; io_write_binary #hero_YPos #1
				; jmi sgstf_e

				; ; Store hero direction (bit in the game_flags)
				; io_write_binary #game_flags #1
				; jmi sgstf_e
				
				; ; Store the logic state of the game
				; io_write_binary #logic_flags_000 #1
				; jmi sgstf_e
				; io_write_binary #logic_flags_001 #1
				; jmi sgstf_e
				; io_write_binary #logic_flags_002 #1
				; jmi sgstf_e
				; io_write_binary #logic_flags_003 #1
				; jmi sgstf_e
				; io_write_binary #logic_flags_004 #1
				; jmi sgstf_e
				; io_write_binary #logic_flags_005 #1
				; jmi sgstf_e
				; io_write_binary #logic_flags_006 #1
				; jmi sgstf_e
				; io_write_binary #logic_flags_007 #1
				; jmi sgstf_e
				; io_write_binary #logic_flags_008 #1
				; jmi sgstf_e
				; io_write_binary #logic_flags_009 #1
				; jmi sgstf_e
				; io_write_binary #logic_flags_010 #1
				; jmi sgstf_e
				; io_write_binary #logic_flags_011 #1
				; jmi sgstf_e
				; io_write_binary #logic_flags_012 #1
				; jmi sgstf_e
				; io_write_binary #logic_flags_013 #1
				; jmi sgstf_e
				; io_write_binary #hanging_skull_pos #1
				; jmi sgstf_e
				
				; ; Store current map number
				; io_write_binary #game_state.current_map #4
				; jmi sgstf_e
				
				; ; Save process OK
				; jmp sgstf0
	
; sgstf_e			dec save_load_ok
				
; sgstf0			io_close_file
				; enable_antic
				rts
.endp

; Some consts to use with files
;drive_id		dta c"D:"
;map_file_ext	dta c".MAP"
;font_file_ext	dta c".FNT"
;save_state_file	dta c"D:SAVSTATE.RZY",b($9b)

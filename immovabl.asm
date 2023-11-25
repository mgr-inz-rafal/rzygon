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

;	@com.wudsn.ide.asm.mainsourcefile=main.asm

POCKET_COLOR_BCKG		equ $00
POCKET_COLOR_TEXT		equ $0a

; Indicates which part of the pocket
; should be displayed on the screen.
.var		pocket_offset		.byte
.var		pocket_highlight	.byte
.var		bar_blink_counter	.word
.zpvar		item_name			.word
.zpvar 		object 				.word
.zpvar 		current_pocket 		.word
.var		pocket_loaded		.byte

item1_vert			equ $46
item2_vert			equ $46
item3_vert			equ $96
item4_vert			equ $96
item13_hor			equ $b8
item24_hor			equ $40
bar_blink_delay		equ 3600
pocket_move_delay	equ	30

; Looks-up the first free socket in the hero pocket.
; Offset is returned in Y
; X=0 = no free socket
.proc find_free_pocket_socket
				ldx #1
				ldy #0
@				lda POCKET,y
				cmp #0
				beq @+
				iny5
				cpy #$ff
				bne @-
				ldx #0
@				rts
.endp

; Turns "pocket-state" on and off
.proc switch_pocket_state
				lda game_flags
				eor #FLAGS_INPOCKET
				sta game_flags
				rts
.endp

; Builds the pocket filename in the io_buffer
.proc build_pocket_file_name
				ldx #0
@				lda pocket_file,x
				sta io_buffer,x
				inx
				cpx #12
				bne @-
				lda #$9b
				sta io_buffer,x
				rts
.endp

; Builds the pocket font filename in the io_buffer
.proc build_pocket_font_file_name
				ldx #0
@				lda pocket_font,x
				sta io_buffer+$60,x
				inx
				cpx #12
				bne @-
				lda #$9b
				sta io_buffer+$60,x
				rts
.endp

; Shows the pocket background on the screen
.proc show_pocket_background
				lda pocket_loaded
				cmp #1
				beq @+
				build_pocket_file_name
;				load_screen #screen_mem #20*40
				;load_screen #pocket_scr_buf #20*40
				
				inc pocket_loaded
@				
				; Pocket is ready in the pocket_scr_buf - copy it to screen
				build_pocket_font_file_name
				open_object_file
				read_font
				io_close_file
				copy_buffer_to_screen
				invalidate_font
				
				rts
.endp

.proc copy_buffer_to_screen
				ldy #0
				mwa #screen_mem tmp2
				mwa #pocket_scr_buf tmp1
@				lda (tmp1),y
				sta (tmp2),y
				inw tmp1
				inw tmp2
				lda tmp2+1
				cmp #>(screen_mem+800)
				bne @-
				lda tmp2
				cmp #<(screen_mem+800)
				bne @-
				rts											
.endp

; Stores the letter availabe in io_buffer
; in the correct item name slot
.proc store_letter_in_appropriate_name
				lda io_buffer
				ldy item_being_loaded
				cpy #1
				bne @+				
				sta POCKET_NAME_1,x
				rts
@				cpy #2
				bne @+				
				sta POCKET_NAME_2,x
				rts
@				cpy #3
				bne @+				
				sta POCKET_NAME_3,x
				rts
@				sta POCKET_NAME_4,x
				rts
.endp

; Fills item names with $9b which means that
; pocket slot is unused
.proc mark_pocket_names_as_unused
				lda #$9b
				ldy #0
@				sta POCKET_NAME_1,y
				iny
				cpy #84
				bne @-
				rts
.endp

; Shows item names within the pocket
.proc show_pocket_item_names
				print_string #STR_CLEAR_LONG #8 #7 #0
				#if .byte POCKET_NAME_1 <> #$9b
					print_string #POCKET_NAME_1 #9 #7 #0
				#end
				print_string #STR_CLEAR_LONG #10 #2 #0
				#if .byte POCKET_NAME_2 <> #$9b
					print_string #POCKET_NAME_2 #11 #2 #0
				#end
				print_string #STR_CLEAR_LONG #8 #2+10 #0
				#if .byte POCKET_NAME_3 <> #$9b
					print_string #POCKET_NAME_3 #9 #2+10 #0
				#end
				print_string #STR_CLEAR_LONG #10 #7+10 #0
				#if .byte POCKET_NAME_4 <> #$9b
					print_string #POCKET_NAME_4 #11 #7+10 #0
				#end
				
				rts
.endp

; Finds first socket that contains an element
; Order: 2->1
; No need to check further since:
; 1. If pocket empty - appropriate message
;                      will be shown and pocket
;                      view will be closed
; 2. If one item     - we need to start highlighting
;					   at item #2 (!)
; 3. If two or more  items     - we need to start highlighting
;					             at item #1 (!)
.proc find_first_item_to_highlight
				ldy #1
				is_pocket_socket_empty ,
				cpx #1
				bne ffith0 
				mva #1 pocket_highlight
				rts
ffith0			iny
				mva #2 pocket_highlight
				rts
.endp

; Responsible for blinking the currently
; highlighted item.
.proc blink_highlight_bar
				dew bar_blink_counter
				#if .word bar_blink_counter = #0
					highlight_current_item
					mwa #bar_blink_delay bar_blink_counter
				#end
				rts
.endp

; Handles all actions that can happen
; within the pocket.
.proc pocket_main_routine
				lda POCKET
				cmp #0
				beq pmr2
				highlight_current_item
								
pmr2			deal_with_atract
				blink_highlight_bar
				lda POCKET
				cmp #0
				beq pmr4 ; Pocket is empty
				
				lda STICK0
				cmp #13			; Down
				jeq pmr0
				cmp #14			; Up
				jeq pmr1
				
pmr4			lda STRIG0
				cmp #0
				beq pmr6
				jmp pmr2
				
pmr0
				highlight_down
				jmp pmr2

pmr1
				highlight_up
				jmp pmr2

pmr6			set_selected_item_pointer	
				rts
.endp

; Guess what...
.proc iny5
				iny
				iny
				iny
				iny
				iny
				rts
.endp

; Sets the pointer to the item being selected so
; the logic part of the game may behave accordingly.
.proc set_selected_item_pointer
				ldy pocket_offset
				ldx pocket_highlight
				cpx #1
				bne @+
				iny5
				jmp ssip0
@				cpx #3
				bne @+
				iny5
				iny5
				jmp ssip0				
@				cpx #4
				bne @+
				iny5
				iny5
				iny5
				jmp ssip0
@				
ssip0			sty pocket_selection_offset
				rts
.endp

; Check whether the given pocket socket
; is empty (counting from top to bottom
; as the highlight-bar moves)
; X=1 = empty; otherwise occupied
.proc is_pocket_socket_empty(.byte y) .reg
				ldx #1	; Assume empty
				cpy #1
				bne ipse0
				#if .byte POCKET_NAME_2 = #$9b
					dex
				#end
				jmp ipse_X 
ipse0			cpy #2
				bne ipse1
				#if .byte POCKET_NAME_1 = #$9b
					dex
				#end
				jmp ipse_X 				
ipse1			cpy #3
				bne ipse2
				#if .byte POCKET_NAME_3 = #$9b
					dex
				#end				
				jmp ipse_X 
ipse2			#if .byte POCKET_NAME_4 = #$9b
					dex
				#end
ipse_X			rts
.endp

; Refreshes the pocket page
.proc pocket_page_refresh
				synchro
				disable_antic
				show_pocket_items
				show_pocket_item_names
				find_first_item_to_highlight
				enable_antic
				rts
.endp

; Displays next page of the pocket
.proc next_pocket_page
				adb pocket_offset #20
				ldy pocket_offset
				lda POCKET,y
				cmp #0
				beq npp0
				pocket_page_refresh
				rts
npp0			sbb pocket_offset #20
				rts
.endp

; Displays previous page of the pocket
.proc prev_pocket_page
				sbb pocket_offset #20
				pocket_page_refresh
				ldy #4
				sty pocket_highlight
				rts
.endp

; Moves the item highlight bar to the next item
.proc highlight_down
				ldy pocket_highlight
				iny
				cpy #5
				bne hd0
				next_pocket_page
				rts
hd0				is_pocket_socket_empty ,
				cpx #0
				beq hd_x
				show_pocket_item_names
				inc pocket_highlight
				mwa #bar_blink_delay bar_blink_counter
				highlight_current_item
				mva #pocket_move_delay to_be_delayed
				delay
hd_X			rts
.endp

; Moves the item highlight bar to the previous item
.proc highlight_up
				; Generally there's no need to check
				; whether we can move the highlight bar
				; up, except the situation where current
				; highlight equals 2, because this
				; might occur when there is only one
				; item in the pocket, so we shouldn't
				; allow to move the highlight bar up
				; to the empty space.
				ldy pocket_highlight
				cpy #2
				bne hu_1
				ldy #1
				is_pocket_socket_empty ,
				cpx #0
				beq hu_5
hu_1			show_pocket_item_names
				dec pocket_highlight
				lda pocket_highlight
				cmp #0
				bne hu_2
hu_3			lda pocket_offset
				cmp #0
				beq hu_4
				prev_pocket_page
				rts
hu_2			mwa #bar_blink_delay bar_blink_counter
				highlight_current_item
				mva #pocket_move_delay to_be_delayed
				delay
hu_X			rts
hu_4			inc pocket_highlight
				rts
hu_5			lda pocket_offset
				cmp #0
				beq hu_X
				prev_pocket_page
				rts
.endp

; Inverts all chars representing the name
; of appropriate item
.proc highlight_current_item
				lda pocket_highlight
				cmp #1
				bne hci0
				highlight_row #screen_mem+40*2+11
				jmp hci_X
hci0			cmp #2
				bne hci1 
				highlight_row #screen_mem+40*7+8
				jmp hci_X
hci1			cmp #3
				bne hci2
				highlight_row #screen_mem+40*12+8
				jmp hci_X
hci2			highlight_row #screen_mem+40*17+11
hci_X			rts
.endp

; Highlights 21 characters starting at the
; given address (19 = max item name length + 2 for border)
.proc highlight_row(.word addr) .var
.zpvar addr .word
				ldy #0
@				lda (addr),y
				eor #%10000000
				sta (addr),y
				iny
				cpy #21
				bne @-
				rts
.endp

; Shows pocket on the screen
.proc show_pocket_INTERNAL
				lda default_font
				pha
				lda #0
				sta default_font
				disable_antic
				clear_status_bar
				mwa #bar_blink_delay bar_blink_counter
				hide_hero
				switch_pocket_state
				
				show_pocket_background
								
				show_pocket_items
				show_pocket_item_names
				lda POCKET
				cmp #0
				beq sp0 ; Pocket is empty
				find_first_item_to_highlight
				
sp0				enable_antic
				pocket_main_routine
				disable_antic

				show_hero
				enable_antic
				switch_pocket_state
				pla
				sta default_font
				rts
.endp

; Checks if the particular item has been
; selected from the pocket.
; X=0 - not chosen, otherwise X=1
.proc is_chosen_in_pocket_INTERNAL(.word item) .var
.zpvar item .word
				lda pocket_selection_offset
				pha
				ldx #0
@				txa
				tay
				lda (item),y
				ldy pocket_selection_offset
				cmp POCKET,y
				bne icip0
				inc pocket_selection_offset
				inx
				cpx #5
				bne @-
				
				ldx #1
icip1			pla
				sta pocket_selection_offset
				rts
icip0
				ldx #0
				jmp icip1
.endp

; Removes specified item from pocket
; MUST NOT BE USED!
; ... until a way of marking items as used is invented.
; Currently, when map is loaded all items are also loaded
; and drawn on the screen, UNLESS they are in pocket.
; So, if you pick up cheese and then give it to rat
; it will magically reappear in its original location since
; it is no longer in pocket.
; I may fix this in the future.
; 	Note: Fixed :)
.proc remove_from_pocket_INTERNAL(.word item) .var
.var	item .word
				; Look up last item
				find_free_pocket_socket
				dey
				dey
				dey
				dey
				dey
				tya
				pha

				; Find the item (address of the item name is stored in the 'current_pocket' variable)
				is_item_in_pocket item
				
				; Move last item into the recovered place
				pla
				tax
				ldy #0
@				lda POCKET,x
				sta (current_pocket),y
				lda #0
				sta POCKET,x
				inx
				iny
				cpy #5
				bne @-
				
				rts
.endp


POCKET			equ LEVEL_NAME_BUFFER2+22
ONE_USE_NEXT_FREE equ POCKET + 51*5
POCKET_NAME_1	dta b(0),b(0),b(0),b(0),b(0)
				dta b(0),b(0),b(0),b(0),b(0)
				dta b(0),b(0),b(0),b(0),b(0)
				dta b(0),b(0),b(0),b(0),b(0)
				dta b(0) ; Eol
POCKET_NAME_2	dta b(0),b(0),b(0),b(0),b(0)
				dta b(0),b(0),b(0),b(0),b(0)
				dta b(0),b(0),b(0),b(0),b(0)
				dta b(0),b(0),b(0),b(0),b(0)
				dta b(0) ; Eol
POCKET_NAME_3	dta b(0),b(0),b(0),b(0),b(0)
				dta b(0),b(0),b(0),b(0),b(0)
				dta b(0),b(0),b(0),b(0),b(0)
				dta b(0),b(0),b(0),b(0),b(0)
				dta b(0) ; Eol
POCKET_NAME_4	dta b(0),b(0),b(0),b(0),b(0)
				dta b(0),b(0),b(0),b(0),b(0)
				dta b(0),b(0),b(0),b(0),b(0)
				dta b(0),b(0),b(0),b(0),b(0)
				dta b(0) ; Eol
pocket_file		dta c"D:POCKET.SCR"
pocket_font		dta c"D:POCKET.FNT"

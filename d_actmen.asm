;	@com.wudsn.ide.asm.mainsourcefile=main.asm
.var			action_menu_index	.byte

; Clears the action menu on the statusbar
.proc clear_action_menu
				lda game_flags
				eor #FLAGS_IN_ACTMENU
				sta game_flags

				lda #0
				color_action_menu
				
				lda hero_XPos
				sta HPOSP0
				lda item1_tmp_pos
				sta HPOSP1
				lda #%00010001
				sta GPRIOR
				lda #0
				sta SIZEP0
				sta SIZEP1
				sta HITCLR
				dec skip_WSYNC

				mva #20 action_menu_index				
@				print_string #ACT_MENU_CLR #(40/2 - 10/2)-2 action_menu_index #0
				inc action_menu_index
				lda action_menu_index
				cmp #24
				bne @-				
				
				restore_level_name
				rts
.endp

; Fills the sprite covering the action menu
; with value stored in A
.proc color_action_menu
				ldy #192
@				sta pmg_hero,y
				sta pmg_item1,y
				iny
				cpy #192+8*4
				bne @-
				rts
.endp

; Displays the action menu on the statusbar
.proc display_action_menu
;				music_play #MUSIC_MENU_OPEN_CLOSE
				
				lda game_flags
				eor #FLAGS_IN_ACTMENU
				sta game_flags
				
				lda #$ff
				color_action_menu

				store_level_name
				
				mva #20 action_menu_index				
@				print_string #ACT_MENU_BRDR #(40/2 - 10/2)-2 action_menu_index #0
				inc action_menu_index
				lda action_menu_index
				cmp #24
				bne @-
				
				print_string #ACTION_MENU_SLOT_1 #(40/2 - 10/2) #20 #0
				print_string #ACTION_MENU_SLOT_2 #(40/2 - 10/2) #21 #0
				print_string #ACTION_MENU_SLOT_3 #(40/2 - 10/2) #22 #0
				print_string #ACTION_MENU_SLOT_4 #(40/2 - 10/2) #23 #0
				mva #0 current_action_menu_item
				
				inc skip_WSYNC
				mva #50 to_be_delayed
				delay
;				stop_music
				
				rts
.endp

; Highlights or de-highlights currently
; selected action menu item.
; Sets X to 128 if highlighted row is empty, otherwise sets X to non 128
.proc switch_selected_highlight
.zpvar tmp .word				
			ldx current_action_menu_item
			cpx #0
			bne @+
			mwa #screen_mem+40*20+13 tmp
			jmp ssh0
@			cpx #1
			bne @+
			mwa #screen_mem+40*21+13 tmp
			jmp ssh0
@			cpx #2
			bne @+
			mwa #screen_mem+40*22+13 tmp
			jmp ssh0
@			mwa #screen_mem+40*23+13 tmp
ssh0
			ldy #12
@			lda (tmp),y
			eor #%10000000
			sta (tmp),y
			cpy #2
			bne @+ 
			tax
@			dey
			bne @-1
			
			txa
			
			rts
.endp


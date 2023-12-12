;	@com.wudsn.ide.asm.mainsourcefile=main.asm

.zpvar tmp_src, tmp_trg .word


; Propagates single action menu item
.proc propagate_single_action_item
			ldy #0
psai0		lda (tmp_src),y
			cmp #$9b
			sta (tmp_trg),y
			beq @+
			iny
			jmp psai0 
@			rts
.endp

; Handles all logic connected to the action menu
.proc process_action_menu
			switch_selected_highlight
			mva #20 to_be_delayed
			delay
pam0		lda STICK0
			cmp #13
			bne @+
			action_menu_item_down
			jmp pam0 
@			cmp #14
			bne @+
			action_menu_item_up
			
@			lda STRIG0
			cmp #0
			bne pam0
;			music_play #MUSIC_MENU_OPEN_CLOSE
			clear_action_menu
			mva #26 to_be_delayed
			delay
;			stop_music
			
			rts
.endp

.proc action_menu_item_down
;			music_play #MUSIC_MENU_SWITCH
@			lda current_action_menu_item
			cmp #3
			beq @+
			switch_selected_highlight
			inc current_action_menu_item
			switch_selected_highlight
			cpx #128
			beq @-
			mva #40 to_be_delayed
amid0		delay
;			stop_music
			rts
@			switch_selected_highlight
			mva #0 current_action_menu_item
			switch_selected_highlight
			jmp amid0
.endp

.proc action_menu_item_up
;			music_play #MUSIC_MENU_SWITCH
@			lda current_action_menu_item
			cmp #0
			beq @+
			switch_selected_highlight
			dec current_action_menu_item
			switch_selected_highlight
			cpx #128
			beq @-
			mva #40 to_be_delayed
amiu0		delay
;			stop_music
			rts
@			switch_selected_highlight
			mva #3 current_action_menu_item
			switch_selected_highlight
			jmp amiu0
.endp


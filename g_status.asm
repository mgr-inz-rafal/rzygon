;	@com.wudsn.ide.asm.mainsourcefile=main.asm

; Writes the item name on the footer
; and stores the item ID
.proc write_item_name(.byte y) .reg
.zpvar tmp .word
				cpy #1
				bne win1
				mwa #ITEM_1_ID tmp
				jsr win4
				mwa #(ITEM_1_DATA+1) tmp
				jmp win0				
win1			cpy #2
				bne win2
				mwa #ITEM_2_ID tmp
				jsr win4
				mwa #(ITEM_2_DATA+1) tmp
				jmp win0
win2			cpy #3
				bne win3
				mwa #ITEM_3_ID tmp
				jsr win4
				mwa #(ITEM_3_DATA+1) tmp
				jmp win0
win3			mwa #ITEM_4_ID tmp
				jsr win4
				mwa #(ITEM_4_DATA+1) tmp
win0
				print_string tmp, #1, #21, #0
				rts
win4
				ldy #0
@				lda (tmp),y
				sta ITEM_CONTACT,y
				iny
				cpy #5
				bne @-
				rts
.endp

; Draws the frame of the status message
.proc show_status_border
				print_string #STATUS_MSG_BR1 #0 #20 #0
				print_string #STATUS_MSG_BR2 #0 #23 #0
				mwa #$5d5b screen_mem+40*21
				mwa #$5d5b screen_mem+40*22
				mwa #$5c5d screen_mem+40*21+38
				mwa #$5c5d screen_mem+40*22+38
				rts
.endp

; Clears the statusbar ares
.proc clear_status_bar
				ldy #0
				lda #0
@				sta screen_mem+40*20,y
				iny
				cpy #40*4
				bne @-				
				rts
.endp


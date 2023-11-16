;	@com.wudsn.ide.asm.mainsourcefile=main.asm

; Puts the item that is currently in contact
; in the hero socket and removes the
; appropriate sprite from the screen.
.proc			pick_up_item

				; Put into pocket.
				ldx #0
@				lda ITEM_CONTACT,x
				sta POCKET,y
				inx
				iny
				cpx #5
				bne @-
				
				; Remove from screen.
				lda #0
				ldy ITEM_CONTACT_S
				cpy #1
				bne @+
				lda #0
				sta item1_tmp_pos
@				cpy #4
				beq @+
				sta HPOSP0,Y
				rts
@
				; Remove fifth player
				sta HPOSM0
				sta HPOSM1
				sta HPOSM2
				sta HPOSM3
				
				rts
.endp


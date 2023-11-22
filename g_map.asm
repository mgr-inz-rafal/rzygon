;	@com.wudsn.ide.asm.mainsourcefile=main.asm

; Used to copy buffers
.zpvar tmp1, tmp2 .word

; Converts the hero position to screen position
; using the following formula:
;   Xscreen = INT((Xhero-$30)/4)
;	Yscreen = INT((Yhero-$20)/8)
; Values are returned via X and Y register
.proc hero_pos_to_screen_pos
				lda hero_XPos
				sub #$30
				lsr
				lsr
				tax
				lda hero_Ypos
				sub #$20
				lsr
				lsr
				lsr
				tay
				rts
.endp

; Converts the hero vertical hero position to screen position
; using the following formula:
;	Yscreen = INT((Yhero-$20)/8)
; Value is returned in Y register
; Note: Y=1 means that hero is going up, therefor we need
;       to subtract height of the one less char
.proc hero_vpos_to_screen_pos(.byte y) .reg
				lda hero_Ypos
				cpx #1
				bne @+
				sub #$20-6
				jmp hvtsp0
@				sub #$20
hvtsp0			lsr
				lsr
				lsr
				tay
				rts
.endp

; Converts the hero horizontal hero position to screen position
; using the following formula:
;	Xscreen = INT((Xhero-$30)/4)
; Value is returned in Y register
.proc hero_hpos_to_screen_pos
				lda hero_XPos
				sub #$30
				lsr
				lsr
				tay
				rts
.endp

; Converts the horizontal hero position to
; screen position and providing the
; char-alignment information
; XPos is returned in X
; Division remainder in A (if 0 then sprite and chars are aligned)
.proc hero_hpos_to_screen_pos_with_remainder
				lda hero_XPos
				sub #$30
				ldx #4
				divByte @ , ,
				rts
.endp

; Converts the vertical hero position to
; screen position and providing the
; char-alignment information
; YPos is returned in X
; Division remainder in A (if 0 then sprite and chars are aligned)
.proc hero_vpos_to_screen_pos_with_remainder
				lda hero_YPos
				sub #$20
				ldx #8
				divByte @ , ,
				rts
.endp

; Checks if char in A is already on the transparent
; chars list. If yes X=1
.proc is_on_transchar_list_already
				sta tmp_transchar
				ldy #$ff
iotla0			iny
				cpy TRANSCHAR_COUNT
				beq @+1
				lda TRANSCHARS,y
				cmp tmp_transchar
				beq @+
				jmp iotla0 
@				ldx #1		; Found it
				rts
@				ldx #0		; Reached the end of the list and didn't find
				rts
.endp

; Puts the specified chars in the "transparent chars" table.
.proc add_to_transparent_chars(.word from_where .byte how_much) .var
.zpvar	from_where	.word
.var	how_much	.byte
				txa
				pha

				ldy #0
@				lda (from_where),y
				tax
				tya
				pha
				
				txa
				add_single_char_to_transparent_chars
								
				pla
				tay
				iny
				cpy how_much
				bne @-
				
				pla
				tax
				
				rts
.endp


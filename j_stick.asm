;	@com.wudsn.ide.asm.mainsourcefile=main.asm

.var was_one .byte

; Waits until FIRE on stick 'a' is pressed
.proc			wait_for_fire
				lda #0
				sta was_one
flaki			deal_with_atract
				ldx STRIG0
				cpx #1
				beq golonka
				lda was_one
				cmp #1
				bne flaki 
				rts
.endp
golonka
				ldx #1
				stx was_one
				jmp wait_for_fire.flaki

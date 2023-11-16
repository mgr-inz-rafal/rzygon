;	@com.wudsn.ide.asm.mainsourcefile=main.asm

; Waits until FIRE on stick 'a' is pressed
.proc			wait_for_fire(.byte a) .reg
				deal_with_atract
				cmp #0
				bne wff0
				ldx STRIG0
				jmp wff1 
wff0			ldx STRIG1
wff1			cpx #0
				bne wait_for_fire
				rts
.endp
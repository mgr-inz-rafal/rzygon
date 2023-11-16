;	@com.wudsn.ide.asm.mainsourcefile=main.asm

; Stores the original colors for strobo effect
.var	col1, col2					.byte
.var	time_to_strobo				.byte
.var	strobo_counter				.byte
.var	strobo_is_dark				.byte

; Prepares to display the strobo effect
.proc setup_strobo
				lda COLOR1
				sta col1
				lda COLOR2
				sta col2
				
				lda #0
				sta strobo_counter
				sta strobo_is_dark

				setup_time_to_strobo				

				rts
.endp

; Prepares to display the lightning effect
.proc setup_lightning
				setup_strobo
				rts				
.endp

; Sets up the correct time of strobo phase
; dark=long, bright=short
.proc setup_time_to_strobo
				lda strobo_is_dark
				cmp #1
				bne @+
				clc
				lda RANDOM
				and #%00000111
				tax
				lda #30
stts2			cpx #0
				beq stts1
				adc #15
				dex
				jmp stts2 
@				lda #5			
stts1			sta time_to_strobo
				rts
.endp

; Implements the lightning effect
.proc process_lightning
				lda game_flags
				and #FLAGS_LIGHTNING
				cmp #FLAGS_LIGHTNING
				bne @+
				
				ldx strobo_counter
				inx
				stx strobo_counter
				cpx time_to_strobo
				bne @+
				
				ldy #0
				sty strobo_counter
				setup_time_to_strobo
				ldx strobo_is_dark
				inx
				stx strobo_is_dark
				cpx #2
				bne pl2
				lda #0
				sta strobo_is_dark
				
pl2				lda strobo_is_dark
				cmp #0
				bne pl1
				lda #000
				sta COLOR1
				lda #004
				sta COLOR2
				jmp pl_X	
pl1
				lda #$00
				sta COLOR1
				lda #$ff
				sta COLOR2			
pl_X
@				rts
.endp

; Implements the stroboscope effect
.proc process_strobo
				lda game_flags
				and #FLAGS_STROBO
				cmp #FLAGS_STROBO
				bne @+
				
				ldx strobo_counter
				inx
				stx strobo_counter
				cpx time_to_strobo
				bne @+
				
				ldy #0
				sty strobo_counter
				setup_time_to_strobo
				ldx strobo_is_dark
				inx
				stx strobo_is_dark
				cpx #2
				bne ps2
				lda #0
				sta strobo_is_dark
				
ps2				lda strobo_is_dark
				cmp #0
				bne ps1
				lda #$00
				sta COLOR1
				sta COLOR2
				jmp ps_X	
ps1
				lda col1
				sta COLOR1
				lda col2
				sta COLOR2			
ps_X
@				rts
.endp


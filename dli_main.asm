;	@com.wudsn.ide.asm.mainsourcefile=main.asm

.var skip_WSYNC .byte
.var sky_color	.byte

; Init DLI
.proc dli_init
				dli_switch_from_adventure_message
				lda #192
				sta NMIEN
				rts
.endp

.proc dli_switch_to_adventure_message
				lda <dli_routine_adv
				sta VDSLST
				lda >dli_routine_adv
				sta VDSLST+1
				rts
.endp

.proc dli_switch_to_title_screen
				lda <dli_routine_title
				sta VDSLST
				lda >dli_routine_title
				sta VDSLST+1
				rts
.endp

.proc dli_switch_from_adventure_message
				lda <dli_routine
				sta VDSLST
				lda >dli_routine
				sta VDSLST+1
				rts
.endp

dli_routine_title
				phr
				lda VCOUNT
				cmp #$07
				bne @+
				
				; Color for the picture
				lda adv_color_1
				ldx sky_color
				ldy adv_color_3
				sta COLPF0
				stx COLPF1
				sty COLPF2
				jmp dli_routine_title_x
				
@				; Set text colors
				cmp #$37
				bne dli_routine_title_x
				lda #TITLE_COLOR_BCKG
				ldx #TITLE_COLOR_TEXT
				sta WSYNC
				sta COLPF2
				stx COLPF1
					
dli_routine_title_x
				plr				
				rti
				
dli_routine_adv
				phr
				lda VCOUNT
				cmp #$07
				bne @+
				
				; Color for the picture
				lda adv_color_1
				ldx adv_color_2
				ldy adv_color_3
;				lda #$07
;				ldx #$FB
;				ldy #$07
				sta COLPF0
				stx COLPF1
				sty COLPF2
				jmp dli_routine_adv_x
				
@				; Set text colors
				cmp #$37
				bne dli_routine_adv_x
				lda #ADVMSG_COLOR_BCKG
				ldx #ADVMSG_COLOR_TEXT
				sta WSYNC
				sta COLPF2
				stx COLPF1
				
dli_routine_adv_x
				plr				
				rti

dli_routine
				phr
				
;;----------------------------------------------- @footer				
				lda VCOUNT
				cmp #$5b
				bne dli_0

				; Change footer color
				ldy #>text_font 
@				ldx #COLOR_FOOTER_FONT
				sta WSYNC
				sta WSYNC
				sta WSYNC
				sta WSYNC
				sta WSYNC
				sta WSYNC
				sta WSYNC

				; Well... enough WSYNCing.
				; Check if we should cover action menu with sprite
				lda skip_WSYNC
				beq @+
				lda #100
				sta HPOSP0
				lda #100+8*3
				sta HPOSP1
				lda #%00011000
				sta GPRIOR
				lda #3
				sta SIZEP0
				sta SIZEP1
				lda #147
				sta COLPM0
				sta COLPM1

				; Thank you. Now get back to WSYNCing :)
@				sta WSYNC
				lda #COLOR_FOOTER_BCKG
				sta COLPF2
				stx COLPF1
				
				; Change font to display text
				sty CHBASE

				
@				
				jmp dli_1
				
;;----------------------------------------------- @exit_footer				
				
dli_0
;;----------------------------------------------- @top				
				lda VCOUNT
				cmp #$07
				bne dli_1
				
				; Change font to display level
				lda default_font
				cmp #0
				bne @+
				lda #>level_font
				jmp dli_666
@				lda #224				
dli_666			sta CHBASE

				; Clear the sprite covering action menu
				lda game_flags
				and #FLAGS_IN_ACTMENU
				cmp #FLAGS_IN_ACTMENU
				bne dli_2
				lda hero_XPos
				sta HPOSP0
				lda item1_tmp_pos
				sta HPOSP1
				lda #%00010001
				sta GPRIOR
				lda #0
				sta SIZEP0
				sta SIZEP1
								
dli_2
				; If in pocket, change colors appropriately
				lda game_flags
				and #FLAGS_INPOCKET
				cmp #FLAGS_INPOCKET
				bne dli_3
				lda #POCKET_COLOR_TEXT
				ldx #POCKET_COLOR_BCKG
				sta WSYNC
				sta COLOR1
				stx COLOR2
dli_3
				
dli_1			plr				
				rti
;;----------------------------------------------- @exit_top				
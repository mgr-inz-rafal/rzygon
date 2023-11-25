;	@com.wudsn.ide.asm.mainsourcefile=main.asm

.var			loopind			.byte
.var			thunder_timer	.byte
.var			tmp_char		.byte
.var			any_flipped		.byte
.var			tmp_from_page	.word
.var			tmp_to_page		.word
.var			anim_state		.byte
.var			flip_timer		.byte
.var			odbytnica		.byte

.zpvar			from_page		.word
.zpvar			to_page			.word

TP_FLIPCHARS		equ	0
TP_WAIT				equ 1
TP_READY			equ 2

TP_WAITTIME			equ $01

TP_PAGESIZE			equ TITLEPAGE_01-TITLEPAGE_00
TP_ROWSIZE			equ 34
TP_ROWCOUNT			equ 10

.proc draw_border
				; Draw border
				print_string #TITLE_01 #0 #40 #0
				print_string #TITLE_02 #0 #51 #0
				lda #41
				sta loopind
@				print_string #TITLE_03 #0 loopind #0
				inc loopind
				lda loopind
				cmp #51
				bne @-
				rts
.endp

.proc	title_display_list
		; Configure display list
		dli_switch_to_title_screen
		ldx <dl_adventure_message
		ldy >dl_adventure_message
		stx SDLSTL
		sty SDLSTL+1	
		rts
.endp

.proc show_predefined_adventure(.byte odbytnica) .var
				disable_antic
				ldy #0
				lda (show_adventure_message_INTERNAL.id),y
				pha
				lda #'0'
				sta (show_adventure_message_INTERNAL.id),y
				iny
				lda (show_adventure_message_INTERNAL.id),y
				pha
				lda #'0'
				sta (show_adventure_message_INTERNAL.id),y
				iny
				lda (show_adventure_message_INTERNAL.id),y
				pha
				lda odbytnica
				sta (show_adventure_message_INTERNAL.id),y
				display_adventure_picture
				
				enable_antic
				ldy #2
				pla
				sta (show_adventure_message_INTERNAL.id),y
				dey
				pla
				sta (show_adventure_message_INTERNAL.id),y
				dey
				pla
				sta (show_adventure_message_INTERNAL.id),y				
		rts
.endp

.proc	legal_disclaimer
				title_display_list
				show_predefined_adventure #'1'
								
				draw_border
				print_string #DISCLAIMER_00 #3 #41 #0				
				print_string #DISCLAIMER_01 #3 #42 #0				
				print_string #DISCLAIMER_02 #3 #43 #0				
				print_string #DISCLAIMER_03 #3 #44 #0				
				print_string #DISCLAIMER_04 #3 #45 #0				
				print_string #DISCLAIMER_05 #3 #46 #0				
				print_string #DISCLAIMER_06 #3 #47 #0				
				print_string #DISCLAIMER_07 #3 #48 #0				
				print_string #DISCLAIMER_08 #3 #49 #0				
				print_string #DISCLAIMER_09 #3 #50 #0				

disc0			lda STRIG0
				sta ATRACT
				cmp #0
				beq disclaimer_exit
				lda STRIG1
				cmp #0
				beq disclaimer_exit
				jmp disc0

disclaimer_exit
				disable_antic
				mva #50 to_be_delayed
				delay
				enable_antic
				rts
.endp

; Takes care of setting up and
; displaying title screen
.proc			title_screen

				lda #TP_FLIPCHARS
				sta anim_state

				lda #$81
				sta sky_color
				
				lda RANDOM
				sta thunder_timer
				
				mva #TP_WAITTIME flip_timer

				title_display_list
								
				; Hide sprites
				lda #0
				sta HPOSP0
				sta HPOSP1
				sta HPOSP2
				sta HPOSP3
				sta HPOSM0
				sta HPOSM1
				sta HPOSM2
				sta HPOSM3
				
				show_predefined_adventure #'0'

				music_init #$0
				music_play
				
				draw_border
				
				; Address of the page to be animated
				mwa #$2a6b from_page
				mwa #TITLEPAGE_00 to_page
				
title_loop		; Main title loop
				do_thunder
				do_page_animation
				lda STRIG0
				sta ATRACT
				cmp #0
				beq title_exit
				lda STRIG1
				cmp #0
				beq title_exit
				lda STICK0
				cmp #7
				bne title_00
				lda anim_state
				cmp #TP_READY
				bne @+
				next_page
@				jmp title_loop
title_00		cmp #11
				bne title_loop
				lda anim_state
				cmp #TP_READY
				bne @+
				prev_page
@				jmp title_loop
title_exit		
				stop_music
				rts
.endp

.proc flip_chars
				ldx #0
				stx any_flipped
np2				ldy #0
np0				lda (from_page),y
				sta tmp_char
				lda (to_page),y
				cmp tmp_char	; Char ready?
				beq np3 ; Y - skip
				inc tmp_char ; N - Increase
				lda tmp_char
				cmp #128
				bne np4
				lda #0
np4				sta (from_page),y
				lda #1
				sta any_flipped
np3				iny
				cpy #TP_ROWSIZE	; Finished row?
				beq np1
				jmp np0 ; Continue row
np1				adw from_page #40
				adw to_page #TP_ROWSIZE
				inx
				cpx #TP_ROWCOUNT
				bne np2
				rts
.endp

.proc next_page
				#if .word to_page <> #TITLEPAGE_LAST
					adw to_page #TP_PAGESIZE
					lda #TP_FLIPCHARS
					sta anim_state
				#end
				rts
.endp

.proc prev_page
				#if .word to_page <> #TITLEPAGE_00
					sbw to_page #TP_PAGESIZE
					lda #TP_FLIPCHARS
					sta anim_state
				#end
				rts
.endp

.proc do_page_animation
				lda anim_state
				cmp #TP_FLIPCHARS
				bne @+
				mwa from_page tmp_from_page
				mwa to_page tmp_to_page
				flip_chars
				mwa tmp_from_page from_page 
				mwa tmp_to_page to_page
				lda any_flipped
				cmp #0
				beq dpa_1
				lda #TP_WAIT
				sta anim_state
				mva #TP_WAITTIME flip_timer
				rts
@				cmp #TP_WAIT
				bne @+
				dec flip_timer
				#if .byte flip_timer = #0
					lda #TP_FLIPCHARS
					sta anim_state
					mwa #$2a6b from_page
				#end
dpa_x
@				rts
dpa_1
				lda #TP_READY
				sta anim_state
				rts
.endp

.proc do_thunder
				dec thunder_timer
				#if .byte thunder_timer = #0
					lda RANDOM
					sta thunder_timer
					lda #$81
					sta sky_color
					rts
				#end
				#if .byte thunder_timer < #4
					lda #$ff
					sta sky_color
					rts
				#end
				rts
.endp
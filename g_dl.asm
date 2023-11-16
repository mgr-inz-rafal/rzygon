;	@com.wudsn.ide.asm.mainsourcefile=main.asm

; Activates the currently loaded Display List
.proc			activate_display_list

				ldx <display_list
				ldy >display_list
				stx SDLSTL
				sty SDLSTL+1
				
				rts
.endp

; Loads the specific Display List
.proc			set_display_list(.word dl_name .byte dl_len) .var
.zpvar			dl_name .word
.var			dl_len	.byte

				dec dl_len
				ldy #$ff
sdl_0			iny
				lda (dl_name),y
				sta display_list,y
				dec	dl_len
				bpl sdl_0
				
				rts 
.endp

; Display List used for Adventure Message
dl_adventure_message
				dta b(%11110000)			; DLI - begin
				dta b(%01110000)
				dta b(%01110000)
				dta b(%01001101)
				dta a(screen_mem)			; screen memory
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%00001101)
				dta b(%10001101)			; DLI - text
				dta b(%00010000)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b($41),a(dl_adventure_message)
dl_adventure_message_len	equ *-dl_adventure_message

; Display List used for Main Game Screen
dl_game_screen
				dta b(%11110000)		; DLI - begin
				dta b(%01110000)
				dta b(%01110000)
				dta b(%01000010)
				dta a(screen_mem)		; screen memory
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)			
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%10000010)		; DLI - footer
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b(%00000010)
				dta b($41),a(dl_game_screen)
dl_game_screen_len	equ *-dl_game_screen
; Display List used for initialization


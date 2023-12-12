;	@com.wudsn.ide.asm.mainsourcefile=main.asm

; Temporary for screen calculations.
.zpvar Xpos, Ypos			.byte

; Returns the screen character that is
; located at the given coordinates (X=x, A=y)
; Value is returned in A
.proc on_screen(.byte x,a) .reg
				mwy #screen_mem screen_tmp
				tay
ps_3			cpy #0
				beq @+
				adw screen_tmp #40
				dey
				jmp ps_3  

@				stx Xpos
				clc
				lda screen_tmp
				adc Xpos
				sta screen_tmp
				lda screen_tmp+1
				adc #0
				sta screen_tmp+1

/*				
				lda #65
				ldy #0
				sta (screen_tmp),y				
				wait
				lda #0
				ldy #0
				sta (screen_tmp),y
*/
				 
				ldy #0
				lda (screen_tmp),y
				
				rts
.endp

; Returns what is on screen using the
; address previously calculated by on_screen().
; It accepts offset in Y, so we can for example
; calculate the address based on player position
; only once and then check several adjoining chars.
.proc on_screen_reuse(.byte y) .reg
;				lda #65
;				sta (screen_tmp),y

				lda (screen_tmp),y
				rts
.endp

; Displays the map chunk loaded into I/O buffer
; Map chunk has the following format:
; AAA,BBB,CCC,DDD,XXX...
; 	AAA		= X position of the chunk
;	BBB		= Y position of the chunk
;	CCC		= Length of the chunk segment
;	DDD		= Number of repetitions of the chunk segment
;	XXX...	= Chunk segment itself
; .proc display_map_chunk
; .zpvar len,rep .byte
; 				mva io_buffer Xpos
; 				mva io_buffer+1 Ypos
; 				mva io_buffer+2 len
; 				mva io_buffer+3 rep
				
; 				ldy rep
; dmc0			tya
; 				pha
; 				print_string #io_buffer+4 Xpos Ypos #0
; 				pla
; 				tay
; 				lda Xpos
; 				add len
; 				sta Xpos
; 				dey
; 				cpy #0
; 				bne dmc0 
				
; 				rts
; .endp

; Displays level name
; Level name is stored in the io_buffer
.proc display_level_name
.var tmp_adr .word
			mwa #LVLNAME_BORDER tmp_adr

			; 1. Calculate xpos of the string based on the level name length
			lda #41
			sta Xpos
			ldy #$ff
@			iny
			dec Xpos
			dew tmp_adr
			lda io_buffer_cart,y
			cmp #$9b
			bne @-
			
			print_string #io_buffer_cart Xpos #23 #0
			
			; 2. Display the correctly trimmed name border
			print_string #LVLNAME_BRD_COR Xpos #22 #0
			inc Xpos
			print_string tmp_adr Xpos #22 #0
			
			rts
.endp

; ; Displays the map object
; .proc display_map_object(.byte xsize, xpos, ypos, yoffset) .var
; .zpvar xsize, xpos, ypos	.byte
; .zpvar yoffset				.word
; 				mwa #screen_mem screen_tmp
; 				lda ypos
; 				add yoffset
; 				tay
; ps_3			cpy #0
; 				beq ps_2
; 				adw screen_tmp #40
; 				dey
; 				jmp ps_3  

; ps_2			clc
; 				lda screen_tmp
; 				adc xpos
; 				sta screen_tmp
; 				lda screen_tmp+1
; 				adc #0
; 				sta screen_tmp+1

; 				ldy #0
; 				#while .byte xsize > #0
; 					lda io_buffer+$60,y
; 					sta (screen_tmp),y
; 					iny
; 					dec xsize
; 				#end
				
; 				rts
; .endp

; 800 bytes for fast switching back to
; the game map.
; -> Will use the bytes spared by introducing one_use.asm.
/*
SCREEN_BUFFER
				dta c"                                        "
				dta c"                                        "
				dta c"                                        "
				dta c"                                        "
				dta c"                                        "
				dta c"                                        "
				dta c"                                        "
				dta c"                                        "
				dta c"                                        "
				dta c"                                        "
				dta c"                                        "
				dta c"                                        "
				dta c"                                        "
				dta c"                                        "
				dta c"                                        "
				dta c"                                        "
				dta c"                                        "
				dta c"                                        "
				dta c"                                        "
				dta c"                                        "
*/
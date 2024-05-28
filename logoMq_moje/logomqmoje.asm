pmg_base	equ $8000
font_base	equ $8000
screen_mem	equ $51f0

	org VIDEO_RAM_ADDRESS
	ins "logo.data"

			icl '../atari.inc'
			org	$2c20

			lda #0
			sta COLOR1 ; Logo
			sta COLOR2

			ldx <dl_start
			ldy >dl_start
			stx SDLSTL
			sty SDLSTL+1			

			lda #$ff
zupa
			inc 1536
			lda 1536
			sta COLOR1
			ldx #107
@			jsr WAIT
			dex
			cpx #0
			bne @-
			#if .byte 1536 < #12
				jmp zupa
			#end

			ldx #<MODUL
			ldy #>MODUL
			lda #0
			jsr RASTERMUSICTRACKER	;Init
			ldy <vbi_routine
			ldx >vbi_routine
			lda #7
			jsr SETVBV

			ldx #16
@			ldy #0
deser
			jsr WAIT
			iny
			cpy #$0
			bne deser

			dex
			cpx #0
			bne @-


			lda #$13
drugie_danie
			dec 1536
			lda 1536
			sta COLOR1
			ldx #107
@			jsr WAIT
			dex
			cpx #0
			bne @-
			#if .byte 1536 > #0
				jmp drugie_danie
			#end

			rts

wait
		lda PAL
		cmp #1
		beq syn_pal
saas112
		#if .byte VCOUNT >= #117
			rts
		#end
		jmp saas112
		rts
syn_pal
		#if .byte VCOUNT >= #150
			rts
		#end
		jmp syn_pal
		rts

vbi_routine
		jsr RASTERMUSICTRACKER+3	;Play
		jsr RASTERMUSICTRACKER+3	;Play
		jsr RASTERMUSICTRACKER+3	;Play
		jmp XITVBV

VIDEO_RAM_ADDRESS equ $51f0

; Here is place for your custom display list definition.
; Handy constants are defined first:
   
; It's always useful to include you program global constants here
;    icl 'const.inc'

; and declare display list itself

; example (BASIC mode 0 + display list interrupt at top):
dl_start
    dta %01110000 ;+ DL_DLI  ; 8 blank lines and display list interrupt call
:7 dta %01110000        ; 16 blank lines
    dta $F + %01000000, a(VIDEO_RAM_ADDRESS) ; first text line
:79 dta $F ; remaining 23 lines
    
    dta DL_JVB, a(dl_start) ; jump to start

; RMT player
	icl "rmtplayr.a65"
; RMT module

PLAYER_FINISHES_HERE

	opt h-						;RMT module is standard Atari binary file already
	ins "song.rmt"				;include music RMT module
	opt h+
MODUL equ $4A1E

 		
	org $02e0
	dta a($2c20)

pmg_base	equ $8000
font_base	equ $8000
screen_mem	equ $51f0

	org VIDEO_RAM_ADDRESS
	ins "logo.data"

			icl '../atari.inc'
			org	$2c20

			ldx #<MODUL
			ldy #>MODUL
			lda #0
			jsr RASTERMUSICTRACKER	;Init
			ldy <vbi_routine
			ldx >vbi_routine
			lda #7
			jsr SETVBV

			ldx <dl_start
			ldy >dl_start
			stx SDLSTL
			sty SDLSTL+1			


chuj		jmp chuj

vbi_routine
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

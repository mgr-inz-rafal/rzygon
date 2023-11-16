				org $2000

.zpvar			c1		.byte
.zpvar			c2		.byte

				icl 'atari.inc'
				

				jsr VBXE_Detect
				
				#if .byte detected_vbxe = #1
					lda #0
					sta VBXE_base
					lda detected_vbxe_page
					sta VBXE_base+1
					
					lda #2
					ldy #$40
					sta (VBXE_base),y		
				#end

				lda #0
				sta c1
				lda #$ff
				sta c2

				putline	#init_text_00
				putline	#init_text_01
				putline	#init_text_02
				
chuj			
				lda	STRIG0
				cmp #0
				bne @+
				display_colors

@				lda STICK0
				; 11 - left
				; 7  - right
				; 14 - up
				; 13 - down
				cmp #11
				bne @+
				dec c1
				apply_color
				jmp chuj
@				cmp #7
				bne @+
				inc c1
				apply_color
				jmp chuj
@				cmp #14
				bne @+
				dec c2
				apply_color
				jmp chuj
@				cmp #13
				bne @+
				inc c2
				apply_color
@				jmp chuj

.proc apply_color
				lda c1
				sta COLOR1
				lda c2
				sta COLOR2
				delay
				rts
.endp

.proc display_colors
				putline	#init_text_03
				lda c1
				display_byte
				putline	#init_text_04
				lda c2
				display_byte
				putchar #$9b
				rts
.endp

.proc putline (.word ya) .reg
				ldx #$00
				sta ICBAL,x
				tya
				sta ICBAL+1,x
				mwa	#$ff ICBLL,x
				mva	#$09 ICCOM,x
				jmp CIOV
				rts
.endp

init_text_00	.by 'VBXE color picker' $9b		
init_text_01	.by 'L/R - change text' $9b		
init_text_02	.by 'U/D - change background' $9b		
init_text_03	.by 'TEXT:    WWWWWWWWWWWWWWWWWWWWW' $9b		
init_text_04	.by 'BCKG:    XXXXXXXXXXXXXXXXXXXXX' $9b		


;--------------------------------------------------------
;VBXE_Detect - detects VBXE FX core version 1.07 and above,
; and stores VBXE Base address in VBXEBase
VBXE_Detect	.local
	lda	#0
	ldx	#0xd6
	sta	0xd640			; make sure it isn't coincidence
	lda	0xd640
	cmp	#0x10			; do we have major version here?
	beq	VBXE_FX_Detected	; if so, then VBXE FX core is detected
	lda	#0
	inx
	sta	0xd740			; no such luck, try other location
	lda	0xd740
	cmp	#0x10
	beq	VBXE_FX_Detected
	ldx #0  			; not here, so not present or FX core version too low
	stx	detected_vbxe_page
	stx detected_vbxe
	sec
	rts
VBXE_FX_Detected:
	stx	detected_vbxe_page
	lda	#0
	vblda VBXE_MINOR
	and	#0x70			; disregard if this is A or R core version
	cmp	#(REVISION & 0x70)	; check if core revision is compatible with the software
	beq	VBXE_Detected
	lda #0
	sta detected_vbxe
	sec
	rts
VBXE_Detected:
	stx	detected_vbxe_page
	lda #1
	sta detected_vbxe
	clc	 			; x - page of vbxe

	lda $800		//hidden part
	cmp #'x'
	bne eend
	lda $801
	cmp #'B'
	bne eend
	lda #1
	sta $80
eend
	rts

	;--------------------------------------------------------
;vblda	- loads accumulator with VBXE register value
;	  use:	vblda	VBXE_REGISTER

vblda	.macro
.ifdef	__VBXE_AUTO__
	lda	detected_vbxe_page
	sta	vblda_adr
	lda.w	:1
vblda_adr	equ *-1
.else
	lda	:1
.endif
.endm

;--------------------------------------------------------
;vbsta	- stores accumulator in VBXE register
;	  use:	vbsta	VBXE_REGISTER

vbsta	.macro
.ifdef	__VBXE_AUTO__
	pha
	lda	detected_vbxe_page
	sta	vbsta_adr
	pla
	sta.w	:1
vbsta_adr	equ *-1
.else
	sta.w	:1
.endif
.endm

.def	__VBXE_AUTO__
.def	REVISION	=	0x20

.if .not .def __VBXE_AUTO__ .and .not .def __VBXE_D700__	; default case - vbxe at 0xd640
VBXE_BASE		equ	0xd600
.elseif .not .def __VBXE_AUTO__ .and def __VBXE_D700__		; vbxe is assumed to be under 0xd740
VBXE_BASE		equ	0xd700
.else								; vbxe should be autodetected
VBXE_BASE		equ	0x0000
.endif

VBXE_MAJOR		equ	VBXE_BASE+0x40
VBXE_MINOR		equ	VBXE_BASE+0x41

	
.endl	

detected_vbxe				dta b(0)
detected_vbxe_page			dta b(0)
.zpvar		VBXE_base			.word


TAB_HEXCHARS	dta c"0123456789ABCDEF"

.proc display_byte
				pha
				lda #'$'
				putchar @
				pla
				pha
				and #%11110000
				lsr
				lsr
				lsr
				lsr
				tay
				txa
				lda TAB_HEXCHARS,y
				putchar @
				pla
				and #%00001111
				tay
				lda TAB_HEXCHARS,y
				putchar @
				lda #$9b
				putchar @
				rts
.endp

.proc putchar (.byte a) .reg
putchar	ldx #$00
				tay
				lda ICPTL+1,x
				pha
				lda ICPTL,x
				pha
				tya
				rts
.endp
.proc delay
				synchro
				synchro
				synchro
				synchro
				synchro
				synchro
				synchro
				synchro
				rts
.endp
.proc synchro
				lda COLPM2
				cmp #1
				bne synchr1
				; PAL
				lda #$90
				jmp synchr2
synchr1 		; NTSC
				lda #$7c
synchr2			cmp VCOUNT
				bne synchr2
				rts
.endp

				end

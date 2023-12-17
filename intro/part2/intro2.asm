/***************************************/
/*  Use MADS http://mads.atari8.info/  */
/*  Mode: DLI (char mode)              */
/***************************************/

APPEND	= $01		;open write append (D:)
DIRECT	= $02		;open for directory access (D:)
OPNIN	= $04		;open for input (all devices)
OPNOT	= $08		;open for output (all devices)
MXDMOD	= $10		;open for mixed mode (E:, S:)
INSCLR	= $20		;open for input without clearing screen
IOCB	= $0340		;I/O CONTROL BLOCKS
ICHID	= $0340		;HANDLER INDEX NUMBER (FF=IOCB FREE)
ICDNO	= $0341		;DEVICE NUMBER (DRIVE NUMBER)
ICCOM	= $0342		;COMMAND CODE
ICSTA	= $0343		;STATUS OF LAST IOCB ACTION
ICBAL	= $0344		;1-byte low buffer address
ICBAH	= $0345		;1-byte high buffer address
ICPTL	= $0346		;1-byte low PUT-BYTE routine address - 1
ICPTH	= $0347		;1-byte high PUT-BYTE routine address - 1
ICBLL	= $0348		;1-byte low buffer length
ICBLH	= $0349		;1-byte high buffer length
ICAX1	= $034A		;1-byte first auxiliary information
ICAX2	= $034B		;1-byte second auxiliary information
ICAX3	= $034C		;1-byte third auxiliary information
ICAX4	= $034D		;1-byte fourth auxiliary information
ICAX5	= $034E		;1-byte fifth auxiliary information
ICSPR	= $034F		;SPARE BYTE
DISKIV	= $E450		;vector to initialize DIO
DSKINV	= $E453		;vector to DIO
CIOV	= $E456		;vector to CIO
SIOV	= $E459		;vector to SIO
SETVBV	= $E45C		;vector to set VBLANK parameters
SYSVBV	= $E45F		;vector to process immediate VBLANK
XITVBV	= $E462		;vector to process deferred VBLANK
SIOINV	= $E465		;vector to initialize SIO
SENDEV	= $E468		;vector to enable SEND
INTINV	= $E46B		;vector to initialize interrupt handler
CIOINV	= $E46E		;vector to initialize CIO
BLKBDV	= $E471		;vector to power-up display
WARMSV	= $E474		;vector to warmstart
COLDSV	= $E477		;vector to coldstart
RBLOKV	= $E47A		;vector to read cassette block
CSOPIV	= $E47D		;vector to open cassette for input
VCTABL	= $E480		;RAM vector initial value table
PUPDIV	= $E480		;##rev2## vector to power-up display
SLFTSV	= $E483		;##rev2## vector to self-test
PHENTV	= $E486		;##rev2## vector to enter peripheral handler
PHUNLV	= $E489		;##rev2## vector to unlink peripheral handler
PHINIV	= $E48C		;##rev2## vector to initialize peripheral handler
GPDVV	= $E48F		;##rev2## generic parallel device handler vector
OPEN	= $03		;open
GETREC	= $05		;get record
GETCHR	= $07		;get character(s)
PUTREC	= $09		;put record
PUTCHR	= $0B		;put character(s)
CLOSE	= $0C		;close
STATIS	= $0D		;status
SPECIL	= $0E		;special

; RMT player
	icl "rmtplayr.a65"
; RMT module
	opt h-						;RMT module is standard Atari binary file already
	ins "title.rmt"				;include music RMT module
	opt h+
MODUL equ $6000

; loader_start	equ $8CD5
; io_buffer		equ	$b900			; Size = io_buffer_size

				; org loader_start
				
; .var			addr0		.word;
; .var			addr1		.word;
				
; finale_loader
				; ldy #0
; @				lda finale_file,y
				; sta io_buffer,y
				; iny
				; cmp #$9b
				; bne @- 
				
				; io_find_free_iocb_LOADER
				; io_open_file_LOADER #io_buffer #OPNIN	; IO buffer (b900) is not used by 'finale'
				
				; io_read_binary_LOADER #io_buffer #2	; FF FF
				
; nextpart		io_read_binary_LOADER #addr0 #2			; Start address of the block
				; jmi loaded
				; io_read_binary_LOADER #addr1 #2			; Size of the block
				; sbw addr1 addr0
				; adw addr1 #1				
				; io_read_binary_LOADER addr0 addr1
				; jmp nextpart

; loaded
				; io_close_file_LOADER
				
				; ; Run the loaded file
				; lda #34
				; sta 559
				; jmp $2c20

; ; Free IOCB returned in X
; .proc	io_find_free_iocb_LOADER
		; ldx #$00
        ; ldy #$01
; io_loop lda IOCB,x
        ; cmp #$ff
        ; beq io_fnd
        ; txa
        ; clc
        ; adc #$10
        ; tax
        ; bpl io_loop
        ; ldy #-95
; io_fnd  rts
; .endp
; .proc	io_open_file_LOADER(.word filename .byte file_open_mode) .var
		; lda #OPEN
		; sta ICCOM,x
		; lda file_open_mode
		; sta icax1,x
		; lda #$00
		; sta icax2,x 
		; lda filename
		; sta ICBAL,x
		; lda filename+1
		; sta ICBAL+1,x
		; jsr CIOV
		; rts
; .endp
	
; .proc	io_close_file_LOADER
		; lda #CLOSE
		; sta ICCOM,X
		; jsr CIOV
		; rts
; .endp
		
; .proc	io_read_binary_LOADER(.word buf_addr .word buf_len) .var
; .var	buf_addr .word
; .var	buf_len .word
		; lda #GETCHR
		; sta ICCOM,x
		; lda buf_addr
		; sta ICBAL,x
		; lda buf_addr+1
		; sta ICBAL+1,x
		; lda buf_len
		; sta ICBLL,x
		; lda buf_len+1
		; sta ICBLL+1,x
		; jsr ciov		
		; rts
; .endp


; finale_file	dta c"D:CUDOWNY.CYC",b($9b)
; .var		file_open_mode		.byte
; .var		filename 			.word

	icl "intro2.h"

	org $f0

fcnt	.ds 2
fadr	.ds 2
fhlp	.ds 2
cloc	.ds 1
regA	.ds 1
regX	.ds 1
regY	.ds 1

WIDTH	= 40
HEIGHT	= 30

; ---	BASIC switch OFF
;	org $2000\ mva #$ff portb\ rts\ ini $2000

; ---	MAIN PROGRAM
	org $2000
ant	dta $44,a(scr)
	dta $04,$84,$04,$04,$84,$04,$04,$84,$04,$04,$84,$04,$04,$84,$04,$04
	dta $84,$04,$04,$84,$04,$04,$84,$04,$04,$84,$04,$04,$04
	dta $41,a(ant)

scr	ins "intro2.scr"

	.ALIGN $0400
fnt	ins "intro2.fnt"

	ift USESPRITES
	.ALIGN $0800
pmg	.ds $0300
	ift FADECHR = 0
	SPRITES
	els
	.ds $500
	eif
	eif

main
; ---	init PMG

			ldx #<MODUL
			ldy #>MODUL
			lda #0
			jsr RASTERMUSICTRACKER	;Init

			ift USESPRITES
	mva >pmg pmbase		;missiles and players data address
	mva #$03 pmcntl		;enable players and missiles
	eif

	ift CHANGES		;if label CHANGES defined
	jsr save_color		;then save all colors and set value 0 for all colors
	eif

	lda:cmp:req $14		;wait 1 frame

	sei			;stop IRQ interrupts
	mva #$00 nmien		;stop NMI interrupts
	sta dmactl
	mva #$fe portb		;switch off ROM to get 16k more ram

	mwa #NMI $fffa		;new NMI handler

	mva #$c0 nmien		;switch on NMI+DLI again

	ift CHANGES		;if label CHANGES defined

	jsr fade_in		;fade in colors

_lp	lda trig0		; FIRE #0
	beq stop

	lda trig1		; FIRE #1
	beq stop

	lda consol		; START
	and #1
	beq stop

	lda skctl
	and #$04
	bne _lp			;wait to press any key; here you can put any own routine

	
	els

null	jmp DLI.dli1		;CPU is busy here, so no more routines allowed

	eif


stop
	jsr fade_out		;fade out colors
	lda #0
	sta 559
	jsr RASTERMUSICTRACKER+9	;Stop

	mva #$00 pmcntl		;PMG disabled
	tax
	sta:rne hposp0,x+

	mva #$ff portb		;ROM switch on
	mva #$40 nmien		;only NMI interrupts, DLI disabled
	cli			;IRQ enabled
	rts

	;jmp loader_start

; ---	DLI PROGRAM

.local	DLI

	?old_dli = *

	ift !CHANGES

dli1	lda trig0		; FIRE #0
	beq stop

	lda trig1		; FIRE #1
	beq stop

	lda consol		; START
	and #1
	beq stop

	lda skctl
	and #$04
	beq stop

	lda vcount
	cmp #$02
	bne dli1

	:3 sta wsync

	DLINEW DLI.dli2
	eif


dli_start

dli2
	sta regA
	lda >fnt+$400*$01
	sta wsync		;line=24
	sta chbase
	DLINEW dli3 1 0 0

dli3
	sta regA
	lda >fnt+$400*$02
	sta wsync		;line=48
	sta chbase
	DLINEW dli4 1 0 0

dli4
	sta regA
	lda >fnt+$400*$03
	sta wsync		;line=72
	sta chbase
	DLINEW dli5 1 0 0

dli5
	sta regA
	lda >fnt+$400*$04
	sta wsync		;line=96
	sta chbase
	DLINEW dli6 1 0 0

dli6
	sta regA
	lda >fnt+$400*$05
	sta wsync		;line=120
	sta chbase
	DLINEW dli7 1 0 0

dli7
	sta regA
	lda >fnt+$400*$06
	sta wsync		;line=144
	sta chbase
	DLINEW dli8 1 0 0

dli8
	sta regA
	lda >fnt+$400*$07
	sta wsync		;line=168
	sta chbase
	DLINEW dli9 1 0 0

dli9
	sta regA
	lda >fnt+$400*$08
	sta wsync		;line=192
	sta chbase
	DLINEW dli10 1 0 0

dli10
	sta regA
	lda >fnt+$400*$09
	sta wsync		;line=216
	sta chbase

	lda regA
	rti

.endl

; ---

CHANGES = 1
FADECHR	= 0

; ---

.proc	NMI

	bit nmist
	bpl VBL

	jmp DLI.dli_start
dliv	equ *-2

VBL
	sta regA
	stx regX
	sty regY
	
	sta nmist		;reset NMI flag

	mwa #ant dlptr		;ANTIC address program

	mva #scr40 dmactl	;set new screen width

	inc cloc		;little timer

; Initial values

	lda >fnt+$400*$00
	sta chbase
c0	lda #$00
	sta colbak
c1	lda #$B5
	sta color0
c2	lda #$DA
	sta color1
c3	lda #$32
	sta color2
c4	lda #$0E
	sta color3
	lda #$00
	sta chrctl
	lda #$04
	sta gtictl
x0	lda #$00
	sta hposp0
	sta hposp1
	sta hposp2
	sta hposp3
	sta hposm0
	sta hposm1
	sta hposm2
	sta hposm3
	sta sizep0
	sta sizep1
	sta sizep2
	sta sizep3
	sta sizem
	sta colpm0
	sta colpm1
	sta colpm2
	sta colpm3

	mwa #DLI.dli_start dliv	;set the first address of DLI interrupt

	jsr RASTERMUSICTRACKER+3	;Play
;this area is for yours routines

quit
	lda regA
	ldx regX
	ldy regY
	rti

.endp

; ---
	ift CHANGES
		ift FADECHR = 0
		icl 'intro2.fad'
		eif
	eif

	run main
; ---

	opt l-

.MACRO	SPRITES
missiles
	.ds $100
player0
	.ds $100
player1
	.ds $100
player2
	.ds $100
player3
	.ds $100
.ENDM

USESPRITES = 0

.MACRO	DLINEW
	mva <:1 NMI.dliv
	ift [>?old_dli]<>[>:1]
	mva >:1 NMI.dliv+1
	eif

	ift :2
	lda regA
	eif

	ift :3
	ldx regX
	eif

	ift :4
	ldy regY
	eif

	rti

	.def ?old_dli = *
.ENDM

vbi_routine
		jsr RASTERMUSICTRACKER+3	;Play
		jmp XITVBV

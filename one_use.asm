;	@com.wudsn.ide.asm.mainsourcefile=main.asm

ONE_USE_BEGIN
;;;; - BEGIN: CAN BE OVERWRITTEN
; init_text_0		dta b(124)
; :38				dta b(125)
; 				dta b(127)
; 				dta d'                                        '
; 				dta d'SDX: '
; 				dta d'$..'*
; 				dta d'  VBXE: '
; 				dta d'$..'*
; 				dta d'  Banks: '
; 				dta d'$..'*
; 				dta d' '
; 				dta d'$..'*
; 				dta b($9b)
; init_text_1		dta d' DUSZPASTERZ is now warming-up... '*,b($9b)
; init_text_2		dta d'auto',b($9b)
; init_text_3		dta d'file',b($9b)
; .var			autobanks	.byte

; :25				dta b('X')			; Currently lack of 22 bytes, reserve for bank loading code

; dl_initialization
; 				dta b(%01110000)		; DLI - begin
; 				dta b(%01110000)
; 				dta b(%01110000)
; 				dta b(%01110000)
; 				dta b(%01110000)
; 				dta b(%01110000)
; 				dta b(%01000010)
; 				dta a(screen_mem)		; screen memory
; :4				dta b($02)
; 				dta b($41),a(dl_initialization)

; .zpvar		VBXE_base			.word
; .var		bank_offset			.byte
; .var		banks_established	.byte

; detected_vbxe_page			dta b(0)

; TAB_HEXCHARS	dta d"0123456789ABCDEF"*
; 				dta b(0)
; 				dta b(0)
; 				dta b(0)
; 				dta b(0)
; 				dta b(0)
; 				dta b(0)
; 				dta b(0)
; 				dta b(0)
; 				dta b(0)
; 				dta b(0)
; 				dta b(0)
; 				dta b(0)
; 				dta b(0)
; 				dta b(0)
; 				dta b(0)
; 				dta b(0)
; 				dta b(0)
; 				dta b(0)
; 				dta b(0)
; 				dta b(0)
; 				dta b(0)
; 				dta b(0)
; 				dta b(0)
; 				dta b(0)
; 				dta b(0)
; 				dta b(0)
; 				dta b(0)
; 				dta b(0)
; 				dta b(0)
; 				dta b(0)
; 				dta b(0)
; 				dta b(0)
; 				dta b($0)
; 				dta b($1)
; 				dta b($2)
; 				dta b($3)
; 				dta b($4)
; 				dta b($5)
; 				dta b($6)
; 				dta b($7)
; 				dta b($8)
; 				dta b($9)
; 				dta b(0)
; 				dta b(0)
; 				dta b(0)
; 				dta b(0)
; 				dta b(0)
; 				dta b(0)
; 				dta b(0)
; 				dta b($a)
; 				dta b($b)
; 				dta b($c)
; 				dta b($d)
; 				dta b($e)
; 				dta b($f)

; .proc display_hash
; 				lda #13+128
; 				ldy #0
; 				sta (item_name),y
; 				iny
; 				sta (item_name),y
; 				rts
; .endp

; .proc display_byte
; 				ldy #0
; 				pha
; 				and #%11110000
; 				lsr
; 				lsr
; 				lsr
; 				lsr
; 				tax
; 				lda TAB_HEXCHARS,x
; 				sta (item_name),y
; 				iny
; 				pla
; 				and #%00001111
; 				tax
; 				lda TAB_HEXCHARS,x
; 				sta (item_name),y
; 				rts
; .endp

; .proc init_step
; 				ldx #0
; 				ldy pocket_offset
; 				lda #126
; @				sta screen_mem+40*2,y
; 				iny
; 				inx
; 				cpx #6
; 				bne @-
; 				sty pocket_offset
; 				delay5
; 				rts
; .endp

; .proc is_extram_auto
; 				; Assume autodetect
; 				lda #1
; 				sta autobanks
				
; 				; Build file name
; 				ldx #0
; @				lda banks_file,x
; 				sta io_buffer,x
; 				inx
; 				cpx #12
; 				bne @-
; 				lda #$9b
; 				sta io_buffer,x
				
; 				; Try open
; 				io_find_free_iocb
; 				io_open_file_OPT1 
; 				bmi iea_x
; 				io_read_record_OPT1
; 				io_close_file
				
; 				#if .word io_buffer = #$5541 .and .word io_buffer+2 = #$4f54
; 					; Auto
; 					rts
; 				#end

; 				ldy io_buffer
; 				lda TAB_HEXCHARS,y
; 				asl
; 				asl
; 				asl
; 				asl
; 				sta io_buffer+10
; 				ldy io_buffer+1
; 				lda TAB_HEXCHARS,y
; 				ora io_buffer+10
; 				ldy #0
; 				sty ext_ram_bank
; 				sta @TAB_MEM_BANKS+1

; 				ldy io_buffer+3
; 				lda TAB_HEXCHARS,y
; 				asl
; 				asl
; 				asl
; 				asl
; 				sta io_buffer+10
; 				ldy io_buffer+4
; 				lda TAB_HEXCHARS,y
; 				ora io_buffer+10
; 				ldy #1
; 				sty ext_ram_bank_msg
; 				sta @TAB_MEM_BANKS+2

; 				; Manual banks
; 				dec autobanks
				
; iea_x			
; 				rts
; .endp

; .proc initialization
				; jsr enable_VBXE
				; jsr clear_init_memory
				; jsr set_init_displaylist
				; lda #>text_font
				; sta CHBAS
				; lda #220
				; sta COLOR1
				; lda #83
				; sta COLOR2
				; lda #34
				; sta 559
				; print_string #init_text_0 #0 #2 #0
				; print_string #init_text_1 #3 #0 #0
				
				; lda #1
				; sta pocket_offset
				; delay5
				
				; ; Step #1: VBXE base
				; mwa #screen_mem+4*40+17 item_name
				; #if .byte detected_vbxe = #1
					; lda detected_vbxe_page
					; display_byte
				; #else
					; display_hash
				; #end
				; jsr init_step
				
				; jsr is_extram_auto
				
				; ; Step #2: Sparta bank
				; mwa #screen_mem+4*40+6 item_name
				; #if .byte sparta_bank = #$fe
					; inc sparta_bank
				; #end 
				; #if .byte sparta_bank = #$ff
					; display_hash
				; #else
					; lda sparta_bank
					; display_byte
				; #end
				; jsr init_step
				
				; ldy ext_ram_bank
				; mwa #screen_mem+4*40+29 item_name
				; lda @TAB_MEM_BANKS+1,y
				; display_byte
				; ldy ext_ram_bank_msg
				; mwa #screen_mem+4*40+33 item_name
				; lda @TAB_MEM_BANKS+1,y
				; display_byte
				; lda autobanks
				; cmp #1
				; beq @+
				; print_string #init_text_3 #36 #4 #0
				; jmp i00
; @				print_string #init_text_2 #36 #4 #0
; i00				jsr init_step
				
				; preload_data
				; lda #126
				; sta screen_mem+2*40+37
				; sta screen_mem+2*40+38
				; delay5
				; rts
; .endp

;--------------------------------------------------------
;VBXE_Detect - detects VBXE FX core version 1.07 and above,
; and stores VBXE Base address in VBXEBase
; VBXE_Detect	.local
; 	lda	#0
; 	ldx	#0xd6
; 	sta	0xd640			; make sure it isn't coincidence
; 	lda	0xd640
; 	cmp	#0x10			; do we have major version here?
; 	beq	VBXE_FX_Detected	; if so, then VBXE FX core is detected
; 	lda	#0
; 	inx
; 	sta	0xd740			; no such luck, try other location
; 	lda	0xd740
; 	cmp	#0x10
; 	beq	VBXE_FX_Detected
; 	ldx #0  			; not here, so not present or FX core version too low
; 	stx	detected_vbxe_page
; 	stx detected_vbxe
; 	sec
; 	rts
; VBXE_FX_Detected:
; 	stx	detected_vbxe_page
; 	lda	#0
; 	vblda VBXE_MINOR
; 	and	#0x70			; disregard if this is A or R core version
; 	cmp	#(REVISION & 0x70)	; check if core revision is compatible with the software
; 	beq	VBXE_Detected
; 	lda #0
; 	sta detected_vbxe
; 	sec
; 	rts
; VBXE_Detected:
; 	stx	detected_vbxe_page
; 	lda #1
; 	sta detected_vbxe
; 	clc	 			; x - page of vbxe

; 	lda $800		//hidden part
; 	cmp #'x'
; 	bne eend
; 	lda $801
; 	cmp #'B'
; 	bne eend
; 	lda #1
; 	sta $80
; eend
; 	rts

; 	;--------------------------------------------------------
; ;vblda	- loads accumulator with VBXE register value
; ;	  use:	vblda	VBXE_REGISTER

; vblda	.macro
; .ifdef	__VBXE_AUTO__
; 	lda	detected_vbxe_page
; 	sta	vblda_adr
; 	lda.w	:1
; vblda_adr	equ *-1
; .else
; 	lda	:1
; .endif
; .endm

; ;--------------------------------------------------------
; ;vbsta	- stores accumulator in VBXE register
; ;	  use:	vbsta	VBXE_REGISTER

; vbsta	.macro
; .ifdef	__VBXE_AUTO__
; 	pha
; 	lda	detected_vbxe_page
; 	sta	vbsta_adr
; 	pla
; 	sta.w	:1
; vbsta_adr	equ *-1
; .else
; 	sta.w	:1
; .endif
; .endm

; .def	__VBXE_AUTO__
; .def	REVISION	=	0x20

; .if .not .def __VBXE_AUTO__ .and .not .def __VBXE_D700__	; default case - vbxe at 0xd640
; VBXE_BASE		equ	0xd600
; .elseif .not .def __VBXE_AUTO__ .and def __VBXE_D700__		; vbxe is assumed to be under 0xd740
; VBXE_BASE		equ	0xd700
; .else								; vbxe should be autodetected
; VBXE_BASE		equ	0x0000
; .endif

; VBXE_MAJOR		equ	VBXE_BASE+0x40
; VBXE_MINOR		equ	VBXE_BASE+0x41

	
; .endl	

; .proc enable_vbxe
; 				jsr VBXE_Detect
				
; 				#if .byte detected_vbxe = #1
; 					lda #0
; 					sta VBXE_base
; 					lda detected_vbxe_page
; 					sta VBXE_base+1
					
; 					lda #2
; 					ldy #$40
; 					sta (VBXE_base),y		
; 				#end
				
; 				; No VBXE - do nothing. 
; 				rts
; .endp
; ; Preloads data to the extended memory banks
; .proc preload_data
; 				preload_objects
; 				jsr init_step
; 				preload_items
; 				jsr init_step
; 				lda #0
; 				sta slow
; 				preload_messages #$534d
; 				jsr init_step
; 				rts
; .endp

; ; Preloads the object data
; .proc preload_objects
; 				build_object_file_name
; 				open_object_file

; 				extended_mem ext_ram_bank
												
; 				io_read_binary #EXTRAM_OBJECTS #ob_size
				
; 				main_mem
; 				io_close_file 				

; 				rts
; .endp

; ; Preloads the items data
; .proc preload_items
; 				build_item_file_name
; 				open_object_file

; 				extended_mem ext_ram_bank
				
; 				io_read_binary #EXTRAM_ITEMS #it_size

; 				main_mem
; 				io_close_file 				

; 				rts
; .endp

; p0      = $f0
; fsymbol = $07EB

; .proc establish_extended_bank
; 				lda #0
; 				sta ext_ram_bank
; 				sta ext_ram_bank_msg
; 				sta bank_offset
; 				sta banks_established
				
; ;				#if .byte ext_ram_banks = #0
; ;					putline	#init_text_05
; ;					putchar #$9b
; ;					delay5
; ;					rts
; ;				#end
				
; 				#if .byte sparta_bank = #$ff
; 					; No need to take care about SDX
; 					ldy #0
; 					sty ext_ram_bank
; 					iny				
; 					sty ext_ram_bank_msg
; 					rts
; 				#end
								
; 				; Load first extended memory bank
; 				ldy #0
; eeb_0			lda @TAB_MEM_BANKS+1,y
				
; 				; Is it used by SDX?
; 				cmp sparta_bank
; 				beq @+
				
; 				; This one is not used by SDX
; 				tya
; 				ldy bank_offset
; 				sta ext_ram_bank,y
; 				inc banks_established
; 				inc bank_offset
; 				tay
; 				iny
; 				lda banks_established
; 				cmp #2
; 				bne eeb_0
; 				rts
				
; @				; This one is used by SDX
; 				iny
				
; 				; Did we reach the end of banks?
; 				cpy ext_ram_banks
; 				beq @+
; 				jmp eeb_0
				
; @				; No block available
; 				lda #0
; 				sta ext_ram_banks
; 				rts		
				
; .endp

; sparta_detect

; ; if peek($700) = 'S' and bit($701) sets V then we're SDX

;                 lda $0700
;                 cmp #$53         ; 'S'
;                 bne no_sparta
;                 lda $0701
;                 cmp #$40
;                 bcc no_sparta
;                 cmp #$44
;                 bcc _oldsdx

; ; we're running 4.4 - the old method is INVALID as of 4.42

;                 lda #<sym_t
;                 ldx #>sym_t
;                 jsr fsymbol
;                 sta p0
;                 stx p0+1
;                 ldy #$06
;                 bne _fv

; ; we're running SDX, find (DOSVEC)-$150 

; _oldsdx         lda $a
;                 sec
;                 sbc #<$150
;                 sta p0
;                 lda $b
;                 sbc #>$150
;                 sta p0+1

; ; ok, hopefully we have established the address. 
; ; now peek at it. return the value. 

;                 ldy #0
; _fv             lda (p0),y
;                 rts
; no_sparta       lda #$ff 
;                 rts

; sym_t           .byte 'T_      '		; Thanks to drac030!

; ; if A=$FF -> No SDX :(
; ; if A=$FE -> SDX is in OSROM mode
; ; if A=$00 -> SDX doesn't use any XMS banks
; ; if A=anything else -> BANKED mode, and A is the bank number 

; 				ICL 'mads\@mem_detect.asm'
; ; Stuff from MADS examples to display initialization strings
; .proc delay5
; 				mva #25 to_be_delayed
; 				delay
; 				rts
; .endp

; .proc set_init_displaylist
; 				ldx <dl_initialization
; 				ldy >dl_initialization
; 				stx SDLSTL
; 				sty SDLSTL+1
; 				rts
; .endp

; .proc clear_init_memory
; 				ldy #0
; 				lda #0
; @				sta screen_mem,y
; 				iny
; 				cpy #5*40
; 				bne @-
; 				rts
; .endp

; banks_file		dta c"D:BANKS.TXT"
				
;;;; - END: CAN BE OVERWRITTEN
ONE_USE_END

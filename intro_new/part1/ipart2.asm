				icl '../../atari.inc'

dlist			equ $2800
screen_mem		equ $3000
screen_mem_2	equ $4000
pstart			equ $2C20


				org screen_mem
				ins "pegi.sra"
				org screen_mem_2
				ins "pegi.sradown"


				org	pstart
				lda #15
				ldx #05
				ldy #15
				sta COLOR0
				stx COLOR1
				sty COLOR2

				ldx <dl_main
				ldy >dl_main
				stx SDLSTL
				sty SDLSTL+1 
				
@				lda STRIG0
				sta ATRACT
				cmp #1
				beq @-
				
				lda #0
				sta 559

				jmp finale_loader
		
				org dlist
dl_main
				dta b(%11110000)			; DLI - begin
				dta b(%01110000)
				dta b(%01110000)
				dta b(%01001110)
				dta a(screen_mem)			; screen memory, part 1
:95				dta b(%00001110)
				dta b(%01001110)
				dta a(screen_mem_2)			; screen memory, part 2
:95				dta b(%00001110)
				dta b($41),a(dl_main)
dl_main_len	equ *-dl_main

loader_start	equ $ad80
io_buffer		equ	$b900			; Size = io_buffer_size

				org loader_start
				
.var			addr0		.word;
.var			addr1		.word;
				
finale_loader
				ldy #0
@				lda finale_file,y
				sta io_buffer,y
				iny
				cmp #$9b
				bne @- 
				
				io_find_free_iocb_LOADER
				io_open_file_LOADER #io_buffer #OPNIN	; IO buffer (b900) is not used by 'finale'
				
				io_read_binary_LOADER #io_buffer #2	; FF FF
				
nextpart		io_read_binary_LOADER #addr0 #2			; Start address of the block
				jmi loaded
				io_read_binary_LOADER #addr1 #2			; Size of the block
				sbw addr1 addr0
				adw addr1 #1				
				io_read_binary_LOADER addr0 addr1
				jmp nextpart

loaded
				io_close_file_LOADER
				
				; Run the loaded file
;				lda #34
;				sta 559
				jmp pstart

; Free IOCB returned in X
.proc	io_find_free_iocb_LOADER
		ldx #$00
        ldy #$01
io_loop lda IOCB,x
        cmp #$ff
        beq io_fnd
        txa
        clc
        adc #$10
        tax
        bpl io_loop
        ldy #-95
io_fnd  rts
.endp
.proc	io_open_file_LOADER(.word filename .byte file_open_mode) .var
		lda #OPEN
		sta ICCOM,x
		lda file_open_mode
		sta icax1,x
		lda #$00
		sta icax2,x 
		lda filename
		sta ICBAL,x
		lda filename+1
		sta ICBAL+1,x
		jsr CIOV
		rts
.endp
	
.proc	io_close_file_LOADER
		lda #CLOSE
		sta ICCOM,X
		jsr CIOV
		rts
.endp
		
.proc	io_read_binary_LOADER(.word buf_addr .word buf_len) .var
.var	buf_addr .word
.var	buf_len .word
		lda #GETCHR
		sta ICCOM,x
		lda buf_addr
		sta ICBAL,x
		lda buf_addr+1
		sta ICBAL+1,x
		lda buf_len
		sta ICBLL,x
		lda buf_len+1
		sta ICBLL+1,x
		jsr ciov		
		rts
.endp


finale_file	dta c"D:DORODNY.CYC",b($9b)
.var		file_open_mode		.byte
.var		filename 			.word


	org $02e0
.dw		pstart

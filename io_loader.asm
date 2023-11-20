; 				org loader_start
				
; .var			addr0		.word;
; .var			addr1		.word;
				
; finale_loader
; 				ldy #0
; @				lda finale_file,y
; 				sta io_buffer,y
; 				iny
; 				cmp #$9b
; 				bne @- 
				
; 				io_find_free_iocb_LOADER
; 				io_open_file_LOADER #io_buffer #OPNIN	; IO buffer (b900) is not used by 'finale'
				
; 				io_read_binary_LOADER #io_buffer #2	; FF FF
				
; nextpart		io_read_binary_LOADER #addr0 #2			; Start address of the block
; 				jmi loaded
; 				io_read_binary_LOADER #addr1 #2			; Size of the block
; 				sbw addr1 addr0
; 				adw addr1 #1				
; 				io_read_binary_LOADER addr0 addr1
; 				jmp nextpart

; loaded
; 				io_close_file_LOADER
				
; 				; Run the loaded file
; 				lda #34
; 				sta 559
; 				jmp $2c20

; ; Free IOCB returned in X
; .proc	io_find_free_iocb_LOADER
; 		ldx #$00
;         ldy #$01
; io_loop lda IOCB,x
;         cmp #$ff
;         beq io_fnd
;         txa
;         clc
;         adc #$10
;         tax
;         bpl io_loop
;         ldy #-95
; io_fnd  rts
; .endp
; 	.proc	io_open_file_LOADER(.word filename .byte file_open_mode) .var
; 		lda #OPEN
; 		sta ICCOM,x
; 		lda file_open_mode
; 		sta icax1,x
; 		lda #$00
; 		sta icax2,x 
; 		lda filename
; 		sta ICBAL,x
; 		lda filename+1
; 		sta ICBAL+1,x
; 		jsr CIOV
; 		rts
; .endp
	
; .proc	io_close_file_LOADER
; 		lda #CLOSE
; 		sta ICCOM,X
; 		jsr CIOV
; 		rts
; .endp
		
; .proc	io_read_binary_LOADER(.word buf_addr .word buf_len) .var
; .var	buf_addr .word
; .var	buf_len .word
; 		lda #GETCHR
; 		sta ICCOM,x
; 		lda buf_addr
; 		sta ICBAL,x
; 		lda buf_addr+1
; 		sta ICBAL+1,x
; 		lda buf_len
; 		sta ICBLL,x
; 		lda buf_len+1
; 		sta ICBLL+1,x
; 		jsr ciov		
; 		rts
; .endp


finale_file	dta c"D:MIENTKI.CYC",b($9b)

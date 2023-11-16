;	@com.wudsn.ide.asm.mainsourcefile=main.asm

; Free IOCB returned in X
.proc	io_find_free_iocb
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
	
.proc	io_open_file(.word filename .byte file_open_mode) .var
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
		
.proc	io_close_file
		lda #CLOSE
		sta ICCOM,X
		jsr CIOV
		rts
.endp
		
.proc	io_read_record(.word buf_addr .byte buf_len) .var
.var	buf_addr .word
.var	buf_len .byte
		lda #GETREC
		sta ICCOM,x
		lda buf_addr
		sta ICBAL,x
		lda buf_addr+1
		sta ICBAL+1,x
		lda buf_len
		sta ICBLL,x
		lda #0
		sta ICBLL+1,x
		jsr ciov		
		rts
.endp
       
.proc	io_write_binary(.word buf_addr .word buf_len) .var
.var	buf_addr .word
.var	buf_len .word
		lda #PUTCHR
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
 
 ; Size optimization
 .proc	io_read_record_OPT1
 		io_read_record #io_buffer #io_buffer_size
 		rts
 .endp
 .proc	io_read_binary_OPT1
		io_read_binary #io_buffer #1
 		rts
 .endp
 .proc io_open_file_OPT1 
 		io_open_file #io_buffer #OPNIN
 		rts
 .endp
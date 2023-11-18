;	@com.wudsn.ide.asm.mainsourcefile=main.asm

; Some global variables
.var			ext_ram_bank		.byte
.var			ext_ram_bank_msg	.byte
.var			sparta_bank			.byte
.zpvar			ext_ram_tmp			.word
.zpvar			buf_addr_tmp		.word

EXTRAM_OBJECTS		equ		$4000			; 15kb for "ob"
EXTRAM_ITEMS		equ		$7400			; 3kb for "it"
EXTRAM_MESSAGES		equ		$4000			; 16kb for "ms" (in another bank)

.proc adv_buffer_read_record
				ldy #0
				mwa #io_buffer_cart buf_addr_tmp
abrr_01				
				lda (ext_ram_tmp),y
				sta (buf_addr_tmp),y
				cmp #$9b
				beq abrr_X
				inw ext_ram_tmp
				inw buf_addr_tmp
				jmp abrr_01
abrr_X
				rts
.endp

; Reads record from the extended memory
.proc mem_read_record(.word buf_addr_tmp) .var
; 				ldy #0
; @				lda (ext_ram_tmp),y
; 				sta (buf_addr_tmp),y
; 				tax
; 				inw ext_ram_tmp
; 				inw buf_addr_tmp
; 				cpx #$9b
; 				bne @-
				rts
.endp

; Size optimization
.proc mem_read_record_OPT1
				mem_read_record #io_buffer
				rts
.endp
.proc mem_read_binary_OPT1
				mem_read_binary #io_buffer #1
				rts
.endp
     
; Reads binary data from the extended memory
.proc mem_read_binary(.word buf_addr_tmp .byte length) .var
.var length .byte
				; phr
				; ldx length
				; ldy #0
; @				lda (ext_ram_tmp),y
				; sta (buf_addr_tmp),y
				; inw ext_ram_tmp
				; inw buf_addr_tmp
				; dex
				; cpx #0
				; bne @-
				; plr
				rts
.endp 

; Switches back to the base memory
.proc main_mem
				lda @TAB_MEM_BANKS
;				and #%11111110
				sta PORTB
				rts
.endp

; Switches to extended RAM
.proc extended_mem(.byte y) .reg
				lda @TAB_MEM_BANKS+1,y
;				and #%11111110
				sta PORTB
				rts
.endp

;	@com.wudsn.ide.asm.mainsourcefile=main.asm

.var	antic_tmp		.byte

.proc delay_INTERNAL
				inc CDTMF4
				lda to_be_delayed
				lsr
				lsr
				ora #%00000001	; At least one
				sta CDTMV4
				lda #0
				sta CDTMV4+1
@				lda CDTMF4
				bne @-
				rts
.endp

.proc delay5
				mva #1 to_be_delayed
				delay
				rts
.endp

.proc disantic
				lda SDMCTL
				sta sparta_bank
				lda #0
				sta SDMCTL
				delay5
				rts
.endp

.proc enantic
				lda sparta_bank
				sta SDMCTL
				rts
.endp

; Disables ANTIC and DLI
.proc disable_antic
				lda SDMCTL
				sta antic_tmp
				lda #$00
				sta SDMCTL
				lda 20
@				cmp 20
				beq @-
				lda #%01000000
				sta NMIEN
				rts
.endp

; Enables ANTIC and DLI
.proc enable_antic
				lda antic_tmp
				sta SDMCTL
				lda #%11000000
				sta NMIEN
				rts
.endp

.proc deal_with_atract
				lda #0
				sta ATRACT
				rts
.endp

; Loads the screen from file whose name is stored in io_buffer
; .proc load_screen(.word tmp_src .word tmp_trg) .var
; 				io_find_free_iocb
; 				io_open_file_OPT1
; 				io_read_binary tmp_src tmp_trg
; 				io_close_file
; 				rts
; .endp

; Invalidates the current font so a correct one will be reloaded from disk
.proc invalidate_font
				lda #88
				sta game_state.current_font
				rts
.endp

; Invalidates the current logic DLL so a correct one will be reloaded from disk
.proc invalidate_logic_dll
				ldy #88
				sty game_state.logic_dll_name
				iny
				sty logic_dll_name_to_be_used
				rts
.endp


; Parses the number stored in buffer and
; converts it to single byte.
; Number must be composed of three digits (eg. 021 instead of 21).
; Parsed number is stored in A
.proc string2byte(.word buffer) .var
.zpvar buffer .word
.var tmp1, tmp2, tmp3 .byte
				ldy #0
				lda (buffer),y
				sub #$30
				sta tmp1
				iny
				lda (buffer),y
				sub #$30
				sta tmp2
				iny
				lda (buffer),y
				sub #$30
				sta tmp3
				
				lda #0
				ldy tmp1
s2b0			cpy #0
				beq s2b2
				add #100
				dey
				jmp s2b0
				
s2b2			ldy tmp2 
s2b1			cpy #0
				beq s2b3
				add #10
				dey
				jmp s2b1
				
s2b3			add tmp3
				rts
.endp

; Translates ATASCII value in A into Internal
.proc Atascii2Internal(.byte a) .reg
				#if .byte @ < #32
					add #64
				#else
					#if .byte @ < #96
						sub #32
					#end
				#end
				rts
.endp

; Translates Internal value in A into ATASCII
.proc Internal2Atascii(.byte a) .reg
				#if .byte @ < #64
					add #32
				#else
					#if .byte @ < #96
						sub #64
					#end
				#end
				rts
.endp

; Converts single byte to ATASCII string
.proc byte2string(.byte byte .word target .byte offset) .var
.var	.byte byte
.zpvar	.word target
.var	.byte offset
				ldy offset
				lda byte				
				lsr
				lsr
				lsr
				lsr
				#if .byte @ > #9
					add #55
				#else
					add #48
				#end
				sta (target),y
				lda byte
				and #$0f
				#if .byte @ > #9
					add #55
				#else
					add #48
				#end
				iny
				sta (target),y				
				rts
.endp

; Waits for next frame
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

.proc divbyte(.byte a,x) .reg
.var tmp01 .byte
				; A / X
				; Result in X, remainder in A
				stx tmp01
				ldx #0
@				sec
				sbc tmp01
				bcc @+
				inx
				jmp @-
@				clc
				adc tmp01
				rts
.endp

; Preloads the object data
; .proc preload_messages(.word which_file) .var
; ; $534d = "MS"
; ; $544d = "MT"
; .var which_file .word
; 				lda slow
; 				cmp #0
; 				beq @+
; 				disable_antic
; @				mwa drive_id		io_buffer
; 				mwa which_file io_buffer+2	; "MS"
; 				mva #$9b io_buffer+4	; eol
; 				io_find_free_iocb
; 				io_open_file_OPT1

; 				extended_mem ext_ram_bank_msg	
				
; 				#if .word which_file = #$534d
; 					io_read_binary #EXTRAM_MESSAGES #ms_size
; 				#else
; 					io_read_binary #EXTRAM_MESSAGES #mt_size
; 				#end

; 				main_mem
; 				io_close_file 				
; 				lda slow
; 				cmp #0
; 				beq @+
; 				enable_antic

; @				rts
; .endp


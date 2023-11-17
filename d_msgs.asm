;	@com.wudsn.ide.asm.mainsourcefile=main.asm

ADVMSG_COLOR_BCKG		equ $ca
ADVMSG_COLOR_TEXT		equ $c2

TITLE_COLOR_BCKG		equ $00
TITLE_COLOR_TEXT		equ $0f

.var	adv_color_1		.byte
.var	adv_color_2		.byte
.var	adv_color_3		.byte

; Displays the picture for the current adventure message
.proc display_adventure_picture
				build_advmap_picture_file_name

				io_cart_load_picture

;				io_find_free_iocb
;				io_open_file_OPT1
;				io_read_binary #screen_mem #40*40
;				io_read_binary #adv_color_1 #3
;				io_close_file
				rts
.endp

; Builds the adventure message font filename in the io_buffer
.proc build_advmap_font_file_name
				ldx #0
@				lda advmsg_font,x
				sta io_buffer+$60,x
				inx
				cpx #12
				bne @-
				lda #$9b
				sta io_buffer+$60,x
				rts
.endp

; Builds the adventure message picture filename in the io_buffer
.proc build_advmap_picture_file_name
				ldy #0
; #				lda #'D'
; 				sta io_buffer
; 				lda #':'
; 				sta io_buffer+1
				lda #'P'
				sta io_buffer_cart
				
				; lda use_folders
				; cmp #1
				; beq @+
				
				
				lda (show_adventure_message_INTERNAL.id),y
				sta io_buffer_cart+1
				iny
				lda (show_adventure_message_INTERNAL.id),y
				sta io_buffer_cart+2
				iny
				lda (show_adventure_message_INTERNAL.id),y
				sta io_buffer_cart+3
				; lda #'.'
				; sta io_buffer+6
				; lda #'S'
				; sta io_buffer+7
				; lda #'R'
				; sta io_buffer+8
				; lda #'A'
				; sta io_buffer+9
				; lda #$9b
				; sta io_buffer+10
				rts
.endp

; Builds the adventure message filename in the io_buffer
.proc build_advmsg_file_name
				ldx #0
@				lda advmsg_file,x
				sta io_buffer,x
				inx
				cpx #12
				bne @-
				lda #$9b
				sta io_buffer,x
				rts
.endp

; Turns "adventure message-state" on and off
.proc switch_advmessage_state
				lda game_flags
				eor #FLAGS_INADVMESSAGE
				sta game_flags
				rts
.endp

advmsg_file		dta c"D:ADVMSG.SCR"
advmsg_font		dta c"D:ADVMSG.FNT"


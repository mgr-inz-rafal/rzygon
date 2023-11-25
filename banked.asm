;	@com.wudsn.ide.asm.mainsourcefile=main.asm

				icl 'memcache.asm'
				icl 'io.asm'

PERSISTENCY_BANK_CTL equ $d500				
CART_RAM_START	equ $a000
CART_DISABLE_CTL equ $d580

.var			srom	.byte				
.var			szczam	.word
				
;---------------- g_pocket.asm
; Shows the items from pocket on the screen
; TODO: A lot of code copy&pasted from g_main.asm (load_map_item)
.proc show_pocket_items
.zpvar tmp .byte
@				mark_pocket_names_as_unused

				; Remember pocket offset
				lda pocket_offset
				pha

				clear_sprites_memory #1
				mva #1 item_being_loaded

				; Iterate through all items
spi3			ldy pocket_offset
@				lda POCKET,y
				cmp #0
				bne @+
				iny5
				cpy #5*51
				bne @-
				
				; Entire pocket read, restore the offset and exit
				jmp spi8

@
				mwa POCKET,y		io_buffer				 
				mwa POCKET+2,y		io_buffer+2			 
				mva POCKET+4,y		io_buffer+4
								
				; #if .byte ext_ram_banks <> #0
				; 	; Load from extended RAM
				; 	mwa #EXTRAM_ITEMS ext_ram_tmp
				; #else
					; build_item_file_name
					; open_object_file				; Reuse the "font file open" code.
;				#end
				
spiC			
				; #if .byte ext_ram_banks <> #0
				; 	extended_mem ext_ram_bank
				; 	mem_read_record #io_buffer+5
				; 	main_mem
				; #else	
;					io_read_record #io_buffer+5 #io_buffer_size-5
;				#end
@				lda io_buffer+5
				cmp #$ff			; This indicates that the item ID has been read
				bne spiC			
				
				; Check if we have read the item we need
				#if .dword io_buffer <> io_buffer+6 .or .byte io_buffer+4 <> io_buffer+10
					jmp spiC
				#end

				; Read size of the item
				; #if .byte ext_ram_banks <> #0
				; 	extended_mem ext_ram_bank
				; 	mem_read_binary_opt1
				; 	main_mem
				; #else
;					jsr io_read_binary_OPT1
;				#end
				
				; Set up item vertial position
				ldy item_being_loaded
				cpy #1
				bne @+
				mva #item1_vert tmp
				jmp spi6				
@				cpy #2
				bne @+
				mva #item2_vert tmp
				jmp spi6				
@				cpy #3
				bne @+				
				mva #item3_vert tmp
				jmp spi6				
@				mva #item4_vert tmp
spi6

				; Align center of the item vertically
				lda io_buffer
				lsr
				sta io_buffer+1
				sbw tmp io_buffer+1

				; Read all bytes
				ldy io_buffer
spi0			cpy #0
				jeq spi1
				tya
				pha
				; #if .byte ext_ram_banks <> #0
				; 	extended_mem ext_ram_bank
				; 	mem_read_binary_opt1
				; 	main_mem
				; #else
;					jsr io_read_binary_OPT1
;				#end				
				txa
				pha
				
				lda io_buffer
				ldy tmp

				ldx item_being_loaded
				cpx #1
				bne @+ 
				sta pmg_item1,y
				jmp spi2
@				cpx #2
				bne @+
				sta pmg_item2,y
				jmp spi2
@				cpx #3
				bne @+
				sta pmg_item3,y
				jmp spi2
@				sta pmg_item4,y

spi2			pla
				tax
				
				ldy tmp
				iny
				sty tmp

				pla
				tay
				dey
				
				jmp spi0
				 
spi1			; Read color and position the sprite accordingly			
				; #if .byte ext_ram_banks <> #0
				; 	extended_mem ext_ram_bank
				; 	mem_read_binary_opt1
				; 	lda io_buffer
				; 	pha
				; 	main_mem
				; 	pla
				; #else
;					ldx tmp_channel 
;					jsr io_read_binary_OPT1
;				#end
								
				lda item_being_loaded
				and #%00000001
				cmp #1
				beq @+
				lda #item13_hor
				jmp spi5
@				lda #item24_hor
spi5			ldy item_being_loaded
				cpy #4
				beq @+
				sta HPOSP0,y
				jmp spi7
@				sta HPOSM3
				add #2
				sta HPOSM2				
				add #2
				sta HPOSM1				
				add #2
				sta HPOSM0				
spi7			lda io_buffer
				cpy #4
				beq @+ 
				sta PCOLR0,y
				jmp spi4
@				sta COLOR3
spi4			

				; Read item name length
				; #if .byte ext_ram_banks <> #0
				; 	extended_mem ext_ram_bank
				; 	mem_read_binary_opt1
				; 	lda io_buffer
				; 	pha
				; 	main_mem
				; 	pla
				; #else
;					ldx tmp_channel 
;					jsr io_read_binary_OPT1
;				#end
								
				; Read item name into appropriate slot
;				stx tmp_channel

				#if .byte item_being_loaded = #2 .or .byte item_being_loaded = #4
					lda #20
					sub io_buffer
					tax
					pha
					
					dex
					lda item_being_loaded
					cmp #2
					bne spib
					lda #0
@					sta POCKET_NAME_2,x
					dex
					cpx #$ff
					bne @-
					jmp spi9
spib
					lda #0
@					sta POCKET_NAME_4,x
					dex
					cpx #$ff
					bne @-
spi9					
					pla
					tax
				#else
					ldx #0
				#end 
				ldy io_buffer
spia				
				tya
				pha
				txa
				pha
;				ldx tmp_channel
				; #if .byte ext_ram_banks <> #0
				; 	extended_mem ext_ram_bank
				; 	mem_read_binary_opt1
				; 	lda io_buffer
				; 	pha
				; 	main_mem
				; 	pla
				; #else
					; ldx tmp_channel 
					; jsr io_read_binary_OPT1
;				#end
				pla
				tax
				
				store_letter_in_appropriate_name

				pla
				tay
				inx
				dey
				cpy #0
				bne spia	
				
				mva #$9b io_buffer
				store_letter_in_appropriate_name			

;				ldx tmp_channel				

				; Close the file
//				io_close_file
				
				; Continue with next item
				inc item_being_loaded
				lda item_being_loaded
				cmp #5
				beq spi8 
				adb pocket_offset #5
				jmp spi3

				; Restore pocket offset and exit								 
spi8			pla
				sta pocket_offset
				rts
.endp


;---------------- g_main.asm
; Loads the map item from disks and set ups
; sprites accordingly
.proc load_map_item
				; Store item ID in the item buffer
				txa
				pha
				ldx item_being_loaded
				lda #1
				add #20
lmia			dex
				cpx #0
				beq @+
				add #ITEM_DATA_LEN
				jmp lmia
@				tax
				ldy #0
@;				lda io_buffer,y
				sta ITEM_1_DATA,x				
				iny
				inx
				cpy #5
				bne @-
				pla
				tax

				; Load item
				string2byte #io_buffer+10
				sta load_map_item_tmp

				; #if .byte ext_ram_banks <> #0
				; 	; Load from extended RAM
				; 	mwa #EXTRAM_ITEMS ext_ram_tmp
				; #else
					; build_item_file_name
					; open_object_file				; Reuse the "font file open" code.
					; jmi lmi_ERR
;				#end

lmiB				
				; #if .byte ext_ram_banks <> #0
				; 	extended_mem ext_ram_bank
				; 	mem_read_record #io_buffer+5
				; 	main_mem
				; #else	
;					io_read_record #io_buffer+5 #io_buffer_size-5
;				#end
				
@				lda io_buffer+5
				cmp #$ff			; This indicates that the item ID has been read
				bne lmiB			
				
				; Check if we have read the item we need
				#if .dword io_buffer <> io_buffer+6 .or .byte io_buffer+4 <> io_buffer+10
					jmp lmiB
				#end
				; #if .byte ext_ram_banks <> #0
				; 	extended_mem ext_ram_bank
				; 	mem_read_binary_opt1
				; 	main_mem
				; #else
;					jsr io_read_binary_OPT1
;				#end
				ldy #0
				; sty tmp_channel+1
				; ldy io_buffer
				; sty tmp_channel
							
				; #if .byte ext_ram_banks <> #0
				; 	extended_mem ext_ram_bank
				; 	mem_read_binary #io_buffer tmp_channel
				; 	main_mem
				; #else
	;				io_read_binary #io_buffer tmp_channel
;				#end
				; ldy tmp_channel
				; lda #0
				; sta tmp_channel
				
lmi0			cpy #0
				jeq lmi1
				
				tya
				pha
				
				ldy load_map_item_tmp
				
				txa
				pha
				
				
				tya
				pha			
				; ldy tmp_channel
				; lda io_buffer,y
				; sta tmp_channel+1
				; inc tmp_channel
				pla
				tay
;				lda tmp_channel+1
				ldx item_being_loaded
				cpx #1
				bne @+ 
				sta pmg_item1,y
				jmp lmi2
@				cpx #2
				bne @+
				sta pmg_item2,y
				jmp lmi2
@				cpx #3
				bne @+
				sta pmg_item3,y
				jmp lmi2
@				sta pmg_item4,y
				
lmi2			pla
				tax				
				iny
				sty load_map_item_tmp
				
				pla
				tay
				
				dey
				jmp lmi0 
				
lmi1			; Read color			
				; #if .byte ext_ram_banks <> #0
				; 	extended_mem ext_ram_bank
				; 	mem_read_binary_opt1
				; 	main_mem
				; #else
;					jsr io_read_binary_OPT1
;				#end
				lda io_buffer
				ldy item_being_loaded
				cpy #4
				beq @+ 
				sta PCOLR0,y
				jmp lmi3
@				sta COLOR3
lmi3			
				; Move sprite accordingly
				string2byte #io_buffer+$57
				ldy item_being_loaded
				cpy #1
				bne @+
				sta item1_tmp_pos
@				cpy #4
				beq @+
				sta HPOSP0,y
				jmp lmi4
@ 				sta HPOSM3
				add #2
				sta HPOSM2
				add #2
				sta HPOSM1
				add #2
				sta HPOSM0
			
				; Read item name length
lmi4			
				; #if .byte ext_ram_banks <> #0
				; 	extended_mem ext_ram_bank
				; 	mem_read_binary_opt1
				; 	lda io_buffer
				; 	pha
				; 	main_mem
				; 	pla
				; #else
					; stx tmp_channel
					; jsr io_read_binary_OPT1
				;#end
				tay
				mva #1 load_map_item_tmp
lmi5			tya
				pha
				; #if .byte ext_ram_banks <> #0
				; 	extended_mem ext_ram_bank
				; 	mem_read_binary_opt1
				; 	lda io_buffer
				; 	pha
				; 	main_mem
				; 	pla
				; #else
					; ldx tmp_channel 
					; jsr io_read_binary_OPT1
;				#end
				ldy item_being_loaded
				cpy #1
				bne lmi6
				ldx load_map_item_tmp
				sta ITEM_1_DATA,x
				inx
				lda #$9b
				sta ITEM_1_DATA,x
				stx load_map_item_tmp
				jmp lmi9
lmi6			cpy #2
				bne lmi7
				ldx load_map_item_tmp
				sta ITEM_2_DATA,x
				inx
				lda #$9b
				sta ITEM_2_DATA,x
				stx load_map_item_tmp
				jmp lmi9
lmi7			cpy #3
				bne lmi8
				ldx load_map_item_tmp
				sta ITEM_3_DATA,x
				inx
				lda #$9b
				sta ITEM_3_DATA,x
				stx load_map_item_tmp
				jmp lmi9
lmi8			ldx load_map_item_tmp
				sta ITEM_4_DATA,x
				inx
				lda #$9b
				sta ITEM_4_DATA,x
				stx load_map_item_tmp
lmi9			pla
				tay
				dey
				cpy #0
				jne lmi5
				
				inc item_being_loaded

				; #if .byte ext_ram_banks = #0
//					ldx tmp_channel
//					io_close_file
				; #end
				
lmi_ERR			rts
.endp

; Loads the map object which definition is stored in I/O buffer
; Object definition has the following format:
; FNAME;XXX,YYY
;	FNAME	= file name with object definition (always 5 characters)
;	XXX		= X position of the object
;	YYY		= Y position of the object
.proc load_map_object
; .var xpos, ypos, xsize, ysize, transparent .byte
; .var yoffset .byte
; 				; #if .byte ext_ram_banks <> #0
; 				; 	; Load from extended RAM
; 				; 	mwa #EXTRAM_OBJECTS ext_ram_tmp
; 				; #else
; 					build_object_file_name
; 					open_object_file				; Reuse the "font file open" code.
; 					jmi lmo_ERR
; ;				#end
					
; lmo2			
; 				; #if .byte ext_ram_banks <> #0
; 				; 	extended_mem ext_ram_bank
; 				; 	mem_read_record #io_buffer+5+$40
; 				; 	main_mem
; 				; #else
; ;					io_read_record #io_buffer+5+$40 #io_buffer_size-5-$40
; ;				#end
; @				lda io_buffer+5+$40
; 				cmp #$ff			; This indicates that the item ID has been read
; 				bne lmo2			

; 				; Check if we have read the object we need
; 				#if .dword io_buffer <> io_buffer+6+$40 .or .byte io_buffer+4 <> io_buffer+10+$40
; 					jmp lmo2
; 				#end

; 				; #if .byte ext_ram_banks <> #0
; 				; 	extended_mem ext_ram_bank
; 				; 	mem_read_record_OPT1
; 				; 	main_mem
; 				; #else
; 					jsr io_read_record_OPT1
; 					jmi lmo_ERR
; 				;#end
; 				mva io_buffer	transparent
; 				mva io_buffer+1	xsize
; 				mva io_buffer+2	ysize
				
; 				mva #0 yoffset
				
; 				#while .byte ysize > #0
; 					; #if .byte ext_ram_banks <> #0
; 					; 	extended_mem ext_ram_bank
; 					; 	mem_read_record #io_buffer+$60
; 					; 	main_mem
; 					; #else
; ;						io_read_record #io_buffer+$60 #io_buffer_size
; ;					#end
; 					#if .byte transparent = #1
; 						add_to_transparent_chars #io_buffer+$60 xsize
; 					#end
					
; 					mwa #io_buffer load_map_object_tmp
						
; 					ldy #0
; 					adw load_map_object_tmp #5	
; lmo0				lda (load_map_object_tmp),y
; 					sta xpos
; 					inw load_map_object_tmp
; 					lda (load_map_object_tmp),y
; 					sta ypos
; 					display_map_object xsize xpos ypos yoffset
					
; 					inw load_map_object_tmp
; 					ldy #0
; 					lda (load_map_object_tmp),y
; 					cmp #$9b
; 					jeq lmo1
; 					jmp lmo0
					
; lmo1				dec ysize
					
; 					inc yoffset			
; 				#end
				
;				#if .byte ext_ram_banks = #0
;					io_close_file
;				#end
				
lmo_ERR			rts
.endp

; Needs to be called after the status
; message should be removed from screen.
.proc recover_from_status_message
				clear_status_bar
				restore_level_name
				mva #50 to_be_delayed
				delay
				rts
.endp

; Prepares the requirements for displaying the message:
;   1. Opens the "MS" file
;   2. Looks for appropriate message
;
; In the cart version it 
.proc show_message_prerequisites
.zpvar	ptr .word
.zpvar  ptr2 .word
.var	slot .byte

		lda #0
		sta NMIEN

		lda #23
		sta slot

smp_06
		ldy slot
		sta PERSISTENCY_BANK_CTL,y
		sta wsync
		mwa #CART_RAM_START ptr

		ldy #0

smp_02		
		lda (ptr),y
		cmp #$ff
		beq smp_01
		inw ptr
		jmp smp_02

		; Some message found
smp_01
		iny				; 1
		lda (ptr),y	
		cmp #$ff ; two FF in a row means end of bank
		beq smp_03
		inw ptr
		dey
		lda (ptr),y
		cmp (show_adventure_message_INTERNAL.id),y
		bne smp_04
		iny
		lda (ptr),y	
		cmp (show_adventure_message_INTERNAL.id),y
		bne smp_04
		iny
		lda (ptr),y	
		cmp (show_adventure_message_INTERNAL.id),y
		bne smp_04

		; Message found, copy it to ADV_MESSAGE_BUFFER
		mwa #ADV_MESSAGE_BUFFER ptr2
		adw ptr #4
		ldy #0
smp_07
		lda (ptr),y
		cmp #$ff ; Last char
		sta (ptr2),y
		beq smp_X
		inw ptr
		inw ptr2
		jmp smp_07

smp_04	; Not this message
		inw ptr
		ldy #0
		jmp smp_02

; 				cmp (show_adventure_message_INTERNAL.id),y
; 				bne @-2
; 				lda io_buffer+2
; 				iny
; 				cmp (show_adventure_message_INTERNAL.id),y
; 				bne @-2
; 				lda io_buffer+3
; 				iny
; 				cmp (show_adventure_message_INTERNAL.id),y 
; Next bank
smp_03		
		inc slot
		jmp smp_06

				;build_and_open_messages_file_name
				
				; Look for appropriate message
;;@				
; 				#if .byte ext_ram_banks <> #0
; 					extended_mem ext_ram_bank_msg
; 					mem_read_record_OPT1
; 					main_mem
; 				#else
; 					jsr io_read_record_OPT1
; 				#end
; @				lda io_buffer
; 				cmp #$ff			; This indicates that the message ID has been read
; 				bne @-1
				
; @				lda io_buffer+1
; 				ldy #0
; 				cmp (show_adventure_message_INTERNAL.id),y
; 				bne @-2
; 				lda io_buffer+2
; 				iny
; 				cmp (show_adventure_message_INTERNAL.id),y
; 				bne @-2
; 				lda io_buffer+3
; 				iny
; 				cmp (show_adventure_message_INTERNAL.id),y 
; 				bne @-2
; 				rts
smp_X
				sta CART_DISABLE_CTL
				sta wsync
				rts
.endp

; Builds the message filename
; .proc build_and_open_messages_file_name
; 				#if .byte ext_ram_banks <> #0
; 					; Load from extended RAM
; 					mwa #EXTRAM_MESSAGES ext_ram_tmp
; 				#else
; 					mwa drive_id		io_buffer
; 					mwa #$534d io_buffer+2	; "MS"
; 					mva #$9b io_buffer+4	; eol
; 					io_find_free_iocb
; 					io_open_file_OPT1
; 				#end
; 				rts
; .endp

; Stores the part of the status bar that
; displays level name in the buffer.
.proc store_level_name
				ldy #0
@				lda screen_mem+23*40+19,y
				sta LEVEL_NAME_BUFFER1,y
				lda screen_mem+22*40+19,y
				sta LEVEL_NAME_BUFFER2,y
				iny
				cpy #21
				bne @-
				rts
.endp

; Restores the part of the status bar that
; displays level name from the buffer.
.proc restore_level_name
				ldy #0
@				lda LEVEL_NAME_BUFFER1,y
				sta screen_mem+23*40+19,y
				lda LEVEL_NAME_BUFFER2,y
				sta screen_mem+22*40+19,y
				iny
				cpy #21
				bne @-
				rts
.endp

; Shows the message on the status bar
.proc show_status_message_INTERNAL(.word id) .var
.zpvar id .word
.var line .byte
				store_level_name
				clear_status_bar
				
				lda id
				sta show_adventure_message_INTERNAL.id
				lda id+1
				sta show_adventure_message_INTERNAL.id+1
				
				;preload_correct_message_file id
				
				ldx #%01000000
				stx NMIEN	
				show_message_prerequisites
				mva #21 show_adventure_message_INTERNAL.line
ssm0			
				; #if .byte ext_ram_banks <> #0
				; 	extended_mem ext_ram_bank_msg
				; 	mem_read_record_OPT1
				; 	main_mem
				; #else
;					jsr io_read_record_OPT1
;					bmi ssm1
;				#end

				lda io_buffer
				cmp #$9b
				beq ssm1
				cmp #$ff
				beq ssm1 
				print_string #io_buffer #3 show_adventure_message_INTERNAL.line #0
				inc show_adventure_message_INTERNAL.line
				jmp ssm0
ssm1
;				#if .byte ext_ram_banks = #0
;					io_close_file
;				#end
				ldx #%11000000
				stx NMIEN	
				show_status_border
				lda msg_wait_fire
				cmp #0
				bne @+
				wait_for_fire #0
				recover_from_status_message
@				rts
.endp

; .proc preload_correct_message_file(.word id_q) .var
; .zpvar id_q .word
; ; Check which message file should be loaded
; 				lda #1
; 				sta slow
; 				ldy #0
; 				lda (id_q),y
; 				cmp #$32
; 				beq @+2
; 				tax
; 				iny
; 				lda (id_q),y
; 				cmp #$39
; 				bne @+
; 				iny
; @				cpx #$31
; 				bne @+
; 				iny
; @				cpy #3
; 				beq @+
; ; "ms" file is needed
; 				#if .byte game_state.current_msg_file = #0
; 					; Already loaded
; 					jmp sam2
; 				#else
; 					preload_messages #$534d
; 					mva #0 game_state.current_msg_file
; 					jmp sam2
; 				#end
; 				jmp sam2
; ; "mt" file is needed
; @				#if .byte game_state.current_msg_file = #1
; 					; Already loaded
; 					jmp sam2
; 				#else
; 					preload_messages #$544d
; 					mva #1 game_state.current_msg_file
; 					jmp sam2
; 				#end
; sam2			
; 				rts
; .endp

.proc play_adventure_music
				lda RANDOM
				sta srom
				sec
				sbc #51*1
				bcc pam1
				lda srom
				sec
				sbc #51*2
				bcc pam2
				lda srom
				sec
				sbc #51*3
				bcc pam3
				lda srom
				sec
				sbc #51*4
				bcc pam4
				lda #$18
				jmp pam_s
pam4			lda #$15
				jmp pam_S
pam3			lda #$12
				jmp pam_s
pam2			lda #$0f
				jmp pam_s
pam1			lda #$0c
				
pam_S			music_init @
				music_play
				rts
.endp

; Displays the adventure message on the screen
; and handles all logic within the message.
.proc show_adventure_message_INTERNAL(.word id) .var
.zpvar id .word
.var line .byte
;				preload_correct_message_file id
				
				; Prepare the screen screen
				disable_antic
				clear_status_bar
				switch_advmessage_state
				show_advmessage_border
				;build_advmsg_file_name
;				load_screen #screen_mem+$640 #12*40
				hide_hero
				hide_sprites
				build_advmap_font_file_name
;				open_object_file
				read_font
;				io_close_file
				display_adventure_picture
				ldx <dl_adventure_message
				ldy >dl_adventure_message
				stx SDLSTL
				sty SDLSTL+1				
								
				show_message_prerequisites

				mva #42 line
				mwa #ADV_MESSAGE_BUFFER ext_ram_tmp
sam0			
				adv_buffer_read_record
				
				; #if .byte ext_ram_banks <> #0
				; 	extended_mem ext_ram_bank_msg
				; 	mem_read_record_OPT1
				; 	main_mem
				; #else
				; 	jsr io_read_record_OPT1
				; 	bmi sam1
				; #end

				lda io_buffer_cart
				cmp #$ff
				beq sam1 
				print_string #io_buffer_cart #3 line #0
				inc line
				inw ext_ram_tmp
				jmp sam0
sam1
				; #if .byte ext_ram_banks = #0
				; 	io_close_file
				; #end

				dli_switch_to_adventure_message
				enable_antic	

cipeczka
				
				play_adventure_music
				wait_for_fire #0
				stop_music 
				disable_antic	
				
				; Invalidate font so it will reload on exiting the adventure message
				invalidate_font
								
				; Restore screen
				show_hero
				
				switch_advmessage_state			
				ldx <dl_game_screen
				ldy >dl_game_screen
				stx SDLSTL
				sty SDLSTL+1					
				dli_switch_from_adventure_message
				enable_antic
				
				rts
.endp

.proc	io_read_binary(.word buf_addr .word buf_len) .var
.var	buf_addr .word
.var	buf_len .word
		rts
.endp

.proc	io_cart_load_picture
.zpvar	ptr .word
.zpvar	ptr2 .word
.var	slot .byte
		lda #0
		sta NMIEN

		ldx #5	; How many pics per bank

		lda #16
		sta slot

ioclp_04
		ldy slot
		sta PERSISTENCY_BANK_CTL,y
		sta wsync

		mwa #CART_RAM_START ptr

ioclp_01
		ldy #0
		lda (ptr),y
		cmp io_buffer_cart
		bne ioclp_03
		iny
		lda (ptr),y
		cmp io_buffer_cart+1
		bne ioclp_03
		iny
		lda (ptr),y
		cmp io_buffer_cart+2
		bne ioclp_03
		iny
		lda (ptr),y
		cmp io_buffer_cart+3
		bne ioclp_03

		; Picture found - copy 1600 bytes into "screen_mem"
		mwa #screen_mem ptr2
		adw ptr #4 ; Skip file name
		ldy #0
ioclp_05		
		lda (ptr),y
		sta (ptr2),y
		inw ptr
		inw ptr2
		#if .word ptr2 = #(screen_mem+40*40)
			lda (ptr),y
			sta adv_color_1
			iny
			lda (ptr),y
			sta adv_color_2
			iny
			lda (ptr),y
			sta adv_color_3
			jmp ioclp_X
		#end
		jmp ioclp_05
ioclp_03
		dex
		cpx #0
		beq ioclp_00 ; Finish for this bank
		adw ptr #1607 ; Advance to next slot
		jmp ioclp_01

ioclp_00
		inc slot
		jmp ioclp_04 ; Don't check if we're past the last bank. Musimy znalezc pic inaczej chuj tam niech sie dzieje co chce

ioclp_X
		sta CART_DISABLE_CTL
		sta wsync

		rts
.endp

vbi_routine
		jsr RASTERMUSICTRACKER+3	;Play
		jmp XITVBV

.STRUCT	game
		current_map			.dword		; Id of the map being displayed
		link_right			.dword		; Id of the map linked to the right
		link_left			.dword		; Id of the map linked to the left
		link_top			.dword		; Id of the map linked at the top
		link_bottom			.dword		; Id of the map linked to the bottom
		current_font		.long		; Number of currently used font (to prevent unnecessary reloading) 
		logic_dll_name		.word		; Number of currently used logic DLL (to prevent unnecessary reloading)
		current_msg_file	.byte		; Currently loaded message file (0 = ms, 1 = mt)
.ENDS

.var	cio_handle 			.byte
.var	item_being_loaded	.byte

; Some global variables
.zpvar 		screen_tmp			.word
//.var		tmp_channel 		.word
.var		load_map_item_tmp	.byte
.zpvar		load_map_object_tmp	.word
.var		tmp_transchar		.byte
.var		tmp_pipes			.byte
.var		file_open_mode		.byte
.var		filename 			.word
.var		save_load_ok		.byte

; ------------- END BANKED - MUST BE ASSMBLED BEFORE $4000
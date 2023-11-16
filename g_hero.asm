;	@com.wudsn.ide.asm.mainsourcefile=main.asm

.STRUCT hero
		state			.byte		; Current hero state
		jump_counter	.byte		; How long to jump
.ENDS

hero_jump_time			equ 20

; Hero states
hs_falling	equ 0
hs_jumping	equ 1
hs_grounded	equ 2

; Hero colors
hc_alive	equ 188
hc_dead		equ	14

; Variables used for animation
.zpvar	hero_data_offset	.word
.var	hero_anim_count		.byte
.var	hero_stand_count	.byte
.var	hero_tupta_count	.word
hero_anim_time				equ			2
hero_anim_time_dead			equ			3
hero_tuptac_time			equ			15
hero_stand_time				equ			244
hero_tupta_time				equ			600



; Sets up all initial hero-related variables
.proc initialize_hero_state
				mva #hs_falling 	hero_state.state
				sta hero_stand_count
				sta hero_tupta_count
				sta hero_tupta_count+1
				lda #hc_alive
				sta PCOLR0
				mva #$5c hero_XPos
				mva #$8e hero_YPos
; DEBUG
;				mva #$8c hero_XPos
;				mva #$98 hero_YPos
				rts
.endp

; Switches to the next animation frame
.proc animate_hero
				ldy hero_anim_count
				dey
				sty hero_anim_count
				cpy #0
				jne ah_X
				
				lda game_flags
				and #FLAGS_HERO_TUPTA
				cmp #FLAGS_HERO_TUPTA
				beq ah2
				
				lda logic_flags_003
				and #LF_RZYGON_DEAD
				cmp #LF_RZYGON_DEAD
				beq ah6
				mva #hero_anim_time hero_anim_count
				jmp ah7
ah6				mva #hero_anim_time_dead hero_anim_count
ah7				
				jmp ah3
ah2 
				mva #hero_tuptac_time hero_anim_count

ah3				clc
				lda hero_data_offset
				adc #24
				sta hero_data_offset
				lda hero_data_offset+1
				adc #0
				sta hero_data_offset+1

				lda game_flags
				and #FLAGS_HERO_TUPTA
				cmp #FLAGS_HERO_TUPTA
				beq ah1
				
				lda logic_flags_003
				and #LF_RZYGON_DEAD
				cmp #LF_RZYGON_DEAD
				beq ah4
				#if .word hero_data_offset = #hero_data_finish
					mwa #hero_data hero_data_offset
				#end
				jmp ah5			
ah4
				#if .word hero_data_offset = #hero_data_dead_finish
					mwa #hero_data_dead hero_data_offset
				#end
ah5
				
				draw_hero
				rts
ah1
				lda logic_flags_003
				and #LF_RZYGON_DEAD
				cmp #LF_RZYGON_DEAD
				beq @+
				#if .word hero_data_offset = #hero_data_standing_finish
					mwa #hero_data_standing hero_data_offset
				#end
				jmp ah8			
@				#if .word hero_data_offset = #hero_data_dead_standing_finish
					mwa #hero_data_dead_standing hero_data_offset
				#end
				
ah8				
				draw_hero				
ah_X			rts
.endp

; Sets the flag that indicates that hero is facing left
; so bits will be mirrored when drawing a hero
.proc turn_hero_left
				lda game_flags
				ora #FLAGS_HERO_LEFT
				sta game_flags
				rts
.endp

; Clears the flag that indicates that hero is facing left
; so bits will NOT be mirrored when drawing a hero
.proc turn_hero_right
				lda game_flags
				and #~FLAGS_HERO_LEFT
				sta game_flags
				rts
.endp

; Makes hero do the walking animation again
.proc restore_hero_walk_animation
				lda #0
				sta hero_stand_count
				sta hero_tupta_count
				sta hero_tupta_count+1
				lda game_flags
				and #FLAGS_HERO_FRONT
				cmp #FLAGS_HERO_FRONT
				bne rhwa_0
				lda logic_flags_003
				and #LF_RZYGON_DEAD
				cmp #LF_RZYGON_DEAD
				beq @+ 
				mwa #hero_data hero_data_offset
				jmp rhwa_1
@				mwa #hero_data_dead hero_data_offset				
rhwa_1			lda game_flags
				eor #FLAGS_HERO_FRONT
				and #~FLAGS_HERO_TUPTA
				sta game_flags
				mwa #0 hero_tupta_count
				lda #1
				sta hero_anim_count
rhwa_0			rts
.endp


; Moves the main hero up
; MinPos = $20
.proc hero_up
				ldx hero_YPos
				dex
				stx hero_YPos
				sprite_0_up
hu_X			rts
.endp

; Checks if hero can move up or down.
; If yes, A=0
.proc can_hero_move_vertical(.byte up) .var
.var screenX, screenY .byte
.var up .byte
				hero_hpos_to_screen_pos_with_remainder
				stx screenX
				pha
				
				ldx up
				hero_vpos_to_screen_pos ,
				#if .byte up = #0
					iny
					iny
					iny
				#else
					dey
				#end
				tya
				
				ldx screenX
				on_screen , @
				isnt_on_trasnchar
				cmp #0
				jne chmv0
				
				ldy #1
				on_screen_reuse , 
				isnt_on_trasnchar
				cmp #0
				jne chmv0
				
				pla
				cmp #0	; Check sprite-char alignment 
				beq @+

				ldy #2				
				on_screen_reuse , 
				isnt_on_trasnchar
				cmp #0
				jne chmv1

@
				lda #0
				rts

				; No movement possible
chmv0			pla
chmv1			lda #1
				rts
.endp

; Checks if char in A is present on the transparent
; chars list.
; A=0 - char is present
; A=1 - char isn't present
.proc isnt_on_trasnchar
.var	tmp .byte
				cmp #0
				beq @+1
				sta tmp
				
				ldy TRANSCHAR_COUNT
				cpy #0
				beq @+
				dey
iot0			lda TRANSCHARS,y
				cmp tmp
				beq @+1
				dey
				cpy #$ff
				bne iot0
@				lda #1
				rts
@				lda #0
				rts
.endp

; Checks if hero can move right.
; If yes, A=0
.proc can_hero_move_right
.var screenX, screenY .byte
				hero_vpos_to_screen_pos_with_remainder
				stx screenY
				pha
				
				hero_hpos_to_screen_pos
				tya
				tax
				inx
				inx
				
				lda screenY
				on_screen , @
				isnt_on_trasnchar
				cmp #0
				jne chmr0
				
				ldy #40
				on_screen_reuse , 
				isnt_on_trasnchar
				cmp #0
				jne chmr0
				
				ldy #2*40				
				on_screen_reuse , 
				isnt_on_trasnchar
				cmp #0
				jne chmr0

				pla
				cmp #0	; Check sprite-char alignment 
				beq @+

				ldy #3*40				
				on_screen_reuse , 
				isnt_on_trasnchar
				cmp #0
				jne chmr1

@
				lda #0
				rts

				; No movement possible
chmr0			pla
chmr1			lda #1
				rts
.endp

; Checks if hero can move left.
; If yes, A=0
.proc can_hero_move_left
.var screenX, screenY .byte
				hero_vpos_to_screen_pos_with_remainder
				stx screenY
				pha
				
				ldx hero_Xpos
				dex
				stx hero_Xpos
				hero_hpos_to_screen_pos
				inx
				stx hero_Xpos
				tya
				tax
				
				lda screenY
				on_screen , @
				isnt_on_trasnchar
				cmp #0
				jne chml0
				
				ldy #40
				on_screen_reuse , 
				isnt_on_trasnchar
				cmp #0
				jne chml0
				
				ldy #2*40				
				on_screen_reuse , 
				isnt_on_trasnchar
				cmp #0
				jne chml0

				pla
				cmp #0	; Check sprite-char alignment 
				beq @+

				ldy #3*40				
				on_screen_reuse , 
				isnt_on_trasnchar
				cmp #0
				jne chml1

@
				lda #0
				rts

				; No movement possible
chml0			pla
chml1			lda #1
				rts
.endp

/*
; Check whether the main hero should move.
; If yes, A=1, otherwise 0
.proc count_movement
				lda #1
				rts

				lda #0
				ldx hero_state.move_delay
				inx
				cpx #hero_move_delay
				beq cm0
				stx hero_state.move_delay
				rts
cm0				sta hero_state.move_delay
				lda #1
				rts
.endp
*/

; Performs the free-fall of the main hero
.proc hero_gravity
				can_hero_move_vertical #0
				cmp #0
				jne hg0
				ldx hero_YPos
				cpx #$a8
				bne hg1
				follow_down #0
				ldx #32
				stx hero_YPos
				clear_hero
				draw_hero
				rts
hg1				inx
				inx
				stx hero_YPos
				sprite_0_down
				sprite_0_down
hg_X			rts
hg0				mva #hs_grounded 	hero_state.state
				rts
.endp

; Performs the anti-free-fall of the main hero :)
.proc hero_antigravity
				can_hero_move_vertical #1
				cmp #0
				jne hag0
				ldx hero_YPos
				cpx #34
				bne hag1
				follow_up #0
				ldx #$a8
				stx hero_YPos
				clear_hero
				draw_hero
				mva #$ff to_be_delayed
				delay
				rts
hag1			dex
				dex
				stx hero_YPos
				sprite_0_up
				sprite_0_up
				ldx hero_state.jump_counter
				dex
				stx hero_state.jump_counter
				cpx #0
				bne hag_X
hag0			mva #hs_falling 	hero_state.state
hag_X			rts
.endp

; Makes hero "tuptac"
.proc make_hero_tupta
				lda logic_flags_003
				and #LF_RZYGON_DEAD
				cmp #LF_RZYGON_DEAD
				beq mht00
				mwa #hero_data_standing hero_data_offset				
				jmp mht01
mht00			mwa #hero_data_dead_standing hero_data_offset				
mht01			lda game_flags
				eor #FLAGS_HERO_TUPTA
				sta game_flags
				rts
.endp

; Manipulates main hero according to current state
.proc process_hero_state
				lda game_flags
				and #FLAGS_HERO_FRONT
				cmp #FLAGS_HERO_FRONT
				bne @+1
				lda game_flags
				and #FLAGS_HERO_TUPTA
				cmp #FLAGS_HERO_TUPTA
				bne @+
				animate_hero
				rts
@				inw hero_tupta_count
				cpw hero_tupta_count #hero_tupta_time
				bne @+
				jsr make_hero_tupta
				rts
@				lda hero_state.state
				cmp #hs_falling
				jne @+
				hero_gravity
				jmp phs_X
@				cmp #hs_grounded				
				jne @+
				can_hero_move_vertical #0
				cmp #0
				jne phs_X
				mva #hs_falling 	hero_state.state
				jmp phs_X
@				cmp #hs_jumping				
				jne @+
				hero_antigravity
@
phs_X			
				inc hero_stand_count
				ldx hero_stand_count
				cpx #hero_stand_time
				bne @+
				turn_hero_front
@				rts
.endp

; Makes the hero facing to the player
.proc turn_hero_front
				lda game_flags
				ora #FLAGS_HERO_FRONT
				sta game_flags
				lda logic_flags_003
				and #LF_RZYGON_DEAD
				cmp #LF_RZYGON_DEAD
				beq @+ 
				lda <hero_data_standing
				sta hero_data_offset
				lda >hero_data_standing
				sta hero_data_offset+1
				jmp thf_00
@				lda <hero_data_dead_standing
				sta hero_data_offset
				lda >hero_data_dead_standing
				sta hero_data_offset+1
thf_00			draw_hero								
				rts
.endp

; Performs the action depending on the current context
; 1. When on item - displays menu (pick up? - Yes/No)
; 2. ...
.proc hero_action
				lda ITEM_CONTACT
				cmp #0
				beq @+

; --- Assuming we will not spawn more than 51 items in the game world				
				; Picking up
				find_free_pocket_socket
;				cpx #0
;				beq ha_X	; Not picking up - no free pocket socket

				pick_up_item
@				rts
.endp

; Hides the hero
.proc hide_hero
				lda #0
				sta HPOSP0
				rts
.endp

; Shows the hero
.proc show_hero
				lda hero_Xpos
				sta HPOSP0
				rts
.endp

; Moves the main hero left
; MinPos = $30
.proc hero_left_INTERNAL
				restore_movement_when_needed
				txa
				pha
				ldx hero_XPos
				dex
				cpx #$2f
				beq @+1
				can_hero_move_left
				cmp #0
				jne @+
				ldx hero_XPos
				dex
				stx hero_XPos
				stx HPOSP0
				turn_hero_left
				animate_hero
				#if .byte hero_state = #hs_grounded
					hero_gravity
				#end
@				pla
				tax
				rts
@				ldx #$c8
				stx hero_XPos
				stx HPOSP0
				follow_left
				pla
				tax
				rts
.endp

.proc restore_movement_when_needed
				lda game_flags
				and #FLAGS_HERO_FRONT
				cmp #FLAGS_HERO_FRONT
				bne @+
				restore_hero_walk_animation
@				
				rts
.endp

; Moves the main hero right
; MaxPos = $c8
.proc hero_right_INTERNAL
				restore_movement_when_needed
				ldx hero_XPos
				inx
				cpx #$c9
				beq @+1
				can_hero_move_right
				cmp #0
				jne @+
				ldx hero_XPos
				inx
				stx hero_XPos
				stx HPOSP0
				turn_hero_right
				animate_hero
				#if .byte hero_state = #hs_grounded
					hero_gravity
				#end
@				rts
@				ldx #$30
				stx hero_XPos
				stx HPOSP0
				follow_right #0
				rts
.endp

; Draws the main hero on the current position
.proc draw_hero_INTERNAL
.var tmp .byte
				ldy #0
				sty tmp
				ldx	hero_YPos
@				lda (hero_data_offset),y
				pha
				
				lda game_flags
				and #FLAGS_HERO_LEFT
				cmp #FLAGS_HERO_LEFT
				beq dh0
				pla 
				tay
				lda bit_mirror_lut,y
				ldy tmp
				jmp dh1
dh0				
				pla			
dh1				sta pmg_hero,x
				iny
				sty tmp
				inx
				cpy #(3*8)
				bne @-

				rts
.endp

; Turs the hero into skeleton
.proc turn_hero_dead_INTERNAL
				lda logic_flags_003
				ora #LF_RZYGON_DEAD
				sta logic_flags_003
				
				mwa #hero_data_dead hero_data_offset
				mva #hero_anim_time hero_anim_count
				
				lda #hc_dead
				sta PCOLR0				
				
				draw_hero
				rts
.endp

; Turs the hero into hero (back from skeleton form)
.proc turn_hero_alive_INTERNAL
				lda logic_flags_003
				and #~LF_RZYGON_DEAD
				sta logic_flags_003
				
				mwa #hero_data hero_data_offset
				mva #hero_anim_time hero_anim_count
	
				lda #hc_alive
				sta PCOLR0

				draw_hero
				rts
.endp
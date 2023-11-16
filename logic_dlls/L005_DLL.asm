;	@com.wudsn.ide.asm.mainsourcefile=../main.asm
				org logic_dll
				
.proc process_logic
				mwa #0 current_action
					
				; "Ujœcie krypty" = MAP0144.MAP
				is_on_30313434
				cpx #1
				bne pl01
				mwa #act_on_action_M0144-1 act_on_action_vector
				process_logic_M0144
				rts
pl01

				; "Halucynacje" = MAP0155.MAP
				is_on_30313535
				cpx #1
				bne pl02
				process_logic_M0155
				rts
pl02

				; "Ci¹g w dó³" = MAP0153.MAP
				is_on_30313335
				cpx #1
				bne pl03
				mwa #act_on_action_M0153-1 act_on_action_vector
				process_logic_M0153
				rts
pl03

				; "Nora w tunelu" = MAP0162.MAP
				is_on_30313236
				cpx #1
				bne pl04
				mwa #act_on_action_M0162-1 act_on_action_vector
				process_logic_M0162
				rts
pl04

				; "Kwaterki" = MAP0164.MAP
				is_on_30313436
				cpx #1
				bne pl05
				mwa #act_on_action_M0164-1 act_on_action_vector
				process_logic_M0164
				rts

pl05
				; "Kostucha" = MAP0156.MAP
				is_on_30313635
				cpx #1
				bne pl06
				mwa #act_on_action_M0156-1 act_on_action_vector
				process_logic_M0156
				rts

pl06
				; "Piekielne zakrety" = MAP0132.MAP
				is_on_31303233
				cpx #1
				bne pl07
				mwa #act_on_action_M0132-1 act_on_action_vector
				process_logic_M0132
@				rts
pl07
				; "Dolny grobowiec" = MAP0157.MAP
				is_on_31303735
				cpx #1
				bne pl08
				mwa #act_on_action_M0157-1 act_on_action_vector
				process_logic_M0157
@				rts
pl08
				rts
.endp


; Performs all actions connected to logic on MAP0144
.proc process_logic_M0144
				#if .byte hero_XPos >= #$3b .and .byte hero_XPos <= #$4d .and .byte hero_YPos = #$88
					write_action_name #A_M0003_042
					mwa #A_M0003_042_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_PENETRATE #ACT_EMPTY
				#end
				rts
.endp

; Performs all actions connected to logic on MAP0153
.proc process_logic_M0153
				#if .byte hero_XPos = #$bc .and .byte hero_YPos = #$80
					lda logic_flags_009
					and #LF_URN_PLACED
					cmp #LF_URN_PLACED
					beq @+
					write_action_name #A_M0003_043
					mwa #A_M0003_043_ID current_action
					propagate_action_menu_EXEMEM
@
				#end
				
				#if .byte hero_XPos = #$b0 .and .byte hero_YPos = #$80
					write_action_name #A_M0003_037
					mwa #A_M0003_037_ID current_action
					lda logic_flags_009
					and #LF_VALVE3_ROTATED
					cmp #LF_VALVE3_ROTATED
					beq @+
					propagate_action_menu #ACT_EXPLORE #ACT_ROTATE #ACT_EMPTY
					rts
@					propagate_action_menu_EXEMEM
				#end
				rts
				
.endp

; Performs all actions connected to logic on MAP0144
.proc process_logic_M0155
				#if .byte hero_XPos = #$63
					show_ghost_on_right
				#end
				#if .byte hero_XPos = #$94
					show_ghost_on_left
				#end
				rts
.endp

; Performs all actions connected to logic on MAP0156
.proc process_logic_M0156
				#if .byte hero_XPos = #$ac .and .byte hero_YPos = #$80
					lda logic_flags_006
					and #LF_SUPPOSITORY
					cmp #LF_SUPPOSITORY
					beq @+
					write_action_name #A_M0003_055
					mwa #A_M0003_055_ID current_action
					propagate_action_menu_EXUSEM
				#end
@				#if .byte hero_XPos = #$c4 .and .byte hero_YPos = #$98
					write_action_name #A_M0003_056
					mwa #A_M0003_056_ID current_action
					lda logic_flags_006
					and #LF_SUPPOSITORY
					cmp #LF_SUPPOSITORY
					beq @+
					lda logic_flags_006
					and #LF_EMMENTALER
					cmp #LF_EMMENTALER
					beq plM0156_01
					propagate_action_menu #ACT_SNIFF #ACT_SCRATCH #ACT_TICKLE
					jmp pl_0156_1
plM0156_01			propagate_action_menu #ACT_SNIFF #ACT_EMPTY #ACT_TICKLE
					jmp pl_0156_1
@					lda logic_flags_006
					and #LF_EMMENTALER
					cmp #LF_EMMENTALER
					beq plM0156_02
					propagate_action_menu #ACT_SNIFF #ACT_SCRATCH #ACT_EMPTY
					jmp pl_0156_1
plM0156_02			propagate_action_menu #ACT_SNIFF #ACT_EMPTY #ACT_EMPTY		
				#end
pl_0156_1		
				#if .byte hero_XPos = #$64 .and .byte hero_YPos = #$98
					lda logic_flags_009
					and #LF_CROW_KILLED
					cmp #LF_CROW_KILLED
					beq @+
					write_action_name #A_M0003_075
					mwa #A_M0003_075_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_TALK #ACT_FEED
@					
				#end

				rts
.endp

; Performs all actions connected to logic on MAP0157
.proc process_logic_M0157
				#if .byte hero_XPos = #$88 .and .byte hero_YPos = #$98
					write_action_name #A_M0003_077
					mwa #A_M0003_077_ID current_action
					lda logic_flags_009
					and #LF_URN_PLACED
					cmp #LF_URN_PLACED
					beq @+
					propagate_action_menu #ACT_EXPLORE #ACT_READ #ACT_PLACE
					rts
@					propagate_action_menu #ACT_EXPLORE #ACT_READ #ACT_EMPTY
					rts
				#end
				rts
.endp

; Performs all actions connected to logic on MAP0162
.proc process_logic_M0162
				#if .byte hero_XPos >= #$72 .and .byte hero_XPos <= #$78 .and .byte hero_YPos = #$98
					write_action_name #A_M0003_044
					mwa #A_M0003_044_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_SNIFF #ACT_PENETRATE
				#end
				rts
.endp

; Performs all actions connected to logic on MAP0164
.proc process_logic_M0164
				#if .byte hero_XPos = #$a5
					hide_eyes
				#end
				#if .byte hero_XPos = #$a0
					show_eyes
				#end
				#if .byte hero_XPos >= #$b4 .and .byte hero_XPos <= #$c0 .and .byte hero_YPos = #$68
					write_action_name #A_M0003_045
					mwa #A_M0003_045_ID current_action
					lda logic_flags_009
					and #LF_FREAK_HARRASED
					cmp #LF_FREAK_HARRASED
					beq @+
					propagate_action_menu #ACT_EXPLORE #ACT_OPEN #ACT_HARASS
					rts
@					propagate_action_menu #ACT_EXPLORE #ACT_OPEN #ACT_EMPTY
					rts
				#end
				rts
.endp

; Performs actions on M0144
.proc act_on_action_M0144
				lda current_action
				cmp #A_M0003_042_ID	; Crypt gate
				bne aoaM0144_1
				lda current_action_menu_item
				cmp #0				; Crypt gate -> Explore
				bne @+
				show_status_message #STATUSMSG_107
				rts
@				cmp #1				; Crypt gate -> Penetrate
				bne @+
				mva #$8b hero_XPos
				sta HPOSP0
				mva #$70 hero_YPos
				clear_hero
				draw_hero				
				follow_down #1
				rts				
@
aoaM0144_1
				rts
.endp

; Performs actions on M0132
.proc act_on_action_M0132
				lda current_action
				cmp #A_M0003_076_ID	; Greedy woman
				jne aoaM0132_x1
				lda current_action_menu_item
				cmp #0				; Greedy woman -> Talk
				bne aoaM0132_x2
				show_adventure_message #ADVMSG_183
				prepare_map
				rts
aoaM0132_x2		cmp #1				; Greedy woman -> Rape
				bne aoaM0132_x3
				show_status_message #STATUSMSG_184
				rts
aoaM0132_x3		cmp #2				; Greedy woman -> Give
				bne aoaM0132_x1
				show_pocket
				prepare_map
				is_chosen_in_pocket #ACTI_ZIGMUNT
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				show_status_message #STATUSMSG_185
				logic_M0132_remove_witch #1
				remove_from_pocket #ACTI_ZIGMUNT
				lda logic_flags_009
				eor #LF_WITCH_REMOVED
				sta logic_flags_009
aoaM0132_x1		rts
.endp

; Performs actions on M0153
.proc act_on_action_M0153
				lda current_action
				cmp #A_M0003_043_ID	; Mechanical obstacle
				bne aoaM0153_1
				lda current_action_menu_item
				cmp #0				; Mechanical obstacle -> Explore
				bne @+
				show_status_message #STATUSMSG_108
				rts
@
aoaM0153_1		cmp #A_M0003_037_ID	; Valve
				bne aoaM0153_2
				lda current_action_menu_item
				cmp #0				; Valve -> Explore
				bne @+
				show_status_message #STATUSMSG_190
				rts
@				cmp #1				; Valve -> Use
				bne aoaM0153_2
				logic_0153_rotate_valve
				show_status_message #STATUSMSG_191
				lda logic_flags_009
				eor #LF_VALVE3_ROTATED
				sta logic_flags_009
aoaM0153_2		rts
.endp

; Performs actions on M0156
.proc act_on_action_M0156
				lda current_action
				cmp #A_M0003_055_ID	; Dead man's ass
				bne aoaM0156_1
				lda current_action_menu_item
				cmp #0				; Dead man's as -> Explore
				bne @+
				show_status_message #STATUSMSG_134
				rts
@				cmp #1				; Dead man's as -> Use
				bne aoaM0156_2
				show_pocket
				prepare_map
				show_status_message #STATUSMSG_135
aoaM0156_2
@				rts
aoaM0156_1							
				cmp #A_M0003_056_ID	; Dead man's feet
				bne aoaM0156_5
				lda current_action_menu_item
				cmp #0				; Dead man's as -> Sniff
				bne @+
				show_status_message #STATUSMSG_136
				rts
@				cmp #1				; Dead man's as -> Lick
				bne aoaM0156_4
				show_status_message #STATUSMSG_137
				lda logic_flags_006
				eor #LF_EMMENTALER
				sta logic_flags_006
				spawn_in_pocket #ACTI_CHEESE
				rts
aoaM0156_4		cmp #2				; Dead man's as -> Tickle
				bne aoaM0156_3
				show_pocket
				is_chosen_in_pocket #ACTI_FEATHER
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				lda logic_flags_006
				eor #LF_SUPPOSITORY
				sta logic_flags_006
				logic_M0156_show_suppository
				show_status_message #STATUSMSG_138
aoaM0156_3		rts
aoaM0156_5		cmp #A_M0003_075_ID	; Crow
				bne aoaM0156_6
				lda current_action_menu_item
				cmp #0				; Crow -> Explore
				bne @+
				show_status_message #STATUSMSG_180
				rts
@				cmp #1				; Crow -> Talk
				bne @+
				show_adventure_message #ADVMSG_181
				prepare_map
				rts
@				cmp #2				; Crow -> Feed
				bne @+
				show_pocket
				is_chosen_in_pocket #ACTI_EBOLA
				cpx #1
				beq @+
				is_chosen_in_pocket #ACTI_CHEESE
				cpx #1
				beq aoaM0156_ciul
				finish_with_message_006
				rts
@				prepare_map
				lda logic_flags_009
				eor #LF_CROW_KILLED
				sta logic_flags_009
				logic_M0156_kill_crow
				show_status_message #STATUSMSG_182
				remove_from_pocket #ACTI_EBOLA
@
aoaM0156_6		rts
aoaM0156_ciul	prepare_map
				show_status_message #STATUSMSG_252
				rts
.endp

; Performs actions on M0157
.proc act_on_action_M0157
				lda current_action
				cmp #A_M0003_077_ID	; Altar
				bne aoaM0157_1
				lda current_action_menu_item
				cmp #0				; Altar -> Explore
				bne @+
				show_status_message #STATUSMSG_187
				rts
@				cmp #1				; Altar -> Read
				bne @+
				show_status_message #STATUSMSG_188
				rts
@				cmp #2				; Altar -> Place
				bne @+
				show_pocket
				prepare_map
				is_chosen_in_pocket #ACTI_URN
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				logic_M0157_place_urn
				show_status_message #STATUSMSG_189
				remove_from_pocket #ACTI_URN
				lda logic_flags_009
				eor #LF_URN_PLACED
				sta logic_flags_009
				rts
@
aoaM0157_1				
				rts
.endp

; Performs actions on M0162
.proc act_on_action_M0162
				lda current_action
				cmp #A_M0003_044_ID	; Norah
				bne aoaM0162_1
				lda current_action_menu_item
				cmp #0				; Norah -> Explore
				bne @+
				show_status_message #STATUSMSG_109
				rts
@				cmp #1				; Norah -> Sniff
				bne @+
				show_status_message #STATUSMSG_110
				rts
@				cmp #2				; Norah -> Penetrate
				bne @+
				mva #$5e hero_XPos
				sta HPOSP0
				mva #$a0 hero_YPos
				clear_hero
				draw_hero				
				follow_up #1
				rts
@
aoaM0162_1							
				rts
.endp

; Performs all actions connected to logic on MAP0132
.proc process_logic_M0132
				#if .byte hero_XPos = #$90 .and .byte hero_YPos = #$40
					lda logic_flags_009
					and #LF_WITCH_REMOVED
					cmp #LF_WITCH_REMOVED
					beq @+
					write_action_name #A_M0003_076
					mwa #A_M0003_076_ID current_action
					propagate_action_menu #ACT_TALK #ACT_RAPE #ACT_GIVE
					rts
				#end
@				rts
.endp


; Performs actions on M0164
.proc act_on_action_M0164
				lda current_action
				cmp #A_M0003_045_ID	; Brooken door
				bne aoaM0164_1
				lda current_action_menu_item
				cmp #0				; Brooken door -> Explore
				bne @+
				show_status_message #STATUSMSG_111
				rts
@				cmp #1				; Brooken door -> Open
				bne @+
				show_status_message #STATUSMSG_112
				rts
@				cmp #2				; Brooken door -> Harass
				bne @+
				show_pocket
				prepare_map
				is_chosen_in_pocket #ACTI_DILDO
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				show_adventure_message #ADVMSG_186
				prepare_map
				spawn_in_pocket #ACTI_URN
				lda logic_flags_009
				eor #LF_FREAK_HARRASED
				sta logic_flags_009
@
aoaM0164_1
				rts
.endp

; Assures that all actions done to the
; particular map are visible when
; map is preloaded.
				org logic_dll_post
								
.proc post_load_logic
				disable_lightning
				
				; ============== MAP 0156 ==========
				is_on_30313635
				cpx #1
				jne pll_next_map_0001
				lda logic_flags_009
				and #LF_CROW_KILLED
				cmp #LF_CROW_KILLED
				bne @+
				logic_M0156_kill_crow
@				lda logic_flags_006
				and #LF_SUPPOSITORY
				cmp #LF_SUPPOSITORY
				bne @+
				is_item_in_pocket #ACTI_ASS_PLUG
				cmp #1
				beq @+
				logic_M0156_show_suppository
@				rts

pll_next_map_0001

				; ============== MAP 0132 ==========
				is_on_31303233
				cpx #1
				jne pll_next_map_0002
				lda logic_flags_009
				and #LF_WITCH_REMOVED
				cmp #LF_WITCH_REMOVED
				bne @+
				logic_M0132_remove_witch #0
				rts
				
@				rts

pll_next_map_0002

				; ============== MAP 0157 ==========
				is_on_31303735
				cpx #1
				jne pll_next_map_0003
				lda logic_flags_009
				and #LF_URN_PLACED
				cmp #LF_URN_PLACED
				bne @+
				logic_M0157_place_urn
				rts
				
@				rts

pll_next_map_0003

				; ============== MAP 0153 ==========
				is_on_31303335
				cpx #1
				jne pll_next_map_0004
				lda logic_flags_009
				and #LF_URN_PLACED
				cmp #LF_URN_PLACED
				bne @+
				logic_M0153_remove_barrier
				rts
				
@				rts

pll_next_map_0004
				; Make sure Rzygon can go through
				; the morgue door even if the
				; monster eyes are not visible.
				lda #86
				add_single_char_to_transparent_chars
				lda #22
				add_single_char_to_transparent_chars
				lda #21
				add_single_char_to_transparent_chars
				lda #23
				add_single_char_to_transparent_chars

				rts
.endp

; Shows the hallucination ghost
; on the right side of the screen
.proc show_ghost_on_right
				mva #0 screen_mem+14*40+8
				mva #0 screen_mem+14*40+9
				mva #0 screen_mem+15*40+8
				mva #0 screen_mem+15*40+9
				mva #0 screen_mem+16*40+8
				mva #0 screen_mem+16*40+9
				mva #0 screen_mem+17*40+8
				mva #0 screen_mem+17*40+9

				mva #16 screen_mem+6*40+31
				mva #17 screen_mem+6*40+32
				mva #48 screen_mem+7*40+31
				mva #49 screen_mem+7*40+32
				mva #80 screen_mem+8*40+31
				mva #81 screen_mem+8*40+32
				mva #112 screen_mem+9*40+31
				mva #113 screen_mem+9*40+32
				rts
.endp

; Shows the hallucination ghost
; on the left side of the screen
.proc show_ghost_on_left
				mva #0 screen_mem+6*40+31
				mva #0 screen_mem+6*40+32
				mva #0 screen_mem+7*40+31
				mva #0 screen_mem+7*40+32
				mva #0 screen_mem+8*40+31
				mva #0 screen_mem+8*40+32
				mva #0 screen_mem+9*40+31
				mva #0 screen_mem+9*40+32

				mva #18 screen_mem+14*40+8
				mva #19 screen_mem+14*40+9
				mva #50 screen_mem+15*40+8
				mva #51 screen_mem+15*40+9
				mva #82 screen_mem+16*40+8
				mva #83 screen_mem+16*40+9
				mva #114 screen_mem+17*40+8
				mva #115 screen_mem+17*40+9
				rts
.endp

; Hides the eyes inside the crypt
.proc hide_eyes
				mva #86 screen_mem+9*40+34
				mva #21 screen_mem+9*40+35
				mva #22 screen_mem+10*40+34
				mva #23 screen_mem+10*40+35
				rts
.endp

; Show the eyes inside the crypt
.proc show_eyes
				mva #91 screen_mem+9*40+34
				mva #92 screen_mem+9*40+35
				mva #123 screen_mem+10*40+34
				mva #124 screen_mem+10*40+35
				rts
.endp

; Lowers the barrier
.proc logic_M0153_remove_barrier
				mwa #screen_mem+7*40+34 screen_tmp
				lda #0
				ldy #0
				ldx #6
@				sta (screen_tmp),y
				pha
 				adw screen_tmp #40
				pla
				dex
				bne @-
				rts
.endp

; Shows the suppository near the dead man's ass
.proc logic_M0156_show_suppository
				lda ITEM_1_ID
				cmp #'R'	; Do not move RING
				beq @+
				lda #169
				sta HPOSP1
				sta item1_tmp_pos
@				rts
.endp

; Removes the crow from the map
.proc logic_M0156_kill_crow
				lda #0
				sta screen_mem+15*40+15
				sta screen_mem+15*40+16
				sta screen_mem+15*40+17
				sta screen_mem+16*40+15
				sta screen_mem+16*40+16
				sta screen_mem+16*40+17
				sta screen_mem+17*40+15
				sta screen_mem+17*40+16
				sta screen_mem+17*40+17
				rts
.endp

; Removes the witch
.proc logic_M0132_remove_witch_single_step
				mwa #screen_mem+5*40+26 screen_tmp
				lda #4
				sta slow
@				ldx #3
				ldy #0
@				lda (screen_tmp),y
				pha
				adw screen_tmp #40
				pla
				sta (screen_tmp),y
				sbw screen_tmp #39
				dex
				bne @-				
				sbw screen_tmp #43
				dec slow
				bne @-1
				rts
.endp
.proc logic_M0132_remove_witch(.byte slow) .var
				mva #103 to_be_delayed
				#if .byte slow = #0
					mva #1 to_be_delayed
				#end
				
				ldy #4
@				tya
				pha
				logic_M0132_remove_witch_single_step
				delay
				pla
				tay
				dey
				bne @-
				
				rts
.endp

; Places the urn on the altar
.proc logic_M0157_place_urn
				lda #93
				sta screen_mem+14*40+20
				lda #125
				sta screen_mem+15*40+20
				rts
.endp

; Rotates the valve
.proc logic_0153_rotate_valve
				mva #15 to_be_delayed
				
				ldx #100
@				lda #56
				sta screen_mem+40*13+31
				delay
				lda #55
				sta screen_mem+40*13+31
				delay
				dex
				cpx #0
				bne @-
				rts
.endp

.proc is_on_30313434
				is_on_map_3130 #$3434
				rts
.endp

.proc is_on_30313535
				is_on_map_3130 #$3535
				rts
.endp

.proc is_on_30313335
				is_on_map_3130 #$3335
				rts
.endp

.proc is_on_30313236
				is_on_map_3130 #$3236
				rts
.endp

.proc is_on_30313436
				is_on_map_3130 #$3436
				rts
.endp

.proc is_on_30313635
				is_on_map_3130 #$3635
				rts
.endp
.proc is_on_31303233
				is_on_map_3130 #$3233
				rts
.endp
.proc is_on_31303735
				is_on_map_3130 #$3735
				rts
.endp
.proc is_on_31303335
				is_on_map_3130 #$3335
				rts
.endp
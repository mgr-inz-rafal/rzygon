;	@com.wudsn.ide.asm.mainsourcefile=../main.asm
				org logic_dll
				
.proc process_logic
				mwa #0 current_action
					
				; "Czarna dziura" = MAP0116.MAP
				is_on_31303631
				cpx #1
				bne pl0
				mwa #act_on_action_M0116-1 act_on_action_vector
				process_logic_M0116
@				rts
pl0
				; "Wejœcie do piek³a" = MAP0081.MAP
				is_on_30303138
				cpx #1
				bne pl1
				mwa #act_on_action_M0081-1 act_on_action_vector
				process_logic_M0081
@				rts
pl1
				; "Trupi mechanizm" = MAP0126.MAP
				is_on_30313632
				cpx #1
				bne pl2
				mwa #act_on_action_M0126-1 act_on_action_vector
				process_logic_M0126
@				rts
pl2
				; "Górna krypta" = MAP0119.MAP
				is_on_30313931
				cpx #1
				bne pl3
				mwa #act_on_action_M0119-1 act_on_action_vector
				process_logic_M0119
@				rts
pl3
				; "Korytarz" = MAP0131.MAP
				is_on_30313133
				cpx #1
				bne pl4
				mwa #act_on_action_M0131-1 act_on_action_vector
				process_logic_M0131
@				rts
pl4
				; "Koœci" = MAP0140.MAP
				is_on_30310134
				cpx #1
				bne pl5
				mwa #act_on_action_M0140-1 act_on_action_vector
				process_logic_M0140
@				rts
pl5
				; "Niebo w piekle" = MAP0139.MAP
				is_on_30319133
				cpx #1
				bne pl6
				mwa #act_on_action_M0139-1 act_on_action_vector
				process_logic_M0139
@				rts
pl6
				; "Pieczara Biesa" = MAP0141.MAP
				is_on_30319134
				cpx #1
				bne pl7
				mwa #act_on_action_M0141-1 act_on_action_vector
				process_logic_M0141
@				rts
pl7
				; "Wyjscie z lochow" = MAP0047.MAP
				is_on_30303734
				cpx #1
				bne pl8
				mwa #act_on_action_M0047-1 act_on_action_vector
				process_logic_M0047
@				rts
pl8
				; "Dno studni" = MAP0109.MAP
				is_on_31303930
				cpx #1
				bne pl9
				mwa #act_on_action_M0109-1 act_on_action_vector
				process_logic_M0109
@				rts
pl9
				; "Straznik piekiel" = MAP0110.MAP
				is_on_31303031
				cpx #1
				bne pl10
				mwa #act_on_action_M0110-1 act_on_action_vector
				process_logic_M0110
@				rts
pl10
				rts
.endp

; Performs actions on M0047
.proc act_on_action_M0047
				lda current_action
				cmp #A_M0003_039_ID	; Note
				bne aoaM0047_1
				lda current_action_menu_item
				cmp #0				; Note -> Read
				bne @+
				show_status_message #STATUSMSG_098
@				rts
aoaM0047_1		
				cmp #A_M0003_040_ID	; Sinister door
				bne aoaM0047_1
				lda current_action_menu_item
				cmp #0				; Sinister door -> Explore
				bne @+
				show_status_message #STATUSMSG_099
@				cmp #1				; Sinister door -> Open
				bne @+
				lda logic_flags_005
				and #LF_HELL_DOOR_OPENED
				cmp #LF_HELL_DOOR_OPENED
				bne aoaM0047_3
				mva #$b1 hero_XPos
				sta HPOSP0
				mva #$a0 hero_YPos
				clear_hero
				draw_hero				
				follow_right #1
				rts
aoaM0047_3		show_status_message #STATUSMSG_100
				rts
@				cmp #2				; Sinister door -> Use
				bne aoaM0047_2
				show_pocket
				is_chosen_in_pocket #ACTI_HELL_KEY
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				show_status_message #STATUSMSG_101
				lda logic_flags_005
				eor #LF_HELL_DOOR_OPENED
				sta logic_flags_005
aoaM0047_2		rts
.endp

; Performs all actions connected to logic on MAP0047
.proc process_logic_M0047
				#if .byte hero_XPos >= #$5e .and .byte hero_XPos <= #$64 .and .byte hero_YPos = #$98
					write_action_name #A_M0003_039
					mwa #A_M0003_039_ID current_action
@					propagate_action_menu #ACT_READ #ACT_EMPTY #ACT_EMPTY
					rts
				#end
				#if .byte hero_XPos >= #$4b .and .byte hero_XPos < #$5c .and .byte hero_YPos = #$98
					write_action_name #A_M0003_040
					mwa #A_M0003_040_ID current_action
					lda logic_flags_005
					and #LF_HELL_DOOR_OPENED
					cmp #LF_HELL_DOOR_OPENED
					beq @+
					propagate_action_menu_EXOPUS
					rts
@					propagate_action_menu #ACT_EXPLORE #ACT_OPEN #ACT_EMPTY
					rts
				#end
				rts
.endp

; Performs all actions connected to logic on MAP0109
.proc process_logic_M0109
				#if .byte hero_XPos = #$88 .and .byte hero_YPos = #$90
					write_action_name #A_M0003_064
					mwa #A_M0003_064_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_TALK #ACT_LICK
				#end
				rts
.endp

; Performs all actions connected to logic on MAP0110
.proc process_logic_M0110
				#if .byte hero_XPos = #$64 .and .byte hero_YPos = #$80
					lda logic_flags_008
					and #LF_BEAST_CARVED
					cmp #LF_BEAST_CARVED
					beq @+
					write_action_name #A_M0003_065
					mwa #A_M0003_065_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_TALK #ACT_CARVE
				#end
@				rts
.endp

; Performs actions on M0109
.proc act_on_action_M0109
				lda current_action
				cmp #A_M0003_064_ID	; Freak
				jne aoaM0109_x1
				lda current_action_menu_item
				cmp #0				; Freak -> Explore
				bne aoaM0109_x2
				show_status_message #STATUSMSG_157
				rts
aoaM0109_x2		cmp #1				; Freak -> Talk
				bne aoaM0109_x3
				lda logic_flags_007
				and #LF_WITCHER_HANDLED
				cmp #LF_WITCHER_HANDLED
				beq @+
				show_adventure_message #ADVMSG_156
				prepare_map
				rts
@				show_status_message #STATUSMSG_159
				logic_M0109_show_stair
				rts
aoaM0109_x3		cmp #2				; Freak -> Lick
				bne aoaM0109_x1
				show_status_message #STATUSMSG_158
aoaM0109_x1		rts
.endp

; Performs actions on M0110
.proc act_on_action_M0110
				lda current_action
				cmp #A_M0003_065_ID	; Filthy Reptile
				jne aoaM0110_x1
				lda current_action_menu_item
				cmp #0				; Filthy Reptile -> Explore
				bne aoaM0110_x2
				show_status_message #STATUSMSG_161
				rts
aoaM0110_x2		cmp #1				; Filthy Reptile -> Talk
				bne aoaM0110_x3
				show_adventure_message #ADVMSG_162
				prepare_map
				rts
aoaM0110_x3		cmp #2				; Filthy Reptile -> Carve
				bne aoaM0110_x1
				show_pocket
				is_chosen_in_pocket #ACTI_SWORD
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				logic_M0110_carve_the_beast #1
				lda logic_flags_008
				eor #LF_BEAST_CARVED
				sta logic_flags_008
aoaM0110_x1		rts
.endp

; Performs all actions connected to logic on MAP0081
.proc process_logic_M0081_explore_hard_rock
				write_action_name #A_M0003_032
				mwa #A_M0003_032_ID current_action
				propagate_action_menu #ACT_EXPLORE #ACT_MOVE #ACT_EMPTY
				rts
.endp
.proc process_logic_M0081
				#if .byte hero_XPos = #$c4 .and .byte hero_YPos = #$78
					lda logic_flags_003
					and #LF_HARD_ROCK_MOVED
					cmp #LF_HARD_ROCK_MOVED
					beq @+
					process_logic_M0081_explore_hard_rock
					rts
				#end
@
				#if .byte hero_XPos = #$b0 .and .byte hero_YPos = #$80
					process_logic_M0081_explore_hard_rock
					rts
				#end

				#if .byte hero_XPos >= #$56 .and .byte hero_XPos <= #$65 .and .byte hero_YPos = #$a0
					write_action_name #A_M0003_035
					mwa #A_M0003_035_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_ENTER #ACT_EMPTY
					rts
				#end
			
				#if .byte hero_XPos = #$6a .and .byte hero_YPos <= #$50
					lda	logic_flags_003
					and #LF_RETURN_FROM_HELL_MSG
					cmp #LF_RETURN_FROM_HELL_MSG
					beq @+
					lda logic_flags_003
					eor #LF_RETURN_FROM_HELL_MSG
					sta logic_flags_003
					show_status_message #STATUSMSG_078
					rts
				#end				
@
				#if .byte hero_XPos = #$6a .and .byte hero_YPos <= #$50
					lda	logic_flags_004
					and #LF_HELLGATE_DISAPPEARED
					cmp #LF_HELLGATE_DISAPPEARED
					bne @+
					show_status_message #STATUSMSG_253
					hero_left
					hero_left
					hero_left
					hero_left
					rts
				#end				
@				
				#if .byte hero_XPos >= #$b3 .and .byte hero_XPos <= #$bc .and .byte hero_YPos = #$80
					write_action_name #A_M0003_087
					mwa #A_M0003_087_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_READ #ACT_EMPTY
					rts
				#end
				rts
.endp


; Performs all actions connected to logic on MAP0116
.proc process_logic_M0116
				#if .byte hero_XPos >= #$95 .and .byte hero_XPos <= #$a8 .and .byte hero_YPos = #$98
					lda logic_flags_004
					and #LF_HELLGATE_DISAPPEARED
					cmp #LF_HELLGATE_DISAPPEARED
					beq @+
					write_action_name #A_M0003_035
					mwa #A_M0003_035_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_ENTER #ACT_EMPTY
@					rts
				#end
				
				#if .byte hero_XPos = #$6e
					lda logic_flags_004
					and #LF_HELLGATE_DISAPPEARED
					cmp #LF_HELLGATE_DISAPPEARED
					beq @+
					logic_M0116_hellgate_disappears #1
					show_status_message #STATUSMSG_082
					
					; A hack, to make the skulls non-transparent for Rzygon
					lda #44
					sta TRANSCHARS+3
					sta TRANSCHARS+4
					
					lda logic_flags_004
					eor #LF_HELLGATE_DISAPPEARED
					sta logic_flags_004
@					rts
				#end
				
				rts
.endp

; Performs all actions connected to logic on MAP0119
.proc process_logic_M0119
				#if .byte hero_XPos >= #$37 .and .byte hero_XPos <= #$3c .and .byte hero_YPos = #$50
					write_action_name #A_M0003_037
					mwa #A_M0003_037_ID current_action
					lda logic_flags_004
					and #LF_VALVE2_ROTATED
					cmp #LF_VALVE2_ROTATED
					beq @+
					propagate_action_menu #ACT_EXPLORE #ACT_ROTATE #ACT_LICK
					rts
@					propagate_action_menu #ACT_EXPLORE #ACT_EMPTY #ACT_LICK
					rts
				#end
				rts
.endp

; Performs all actions connected to logic on MAP0126
.proc process_logic_M0126
				#if .byte hero_XPos = hanging_skull_pos .and .byte hero_YPos = #$98
					write_action_name #A_M0003_036
					mwa #A_M0003_036_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_USE #ACT_EMPTY
@					rts
				#end
				rts
.endp

; Performs all actions connected to logic on MAP0131
.proc process_logic_M0131
				#if .byte hero_XPos = #$4c .and .byte hero_YPos = #$a0
					write_action_name #A_M0003_010
					mwa #A_M0003_010_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_USE #ACT_EMPTY
					rts
				#end
				#if .byte hero_XPos >= #$5c .and .byte hero_XPos <= #$61 .and .byte hero_YPos = #$78
					write_action_name #A_M0003_037
					mwa #A_M0003_037_ID current_action
					lda logic_flags_004
					and #LF_VALVE2_UNJAMMED
					cmp #LF_VALVE2_UNJAMMED
					beq @+					
					propagate_action_menu #ACT_EXPLORE #ACT_ROTATE #ACT_UNJAM
					rts
@					lda logic_flags_004
					and #LF_VALVE1_ROTATED
					cmp #LF_VALVE1_ROTATED
					beq @+
					propagate_action_menu #ACT_EXPLORE #ACT_ROTATE #ACT_EMPTY
					rts
@					propagate_action_menu_EXEMEM
					rts
				#end
				rts
.endp

; Performs all actions connected to logic on MAP0139
.proc process_logic_M0139
				#if .byte hero_XPos >= #$c4 .and .byte hero_XPos <= #$c8 .and .byte hero_YPos = #$a0
					write_action_name #A_M0003_037
					mwa #A_M0003_037_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_ROTATE #ACT_EMPTY
					rts
				#end
@
				rts
.endp

; Performs all actions connected to logic on MAP0140
.proc process_logic_M0140
				#if .byte hero_XPos = #$c0 .and .byte hero_YPos = #$78
					lda logic_flags_004
					and #LF_BUTTON_PRESSED
					cmp #LF_BUTTON_PRESSED
					beq @+
					write_action_name #A_M0003_038
					mwa #A_M0003_038_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_ACTIVATE #ACT_EMPTY
					rts
				#end
@

				rts
.endp

; Performs all actions connected to logic on MAP0141
.proc process_logic_M0141
				#if .byte hero_XPos = #$8c .and .byte hero_YPos = #$58
					lda logic_flags_004
					and #LF_HELL_WEED_REMOVED
					cmp #LF_HELL_WEED_REMOVED
					beq @+
					write_action_name #A_M0003_028
					mwa #A_M0003_028_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_USE #ACT_EMPTY
@					rts
				#end
				#if .byte hero_XPos = #$94 .and .byte hero_YPos = #$98
					lda logic_flags_005
					and #LF_HELL_DEMON_PISSING
					cmp #LF_HELL_DEMON_PISSING
					beq @+
					write_action_name #A_M0003_012
					mwa #A_M0003_012_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_TALK #ACT_EMPTY
@					rts
				#end
				#if .byte hero_XPos >= #$ad .and .byte hero_XPos <= #$b8 .and .byte hero_YPos = #$a0
					write_action_name #A_M0003_040
					mwa #A_M0003_040_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_OPEN #ACT_EMPTY
				#end
				#if .byte hero_XPos = #$6c .and .byte hero_YPos = #$a0
					lda logic_flags_005
					and #LF_DEVIL_DOOR_OPENED
					cmp #LF_DEVIL_DOOR_OPENED
					beq @+
					write_action_name #A_M0003_041
					mwa #A_M0003_041_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_OPEN #ACT_USE
@					rts
				#end
				rts
.endp

; Performs actions on M0081
.proc act_on_action_M0081
				lda current_action
				cmp #A_M0003_032_ID	; Hard rock
				bne aoaM0081_1
				lda current_action_menu_item
				cmp #0				; Hard rock -> Explore
				bne @+
				show_status_message #STATUSMSG_075
				rts
@				cmp #1				; Hard rock -> Push
				lda logic_flags_003
				and #LF_HARD_ROCK_MOVED
				cmp #LF_HARD_ROCK_MOVED
				beq @+
				logic_M0081_move_hard_rock
				lda logic_flags_003
				eor #LF_HARD_ROCK_MOVED
				sta logic_flags_003
				show_status_message #STATUSMSG_076
				rts
@				show_status_message #STATUSMSG_077
				rts				
aoaM0081_1
				cmp #A_M0003_035_ID	; Hell Gate
				bne aoaM0081_2
				lda current_action_menu_item
				cmp #0				; Hell Gate -> Explore
				bne @+
				show_status_message #STATUSMSG_081
				rts
@				cmp #1				; Hell Gate -> Penetrate
				bne @+
				ldx #$9d
				stx hero_Xpos
				stx HPOSP0
				ldx #$98
				stx hero_YPos
				clear_hero
				draw_hero
				follow_down #1
@				rts				
aoaM0081_2
				cmp #A_M0003_087_ID	; Bad news
				bne aoaM0081_3
				lda current_action_menu_item
				cmp #0				; Bad news -> Explore
				bne @+
				show_status_message #STATUSMSG_241
				rts
@				cmp #1				; Bad news -> Read
				bne @+
				show_adventure_message #ADVMSG_240
				prepare_map
aoaM0081_3
@				rts				
.endp

; Performs actions on M0116
.proc act_on_action_M0116
				lda current_action
				cmp #A_M0003_035_ID	; Hell Gate
				bne aoaM0116_2
				lda current_action_menu_item
				cmp #0				; Hell Gate -> Explore
				bne @+
				show_status_message #STATUSMSG_081
				rts
@				cmp #1				; Hell Gate -> Penetrate
				bne @+
				ldx #$5f
				stx hero_Xpos
				stx HPOSP0
				ldx #$a0
				stx hero_YPos
				clear_hero
				draw_hero
				follow_up #1
@				rts				
aoaM0116_2
				rts
.endp

; Performs actions on M0119
.proc act_on_action_M0119
				lda current_action
				cmp #A_M0003_037_ID	; Valve
				bne aoaM0119_1
				lda current_action_menu_item
				cmp #0				; Valve -> Explore
				bne @+
				show_status_message #STATUSMSG_084
				rts
@				cmp #1				; Valve -> Rotate
				bne @+
				logic_M0119_rotate_valve
				lda logic_flags_004
				eor #LF_VALVE2_ROTATED
				sta logic_flags_004
				show_status_message #STATUSMSG_087
				rts
@				cmp #2				; Valve -> Lick
				bne @+
				lda logic_flags_004
				and #LF_VALVE_LICKED
				cmp #LF_VALVE_LICKED
				bne aoaM0119_2
				show_status_message #STATUSMSG_086
				rts
aoaM0119_2		show_status_message #STATUSMSG_085	
				lda logic_flags_004
				eor #LF_VALVE_LICKED
				sta logic_flags_004
				rts		
@				
aoaM0119_1
				rts
.endp

; Performs actions on M0126
.proc act_on_action_M0126
				lda current_action
				cmp #A_M0003_036_ID	; Hanging skull
				bne aoaM0126_1
				lda current_action_menu_item
				cmp #0				; Hanging skull -> Explore
				bne @+
				show_status_message #STATUSMSG_083
				rts
@				cmp #1				; Hanging skull -> Use
				bne @+
				show_pocket
				finish_with_message_006				
@
aoaM0126_1
				rts
.endp

; Performs actions on M0131
.proc act_on_action_M0131
				lda current_action
				cmp #A_M0003_010_ID	; Crack
				bne aoaM0131_1
				lda current_action_menu_item
				cmp #0				; Crack -> Explore
				bne @+
				show_status_message #STATUSMSG_088
				rts
@				cmp #1				; Crack -> Use
				bne @+
				show_pocket
				finish_with_message_006				
@
aoaM0131_1
				cmp #A_M0003_037_ID	; Valve
				jne aoaM0131_2
				lda current_action_menu_item
				cmp #0				; Valve -> Explore
				bne @+
				show_status_message #STATUSMSG_090
				rts
@				cmp #1				; Valve -> Rotate
				bne @+
				lda logic_flags_004
				and #LF_VALVE2_UNJAMMED
				cmp #LF_VALVE2_UNJAMMED
				bne aoa131_1
				logic_M0131_rotate_valve
				lda logic_flags_004
				eor #LF_VALVE1_ROTATED
				sta logic_flags_004
				show_status_message #STATUSMSG_087
				rts
aoa131_1
				show_status_message #STATUSMSG_089
				rts
@				cmp #2				; Valve -> Unjam
				bne @+1
				show_pocket
				is_chosen_in_pocket #ACTI_WRENCH
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				lda logic_flags_004
				eor #LF_VALVE2_UNJAMMED
				sta logic_flags_004
				show_status_message #STATUSMSG_091
				rts
@
aoaM0131_2		rts
.endp

; Performs actions on M0139
.proc act_on_action_M0139
				lda current_action
				cmp #A_M0003_037_ID	; Valve
				bne aoaM0119_1
				lda current_action_menu_item
				cmp #0				; Valve -> Explore
				bne @+
				show_status_message #STATUSMSG_093
				rts
@				cmp #1				; Valve -> Rotate
				bne @+
				show_status_message #STATUSMSG_094
				rts
@				
aoaM0119_1
				rts
.endp

; Performs actions on M0140
.proc act_on_action_M0140
				lda current_action
				cmp #A_M0003_038_ID	; Button
				bne aoaM0140_1
				lda current_action_menu_item
				cmp #0				; Button -> Explore
				bne @+
				show_status_message #STATUSMSG_092
				rts
@				cmp #1				; Button -> Activate
				bne @+
				
				; Temporarily disable strobo in order
				; to make the grate disappearance visible
				; to the player.
				lda col1
				sta COLOR1
				lda col2
				sta COLOR2
				synchro			
				
				logic_M0140_grate_disappears #1
				lda logic_flags_004
				eor #LF_BUTTON_PRESSED
				sta logic_flags_004
@
aoaM0140_1
				rts
.endp

; Performs actions on M0141
.proc act_on_action_M0141
				lda current_action
				cmp #A_M0003_028_ID	; Weed
				jne aoaM0141_x1
				lda current_action_menu_item
				cmp #0				; Weed -> Explore
				bne aoaM0141_1
				show_status_message #STATUSMSG_095
				rts
aoaM0141_1		cmp #1				; Weed -> Use
				bne aoaM0141_x2
				show_pocket
				is_chosen_in_pocket #ACTI_SCISSORS
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				logic_M0141_weed_disappears #1
				lda logic_flags_004
				eor #LF_HELL_WEED_REMOVED
				sta logic_flags_004			
				rts
aoaM0141_x1		cmp #A_M0003_012_ID	; Demon
				jne aoaM0141_x2
				lda current_action_menu_item
				cmp #0				; Demon -> Explore
				bne aoaM0141_3
				show_status_message #STATUSMSG_096
				rts
aoaM0141_3		cmp #1				; Demon -> Talk
				show_adventure_message #ADVMSG_097
				prepare_map
				logic_M0141_demon_disappears
				lda logic_flags_005
				eor #LF_HELL_DEMON_PISSING
				sta logic_flags_005
				rts			
aoaM0141_x2		cmp #A_M0003_040_ID	; Sinister door
				jne aoaM0141_x3
				lda current_action_menu_item
				cmp #0				; Sinister door -> Explore
				bne aoaM0141_4
				show_status_message #STATUSMSG_102
				rts
aoaM0141_4		cmp #1				; Sinister door -> Open
				mva #$52 hero_XPos
				sta HPOSP0
				mva #$98 hero_YPos
				clear_hero
				draw_hero				
				follow_right #1
				rts
aoaM0141_x3		cmp #A_M0003_041_ID	; Devil door
				jne aoaM0141_x4
				lda current_action_menu_item
				cmp #0				; Devil door -> Explore
				bne aoaM0141_5
				show_status_message #STATUSMSG_103
				rts
aoaM0141_5		cmp #1				; Devil door  -> Open
				bne aoaM0141_6
				show_status_message #STATUSMSG_104
				rts
aoaM0141_6		show_pocket
				is_chosen_in_pocket #ACTI_HELL_KEY
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				show_status_message #STATUSMSG_101
				logic_M0141_demon_door_open
				lda logic_flags_005
				eor #LF_DEVIL_DOOR_OPENED
				sta logic_flags_005
aoaM0141_x4		rts
.endp

; Makes the hell gate disappear in pieces
.proc logic_M0116_hellgate_disappears(.byte slow) .var
				mva #15 to_be_delayed
				#if .byte slow = #0
					mva #1 to_be_delayed
				#end
				ldx #0
				stx screen_mem+40*(10+4)+(24+0)
				delay
				stx screen_mem+40*(10+7)+(24+4)
				delay
				stx screen_mem+40*(10+5)+(24+2)
				delay
				stx screen_mem+40*(10+7)+(24+5)
				delay
				stx screen_mem+40*(10+1)+(24+3)
				delay
				stx screen_mem+40*(10+0)+(24+8)
				delay
				stx screen_mem+40*(10+2)+(24+0)
				delay
				stx screen_mem+40*(10+4)+(24+6)
				delay
				stx screen_mem+40*(10+4)+(24+7)
				delay
				stx screen_mem+40*(10+1)+(24+5)
				delay
				stx screen_mem+40*(10+3)+(24+0)
				delay
				stx screen_mem+40*(10+1)+(24+4)
				delay
				stx screen_mem+40*(10+3)+(24+2)
				delay
				stx screen_mem+40*(10+1)+(24+1)
				delay
				stx screen_mem+40*(10+5)+(24+6)
				delay
				stx screen_mem+40*(10+6)+(24+1)
				delay
				stx screen_mem+40*(10+0)+(24+7)
				delay
				stx screen_mem+40*(10+6)+(24+0)
				delay
				stx screen_mem+40*(10+4)+(24+3)
				delay
				stx screen_mem+40*(10+2)+(24+7)
				delay
				stx screen_mem+40*(10+4)+(24+5)
				delay
				stx screen_mem+40*(10+1)+(24+7)
				delay
				stx screen_mem+40*(10+0)+(24+4)
				delay
				stx screen_mem+40*(10+6)+(24+8)
				delay
				stx screen_mem+40*(10+0)+(24+5)
				delay
				stx screen_mem+40*(10+7)+(24+1)
				delay
				stx screen_mem+40*(10+5)+(24+0)
				delay
				stx screen_mem+40*(10+6)+(24+7)
				delay
				stx screen_mem+40*(10+5)+(24+5)
				delay
				stx screen_mem+40*(10+3)+(24+4)
				delay
				stx screen_mem+40*(10+3)+(24+7)
				delay
				stx screen_mem+40*(10+7)+(24+8)
				delay
				stx screen_mem+40*(10+1)+(24+2)
				delay
				stx screen_mem+40*(10+5)+(24+4)
				delay
				stx screen_mem+40*(10+1)+(24+8)
				delay
				stx screen_mem+40*(10+7)+(24+6)
				delay
				stx screen_mem+40*(10+3)+(24+3)
				delay
				stx screen_mem+40*(10+2)+(24+5)
				delay
				stx screen_mem+40*(10+4)+(24+1)
				delay
				stx screen_mem+40*(10+7)+(24+2)
				delay
				stx screen_mem+40*(10+1)+(24+0)
				delay
				stx screen_mem+40*(10+0)+(24+0)
				delay
				stx screen_mem+40*(10+2)+(24+4)
				delay
				stx screen_mem+40*(10+0)+(24+3)
				delay
				stx screen_mem+40*(10+6)+(24+4)
				delay
				stx screen_mem+40*(10+0)+(24+2)
				delay
				stx screen_mem+40*(10+5)+(24+7)
				delay
				stx screen_mem+40*(10+6)+(24+3)
				delay
				stx screen_mem+40*(10+2)+(24+3)
				delay
				stx screen_mem+40*(10+0)+(24+1)
				delay
				stx screen_mem+40*(10+4)+(24+8)
				delay
				stx screen_mem+40*(10+4)+(24+2)
				delay
				stx screen_mem+40*(10+7)+(24+3)
				delay
				stx screen_mem+40*(10+4)+(24+4)
				delay
				stx screen_mem+40*(10+2)+(24+2)
				delay
				stx screen_mem+40*(10+5)+(24+8)
				delay
				stx screen_mem+40*(10+6)+(24+6)
				delay
				stx screen_mem+40*(10+5)+(24+1)
				delay
				stx screen_mem+40*(10+7)+(24+7)
				delay
				stx screen_mem+40*(10+1)+(24+6)
				delay
				stx screen_mem+40*(10+3)+(24+8)
				delay
				stx screen_mem+40*(10+2)+(24+8)
				delay
				stx screen_mem+40*(10+2)+(24+6)
				delay
				stx screen_mem+40*(10+6)+(24+2)
				delay
				stx screen_mem+40*(10+3)+(24+5)
				delay
				stx screen_mem+40*(10+5)+(24+3)
				delay
				stx screen_mem+40*(10+3)+(24+6)
				delay
				stx screen_mem+40*(10+6)+(24+5)
				delay
				stx screen_mem+40*(10+2)+(24+1)
				delay
				stx screen_mem+40*(10+7)+(24+0)
				delay
				stx screen_mem+40*(10+0)+(24+6)
				delay
				stx screen_mem+40*(10+3)+(24+1)
				
				rts
.endp

; Assures that all actions done to the
; particular map are visible when
; map is preloaded.
				org logic_dll_post				
.proc post_load_logic
				disable_strobo
				disable_lightning

				; ============== MAP 0116 ==========
				is_on_31303631
				cpx #1
				jne pll_next_map_0000
				lda logic_flags_004
				and #LF_HELLGATE_DISAPPEARED
				cmp #LF_HELLGATE_DISAPPEARED
				bne @+
				logic_M0116_hellgate_disappears #0
@				rts

pll_next_map_0000
				; ============== MAP 0081 ==========
				is_on_30303138
				cpx #1
				jne pll_next_map_0001
				make_message_transparent
				lda logic_flags_003
				and #LF_HARD_ROCK_MOVED
				cmp #LF_HARD_ROCK_MOVED
				bne @+
				logic_M0081_move_hard_rock
@				rts

pll_next_map_0001
				; ============== MAP 0119 ==========
				is_on_30313931
				cpx #1
				jne pll_next_map_0002
				make_valve_transparent
				lda logic_flags_004
				and #LF_VALVE1_ROTATED
				cmp #LF_VALVE1_ROTATED
				bne @+
				lda #57
				sta screen_mem+40*7+3
@				rts
pll_next_map_0002
				; ============== MAP 0126 ==========
				is_on_30313632
				cpx #1
				jne pll_next_map_0003
				lda logic_flags_004
				and #LF_VALVE2_ROTATED
				cmp #LF_VALVE2_ROTATED
				bne @+
				logic_M0126_lift_left_skull
@				lda logic_flags_004
				and #LF_VALVE1_ROTATED
				cmp #LF_VALVE1_ROTATED
				bne @+
				logic_M0126_lift_middle_skull
@				lda logic_flags_009
				and #LF_VALVE3_ROTATED
				cmp #LF_VALVE3_ROTATED
				bne @+
				logic_M0126_lift_right_skull
@
				rts
pll_next_map_0003
				; ============== MAP 0120 ==========
				is_on_30313032
				cpx #1
				jne pll_next_map_0004
				enable_strobo
@				rts
pll_next_map_0004
				; ============== MAP 0131 ==========
				is_on_30313133
				cpx #1
				jne pll_next_map_0005
				make_valve_transparent
@				rts
pll_next_map_0005
				; ============== MAP 0138 ==========
				is_on_30313833
				cpx #1
				jne pll_next_map_0006
				randomize_corridor_colors
@				rts
pll_next_map_0006
				; ============== MAP 0139 ==========
				is_on_30313933
				cpx #1
				jne pll_next_map_0007
				enable_strobo
@				rts
pll_next_map_0007
				; ============== MAP 0140 ==========
				is_on_30310134
				cpx #1
				jne pll_next_map_0008
				enable_strobo
				lda logic_flags_004
				and #LF_BUTTON_PRESSED
				cmp #LF_BUTTON_PRESSED
				bne @+
				logic_M0140_grate_disappears #0
@				rts
pll_next_map_0008
				; ============== MAP 0141 ==========
				is_on_30319134
				cpx #1
				jne pll_next_map_0009
				lda logic_flags_004
				and #LF_HELL_WEED_REMOVED
				cmp #LF_HELL_WEED_REMOVED
				bne @+
				logic_M0141_weed_disappears #0
@				lda logic_flags_005
				and #LF_HELL_DEMON_PISSING
				cmp #LF_HELL_DEMON_PISSING
				bne @+
				logic_M0141_demon_disappears
@				lda logic_flags_005
				and #LF_DEVIL_DOOR_OPENED
				cmp #LF_DEVIL_DOOR_OPENED
				bne @+
				logic_M0141_demon_door_open
@				rts
pll_next_map_0009
				; ============== MAP 0109 ==========
				is_on_31303930
				cpx #1
				jne pll_next_map_0010
				make_water_transparent
				lda logic_flags_007
				and #LF_WITCHER_HANDLED
				cmp #LF_WITCHER_HANDLED
				bne @+
				logic_M0109_show_stair
@				rts
pll_next_map_0010
				; ============== MAP 0110 ==========
				is_on_31303031
				cpx #1
				jne pll_next_map_0011
				make_water_transparent
				lda logic_flags_008
				and #LF_BEAST_CARVED
				cmp #LF_BEAST_CARVED
				bne @+
				logic_M0110_carve_the_beast #0
				rts
@
pll_next_map_0011
				rts
.endp

.proc logic_M0119_rotate_valve
				mva #15 to_be_delayed
				
				ldx #10
@				lda #57
				sta screen_mem+40*7+3
				delay
				lda #25
				sta screen_mem+40*7+3
				delay
				dex
				cpx #0
				bne @-
				delay
				lda #57
				sta screen_mem+40*7+3
				
				rts
.endp
.proc logic_M0131_rotate_valve
				mva #15 to_be_delayed
				
				ldx #10
@				lda #57
				sta screen_mem+40*12+12
				delay
				lda #25
				sta screen_mem+40*12+12
				delay
				dex
				cpx #0
				bne @-
				delay
				lda #57
				sta screen_mem+40*12+12
				
				rts
.endp

; Moves the hard rock at the hell entrance.
.proc logic_M0081_move_hard_rock
				mwa screen_mem+40*11+33 screen_mem+40*12+28
				mwa screen_mem+40*11+35 screen_mem+40*12+30
				mwa screen_mem+40*12+33 screen_mem+40*13+28
				mwa screen_mem+40*12+35 screen_mem+40*13+30
				mwa screen_mem+40*13+33 screen_mem+40*14+28
				mwa screen_mem+40*13+35 screen_mem+40*14+30
				mwa screen_mem+40*14+33 screen_mem+40*15+28
				mwa screen_mem+40*14+35 screen_mem+40*15+30

				lda #0
				sta screen_mem+40*11+33
				sta screen_mem+40*11+34
				sta screen_mem+40*11+35
				sta screen_mem+40*11+36
				sta screen_mem+40*14+33
				sta screen_mem+40*14+36
				sta screen_mem+40*12+33
				sta screen_mem+40*12+36
				sta screen_mem+40*13+33
				sta screen_mem+40*13+36

				ldy #62
				sty screen_mem+40*12+34
				iny
				sty screen_mem+40*12+35
				ldy #94
				sty screen_mem+40*13+34
				iny
				sty screen_mem+40*13+35
				ldy #126
				sty screen_mem+40*14+34
				iny
				sty screen_mem+40*14+35
				

				rts
.endp

; Lifts the middle skull up
.proc logic_M0126_lift_middle_skull
				ldy #12
				sty screen_mem+40*3+19
				iny
				sty screen_mem+40*3+20
				ldy #44
				sty screen_mem+40*4+19
				iny
				sty screen_mem+40*4+20
				ldy #76
				sty screen_mem+40*5+19
				iny
				sty screen_mem+40*5+20
				
				mva #5 tmp_loop_iterator 
				ldy #11
@				inc tmp_loop_iterator
				tya
				pha
				print_string #CHAR_CLR #19 tmp_loop_iterator #0
				pla
				tay
				dey
				bne @-
				
				lda #0
				sta screen_mem+40*14+20
				sta screen_mem+40*15+20
				sta screen_mem+40*16+20
				
				ldy #4
				sty screen_mem+40*12+19
				dey
				sty screen_mem+40*11+19
				
				; Since now, we need the second skull to trigger the menu
				mva #$8c hanging_skull_pos
				
				rts
.endp

; Lifts the left skull up
.proc logic_M0126_lift_left_skull
				ldy #12
				sty screen_mem+40*3+13
				iny
				sty screen_mem+40*3+14
				ldy #44
				sty screen_mem+40*4+13
				iny
				sty screen_mem+40*4+14
				ldy #76
				sty screen_mem+40*5+13
				iny
				sty screen_mem+40*5+14
				
				mva #5 tmp_loop_iterator 
				ldy #11
@				inc tmp_loop_iterator
				tya
				pha
				print_string #CHAR_CLR #13 tmp_loop_iterator #0
				pla
				tay
				dey
				bne @-
				
				lda #0
				sta screen_mem+40*14+14
				sta screen_mem+40*15+14
				sta screen_mem+40*16+14
				
				ldy #4
				sty screen_mem+40*12+13
				dey
				sty screen_mem+40*11+13
				
				; Since now, we need the second skull to trigger the menu
				mva #$74 hanging_skull_pos
				
				rts
.endp

; Lifts the right skull up
.proc logic_M0126_lift_right_skull
				ldy #12
				sty screen_mem+40*3+25
				iny
				sty screen_mem+40*3+26
				ldy #44
				sty screen_mem+40*4+25
				iny
				sty screen_mem+40*4+26
				ldy #76
				sty screen_mem+40*5+25
				iny
				sty screen_mem+40*5+26
				
				mva #5 tmp_loop_iterator 
				ldy #11
@				inc tmp_loop_iterator
				tya
				pha
				print_string #CHAR_CLR #25 tmp_loop_iterator #0
				pla
				tay
				dey
				bne @-
				
				lda #0
				sta screen_mem+40*14+26
				sta screen_mem+40*15+26
				sta screen_mem+40*16+26
				
				ldy #4
				sty screen_mem+40*12+25
				dey
				sty screen_mem+40*11+25
				
				; Since now, we don't need to trigger the menu
				mva #$0 hanging_skull_pos
				
				rts
.endp

; Opens the small grate after button is pressed
.proc logic_M0140_grate_disappears(.byte slow) .var
				mva #100 to_be_delayed
				#if .byte slow = #0
					mva #1 to_be_delayed
				#end
				
				ldy #122
				sty screen_mem+40*12+38
				delay

				ldy #0
				sty screen_mem+40*18+2
				delay
				sty screen_mem+40*17+2
				delay
				sty screen_mem+40*16+2
				delay
				sty screen_mem+40*15+2
				
				
				rts
.endp

; Removes the weed from the "Pieczara Biesa" map.
.proc logic_M0141_weed_disappears(.byte slow) .var
				mva #50 to_be_delayed
				#if .byte slow = #0
					mva #1 to_be_delayed
				#end
				
				ldx #0
				stx screen_mem+40*7+25
				stx screen_mem+40*7+26
				stx screen_mem+40*7+27
				delay

				stx screen_mem+40*6+25
				stx screen_mem+40*6+26
				stx screen_mem+40*6+27
				delay

				stx screen_mem+40*5+25
				stx screen_mem+40*5+26
				stx screen_mem+40*5+27

				rts
.endp

; M0141 - removes demon from the map
.proc logic_M0141_demon_disappears
				mva #14 tmp_loop_iterator 
				ldy #4
@				inc tmp_loop_iterator
				tya
				pha
				print_string #DEMON_CLR #27 tmp_loop_iterator #0
				pla
				tay
				dey
				bne @-
				rts
.endp

; M0141 - Opens the door to the demon
.proc logic_M0141_demon_door_open
				lda #0
				sta screen_mem+40*16+17
				sta screen_mem+40*17+17
				sta screen_mem+40*18+17
				rts
.endp

.proc is_on_31303631
				is_on_map_3130 #$3631
				rts
.endp
.proc is_on_30303138
				is_on_map_3030 #$3138
				rts
.endp
.proc is_on_30313632
				is_on_map_3130 #$3632
				rts
.endp
.proc is_on_30313931
				is_on_map_3130 #$3931
				rts
.endp
.proc is_on_30313032
				is_on_map_3130 #$3032
				rts
.endp
.proc is_on_30313133
				is_on_map_3130 #$3133
				rts
.endp
.proc is_on_30313833
				is_on_map_3130 #$3833
				rts
.endp
.proc is_on_30313933
				is_on_map_3130 #$3933
				rts
.endp
.proc is_on_30310134
				is_on_map_3130 #$3034
				rts
.endp
.proc is_on_30319133
				is_on_map_3130 #$3933
				rts
.endp
.proc is_on_30319134
				is_on_map_3130 #$3134
				rts
.endp
.proc is_on_30303734
				is_on_map_3030 #$3734
				rts
.endp
.proc is_on_31303930
				is_on_map_3130 #$3930
				rts
.endp
.proc is_on_31303031
				is_on_map_3130 #$3031
				rts
.endp

; Allows hero to go through the secret message
.proc make_message_transparent
				ldx #0
@				lda MESSAGE_CHARS,x
				stx tmp_pipes
				add_single_char_to_transparent_chars
				ldx tmp_pipes
				inx
				cpx #6
				bne @-
				
				rts
.endp

.proc logic_M0109_show_stair
				ldx #124
				stx screen_mem+40*15+21
				dex
				stx screen_mem+40*15+22
				ldx #113
				stx screen_mem+40*15+23
				rts
.endp

.proc hero_right_4
				hero_right
				hero_right
				hero_right
				hero_right
				rts
.endp
.proc logic_M0110_carve_the_beast(.byte slow) .var
				mva #15 to_be_delayed
				#if .byte slow = #0
					mva #1 to_be_delayed
				#end
				ldx #0
				stx screen_mem+40*12+15
				stx screen_mem+40*13+15
				stx screen_mem+40*14+15
				delay
				#if .byte slow = #1
					hero_right_4
				#end
				delay
				ldx #0
				stx screen_mem+40*12+16
				stx screen_mem+40*13+16
				stx screen_mem+40*14+16
				delay
				#if .byte slow = #1
					hero_right_4
				#end
				delay
				#if .byte slow = #1
					hero_gravity_IMMOVABLE
					hero_gravity_IMMOVABLE
					hero_gravity_IMMOVABLE
					hero_gravity_IMMOVABLE
				#end
				delay
				ldx #0
				stx screen_mem+40*13+17
				delay
				#if .byte slow = #1
					hero_right_4
				#end
				delay

				mva #8 tmp_loop_iterator 
				mwa #screen_mem+40*13+18 screen_tmp
@				lda #0
				ldy #0
				sta (screen_tmp),y
				adw screen_tmp #40
				lda #0
				sta (screen_tmp),y
				adw screen_tmp #40
				lda #1
				sta (screen_tmp),y
				delay
				lda screen_tmp
				pha
				lda screen_tmp+1
				pha
				#if .byte slow = #1
					hero_right_4
				#end
				pla
				sta screen_tmp+1
				pla
				sta screen_tmp
				delay
				sbw screen_tmp #79
				dec tmp_loop_iterator
				bne @-
				rts
.endp

; Allows hero to go through the valve
.proc make_valve_transparent
				lda #25
				add_single_char_to_transparent_chars
				lda #57
				add_single_char_to_transparent_chars 
				rts
.endp

; Randomizes the color of never ending corridor
.proc randomize_corridor_colors
				ldy detected_vbxe
				cpy #1
				beq @+

				lda #$cf
				sta COLOR1

				lda RANDOM
				and #%00000011
				tay
				lda NOVBXE_COLORS,y
				sta COLOR2 
				rts

@

				lda #$00
				sta COLOR2

				lda RANDOM
				and #%00000011
				tay
				lda VBXE_COLORS,y
				sta COLOR1 
				rts
.endp

; Makes the water transparent
.proc make_water_transparent
				lda #1
				add_single_char_to_transparent_chars
				rts
.endp

NOVBXE_COLORS
				dta b($c0),b($62),b($20),b(00)
VBXE_COLORS
				dta b($cf),b($6e),b($26),b($0f)


MESSAGE_CHARS
				dta b(62),b(63),b(94),b(95),b(126),b(127)

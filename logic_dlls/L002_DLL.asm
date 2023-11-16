;	@com.wudsn.ide.asm.mainsourcefile=../main.asm
				org logic_dll
				
.proc process_logic
				mwa #0 current_action
					
				; "Tunele cmentarne" = MAP0078.MAP
pl02			is_on_30303837
				cpx #1
				bne pl03
				mwa #act_on_action_M0078-1 act_on_action_vector
				process_logic_M0078
				rts
pl03			
				; "Czaszkowe schody" = MAP0082.MAP
				is_on_30303238
				cpx #1
				bne pl04
				mwa #act_on_action_M0082-1 act_on_action_vector
				process_logic_M0082
				rts
pl04
				; "Most zwodzony" = MAP0084.MAP
				is_on_30303438
				cpx #1
				bne pl05
				process_logic_M0084
				mwa #act_on_action_M0084-1 act_on_action_vector
				rts
pl05
				; "Rowy cmentarne" = MAP0073.MAP
				is_on_30303337
				cpx #1
				bne pl06
				mwa #act_on_action_M0073-1 act_on_action_vector
				process_logic_M0073
				rts
pl06
				; "Tunele cmentarne" = MAP0085.MAP
				is_on_30303538
				cpx #1
				bne pl07
				mwa #act_on_action_M0085-1 act_on_action_vector
				process_logic_M0085
				rts
pl07
				; "Baszta windy" = MAP00100.MAP
				is_on_31303030
				cpx #1
				bne pl09
				mwa #act_on_action_M0100-1 act_on_action_vector
				process_logic_M0100
				rts
pl09
				; "Baszta windy" = MAP00103.MAP
				is_on_31303330
				cpx #1
				bne pl10
				mwa #act_on_action_M0103-1 act_on_action_vector
				process_logic_M0103
				rts
pl10
pl12
				; "Rowy cmentarne" = MAP0077.MAP
				is_on_30303737
				cpx #1
				bne pl13
				mwa #act_on_action_M0077-1 act_on_action_vector
				process_logic_M0077
@				rts
pl13
				; "Tunele cmentarne" = MAP0080.MAP
				is_on_30303038
				cpx #1
				bne pl14
				mwa #act_on_action_M0080-1 act_on_action_vector
				process_logic_M0080
@				rts
pl14
				; "Szczurzy most" = MAP0083.MAP
				is_on_30303338
				cpx #1
				bne pl15
				mwa #act_on_action_M0083-1 act_on_action_vector
				process_logic_M0083
@				rts
pl15
				; "Rowy cmentarne" = MAP0111.MAP
				is_on_31303131
				cpx #1
				bne pl16
				mwa #act_on_action_M0111-1 act_on_action_vector
				process_logic_M0111
@				rts
pl16
				; "Tunele cmentarne" = MAP0079.MAP
				is_on_30303937
				cpx #1
				bne pl17
				mwa #act_on_action_M0079-1 act_on_action_vector
				process_logic_M0079
@				rts
pl17
				; "Na blankach" = MAP0101.MAP
				is_on_31303130
				cpx #1
				bne pl18
				mwa #act_on_action_M0101-1 act_on_action_vector
				process_logic_M0101
@				rts
pl18
				rts
.endp

; Performs all actions connected to logic on MAP0073
.proc process_logic_M0073
				#if .byte hero_XPos = #$98 .and .byte hero_YPos = #$98
					write_action_name #A_M0003_024
					mwa #A_M0003_024_ID current_action
					lda logic_flags_002
					and #LF_WORM_PLUGGED
					cmp #LF_WORM_PLUGGED
					beq @+
					propagate_action_menu #ACT_EXPLORE #ACT_CLEANUP #ACT_INSERT
					rts
@					lda logic_flags_002
					and #LF_WORM_CLEANED
					cmp #LF_WORM_CLEANED
					beq @+
					propagate_action_menu #ACT_EXPLORE #ACT_CLEANUP #ACT_EMPTY
					rts
@					propagate_action_menu_EXEMEM
					rts
				#end
@
				#if .byte hero_XPos = #$84 .and .byte hero_YPos = #$60
					lda logic_flags_005
					and #LF_ZOMBIE_HAS_BRAIN
					cmp #LF_ZOMBIE_HAS_BRAIN
					beq @+
					write_action_name #A_M0003_050
					mwa #A_M0003_050_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_GIVE #ACT_EMPTY
				#end
@				
				rts
.endp

; Performs all actions connected to logic on MAP0083
.proc process_logic_M0083
					lda logic_flags_006
					and #LF_BEER_FOAMED
					cmp #LF_BEER_FOAMED
					jeq @+
				#if .byte hero_XPos = #$5c .and .byte hero_YPos = #$68
					write_action_name #A_M0003_051
					mwa #A_M0003_051_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_GIVE #ACT_TALK
					rts
				#end
				#if .byte hero_XPos >= #$7c .and .byte hero_XPos <= #$8c .and .byte hero_YPos = #$68
					write_action_name #A_M0003_052
					mwa #A_M0003_052_ID current_action
					propagate_action_menu_EXUSEM
				#end
@				rts
.endp

; Performs all actions connected to logic on MAP0078
.proc process_logic_M0078
				#if .byte hero_XPos = #$74 .and .byte hero_YPos = #$58
					lda logic_flags_002
					and #LF_TUNNELS_MSG1
					cmp #LF_TUNNELS_MSG1
					beq @+
					show_status_message #STATUSMSG_054
					lda logic_flags_002
					eor #LF_TUNNELS_MSG1
					sta logic_flags_002
					rts
				#end
@
				#if .byte hero_XPos = #$80 .and .byte hero_YPos = #$98
					lda logic_flags_004
					and #LF_GRAVEUNDER_OPENED
					cmp #LF_GRAVEUNDER_OPENED
					beq @+
					write_action_name #A_M0003_033
					mwa #A_M0003_033_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_ACTIVATE #ACT_EMPTY
				#end
@
				#if .byte hero_XPos = #$98 .and .byte hero_YPos = #$70
					lda logic_flags_004
					and #LF_GRAVEUNDER_OPENED
					cmp #LF_GRAVEUNDER_OPENED
					beq @+
					write_action_name #A_M0003_034
					mwa #A_M0003_034_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_OPEN #ACT_EMPTY
				#end
@

				rts
.endp

; Performs all actions connected to logic on MAP0077
.proc process_logic_M0077
				#if .byte hero_XPos = #$b4 .and .byte hero_YPos = #$60
					lda logic_flags_006
					and #LF_ICICLE_MELTED
					cmp #LF_ICICLE_MELTED
					beq @+
					write_action_name #A_M0003_049
					mwa #A_M0003_049_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_USE #ACT_LICK
				#end
@				rts
.endp

; Performs all actions connected to logic on MAP0079
.proc process_logic_M0079
				#if .byte hero_XPos = #$94 .and .byte hero_YPos = #$50
					lda logic_flags_006
					and #LF_SHIT_CLEARED
					cmp #LF_SHIT_CLEARED
					beq @+
					write_action_name #A_M0003_054
					mwa #A_M0003_054_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_USE #ACT_LICK
				#end
@				rts
.endp

; Performs all actions connected to logic on MAP0080
.proc process_logic_M0080
				#if .byte hero_XPos >= #$78 .and .byte hero_XPos <= #$84 .and .byte hero_YPos = #$a0
					write_action_name #A_M0003_044
					mwa #A_M0003_044_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_SNIFF #ACT_PENETRATE
					#end
				rts
.endp

; Performs all actions connected to logic on MAP0082
.proc process_logic_M0082_analyze_grave
				write_action_name #A_M0003_023
				mwa #A_M0003_023_ID current_action
				lda logic_flags_002
				and #LF_GRAVE_CLEANED
				cmp #LF_GRAVE_CLEANED
				beq @+
				propagate_action_menu #ACT_EXPLORE #ACT_CLEANUP #ACT_EMPTY
				rts
@				propagate_action_menu_EXEMEM
				rts
.endp
.proc process_logic_M0082
				#if .byte hero_XPos = #$78 .and .byte hero_YPos = #$98
					process_logic_M0082_analyze_grave
				#end
				#if .byte hero_XPos = #$8c .and .byte hero_YPos = #$90
					process_logic_M0082_analyze_grave
				#end
				rts
.endp

; Performs all actions connected to logic on MAP0084
.proc process_logic_M0084
				#if .byte hero_XPos = #$b4
					lda logic_flags_002
					and #LF_BASCULE_BRIDGE_LOW
					cmp #LF_BASCULE_BRIDGE_LOW
					beq @+
					show_status_message #STATUSMSG_058
					hero_right
					hero_right
					hero_right
					hero_right
					rts
				#end
@
				#if .byte hero_XPos >= #$b8 .and .byte hero_XPos <= #$bd .and .byte hero_YPos = #$68
					lda logic_flags_002
					and #LF_BASCULE_BRIDGE_LOW
					cmp #LF_BASCULE_BRIDGE_LOW
					beq @+
					write_action_name #A_M0003_057
					mwa #A_M0003_057_ID current_action
					propagate_action_menu_EXUSEM
					#end
@				rts
.endp

; Performs all actions connected to logic on MAP0085
.proc process_logic_M0085
				#if .byte hero_XPos = #$8c .and .byte hero_YPos = #$98
					lda logic_flags_002
					and #LF_RAT_FED
					cmp #LF_RAT_FED
					beq @+
					write_action_name #A_M0003_025
					mwa #A_M0003_025_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_TALK #ACT_GIVE
@					rts
				#end
@
				rts
.endp

; Performs all actions connected to logic on MAP0100
.proc process_logic_M0100
				#if .byte hero_XPos = #$a4 .and .byte hero_YPos = #$98
					lda logic_flags_003
					and #LF_COLUMN_REMOVED
					cmp #LF_COLUMN_REMOVED			
					beq @+
					write_action_name #A_M0003_027
					mwa #A_M0003_027_ID current_action
					propagate_action_menu_EXUSEM
@
				#end
				rts
.endp

; Performs all actions connected to logic on MAP0101
.proc process_logic_M0101
				#if .byte hero_XPos = #$5c .and .byte hero_YPos = #$60
					write_action_name #A_M0003_063
					mwa #A_M0003_063_ID current_action
					lda logic_flags_007
					and #LF_HERO_ALIVE
					cmp #LF_HERO_ALIVE
					beq @+
					propagate_action_menu #ACT_EXPLORE #ACT_TALK #ACT_GIVE
					rts
@					propagate_action_menu #ACT_EXPLORE #ACT_EMPTY #ACT_GIVE
				#end
				rts
.endp

; Performs all actions connected to logic on MAP0103
.proc process_logic_M0103
				#if .byte hero_XPos = #$b4 .and .byte hero_YPos = #$88
					lda logic_flags_003
					and #LF_WEED_REMOVED
					cmp #LF_WEED_REMOVED			
					beq @+
					write_action_name #A_M0003_028
					mwa #A_M0003_028_ID current_action
					propagate_action_menu_EXUSEM
@
				#end
				rts
.endp

; Performs all actions connected to logic on MAP0111
.proc process_logic_M0111
				#if .byte hero_XPos = #$98 .and .byte hero_YPos = #$70
					lda logic_flags_006
					and #LF_GRAVE_LOWERED
					cmp #LF_GRAVE_LOWERED
					beq @+
					write_action_name #A_M0003_053
					mwa #A_M0003_053_ID current_action
					propagate_action_menu_EXUSEM
@					rts
				#end
				rts
.endp

; Performs actions on M0083
.proc act_on_action_M0083
				lda current_action
				cmp #A_M0003_051_ID	; Drunk guy
				jne aoaM0083_1
				lda current_action_menu_item
				cmp #0				; Drunk guy -> Explore
				bne aoa_M0083_1
				show_status_message #STATUSMSG_126
				rts
aoa_M0083_1
				cmp #1				; Drunk guy -> Give
				bne aoa_M0083_2
				show_pocket
				finish_with_message_006
				rts
aoa_M0083_2
				cmp #2				; Drunk guy -> Talk
				bne aoa_M0083_4
				show_adventure_message #ADVMSG_127
				prepare_map
				rts
aoaM0083_1
				cmp #A_M0003_052_ID	; Beer w/o foam
				jne aoaM0083_2
				lda current_action_menu_item
				cmp #0				; Beer w/o foam -> Explore
				bne aoa_M0083_3
				show_status_message #STATUSMSG_128
				rts
aoa_M0083_3
				cmp #1				; Beer w/o foam -> Use
				bne aoa_M0083_4
				show_pocket
				is_chosen_in_pocket #ACTI_BEER_FOAM
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				lda logic_flags_006
				eor #LF_BEER_FOAMED
				sta logic_flags_006
				logic_M0083_foam_beer #1
				remove_from_pocket #ACTI_BEER_FOAM
				rts

aoaM0083_2
aoa_M0083_4		rts
.endp

; Performs actions on M084
.proc act_on_action_M0084
				lda current_action
				cmp #A_M0003_057_ID	; Rifled hole
				jne aoaM0084_1
				lda current_action_menu_item
				cmp #0				; Rifled hole -> Explore
				bne aoa_M0084_1
				show_status_message #STATUSMSG_139
				rts
aoa_M0084_1		cmp #1				; Rifled hole -> Use
				bne aoa_M0084_2
				show_pocket
				is_chosen_in_pocket #ACTI_CRANK
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				lda logic_flags_002
				eor #LF_BASCULE_BRIDGE_LOW
				sta logic_flags_002
				logic_M0084_lower_bascule_bridge #1
				remove_from_pocket #ACTI_CRANK
aoa_M0084_2
aoaM0084_1
				rts
.endp

; Performs actions on M0077
.proc act_on_action_M0077
				lda current_action
				cmp #A_M0003_049_ID	; Icicle
				jne aoaM0077_1
				lda current_action_menu_item
				cmp #0				; Icicle -> Explore
				bne aoa_M0077_1
				show_status_message #STATUSMSG_122
				rts
aoa_M0077_1
				cmp #2				; Icicle -> Lick
				bne aoa_M0077_2
				show_status_message #STATUSMSG_123
				rts
aoa_M0077_2
				cmp #1				; Icicle -> Use
				bne aoa_M0077_3
				show_pocket
				is_chosen_in_pocket #ACTI_GRAVELIGHT
				cpx #1
				beq @+
				is_chosen_in_pocket #ACTI_FIRE_BRAIN
				cpx #1
				beq aoaM0077_8
				finish_with_message_006
				rts
@				prepare_map
				lda logic_flags_006
				eor #LF_ICICLE_MELTED
				sta logic_flags_006
				logic_M0077_remove_icicle #1
aoaM0077_1
aoa_M0077_3		rts
aoaM0077_8		prepare_map
				show_status_message #STATUSMSG_248
				rts
.endp

; Performs actions on M0078
.proc act_on_action_M0078
				lda current_action
				cmp #A_M0003_033_ID	; Foot button
				jne aoaM0078_1
				lda current_action_menu_item
				cmp #0				; Foot button -> Explore
				bne aoa_M0078_1
				show_status_message #STATUSMSG_079
				rts
aoa_M0078_1		cmp #1				; Foot button -> Activate
				bne aoa_M0078_2
				lda logic_flags_004
				eor #LF_GRAVEUNDER_OPENED
				sta logic_flags_004
				logic_M0078_open_gate #1
				rts
aoa_M0078_2
aoaM0078_1	
				lda current_action
				cmp #A_M0003_034_ID	; Powerful barrier
				jne aoaM0078_2
				lda current_action_menu_item
				cmp #0				; Powerful barrier -> Explore
				bne aoa_M0078_3
				show_status_message #STATUSMSG_080
				rts
aoa_M0078_3		cmp #1				; Powerful barrier -> Open
				bne aoa_M0078_4
				show_status_message_003
				rts

aoa_M0078_4
aoaM0078_2	
				rts
.endp

; Performs actions on M0073
.proc act_on_action_M0073
				lda current_action
				cmp #A_M0003_024_ID	; Worm ass
				jne aoa_M0073_1
				lda current_action_menu_item
				cmp #0				; Worm ass -> Explore
				bne aoaM0073_1
				lda logic_flags_002
				and #LF_WORM_PLUGGED
				cmp #LF_WORM_PLUGGED
				beq @+
				show_status_message #STATUSMSG_064
				rts
@				lda logic_flags_002
				and #LF_WORM_CLEANED
				cmp #LF_WORM_CLEANED
				beq @+
				show_status_message #STATUSMSG_059
				rts
@				show_status_message #STATUSMSG_060
				rts				
aoaM0073_1		cmp #1				; Worm ass -> Cleanup
				bne aoaM0073_2
				show_pocket
				is_chosen_in_pocket #ACTI_SHIT_SCRAP
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				lda logic_flags_002
				and #LF_WORM_PLUGGED
				cmp #LF_WORM_PLUGGED
				beq @+
				show_status_message #STATUSMSG_065
				rts
@				show_status_message #STATUSMSG_061
				spawn_in_pocket #ACTI_DROPPINGS
				lda logic_flags_002
				eor #LF_WORM_CLEANED
				sta logic_flags_002
				rts
aoaM0073_2		cmp #2				; Worm ass -> Use
				bne aoaM0073_3
				show_pocket
				is_chosen_in_pocket #ACTI_ASS_PLUG
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				lda logic_flags_002
				eor #LF_WORM_PLUGGED
				sta logic_flags_002
				show_status_message #STATUSMSG_066
				remove_from_pocket #ACTI_ASS_PLUG
aoaM0073_3		rts
aoa_M0073_1		
				cmp #A_M0003_050_ID	; Zombie
				jne aoa_M0073_2
				
				lda current_action_menu_item
				cmp #0				; Zombie -> Explore
				bne aoa_M0073_4
				show_status_message #STATUSMSG_124
				rts
aoa_M0073_4				
				cmp #1				; Zombie -> Give
				bne aoa_M0073_5
				show_pocket
				is_chosen_in_pocket #ACTI_ROTTENFISH
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				show_status_message #STATUSMSG_125
				logic_M0073_zombie_disappears
				lda logic_flags_005
				eor #LF_ZOMBIE_HAS_BRAIN
				sta logic_flags_005
				remove_from_pocket #ACTI_ROTTENFISH
				rts
aoa_M0073_5								
aoa_M0073_2
				rts
.endp

.proc act_on_action_M0080
				lda current_action
				cmp #A_M0003_044_ID	; Norah
				bne aoaM0080_1
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
				mva #$c2 hero_XPos
				sta HPOSP0
				mva #$3c hero_YPos
				clear_hero
				draw_hero				
				follow_down #1
@				rts
aoaM0080_1
				rts
.endp

; Performs actions on M0082
.proc act_on_action_M0082
				lda current_action
				cmp #A_M0003_023_ID	; Dirty grave
				bne aoaM0082_1
				lda current_action_menu_item
				cmp #0				; Dirty grave -> Explore
				bne @+1
				lda logic_flags_002
				and #LF_GRAVE_CLEANED
				cmp #LF_GRAVE_CLEANED
				beq @+
				show_status_message #STATUSMSG_055
				rts
@				show_status_message #STATUSMSG_057
				rts
@				cmp #1				; Dirty grave -> Cleanup
				bne @+
				show_pocket
				is_chosen_in_pocket #ACTI_SHIT_SCRAP
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				show_status_message #STATUSMSG_056
				spawn_in_pocket #ACTI_HOSPITAL_C
				lda logic_flags_002
				eor #LF_GRAVE_CLEANED
				sta logic_flags_002
@
aoaM0082_1
				rts
.endp

; Performs actions on M0085
.proc act_on_action_M0085
				lda current_action
				cmp #A_M0003_025_ID	; Cheese rat
				bne aoaM0085_1
				lda current_action_menu_item
				cmp #0				; Cheese rat -> Explore
				bne @+
				show_status_message #STATUSMSG_062
				rts
@				cmp #1				; Cheese rat -> Talk
				bne @+
				show_adventure_message #ADVMSG_063
				prepare_map
				rts
@
				show_pocket
				is_chosen_in_pocket #ACTI_CHEESE
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				lda logic_flags_002
				eor #LF_RAT_FED
				sta logic_flags_002
				show_status_message #STATUSMSG_067
				logic_M0085_rat_disappears
				remove_from_pocket #ACTI_CHEESE
aoaM0085_1
				rts
.endp

; Performs actions on M0100
.proc act_on_action_M0100
				lda current_action
				cmp #A_M0003_027_ID	; Column
				jne aoaM0100_x1
				lda current_action_menu_item
				cmp #0				; Column -> Explore
				bne aoaM0100_1
				show_status_message #STATUSMSG_071
				rts
aoaM0100_1		cmp #1				; Column -> Use
				bne aoaM0100_x1
				show_pocket
				is_chosen_in_pocket #ACTI_AXE
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				logic_M0100_column_disappears
				lda logic_flags_003
				eor #LF_COLUMN_REMOVED
				sta logic_flags_003			
aoaM0100_x1		rts
.endp

; Performs actions on M0101
.proc act_on_action_M0101
				lda current_action
				cmp #A_M0003_063_ID	; Witcher
				jne aoaM0101_x1
				lda current_action_menu_item
				cmp #0				; Witcher -> Explore
				bne aoaM0101_1
				show_status_message #STATUSMSG_152
				rts
aoaM0101_1		cmp #1				; Witcher -> Talk
				bne aoaM0101_2
				show_adventure_message #ADVMSG_153
				prepare_map
				rts
aoaM0101_2		cmp #2				; Witcher -> Give
				jne aoaM0101_x1
				show_pocket
				is_chosen_in_pocket #ACTI_CHICKENLEG
				cpx #1
				beq @+
				is_chosen_in_pocket #ACTI_GOLDBARS
				cpx #1
				beq @+1
				finish_with_message_006
				rts
@				prepare_map
				remove_from_pocket #ACTI_CHICKENLEG
				show_adventure_message #ADVMSG_154
				prepare_map
				lda logic_flags_007
				eor #LF_WITCHER_HANDLED
				sta logic_flags_007
				rts
@				prepare_map
				remove_from_pocket #ACTI_GOLDBARS
				show_status_message #STATUSMSG_155
				turn_hero_alive
				lda logic_flags_009
				eor #LF_HERO_ALIVE
				sta logic_flags_009
				lda logic_flags_013
				eor #LF_GOLD_BARS_GIVEN
				sta logic_flags_013
aoaM0101_x1		rts
.endp

; Performs actions on M0103
.proc act_on_action_M0103
				lda current_action
				cmp #A_M0003_028_ID	; Weed
				jne aoaM0103_x1
				lda current_action_menu_item
				cmp #0				; Weed -> Explore
				bne aoaM0103_1
				show_status_message #STATUSMSG_072
				rts
aoaM0103_1		cmp #1				; Weed -> Use
				bne aoaM0103_x1
				show_pocket
				is_chosen_in_pocket #ACTI_SCISSORS
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				logic_M0103_weed_disappears #1
				lda logic_flags_003
				eor #LF_WEED_REMOVED
				sta logic_flags_003			
aoaM0103_x1		rts
.endp

; Performs actions on M0111
.proc act_on_action_M0111
				lda current_action
				cmp #A_M0003_053_ID	; Grave of the slut
				jne aoaM0111_x1
				lda current_action_menu_item
				cmp #0				; Grave of the slut -> Explore
				bne aoaM0111_x2
				show_status_message #STATUSMSG_129
				rts
aoaM0111_x2		cmp #1				; Grave of the slut -> Use
				show_pocket
				is_chosen_in_pocket #ACTI_SKULL
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				logic_M0111_grave_lowers #1
				remove_from_pocket #ACTI_SKULL
				lda logic_flags_006
				eor #LF_GRAVE_LOWERED
				sta logic_flags_006			
aoaM0111_x1		rts
.endp

; Puts the faom on beer and moves the drunk
; guy towards the glass
.proc logic_M0083_foam_beer(.byte slow) .var
				mva #50 to_be_delayed
				#if .byte slow = #0
					mva #1 to_be_delayed
				#end

				delay
				
				ldx #122
				stx screen_mem+40*10+21
				inx
				stx screen_mem+40*10+22

				delay

				lda #10
				pha
lmfb_00			ldx #19
@				lda screen_mem+40*10,x
				inx
				sta screen_mem+40*10,x
				dex
				lda screen_mem+40*11,x
				inx
				sta screen_mem+40*11,x
				dex
				dex
				cpx #4
				bne @-
				pla
				tay
				dey
				cpy #0
				beq @+
				tya
				pha
				delay
				jmp lmfb_00
				
@
				rts
.endp

.proc logic_M0084_lower_bascule_bridge(.byte slow) .var
				mva #97 to_be_delayed
				#if .byte slow = #0
					mva #1 to_be_delayed
				#end
				delay
				
				ldx #32
 				stx screen_mem+40*6+28
 				stx screen_mem+40*7+28
 				stx screen_mem+40*8+28
				ldx #0
 				stx screen_mem+40*6+27
 				stx screen_mem+40*7+27
 				stx screen_mem+40*8+27
				delay
					
				ldx #32
 				stx screen_mem+40*6+30
 				stx screen_mem+40*7+29
 				stx screen_mem+40*8+29
 				stx screen_mem+40*9+28
 				stx screen_mem+40*10+28
				ldx #0
 				stx screen_mem+40*9+27
 				stx screen_mem+40*10+27
 				stx screen_mem+40*6+28
 				stx screen_mem+40*7+28
 				stx screen_mem+40*8+28
				delay
				
				ldx #32
 				stx screen_mem+40*11+28	
 				stx screen_mem+40*10+29
 				stx screen_mem+40*9+30
 				stx screen_mem+40*8+31	
 				stx screen_mem+40*7+32	
				ldx #0
 				stx screen_mem+40*6+30
 				stx screen_mem+40*7+29
 				stx screen_mem+40*8+29
 				stx screen_mem+40*9+28
 				stx screen_mem+40*10+28
 				stx screen_mem+40*11+27
				delay

				ldx #32
 				stx screen_mem+40*12+28	
 				stx screen_mem+40*11+29
 				stx screen_mem+40*11+30
 				stx screen_mem+40*10+31
 				stx screen_mem+40*10+32
 				stx screen_mem+40*9+33
				ldx #0
 				stx screen_mem+40*11+28	
 				stx screen_mem+40*10+29
 				stx screen_mem+40*9+30
 				stx screen_mem+40*8+31	
 				stx screen_mem+40*7+32	
				delay

				ldx #32
 				stx screen_mem+40*12+29
 				stx screen_mem+40*12+30
 				stx screen_mem+40*11+31
 				stx screen_mem+40*11+32
 				stx screen_mem+40*11+33
				ldx #0
 				stx screen_mem+40*11+29
 				stx screen_mem+40*11+30
 				stx screen_mem+40*10+31
 				stx screen_mem+40*10+32
 				stx screen_mem+40*9+33
				delay

				ldx #32
 				stx screen_mem+40*12+29
 				stx screen_mem+40*12+30
 				stx screen_mem+40*12+31
 				stx screen_mem+40*12+32
 				stx screen_mem+40*12+33
				ldx #0
 				stx screen_mem+40*11+31
 				stx screen_mem+40*11+32
 				stx screen_mem+40*11+33
				delay

				rts
.endp

; Assures that all actions done to the
; particular map are visible when
; map is preloaded.
				org logic_dll_post
				
.proc post_load_logic
				disable_lightning

				; ============== MAP 0085 ==========
				is_on_30303538
				cpx #1
				jne pll_next_map_0001
				lda logic_flags_002
				and #LF_RAT_FED
				cmp #LF_RAT_FED
				bne @+
				logic_M0085_rat_disappears
@				rts

pll_next_map_0001
				; ============== MAP 0100 ==========
				is_on_31303030
				cpx #1
				jne pll_next_map_0003
				lda logic_flags_003
				and #LF_COLUMN_REMOVED
				cmp #LF_COLUMN_REMOVED
				bne @+
				logic_M0100_column_disappears
@				rts

pll_next_map_0003
				; ============== MAP 0103 ==========
				is_on_31303330
				cpx #1
				jne pll_next_map_0004
				lda logic_flags_003
				and #LF_WEED_REMOVED
				cmp #LF_WEED_REMOVED
				bne @+
				logic_M0103_weed_disappears #0
@				rts

pll_next_map_0004
pll_next_map_0006
pll_next_map_0008
				; ============== MAP 0078 ==========
				is_on_30303837
				cpx #1
				jne pll_next_map_0009
				lda logic_flags_004
				and #LF_GRAVEUNDER_OPENED
				cmp #LF_GRAVEUNDER_OPENED
				bne @+
				logic_M0078_open_gate #0
@				rts

pll_next_map_0009

				; ============== MAP 0073 ==========
				is_on_30303337
				cpx #1
				jne pll_next_map_0010
				lda logic_flags_005
				and #LF_ZOMBIE_HAS_BRAIN
				cmp #LF_ZOMBIE_HAS_BRAIN
				bne @+
				logic_M0073_zombie_disappears
@				rts

pll_next_map_0010

				; ============== MAP 0077 ==========
				is_on_30303737
				cpx #1
				jne pll_next_map_0011
				lda logic_flags_006
				and #LF_ICICLE_MELTED
				cmp #LF_ICICLE_MELTED
				bne @+
				logic_M0077_remove_icicle #0
@				rts

pll_next_map_0011

				; ============== MAP 0083 ==========
				is_on_30303338
				cpx #1
				jne pll_next_map_0012
				lda logic_flags_006
				and #LF_BEER_FOAMED
				cmp #LF_BEER_FOAMED
				bne @+
				logic_M0083_foam_beer #0
@				rts

pll_next_map_0012
				; ============== MAP 0111 ==========
				is_on_31303131
				cpx #1
				jne pll_next_map_0013
				lda logic_flags_006
				and #LF_GRAVE_LOWERED
				cmp #LF_GRAVE_LOWERED
				bne @+
				logic_M0111_grave_lowers #0
@				rts

pll_next_map_0013

				; ============== MAP 0079 ==========
				is_on_30303937
				cpx #1
				jne pll_next_map_0014
				lda logic_flags_006
				and #LF_SHIT_CLEARED
				cmp #LF_SHIT_CLEARED
				bne @+
				logic_M0079_clear_shit #0
@				rts

pll_next_map_0014

				; ============== MAP 0084 ==========
				is_on_30303438
				cpx #1
				jne pll_next_map_0015
				lda #108	; Make "dziura z gwintem" transparent
				add_single_char_to_transparent_chars
				lda logic_flags_002
				and #LF_BASCULE_BRIDGE_LOW
				cmp #LF_BASCULE_BRIDGE_LOW
				bne @+
				logic_M0084_lower_bascule_bridge #0
@				rts

pll_next_map_0015
				rts
.endp

; Removes Zombie from the cementery underground
.proc logic_M0073_zombie_disappears
				ldx #0
				stx screen_mem+40*6+19
				stx screen_mem+40*6+20
				stx screen_mem+40*7+19
				stx screen_mem+40*7+20
				stx screen_mem+40*8+19
				stx screen_mem+40*8+20
				stx screen_mem+40*9+19
				stx screen_mem+40*9+20
				stx screen_mem+40*10+19
				stx screen_mem+40*10+20
				stx screen_mem+40*11+19
				stx screen_mem+40*11+20
				stx screen_mem+40*11+21
				rts
.endp

; Removes the icicle
.proc logic_M0077_remove_icicle(.byte slow) .var
				mva #100 to_be_delayed
				#if .byte slow = #0
					mva #1 to_be_delayed
				#end
				delay

				ldx screen_mem+40*8+35
				stx screen_mem+40*7+35
				ldx screen_mem+40*9+35
				stx screen_mem+40*8+35
				ldx #0
				stx screen_mem+40*9+35
				delay
				
				ldx screen_mem+40*8+35
				stx screen_mem+40*7+35
				ldx #0
				stx screen_mem+40*8+35
				delay
				
				rts
.endp

; Removes the pile of shit
.proc logic_M0079_clear_shit(.byte slow) .var
				mva #100 to_be_delayed
				#if .byte slow = #0
					mva #1 to_be_delayed
				#end
				delay

				ldx #0
				stx screen_mem+40*7+23
				stx screen_mem+40*7+24
				delay
				stx screen_mem+40*8+23
				stx screen_mem+40*8+24
				
				rts
.endp

; Opens the gate in the graveyard underground
.proc logic_M0078_open_gate(.byte slow) .var
				mva #50 to_be_delayed
				#if .byte slow = #0
					mva #1 to_be_delayed
				#end
				
				ldx #61
				stx screen_mem+40*17+22
				delay
				
				ldx #0
				stx screen_mem+40*10+28
				stx screen_mem+40*11+28
				delay
				delay
				delay

				stx screen_mem+40*9+28
				stx screen_mem+40*12+28
				rts
.endp

; M0085 - removes rat from the map
.proc logic_M0085_rat_disappears
				mva #13 tmp_loop_iterator 
				ldy #4
@				inc tmp_loop_iterator
				tya
				pha
				print_string #CISTERN_CLR_0 #25 tmp_loop_iterator #0
				pla
				tay
				dey
				bne @-
				rts
.endp

; Removes the column from the "Roderic" map.
.proc logic_M0100_column_disappears
				lda #$00
				sta screen_mem+40*13+31
				sta screen_mem+40*14+31
				sta screen_mem+40*15+31
				sta screen_mem+40*16+31
				sta screen_mem+40*17+31
				rts
.endp

; Removes the weed from the "Roderic" map.
.proc logic_M0103_weed_disappears(.byte slow) .var
				mva #50 to_be_delayed
				#if .byte slow = #0
					mva #1 to_be_delayed
				#end
				
				ldx #$00
				stx screen_mem+40*8+35
				stx screen_mem+40*8+36
				delay

				stx screen_mem+40*9+35
				stx screen_mem+40*9+36
				delay

				stx screen_mem+40*10+35
				stx screen_mem+40*10+36
				delay

				stx screen_mem+40*11+35
				stx screen_mem+40*11+36
				delay

				stx screen_mem+40*12+35
				stx screen_mem+40*12+36
				delay

				stx screen_mem+40*13+35
				stx screen_mem+40*13+36
				delay

				stx screen_mem+40*14+35
				stx screen_mem+40*14+36
				rts
.endp

.proc logic_M0111_grave_lowers(.byte slow) .var
				mva #100 to_be_delayed
				#if .byte slow = #0
					mva #1 to_be_delayed
				#end
				
				ldx #107
				stx screen_mem+40*13+30
				ldx #109
				stx screen_mem+40*13+28
				ldx #0
				stx screen_mem+40*13+29
				delay

				ldx #107
				stx screen_mem+40*13+31
				ldx #109
				stx screen_mem+40*13+27
				ldx #0
				stx screen_mem+40*13+28
				stx screen_mem+40*13+30
				delay
				delay
				delay
				
				ldx #75
				stx screen_mem+40*13+28
				ldx #78
				stx screen_mem+40*13+29
				ldx #23
				stx screen_mem+40*13+30
				
				ldx #72
				stx screen_mem+40*12+28
				inx
				stx screen_mem+40*12+29
				inx
				stx screen_mem+40*12+30

				ldx #69
				stx screen_mem+40*11+28
				inx
				stx screen_mem+40*11+29
				inx
				stx screen_mem+40*11+30
				
				ldx #66
				stx screen_mem+40*10+28
				inx
				stx screen_mem+40*10+29
				inx
				stx screen_mem+40*10+30

				ldx #0
				stx screen_mem+40*9+28
				stx screen_mem+40*9+29
				stx screen_mem+40*9+30

				rts
.endp

; Performs actions on M0079
.proc act_on_action_M0079
				lda current_action
				cmp #A_M0003_054_ID	; Pile of shit
				bne aoaM0079_1
				lda current_action_menu_item
				cmp #0				; Pile of shit -> Explore
				bne @+
				show_status_message #STATUSMSG_130
				rts
@				cmp #2				; Pile of shit -> Lick
				bne @+
				show_status_message #STATUSMSG_131
				rts
@				cmp #1				; Pile of shit -> Use
				show_pocket
				is_chosen_in_pocket #ACTI_TOILETBRSH
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				lda logic_flags_006
				eor #LF_SHIT_CLEARED
				sta logic_flags_006
				logic_M0079_clear_shit #1
				remove_from_pocket #ACTI_TOILETBRSH
				rts
aoaM0079_1
				rts
.endp

.proc is_on_30303337
				is_on_map_3030 #$3337
				rts
.endp
.proc is_on_30303837
				is_on_map_3030 #$3837
				rts
.endp
.proc is_on_30303937
				is_on_map_3030 #$3937
				rts
.endp
.proc is_on_30303238
				is_on_map_3030 #$3238
				rts
.endp
.proc is_on_30303438
				is_on_map_3030 #$3438
				rts
.endp
.proc is_on_30303538
				is_on_map_3030 #$3538
				rts
.endp
.proc is_on_30303839
				is_on_map_3030 #$3839
				rts
.endp
.proc is_on_31303030
				is_on_map_3130 #$3030
				rts
.endp
.proc is_on_31303330
				is_on_map_3130 #$3330
				rts
.endp
.proc is_on_31303031
				is_on_map_3130 #$3031
				rts
.endp
.proc is_on_30303737
				is_on_map_3030 #$3737
				rts
.endp
.proc is_on_30303038
				is_on_map_3030 #$3038
				rts
.endp
.proc is_on_30303338
				is_on_map_3030 #$3338
				rts
.endp
.proc is_on_31303131
				is_on_map_3130 #$3131
				rts
.endp
.proc is_on_31303130
				is_on_map_3130 #$3130
				rts
.endp

; Makes the water transparent
.proc make_water_transparent
				lda #1
				add_single_char_to_transparent_chars
				rts
.endp


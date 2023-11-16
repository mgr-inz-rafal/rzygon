;	@com.wudsn.ide.asm.mainsourcefile=../main.asm
				org logic_dll
				
.proc process_logic
				mwa #0 current_action
					
				; "Przedsionek kanalow" = MAP0011.MAP
pl02			is_on_30303131
				cpx #1
				bne pl03
				process_logic_M0011
@				rts

				; "Tank kalowy" = MAP0014.MAP
pl03			is_on_30303431
				cpx #1
				bne pl04
				mwa #act_on_action_M0014-1 act_on_action_vector
				process_logic_M0014
@				rts

				; "Cysterna" = MAP0020.MAP
pl04			is_on_30303032
				cpx #1
				bne pl05
				mwa #act_on_action_M0020-1 act_on_action_vector
				process_logic_M0020
@				rts
pl05

				; "Kanaly pod lochami" = MAP0018.MAP
				is_on_30303831
				cpx #1
				bne pl06
				mwa #act_on_action_M0018-1 act_on_action_vector
				process_logic_M0018
@				rts
pl06

				; "Odstojniki" = MAP0027.MAP
				is_on_30303732
				cpx #1
				bne pl07
				mwa #act_on_action_M0027-1 act_on_action_vector
				process_logic_M0027
@				rts
pl07

				; "Musi roj" = MAP0029.MAP
				is_on_30303932
				cpx #1
				bne pl08
				mwa #act_on_action_M0029-1 act_on_action_vector
				process_logic_M0029
@				rts
pl08
				; "Wejscie do magazynu" = MAP0038.MAP
				is_on_30303833
				cpx #1
				bne pl09
				mwa #act_on_action_M0038-1 act_on_action_vector
				process_logic_M0038
@				rts
pl09
				; "Dno cysterny" = MAP0022.MAP
				is_on_30303232
				cpx #1
				bne pl10
				mwa #act_on_action_M0022-1 act_on_action_vector
				process_logic_M0022
@				rts
pl10
				; "Wejscie do cysterny" = MAP0019.MAP
				is_on_30303931
				cpx #1
				bne pl12
				mwa #act_on_action_M0019-1 act_on_action_vector
				process_logic_M0019
@				rts
pl12
				; "Kanaly pod lochami" = MAP0012.MAP
				is_on_30303231
				cpx #1
				bne pl14
				mwa #act_on_action_M0012-1 act_on_action_vector
				process_logic_M0012
@				rts
pl14
				; "Rozwidlenie rowu" = MAP0071.MAP
				is_on_30303137
				cpx #1
				bne pl16
				mwa #act_on_action_M0071-1 act_on_action_vector
				process_logic_M0071
@				rts
pl16
				; "Kostkowy korytarz" = MAP0127.MAP
				is_on_30310732
				cpx #1
				bne pl17
				mwa #act_on_action_M0127-1 act_on_action_vector
				process_logic_M0127
@				rts
pl17
				; "Magazyn" = MAP0042.MAP
				is_on_30303234
				cpx #1
				bne pl18
				mwa #act_on_action_M0042-1 act_on_action_vector
				process_logic_M0042
@				rts
pl18
				; "Biedny..." = MAP0105.MAP
				is_on_31303530
				cpx #1
				bne pl19
				mwa #act_on_action_M0105-1 act_on_action_vector
				process_logic_M0105
@				rts
pl19
				; "...pies..." = MAP0106.MAP
				is_on_31303630
				cpx #1
				bne pl20
				mwa #act_on_action_M0106-1 act_on_action_vector
				process_logic_M0106
@				rts
pl20
				; "Przepompownia kału" = MAP0016.MAP
				is_on_30303631
				cpx #1
				bne pl21
				mwa #act_on_action_M0016-1 act_on_action_vector
				process_logic_M0016
@				rts
pl21

				rts
.endp

; Performs actions on M0016
.proc act_on_action_M0016
				lda current_action
				cmp #A_M0003_079_ID	; Control panel
				jne aoaM0016_1
				lda current_action_menu_item
				cmp #0				; Control panel -> Explore
				bne @+
				show_status_message #STATUSMSG_195
				rts
@				cmp #1				; Control panel -> Start
				bne @+
				lda logic_flags_010
				and #LF_POOPUMP_SCREWS
				cmp #LF_POOPUMP_SCREWS
				beq aoaM0016_2
				show_status_message #STATUSMSG_196
				rts
aoaM0016_2
				lda logic_flags_010
				eor #LF_POOPUMP_STARTED
				sta logic_flags_010
				show_status_message #STATUSMSG_203
				rts
@				cmp #2				; Control panel -> Use
				bne @+
				show_pocket
				is_chosen_in_pocket #ACTI_SCREWDRVR
				cpx #1
				beq @+
				is_chosen_in_pocket #ACTI_MUCUS
				cpx #1
				beq aoaM0016_4
				finish_with_message_006
				rts
@				prepare_map
				lda logic_flags_010
				cmp #LF_POOPUMP_MUCUS
				and #LF_POOPUMP_MUCUS
				beq aoaM0016_3
				show_status_message #STATUSMSG_197
				lda logic_flags_010
				eor #LF_POOPUMP_SCREWS
				sta logic_flags_010
				rts				
aoaM0016_3		show_status_message #STATUSMSG_198
				rts
aoaM0016_4		prepare_map
				show_status_message #STATUSMSG_199
				lda logic_flags_010
				eor #LF_POOPUMP_MUCUS
				sta logic_flags_010
				remove_from_pocket #ACTI_MUCUS
				rts
@
aoaM0016_1
				rts
.endp

; Performs all actions connected to logic on MAP0016
.proc process_logic_M0016
				#if .byte hero_XPos = #$3c .and .byte hero_YPos = #$a0
					write_action_name #A_M0003_079
					mwa #A_M0003_079_ID current_action
					lda logic_flags_010
					and #LF_POOPUMP_SCREWS
					cmp #LF_POOPUMP_SCREWS
					beq @+
					propagate_action_menu #ACT_EXPLORE #ACT_START #ACT_USE
					rts
@					lda logic_flags_010
					and #LF_POOPUMP_STARTED
					cmp #LF_POOPUMP_STARTED
					beq @+
					propagate_action_menu #ACT_EXPLORE #ACT_START #ACT_EMPTY
					rts
@					propagate_action_menu_EXEMEM
					rts
				#end
				rts
.endp

; Performs actions on M0105
.proc act_on_action_M0105
				lda current_action
				cmp #A_M0003_078_ID	; Slug
				bne aoaM0105_1
				lda current_action_menu_item
				cmp #0				; Slug -> Explore
				bne @+
				show_status_message #STATUSMSG_193
				rts
@				cmp #1				; Slug -> Give
				bne aoaM0105_1
				show_pocket
				is_chosen_in_pocket #ACTI_CHICK
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				show_status_message #STATUSMSG_194
				remove_from_pocket #ACTI_CHICK
				spawn_in_pocket #ACTI_MUCUS
				lda logic_flags_009
				eor #LF_SLUG_FED
				sta logic_flags_009
				rts				
aoaM0105_1
				rts
.endp

; Performs actions on M0105
.proc act_on_action_M0106
				lda current_action
				cmp #A_M0003_030_ID	; Morel
				bne aoaM0106_1
				lda current_action_menu_item
				cmp #0				; Morel -> Explore
				bne @+
				show_status_message #STATUSMSG_225
				rts
@				cmp #1				; Morel -> Cut
				bne @+
				show_pocket
				is_chosen_in_pocket #ACTI_PENKNIFE
				cpx #1
				beq aoaM0106_2
				finish_with_message_006
				rts
aoaM0106_2		prepare_map
				logic_M0106_cut_morel
				lda logic_flags_012
				eor #LF_MOREL_CUT
				sta logic_flags_012
				rts
@				cmp #2				; Morel -> Pee
				bne @+
				show_status_message #STATUSMSG_224
				rts
@
aoaM0106_1		rts				
.endp

; Performs all actions connected to logic on MAP0106
.proc process_logic_M0106
				lda logic_flags_012
				and #LF_MOREL_CUT
				cmp #LF_MOREL_CUT
				beq @+
				#if .byte hero_XPos = #$84 .and .byte hero_YPos = #$58
					write_action_name #A_M0003_030
					mwa #A_M0003_030_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_CUT #ACT_PEE
					rts
				#end
@				rts
.endp

; Performs all actions connected to logic on MAP0105
.proc process_logic_M0105
				#if .byte hero_XPos = #$b0 .and .byte hero_YPos = #$90
					write_action_name #A_M0003_078
					mwa #A_M0003_078_ID current_action
					lda logic_flags_009
					and #LF_SLUG_FED
					cmp #LF_SLUG_FED
					beq @+
					propagate_action_menu #ACT_EXPLORE #ACT_GIVE #ACT_EMPTY
					rts
@					propagate_action_menu_EXEMEM
					rts
				#end
				rts
.endp

; Performs actions on M0014
.proc act_on_action_M0014
				lda current_action
				cmp #A_M0003_005_ID	; Cistern lever
				bne aoaM0014_1
				lda current_action_menu_item
				cmp #0				; Cistern lever -> Explore
				bne @+
				show_status_message #STATUSMSG_010
				rts
@				cmp #1				; Cistern lever -> Move
				bne @+
				lda logic_flags_000
				eor #LF_CISTERN_EMPTY
				sta logic_flags_000
				logic_M0014_empty_cistern #1
				bne @+ 
@				rts				
aoaM0014_1
				rts
.endp

; Performs actions on M0018
.proc act_on_action_M0018
				lda current_action
				cmp #A_M0003_058_ID	; Steel door
				bne aoaM0018_1
				lda current_action_menu_item
				cmp #0				; Steel door -> Explore
				bne @+
				show_status_message #STATUSMSG_142
				rts
@				cmp #1				; Steel door -> Use
				bne aoaM0018_1
				show_pocket
				is_chosen_in_pocket #ACTI_ID_CARD
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				logic_M0018_remove_steel_door
				lda logic_flags_006
				eor #LF_STEEL_DOOR_OPENED
				sta logic_flags_006
				rts				
aoaM0018_1
				rts
.endp

; Performs actions on M0019
.proc act_on_action_M0019
				lda current_action
				cmp #A_M0003_013_ID	; Grate
				bne aoaM0019_1
				lda current_action_menu_item
				cmp #0				; Grate -> Explore
				bne @+
				show_status_message #STATUSMSG_031
				rts
@				cmp #1				; Grate -> Use
				bne @+1
				show_pocket
				is_chosen_in_pocket #ACTI_WRENCH
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				logic_M0019_remove_grate
				lda logic_flags_001
				eor #LF_SEWER_GRATE_REMOVED
				sta logic_flags_001
@
aoaM0019_1
				rts
.endp

; Performs actions on M0020
.proc act_on_action_M0020
				lda current_action
				cmp #A_M0003_006_ID	; Toilet
				bne aoaM0020_1
				lda current_action_menu_item
				cmp #0				; Toilet -> Explore
				bne @+
				show_status_message #STATUSMSG_012
				rts
@				cmp #2				; Toilet -> Sniff
				bne @+
				show_status_message #STATUSMSG_013
				rts
@				cmp #1				; Toilet -> Flush
				bne @+
				mva #$b6 hero_Xpos
				mva #$80 hero_Ypos
				clear_hero
				hero_right
				draw_hero
				rts
@
aoaM0020_1		cmp #A_M0003_004_ID
				bne aoaM0020_2 
				lda current_action_menu_item
				cmp #0				; Lever - Explore
				bne @+
				show_status_message #STATUSMSG_014
				rts
@				cmp #1				; Lever - Flush
				bne @+
				lda logic_flags_000
				eor #LF_BIG_CISTERN_EMPTY
				sta logic_flags_000
				logic_M0020_empty_big_cistern #1
@
aoaM0020_2		rts
.endp

; Performs actions on M0012
.proc act_on_action_M0012
				lda current_action
				cmp #A_M0003_016_ID	; Modern door
				bne aoaM0012_1
				lda current_action_menu_item
				cmp #0				; Modern door -> Explore
				bne @+
				show_status_message #STATUSMSG_034
				rts
@				cmp #1				; Modern door -> Open
				bne @+
				lda logic_flags_005
				and #LF_HOSPITAL_OPENED
				cmp #LF_HOSPITAL_OPENED
				bne aoaM0012_4
				mva #$7e hero_XPos
				sta HPOSP0
				mva #$58 hero_YPos
				clear_hero
				draw_hero				
				follow_up #1
				rts												 
aoaM0012_4		show_status_message_003
@				rts				
aoaM0012_1
				cmp #A_M0003_046_ID	; Keyboard
				bne aoaM0012_2
				lda current_action_menu_item
				cmp #0				; Keyboard -> Explore
				bne @+
				show_status_message #STATUSMSG_113
				rts
@				cmp #1				; Keyboard -> Type
				bne @+
				show_pocket
				is_chosen_in_pocket #ACTI_HOSPITAL_C
				cpx #1
				beq aoaM0012_3
				finish_with_message_006
				rts				
aoaM0012_3		prepare_map
				lda logic_flags_005
				eor #LF_HOSPITAL_OPENED
				sta logic_flags_005
				show_status_message #STATUSMSG_114
aoaM0012_2
@
				rts
.endp

; Performs actions on M0027
.proc act_on_action_M0027
				lda current_action
				cmp #A_M0003_008_ID	; Heater
				bne aoaM0027_1
				lda current_action_menu_item
				cmp #0				; Heater -> Explore
				bne @+
				show_status_message #STATUSMSG_019
				rts
@				cmp #1				; Heater -> Use
				bne @+
				show_pocket
				is_chosen_in_pocket #ACTI_DRY_BRAIN
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				show_status_message #STATUSMSG_020
				logic_M0027_fire_brain
				rts
aoaM0027_1		
				cmp #A_M0003_015_ID	; Broken pipe
				bne aoaM0027_2
				lda current_action_menu_item
				cmp #0				; Broken pipe -> Explore
				bne @+
				show_status_message #STATUSMSG_033
				rts
@				cmp #1				; Broken pipe -> Plug
				bne @+
				show_pocket
				is_chosen_in_pocket #ACTI_SNOT
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				logic_M0027_stop_leakage
				remove_from_pocket #ACTI_SNOT
				lda logic_flags_001
				eor #LF_PIPE_SNOTTED
				sta logic_flags_001
aoaM0027_2		
				rts
.endp

; Performs actions on M0029
.proc act_on_action_M0029
				lda current_action
				cmp #A_M0003_009_ID	; Fly swarm
				bne aoaM0029_1
				lda current_action_menu_item
				cmp #0				; Heater -> Explore
				bne @+
				show_status_message #STATUSMSG_022
@				rts
aoaM0029_1		
				cmp #A_M0003_010_ID	; Crack
				jne aoaM0029_2
				lda current_action_menu_item
				cmp #0				; Crack -> Explore
				bne @+
				show_status_message #STATUSMSG_023
				rts
@				cmp #1				; Crack -> Have Crap
				bne @+
				show_status_message #STATUSMSG_024
				rts
@				cmp #2				; Crack -> Drop
				bne @+1
				show_pocket
				is_chosen_in_pocket #ACTI_DOG_SHEET
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				lda logic_flags_001
				and #LF_FLY_SWARM_EXPELLED
				cmp #LF_FLY_SWARM_EXPELLED
				beq @+1 
				lda logic_flags_001
				eor #LF_FLY_SWARM_EXPELLED
				sta logic_flags_001
				logic_M0029_expel_fly_swarm #1
@				rts
@				show_status_message #STATUSMSG_025
aoaM0029_2		rts
.endp

; Performs actions on M0038
.proc act_on_action_M0038
				lda current_action
				cmp #A_M0003_011_ID	; Barrier
				bne aoaM0038_1
				lda current_action_menu_item
				cmp #0				; Barrier -> Explore
				bne @+
				show_status_message #STATUSMSG_026
				rts
@				cmp #1				; Barrier -> Open
				bne @+
				show_status_message_003
@				rts
aoaM0038_1		
				rts
.endp

; Performs actions on M0022
.proc act_on_action_M0022
				lda current_action
				cmp #A_M0003_004_ID	; Lever
				bne aoaM0022_1
				lda current_action_menu_item
				cmp #0				; Lever -> Explore
				bne @+
				show_status_message #STATUSMSG_027
				rts
@				cmp #1				; Lever -> Activate
				bne @+
				lda logic_flags_001
				eor #LF_WAREHOUSE_OPENED
				sta logic_flags_001
				logic_M0022_move_lever
@				rts
aoaM0022_1		
				rts
.endp

; Performs actions on M0071
.proc act_on_action_M0071
				lda current_action
				cmp #A_M0003_089_ID	; Concrete formwork
				bne aoaM0071_1
				lda current_action_menu_item
				cmp #0				; Concrete formwork -> Explore
				bne @+
				show_status_message #STATUSMSG_245
				rts
@				cmp #1				; Concrete formwork -> Use
				bne @+
				show_pocket
				is_chosen_in_pocket #ACTI_PNEUMO
				cpx #1
				beq @+
				is_chosen_in_pocket #ACTI_2_DYNAMS
				cpx #1
				beq aoaM0071_2
				finish_with_message_006
				rts
@				prepare_map
				logic_M0071_remove_fallen_rocks #1
				lda logic_flags_002
				eor #LF_ROCKS_PICKAXED
				sta logic_flags_002
aoaM0071_1		
				rts
aoaM0071_2		prepare_map
				show_status_message #STATUSMSG_249
				rts
.endp

; Performs actions on M0127
.proc act_on_action_M0127
				lda current_action
				cmp #A_M0003_066_ID	; Kutas
				bne aoaM0127_1
				lda current_action_menu_item
				cmp #0				; Kutas -> Explore
				bne @+
				show_status_message #STATUSMSG_163
				rts
@				cmp #1				; Kutas -> Blow
				bne @+
				show_status_message #STATUSMSG_164
				rts
@									; Kutas -> Spill
				show_pocket
				is_chosen_in_pocket #ACTI_ICE_WATER
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				logic_M0127_shrink_kutas #1
				lda logic_flags_008
				eor #LF_KUTAS_SHRINKED				
				sta logic_flags_008
				remove_from_pocket #ACTI_ICE_WATER
aoaM0127_1		
				rts
.endp

; Performs all actions connected to logic on MAP0011
.proc process_logic_M0011
				lda logic_flags_000
				and #LF_SEWER_MSG1
				cmp #LF_SEWER_MSG1
				beq @+
				#if .byte hero_YPos = #$88
					show_adventure_message #ADVMSG_036
					prepare_map
					lda logic_flags_000
					eor #LF_SEWER_MSG1
					sta logic_flags_000
				#end
@				rts
.endp

; Performs all actions connected to logic on MAP0012
.proc process_logic_M0012
				#if .byte hero_XPos >= #$9c .and .byte hero_XPos <= #$a6 .and .byte hero_YPos = #$38
					write_action_name #A_M0003_016
					mwa #A_M0003_016_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_OPEN #ACT_EMPTY
@					rts
				#end
				#if .byte hero_XPos >= #$ac .and .byte hero_XPos <= #$b0 .and .byte hero_YPos = #$38
					write_action_name #A_M0003_046
					mwa #A_M0003_046_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_TYPE #ACT_EMPTY
@					rts
				#end
				rts
.endp

; Performs all actions connected to logic on MAP0014
.proc process_logic_M0014
				#if .byte hero_XPos = #$ab .and .byte hero_YPos = #$68
					lda logic_flags_000
					and #LF_CISTERN_EMPTY
					cmp #LF_CISTERN_EMPTY
					beq @+		
					show_status_message #STATUSMSG_009
					hero_right
					hero_jump
@					rts
				#end
				#if .byte hero_XPos = #$6c .and .byte hero_YPos = #$30
					write_action_name #A_M0003_005
					mwa #A_M0003_005_ID current_action
					lda logic_flags_000
					and #LF_CISTERN_EMPTY
					cmp #LF_CISTERN_EMPTY
					beq @+
					propagate_action_menu #ACT_EXPLORE #ACT_ACTIVATE #ACT_EMPTY
					rts
@					propagate_action_menu_EXEMEM
				#end
				rts
.endp 

; Performs all actions connected to logic on MAP0018
.proc process_logic_M0018
				#if .byte hero_XPos = #$6c .and .byte hero_YPos = #$a0
					is_item_in_pocket #ACTI_FIRE_BRAIN
					cmp #1
					beq @+1
					show_status_message #STATUSMSG_018
					ldx #18
@					hero_left
					dex
					bne @-
					rts
@					
					lda logic_flags_000
					and #LF_BRAIN_FIRED
					cmp #LF_BRAIN_FIRED
					beq @+ 
					show_status_message #STATUSMSG_021
					lda logic_flags_000
					eor #LF_BRAIN_FIRED
					sta logic_flags_000
@					rts
				#end

				#if .byte hero_XPos = #$a8 .and .byte hero_YPos = #$50
					lda logic_flags_006
					and #LF_STEEL_DOOR_OPENED
					cmp #LF_STEEL_DOOR_OPENED
					beq @+
					write_action_name #A_M0003_058
					mwa #A_M0003_058_ID current_action
					propagate_action_menu_EXUSEM
@
				#end
.endp

; Performs all actions connected to logic on MAP0019
.proc process_logic_M0019
				#if .byte hero_XPos = #$68 .and .byte hero_YPos = #$38
					lda logic_flags_001
					and #LF_SEWER_GRATE_REMOVED
					cmp #LF_SEWER_GRATE_REMOVED
					beq @+
					write_action_name #A_M0003_013
					mwa #A_M0003_013_ID current_action
					propagate_action_menu_EXUSEM
@
				#end
				rts
.endp

; Performs all actions connected to logic on MAP0020
.proc process_logic_M0020
				lda logic_flags_000
				and #LF_BIG_CISTERN_EMPTY
				cmp #LF_BIG_CISTERN_EMPTY
				beq @+1 
				#if .byte hero_XPos = #$51 .and .byte hero_YPos > #$45
					show_status_message #STATUSMSG_011
					ldx #8
@					hero_left
					dex
					bne @-
					rts
				#end
@				#if .byte hero_XPos = #$a4 .and .byte hero_YPos = #$30
					write_action_name #A_M0003_006
					mwa #A_M0003_006_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_FLUSH #ACT_SNIFF
				#end
				#if .byte hero_XPos = #$b4 .and .byte hero_YPos = #$90
					write_action_name #A_M0003_004
					mwa #A_M0003_004_ID current_action
					lda logic_flags_000
					and #LF_BIG_CISTERN_EMPTY
					cmp #LF_BIG_CISTERN_EMPTY
					beq @+
					propagate_action_menu_EXUSEM
					rts
@					propagate_action_menu_EXEMEM
				#end
				rts
.endp

; Performs all actions connected to logic on MAP0027
.proc process_logic_M0027
				#if .byte hero_XPos = #$4c .and .byte hero_YPos = #$a0
					write_action_name #A_M0003_008
					mwa #A_M0003_008_ID current_action
					propagate_action_menu_EXUSEM
					rts
				#end
				#if .byte hero_XPos = #$50 .and .byte hero_YPos = #$40
					lda logic_flags_001
					and #LF_PIPE_SNOTTED
					cmp #LF_PIPE_SNOTTED
					beq @+
					write_action_name #A_M0003_015
					mwa #A_M0003_015_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_PLUG #ACT_EMPTY
					rts
@
				#end
				rts
.endp

; Performs all actions connected to logic on MAP0029
.proc process_logic_M0029
				#if .byte hero_XPos = #$98 .and .byte hero_YPos = #$68
					lda logic_flags_001
					and #LF_FLY_SWARM_EXPELLED
					cmp #LF_FLY_SWARM_EXPELLED
					beq @+
					write_action_name #A_M0003_009
					mwa #A_M0003_009_ID current_action
					propagate_action_menu_EXEMEM
@					rts
				#end
				#if .byte hero_YPos = #$a0 .and .byte hero_XPos = #$94
plM0029_1			write_action_name #A_M0003_010
					mwa #A_M0003_010_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_HAVECRAP #ACT_DROP
					rts
				#end
				#if .byte hero_YPos = #$a0 .and .byte hero_XPos = #$a8
					jmp plM0029_1
				#end
				rts
.endp

; Performs all actions connected to logic on MAP0038
.proc process_logic_M0038
				#if .byte hero_XPos = #$84 .and .byte hero_YPos = #$88
					lda logic_flags_001
					and #LF_WAREHOUSE_OPENED
					cmp #LF_WAREHOUSE_OPENED
					beq @+
					write_action_name #A_M0003_011
					mwa #A_M0003_011_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_OPEN #ACT_EMPTY
@					rts
				#end
				rts
.endp

; Performs all actions connected to logic on MAP0022
.proc process_logic_M0022
				#if .byte hero_XPos = #$b8 .and .byte hero_YPos = #$68
					write_action_name #A_M0003_004
					mwa #A_M0003_004_ID current_action
					lda logic_flags_001
					and #LF_WAREHOUSE_OPENED
					cmp #LF_WAREHOUSE_OPENED
					beq @+
					propagate_action_menu #ACT_EXPLORE #ACT_ACTIVATE #ACT_EMPTY
					rts
@					propagate_action_menu_EXEMEM
					rts
				#end
				rts
.endp

; Performs all actions connected to logic on MAP0071
.proc process_logic_M0071
				#if .byte hero_XPos = #$40 .and .byte hero_YPos = #$a0
					lda logic_flags_002
					and #LF_ROCKS_PICKAXED
					cmp #LF_ROCKS_PICKAXED
					beq @+
					write_action_name #A_M0003_089
					mwa #A_M0003_089_ID current_action
					propagate_action_menu_EXUSEM
				#end
@				rts
.endp

; Performs all actions connected to logic on MAP0127
.proc process_logic_M0127
				#if .byte hero_XPos = #$7c .and .byte hero_YPos = #$68
					lda logic_flags_008
					and #LF_KUTAS_SHRINKED				
					cmp #LF_KUTAS_SHRINKED
					beq @+
					write_action_name #A_M0003_066
					mwa #A_M0003_066_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_BLOW #ACT_SPILL 
@
				#end
				rts
.endp

; Shrinks the kutas after it has been poured over with the ice-cold water
.proc logic_M0127_shrink_kutas(.byte slow) .var
				mva #50 to_be_delayed
				#if .byte slow = #0
					mva #1 to_be_delayed
				#end

				lda #0
				sta screen_mem+6*40+21
				lda #60
				sta screen_mem+7*40+21
				delay
				lda #0
				sta screen_mem+7*40+21
				lda #60
				sta screen_mem+8*40+21
				delay
				lda #0
				sta screen_mem+8*40+21
				lda #60
				sta screen_mem+9*40+21
				delay
				lda #0
				sta screen_mem+9*40+21
				lda #60
				sta screen_mem+10*40+21
				
				rts
.endp

.proc act_on_action_M0042
				lda current_action
				cmp #A_M0003_074_ID	; Unstable coffin
				bne aoaM0042_1
				lda current_action_menu_item
				cmp #0				; Unstable coffin -> Explore
				bne @+
				show_status_message #STATUSMSG_178
				rts
@				cmp #1				; Unstable coffin -> Move
				bne @+
				show_status_message #STATUSMSG_179
				rts
@				cmp #2				; Unstable coffin -> Use
				show_pocket
				is_chosen_in_pocket #ACTI_COFFIN_HND
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				logic_M0042_move_coffin #1
				remove_from_pocket #ACTI_COFFIN_HND
				lda logic_flags_009
				eor #LF_COFFIN_MOVED
				sta logic_flags_009
				bne aoaM0042_1
aoaM0042_1
				rts
.endp

.proc logic_M0042_move_coffin(.byte slow) .var
				mva #100 to_be_delayed
				#if .byte slow = #0
					mva #1 to_be_delayed
				#end

				delay
;				hero_right_3
				
				ldx #2
				mwa #screen_mem+40*8+9 screen_tmp

@				lda #6
				sta slow
@				ldy #0
				lda (screen_tmp),y
				iny
				sta (screen_tmp),y
				adw screen_tmp #39
				lda (screen_tmp),y
				iny
				sta (screen_tmp),y
				sbw screen_tmp #40
				dec slow
				bne @-
				
				pha
				tya
				pha
				txa
				pha
				lda screen_mem
				pha
				lda screen_mem+1
				pha
				lda screen_tmp
				pha
				lda screen_tmp+1
				pha
;				hero_right_3
				pla
				sta screen_tmp+1
				pla
				sta screen_tmp
				pla
				sta screen_mem+1
				pla
				sta screen_mem
				pla
				tax
				pla
				tay
				pla
				
				adw screen_tmp #7
				delay
				dex
				cpx #0
				bne @-1
				
				rts
.endp

; Performs all actions connected to logic on MAP0042
.proc process_logic_M0042
				#if .byte hero_XPos = #$58 .and .byte hero_YPos = #$58
					write_action_name #A_M0003_074
					mwa #A_M0003_074_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_MOVE #ACT_USE
					rts
				#end
				rts
.endp

; Assures that all actions done to the
; particular map are visible when
; map is preloaded.
				org logic_dll_post
				
.proc post_load_logic
				disable_strobo
				disable_lightning

				; ============== MAP 0011 ==========
				is_on_30303131
				cpx #1
				jne pll_next_map_0003
				make_pipes_transparent
@				rts
				; ==================================
pll_next_map_0003

				; ============== MAP 0012 ==========
				is_on_30303231
				cpx #1
				jne pll_next_map_0004
				make_pipes_transparent
@				rts
				; ==================================
pll_next_map_0004

				; ============== MAP 0013 ==========
				is_on_30303331
				cpx #1
				jne pll_next_map_0005
				make_pipes_transparent
@				rts
				; ==================================
pll_next_map_0005

				; ============== MAP 0015 ==========
				is_on_30303531
				cpx #1
				jne pll_next_map_0006
				make_pipes_transparent
@				rts
				; ==================================
pll_next_map_0006
				; ============== MAP 0014 ==========
				is_on_30303431
				cpx #1
				jne pll_next_map_0007
				make_pipes_transparent
				lda logic_flags_000
				and #LF_CISTERN_EMPTY
				cmp #LF_CISTERN_EMPTY
				bne @+
				logic_M0014_empty_cistern #0
@				rts
				; ==================================
pll_next_map_0007

				; ============== MAP 0018 ==========
				is_on_30303831
				cpx #1
				jne pll_next_map_0008
				make_pipes_transparent
				logic_M0018_set_room_dark
				lda logic_flags_006
				and #LF_STEEL_DOOR_OPENED
				cmp #LF_STEEL_DOOR_OPENED
				bne @+
				logic_M0018_remove_steel_door
@				rts
				; ==================================
pll_next_map_0008
				; ============== MAP 0020 ==========
				is_on_30303032
				cpx #1
				jne pll_next_map_0009
				lda logic_flags_000
				and #LF_BIG_CISTERN_EMPTY
				cmp #LF_BIG_CISTERN_EMPTY
				bne @+
				logic_M0020_empty_big_cistern #0
				
@				rts
				; ==================================
pll_next_map_0009
				; ============== MAP 0025 ==========
				is_on_30303532
				cpx #1
				jne pll_next_map_0010
				make_pipes_transparent
@				rts
				; ==================================
pll_next_map_0010
				; ============== MAP 0026 ==========
				is_on_30303632
				cpx #1
				jne pll_next_map_0011
				make_pipes_transparent
@				rts
				; ==================================
pll_next_map_0011
				; ============== MAP 0023 ==========
				is_on_30303332
				cpx #1
				jne pll_next_map_0012
				make_pipes_transparent
@				rts
				; ==================================
pll_next_map_0012
				; ============== MAP 0022 ==========
				is_on_30303232
				cpx #1
				jne pll_next_map_0013
				make_pipes_transparent
				lda logic_flags_001
				and #LF_WAREHOUSE_OPENED
				cmp #LF_WAREHOUSE_OPENED
				bne @+
				logic_M0022_move_lever
				
@				rts
				; ==================================
pll_next_map_0013
				; ============== MAP 0027 ==========
				is_on_30303732
				cpx #1
				jne pll_next_map_0014
				make_pipes_transparent
				lda logic_flags_001
				and #LF_PIPE_SNOTTED
				cmp #LF_PIPE_SNOTTED
				bne @+
				logic_M0027_stop_leakage
@				rts
				; ==================================
pll_next_map_0014
				; ============== MAP 0028 ==========
				is_on_30303832
				cpx #1
				jne pll_next_map_0015
				make_pipes_transparent
@				rts
				; ==================================
pll_next_map_0015
				; ============== MAP 0030 ==========
				is_on_30303033
				cpx #1
				jne pll_next_map_0016
				make_pipes_transparent
@				rts
				; ==================================
pll_next_map_0016
				; ============== MAP 0031 ==========
				is_on_30303133
				cpx #1
				jne pll_next_map_0017
				make_pipes_transparent
@				rts
				; ==================================
pll_next_map_0017
				; ============== MAP 0032 ==========
				is_on_30303233
				cpx #1
				jne pll_next_map_0018
				make_pipes_transparent
@				rts
				; ==================================
pll_next_map_0018
				; ============== MAP 0029 ==========
				is_on_30303932
				cpx #1
				jne pll_next_map_0019
				lda logic_flags_001
				and #LF_FLY_SWARM_EXPELLED
				cmp #LF_FLY_SWARM_EXPELLED
				bne @+
				logic_M0029_expel_fly_swarm #0
@				rts
				; ==================================
pll_next_map_0019
				; ============== MAP 0038 ==========
				is_on_30303833
				cpx #1
				jne pll_next_map_0020
				lda logic_flags_001
				and #LF_WAREHOUSE_OPENED
				cmp #LF_WAREHOUSE_OPENED
				bne @+
				logic_M0038_open_warehouse
@				rts
				; ==================================
pll_next_map_0020
				; ============== MAP 0019 ==========
				is_on_30303931
				cpx #1
				jne pll_next_map_0022
				lda logic_flags_001
				and #LF_SEWER_GRATE_REMOVED
				cmp #LF_SEWER_GRATE_REMOVED
				bne @+
				logic_M0019_remove_grate
@				rts
				; ==================================
pll_next_map_0022
				; ============== MAP 0071 ==========
				is_on_30303137
				cpx #1
				jne pll_next_map_0023
				lda #124
				add_single_char_to_transparent_chars
				lda logic_flags_002
				and #LF_ROCKS_PICKAXED
				cmp #LF_ROCKS_PICKAXED
				bne @+
				logic_M0071_remove_fallen_rocks #0
@				rts
				; ==================================
pll_next_map_0023
				; ============== MAP 0127 ==========
				is_on_30310732
				cpx #1
				jne pll_next_map_0024
				lda logic_flags_008
				and #LF_KUTAS_SHRINKED
				cmp #LF_KUTAS_SHRINKED
				bne @+
				logic_M0127_shrink_kutas #0
@				rts
				; ==================================
pll_next_map_0024
				; ============== MAP 0042 ==========
				is_on_30303234
				cpx #1
				jne pll_next_map_0025
				lda logic_flags_009
				and #LF_COFFIN_MOVED
				cmp #LF_COFFIN_MOVED
				bne @+
				logic_M0042_move_coffin #0
@				rts
				; ==================================
pll_next_map_0025
				; ============== MAP 0106 ==========
				is_on_31303630
				cpx #1
				jne pll_next_map_0026
				lda logic_flags_012
				and #LF_MOREL_CUT
				cmp #LF_MOREL_CUT
				bne @+
				logic_M0106_cut_morel
@				rts
				; ==================================
pll_next_map_0026
				rts
.endp

; M0014 - moves the lever and empties the cistern
.proc logic_M0014_empty_cistern(.byte slow) .var
				mva #50 to_be_delayed
				#if .byte slow = #0
					mva #1 to_be_delayed
				#end
				mva #113 screen_mem+3*40+14
				print_string #CISTERN_CLR_0 #30 #13 #0				
				mva #102 screen_mem+17*40+22				
				delay
				print_string #CISTERN_CLR_0 #30 #14 #0				
				mva #102 screen_mem+18*40+22				
				delay
				print_string #CISTERN_CLR_0 #30 #15 #0				
				mva #102 screen_mem+18*40+19				
				mva #102 screen_mem+17*40+20
				delay
				print_string #CISTERN_CLR_1 #31 #16 #0
				mva #102 screen_mem+18*40+21				
				rts				
.endp

; M0020 - moves the lever and empties the big cistern
.proc logic_M0020_empty_big_cistern(.byte slow) .var
				mva #50 to_be_delayed
				#if .byte slow = #0
					mva #1 to_be_delayed
				#end
				
				mva #113 screen_mem+15*40+32
				
				mva #16 tmp_loop_iterator 
				ldy #2
@				inc tmp_loop_iterator
				tya
				pha
				delay
				print_string #STR_CLEAR_CIST #4 tmp_loop_iterator #0
				pla
				tay
				dey
				bne @-
				
				delay
				print_string #STR_CLEAR_CIST1 #4 #19 #0

				rts
.endp

; Makes the room entirely dark
.proc logic_M0018_set_room_dark
				is_item_in_pocket #ACTI_FIRE_BRAIN
				cmp #1
				beq @+ 
				lda #0
				sta COLOR1
				sta COLOR2
@				rts
.endp

; Opens the steel door
.proc logic_M0018_remove_steel_door
				lda #0
				sta screen_mem+6*40+29
				sta screen_mem+7*40+29
				sta screen_mem+8*40+29
				rts
.endp

; Fires the brain.
; Literally replaces the "DRYBR" object in the pocket
; with "DRYBF".
.proc logic_M0027_fire_brain
				; Will leave the address of the DRYBR item
				; in the current_pocket
				is_item_in_pocket #ACTI_DRY_BRAIN
				ldy #4
				lda #'F'
				sta (current_pocket),y
				rts
.endp

; Removes the gas leakega
.proc logic_M0027_stop_leakage
				lda #0
				sta screen_mem+5*40+8
				sta screen_mem+5*40+9
				mva #24 screen_mem+5*40+7 				
				rts
.endp

; Expels the fly swarm from the map
.proc logic_M0029_expel_fly_swarm(.byte slow) .var
				mva #50 to_be_delayed
				#if .byte slow = #0
					mva #1 to_be_delayed
				#end
				mva #0 screen_mem+8*40+27
				delay
				mva #0 screen_mem+7*40+27
				delay
				mva #0 screen_mem+9*40+30
				delay
				mva #0 screen_mem+7*40+28
				delay
				mva #0 screen_mem+6*40+27
				delay
				mva #0 screen_mem+7*40+30
				delay
				mva #0 screen_mem+6*40+28
				delay
				mva #0 screen_mem+8*40+28
				delay
				mva #0 screen_mem+10*40+30
				delay
				mva #0 screen_mem+9*40+29
				delay
				mva #0 screen_mem+8*40+30
				delay
				mva #0 screen_mem+9*40+28
				delay
				mva #0 screen_mem+7*40+29
				delay

				mva screen_mem+10*40+29 screen_mem+11*40+29
				mva #0 screen_mem+10*40+29
				delay
				mva screen_mem+11*40+29 screen_mem+12*40+29
				mva #0 screen_mem+11*40+29
				delay
				mva screen_mem+12*40+29 screen_mem+13*40+29
				mva #0 screen_mem+12*40+29
				delay
				mva screen_mem+13*40+29 screen_mem+14*40+29
				mva #0 screen_mem+13*40+29
				delay
				mva screen_mem+14*40+29 screen_mem+15*40+29
				mva #0 screen_mem+14*40+29
				delay
				mva screen_mem+15*40+29 screen_mem+16*40+28
				mva #0 screen_mem+15*40+29
				delay
				mva screen_mem+16*40+28 screen_mem+17*40+28
				mva #0 screen_mem+16*40+28
				delay
				mva screen_mem+17*40+28 screen_mem+18*40+28
				mva #0 screen_mem+17*40+28
				delay
				mva screen_mem+18*40+28 screen_mem+19*40+28
				mva #0 screen_mem+18*40+28
				delay
				mva #0 screen_mem+19*40+28
				rts
.endp

; Moves the lever at the bottom of the cistern
.proc logic_M0022_move_lever
				mva #82 screen_mem+10*40+36
				rts
.endp

; Lovers the barrier to the warehouse
.proc logic_M0038_open_warehouse
				lda #0
				sta screen_mem+11*40+19
				sta screen_mem+11*40+20

				sta screen_mem+12*40+19
				sta screen_mem+12*40+20

				sta screen_mem+13*40+19
				sta screen_mem+13*40+20

				sta screen_mem+14*40+19
				sta screen_mem+14*40+20
				rts
.endp

; Removes grate after using the wrench
.proc logic_M0019_remove_grate
				lda #0
				sta	screen_mem+3*40+16
				sta screen_mem+4*40+16
				sta screen_mem+5*40+16
				rts
.endp

; Removes the fallen rocks that block the way
.proc logic_M0071_remove_fallen_rocks(.byte slow) .var
				mva #50 to_be_delayed
				#if .byte slow = #0
					mva #1 to_be_delayed
				#end
				delay
				ldx #0
				stx screen_mem+16*40+3
				delay
				stx screen_mem+18*40+3
				delay
				stx screen_mem+17*40+3
				delay
				stx screen_mem+17*40+2
				delay
				stx screen_mem+18*40+2
				delay
				stx screen_mem+16*40+2
				delay
				rts
.endp

; Puts all characters that should be always transparent
; withing the sewers to the list of the transparent chars
.proc make_pipes_transparent
				ldx #0
@				lda PIPES_CHARS,x
				stx tmp_pipes
				add_single_char_to_transparent_chars
				ldx tmp_pipes
				inx
				cpx #15
				bne @-
				rts
.endp

; Handles all issues connected to the logic
; of the game (acting, using items, etc.).
.proc is_on_30303332
				is_on_map_3030 #$3332
				rts
.endp
.proc is_on_30303232
				is_on_map_3030 #$3232
				rts
.endp
.proc is_on_30303231
				is_on_map_3030 #$3231
				rts
.endp
.proc is_on_30303233
				is_on_map_3030 #$3233
				rts
.endp
.proc is_on_30303833
				is_on_map_3030 #$3833
				rts
.endp
.proc is_on_30303133
				is_on_map_3030 #$3133
				rts
.endp
.proc is_on_30303932
				is_on_map_3030 #$3932
				rts
.endp
.proc is_on_30303732
				is_on_map_3030 #$3732
				rts
.endp
.proc is_on_30303832
				is_on_map_3030 #$3832
				rts
.endp
.proc is_on_30303931
				is_on_map_3030 #$3931
				rts
.endp
.proc is_on_30303131
				is_on_map_3030 #$3131
				rts
.endp
.proc is_on_30303331
				is_on_map_3030 #$3331
				rts
.endp
.proc is_on_30303531
				is_on_map_3030 #$3531
				rts
.endp
.proc is_on_30303431
				is_on_map_3030 #$3431
				rts
.endp
.proc is_on_30303831
				is_on_map_3030 #$3831
				rts
.endp
.proc is_on_30303532
				is_on_map_3030 #$3532
				rts
.endp
.proc is_on_30303632
				is_on_map_3030 #$3632
				rts
.endp
.proc is_on_30303032
				is_on_map_3030 #$3032
				rts
.endp
.proc is_on_30303033
				is_on_map_3030 #$3033
				rts
.endp
.proc is_on_30303137
				is_on_map_3030 #$3137
				rts
.endp
.proc is_on_30310732
				is_on_map_3130 #$3732
				rts
.endp
.proc is_on_30303234
				is_on_map_3030 #$3234
				rts
.endp
.proc is_on_31303530
				is_on_map_3130 #$3530
				rts
.endp
.proc is_on_31303630
				is_on_map_3130 #$3630
				rts
.endp
.proc is_on_30303631
				is_on_map_3030 #$3631
				rts
.endp

.proc logic_M0106_cut_morel
				lda #0
				sta screen_mem+9*40+23
				sta screen_mem+9*40+24
				rts
.endp



; These chars are made transparent after call
; to "make_pipes_transparent". Please note
; that these also include the character
; representing water.
PIPES_CHARS
				dta b(3),b(23),b(24),b(25),b(22),b(26),b(27),b(31),b(34),b(35),b(38),b(101),b(52),b(118),b(119)

				
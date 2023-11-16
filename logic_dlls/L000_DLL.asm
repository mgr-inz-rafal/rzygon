;	@com.wudsn.ide.asm.mainsourcefile=../main.asm
				org logic_dll
				
.proc process_logic
				mwa #0 current_action
					
				; "Wyjscie z celi" = MAP0007.MAP
pl00			is_on_30303730
				cpx #1
				bne pl01
				mwa #act_on_action_M0007-1 act_on_action_vector
				process_logic_M0007
				rts
				
				; "Lochy" = MAP0010.MAP
pl01			is_on_30303031
				cpx #1
				bne pl07
				mwa #act_on_action_M0010-1 act_on_action_vector
				process_logic_M0010
				rts
pl07
				; "Straznik klucza" = MAP0000.MAP
				is_on_30303030
				cpx #1
				bne pl11
				mwa #act_on_action_M0000-1 act_on_action_vector
				process_logic_M0000
@				rts
pl11
				; "Oltarz w kaplicy" = MAP0050.MAP
				is_on_30303035
				cpx #1
				bne pl13
				mwa #act_on_action_M0050-1 act_on_action_vector
				process_logic_M0050
@				rts
pl13
				; "Gasienicoksiadz" = MAP0061.MAP
				is_on_30303136
				cpx #1
				bne pl15
				mwa #act_on_action_M0061-1 act_on_action_vector
				process_logic_M0061
@				rts
pl15
				; "Sala operacyjna" = MAP0064.MAP
				is_on_30303436
				cpx #1
				bne pl16
				mwa #act_on_action_M0064-1 act_on_action_vector
				process_logic_M0064
@				rts
pl16
				; "Magazyn" = MAP0041.MAP
				is_on_30303134
				cpx #1
				bne pl17
				mwa #act_on_action_M0041-1 act_on_action_vector
				process_logic_M0041
@				rts
pl17
				; "Tajny kurnik" = MAP0063.MAP
				is_on_30303336
				cpx #1
				bne pl18
				mwa #act_on_action_M0063-1 act_on_action_vector
				process_logic_M0063
@				rts
pl18
				; "Magazyn" = MAP0040.MAP
				is_on_30303034
				cpx #1
				bne pl19
				mwa #act_on_action_M0040-1 act_on_action_vector
				process_logic_M0040
@				rts
pl19
				; "H.E.R.O." = MAP0057.MAP
				is_on_30303735
				cpx #1
				bne pl20
				mwa #act_on_action_M0057-1 act_on_action_vector
				process_logic_M0057
@				rts
pl20
				; "H.E.R.O." = MAP0065.MAP
				is_on_30303536
				cpx #1
				bne pl21
				mwa #act_on_action_M0065-1 act_on_action_vector
				process_logic_M0065
@				rts
pl21
				; "H.E.R.O." = MAP0066.MAP
				is_on_30303636
				cpx #1
				bne pl22
				process_logic_M0066
@				rts
pl22
				; "H.E.R.O." = MAP0067.MAP
				is_on_30303736
				cpx #1
				bne pl23
				mwa #act_on_action_M0067-1 act_on_action_vector
				process_logic_M0067
@				rts
pl23
				; "Nad kaplica" = MAP0056.MAP
				is_on_30303635
				cpx #1
				bne pl24
				mwa #act_on_action_M0056-1 act_on_action_vector
				process_logic_M0056
@				rts
pl24
				; "Kaplica" = MAP0048.MAP
				is_on_30303834
				cpx #1
				bne pl25
				mwa #act_on_action_M0048-1 act_on_action_vector
				process_logic_M0048
@				rts
pl25
				rts
.endp

.proc process_logic_M0048
				#if .byte hero_XPos=#$40 .and .byte hero_YPos=#$a0
					write_action_name #A_M0003_086
					mwa #A_M0003_086_ID current_action
					lda logic_flags_012
					and #LF_HOLYWATER_PEE
					cmp #LF_HOLYWATER_PEE
					beq plM0048_1
					propagate_action_menu #ACT_EXPLORE #ACT_GATHER #ACT_PEE1
					rts
plM0048_1			
					lda logic_flags_012
					and #LF_HOLYWATER_PRAY
					cmp #LF_HOLYWATER_PRAY
					beq plM0048_2
					propagate_action_menu #ACT_EXPLORE #ACT_GATHER #ACT_PRAY
					rts
plM0048_2
					propagate_action_menu #ACT_EXPLORE #ACT_GATHER #ACT_EMPTY
					rts
				#end
				rts
.endp

; Performs actions on M0000
.proc act_on_action_M0000
				lda current_action
				cmp #A_M0003_012_ID	; Demon
				bne aoaM0000_1
				lda current_action_menu_item
				cmp #0				; Demon -> Explore
				bne @+
				show_status_message #STATUSMSG_028
				rts
@				cmp #1				; Demon -> Talk
				bne @+ 
				show_adventure_message #ADVMSG_029
				prepare_map
				rts
@				cmp #2				; Demon -> Give
				bne @+1
				show_pocket
				is_chosen_in_pocket #ACTI_GOLD_CROSS
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				show_status_message #STATUSMSG_030
				lda logic_flags_001
				eor #LF_DEMON_BRIBED
				sta logic_flags_001
				logic_M0000_demon_disappears
				remove_from_pocket #ACTI_GOLD_CROSS
aoaM0000_1
@				rts				
.endp

; Performs actions on M0007
.proc act_on_action_M0007
				lda current_action
				cmp #A_M0003_002_ID	; Wooden door
				bne aoaM0007_1
				lda current_action_menu_item
				cmp #1				; Wooden door -> Squeeze
				bne @+
				lda #$3c
				sta hero_XPos
				sta HPOSP0
				follow_down #1
				rts
@				cmp #0				; Wooden door -> Analyze
				bne @+ 
				show_status_message #STATUSMSG_002
@				rts				
aoaM0007_1
				rts
.endp

; Performs actions on M0010
.proc act_on_action_M0010
				lda current_action
				cmp #A_M0003_004_ID	; Lever
				bne aoaM0010_1
				lda current_action_menu_item
				cmp #0				; Lever -> Explore
				bne @+
				show_status_message #STATUSMSG_007
				rts
@				cmp #1				; Lever -> Move
				lda logic_flags_000
				eor #LF_SEWER_LEVER_OPE_USED
				sta logic_flags_000
				logic_M0010_move_lever
				bne @+ 
@				rts				
aoaM0010_1
				cmp #A_M0003_007_ID	; Fragile skull
				jne aoaM0010_2
				lda current_action_menu_item
				cmp #0				; Fragile skull -> Explore
				bne @+1
				lda logic_flags_000
				and #LF_SKULL_CRACKED
				cmp #LF_SKULL_CRACKED
				beq @+
				show_status_message #STATUSMSG_016
				rts
@				show_status_message #STATUSMSG_017
				rts
@				cmp #1				; Fragile skull -> Use
				bne @+
				show_pocket
				is_chosen_in_pocket #ACTI_HAMMER
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				lda logic_flags_000
				eor #LF_SKULL_CRACKED
				sta logic_flags_000
				prepare_map
				logic_M0010_break_skull
				show_status_message #STATUSMSG_015
				spawn_in_pocket #ACTI_DRY_BRAIN
@				rts
@
aoaM0010_2		rts
.endp

; Performs actions on M0040
.proc act_on_action_M0040
				lda current_action
				cmp #A_M0003_059_ID	; Heavy crate
				jne aoaM0040_1
				lda current_action_menu_item
				cmp #1				; Heavy crate -> Move
				bne @+1
				lda logic_flags_007
				and #LF_CRATE_OILED
				cmp #LF_CRATE_OILED
				beq @+
				show_status_message #STATUSMSG_143
				rts
@				logic_M0040_move_crate
				lda logic_flags_007
				eor #LF_CRATE_MOVED
				sta logic_flags_007
				rts
@				cmp #0				; Heavy crate -> Explore
				bne @+ 
				show_status_message #STATUSMSG_144
				rts
@				cmp #2				; Heavy crate -> Lubricate
				bne @+1
				show_pocket
				is_chosen_in_pocket #ACTI_WD_40
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				show_status_message #STATUSMSG_145
				remove_from_pocket #ACTI_WD_40
				lda logic_flags_007
				eor #LF_CRATE_OILED
				sta logic_flags_007
@				
				rts				
aoaM0040_1
				rts
.endp

; Performs actions on M0041
.proc act_on_action_M0041
				lda current_action
				cmp #A_M0003_004_ID	; Lever
				bne aoaM0041_1
				lda current_action_menu_item
				cmp #1				; Lever -> Activate
				bne @+
				logic_M0041_lower_obelisk_lever			
				lda logic_flags_003
				eor #LF_OBELISK_MOVED
				sta logic_flags_003
				rts
@				cmp #0				; Lever -> Explore
				bne @+ 
				show_status_message #STATUSMSG_070
@				rts				
aoaM0041_1
				lda current_action
				cmp #A_M0003_022_ID	; Fallen rocks
				bne aoaM0041_2
				lda current_action_menu_item
				cmp #0				; Fallen rocks -> Explore
				bne @+
				show_status_message #STATUSMSG_053
				rts
@				cmp #1				; Fallen rocks -> Use
				show_pocket
				is_chosen_in_pocket #ACTI_PICKAXE
				cpx #1
				beq @+
				is_chosen_in_pocket #ACTI_2_DYNAMS
				cpx #1
				beq aoaM0041_8
				is_chosen_in_pocket #ACTI_PNEUMO
				cpx #1
				beq aoaM0041_7
				finish_with_message_006
				rts
@				prepare_map
				logic_M0041_remove_fallen_rocks #1
				lda logic_flags_013
				eor #LF_PICKAXE_WAREHOUSE
				sta logic_flags_013
@				
aoaM0041_2		rts
aoaM0041_7		
 				prepare_map
				show_status_message #STATUSMSG_246
				rts
aoaM0041_8
 				prepare_map
				show_status_message #STATUSMSG_249
				rts
.endp

; Performs actions on M0050
.proc act_on_action_M0050
				lda current_action
				cmp #A_M0003_014_ID	; Vestry door
				bne aoaM0050_1
				lda current_action_menu_item
				cmp #0				; Vestry door -> Explore
				bne @+
				show_status_message #STATUSMSG_032
				rts
@				cmp #1				; Vestry door -> Open
				bne @+
				show_status_message_003
				rts
@				cmp #2				; Vestry door -> Use
				bne @+1
				show_pocket
				is_chosen_in_pocket #ACTI_RUSTY_KEY
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				logic_M0050_open_vestry_door
				lda logic_flags_001
				eor #LF_VESTRY_OPENED
				sta logic_flags_001
@
aoaM0050_1		
				rts
.endp

; Performs actions on M0056
.proc act_on_action_M0056
				lda current_action
				cmp #A_M0003_062_ID	; Catholic door
				bne aoaM0056_1
				lda current_action_menu_item
				cmp #0				; Catholic door -> Explore
				bne @+
				show_status_message #STATUSMSG_151
				rts
@				cmp #1				; Catholic door -> Use
				jne aoaM0056_1
				show_pocket
				is_chosen_in_pocket #ACTI_PRAYBOOK
				cpx #1
				beq @+
				is_chosen_in_pocket #ACTI_ROSARY
				cpx #1
				beq aoaM0056_2
				finish_with_message_006
				rts
@				prepare_map
				logic_M0056_open_catholic_door
				remove_from_pocket #ACTI_PRAYBOOK
				lda logic_flags_007
				eor #LF_PRAYER_SPEAKED
				sta logic_flags_007
aoaM0056_1		rts
aoaM0056_2		prepare_map
				show_status_message #STATUSMSG_247
				rts
.endp

; Performs actions on M0057
.proc act_on_action_M0057
				lda current_action
				cmp #A_M0003_060_ID	; Wall
				bne aoaM0057_1
				lda current_action_menu_item
				cmp #0				; Wall -> Explore
				bne @+
				show_status_message #STATUSMSG_146
				rts
@				cmp #1				; Wall -> Explode
				jne aoaM0057_1
				show_pocket
				is_chosen_in_pocket #ACTI_2_DYNAMS
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				logic_M0057_blow_the_wall
				remove_from_pocket #ACTI_2_DYNAMS
				spawn_in_pocket #ACTI_DYNAMITE
				lda logic_flags_007
				eor #LF_1ST_WALL_BLOWN
				sta logic_flags_007
				rts
aoaM0057_1		
				rts
.endp

; Performs actions on M0065
.proc act_on_action_M0065
				lda current_action
				cmp #A_M0003_060_ID	; Wall
				bne aoaM0057_1
				lda current_action_menu_item
				cmp #0				; Wall -> Explore
				bne @+
				show_status_message #STATUSMSG_146
				rts
@				cmp #1				; Wall -> Explode
				jne aoaM0057_1
				show_pocket
				is_chosen_in_pocket #ACTI_DYNAMITE
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				logic_M0065_blow_the_wall
				remove_from_pocket #ACTI_DYNAMITE
				lda logic_flags_007
				eor #LF_2ND_WALL_BLOWN
				sta logic_flags_007
				rts
aoaM0057_1		
				rts
.endp

; Performs actions on M0067
.proc act_on_action_M0067
				lda current_action
				cmp #A_M0003_061_ID	; Ianus
				bne aoaM0067_1
				lda current_action_menu_item
				cmp #0				; Ianus -> Explore
				bne @+
				show_status_message #STATUSMSG_150
				rts
@				cmp #1				; Ianus -> Rape
				bne @+
				show_status_message #STATUSMSG_149
				rts
@				cmp #2				; Ianus -> Talk
				bne aoaM0067_1
				show_adventure_message #ADVMSG_148
				prepare_map
aoaM0067_1		
				rts
.endp

; Performs actions on M0061
.proc act_on_action_M0061
				lda current_action
				cmp #A_M0003_017_ID	; "Pan Zwami"
				bne aoaM0061_1
				lda current_action_menu_item
				cmp #0				; "Pan Zwami" -> Explore
				bne @+
				show_status_message #STATUSMSG_040
				rts
@				cmp #1				; "Pan Zwami" -> Talk
				bne @+
				show_adventure_message #ADVMSG_041
				prepare_map
				rts
@				cmp #2				; "Pan Zwami" -> Give
				bne @+1
				show_pocket
				is_chosen_in_pocket #ACTI_WORM_DROPS
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				show_status_message #STATUSMSG_073
				lda logic_flags_003
				eor #LF_DROPS_GIVEN
				sta logic_flags_003
				remove_from_pocket #ACTI_WORM_DROPS
				rts
@
aoaM0061_1		
				cmp #A_M0003_048_ID	; "Pusty oltarz"
				jne aoaM0061_2
				lda current_action_menu_item
				cmp #0				; "Pusty oltarz" -> Explore
				bne @+
				show_status_message #STATUSMSG_119
				rts
@				cmp #1				; "Pusty oltarz" -> Profane
				bne @+
				show_status_message #STATUSMSG_120
				rts
@				cmp #2				; "Pusty oltarz" -> Put
				show_pocket
				is_chosen_in_pocket #ACTI_GRAIL
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				show_adventure_message #ADVMSG_121
				remove_from_pocket #ACTI_GRAIL
				lda logic_flags_005
				eor #LF_GRAIL_GIVEN
				sta logic_flags_005
				lda #$80
				sta hero_XPos
				sta HPOSP0
				lda #$a0
				sta hero_YPos
				clear_hero
				draw_hero
				turn_hero_dead				
				follow_down #1
				rts
aoaM0061_2		
.endp

; Performs actions on M0064
.proc act_on_action_M0064
				lda current_action
				cmp #A_M0003_018_ID	; Mutated chicken
				bne aoaM0064_1
				lda current_action_menu_item
				cmp #0				; Mutated chicked -> Explore
				bne @+
				show_status_message #STATUSMSG_042
				rts
@				cmp #1				; Mutated chicked -> Talk
				bne @+
				show_adventure_message #ADVMSG_043
				prepare_map
				rts
@				cmp #2				; Mutated chicked -> Operate
				bne @+1
				show_pocket
				is_chosen_in_pocket #ACTI_HAMMER
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				logic_M0064_kill_chicken
				show_status_message #STATUSMSG_044
				lda logic_flags_001
				eor #LF_CHICKEN_KILLED
				sta logic_flags_001
				rts
@
aoaM0064_1
				cmp #A_M0003_019_ID	; Flatten chicken
				bne aoaM0064_2
				lda current_action_menu_item
				cmp #0				; Flatten chicken -> Explore
				bne @+
				show_status_message #STATUSMSG_045
				rts
@				cmp #1				; Flatten chicken -> Chop
				bne @+1
				show_pocket
				is_chosen_in_pocket #ACTI_AXE
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				logic_M0064_chop_chicken_leg
				spawn_in_pocket #ACTI_CHICKENLEG
				show_status_message #STATUSMSG_046
				lda logic_flags_001
				eor #LF_CHICKEN_LEG_TAKEN
				sta logic_flags_001
@
				rts
aoaM0064_2
				cmp #A_M0003_004_ID	; Lever
				bne aoaM0064_2
				lda current_action_menu_item
				cmp #0				; Lever -> Explore
				bne @+
				show_status_message #STATUSMSG_047
				rts
@				cmp #1				; Lever -> Use
				bne @+
				show_status_message #STATUSMSG_048
@				rts
.endp

; Performs all actions connected to logic on MAP0000
.proc process_logic_M0000
				#if .byte hero_XPos=#$4c .and .byte hero_YPos=#$40
					lda logic_flags_001
					and #LF_DEMON_BRIBED
					cmp #LF_DEMON_BRIBED
					beq @+
					write_action_name #A_M0003_012
					mwa #A_M0003_012_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_TALK #ACT_GIVE
@					rts
				#end
				rts
.endp

; Performs all actions connected to logic on MAP0007
.proc process_logic_M0007
				#if .byte hero_XPos >= #$46 .and .byte hero_XPos <= #$4f .and .byte hero_YPos = #$98
					write_action_name #A_M0003_002
					mwa #A_M0003_002_ID current_action
@					propagate_action_menu #ACT_EXPLORE #ACT_SQUEEZE #ACT_EMPTY
					rts
				#end
				rts
.endp

; Performs all actions connected to logic on MAP0010
.proc process_logic_M0010
				#if .byte hero_XPos = #$3c .and .byte hero_YPos = #$98
					write_action_name #A_M0003_004
					mwa #A_M0003_004_ID current_action
					lda logic_flags_000
					and #LF_SEWER_LEVER_OPE_USED
					cmp #LF_SEWER_LEVER_OPE_USED
					beq @+
					propagate_action_menu #ACT_EXPLORE #ACT_MOVE #ACT_EMPTY
					rts
@					propagate_action_menu_EXEMEM										
				#end
				#if .byte hero_XPos = #$b8 .and .byte hero_YPos = #$98
					write_action_name #A_M0003_007
					mwa #A_M0003_007_ID current_action
					lda logic_flags_000
					and #LF_SKULL_CRACKED
					cmp #LF_SKULL_CRACKED
					beq @+
					propagate_action_menu_EXUSEM
					rts
@					propagate_action_menu_EXEMEM
				#end
				rts
.endp

; Performs all actions connected to logic on MAP0040
.proc process_logic_M0040
				#if .byte hero_XPos = #$48 .and .byte hero_YPos = #$a0
					lda logic_flags_007
					and #LF_CRATE_MOVED
					cmp #LF_CRATE_MOVED
					bne @+
					rts
@					write_action_name #A_M0003_059
					mwa #A_M0003_059_ID current_action
					lda logic_flags_007
					and #LF_CRATE_OILED
					cmp #LF_CRATE_OILED
					beq @+
					propagate_action_menu #ACT_EXPLORE #ACT_MOVE #ACT_LUBRICATE
					rts
@					propagate_action_menu #ACT_EXPLORE #ACT_MOVE #ACT_EMPTY
					rts
				#end
				rts
.endp

; Performs all actions connected to logic on MAP0041
.proc process_logic_M0041
				#if .byte hero_XPos = #$3c .and .byte hero_YPos = #$68
					write_action_name #A_M0003_004
					mwa #A_M0003_004_ID current_action
					lda logic_flags_003
					and #LF_OBELISK_MOVED
					cmp #LF_OBELISK_MOVED
					beq @+
					propagate_action_menu #ACT_EXPLORE #ACT_ACTIVATE #ACT_EMPTY
					rts
@					propagate_action_menu #ACT_EXPLORE #ACT_EMPTY #ACT_EMPTY
					rts
				#end

				#if .byte hero_YPos = #$90 .and .byte hero_XPos = #$38 .or .byte hero_XPos = #$48
					lda logic_flags_013
					and #LF_PICKAXE_WAREHOUSE
					cmp #LF_PICKAXE_WAREHOUSE
					beq @+
					mwa #A_M0003_022_ID current_action
					write_action_name #A_M0003_022
					propagate_action_menu_EXUSEM
					rts
				#end
@				rts
.endp

; Performs all actions connected to logic on MAP0050
.proc process_logic_M0050
				#if .byte hero_XPos = #$c4 .and .byte hero_YPos = #$88
					lda logic_flags_001
					and #LF_VESTRY_OPENED
					cmp #LF_VESTRY_OPENED
					beq @+
					write_action_name #A_M0003_014
					mwa #A_M0003_014_ID current_action
					propagate_action_menu_EXOPUS
@					rts
				#end
				rts
.endp

; Performs all actions connected to logic on MAP0057
.proc process_logic_M0057
				#if .byte hero_XPos = #$50 .and .byte hero_YPos = #$58
					lda logic_flags_007
					and #LF_1ST_WALL_BLOWN
					cmp #LF_1ST_WALL_BLOWN
					beq @+
					write_action_name #A_M0003_060
					mwa #A_M0003_060_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_EXPLODE #ACT_EMPTY
@					rts
				#end
				rts
.endp

; Performs all actions connected to logic on MAP0065
.proc process_logic_M0065
				#if .byte hero_XPos = #$58 .and .byte hero_YPos = #$80
					lda logic_flags_007
					and #LF_2ND_WALL_BLOWN
					cmp #LF_2ND_WALL_BLOWN
					beq @+
					write_action_name #A_M0003_060
					mwa #A_M0003_060_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_EXPLODE #ACT_EMPTY
@					rts
				#end
				rts
.endp

; Performs all actions connected to logic on MAP0065
.proc process_logic_M0066
				#if .byte hero_XPos = #$4c
					lda logic_flags_007
					and #LF_HERO_MSG_SHOWN
					cmp #LF_HERO_MSG_SHOWN
					beq @+
					show_status_message #STATUSMSG_147
					lda logic_flags_007
					eor #LF_HERO_MSG_SHOWN
					sta logic_flags_007
@					rts
				#end
				rts
.endp

; Performs all actions connected to logic on MAP0067
.proc process_logic_M0067
				#if .byte hero_XPos = #$54 .and .byte hero_YPos = #$80
					write_action_name #A_M0003_061
					mwa #A_M0003_061_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_RAPE #ACT_TALK
@					rts
				#end
				rts
.endp

; Performs all actions connected to logic on MAP0061
.proc process_logic_M0061
				#if .byte hero_XPos >= #$85
					lda logic_flags_003
					and #LF_DROPS_GIVEN
					cmp #LF_DROPS_GIVEN
					beq @+1
					show_status_message #STATUSMSG_039
					ldx #18
@					hero_left
					dex
					bne @-
@					rts
				#end
				#if .byte hero_XPos = #$78 .and .byte hero_YPos = #$60
					write_action_name #A_M0003_017
					mwa #A_M0003_017_ID current_action
					lda logic_flags_003
					and #LF_DROPS_GIVEN
					cmp #LF_DROPS_GIVEN
					beq @+
					propagate_action_menu #ACT_EXPLORE #ACT_TALK #ACT_GIVE
					rts
@					propagate_action_menu_EXEMEM
					rts
				#end
				#if .byte hero_XPos >= #$67 .and .byte hero_XPos <= #$72 .and .byte hero_YPos = #$80
					write_action_name #A_M0003_048
					mwa #A_M0003_048_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_PROFANE #ACT_PLACE
					rts
				#end
				rts
.endp

; Performs all actions connected to logic on MAP0056
.proc process_logic_M0056
				#if .byte hero_XPos = #$6c .and .byte hero_YPos = #$90
					lda logic_flags_007
					and #LF_PRAYER_SPEAKED
					cmp #LF_PRAYER_SPEAKED
					beq @+
					write_action_name #A_M0003_062
					mwa #A_M0003_062_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_PRAY #ACT_EMPTY
					rts
				#end
@				rts
.endp

; Performs all actions connected to logic on MAP0063
.proc process_logic_M0063
				#if .byte hero_XPos = #$b4 .and .byte hero_YPos = #$98
					lda logic_flags_013
					and #LF_MONGREL_REMOVED
					cmp #LF_MONGREL_REMOVED
					beq @+
					mwa #A_M0003_031_ID current_action
					write_action_name #A_M0003_031
					propagate_action_menu #ACT_EXPLORE #ACT_TALK #ACT_EMPTY
					rts
				#end
@				#if .byte hero_XPos < #$3c .and .byte hero_YPos = #$58
					write_action_name #A_M0003_044
					mwa #A_M0003_044_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_SNIFF #ACT_PENETRATE
					rts
				#end
				rts
.endp

; Performs all actions connected to logic on MAP0064
.proc process_logic_M0064
				lda logic_flags_001
				and #LF_CHICKEN_KILLED
				cmp #LF_CHICKEN_KILLED
				jeq @+
				#if .byte hero_XPos = #$70 .and .byte hero_YPos = #$78
plM0064_1
					write_action_name #A_M0003_018
					mwa #A_M0003_018_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_TALK #ACT_OPERATE
					rts
				#end
				#if .byte hero_XPos = #$60 .and .byte hero_YPos = #$78
					jmp plM0064_1
				#end
				
@
				lda logic_flags_001
				and #LF_CHICKEN_LEG_TAKEN
				cmp #LF_CHICKEN_LEG_TAKEN
				jeq @+1
				#if .byte hero_XPos = #$70 .and .byte hero_YPos = #$78
plM0064_2
					lda logic_flags_001
					and #LF_CHICKEN_KILLED
					cmp #LF_CHICKEN_KILLED
					bne @+
					write_action_name #A_M0003_019
					mwa #A_M0003_019_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_CHOP #ACT_EMPTY
@					rts
				#end
				#if .byte hero_XPos = #$5c .and .byte hero_YPos = #$78
					jmp plM0064_2
				#end
@				
				#if .byte hero_XPos >= #$3c .and .byte hero_XPos <= #$44 .and .byte hero_YPos = #$90
					write_action_name #A_M0003_004
					mwa #A_M0003_004_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_MOVE #ACT_EMPTY
					rts
				#end

				rts
.endp

; Assures that all actions done to the
; particular map are visible when
; map is preloaded.
				org logic_dll_post
				
.proc post_load_logic
				disable_lightning

pll_next_map_0000
				; ============== MAP 0010 ==========
				is_on_30303031
				cpx #1
				jne pll_next_map_0001
				lda logic_flags_000
				and #LF_SEWER_LEVER_OPE_USED
				cmp #LF_SEWER_LEVER_OPE_USED		; Sewer lever moved?
				bne @+
				logic_M0010_move_lever			
@				lda logic_flags_000
				and #LF_SKULL_CRACKED
				cmp #LF_SKULL_CRACKED
				bne @+	
				logic_M0010_break_skull
				rts
@				; ==================================
pll_next_map_0001

				; ============== MAP 0009 ==========
				is_on_30303930
				cpx #1
				jne pll_next_map_0002
				lda logic_flags_000
				and #LF_SEWER_LEVER_OPE_USED
				cmp #LF_SEWER_LEVER_OPE_USED		; Sewer lever moved?
				bne @+
				logic_M0009_open_sewer
				rts			
@				
				; ==================================
pll_next_map_0002

				; ============== MAP 0000 ==========
				is_on_30303030
				cpx #1
				jne pll_next_map_0021
				lda logic_flags_001
				and #LF_DEMON_BRIBED
				cmp #LF_DEMON_BRIBED
				bne @+
				logic_M0000_demon_disappears
@				rts
				; ==================================
pll_next_map_0021
				; ============== MAP 0050 ==========
				is_on_30303035
				cpx #1
				jne pll_next_map_0023
				lda logic_flags_001
				and #LF_VESTRY_OPENED
				cmp #LF_VESTRY_OPENED
				bne @+
				logic_M0050_open_vestry_door
@				rts
				; ==================================
pll_next_map_0023
				; ============== MAP 0064 ==========
				is_on_30303436
				cpx #1
				jne pll_next_map_0024
				lda logic_flags_001
				and #LF_CHICKEN_KILLED
				cmp #LF_CHICKEN_KILLED
				bne @+
				logic_M0064_kill_chicken
@				lda logic_flags_001
				and #LF_CHICKEN_LEG_TAKEN
				cmp #LF_CHICKEN_LEG_TAKEN
				bne @+
				logic_M0064_chop_chicken_leg
@				rts
				; ==================================
pll_next_map_0024
				; ============== MAP 0041 ==========
				is_on_30303134
				cpx #1
				jne pll_next_map_0025
				lda logic_flags_003
				and #LF_OBELISK_MOVED
				cmp #LF_OBELISK_MOVED
				bne @+
				logic_M0041_lower_obelisk_lever
@				lda logic_flags_013
				and #LF_PICKAXE_WAREHOUSE
				cmp #LF_PICKAXE_WAREHOUSE
				bne @+
				logic_M0041_remove_fallen_rocks #0
@				rts
				; ==================================
pll_next_map_0025
				; ============== MAP 0040 ==========
				is_on_30303034
				cpx #1
				jne pll_next_map_0026
				lda logic_flags_007
				and #LF_CRATE_MOVED
				cmp #LF_CRATE_MOVED
				bne @+
				logic_M0040_move_crate
@				rts
				; ==================================
pll_next_map_0026
				; ============== MAP 0057 ==========
				is_on_30303735
				cpx #1
				jne pll_next_map_0027
				lda logic_flags_007
				and #LF_1ST_WALL_BLOWN
				cmp #LF_1ST_WALL_BLOWN
				bne @+
				logic_M0057_blow_the_wall
@				rts
				; ==================================
pll_next_map_0027
				; ============== MAP 0065 ==========
				is_on_30303536
				cpx #1
				jne pll_next_map_0028
				lda logic_flags_007
				and #LF_2ND_WALL_BLOWN
				cmp #LF_2ND_WALL_BLOWN
				bne @+
				logic_M0065_blow_the_wall
@				rts
				; ==================================
pll_next_map_0028
				; ============== MAP 0056 ==========
				is_on_30303635
				cpx #1
				jne pll_next_map_0029
				lda logic_flags_007
				and #LF_PRAYER_SPEAKED
				cmp #LF_PRAYER_SPEAKED
				bne @+
				logic_M0056_open_catholic_door
@				rts
				; ==================================
pll_next_map_0029
				; ============== MAP 0063 ==========
				is_on_30303336
				cpx #1
				jne pll_next_map_0030
				lda logic_flags_013
				and #LF_MONGREL_REMOVED
				cmp #LF_MONGREL_REMOVED
				bne @+
				logic_M0063_remove_antoni
@				rts
				; ==================================
pll_next_map_0030
				rts
.endp

; Performs actions on M0063
.proc act_on_action_M0063
				lda current_action
				cmp #A_M0003_031_ID	; "Mongrel"
				bne aoaM0063_1
				lda current_action_menu_item
				cmp #0				; "Mongrel" -> Explore
				bne @+
				show_status_message #STATUSMSG_140
				rts
@				cmp #1				; "Mongrel" -> Talk
				bne @+
				lda logic_flags_013
				and #LF_GOLD_BARS_GIVEN
				cmp #LF_GOLD_BARS_GIVEN
				beq aoaM0063_7
				show_adventure_message #ADVMSG_141
				prepare_map
				jmp aoaM0063_1
aoaM0063_7		show_adventure_message #ADVMSG_192
				prepare_map
				logic_M0063_remove_antoni
				lda logic_flags_013
				eor #LF_MONGREL_REMOVED
				sta logic_flags_013
@
aoaM0063_1		
				cmp #A_M0003_044_ID	; Norah
				bne aoaM0063_2
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

aoaM0063_2		rts
.endp


; M0000 - removes demon from the map
.proc logic_M0000_demon_disappears
				mva #4 tmp_loop_iterator 
				ldy #4
@				inc tmp_loop_iterator
				tya
				pha
				print_string #DEMON_CLR #4 tmp_loop_iterator #0
				pla
				tay
				dey
				bne @-
				rts
.endp

; Moves the crate in the warehouse
.proc logic_M0040_move_crate
				lda #128
				ldx #4
@				lda screen_mem+16*40+7,x
				inx
				sta screen_mem+16*40+7,x

				dex
				lda screen_mem+17*40+7,x
				inx
				sta screen_mem+17*40+7,x

				dex
				lda screen_mem+14*40+7,x
				inx
				sta screen_mem+14*40+7,x

				dex
				lda screen_mem+15*40+7,x
				inx
				sta screen_mem+15*40+7,x
				
				dex
				dex
				cpx #$ff
				bne @-
				rts
.endp

; M0041 - lowers the obelisk lever
.proc logic_M0041_lower_obelisk_lever
				mva #127 screen_mem+10*40+5
				rts
.endp

; M0090 - opens the sewer
.proc logic_M0009_open_sewer
				mwa #0000 screen_mem+19*40+20
				rts
.endp

; M0010 - moves the lever
.proc logic_M0010_move_lever
				mva #119 screen_mem+16*40+2
				rts
.endp

; M0010 - break skull
.proc logic_M0010_break_skull
				mva #86 screen_mem+15*40+36
				rts
.endp

; Opens the vestry door
.proc logic_M0050_open_vestry_door
				lda #0
				sta	screen_mem+13*40+39
				sta screen_mem+14*40+39
				sta screen_mem+15*40+39
				rts
.endp

; Blows the wall
.proc logic_M0057_blow_the_wall
				mwa #screen_mem+5*40+10 tmp_loop_iterator
				blow_wall_internal
				rts
.endp

; Blows the 2nd wall
.proc logic_M0065_blow_the_wall
				mwa #screen_mem+10*40+12 tmp_loop_iterator
				blow_wall_internal
				rts
.endp

; Blows the wall at the location given in "tmp_loop_iterator"
.proc blow_wall_internal
				ldx #5
				
@				lda #0
				ldy #0
				sta	(tmp_loop_iterator),y
				iny
				sta	(tmp_loop_iterator),y
				iny
				sta	(tmp_loop_iterator),y				
				adw tmp_loop_iterator #40
				dex
				cpx #0
				bne @-
				rts
.endp

; Opens the catholic door
.proc logic_M0056_open_catholic_door
				ldx #0
				stx screen_mem+12*40+14
				stx screen_mem+13*40+14
				stx screen_mem+14*40+14
				stx screen_mem+15*40+14
				stx screen_mem+16*40+14
				rts
.endp

; Removes Dog Antoni from the map
.proc logic_M0063_remove_antoni
				lda #0
				sta screen_mem+15*40+35
				sta screen_mem+15*40+36
				sta screen_mem+16*40+35
				sta screen_mem+16*40+36
				rts
.endp

; Kills the chicken
.proc logic_M0064_kill_chicken
				mva #0 screen_mem+11*40+15
				mva #68 screen_mem+12*40+14
				mva #69 screen_mem+12*40+15

				mva #38 screen_mem+13*40+13
				mva #100 screen_mem+13*40+14
				mva #7 screen_mem+13*40+15
				rts
.endp

; Chops the chicken leg
.proc logic_M0064_chop_chicken_leg
				mva #0 screen_mem+12*40+15
				rts
.endp

; Handles all issues connected to the logic
; of the game (acting, using items, etc.).
.proc is_on_30303436
				is_on_map_3030 #$3436
				rts
.endp
.proc is_on_30303030
				is_on_map_3030 #$3030
				rts
.endp
.proc is_on_30303136
				is_on_map_3030 #$3136
				rts
.endp
.proc is_on_30303035
				is_on_map_3030 #$3035
				rts
.endp
.proc is_on_30303730
				is_on_map_3030 #$3730
				rts
.endp
.proc is_on_30303031
				is_on_map_3030 #$3031
				rts
.endp
.proc is_on_30303033
				is_on_map_3030 #$3033
				rts
.endp
.proc is_on_30303930
				is_on_map_3030 #$3930
				rts
.endp
.proc is_on_30303032
				is_on_map_3030 #$3032
				rts
.endp
.proc is_on_30303134
				is_on_map_3030 #$3134
				rts
.endp
.proc is_on_30303336
				is_on_map_3030 #$3336
				rts
.endp
.proc is_on_30303034
				is_on_map_3030 #$3034
				rts
.endp
.proc is_on_30303735
				is_on_map_3030 #$3735
				rts
.endp
.proc is_on_30303536
				is_on_map_3030 #$3536
				rts
.endp
.proc is_on_30303636
				is_on_map_3030 #$3636
				rts
.endp
.proc is_on_30303736
				is_on_map_3030 #$3736
				rts
.endp
.proc is_on_30303635
				is_on_map_3030 #$3635
				rts
.endp
.proc is_on_30303834
				is_on_map_3030 #$3834
				rts
.endp

.proc act_on_action_M0048
				lda current_action
				cmp #A_M0003_086_ID	; Holy water font
				jne aoaM0048_1
				lda current_action_menu_item
				cmp #0				; Holy water font -> Explore
				bne aoaM0048_1_1
				
				lda logic_flags_012
				and #LF_HOLYWATER_PEE
				cmp #LF_HOLYWATER_PEE
				beq aoaM0048_1_5
				show_status_message #STATUSMSG_229
				rts
aoaM0048_1_5	lda logic_flags_012
				and #LF_HOLYWATER_PRAY
				cmp #LF_HOLYWATER_PRAY
				beq aoaM0048_1_9
				show_status_message #STATUSMSG_232
				rts			
aoaM0048_1_9
				show_status_message #STATUSMSG_235
				rts	
				
aoaM0048_1_1	cmp #1				; Holy water font -> Gather
				jne aoaM0048_1_2
		
				lda logic_flags_012
				and #LF_HOLYWATER_PEE
				cmp #LF_HOLYWATER_PEE
				beq aoaM0048_1_6
				show_status_message #STATUSMSG_230
				rts
aoaM0048_1_6	lda logic_flags_012
				and #LF_HOLYWATER_PRAY
				cmp #LF_HOLYWATER_PRAY
				beq aoaM0048_1_10
				show_status_message #STATUSMSG_233
				rts		
aoaM0048_1_10
				show_pocket
				is_chosen_in_pocket #ACTI_FLASK
				cpx #1
				beq @+
				is_chosen_in_pocket #ACTI_GRAIL
				cpx #1
				beq aoaM0048_1_cv
				finish_with_message_006
				rts
@				prepare_map
				remove_from_pocket #ACTI_FLASK
				spawn_in_pocket #ACTI_HOLYWATER
				show_status_message #STATUSMSG_251
				lda logic_flags_013
				eor #LF_FLASK_USED
				sta logic_flags_013
				rts
aoaM0048_1_cv	prepare_map
				show_status_message #STATUSMSG_242
				rts
				
aoaM0048_1_2	cmp #2				; Holy water font -> Pee / Pray
				bne aoaM0048_1_3
				
				lda logic_flags_012
				and #LF_HOLYWATER_PEE
				cmp #LF_HOLYWATER_PEE
				beq aoaM0048_1_7
				
				show_status_message #STATUSMSG_231
				lda logic_flags_012
				eor #LF_HOLYWATER_PEE
				sta logic_flags_012
				rts
aoaM0048_1_7
				show_status_message #STATUSMSG_234
				lda logic_flags_012
				eor #LF_HOLYWATER_PRAY
				sta logic_flags_012
				rts
				
aoaM0048_1_3
aoaM0048_1
@				rts				
.endp

; Removes the fallen rocks that block the way
.proc logic_M0041_remove_fallen_rocks(.byte slow) .var
				mva #50 to_be_delayed
				#if .byte slow = #0
					mva #1 to_be_delayed
				#end
				delay
				ldx #0
				stx screen_mem+17*40+2
				delay
				stx screen_mem+17*40+3
				delay
				stx screen_mem+15*40+4
				delay
				stx screen_mem+16*40+4
				delay
				stx screen_mem+16*40+5
				delay
				stx screen_mem+17*40+6
				rts
.endp


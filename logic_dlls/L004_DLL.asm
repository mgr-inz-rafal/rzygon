;	@com.wudsn.ide.asm.mainsourcefile=../main.asm
				org logic_dll
				
.proc process_logic
				mwa #0 current_action
					
				; "Cmentarz" = MAP0098.MAP
				is_on_30303839
				cpx #1
				bne pl08
				mwa #act_on_action_M0098-1 act_on_action_vector
				process_logic_M0098
				rts
pl08
				; "Mogila" = MAP0068.MAP
				is_on_30303836
				cpx #1
				bne pl15
				mwa #act_on_action_M0068-1 act_on_action_vector
				process_logic_M0068
@				rts
pl15
				; "Grobowiec" = MAP0095.MAP
				is_on_30303539
				cpx #1
				bne pl16
				mwa #act_on_action_M0095-1 act_on_action_vector
				process_logic_M0095
@				rts
pl16

				; "Nora na cmentarzu" = MAP0090.MAP
				is_on_30303039
				cpx #1
				bne pl17
				mwa #act_on_action_M0090-1 act_on_action_vector
				process_logic_M0090
@				rts
pl17
				; "Koniec zamku" = MAP0104.MAP
				is_on_31303430
				cpx #1
				bne pl18
				mwa #act_on_action_M0104-1 act_on_action_vector
				process_logic_M0104
@				rts
pl18
				; "Kostkowe schody" = MAP0128.MAP
				is_on_31303832
				cpx #1
				bne pl19
				mwa #act_on_action_M0128-1 act_on_action_vector
				process_logic_M0128
@				rts
pl19
				; "Grota Roweckiego" = M0184.MAP
				is_on_30313438
				cpx #1
				bne pl10
				mwa #act_on_action_M0184-1 act_on_action_vector
				process_logic_M0184
				rts
pl10
				; "...Antoni!" = MAP00107.MAP
				is_on_31303730
				cpx #1
				bne pl11
				mwa #act_on_action_M0107-1 act_on_action_vector
				process_logic_M0107
				rts
pl11
				rts
.endp

; Performs all actions connected to logic on MAP0068
.proc process_logic_M0068_analyze_grave
				write_action_name #A_M0003_021
				mwa #A_M0003_021_ID current_action
				propagate_action_menu_EXEMEM
				rts
.endp
.proc process_logic_M0068
				#if .byte hero_XPos = #$80 .and .byte hero_YPos = #$78
					process_logic_M0068_analyze_grave
				#end
				#if .byte hero_XPos = #$6c .and .byte hero_YPos = #$80
					process_logic_M0068_analyze_grave
				#end
				rts
.endp

; Performs all actions connected to logic on MAP0090
.proc process_logic_M0090
				#if .byte hero_XPos >= #$59 .and .byte hero_XPos <= #$60 .and .byte hero_YPos = #$a0
					write_action_name #A_M0003_044
					mwa #A_M0003_044_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_SNIFF #ACT_PENETRATE
					rts
				#end
				rts
.endp

; Performs all actions connected to logic on MAP0095
.proc process_logic_M0095
				#if .byte hero_XPos >= #$83 .and .byte hero_XPos <= #$94 .and .byte hero_YPos = #$70
					write_action_name #A_M0003_042
					mwa #A_M0003_042_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_PENETRATE #ACT_USE
					rts
				#end
				rts
.endp

; Performs all actions connected to logic on MAP0098
.proc process_logic_M0098_obelisk_internal
					write_action_name #A_M0003_026
					mwa #A_M0003_026_ID current_action
					lda logic_flags_003
					and #LF_OBELISK_MOVED
					cmp #LF_OBELISK_MOVED
					beq @+
					propagate_action_menu #ACT_EXPLORE #ACT_MOVE #ACT_ACTIVATE
					rts
@					propagate_action_menu_EXEMEM
					rts					
.endp
.proc process_logic_M0098
				#if .byte hero_XPos = #$b8 .and .byte hero_YPos = #$98
					process_logic_M0098_obelisk_internal
				#end
				#if .byte hero_XPos = #$c8 .and .byte hero_YPos = #$98
					process_logic_M0098_obelisk_internal
				#end
				rts
.endp

; Performs all actions connected to logic on MAP0128
.proc process_logic_M0128
				#if .byte hero_XPos = #$4c .and .byte hero_YPos = #$60
					write_action_name #A_M0003_068
					mwa #A_M0003_068_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_SMASH #ACT_PROFANE
					rts
				#end
				rts
.endp

; Performs all actions connected to logic on MAP0107
.proc process_logic_M0107
				#if .byte hero_XPos = #$88 .and .byte hero_YPos = #$68
					write_action_name #A_M0003_021
					mwa #A_M0003_021_ID current_action
					propagate_action_menu_EXEMEM
				#end
				#if .byte hero_XPos = #$b4 .and .byte hero_YPos = #$50
					write_action_name #A_M0003_029
					mwa #A_M0003_029_ID current_action
					lda logic_flags_013
					and #LF_WICK_INSERTED
					cmp #LF_WICK_INSERTED
					beq @+
					propagate_action_menu #ACT_EXPLORE #ACT_USE #ACT_START
					rts
@					propagate_action_menu #ACT_EXPLORE #ACT_EMPTY #ACT_START
					rts
				#end
				#if .byte hero_XPos = #$a4 .and .byte hero_YPos = #$60
					lda logic_flags_012
					and #LF_DRAKUL_SPILLED
					cmp #LF_DRAKUL_SPILLED
					beq @+
					write_action_name #A_M0003_085
					mwa #A_M0003_085_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_TALK #ACT_SPILL
@					
				#end
				rts
.endp

; Performs actions on M0107
.proc act_on_action_M0107
				lda current_action
				cmp #A_M0003_021_ID	; Grave
				jne aoaM0107_x1
				lda current_action_menu_item
				cmp #0				; Grave -> Explore
				jne aoaM0107_x2
				show_status_message #STATUSMSG_074
				rts
aoaM0107_x1		
				cmp #A_M0003_029_ID	; Propulsion candle 
				jne aoaM0107_x2
				lda current_action_menu_item
				cmp #0				; Propulsion candle -> Explore
				bne aoaM0107_2
				show_status_message #STATUSMSG_236
				rts
aoaM0107_2				
				cmp #1				; Propulsion candle -> Use
				bne aoaM0107_x23
				show_pocket
				is_chosen_in_pocket #ACTI_CANDLEWICK
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				lda logic_flags_013
				eor #LF_WICK_INSERTED
				sta logic_flags_013
				remove_from_pocket #ACTI_CANDLEWICK
				show_status_message #STATUSMSG_238
				rts
aoaM0107_x23				
				cmp #2				; Propulsion candle -> Start
				bne aoaM0107_x2
					
				lda logic_flags_013
				and #LF_WICK_INSERTED
				cmp #LF_WICK_INSERTED
				beq @+				
				show_status_message #STATUSMSG_237
				rts
@				
				is_item_in_pocket #ACTI_ESSENCE
				cmp #1
				beq aoaM0107_x231
				show_status_message #STATUSMSG_239
				rts
aoaM0107_x231
				; Fly away!
				; Call finale loader
				pla
				pla
				disable_antic
				jmp finale_loader
				rts
aoaM0107_x2		
				cmp #A_M0003_085_ID	; Drakul
				jne aoaM0107_x3
				lda current_action_menu_item
				cmp #0				; Drakul -> Explore
				bne aoaM0107_3
				show_status_message #STATUSMSG_226
				rts
aoaM0107_3	
				cmp #1				; Drakul -> Talk
				bne aoaM0107_4
				show_adventure_message #ADVMSG_227
				prepare_map
				rts
aoaM0107_4
				cmp #2				; Drakul -> Spill
				bne aoaM0107_x3

				show_pocket
				is_chosen_in_pocket #ACTI_HOLYWATER
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				lda logic_flags_012
				eor #LF_DRAKUL_SPILLED
				sta logic_flags_012
				logic_M0107_remove_drakul
				show_status_message #STATUSMSG_228
				remove_from_pocket #ACTI_HOLYWATER
				spawn_in_pocket #ACTI_FLASK
				
aoaM0107_x3		rts
.endp

.proc process_logic_M0184
				#if .byte hero_XPos > #$72 .and .byte hero_YPos = #$90
					write_action_name #A_M0003_039
					mwa #A_M0003_039_ID current_action
					propagate_action_menu #ACT_READ #ACT_EMPTY #ACT_EMPTY
				#end
				#if .byte hero_XPos = #$90 .or .byte hero_XPos = #$a0 .and .byte hero_YPos = #$68
					write_action_name #A_M0003_084
					mwa #A_M0003_084_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_TOSS #ACT_CRUSH
					rts
				#end
				rts
.endp

.proc act_on_action_M0184
				lda current_action
				cmp #A_M0003_039_ID	; Note
				jne aoaM0184_1
				lda current_action_menu_item
				cmp #0				; Note -> Read
				bne @+
				show_adventure_message #ADVMSG_214
				prepare_map
				rts
@				
aoaM0184_1		cmp #A_M0003_084_ID
				jne aoaM0184_2
				lda current_action_menu_item
				cmp #0				; Mortar -> Explore
				bne @+
				show_status_message #STATUSMSG_215
				rts
@				cmp #1				; Mortar -> Toss
				jne aoaM0184_3
				show_pocket
				
				; Check for VISCERA 1
				is_chosen_in_pocket #ACTI_VISCERA1
				cpx #1
				bne @+
				; VISCERA 1 being tossed
				prepare_map
				remove_from_pocket #ACTI_VISCERA1
				lda logic_flags_011
				eor #LF_VISCERA1
				sta logic_flags_011
				show_status_message #STATUSMSG_216
				rts
				
@				; Check for VISCERA 2
				is_chosen_in_pocket #ACTI_VISCERA2
				cpx #1
				bne @+
				; VISCERA 2 being tossed
				prepare_map
				remove_from_pocket #ACTI_VISCERA2
				lda logic_flags_011
				eor #LF_VISCERA2
				sta logic_flags_011
				show_status_message #STATUSMSG_216
				rts

@				; Check for VISCERA 3
				is_chosen_in_pocket #ACTI_VISCERA3
				cpx #1
				bne @+
				; VISCERA 3 being tossed
				prepare_map
				remove_from_pocket #ACTI_VISCERA3
				lda logic_flags_011
				eor #LF_VISCERA3
				sta logic_flags_011
				show_status_message #STATUSMSG_216
				rts

@				; Check for VISCERA 4
				is_chosen_in_pocket #ACTI_VISCERA4
				cpx #1
				bne @+
				; VISCERA 4 being tossed
				prepare_map
				remove_from_pocket #ACTI_VISCERA4
				lda logic_flags_011
				eor #LF_VISCERA4
				sta logic_flags_011
				show_status_message #STATUSMSG_216
				rts

@				; Check for VISCERA 5
				is_chosen_in_pocket #ACTI_VISCERA5
				cpx #1
				bne @+
				; VISCERA 5 being tossed
				prepare_map
				remove_from_pocket #ACTI_VISCERA5
				lda logic_flags_011
				eor #LF_VISCERA5
				sta logic_flags_011
				show_status_message #STATUSMSG_216
				rts

@				; Check for VISCERA 6
				is_chosen_in_pocket #ACTI_VISCERA6
				cpx #1
				bne @+
				; VISCERA 6 being tossed
				prepare_map
				remove_from_pocket #ACTI_VISCERA6
				lda logic_flags_012
				eor #LF_VISCERA6
				sta logic_flags_012
				show_status_message #STATUSMSG_216
				rts

@				; Check for VISCERA 7
				is_chosen_in_pocket #ACTI_VISCERA7
				cpx #1
				bne @+
				; VISCERA 7 being tossed
				prepare_map
				remove_from_pocket #ACTI_VISCERA7
				lda logic_flags_012
				eor #LF_VISCERA7
				sta logic_flags_012
				show_status_message #STATUSMSG_216
				rts

@				; Check for DNA
				is_chosen_in_pocket #ACTI_DNA
				cpx #1
				bne @+
				; VISCERA_DNA being tossed
				is_all_VISCERA_tossed
				cpx #1
				beq aoaM0184_5
				; Not all VISCERA tossed
				prepare_map
				show_status_message #STATUSMSG_217
				rts
aoaM0184_5		
				; All VISCERA tossed
				remove_from_pocket #ACTI_DNA
				lda logic_flags_012
				eor #LF_VISCERA_DNA
				sta logic_flags_012
				prepare_map
				show_status_message #STATUSMSG_218
				rts
				
@				; Check for sauce
				is_chosen_in_pocket #ACTI_WORCESTER
				cpx #1
				bne @+
				; VISCERA_WORCESTER being tossed
				is_all_VISCERA_tossed
				cpx #1
				beq aoaM0184_6
				; Not all VISCERA tossed
				finish_with_message_006
				rts
				
aoaM0184_6
				; All VISCERA tossed
				lda logic_flags_012
				and #LF_VISCERA_DNA
				cmp #LF_VISCERA_DNA
				beq aoaM0184_7
				finish_with_message_006
				rts				
aoaM0184_7
				remove_from_pocket #ACTI_WORCESTER
				prepare_map
				show_status_message #STATUSMSG_219
				lda logic_flags_012
				eor #LF_VISCERA_WORCESTER
				sta logic_flags_012
				rts
				
@				finish_with_message_006
				rts
aoaM0184_3	
				cmp #2				; Mortar -> Crush
				jne aoaM0184_2
				
				show_pocket
				is_chosen_in_pocket #ACTI_PESTLE
				cpx #1
				jne aoaM0184_Q
				
				is_all_VISCERA_tossed
				cpx #1
				beq aoaM0184_Q1
				prepare_map
				show_status_message #STATUSMSG_220
				rts
				
aoaM0184_Q1
				; All VISCERA are tossed into mortar
				lda logic_flags_012
				and #LF_VISCERA_DNA
				cmp #LF_VISCERA_DNA
				beq aoaM0184_Q2
				; ... but D.N.A still missing
				prepare_map
				show_status_message #STATUSMSG_221
				rts	
aoaM0184_Q2			
				; D.N.A also tossed
				lda logic_flags_012
				and #LF_VISCERA_WORCESTER
				cmp #LF_VISCERA_WORCESTER
				beq aoaM0184_Q3
				; ... but Worcestershire still missing
				prepare_map
				show_status_message #STATUSMSG_222
				rts
				
aoaM0184_Q3
				prepare_map
				show_adventure_message #ADVMSG_223
				prepare_map
				spawn_in_pocket #ACTI_ESSENCE
				rts
aoaM0184_Q
				finish_with_message_006
aoaM0184_2
				rts
.endp

; X=1 if all VISCERA is tossed into mortar
; X=0 otherwise
.proc is_all_VISCERA_tossed
				ldx #0
				lda logic_flags_011
				and #LF_VISCERA1
				cmp #LF_VISCERA1
				beq @+
				rts
@
				lda logic_flags_011
				and #LF_VISCERA2
				cmp #LF_VISCERA2
				beq @+
				rts
@
				lda logic_flags_011
				and #LF_VISCERA3
				cmp #LF_VISCERA3
				beq @+
				rts
@
				lda logic_flags_011
				and #LF_VISCERA4
				cmp #LF_VISCERA4
				beq @+
				rts
@
				lda logic_flags_011
				and #LF_VISCERA5
				cmp #LF_VISCERA5
				beq @+
				rts
@
				lda logic_flags_012
				and #LF_VISCERA6
				cmp #LF_VISCERA6
				beq @+
				rts
@
				lda logic_flags_012
				and #LF_VISCERA7
				cmp #LF_VISCERA7
				beq @+
				rts
@
				inx
				rts
.endp

; Performs actions on M0068
.proc act_on_action_M0068
				lda current_action
				cmp #A_M0003_021_ID	; Grave
				bne aoaM0022_1
				lda current_action_menu_item
				cmp #0				; Grave -> Explore
				bne @+
				show_status_message #STATUSMSG_052
@				rts
aoaM0022_1		
				rts
.endp

; Performs actions on M0104
.proc act_on_action_M0104
				lda current_action
				cmp #A_M0003_067_ID	; Fat Paladin
				bne aoaM0104_1
				lda current_action_menu_item
				cmp #0				; Fat Paladin -> Explore
				bne @+
				show_status_message #STATUSMSG_165
				rts
@				cmp #1				; Fat Paladin -> Give
				bne @+
				show_pocket
				finish_with_message_006
				rts
@				cmp #2				; Fat Paladin -> Puff
				bne @+
				lda logic_flags_004
				and #LF_VALVE_LICKED
				cmp #LF_VALVE_LICKED
				beq aoaM0104_2
				show_status_message #STATUSMSG_167
				rts
aoaM0104_2
				show_status_message #STATUSMSG_166
				lda logic_flags_008
				eor #LF_RODERIC_INTOXICATED
				sta logic_flags_008
				logic_M0104_remove_roderic #1
				rts
aoaM0104_1
@				rts
.endp

; Performs actions on M0090
.proc act_on_action_M0090
				lda current_action
				cmp #A_M0003_044_ID	; Norah
				bne aoaM0090_1
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
				mva #$76 hero_XPos
				sta HPOSP0
				mva #$98 hero_YPos
				clear_hero
				draw_hero				
				follow_up #1
@				rts
aoaM0090_1
				rts							
.endp

; Performs actions on M0098
.proc act_on_action_M0098
				lda current_action
				cmp #A_M0003_026_ID	; Obelisk
				jne aoaM0098_x1
				lda current_action_menu_item
				cmp #0				; Obelisk -> Explore
				bne aoaM0098_1
				show_status_message #STATUSMSG_068
				rts
aoaM0098_1		cmp #1				; Obelisk -> Move
				bne aoaM0098_2
				show_status_message #STATUSMSG_069
				rts
aoaM0098_2		cmp #2				; Obelisk -> Activate
				bne aoaM0098_x1
				show_status_message #STATUSMSG_069
aoaM0098_x1		rts
.endp

; Performs actions on M0095
.proc act_on_action_M0095
				lda current_action
				cmp #A_M0003_042_ID	; Dark crypt
				jne aoaM0095_2
				lda current_action_menu_item
				cmp #0				; Dark crypt -> Explore
				bne aoaM0095_1
				show_status_message #STATUSMSG_106
				rts
aoaM0095_1		cmp #1				; Dark crypt -> Penetrate
				bne aoaM0095_2
				lda logic_flags_006
				and #LF_CRYPT_OPENED
				cmp #LF_CRYPT_OPENED
				beq @+
				show_status_message #STATUSMSG_132
				rts
@				mva #$44 hero_XPos
				sta HPOSP0
				mva #$88 hero_YPos
				clear_hero
				draw_hero				
				follow_down #1
				rts
aoaM0095_2		cmp #2				; Dark crypt -> Use
				bne aoaM0095_3
				show_pocket
				is_chosen_in_pocket #ACTI_ROTTENKEY
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				lda logic_flags_006
				eor #LF_CRYPT_OPENED
				sta logic_flags_006
				show_status_message #STATUSMSG_133
				remove_from_pocket #ACTI_ROTTENKEY
aoaM0095_3		rts
.endp

.proc act_on_action_M0128
				lda current_action
				cmp #A_M0003_068_ID	; Brass grave
				jne aoaM0128_x1
				lda current_action_menu_item
				cmp #0				; Brass grave -> Explore
				bne aoaM0128_1
				show_status_message #STATUSMSG_168
				rts
aoaM0128_1		cmp #1				; Brass grave -> Smash
				bne aoaM0128_2
				show_pocket
				is_chosen_in_pocket #ACTI_EGG
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				lda logic_flags_008
				eor #LF_EGG_SMASHED
				sta logic_flags_008
				show_status_message #STATUSMSG_170
				remove_from_pocket #ACTI_EGG
				spawn_in_pocket #ACTI_CHICK
				rts
aoaM0128_2		cmp #2				; Brass grave -> Profane
				bne aoaM0128_x1
				show_status_message #STATUSMSG_169
aoaM0128_x1		rts
				rts
.endp

; Lowers the obelisk at the cementery
.proc logic_M0098_lower_obelisk
				mva #5 tmp_loop_iterator 
				ldy #9
@				inc tmp_loop_iterator
				tya
				pha
				print_string #ACT_CURSOR_CLR #35 tmp_loop_iterator #0
				pla
				tay
				dey
				bne @-
				mva #5 screen_mem+40*15+36		
				mva #6 screen_mem+40*15+37
				ldx #7
				stx	screen_mem+40*16+36
				stx screen_mem+40*17+36
				stx screen_mem+40*18+36
				inx
				stx screen_mem+40*16+37		
				stx screen_mem+40*17+37		
				stx screen_mem+40*18+37
				inx		
				stx screen_mem+40*19+36
				inx		
				stx screen_mem+40*19+37		
				rts
.endp

.proc logic_M0104_remove_roderic(.byte slow) .var
				mva #20 to_be_delayed
				#if .byte slow = #0
					mva #1 to_be_delayed
				#end
				
				mwa #screen_mem+40*14+14 screen_tmp
				lda #8
				sta slow
@				lda #4
				sta tmp_loop_iterator				
@				ldy #1
				lda (screen_tmp), y
				dey
				sta (screen_tmp), y
				iny
				iny
				lda (screen_tmp), y
				dey
				sta (screen_tmp), y
				iny
				iny
				lda (screen_tmp), y
				dey
				sta (screen_tmp), y
				adw screen_tmp #40
				dec tmp_loop_iterator
				bne @-
				delay
				sbw screen_tmp #161
				dec slow
				bne @-1
				rts
.endp

; Performs all actions connected to logic on MAP0104
.proc process_logic_M0104
				#if .byte hero_XPos = #$3f
					lda logic_flags_007
					and #LF_SWORD_MENTIONED
					cmp #LF_SWORD_MENTIONED		
					beq @+
					show_status_message #STATUSMSG_160
					lda logic_flags_007
					eor #LF_SWORD_MENTIONED
					sta logic_flags_007
@
				#end
				#if .byte hero_XPos = #$64 .and .byte hero_YPos = #$98
					lda logic_flags_008
					and #LF_RODERIC_INTOXICATED
					cmp #LF_RODERIC_INTOXICATED
					beq @+
					write_action_name #A_M0003_067
					mwa #A_M0003_067_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_GIVE #ACT_PUFF
@					rts
				#end
				rts
.endp

; Assures that all actions done to the
; particular map are visible when
; map is preloaded.
				org logic_dll_post
								
.proc post_load_logic
				disable_lightning
				
				; ============== MAP 0099 ==========
				is_on_30303939
				cpx #1
				jne pll_next_map_0001
				enable_lightning
@				rts

pll_next_map_0001
				; ============== MAP 0098 ==========
				is_on_30303839
				cpx #1
				jne pll_next_map_0002
				enable_lightning
				lda logic_flags_003
				and #LF_OBELISK_MOVED
				cmp #LF_OBELISK_MOVED
				bne @+
				logic_M0098_lower_obelisk
@				rts

pll_next_map_0002
				; ============== MAP 0097 ==========
				is_on_30303739
				cpx #1
				jne pll_next_map_0003
				enable_lightning
@				rts

pll_next_map_0003
				; ============== MAP 0095 ==========
				is_on_30303539
				cpx #1
				jne pll_next_map_0004
				enable_lightning
				rts

pll_next_map_0004
				; ============== MAP 0094 ==========
				is_on_30303439
				cpx #1
				jne pll_next_map_0005
				enable_lightning
				rts

pll_next_map_0005
				; ============== MAP 0093 ==========
				is_on_30303339
				cpx #1
				jne pll_next_map_0006
				enable_lightning
				rts

pll_next_map_0006
				; ============== MAP 0096 ==========
				is_on_30303639
				cpx #1
				jne pll_next_map_0007
				enable_lightning
				rts

pll_next_map_0007
				; ============== MAP 0092 ==========
				is_on_30303239
				cpx #1
				jne pll_next_map_0008
				enable_lightning
				rts

pll_next_map_0008
				; ============== MAP 0091 ==========
				is_on_30303139
				cpx #1
				jne pll_next_map_0009
				enable_lightning
				rts

pll_next_map_0009
				; ============== MAP 0090 ==========
				is_on_30303039
				cpx #1
				jne pll_next_map_0010
				enable_lightning
				rts

pll_next_map_0010
				; ============== MAP 0089 ==========
				is_on_30303938
				cpx #1
				jne pll_next_map_0011
				enable_lightning
				rts

pll_next_map_0011
				; ============== MAP 0068 ==========
				is_on_30303836
				cpx #1
				jne pll_next_map_0012
				enable_lightning
				rts

pll_next_map_0012
				; ============== MAP 0104 ==========
				is_on_31303430
				cpx #1
				jne pll_next_map_0013
				lda logic_flags_008
				and #LF_RODERIC_INTOXICATED
				cmp #LF_RODERIC_INTOXICATED
				bne @+
				logic_M0104_remove_roderic #0
@				rts

pll_next_map_0013
				; ============== MAP 0107 ==========
				is_on_31303730
				cpx #1
				jne pll_next_map_0014
				make_dog_trails_transparent
				logic_M0107_show_dog_trails
				lda logic_flags_012
				and #LF_DRAKUL_SPILLED
				cmp #LF_DRAKUL_SPILLED
				bne @+
				logic_M0107_remove_drakul
@				rts

pll_next_map_0014
				rts
.endp


.proc is_on_30303939
				is_on_map_3030 #$3939
				rts
.endp
.proc is_on_30303839
				is_on_map_3030 #$3839
				rts
.endp
.proc is_on_30303739
				is_on_map_3030 #$3739
				rts
.endp
.proc is_on_30303539
				is_on_map_3030 #$3539
				rts
.endp
.proc is_on_30303439
				is_on_map_3030 #$3439
				rts
.endp
.proc is_on_30303339
				is_on_map_3030 #$3339
				rts
.endp
.proc is_on_30303639
				is_on_map_3030 #$3639
				rts
.endp
.proc is_on_30303239
				is_on_map_3030 #$3239
				rts
.endp
.proc is_on_30303139
				is_on_map_3030 #$3139
				rts
.endp
.proc is_on_30303039
				is_on_map_3030 #$3039
				rts
.endp
.proc is_on_30303938
				is_on_map_3030 #$3938
				rts
.endp
.proc is_on_30303836
				is_on_map_3030 #$3836
				rts
.endp
.proc is_on_31303430
				is_on_map_3130 #$3430
				rts
.endp
.proc is_on_31303832
				is_on_map_3130 #$3832
				rts
.endp
.proc is_on_30313438
				is_on_map_3130 #$3438
				rts
.endp
.proc is_on_31303730
				is_on_map_3130 #$3730
				rts
.endp
; Allows hero to go through the dog trails
.proc make_dog_trails_transparent
				ldx #0
@				lda DOGTRAIL_CHARS,x
				stx tmp_pipes
				add_single_char_to_transparent_chars
				ldx tmp_pipes
				inx
				cpx #6
				bne @-
				
				rts
.endp

.proc logic_M0107_remove_drakul
				ldx #0
				stx screen_mem+40*9+32
				stx screen_mem+40*9+31
				ldx #115
				stx screen_mem+40*10+31
				inx
				stx screen_mem+40*10+32
				rts
.endp

; Slowly shows the dog trails and the grave
.proc logic_M0107_show_dog_trails
				mva #1 to_be_delayed
				lda logic_flags_003
				and #LF_DOG_TRAILS_SHOWN
				cmp #LF_DOG_TRAILS_SHOWN
				beq @+
				enable_antic
				mva #50 to_be_delayed
@				
				lda logic_flags_003
				ora #LF_DOG_TRAILS_SHOWN
				sta logic_flags_003
				ldx #78
				stx screen_mem+40*19+5
				delay
				stx screen_mem+40*18+5
				delay
				stx screen_mem+40*17+5
				delay
				stx screen_mem+40*16+5
				delay
				stx screen_mem+40*15+5

				delay
				ldx #72
				stx screen_mem+40*15+6
				delay
				stx screen_mem+40*15+7
				delay
				stx screen_mem+40*15+8
				delay
				stx screen_mem+40*15+9
				delay
				stx screen_mem+40*15+10
				delay
				stx screen_mem+40*15+11

				delay
				ldx #78
				stx screen_mem+40*14+11

				delay
				ldx #72
				stx screen_mem+40*14+12

				delay
				ldx #78
				stx screen_mem+40*13+12
				delay
				stx screen_mem+40*12+12
				delay
				stx screen_mem+40*11+12
				delay
				stx screen_mem+40*10+12

				delay
				ldx #74
				stx screen_mem+40*10+11
				delay
				stx screen_mem+40*10+10
				delay
				stx screen_mem+40*10+9

				delay
				ldx #78
				stx screen_mem+40*9+9
				delay
				stx screen_mem+40*8+9
				delay
				stx screen_mem+40*7+9
				delay
				stx screen_mem+40*6+9

				delay
				ldx #72
				stx screen_mem+40*6+10
				delay
				stx screen_mem+40*6+11
				delay
				stx screen_mem+40*6+12
				delay
				stx screen_mem+40*6+13
				delay
				stx screen_mem+40*6+14
				delay
				stx screen_mem+40*6+15
				delay
				stx screen_mem+40*6+16
				delay
				stx screen_mem+40*6+17

				delay
				inx
				stx screen_mem+40*7+17
				delay
				stx screen_mem+40*8+17
				delay
				stx screen_mem+40*9+17
				delay
				stx screen_mem+40*10+17
				delay
				stx screen_mem+40*11+17

				delay
				dex
				stx screen_mem+40*11+18
				delay
				stx screen_mem+40*11+19

				delay
				ldx #70
				stx screen_mem+40*11+20
				inx
				stx screen_mem+40*11+21
				ldx #68
				stx screen_mem+40*10+21
				ldx #65
				stx screen_mem+40*10+20
				
				rts
.endp

; These chars are made transparent after call
; to "make_dog_trails_transparent".
; 115 and 116 represent the ashes after
; Drakul is burned with holy water
DOGTRAIL_CHARS
				dta b(72),b(73),b(74),b(78),b(115),b(116)
				
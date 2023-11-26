;	@com.wudsn.ide.asm.mainsourcefile=../main.asm
;	@com.wudsn.ide.asm.mainsourcefile=../main.asm
				org logic_dll
				
.proc process_logic
				mwa #0 current_action
					
				; "Wej�cie do gabinetu" = MAP0167.MAP
				is_on_30313736
				cpx #1
				bne pl01
				mwa #act_on_action_M0167-1 act_on_action_vector
				process_logic_M0167
				rts
pl01
				; "Rozdrabniarka" = MAP0174.MAP
				is_on_30313437
				cpx #1
				bne pl02
				mwa #act_on_action_M0174-1 act_on_action_vector
				process_logic_M0174
				rts
pl02
				; "Zejscie do piwnic" = MAP0170.MAP
				is_on_30313037
				cpx #1
				bne pl03
				mwa #act_on_action_M0170-1 act_on_action_vector
				process_logic_M0170
				rts
pl03
				; "Tank piwniczny" = MAP0172.MAP
				is_on_30313237
				cpx #1
				bne pl04
				mwa #act_on_action_M0172-1 act_on_action_vector
				process_logic_M0172
				rts
pl04
				; "Gabinet ordynatora" = MAP0168.MAP
				is_on_30313836
				cpx #1
				bne pl05
				mwa #act_on_action_M0168-1 act_on_action_vector
				process_logic_M0168
				rts
pl05
				; "Zej�cie do groty" - MAP0181.MAP
				is_on_30313138
				cpx #1
				bne pl06
				mwa #act_on_action_M0181-1 act_on_action_vector
				process_logic_M0181
				rts
pl06
				; "Cela" = M0003.MAP
				is_on_30303330
				cpx #1
				bne pl07
				mwa #act_on_action_M0003-1 act_on_action_vector
				process_logic_M0003
				rts
pl07				
				; "Tank na resztki" = M0179.MAP
				is_on_30313937
				cpx #1
				bne pl08
				mwa #act_on_action_M0179-1 act_on_action_vector
				process_logic_M0179
				rts
pl08
				; "G��bsza grota" = M0006.MAP
				is_on_30303630
				cpx #1
				bne pl09
				mwa #act_on_action_M0006-1 act_on_action_vector
				process_logic_M0006
				rts
pl09
				; "Poczekalnia" = M0165.MAP
				is_on_30313536
				cpx #1
				bne pl10
				mwa #act_on_action_M0165-1 act_on_action_vector
				process_logic_M0165
				rts
pl10
				rts
.endp

.proc process_logic_M0006
				#if .byte hero_YPos = #$48
					lda logic_flags_011
					and #LF_OAK_LOG
					cmp #LF_OAK_LOG
					beq @+
					write_action_name #A_M0003_083
					mwa #A_M0003_083_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_SAW #ACT_EMPTY
@
				#end
				rts
.endp

.proc process_logic_M0179
				#if .byte hero_XPos <= #$45 .and .byte hero_YPos = #$48
					write_action_name #A_M0003_082
					mwa #A_M0003_082_ID current_action
					lda logic_flags_011
					and #LF_SLUGDE_POWERED
					cmp #LF_SLUGDE_POWERED
					beq @+
					propagate_action_menu #ACT_EXPLORE #ACT_ACTIVATE #ACT_POWERUP
					rts
@					lda logic_flags_010
					and #LF_SLUGDE_FLUSHED
					cmp #LF_SLUGDE_FLUSHED
					beq @+
					propagate_action_menu #ACT_EXPLORE #ACT_ACTIVATE #ACT_EMPTY
					rts
@					propagate_action_menu_EXEMEM
					rts
				#end
				#if .byte hero_XPos = #$68 .and .byte hero_YPos = #$98
					lda logic_flags_011
					and #LF_SLUDGE_DOOR_OPENED
					cmp #LF_SLUDGE_DOOR_OPENED
					beq @+
					write_action_name #A_M0003_058
					mwa #A_M0003_058_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_OPEN #ACT_EMPTY
@
				#end
				rts
.endp

; Performs all actions connected to logic on MAP0003
.proc process_logic_M0003
				#if .byte hero_XPos = #$54 .and .byte hero_YPos = #$98
					write_action_name #A_M0003_001
					mwa #A_M0003_001_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_MOVE #ACT_EMPTY
					rts
				#end
				#if .byte hero_XPos >= #$3a .and .byte hero_XPos <= #$43 .and .byte hero_YPos = #$98
					write_action_name #A_M0003_002
					mwa #A_M0003_002_ID current_action
					lda logic_flags_000
					and #LF_BORER_USED
					cmp #LF_BORER_USED
					beq @+
					propagate_action_menu_EXOPUS
					rts
@					propagate_action_menu #ACT_EXPLORE #ACT_SQUEEZE #ACT_EMPTY
					rts
				#end
				#if .byte hero_XPos = #$64 .and .byte hero_YPos = #$70
					lda logic_flags_002
					and #LF_BOLTS_CROPPED
					cmp #LF_BOLTS_CROPPED
					beq @+
					write_action_name #A_M0003_003
					mwa #A_M0003_003_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_BITE #ACT_USE
@					rts
				#end
				#if .byte hero_XPos = #$a0+4 .and .byte hero_YPos = #$98
					write_action_name #A_M0003_020
					mwa #A_M0003_020_ID current_action
					lda logic_flags_010
					and #LF_DNA_GATHERED
					cmp #LF_DNA_GATHERED
					beq @+
					propagate_action_menu #ACT_EXPLORE #ACT_TALK #ACT_GATHER_DNA
					rts
@					propagate_action_menu #ACT_EXPLORE #ACT_TALK #ACT_EMPTY
					rts
				#end
				#if .byte hero_XPos = #$98 .and .byte hero_YPos = #$38
					lda logic_flags_013
					and #LF_CEILING_DESTROYED
					cmp #LF_CEILING_DESTROYED
					beq @+
					write_action_name #A_M0003_088
					mwa #A_M0003_088_ID current_action
					propagate_action_menu_EXUSEM
@					rts
				#end
				rts
.endp


.proc process_logic_M0181
				#if .byte hero_XPos = #$3c .and .byte hero_YPos = #$80
					write_action_name #A_M0003_081
					mwa #A_M0003_081_ID current_action
					lda logic_flags_010
					and #LF_DILDO_GIVEN
					cmp #LF_DILDO_GIVEN
					beq @+
					propagate_action_menu #ACT_TALK #ACT_PENETRATE #ACT_GIVE
					rts
@					propagate_action_menu #ACT_EXPLORE #ACT_PENETRATE #ACT_EMPTY
					rts
				#end
				rts
.endp

.proc process_logic_M0168
				#if .byte hero_XPos >= #$b4 .and .byte hero_YPos = #$98
					write_action_name #A_M0003_058
					mwa #A_M0003_058_ID current_action
					propagate_action_menu #ACT_PENETRATE #ACT_EMPTY #ACT_EMPTY
				#end
				#if .byte hero_XPos = #$7c .and .byte hero_YPos = #$98
					lda logic_flags_010
					and #LF_ARMCHAIR_PUSHED
					cmp #LF_ARMCHAIR_PUSHED
					beq @+1
					write_action_name #A_M0003_080
					mwa #A_M0003_080_ID current_action
					lda logic_flags_010
					and #LF_ARMCHAIR_WHEEL
					cmp #LF_ARMCHAIR_WHEEL
					beq @+
					propagate_action_menu #ACT_EXPLORE #ACT_PUSH #ACT_USE
					rts
@					propagate_action_menu #ACT_EXPLORE #ACT_PUSH #ACT_EMPTY
					rts
@
				#end
				rts
.endp

; Performs all actions connected to logic on MAP0167
.proc process_logic_M0167
				#if .byte hero_XPos >= #$88 .and .byte hero_XPos <= #$8f .and .byte hero_YPos = #$88
					write_action_name #A_M0003_047
					mwa #A_M0003_047_ID current_action
					propagate_action_menu #ACT_READ #ACT_EMPTY #ACT_EMPTY
				#end
				#if .byte hero_XPos >= #$79 .and .byte hero_XPos <= #$84 .and .byte hero_YPos = #$88
					write_action_name #A_M0003_016
					mwa #A_M0003_016_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_KNOCK #ACT_RECITE
				#end
				rts
.endp

; Performs all actions connected to logic on MAP0170
.proc process_logic_M0170
				#if .byte hero_XPos = #$44 .and .byte hero_YPos = #$50
					lda logic_flags_008
					and #LF_TIN_HATCH_MELTED
					cmp #LF_TIN_HATCH_MELTED
					beq @+
					write_action_name #A_M0003_069
					mwa #A_M0003_069_ID current_action
					propagate_action_menu_EXUSEM
@					
				#end
				rts
.endp

; Performs all actions connected to logic on MAP0172
.proc process_logic_M0172
				#if .byte hero_XPos = #$ac .and .byte hero_YPos = #$78
					lda logic_flags_008
					and #LF_EBOLA_FOUND
					cmp #LF_EBOLA_FOUND
					beq @+
					lda logic_flags_008
					and #LF_SAFE_PUSHED
					cmp #LF_SAFE_PUSHED
					bne @+
					write_action_name #A_M0003_073
					mwa #A_M0003_073_ID current_action
					propagate_action_menu_EXEMEM
@					
				#end
				#if .byte hero_XPos = #$94 .and .byte hero_YPos = #$48
					lda logic_flags_008
					and #LF_SAFE_PUSHED
					cmp #LF_SAFE_PUSHED
					beq @+
					write_action_name #A_M0003_070
					mwa #A_M0003_070_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_OPEN #ACT_PUSH
@					
				#end
				#if .byte hero_XPos >= #$b0 .and .byte hero_XPos <= #$c0 .and .byte hero_YPos = #$78
					lda logic_flags_008
					and #LF_FROG_SEDUCED
					cmp #LF_FROG_SEDUCED
					beq @+
					write_action_name #A_M0003_071
					mwa #A_M0003_071_ID current_action
					propagate_action_menu_EXEMEM
@					
				#end
				#if .byte hero_XPos = #$a4 .and .byte hero_YPos = #$78
					lda logic_flags_008
					and #LF_FROG_SEDUCED
					cmp #LF_FROG_SEDUCED
					beq @+
					write_action_name #A_M0003_072
					mwa #A_M0003_072_ID current_action
					propagate_action_menu_EXUSEM
@					
				#end
				rts
.endp

; Performs all actions connected to logic on MAP0174
.proc process_logic_M0174
				#if .byte hero_XPos >= #$98 .and .byte hero_XPos <= #$a0 .and .byte hero_YPos = #$60
					write_action_name #A_M0003_047
					mwa #A_M0003_047_ID current_action
					propagate_action_menu #ACT_READ #ACT_EMPTY #ACT_EMPTY
				#end
				rts
.endp

.proc process_logic_M0165
				#if .byte hero_XPos < #$84 .and .byte hero_YPos = #$58
					write_action_name #A_M0003_016
					mwa #A_M0003_016_ID current_action
					propagate_action_menu #ACT_EXPLORE #ACT_OPEN #ACT_EMPTY
				#end
				rts
.endp

.proc act_on_action_M0165
				lda current_action
				cmp #A_M0003_016_ID	; Door
				jne aoaM0165_1
				lda current_action_menu_item
				cmp #0				; Door -> Explore
				bne @+
				show_status_message #STATUSMSG_243
				rts
@				cmp #1				; Door -> Open
				bne aoaM0165_1
				mva #$a4 hero_XPos
				sta HPOSP0
				mva #$38 hero_YPos
				clear_hero
				draw_hero				
				follow_down #1
aoaM0165_1		rts
.endp

.proc logic_M0179_flush_sludge(.byte slow) .var
				mva #100 to_be_delayed
				#if .byte slow = #0
					mva #1 to_be_delayed
				#end
				
				delay

				; Flush first three rows
				mwa #screen_mem+40*12+16 screen_tmp
				ldx #0
@				lda #0
				ldy #0
@				sta (screen_tmp),y
				iny
				cpy #19
				bne @-
				delay
				adw screen_tmp #40
				inx
				cpx #3
				bne @-1

				; Flush middle three rows
				sbw screen_tmp #2
				ldx #0
@				lda #0
				ldy #0
@				sta (screen_tmp),y
				iny
				cpy #21
				bne @-
				delay
				adw screen_tmp #40
				inx
				cpx #3
				bne @-1
				
				; Flush last two rows
				lda #0
				sta screen_mem+40*18+33
				sta screen_mem+40*18+34
				delay
				lda #0
				sta screen_mem+40*19+33
				sta screen_mem+40*19+34
				
				; Open the hatch
				delay
				lda #0
				sta screen_mem+40*7+24
				sta screen_mem+40*7+25
				
				rts
.endp

.proc logic_M0176_flush_sludge
				; Flush top rows
				lda #0
				sta screen_mem+40*0+33
				sta screen_mem+40*0+34
				sta screen_mem+40*1+33
				sta screen_mem+40*1+34

				; Flush bottom rows
				mwa #screen_mem+40*2+33 screen_tmp
				ldx #0
@				lda #0
				ldy #0
@				sta (screen_tmp),y
				iny
				cpy #7
				bne @-
				delay
				adw screen_tmp #40
				inx
				cpx #3
				bne @-1
				
				rts
.endp

.proc logic_M0177_flush_sludge
				; Flush top rows
				lda #0
				sta screen_mem+40*0+3
				sta screen_mem+40*0+4
				sta screen_mem+40*1+3
				sta screen_mem+40*1+4

				; Flush bottom rows
				mwa #screen_mem+40*2+0 screen_tmp
				ldx #0
@				lda #0
				ldy #0
@				sta (screen_tmp),y
				iny
				cpy #5
				bne @-
				delay
				adw screen_tmp #40
				inx
				cpx #3
				bne @-1
				
				rts
.endp

.proc logic_M0178_flush_sludge
				; Flush bottom rows
				lda #0
				sta screen_mem+40*19+3
				sta screen_mem+40*19+4
				
				rts
.endp

.proc logic_M0168_move_armchair(.byte slow) .var
				mva #25 to_be_delayed
				#if .byte slow = #0
					mva #1 to_be_delayed
				#end
				
				delay
				delay

				mwa #screen_mem+40*15+15 screen_tmp
				
				; Move 9 times...
				lda #9
				sta tmp_loop_iterator
				
				; Single move
@				ldx #3
@				ldy #1
				lda #4
				sta slow
@				lda (screen_tmp),y
				dey
				sta (screen_tmp),y
				iny
				iny
				dec slow
				bne @-				
				adw screen_tmp #40
				dex
				bne @-1
				sbw screen_tmp #121
				
				; ...to the left
				delay
				dec tmp_loop_iterator
				bne @-2
				
				; Now move down
				adw screen_tmp #80				
				ldy #1
				
				lda #3
				sta tmp_pipes
				
@				lda #3
				sta tmp_loop_iterator
	
@				lda #3
				sta slow				
@				lda (screen_tmp),y
				tax
				adw screen_tmp #40				
				txa
				pha
				#if .word screen_tmp < #screen_mem+40*20
					pla
					sta (screen_tmp),y
				#else
					pla
				#end
				tax
				sbw screen_tmp #39
				txa
				dec slow
				bne @-
				
				sbw screen_tmp #43
				dec tmp_loop_iterator
				bne @-1
				
				adw screen_tmp #40
				lda #0
				sta (screen_tmp),y
				iny
				sta (screen_tmp),y
				iny
				sta (screen_tmp),y

				adw screen_tmp #118
				
				tya
				pha
				delay
				pla
				tay
				dec tmp_pipes
				bne @-2

				rts
.endp

.proc logic_M0181_remove_water
				mwa #screen_mem+40*7+22 screen_tmp

				ldx #0
M0181_rw_0		ldy #0
				lda #0
@				sta (screen_tmp),y
				iny
				cpy #5
				bne @-
				adw screen_tmp #40
				inx
				cpx #3
				bne M0181_rw_0
				
				; Leave one little pooooo
				sbw screen_tmp #44
				lda #53
				sta (screen_tmp),y
				
				rts
.endp

.proc logic_M0181_open_locker(.byte slow) .var
				mva #53 to_be_delayed
				#if .byte slow = #0
					mva #1 to_be_delayed
				#end
				
				delay
				delay

				lda #0
				sta screen_mem+40*5+9
				delay
				lda #0
				sta screen_mem+40*4+9
				delay
				lda #0
				sta screen_mem+40*3+9
				delay

				rts
.endp

.proc logic_M0172_move_safe(.byte slow) .var
				mva #25 to_be_delayed
				#if .byte slow = #0
					mva #1 to_be_delayed
				#end
				
				delay
				delay

				; Slight right
				lda screen_mem+40*5+29
				sta screen_mem+40*5+30
				lda screen_mem+40*5+28
				sta screen_mem+40*5+29
				lda screen_mem+40*5+27
				sta screen_mem+40*5+28
				lda screen_mem+40*6+29
				sta screen_mem+40*6+30
				lda screen_mem+40*6+28
				sta screen_mem+40*6+29
				lda screen_mem+40*6+27
				sta screen_mem+40*6+28
				lda screen_mem+40*7+29
				sta screen_mem+40*7+30
				lda screen_mem+40*7+28
				sta screen_mem+40*7+29
				lda screen_mem+40*7+27
				sta screen_mem+40*7+28
				lda #0
				sta screen_mem+40*7+27
				sta screen_mem+40*6+27
				sta screen_mem+40*5+27

				delay

				; And down
				mva #6 slow
				mwa #screen_mem+40*7+28 screen_tmp
@				ldx #4
@				ldy #0
				lda (screen_tmp),y
				ldy #40
				sta (screen_tmp),y
				ldy #1
				lda (screen_tmp),y
				ldy #41
				sta (screen_tmp),y
				ldy #2
				lda (screen_tmp),y
				ldy #42
				sta (screen_tmp),y
				sbw screen_tmp #40
				dex
				cpx #0
				bne @-
				delay
				adw screen_tmp #40*5
				dec slow
				bne @-1

				rts
.endp

.proc logic_M0172_move_frog(.byte slow) .var
				mva #100 to_be_delayed
				#if .byte slow = #0
					mva #1 to_be_delayed
				#end
				
				lda #5
				sta slow
				mwa #screen_mem+40*12+33 screen_tmp
@				ldy #1
				lda (screen_tmp),y
				dey
				sta (screen_tmp),y
				iny
				iny
				lda (screen_tmp),y
				dey
				sta (screen_tmp),y
				iny
				iny
				lda (screen_tmp),y
				dey
				sta (screen_tmp),y				
				adw screen_tmp #40
				ldy #1
				lda (screen_tmp),y
				dey
				sta (screen_tmp),y
				iny
				iny
				lda (screen_tmp),y
				dey
				sta (screen_tmp),y
				iny
				iny
				lda (screen_tmp),y
				dey
				sta (screen_tmp),y
				delay
				sbw screen_tmp #41
				dec slow
				bne @-
				
				rts
.endp

; Makes the pipes and water in the ward office transparent
.proc make_ward_pipes_transparent
				lda #20
				add_single_char_to_transparent_chars
				lda #31
				add_single_char_to_transparent_chars
				lda #63
				add_single_char_to_transparent_chars
				lda #95
				add_single_char_to_transparent_chars
				lda #117
				add_single_char_to_transparent_chars
				lda #120
				add_single_char_to_transparent_chars
				rts
.endp

; M0003 - moves bed
.proc logic_M0003_move_bed
				print_string #MOVED_BED_TOP #9 #16 #0
				print_string #MOVED_BED_BOT #9 #17 #0
				rts
.endp

; M0003 - crop bolts
.proc logic_M0003_crop_bolts
				lda #0
				sta screen_mem+40*10+15
				sta screen_mem+40*10+20
				sta screen_mem+40*11+15
				sta screen_mem+40*11+20
				sta screen_mem+40*12+15
				sta screen_mem+40*12+20
				rts
.endp

; M0003 - opens the door with borer
.proc logic_M0003_crack_door
				mva #73  screen_mem+16*40+4
				add_single_char_to_transparent_chars
				mva #74  screen_mem+16*40+5
				add_single_char_to_transparent_chars
				mva #105 screen_mem+17*40+4
				add_single_char_to_transparent_chars
				mva #106 screen_mem+17*40+5
				add_single_char_to_transparent_chars
				rts
.endp

.proc act_on_action_M0179
				lda current_action
				cmp #A_M0003_082_ID	; Pump panel
				jne aoaM0179_2
				lda current_action_menu_item
				cmp #0				; Pump panel -> Explore
				bne @+
				show_status_message #STATUSMSG_209
				rts
@				cmp #1				; Pump panel -> Activate
				bne @+
				lda logic_flags_011
				and #LF_SLUGDE_POWERED
				cmp #LF_SLUGDE_POWERED
				beq aoaM0179_3
				show_status_message #STATUSMSG_210
				rts
aoaM0179_3		logic_M0179_flush_sludge #1
				lda logic_flags_010
				eor #LF_SLUGDE_FLUSHED
				sta logic_flags_010
				rts
@				cmp #2				; Pump panel -> Use
				bne aoaM0179_2
				show_pocket
				is_chosen_in_pocket #ACTI_BATTERY
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				lda logic_flags_011
				eor #LF_SLUGDE_POWERED
				sta logic_flags_011
				remove_from_pocket #ACTI_BATTERY
				show_status_message #STATUSMSG_211
				rts
aoaM0179_2		cmp #A_M0003_058_ID	; Steel door
				bne aoaM0179_5
				lda current_action_menu_item
				cmp #0				; Steel door -> Explore
				bne @+
				show_status_message #STATUSMSG_212
				rts
@				cmp #1
				bne aoaM0179_5
				logic_M0179_open_steel_door
				lda logic_flags_011
				eor #LF_SLUDGE_DOOR_OPENED
				sta logic_flags_011
				rts
aoaM0179_5
@				rts
.endp

.proc act_on_action_M0006
				lda current_action
				cmp #A_M0003_083_ID	; Wooden log
				bne aoaM0006_1
				lda current_action_menu_item
				cmp #0				; Wooden log -> Explore
				bne @+
				show_status_message #STATUSMSG_213
				rts
@
				cmp #1				; Wooden log -> Saw
				bne @+
				show_pocket
				is_chosen_in_pocket #ACTI_SAW
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				lda logic_flags_011
				eor #LF_OAK_LOG
				sta logic_flags_011
				logic_M0006_oak_log_gravity #1
				rts
aoaM0006_1				
				rts
.endp

.proc logic_M0006_oak_log_gravity(.byte slow) .var
				mva #100 to_be_delayed
				#if .byte slow = #0
					mva #1 to_be_delayed
				#end
				
				delay
				
				mwa #screen_mem+40*7+9 screen_tmp
				
				ldx #4
				
lM006_1			ldy #0
				adw screen_tmp #40
				
@				lda (screen_tmp),y
				pha
				lda #0
				sta (screen_tmp),y
				adw screen_tmp #40
				pla
				sta (screen_tmp),y
				pha
				sbw screen_tmp #40
				pla
				iny
				cpy #3
				bne @-
	
				delay
				dex
				bne lM006_1
					
		
				rts
.endp

; Performs actions on M0003
.proc act_on_action_M0003
				lda current_action
				cmp #A_M0003_001_ID	; Bed
				bne aoaM0003_1
				lda current_action_menu_item
				cmp #1				; Bed -> Move
				bne @+1
				lda logic_flags_000
				eor #LF_BED_MOVED
				sta logic_flags_000
				logic_M0003_move_bed
				ldy #8
@				tya
				pha
				hero_left
				pla
				tay
				dey
				bne @-
				rts
@				cmp #0				; Bed -> Analyze
				bne @+ 
				show_status_message #STATUSMSG_001
@				rts				

aoaM0003_1
				cmp #A_M0003_002_ID ; Wooden door
				bne aoaM0003_2
				lda current_action_menu_item
				cmp #0				; Wooden door -> Analyze
				bne @+
				show_status_message #STATUSMSG_002
				rts
@				cmp #1				; Wooden door -> Open || Wooden door -> Sneak through the hole 
				bne @+
				lda logic_flags_000
				and #LF_BORER_USED
				cmp #LF_BORER_USED
				beq aoa_tmp_000
				show_status_message_003
				rts
aoa_tmp_000		lda #$48
				sta hero_XPos
				sta HPOSP0				
				follow_right #1
				rts				
@				cmp #2				; Wooden door -> Use
				bne @+1
				show_pocket
				is_chosen_in_pocket #ACTI_BORER
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				lda logic_flags_000
				eor #LF_BORER_USED
				sta logic_flags_000
				remove_from_pocket #ACTI_BORER
				prepare_map
@				rts
				
aoaM0003_2
				cmp #A_M0003_003_ID ; Wire grate
				bne aoaM0003_3
				lda current_action_menu_item
				cmp #0				; Wire grate -> Analyze
				bne @+
				show_status_message #STATUSMSG_004
				rts
@				cmp #1				; Wire grate -> Bite
				bne @+
				show_status_message #STATUSMSG_005
				rts
@				cmp #2				; Wire grate -> Use
				bne @+
				show_pocket
				is_chosen_in_pocket #ACTI_BOLT_CROPP
				cpx #1
				beq @+1
				finish_with_message_006
@				rts
@				lda logic_flags_002
				eor #LF_BOLTS_CROPPED
				sta logic_flags_002
				prepare_map
				show_status_message #STATUSMSG_049
aoaM0003_3

				cmp #A_M0003_020_ID 	; Hanger
				jne aoaM0003_4
				lda current_action_menu_item
				cmp #0				; Hanger -> Analyze
				bne @+
				show_status_message #STATUSMSG_051
				rts
@				cmp #1				; Hanger -> Talk
				bne @+
				show_adventure_message #ADVMSG_050
				prepare_map
				rts
@				cmp #2				; Hanger -> Suck D.N.A
				bne @+
				show_pocket
				is_chosen_in_pocket #ACTI_SYRINGE
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				lda logic_flags_010
				eor #LF_DNA_GATHERED
				sta logic_flags_010
				remove_from_pocket #ACTI_SYRINGE
				spawn_in_pocket #ACTI_DNA
				prepare_map
				show_status_message #STATUSMSG_208
@
aoaM0003_4
				cmp #A_M0003_088_ID ; Loose ceiling
				jne aoaM0003_5
				lda current_action_menu_item
				cmp #0				; Loose ceiling -> Explore
				bne @+
				show_status_message #STATUSMSG_244
				rts
@				cmp #1				; Loose ceiling -> Use
				bne @+
				show_pocket
				is_chosen_in_pocket #ACTI_PICKAXE
				cpx #1
				beq @+
				is_chosen_in_pocket #ACTI_PNEUMO
				cpx #1
				beq aoaM0003_7
				is_chosen_in_pocket #ACTI_2_DYNAMS
				cpx #1
				beq aoaM0003_8
				finish_with_message_006
				rts
@				prepare_map
				logic_M0003_remove_loose_ceiling #1
				lda logic_flags_013
				eor #LF_CEILING_DESTROYED
				sta logic_flags_013
				rts
aoaM0003_5
@
				rts
aoaM0003_7		
 				prepare_map
				show_status_message #STATUSMSG_246
				rts
aoaM0003_8
 				prepare_map
				show_status_message #STATUSMSG_249
				rts
.endp

A_M0003_001		dta d"Prycza",b($9b)					\ A_M0003_001_ID	equ 1
A_M0003_003		dta d"Druciana krata",b($9b)			\ A_M0003_003_ID	equ 3
A_M0003_082		dta "Panel pompy",b($9b)				\ A_M0003_082_ID	equ 82
A_M0003_083		dta "D",b(69),"bowa k",b(76),"oda",b($9b)	\ A_M0003_083_ID	equ 83
A_M0003_020		dta d"Umrzyk",b($9b)					\ A_M0003_020_ID	equ 20
A_M0003_088		dta "Kruchy sufit",b($9b) 				\ A_M0003_088_ID	equ 88

; Assures that all actions done to the
; particular map are visible when
; map is preloaded.
				org logic_dll_post
								
.proc post_load_logic
				disable_lightning
				
				; ============== MAP 0171 ==========
				is_on_30313137
				cpx #1
				jne pll_next_map_0001
				make_water_transparent
@				rts
				; ==================================
pll_next_map_0001
				; ============== MAP 0172 ==========
				is_on_30313237
				cpx #1
				jne pll_next_map_0002
				make_water_transparent
				lda logic_flags_008
				and #LF_FROG_SEDUCED
				cmp #LF_FROG_SEDUCED
				bne @+
				logic_M0172_move_frog #0
@				lda logic_flags_008
				and #LF_SAFE_PUSHED
				cmp #LF_SAFE_PUSHED
				bne @+
				logic_M0172_move_safe #0
@				rts
				; ==================================
pll_next_map_0002
				; ============== MAP 0170 ==========
				is_on_30313037
				cpx #1
				jne pll_next_map_0003
				lda logic_flags_008
				and #LF_TIN_HATCH_MELTED
				cmp #LF_TIN_HATCH_MELTED
				bne @+
				logic_M0170_melt_tin_hatch							
@				rts
				; ==================================
pll_next_map_0003
				; ============== MAP 0168 ==========
				is_on_30313836
				cpx #1
				jne pll_next_map_0004
				lda logic_flags_010
				and #LF_ARMCHAIR_PUSHED
				cmp #LF_ARMCHAIR_PUSHED
				bne @+
				logic_M0168_move_armchair #0
@				rts
				; ==================================
pll_next_map_0004
				; ============== MAP 0181 ==========
				is_on_30313138
				cpx #1
				jne pll_next_map_0005
				make_ward_pipes_transparent
				lda logic_flags_010
				and #LF_DILDO_GIVEN
				cmp #LF_DILDO_GIVEN
				bne @+
				logic_M0181_open_locker #0
@				lda logic_flags_010
				and #LF_POOPUMP_STARTED
				cmp #LF_POOPUMP_STARTED
				bne @+
				logic_M0181_remove_water
@				rts
				; ==================================
pll_next_map_0005
				; ============== MAP 0003 ==========
				is_on_30303330
				cpx #1
				jne pll_next_map_0006
				lda logic_flags_000
				and #LF_BED_MOVED
				cmp #LF_BED_MOVED		; Bed moved?
				bne @+
				logic_M0003_move_bed
								
@				lda logic_flags_000
				and #LF_BORER_USED
				cmp #LF_BORER_USED		; Door cracked?
				bne @+
				logic_M0003_crack_door
				
@				lda logic_flags_002
				and #LF_BOLTS_CROPPED
				cmp #LF_BOLTS_CROPPED
				bne @+
				logic_M0003_crop_bolts
		
@				lda logic_flags_013
				and #LF_CEILING_DESTROYED
				cmp #LF_CEILING_DESTROYED
				bne @+
				logic_M0003_remove_loose_ceiling #0
				
@				rts
				; ==================================

pll_next_map_0006
				; ============== MAP 0179 ==========
				is_on_30313937
				cpx #1
				jne pll_next_map_0007
				lda logic_flags_010
				and #LF_SLUGDE_FLUSHED
				cmp #LF_SLUGDE_FLUSHED		; Sludge flushed?
				bne @+
				logic_M0179_flush_sludge #0
@				lda logic_flags_011
				and #LF_SLUDGE_DOOR_OPENED
				cmp #LF_SLUDGE_DOOR_OPENED
				bne @+
				logic_M0179_open_steel_door
				rts
				; ==================================
@
pll_next_map_0007
				; ============== MAP 0176 ==========
				is_on_30313637
				cpx #1
				jne pll_next_map_0008
				lda logic_flags_010
				and #LF_SLUGDE_FLUSHED
				cmp #LF_SLUGDE_FLUSHED		; Sludge flushed?
				bne @+
				logic_M0176_flush_sludge
				rts
				; ==================================
@
pll_next_map_0008
				; ============== MAP 0177 ==========
				is_on_30313737
				cpx #1
				jne pll_next_map_0009
				lda logic_flags_010
				and #LF_SLUGDE_FLUSHED
				cmp #LF_SLUGDE_FLUSHED		; Sludge flushed?
				bne @+
				logic_M0177_flush_sludge
				rts
				; ==================================
@
pll_next_map_0009
				; ============== MAP 0178 ==========
				is_on_30313837
				cpx #1
				jne pll_next_map_0010
				lda logic_flags_010
				and #LF_SLUGDE_FLUSHED
				cmp #LF_SLUGDE_FLUSHED		; Sludge flushed?
				bne @+
				logic_M0178_flush_sludge
				rts
				; ==================================
@
pll_next_map_0010
				; ============== MAP 0006 ==========
				is_on_30303630
				cpx #1
				jne pll_next_map_0011
				lda logic_flags_011
				and #LF_OAK_LOG
				cmp #LF_OAK_LOG
				bne @+
				logic_M0006_oak_log_gravity #0
				rts
				; ==================================
@
pll_next_map_0011
				rts
.endp

; Allows hero to go underwater
.proc make_water_transparent
				lda #72
				add_single_char_to_transparent_chars
				rts
.endp

; Performs actions on M0167
.proc act_on_action_M0167
				lda current_action
				cmp #A_M0003_047_ID	; Memo
				bne aoaM0167_1
				lda current_action_menu_item
				cmp #0				; Memo -> Read
				bne @+
				show_status_message #STATUSMSG_115
				rts
@
aoaM0167_1							
				cmp #A_M0003_016_ID	; Modern door
				bne aoaM0167_2
				lda current_action_menu_item
				cmp #0				; Modern -> Explore
				bne @+
				show_status_message #STATUSMSG_116
				rts
@
				cmp #1				; Modern -> Knock
				bne @+
				show_status_message #STATUSMSG_117
				rts
@				cmp #2				; Modern -> Use
				bne aoaM0167_2
				show_pocket
				is_chosen_in_pocket #ACTI_POEM
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				mva #$b2 hero_XPos
				sta HPOSP0
				mva #$98 hero_YPos
				clear_hero
				draw_hero				
				follow_up #1
				rts
aoaM0167_2
@				rts
.endp

.proc act_on_action_M0168
				lda current_action
				cmp #A_M0003_058_ID	; Steel door
				bne aoaM0168_1
				lda current_action_menu_item
				cmp #0				; Steel door -> Penetrate
				bne @+
				mva #$76 hero_XPos
				sta HPOSP0
				mva #$88 hero_YPos
				clear_hero
				draw_hero				
				follow_up #1
				rts
@
aoaM0168_1
				cmp #A_M0003_080_ID	; Fustian armchair
				jne aoaM0168_2
				lda current_action_menu_item
				cmp #0				; Fustian armchair -> Explore
				bne @+
				show_status_message #STATUSMSG_200
				rts
@				
				cmp #1				; Fustian armchair -> Push
				bne @+
				lda logic_flags_010
				and #LF_ARMCHAIR_WHEEL
				cmp #LF_ARMCHAIR_WHEEL
				beq aoaM0168_10
				show_status_message #STATUSMSG_201
				rts	
aoaM0168_10		logic_M0168_move_armchair #1
				lda logic_flags_010
				eor #LF_ARMCHAIR_PUSHED
				sta logic_flags_010
				rts
							
@
				cmp #2				; Fustian armchair -> Use
				bne @+
				show_pocket
				is_chosen_in_pocket #ACTI_WHEEL
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				remove_from_pocket #ACTI_WHEEL
				lda logic_flags_010
				eor #LF_ARMCHAIR_WHEEL
				sta logic_flags_010
				show_status_message #STATUSMSG_202
				rts
aoaM0168_2
				rts
.endp

; Performs actions on M0170
.proc act_on_action_M0170
				lda current_action
				cmp #A_M0003_069_ID	; Tin hatch
				bne aoaM0170_1
				lda current_action_menu_item
				cmp #0				; Tin hatch -> Explore
				bne @+
				show_status_message #STATUSMSG_171
				rts
@				cmp #1				; Tin hatch -> Use
				bne aoaM0170_1
				show_pocket
				is_chosen_in_pocket #ACTI_SOLDERTOOL
				cpx #1
				beq @+
				is_chosen_in_pocket #ACTI_GRAVELIGHT
				cpx #1
				beq aoaM0170_2
				is_chosen_in_pocket #ACTI_FIRE_BRAIN
				cpx #1
				beq aoaM0170_2
				finish_with_message_006
				rts
@				prepare_map
				lda logic_flags_008
				eor #LF_TIN_HATCH_MELTED
				sta logic_flags_008
				logic_M0170_melt_tin_hatch
				show_status_message #STATUSMSG_172
aoaM0170_1							
				rts
aoaM0170_2		prepare_map
				show_status_message #STATUSMSG_250
				rts
.endp

; Performs actions on M0181
.proc act_on_action_M0181
				lda current_action
				cmp #A_M0003_081_ID	; Head of hospital ward's wife
				jne aoaM0181_1
				lda current_action_menu_item
				cmp #0				; Head of hospital ward's wife -> Talk / Explore
				bne @+
				lda logic_flags_010
				and #LF_DILDO_GIVEN
				cmp #LF_DILDO_GIVEN
				beq aoa_M0181_1
				show_adventure_message #ADVMSG_204
				prepare_map
				rts
aoa_M0181_1		show_status_message #STATUSMSG_207
				rts
@						
				cmp #1				; Head of hospital ward's wife -> Penetrate
				bne @+
				show_status_message #STATUSMSG_205
				rts
@
				cmp #2				; Head of hospital ward's wife -> Give
				bne @+
				show_pocket
				is_chosen_in_pocket #ACTI_DILDO
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				show_status_message #STATUSMSG_206
				remove_from_pocket #ACTI_DILDO
				logic_M0181_open_locker #1
				lda logic_flags_010
				eor #LF_DILDO_GIVEN
				sta logic_flags_010
				rts
@
aoaM0181_1		rts
.endp

; Performs actions on M0172
.proc act_on_action_M0172
				lda current_action
				cmp #A_M0003_070_ID	; Pharmacy safe
				bne aoaM0172_1
				lda current_action_menu_item
				cmp #0				; Pharmacy safe -> Explore
				bne @+
				show_status_message #STATUSMSG_173
				rts
@				cmp #1				; Pharmacy safe -> Open
				bne @+
				show_status_message #STATUSMSG_003
@				cmp #2				; Pharmacy safe -> Push
				bne aoaM0172_1
				lda logic_flags_008
				and #LF_FROG_SEDUCED
				cmp #LF_FROG_SEDUCED
				beq @+
				show_status_message #STATUSMSG_174
				rts
@				logic_M0172_move_safe #1
				lda logic_flags_008
				eor #LF_SAFE_PUSHED
				sta logic_flags_008
				rts
aoaM0172_1							
				cmp #A_M0003_071_ID	; Froggy
				bne aoaM0172_2
				lda current_action_menu_item
				cmp #0				; Froggy -> Explore
				bne @+
				show_status_message #STATUSMSG_175
				rts
@
aoaM0172_2
				cmp #A_M0003_072_ID	; Bowl
				bne aoaM0172_3
				lda current_action_menu_item
				cmp #0				; Bowl -> Explore
				bne @+
				show_status_message #STATUSMSG_176
				rts
@				cmp #1				; Bowl -> Use
				bne aoaM0172_3
				show_pocket
				is_chosen_in_pocket #ACTI_FOSSILIZED
				cpx #1
				beq @+
				finish_with_message_006
				rts
@				prepare_map
				lda logic_flags_008
				eor #LF_FROG_SEDUCED
				sta logic_flags_008
				logic_M0172_move_frog #1
				remove_from_pocket #ACTI_FOSSILIZED
aoaM0172_3
				cmp #A_M0003_073_ID	; Flatten frog
				bne aoaM0172_4
				lda current_action_menu_item
				cmp #0				; Flatten frog -> Explore
				bne @+
				show_status_message #STATUSMSG_177
				spawn_in_pocket #ACTI_EBOLA
				lda logic_flags_008
				eor #LF_EBOLA_FOUND
				sta logic_flags_008
@				rts
aoaM0172_4
				rts
.endp

; Performs actions on M0174
.proc act_on_action_M0174
				lda current_action
				cmp #A_M0003_047_ID	; Memo
				bne aoaM0174_1
				lda current_action_menu_item
				cmp #0				; Memo -> Read
				bne @+
				show_status_message #STATUSMSG_118
				rts
@
aoaM0174_1							
				rts
.endp

.proc logic_M0170_melt_tin_hatch
				lda #0
				sta screen_mem+40*9+5
				sta screen_mem+40*9+6
				rts
.endp

.proc logic_M0179_open_steel_door
				lda #0
				sta screen_mem+40*15+13
				sta screen_mem+40*16+13
				sta screen_mem+40*17+13
				rts
.endp

.proc is_on_30313736
				is_on_map_3130 #$3736
				rts
.endp
.proc is_on_30313137
				is_on_map_3130 #$3137
				rts
.endp
.proc is_on_30313237
				is_on_map_3130 #$3237
				rts
.endp
.proc is_on_30313437
				is_on_map_3130 #$3437
				rts
.endp
.proc is_on_30313037
				is_on_map_3130 #$3037
				rts
.endp
.proc is_on_30313836
				is_on_map_3130 #$3836
				rts
.endp
.proc is_on_30313138
				is_on_map_3130 #$3138
				rts
.endp
.proc is_on_30303330
				is_on_map_3030 #$3330
				rts
.endp
.proc is_on_30313937
				is_on_map_3130 #$3937
				rts
.endp
.proc is_on_30313637
				is_on_map_3130 #$3637
				rts
.endp
.proc is_on_30313737
				is_on_map_3130 #$3737
				rts
.endp
.proc is_on_30313837
				is_on_map_3130 #$3837
				rts
.endp
.proc is_on_30303630
				is_on_map_3030 #$3630
				rts
.endp
.proc is_on_30313536
				is_on_map_3130 #$3536
				rts
.endp

.proc logic_M0003_remove_loose_ceiling(.byte slow) .var
				mva #50 to_be_delayed
				#if .byte slow = #0
					mva #1 to_be_delayed
				#end
				delay
				ldx #0
				stx screen_mem+6*40+26
				delay
				stx screen_mem+7*40+26
				delay
				stx screen_mem+7*40+27
				delay
				stx screen_mem+8*40+26
				rts
.endp

A_M0003_081		dta b(88),"ona ordynatora",b($9b)		\ A_M0003_081_ID	equ 81
A_M0003_080		dta "Barchanowy fotel",b($9b)			\ A_M0003_080_ID	equ 80


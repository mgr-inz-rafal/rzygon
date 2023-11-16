
;	@com.wudsn.ide.asm.mainsourcefile=../main.asm
				org logic_dll
				
.proc process_logic
				mwa #0 current_action
					
				; "Przeci¹g" = MAP0142.MAP
				is_on_30319234
				cpx #1
				bne pl1
;				mwa #act_on_action_M0142-1 act_on_action_vector
				process_logic_M0142
@				rts
pl1
					
				rts
.endp


				org HLEJNIA_MUSIC
				ins 'Hlejnia_9C80.CMR'
				
				org HLEJNIA_PLAYER
				icl "cmc_player.asm"


; Performs all actions connected to logic on MAP0142
.proc process_logic_M0142
				#if .byte hero_XPos = #$55
					lda logic_flags_005
					and #LF_ZUG_MSG_DISPLAYED
					cmp #LF_ZUG_MSG_DISPLAYED
					beq @+
					lda logic_flags_005
					eor #LF_ZUG_MSG_DISPLAYED
					sta logic_flags_005
					show_status_message #STATUSMSG_105
@					rts
				#end
				rts
.endp



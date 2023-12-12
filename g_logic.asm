;	@com.wudsn.ide.asm.mainsourcefile=main.asm

;=================================================================================
; A set of variables that keep status
; of the logic actions done by player.
;=================================================================================
				
.proc build_logic_DLL_file_name
;				mwa drive_id					io_buffer
				lda #$4c
				sta io_buffer+2
				sta io_buffer+7
				sta io_buffer+8
				mva #$4c						io_buffer+2	; "L"
				mwa logic_dll_name_to_be_used	io_buffer+3
				mwa #$442e						io_buffer+5	; ".D"
				rts
.endp

; Preloads the specific logic DLL.
.proc load_logic_block
;				rts
				
				build_logic_DLL_file_name
;				io_find_free_iocb
;				io_open_file_OPT1
;				io_read_binary #logic_dll #5887
;				io_close_file
				rts
.endp

item_respawn_tab
				; Do not spawn ass plug if worm has been plugged
				dta a(ACTI_ASS_PLUG)
				dta a(logic_flags_002)
				dta b(LF_WORM_PLUGGED)
				; Do not spawn praybook if prayer has been heard
				dta a(ACTI_PRAYBOOK)
				dta a(logic_flags_007)
				dta b(LF_PRAYER_SPEAKED)
				; Do not spawn borer if it has been used
				dta a(ACTI_BORER)
				dta a(logic_flags_000)
				dta b(LF_BORER_USED)
				; Do not spawn snot if it has been used
				dta a(ACTI_SNOT)
				dta a(logic_flags_001)
				dta b(LF_PIPE_SNOTTED)
				; Do not spawn cross if it has been given to the demon
				dta a(ACTI_GOLD_CROSS)
				dta a(logic_flags_001)
				dta b(LF_DEMON_BRIBED)
				; Do not spawn grail if it has been given to the big priest
				dta a(ACTI_GRAIL)
				dta a(logic_flags_005)
				dta b(LF_GRAIL_GIVEN)
				; Do not spawn ice-cold water if it has been poured over the kutas
				dta a(ACTI_ICE_WATER)
				dta a(logic_flags_008)
				dta b(LF_KUTAS_SHRINKED)
				; Do not spawn fossilized bug if The Frog has beed seduced
				dta a(ACTI_FOSSILIZED)
				dta a(logic_flags_008)
				dta b(LF_FROG_SEDUCED)
				; Do not spawn coffin handler if coffin has been moved
				dta a(ACTI_COFFIN_HND)
				dta a(logic_flags_009)
				dta b(LF_COFFIN_MOVED)
				; Do not spawn WD 40 if crate has been oiled
				dta a(ACTI_WD_40)
				dta a(logic_flags_007)
				dta b(LF_CRATE_OILED)
				; Do not spawn 2 dynamites if 1st wall has been blown
				dta a(ACTI_2_DYNAMS)
				dta a(logic_flags_007)
				dta b(LF_1ST_WALL_BLOWN)
				; Do not spawn dynamite if 2nd wall has been blown
				dta a(ACTI_DYNAMITE)
				dta a(logic_flags_007)
				dta b(LF_2ND_WALL_BLOWN)
				; Do not spawn crank if bascule bridge has been lowered
				dta a(ACTI_CRANK)
				dta a(logic_flags_002)
				dta b(LF_BASCULE_BRIDGE_LOW)
				; Do not spawn rotten fish if it has been given to the zombie
				dta a(ACTI_ROTTENFISH)
				dta a(logic_flags_005)
				dta b(LF_ZOMBIE_HAS_BRAIN)
				; Do not spawn gold bars if they has been given to the withcer
				dta a(ACTI_GOLDBARS)
				dta a(logic_flags_013)
				dta b(LF_GOLD_BARS_GIVEN)
				; Do not spawn skull if grave has been lowered
				dta a(ACTI_SKULL)
				dta a(logic_flags_006)
				dta b(LF_GRAVE_LOWERED)
				; Do not spawn toilet brush if shit has been cleared
				dta a(ACTI_TOILETBRSH)
				dta a(logic_flags_006)
				dta b(LF_SHIT_CLEARED)
				; Do not spawn candle wick if it has been planted into the candle
				dta a(ACTI_CANDLEWICK)
				dta a(logic_flags_013)
				dta b(LF_WICK_INSERTED)
				; Do not spawn visceras if they have been tossed into the mortar
				dta a(ACTI_VISCERA1)
				dta a(logic_flags_011)
				dta b(LF_VISCERA1)
				dta a(ACTI_VISCERA2)
				dta a(logic_flags_011)
				dta b(LF_VISCERA2)
				dta a(ACTI_VISCERA3)
				dta a(logic_flags_011)
				dta b(LF_VISCERA3)
				dta a(ACTI_VISCERA4)
				dta a(logic_flags_011)
				dta b(LF_VISCERA4)
				dta a(ACTI_VISCERA5)
				dta a(logic_flags_011)
				dta b(LF_VISCERA5)
				dta a(ACTI_VISCERA6)
				dta a(logic_flags_012)
				dta b(LF_VISCERA6)
				dta a(ACTI_VISCERA7)
				dta a(logic_flags_012)
				dta b(LF_VISCERA7)
				; Do not spawn Worcestershire sauce if it has been tossed into the mortar
				dta a(ACTI_WORCESTER)
				dta a(logic_flags_012)
				dta b(LF_VISCERA_WORCESTER)
				; Do not spawn rotten key if the crypt has been opened
				dta a(ACTI_ROTTENKEY)
				dta a(logic_flags_006)
				dta b(LF_CRYPT_OPENED)
				; Do not spawn egg if it has been smashed over the wall
				dta a(ACTI_EGG)
				dta a(logic_flags_008)
				dta b(LF_EGG_SMASHED)
				; Do not spawn Zigmunt ring if it has been given to the witch
				dta a(ACTI_ZIGMUNT)
				dta a(logic_flags_009)
				dta b(LF_WITCH_REMOVED)
				; Do not spawn battery if the sludge pump has been powered
				dta a(ACTI_BATTERY)
				dta a(logic_flags_011)
				dta b(LF_SLUGDE_POWERED)
				; Do not spawn syringe if DNA has been gathered
				dta a(ACTI_SYRINGE)
				dta a(logic_flags_010)
				dta b(LF_DNA_GATHERED)
				; Do not spawn wheel if it has been attached to the armchair
				dta a(ACTI_WHEEL)
				dta a(logic_flags_010)
				dta b(LF_ARMCHAIR_WHEEL)
				; Do not spawn dildo if it has been given to the lady
				dta a(ACTI_DILDO)
				dta a(logic_flags_010)
				dta b(LF_DILDO_GIVEN)
				; Do not spawn flask if holy water has been gathered
				dta a(ACTI_FLASK)
				dta a(logic_flags_013)
				dta b(LF_FLASK_USED)
				; End
				dta b($ff),b($ff)			
				
.proc should_spawn_this_item_compare
				ldy #0
sstic1			lda (screen_tmp),y
				cmp (show_message_prerequisites.ptr2),y
				bne sstic0
				iny
				cpy #6
				beq sstic0
				jmp sstic1
sstic0			rts
.endp

.zpvar dupa_tmp .word

; Return: A=0 - yes     A=1 - no
.proc should_spawn_this_item
				mwa #item_respawn_tab dupa_tmp
ssti0			ldy #0
				lda (dupa_tmp),y
				sta screen_tmp
				iny
				lda (dupa_tmp),y
				sta screen_tmp+1

				jsr should_spawn_this_item_compare
				cpy #5
				beq should_spawn_this_item_COMPARED
				; Check next item
				adw dupa_tmp #5
				ldy #1
				lda (dupa_tmp),y
				cmp #$ff
				bne ssti0
				; Don't spawn
				lda #0
				rts
				; Check additional coditions
should_spawn_this_item_COMPARED
				adw dupa_tmp #2
				ldy #0
				lda (dupa_tmp),y
				sta screen_tmp
				iny
				lda (dupa_tmp),y
				sta screen_tmp+1
				dey
				; Appropriate logic flags in A
				lda (screen_tmp),y
				pha
				adw dupa_tmp #2
				lda (dupa_tmp),y
				sta screen_tmp
				pla
				and screen_tmp
				cmp screen_tmp
				jne @+
				lda #1
				rts
@				lda #0
				rts
.endp

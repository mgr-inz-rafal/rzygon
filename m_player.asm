;	@com.wudsn.ide.asm.mainsourcefile=main.asm

.var	old_vbi	.word
.var	which	.byte

MUSIC_ADVENTURE_MESSAGE		equ 0
MUSIC_MENU_SWITCH			equ 1
MUSIC_MENU_OPEN_CLOSE		equ 2

HLEJNIA_MUSIC				equ		$9C80-6
HLEJNIA_PLAYER				equ		$A9C2


; Used to play CMC music
vbi_routine_CMC
		jsr HLEJNIA_PLAYER+6
		jmp XITVBV

; Starts playing "Hlejnia". Assuming that
; L06.DLL which contains both music and CMC player
; is already loaded
.proc music_play_cmc_hlejnia
				lda logic_flags_005
				eor #LF_HLEJNIA_PLAYING
				sta logic_flags_005

				ldx <HLEJNIA_MUSIC+6
				ldy >HLEJNIA_MUSIC+6
				lda #$70
				jsr HLEJNIA_PLAYER+3
		
				lda vvblkd
       			sta old_vbi
       			lda vvblkd+1
       			sta old_vbi+1   

				ldy <vbi_routine_CMC
		        ldx >vbi_routine_CMC
		        lda #7
		        jsr SETVBV

				ldx #0
				txa
				jsr HLEJNIA_PLAYER+3

				rts
.endp

; Stops playing "Hlejnia".
.proc music_stop_cmc_hlejnia
				lda logic_flags_005
				and #LF_HLEJNIA_PLAYING
				cmp #LF_HLEJNIA_PLAYING
				bne @+
				
				lda logic_flags_005
				eor #LF_HLEJNIA_PLAYING
				sta logic_flags_005

				lda #$40
				jsr HLEJNIA_PLAYER+3
				
				lda #7
       			ldy old_vbi
       			ldx old_vbi+1
			    jmp setvbv
       
@				rts
.endp

; Plays music with the provided identifier
.proc music_play
				lda VVBLKD
				sta old_vbi
				lda VVBLKD+1
				sta old_vbi+1
				
				ldy <vbi_routine
				ldx >vbi_routine
				lda #7
				jsr SETVBV
				rts
.endp

; Stops all music and restores the original VBI
; in order to allow flawless I/O
.proc stop_music
				jsr RASTERMUSICTRACKER+9
				jsr restore_musical_vbi
				rts
.endp

.proc restore_musical_vbi
				lda #7
				ldy old_vbi
				ldx old_vbi+1
				jmp setvbv
				rts
.endp

.proc music_init(.byte which) .var
				ldx #<MODUL
				ldy #>MODUL
				lda which
				jsr RASTERMUSICTRACKER	;Init
				rts
.endp
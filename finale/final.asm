pmg_base	equ $8000
font_base	equ $8000
screen_mem	equ $b900

ST_ARRIVE			equ	0
ST_FLOATING_RIGHT	equ 1
ST_SKULK			equ 2
ST_FLOATING_LEFT	equ 3
ST_BEFORE_SINUS		equ 4

CRS_NONE			equ 0
CRS_FADEIN_UP		equ 1
CRS_PAUSE			equ	2
CRS_FADEIN_DOWN		equ 3
CRS_PRESENTED		equ 4
CRS_FADEOUT			equ 5
CRS_WARMUP			equ 6

;SKULK_COUNT			equ 600
SKULK_COUNT			equ 100
SINUS_COUNT			equ 200
PAUSE_COUNT			equ 50
PRESENT_COUNT		equ	230
WARMUP_COUNT		equ 75

.zpvar		ptr0	.word
.zpvar		ptr1	.word
.zpvar		ptr2	.word
.zpvar		ptr3	.word
.zpvar		tmpX	.byte
.zpvar		tmp1	.byte
.zpvar		tmp2	.byte
.zpvar		tmp4	.byte
.zpvar		tmp5	.byte
.zpvar		tmp6	.byte
.zpvar		tmp7	.byte
.zpvar		state	.byte
.zpvar		xpos	.byte
.zpvar		counter	.word
.zpvar		sineind	.word
.zpvar		ptrcrup	.word
.zpvar		ptrcrdn	.word
.zpvar		crstate	.byte
.zpvar		ccolup	.byte
.zpvar		ccoldn	.byte
.zpvar		ccount	.word
.zpvar		kroplay	.byte
.zpvar		kroplax	.byte
.zpvar		revstat	.byte
.zpvar		ypos	.byte

			icl '../atari.inc'
			org	$2c20

			ldx #<MODUL
			ldy #>MODUL
			lda #0
			jsr RASTERMUSICTRACKER	;Init
			ldy <vbi_routine
			ldx >vbi_routine
			lda #7
			jsr SETVBV

			; Border color			
			lda #$00
			sta revstat
			sta ypos
			sta COLOR4

			lda #%00000001
			sta GPRIOR
			
			lda #$70
			sta kroplay
			
			lda #0
			sta ccolup
			sta ccoldn
									
;			lda SDMCTL
;			ora #%00101100
;			sta SDMCTL

;			lda >pmg_base
;			sta PMBASE

;			lda #%00000011
;			sta GRACTL

			; Init DLI
			lda <dli_routine
			sta VDSLST
			lda >dli_routine
			sta VDSLST+1
			lda #192
			sta NMIEN
			
			lda #>pmg_base
			sta PMBASE
			
			lda #%00000011
			sta GRACTL

			lda SDMCTL
			ora #%00011100
			sta SDMCTL
			
			lda SDMCTL
			sta tmp7
			lda #0
			sta SDMCTL

			lda #CRS_NONE
			sta crstate
			mwa #SKULK_COUNT counter
			lda #ST_SKULK
			sta state
			lda #$ff
			sta xpos
			
			lda #44
			sta PCOLR0
			lda #40
			sta PCOLR1
			lda #188
			sta PCOLR2
			lda xpos
			sta HPOSP0
			sta HPOSP1
			sta HPOSP2
			lda #%00000000
			sta SIZEP0
			sta SIZEP1
			sta SIZEP2
			sta SIZEP3

			lda #$ff
			sta kroplax
			sta HPOSP3
			
			mwa #credits_0u ptrcrup
			mwa #credits_0d ptrcrdn
			
			jsr flight
			jsr starquake
			jsr pause
			jsr pause
			jsr pause
			jsr to_be_continued
chuj		lda #0
			sta ATRACT
			jmp chuj

to_be_continued
			lda #$0f
			sta COLOR4
			lda #$b2
			sta COLOR1
			lda #$62
			sta COLOR3
			
			lda #0
			sta HPOSP0
			sta HPOSP1
			sta HPOSP2
			sta HPOSP3
			
			lda #>(font_base+512)
			sta CHBAS
			
			ldy #0
@			lda cdn_strings,y
			sta screen_mem,y
			iny
			cpy #40
			bne @-

			ldx <dl_cdn
			ldy >dl_cdn
			stx SDLSTL
			sty SDLSTL+1

			rts
			
position_kropla
			ldx #0
			ldy kroplay
pk0			lda kropla_data,x
			sta kropla_sprite,y
			inx
			cpx #19
			beq @+
			iny
			jmp pk0
@			rts
			
kropla_data
			dta b(16)
			dta b(16)
			dta b(16)
			dta b(16)
			dta b(16)
			dta b(48)
			dta b(48)
			dta b(56)
			dta b(56)
			dta b(56)
			dta b(56)
			dta b(60)
			dta b(60)
			dta b(124)
			dta b(126)
			dta b(126)
			dta b(62)
			dta b(60)
			dta b(60)

flight		
			lda #98
			sta COLOR2
			lda #238
			sta COLOR0
			lda #58
			lda #166
			sta COLOR1

			jsr prepare_stars
			ldx <dl_flight
			ldy >dl_flight
			stx SDLSTL
			sty SDLSTL+1

			ldx #80
@			stx kroplax
			jsr move_stars
			ldx kroplax
			dex
			cpx #0
			bne @-
						
			jsr print_up_string			
			jsr print_down_string			
		
fl0			
			lda HELPFG
			ora #%00000001
			cmp #1
			bne fl1
			lda #0
			sta ATRACT
			jsr delay
			jsr move_stars
			jsr move_rzygon
			jsr move_kropla
			jsr move_strings
			jmp fl0
fl1			rts
			
move_kropla
			lda kroplax
			cmp #$ff
			bne @+
			; No kropla on screen
			rts
@			jsr kropla_down
			rts
			
kropla_down
			ldy #$fe
@			lda kropla_sprite,y
			iny
			sta kropla_sprite,y
			dey
			dey
			cpy #0
			bne @-
			ldy kroplay
			iny
			sty kroplay
			cpy #$ff
			bne @+
			lda #$ff
			sta kroplax
			lda #$70
			sta kroplay
@			rts
			
move_strings
			lda crstate
			cmp #CRS_NONE
			bne @+
			; No need to to anything
			rts
			
@			cmp #CRS_FADEIN_UP
			bne @+
			ldx ccolup
			inx
			cpx #$f
			beq mos0
			stx ccolup
			rts
mos0		lda #CRS_PAUSE
			sta crstate
			mwa #PAUSE_COUNT ccount
			rts

@			cmp #CRS_PAUSE
			bne @+
			dew ccount
			#if .word ccount = #0
				lda #CRS_FADEIN_DOWN
				sta crstate
				rts
			#end
			rts

@			cmp #CRS_FADEIN_DOWN
			bne @+
			ldx ccoldn
			inx
			cpx #$f
			beq mos1
			stx ccoldn
			rts
mos1		lda #CRS_PRESENTED
			sta crstate
			mwa #PRESENT_COUNT ccount
			rts

@			cmp #CRS_PRESENTED
			bne @+
			dew ccount
			#if .word ccount = #0
				lda #CRS_FADEOUT
				sta crstate
				rts
			#end
			rts

@			cmp #CRS_FADEOUT
			bne @+
			
			ldx ccoldn
			dex
			cpx #$0
			beq mos2
			stx ccoldn
			stx ccolup
			rts
mos2		adw ptrcrup #82
			adw ptrcrdn #82
			
			ldy #0
			lda (ptrcrup),y
			cmp #$ff
			beq mos4
			
mos3		jsr print_up_string			
			jsr print_down_string			
			lda #CRS_WARMUP
			sta crstate
			mwa #WARMUP_COUNT ccount
			rts
			
@			cmp #CRS_WARMUP
			bne @+
			dew ccount
			#if .word ccount = #0
				lda #CRS_FADEIN_UP
				sta crstate
				rts
			#end
@			rts
mos4		
			mwa #credits_1u ptrcrup
			mwa #credits_1d ptrcrdn
			jmp mos3
			
print_up_string
			ldy #0
pus0		lda (ptrcrup),y
			cmp #$9b
			beq @+
			sta screen_mem+440,y
			iny
			jmp pus0
@			rts

print_down_string
@			ldy #0
pds0		lda (ptrcrdn),y
			cmp #$9b
			beq @+
			sta screen_mem+520,y
			iny
			jmp pds0
@			rts
			
reverse_rzygon
			ldy #$ff
rr0			iny
			cpy #$ff
			beq @+
			sty tmp5
			lda rzygon_sprite_data,y
			tay
			lda bit_mirror_lut,y
			ldy tmp5
			sta rzygon_sprite_data,y
			jmp rr0
@			inc revstat
			rts

dli_routine
		pha
		txa
		pha
		tya
		pha

		lda #$00
		sta COLPF2

		lda VCOUNT
		cmp #$67
		bne @+
		
		lda ccolup
		sta COLPF1
		
		jmp dlifin

@		cmp #$6b
		bne dlifin

		lda ccoldn
		sta COLPF1
		
dlifin	pla
		tay
		pla
		tax
		pla
		rti

; HPOS from A			
position_rzygon
			sta xpos
			sta HPOSP0
			clc
			adc #$8
			sta HPOSP1
			sec
			sbc #4
			sta HPOSP2
			rts
			
spawn_kropla
			lda state
			cmp #ST_FLOATING_LEFT
			beq @+
			cmp #ST_FLOATING_RIGHT
			beq @+
			; Spawn only when floating LEFT or RIGHT
			rts
@			lda kroplax
			cmp #$ff
			beq @+
			; Don't spawn when already spawned
			rts

@			
			lda RANDOM
			sec
			sbc #253
			bcc sk0
			lda RANDOM
			sta PCOLR3
			jsr position_kropla
			lda xpos
			clc
			adc #3
			sta kroplax
			sta HPOSP3
			
sk0			rts
			
move_rzygon
			jsr spawn_kropla
			lda state
			cmp #ST_ARRIVE
			bne @+
			ldx xpos
			dex
;			cpx #256/2-8
			cpx #60
			beq mr0
			txa
			pha
			jsr position_rzygon
			pla
			sta xpos
			rts
		
@			cmp #ST_FLOATING_RIGHT
			bne @+
			ldy sineind
			cpy #0
			bne mr1
			lda #ST_FLOATING_LEFT
			sta state
			jsr reverse_rzygon
			rts			
mr1			lda rzygon_sinus_right,y
			jsr position_rzygon
			dec sineind
			rts

@			cmp #ST_SKULK
			bne @+
			dew counter
			#if .word counter = #0
				lda #ST_ARRIVE
				sta state
			#end
			rts

@			cmp #ST_FLOATING_LEFT
			bne @+
			ldy sineind
			cpy #116
			bne mr2
			lda #ST_FLOATING_RIGHT
			sta state
			jsr reverse_rzygon
			rts			
mr2			lda rzygon_sinus_right,y
			jsr position_rzygon
			inc sineind
			rts
			
@			cmp #ST_BEFORE_SINUS
			bne @+
			dew counter
			#if .word counter = #0
				lda #ST_FLOATING_RIGHT
				sta state
				rts
			#end
@			rts

mr0
			lda #ST_BEFORE_SINUS
			sta state
			lda #116
			sta sineind
			jsr reverse_rzygon
			lda #CRS_FADEIN_UP
			sta crstate
			mwa #SINUS_COUNT counter
			rts
			
; TODO: 'extract method' with prepare_stars
move_stars
			ldx #<stars_pos
			stx ptr0
			ldx #>stars_pos
			stx ptr0+1
			
			ldx #stars_count
			
ms0			
			ldy #0
			lda (ptr0),y
			sta ptr1
			iny
			lda (ptr0),y
			sta ptr1+1
			
			ldy #0
			lda (ptr1),y
			cmp #0
			beq ms6

			ldy #0
			lda (ptr1),y
			jsr do_next_char
			cpy #1
			bne @+
			
			; Here move to next char
			sta tmpX
			ldy #0
			lda (ptr0),y
			sta ptr2
			iny
			lda (ptr0),y
			sta ptr2+1
			
			ldy #0
			lda (ptr2),y
			
			inw ptr2
ms3			jsr check_offscreen
			pha
			
			
			ldy #0
			lda ptr2,y
			sta (ptr0),y
			iny
			lda ptr2,y
			sta (ptr0),y
			pla
			cmp #1
			beq ms1
			lda tmpX
			ldy #1
			sta (ptr1),y
ms1			lda #0
			ldy #0
			sta (ptr1),y
			; Moving to next char finished
			
@			ldy #0
			sta (ptr1),y

ms7			dex
			beq @+
			
			adw ptr0 #4
			jmp ms0
			
@			rts
ms6			jsr do_next_char
			ldy #0
			sta (ptr1),y			
			jmp ms7
			
check_offscreen_internal
			lda tmp7
			sta SDMCTL

			mwa ptr3 ptr2
			
			lda RANDOM
			lda #$0
			sty tmp2
			ldy #3
			sta (ptr0),y
			ldy tmp2
			
			lda #1
			rts

; Return:
; A=0 - no need to reset the star
; A=1 - need to reset the star
check_offscreen
			#if .word ptr2 = #screen_mem+$28
				mwa #screen_mem ptr3
				jsr check_offscreen_internal
				rts
			#end
			#if .word ptr2 = #screen_mem+$50
				mwa #screen_mem+$28 ptr3
				jsr check_offscreen_internal
				rts
			#end
			#if .word ptr2 = #screen_mem+$78
				mwa #screen_mem+$50 ptr3
				jsr check_offscreen_internal
				rts
			#end
			#if .word ptr2 = #screen_mem+$A0
				mwa #screen_mem+$78 ptr3
				jsr check_offscreen_internal
				rts
			#end
			#if .word ptr2 = #screen_mem+$C8
				mwa #screen_mem+$A0 ptr3
				jsr check_offscreen_internal
				rts
			#end
			#if .word ptr2 = #screen_mem+$F0
				mwa #screen_mem+$c8 ptr3
				jsr check_offscreen_internal
				rts
			#end
			#if .word ptr2 = #screen_mem+$118
				mwa #screen_mem+$f0 ptr3
				jsr check_offscreen_internal
				rts
			#end
			#if .word ptr2 = #screen_mem+$140
				mwa #screen_mem+$118 ptr3
				jsr check_offscreen_internal
				rts
			#end
			#if .word ptr2 = #screen_mem+$168
				mwa #screen_mem+$140 ptr3
				jsr check_offscreen_internal
				rts
			#end
			#if .word ptr2 = #screen_mem+$190
				mwa #screen_mem+$168 ptr3
				jsr check_offscreen_internal
				rts
			#end
			#if .word ptr2 = #screen_mem+$1b8
				mwa #screen_mem+$190 ptr3
				jsr check_offscreen_internal
				rts
			#end
			lda #0
			rts
			
generate_random_star
			sty tmp1
			ldy RANDOM
			lda random_stars,y
			ldy tmp1
			rts

; Return:
; Y=0 - don't move to next char
; Y=1 - move to next char
do_next_char
			ldy #1
			cmp #0
			bne @+
			lda RANDOM
			sec
			sbc #250
			bcc dnc1
			jsr generate_random_star
			rts
dnc1		lda #0
			rts

@			cmp #68
			bne @+
			lda #65
			rts
			
@			cmp #70
			bne @+
			lda #69
			rts
			
@			cmp #76
			bne @+
			lda #73
			rts

@			cmp #78
			bne @+
			lda #77
			rts

@			cmp #84
			bne @+
			lda #81
			rts

@			cmp #86
			bne @+
			lda #85
			rts

@			
			tay
			iny
			tya
			ldy #0
			rts
			
prepare_stars
			lda #>font_base
			sta CHBAS
			
			ldx #<stars_pos
			stx ptr0
			ldx #>stars_pos
			stx ptr0+1
			
			ldx #stars_count
			
ps0			ldy #0
			lda (ptr0),y
			sta ptr1
			iny
			lda (ptr0),y
			sta ptr1+1

			iny
			lda (ptr0),y
			ldy #0
			sta (ptr1),y
			
			dex
			beq @+
			
			adw ptr0 #4
			jmp ps0
			
@			rts

random_stars
:52			dta b(65)
:32			dta b(69)
:53			dta b(73)
:33			dta b(77)
:53			dta b(81)
:33			dta b(85)
			
stars_count	equ	11
stars_pos
			dta a(screen_mem),b(69),b(0)
			dta a(screen_mem+$28),b(69),b(0)
			dta a(screen_mem+$50),b(69),b(0)
			dta a(screen_mem+$78),b(69),b(0)
			dta a(screen_mem+$A0),b(69),b(0)
			dta a(screen_mem+$C8),b(69),b(0)
			dta a(screen_mem+$F0),b(69),b(0)
			dta a(screen_mem+$118),b(69),b(0)
			dta a(screen_mem+$140),b(69),b(0)
			dta a(screen_mem+$168),b(69),b(0)
			dta a(screen_mem+$190),b(69),b(0)

starquake	
			ldx <dl_starquake
			ldy >dl_starquake
			stx SDLSTL
			sty SDLSTL+1

			lda #112
			sta COLOR2
			lda #$fb
			sta COLOR1			
			
			; Remove kropla
			lda #0
			sta HPOSP3
			
			; Hide Rzygon
			lda #0
			sta xpos
			jsr position_rzygon
			
			lda revstat
			and #%00000001
			cmp #1
			beq @+
			jsr reverse_rzygon

@			jsr pause
			jsr pause
			jsr pause
			jsr pause
			jsr pause
			jsr pause
			
@			jsr sq_rzygon_right
			cmp #0
			beq @-
			
			jsr pause
			jsr reverse_rzygon
			jsr pause

@			jsr sq_rzygon_down
			cmp #0
			beq @-
			
			jsr pause
			jsr pause

@			jsr sq_sam_rzygon_left_up
			cmp #0
			beq @-
@			jsr sq_sam_rzygon_left_down
			cmp #0
			beq @-
@			jsr sq_sam_rzygon_down_offscreen
			cmp #0
			beq @-
			
			rts
			
sq_sam_rzygon_down_offscreen
			jsr delay
			jsr delay
			jsr sq_sam_rzygon_down
			inc ypos
			lda ypos
			cmp #$8e
			beq @+
			lda #0
@			rts
			
sq_sam_rzygon_left_up
			jsr delay
			jsr delay
			jsr delay
			jsr delay
			jsr sq_sam_rzygon_up
			jsr sq_sam_rzygon_up
			dec xpos
			lda xpos
			sta HPOSP2
			dec ypos
			lda ypos
			cmp #$2a
			beq @+
			lda #0
@			rts

sq_sam_rzygon_left_down
			jsr delay
			jsr delay
			jsr delay
			jsr delay
			jsr sq_sam_rzygon_down
			jsr sq_sam_rzygon_down
			dec xpos
			lda xpos
			sta HPOSP2
			inc ypos
			lda ypos
			cmp #$33
			beq @+
			lda #0
@			rts
			
sq_sam_rzygon_up
			ldy #1
@			lda rzygon_sprite_data,y
			dey
			sta rzygon_sprite_data,y
			iny
			iny
			cpy #254
			bne @-
			rts
		
sq_sam_rzygon_down
			ldy #254
			ldy #200-1
@			lda rzygon_sprite_data,y
			iny
			sta rzygon_sprite_data,y
			dey
			dey
			cpy #0
			bne @-
			rts
		
sq_rzygon_down
			inc ypos
			jsr full_rzygon_down
			jsr delay
			jsr delay
			jsr delay
			lda ypos
			cmp #$33
			beq @+
			lda #0
@			rts

full_rzygon_down
			ldy #254
@			lda PMG_P0,y
			iny
			sta PMG_P0,y
			dey
			lda PMG_P1,y
			iny
			sta PMG_P1,y
			dey
			lda rzygon_sprite_data,y
			iny
			sta rzygon_sprite_data,y
			
			dey
			dey
			cpy #0
			bne @-
			rts
			
sq_rzygon_right
			inc xpos
			lda xpos
			jsr position_rzygon
			jsr delay
			jsr delay
			jsr delay
			lda xpos
			cmp #$6f
			beq @+
			lda #0
@			rts

pause
		ldx #200
@		jsr delay
		dex
		cpx #0
		bne @-
		rts

synchro
		lda COLPM2
		cmp #1
		bne synchr1
		; PAL
		lda #$68
		jmp synchr2
synchr1 ; NTSC
		lda #$7c
synchr2	cmp VCOUNT
		bne synchr2
		rts
		
delay
		jsr synchro
		rts
	
rzygon_sinus_right
		dta b(176)
		dta b(176)
		dta b(176)
		dta b(176)
		dta b(176)
		dta b(175)
		dta b(175)
		dta b(175)
		dta b(175)
		dta b(174)
		dta b(174)
		dta b(173)
		dta b(173)
		dta b(172)
		dta b(172)
		dta b(171)
		dta b(171)
		dta b(170)
		dta b(169)
		dta b(168)
		dta b(168)
		dta b(167)
		dta b(166)
		dta b(165)
		dta b(164)
		dta b(163)
		dta b(162)
		dta b(161)
		dta b(160)
		dta b(159)
		dta b(158)
		dta b(157)
		dta b(156)
		dta b(154)
		dta b(153)
		dta b(152)
		dta b(151)
		dta b(149)
		dta b(148)
		dta b(147)
		dta b(145)
		dta b(144)
		dta b(142)
		dta b(141)
		dta b(139)
		dta b(138)
		dta b(137)
		dta b(135)
		dta b(134)
		dta b(132)
		dta b(130)
		dta b(129)
		dta b(127)
		dta b(126)
		dta b(124)
		dta b(123)
		dta b(121)
		dta b(120)
		dta b(118)
		dta b(116)
		dta b(115)
		dta b(113)
		dta b(112)
		dta b(110)
		dta b(109)
		dta b(107)
		dta b(106)
		dta b(104)
		dta b(102)
		dta b(101)
		dta b(99)
		dta b(98)
		dta b(97)
		dta b(95)
		dta b(94)
		dta b(92)
		dta b(91)
		dta b(89)
		dta b(88)
		dta b(87)
		dta b(85)
		dta b(84)
		dta b(83)
		dta b(82)
		dta b(80)
		dta b(79)
		dta b(78)
		dta b(77)
		dta b(76)
		dta b(75)
		dta b(74)
		dta b(73)
		dta b(72)
		dta b(71)
		dta b(70)
		dta b(69)
		dta b(68)
		dta b(68)
		dta b(67)
		dta b(66)
		dta b(65)
		dta b(65)
		dta b(64)
		dta b(64)
		dta b(63)
		dta b(63)
		dta b(62)
		dta b(62)
		dta b(61)
		dta b(61)
		dta b(61)
		dta b(61)
		dta b(60)
		dta b(60)
		dta b(60)
		dta b(60)
		dta b(60)	; #116

bit_mirror_lut
		dta b(0),b(128),b(64),b(192),b(32),b(160),b(96),b(224),b(16),b(144),b(80),b(208),b(48),b(176),b(112),b(240),b(8),b(136),b(72),b(200),b(40),b(168),b(104),b(232),b(24),b(152),b(88),b(216),b(56),b(184),b(120),b(248),b(4),b(132),b(68),b(196),b(36),b(164),b(100),b(228),b(20),b(148),b(84),b(212),b(52),b(180),b(116),b(244),b(12),b(140),b(76),b(204),b(44),b(172),b(108),b(236),b(28),b(156),b(92),b(220),b(60),b(188),b(124),b(252),b(2),b(130),b(66),b(194),b(34),b(162),b(98),b(226),b(18),b(146),b(82),b(210),b(50),b(178),b(114),b(242),b(10),b(138),b(74),b(202),b(42),b(170),b(106),b(234),b(26),b(154),b(90),b(218),b(58),b(186),b(122),b(250),b(6),b(134),b(70),b(198),b(38),b(166),b(102),b(230),b(22),b(150),b(86),b(214),b(54),b(182),b(118),b(246),b(14),b(142),b(78),b(206),b(46),b(174),b(110),b(238),b(30),b(158),b(94),b(222),b(62),b(190),b(126),b(254),b(1),b(129),b(65),b(193),b(33),b(161),b(97),b(225),b(17),b(145),b(81),b(209),b(49),b(177),b(113),b(241),b(9),b(137),b(73),b(201),b(41),b(169),b(105),b(233),b(25),b(153),b(89),b(217),b(57),b(185),b(121),b(249),b(5),b(133),b(69),b(197),b(37),b(165),b(101),b(229),b(21),b(149),b(85),b(213),b(53),b(181),b(117),b(245),b(13),b(141),b(77),b(205),b(45),b(173),b(109),b(237),b(29),b(157),b(93),b(221),b(61),b(189),b(125),b(253),b(3),b(131),b(67),b(195),b(35),b(163),b(99),b(227),b(19),b(147),b(83),b(211),b(51),b(179),b(115),b(243),b(11),b(139),b(75),b(203),b(43),b(171),b(107),b(235),b(27),b(155),b(91),b(219),b(59),b(187),b(123),b(251),b(7),b(135),b(71),b(199),b(39),b(167),b(103),b(231),b(23),b(151),b(87),b(215),b(55),b(183),b(119),b(247),b(15),b(143),b(79),b(207),b(47),b(175),b(111),b(239),b(31),b(159),b(95),b(223),b(63),b(191),b(127),b(255)
		
; Pliterki:
;e - 125
;o - 93
;a - 127
;s - 92
;l - 95
;z - 91
;x - 123
;c - 126
;n - 94
		
cdn_strings
		dta d"    ",b(87),"i",b(127),"g ",b(88),"alszy     "
		dta d"      "*,b(80+128),"ast"*,b(127+128),"pi       "*
credits_0u
		dta d"Ale",b(91)," ",b(92),"liczny kosmos...                  ",b($9b)
credits_0d
		dta d"            ...i tyle dziewiczych planet",b($9b)
		dta d"Chyba pora zacz",b(127),b(126),"...                    ",b($9b)
		dta d"       ...skraplanie Sokiem Stworzyciela",b($9b)
		dta d"Tylko w ten spos",b(93),"b odbudujemy...        ",b($9b)
		dta d"       ...pot",b(125),"g",b(125)," wspania",b(95),"ego katolicyzmu",b($9b)
		dta d"I raz na zawsze...                      ",b($9b)
		dta d"   ...rozprawimy si",b(125)," z kryzysem powo",b(95),"a",b(94),"!",b($9b)
		dta d"                                        ",b($9b)
		dta d"                                        ",b($9b)
credits_1u
		dta d"Pomys",b(95),", idea, koncepcja, inicjatywa:    ",b($9b)
credits_1d
		dta d"                          mgr in",b(91),". Rafa",b(95),b($9b)
		dta d"Kod, projekt, implementacja, testy:     ",b($9b)
		dta d"                          mgr in",b(91),". Rafa",b(95),b($9b)
		dta d"Kompilacja, integracja, masturbacja:    ",b($9b)
		dta d"                          mgr in",b(91),". Rafa",b(95),b($9b)
		dta d"Ud",b(123),"wi",b(125),"kowienie:                         ",b($9b)
		dta d"                                     WnZ",b($9b)
		dta d"Dodatkowa muzyka:                       ",b($9b)
		dta d"                                   Cedy",b(94),b($9b)
		dta d"Grafika:                                ",b($9b)
		dta d"                          mgr in",b(91),". Rafa",b(95),b($9b)
		dta d"Obrazek tytu",b(95),"owy i cut-sceny:           ",b($9b)
		dta d"                                     eZp",b($9b)
		dta d"Animacja bohatera:                      ",b($9b)
		dta d"                                   Vidol",b($9b)
		dta d"Dodatkowa grafika:                      ",b($9b)
		dta d"                           Secon, Hospes",b($9b)
		dta d"Testy i weryfikacja:                    ",b($9b)
		dta d"                           mgr Katarzyna",b($9b)
		dta d"Walidacja i akceptacja:                 ",b($9b)
		dta d"             Ku",b(92),"tyga-Matyjasek aka Zeniu",b($9b)
		dta d"Cz",b(125),b(92),b(126)," grafik po",b(91),"yczono z gier na ZX:    ",b($9b)
		dta d"  Camelot Warriors, Agent X2, Spellbound",b($9b)
		dta d"Biogen, Biff                            ",b($9b)
		dta d"        Amazing Adventures of Robin Hood",b($9b)
		dta d"Beyond the Ice Palace, Bloody Paws      ",b($9b)
		dta d"          Bloody, Army Moves, Cauldron 2",b($9b)
		dta d"Addams Family                           ",b($9b)
		dta d"                  Abu Simbel Profanation",b($9b)
		dta d"Cz",b(125),b(92),b(126)," grafik po",b(91),"yczono z gier na Atari: ",b($9b)
		dta d"                Roderic, Gruczo",b(95)," Grubasa",b($9b)
		dta d"Biedny Pies Antoni                      ",b($9b)
		dta d"                      H.E.R.O, Starquake",b($9b)
		dta d"Ostateczie w rysowaniu                  ",b($9b)
		dta d"                    pomaga",b(95)," te",b(91)," Internet",b($9b)
		dta d"Dodatkowe podzi",b(125),"kowania dla:            ",b($9b)
		dta d"Ajcek [VBXE]   JAC! [WUDSN]  tebe [MADS]",b($9b)
		dta d"             Avery Lee/Phaeron [Altirra]",b($9b)
		dta d"Greblus [konfiguracja emulatora]        ",b($9b)
		dta d"I jeszcze pozdrowienia dla:             ",b($9b)
		dta d"              sOnar, mono, Gzynio, miker",b($9b)
		dta d"CharlieChaplin, xxl, pin                ",b($9b)
		dta d"                marekp, MaW, Adam, Sikor",b($9b)
		dta d"nosty, Kuba Husak, pirx                 ",b($9b)
		dta d"                 IRATA4, Koala, Lotharek",b($9b)
		dta d"xeen, larek, bartcom, MWK               ",b($9b)
		dta d"                Dubmood, Sinny, Ghidorah",b($9b)
		dta d"atarionline.pl                          ",b($9b)
		dta d"                        www.atari.org.pl",b($9b)
		dta d"     Dzi",b(125),"kuj",b(125)," te",b(91)," wszystkim, kt",b(93),"rzy     ",b($9b)
		dta d"deklarowali pomoc, ale im si",b(125)," odechcia",b(95),"o",b($9b)
		dta d"                                        ",b($9b)
		dta d"                                        ",b($9b)
		dta d"Aha, pode mn",b(127)," p",b(95),"odna planeta...         ",b($9b)
		dta d"              ...najwy",b(91),"szy czas l",b(127),"dowa",b(126),"!",b($9b)
		dta d"                                        ",b($9b)
		dta d"             Wci",b(92),"nij ",b(96),"HELP",b(96),"             ",b($9b)
		dta b($ff)

vbi_routine
		jsr RASTERMUSICTRACKER+3	;Play
		jmp XITVBV
		
		
			org pmg_base+$400
			; Player 0
PMG_P0
:78			dta b($00)
:2			dta b(0)
:2			dta b(1)
:2			dta b(3)
:2			dta b(1)
:2			dta b(0)
:2			dta b(3)
:2			dta b(28)
:2			dta b(32)
:2			dta b(65)
:2			dta b(129)
:2			dta b(135)
:2			dta b(135)
:2			dta b(129)
:2			dta b(65)
:2			dta b(65)
:2			dta b(65)
:2			dta b(33)
:2			dta b(33)
:2			dta b(32)
:2			dta b(16)
:2			dta b(8)
:2			dta b(15)
:2			dta b(31)
:2			dta b(31)
:130		dta b($00)
			; Player 1
PMG_P1
:78			dta b($00)
:2			dta b(128)
:2			dta b(128)
:2			dta b(192)
:2			dta b(128)
:2			dta b(128)
:2			dta b(224)
:2			dta b(24)
:2			dta b(4)
:2			dta b(130)
:2			dta b(129)
:2			dta b(229)
:2			dta b(229)
:2			dta b(133)
:2			dta b(138)
:2			dta b(138)
:2			dta b(138)
:2			dta b(148)
:2			dta b(148)
:2			dta b(20)
:2			dta b(40)
:2			dta b(16)
:2			dta b(240)
:2			dta b(248)
:2			dta b(248)
:130		dta b($00)
			; Player 2
rzygon_sprite_data
:59			dta b($00)
			dta b(8)
			dta b(28)
			dta b(8)
			dta b(28)
			dta b(28)
			dta b(0)
			dta b(28)
			dta b(44)
			dta b(28)
			dta b(8)
			dta b(28)
			dta b(20)
			dta b(62)
			dta b(58)
			dta b(63)
			dta b(93)
			dta b(95)
			dta b(62)
			dta b(62)
			dta b(127)
			dta b(127)
			dta b(65)
			dta b(195)
			dta b(0)
:172		dta b($00)
			; Player 3
kropla_sprite
:256		dta b(0)

			org $9000
dl_starquake
:6			dta b(%01110000)					; x6 blank 8
			dta b($4f)							; mode F @ A1F0
			dta a($a1f0)
:89			dta b($f)							; x45 mode F
			dta b($4f)							; mode F @ B000
			dta a($b000)
:54			dta b($f)
			dta b($41),a(dl_starquake)
dl_starquake_len	equ *-dl_starquake
dl_flight
:3			dta b(%01110000)					; x3 blank 8
			dta b($45)
			dta a(screen_mem)
:9			dta b($5)
			dta b(%10000101)
			dta b(%10000010)
			dta b($2)
			dta b($2)
			dta b($41),a(dl_flight)
dl_flight_len	equ *-dl_flight
dl_cdn
:12			dta b(%01110000)					; x3 blank 8
			dta b(%01000111)
			dta a(screen_mem)
			dta b(%01110000)
			dta b($7)
			dta b($41),a(dl_flight)
dl_cdn_len	equ *-dl_flight

; RMT player
	icl "rmtplayr.a65"
; RMT module
	opt h-						;RMT module is standard Atari binary file already
	ins "ending.rmt"				;include music RMT module
	opt h+
MODUL equ $5000

 		
; Include screen memory from Starquake
	org $a1f0
;	ins '../../Design/starquake-dump/screen.txt'
	ins 'screen.txt'
; Include font for Flight
	org font_base
	ins 'flight.fnt'
; Clear panel screen memory by loading 0's :)
	org screen_mem+440
:120 		dta b(0)
	org $02e0
	dta a($2c20)

; TODO:

;	@com.wudsn.ide.asm.mainsourcefile=main.asm

pmg_hero		equ	sprite_mem+$400
pmg_item1		equ	sprite_mem+$500
pmg_item2		equ	sprite_mem+$600
pmg_item3		equ	sprite_mem+$700
pmg_item4		equ	sprite_mem+$300			; Missiles

; Puts all the sprites (except main hero) off screen
.proc hide_sprites
				ldy #0
				sty HPOSP1
				sty HPOSP2
				sty HPOSP3
				sty HPOSM0
				sty HPOSM1
				sty HPOSM2
				sty HPOSM3
				rts
.endp

; Clears memory used by sprites
; Saves hero data if necessary.
.proc clear_sprites_memory
				pha
				; if a=1, don't clear hero
				hide_sprites
				ldy #0
				mwa #pmg_item4 screen_tmp
csm_2			lda #0
				sta (screen_tmp),y
				#if .word screen_tmp == #pmg_hero
					jmp csm_1
				#end
				inw screen_tmp
				jmp csm_2
csm_1			pla
				#if .byte @ == 1
					mwa #pmg_item1 screen_tmp
				#else
					mwa #pmg_hero screen_tmp
					sty HPOSP0
				#end
csm_0			lda #0
 				sta (screen_tmp),y
 				inw screen_tmp
				#if .word screen_tmp == #pmg_item3+$100
					rts
				#end
				jmp csm_0
.endp

; Moves sprite 0 one row down
; TODO: Parametrize when other sprites will require to move
.proc sprite_0_down
				ldy #$fe
@				lda pmg_hero,y
				iny
				sta pmg_hero,y
				dey
				dey
				cpy #$ff
				bne @-
				rts
.endp

; Moves sprite 0 one row up
; TODO: Parametrize when other sprites will require to move
.proc sprite_0_up
				ldy #$1
@				lda pmg_hero,y
				dey
				sta pmg_hero,y
				iny
				iny
				cpy #$0
				bne @-
				rts
.endp

; Initializes the sprites used during the game
.proc setup_sprites
				lda #0
				clear_sprites_memory
				ldy #0
				sty SIZEP0
				sty SIZEP1
				sty SIZEP2
				sty SIZEP3
				
				draw_hero
				enable_sprites
				rts
.endp

; Enable sprites
.proc enable_sprites
				lda #>sprite_mem
				sta PMBASE
		
				lda #%00000011
				sta GRACTL

				lda SDMCTL
				ora #%00011100
				sta SDMCTL
				
				lda #%00010001
				sta GPRIOR
				
				synchro
		
				rts
.endp

; Checks collisions between player and items.
; Number of item being in contact is returned in Y
.proc check_collisions
				ldy #0
				lda P0PL
				cmp #%00000010
				beq cc_itm1
				cmp #%00000100
				beq cc_itm2
				cmp #%00001000
				beq cc_itm3
				lda M0PL
				cmp #0
				bne cc_itm4
				lda M1PL
				cmp #0
				bne cc_itm4
				lda M2PL
				cmp #0
				bne cc_itm4
				lda M3PL
				cmp #0
				bne cc_itm4
				jmp cc_X
cc_itm1			ldy #1
				jmp cc_X	
cc_itm2			ldy #2
				jmp cc_X
cc_itm3			ldy #3
				jmp cc_X		
cc_itm4			ldy #4				
cc_X			sty ITEM_CONTACT_S
				sta HITCLR
				rts
.endp

hero_data_standing
				dta b(0),b(8),b(28),b(8),b(28),b(28),b(0),b(28)
				dta b(42),b(20),b(8),b(28),b(20),b(62),b(62),b(62)
				dta b(93),b(93),b(62),b(62),b(126),b(126),b(66),b(195)

				dta b(0),b(8),b(28),b(8),b(28),b(28),b(0),b(28)
				dta b(42),b(20),b(8),b(28),b(20),b(62),b(62),b(62)
				dta b(93),b(93),b(62),b(62),b(126),b(94),b(194),b(3)
hero_data_standing_finish

hero_data_dead_standing
				dta b(0),b(8),b(28),b(8),b(28),b(28),b(0),b(28)
				dta b(8),b(20),b(8),b(12),b(30),b(100),b(74),b(6)
				dta b(12),b(6),b(14),b(18),b(18),b(33),b(33),b(99)

				dta b(0),b(8),b(28),b(8),b(28),b(28),b(0),b(28)
				dta b(8),b(20),b(8),b(12),b(30),b(100),b(74),b(6)
				dta b(12),b(6),b(14),b(18),b(34),b(33),b(97),b(3)
hero_data_dead_standing_finish

bit_mirror_lut
		dta b(0),b(128),b(64),b(192),b(32),b(160),b(96),b(224),b(16),b(144),b(80),b(208),b(48),b(176),b(112),b(240),b(8),b(136),b(72),b(200),b(40),b(168),b(104),b(232),b(24),b(152),b(88),b(216),b(56),b(184),b(120),b(248),b(4),b(132),b(68),b(196),b(36),b(164),b(100),b(228),b(20),b(148),b(84),b(212),b(52),b(180),b(116),b(244),b(12),b(140),b(76),b(204),b(44),b(172),b(108),b(236),b(28),b(156),b(92),b(220),b(60),b(188),b(124),b(252),b(2),b(130),b(66),b(194),b(34),b(162),b(98),b(226),b(18),b(146),b(82),b(210),b(50),b(178),b(114),b(242),b(10),b(138),b(74),b(202),b(42),b(170),b(106),b(234),b(26),b(154),b(90),b(218),b(58),b(186),b(122),b(250),b(6),b(134),b(70),b(198),b(38),b(166),b(102),b(230),b(22),b(150),b(86),b(214),b(54),b(182),b(118),b(246),b(14),b(142),b(78),b(206),b(46),b(174),b(110),b(238),b(30),b(158),b(94),b(222),b(62),b(190),b(126),b(254),b(1),b(129),b(65),b(193),b(33),b(161),b(97),b(225),b(17),b(145),b(81),b(209),b(49),b(177),b(113),b(241),b(9),b(137),b(73),b(201),b(41),b(169),b(105),b(233),b(25),b(153),b(89),b(217),b(57),b(185),b(121),b(249),b(5),b(133),b(69),b(197),b(37),b(165),b(101),b(229),b(21),b(149),b(85),b(213),b(53),b(181),b(117),b(245),b(13),b(141),b(77),b(205),b(45),b(173),b(109),b(237),b(29),b(157),b(93),b(221),b(61),b(189),b(125),b(253),b(3),b(131),b(67),b(195),b(35),b(163),b(99),b(227),b(19),b(147),b(83),b(211),b(51),b(179),b(115),b(243),b(11),b(139),b(75),b(203),b(43),b(171),b(107),b(235),b(27),b(155),b(91),b(219),b(59),b(187),b(123),b(251),b(7),b(135),b(71),b(199),b(39),b(167),b(103),b(231),b(23),b(151),b(87),b(215),b(55),b(183),b(119),b(247),b(15),b(143),b(79),b(207),b(47),b(175),b(111),b(239),b(31),b(159),b(95),b(223),b(63),b(191),b(127),b(255)
		
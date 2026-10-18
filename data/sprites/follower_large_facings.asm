; 24x24 custom follower OAM facings; only for the three Johto starter prototypes.
; Base tile $65 selects 27 standing tiles in VRAM bank 0 ($65..$7f).
; Walking tiles use base $65 plus offsets $78..$92 in VRAM bank 1.
; Bank-1 $f8..$ff belongs to Crystal's emote/shadow/grass effects.
; Select OAM_BANK1 on each walking tile, not on the whole facing:
; alternate side strides combine walking bodies with standing foot tiles.
; Center on the player's 16px footprint and align feet at y=+16.
; Standing and walking poses share a grounded Y anchor (no artificial hop).
FollowerLargeFacings:
	table_width 2
	dw Follower24DownStand
	dw Follower24DownWalk
	dw Follower24DownStand
	dw Follower24DownWalkFlip
	dw Follower24UpStand
	dw Follower24UpWalk
	dw Follower24UpStand
	dw Follower24UpWalkFlip
	dw Follower24LeftStand
	dw Follower24LeftWalk
	dw Follower24LeftStand
	dw Follower24LeftWalkAlt
	dw Follower24RightStand
	dw Follower24RightWalk
	dw Follower24RightStand
	dw Follower24RightWalkAlt
	assert_table_length FACING_FISH_DOWN

Follower24DownStand:
	db 9
	db  -8,  -4, RELATIVE_ATTRIBUTES, $00
	db  -8,   4, RELATIVE_ATTRIBUTES, $01
	db  -8,  12, RELATIVE_ATTRIBUTES, $02
	db   0,  -4, RELATIVE_ATTRIBUTES, $03
	db   0,   4, RELATIVE_ATTRIBUTES, $04
	db   0,  12, RELATIVE_ATTRIBUTES, $05
	db   8,  -4, RELATIVE_ATTRIBUTES, $06
	db   8,   4, RELATIVE_ATTRIBUTES, $07
	db   8,  12, RELATIVE_ATTRIBUTES, $08

Follower24DownWalk:
	db 9
	db  -8,  -4, RELATIVE_ATTRIBUTES | OAM_BANK1, $78
	db  -8,   4, RELATIVE_ATTRIBUTES | OAM_BANK1, $79
	db  -8,  12, RELATIVE_ATTRIBUTES | OAM_BANK1, $7a
	db   0,  -4, RELATIVE_ATTRIBUTES | OAM_BANK1, $7b
	db   0,   4, RELATIVE_ATTRIBUTES | OAM_BANK1, $7c
	db   0,  12, RELATIVE_ATTRIBUTES | OAM_BANK1, $7d
	db   8,  -4, RELATIVE_ATTRIBUTES | OAM_BANK1, $7e
	db   8,   4, RELATIVE_ATTRIBUTES | OAM_BANK1, $7f
	db   8,  12, RELATIVE_ATTRIBUTES | OAM_BANK1, $80

Follower24DownWalkFlip:
	db 9
	db  -8,  -4, RELATIVE_ATTRIBUTES | OAM_XFLIP | OAM_BANK1, $7a
	db  -8,   4, RELATIVE_ATTRIBUTES | OAM_XFLIP | OAM_BANK1, $79
	db  -8,  12, RELATIVE_ATTRIBUTES | OAM_XFLIP | OAM_BANK1, $78
	db   0,  -4, RELATIVE_ATTRIBUTES | OAM_XFLIP | OAM_BANK1, $7d
	db   0,   4, RELATIVE_ATTRIBUTES | OAM_XFLIP | OAM_BANK1, $7c
	db   0,  12, RELATIVE_ATTRIBUTES | OAM_XFLIP | OAM_BANK1, $7b
	db   8,  -4, RELATIVE_ATTRIBUTES | OAM_XFLIP | OAM_BANK1, $80
	db   8,   4, RELATIVE_ATTRIBUTES | OAM_XFLIP | OAM_BANK1, $7f
	db   8,  12, RELATIVE_ATTRIBUTES | OAM_XFLIP | OAM_BANK1, $7e

Follower24UpStand:
	db 9
	db  -8,  -4, RELATIVE_ATTRIBUTES, $09
	db  -8,   4, RELATIVE_ATTRIBUTES, $0a
	db  -8,  12, RELATIVE_ATTRIBUTES, $0b
	db   0,  -4, RELATIVE_ATTRIBUTES, $0c
	db   0,   4, RELATIVE_ATTRIBUTES, $0d
	db   0,  12, RELATIVE_ATTRIBUTES, $0e
	db   8,  -4, RELATIVE_ATTRIBUTES, $0f
	db   8,   4, RELATIVE_ATTRIBUTES, $10
	db   8,  12, RELATIVE_ATTRIBUTES, $11

Follower24UpWalk:
	db 9
	db  -8,  -4, RELATIVE_ATTRIBUTES | OAM_BANK1, $81
	db  -8,   4, RELATIVE_ATTRIBUTES | OAM_BANK1, $82
	db  -8,  12, RELATIVE_ATTRIBUTES | OAM_BANK1, $83
	db   0,  -4, RELATIVE_ATTRIBUTES | OAM_BANK1, $84
	db   0,   4, RELATIVE_ATTRIBUTES | OAM_BANK1, $85
	db   0,  12, RELATIVE_ATTRIBUTES | OAM_BANK1, $86
	db   8,  -4, RELATIVE_ATTRIBUTES | OAM_BANK1, $87
	db   8,   4, RELATIVE_ATTRIBUTES | OAM_BANK1, $88
	db   8,  12, RELATIVE_ATTRIBUTES | OAM_BANK1, $89

Follower24UpWalkFlip:
	db 9
	db  -8,  -4, RELATIVE_ATTRIBUTES | OAM_XFLIP | OAM_BANK1, $83
	db  -8,   4, RELATIVE_ATTRIBUTES | OAM_XFLIP | OAM_BANK1, $82
	db  -8,  12, RELATIVE_ATTRIBUTES | OAM_XFLIP | OAM_BANK1, $81
	db   0,  -4, RELATIVE_ATTRIBUTES | OAM_XFLIP | OAM_BANK1, $86
	db   0,   4, RELATIVE_ATTRIBUTES | OAM_XFLIP | OAM_BANK1, $85
	db   0,  12, RELATIVE_ATTRIBUTES | OAM_XFLIP | OAM_BANK1, $84
	db   8,  -4, RELATIVE_ATTRIBUTES | OAM_XFLIP | OAM_BANK1, $89
	db   8,   4, RELATIVE_ATTRIBUTES | OAM_XFLIP | OAM_BANK1, $88
	db   8,  12, RELATIVE_ATTRIBUTES | OAM_XFLIP | OAM_BANK1, $87

Follower24LeftStand:
	db 9
	db  -8,  -4, RELATIVE_ATTRIBUTES, $12
	db  -8,   4, RELATIVE_ATTRIBUTES, $13
	db  -8,  12, RELATIVE_ATTRIBUTES, $14
	db   0,  -4, RELATIVE_ATTRIBUTES, $15
	db   0,   4, RELATIVE_ATTRIBUTES, $16
	db   0,  12, RELATIVE_ATTRIBUTES, $17
	db   8,  -4, RELATIVE_ATTRIBUTES, $18
	db   8,   4, RELATIVE_ATTRIBUTES, $19
	db   8,  12, RELATIVE_ATTRIBUTES, $1a

Follower24LeftWalk:
	db 9
	db  -8,  -4, RELATIVE_ATTRIBUTES | OAM_BANK1, $8a
	db  -8,   4, RELATIVE_ATTRIBUTES | OAM_BANK1, $8b
	db  -8,  12, RELATIVE_ATTRIBUTES | OAM_BANK1, $8c
	db   0,  -4, RELATIVE_ATTRIBUTES | OAM_BANK1, $8d
	db   0,   4, RELATIVE_ATTRIBUTES | OAM_BANK1, $8e
	db   0,  12, RELATIVE_ATTRIBUTES | OAM_BANK1, $8f
	db   8,  -4, RELATIVE_ATTRIBUTES | OAM_BANK1, $90
	db   8,   4, RELATIVE_ATTRIBUTES | OAM_BANK1, $91
	db   8,  12, RELATIVE_ATTRIBUTES | OAM_BANK1, $92

Follower24RightStand:
	db 9
	db  -8,  -4, RELATIVE_ATTRIBUTES | OAM_XFLIP, $14
	db  -8,   4, RELATIVE_ATTRIBUTES | OAM_XFLIP, $13
	db  -8,  12, RELATIVE_ATTRIBUTES | OAM_XFLIP, $12
	db   0,  -4, RELATIVE_ATTRIBUTES | OAM_XFLIP, $17
	db   0,   4, RELATIVE_ATTRIBUTES | OAM_XFLIP, $16
	db   0,  12, RELATIVE_ATTRIBUTES | OAM_XFLIP, $15
	db   8,  -4, RELATIVE_ATTRIBUTES | OAM_XFLIP, $1a
	db   8,   4, RELATIVE_ATTRIBUTES | OAM_XFLIP, $19
	db   8,  12, RELATIVE_ATTRIBUTES | OAM_XFLIP, $18

Follower24RightWalk:
	db 9
	db  -8,  -4, RELATIVE_ATTRIBUTES | OAM_XFLIP | OAM_BANK1, $8c
	db  -8,   4, RELATIVE_ATTRIBUTES | OAM_XFLIP | OAM_BANK1, $8b
	db  -8,  12, RELATIVE_ATTRIBUTES | OAM_XFLIP | OAM_BANK1, $8a
	db   0,  -4, RELATIVE_ATTRIBUTES | OAM_XFLIP | OAM_BANK1, $8f
	db   0,   4, RELATIVE_ATTRIBUTES | OAM_XFLIP | OAM_BANK1, $8e
	db   0,  12, RELATIVE_ATTRIBUTES | OAM_XFLIP | OAM_BANK1, $8d
	db   8,  -4, RELATIVE_ATTRIBUTES | OAM_XFLIP | OAM_BANK1, $92
	db   8,   4, RELATIVE_ATTRIBUTES | OAM_XFLIP | OAM_BANK1, $91
	db   8,  12, RELATIVE_ATTRIBUTES | OAM_XFLIP | OAM_BANK1, $90

; A second side-walking phase assembled from the existing 24x24 assets.
; The standing foot-row supplies a different contact silhouette without
; adding VRAM tiles. A future fully hand-drawn stride can replace this.
Follower24LeftWalkAlt:
	db 9
	db  -8,  -4, RELATIVE_ATTRIBUTES | OAM_BANK1, $8a
	db  -8,   4, RELATIVE_ATTRIBUTES | OAM_BANK1, $8b
	db  -8,  12, RELATIVE_ATTRIBUTES | OAM_BANK1, $8c
	db   0,  -4, RELATIVE_ATTRIBUTES | OAM_BANK1, $8d
	db   0,   4, RELATIVE_ATTRIBUTES | OAM_BANK1, $8e
	db   0,  12, RELATIVE_ATTRIBUTES | OAM_BANK1, $8f
	db   8,  -4, RELATIVE_ATTRIBUTES, $18
	db   8,   4, RELATIVE_ATTRIBUTES, $19
	db   8,  12, RELATIVE_ATTRIBUTES, $1a

Follower24RightWalkAlt:
	db 9
	db  -8,  -4, RELATIVE_ATTRIBUTES | OAM_XFLIP | OAM_BANK1, $8c
	db  -8,   4, RELATIVE_ATTRIBUTES | OAM_XFLIP | OAM_BANK1, $8b
	db  -8,  12, RELATIVE_ATTRIBUTES | OAM_XFLIP | OAM_BANK1, $8a
	db   0,  -4, RELATIVE_ATTRIBUTES | OAM_XFLIP | OAM_BANK1, $8f
	db   0,   4, RELATIVE_ATTRIBUTES | OAM_XFLIP | OAM_BANK1, $8e
	db   0,  12, RELATIVE_ATTRIBUTES | OAM_XFLIP | OAM_BANK1, $8d
	db   8,  -4, RELATIVE_ATTRIBUTES | OAM_XFLIP, $1a
	db   8,   4, RELATIVE_ATTRIBUTES | OAM_XFLIP, $19
	db   8,  12, RELATIVE_ATTRIBUTES | OAM_XFLIP, $18

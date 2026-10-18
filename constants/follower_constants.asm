; Dedicated follower graphics constants.
; Include after the standard sprite/species/palette constants.

DEF FOLLOWER_SPRITE_TILES      EQU 12
DEF FOLLOWER_GFX_HALVES        EQU 2
DEF FOLLOWER_GFX_BYTES         EQU FOLLOWER_SPRITE_TILES * TILE_SIZE * FOLLOWER_GFX_HALVES
DEF FOLLOWER_GFX_ENTRY_SIZE    EQU 4 ; bank, pointer, overworld palette

; 24x24 format: 3x3 OBJ tiles per pose, three facing poses per half.
; Two halves = six poses * 9 tiles * 16 bytes = 864 bytes.
DEF FOLLOWER_LARGE_FRAME_TILES EQU 9
DEF FOLLOWER_LARGE_HALF_TILES EQU 3 * FOLLOWER_LARGE_FRAME_TILES
DEF FOLLOWER_LARGE_BYTES EQU 2 * FOLLOWER_LARGE_HALF_TILES * TILE_SIZE
; Reserve room for either legacy or large sprites. Other species remain 384 bytes.
DEF FOLLOWER_RESERVED_TILES EQU FOLLOWER_LARGE_HALF_TILES

; Reserve $e5..$ff of the bank-0 sprite tile table for follower graphics.
; The tile attribute bank still follows the existing follower sprite path.
; This allocation is larger than the original 12-tile reservation ($f4..$ff).
DEF FOLLOWER_VTILE             EQU $100 - FOLLOWER_RESERVED_TILES ; $e5
DEF FOLLOWER_VRAM_TILE         EQU FOLLOWER_VTILE & $7f         ; $65

; Large follower walking graphics live in bank 1 at $dd..$f7.
; Crystal's emote/shadow/rustle graphics occupy bank 1 $f8..$ff.
; Legacy 16x16 sheets use the original bank-1 $e5..$f0 range instead.
DEF FOLLOWER_LARGE_WALK_VTILE  EQU $f8 - FOLLOWER_LARGE_HALF_TILES ; $dd
DEF FOLLOWER_LARGE_WALK_OFFSET EQU FOLLOWER_LARGE_WALK_VTILE - FOLLOWER_VRAM_TILE ; $78
assert FOLLOWER_LARGE_WALK_VTILE + FOLLOWER_LARGE_HALF_TILES == $f8
assert FOLLOWER_LARGE_WALK_VTILE >= $80
assert FOLLOWER_LARGE_WALK_OFFSET == $78

; A normal walking sprite uses one copy at tile n in bank 1 and
; its walking graphics at tile $80+n in bank 1. Keep the first
; normal sprite table below $5d to protect large follower strides
; at $dd..$f7, without relying on the order of map sprite loading.
DEF FOLLOWER_NORMAL_FIRST_TABLE_LIMIT EQU FOLLOWER_LARGE_WALK_VTILE - $80 ; $5d
assert FOLLOWER_NORMAL_FIRST_TABLE_LIMIT == $5d
DEF FOLLOWER_VTILE_END         EQU FOLLOWER_VTILE + FOLLOWER_RESERVED_TILES
assert FOLLOWER_VTILE_END == $100
assert FOLLOWER_VRAM_TILE == $65

; The override marker makes old saves/padding harmless. A missing marker means
; "follow the first valid Pokémon in the party".
DEF FOLLOWER_OVERRIDE_MAGIC    EQU $a5

; Additional graphics IDs begin after Celebi. IDs are 16-bit at runtime.
DEF FOLLOWER_GFX_CUSTOM_BASE   EQU NUM_POKEMON + 1

; Reserve four tiles for fruit-tree graphics.
DEF FIXED_FRUIT_TREE_VTILE EQU $78
DEF FIXED_FRUIT_TREE_TILES EQU 4
assert FIXED_FRUIT_TREE_VTILE + FIXED_FRUIT_TREE_TILES == $7c

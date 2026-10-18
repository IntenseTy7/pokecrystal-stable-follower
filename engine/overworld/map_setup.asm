RunMapSetupScript::
	ldh a, [hMapEntryMethod]
	and $f
	dec a
	ld c, a
	ld b, 0
	ld hl, MapSetupScripts
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call ReadMapSetupScript
	ret

INCLUDE "data/maps/setup_scripts.asm"

ReadMapSetupScript:
.loop
	ld a, [hli]
	cp -1 ; end?
	ret z

	push hl

	ld c, a
	ld b, 0
	ld hl, MapSetupCommands
	add hl, bc
	add hl, bc
	add hl, bc

	; bank
	ld b, [hl]
	inc hl

	; address
	ld a, [hli]
	ld h, [hl]
	ld l, a

	; Bit 7 of the bank indicates a parameter.
	; This is left unused.
	bit MAPSETUPSCRIPT_HAS_PARAM_F, b
	jr z, .go

	pop de
	ld a, [de]
	ld c, a
	inc de
	push de

.go
	ld a, b
	and $7f
	rst FarCall

	pop hl
	jr .loop

INCLUDE "data/maps/setup_script_pointers.asm"

EnableTextAcceleration:
	xor a
	ld [wDisableTextAcceleration], a
	ret

ActivateMapAnims:
	ld a, TRUE
	ldh [hMapAnims], a
	ret

SuspendMapAnims:
	xor a ; FALSE
	ldh [hMapAnims], a
	ret

LoadMapObjects:
	ld a, MAPCALLBACK_OBJECTS
	call RunMapCallback
	farcall LoadObjectMasks
	farcall PlaceFollowerObject
	farcall InitializeVisibleSprites
	farcall StartFollowerObject
	call UpdatePlayerSprite
	ret

MapSetup_DummyFunction: ; unreferenced
	ret

; Called by the seamless map-connection setup after new map objects are loaded
; into wMapObjects, but before they are initialized as visible structs.
; The old group-wide sprite preload is no longer used for outdoor maps.
RefreshConnectionSpriteGFX:
	farcall RefreshSprites
	ret

ResetPlayerObjectAction:
	ld hl, wPlayerSpriteSetupFlags
	set PLAYERSPRITESETUP_RESET_ACTION_F, [hl]
	ret

SkipUpdateMapSprites:
	ld hl, wPlayerSpriteSetupFlags
	set PLAYERSPRITESETUP_SKIP_RELOAD_GFX_F, [hl]
	ret

CheckUpdatePlayerSprite:
	nop
	call .CheckForcedBiking
	jr c, .ok
	call .CheckSurfing
	jr c, .ok
	call .ResetSurfingOrBikingState
	jr c, .ok
	ret

.ok
	call UpdatePlayerSprite
	ret

.CheckForcedBiking:
	and a
	ld hl, wBikeFlags
	bit BIKEFLAGS_ALWAYS_ON_BIKE_F, [hl]
	ret z
	ld a, PLAYER_BIKE
	ld [wPlayerState], a
	scf
	ret

.ResetSurfingOrBikingState:
	ld a, [wPlayerState]
	cp PLAYER_NORMAL
	jr z, .nope
	cp PLAYER_SKATE
	jr z, .nope
	cp PLAYER_SURF
	jr z, .surfing
	cp PLAYER_SURF_PIKA
	jr z, .surfing
	call GetMapEnvironment
	cp INDOOR
	jr z, .no_biking
	cp ENVIRONMENT_5
	jr z, .no_biking
	cp DUNGEON
	jr z, .no_biking
	jr .nope
.no_biking
	ld a, [wPlayerState]
	cp PLAYER_BIKE
	jr nz, .nope
.surfing
	ld a, PLAYER_NORMAL
	ld [wPlayerState], a
	scf
	ret

.nope
	and a
	ret

.CheckSurfing:
	call CheckOnWater
	jr nz, .nope2
	ld a, [wPlayerState]
	cp PLAYER_SURF
	jr z, .is_surfing
	cp PLAYER_SURF_PIKA
	jr z, .is_surfing
	ld a, PLAYER_SURF
	ld [wPlayerState], a
.is_surfing
	scf
	ret

.nope2
	and a
	ret

FadeOutMapMusic:
	ld a, 6
	call SkipMusic
	ret

ApplyMapPalettes:
	farcall _UpdateTimePals
	ret

FadeMapMusicAndPalettes:
	ld e, LOW(MUSIC_NONE)
	ld a, [wMusicFadeID]
	ld d, HIGH(MUSIC_NONE)
	ld a, [wMusicFadeID + 1]
	ld a, $4
	ld [wMusicFade], a
	call RotateThreePalettesRight
	ret

ForceMapMusic:
	ld a, [wPlayerState]
	cp PLAYER_BIKE
	jr nz, .notbiking
	call MinVolume
	ld a, $88
	ld [wMusicFade], a
.notbiking
	call TryRestartMapMusic
	ret

PUSHS
SECTION "Follower", ROMX

FollowerObjectTemplate:
    object_event 0, 0, FOLLOWER_SPRITE, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, FollowerDummyScript, -1

AddFollowerObject::
	farcall PrepareFollowerGFX
	ret c
    ld a, [wCurMapObjectEventCount]
    cp NUM_OBJECTS - 1
    ret nc
    ld hl, wMap1Object
    and a
    jr z, .found
    ld de, MAPOBJECT_LENGTH
.next
    add hl, de
    dec a
    jr nz, .next
.found
    ld a, $ff
    ld [hli], a
    ld de, FollowerObjectTemplate
    ld b, OBJECT_EVENT_SIZE
.copy
    ld a, [de]
    inc de
    ld [hli], a
    dec b
    jr nz, .copy
    ld hl, wCurMapObjectEventCount
    inc [hl]
    ret

FindFollowerSlot:
    ld a, [wCurMapObjectEventCount]
    and a
    jr z, .none
    dec a
    ld hl, wMap1Object
    jr z, .check
    ld de, MAPOBJECT_LENGTH
.next
    add hl, de
    dec a
    jr nz, .next
.check
    push hl
    ld de, 1 + OBJECT_EVENT_SIZE - 4
    add hl, de
    ld de, FollowerObjectTemplate + OBJECT_EVENT_SIZE - 4
    ld b, 4
.compare
    ld a, [de]
    inc de
    cp [hl]
    jr nz, .mismatch
    inc hl
    dec b
    jr nz, .compare
    pop hl
    and a
    ret
.mismatch
    pop hl
.none
    scf
    ret

; Place the follower a step behind the player's map-entry direction.
; Do not start the follow queue from the same tile as the player.
PlaceFollowerObject::
    call FindFollowerSlot
    ret c
    push bc
    push hl
    call GetFollowerSpawnFacing ; identical direction used for initial OAM
    call GetFollowerSpawnCoords ; D = X, E = Y
    pop hl
    pop bc
    ld a, e
    push de
    ld de, MAPOBJECT_Y_COORD
    add hl, de
    ld [hl], a
    pop de
    ld a, d
    ld de, MAPOBJECT_X_COORD - MAPOBJECT_Y_COORD
    add hl, de
    ld [hl], a
    ret

; Resolve the follower's map-entry position AND initial facing together.
; Bottom-door arrivals enter from below even when the player's warp-facing
; routine forces DOWN on the destination tile.  Preserve the caller's object
; pointers: this routine also runs during follower object initialization.
GetFollowerSpawnFacing::
    push bc
    push de
    push hl
    call GetFollowerEntryFacing
    push af
    call GetMapEnvironment
    cp INDOOR
    jr nz, .usual
    ld a, [wMapHeight]
    add a
    dec a ; final indoor tile row
    ld c, a
    ld a, [wYCoord]
    cp c
    jr nz, .usual
    pop af
    ld a, UP ; follower is one tile below the player, facing UP
    jr .done
.usual
    pop af
.done
    pop hl
    pop de
    pop bc
    ret

; A = resolved facing; returns D = follower X, E = follower Y.
GetFollowerSpawnCoords:
    push af
    ld a, [wXCoord]
    add 4
    ld d, a
    ld a, [wYCoord]
    add 4
    ld e, a
    pop af
    cp DOWN
    jr z, .player_facing_down
    cp UP
    jr z, .player_facing_up
    cp LEFT
    jr z, .player_facing_left
; Player faces right: follower starts to the left.
    dec d
    ret

.player_facing_down
    dec e
    ret

.player_facing_up
    inc e
    ret

.player_facing_left
    inc d
    ret

; Match the facing rules in RefreshPlayerSprite, which runs *after*
; LoadMapObjects in Crystal's warp/connection map-setup scripts.
; At a door/staircase, the player will be forced to face down regardless of
; the direction used to enter the previous map. Custom facing wins last.
; Return A = direction 0..3, preserving BC/DE/HL for object callers.
GetFollowerEntryFacing::
    push bc
    push de
    push hl
    farcall CheckWarpFacingDown
    jr nc, .from_player
    xor a ; DOWN
    jr .check_custom
.from_player
    ld a, [wPlayerDirection]
    srl a
    srl a
    maskbits NUM_DIRECTIONS
.check_custom
    ld e, a
    ld a, [wPlayerSpriteSetupFlags]
    bit PLAYERSPRITESETUP_CUSTOM_FACING_F, a
    jr z, .normal
    and PLAYERSPRITESETUP_FACING_MASK
    jr .done
.normal
    ld a, e
.done
    pop hl
    pop de
    pop bc
    ret

StartFollowerObject::
    call FindFollowerSlot
    ret c
    ld a, [wCurMapObjectEventCount]
    ld c, a
    ld b, 0
    farcall StartFollowMap
    ret

; Temporarily remove the permanent Pokemon follower from the active
; object list while a scripted NPC uses Crystal's shared follow state.
; The map-event template remains so RespawnFollowerObject can restore it
; when the entire script finishes (not at the middle of a rival shove).
SuspendNativeFollowerForScript::
    call FindFollowerSlot
    ret c
    ld a, [wCurMapObjectEventCount]
    ldh [hMapObjectIndex], a
    jp DeleteObjectStruct

RespawnFollowerObject::
    call FindFollowerSlot
    ret c
    ld a, [wCurMapObjectEventCount]
    ldh [hMapObjectIndex], a
    call DeleteObjectStruct
    call PlaceFollowerObject
    ld a, [wCurMapObjectEventCount]
    call UnmaskCopyMapObjectStruct
    jp StartFollowerObject

SpawnFollowerAfterStarter::
    call AddFollowerObject
    call PlaceFollowerObject
    farcall InitializeVisibleSprites
    call StartFollowerObject
    farcall LoadFollowerGFX
    ret
POPS

PUSHS
SECTION "Follower Dummy Script", ROM0
FollowerDummyScript::
    end
POPS

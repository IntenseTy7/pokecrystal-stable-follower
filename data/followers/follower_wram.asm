; Replace the existing anonymous `ds 40` immediately after wCmdQueue with
; these labels. Total size remains exactly 40 bytes; no WRAM/save addresses move.
wFollowerOverrideMagic:: db
wFollowerOverrideGFXID:: dw
wFollowerResolvedGFXID:: dw
wFollowerPalette:: db
; 34 bytes reserved for independent native-Pokemon movement state.
; Do not change the total size: all later WRAM addresses must stay fixed.
wFollowerPathHead:: db
wFollowerPathCount:: db
wFollowerPathOverflow:: db
wFollowerStrideParity:: db
wFollowerPathTiles:: ds 30 ; fifteen pairs of absolute map X/Y coordinates
assert @ - wFollowerOverrideMagic == 40

;----------------------------------------------------------------------------
; Simulation of a DSP values array
; Stored in ROM bank 4 for now...
;----------------------------------------------------------------------------
.bank 0
.org 17408
.section "DSP_Value_Sim" force
dsp_value_array:
    .byte $00,$00,$7F,$7F,$00,$01,$00,$FF,$E0,$01,$00,$00,$00,$7F,$7F,$00,$01,$00,$FF,$E0,$02,$00,$00,$00,$7F,$7F,$00,$01,$00,$FF,$E0,$00,$00,$00,$00,$7F,$7F,$00,$01,$00,$FF,$E0,$00,$00,$00,$00,$20,$03,$FC,$02,$00,$00,$7F,$7F,$00,$00
dsp_value_array_end:
.ends
;============================================================================

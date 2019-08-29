.ENUM $0F00
Joy1Raw     DW      ; Holder of RAW joypad data from register (from last frame)

Joy1Press   DW      ; Contains only pressed buttons (not held down)

Joy1Held    DW      ; Contains only buttons that are Held

.ENDE

; Joypad defines
; $4218
.EQU Button_A		$80
.EQU Button_X		$40
.EQU Button_L		$20
.EQU Button_R		$10
; $4219
.EQU Button_B		$80
.EQU Button_Y		$40
.EQU Button_Select	$20
.EQU Button_Start	$10
.EQU Button_Up		$08
.EQU Button_Down	$04
.EQU Button_Left	$02
.EQU Button_Right	$01

;---------------|---------|------------|-------------------------------------
;
; 
; 
;
;---------------|---------|------------|-------------------------------------
.bank 0
.org 14336
.section "Controller_Input_Routines" force

Joypad_Ready:   LDA       $4212
                AND       #$01
                BNE       Joypad_Ready
                Accu_16bit
                LDX       Joy1Raw
                LDA       $4218
                STA       Joy1Raw
                TXA
                EOR       Joy1Raw
                AND       Joy1Raw
                STA       Joy1Press
                TXA
                AND       Joy1Raw
                STA       Joy1Held
                Accu_8bit
  Skip_Joypad:  RTS

;---------------|---------|------------|-------------------------------------
;
; 
; 
;
;---------------|---------|------------|-------------------------------------

Jump_Around:    Accu_16bit             ;Jump up, jump up and get down
                LDA       $7F11C0        
                TAX
                LDA       $7F0000,X
                LSR
                LSR
                LSR
                LSR
                LSR
                LSR
                LSR
                LSR
                AND       #$000F
                CMP       #$1
                BEQ       JMP_UP
                CMP       #$2
                BEQ       JMP_LFT
                CMP       #$5
                BEQ       JMP_UP_DWN
                CMP       #$8
                BEQ       JMP_RGT
                CMP       #$A
                BEQ       JMP_LFT_RGT
                CMP       #$E
                BEQ       JMP_LFT_DWN_RGT

  JMP_UP:       LDA       $000F02
                CMP       #$0800
                BNE       Leave_Short1
                LDA       $7F0002,X
                STA       $7F11C0
    Leave_Short1:
                Accu_8bit
                RTS

  JMP_LFT:      LDA       $000F02
                CMP       #$0200.W
                BNE       Leave_Short2
                LDA       $7F0004,X
                STA       $7F11C0
    Leave_Short2:
                Accu_8bit
                RTS

  JMP_UP_DWN:   LDA       $000F02
                CMP       #$0800.W
                BNE       UP_DOWN
                LDA       $7F0002,X
                STA       $7F11C0
    UP_DOWN:    CMP       #$0400.W
                BNE       Leave_Short3
                LDA       $7F0006,X
                STA       $7F11C0
    Leave_Short3:
                Accu_8bit
                RTS

  JMP_RGT:      LDA       $000F02
                CMP       #$0100.W
                BNE       Leave_Short4
                LDA       $7F0008,X
                STA       $7F11C0
    Leave_Short4:
                Accu_8bit
                RTS

  JMP_LFT_RGT:  LDA       $000F02
                CMP       #$0200.W
                BNE       LFT_RGT
                LDA       $7F0004,X
                STA       $7F11C0
    LFT_RGT:    CMP       #$0100.W
                BNE       Leave_Short5
                LDA       $7F0008,X
                STA       $7F11C0
    Leave_Short5:
                Accu_8bit
                RTS

  JMP_LFT_DWN_RGT:
                LDA       $000F02
                CMP       #$0200.W
                BNE       LFT_DWN_RGT1
                LDA       $7F0004,X
                STA       $7F11C0
    LFT_DWN_RGT1:
                CMP       #$0400.W
                BNE       LFT_DWN_RGT2
                LDA       $7F0006,X
                STA       $7F11C0
    LFT_DWN_RGT2:
                CMP       #$0100.W
                BNE       Leave
                LDA       $7F0008,X
                STA       $7F11C0
  Leave:       
               Accu_8bit
               RTS
                
.ends

;---------------|---------|------------|-------------------------------------
;
;
;
;---------------|---------|------------|-------------------------------------
.macro  READ_CONTROLLER_1
                PER       ret30
                BRL       Joypad_Ready
                ret30:     NOP
.endm

;---------------|---------|------------|-------------------------------------
;
;
;
;---------------|---------|------------|-------------------------------------
.macro  JUMP_INTERFACE
                PER       ret31
                BRL       Jump_Around
                ret31:     NOP
.endm
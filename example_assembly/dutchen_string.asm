sc32_main:                              
                                        ; @sc32_main
; %bb.0:                                ; %entry
        PUSH GP0
        MOV GP0, GP29
        SUBI GP29, #4
        LLI GP23, #72
        CALLI sc32_putc
        LLI GP23, #101
        CALLI sc32_putc
        LLI GP23, #108
        ST GP23, GP0, #-4
        CALLI sc32_putc
        LD GP23, GP0, #-4
        CALLI sc32_putc
        LLI GP23, #111
        CALLI sc32_putc
        LLI GP23, #33
        CALLI sc32_putc
        LLI GP23, #10
        CALLI sc32_putc
        MOV GP29, GP0
        POP GP0
        RET

sc32_putc:                              
                                        ; @sc32_putc
; %bb.0:                                ; %entry
        PUSH GP0
        MOV GP0, GP29
        SUBI GP29, #4
        ST GP23, GP0, #-4
        LD GP2, GP0, #-4
        LUI GP3, #64
        ORI GP3, #1
        ST GP2, GP3, #0
        MOV GP29, GP0
        POP GP0
        RET
                                        ; -- End function


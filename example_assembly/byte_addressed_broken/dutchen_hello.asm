hello:                                  ; -- Begin function hello
                                        ; @hello
; %bb.0:                                ; %entry
        LUI GP2, #64
        ORI GP2, #1
        LLI GP3, #72
        ST GP3, GP2, #0
        LLI GP3, #101
        ST GP3, GP2, #0
        LLI GP3, #108
        ST GP3, GP2, #0
        ST GP3, GP2, #0
        LLI GP3, #111
        ST GP3, GP2, #0
        LLI GP3, #33
        ST GP3, GP2, #0
        RET
                                        ; -- End 

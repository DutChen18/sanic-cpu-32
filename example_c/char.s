test:                                   ; -- Begin function test
                                        ; @test
; %bb.0:                                ; %entry
	LDB GP28, GP23, #0
	ADDI GP23, #1
	STB GP24, GP23, #0
	RET
                                        ; -- End function

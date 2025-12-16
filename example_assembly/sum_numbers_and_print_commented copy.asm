LUI GP0, #64
ADDI GP0, #1 // Peripheral Location
LUI GP1, #128 // Mem location
LLI GP2, #48 // First letter
LLI GP3, #57 // Limit
ST GP2, GP1, #0 // Store
ADDI GP2, #1 // Increment
CMP GP2, GP3 // Compare
JLT #-4 // Jmp back to continue populating RAM
LLI GP2, #1 // Set first num
LLI GP4, #1 // Put first num in a 2nd register
LLI GP3, #2 // Set seconds num
ADD GP2, GP3 // Sum them
MOV GP1, GP5 // Copy mem address
MOV GP1, GP6 // Copy mem address
ADD GP5, GP4 // Get address for first value
ADD GP6, GP3 // Get address for second value
ADD GP7, GP2 // Get address for sum
LD GP8, GP5, #0 // Get value for 1st operand
LD GP9, GP6, #0 // Get value for 2nd operand
LD GP10, GP2, #0 // Get value for sum
LLI GP11, #45
ST GP7, GP0, #0 // Print number
ST GP11, GP0, #0 // Print -
ST GP8, GP0, #0 // Print 2nd number
LLI GP11, #61 // Put =
ST GP11, GP0, #0 // Put equals
ST GP10, GP0, #0

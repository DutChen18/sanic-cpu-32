; Kinda need to bootstrap?
; Idk what that means, really

LUI GP31, 1024  ; peripheral base address

; Create stack
LUI GP29, 4096 ; 1 past Max Memory
SUBI GP29, 1 ; Max address

; Create Heap pointer
LUI GP30, 2048 ; Minimum memory address

; What should

JMP HALT

free_block:
  ; GP23 Address of block
  PUSH GP0
  PUSH GP1
  PUSH GP2
  PUSH GP15
  MOV GP2, GP23
  SUBI GP2, 4
  LLI GP15, 0
  LD GP0, GP2, 0
  CMP GP20, GP15
  JNE skip_free_block_set_free_list_head
  MOV GP20, GP2
  JMP exit_free_block
  skip_free_block_set_free_list_head:
    MOV GP1, GP20 ; Load in next pointer from the haed of the free list initially
    retrieve_block_loop:
    ; The free list already exists
    LD GP0, GP1, 4 ; Load in the next pointer from the next block
    CMP GP0, GP15 ; Check if it's null/0
    JNE advance_block
    ST GP2, GP1, 4 ; Set the next pointer for this block
    exit_free_block:
    ST GP15, GP2, 4 ; Set next pointer to nothing for the block we're freeing
    POP GP15
    POP GP2
    POP GP1
    POP GP0
    RET
  advance_block:
    MOV GP1, GP0
    JMP retrieve_block_loop


malloc:
  ; GP23 Desired size
  ; GP28 Returned pointer
  ; Steps:
  ;  1. Walk free_list to find a block that's at least desired_size+2
  ;  2. If we find a block, decide what to do based on the location of that block in the free_list:
  ;     1. If the block is located at free_block_head, replace free_block_head with the value of next on the current free_block_head (Whatever pointer is at free_block_head+2), then pass free_block_head to the caller
  ;     2. If the block is in the middle somewhere, we need to connect the previous block to the block after this one - set the previous block's "next" to the block we're allocating's "next" value.
  ;     3. If the block is at the end (no "next" value), then remove this block's address from the previous block's "next" and nothing else is needed
  ;
  ;  3. If we did not find a free block of the needed size, allocate a new one aligned to the minimum allocation size, and pass back the pointer to that location+2. Place the size of the block the allocator created at location (should be 2 bytes)
  ;  3a. I don't have a _great_ way to write 2 bytes from a 4-byte register except maybe shifting and STB... Idk
  PUSH GP0 ; Save the value of GP0
  PUSH GP1 ; Save the value of GP1
  PUSH GP2 ; Save the value of GP2
  PUSH GP3 ; Save the value of GP3
  PUSH GP4 ; Save the value of GP4
  PUSH GP15
  PUSH GP16
  MOV GP1, GP20 ; Copy the pointer to the free_block_head
  LLI GP15, 0 ; Set register to 0 to check for uninitialized pointers
  LLI GP16, 16 ; Set register to 16 to check if the desired size is less than the minimum size
  CMP GP23, GP16 ; Check if size is less than minimum
  JGT skip_set_size
  LLI GP23, 16 ; Set size to 16 sinec it was less
  skip_set_size:
    CMP GP20, GP15 ; Check if the free_block_head is uninitialized
    JEQ allocate_new_block

  load_next_block:
    LD GP2, GP1, 0; Load size of the next free block
    CMP GP2, GP23 ; Compare the size of the block to the desired size
    JGE reallocate_block
    MOV GP0, GP1 ; Set GP0 to the last pointer value
    LD GP1, GP2, 4 ; Load pointer stored at location GP2+4 into GP1
    CMP GP1, GP15 ; Check if pointer is 0
    JEQ allocate_new_block ; Allocate new block as we've reached the end
    MOV GP1, GP2 ; Set GP1 to the contents of GP2 (which should be the "next" pointer)
    ADDI GP1, 4 ; Add 4 because I was a total liar the last line
    JMP load_next_block ; Jump back to continue the loop

  reallocate_block:
    CMP GP0, GP15 ; Check if the previous pointer exists
    JEQ skip_realloc_last
    LD GP2, GP1, 4 ; Grab next pointer
    CMP GP2, GP15 ; Check if next pointer is zero
    JNE skip_malloc_clear_previous_ptr
    ST GP15, GP0, 4 ; Set previous ptr to zero
    JMP skip_remove_free_list
    skip_malloc_clear_previous_ptr:
    ST GP2, GP0, 4 ; Set the next pointer for the previous block to the block after current.
    JMP skip_remove_free_list
    skip_realloc_last:
    LD GP2, GP1, 4 ; Grab next pointer
    CMP GP2, GP15 ; Check if next pointer is zero
    JNE set_free_list_head_malloc
    LLI GP20, 0 ; Set free_list to 0 since we just reallocated its only entry.
    skip_remove_free_list:
    ADDI GP1, 4    ; Add 4 bytes to the start of the block to remove the header from the block for the caller.
    MOV GP28, GP1  ; Set return value
    JMP malloc_exit ; Exit

  allocate_new_block:
    MOV GP28, GP30 ; Copy current heap pointer to GP28
    ADDI GP30, 4    ; Add 4 bytes for header
    ADD GP30, GP23 ; Add Size bytes
    MOV GP2, GP23
    ADDI GP2, 4 ; Add size for header piece
    ST GP2, GP28, 0 ; Store size at specified location
    ADDI GP28, 4 ; Add size for header piece to output pointer
    JMP malloc_exit

  set_free_list_head_malloc:
    MOV GP20, GP2 ; Set free_list_head

  malloc_exit:
    POP GP16
    POP GP15
    POP GP4
    POP GP3
    POP GP2
    POP GP1
    POP GP0
    RET

find_match:
  ; Iterate over the command words pointers, sub-iterate on those pointers until we find a null character.
  ; Each sub-loop, check if that word matches the word given by the user at that offset.
  ; If the word does match, continue. If not, early exit and have the outer loop continue.
  ; If we find a null character, and it's matched up to this point, consider it a pass.
  ; Command word start is really like... We're looping over command structs, and the first pointer in a command struct is the pointer.
  ; So instead of simply looping and doing LD GP1, <command word pointer> 
  ; We have to first retrieve the command word pointer from the command struct pointer
  MOV GP2, GP24 ; Copy beginning of command pointers array
  MOV GP3, GP23 ; Copy beginning of entered command
  ; GP7 will be the "non-zero means we didn't match" reg, because we need to check if there's a null byte at the end of the word so we know to stop scanning.
  outer_loop:
    CMP GP2, GP21   ; Check if the pointer is null
    JEQ fail_exit  ; Early exit if we reached the end of the pointers array
    LD GP4, GP2, #0 ; Load pointer to command struct
    LD GP5, GP4, #0 ; Load command word pointer
    LD GP1, GP5, #0 ; Load command word
    LD GP0, GP3, #0 ; Load first entered command word
    inner_loop:
      LLI GP13, #3 ; Shift byte amount
      LLI GP14, #8 ; Byte
      MUL GP14, GP13 ; Multiply to get shift amount
      byte_loop:
        MOV GP11, GP0
        MOV GP12, GP1
        SHR GP11, GP14
        SHR GP12, GP14
        CMP GP11, GP12
        JEQ match
        LLI GP7, #1 ; Didn't match
        match:
        SUBI GP13, #1
        CMP GP13, GP21 ; Check if counter is less than 0
        JGE byte_loop ; Keep getting bytes from this word
        CMP GP12, GP21 ; Check if it's zero (end)
        JNE more_bytes
        ; We reached the end of the command word we're checking.
        CMP GP7, GP21  ; Check if it's zero
        JNE not_match ; Jump away if it didn't match
        MOV GP28, GP4  ; Pointer to matching command
        RET
        more_bytes:
          ADDI GP3, #1 ; Add 1 to get next word
          ADDI GP5, #1 ; Add 1 to get next word
          LD GP0, GP3, #0 ; Load entered command next word
          LD GP1, GP5, #0 ; Load next command word
          JMP inner_loop

  
  not_match:
    ADDI GP2, #1
    MOV GP3, GP23
    JMP outer_loop ; Try again
  success_exit:
    MOV GP28, GP4 ; Copy command struct pointer to return
    RET
  fail_exit:
    LLI GP28, #0
    RET

HALT:
ADD GP0, GP1

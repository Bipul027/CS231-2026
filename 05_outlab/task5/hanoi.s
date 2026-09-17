extern printf
extern exit

section .rodata
    fmt_move: db "Move disk %d from %s to %s", 10, 0
    fmt_count: db "Total moves: %ld", 10, 0
    pole_a: db "A", 0
    pole_b: db "B", 0
    pole_c: db "C", 0

section .data
    move_count: dq 0

section .text
    global _start

; towers_of_hanoi(const char* src{rdi}, const char* dest{rsi}, const char* aux{rdx}, size_t num_discs{rcx})
towers_of_hanoi:
    cmp rcx, 0
    jne .recurse
    ret

.recurse:
    push r12
    push r13
    push r14

    mov r12, rdi    ; source
    mov r13, rsi    ; dest
    mov r14, rdx    ; aux

    dec rcx
    mov rdx, r13
    mov rsi, r14
    push rcx
    call towers_of_hanoi
    pop rcx

    push rcx
    mov rdi, fmt_move
    inc rcx
    xor eax, eax
    mov rsi, rcx
    mov rdx, r12
    mov rcx, r13

    call printf
    pop rcx

    inc qword [move_count]
    
    mov rdi, r14  ; aux
    mov rsi, r13  ; dest
    mov rdx, r12  ; src

    push rcx
    call towers_of_hanoi
    pop rcx

    pop r14
    pop r13
    pop r12
    ret

_start:
    and rsp, -16
;   call towers_of_hanoi(pole_a, pole_c, pole_b, 3), then printf the total
;   move count (should be 2^n - 1), and exit with it.
    mov rdi, pole_a
    mov rsi, pole_c
    mov rdx, pole_b
    mov rcx, 3
    call towers_of_hanoi

    xor eax, eax
    mov rdi, fmt_count
    mov rsi, qword [move_count]
    call printf

    mov rdi, qword [move_count]
    call exit

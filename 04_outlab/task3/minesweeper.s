section .data
    ROWS equ 5
    COLS equ 6

    grid:
        db 0,0,1,0,0,0
        db 0,0,0,0,1,0
        db 0,1,0,0,0,0
        db 0,0,0,0,0,0
        db 1,0,0,1,0,0
    .end:
    
    ;; number of non-bomb cells with 0 neighboring bombs is 3 by default

%if (ROWS*COLS) != (grid.end-grid)
    %error "Size does not match (ROWS, COLS)"
%endif

section .text
    global _start

_start:
;   grid[r*COLS+c] is 1 if that cell has a bomb, 0 otherwise. For every
;   non-bomb cell, count how many of its up-to-8 neighbors (including
;   diagonals) are bombs -- remember cells on an edge or corner have
;   fewer than 8 neighbors. Exit with the number of non-bomb cells whose
;   neighbor-bomb-count is exactly 0.

    xor rdi, rdi    ; Final count of number of non-bomb cells whose neighbor-bomb-count is exactly 0
    xor rbx, rbx    ; Row index
    xor rcx, rcx    ; Col index

    .rowloopbegin:
        cmp rbx, ROWS
        jge .rowloopend

        xor rcx, rcx

    .colloopbegin:
        cmp rcx, COLS
        jge .colloopend

        mov rax, rbx
        imul rax, COLS
        add rax, rcx

        cmp byte [grid + rax], 0
        jne .colloopinc

        mov r9, -1
        xor r13, r13

    .rownbbegin:
        cmp r9, 2
        jge .rownbend

        mov r10, -1

    .colnbbegin:
        cmp r10, 2
        jge .colnbend

        mov r11, rbx
        mov r12, rcx

        add r11, r9
        add r12, r10

        cmp r11, 0
        jl .colnbinc
        cmp r11, ROWS
        jge .colnbinc

        cmp r12, 0
        jl .colnbinc
        cmp r12, COLS
        jge .colnbinc

        mov rax, r11
        imul rax, COLS
        add rax, r12

        cmp byte [grid + rax], 1
        jne .colnbinc
        inc r13

    .colnbinc:
        inc r10
        jmp .colnbbegin

    .colnbend:
        inc r9
        jmp .rownbbegin

    .rownbend:
        cmp r13, 0
        jne .colloopinc
        inc rdi
    
    .colloopinc:
        inc rcx
        jmp .colloopbegin

    .colloopend:
        inc rbx
        jmp .rowloopbegin

    .rowloopend:

    mov rax, 60
    syscall

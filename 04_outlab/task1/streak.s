section .data
    values:
        dq 4, 4, 4, 7, 7, 2, 2, 2, 2, 9, 9, 1, 7, 7, 7
    .end:
    n equ (values.end - values)/8

    ;; longest run of consecutive equal values is 4 by default

section .text
    global _start

_start:
;   find the length of the longest run of consecutive equal values in
;   `values`, and exit with that length
    xor rbx, rbx    ; Last value
    xor rcx, rcx    ; Index count
    xor rdx, rdx    ; Current max count
    mov rdi, 1      ; Current running count

    .loopbegin:
        cmp rcx, n
        jge .loopend

        cmp rbx, [values + 8*rcx]
        jne .else

    .if:    ; current value equals last value
        inc rdi
        jmp .endif

    .else:
        cmp rdi, rdx
        jle .not_greater
        mov rdx, rdi

    .not_greater:
        mov rdi, 1

    .endif:
        mov rbx, [values + 8*rcx]
        inc rcx
        jmp .loopbegin

    .loopend:
        cmp rdi, rdx
        jle .final
        mov rdx, rdi

    .final:
        mov rdi, rdx
        mov rax, 60
        syscall

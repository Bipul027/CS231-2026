section .data
    array: 
        dd 3, 6, 1, 42, 8, 1, 3, 6, 8
    .end:
    array_len equ (array.end - array)/4

section .text
    global _start

_start:
    xor edi, edi
    xor rcx, rcx

    .loopbegin:
        cmp rcx, array_len
        jge .loopend

        xor edi, [array + rcx*4]
        inc rcx

        jmp .loopbegin
    .loopend:

    mov eax, 60
    syscall
    
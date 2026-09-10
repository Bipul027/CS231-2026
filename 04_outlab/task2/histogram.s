section .data
    text:
        db "mississippi"
    .end:
    text_len equ (text.end - text)

    counts: times 26 dd 0

    ;; the most common letter's count is 4 by default

section .text
    global _start

_start:
;   build a histogram of letter counts into `counts` (counts[c - 'a']
;   for each byte c in `text`), then exit with the highest count found
;   in `counts`

    xor rcx, rcx    ; Index count   
    xor rbx, rbx    ; max count

    .loopbegin:
        cmp rcx, text_len
        jge .loopend

        movzx rax, byte [text + rcx]
        sub rax, 'a'
        inc dword [counts + 4*rax]

        inc rcx
        jmp .loopbegin

    .loopend:
        xor rcx, rcx

    .ctloopbegin:
        cmp rcx, 26
        jge .ctloopend

        cmp dword [counts + 4*rcx], ebx
        jle .not_greater
    
        mov ebx, dword [counts + 4*rcx]

    .not_greater:
        inc rcx
        jmp .ctloopbegin

    .ctloopend:
        mov rdi, rbx

    mov rax, 60
    syscall

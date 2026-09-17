section .rodata
    error_msg: db "There should be 3 command line arguments!",10
    .end: db 0 ; null terminator for the TA's mental peace
    error_msg_len equ (error_msg.end-error_msg)

section .text
    global _start

; my_strlen(const char* str{rdi}) -> rax (not counting the null terminator)
my_strlen:
    xor eax, eax    ; Value of i
    xor edx, edx    ; Contains character value
.forbegin:
    movzx edx, byte [rdi + rax];
    
    cmp edx, 0
    je .forend
    
    inc rax
    jmp .forbegin
.forend:
    ret

; my_atoi(const char* str{rdi}) -> rax (handles an optional leading '-')
my_atoi:

    xor eax, eax   ; Value of number
    xor ecx, ecx    ; Value of i
    xor edx, edx    ; contains character value
    xor rsi, rsi    ; Flag telling if number is negative or not

    movzx edx, byte [rdi]
    cmp edx, 45
    jne .forbegin
    inc rcx
    mov rsi, 1

.forbegin:
    movzx rdx, byte [rdi + rcx]
    sub rdx, '0'
    cmp rdx, 9
    ja .forend

    imul rax, 10
    add rax, rdx

    inc rcx
    jmp .forbegin 
.forend:
    test rsi, rsi
    jz .non_neg
    neg rax

.non_neg:
    ret

; absolute_value(int64_t a{rdi}) -> rax
absolute_value:
    mov rax, rdi
    cmp rax, 0
    jge .is_positive
    neg rax
.is_positive:
    ret

; gcd(int64_t a{rdi}, int64_t b{rsi}) -> rax
gcd:
    call absolute_value
    mov r10, rax    ; r10 contains absolute value of rdi
    push rdi
    mov rdi, rsi
    call absolute_value
    mov r11, rax    ; r11 contains absolute value of rsi
    pop rdi

.loop:
    test r11, r11
    jnz .main
    mov rax, r10
    ret

.main:
    xor edx, edx
    mov rax, r10
    div r11

    mov r10, r11
    mov r11, rdx
    jmp .loop

_start:
;   check argc at [rsp] if it is 3, if not print error_msg and exit.
;   argv[1] is at [rsp+16], argv[2] is at [rsp+24] (argc is at [rsp]).
;   Print argv[1] as-is (using my_strlen + a direct write syscall), then
;   exit with gcd(atoi(argv[1]), atoi(argv[2])).

    mov rbx, [rsp]
    cmp rbx, 3
    je .no_error
    
    mov rax, 1
    mov rdi, 1
    mov rsi, error_msg
    mov rdx, error_msg_len
    syscall

    mov rax, 60
    mov rdi, 1
    syscall

.no_error:
    mov rdi, [rsp + 16]
    call my_strlen

    push rdi
    push rax
    mov rax, 1
    mov rsi, rdi
    mov rdi, 1
    pop rdx
    syscall
    pop rdi

    call my_atoi
    mov rbx, rax

    mov rdi, [rsp + 24]
    call my_atoi
    mov rcx, rax

    mov rdi, rbx
    mov rsi, rcx
    call gcd

    mov rdi, rax

    mov rax, 60
    syscall

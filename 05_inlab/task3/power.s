section .data
    one: dq 1.0

    base: dq 1.5
    exponent: dq 10

    ;; 1.5^10 truncates to 57

section .text
    global _start

; pow_naive(double base{xmm0}, uint64_t exponent{rdi}) -> xmm0
; exponent is a non-negative integer. Uses call/ret recursion.
pow_naive:
    test rdi, rdi
    jnz .recurse
    movsd xmm0, [one]
    ret

.recurse:
    test rdi, 1
    jnz .odd

.even:
    shr rdi, 1
    mulsd xmm0, xmm0
    call pow_naive
    ret

.odd:
    movsd xmm1, xmm0
    movq rdx, xmm1
    push rdx
    shr rdi, 1
    mulsd xmm0, xmm0
    call pow_naive
    pop rdx
    movq xmm1, rdx
    mulsd xmm0, xmm1
    ret

; pow_tail(double base{xmm0}, uint64_t exponent{rdi}, double acc{xmm1} = 1.0) -> xmm0
; Same result as pow_naive, but written as a tail call (jmp, not call/ret)
; so it doesn't grow the stack with recursion depth.
pow_tail:
    test rdi, rdi
    jnz .recurse
    movsd xmm0, xmm1
    ret

.recurse:
    test rdi, 1
    jnz .odd

.even:
    mulsd xmm0, xmm0
    shr rdi, 1
    jmp pow_tail

.odd:
    mulsd xmm1, xmm0
    mulsd xmm0, xmm0
    shr rdi, 1
    jmp pow_tail

_start:
;   Call pow_naive(base, exponent), truncate the result, and add it to
;   pow_tail(base, exponent, acc=1.0)'s truncated result. Exit with the sum.
;   (Both should independently come out to 57, so the exit code should be 114.)

    movsd xmm0, [base]
    mov rdi, [exponent]
    call pow_naive

    cvttsd2si rdi, xmm0
    mov rbx, rdi

    movsd xmm0, [base]
    mov rdi, [exponent]
    movsd xmm1, [one]
    call pow_tail

    cvttsd2si rdi, xmm0
    add rdi, rbx

    mov rax, 60
    syscall

.LC7:
        .string "%lf"
main:
        lea     ecx, [esp+4]
        and     esp, -16
        pxor    xmm7, xmm7
        xor     eax, eax
        push    DWORD PTR [ecx-4]
        push    ebp
        mov     ebp, esp
        push    ecx
        sub     esp, 20
        movaps  XMMWORD PTR [ebp-24], xmm7
        movsd   xmm6, QWORD PTR .LC4
        movdqa  xmm4, XMMWORD PTR .LC0
        unpcklpd        xmm6, xmm6
.L2:
        movdqa  xmm0, xmm4
        movapd  xmm3, xmm6
        pxor    xmm7, xmm7
        add     eax, 1
        movdqa  xmm1, xmm0
        movdqa  xmm5, xmm7
        pand    xmm0, XMMWORD PTR .LC2
        paddd   xmm4, XMMWORD PTR .LC1
        pslld   xmm1, 1
        paddd   xmm1, XMMWORD PTR .LC2
        pcmpeqd xmm0, xmm7
        movapd  xmm7, XMMWORD PTR .LC5
        cvtdq2pd        xmm2, xmm1
        divpd   xmm3, xmm2
        pshufd  xmm1, xmm1, 238
        movapd  xmm2, xmm6
        cvtdq2pd        xmm1, xmm1
        pcmpgtd xmm5, xmm0
        divpd   xmm2, xmm1
        movdqa  xmm1, xmm0
        punpckhdq       xmm0, xmm5
        punpckldq       xmm1, xmm5
        xorpd   xmm7, xmm3
        andpd   xmm3, xmm1
        andnpd  xmm1, xmm7
        orpd    xmm1, xmm3
        movapd  xmm3, XMMWORD PTR .LC5
        xorpd   xmm3, xmm2
        andpd   xmm2, xmm0
        andnpd  xmm0, xmm3
        orpd    xmm0, xmm2
        addpd   xmm1, xmm0
        addpd   xmm1, XMMWORD PTR [ebp-24]
        movaps  XMMWORD PTR [ebp-24], xmm1
        cmp     eax, 525000000
        jne     .L2
        movapd  xmm0, xmm1
        sub     esp, 12
        unpckhpd        xmm0, xmm1
        addpd   xmm0, xmm1
        movsd   QWORD PTR [esp], xmm0
        push    OFFSET FLAT:.LC7
        call    printf
        mov     ecx, DWORD PTR [ebp-4]
        add     esp, 16
        xor     eax, eax
        leave
        lea     esp, [ecx-4]
        ret
.LC0:
        .long   0
        .long   1
        .long   2
        .long   3
.LC1:
        .long   4
        .long   4
        .long   4
        .long   4
.LC2:
        .long   1
        .long   1
        .long   1
        .long   1
.LC4:
        .long   0
        .long   1074790400
.LC5:
        .long   0
        .long   -2147483648
        .long   0
        .long   -2147483648
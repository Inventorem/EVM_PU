.LC2:
        .string "%lf"
main:
        leal    4(%esp), %ecx
        andl    $-16, %esp
        pushl   -4(%ecx)
        pushl   %ebp
        movl    %esp, %ebp
        pushl   %ecx
        subl    $52, %esp
        movl    $2100000000, -40(%ebp)
        movl    $0, -36(%ebp)
        fldz
        fstpl   -16(%ebp)
        fldz
        fstpl   -24(%ebp)
        movl    $0, -28(%ebp)
        jmp     .L2
.L4:
        movl    -28(%ebp), %eax
        addl    %eax, %eax
        addl    $1, %eax
        movl    %eax, -44(%ebp)
        fildl   -44(%ebp)
        fldl    .LC1
        fdivp   %st, %st(1)
        fstpl   -24(%ebp)
        movl    -28(%ebp), %edx
        movl    %edx, %eax
        sarl    $31, %eax
        shrl    $31, %eax
        addl    %eax, %edx
        andl    $1, %edx
        subl    %eax, %edx
        movl    %edx, %eax
        cmpl    $1, %eax
        jne     .L3
        fldl    -24(%ebp)
        fchs
        fstpl   -24(%ebp)
.L3:
        fldl    -16(%ebp)
        faddl   -24(%ebp)
        fstpl   -16(%ebp)
        addl    $1, -28(%ebp)
.L2:
        movl    -28(%ebp), %eax
        cltd
        cmpl    -40(%ebp), %eax
        movl    %edx, %eax
        sbbl    -36(%ebp), %eax
        jl      .L4
        subl    $4, %esp
        pushl   -12(%ebp)
        pushl   -16(%ebp)
        pushl   $.LC2
        call    printf
        addl    $16, %esp
        movl    $0, %eax
        movl    -4(%ebp), %ecx
        leave
        leal    -4(%ecx), %esp
        ret
.LC1:
        .long   0
        .long   1074790400
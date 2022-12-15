.LC0:
        .ascii  "%lf\000"
main:
        push    {r7, lr}            //На стек два регистра
        sub     sp, sp, #32         //Выделить 32 байта
        add     r7, sp, #0          //Прибавить ноль, записать в r7
        adr     r1, .L6             //записать в r1 .L6 адрес N
        ldrd    r0, [r1]            //Загрузить в r0 значение N
        strd    r0, [r7]            //Сохранить r0 по адресу r7
        mov     r0, #0              //Записать ноль в r0
        mov     r1, #0              //Также обнуляем r1
        strd    r0, [r7, #24]       //На 24 бита пишем ноль
        mov     r0, #0
        mov     r1, #0
        strd    r0, [r7, #16]
        movs    r1, #0
        str     r1, [r7, #12]       //Записываем i
        b       .L2
.L4:
        ldr     r1, [r7, #12]
        lsls    r1, r1, #1
        adds    r1, r1, #1
        vmov    s15, r1 @ int
        vcvt.f64.s32    d17, s15
        vmov.f64        d18, #4.0e+0
        vdiv.f64        d16, d18, d17
        vstr.64 d16, [r7, #16]
        ldr     r1, [r7, #12]
        cmp     r1, #0
        and     r1, r1, #1
        it      lt
        rsblt   r1, r1, #0
        cmp     r1, #1
        bne     .L3
        vldr.64 d16, [r7, #16]
        vneg.f64        d16, d16
        vstr.64 d16, [r7, #16]
.L3:
        vldr.64 d17, [r7, #24]
        vldr.64 d16, [r7, #16]
        vadd.f64        d16, d17, d16
        vstr.64 d16, [r7, #24]
        ldr     r1, [r7, #12]
        adds    r1, r1, #1
        str     r1, [r7, #12]
.L2:
        ldr     r1, [r7, #12]
        asrs    r0, r1, #31
        mov     r2, r1
        mov     r3, r0
        ldrd    r0, [r7]
        cmp     r2, r0
        sbcs    r1, r3, r1
        blt     .L4
        ldrd    r2, [r7, #24]
        movw    r0, #:lower16:.LC0
        movt    r0, #:upper16:.LC0
        bl      printf
        movs    r3, #0
        mov     r0, r3
        adds    r7, r7, #32
        mov     sp, r7
        pop     {r7, pc}
.L6:
        .word   2100000000
        .word   0
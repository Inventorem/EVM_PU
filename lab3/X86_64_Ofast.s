.LC7:
        .string "%lf"
main:
//В этом блоке идет применение sse2 инструкций и запись констант из .LC#
        subq    $8, %rsp                    //Сдвигаем вершину стэка на 8 байт
        movsd   .LC4(%rip), %xmm6           //0, 1074790400
        xorl    %eax, %eax
        movsd   .LC6(%rip), %xmm5           //0, 10..0
        movdqa  .LC0(%rip), %xmm2           //0, 1, 2, 3
        movdqa  .LC2(%rip), %xmm7           //1,1,1,1
        pxor    %xmm3, %xmm3                //Зануляем xmm3, xmm4
        pxor    %xmm4, %xmm4
        movdqa  .LC1(%rip), %xmm8           //4,4,4,4
        unpcklpd        %xmm6, %xmm6        //Инструкция sse2 на перенос нижних упакованных значений double с чередованием
        unpcklpd        %xmm5, %xmm5

//Этот блок повторяет то, что  выполняется в теле главного цикла в O0, но в развернутом цикле на 2 векторах по два значения и со счетчиком N/4
.L2:
        //Копируем значения
        movdqa  %xmm2, %xmm0
        movapd  %xmm6, %xmm10
        movdqa  %xmm4, %xmm11

        //Прибавляем счетчик
        addl    $1, %eax

        //Копируем значения
        movdqa  %xmm0, %xmm1

        //Побитовое и, побитовое сложение,
        //сдвиг влево, сравнение равенства,
        //преобразование dword в double, деление,
        //перераспределние упакованных слов и по новой
        pand    %xmm7, %xmm0 //Упакованное обитовое сложение
        paddd   %xmm8, %xmm2 //Упакованное сложение
        pslld   $1, %xmm1 //Cдвиг влево упакованных двойных словь
        pcmpeqd %xmm4, %xmm0 //Сравнение на равенство упакованных слов
        paddd   %xmm7, %xmm1 //Прибавляем
        cvtdq2pd        %xmm1, %xmm9 //Преобразование двух dword в double
        divpd   %xmm9, %xmm10 //векторное деление double
        pshufd  $238, %xmm1, %xmm1
        movapd  %xmm6, %xmm9 //перемещение упакованных double
        cvtdq2pd        %xmm1, %xmm1
        pcmpgtd %xmm0, %xmm11 //Сравнение на больше
        divpd   %xmm1, %xmm9 //Векторное деление
        movdqa  %xmm0, %xmm1
        punpckhdq       %xmm11, %xmm0 //Распаковка в qword
        punpckldq       %xmm11, %xmm1
        movapd  %xmm10, %xmm12 //перемещение слов
        andpd   %xmm1, %xmm10 //упакованное и
        xorpd   %xmm5, %xmm12 //упакованный xor
        andnpd  %xmm12, %xmm1 //упакованный и
        orpd    %xmm10, %xmm1 //упакованный |
        movapd  %xmm9, %xmm10
        andpd   %xmm0, %xmm9
        xorpd   %xmm5, %xmm10
        andnpd  %xmm10, %xmm0
        orpd    %xmm9, %xmm0
        addpd   %xmm0, %xmm1
        addpd   %xmm1, %xmm3

        //Перемещение по метке в цикл
        cmpl    $525000000, %eax
        jne     .L2

        //Вывод числа
        movapd  %xmm3, %xmm0
        movl    $.LC7, %edi
        movl    $1, %eax
        unpckhpd        %xmm3, %xmm0
        addpd   %xmm3, %xmm0
        call    printf
        xorl    %eax, %eax
        addq    $8, %rsp
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
.LC6:
        .long   0
        .long   -2147483648
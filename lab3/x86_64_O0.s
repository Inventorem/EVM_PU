.LC3:
        .string "%lf" 			//метка на форматную строку для вывода
main:
        pushq   %rbp 			//Выделяем стековый кадр
        movq    %rsp, %rbp 		//копируем адрес вершины стека в rbp
        subq    $32, %rsp 		//сдвигаем вершину стека на 32 байта под наши переменные
        movq    $2100000000, -32(%rbp) 	//Записываем на место прошлой вершины стека 8 байт значение N = 2100000000
        pxor    %xmm0, %xmm0 		// Обнуляем xmm0
        movsd   %xmm0, -8(%rbp) 	//Заполняем 8 байт нулями для double pi = 0
        pxor    %xmm0, %xmm0 		// Обнуляем xmm0
        movsd   %xmm0, -16(%rbp) 	//Заполняем 8 байт нулями для double delta= 0
        movl    $0, -20(%rbp) 		// заполняем 4 байта нулями для int i = 0
        jmp     .L2 			//Переходим на метку проверку условий цикла

//Тело цикла
.L4:
        movl    -20(%rbp), %eax 	//Загружаем значение i в %eax
        addl    %eax, %eax 		//Умножаем eax на два
        addl    $1, %eax 		//Добавляем единичку в %eax
        pxor    %xmm1, %xmm1 		//Зануляем %xmm1
        cvtsi2sdl       %eax, %xmm1 	//Преобразуем в double и помещаем в %xmm1
        movsd   .LC1(%rip), %xmm0 	//Кидаем в %xmm0 значение 0 из .LC1 
        divsd   %xmm1, %xmm0 		//Делим %xmm0 на %xmm1
        movsd   %xmm0, -16(%rbp)	//Копируем полученное значение в delta
        movl    -20(%rbp), %edx		//Копируем i в %edx
        movl    %edx, %eax		//Копируем i в %eax
        sarl    $31, %eax
        //Проверка на четность
        shrl    $31, %eax	
        addl    %eax, %edx
        andl    $1, %edx
        subl    %eax, %edx
        movl    %edx, %eax
        //Если четно, идем на прибавление к pi
        cmpl    $1, %eax
        jne     .L3
        //Если нечетно, отнимаем дельту
        movsd   -16(%rbp), %xmm0	//Если не получили, копируем в xmm0 delta
        movq    .LC2(%rip), %xmm1	//Потом в xmm1 копируем -2147483648
        xorpd   %xmm1, %xmm0		//Зануляем xmm0
        movsd   %xmm0, -16(%rbp)

//Прибавляем к pi delta
.L3:
        movsd   -8(%rbp), %xmm0
        addsd   -16(%rbp), %xmm0
        movsd   %xmm0, -8(%rbp)
        addl    $1, -20(%rbp) //Инкремент счетчика
//Проверка условий цикла
.L2:
        movl    -20(%rbp), %eax //Кладем в eax текущее значение i
        cltq    		//Приводим 4 байтовый i к 8 байтам в rax
        cmpq    %rax, -32(%rbp)	//Сравниваем N и i
        jg      .L4 		//Если i меньше N, заходим в тело цикла .L4
        movq    -8(%rbp), %rax 	//Копируем pi в rax
        movq    %rax, %xmm0 	//Копируем pi в xmm0, т.к. выводим вещественное число
        movl    $.LC3, %edi 	//Копируем форматную строку в edi, потому что первый аргумент в printf
        movl    $1, %eax 	// пишем 1 в eax, т.к. выводим только pi
        call    printf 		//Выводим pi
        movl    $0, %eax 	//Зануляем eax
        leave 			//Выходим из main
        ret 			//Возврат из main
				//Завершение программы

//Константы
.LC1:
        .long   0
        .long   1074790400
.LC2:
        .long   0
        .long   -2147483648
        .long   0
        .long   0
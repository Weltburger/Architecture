CODESG		SEGMENT PARA 'CODE'
		ASSUME CS:CODESG, SS:CODESG, DS:CODESG, ES:CODESG
		ORG	100H
BEGIN:		JMP	MAIN	
;---------------------------------
	date    dw      ?
	T_Th    db      ?
	Th      db      ?
	Hu      db      ?
	Tens    db      ?
	Ones    db      ?
;---------------------------------

	A DT 34A03221D0401CBB050Ah
	S DB 0 ; количество единиц
	TEN DB ?
	ED DB ?
	str1 db 10,13,'Kolichestvo edinits v yacheike A = $'
	str0 db 'Soderzhimoe ishodnoi yacheike A iz 10 baitov:',10,13,'$'

;------ГЛАВНАЯ ПРОЦЕДУРА----------
MAIN 	PROC	NEAR	

	mov bp,0 	; номер байта из десяти --> 0
	mov cx,10 	; цикл по количеству байтов

	; ***** Начало внешнего цикла ******************
	m1: push cx ; сохраняем в стеке счетчик цикла
	mov al,byte ptr [A+bp] ;загружаем в al bp-тый байт
	
	; **** внутренний цикл по 8 битам
	mov cx,8 	; цикл по количеству битов в байте
	m2: test al,00000001b ; проверяем нулевой бит байта
	je m3 		; если он=0, то продолжаем цикл
	add s,1 	; наращиваем счетчик единиц
	m3: shr al,1 ; сдвигаем al вправо на один бит
	loop m2 	; конец цикла по количеству битов в байте
	; конец внутреннего цикла по битам

	add bp,1 	; переходим к следующему байту
	pop cx 		; извлекаем из стека счетчик цикла
	loop m1 	; конец цикла по количеству байтов

	; ****** конец внешнего цикла
	mov ah,09h
	lea dx,str0
	int 21h

	; *** Вывод исходного числа в двоичном виде
	mov bp,9
	mov cx,10
	m23: push cx
	mov bl,byte ptr [A+bp]

	; распечатка одного байта
	mov cx,8
	m25: push cx
	test bl,10000000b

	je m26
	mov ah,02h 	; там стоит 1. Выводим.
	mov dl,'1'
	int 21h
	jmp m27
	m26:		; там стоит 0. Выводим.
	mov ah,02h
	mov dl,'0'
	int 21h
	m27: shl bl,1 ; сдвиг влево на 1 бит
	pop cx
	loop m25
	mov ah,02h 	; выводим пробел после вывода 8 бит
	mov dl,' '
	int 21h
	sub bp,1 	; переходим к следующему байту
	pop cx
	loop m23
	; *** конец вывода исходного числа в двоичном виде

	; ------ вывод результата --------
	mov al,s
	cbw
	mov bl,10
	idiv bl 	; в al - десятки, в ah = единицы
	mov ten,al
	mov ed,ah

	; ---- вывод строки -----
	mov ah,09h
	lea dx,str1
	int 21h

	; ---- отображение символов на экран ----
	mov ah,02h 	; вывод десятков
	mov dl,ten
	add dl,30h
	int 21h
	mov ah,02h
	mov dl,ed 	; вывод единиц
	add dl,30h
	int 21h
	mov ah,08 	; задержка до нажатия клавиши
	int 21h
	ret

MAIN ENDP

; Процедура выводит результат вычислений, помещенный в data

DISP 	PROC 	NEAR 
;----- Вывод результата на экран ----------------
;--- Число отрицательное ?----------
        mov     ax,date               
        and     ax,1000000000000000b
        mov     cl,15
        shr     ax,cl
        cmp     ax,1
        jne     @m1
        mov     ax,date
        neg     ax

	push 	ax dx
        mov 	dl, '-'
	mov 	ah,02h
	int 	21h
	pop	dx ax
        jmp     @m2
;--- Получаем десятки тысяч ---------------
@m1:    mov     ax,date
@m2:    cwd     
        mov     bx,10000
        idiv    bx
        mov     T_Th,al
;------- Получаем тысячи ------------------------------
        mov     ax,dx
        cwd
        mov     bx,1000
        idiv    bx
        mov     Th,al
;------ Получаем сотни ---------------
        mov     ax,dx
        mov     bl,100
        idiv    bl
        mov     Hu,al
;---- Получаем десятки и единицы ----------------------
        mov     al,ah   
        cbw
        mov     bl,10
        idiv    bl
        mov     Tens,al
        mov     Ones,ah

;----------  Выводим цифры -----------------
@m500:  cmp     T_TH,0    ; проверка на ноль
        je      @m200
        mov     ah,02h    ; выводим на экран, если не ноль
        mov     dl,T_Th
        add     dl,48
        int     21h

@m200:  cmp     T_Th,0
        jne     @m300
        cmp     Th,0
        je      @m400
@m300:  mov     ah,02h
        mov     dl,Th
        add     dl,48
        int     21h

@m400:  cmp     T_TH,0
        jne     @m600
        cmp     Th,0
        jne     @m600
        cmp     hu,0
        je      @m700
@m600:  mov     ah,02h
        mov     dl,Hu
        add     dl,48
        int     21h

@m700:  cmp     T_TH,0
        jne     @m900
        cmp     Th,0
        jne     @m900
        cmp     Hu,0
        jne     @m900 
        cmp     Tens,0
        je      @m950
@m900:  mov     ah,02h
        mov     dl,Tens
        add     dl,48
        int     21h

@m950:  mov     ah,02h
        mov     dl,Ones
        add     dl,48
        int     21h     
        
        mov     ah,02h
        mov     dl,10
        int     21h
        mov     ah,02h
        mov     dl,13
        int     21h
;-------------------------------------
        mov     ah,08
        int     21h
        RET
DISP    ENDP 

CODESG		ENDS
		END 	BEGIN
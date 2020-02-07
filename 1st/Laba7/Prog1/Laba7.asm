CODESG		SEGMENT PARA 'CODE'
		ASSUME CS:CODESG
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
Gorod DB 30,'Accountant ',10,'Cleaner     ' ; 12 символов на город
DB 35,'Junior      ',70,'Programmer    '
DB 90,'Director    ',85,'Teamlead    '
DB 75,'Senior      ',20,'Anfanger    '
DB 40,'Middle      '
Rezult DB 12 Dup(?),'$'
Buf DB 3,3 Dup(?)
Distance DB ?
Mes DB 'There is no that position!$'
Eter DB 10,13,'$'
Podskaz DB 'Set the salary:$'


;------ƒ‹€‚€Ÿ Ž–…„“€----------

MAIN 	PROC	NEAR	

;------------------------------------- PROGRAM
; ------ Подсказка -------
mov ah,09
lea dx,podskaz
int 21h
; Ввод строки
mov ah,0ah
lea dx,Buf
int 21h
; Преобразование символов в число
; Получаем десятки из буфера
mov bl,buf+2
sub bl,30h
mov al,10
imul bl ; в al - десятки
; Получаем единицы из буфера
mov bl,buf+3
sub bl,30h
; Складываем ------
add al,bl
mov distance,al ; сохраняем в distance
; -------- Переход на новую строку ---
mov ah,09h
lea dx,eter
int 21h
; --- сканирование таблицы городов ----
cld ; искать слева направо

mov cx,117 ; сколько байт сканировать
lea di,gorod ; строка, где искать
mov al,distance ; что искать
repne scasb ; поиск
je @m2
; ------- Сообщение об отсутствии города
mov ah,09h
lea dx,Mes
int 21h
jmp @m3 ; выходим из программы
; -------- переписываем в результат
@m2:
cld
mov si,di
lea di,rezult
mov cl,12
rep movsb
; ----- Вывод результата ----
mov ah,09h
lea dx,rezult
int 21h
;-------------------------------------
@m3: mov ah,08
int 21h
ret
;-------don't touch-----
;mov date,ax
;call DISP	

MAIN ENDP
;-----------------------

CODESG		ENDS
		END 	BEGIN
MINIMUM macro p
	local @w4,@w5,@w6,@w7
	mov cl,dln ; счетчик цикла
	mov bp,0 ; индексный регистр
	@w4:
	mov al,spisok+bp
	cmp al,p
	je @w5
	jne @w6
	
	@w5: 

	;mov al, spisok+bp ; запоминаем позицию
	;mov poz, al
	;mov si,di
        ;dec di
        ;rep movsb
        ;dec dln
	;add bp,2
	mov al, cl
	;add bp,1
	CLD ; положить DF = 0 для обработки слева направо
	LEA SI, spisok+bp+1 ; занести смещение адреса SOURCE в SI
	LEA DI, spisok+bp;-1 ; занести смещение адреса DEST в DI
	mov ax,29
	sub ax,bp
	MOV CX, AX ; занести счетчик элементов в CX
	REP MOVS spisok+bp, spisok+bp+1
	mov cl,al
	;sub dln,1
	;lea si, spisok+bp+1
	;mov spisok+bp, si
	;sub bp,1
	;lea di, spisok+bp+1
	;mov cx, 29
	;cld
	;rep movsb

        ;mov cl,0
        ;mov ah,09h
	;lea dx,Mes2
	;int 21h


        ;loop @w4
        ;ret
	; сообщение об отсутствии числа
	@w6: 
	add bp,1 ; к след.элементу списка
	cmp cl,0
	je @w7
	loop @w4

	@w7:
	mov ah,09h
	;lea dx,Mes
	int 21h

endm

tanya segment para 'code'
assume cs:tanya, ds:tanya, ss:tanya, es:tanya
org 100h
begin: jmp main

;-------Данные -------------------
SPISOK db 7,13,15,18,20,21,22,24,27,30
       db 31,32,35,36,38,39,41,42,45,46
       db 47,50,53,58,62,73,75,80,82,85
sk db ?
dln db 30
Mes DB 'There is no that number!$'
Mes2 DB 'There is that number nibba!$'
pr db 10,13,'Which element do you want to delete ?', 10,13,'$'
buf db 4,4 dup(?)
ps db 10,13,'$'
des db ?
ed db ?
poz db ?
;otv db 10,13,'Minimum= $'
min db ?
;---------------------------------
main proc near
;-------Команды программы --------
call pechat
call skolko
call perehod
;************* Макровызов ********************************
MINIMUM sk
;****************************************************
sub dln,1
;call otvet
call perehod
call pechat
ret
main endp
; ************** Переход на новую строку **********
perehod proc near
mov ah,09
lea dx,ps
int 21h
ret
perehod endp
; ************** Читаем с экрана, сколько элементов взять из списка **********
skolko proc near
mov ah,09
lea dx,pr
int 21h
; Ввод строки
mov ah,0ah
lea dx,buf
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
mov sk,al ; сохраняем в sk
; -------- Переход на новую строку ---
mov ah,09h
lea dx,ps
int 21h
ret
skolko endp
;************* Выводим элементы списка на экран ****************************
pechat proc near
mov cl,dln ;sk
mov bp,0
@w3:
mov al,SPISOK+bp ; один элемент списка
cbw ; al --> ax
mov bl,10
idiv bl
mov des,al
mov ed,ah
; выводим десятки
mov ah,02
mov dl,des
add dl,30h
int 21h
; выводим единицы
mov ah,02
mov dl,ed
add dl,30h
int 21h
; выводим пробел
mov ah,02
mov dl,' '
int 21h

add bp,1 ; переход к следующему элементу
loop @w3
mov ah,09
lea dx,ps
int 21h
ret
pechat endp
;***********************************************************
;otvet proc near
;mov ah,09
;lea dx,otv
;int 21h
; вывод числа по одной цифре
;mov al,min
;cbw ; al --> ax
;mov bl,10
;idiv bl
;mov des,al
;mov ed,ah
;; выводим десятки
;mov ah,02
;mov dl,des
;add dl,30h
;int 21h
; выводим единицы
;mov ah,02
;mov dl,ed
;add dl,30h
;int 21h
;; перевод строки
;mov ah,09
;lea dx,ps
;int 21h
; ожидание нажатия на клавишу
;mov ah,08
;int 21h
;ret
;otvet endp
tanya ends
end begin
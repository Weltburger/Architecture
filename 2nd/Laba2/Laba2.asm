MINIMUM macro p
	local @w4,@w5
	mov min,127 ; большое число
	mov cl,p ; счетчик цикла
	mov bp,0 ; индексный регистр
	@w4:
	mov al,spisok+bp
	cmp al,min
	jge @w5
	; текущий элемент меньше минимума
	mov min,al
	@w5: add bp,1 ; к след.элементу списка
	loop @w4
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
pr db 10,13,'Sredi skolkih elementov iskat minimum ?', 10,13,'$'
buf db 4,4 dup(?)
ps db 10,13,'$'
des db ?
ed db ?
otv db 10,13,'Minimum= $'
min db ?
;---------------------------------
main proc near
;-------Команды программы --------
call skolko
call pechat
;************* Макровызов ********************************
MINIMUM sk
;****************************************************
call otvet
ret
main endp
; ************** Читаем с экрана, сколько элементов взять из списка **********
skolko proc near
; подсказка
mov ah,09
lea dx,pr
int 21h
; считываем с экрана число как строку
mov ah,0ah

lea dx,buf
int 21h
; преобразуем строку в число
cmp buf+1,1 ; сколько символов ввели ?
jne @w1
;один символ ввели
mov al,buf+2
sub al,30h
jmp @w2
@w1: ; две цифры
mov al,buf+2
sub al,30h
mov bl,10
imul bl
mov bl,buf+3
sub bl,30h
add al,bl
@w2: mov sk,al
; перевод строки
mov ah,09
lea dx,ps
int 21h
ret
skolko endp
;************* Выводим элементы списка на экран ****************************
pechat proc near
mov cl,sk
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
otvet proc near
mov ah,09
lea dx,otv
int 21h
; вывод числа по одной цифре
mov al,min
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
; перевод строки
mov ah,09
lea dx,ps
int 21h
; ожидание нажатия на клавишу
mov ah,08
int 21h
ret
otvet endp
tanya ends
end begin
CODESG segment
	ASSUME cs:CODESG
	ASSUME ds:CODESG
	ASSUME es:CODESG
	ASSUME ss:CODESG
	org 100h

begin:jmp main

;******************************************************************************
	X 		dd -2.2
	y 		dd ?
	result 		dd 56.76734865441256
	floatpart	dd ?
	tmp 		dd ?
	intpart		dd ?
	numb 		dw ?
	lenintpart 	dw 5
	lenfloatpart	dw 3
	tmpint		dw ?
	d 		dd 10.0
	print_str 	db 20 dup('$')
	separator 	db '.'
	sign		db ' '

;******************************************************************************
MAIN proc 
;------------------------------------------------------------------------------
fld result                 ; загружаем в ST(0)
fstp result		   ; выгружаем из ST(0) ячейку в result
call Out_DD_float
ret
;-------------------------------------
main endp

;*****************************************************************
;  Процедура вывода 4-байтового вещественного числа	     
;  Вход: переменная lenfloatpart (DW) = число знаков после точки
;        переменная result (DD) - число для вывода
;	 переменная  d (DD) - основание системы счисления
;  Выход: строка print_str (строка выводится на экран)
;  Исполузует: y(DD),intpart(DD),floatpart(DD),tmp(DD),
;              lenintpart(DW),separator(DB),tmpint(DW),
;              sign(DB), numb(DW)
;	{offset lenfloatpart = offset lenintpart + 2}
;	{offset sign         = offset separator  + 1}
;*****************************************************************

Out_DD_float proc near
;--------------------------------------
fld result	;загрузить в ST(0) переменную для вывода
lea si,result
add si,3
mov al,[si]
test al,80h
jz @positiv
	fchs
	mov sign,'-'
@positiv:
	fst tmp
	fld1
	fld tmp
	fprem
	fsub st(2),st
	mov cx,lenfloatpart
	mov lenfloatpart,cx
@floatpart_mul_10:
	fmul d
loop @floatpart_mul_10
	frndint
	fstp floatpart
	fstp tmp
	fstp intpart
;---------------------------------запись цифр в строку
mov cx,2
lea si,print_str
add si,lenintpart
add si,lenfloatpart
lea di,separator
lea bx,lenfloatpart
fld floatpart
@print_to_str:
	fst y
	push cx
	mov cx,[bx]
	@repeate_out_char:
		fld d
		fld y
		fprem
		fist numb
		fsub st(2),st
		fstp tmp
		fdiv
		fist tmpint
		fst y
		mov dx,numb
		mov ax,tmpint
		add dl,48
		mov [si],dl
		dec si
		cmp ax,0
	loopne @repeate_out_char
	fstp tmp
	mov al,[di]
	mov [si],al
	inc di
	dec si
	sub bx,2
	fld intpart
	pop cx
loop @print_to_str
fstp tmp
;------------------------------------Вывод строки на экран
inc si
mov dx,si
mov ah,09h
int 21h
ret
;--------------------------------------
Out_DD_float endp

;*****************************************************************************
codesg ends
end begin

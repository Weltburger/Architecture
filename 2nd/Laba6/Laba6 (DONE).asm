nata segment 'code'
assume cs:nata
org 100h
begin: jmp main
;--------------------------------- DATA
	X 		dd 2.2
	y 		dd ?
	result 		dd ?
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
	t 		dd 2.0
;---------------------------------
main proc near
;------------------------------------- PROGRAM
	;Y = tg(x*x / 4 + x / 2 + 1)
	;Y = arctg (ln (x)/2)
	finit;инициализирую FPU
	    fld1;загружаю 1
	    fld x;загружаю Х
	    ;fsub st(0),st(1); st(0)=X-1
	    ;fadd st(0),st(1)
	    fyl2x;Computes ST(1)*log2(ST(0)), stores the result in register ST(1), 
		;and pops the FPU register stack. The source operand in ST(0) must be a non-zero positive number.
	    fldln2;загружает константу натурального логарифма 2 в вершину стека сопроцессора.
	    fmul;Процессор может вычислить только логарифм по основанию 2.
		;поэтому полученное значение умножаем на натуральный логарифм от 2. 
		;И получаем натуральный логарифм от исходного числа.
	    ;fmul d; то что получилось умножаем на 10
	    fdiv t
	    fld1
	    FPATAN
	    fstp result; результат в переменную
	call Out_DD_float

ret
main endp


Out_DD_float proc near
;--------------------------------------
fld result	;§ £àã§¨âì ¢ ST(0) ¯¥à¥¬¥­­ãî ¤«ï ¢ë¢®¤ 
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
;---------------------------------§ ¯¨áì æ¨äà ¢ áâà®ªã
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
;------------------------------------‚ë¢®¤ áâà®ª¨ ­  íªà ­
inc si
mov dx,si
mov ah,09h
int 21h
ret
;--------------------------------------
Out_DD_float endp


nata ends
end begin
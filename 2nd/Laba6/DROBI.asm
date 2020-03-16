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
fld result                 ; ����㦠�� � ST(0)
fstp result		   ; ���㦠�� �� ST(0) �祩�� � result
call Out_DD_float
ret
;-------------------------------------
main endp

;*****************************************************************
;  ��楤�� �뢮�� 4-���⮢��� ����⢥����� �᫠	     
;  �室: ��६����� lenfloatpart (DW) = �᫮ ������ ��᫥ �窨
;        ��६����� result (DD) - �᫮ ��� �뢮��
;	 ��६����� �d (DD) - �᭮����� ��⥬� ��᫥���
;  ��室: ��ப� print_str (��ப� �뢮����� �� �࠭)
;  �ᯮ����: y(DD),intpart(DD),floatpart(DD),tmp(DD),
;              lenintpart(DW),separator(DB),tmpint(DW),
;              sign(DB), numb(DW)
;	{offset lenfloatpart = offset lenintpart + 2}
;	{offset sign         = offset separator  + 1}
;*****************************************************************

Out_DD_float proc near
;--------------------------------------
fld result	;����㧨�� � ST(0) ��६����� ��� �뢮��
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
;---------------------------------������ ��� � ��ப�
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
;------------------------------------�뢮� ��ப� �� �࠭
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

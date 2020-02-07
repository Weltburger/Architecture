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
n dw 40 ; количество разбиений
s dw 0 ; текущее значение суммы(интегралла)
a dw 0 ; начало отрезка
b dw 40 ; конец отрезка
tw dw 2
x dw ? ; текущая точка (всего n=40)
t dw ?


;------ƒ‹€‚€Ÿ Ž–…„“€----------

MAIN 	PROC	NEAR	

mov ax,a ; задаем начальную точку
mov x,ax
mov cx,39 ; счетчик цикла
m1:
; считаем f(x), т.е. в текущей точке
imul x ; dx:ax=x*x
add s,ax
mov ax,a
imul tw
add s,ax
add x,1 ; переходим к следующей точке
mov ax,x ;
loop m1
;---------------------------------
mov ax,s
cwd ; dx:ax=s
mov bx,40
idiv bx ; s/40 --> ax
mov s,ax

;-------don't touch-----
mov date,ax
call DISP	

MAIN ENDP
;-----------------------



; à®æ¥¤ãà  ¢ë¢®¤¨â à¥§ã«ìâ â ¢ëç¨á«¥­¨©, ¯®¬¥é¥­­ë© ¢ data

DISP 	PROC 	NEAR 
;----- ‚ë¢®¤ à¥§ã«ìâ â  ­  íªà ­ ----------------
;--- —¨á«® ®âà¨æ â¥«ì­®¥ ?----------
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
;--- ®«ãç ¥¬ ¤¥áïâª¨ âëáïç ---------------
@m1:    mov     ax,date
@m2:    cwd     
        mov     bx,10000
        idiv    bx
        mov     T_Th,al
;------- ®«ãç ¥¬ âëáïç¨ ------------------------------
        mov     ax,dx
        cwd
        mov     bx,1000
        idiv    bx
        mov     Th,al
;------ ®«ãç ¥¬ á®â­¨ ---------------
        mov     ax,dx
        mov     bl,100
        idiv    bl
        mov     Hu,al
;---- ®«ãç ¥¬ ¤¥áïâª¨ ¨ ¥¤¨­¨æë ----------------------
        mov     al,ah   
        cbw
        mov     bl,10
        idiv    bl
        mov     Tens,al
        mov     Ones,ah

;----------  ‚ë¢®¤¨¬ æ¨äàë -----------------
@m500:  cmp     T_TH,0    ; ¯à®¢¥àª  ­  ­®«ì
        je      @m200
        mov     ah,02h    ; ¢ë¢®¤¨¬ ­  íªà ­, ¥á«¨ ­¥ ­®«ì
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
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
A dw 10
B dw 5
Y dw ?
Z1 dw ?
Z2 dw ?
Z3 dw ?
adres dw ?


;------ƒ‹€‚€Ÿ Ž–…„“€----------

MAIN 	PROC	NEAR	

mov ax,A
sub ax,B ; ax=A-B
mov Z1, ax ; Z1=A-B

mov ax,A
neg ax
add ax,B ; ax=-A+B
mov Z2, ax ; Z2=-A+B

mov ax,A
add ax,B ; ax=-(A+B)
neg ax
mov Z3, ax ; Z3=-(A+B)

push Z1 
push Z2
push Z3
call myproc ; в верхушке стека адрес возврата,под ним 100 и 50
pop ax ; достаем ответ из стека (стек теперь пустой)
;pop Y
;mov ax,Y

;-------don't touch-----
mov date,ax
call DISP	

MAIN ENDP
;-----------------------


myproc proc near

pop adres ; достаем из стека адрес возврата в ячейку adres
; -- команды задания

pop Z3
pop Z2
pop Z1 

cmp Z1,0
je m1 ; Z1 равно нулю, уходим на метку m1
;mov Y,3; Z!=0 ---------------------------------------
jne m2 ; на m2, если не равно
jmp konec

m1: ; Z равно 0
mov Y,0
jmp konec

m2: ; Z!=0
cmp Z2,0
je m3 
jne m4
jmp konec

m3: 
mov Y,1
jmp konec

m4: ; Z2!=0
cmp Z3,0
je m5 
jne m6
jmp konec

m5: 
mov Y,2
jmp konec

m6: ; Z3!=0
mov Y,3
jmp konec

konec:  
push Y ; кладем в стек Y (ответ)

push adres

ret
myproc endp


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
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
A dw 0FD32h
OTV dw ?
MASKA dw 0000000011000000b


;------ƒ‹€‚€Ÿ Ž–…„“€----------

MAIN 	PROC	NEAR	

mov ax,A
and ax,MASKA ; получили 4 варианта
; первый вариант
cmp ax,0
jz m1
; второй вариант
cmp ax,40h
jz m2
cmp ax,80h
jz m3
; результат 0000 0000 1100 0000
mov OTV,3
jmp konec
m1: ; результат 0000 0000 0000 0000
mov OTV,0
jmp konec
m2: ; результат 0000 0000 0100 0000
mov OTV,2
jmp konec
m3: ; результат 0000 0000 1000 0000
mov OTV,1
konec: mov ax,OTV

;-------don't touch-----
mov date,ax
call DISP	
ret
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
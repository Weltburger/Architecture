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
a db 2


;------������� ���������----------

MAIN 	PROC	NEAR	

mov al,21
cbw
mov bl,7
idiv bl
add a,3
mov bl,a
imul bl
sub ax,5
add ax,569

;-------no tach-----
mov date,ax
call DISP	

MAIN ENDP

; ��楤�� �뢮��� १���� ���᫥���, ����饭�� � data

DISP 	PROC 	NEAR 
;----- �뢮� १���� �� �࠭ ----------------
;--- ��᫮ ����⥫쭮� ?----------
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
;--- ����砥� ����⪨ ����� ---------------
@m1:    mov     ax,date
@m2:    cwd     
        mov     bx,10000
        idiv    bx
        mov     T_Th,al
;------- ����砥� ����� ------------------------------
        mov     ax,dx
        cwd
        mov     bx,1000
        idiv    bx
        mov     Th,al
;------ ����砥� �⭨ ---------------
        mov     ax,dx
        mov     bl,100
        idiv    bl
        mov     Hu,al
;---- ����砥� ����⪨ � ������� ----------------------
        mov     al,ah   
        cbw
        mov     bl,10
        idiv    bl
        mov     Tens,al
        mov     Ones,ah

;----------  �뢮��� ���� -----------------
@m500:  cmp     T_TH,0    ; �஢�ઠ �� ����
        je      @m200
        mov     ah,02h    ; �뢮��� �� �࠭, �᫨ �� ����
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
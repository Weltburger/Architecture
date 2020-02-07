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
A DT 0A1B3C4FFF5F835D2A001h
SM DB ?
Stroka DB 10,13,'Max amount of 0 in a row=$'
ed DB ?
des DB ?
st1 DB 10,13,'Start value=',10,13,'$'


;------ƒ‹€‚€Ÿ Ž–…„“€----------

MAIN 	PROC	NEAR	

;********************* Вывод числа в двоичном виде ************
mov ah,9
lea dx,st1
int 21h
;-------- Вывод исходного данного ------------------------
mov cx,10
mov si,9
m1000: push cx
mov bl,byte ptr A+si ; берем один байт для вывода
;------------------------------------------
mov cx,8
m2000: shl bl,1
jc edin1
; выводим ноль
mov ah,02
mov dl,'0'
int 21h

jmp dalshe1
edin1:
; выводим единицу
mov ah,02
mov dl,'1'
int 21h

dalshe1:
loop m2000
;------------------------------------------
mov ah,02
mov dl,' '
int 21h

sub si,1
pop cx
loop m1000
;********************* конец вывода числа в двоичном виде ************

;-------Команды программы --------
mov SM,0 ; максимум нулевых битов
mov bp,9 ; определяем индекс
mov bl,0 ; сколько нулей в текущей цепочке
;---------------Внешний цикл -----------------------------
mov cx,10 ; цикл по количеству байтов
m1:
mov al,byte ptr A+bp ; загружаем очередной байт
push cx ; сохраняем счетчик цила

; ---- цикл по битам байта --------********************************

mov cx,8
m4:
test al,10000000b ; проверяем нулевой бит
jnz m2 ; если = 1 ( <>0 )
; если ноль
add bl,1 ; если=0,то s+1
jmp m3 ; уходим на сдвиг
m2: ; цепочка нулей оборвалась
cmp bl,sm ; сравниваем с максимумом
jle m10 ; если <=
; количество нулей в тек. цепочке > sm
mov sm,bl ; если bl>max,то sm=bl
m10: mov bl,0 ; обнуляем счетчик нулей
m3: shl al,1 ; сдвигаем байт вправо на 1
loop m4
; ----------------------------------**********************************

sub bp,1 ;переходим к следующему байту
pop cx ;восстанавливаем счетчик цикла
loop m1 ;конец цикла по байтам
;--------------конец внешнего цикла ------------------------

cmp bl,sm ; сравниваем с максимумом
jle m5
mov sm,bl ; если bl>max,то sm=bl
m5:
;------- вывод строки ----------------------
mov ah,09h
lea dx,stroka
int 21h
;------- вывод результата ----------------------

mov al,sm
cbw ; al---> ax
mov bl,10
idiv bl ; al-частное ah-остаток
mov ed,ah ; сохраняем единицы
mov des,al ; сохраняем десятки
cmp des,0
je m12
; выводи десятки
mov ah,02h
mov dl,des
add dl,30h
int 21h
; выводим единицы
m12: mov ah,02h
mov dl,ed
add dl,30h
int 21h
; ожидание нажатие на клавишу
mov ah,08
int 21h
ret
;-------don't touch-----
;mov date,ax
;call DISP	

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
;-------------------------------------
CODESG		ENDS
		END 	BEGIN
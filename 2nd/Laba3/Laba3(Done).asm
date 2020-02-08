; Вариант 4
; Y[k] = 4*X[k]/X[2N-k] + k**2*X[N+1-k]/(k+1)/X[k+1] N=5 k=1,2,...5

; Z[k] = (k+1)**2*X[k+1]**2+(N+1-k)**2*X[N+1-k]**2 N=6 k=1,2,...6

; po = (k+1)**2, pt = X[k+1]**2, pth = (N+1-k)**2, pf = X[N+1-k]**2 
; kpo = k+1, npomk = N+1-k
nata segment 'code'
assume cs:nata, ds:nata, ss:nata, es:nata
org 100h
begin: jmp main
;------------Для ввода ---------------------
Buf db 7,7 DUP(?)
datev dw 0
mnoj dw ?
ps dw 10,13,'$'
;------------Для вывода ---------------------
date dw ?
my_s db '+'
T_Th db ?
Th db ?
Hu db ?
Tens db ?
Ones db ?
;---------------------------------
Q dw ?
T dw ?
N dw 6
k dw ?
po dw ?
pt dw ?
pth dw ?
pf dw ?
bpo dw ?
bpt dw ?
kpo dw ?
npomk dw ?
vvodX db 10,13,'Enter an array element X!',10,13,'$'
vivX db 10,13,'Array X:',10,13,'$'
vivY db 10,13,'Array Y:',10,13,'$'
X dw 11 DUP(?)
Y dw 6 DUP(?)
;---------------------------------
main proc near
; *************** Заполнение массива X ***************
mov cx,11 ; 11 элементов массива X
lea si,X ; загружаем в si адрес первого элемента массива X
@XVVOD:
push cx ; сохраняем в стеке счетчик цикла
; Выводим подсказку
mov ah,09
lea dx,vvodX
int 21h
; вводим один элемент массива
call vvod
mov ax,datev ; datev - очередной элемент
mov [si],ax ; сохраняем элемнет по адресу
add si,2 ; наращиваем адрес на 2
pop cx
loop @XVVOD
; *************** конец заполнения массива X ***************
;*************** Вывод массива X **********************
mov ah,09

lea dx,vivX
int 21h
mov cx,11
lea si,X ; адрес первого элемента
@XVIVOD:
push cx
mov ax,[si] ; берем очередной элемент
mov date,ax
; выводим элемент на экран
call vivod
add si,2 ; наращиваем адрес на 2
pop cx
loop @XVIVOD
; перевод строки
mov ah,09
lea dx,ps
int 21h
; *************** Конец вывода массива X ***************
; ********** Расчёт элементов массива Y
mov cx,6 ; считаем 6 элементов массива Y
mov k,1 ; просто значение K
mov bp,0 ; индекс элемента в массиве Y
@MY:
push cx
; ***** Считаем первое слагаемое ************
; считаем адрес элемента K
;(k+1)**2
mov ax,k
add ax,1 ; ax=k+1
mov kpo, ax ; kpo=ax=k+1
mov bx, ax
imul bx ; ax=(k+1)**2
mov po,ax
;X(k+1)**2
mov ax,kpo
sub ax,1 ; ax=(k+1)-1
mov bx,2
imul bx ; ax=((k+1)-1)*2
mov si,ax ; si=ax=((k+1)-1)*2
mov ax,word ptr [X+si] ; берем элемент X(k+1)
mov bx, ax ; X(k+1)
imul bx ; X(k+1)**2
mov pt,ax ; pt=ax=X(k+1)**2
;(N+1-k)**2
mov ax,N
add ax,1
sub ax,k
mov npomk, ax ; npomk=ax=(N+1-k)
mov bx, ax
imul bx ; ax=(N+1-k)**2
mov pth,ax ; pth=ax=(N+1-k)**2
; X[N+1-k]**2 
mov ax,npomk
sub ax,1 ; ax=(N+1-k)-1
mov bx,2
imul bx ; ax=((N+1-k)-1)*2
mov si,ax ; si=ax=((N+1-k)-1)*2
mov ax,word ptr [X+si] ; берем элемент X(N+1-k)
mov bx,ax
imul bx ; ax=X(N+1-k)**2
mov pf,ax ; pf=ax=X(N+1-k)**2
; складываем слагаемые
mov ax,po
mov bx,pt
imul bx ; ax=(k+1)**2*X[k+1]**2
mov bpo,ax
mov ax,pth
mov bx,pf
imul bx ; ax=(N+1-k)**2*X[N+1-k]**2
add ax, bpo

;mov bpt,ax
;mov ax,bpo
;add ax,bpt ; ax=(k+1)**2*X[k+1]**2+(N+1-k)**2*X[N+1-k]**2

; заносим высчитанное в элемент массива Y
mov Y+bp,ax
; наращиваем k на 1
add k,1
; переходим к след.элементу массива Y

add bp,2
pop cx
sub cx,1
cmp cx,0
je @FIN
jmp @MY



; *************** Вывод массива Y ***************
@FIN: mov ah,09
lea dx,vivY
int 21h
mov cx,6
lea si,Y ; адрес первого элемента
@YVIVOD:
push cx
mov ax,[si] ; берем очередной элемент
mov date,ax
; выводим элемент на экран
call vivod
add si,2 ; наращиваем адрес на 2
pop cx
loop @YVIVOD
; перевод строки
mov ah,09
lea dx,ps
int 21h
; *************** Конец вывода массива Y ***************
mov ah,08
int 21h
ret
main endp
; *************** Ввод одного элемента массива X ***************
vvod proc near
mov datev,0
; ввод числа в виде символов
mov ah,0ah
lea dx,buf
int 21h
; получаем количество введенных символов
mov mnoj,1
mov cl,byte ptr buf+1 ; сколько символов(цифр)
mov ch,0
mov bp,cx
add bp,1 ; адрес последней цифры
@m1000:
; берем одну цифру
mov al,byte ptr buf+bp
sub al,30h
cbw
imul mnoj ; ax=цифра*10^
add datev,ax

; умножаем множитель на 10
mov ax,10
imul mnoj
mov mnoj,ax
sub bp,1
loop @m1000
mov ah,09
lea dx,ps
int 21h
ret
vvod endp
vivod proc near
;--- Число отрицательное ?----------
mov ax,date
and ax,1000000000000000b
mov cl,15
shr ax,cl
cmp ax,1
jne @m1
mov ax,date
neg ax
mov my_s,'-'
jmp @m2
;--- Получаем десятки тысяч ---------------
@m1: mov ax,date
@m2: cwd
mov bx,10000
idiv bx
mov T_Th,al
;------- Получаем тысячи ------------------------------
mov ax,dx
cwd
mov bx,1000
idiv bx
mov Th,al
;------ Получаем сотни ---------------
mov ax,dx
mov bl,100
idiv bl
mov Hu,al
;---- Получаем десятки и единицы ----------------------
mov al,ah
cbw
mov bl,10
idiv bl
mov Tens,al
mov Ones,ah
;--- Выводим знак -----------------------
cmp my_s,'+'
je @m500
mov ah,02h

mov dl,my_s
int 21h
;---------- Выводим цифры -----------------
@m500: cmp T_TH,0 ; проверка на ноль
je @m200
mov ah,02h ; выводим на экран, если не ноль
mov dl,T_Th
add dl,48
int 21h
@m200: cmp T_Th,0
jne @m300
cmp Th,0
je @m400
@m300: mov ah,02h
mov dl,Th
add dl,48
int 21h
@m400: cmp T_TH,0
jne @m600
cmp Th,0
jne @m600
cmp hu,0
je @m700
@m600: mov ah,02h
mov dl,Hu
add dl,48
int 21h
@m700: cmp T_TH,0
jne @m900
cmp Th,0
jne @m900
cmp Hu,0
jne @m900
cmp Tens,0
je @m950
@m900: mov ah,02h
mov dl,Tens
add dl,48
int 21h
@m950: mov ah,02h
mov dl,Ones
add dl,48
int 21h
mov ah,02h
mov dl,' '
int 21h
ret
vivod endp
nata ends
end begin
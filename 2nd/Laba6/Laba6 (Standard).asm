FINIT ; инициализация математического сопроцессора
FLD X ; ST(0) = x = –1.3
FLD CHETIRE ; ST(0) = 4; ST(1) = x = –1.3
FDIV ; ST(0) = x / 4 = –0.325
FLD X ; ST(0) = –1.3 ST(1) = –0.325
FMUL ; ST(0) = x*x / 4 = 0.4225
FSTP TIME ; TIME = x*x / 4 = 0.4225
FLD X ; ST(0) = x = –1.3
FLD DWA ; ST(0) =2 ST(1) = x = –1.3
FDIV ; ST(0) = x / 2 = –0.65
FADD TIME ; ST(0) = x*x / 4 + x / 2 = –0.65 + 0.4225 = –0.2275
FLD1 ; ST(0) =1; ST(1) = x*x / 4 + x / 2 = –0.2275
FADD ; ST(0) = x*x / 4 + x / 2+1 = 0.7725
FPTAN ; ST(0) = 1; ST(1) = 0.9745
FSTP X ; X = 1
FSTP Y ; Y= 0.9745
extern ExitProcess
global start
%include "invoke.inc"

section .data
	eps: dd 0.0000000001
	x: dd 0.1
	n: dd 20
	z: dd 0
section .code
	start:
		finit
		fldz ; st6 abs (delta)
		fld1 ; st5 (one)
		fld1 ; st4 (res) cos
		fld1 ; st3 (delta)
		fld1 ; st2 (n)
		fadd st3 ; for step2
		fld dword[eps] ; st1
		fld dword[x] ; st0
		
		;step2
		fmul st0 ; x^2
		fst st3 ; delta = x^2
		;fxch st3 ; st0 = delta
		fdiv st2 ; delta = x^2/2!
		fchs ; delta = ( (-1)*x^2 )/2! 
		fadd st4, st0 ;res = res+delta
		
		.calc_cos:
			fchs ; delta = -delta
			fmul st3 ; delta * x
			fxch st2 ; st0 = n
			fadd st5; n = n+1
			fdiv st2, st0 ; res/n
			fadd st5; n = n+1
			fdiv st2, st0 ; res/n
			fxch st2 ; st0 = delta
			fadd st4, st0 ; res = res + delta
			fst st6
			fabs
			fcomi st0, st1 ; if (delta > eps)
			fxch st6
			ja .calc_cos ; jump calc	
		;cos is in st0 now
		;we will load it in st1 and res will be in st0
			fxch st4
			fldz ; st0=0, st1=cos(x)
			fadd st1 ; st0 = st0 + st1;
			
			mov ecx, dword[n] ; ecx = n
			.calc_func:
				fmul st0 ;(cos(x))^n
				fadd st1, st0 ; res = res + ( cos(x) )^n
			loop .calc_func
			fstp dword[z]
			fstp dword[z]
			
			invoke ExitProcess, 0 ; else exit
		
		
		
		
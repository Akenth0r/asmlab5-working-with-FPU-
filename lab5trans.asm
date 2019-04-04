extern ExitProcess
global start
%include "invoke.inc"

;t = cos(x) + cos^2(x)+...+cos^n(x), 1<=n<=32
section .data
	n: dd 12
	x dd 1.4
	n dd 12
	z dd 0 ; result
section .code
	start:
		finit
		fld dword[x]
		fcos ; cos(x)
		mov ecx, dword[n]
		fldz
		fxch st0, st1
		
		.cycle:
			fadd st1, st0
			fmul st0, st0
		loop .cycle
		
		fstp dword[z]
		fstp dword[z]
	
		invoke ExitProcess, 0
	
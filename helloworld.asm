; AddTwo.asm - adds two 32-bit integers.
; Chapter 3 example

Include Irvine32.inc

.data
val1 dword 4040h
val2 dword 1555h
sum dword 0h

;after step 1, the hex value of eax is 8 h
;after step 2, the hex value of eax is C h
;after step 3, the hex value of eax is B h

.code
main proc
	
	mov eax,8h
	
	call DumpRegs	

	add eax,4h
	
	call DumpRegs	

	sub eax,1h

	call DumpRegs				

	invoke ExitProcess,0
main endp
end main
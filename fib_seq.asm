COMMENT !
	An ASM program that reads an integer number N and then displays the first N values 
	of the Fibonacci number sequence, described by:
	Fib(0) = 0, Fib(1) = 1, Fib(N) = Fib(N-2) + Fib(N-1)
	Thus, if the input is N = 10, your program Ass_1-b.exe should display the following single line:
	Fibonacci sequence with N = 10 is:  0   1   1   2   3   5   8   13   21   34   55
!

include Irvine32.inc

.data
N DWORD ? 
blank_space BYTE " ",0
prompt BYTE "Input a number for the sequence: ",0
msg1 BYTE "Fibonacci sequence with N = ",0
msg2 BYTE "is: ",0

.code
main PROC

;prompt message for user
mov edx, OFFSET prompt 
	call WriteString

;read number
	mov	 edx,N 
	call ReadInt

    mov ecx,eax
    
	COMMENT !
	---------------Fibonacci Sequence here-------------
	!
	
	;Message
	mov edx, OFFSET msg1 
	call WriteString
	call WriteDec
	mov edx, OFFSET blank_space
	call WriteString
	mov edx, OFFSET msg2 
	call WriteString

	;Fib(0) = 0, Fib(1) = 1
	mov  eax, 0    
    mov  esi, 1    
	call WriteDec
	mov edx, OFFSET blank_space
	call WriteString

L1:
;Fib(N) = Fib(N-2) + Fib(N-1)
    mov  edx, eax 
    add  edx, esi 
	dec ecx
    mov  eax, esi
    mov  esi, edx  
	call WriteDec

	;print blank space
	mov edx, OFFSET blank_space 
	call WriteString

	cmp ecx,0
	jnz L1

	call CRLF
	
	exit
main ENDP

END main
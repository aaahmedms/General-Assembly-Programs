COMMENT !
	Problems 1,2,3 are completed below.
	Problem 4 is incomplete so it has been commented out.
!


Include Irvine32.inc
.data   
        input1      BYTE    "Input X value: ", 0
        input2      BYTE    "Input Y value: ", 0
		input3      BYTE    "Input N value for factorial procedure: ", 0
		msg4      BYTE    "Sieve of Eratosthenes: ", 0
		blank_space BYTE    " ", 0
        msg   BYTE    "GCD: ", 0
		msg2   BYTE    "Recursive GCD: ", 0
		msg3   BYTE    "Factorial result: ", 0
        xVal        DWORD   ?
        yVal        DWORD   ?       
		N	DWORD	?
		
		myArray SDWORD 100 DUP (?) 
		primeArray DWORD 100 DUP (?) 
		tempNum DWORD 1
		counter DWORD 0
	
.code
main PROC       
		
        mov edx, OFFSET input1         ;get x value as user input1
        call WriteString

		mov eax, 0
        call ReadInt
		;get absolute value of x
		mov ecx, eax ;hold eax temporarily
		neg eax
		cmovl eax, ecx ;if eax is negative, set it back to positive
        mov xVal, eax


        mov edx, OFFSET input2          ;get y value as user input2
        call WriteString
        call ReadInt
		;get absolute value of y
		mov ecx, eax ;hold eax temporarily
		neg eax
		cmovl eax, ecx ;if eax is negative, set it back to positive
        mov yVal, eax
        call Crlf

		;inputted values are pushed onto the stack

        ;problem 1
		push yVal                       
        push xVal
        call GCD

		;problem 2
		push yVal                       
        push xVal
		call GCD_Rec

		call CRLF

		;problem 3
		call Factori

		call CRLF

		COMMENT !
		;Incomplete, this wasn't finished on time
		;problem 4
		 mov edx, OFFSET msg4         
        call WriteString
		call CRLF
		call SieveEratos
		!
     	call Dumpregs

        exit
main ENDP

COMMENT !
	Problem #1 -------------------------------
!

GCD PROC
    mov edx,0                       ;edx has to be cleared before dividing to avoid integer overflow
    mov eax, DWORD ptr[esp+4]       ;get value from stack pointer for x
    mov ebx, DWORD ptr[esp+8]       ;get value from stack pointer for y

	do_while:
		div ebx                         ;x/y for x % y where eax = x and edx = remainder
		mov eax, ebx                    ;x = y
		mov ebx, edx                    ;y = n
		mov edx,0						;edx has to be cleared before dividing to avoid integer overflow
		cmp ebx, 0                      ;check if remainder > 0
		jg do_while                     ;y > 0   

			;print message for gcd
			mov edx, OFFSET msg
			call WriteString

			call WriteDec         
			call Crlf
			ret 8                           ;clear stack, remove 8 bytes from the stack

GCD ENDP

COMMENT !
	Problem #2 -----------------------
!
GCD_Rec PROC
here:
	mov edx,0                       ;edx has to be cleared before dividing to avoid integer overflow
    mov eax, DWORD ptr[esp+4]       ;get value from stack pointer for x
    mov ebx, DWORD ptr[esp+8]       ;get value from stack pointer for y

		;If (b == 0)
        cmp  ebx,0           
        je   return_a				;If (b == 0), then return a

		;else, a = b and b =  (a % b) 
		div ebx						;a/b with remainder for (a % b) where edx = remainder
		mov [esp+4],ebx				;store b in older a, b = a of  GCD(b, a % b)
		mov [esp+8],edx				;store remainder on older b, (a % b) = b of GCD(b, a % b)
		jmp here
        call GCD_Rec				;recursively call the function again
		ret 

 return_a:      
	;print message for recursive gcd
	mov edx, OFFSET msg2
	call WriteString

	call WriteDec                 
	call Crlf
    ret 8                           ;clear stack, remove 8 bytes from the stack
GCD_Rec ENDP

COMMENT !
	Problem #3 -------------------------------
!

Factori PROC
		;user input for factorial function
		mov edx, OFFSET input3          ;get N value as user input3
        call WriteString
        call ReadInt
		mov N, eax

		mov eax,N
		mov ebx,eax 
		loopJ:
			dec ebx
			AND ebx,ebx
			je exit_loop
			mul ebx 
		jmp loopJ
		
	exit_loop:
		;print message for factorial result
		mov edx, OFFSET msg3
		call WriteString

		call WriteDec
		call Crlf
		ret

Factori ENDP

COMMENT !
;--------------------INCOMPLETE-----------------------------------
	SieveEratos PROC
		mov eax, 1
		mov ebx, 0
		mov ecx, 100

		loop1:
			mov myArray[ebx], eax
			inc eax
			add ebx, 4
		loop loop1

		;Sieve of Eratos
		mov eax,0
		mov ecx, 100
		mov ebx, 0
		mov esi,2

		outterLoop:
				cmp myArray[ebx],-1
				je end_loop
				;if not equal to 1
					innerLoop:
					;for (eax = 2*myArray[ebx]-2; eax<100; eax+=myArray[ebx])
					; myArray[eax]=-1;
						mov eax,myArray[ebx]
						mul esi
						sub eax,2
						mov myArray[eax],-1

						call writeDec

						;print space
						mov edx, OFFSET blank_space
						call WriteString

						cmp eax,100
						call dumpregs
						add eax,myArray[ebx]
						jl innerLoop
					
			end_loop:
		  add ebx,4
		loop outterLoop

		;SHOW ARRAY
		mov ecx, 100
		mov ebx, 0
		loop2:
			mov eax,primeArray[ebx]
			add ebx, 4
			call WriteDec

			;print space
			mov edx, OFFSET blank_space
			call WriteString
		loop loop2
		call CRLF

	ret

	SieveEratos ENDP
!
		

END main

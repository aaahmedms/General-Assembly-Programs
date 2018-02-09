COMMENT !
	an ASM program that will count the total number of characters, 
	the number of lowercase characters,
	the numbers of decimal digits, 
	and the number of blank characters contained in a text.
	Alternative 1 is used.
!

INCLUDE Irvine32.inc 
.data 
prompt BYTE "Enter lines of text, program will exit when a period is entered: ",0
prompt1 BYTE "This file contains ",0
prompt2 BYTE " characters out of which, ",0
prompt3 BYTE " are lowercase characters; ",0
prompt4 BYTE " are decimal numbers; and, ",0
prompt5 BYTE " are blank characters. ",0

myStr BYTE 128 DUP(?) 
strSize DWORD ? 
count_lowerc DWORD 0
count_decimal DWORD 0
count_blank DWORD 0

.code 
main PROC 

	;prompt message
	 mov edx, OFFSET prompt 
	 mov ecx, 127 
	 call WriteString
	 call crlf

	 mov ecx, 0 
;Reads character by character, includes input of new line and backspacing
continue:
	 CALL ReadChar ;char in al
	  cmp al,'.' ;is it a .
	  je stop    ;if yes then stop

	  cmp al,8  ;check if backspace
	  je ne_backspace 

	  cmp al,13  ;check if carriage return
	  je ne_line 

	  call WriteChar
	  mov myStr[ecx],al
	  inc ecx
	  JMP continue

	 ne_line:
	    call crlf
	    JMP continue

	 ne_backspace:
	    mov al,8 ;backspace
		call WriteChar
		mov al,32
		call WriteChar
		mov al,8 ;backspace
		call WriteChar
		dec ecx
	    JMP continue
stop:
	  mov al,'.' ;print period
	  mov myStr[ecx],al
	  inc ecx
	  call WriteChar
	 ;----------------------------------------

	  

	 ;loop through string
	 mov strSize,ecx
	 mov esi,0 

	L1: 
		 movzx eax,myStr[esi] 

		;--------	count the lowercase ------------------------------------

		cmp eax,'a'  ;check if string is lowercase
		jge is_lowercase
		jmp check1			;else ignore and skip to next check

		is_lowercase:
		cmp eax,'z'				;if(eax <= 90), 90 = Z, then lowercase
		jle inc_lower			;then the character is between 65 and 97 so uppercase, jump to inc_lower

		inc_lower:
		inc count_lowerc
		jmp check1

		;---------------------------------------------

		check1:
		;-------- count the blank space ------------------------------------
		cmp eax,' '  ;check if string is blank space
		je is_blankspace
		jmp check2			;else ignore and skip to next check

		is_blankspace:
		inc count_blank
		jmp check2			;else ignore and skip to next check
		
		;---------------------------------------------

		check2:
		;-------- count the number of decimals ------------------------------------
		cmp eax,'0'  ;check if string is a decimal number
		jge is_decimal
		jmp continn_prog			;else ignore and skip to next check

		is_decimal:
		cmp eax,'9'				;if(eax <= 90), 90 = '9', then lowercase
		jle inc_decim			;then the character is decimal between 0 and 9, jump to inc_decim
		jmp continn_prog

		inc_decim:
		inc count_decimal
		jmp continn_prog
		
		;---------------------------------------------

		continn_prog:
		 inc esi 
	loop L1 
	

	;Prompt ending message
	call crlf

	 mov edx, OFFSET prompt1
	 call WriteString

	 ;number of characters
	 mov eax, strSize 
	 call WriteDec

	 ;Prompt ending message
	 mov edx, OFFSET prompt2
	 call WriteString
	 call crlf

	 ;number of lowercase characters
	 mov eax, count_lowerc 
	 call WriteDec
	 
	 
	 ;Prompt ending message
	 mov edx, OFFSET prompt3
	 call WriteString

	 ;number of lowercase characters
	 mov eax, count_decimal 
	 call WriteDec
	 
	 ;Prompt ending message
	 mov edx, OFFSET prompt4
	 call WriteString

	 ;number of blankspace characters
	 mov eax, count_blank 
	 call WriteDec

	 ;Prompt ending message
	 mov edx, OFFSET prompt5
	 call WriteString

	 call crlf

 invoke ExitProcess,0 
main ENDP 
END main

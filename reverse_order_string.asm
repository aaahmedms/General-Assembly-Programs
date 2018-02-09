COMMENT !
	An ASM program that prompts the user to enter a string of at most 128 characters 
	and then displays the string in reverse order, with each upper-case letter 
	converted to its corresponding lower-case letter. 
!

INCLUDE Irvine32.inc

.data
MAX = 129
prompt BYTE "Enter a string of at most 128 characters: ",0
prompt2 BYTE " ",0
prompt3 BYTE "Here it is in LOWERCASE and in reverse order: ",0
myStr BYTE MAX+1 DUP(?)
myStr2 BYTE MAX+1 DUP(?)
strSize DWORD ?

.code
main PROC

	;show prompt
	mov  edx,OFFSET prompt	
	call WriteString
	call crlf
	
	;Read string
	mov edx, OFFSET myStr
	mov ecx, (SIZEOF myStr) - 1
	call ReadString	
	mov strSize, eax

;show message before reverse output
	mov  edx,OFFSET prompt3	
	call WriteString
	call crlf

;print string in reverse order
;Set counter to string size
		mov ecx,strSize
		mov esi,0

	L1:	
	;check to see if character is uppercase
	movzx eax,myStr[ecx-1]
	cmp eax,'A'				;if(eax >= 'A'), then uppercase
	jge is_capital			;if uppercase, goto is_capital
	jmp store_char			;else its lowercase letter or something else, so store it

	  is_capital:
		cmp eax,'Z'				;if(eax <= 'Z'), then uppercase
		jle inc_lower			;then the character is between 'A' and 'Z' so uppercase, jump to inc_lower
		jmp store_char			;else its lowercase letter or something else, so store it

	 inc_lower:
		;convert to lower case
		mov al,myStr[ecx-1]
		add al,20h ;converts to uppercase 
		mov myStr[ecx-1],al  

	 store_char:
		movzx eax,myStr[ecx-1]
		mov myStr2[esi],al	; store string in variable myStr2 in reverse order	
		inc esi

	Loop L1

		;Display the reversed string
		mov edx,OFFSET myStr2
		call Writestring
		call Crlf
		call DumpRegs
	exit
main ENDP
END main
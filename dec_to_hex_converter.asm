COMMENT !
	NAME: Muhaimen Ahmed
	ID: 103997335 
	
	A program that takes in a decimal value inputted by the user, and converts it to
	a hexadecimal number using a set of procedures that call back to the previous procedure
	to print the value.
!

INCLUDE Irvine32.inc 
.data 
prompt BYTE "Input a number: ",0
N DWORD ? 

.code 
main PROC

;prompt message for user
mov edx, OFFSET prompt 
	call WriteString
	call crlf

	;read number
	mov	 edx,N 
	call ReadInt
	
	;user input is stored in bx
	mov ebx,0h
	mov	bx, ax
	jmp check  ;jump to check so the procedures don't run


COMMENT !
---------------Hex WORD PROCEDURE-------------
	Value is within the range 256 to 65535 but references back to the previous procedure
!
	DisplayHexWord proc
		mov ecx,0h ;clear ecx register to avoid any miscalculationsc
		mov	cx,bx	;since bx will be modified, the value is stored to cx temporarily
		mov bh, 0h  ;clear high bit values of bx so value is not misrepresented when converted
		mov	bl, ch  ;we start by displaying upper bit segment of the hexadecimal number
		call	displayHexByte

		mov	bl, cl	;lower bit segment is displayed next as a hexadecimal byte
		call	displayHexByte

		ret
	DisplayHexWord endp

COMMENT !
---------------Hex BYTE PROCEDURE-------------
	Value is within the range 16 to 255 but references back to the previous procedure
!
	DisplayHexByte proc

	;Upper bits of EBX are cleared
	and bx,0FFFFh
	mov eax, 0h
	mov ax,bx

	COMMENT !
	rotate until the upper half of byte is in the same position as the least significant byte, 
	vice versa for the lower half to be positioned to the most significant
	e.g. if ebx = 00000035 then 50000003
	Lower half of ebx containing bx is then printed in the displayHexDigit procedure
	!
		rol	eax, 28
		mov ebx,eax
		call displayHexDigit

		shr	ebx,28 ;least significant bits is moved to allow printing of next digit
		call displayHexDigit
		ret
	DisplayHexByte endp


COMMENT !
---------------Hex DIGIT PROCEDURE-------------
	Value is within the range 0 to 15, this procedure deals with single hex digit values
!

	DisplayHexDigit proc
		
		;check if number is between 10 and 15
		cmp	bx, 10         
		jae	conv_hex
		jmp	is_below
	
	;if number is below 10
	is_below:	
		add	bx, 48    ;ascii 0 is 48
		jmp show_HexDigit
	
	;if number is greater then 10
	conv_hex:
		add	bx, 55  ;ascii a is 65

		show_HexDigit:
				movzx	eax, bx  
				call WriteChar
				ret
	DisplayHexDigit endp

COMMENT !
---------------Program does checks after input-------------
!

check:
	; displayHexDigit if number is between 0 and 15
	cmp	bx, 0
	je	zero_print
	cmp	bx, 15
	jbe	DHexDigit
	ja checkByte
	jmp	main_done

	; displayHexByte if number is between 15 and 255
	checkByte:
		cmp	bx, 255
		jbe	DHexByte
		ja	DHexWord
		jmp	main_done

DHexDigit:
	call DisplayHexDigit
	call crlf
	jmp	main_done

DHexByte:
	call DisplayHexByte
	call crlf
	jmp	main_done

;displayHexByte if number is above 255, from 256 to 65535
DHexWord:
	call DisplayHexWord
	call crlf
	jmp	main_done

zero_print:
	mov eax,'0'
	call WriteChar
	call crlf
	
	main_done:
	;end program
	

 invoke ExitProcess,0 
main ENDP 
END main
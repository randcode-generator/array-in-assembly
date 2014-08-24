global main
 
extern printf
 
section .data
	array:			db 0xF204, 0x64
	array2:			dw 0x1260, 0x62
	array3:			dw 0x54, 0x32
	arraydb:		db 10, 33, 88, 99
	arraydw:		dw 77, 460, 120, 550
	fmtStr: 		db '%i',0xA,0

section .text
	main:

	; Read a byte from array
	; Note: 0xF204 is truncated to
	; 0x04 because array is declared
	; as byte (db)
	movzx	edx, byte[array]
	call 	printout

	; Read a word from array
	; Note: it will be interpreted as 0x6404
	; because it's stored backwards
	movzx	edx, word[array]
	call 	printout

	; Read a word from array2
	movzx	edx, word[array2]
	call 	printout

	; Read a word from array2
	; with 1 byte offset
	; Note: it will be interpreted as 0x6212
	movzx	edx, word[array2+1]
	call 	printout

	; Read a word from array3
	; with 1 byte offset
	; Note: it will be interpreted as 0x3200
	movzx	edx, word[array3+1]
	call 	printout

	; Loop through byte by byte arraydb
	mov 	ebx, 0
	loop:
	movzx	edx, byte[arraydb+ebx]
	call 	printout
	inc 	ebx
	cmp		ebx, 4
	jne		loop

	; Loop through word by word arraydb
	mov 	ebx, 0
	loop2:
	; Size of word is 2 byte, increment
	; by 2
	movzx	edx, word[arraydw+(ebx*2)]
	call 	printout
	inc 	ebx
	cmp		ebx, 4
	jne		loop2

	ret

	printout:
	; print out the argument
    sub     esp, 4
    mov     [esp], edx          ; Copy edx into address of esp
    ; Load the format string into the stack
    sub     esp, 4              ; Allocate space on the stack for one 4 byte parameter
    lea     eax, [fmtStr]       ; Load string into eax
    mov     [esp], eax          ; Copy eax into the address of esp
 
    ; Call printf
    call    printf              ; Call printf(3):
                     
	add     esp, 8				; pop stack by 8 (2 elements * 4 bytes each element)
	ret
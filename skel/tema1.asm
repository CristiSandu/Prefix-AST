%include "includes/io.inc"

extern getAST
extern freeAST
extern printf
section .data
    mystring db " ", 0
section .bss
    ; La aceasta adresa, scheletul stocheaza radacina arborelui
    root: resd 1
    vector: resd 200

section .text
global main

atoi:
    mov ebx, 0              ; Set initial total to 0
     
convert:
    movzx edx, byte [eax]   ; Get the current character
    test edx,edx           ; Check for \0
    je done
    
    cmp edx, 48             ; Anything less than 0 is invalid
    jl error
    
    cmp edx, 57             ; Anything greater than 9 is invalid
    jg error
     
    sub edx, 48             ; Convert from ASCII to decimal 
    imul ebx, 10            ; Multiply total by 10
    add ebx, edx           ; Add current digit to total
    
    inc eax                 ; Get the address of the next character
    jmp convert

error:
    mov ebx, [eax]             ; Return -1 on error
 
done:
    ret             

preordine:
     push ebp
     mov ebp, esp

     cmp DWORD[ebp+8],0
     jne printare
     jmp iesire
printare:
    mov eax,[ebp+8]
    mov eax,[eax]
    
    call atoi
    mov [vector +4*ecx], ebx
    inc ecx
    
    ;PRINT_DEC 4, ebx
    ;PRINT_STRING mystring
    
    mov eax,[ebp+8]
    mov eax,[eax+4]
    push eax
    call preordine
    
    mov eax,[ebp+8]
    mov eax,[eax+8]
    push eax
    call preordine
    
iesire:
    leave
    ret    
main:
    mov ebp, esp; for correct debugging
    ; NU MODIFICATI
    push ebp
    mov ebp, esp
    
    ; Se citeste arborele si se scrie la adresa indicata mai sus
    call getAST
    mov [root], eax

    ; Implementati rezolvarea aici:
    
 
   
    push eax 
    xor ecx,ecx
    call preordine
    ;;mov ecx,3
   ; NEWLINE
    dec ecx
   ; PRINT_DEC 4,ecx
  ;  NEWLINE
prin:
    push DWORD[vector + 4*ECX]
    ;PRINT_DEC 4, [vector + 4*ECX]
    cmp DWORD[vector + 4*ECX], '-'
    je plus
    loop prin
    ;PRINT_DEC 4,[vector]
    
plus:
     pop eax
     pop ebx
     sub eax,ebx
     push eax
    
     PRINT_DEC 4,eax
    ; NU MODIFICATI
    ; Se elibereaza memoria alocata pentru arbore
    push dword [root]
    
    call freeAST
     
    
    xor eax, eax
    leave
    ret

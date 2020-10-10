%include "includes/io.inc"

extern getAST
extern freeAST


section .bss
    ; La aceasta adresa, scheletul stocheaza radacina arborelui
    root: resd 1
    ;initializare vector cu un numar mare (cazul meu 100)
    vector: resd 100

section .text
global main


atoi:
    xor ebx,ebx             ;setez valoarea initiala la 0
     
convertire:
    movzx edx, byte [eax]   ;obtin primul caracter si extind cu zerouri 
    test edx,edx            ;testez dupa terminatorul de sir 
    je done
    
     
    cmp edx, 45             ;testez daca primul caracter este '-'        
    je tratare_minus
   
    
    cmp edx, 48             ; compar daca caracterul este mai mic ca '0'
    jl iesire_atoi          ; si daca da returnez sirul forma pana atunci    
    
    cmp edx, 57             ; compar daca caracterul este mai mare ca '9'
    jg iesire_atoi          ; si daca da returnez sirul forma pana atunci
   
   
    sub edx, 48             ; convertire din ascii in decimal  
    imul ebx, 10            ; multiplicam cu 10
    add ebx, edx            ; adaugam cifra la total
     
    urmatorul_element:   
    inc eax                 ;ia adresa urmatorul caracter
                
    jmp convertire

iesire_atoi:
    mov ebx, [eax]          ; salvez in ebx valoarea de la adreasa eax
    
done:
    cmp edi, 1              ;tratez numerele negative daca flagul edi e 1     
    je negare               ;jump la negarea numarului 
    jl iesire_negare        ;altfel ies din functie

tratare_minus:              
    cmp byte [eax+1], 0     ;tratez daca si valoarea urmatoare este terminator de sir
    je iesire_atoi          ;daca da jump la iesire_atoi care salveaza semnul in ebx
    mov edi,1               ;daca nu setez edi pe 1
    jmp urmatorul_element   ;jump inapoi in convertire
        
negare:
    dec ebx                 ;decrementez ebx daca numarul este negativ (am observat ca daca nu fac asta rezultatul in modul e mai mare cu o unitate)    
    not ebx                 ;neg ebx pentru a obtine numarul cu minus
    jmp iesire_negare       ;jump la iesire
         
iesire_negare:
    xor edi,edi             ;resetez edi
    ret                     ;ies din atoi



parcurgere_preordine:       
     push ebp               ;pun pe stiva base pointer-ul vechi
     mov ebp, esp           ;mut in ebp valoarea lui esp 

     cmp DWORD[ebp+8],0     ;compar valoara de la adresa ebp+8 care reprezinta pointerul de root pus pe stiva la apelarea functiei cu 0
     jne parcurgere         ;daca nu sunt egali sar la parcurgerea arborelui 
     jmp iesire             ;daca nu sar la iesirea din parcurgere 
     
parcurgere:
    mov eax,[ebp+8]         ;mut in eax valoarea de la ebp+8 care prezinta o adresa a nodului grafului 
    mov eax,[eax]           ;accesez valoarea din nodul grafului 
    
    call atoi               ;apelez atoi pentru valoarea din eax
 
    mov [vector +4*ecx], ebx    ;introduc in vector valoarea returnata de atoi in ebx
    inc ecx                     ;incrementez contorul vectorului
  
        
    mov eax,[ebp+8]             ;salvez in eax valoarea de la ebp+8    
    mov eax,[eax+4]             ;salvez in eax adresa fiului stang al nodului facand dereferentiere de eax+4 
    push eax                    ;pun pe stiva adesa din edx 
    call parcurgere_preordine   ;apelez recursiv functia de parcurgere     
    
    mov eax,[ebp+8]             ;salvez in eax valoarea de la ebp+8
    mov eax,[eax+8]             ;salvez in eax adresa fiului drept al nodului facand dereferentiere de eax+4
    push eax                    ;pun pe stiva adesa din edx
    call parcurgere_preordine   ;apelez recursiv functia de parcurgere
    
iesire:                                                     
    leave                       ;iesirea din functie 
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
    xor ecx,ecx                                   ;setez ecx sa fie 0 pentru introducerea in vector                                          
    call parcurgere_preordine                     ;apelez funtia de parcurgere in preordine a arborelui   
    
    dec ecx                                       ;decrementez ecx deoarece la final in functia de parcurgere_preordine se mai incrementeaza o data   
                                                  ;inainte sa iasa 
   
calcul_expresie:

    ;parcurg vectorul invers si daca valoarea este egala cu un numar dau push pe stiva 
    ;daca este egal cu un simbol din multimea {+,-,*,/} atunci sar la labe-ul corespunzator pentru fiecare operatie
    ;si dau pop la ultimele doua numere adaugate punand pe stiva rezultatul 
    
    cmp DWORD[vector + 4*ECX], '+'                  ;compar daca elementul din vector este '+' daca sunt egale sar la labe-ul corespunzator
    je plus                 
    
    cmp DWORD[vector + 4*ECX], '-'                  ;compar daca elementul din vector este '-' daca sunt egale sar la labe-ul corespunzator
    je minus
     
    cmp DWORD[vector + 4*ECX], '/'                  ;compar daca elementul din vector este '/' daca sunt egale sar la labe-ul corespunzator
    je impartire
    
    cmp DWORD[vector + 4*ECX], '*'                  ;compar daca elementul din vector este '*' daca sunt egale sar la labe-ul corespunzator
    je inmultire
    
    push DWORD[vector + 4*ECX]                      ;pun numerele pe stiva 
    jmp dec_ecx                                     ;sar si decrementez ecx 


plus:                       ;scot doua elemente din stiva si fac adunarea punand rezultatul inapoi pe stiva 
     pop eax
     pop ebx
     add eax,ebx
     push eax
     jmp dec_ecx
     
minus:                      ;scot doua elemente din stiva si fac scaderea punand rezultatul inapoi pe stiva
     pop eax
     pop ebx
     sub eax,ebx
     push eax
     jmp dec_ecx     

inmultire:                  ;scot doua elemente din stiva si fac inmultirea punand rezultatul inapoi pe stiva
     pop eax
     pop ebx
     imul ebx               ;folosesc imul ca sa ia si numerele cu semn 
     push eax
     jmp dec_ecx
     
impartire:                  ;scot doua elemente din stiva si fac impartirea punand rezultatul inapoi pe stiva
     xor edx,edx            ;xorez edx ca sa nu am surprize la impartire
     pop eax
     pop ebx
     cmp eax,0              ;daca numarul este negativ sare ,initializez edx cu 0xffffffff si se intoarce 
     jl negative1
negative2:  
     idiv ebx               ;folosesc idiv ca sa ia si numerele cu semn 
     push eax
     jmp dec_ecx
     
     
negative1:  
     mov edx,0xffffffff     ;setez edx cu 0xffffffff daca eax are un nr negativ 
     jmp negative2 
     
dec_ecx:                     ;decrementez ecx si compar daca am terminat vectorul            
      dec ecx
      cmp ecx , -1
      jne calcul_expresie


     xor eax,eax              ;xorez eax             
     pop eax                  ;scot din stiva elementul din stiva in eax
     PRINT_DEC 4,eax          ;printez eax 
    ; NU MODIFICATI
    ; Se elibereaza memoria alocata pentru arbore
    push dword [root]
    
    call freeAST
     
    
    xor eax, eax
    leave
    ret
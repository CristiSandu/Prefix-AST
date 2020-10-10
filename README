Tema 1 - Prefix AST - IOCLA

    Programul creeaza un arbore in care pune o expresie in forma poloneza prefixate si 
calculeaza rezultatul expresiei utilizand : o parcurgere in preordine a arborelui 
utilizand o functie recursiva , o functie atoi care transforma caracterele in numere si
un vector alaturi de stiva.

Implementare

    La implementare parcurg recursiv arborele apeland functia atoi care imi transforma in
numar valorile din arbore ,acolo unde este cazul punand intr-un vector valorile.
La terminarea parcurgeri arborelui, parcurg vectorul invers si daca valoarea este egala
cu un numar dau push pe stiva ,iar daca este egal cu un simbol din multimea {+,-,*,/} 
atunci sar la labe-ul corespunzator pentru fiecare operatie si dau pop la ultimele doua
numere adaugate punand pe stiva rezultatul operatiei dintre cele doua .
La finalul fiecarei operatii sar la un label unde decrementez ecx-ul si verific daca am
terminat vectorul.
In plus la operatia de impartire am verificat daca eax este negtiv sau pozitiv astfel 
in cazul in care este negativ setez edx-ul cu 0xffffffff ,iar in cazul in care este 
pozitiv setez prin xor-are edx la valoarea 0.
La final printez ultimul element ramas in stiva care reprezinta rezultatul final al 
operatiei.

La functia atoi am tratat separat numerele negative setand registrul edi cu 1 daca primul 
element este '-' si urmatorul este diferit de '\0' negand numarul inainte de iesirea din 
functie.


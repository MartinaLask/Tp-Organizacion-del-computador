section .rodata
; Tabla BASE64 (A-Z, a-z, 0-9, +, /)
base64_table: 
    db "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

section .text
global base64_encode

; void base64_encode(const unsigned char* input, unsigned int len, char* output)
; rdi = input, rsi = len, rdx = output
base64_encode:
    push r12
    push r13
    push r14
    mov r12, rdi        ; r12 = puntero a entrada
    mov r13, rsi        ; r13 = longitud de entrada
    mov r14, rdx        ; r14 = puntero a salida

    ; Calcular grupos completos de 3 bytes
    mov rcx, r13
    shr rcx, 2          ; rcx = r13 / 4? ¡Error! Debe ser /3.
    ; Corregimos:
    mov rax, r13
    xor rdx, rdx
    mov rcx, 3
    div rcx             ; rax = grupos completos, rdx = resto
    mov rcx, rax        ; rcx = contador de grupos

    lea r11, [rel base64_table]  ; r11 = dirección de la tabla

.encode_loop:
    test rcx, rcx
    jz .handle_remaining

    ; Cargar 3 bytes: [A B C]
    movzx eax, byte [r12]
    shl eax, 16
    movzx ebx, byte [r12+1]
    shl ebx, 8
    or eax, ebx
    movzx ebx, byte [r12+2]
    or eax, ebx         ; eax = 0x00AABBCC

    ; Extraer 4 índices de 6 bits
    mov r8d, eax
    shr r8d, 18         ; Primeros 6 bits (índice 0)
    and r8d, 0x3F

    mov r9d, eax
    shr r9d, 12         ; Siguientes 6 bits (índice 1)
    and r9d, 0x3F

    mov r10d, eax
    shr r10d, 6         ; Siguientes 6 bits (índice 2)
    and r10d, 0x3F

    and eax, 0x3F       ; Últimos 6 bits (índice 3)

    ; Convertir índices a caracteres
    mov r8b, [r11 + r8]
    mov [r14], r8b
    mov r9b, [r11 + r9]
    mov [r14+1], r9b
    mov r10b, [r11 + r10]
    mov [r14+2], r10b
    mov al, [r11 + rax]
    mov [r14+3], al

    add r12, 3
    add r14, 4
    dec rcx
    jmp .encode_loop

.handle_remaining:
    ; Manejar bytes restantes (0, 1, o 2)
    test rdx, rdx
    jz .end
    cmp rdx, 2
    je .two_bytes
    ; else: 1 byte restante

.one_byte:
    ; Cargar 1 byte [A] -> [A 0x00 0x00]
    movzx eax, byte [r12]
    shl eax, 16

    mov r8d, eax
    shr r8d, 18
    and r8d, 0x3F
    mov r8b, [r11 + r8]
    mov [r14], r8b

    mov r9d, eax
    shr r9d, 12
    and r9d, 0x3F
    mov r9b, [r11 + r9]
    mov [r14+1], r9b

    ; Rellenar con '=='
    mov byte [r14+2], '='
    mov byte [r14+3], '='
    jmp .end

.two_bytes:
    ; Cargar 2 bytes [A B] -> [A B 0x00]
    movzx eax, byte [r12]
    shl eax, 16
    movzx ebx, byte [r12+1]
    shl ebx, 8
    or eax, ebx

    mov r8d, eax
    shr r8d, 18
    and r8d, 0x3F
    mov r8b, [r11 + r8]
    mov [r14], r8b

    mov r9d, eax
    shr r9d, 12
    and r9d, 0x3F
    mov r9b, [r11 + r9]
    mov [r14+1], r9b

    mov r10d, eax
    shr r10d, 6
    and r10d, 0x3F
    mov r10b, [r11 + r10]
    mov [r14+2], r10b

    ; Rellenar con '='
    mov byte [r14+3], '='

.end:
    pop r14
    pop r13
    pop r12
    ret
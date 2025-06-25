section .data
base64_table db "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

section .text
global base64_encode

;_______________________________MACROS________________________________________
%macro PUT_CHAR 2
    mov ebx, r12d
    shr ebx, %1
    and ebx, 0x3F
    mov al, [r15 + rbx]    ; Usar registro r15 para tabla
    mov [r9 + %2], al
%endmacro

%macro CLEANUP 0
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret
%endmacro

;____________________FUNCION PRINCIPAL_________________________
base64_encode:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push r14
    push r15

    ; Cargar tabla en registro permanente
    lea r15, [rel base64_table]
    
    ; Verificar entrada vacía
    test rsi, rsi
    jz .fin
    
    ; Configurar punteros y contadores
    mov r8, rdi         ; input
    mov rcx, rsi        ; input_len (64 bits)
    mov r9, rdx         ; output
    xor r10, r10        ; offset (64 bits)

.loop:
    mov rax, rcx
    sub rax, r10
    cmp rax, 3
    jge .convertir_3
    cmp rax, 2
    je .convertir_2
    cmp rax, 1
    je .convertir_1
    jmp .fin

.convertir_3:
    ; Cargar 3 bytes usando acceso de 32 bits
    mov eax, [r8 + r10]     ; Carga 4 bytes (usamos 3)
    bswap eax               ; Corrección endianness
    shr eax, 8              ; Eliminar byte extra
    mov r12d, eax

    ; Codificar a Base64
    PUT_CHAR 18, 0
    PUT_CHAR 12, 1
    PUT_CHAR 6,  2
    PUT_CHAR 0,  3

    add r10, 3
    add r9, 4
    jmp .loop

.convertir_2:
    ; Cargar 2 bytes
    movzx eax, word [r8 + r10]
    xchg al, ah             ; Corrección endianness
    shl eax, 8              ; Alinear correctamente
    mov r12d, eax

    PUT_CHAR 18, 0
    PUT_CHAR 12, 1
    PUT_CHAR 6,  2
    mov byte [r9 + 3], '='  ; Padding

    add r10, 2
    add r9, 4
    jmp .loop

.convertir_1:
    ; Cargar 1 byte
    movzx eax, byte [r8 + r10]
    shl eax, 16             ; Alinear correctamente
    mov r12d, eax

    PUT_CHAR 18, 0
    PUT_CHAR 12, 1
    mov byte [r9 + 2], '='
    mov byte [r9 + 3], '='

    add r10, 1
    add r9, 4
    jmp .loop

.fin:
    CLEANUP
section .note.GNU-stack
    dd 0
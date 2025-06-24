section .note.GNU-stack noalloc noexec nowrite progbits

section .data
base64_table db "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

section .text
global base64_encode

base64_encode:
    push r12
    push r13
    push r14
    push r15
    push rbx                  ; Preservar rbx 
    mov r12, rdi              ; input buffer
    mov r13, rsi              ; input length
    mov r14, rdx              ; output buffer
    mov r15, rdx              ; inicio de output

    ; Calcular grupos completos
    mov rax, r13
    xor rdx, rdx
    mov rcx, 3
    div rcx
    mov rcx, rax              ; contador de grupos

    lea r11, [rel base64_table]

    ; Procesar grupos completos
    test rcx, rcx
    jz .handle_rest
.process_group:
    ; Cargar 3 bytes 
    movzx eax, byte [r12]
    shl eax, 16
    movzx ebx, byte [r12+1]
    shl ebx, 8
    or eax, ebx
    movzx ebx, byte [r12+2]
    or eax, ebx

    ; Extraer índices
    mov r8, rax
    shr r8, 18
    and r8, 0x3F

    mov r9, rax
    shr r9, 12
    and r9, 0x3F

    mov r10, rax
    shr r10, 6
    and r10, 0x3F

    and rax, 0x3F

    ; Mapear a caracteres
    mov al, [r11 + rax]
    mov r10b, [r11 + r10]
    mov r9b, [r11 + r9]
    mov r8b, [r11 + r8]

    ; Almacenar
    mov [r14], r8b
    mov [r14+1], r9b
    mov [r14+2], r10b
    mov [r14+3], al

    add r12, 3
    add r14, 4
    loop .process_group

.handle_rest:
    cmp rdx, 0
    je .done
    cmp rdx, 2
    je .two_bytes

    ; Caso 1 byte 
.one_byte:
    movzx eax, byte [r12]     ; Cargar solo el byte válido
    shl eax, 16               ; [byte1, 0x00, 0x00]

    ; Extraer solo 2 índices válidos
    mov r8, rax
    shr r8, 18
    and r8, 0x3F

    mov r9, rax
    shr r9, 12
    and r9, 0x3F

    ; Mapear
    mov r8b, [r11 + r8]
    mov r9b, [r11 + r9]

    mov [r14], r8b
    mov [r14+1], r9b
    mov byte [r14+2], '='     ; Relleno directo 
    mov byte [r14+3], '='     ; Relleno directo 
    add r14, 4
    jmp .done

.two_bytes:
    ; Cargar 2 bytes 
    movzx eax, word [r12]     ; Carga little-endian: [byte1, byte2]
    shl eax, 8                ; [byte1, byte2, 0x00]

    mov r8, rax
    shr r8, 18
    and r8, 0x3F

    mov r9, rax
    shr r9, 12
    and r9, 0x3F

    mov r10, rax
    shr r10, 6
    and r10, 0x3F

    ; Mapear
    mov r8b, [r11 + r8]
    mov r9b, [r11 + r9]
    mov r10b, [r11 + r10]

    mov [r14], r8b
    mov [r14+1], r9b
    mov [r14+2], r10b
    mov byte [r14+3], '='     ; Relleno
    add r14, 4

.done:
    mov rax, r14
    sub rax, r15
    pop rbx                   ; Restaurar rbx 
    pop r15
    pop r14
    pop r13
    pop r12
    ret
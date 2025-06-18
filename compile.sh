#!/bin/bash

# Compilar código assembler
nasm -f elf64 base_encode.asm -o base64_encode.o

# Compilar código C y enlazar
gcc main.c base64_encode.o -o base64_encoder -Wall -Wextra

echo "Compilación exitosa. Ejecutar con: ./base64_encoder"
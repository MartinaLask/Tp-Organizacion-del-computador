#!/bin/bash

# Compilar código assembler
nasm -f elf64 base64_encode.asm -o base64_encode.o

# Compilar código C y enlazar
gcc -no-pie -z main.c base64_encode.o -o base64_encode -Wall -Wextra

echo "Compilación exitosa. Ejecutar con: ./base64_encode"
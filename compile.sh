#!/bin/bash

# Compilar código assembler
nasm -f elf64 base64_encoder.asm -o base64_encoder.o

# Compilar código C y enlazar
gcc -no-pie main.c base64_encoder.o -o base64_encoder

echo "Compilación exitosa. Ejecutar con: ./base64_encoder"
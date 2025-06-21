# Trabajo Práctico Integrador - Codificación BASE64

## Integrantes
- Martina Laskowski
- Agustin Cordoba Barrenechea

## Descripción
Programa en C y assembler x86_64 que codifica archivos binarios a BASE64.  
Implementación para grupos de 2 alumnos según especificaciones del TP.

## Estructura de Archivos
Tp-Organizacion-del-computador/
├── main.c # Programa principal (manejo de archivos)
├── base64_encode.asm # Algoritmo de codificación en assembler
├── compile.sh #Script de compilacion
└── README.md

## Instrucciones de Compilación
1. Dar permisos de ejecución al script:
```bash
chmod +x compile.sh
```
2. Compilar Proyecto
```bash
./compile.sh
```
Salida esperada:
Compilación exitosa. Ejecutar con: ./base64_encoder

## Instrucciones de Uso
1. Colocar archivo binario de entrada en el directorio con nombre:
inputBinario.bin

2. Ejecutar el programa:
```bash
./base64_encode
```
3. El resultado se guardara en outputTexto.txt

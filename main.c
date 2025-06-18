#include <stdio.h>
#include <stdlib.h>

// Declaración de la función en assembler
extern void base64_encode(const unsigned char* input, unsigned int len, char* output);

int main() {
    FILE* input_file = fopen("inputBinario.bin", "rb");
    if (!input_file) {
        perror("Error al abrir inputBinario.bin");
        return 1;
    }

    // Obtener tamaño del archivo
    fseek(input_file, 0, SEEK_END);
    long file_size = ftell(input_file);
    fseek(input_file, 0, SEEK_SET);

    // Leer datos binarios
    unsigned char* input_data = malloc(file_size);
    fread(input_data, 1, file_size, input_file);
    fclose(input_file);

    // Calcular tamaño de salida (4*(n/3) + padding)
    long output_size = 4 * ((file_size + 2) / 3);
    char* output_data = malloc(output_size + 1); // +1 para NULL

    // Llamar a la función assembler
    base64_encode(input_data, file_size, output_data);

    // Escribir resultado
    FILE* output_file = fopen("outputTexto.txt", "w");
    fwrite(output_data, 1, output_size, output_file);
    fclose(output_file);

    // Liberar recursos
    free(input_data);
    free(output_data);
    return 0;
}
#include <stdio.h>
#include <stdlib.h>

extern void base64_encode(const unsigned char *input, size_t input_len, char *output);

int main() {
    const char* input_file = "inputBinario.bin";
    const char* output_file = "outputTexto.txt";

    // Abrir archivo binario
    FILE* in_file = fopen(input_file, "rb");
    if (!in_file) {
        perror("Error al abrir archivo de entrada");
        return 1;
    }

    // Obtener tamaño del archivo
    fseek(in_file, 0, SEEK_END);
    size_t file_size = ftell(in_file);
    rewind(in_file);

    // Leer datos binarios
    unsigned char* input_data = malloc(file_size);
    if (!input_data) {
        perror("Error de asignación de memoria");
        fclose(in_file);
        return 1;
    }
    
    size_t bytes_read = fread(input_data, 1, file_size, in_file);
    fclose(in_file);
    
    if (bytes_read != file_size) {
        perror("Error de lectura de archivo");
        free(input_data);
        return 1;
    }

    // Calcular tamaño de salida (fórmula Base64)
    size_t output_size = 4 * ((file_size + 2) / 3);
    char* output_data = malloc(output_size + 1); // +1 para terminador nulo
    if (!output_data) {
        perror("Error de asignación de memoria");
        free(input_data);
        return 1;
    }

    // Llamar a función de ensamblador
    base64_encode(input_data, file_size, output_data);
    output_data[output_size] = '\0'; // Añadir terminador nulo

    // Escribir resultado
    FILE* out_file = fopen(output_file, "w");
    if (!out_file) {
        perror("Error al abrir archivo de salida");
        free(input_data);
        free(output_data);
        return 1;
    }
    
    fwrite(output_data, 1, output_size, out_file);
    fclose(out_file);

    // Limpiar memoria
    free(input_data);
    free(output_data);
    
    printf("Codificación completada. Tamaño de entrada: %zu bytes, salida: %zu caracteres\n", 
           file_size, output_size);
    return 0;
}
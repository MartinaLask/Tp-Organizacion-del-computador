#include <stdio.h>
#include <stdlib.h>

// Declaración de la función en assembler
extern int base64_encode(const unsigned char *input, unsigned int input_len, char *output);

int main() {
    const char *input_file = "inputBinario.bin";
    const char *output_file = "outputTexto.txt";
    FILE *in, *out;
    unsigned char *input_data = NULL;
    char *output_data = NULL;
    long file_size;
    int out_len;

    // Abrir archivo binario
    in = fopen(input_file, "rb");
    if (!in) {
        perror("Error al abrir inputBinario.bin");
        return 1;
    }

    // Obtener tamaño del archivo
    fseek(in, 0, SEEK_END);
    file_size = ftell(in);
    fseek(in, 0, SEEK_SET);

    // Leer datos binarios
    input_data = (unsigned char *)malloc(file_size);
    if (!input_data) {
        perror("Error de memoria");
        fclose(in);
        return 1;
    }
    fread(input_data, 1, file_size, in);
    fclose(in);

    // Calcular tamaño de salida: ((n + 2) / 3) * 4
    unsigned int output_size = ((file_size + 2) / 3) * 4;
    output_data = (char *)malloc(output_size + 1); // +1 para terminador nulo (opcional)

    // Llamar a función assembler
    out_len = base64_encode(input_data, (unsigned int)file_size, output_data);

    // Escribir resultado
    out = fopen(output_file, "w");
    if (!out) {
        perror("Error al crear outputTexto.txt");
        free(input_data);
        free(output_data);
        return 1;
    }
    fwrite(output_data, 1, out_len, out);
    fclose(out);

    // Liberar memoria
    free(input_data);
    free(output_data);
    return 0;
}
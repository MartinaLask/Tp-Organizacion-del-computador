#include <stdio.h>

int main() {
    FILE *inputBinario;
    FILE *outputTexto;  
    char buffer[189];
    char output[252];
    size_t cantidadLeida;

    char nombreArchivoEntrada[] = "inputBinario.bin";
    char nombreArchivoSalida[] = "outputTexto.txt";


    inputBinario = fopen(nombreArchivoEntrada, "rb");  
    if (inputBinario == NULL) {
        printf("No se pudo abrir el archivo.\n");
        return 1;
    }

    cantidadLeida = fread(buffer, 1, 189, inputBinario);  
    printf("Se leyeron %zu bytes.\n", cantidadLeida);

    fclose(inputBinario);

    //void base64_encode(const unsigned char* input, unsigned int len, char* output);
    base64_encode((unsigned char*)buffer, (unsigned int)cantidadLeida, output);


    outputTexto = fopen(nombreArchivoSalida, "w");
    if (outputTexto == NULL) {
      printf("No se pudo abrir el archivo.\n");
      return 1; 
    }
  
    fputs(output, outputTexto);//eof o fwrite
    fclose(outputTexto);
  
  
    return 0; 
  }
 

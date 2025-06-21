#include <stdio.h>

int main() {
    FILE *inputBinario;
    FILE *outputTexto;  
    char buffer[189];    
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

    outputTexto = fopen(nombreArchivoSalida, "w");
    if (outputTexto == NULL) {
      printf("No se pudo abrir el archivo.\n");
      return 1; 
    }
  
    fputs(cadena, outputTexto);//eof
    fclose(outputTexto);
  
  
    return 0; 
  }
  """
  inputBinario.bin 
apertura
lectura


outputTexto.txt
escritura 
cierre
"""

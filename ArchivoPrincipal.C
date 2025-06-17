#include <stdio.h>

int main() {
  FILE * outputTexto, inputBinario; 
  void * p;

  char nombreArchivoEntrada[] = "inputBinario.bin";

  inputBinario = fopen( nombreArchivoEntrada[], "rb");

if (inputBinario == NULL) {
    printf("No se pudo abrir el archivo.\n");
    return 1; 
  }
int fread ( p, int 1, int 198, inputBinario);
//close 

  char nombreArchivoSalida[] = "outputTexto.txt";

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

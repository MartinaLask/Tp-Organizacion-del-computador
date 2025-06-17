#include <stdio.h>

int main() {
  FILE *archivo;
  char nombreArchivo[] = "outputTexto.txt";

  archivo = fopen(nombreArchivo, "w");

  if (archivo == NULL) {
    printf("No se pudo abrir el archivo.\n");
    return 1; 
  }

  fputs(cadena, archivo);//eof

  fclose(archivo);


  return 0; 
}

inputBinario.bin 
apertura
lectura


outputTexto.txt
escritura 
cierre

#include <stdio.h>

void bubbleSort(int array[], int tamanho) {
    for (int i = 0; i < tamanho - 1; i++) {
        for (int j = 0; j < tamanho - i - 1; j++) {
            if (array[j] > array[j + 1]) {
                int temp = array[j];
                array[j] = array[j + 1];
                array[j + 1] = temp;
            }
        }
    }
}

void imprimeArray(int array[], int tamanho) {
    for (int i = 0; i < tamanho; i++) {
        printf("%d ", array[i]);
    }
    printf("\n");
}

int main() {
    int numeros[] = {5, 3, 8, 4, 2};
    int tamanho = sizeof(numeros) / sizeof(numeros[0]);

    printf("Antes da ordenação:\n");
    imprimeArray(numeros, tamanho);

    bubbleSort(numeros, tamanho);

    printf("Depois da ordenação:\n");
    imprimeArray(numeros, tamanho);

    return 0;
}
#define _POSIX_C_SOURCE 200809L
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static char **linhasLidas = NULL;

static inline void swap(float *vetorFloat, char **vetorString, int a, int b) {
    float posicaoDoFloatTemporario = vetorFloat[a]; 
    vetorFloat[a] = vetorFloat[b]; 
    vetorFloat[b] = posicaoDoFloatTemporario;

    char *posicaoDaStringTemporaria = vetorString[a];
    vetorString[a] = vetorString[b];
    vetorString[b] = posicaoDaStringTemporaria;
}

static void bubblesort(float *vetorFloat, char **vetorString, int n) {
    for (int i = 0; i < n - 1; ++i) {
        for (int j = 0; j < n - i - 1; ++j) {
            if (vetorFloat[j] > vetorFloat[j + 1]) {
                swap(vetorFloat, vetorString, j, j + 1);
            }
        }
    }
}

static int particiona(float *vetorFloat, char **vetorString, int inicio, int fim) {
    float pivo = vetorFloat[fim];
    int i = inicio - 1;

    for (int j = inicio; j < fim; ++j) {
        if (vetorFloat[j] <= pivo) {
            swap(vetorFloat, vetorString, ++i, j);
        }
    }

    swap(vetorFloat, vetorString, i + 1, fim);
    return i + 1;
}

static void quicksort(float *vetorFloat, char **vetorString, int inicio, int fim) {
    if (inicio >= fim) {
        return;
    }

    int p = particiona(vetorFloat, vetorString, inicio, fim);

    quicksort(vetorFloat, vetorString, inicio, p - 1);
    quicksort(vetorFloat, vetorString, p + 1, fim);
}

static float *ordena(int tamanhoDoVetor, int algoritmoSelecionado, float *v) {
    if (algoritmoSelecionado == 0) {
        bubblesort(v, linhasLidas, tamanhoDoVetor);
    } else if (algoritmoSelecionado == 1) {
        quicksort(v, linhasLidas, 0, tamanhoDoVetor - 1);
    } else {
        fprintf(stderr, "Algoritmo desconhecido");
        return NULL;
    }

    return v;
}

static void corta_newline(char *s) {
    size_t n = strlen(s);
    if (n && s[n - 1] == '\n') s[n - 1] = '\0';
}

int main(int argc, char **argv) {
    const char *caminho = argv[1];
    int alg = atoi(argv[2]);

    FILE *fp = fopen(caminho, "r");

    size_t tamanhoDoVetor = 0; 
    char *linha = NULL; 
    size_t len = 0;

    while (getline(&linha, &len, fp) != -1) {
        ++tamanhoDoVetor;
    }

    rewind(fp);

    float *numeros = malloc(tamanhoDoVetor * sizeof *numeros);
    char **linhas  = malloc(tamanhoDoVetor * sizeof *linhas);

    for (size_t i = 0; i < tamanhoDoVetor; ++i) {
        if (getline(&linha, &len, fp) == -1) {
            break;
        }
        
        corta_newline(linha);
        linhas[i]  = strdup(linha);
        numeros[i] = strtof(linha, NULL);
    }

    free(linha);
    fclose(fp);

    int tamanhoDoVetorInteiro = (int) tamanhoDoVetor;

    linhasLidas = linhas;

    float *numerosOrdenados = ordena(tamanhoDoVetorInteiro, alg, numeros);

    if (!numerosOrdenados) {
        return 1;
    }

    fp = fopen(caminho, "a");

    fprintf(fp, "\n\n");
    for (size_t i = 0; i < tamanhoDoVetor; ++i) {
        fprintf(fp, "%s\n", linhas[i]); // escreve no arquivo, depois de uma quebra de linha para separação
    }
    fclose(fp);

    for (size_t i = 0; i < tamanhoDoVetor; ++i) {
        free(linhas[i]);
    }

    free(linhas);
    free(numeros);
    
    return 0;
}

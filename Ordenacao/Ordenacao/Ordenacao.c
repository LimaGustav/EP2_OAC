// Ordenacao.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <stdlib.h>

const char* caminhoArquivo = "C:\\Users\\OLIMPIADA2024\\Desktop\\OAC\\EP2\\dados.txt";

int particao(float* numeros, int inicio, int fim) {
	float pivo = numeros[fim];
	int i = inicio-1;
	int j = inicio;
	for (j = inicio; j < fim; j++)
	{
		if (numeros[j] <= pivo) {
			i = i+1;
			//printf("I = %i\n", i);
			float k = numeros[j];
			numeros[j] = numeros[i];
			numeros[i] = k;
			
		}
	}
	float q = numeros[i + 1];
	numeros[i + 1] = numeros[fim];
	numeros[fim] = q;
	return i + 1;
}

//                
void quickSort(float* numeros,int inicio, int fim) {
	if (inicio >= fim) return;
	int q = particao(numeros, inicio, fim);
	quickSort(numeros, inicio, q - 1);
	quickSort(numeros, q + 1, fim);
}

int main() 
{
	

	FILE* arquivo;
	arquivo = fopen(caminhoArquivo, "r");

	float numero;
	int n = 0;
	while (fscanf(arquivo, "%f", &numero) != EOF) {
		n++;
	}
	fclose(arquivo);


	float* numeros = (float*)malloc(sizeof(float) * n);
	arquivo = fopen(caminhoArquivo, "r");
	int i = 0;
	while (fscanf(arquivo, "%f", &numero) != EOF) {
		numeros[i] = numero;
		i++;
	}

	quickSort(numeros, 0,n-1);
	for (i = 0; i < n; i++)
	{
		printf("\n%f", numeros[i]);
	}
	return 0;
}



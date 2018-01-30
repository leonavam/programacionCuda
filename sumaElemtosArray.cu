#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <cuda_runtime.h>

#define TAM_V 1024
#define N_ThRead 128

__global__ void reduceVector(float *v1, float *v2, float *res){


    int index = blockIdx.x * blockDim.x + threadIdx.x;
    int index2;

    for (int i = blockDim.x/2; i>=1; i=i/2){

        if(threadIdx.x < i){
            index2 = index + i;
            v1[index] += v1[index2];
        }
        __syncthreads();

    }
    if(threadIdx.x==0)
        res[blockIdx.x] = v1[index];

}

int main(){

    float *h_v1, *h_v2, *h_res;
    float *d_v1, *d_v2, *d_res;

    int memSize = TAM_V* sizeof(float);
//reserva en Host
    h_v1 = (float *) malloc (memSize);
    h_v2 = (float *) malloc (memSize);
    h_res = (float *) malloc (memSize);
//reserva en GPU
    cudaMalloc(&d_v1, memSize);
    cudaMalloc(&d_v2, memSize);
    cudaMalloc(&d_res, memSize);

//inicializa vectores
    for (int i=0; i<TAM_V; i++){
        //h_v1[i] = h_v2[i] = (float) (rand()%2);
        h_v1[i] = h_v2[i] = 1.0f;
        h_res[i] = 0.0f;
    }

//copiar datos hacia GPU (device)
    cudaMemcpy(d_v1, h_v1, memSize, cudaMemcpyHostToDevice);
    cudaMemcpy(d_v2, h_v2, memSize, cudaMemcpyHostToDevice);
    cudaMemcpy(d_res, h_res, memSize, cudaMemcpyHostToDevice);

//Lanzar kernel
    int numBlocks = ceil(TAM_V/N_ThRead);
    int numThreads = N_ThRead;
    dim3 block (numBlocks);
    dim3 thread (numThreads);

    printf("Vector de %d elementos \nNumero de bloques = %d\nHilos por bloque = %d\n", TAM_V,numBlocks,numThreads);

//Calcula el tiempo de ejecucion
    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    cudaEventRecord(start);

        reduceVector <<<block,thread>>>(d_v1,d_v2,d_res);

    cudaEventRecord(stop);
    cudaEventSynchronize(stop);

    float milliseconds = 0;
    cudaEventElapsedTime(&milliseconds, start, stop);
    printf ("El tiempo de ejecucion es %f msec\n", milliseconds);
    

    cudaMemcpy(h_res, d_res, memSize, cudaMemcpyDeviceToHost);

    float total =0.0f;
    for(int i=0; i<numBlocks; i++){
       total += h_res[i];
       printf("(%i)%.2f ",i,h_res[i]);
    }

    printf("\n-----%f\n",total);

    cudaFree(d_v1);
    cudaFree(d_v2);
    cudaFree(d_res);
    free(h_v1);
    free(h_v2);
    free(h_res);


    return 0;
}
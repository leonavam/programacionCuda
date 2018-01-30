#include <stdio.h>
#include <cuda_runtime.h>

#define N 24

__global__ void muestraIndice(float *a, float *b, float *c){

    int global = blockIdx.x * blockDim.x + threadIdx.x;

    if(global < N){
        a[global] = threadIdx.x;
        b[global] = blockIdx.x;
        c[global] = global;
    }

}

int main(){

    float *h_hilo, *h_bloque, *h_global;
    float *d_hilo, *d_bloque, *d_global;

    int memSize = N * sizeof(float);

    h_hilo = (float*) malloc (memSize);
    h_bloque = (float*) malloc (memSize);
    h_global = (float*) malloc (memSize);
    cudaMalloc(&d_bloque, memSize);
    cudaMalloc(&d_hilo, memSize);
    cudaMalloc(&d_global, memSize);

    int numBlock = 4;
    int numThread = 6;
    dim3 block(numBlock);
    dim3 thread(numThread);

    muestraIndice<<<block,thread>>>(d_hilo, d_bloque, d_global);

    cudaMemcpy(h_hilo, d_hilo, memSize, cudaMemcpyDeviceToHost);
    cudaMemcpy(h_bloque, d_bloque, memSize, cudaMemcpyDeviceToHost);
    cudaMemcpy(h_global, d_global, memSize, cudaMemcpyDeviceToHost);

    printf("Hilo\n");
    for(int i=0; i<N;i++){
        printf("%.2f ", h_hilo[i]);
    }
    printf("\nBloque\n");
    for(int i=0; i<N;i++){
        printf("%.2f ", h_bloque[i]);
    }
    printf("\nGlobal\n");
    for(int i=0; i<N;i++){
        printf("%.2f ", h_global[i]);
    }




    return 0;
}
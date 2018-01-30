#include <stdio.h>
#include <cuda_runtime.h>
#include <math.h>
#include <time.h>

#define N 9

int main(){

    float *h_a, *h_b;
    float *d_a, *d_b;

    int memSize = N*sizeof(float);

    h_a = (float *) malloc (memSize);
    h_b = (float *) malloc (memSize);
    cudaMalloc (&d_a, memSize);
    cudaMalloc (&d_b, memSize);

    srand(time(NULL));
    for(int i=0; i<N; i++){
        h_a[i] = (float) (rand()%2);
    }

    cudaMemcpy(d_a, h_a, memSize, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, d_a, memSize, cudaMemcpyDeviceToDevice);
    cudaMemcpy(h_b, d_b, memSize, cudaMemcpyDeviceToHost);


    for(int i=0; i<N; i++){
        printf("%.2f - ",h_a[i]);
    }
    printf("\nEmpieza h_b\n");
    for(int i=0; i<N; i++){
        printf("%.2f - ",h_b[i]);
    }

    return 0;
}
#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>
#include <time.h>

#define N 10

__global__ void numMayor(float *d_v, float *d_pos){


    float temp = 0,pos=0;
    for(int i=threadIdx.x; i<blockDim.x;i++){
        if(d_v[i] > temp){
            temp = d_v[i];
            pos = i;
        }
        
    }
    __syncthreads();
    if(pos>d_pos[threadIdx.x])
        d_pos[threadIdx.x] = pos;
    d_v[threadIdx.x] = temp;

}


int main(){

    float *h_pos, *h_v;
    float *d_pos, *d_v;

    int memSize = N*sizeof(float);
    srand(time(NULL));
    h_pos = (float*) malloc (memSize);
    h_v = (float*) malloc (memSize);
    cudaMalloc((void**)&d_v, memSize);
    cudaMalloc((void**)&d_pos, memSize);

    for(int i=0; i<N; i++)
        h_v[i] = (float) (rand()%11);
    
        
    for(int i=0; i<N;i++){
        printf("(%i)%.2f ",i, h_v[i]);
    }

    cudaMemcpy(d_v, h_v, memSize, cudaMemcpyHostToDevice);
    cudaMemcpy(d_pos, h_pos, memSize, cudaMemcpyHostToDevice);

    int block = 1;
    int thread = 10;
    numMayor<<<block,thread>>>(d_v,d_pos);
    
   
    cudaMemcpy(h_pos,d_pos, memSize, cudaMemcpyDeviceToHost);
    printf("\nPosicion %.2f -------\n", *h_pos);
    cudaMemcpy(h_v,d_v, memSize, cudaMemcpyDeviceToHost);
    printf(" Valor %.2f -------\n", *h_v);
    printf("---\n");
    for(int i=0; i<N;i++){
        printf("%.2f ", h_v[i]);
    }
    printf("\n---\n");
    for(int i=0; i<N;i++){
        printf("%.2f ", h_pos[i]);
    }
    return 0;
}
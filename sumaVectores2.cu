#include <stdio.h>
#include <cuda_runtime.h>
#include <math.h>
#define N 9

__global__ void sumaVectores (float * d_a, float *d_b, float * d_c) {

        int index = blockIdx.x*blockDim.x+threadIdx.x;
        if (index < N )
                d_c[index] = d_a[index] +d_b[index];
}

int main () {

        float * h_a, *h_b, *h_c;
        float * d_a, *d_b, *d_c;

        int memsize = N*sizeof(float);

        h_a = (float *) malloc (memsize);
        h_b = (float *) malloc (memsize);
        h_c = (float *) malloc (memsize);
        cudaMalloc (&d_a, memsize);
        cudaMalloc (&d_b, memsize);
        cudaMalloc (&d_c, memsize);

        for (int i=0; i<N; ++i) {
                h_a[i]=h_b[i] = 1.0f;
                h_c[i]= 0.0f;
        }

        cudaMemcpy (d_a, h_a, memsize, cudaMemcpyHostToDevice);
        cudaMemcpy (d_b, h_b, memsize, cudaMemcpyHostToDevice);
        cudaMemcpy (d_c, h_c, memsize, cudaMemcpyHostToDevice);

        int numBlocks =(int) ceil(N/2);
        int numThreads = 2;
        dim3 block (numBlocks);
        dim3 thread (numThreads);

        printf("Vector de %d elementos \nNumero de bloques = %d\nHilos por bloque = %d\n", N,numBlocks,numThreads);

        sumaVectores <<<block,thread>>> (d_a,d_b,d_c);

        cudaMemcpy (h_c, d_c, memsize, cudaMemcpyDeviceToHost);
        for (int i=0; i<N; ++i) {
                printf ("%f, ", h_c[i]);
        }

        printf ("\n");
        free (h_a);
        free (h_b);
        free (h_c);
        cudaFree (d_a);
        cudaFree (d_b);
        cudaFree (d_c);

        return 0;



}

#include <stdio.h>
#include <cuda_runtime.h>

__global__ void sumaGPU(int a, int b, int *sol){

        *sol = a + b;
}

__host__ int sumaCPU(int a, int b){

    return (a+b);
}

int main(){

    int *h_sol;
    int *d_sol;
    int n1 = 3, n2 = 2, sol = 0;

    //Tamaño de reserva
    int memSize = (sizeof(int)); 

    //Reserva espacio en host
    h_sol = (int *) malloc (memSize);
    //Reserva espacio en GPU
    cudaMalloc(&d_sol, memSize);

    //Llama funcion sumaCPU
    sol = sumaCPU(n1,n2);
    printf("Resultado CPU: %2i\n", sol);


    int numBlocks = 1;
    int numThreads = 1;
    dim3 block (numBlocks);
    dim3 thread (numThreads);

    sumaGPU <<<block,thread>>>(n1,n2,d_sol);

    //Recoge de GPU
    cudaMemcpy(h_sol, d_sol, memSize, cudaMemcpyDeviceToHost);
    printf("Resultado GPU: %2d\n", *h_sol);

    cudaFree(d_sol);
    free(h_sol);

    //salida
    /*
    printf("Pulse INTRO para finalizar...");
    fflush(stdin);
    char key = getchar();*/
    return 0;
}
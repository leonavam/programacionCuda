#include <stdio.h>
#include <cuda_runtime.h>
#include <math.h>

__global__ void ecuaciones(int a, int b, int c, float *sol){

    int index = threadIdx.x; 
    float d = 0;
    float x=0, y=0;
    d = b*b-4*a*c;
    if (d > 0) {
        x = (-b+sqrt(d))/(2*a);
        y = (-b-sqrt(d))/(2*a);
        sol[index] = x;
        sol[index+1]=y;
    }
    else if (d == 0) {
        x = (-b)/(2*a);
        sol[index] = x;
    }
}


int main(){
    int a,b,c;
    float *h_x, *d_x;

    int memSize = 1*sizeof(float);
    h_x = (float *) malloc (memSize);
    cudaMalloc(&d_x,memSize);

    printf("Ingrese a: ");
    scanf("%i", &a);
    printf("Ingrese b: ");
    scanf("%i", &b);
    printf("Ingrese c: ");
    scanf("%i", &c);

    ecuaciones<<<1,1>>> (a,b,c,d_x);
    cudaMemcpy(h_x,d_x,sizeof(float),cudaMemcpyDeviceToHost);

    printf("Respuesta x1: %f\n", h_x[0]);
    printf("Respuesta x2: %f\n", h_x[1]);

    char key = getchar();
    return 0;
}
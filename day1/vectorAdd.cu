#include <iostream>
#include <cuda_runtime.h>

using namespace std;

__global__ void vectorAdd(int* dA, int* dB, int* dC, int size)
{
    int i = blockIdx.x*blockDim.x + threadIdx.x;

    if(i<size)
    {
        dC[i] = dA[i] + dB[i];
    }

}

void intializeHostArray(int* hA, int* hB, int size)
{
    for(int i=0; i<size; i++)
    {
        hA[i] = 0;
        hB[i] = i;
    }
}


int main(){

    int size = 1024;

    int* dA, *dB, *dC;
    int* hA, *hB, *hC;


    hA = (int*)malloc(sizeof(int)*size);
    hB = (int*)malloc(sizeof(int)*size);
    hC = (int*)malloc(sizeof(int)*size);

    intializeHostArray(hA, hB, size);

    cudaMalloc(&dA, size*sizeof(int));
    cudaMalloc(&dB, size*sizeof(int));
    cudaMalloc(&dC, size*sizeof(int));

    cudaMemcpy(dA, hA, sizeof(int)*size, cudaMemcpyHostToDevice);
    cudaMemcpy(dB, hB, sizeof(int)*size, cudaMemcpyHostToDevice);

    int threads = 256;
    int grid = (size + threads-1)/threads;

    vectorAdd<<<grid, threads>>>(dA, dB, dC, size);

    cudaMemcpy(hC, dC, sizeof(int)*size, cudaMemcpyDeviceToHost);

    for(int i=0; i<size; i++)
    {
        cout<<hC[i]<<endl;
    }

    cudaFree(dC);
    free(hC);


    return 0;
}

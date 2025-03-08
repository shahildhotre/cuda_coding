#include <iostream>
#include <cuda_runtime.h>

using namespace std;

__constant__ char d_message[40];

__global__ void msgRead(char* d_msg)
{
    int id = blockIdx.x*blockDim.x + threadIdx.x;

    d_msg[id] = d_message[id];
}



int main(){

    char* h_msg;
    char* d_msg;

    char h_message[] = "I am pro cuda developer";

    int length = strlen(h_message);

    h_msg = (char*)malloc(length*sizeof(char));
    cudaMalloc(&d_msg, length*sizeof(char));

    cudaMemcpyToSymbol(d_message, h_message, length*sizeof(char));
    cudaMemcpyToSymbol(d_message, h_message, length * sizeof(char));

    int thread_per_block = length;

    msgRead<<<1, thread_per_block>>>(d_msg);

    cudaMemcpy(h_msg, d_msg, length*sizeof(char), cudaMemcpyDeviceToHost);

    cout<<h_msg<<endl;

    cudaFree(d_msg);
    free(h_msg);



    return 0;
}


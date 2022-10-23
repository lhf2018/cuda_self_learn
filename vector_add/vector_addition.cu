#include <iostream>
#include <ctime>


#define  N 65535

__global__ void vector_add_gpu(int *a, int *b, int *c, int n){
    int tid = blockIdx.x * blockDim.x + threadIdx.x; // 获取线程索引
    const int t_n = gridDim.x * blockDim.x; // 跳步的步长，所有线程的数量

    while (tid < n)
    {
        c[tid] = a[tid] + b[tid];
        tid += t_n;
    }
}

int main() {
    clock_t start,end;//数据类型是clock_t，需要头文件#include<time.h>
    int a[N], b[N], c[N];
    int *dev_a, *dev_b, *dev_c;
    for (int i = 0; i < N; ++i) // 为数组a、b赋值
    {
        a[i] = i;
        b[i] = i * i;
    }
    start=clock();

    cudaMalloc(&dev_a, sizeof(int) * N);
    cudaMemcpy(dev_a, a, sizeof(int) * N, cudaMemcpyHostToDevice);

    cudaMalloc(&dev_b, sizeof(int) * N);
    cudaMemcpy(dev_b, b, sizeof(int) * N, cudaMemcpyHostToDevice);

    cudaMalloc(&dev_c, sizeof(int) * N);
    cudaMemcpy(dev_c, c, sizeof(int) * N, cudaMemcpyHostToDevice);

    vector_add_gpu<<<100, 200>>>(dev_a, dev_b, dev_c, N);
    cudaMemcpy(c, dev_c, sizeof(int) * N, cudaMemcpyDeviceToHost);

    end=clock();

    cudaFree(dev_a);
    cudaFree(dev_b);
    cudaFree(dev_c);


    for(int i=0; i<N; ++i)
    {
        printf("%d + %d = %d \n", a[i], b[i], c[i]);
    }

    std::cout<<"running time is: "<<(double)(end-start)/CLOCKS_PER_SEC<<std::endl;
    return 0;

}
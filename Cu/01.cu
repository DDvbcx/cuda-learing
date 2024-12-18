#include <iostream>

__global__ void kernel(void)  // 告诉编译器，函数在设备上运行
{

}

int main(void)
{
    kernel<<<1,1>>>();
    std::cout << "Hello, World!" << std::endl;
    return 0;
}

#include <stdio.h>

int main() {
    int val_1 = 10;
    int val_2 = 20;

    // const 修饰指针，指针指向可以改，指针值不可以改
    const int* ptr1 = &val_1;
    printf("The value of ptr1: %p\n", (void*)ptr1);
    printf("The value of ptr1 point: %d\n", *ptr1);
    
    ptr1 = &val_2; // 修改指针指向
    printf("The value of ptr1: %p\n", (void*)ptr1);
    printf("The value of ptr1 point: %d\n", *ptr1);
    
    // const 修饰的是常量，指针指向不可以改变，指针指向的值可以改
    int* const ptr2 = &val_1;
    printf("The value of ptr1: %p\n", (void*)ptr2);
    printf("The value of ptr1 point: %d\n", *ptr2);
    
    *ptr2 = val_2; // 修改指针指向的值
    printf("The value of ptr1: %p\n", (void*)ptr2);
    printf("The value of ptr1 point: %d\n", *ptr2);

    // const 既修饰指针，又修饰常量
    const int* const ptr3 = &val_1;
    printf("The value of ptr1: %p\n", (void*)ptr3);
    printf("The value of ptr1 point: %d\n", *ptr3);
    

    return 0;
}
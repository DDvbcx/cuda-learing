#include <stdio.h>

int main(int argc, char **argv) {
    int val = 2;
    printf("Welcome to a program with a bug!\n");
    scanf("%d", val);

    printf("You gave me: %d", val);
    return 0;
}
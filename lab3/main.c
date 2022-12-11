#include <stdio.h>
int main(){
    long long int  N = 2100000000;
    double pi = 0;
    double delta = 0;
    for (int i = 0; i < N; i++){
        delta = (double)4/(double)(2*i+1);
        if (i % 2 == 1)
            delta = -delta;
        pi += delta;
    }
    printf("%lf",pi);
    return 0;
}
#include <stdio.h>
#include <time.h> // for clock_gettime
int main(){
    struct timespec start, end;
    clock_gettime(CLOCK_MONOTONIC_RAW, &start);
    double pisum = 0;
    long long int N = 210000000;
    double pi = 0;
    double delta = 0;
    for (int i = 0; i < N; i++){
        delta = (double)4/(double)(2*i+1);
        if (i % 2 == 1)
            delta = -delta;
        pi += delta;
        pisum +=pi;
    }
// cout <<endl<<"Pi is "<<setprecision(10)<<pi<< endl;
    clock_gettime(CLOCK_MONOTONIC_RAW, &end);
    printf("%lf is ok\n", pisum);
    printf("Time taken: %lf sec.\n",
           end.tv_sec-start.tv_sec
           + 0.000000001*(end.tv_nsec-start.tv_nsec));
    return 0;
}
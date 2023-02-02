#include <stdio.h>
#include <iostream>
#include <vector>
#include <iomanip>

#define N 30//N-way
#define k 100

unsigned long long int rdtsc()
{
    unsigned long long int hi, lo;
    __asm__ __volatile__ ("rdtsc" : "=a"(lo), "=d"(hi));
    return  lo |  (hi << 32ull);
}



void volatile command_a(){
    __asm__  __volatile__ (".align 4096\n\t"
             "nop");
}

void volatile command(){
    __asm__ __volatile__ ("nop");
}

double volatile bypass(int i){
    double volatile sum = 0;
    for (int z = 0; z < k; ++z) {
        for (int j = 0; j < i; ++j) {
            command_a();
        }
        auto t1 = rdtsc();
        for (int j = 0; j < i; ++j) {
            command_a();
        }
        auto t2 = rdtsc();
        sum += (t2 - t1);
    }
    double volatile sumbase = 0;
    for (int volatile z = 0; z < k; ++z) {
        for (int j = 0; j < i; ++j) {
            command();
        }
        auto t1 = rdtsc();
        for (int j = 0; j < i; ++j) {
            command();
        }
        auto t2 = rdtsc();
        sumbase += (t2 - t1);
    }
    return (sum - sumbase)/(i*k);
}


using namespace std;
int main(){
    for (int volatile i = 1; i < N; i++) {
        auto volatile cur_lat = bypass(i);
        cout<<i<<" "<<cur_lat<<endl;
    }

    return 0;
}
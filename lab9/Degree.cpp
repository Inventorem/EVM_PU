#include <iostream>

const unsigned long long int N = 1024 * 1024 * 400;
const unsigned long long int RUN_ARRAY_COUNT = 3;
const unsigned long long int offset = 16 * 1024 * 1024 / sizeof(int);
const unsigned long long int size = 9 * 1024 * 1024 / sizeof(int);
unsigned long long int rdtsc()
{
    unsigned long long int hi, lo;
    __asm__ __volatile__ ("rdtsc" : "=a"(lo), "=d"(hi));
    return  lo |  (hi << 32ull);
}

void bypass(unsigned int *array, unsigned int fragments, int offset, int size)
{
    size_t i = 0;
    size_t j = 1;

    for(i = 0; i < size; i++)
    {
        for(j = 1; j < fragments; j++)
            array[i + (j - 1) * offset] = i + j * offset;

        array[i + (j - 1) * offset] = i + 1;
    }

    array[i - 1 + (j - 1) * offset] = 0;
    volatile size_t counter;
    volatile size_t temp_k;
    volatile size_t temp_j;
    volatile unsigned long long int t1, t2;
    unsigned long long int tmin = ULLONG_MAX;
    for(temp_j = 0; temp_j < RUN_ARRAY_COUNT; temp_j++)
    {
        t1 = rdtsc();

        for(temp_k = 0, counter = 0; counter < N; counter++)
            temp_k = array[temp_k];

        t2 = rdtsc();

        if(tmin > t2 - t1)
            tmin = t2 - t1;
    }

    printf("%u\t %llu\n", fragments, tmin / N);
}

int main()
{
    auto *array = (unsigned int *) malloc(N * sizeof(unsigned int));
    if(!array)
        return 1;
    for(int n = 1; n <= 30; n++)
        bypass(array, n, offset, size);
    free(array);
    return 0;
}

#include <iostream>
#include <set>
#include <cstdlib>
#include <ctime>
#include <iomanip>
#include <fstream>

#define MIN_SIZE (1 * 1024)
#define MAX_SIZE (3 * 1024 * 1024)
//12 мб
/*
 * How to execute:
 *>g++ Cache.cpp -o cache -O1
 *>./cache >log.txt
 */


using namespace std;

void fillStraight(unsigned int *array, unsigned int n)
{
    for(unsigned int i = 0; i < n - 1; ++i) {
        array[i] = i + 1;
    }
    array[n - 1] = 0;
}

void fillReverse(unsigned int *array, unsigned int n)
{
    for(unsigned int i = n - 1; i > 0; --i) {
        array[i] = i - 1;
    }
    array[0] = n - 1;
}


void fillRandom(unsigned int *array, unsigned int n)
{
    srand(time(NULL));

    set<unsigned int> set;
    for(unsigned int i = 0; i < n; ++i)
        set.insert(i);

    unsigned int index = rand() % set.size();
    unsigned int prev = *next(set.begin(), index);
    unsigned int start = prev;

    for(; set.size() > 1;)
    {
        set.erase(next(set.begin(), index));
        index = rand() % set.size();
        array[prev] = *next(set.begin(), index);
        prev = *next(set.begin(), index);
    }
    array[*set.begin()] = start;
}

bool step = false;
unsigned int step0 = 0;

void updateSize(unsigned int& size)
{
    if(!step)
        step0 = size / 2;
    size += step0;
    step = !step;
}

unsigned int m = 0;
void bypass(const unsigned int *array, unsigned int n, unsigned int& k)
{
    for(unsigned int j = 0; j < n * k; ++j)
        m = array[m];
}

union ticks
{
    long long t64;
    struct s32
    {
        long th, tl;
    } t32;
} start0, end0;

void writearrays(){
    for (unsigned int n = MIN_SIZE; n <= MAX_SIZE; updateSize(n)) {
        auto s = std::to_string(n/256);
        auto output = "array" +s+".txt";
        cout<<output<<endl;
        std::ofstream outfile (output);
        auto * array = new uint32_t[n];
        fillRandom(array, n);
        for (int i = 0; i < n; ++i) {
            outfile <<array[i];
            outfile<<endl;
        }
        outfile.close();
    }
}

void readarray(std::ifstream& f, unsigned int * array, unsigned int n){
    for (unsigned int i = 0; i < n; i++)
        f>>array[i];
}

int main(){
//    //До 12 мбайт
    unsigned long long Time = 0;
    std::cout << std::setw(10) << std::left << "Size, KB"
                            << std::setw(10) << std::left << "Straight"
                            << std::setw(10) << std::left << "Reverse"
              << std::setw(10) << std::left << "Random" << std::endl;
    for (unsigned int n = MIN_SIZE; n <= MAX_SIZE; updateSize(n)) {
        cout << std::setw(10) << (double) n / 256;
        unsigned int *array = new uint32_t[n];
        auto s = std::to_string(n / 256);
        auto input = "array" + s + ".txt";
        std::ifstream input_file(input);
        unsigned int k = 1000;
        fillStraight(array, n);
        for (unsigned int j = 0; j < n; ++j)
            m = array[m];
        asm("rdtsc\n":"=a"(start0.t32.th), "=d"(start0.t32.tl));
        bypass(array, n, k);
        asm("rdtsc\n":"=a"(end0.t32.th), "=d"(end0.t32.tl));
        Time = end0.t64 - start0.t64;
        cout << std::setw(10) << Time / (k * n);

        fillReverse(array, n);
        for (unsigned int j = 0; j < n; ++j)
            m = array[m];
        asm("rdtsc\n":"=a"(start0.t32.th), "=d"(start0.t32.tl));
        bypass(array, n, k);
        asm("rdtsc\n":"=a"(end0.t32.th), "=d"(end0.t32.tl));
        unsigned long long Time = end0.t64 - start0.t64;
        cout << std::setw(10) << Time / (k * n);

        readarray(input_file, array, n);
        for (unsigned int j = 0; j < n; ++j)
            m = array[m];
        asm("rdtsc\n":"=a"(start0.t32.th), "=d"(start0.t32.tl));
        bypass(array, n, k);
        asm("rdtsc\n":"=a"(end0.t32.th), "=d"(end0.t32.tl));
        Time = end0.t64 - start0.t64;
        cout << std::setw(10) << Time / (k * n);

        delete[] array;
        cout << endl;
    }
    return 0;
}


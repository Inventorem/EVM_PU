//
// Created by lev on 25.12.2022.
//

#ifndef LAB7_FILES_HPP
#define LAB7_FILES_HPP

#include <fstream>
#include <iostream>
void writeMatrix(int N){
    auto n = std::to_string(N);
    auto output = "matrix"+n+".txt";
    std::ofstream outfile (output);
    for (int i = 0; i < N; ++i) {
        for (int j = 0; j < N; ++j) {
            outfile<<(i*N+j);
            outfile<<"\n";
        }
    }
    outfile.close();
}

void writeResult(int N, std::string mode, float * result){
    auto n = std::to_string(N);
    auto output = "result"+n+mode+".txt";
    std::ofstream outfile (output);
    for (int i = 0; i < N; ++i) {
        for (int j = 0; j < N; ++j) {
            outfile<<result[i*N+j];
            outfile<<"\n";
        }
    }
    outfile.close();
}

void readMatrix(std::string input, float * array, int n){
    std::ifstream inputfile (input);
    for (int i = 0; i < n * n; i++)
        inputfile>>array[i];

}


#endif //LAB7_FILES_HPP

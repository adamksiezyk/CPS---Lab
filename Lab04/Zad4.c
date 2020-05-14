// TO compile: gcc Zad4.c -I/usr/local/include -L/usr/local/lib -lfftw3 -lm -o Zad4

#include <fftw3.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <sys/time.h>

// Macros for real and imaginary parts
#define REAL 0
#define IMAG 1

// To measure time
struct timeval t0;
struct timeval t1;

// Load external data to signal array
void LoadData(fftw_complex *x, int N){
    // Define files of real and imaginary parts
    FILE *FileREAL;
    FILE *FileIMAG;
    // Open the data
    FileREAL = fopen("Zad3-xr.dat", "r");
    FileIMAG = fopen("Zad3-xi.dat", "r");
    // Check if opening the files succeeded
    if(FileREAL == NULL || FileIMAG == NULL){
        exit(EXIT_FAILURE);
    }
    // Load the data to the complex array
    double Re, Imag;
    for(int i=0; i<N; i++){
        fscanf(FileREAL, "%lf", &x[i][REAL]);
        fscanf(FileIMAG, "%lf", &x[i][IMAG]);
    }
    // Close the files
    fclose(FileREAL);
    fclose(FileIMAG);
}

// Save the data to an external file
void SaveComplex(fftw_complex *X, int N){
    // Inpot: X-spectrum, Path-file path, N-number of samples. Saves the complex spectrum to Path.dat file

    // Open real and imaginary part
    FILE *FileRe;
    FILE *FileImag;
    FileRe = fopen("XR_fftw.dat", "w");
    FileImag = fopen("XI_fftw.dat", "w");
    // Check if opening succeed
    if(FileRe == NULL || FileImag == NULL){
        exit(EXIT_FAILURE);
    }

    // Write the data to rhe files
    for(int i=0; i<N; i++){
        fprintf(FileRe, "%lf", X[i][REAL]);
        fprintf(FileRe, "%c", '\t');
        fprintf(FileImag, "%lf", X[i][IMAG]);
        fprintf(FileImag, "%c", '\t');
    }

    // Close the files
    fclose(FileRe);
    fclose(FileImag);
}

int main(){
    // Define the number of samples
    int N = 1024;
    // Input signal
    fftw_complex x[N];
    // Output spectrum
    fftw_complex X[N];
    // Fill the signal
    fftw_complex *xp = x;
    LoadData(xp, N);
    // Plan the FFT
    fftw_plan Plan = fftw_plan_dft_1d(N, x, X, FFTW_FORWARD, FFTW_ESTIMATE);
    // Execute the FFT
    gettimeofday(&t0, NULL);    // Start time measurment
    fftw_execute(Plan);
    gettimeofday(&t1, NULL);
    long t = (t1.tv_usec - t0.tv_usec);
    printf("Computing time: %li us.\n", t);
    // Do some cleaning
    fftw_destroy_plan(Plan);
    fftw_cleanup();
    // Save the spectrum
    fftw_complex *Xp = X;
    SaveComplex(Xp,N);
}
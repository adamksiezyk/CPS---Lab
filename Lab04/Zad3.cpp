#include <complex>
#include <iostream>
#include <fstream>
#include <string>
#include <math.h>
#include <sys/time.h>
#include <iomanip>

// To measure time
struct timeval t0;
struct timeval t1;

template <class T>
std::complex<T>* LoadComplex(std::string PathRe, std::string PathImag, int &N){
    // Input: Path-file path, N-array length. Output: Complex array of loaded data.

    if(!(N && (!(N&(N-1))))) exit(EXIT_FAILURE);

    std::ifstream FileRe;   // Open real and imaginary part
    std::ifstream FileImag;
    FileRe.open(PathRe);
    FileImag.open(PathImag);
    if(!FileRe.is_open() || !FileImag.is_open()){   // Check if opening succeed
        exit(EXIT_FAILURE);
    }

    std::complex<T> *CompData = new std::complex<T>[N];   // Read the data into a complex array
    T Re, Imag;
    for(int i=0; i<N; i++){
        FileRe >> Re;
        FileImag >> Imag;
        CompData[i] = std::complex<T>(Re, Imag);
    }

    FileRe.close();     // Close the files
    FileImag.close();

    return CompData;
}

template <class T>
std::complex<T>* myFFT(std::complex<T> *x, int const &N){
    // Input: signal, N-number of samples. Output: X-spectrum of x

    std::complex<T> const j(0, 1);   // Define i const
    std::complex<T> *X = new std::complex<T>[N];

    if(N == 2){
        X[0] = x[0] + x[1];
        X[1] = x[0] - x[1];
    }
    else
    {
        std::complex<T> *x1 = new std::complex<T>[N/2];
        std::complex<T> *x2 = new std::complex<T>[N/2];
        for(int i=0, c=0; i<N/2; i++, c += 2){
            x1[i] = x[c];
            x2[i] = x[c+1];
        }
        std::complex<T> *X1 = myFFT(x1, N/2);
        std::complex<T> *X2 = myFFT(x2, N/2);
        
        for(int i=0; i<N; i++){
            X[i] = X1[i%(N/2)] + exp(-j*(T)2.0*(T)M_PI/(T)N*(T)i) * X2[i%(N/2)];
        }

        delete[] x1, X1, x2, X2;
    }
    return X;
}

template <class T>
void SaveComplex(std::complex<T> *X, std::string PathRe, std::string PathImag, int &N){
    // Inpot: X-spectrum, Path-file path, N-number of samples. Saves the complex spectrum to Path.dat file

    std::ofstream FileRe;   // Open real and imaginary part
    std::ofstream FileImag;
    FileRe.open(PathRe);
    FileImag.open(PathImag);
    if(!FileRe.is_open() || !FileImag.is_open()){   // Check if opening succeed
        exit(EXIT_FAILURE);
    }

    for(int i=0; i<N; i++){ // Write the data to rhe files
        FileRe << std::setprecision(20) << std::real(X[i]);
        FileRe << '\t';
        FileImag << std::setprecision(20) << std::imag(X[i]);
        FileImag << '\t';
    }

    FileRe.close(); // Close the files
    FileImag.close();
}

int main(){
    int N = 1024;
    // For double
    std::complex<double> *x_double = LoadComplex<double>("Zad3-xr.dat", "Zad3-xi.dat", N);
    gettimeofday(&t0, NULL);    // Start time measurment
    std::complex<double> *X_double = myFFT<double>(x_double, N);
    gettimeofday(&t1, NULL);
    long t = t1.tv_usec - t0.tv_usec;
    std::cout << "Computing time: " << t << " us." << std::endl;
    SaveComplex<double>(X_double,"XR_double.dat", "XI_double.dat", N);

    // For float
    std::complex<float> *x_float = LoadComplex<float>("Zad3-xr.dat", "Zad3-xi.dat", N);
    std::complex<float> *X_float = myFFT<float>(x_float, N);
    SaveComplex<float>(X_float,"XR_float.dat", "XI_float.dat", N);

    delete[] x_double, X_double, x_float, X_float;
}
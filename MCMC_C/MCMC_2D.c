/*
Runs a simple Metropolis-Hastings (ie MCMC) algorithm to simulate two
jointly distributed random variables with probability density
p(x,y)=exp(-(x^4+x*y+y^2)/s^2)/consNorm, where s>0 and consNorm is a
normalization constant.

NOTE: This code will create a local file (see variable strFilename) to store results.

WARNING: This code usese the default C random number generator, which is known for failing various tests of randomness.

Author: H. Paul Keeler, 2022.
Website: hpaulkeeler.com
Repository: github.com/hpaulkeeler/posts
*/

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include <stdbool.h>
#include <string.h>

#define numb(x) (sizeof(x) / sizeof(*x)) // size of array
#define PI 3.14159265358979323846        // constant pi for generating polar oordiantes

double *unirand(int numbRand); // generate  uniform random variables on (0,1)
void normrand(double *p_output, int n_output, double mu, double sigma);
// void exppdf(double x_input, double *p_output, int n_output, double m);
double exppdf_single(double x_input, double m);
double pdf_single(double x_input, double y_input, double s);

int main()
{
    // intializes (pseudo)-random number generator
    time_t timeCPU; // use CPU time for seed
    srand((unsigned)time(&timeCPU));
    // srand(42); //to reproduce results

    bool booleWriteData = true;

    // parameters
    int numbSim = 1e4;   // number of random variables simulated
    int numbSteps = 200; // number of steps for the Markov process
    // probability density parameters
    double s = .5; // scale parameter for distribution to be simulated
    double sigma = 2;
    char strFilename[] = "MCMCData_2D.csv"; // filename for storing simulated random variates

    // Metropolis-hastings variables
    double zxRand;      // random step
    double zyRand;      // random step
    double pdfProposal; // density for proposed position
    double pdfCurrent;  // density of current position
    double ratioAccept;
    double *p_uRand; // points to uniform variable for Bernoulli trial (ie a coin flip)
    double *p_numbNormX = (double *)malloc(1 * sizeof(double));
    double *p_numbNormY = (double *)malloc(1 * sizeof(double));

    double *p_xRand = (double *)malloc(numbSim * sizeof(double));
    double *p_yRand = (double *)malloc(numbSim * sizeof(double));

    p_xRand = unirand(numbSim); // random initial values
    p_yRand = unirand(numbSim); // random initial values

    int i, j; // loop varibales
    for (i = 0; i < numbSim; i++)
    {
        // loop through each random walk instance (or random variable to be simulated)
        pdfCurrent = pdf_single(*(p_xRand + i), *(p_yRand + i), s); // current transition probabilities

        for (j = 0; j < numbSteps; j++)
        {
            // loop through each step of the random walk
            normrand(p_numbNormX, 1, 0, sigma);
            normrand(p_numbNormY, 1, 0, sigma);
            // take a(normally distributed) random step
            zxRand = (*(p_xRand + i)) + (*p_numbNormX);
            zyRand = (*(p_yRand + i)) + (*p_numbNormY);

            pdfProposal = pdf_single(zxRand, zyRand, s); // proposed probability

            // acceptance rejection step
            p_uRand = unirand(1);
            ratioAccept = pdfProposal / pdfCurrent;
            if (*p_uRand < ratioAccept)
            {
                // update state of random walk / Markov chain
                *(p_xRand + i) = zxRand;
                *(p_yRand + i) = zyRand;
                pdfCurrent = pdfProposal;
            }
        }
    }
    free(p_numbNormX);
    free(p_numbNormY);

    // initialize statistics variables (for testing results)
    double meanX = 0;
    double meanY = 0;
    double meanXSquared = 0;
    double meanYSquared = 0;
    double tempX;
    double tempY;
    int countSim = 0;
    for (i = 0; i < numbSim; i++)
    {
        tempX = *(p_xRand + i);
        tempY = *(p_yRand + i);

        meanX += tempX / ((double)numbSim);
        meanY += tempY / ((double)numbSim);
        meanXSquared += pow(tempX, 2) / ((double)numbSim);
        meanYSquared += pow(tempY, 2) / ((double)numbSim);

        countSim++;
    }
    printf("The number of simulations was %d.\n", countSim);

    double varX = meanXSquared - pow(meanX, 2);
    double stdX = sqrt(varX);
    printf("The average of the X random variables is %lf.\n", meanX);
    printf("The standard deviance of the X random  variables is %lf.\n", stdX);

    double varY = meanYSquared - pow(meanY, 2);
    double stdY = sqrt(varY);
    printf("The average of the Y random variables is %lf.\n", meanY);
    printf("The standard deviance of the Y random  variables is %lf.\n", stdY);

    if (booleWriteData)
    {
        // print to file
        FILE *outputFile;
        outputFile = fopen(strFilename, "w+");
        // fprintf(outputFile, "valueSim\n");
        for (int i = 0; i < numbSim; i++)
        {
            fprintf(outputFile, "%lf,%lf\n", *(p_xRand + i), *(p_yRand + i)); // output to file
        }
        printf("Data printed to file.\n");
    }
    free(p_xRand);

    return (0);
}

double pdf_single(double x_input, double y_input, double s)
{ // simulate a single exponential random variable with mean m
    double pdf_output;

    // Simulation window parameters
    double xMin = -1;
    double xMax = 1;
    double yMin = -1;
    double yMax = 1;

    if ((x_input >= xMin) && (x_input <= xMax) && (y_input >= yMin) && (y_input <= yMax))
    {
        pdf_output = exp(-((pow(x_input, 4) + x_input * y_input + pow(y_input, 2)) / (s * s)));
    }
    else
    {
        pdf_output = 0;
    }
    return pdf_output;
}

void normrand(double *p_output, int n_output, double mu, double sigma)
{
    // simulate pairs of iid normal variables using Box-Muller transform
    // https://en.wikipedia.org/wiki/Box%E2%80%93Muller_transform

    double U1, U2, temp_theta, temp_Rayleigh, Z1, Z2;
    double *p_U1, *p_U2;
    int i = 0;
    while (i < n_output)
    {
        // simulate variables in polar coordinates
        // U1 = (double)rand() / (double)((unsigned)RAND_MAX + 1); // generate random variables on (0,1)
        p_U1 = unirand(1);
        U1 = *p_U1;

        temp_theta = 2 * PI * U1; // create uniform theta values
        // U2 = (double)rand() / (double)((unsigned)RAND_MAX + 1); // generate random variables on (0,1)
        p_U2 = unirand(1);
        U2 = *p_U2;
        temp_Rayleigh = sqrt(-2 * log(U2)); // create Rayleigh rho values

        Z1 = temp_Rayleigh * cos(temp_theta);
        Z1 = sigma * Z1 + mu;
        *(p_output + i) = Z1; // assign first of random variable pair
        i++;
        if (i < n_output)
        {
            // if more variables are needed, generate second value of random pair
            Z2 = temp_Rayleigh * sin(temp_theta);
            Z2 = sigma * Z2 + mu;
            *(p_output + i) = Z2; // assign second of random variable pair
            i++;
        }
        else
        {
            break; // break if i hits n_max
        }
    }
}

double *unirand(int numbRand)
{ // simulate a single uniform random variable on the unit interval

    // double static returnValues[10];
    double *returnValues = malloc(numbRand * sizeof(double));
    // C does not advocate to return the address of a local variable to outside of the function, so you would have to define the local variable as static variable.

    for (int i = 0; i < numbRand; i++)
    {
        returnValues[i] = (double)rand() / (double)((unsigned)RAND_MAX + 1);
    }
    return returnValues;
}

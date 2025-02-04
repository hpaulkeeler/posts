/*
Runs a simple Metropolis-Hastings (ie MCMC) algoritm to simulate an
exponential distribution, which has the probability density
p(x)=exp(-x/m), where m>0.

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
int main()
{
    // intializes (pseudo)-random number generator
    time_t timeCPU; // use CPU time for seed
    srand((unsigned)time(&timeCPU));
    // srand(42); //to reproduce results

    bool booleGnuPlot = true;
    bool booleWriteData = true;

    // parameters
    int numbSim = 1e4;   // number of random variables simulated
    int numbSteps = 200; // number of steps for the Markov process
    double sigma = 1;    // standard deviation for normal random steps
    double m = 0.75;     // parameter (ie mean) for distribution to be simulated

    char strFilename[] = "MCMCData_1D.csv"; // filename for storing simulated random variates

    // Metropolis-hastings variables
    double zRand;       // random step
    double pdfProposal; // density for proposed position
    double pdfCurrent;  // density of current position
    double ratioAccept;
    double *p_uRand;                                           // points to uniform variable for Bernoulli trial (ie a coin flip)
    double *p_numbNorm = (double *)malloc(1 * sizeof(double)); // cast points for malloc in C++ and for gcc
    double *p_xRand = (double *)malloc(numbSim * sizeof(double));

    p_xRand = unirand(numbSim); // random initial values
    int i, j;                   // loop varibales
    for (i = 0; i < numbSim; i++)
    {
        // loop through each random walk instance (or random variable to be simulated)
        pdfCurrent = exppdf_single(*(p_xRand + i), m); // current transition probabilities

        for (j = 0; j < numbSteps; j++)
        {
            // loop through each step of the random walk
            normrand(p_numbNorm, 1, 0, sigma);
            zRand = (*(p_xRand + i)) + (*p_numbNorm); // take a(normally distributed) random step
            pdfProposal = exppdf_single(zRand, m);    // proposed probability

            // acceptance rejection step
            p_uRand = unirand(1);
            ratioAccept = pdfProposal / pdfCurrent;
            if (*p_uRand < ratioAccept)
            {
                // update state of random walk / Markov chain
                *(p_xRand + i) = zRand;
                pdfCurrent = pdfProposal;
            }
        }
    }
    free(p_numbNorm);

    // initialize statistics variables (for testing results)
    double meanExp = 0;
    double meanExpSquared = 0;
    double tempExp;
    int countSim = 0;
    for (i = 0; i < numbSim; i++)
    {
        tempExp = *(p_xRand + i);
        meanExp += tempExp / ((double)numbSim);
        meanExpSquared += pow(tempExp, 2) / ((double)numbSim);
        countSim++;
    }
    printf("The number of simulations was %d.\n", countSim);
    double varExp = meanExpSquared - pow(meanExp, 2); // need to cast before doing divisions
    double stdExp = sqrt(varExp);
    printf("The average of the random  variables is %lf.\n", meanExp);
    printf("The standard deviance of the random  variables is %lf.\n", stdExp);

    if (booleWriteData)
    {
        // print to file
        FILE *outputFile;
        outputFile = fopen(strFilename, "w+");
        // fprintf(outputFile, "valueSim\n");
        for (int i = 0; i < numbSim; i++)
        {
            fprintf(outputFile, "%lf\n", *(p_xRand + i)); // output to file
        }
        printf("Data printed to file.\n");
    }
    free(p_xRand);

    // plotting with gnuplot (if it installed)

    if (booleGnuPlot)
    {
        int intGnuPlot = system("gnuplot -e \"quit\"");
        if (intGnuPlot == 0)
        {
            // create a string for running the plotting program gnuplot
            char strCommandPlotL[] = "gnuplot -e \"plot '";
            char strCommandPlotR[] = "' using 1 bins=20;\" -persist";
            int numbCommandPlot = strlen(strCommandPlotL) + strlen(strCommandPlotR) + strlen(strFilename);
            char *strCommandPlot = malloc(numbCommandPlot + 1);

            strcat(strCommandPlot, strCommandPlotL);
            strcat(strCommandPlot, strFilename);
            strcat(strCommandPlot, strCommandPlotR);

            printf("\nRunning the external command:\n%s\n", strCommandPlot);
            system(strCommandPlot); // plot data using external program gnuplot
            free(strCommandPlot);
            printf("\nTo stop plotting, change the boolean variable booleGnuPlot to false.");
        }
    }
    return (0);
}

double exppdf_single(double x_input, double m)
{ // simulate a single exponential random variable with mean m
    double pdf_output;
    if ((x_input) > 0)
    {
        pdf_output = exp(-(x_input / m)) / m;
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

/***********************************************************
 * Runs a simple Metropolis-Hastings (ie MCMC) algorithm to simulate two
 * jointly distributed random variables with probability density
 * p(x,y)=exp(-(x^4+x*y+y^2)/s^2)/consNorm, where s>0 and consNorm is a
 * normalization constant.
 *
 * NOTE: In practice, the value of the normalization constant is not needed, as it cancels out in the algorithm.
 *
 * NOTE: This code will *create* a local file (see variable strFilename) to store results. It will *overwrite* that file if it already exists.
 *
 * WARNING: This code uses the default C random number generator, which is known for failing various tests of randomness. 
 * Strongly recommended to use another generator for purposes beyond simple illustration.
 *
 * Author: H. Paul Keeler, 2024.
 * Website: hpaulkeeler.com
 * Repository: github.com/hpaulkeeler/posts
 *
 ***********************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include <stdbool.h>
#include <string.h>

const long double pi = 3.14159265358979323846; // constant pi for generating polar coordinates

double *unirand(unsigned numbRand, double *returnValues); // generate  uniform random variables on (0,1)
void normrand(double *p_output, unsigned n_output, double mu, double sigma);
double pdf_single(double x_input, double y_input, double s);

int main()
{
    char strFilename[] = "MCMCData_2D.csv"; // filename for storing simulated random variates

    // intializes (pseudo)-random number generator
    time_t timeCPU; // use CPU time for seed
    srand((unsigned)time(&timeCPU));
    // srand(42); //to reproduce results

    bool booleWriteData = true; //write data to file

    // parameters
    unsigned numbSim = 1e4; // number of random variables simulated
    unsigned numbSteps = 200; // number of steps for the Markov process
    // probability density parameters
    double s = .5; // scale parameter for distribution to be simulated
    double sigma = 2;

    // Metropolis-hastings variables
    double zxRand;      // random step
    double zyRand;      // random step
    double pdfProposal; // density for proposed position
    double pdfCurrent;  // density of current position
    double ratioAccept;
    double uRand; // uniform variable for Bernoulli trial (ie a coin flip)
    double *p_numbNormX = (double *)malloc(1 * sizeof(double));
    double *p_numbNormY = (double *)malloc(1 * sizeof(double));

    double *p_xRand = (double *)malloc(numbSim * sizeof(double));
    double *p_yRand = (double *)malloc(numbSim * sizeof(double));

    (void)unirand(numbSim, p_xRand); // random initial values
    (void)unirand(numbSim, p_yRand); // random initial values

    unsigned i, j; // loop varibales
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
            (void)unirand(1, &uRand);
            ratioAccept = pdfProposal / pdfCurrent;
            if (uRand < ratioAccept)
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
    unsigned countSim = 0;
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
    printf("The standard deviation of the X random  variables is %lf.\n", stdX);

    double varY = meanYSquared - pow(meanY, 2);
    double stdY = sqrt(varY);
    printf("The average of the Y random variables is %lf.\n", meanY);
    printf("The standard deviation of the Y random  variables is %lf.\n", stdY);

    if (booleWriteData)
    {
        // print to file
        FILE *outputFile;
        outputFile = fopen(strFilename, "w+");
        // fprintf(outputFile, "valueSim\n");
        for (i = 0; i < numbSim; i++)
        {
            fprintf(outputFile, "%lf,%lf\n", *(p_xRand + i), *(p_yRand + i)); // output to file
        }
        printf("Data printed to file.\n");
    }
    free(p_xRand);
    free(p_yRand);

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

void normrand(double *p_output, unsigned n_output, double mu, double sigma)
{
    // simulate pairs of iid normal variables using Box-Muller transform
    // https://en.wikipedia.org/wiki/Box%E2%80%93Muller_transform

    double U1, U2, temp_theta, temp_Rayleigh, Z1, Z2;
    int i = 0;
    while (i < n_output)
    {
        // simulate variables in polar coordinates
        // U1 = (double)rand() / (double)((unsigned)RAND_MAX + 1); // generate random variables on (0,1)
        (void)unirand(1, &U1);

        temp_theta = 2 * pi * U1; // create uniform theta values
        // U2 = (double)rand() / (double)((unsigned)RAND_MAX + 1); // generate random variables on (0,1)
        (void)unirand(1, &U2);
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

double *unirand(unsigned numbRand, double *returnValues)
{ // simulate numbRand uniform random variables on the unit interval
  // storing them in returnValues which must be allocated by the caller
  // with enough space for numbRand doubles


    for (int i = 0; i < numbRand; i++)
    {
        returnValues[i] = (double)rand() / RAND_MAX;
    }
    return returnValues;
}

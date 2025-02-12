/***********************************************************************
 * Runs a simple Metropolis-Hastings (ie MCMC) algorithm to simulate three
 * jointly distributed random variables with probability density p(x,y).
 * For example:
 * p(x,y)=exp(-(x^4+x*y+y^2+z^4)/s^2)/consNorm, where s>0 and consNorm is a
 * normalization constant. The probability density function is defined in
 * the function pdf_single.
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

// helper function declarations; see below for definitions
static double *unirand(double *randValues, unsigned numbRand);                           // generate  uniform random variables on (0,1)
static double *normrand(double *randValues, unsigned numbRand, double mu, double sigma); // generate normal random variables
static double pdf_single(double *x_input, double *parameters);                           // define probability density to be simulated
static double mean_var(double *set_sample, unsigned numbSim, double *varX);              // calculate meana and variance

int main(int argc, char *argv[])
{

    if (argc > 1)
    {
        fprintf(stderr, "This program takes no arguments...\n");
        exit(1);
    }
    else
    {
        char strFilename[] = "MCMCData_ND.csv"; // filename for storing simulated random variates

        // intializes (pseudo)-random number generator
        time_t timeCPU; // use CPU time for seed
        srand((unsigned)time(&timeCPU));
        // srand(42); //to reproduce results

        bool booleWriteData = true; // write data to file
        bool booleStats = true;     // perform simple mean/std stats

        // parameters
        unsigned numbSim = 1e4;   // number of random variables simulated
        unsigned numbSteps = 200; // number of steps for the Markov process
        double sigma = 2;         // standard deviation for normal random steps

        // probability density parameters
        double s = .5; // scale parameter for distribution to be simulated
        unsigned numbDim = 3;

        // Metropolis-Hastings variables
        // proposal for a new position in the random walk
        double *tRandProposal = (double *)malloc(numbDim * sizeof(double));
        double pdfProposal;      // density for proposed position
        double pdfCurrent;       // density of current position
        double ratioAccept;      // ratio of densities (ie acceptance probability)
        double uRand;            // uniform variable for Bernoulli trial (ie a coin flip)
        // random step (normally distributed)
        double *p_numbNormT = (double *)malloc(1 * sizeof(double));
        // positions of the random walk (ie the simualted random variables after numbSteps)
        double *p_tRand = (double *)malloc(numbDim * numbSim * sizeof(double));

        unsigned i, j, k;     // loop varibales
        unsigned indexSimDim; // index for keeping track of two-dimensional data as a one-dimensional array
        // Typically indexSimDim = i * numbDim + k, where i is simulation number and k is dimension number (minus one)

        double *p_tRandCurrent = (double *)malloc(numbDim * sizeof(double));
        (void)unirand(p_tRand, numbDim * numbSim); // random initial values

        for (i = 0; i < numbSim; i++)
        {
            // loop through each random walk instance (or random variable to be simulated)
            for (k = 0; k < numbDim; k++)
            {
                // loop through dimensions
                indexSimDim = i * numbDim + k;
                // update state of random walk / Markov chain
                *(p_tRandCurrent + k) = *(p_tRand + indexSimDim);
            }

            pdfCurrent = pdf_single(p_tRandCurrent, &s); // current probability density

            for (j = 0; j < numbSteps; j++)
            {
                // loop through each step of the random walk
                for (k = 0; k < numbDim; k++)
                {
                    // loop through dimensions
                    indexSimDim = i * numbDim + k;
                    (void)normrand(p_numbNormT, 1, 0, sigma);
                    // take a(normally distributed) random step in x, y and y
                    *(tRandProposal+k) = *(p_tRand + indexSimDim) + *(p_numbNormT);
                }
                pdfProposal = pdf_single(tRandProposal, &s); // proposed probability density

                // acceptance rejection step
                (void)unirand(&uRand, 1);
                ratioAccept = pdfProposal / pdfCurrent;
                if (uRand < ratioAccept)
                {
                    for (k = 0; k < numbDim; k++)
                    {
                        // loop through dimensions
                        indexSimDim = i * numbDim + k;
                        // update state of random walk / Markov chain
                        *(p_tRand + indexSimDim) = tRandProposal[k];
                    }
                    pdfCurrent = pdfProposal;
                }
            }
        }

        free(p_numbNormT);

        if (booleStats)
        {
            // initialize statistics variables (for testing results)
            double *p_AllRand = (double *)malloc(numbSim * sizeof(double));
            double meanTemp = 0;
            double varTemp = 0;
            double stdTemp = 0;
            unsigned numbDimStats = fmin(3, numbDim);
            for (k = 0; k < numbDimStats; k++)
            {
                // loop through all the dimensions
                for (i = 0; i < numbSim; i++)
                {
                    // collect variables for dimension k+1
                    indexSimDim = i * numbDim + k;
                    *(p_AllRand + i) = *(p_tRand + indexSimDim);
                }
                meanTemp = mean_var(p_AllRand, numbSim, &varTemp);
                stdTemp = sqrt(varTemp);
                printf("The average of dimension %d random variables is %lf.\n", k + 1, meanTemp);
                printf("The standard deviation of dimension %d random  variables is %lf.\n", k + 1, stdTemp);
            }
        }

        if (booleWriteData)
        {
            // print to file
            FILE *outputFile;
            outputFile = fopen(strFilename, "w");

            // create string of spacers (ie commas and newlines)
            char *strSpacer = (char *)malloc((numbDim + 1) * sizeof(char));
            for (k = 0; k < numbDim - 1; k++)
            {
                *(strSpacer + k) = ',';
            }
            strSpacer[numbDim - 1] = '\n';
            strSpacer[numbDim] = '\0';
            for (i = 0; i < numbSim; i++)
            {
                for (k = 0; k < numbDim; k++)
                {
                    indexSimDim = i * numbDim + k;
                    fprintf(outputFile, "%lf%c", *(p_tRand + indexSimDim), strSpacer[k]);
                }
            }

            fclose(outputFile);
            printf("Data printed to file.\n");
        }
        free(p_tRand);

        return (0);
    }
}

static double pdf_single(double *x_input, double *parameters)
{
    // returns the probability density of a single point inside a simulation window defined below
    double pdf_output;

    // non-zero density window parameters
    double xMin = -1;
    double xMax = 1;
    double yMin = -1;
    double yMax = 1;
    double zMin = -1;
    double zMax = 1;

    // retrieve variables
    double x = *(x_input + 0);
    double y = *(x_input + 1);
    double z = *(x_input + 2);

    double s = *(parameters + 0);

    if ((x >= xMin) && (y <= xMax) && (y >= yMin) && (y <= yMax) && (z >= zMin) && (z <= zMax))
    {
        // define probability density
        pdf_output = exp(-((pow(x, 4) + x * y + pow(y, 2) + x * z + pow(z, 4)) / (s * s)));
    }
    else
    {
        pdf_output = 0;
    }
    return pdf_output;
}

static double *normrand(double *randValues, unsigned numbRand, double mu, double sigma)
{
    // simulate pairs of iid normal variables using Box-Muller transform
    // https://en.wikipedia.org/wiki/Box%E2%80%93Muller_transform

    double U1, U2, thetaTemp, rhoTemp, Z1, Z2;
    int i = 0;
    while (i < numbRand)
    {
        // simulate variables in polar coordinates (theta, rho)
        (void)unirand(&U1, 1);
        thetaTemp = 2 * pi * U1; // create uniform theta values
        (void)unirand(&U2, 1);
        rhoTemp = sqrt(-2 * log(U2)); // create Rayleigh rho values

        // change to Cartesian coordinates (Z1, Z2)
        Z1 = rhoTemp * cos(thetaTemp);
        Z1 = sigma * Z1 + mu;
        randValues[i] = Z1; // assign first of random variable pair
        i++;
        if (i < numbRand)
        {
            // if more variables are needed, generate second value of random pair
            Z2 = rhoTemp * sin(thetaTemp);
            Z2 = sigma * Z2 + mu;
            randValues[i] = Z2; // assign second of random variable pair
            i++;
        }
        else
        {
            break;
        }
    }
    return randValues;
}

static double *unirand(double *randValues, unsigned numbRand)
{ // simulate numbRand uniform random variables on the unit interval
  // storing them in randValues which must be allocated by the caller
  // with enough space for numbRand doubles

    for (int i = 0; i < numbRand; i++)
    {
        randValues[i] = (double)rand() / RAND_MAX;
    }
    return randValues;
}

static double mean_var(double *set_sample, unsigned numbSim, double *varX)
{
    // mean and variance of set_sample
    int i;
    // initialize statistics variables (for testing results)
    double meanX = 0;
    double meanXSquared = 0;
    double tempX;
    for (i = 0; i < numbSim; i++)
    {
        tempX = *(set_sample + i);
        meanX += tempX / ((double)numbSim);
        meanXSquared += tempX * tempX / ((double)numbSim);
    }

    *varX = meanXSquared - meanX * meanX;
    return meanX;
}

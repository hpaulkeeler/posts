/***********************************************************
 * Runs a simple Metropolis-Hastings (ie MCMC) algorithm to simulate an
 * exponential distribution, which has the probability density
 * p(x)=exp(-x/m)*(1/m), where m>0 and (1/m) normalization constant, which is also the mean of the random variable.
 *
 * NOTE: In practice, the value of the normalization constant (ie 1/m) is not needed, as it cancels out in the algorithm.
 *
 *
 * NOTE: This code will *create* a local file (see variable strFilename) to store results.
 * This code will *overwrite* that file if it already exists.
 *
 * WARNING: This code uses the default C random number generator, which is known for failing various tests of randomness.
 * Strongly recommended to use another generator for purposes beyond simple illustration.
 *
 * Author: H. Paul Keeler, 2024.
 * Website: hpaulkeeler.com
 * Repository: github.com/hpaulkeeler/posts
 *
 ************************************************************/
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
static double pdf_single(double x_input, double m);                                      // define probability density to be simulated
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

        char strFilename[] = "MCMCData_1D.csv"; // filename for storing simulated random variates

        int numbFilename = *(&strFilename + 1) - strFilename - 1;

        // intializes (pseudo)-random number generator
        time_t timeCPU; // use CPU time for seed
        srand((unsigned)time(&timeCPU));
        // srand(42); //to reproduce results

        bool booleWriteData = true; // write data to file
        bool booleStats = true;     // perform simple mean/std stats
        bool booleGnuPlot = false;   // run gnuplot (if it's installed on the machine)

        // parameters
        unsigned numbSim = 1e4;   // number of random variables simulated
        unsigned numbSteps = 200; // number of steps for the Markov process
        double sigma = 2;         // standard deviation for normal random steps

        // probability density parameters
        double m = 0.75; // parameter (ie mean) for distribution to be simulated

        // Metropolis-Hastings variables
        double zxRand; // random step
        double pdfProposal; // density for proposed position
        double pdfCurrent;  // density of current position
        double ratioAccept; // ratio of densities (ie acceptance probability)
        double uRand;       // uniform variable for Bernoulli trial (ie a coin flip)
        double *p_numbNormX = (double *)malloc(1 * sizeof(double));

        double *p_xRand = (double *)malloc(numbSim * sizeof(double));

        (void)unirand(p_xRand, numbSim); // random initial values

        unsigned i, j; // loop varibales
        for (i = 0; i < numbSim; i++)
        {
            // loop through each random walk instance (or random variable to be simulated)

            pdfCurrent = pdf_single(*(p_xRand + i), m); // current probability density

            for (j = 0; j < numbSteps; j++)
            {
                // loop through each step of the random walk
                (void)normrand(p_numbNormX, 1, 0, sigma);
                // take a(normally distributed) random step in x and y
                zxRand = (*(p_xRand + i)) + (*p_numbNormX);

                pdfProposal = pdf_single(zxRand, m); // proposed probability density

                // acceptance rejection step
                (void)unirand(&uRand, 1);
                ratioAccept = pdfProposal / pdfCurrent;
                if (uRand < ratioAccept)
                {
                    // update state of random walk / Markov chain
                    *(p_xRand + i) = zxRand;
                    pdfCurrent = pdfProposal;
                }
            }
        }

        free(p_numbNormX);
        // free(p_numbNormY);

        if (booleStats)
        {

            // initialize statistics variables (for testing results)
            double meanX = 0;
            // double meanY = 0;
            double varX = 0;
            // double varY = 0;

            meanX = mean_var(p_xRand, numbSim, &varX);
            double stdX = sqrt(varX);

            printf("The average of the X random variables is %lf.\n", meanX);
            printf("The standard deviation of the X random  variables is %lf.\n", stdX);
        }

        if (booleWriteData)
        {
            // print to file
            FILE *outputFile;
            outputFile = fopen(strFilename, "w");
            // fprintf(outputFile, "valueSim\n");
            for (i = 0; i < numbSim; i++)
            {
                fprintf(outputFile, "%lf\n", *(p_xRand + i)); // output to file
            }
            fclose(outputFile);
            printf("Data printed to file.\n");
        }
        
        free(p_xRand);
        // free(p_yRand);

        if (booleGnuPlot)
        {
            int intGnuPlot = system("gnuplot -e \"quit\"");
            if (intGnuPlot == 0)
            {
                // create a string for running the plotting program gnuplot
                char strCommandPlotL[] = "gnuplot -e \"plot '\0";
                char strCommandPlotR[] = "' using 1 bins=20;\" -persist\0";
                unsigned numbCommandPlot = strlen(strCommandPlotL) + strlen(strCommandPlotR) + numbFilename;
                char *strCommandPlot = (char*) malloc((numbCommandPlot + 1) * sizeof(char));

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
}

static double pdf_single(double x_input, double m)
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

        // change to Cartesian coordinates
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
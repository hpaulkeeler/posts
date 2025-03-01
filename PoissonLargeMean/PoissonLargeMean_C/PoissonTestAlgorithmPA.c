/*
This code generates Poisson variates (or simulates Poisson variables).
using a method designed for large (>30) Poisson parameter values.

The generation method is Algorithm PA, a type of rejection method, from 
the paper:

1979 - Atkinson - "The Computer Generation of Poisson Random Variables"

Author: H. Paul Keeler, 2020.
Website: hpaulkeeler.com
Repository: github.com/hpaulkeeler/posts
*/

/*
WARNING:
This code uses rand(), the standard pseudo-random number generating function in 
C, which is known for producing inadequately random numbers. Replace the 
function rand() in the function funUniformSingle with another standard uniform 
number generator, such as one based on the Mersenne Twister.
 */

#include <stdio.h>
#include <stdlib.h>
#include <time.h> /* time */
#include <math.h>
#include <stdbool.h>

const long double pi = 3.14159265358979323846; // constant pi
// value for when NOT to use the direct methof for sampling Poisson variables
const long double meanPoissonLarge = 30;

// declare functions
static double funUniform();                      // generate uniform random variables on (0,1)
static unsigned int funPoissonDirect(double mu); // generate Poisson variables with parameter (ie mean) mu e.g. < 30
static unsigned int funPoissonPA(double mu);     // generate Poisson variables with parameter (ie mean) mu e.g. > 30
static unsigned int funPoisson(double mu);       // generate Poisson variables
static double funLogFac(unsigned int k);         // uses an approximation for log factorial

// START Main
int main(int argc, char *argv[])
{
    if (argc > 1)
    {
        fprintf(stderr, "This program takes no arguments...\n");
        exit(1);
    }
    else
    {
        time_t s; // use CPU time for seed
        // intializes random number generator
        srand((unsigned)time(&s));

        double mu = 37.74; // lambda is the Poisson parameter (that is, its mean)

        unsigned int numbSim = 10000000; // number of variables

        // START Collect statistists on Poisson variables
        // initialize statistics
        unsigned int numbPoissonTemp;
        double sumPoisson = 0;
        double sumPoissonSquared = 0;

        unsigned int i;
        // loop through for each random variable
        for (i = 0; i < numbSim; i++)
        {
            // generate a single poisson variable
            numbPoissonTemp = funPoisson(mu);

            // total sum of variables
            sumPoisson += numbPoissonTemp;
            // total sum of squared variables
            sumPoissonSquared += numbPoissonTemp * numbPoissonTemp;

            if (i < 5)
            {
                // print the first 5 numbers
                printf("One of the Poisson variables has the value %d.\n", numbPoissonTemp);
            }
        }

        // calculate statistics
        double meanPoisson = sumPoisson / ((double)numbSim);                                   // need to cast before doing divisions
        double varPoisson = sumPoissonSquared / ((double)numbSim) - meanPoisson * meanPoisson; // need to cast before doing divisions

        /// print statistics
        printf("The average of the Poisson variables is %f.\n", meanPoisson);
        printf("The variance of the Poisson variables is %f.\n", varPoisson);
        printf("For Poisson random variables, the mean and variance will agree more and more as the number of simulations increases.");

        // END Collect statistists on Poisson variables

        return (0);
    }
}
// END Main

// START Function definitions

// Poisson function -- returns a single Poisson random variable
static unsigned int funPoisson(double mu)
{
    if (mu <= 0)
    {
        fprintf(stderr, "The Poisson parameter must be a positive number...\n");
        exit(1);
    }
    // generate Poisson variables with parameter
    int randPoisson;
    if (mu < meanPoissonLarge)
    {
        randPoisson = funPoissonDirect(mu);
    }
    else
    {
        randPoisson = funPoissonPA(mu);
    }

    return randPoisson;
}

static unsigned int funPoissonPA(double mu)
{
    // precalculate some Poisson-parameter-dependent numbers
    double c = 0.767 - 3.36 / mu;
    double beta = pi / sqrt(3.0 * mu);
    double alpha = beta * mu;
    double k = log(c) - mu - log(beta);
    double log_mu = log(mu);

    // declare variables for the loop
    double U, x, V, y, logfac_n, lhs, rhs;
    unsigned int n;
    unsigned int randPoisson = 0; // initialize the Poisson random variable (or variate)
    bool booleContinue = true;
    while (booleContinue)
    {
        U = funUniform(); // generate first uniform variable
        x = (alpha - log((1.0 - U) / U)) / beta;

        if (x < -.5)
        {
            continue;
        }
        else
        {
            V = funUniform(); // generate second uniform variable
            n = floor(x + .5);
            y = alpha - beta * x;
            logfac_n = funLogFac(n);

            // two sides of an inequality condition
            lhs = y + log(V / (1.0 + exp(y)) / (1.0 + exp(y)));
            rhs = k + n * log_mu - logfac_n; // NOTE: uses log factorial n

            if (lhs <= rhs)
            {
                randPoisson = n;
                booleContinue = false;
                return randPoisson;
            }
            else
            {
                continue;
            }
        }
    }
    return randPoisson;
}

// Poisson function -- returns a single Poisson random variable
static unsigned int funPoissonDirect(double lambda)
{
    double exp_lambda = exp(-lambda); // constant for terminating loop
    double randUni;                   // uniform variable
    double prodUni;                   // product of uniform variables
    int randPoisson;                  // Poisson variable

    // initialize variables
    randPoisson = -1;
    prodUni = 1;
    do
    {
        randUni = funUniform();      // generate uniform variable
        prodUni = prodUni * randUni; // update product
        randPoisson++;               // increase Poisson variable

    } while (prodUni > exp_lambda);
    return randPoisson;
}

////Uniform function -- returns a standard uniform random variable
static double funUniform()
{
    double randUni;
    randUni = (double)rand() / (double)((unsigned)RAND_MAX); // generate random variables on (0,1)
    return randUni;
}

static double funLogFac(unsigned int k)
{

    // pre-calculated logfac_k values for k=0 to 10
    double values_logfac[] = {0, 0, 0.693147180559945, 1.791759469228055, 3.178053830347946,
                              4.787491742782046, 6.579251212010101, 8.525161361065415, 10.604602902745251,
                              12.801827480081469, 15.104412573075516};
    double logfac_k;
    if (k <= 10)
    {
        logfac_k = values_logfac[k];
    }
    else
    {
        logfac_k = log(sqrt(2 * pi)) + (k + 0.5) * log(k) - k + (1 / 12 - 1 / (360 * k * k)) / k;
    }
    return logfac_k;
}
// END  Function definitions

/*
This code generates Poisson variates (or simulates Poisson variables).
using a method designed for large (>30) Poisson parameter values.

This code generates Poisson variates (or simulates Poisson variables).
using a method designed for large (>10) Poisson parameter values.

The generation method is Algorthm PTRS, a type of rejection method, from
the paper:

1993 - Hörmann - "The transformed rejection method for generating Poisson
random variables"


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
static unsigned int funPoissonPTRS(double mu);   // generate Poisson variables with parameter (ie mean) mu e.g. > 30
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
        randPoisson = funPoissonPTRS(mu);
    }

    return randPoisson;
}

static unsigned int funPoissonPTRS(double mu)
{
    // precalculate some Poisson-parameter-dep}ent numbers
    double b = 0.931 + 2.53 * sqrt(mu);
    double a = -0.059 + 0.02483 * b;
    double vr = 0.9277 - 3.6224 / (b - 2);
    double one_over_alpha = 1.1239 + 1.1328 / (b - 3.4);

    // declare variables for the loop
    double U, V, us, log_mu, logfac_n, lhs, rhs;
    unsigned int n;

    unsigned int randPoisson = 0; // initialize the Poisson random variable (or variate)
    bool booleContinue = true;
    // Steps 1 to 3.1 in Algorithm PTRS
    while (booleContinue)
    {
        // generate two uniform variables
        U = funUniform();
        V = funUniform();

        U = U - 0.5;
        us = 0.5 - fabs(U);

        n = floor((2 * a / us + b) * U + mu + 0.43);

        if ((us >= 0.07) && (V <= vr))
        {
            randPoisson = n;
            return randPoisson;
        }

        if ((n <= 0) || ((us < 0.013) && (V > us)))
        {
            continue;
        }

        log_mu = log(mu);
        logfac_n = funLogFac(n);

        // two sides of an inequality condition
        lhs = log(V * one_over_alpha / (a / us / us + b));
        rhs = -mu + n * log_mu - logfac_n; // NOTE: uses log factorial n

        if (lhs <= rhs)
        {
            randPoisson = n;
            return randPoisson;
        }
        else
        {
            continue;
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

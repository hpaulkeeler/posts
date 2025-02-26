// Author: H. Paul Keeler, 2019.
// Website: hpaulkeeler.com
// Repository: github.com/hpaulkeeler/posts

/* This program simulates Poisson random variables based 
on the direct method of using exponential inter-arrival times. 
For more details, see the post:
hpaulkeeler.com/simulating-poisson-random-variables-direct-method/
*/

/*WARNING: 
This program is only suitable for small Poisson parameter (lambda) 
values, for example, lambda<20.
*/ 

/*WARNING: 
This code uses rand(), the standard pseudo-random number generating function in C, 
which is known for producing inadequately random numbers. 
Replace the function rand() in the function funUniformSingle with another standard uniform number generator. 
 */

#include <stdio.h>
#include <stdlib.h>
#include <time.h> /* time */
#include <math.h>

//declare functions
void funUniformMany(double *p_output, int n_output);             //generate uniform random variables on (0,1)
void funPoissonMany(int *p_output, int n_output, double lambda); //generate Poisson variables with parameter (ie mean) lambda
// p_output is the pointer for the random variables/variates
// n_output is the number of random variables/variates to generate
// lambda is the Poisson parameter (that is, its mean)

//START Main
int main()
{
    time_t s; //use CPU time for seed

    //intializes random number generator
    srand((unsigned)time(&s));

    double lambda = 8.7; //Poisson parameter

    int numbSim = 100;

    //START Generate Poisson variables
    //point for Poisson variables
    int *p_numbPoisson = (int *)malloc(numbSim * sizeof(int)); //cast pointers for malloc in C++ and for gcc
    funPoissonMany(p_numbPoisson, numbSim, lambda);            //generate poisson variables
    //END Generate Poisson variables

    //START Collect statistists on Poisson variables
    //initialize statistics
    double sumPoisson = 0;
    double sumPoissonSquared = 0;
    double tempPoisson;

    //loop through for each random variable
    for (int i = 0; i < numbSim; i++)
    {
        tempPoisson = *(p_numbPoisson + i); //access current Poisson variable
        //total sum of variables
        sumPoisson += tempPoisson;
        //total sum of squared variables
        sumPoissonSquared += tempPoisson*tempPoisson;

        if (i < 5)
        {
            printf("One of the Poisson variables has the value %d.\n", (int)tempPoisson);
        }
    }

    //calculate statistics
    double meanPoisson = sumPoisson / ((double)numbSim);                             //need to cast before doing divisions
    double varPoisson = sumPoissonSquared / ((double)numbSim) - meanPoisson*meanPoisson; //need to cast before doing divisions

    ///print statistics
    printf("The average of the Poisson variables is %f.\n", meanPoisson);
    printf("The variance of the Poisson variables is %f.\n", varPoisson);
    printf("For Poisson random variables, the mean and variance will agree more and more as the number of simulations increases.");

    //END Collect statistists on Poisson variables
	
	free(p_numbPoisson); //free pointer for Poisson variables
    return (0);
}
//END Main

//START Function definitions

//Poisson function -- returns pointer for Poisson variables
void funPoissonMany(int *p_output, int n_output, double lambda)
{
    double *p_uu = (double *)malloc(sizeof(double)); //pointer for Poisson variable (array)
    double exp_lambda = exp(-lambda); //constant for terminating loop
    double randUni;                   //uniform variable
    double prodUni;                   //product of uniform variables

    //loop through for all  random variables to be generated
    for (int i = 0; i < n_output; i++)
    {		
        //initialize variables
        *(p_output + i) = -1; //decrease pointer
        prodUni = 1; //product of uniform variables
        do
        {
            funUniformMany(p_uu, 1); //generate uniform variable
            randUni = *p_uu;
            prodUni = prodUni * randUni; //update product
            (*(p_output + i))++;         // increase Poisson variable

        } while (prodUni > exp_lambda); 
    }
	free(p_uu); //free pointer for uniform variables
}

//Uniform function -- returns pointer for standard uniform random variables
void funUniformMany(double *p_output, int n_output)
{
    for (int i = 0; i < n_output; i++)
    {
        *(p_output + i) = (double)rand() / (double)((unsigned)RAND_MAX + 1); //generate random variables on (0,1)
    }
}

//END  Function definitions

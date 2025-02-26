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
double funUniformSingle();           //generate uniform random variables on (0,1)
int funPoissonSingle(double lambda); //generate Poisson variables with parameter (ie mean) lambda

//START Main
int main()
{
    time_t s; //use CPU time for seed
    //intializes random number generator
    srand((unsigned)time(&s));

    double lambda = 8.7; //lambda is the Poisson parameter (that is, its mean)

    int numbSim = 100; // number of variables

    //START Collect statistists on Poisson variables
    //initialize statistics
    int numbPoissonTemp;
    double sumPoisson = 0;
    double sumPoissonSquared = 0;

    //loop through for each random variable
    for (int i = 0; i < numbSim; i++)
    {
        //generate a single poisson variable
        numbPoissonTemp = funPoissonSingle(lambda);

        //total sum of variables
        sumPoisson += numbPoissonTemp;
        //total sum of squared variables
        sumPoissonSquared += numbPoissonTemp*numbPoissonTemp;

        if (i < 5)
        {
            //print the first 5 numbers
            printf("One of the Poisson variables has the value %d.\n", numbPoissonTemp);
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

    return (0);
}
//END Main

//START Function definitions
//Poisson function -- returns a single Poisson random variable
int funPoissonSingle(double lambda)
{
    double exp_lambda = exp(-lambda); //constant for terminating loop
    double randUni;                   //uniform variable
    double prodUni;                   //product of uniform variables
    int randPoisson; //Poisson variable

    //initialize variables
    randPoisson = -1; 
    prodUni = 1;          
    do
    {
        randUni = funUniformSingle(); //generate uniform variable
        prodUni = prodUni * randUni;  //update product
        randPoisson++;                //increase Poisson variable

    } while (prodUni > exp_lambda); 
    return randPoisson;
}

////Uniform function -- returns a standard uniform random variable
double funUniformSingle()
{
    double randUni;
    randUni = (double)rand() / (double)((unsigned)RAND_MAX + 1); //generate random variables on (0,1)
    return randUni;
}

//END  Function definitions

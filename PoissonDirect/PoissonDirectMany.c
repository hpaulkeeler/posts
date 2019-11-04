// Author: H. Paul Keeler, 2019.
// hpaulkeeler.com/


#include <stdio.h>
#include <stdlib.h>
#include <time.h> /* time */
#include <math.h>

//declare functions
void funUniformMany(double *p_output, int n_output);        //generate uniform random variables on (0,1)
void funPoissonMany(int *p_output, int n_output, double lambda); //generate Poisson variables with parameter (ie mean) lambda
// p_output is the pointer for the random variables/variates
// n_output is the number of random variables/variates to generate
// lambda is the Poisson parameter (that is, it's mean)

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
    funPoissonMany(p_numbPoisson, numbSim, lambda);                 //generate poisson variables
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
        sumPoissonSquared += pow(tempPoisson, 2);

        if (i < 5)        {
            printf("One of the Poisson variables has the value %d\n", (int)tempPoisson);
        }
    }

    //calculate statistics
    double meanPoisson = sumPoisson / ((double)numbSim);                             //need to cast before doing divisions
    double varPoisson = sumPoissonSquared / ((double)numbSim) - pow(meanPoisson, 2); //need to cast before doing divisions
    printf("The average of the Poisson variables is %f\n", meanPoisson);
    printf("The variance of the Poisson variables is %f\n", varPoisson);

    //END Collect statistists on Poisson variables

    return (0);
}
//END Main

//START Function definitions

//Poisson function -- returns pointer for Poisson variables
void funPoissonMany(int *p_output, int n_output, double lambda)
{
    double *p_uu = (double *)malloc(sizeof(double));
    double randExpTemp; //exponential variable
    double randUni;
    double sum_exp; //sum of exponential variable s

    //loop through for all  random variables to be generated
    for (int i = 0; i < n_output; i++)
    {

        *(p_output + i) = -1; //decrease pointer

        //initialize variables
        sum_exp = 0; //sum of exponential variable s
        do
        {
            (*(p_output + i))++;
            funUniformMany(p_uu, 1); //generate uniform variable
            randUni = *p_uu;
            randExpTemp = (-1 / lambda) * log(randUni); //generate exponential variable
            sum_exp = sum_exp + randExpTemp;            //add exponential variable to sum
            //generate exponential variable, add it to sum
            //sum_exp = sum_exp - 1 / lambda * log(*p_uu);
        } while (sum_exp < 1); //stop loop if sum exceeds one
    }
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
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

using System;
namespace Poisson

{
    class Poisson {
        static void Main () {
            double lambda = 8.7; // lambda is the Poisson parameter (that is, its mean)

            int numbSim = 100; //number of random variables

            //START Collect statistists on Poisson variables
            //initialize statistics
            int numbPoissonTemp;
            double sumPoisson = 0;
            double sumPoissonSquared = 0;

            RandomGenerator rand = new RandomGenerator ();

            //loop through for each random variable
            for (int i = 0; i < numbSim; i++) {

                //generate a single poisson variable
                numbPoissonTemp = rand.funPoissonSingle (lambda);

                //total sum of variables
                sumPoisson += numbPoissonTemp;
                //total sum of squared variables
                sumPoissonSquared += numbPoissonTemp*numbPoissonTemp;

                if (i < 5) {
                    //print the first 5 numbers
                    Console.WriteLine ("One of the Poisson variables has the value " + numbPoissonTemp + ".");
                }

            }

            //calculate statistics 
            double meanPoisson = sumPoisson / ((double) numbSim);
            double varPoisson = sumPoissonSquared / ((double) numbSim) - meanPoisson*meanPoisson;

            ///print statistics
            Console.WriteLine ("The average of the Poisson variables is " + meanPoisson + ".");
            Console.WriteLine ("The variance of the Poisson variables is " + varPoisson + ".");
            Console.WriteLine ("For Poisson random variables, the mean and variance will agree more and more as the number of simulations increases.");

            //END Collect statistists on Poisson variables

            // keep the console window open in debug mode.
            Console.WriteLine ("Press any key to exit.");
            Console.ReadKey ();

        }

    }

}

//class for generating random numbers    
public class RandomGenerator {
    //create randoom number generator
    Random random = new Random ();

    //START Function definitions
    //Poisson function -- returns a single Poisson random variable        
    public int funPoissonSingle (double lambda) {

        double exp_lambda = Math.Exp (-lambda); //constant for terminating loop
        double randUni; //uniform variable
        double prodUni; //product of uniform variables
	int randPoisson; //Poisson variable

        //initialize variables
        randPoisson = -1;
        prodUni = 1;
        do {
            randUni = funUniformSingle (); //generate uniform variable
            prodUni = prodUni * randUni; //update product
            randPoisson++; // increase Poisson variable

        } while (prodUni > exp_lambda); 

        return randPoisson;
    }

    //Uniform function -- returns a standard uniform random variable
    public double funUniformSingle () {

        return random.NextDouble ();
    }
}

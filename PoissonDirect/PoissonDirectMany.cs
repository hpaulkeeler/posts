// Author: H. Paul Keeler, 2019.
// github.com/hpaulkeeler
// hpaulkeeler.com/

using System;
namespace Poisson

{
    class Poisson {
        static void Main () {
            double lambda = 8.7; // lambda is the Poisson parameter (that is, it's mean)

            int numbSim = 100; //number of random variables

            //START Collect statistists on Poisson variables
            //initialize statistics
            int numbPoissonTemp;
            double sumPoisson = 0;
            double sumPoissonSquared = 0;
            int[] randPoisson= new int[numbSim];
            
            RandomGenerator rand = new RandomGenerator ();
            
            //generate a many poisson variables
            randPoisson=rand.funPoissonMany (lambda,numbSim);

            //loop through for each random variable
            for (int i = 0; i < numbSim; i++) {
                
                numbPoissonTemp =randPoisson[i];

                //total sum of variables
                sumPoisson += numbPoissonTemp;
                //total sum of squared variables
                sumPoissonSquared += Math.Pow (numbPoissonTemp, 2);

                if (i < 5) {
                    //print the first 5 numbers
                    Console.WriteLine ("One of the Poisson variables has the value " + numbPoissonTemp + ".");
                }

            }

            //calculate statistics 
            double meanPoisson = sumPoisson / ((double) numbSim);
            double varPoisson = sumPoissonSquared / ((double) numbSim) - Math.Pow (meanPoisson, 2);

			///print statistics
            Console.WriteLine ("The average of the Poisson variables is " + meanPoisson);
            Console.WriteLine ("The variance of the Poisson variables is " + varPoisson);
            Console.WriteLine ("For Poisson random variables, the mean and variance will more agree as the number of simuations increases.");

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
    public int[] funPoissonMany (double lambda, int n_input) {

        double[] randUni; //uniform variable
        double randExpTemp; //exponential variable		
        int[] randPoisson= new int[n_input];
        
        for (int i = 0; i < n_input; i++) {
            //initialize variables
            double sum_exp = 0; //sum of exponential variables
            randPoisson[i]  = -1;
            do {
                randUni = funUniformMany (1); //generate uniform variable
                randExpTemp = -(1 / lambda) * Math.Log (randUni[0]); //exponential random variable
                sum_exp = sum_exp + randExpTemp; //add exponential variable to sum
                randPoisson[i]++; // increase Poisson variable
				
            } while (sum_exp < 1); //stop loop if sum exceeds one
        }

        return randPoisson;
    }

    //Uniform function -- returns standard uniform random variables
    public double[] funUniformMany (int n_input) {
        double[] randUni = new double[n_input];
        for (int i = 0; i < n_input; i++) {
            randUni[i]=random.NextDouble ();
        }
        return randUni;
    }
}
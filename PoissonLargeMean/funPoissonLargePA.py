# This code generates Poisson variates (or simulates Poisson variables).
# using a method designed for large (>30) Poisson parameter values.
#
# The generation method is Algorithm PA, a type of rejection method, from 
# the paper:
#
# 1979 - Atkinson - "The Computer Generation of Poisson Random Variables"
#
# In practice, you should *always* use the built-in NumPy function
# random.poisson, which (for large Poisson parameter) uses Algorithm PTRS in the
# paper:
#
# 1993 - Hörmann - "The transformed rejection method for generating Poisson
# random variables"
#
# That method is also suggested by Knuth in Volume 2 of his classic
# series "The Art of Computer Programming".
#
# INPUT:
# mu is a single Poisson parameter (or mean) such that mu>=0.
# OUTPUT:
# result_k is a single Poisson variate (that is, an instance of a Poisson random
# variable), which is a non-negative integer.
#
# Author: H. Paul Keeler, 2019.
# Website: hpaulkeeler.com
# Repository: github.com/hpaulkeeler/posts

import numpy as np;  # NumPy package for arrays, random number generation, etc
import scipy 
from getLogFac import getLogFac # type: ignore

def funPoissonLargePA(mu):
    #precalculate some Poisson-parameter-dependent numbers
    c = 0.767 - 3.36/mu;
    beta = np.pi/np.sqrt(3.0*mu);
    alpha = beta*mu;
    k = np.log(c) - mu - np.log(beta);
    log_mu=np.log(mu);

    result_n=-1; #initialize the Poisson random variable (or variate)
    while (result_n<0):
        U = np.random.uniform(0, 1, 1); #generate first uniform variable
        x = (alpha - np.log((1.0 - U)/U))/beta;

        if (x <-.5):
            continue
        else:
            V = np.random.uniform(0, 1, 1); #generate second uniform variable
            n = np.floor(x+.5);
            y = alpha - beta*x;
            #logfac_n=getLogFac(n); 
            #above can be replaced with scipy function: 
            logfac_n=scipy.special.gammaln(n+1)

            #two sides of an inequality condition
            lhs = y + np.log(V/(1.0 + np.exp(y))**2);
            rhs = k + n*log_mu- logfac_n; # NOTE: uses log factorial n

            if (lhs <= rhs):
                result_n=n;
                return result_n;
            else:
                continue;

            #end if-statement

        #end if-statement
    #end while-loop

#end function
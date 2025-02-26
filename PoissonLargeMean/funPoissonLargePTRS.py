# This code generates Poisson variates (or simulates Poisson variables).
# using a method designed for large (>10) Poisson parameter values.
#
# The generation method is Algorthm PTRS, a type of rejection method, from
# the paper:
#
# 1993 - Hörmann - "The transformed rejection method for generating Poisson
# random variables"
#
# WARNING: This code is for illustration purposes only.
#
# In practice, you should *always* use the buil-in MATLAB function
# poissrnd, which (for large Poisson parameter) uses Algorithm PG in the
# paper:
#
# 1974 - Ahrens, Dieter - "Computer methods for sampling from gamma, beta,
# poisson and bionomial distributions".
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

def funPoissonLargePTRS(mu):
    #precalculate some Poisson-parameter-dependent numbers
    b = 0.931 + 2.53 * np.sqrt(mu);
    a =  -0.059 + 0.02483 * b;
    vr = 0.9277 - 3.6224 / (b - 2);
    one_over_alpha=1.1239 + 1.1328/(b - 3.4);

    result_n=-1; #initialize the Poisson random variable (or variate)
    #Steps 1 to 3.1 in Algorithm PTRS
    while (result_n<0):
        #generate two uniform variables
        U = np.random.uniform(0, 1, 1); 
        V = np.random.uniform(0, 1, 1); 

        U=U-0.5;
        us = 0.5 -  abs(U);

        n=np.floor((2 * a / us + b) * U + mu + 0.43);

        if (us>=0.07)&(V<=vr):
            result_n = n;
            return result_n;
        #end if-statement

        if (n<=0) |((us < 0.013) & ( V> us)):
            continue
        #end if-statement

        log_mu = np.log(mu);
        #logfac_n=getLogFac(n); 
        #above can be replaced with SciPy's function: 
        logfac_n = scipy.special.gammaln(n+1);

        #two sides of an inequality condition
        lhs = np.log(V * one_over_alpha / (a/us/us + b));
        rhs = -mu + n * log_mu - logfac_n ;# NOTE: uses log factorial n

        if lhs <= rhs:
            result_n = n;
            return result_n;
        else:
            continue
        #end if-statement


    #end while-loop

#end function
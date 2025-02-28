# Author: H. Paul Keeler, 2019.
# Website: hpaulkeeler.com
# Repository: github.com/hpaulkeeler/posts

import numpy as np;  # NumPy package for arrays, random number generation, etc
import scipy 

#helper function
def getLogFac(k):
    logfac_k=scipy.special.gammaln(k+1); #can be replaced with the method below

    # # NOTE if no function for calculating log of factorials exist, use
    # # approximation below.

    # #pre-calculated logfac_k values for k=0 to 10
    # values_logfac=np.array([0,0,0.693147180559945,1.791759469228055,3.178053830347946,\
    #     4.787491742782046,6.579251212010101,8.525161361065415,10.604602902745251,\
    #     12.801827480081469,15.104412573075516]);
    
    # if (k<=10):        
    #     logfac_k=values_logfac[int(k[0])]; 
    # else:    
    #     logfac_k = np.log(np.sqrt(2 * np.pi))+(k + 0.5)* np.log(k) -k + (1/12 - 1/(360 * k**2))/k;    
    # #end if-statement
    
    return logfac_k

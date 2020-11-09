# Author: H. Paul Keeler, 2019.
# Website: hpaulkeeler.com
# Repository: github.com/hpaulkeeler/posts
#
# This program simulates Poisson random variables based 
# on the direct method of using exponential inter-arrival times. 
# For more details, see the post:
# hpaulkeeler.com/simulating-poisson-random-variables-direct-method/
#
# WARNING: This program is only suitable for small Poisson parameter (mu) 
# values, for example, mu<20. 
# This program is intended as an illustration. Python (NumPy) has its own in-built 
# function numpy.random.poisson, which is much faster. Use it -- not this function.

import numpy as np;  # NumPy package for arrays, random number generation, etc

mu=5; #Poisson parameter
numbSim=10**2; #number of simulations

muVector=mu*np.ones(numbSim);

### START - Function definitions ###

#Use while loop to generate Poisson variates
def funPoissonLoop(mu):
    T=0; #initialize sum of exponential variables as zero
    n=-1;#initialize counting variable as negative one
    
    while (T<1):
        E=-(1/mu)*np.log(np.random.rand(1));#generate exponential random variable
        T=T+E; #update sum of exponential variables
        n=n+1; #update number of exponential variables
    
    N=n;
    return N;

#Use recursion to generate Poisson variates
#WARNING: Might be slow or use up too much memory
def funPoissonRecursive(mu):
    T=0; #initialize sum of exponential variables as zero
    n=-1; #initialize counting variable as negative one    
    
    def funStepExp(nu,S,m):
        if S<1:
            #run if sum of exponential variables is not high enough
            
            #generate exponential random variable
            E=(-np.log(np.random.rand(1)))/nu;
            S=S+E; #update sum of exponential variables
            m=m+1; #update nunber of exponential variables
            
            #recursively call function again
            [T,N]=funStepExp(nu,S,m);
        else:
            T=S;
            N=m;
        return T,N;
    #run (recursive) exponential function step function
    _,N=funStepExp(mu,T,n);
    
    return N;

### END - Function definitions ###

#generate many Poisson variables
randPoissonLoop=np.array(list(map(lambda x: funPoissonLoop(x), muVector)));
randPoissonRecursive=np.array(list(map(lambda x: funPoissonRecursive(x), muVector)));

#calculate sample mean
meanPoissonLoop=np.mean(randPoissonLoop)
print('meanPoissonLoop = ',meanPoissonLoop)
meanPoissonRecursive=np.mean(randPoissonRecursive)
print('meanPoissonRecursive = ',meanPoissonRecursive)

#calculate sample variance
varPoissonLoop=np.var(randPoissonLoop)
print('varPoissonLoop = ',varPoissonLoop)
varPoissonRecursive=np.var(randPoissonRecursive)
print('varPoissonRecursive = ',varPoissonRecursive)
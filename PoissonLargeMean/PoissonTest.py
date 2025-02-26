# This code runs a Poisson variable generating function and then performs a
# chi-squared test to see whethe the function generated sufficently Poisson
# values.
#
# Author: H. Paul Keeler, 2019.
# Website: hpaulkeeler.com
# Repository: github.com/hpaulkeeler/posts

import numpy as np;  # NumPy package for arrays, random number generation, etc
import matplotlib.pyplot as plt  # for plotting
import scipy 
from funPlotPoissonEmpPDF import funPlotPoissonEmpPDF # type: ignore
from funPoissonLargePA import funPoissonLargePA # type: ignore
from funPoissonLargePTRS import funPoissonLargePTRS # type: ignore

plt.close("all");  # close all previous plots

mu=30; #Poisson parameter (ie its mean)
boolePlotResults= True;

numbSim=10**6; #number of samples/simulations

#sample using given Poisson function
X=np.zeros((numbSim,1));
for ss in range(numbSim):
    X[ss]=funPoissonLargePTRS(mu);
#end for-loop
Y=np.random.poisson(mu, numbSim); #sample using built-in Poisson function

#plot results
if boolePlotResults:
    funPlotPoissonEmpPDF(X); 
#end if-statement

meanX=np.mean(X); #unbiased mean
varX=np.var(X); #unbiased variance
ratioMeanVarX=meanX/varX; #a Poisson distribution implies value of one

print("The mean of X is " + str(meanX) +".");
print("The variance of X is " + str(varX) +".");

# do histogram to get empirical probability mass function
binsX=np.arange(np.min(X),np.max(X)+1);
numbBinsX=binsX.size;
countsObserved,_=np.histogram(X,numbBinsX, density=False);
countsExpected=scipy.stats.poisson.pmf(binsX,meanX); #use sample mean
#rescale so countsExpected and countsObserved have the same total sum
countsExpected=countsExpected/np.sum(countsExpected)*np.sum(countsObserved); 

#perform chi-squared test
resultsChiSquare=scipy.stats.chisquare(f_obs=countsObserved,f_exp=countsExpected,ddof =1);
pValueTest=0.05;
booleChiSquaredTest= (resultsChiSquare.pvalue<pValueTest);

print("The null hypothesis is that the data came from a Poisson distribution with mean of X.");
if booleChiSquaredTest:
    print("The chi-squared test rejected the null hypothesis.");
    print("Perhaps the data came from different distributions.")
else:
    print('The chi-squared test did not reject the null hypothesis.');
    print("Perhaps the data came from the same distribution.");
#end if statement
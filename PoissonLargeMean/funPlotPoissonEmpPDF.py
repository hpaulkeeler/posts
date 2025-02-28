#
# Author: H. Paul Keeler, 2019.
# Website: hpaulkeeler.com
# Repository: github.com/hpaulkeeler/posts

import numpy as np;  # NumPy package for arrays, random number generation, etc
import matplotlib.pyplot as plt  # for plotting
import scipy 

#helper function for plotting histogram of possibly Poisson data
def funPlotPoissonEmpPDF(X):
    meanEmp=np.mean(X); #(unbiased) empirical mean of X
    varEmp=np.var(X); #(unbiased) empirical variance of X

    #do histogram to get empirical probability mass function
    binEdges=np.arange(np.min(X),np.max(X+1))-0.5;
    pmfEmp, _=np.histogram(X,bins=binEdges, density=True);


    nValues=np.arange(np.min(X),np.max(X)); # histogram range
    #analytic solution of probability mass function
    pmfExact=scipy.stats.poisson.pmf(nValues,meanEmp);


    # plotting
    plt.scatter(nValues, pmfExact, color='b', marker='s', facecolor='none', label='Exact');
    plt.scatter(nValues, pmfEmp, color='r', marker='+', label='Empirical');
    plt.autoscale(enable=True, axis='y', tight=True)
    plt.xlabel('n');
    plt.ylabel('P(N=n)');
    plt.title('Probability mass functions');
    plt.legend();
    plt.show();
    
    return meanEmp, varEmp, pmfEmp

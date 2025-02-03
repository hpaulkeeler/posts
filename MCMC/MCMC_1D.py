# Runs a simple Metropolis-Hastings (ie MCMC) algoritm to simulate an
# exponential distribution, which has the probability density
# p(x)=exp(-x/m), where m>0.
#
# Author: H. Paul Keeler, 2019.
# Website: hpaulkeeler.com
# Repository: github.com/hpaulkeeler/posts

import numpy as np;  # NumPy package for arrays, random number generation, etc
import matplotlib.pyplot as plt  # For plotting

plt.close('all');  # close all figures

numbSim = 10 ** 4;  # number of random variables simulated
numbSteps = 25;  # number of steps for the Markov process
numbBins = 50;  # number of bins for histogram

sigma = 1;  # standard deviation for normal random steps
m = 2;  # parameter (ie mean) for distribution to be simulated


def fun_p(x):
    return (np.exp(-x / m) / m) * (x >= 0);  # intensity function


xRand = np.random.uniform(0, 1, numbSim);  # random initial values
pdfCurrent = fun_p(xRand);  # current transition (probability) densities

for jj in range(numbSteps):
    zRand = xRand + sigma * np.random.normal(0, 1, numbSim);  # take a (normally distributed) random step
    # zRand= xRand +2*sigma*np.random.uniform(0,1,simNumb);#take a (uniformly distributed) random step
    pdfProposal = fun_p(zRand);  # proposed probability

    # acceptance rejection step
    booleAccept = np.random.uniform(0, 1, numbSim) < pdfProposal / pdfCurrent;
    # update state of random walk/Markov chain
    xRand[booleAccept] = zRand[booleAccept];
    # update transition (probability) densities
    pdfCurrent[booleAccept] = pdfProposal[booleAccept];

# histogram section: empirical probability density
pdfEmp, binEdges = np.histogram(xRand, bins=numbBins, density=bool);
xValues = (binEdges[1:] + binEdges[:-1]) / 2;  # mid-points of bins

# analytic solution of probability density
pdfExact = fun_p(xValues);

# Plotting
plt.plot(xValues, pdfExact)
plt.scatter(xValues, pdfEmp, marker='x', c='r');
plt.grid(True);
plt.xlabel('x');
plt.ylabel('p(x)');
plt.show();

# Runs a simple Metropolis-Hastings (ie MCMC) algorithm to simulate two
# jointly distributed random variables with probability density
# p(x,y)=exp(-(x^4+x*y+y^2)/s^2)/consNorm, where s>0 and consNorm is a
# normalization constant.
#
# Author: H. Paul Keeler, 2019.
# Website: hpaulkeeler.com
# Repository: github.com/hpaulkeeler/posts

import numpy as np;  # NumPy package for arrays, random number generation, etc
import matplotlib.pyplot as plt  # for plotting
from matplotlib import cm  # for heatmap plotting
from mpl_toolkits import mplot3d  # for 3-D plots
from scipy import integrate  # for integrating

plt.close("all");  # close all previous plots

# Simulation window parameters
xMin = -1;
xMax = 1;
yMin = -1;
yMax = 1;

numbSim = 10 ** 4;  # number of random variables simulated
numbSteps = 200;  # number of steps for the Markov process
numbBins = 50;  # number of bins for histogram
sigma = 2;  # standard deviation for normal random steps

# probability density parameters
s = .5;  # scale parameter for distribution to be simulated

def fun_lambda(x, y):
    return np.exp(-(x ** 4 + x*y + y ** 2) / s ** 2);

# normalization constant
consNorm = integrate.dblquad(fun_lambda, xMin, xMax, lambda x: yMin, lambda y: yMax)[0];
#un-normalized joint density of variables to be simulated
def fun_p(x, y):
    return (fun_lambda(x, y) ) * (x >= xMin) * (y >= yMin) * (x <= xMax) * (y <= yMax);

xRand = np.random.uniform(xMin, xMax, numbSim);  # random initial values
yRand = np.random.uniform(yMin, yMax, numbSim);  # random initial values

pdfCurrent = fun_p(xRand, yRand);  # current transition (probability) densities

for jj in range(numbSteps):
    zxRand = xRand + sigma * np.random.normal(0, 1, numbSim);  # take a (normally distributed) random step
    zyRand = yRand + sigma * np.random.normal(0, 1, numbSim);  # take a (normally distributed) random step
    # Conditional random step needs to be symmetric in x and y
    # For example: Z|x ~ N(x,1) (or Y=x+N(0,1)) with probability density
    # p(z|x)=e(-(z-x)^2/2)/sqrt(2*pi)
    pdfProposal = fun_p(zxRand, zyRand);  # proposed probability

    # acceptance rejection step
    booleAccept = np.random.uniform(0, 1, numbSim) < pdfProposal / pdfCurrent;
    # update state of random walk/Markov chain
    xRand[booleAccept] = zxRand[booleAccept];
    yRand[booleAccept] = zyRand[booleAccept];
    # update transition (probability) densities
    pdfCurrent[booleAccept] = pdfProposal[booleAccept];

# for histogram, need to reshape as vectors
xRand = np.reshape(xRand, numbSim);
yRand = np.reshape(yRand, numbSim);

p_Estimate, xxEdges, yyEdges = np.histogram2d(xRand, yRand, bins=numbSteps, density=True);
xValues = (xxEdges[1:] + xxEdges[0:xxEdges.size - 1]) / 2;  # mid-points of bins
yValues = (yyEdges[1:] + yyEdges[0:yyEdges.size - 1]) / 2;  # mid-points of bins
X, Y = np.meshgrid(xValues, yValues);  # create x/y matrices for plotting

# analytic solution of (normalized) joint probability density
p_Exact = fun_p(X, Y) / consNorm;

# Plotting
# Plot empirical estimate
fig1 = plt.figure();
ax = plt.axes(projection="3d");
#plt.rc("text", usetex=True);
#plt.rc("font", family="serif");
surf = ax.plot_surface(X, Y, p_Estimate, cmap=plt.cm.plasma);
plt.xlabel("x");
plt.ylabel("y");
plt.title("p(x,y) Estimate");

# Plot exact expression
fig2 = plt.figure();
#plt.rc("text", usetex=True);
#plt.rc("font", family="serif")
ax = plt.axes(projection="3d");
surf = ax.plot_surface(X, Y, p_Exact, cmap=plt.cm.plasma);
plt.xlabel("x");
plt.ylabel("y");
plt.title("p(x,y) Exact Expression");

meanX = np.mean(xRand);
meanY = np.mean(yRand);
stdX = np.std(xRand);
stdY = np.std(yRand);


print("The average of the X random variables is " + str(meanX)+".\n");
print("The average of the Y random variables is " + str(meanY)+".\n");
print("The standard deviation of the X random variables is " + str(stdX)+".\n");
print("The standard deviation of the Y random variables is " + str(stdY)+".\n");


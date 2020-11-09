# Simulate an inhomogeneous Poisson point process on a rectangle
# This is done by simulating a homogeneous Poisson process, which is
# then thinned according to a (spatially *dependent*) p-thinning.
# The intensity function is
# lambda(x,y)=80*exp(-(x^2+y^2)/s^2)+100*exp(-(x^2+y^2)/s^2), where s>0.
# The simulations are then checked by examining the statistics of the number of
# points and the locations of points (using histograms)
# Author: H. Paul Keeler, 2019.
# Website: hpaulkeeler.com
# Repository: github.com/hpaulkeeler/posts
# For more details, see the post:
# https://hpaulkeeler.com/checking-poisson-point-process-simulations/

import numpy as np;  # NumPy package for arrays, random number generation, etc
import matplotlib.pyplot as plt  # for plotting
from matplotlib import cm  # for heatmap plotting
from mpl_toolkits import mplot3d  # for 3-D plots
from scipy.optimize import minimize  # for optimizing
from scipy import integrate  # for integrating
from scipy.stats import poisson  # for the Poisson probability mass function

plt.close('all');  # close all plots

# Simulation window parameters
xMin = -1;
xMax = 1;
yMin = -1;
yMax = 1;
xDelta = xMax - xMin;
yDelta = yMax - yMin;  # rectangle dimensions
areaTotal = xDelta * yDelta;

numbSim = 10 ** 4;  # number of simulations
numbBins = 30;  # number of bins for histogram

# Point process parameters
s = 0.5;  # scale parameter


def fun_lambda(x, y):
    # intensity function
    lambdaValue = 80 * np.exp(-((x + 0.5) ** 2 + (y + 0.5) ** 2) / s ** 2) + 100 * np.exp(
        -((x - 0.5) ** 2 + (y - 0.5) ** 2) / s ** 2);
    return lambdaValue;


###START -- find maximum lambda -- START ###
# For an intensity function lambda, given by function fun_lambda,
# finds the maximum of lambda in a rectangular region given by
# [xMin,xMax,yMin,yMax].
def fun_Neg(x):
    return -fun_lambda(x[0], x[1]);  # negative of lambda


xy0 = [(xMin + xMax) / 2, (yMin + yMax) / 2];  # initial value(ie centre)
# Find largest lambda value
resultsOpt = minimize(fun_Neg, xy0, bounds=((xMin, xMax), (yMin, yMax)));
lambdaNegMin = resultsOpt.fun;  # retrieve minimum value found by minimize
lambdaMax = -lambdaNegMin;


###END -- find maximum lambda -- END ###

# define thinning probability function
def fun_p(x, y):
    return fun_lambda(x, y) / lambdaMax;


# for collecting statistics -- set numbSim=1 for one simulation
numbPointsRetained = np.zeros(numbSim);  # vector to record number of points
xxAll = [];
yyAll = [];

### START -- Simulation section -- START ###
for ii in range(numbSim):
    # Simulate a Poisson point process
    numbPoints = np.random.poisson(lambdaMax * areaTotal);  # Poisson number of points
    xx = xDelta * np.random.uniform(0, 1, numbPoints) + xMin;  # x coordinates of Poisson points
    yy = yDelta * np.random.uniform(0, 1, numbPoints) + yMin;  # y coordinates of Poisson points

    # calculate spatially-dependent thinning probabilities
    p = fun_p(xx, yy);

    # Generate Bernoulli variables (ie coin flips) for thinning
    booleRetained = np.random.uniform(0, 1, numbPoints) < p;  # points to be thinned

    # x/y locations of retained points
    xxRetained = xx[booleRetained];
    yyRetained = yy[booleRetained];
    numbPointsRetained[ii] = xxRetained.size;
    xxAll.extend(xxRetained);
    yyAll.extend(yyRetained);
### END -- Simulation section -- END ###

# Plotting a simulation
fig1 = plt.figure();
plt.scatter(xxRetained, yyRetained, edgecolor='b', facecolor='none');
plt.xlabel('x');
plt.ylabel('y');
plt.title('A single realization of a Poisson point process');
plt.show();

# run empirical test on number of points generated
###START -- Checking number of points -- START###
# total mean measure (average number of points)
LambdaNumerical = integrate.dblquad(fun_lambda, xMin, xMax, lambda x: yMin, lambda y: yMax)[0];
# Test: as numbSim increases, numbPointsMean converges to LambdaNumerical
numbPointsMean = np.mean(numbPointsRetained);
# Test: as numbSim increases, numbPointsVar converges to LambdaNumerical
numbPointsVar = np.var(numbPointsRetained);
binEdges = np.arange(numbPointsRetained.min(), (numbPointsRetained.max() + 1)) - 0.5;
pdfEmp, binEdges = np.histogram(numbPointsRetained, bins=binEdges, density=True);

nValues = np.arange(numbPointsRetained.min(), numbPointsRetained.max());
# analytic solution of probability density
pdfExact = (poisson.pmf(nValues, LambdaNumerical));

# Plotting
fig2 = plt.figure();
plt.scatter(nValues, pdfExact, color='b', marker='s', facecolor='none', label='Exact');
plt.scatter(nValues, pdfEmp, color='r', marker='+', label='Empirical');
plt.autoscale(enable=True, axis='y', tight=True)
plt.xlabel('n');
plt.ylabel('P(N=n)');
plt.title('Distribution of the number of points');
plt.legend();
plt.show();
###END -- Checking number of points -- END###

###START -- Checking locations -- START###
# 2-D Histogram section
p_Estimate, xxEdges, yyEdges = np.histogram2d(xxAll, yyAll, bins=numbBins, density=True);
lambda_Estimate = p_Estimate * numbPointsMean;

xxValues = (xxEdges[1:] + xxEdges[0:xxEdges.size - 1]) / 2;
yyValues = (yyEdges[1:] + yyEdges[0:yyEdges.size - 1]) / 2;
X, Y = np.meshgrid(xxValues, yyValues)  # create x/y matrices for plotting

# analytic solution of probability density
lambda_Exact = fun_lambda(X, Y);

# Plot empirical estimate
fig3 = plt.figure();
plt.rc('text', usetex=True);
plt.rc('font', family='serif');
ax = plt.subplot(211, projection='3d');
surf = ax.plot_surface(X, Y, lambda_Estimate, cmap=plt.cm.plasma);
plt.xlabel('x');
plt.ylabel('y');
plt.title('Estimate of $\lambda(x)$');
plt.locator_params(axis='x', nbins=3);
plt.locator_params(axis='y', nbins=3);
plt.locator_params(axis='z', nbins=3);
# Plot exact expression
ax = plt.subplot(212, projection='3d');
surf = ax.plot_surface(X, Y, lambda_Exact, cmap=plt.cm.plasma);
plt.xlabel('x');
plt.ylabel('y');
plt.title('True $\lambda(x)$');
plt.locator_params(axis='x', nbins=3);
plt.locator_params(axis='y', nbins=3);
plt.locator_params(axis='z', nbins=3);
###END -- Checking locations -- END###

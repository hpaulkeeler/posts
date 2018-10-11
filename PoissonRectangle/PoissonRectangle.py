#Simulate a Poisson point process on a rectangle
#Author: H. Paul Keeler, 2018.

import numpy as np
import scipy.stats
import matplotlib.pyplot as plt

#Simulation window parameters
xMin=0;xMax=1;
yMin=0;yMax=1;
xDelta=xMax-xMin;yDelta=yMax-yMin; #rectangle dimensions
areaTotal=xDelta*yDelta;

#Point process parameters
lambda0=100; #intensity (ie mean density) of the Poisson process

#Simulate a Poisson point process
numbPoints = scipy.stats.poisson(lambda0*areaTotal).rvs();#Poisson number of points
xx = scipy.stats.uniform.rvs(0,xDelta,((numbPoints,1)))+xMin;#x coordinates of Poisson points
yy = scipy.stats.uniform.rvs(0,yDelta,((numbPoints,1)))+yMin;#y coordinates of Poisson points

#Plotting
plt.scatter(xx,yy, edgecolor='b', facecolor='none', alpha=0.5 );
plt.xlabel("x"); plt.ylabel("y");


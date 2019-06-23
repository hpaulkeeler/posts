#Simulate a Poisson point process on a rectangle
#Then thin the Poisson point process according to a (spatially *dependent*) 
#p-thinning 
#Author: H. Paul Keeler, 2019.

import numpy as np; #NumPy package for arrays, random number generation, etc
import matplotlib.pyplot as plt #For plotting

plt.close("all"); # close all figures

#Simulation window parameters
xMin=-1;xMax=1;
yMin=-1;yMax=1;
xDelta=xMax-xMin;yDelta=yMax-yMin; #rectangle dimensions
areaTotal=xDelta*yDelta;

#Point process parameters
lambda0=100; #intensity (ie mean density) of the Poisson process

#Thinning probability parameters
sigma=0.5; #scale parameter for thinning probability function
#define thinning probability function
def fun_p(s, x, y):
    return np.exp(-(x**2+y**2)/s**2);    

#Simulate a Poisson point process
numbPoints = np.random.poisson(lambda0*areaTotal);#Poisson number of points
xx = np.random.uniform(0,xDelta,numbPoints)+xMin;#x coordinates of Poisson points
yy = np.random.uniform(0,yDelta,numbPoints)+yMin;#y coordinates of Poisson points

#calculate spatially-dependent thinning probabilities
p=fun_p(sigma,xx,yy); 

#Generate Bernoulli variables (ie coin flips) for thinning
booleThinned=np.random.uniform(0,1,numbPoints)<p; #points to be thinned
booleRetained=~booleThinned; #points to be retained

#x/y locations of thinned points
xxThinned=xx[booleThinned]; yyThinned=yy[booleThinned];
#x/y locations of retained points
xxRetained=xx[booleRetained]; yyRetained=yy[booleRetained];

#Plotting
plt.scatter(xxRetained,yyRetained, edgecolor='b', facecolor='none', alpha=0.5 );
plt.scatter(xxThinned,yyThinned, edgecolor='r', facecolor='none', alpha=0.5 );
plt.xlabel("x"); plt.ylabel("y");
plt.show(); 
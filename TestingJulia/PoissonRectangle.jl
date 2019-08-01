#Simulate a Poisson point process on a rectangle
#Author: H. Paul Keeler, 2019.

#Note: Need the .+ for adding a scalar to an array
#Also need . for sqrt, exp, cos, sin etc and assigning scalars to arrays

using Distributions #for random simulations
using Plots #for plotting

#Simulation window parameters
xMin=0;xMax=1;
yMin=0;yMax=1;
xDelta=xMax-xMin;yDelta=yMax-yMin; #rectangle dimensions
areaTotal=xDelta*yDelta;

#Point process parameters
lambda=100; #intensity (ie mean density) of the Poisson process

#Simulate Poisson point process
numbPoints=rand(Poisson(areaTotal*lambda)); #Poisson number of points
xx=xDelta*rand(numbPoints,1).+xMin;#x coordinates of Poisson points
yy=yDelta*(rand(numbPoints,1)).+yMin;#y coordinates of Poisson points

#Plotting
plot1=scatter(xx, yy, xlabel ="x",ylabel ="y",leg = false);
display(plot1);

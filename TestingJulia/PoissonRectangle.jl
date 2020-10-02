# Simulate a Poisson point process on a rectangle
# Author: H. Paul Keeler, 2019.
# Website: hpaulkeeler.com
# Repository: github.com/hpaulkeeler/posts

#Note: Need the .+ for adding a scalar to an array
#Also need . for sqrt, exp, cos, sin etc and assigning scalars to arrays
#Best to use vectors instead of 1-D matrices eg x=rand(n),  NOT x=rand(n,1).

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
xx=xDelta*rand(numbPoints).+xMin;#x coordinates of Poisson points
yy=yDelta*(rand(numbPoints)).+yMin;#y coordinates of Poisson points

#Plotting
plot1=scatter(xx, yy, xlabel ="x",ylabel ="y",leg = false);
display(plot1);

#Simulate a Thomas cluster point process on a rectangle
#Author: H. Paul Keeler, 2019.

#Note: Need the .+ for adding a scalar to an array
#Also need . for sqrt, exp, cos, sin etc and assinging scalars to arrays

using Distributions #for random simulations
using Plots #for plotting

#Simulation window parameters
xMin=-.5;xMax=.5;
yMin=-.5;yMax=.5;
xDelta=xMax-xMin;yDelta=yMax-yMin; #rectangle dimensions
areaTotal=xDelta*yDelta; #area of rectangle

#Parameters for the parent and daughter point processes
lambdaParent=10;#density of parent Poisson point process
lambdaDaughter=10;#mean number of points in each cluster
sigma=0.1; #sigma for normal variables (ie random locations) of daughters

#Simulate Poisson point process
numbPointsParent=rand(Poisson(areaTotal*lambdaParent)); #Poisson number of points

#x and y coordinates of Poisson points for the parent
xxParent=xDelta*rand(numbPointsParent,1).+xMin;
yyParent=yDelta*(rand(numbPointsParent,1)).+yMin;

#Simulate Poisson point process for the daughters (ie final poiint process)
numbPointsDaughter=rand(Poisson(lambdaDaughter),numbPointsParent);
numbPoints=sum(numbPointsDaughter); #total number of points

#Generate the (relative) locations in Cartesian coordinates by
#simulating independent normal variables
xx0=rand(Normal(0,sigma),numbPoints);
yy0=rand(Normal(0,sigma),numbPoints);

#replicate parent points (ie centres of disks/clusters)
xx=vcat(fill.(xxParent, numbPointsDaughter)...);
yy=vcat(fill.(yyParent, numbPointsDaughter)...);

#Shift centre of disk to (xx0,yy0)
xx=xx.+xx0;
yy=yy.+yy0;

#Plotting
plot1=scatter(xx,yy,xlabel ="x",ylabel ="y", leg=false);
display(plot1);

#Simulate a Thomas cluster point process on a rectangle
#Author: H. Paul Keeler, 2019.

#Note: Need the .+ for adding a scalar to an array
#Also need . for sqrt, exp, cos, sin etc and assinging scalars to arrays

using Distributions #for random simulations
using Plots #for plotting

#Simulation window parameters
xMin=-.5;
xMax=.5;
yMin=-.5;
yMax=.5;

#Parameters for the parent and daughter point processes
lambdaParent=10;#density of parent Poisson point process
lambdaDaughter=10;#mean number of points in each cluster
sigma=0.05; #sigma for normal variables (ie random locations) of daughters

#Extended simulation windows parameters
rExt=7*sigma; #extension parameter
#for rExt, use factor of deviation sigma eg 6 or 7
xMinExt=xMin-rExt;
xMaxExt=xMax+rExt;
yMinExt=yMin-rExt;
yMaxExt=yMax+rExt;
#rectangle dimensions
xDeltaExt=xMaxExt-xMinExt;
yDeltaExt=yMaxExt-yMinExt;
areaTotalExt=xDeltaExt*yDeltaExt; #area of extended rectangle

#Simulate Poisson point process
numbPointsParent=rand(Poisson(areaTotalExt*lambdaParent)); #Poisson number of points

#x and y coordinates of Poisson points for the parent
xxParent=xMinExt.+xDeltaExt*rand(numbPointsParent,1);
yyParent=yMinExt.+yDeltaExt*rand(numbPointsParent,1);

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

#thin points if outside the simulation window
booleInside=((xx.>=xMin).&(xx.<=xMax).&(yy.>=yMin).&(yy.<=yMax));
#retain points inside simulation window
xx=xx[booleInside];
yy=yy[booleInside];

#Plotting
plot1=scatter(xx,yy,xlabel ="x",ylabel ="y", leg=false);
display(plot1);

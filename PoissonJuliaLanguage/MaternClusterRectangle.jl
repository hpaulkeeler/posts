#Simulate a Matern cluster point process on a rectangle
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
radiusCluster=0.1;#radius of cluster disk (for daughter points)

#Simulate Poisson point process
numbPointsParent=rand(Poisson(areaTotal*lambdaParent)); #Poisson number of points

#x and y coordinates of Poisson points for the parent
xxParent=xDelta*rand(numbPointsParent,1).+xMin;
yyParent=yDelta*(rand(numbPointsParent,1)).+yMin;

#Simulate Poisson point process for the daughters (ie final poiint process)
numbPointsDaughter=rand(Poisson(lambdaDaughter),numbPointsParent);
numbPoints=sum(numbPointsDaughter); #total number of points

#Generate the (relative) locations in polar coordinates by
#simulating independent variables.
theta=2*pi*rand(numbPoints); #angular coordinates
rho=radiusCluster*sqrt.(rand(numbPoints)); #radial coordinates

#Convert polar to Cartesian coordinates
xx0=rho.*cos.(theta);
yy0=rho.*sin.(theta);

##START -- replicate parent points (ie centres of disks/clusters) -- START
#create xx/yy start/finish indices for each value in xxParent
indexLast=(cumsum(numbPointsDaughter));
indexFirst=ones(size(indexLast));
indexFirst[2:end]=indexFirst[2:end]+indexLast[1:end-1];
#need to convert floats to integers for indices
indexFirst=floor.(Int,indexFirst);indexLast=floor.(Int,indexLast);
xx=zeros(numbPoints,1);yy=zeros(numbPoints,1); #initiate arrays
for ii=1:numbPointsParent
    #Note need .= for assignment
    xx[indexFirst[ii]:indexLast[ii]].=xxParent[ii];
    yy[indexFirst[ii]:indexLast[ii]].=yyParent[ii];
end
##END -- replicate parent points (ie centres of disks/clusters) -- END

#Shift centre of disk to (xx0,yy0)
xx=xx.+xx0;
yy=yy.+yy0;

#Plotting
plot1=scatter(xx,yy,xlabel ="x",ylabel ="y", leg=false);
display(plot1);

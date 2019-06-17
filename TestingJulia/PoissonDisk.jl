#Simulate a Poisson point process on a disk
#Author: H. Paul Keeler, 2019.

#Note: Need the .+ for adding a scalar to an array
#Also need . for sqrt, exp, cos, sin etc and assinging scalars to arrays

using Distributions #for random simulations
using Plots #for plotting

#Simulation window parameters
r=1; #radius of disk
xx0=0; yy0=0; #centre of disk
areaTotal=pi*r^2; #area of disk

#Point process parameters
lambda=100; #intensity (ie mean density) of the Poisson process

#Simulate Poisson point process
numbPoints=rand(Poisson(areaTotal*lambda)); #Poisson number of points
theta=2*pi*(rand(numbPoints,1));#angular  of Poisson points
rho=r*sqrt.(rand(numbPoints,1));#radial coordinates of Poisson points

#Convert polar to Cartesian coordinates
xx=rho.*cos.(theta);
yy=rho.*sin.(theta);

#Shift centre of disk to (xx0,yy0)
xx=xx.+xx0;
yy=yy.+yy0;

plot1=scatter(xx,yy,xlabel ="x",ylabel ="y", leg=false);
display(plot1);

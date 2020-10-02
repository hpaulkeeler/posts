# Simulate a Poisson point process on a triangle
# Author: H. Paul Keeler, 2019.
# Website: hpaulkeeler.com
# Repository: github.com/hpaulkeeler/posts

#Note: Need the .+ for adding a scalar to an array
#Also need . for sqrt, exp, cos, sin etc and assinging scalars to arrays
#Don't confuse 1.-V with 1 .-V for array V
#Best to use vectors instead of 1-D matrices eg x=rand(n),  NOT x=rand(n,1).

using Distributions #for random simulations
using Plots #for plotting

#Simulation window parameters -- points A,B,C of a triangle
xA=0;xB=1;xC=1; #x values of three points
yA=0;yB=0;yC=1; #y values of three points;

#Point process parameters
lambda=100; #ntensity (ie mean density) of the Poisson process

#calculate sides of trinagle
a=sqrt((xA-xB)^2+(yA-yB)^2);
b=sqrt((xB-xC)^2+(yB-yC)^2);
c=sqrt((xC-xA)^2+(yC-yA)^2);
s=(a+b+c)/2; #calculate semi-perimeter

#Use Herron's forumula to calculate area
areaTotal=sqrt(s*(s-a)*(s-b)*(s-c)); #area of triangle

#Simulate a Poisson point process
numbPoints=rand(Poisson(areaTotal*lambda)); #Poisson number of points
U=rand(numbPoints);#uniform random variables
V=rand(numbPoints);#uniform random variables

xx=sqrt.(U).*xA .+sqrt.(U).*(1 .-V).*xB .+sqrt.(U).*V.*xC;#x coordinates of points
yy=sqrt.(U).*yA .+sqrt.(U).*(1 .-V).*yB .+sqrt.(U).*V.*yC;#y coordinates of points

#Plotting
plot1=scatter(xx,yy,xlabel ="x",ylabel ="y", leg=false);
display(plot1);

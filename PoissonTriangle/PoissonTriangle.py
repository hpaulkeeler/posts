#Simulate a Poisson point process on a triangle.
#Author: H. Paul Keeler, 2018.

import numpy as np; #NumPy package for arrays, random number generation, etc
import matplotlib.pyplot as plt #for plotting

plt.close("all"); # close all figures

#Simulation window parameters -- points A,B,C of a triangle
xA=0;xB=1;xC=1; #x values of three points
yA=0;yB=0;yC=1; #y values of three points;

#Point process parameters
lambda0=100; #ntensity (ie mean density) of the Poisson process

#calculate sides of trinagle
a=np.sqrt((xA-xB)**2+(yA-yB)**2); 
b=np.sqrt((xB-xC)**2+(yB-yC)**2); 
c=np.sqrt((xC-xA)**2+(yC-yA)**2); 
s=(a+b+c)/2; #calculate semi-perimeter

#Use Herron's forumula to calculate area -- or use polyarea
areaTotal=np.sqrt(s*(s-a)*(s-b)*(s-c)); #area of triangle

#Simulate a Poisson point process
numbPoints = np.random.poisson(lambda0*areaTotal);#Poisson number of points
U = np.random.uniform(0,1,numbPoints);#uniform random variables
V= np.random.uniform(0,1,numbPoints);#uniform random variables

xx=np.sqrt(U)*xA+np.sqrt(U)*(1-V)*xB+np.sqrt(U)*V*xC;#x coordinates of points
yy=np.sqrt(U)*yA+np.sqrt(U)*(1-V)*yB+np.sqrt(U)*V*yC;#y coordinates of points

#Plotting
plt.scatter(xx,yy, edgecolor='b', facecolor='none', alpha=0.5 );
plt.xlabel("x"); plt.ylabel("y");
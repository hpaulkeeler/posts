#Simulate a Matern point process on a rectangle
#Author: H. Paul Keeler, 2018.

import numpy as np; #NumPy package for arrays, random number generation, etc
import matplotlib.pyplot as plt; 

#Simulation window parameters
xMin=-.5;xMax=.5;
yMin=-.5;yMax=.5;
xDelta=xMax-xMin;yDelta=yMax-yMin; #rectangle dimensions
areaTotal=xDelta*yDelta; #area of rectangle


#Parameters for the parent and daughter point processes 
lambdaParent=10;#density of parent Poisson point process
lambdaDaughter=100;#mean number of points in each cluster
radiusCluster=0.1;#radius of cluster disk (for daughter points)

#Simulate Poisson point process for the parents
numbPointsParent=np.random.poisson(areaTotal*lambdaParent);#Poisson number of points
#x and y coordinates of Poisson points for the parent
xxParent=xMin+xDelta*np.random.uniform(0,1,numbPointsParent);
yyParent=yMin+yDelta*np.random.uniform(0,1,numbPointsParent);

#Simulate Poisson point process for the daughters (ie final poiint process)
numbPointsDaughter=np.random.poisson(lambdaDaughter,numbPointsParent);
numbPoints=sum(numbPointsDaughter); #total number of points

#Generate the (relative) locations in polar coordinates by 
#simulating independent variables.
theta=2*np.pi*np.random.uniform(0,1,numbPoints); #angular coordinates 
rho=radiusCluster*np.sqrt(np.random.uniform(0,1,numbPoints)); #radial coordinates 

#Convert from polar to Cartesian coordinates
xx0 = rho * np.cos(theta);
yy0 = rho * np.sin(theta);

#replicate parent points (ie centres of disks/clusters)
xx=np.repeat(xxParent,numbPointsDaughter);
yy=np.repeat(yyParent,numbPointsDaughter);

#translate points (ie parents points are the centres of cluster disks)
xx=xx+xx0;
yy=yy+yy0;

#Plotting
plt.scatter(xx,yy, edgecolor='b', facecolor='none', alpha=0.5 );
plt.xlabel("x"); plt.ylabel("y");
plt.axis('equal');

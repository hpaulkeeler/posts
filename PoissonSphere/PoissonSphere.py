# Simulate a Poisson point process on a sphere.
# The Code can be modified to simulate the point  process *inside* the sphere; 
# see the post
# hpaulkeeler.com/simulating-a-poisson-point-process-on-a-sphere/
# Author: H. Paul Keeler, 2020.
# Website: hpaulkeeler.com
# Repository: github.com/hpaulkeeler/posts
# For more details, see the post:
# hpaulkeeler.com/simulating-a-poisson-point-process-on-a-sphere/

import numpy as np;  # NumPy package for arrays, random number generation, etc
import matplotlib.pyplot as plt  # for plotting
from numpy import linalg as la #linear algebra pack for norms
from mpl_toolkits import mplot3d

plt.close('all');  # close all figures

# Simulation window parameters
r = 1;  # radius of sphere
#centre of sphere
xx0 = 0;
yy0 = 0;  
zz0 =0; 

# Point process parameters
lambda0 = 10;  # intensity (ie mean density) of the Poisson process

measureTotal = 4*np.pi * r ** 2;  # area of sphere
#use this line instead to uniformly place points *inside* the sphere
#measureTotal = 4/3*np.pi * r ** 3;  # area of sphere


# Simulate Poisson point process
numbPoints = np.random.poisson(lambda0 * measureTotal);  # Poisson number of points

##METHOD 1 for positioning points: Use spherical coodinates
## angular variables
#theta = np.pi * np.random.uniform(0, 1, numbPoints);  # polar angles
#phi = 2 * np.pi * np.random.uniform(0, 1, numbPoints);  # azimuth angles
## radial variables
#rho = r * np.ones(numbPoints);  # radial distances (fixed radius)
##use this line instead to uniformly place points *inside* the sphere
##rho=r*(np.random.uniform(0, 1, numbPoints))**(1/3); 
#
## Convert from polar to Cartesian coordinates
#xx = rho * np.sin(theta) * np.cos(phi);
#yy = rho * np.sin(theta) * np.sin(phi);
#zz = rho * np.cos(theta)

#METHOD 2 for positioning points: Use normal random variables
xxRand=np.random.normal(0,1,size=(numbPoints,3)); #generate two sets of normal variables
normRand=la.norm(xxRand,2,1); #Euclidean norms
xxRandBall=xxRand/normRand[:,None]; #rescale by Euclidean norms
xxRandBall=r*xxRandBall; #rescale for non-unit sphere
#retrieve x and y coordinates
xx= xxRandBall[:,0];
yy= xxRandBall[:,1];
zz= xxRandBall[:,2];

# Shift centre of sphere to (xx0,yy0)
xx = xx + xx0;
yy = yy + yy0;
zz = zz + zz0;

## Plotting
fig = plt.figure()
ax = plt.axes(projection='3d')
ax.scatter3D(xx, yy,zz,color='b');
ax.set_xlabel('x')
ax.set_ylabel('y')
ax.set_zlabel('z')

#control ticks on x,y,z axes
plt.locator_params(axis='x', nbins=5);
plt.locator_params(axis='y', nbins=5);
plt.locator_params(axis='z', nbins=5);

#create mesh to plot the outline of a sphere
numbMesh=20;
thetaMesh, phiMesh = np.meshgrid(np.linspace(0,np.pi,numbMesh), np.linspace(0,2*np.pi,numbMesh))
#convert to Cartesian coordinates
xMesh = r * np.cos(thetaMesh)*np.sin(phiMesh)
yMesh  = r * np.sin(thetaMesh)*np.sin(phiMesh)
zMesh  = r * np.cos(phiMesh)
#Shift centre of sphere to (xx0,yy0,zz0)
xMesh=xMesh+xx0;
yMesh=yMesh+yy0;
zMesh=zMesh+zz0;
#do a surface plot with a clear faces (ie alpha=0)
ax.plot_surface(xMesh, yMesh, zMesh, edgecolor='k',alpha=0)
# Simulate a Poisson point process on a sphere.
# The Code can be modified to simulate the point  process *inside* the sphere; 
# see lines 27 and 34.

# Author: H. Paul Keeler, 2020.
# Website: hpaulkeeler.com
# Repository: github.com/hpaulkeeler/posts

import numpy as np;  # NumPy package for arrays, random number generation, etc
import matplotlib.pyplot as plt  # for plotting
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
# angular variables
theta = np.pi * np.random.uniform(0, 1, numbPoints);  # polar angles
phi = 2 * np.pi * np.random.uniform(0, 1, numbPoints);  # azimuth angles
# radial variables
rho = r * np.ones(numbPoints);  # radial distances (fixed radius)
#use this line instead to uniformly place points *inside* the sphere
#rho=r*(np.random.uniform(0, 1, numbPoints))**(1/3); 

# Convert from polar to Cartesian coordinates
xx = rho * np.sin(theta) * np.cos(phi);
yy = rho * np.sin(theta) * np.sin(phi);
zz = rho * np.cos(theta)

# Shift centre of sphere to (xx0,yy0)
xx = xx + xx0;
yy = yy + yy0;
zz = zz + zz0;

## Plotting
fig = plt.figure()
ax = plt.axes(projection='3d')
ax.scatter3D(xx, yy,zz,color='b');
plt.xlabel('x');
plt.ylabel('y');

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


# Simulate a Poisson point process on the surface of a n-dimensional
# ball (that is, a (n-1)-dimensional sphere).
# Author: H. Paul Keeler, 2020.
# Website: hpaulkeeler.com
# Repository: github.com/hpaulkeeler/posts

import numpy as np;  # NumPy package for arrays, random number generation, etc
from scipy.special import gamma, factorial #gamma function
from numpy import linalg as la #linear algebra pack
import matplotlib.pyplot as plt  # for plotting
from mpl_toolkits import mplot3d

plt.close('all');  # close all figures

numbDim=2; #number of dimensions of embedding (regular sphere numbDim=3)

r=1.7; #radius of sphere

#Point process parameters
lambda0=5; #intensity (ie mean density) of the Poisson process

#surface area of d-dimensional ball
areaTotal=2*np.pi**(numbDim/2)*r**(numbDim-1)/gamma(numbDim/2);

measureTotal=areaTotal*lambda0; #total measure

#Simulate Poisson point process
numbPoints=np.random.poisson(measureTotal);#Poisson number of points

xxRand=np.random.normal(0,1,size=(numbPoints,numbDim));
normRand=la.norm(xxRand,2,1); #Euclidean norms
xxRandBall=xxRand/normRand[:,None]; #rescale by Euclidean norms
xxRandBall=r*xxRandBall; #rescale for non-unit sphere

##Plotting
if numbDim==2:
    #disk
    xx= xxRandBall[:,0];
    yy= xxRandBall[:,1];
    plt.scatter(xx, yy, edgecolor='b', facecolor='b');
    plt.xlabel('x');
    plt.ylabel('y');
    plt.axis('equal');

if numbDim==3: 
    #sphere
    xx= xxRandBall[:,0];
    yy= xxRandBall[:,1];
    zz= xxRandBall[:,2];
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
    
    #do a surface plot with a clear faces (ie alpha=0)
    ax.plot_surface(xMesh, yMesh, zMesh, edgecolor='k',alpha=0)
